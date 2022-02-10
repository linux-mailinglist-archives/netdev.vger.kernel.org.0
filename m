Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD084B1107
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243258AbiBJOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:55:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243236AbiBJOzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:55:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58F6C4C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJz9ZLt24Oh7fUvH0uJssf2eyotg6dHak95IieW4qIyrrQOXfTsxEuxFVel1Kf5XWe89Ytyd9Q7xSuj/m3h0vz5cSF63H+vUIA7M/CKvo67AEjazd44+Erz7ZZGN2n9lYu8sq2PddQtv2qwV6nNJv/7B0C9K5SXhXPkrX5Swc/qaJSazQLTCLy9Ye6cqEshGWpSS7AVnwWI5rnR/nkr+/LN9TqVwSfVknOOrdhD8aApvQHlOAmOegcY1mwbtT2ZFr+M6elFtiNXN21gQf6dsUZRWNMSlz3rGD6LV/6LsFDzNRib4Cr3Duul/NtENOr32H3VcgBbLZyxjPWm6FJ34AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBXtmMdnIwW//XWlk+jfJylHp/96ngZgGmBHv5t2ggQ=;
 b=c2/H4DAUgYWR4RgqJkgRsnxGtujzJ0YkpibD7M5KKGE5yX7fRjeRtHMMVVxAY1Py9isqiouWssL2Wacn/kZwBivQdEtsE/r0OtEX9uI+SeEGW0XhfAaRTcSFkB3GGuuvlLuZWV9mW88pdhDmSplvjsOXAY5MRSH5gSZTz0uDBhrmc0xWHizzuvuKSByN9yOoUJ9QxXCApeCf3kRD1iLydf81t4K89/eXIogtJB/A0LdfaEP/szX0wshmI/zHS/4jpYVEFlDd9q6CMTqhpJ/l6sjhUdc7b3NjOLxGOKLWMiOvpxVjlgaduOLAXFQ1CpGDhP8yzlqHLtZW3BI/kkFYxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBXtmMdnIwW//XWlk+jfJylHp/96ngZgGmBHv5t2ggQ=;
 b=kFC1ShAl11ko28CWnKxwJF4vPrfVKmbVa/LKrt53vG9Z4mMf54jraSxaiLSCWdvzlpj+5K1oCdWfD+kqRhHZuNxEOnFANla24Bnd2U5I7cMUsA7KEKaiESC8ARn3BTs5ld6eI0/3ZMPT18E6ZfuzTV81yVVV42skE29IoN3YmTXnM9qxpRrCZEpuzH2AH+SFEHquQIKnvXDRwDDr6RF33aeLR7rpmVdAN7eo2CQtCSglPsWGYp2agCXaRbzQdEUY0HX7o94r0Yi2/L20q8G+ay+qKCHsqI+Qa4akLG+YuxThkF4rMyB2s4rrc9ApFw0Ud5xTksXPKQpQHvV0EpiHCA==
Received: from DM6PR08CA0051.namprd08.prod.outlook.com (2603:10b6:5:1e0::25)
 by PH7PR12MB5999.namprd12.prod.outlook.com (2603:10b6:510:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 14:55:47 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::6) by DM6PR08CA0051.outlook.office365.com
 (2603:10b6:5:1e0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 10 Feb 2022 14:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 14:55:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 14:55:46 +0000
Received: from [172.27.13.180] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 06:55:44 -0800
Message-ID: <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
Date:   Thu, 10 Feb 2022 16:55:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 1/2] net: bridge: add knob for filtering rx/tx BPDU packets
 on a port
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, <netdev@vger.kernel.org>
References: <20220210142401.4912-1-nbd@nbd.name>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220210142401.4912-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b62949-1532-410f-235a-08d9eca56b7a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5999:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5999B6F443E24F0E06E1E238DF2F9@PH7PR12MB5999.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5eqD+4+V3o4cyD4vwCqZxSRzXtUZHFra6UGw0OYHX2pyoleVkkpl/+Uo+++OaCUlWu/7pJzW3ULKFBtPGLb+rThIhWHRD46ViJeha0K2nPpv8M2bHJS1M2ND1Z1dEtUvux/FhJkB8nqa+xhrKGPvonam+v/fDbjn7kj5+ueBCWfuXwInnnhFj0pi73R7wygUaiw5812omOo+HMlfBCvQ9BRuPEXKZDmnSYty3d19NLbftJb5k64FIUXAeWRgeMtUnH1cTgXr02QTXLZfwS1fdgErKugVPHA3JphhFL4JhO0CDE1qFQ7CBe/LOvGTocKF2kAEA6hN2Oa6o8UV2+AvwvVsN7KEsB4it3nwlGGErfcgwiAE0DOkpQ9nyAp9kqOoeEWsB7DMhhr+NGdlLcBV3UJEvY+TL/Z++eM9N9fR1llpfj3/2XTUdG1J/nTk8f6ZN4yoEQDfyfeTR75xC/BK0V+tHzOh2i4ek9NYKABpYknZIf2Hbryqanr0JfEfE4bIjvumpjtnUVi6XC2sG7Bb9u0xeW2z9CIb5bMHhd1xydIzw2jwr+eHpA4v3ncMDP8GAnPNjv0yBzq90oBKLYXBJAIJb1QuAprFMfKGdPOuYzJ4+aDSQMFpr7P/UZUoC+woIGpuwje77Wr93XJdOM7AMLo/xcOMPmkABRp7PRP9gokpjP/2qvFvjxDHkbfYsEiuNGhn4KCBemYZ2Pj3QEnmSli9RdCfX4VE/E1imH0+eDb6zZFIkzEvS5jipewtrHaPK13/v7tmS2H29jghTRfvw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(110136005)(316002)(16576012)(508600001)(31686004)(6666004)(40460700003)(53546011)(2616005)(336012)(426003)(47076005)(82310400004)(16526019)(70206006)(26005)(186003)(36860700001)(5660300002)(31696002)(356005)(8936002)(8676002)(86362001)(70586007)(83380400001)(4744005)(2906002)(81166007)(36900700001)(43740500002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 14:55:46.5311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b62949-1532-410f-235a-08d9eca56b7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5999
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

On 10/02/2022 16:24, Felix Fietkau wrote:
> Some devices (e.g. wireless APs) can't have devices behind them be part of
> a bridge topology with redundant links, due to address limitations.
> Additionally, broadcast traffic on these devices is somewhat expensive, due to
> the low data rate and wakeups of clients in powersave mode.
> This knob can be used to ensure that BPDU packets are never sent or forwarded
> to/from these devices
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  include/linux/if_bridge.h    | 1 +
>  include/uapi/linux/if_link.h | 1 +
>  net/bridge/br_forward.c      | 5 +++++
>  net/bridge/br_input.c        | 2 ++
>  net/bridge/br_netlink.c      | 6 +++++-
>  net/bridge/br_stp_bpdu.c     | 9 +++++++--
>  net/core/rtnetlink.c         | 4 +++-
>  7 files changed, 24 insertions(+), 4 deletions(-)
> 

Why can't netfilter or tc be used to filter these frames?


