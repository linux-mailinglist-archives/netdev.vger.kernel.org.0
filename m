Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C24B4AB926
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbiBGK5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiBGKvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:51:18 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF602C043181;
        Mon,  7 Feb 2022 02:51:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNCct+sOLgyW9MqWlkdLu1Z1nw2G000Nu8Yiii6aFJKDcwn4/X6Wujz/DaQn3RdKgboXOxkNOyfupEgMPDE2cn9wUog05vSZH9c9kH+XNYTioX7Ak78ZydU4skcUm1KD6TKj0GcEg8Txwn6e8A177jC7euexbedgAOtPWPA89IALJZ63hSxSWEwINefMuXbLeZHj06NnICn7xCUx350wlXglgqzMuWPKtGzzc04wUaZz+Y+a13sUByzPNeXZtYvuEDoeT5mzMS2rH8wqpD/sEPxyL0tGWV+csEv2RMx5HCVlKK5c3WdYk4MR9+4Ou85BCweO38ypVu8q7BcprNnFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmOsTMYoPyt+EMa6/G7D2cBX0asmGes7MTGnDcub4SY=;
 b=N5b8JwJcCPloMh6XP/5oG9DRi8VknisEm0QDF/RIwv4nrEo0IIBDcdX7SY/oV/pZkqr/YhgvqmPbd45ak2NwY+8qyMHO0u04bUceR6pWnwfyUps17mJA0mI1YtAJEfv/lFL+Y0i4Hxngr5pxuxZKVzY7B8wldK+ZkdjeoHtBrekIiCbD4zDWJDLPvCngdOxDQQUf1aC+JKkn1d+bTzRXzOnxpsvcPfNfgwnjnetCo63u8vy3h0i2Df3NFZCWHfRxhLaAyUCuKnyJMqu6jAI8I999hk+a3+r09T6Yyef/I60gy/PcFNYcpqlxWpnSPINkHuVt3xoQusMRh+BkC9SltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmOsTMYoPyt+EMa6/G7D2cBX0asmGes7MTGnDcub4SY=;
 b=kpxnpZ2fPtPQnQ1cqaqBBX8je9MOc9WFGeG9tF0SgAGZ+wyO/+TkxmyotMUXFtfnnNI3/qkG+m+CIYvpPH+aajiefVC98makLT+XaBQZiiqjWGiUXnmEPq3rh+1gfrMe+i+2vuhQtWclyP29VsA0g+/zINS9fERTHRltR+sL9b6QQrDCbJoUtQJoJ/9V2P8uS5RV8Q8i9hg4ugn5iB0gdb88IRrH08BPEdaJdWb+mdTkwoF6a7G5yAZInWXUDPCYmOvBoLZ3FVtog+9SvxjgyqMeRMptS2+0mP6r66wfdjJGKiFJQSu9v+/jt6kHHhF65IMKZizLe7fa9579D7t9kg==
Received: from MW4PR03CA0286.namprd03.prod.outlook.com (2603:10b6:303:b5::21)
 by BN6PR12MB1427.namprd12.prod.outlook.com (2603:10b6:404:20::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 10:51:15 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::b6) by MW4PR03CA0286.outlook.office365.com
 (2603:10b6:303:b5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17 via Frontend
 Transport; Mon, 7 Feb 2022 10:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 10:51:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 10:51:13 +0000
Received: from [172.27.26.97] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 02:51:08 -0800
Message-ID: <af122e70-d073-cd83-541c-b3a0125c7cfb@nvidia.com>
Date:   Mon, 7 Feb 2022 12:51:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 2/4] net: bridge: dsa: Add support for offloading
 of locked port flag
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-3-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220207100742.15087-3-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6881ccf2-f704-4578-54fc-08d9ea27c30b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1427:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB142732CB8F4F383DEBA982E8DF2C9@BN6PR12MB1427.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wu55FupcrmMQp9K0KcbraQ5PypTAYvFoLmyAjD9a3jk0PSp5MtysayOTqzYk6ozHBrC4MBhJdyLC6LKh579k2ej6vUKu5x8jgVdxOM6CD73ZS3S5JlykLkV3XkPOM6u2M+akYoyHbslCncLQRmcFx6X93YMeo4nhmLASWrhDf+XYxnjJf4gCCYvaJTpqRcP15mjnN0Lm832GZUNmJfEJWN26dsHr6nve7WF9gQZcYHC8Hdmq70GLs7A6dtxHLcJwm1ZfaNvxzsQUpjCeR0HtOfkVvSU/FpQobk4lSV0YYI2e72DJXhQCo2bVseWyMvjQKiY25Ji4p6Bc8i5sSH93PlrV+RtOzAJAy/1BotxsSxa7hXXAUKAe+kJS/nHWRocYT8r/+QUfQMNguq24uZWgqUa6M0rzSLX0KFLqIHDeSvKpxoFg9abH7N5vRhR10Dq9eTznPvWtR3f/j8wBbQxHM2zqqx/6dsVy0gWI+KBzfCeFseUtIpNxn70jcSB7xdYJirBEnCMK2CGYufbTXHEZ4w21yWtpNs8N4iayBJqpN9KnnWFhmvLBVl4FjpDDo7miCqyf0RMAzdJQTRUaDV9j79uHbOCd83ebGVR/I+DUte42rXsr+xt+8S3ZRv07qW9C+KNpL/9zu71EwKGi8VLF3UoF5ylwsumjRhvYpJyVQ82+UjDCSVLUt8hTXSRn9+PXgGDCbSIPp6Ev4sYw7EVrk7wfb7ccw3hMgm7jJwtCfRD4FgpGuoKSpaqYEcwF2M44
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(31696002)(16576012)(336012)(316002)(6666004)(53546011)(82310400004)(47076005)(426003)(40460700003)(86362001)(36756003)(2616005)(4744005)(36860700001)(186003)(4326008)(7416002)(31686004)(5660300002)(110136005)(54906003)(83380400001)(8936002)(508600001)(8676002)(81166007)(2906002)(16526019)(26005)(70586007)(70206006)(356005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 10:51:14.5466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6881ccf2-f704-4578-54fc-08d9ea27c30b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1427
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2022 12:07, Hans Schultz wrote:
> Various switchcores support setting ports in locked mode, so that
> clients behind locked ports cannot send traffic through the port
> unless a fdb entry is added with the clients MAC address.
> 
> Among the switchcores that support this feature is the Marvell
> mv88e6xxx family.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  net/bridge/br_switchdev.c | 2 +-
>  net/dsa/port.c            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Hi,
For some reason I still haven't received patch 01 which adds this new flag,
so I'll comment on this patch first.

These should be 2 separate patches, there is no bridge: dsa:.
Please break them into a bridge: and dsa: parts that add the flag, it also
makes it easier for people who have to backport patches and fixes later.

In addition please mention in the commit message why the flag is
added there, i.e. in order to allow to be offloaded.

Thanks,
 Nik

