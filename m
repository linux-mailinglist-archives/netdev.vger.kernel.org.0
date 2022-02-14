Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7592E4B4D58
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbiBNLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:01:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350164AbiBNLAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:00:52 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8819680200
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:28:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uwh8G64G8RETs8U5gBeLAmLWbnwjIq/u3rp2H8Kd6C8q5nZH2GKiJJpmT4MRfqSIjUsbQkA7ZqXNY6WVUs4idColyWgef/qswuWafuxFzDEsDaYJ7M8EKm9yKT2wpPz/a8cUQ47Sk4wsnJCLiqaUKB/jWFcMyRAW23eAAL/HLwFSEo+0JwUJCGokfnyMCgaYJEVkPIL3xBgM2ndJQpxc/Y3PDUhhTjfly4dR065dbsN5MQiTEYnIfw42GeHpxS3y0oDpW0oYS9kZYG9jh44RjMwYV/5hpXxzHk++S0GjPsh67grqM/d3hmyQ5swZAR0itPNw+UPaR3ohkLuNgFrYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kl7BzNrwdIpyBVcW4kn8Ryn9c4jOlfj2TGZJgZ7a+6A=;
 b=ifvvDczYkbbofVGQadaer5ZqI1LhexECuvxm5iqXHEj1um5BoB+W/AA/ePP91nLxRXf/GpbWUm8WzX2CZ9NF2qfP1MnqbB4aB+TIXd099o+c8OAEp2mGkkr4L51fH/69hfSb5AgxKeCACxxHOZVQ16g/Fq/eJbuvcy3dOoDa4XxwQIGOG/jPSC300MHUSA9gds7jvYhDnFfvFgGhbnTVNUZTRAh/gZ5X7QBOsG6K2o80IshOmsMCEHdZ5LpaMdR23pZvcARGexy2SkdfZnOb8jbsZgEwH0BOvA72SdFLnntMI/6Z/5KBnqsvhEIc88cab0ZyQ/HhrknzswlA7I8w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl7BzNrwdIpyBVcW4kn8Ryn9c4jOlfj2TGZJgZ7a+6A=;
 b=JiKczErotuZ9bewGmUbuj3U5L3dc7TXLJFhxnHU3rG4247RKC5ksoocPLVBYbPyDtwhNBXzKWtd5N5s/Bs8AyQFSE0W6t4eXj2LLBADfUZEF/hv3jwOMwD3zfWGd1GbxuR+Zxo6C2Ubf4MQgSCGzAMrD4230Y2k1I6dW8UCPbciXGL+YRP8AbJUN1yAnOvYSOcYSJO/CIKK8mcbPCMU1sR6y0QUOmVM0bldboGVB/EbuQ97sgco7KJUCS4y/j7HqrUTxbne+ljuemfinI4YVgN/QIvOSAaFmJwG6iMDJ6dHxiIe0AMzbmMCBIhQlSwBpW0puidymPYm6DHfAcO1lOw==
Received: from BN9PR03CA0913.namprd03.prod.outlook.com (2603:10b6:408:107::18)
 by CH2PR12MB3736.namprd12.prod.outlook.com (2603:10b6:610:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 10:28:14 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::ff) by BN9PR03CA0913.outlook.office365.com
 (2603:10b6:408:107::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.16 via Frontend
 Transport; Mon, 14 Feb 2022 10:28:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 10:28:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 10:28:08 +0000
Received: from [172.27.14.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 02:28:01 -0800
Message-ID: <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
Date:   Mon, 14 Feb 2022 12:27:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
 <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa1be237-5177-48b2-fcf1-08d9efa4b51c
X-MS-TrafficTypeDiagnostic: CH2PR12MB3736:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB37364F5CCC36D0A4CFD5966CDF339@CH2PR12MB3736.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4VjQv+AaoUMzqsGfKIVXs+7vpwR6HZXh/W99PUoI3VM3ubrWm5HANlqrgBHrRJPYuWHD3ReZeB0V0TElQwda1AlLCgwFxhuZBLZU7HPsYZHkzUbG9Ysg4Qny1jRsVpoyOTs+RcbsjEow0OpyB6HSCkgvTDTJPIBqzQerMGytwK4Et3EIoNZGT5pioCDIqXvHlV/V4UdXitqHozUsgsprgDHWhZNwBZrCIhgxjyPROgLddNZSGHTCTGFp5i1PZ4PNfGWy65CMNuNViN9lXoERy1c56VdAv/Q//0dnJGtNNq8Inwo42Wj3Xld1PxJ/WKXCQFPUeJqCqp8vO3yp0NenzCCjTkD/cMSO/PcjSg6b9QDNvO3mvfggTRALXYGHknUNmiLBYTrP/SqbzkEVcJUGPIG0P45zQnMrVg5seK02BjX/9Ai0vMTVrzjW9Hm2MH7wld9WzE4rvO1LKXk4EGuZo9FvcgwdCTs6RIQ1dMy7y30QGdeDVuUvTjvVB63Bqo9GxL/iwIeLV+mbuK9XPi7OQOsxtWsmcTG6qw4mc/2Eeezv6Knip7u4gPEjWhfpuKG2xVg0jvlU5302qfXdVGWAKYabZkDvuKFtH/D3dwpx5l5jaB4vUi55cxJfCeW1umRTEfA73J7Eodd6uZp/5Zb6ikB5i5leyhqMitPjRM1+edB+fslKfcIQCAXTJ/cgize4W8qovNxK7tXQii8K8irqGvBfgBt2t3fPOWjd/R09B5djwSfI6A4DlHy9ujysBBPt
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(7416002)(8936002)(26005)(83380400001)(16526019)(336012)(81166007)(36860700001)(186003)(426003)(82310400004)(2616005)(2906002)(47076005)(5660300002)(36756003)(110136005)(4326008)(40460700003)(8676002)(508600001)(31696002)(70206006)(6666004)(70586007)(16576012)(316002)(31686004)(53546011)(86362001)(54906003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:28:14.0011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1be237-5177-48b2-fcf1-08d9efa4b51c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3736
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2022 12:07, Vladimir Oltean wrote:
> On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
>> Sounds good to me as well. I assume it means patches #1 and #2 will be
>> changed to make use of this flag and patch #3 will be dropped?
> 
> Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
> their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event when
> really nothing has changed (flags == old_flags, no brentry was created).
> 

I don't think that's needed, a two-line change like
"vlan_already_exists == true && old_flags == flags then do nothing"
would do the trick in DSA for all drivers and avoid the churn of these patches.
It will also keep the order of the events consistent with (most of) the rest
of the bridge. I'd prefer the simpler change which avoids config reverts than
these two patches.

> Patch 3 will be replaced with another patch that extends
> br_switchdev_port_vlan_add() and struct switchdev_obj_port_vlan with a
> "bool changed" meaning that "this notification signifies a change of
> flags for an existing VLAN", and the callers of br_switchdev_port_vlan_add()
> will populate it with false, or *changed, or *flags_changed, as appropriate.

Thanks,
 Nik

