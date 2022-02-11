Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A04B1FF9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbiBKIQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:16:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiBKIQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:16:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5091BDA
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 00:16:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvpoNKkKY5g63frqw6mDSq3D8TSaCEPiqPA9x2XwTgzPhngd3zZhnWbyhfZPaLzXVWC0J0crmwdrxoW5jVJGtXDnrcCxVopwLiUA32oJN0OLEpxtys2Mt2QENVQpdc3p5cG5wurk13m6Wke6KMzEGiJZCoRLPXR4lDOe0EoMiDCDI9aGS/zf7fWjynEyJIUd2JrJj0OFkwSmd+48t+hC8m9nC+Riefq01Sgx2E2QAnagUb1ofIH7GG7d+eKP6tqUaC4dTAY+7GOrdivOFpJ6c8cjI5mQRYQ5MXQ4SX6jnuhAKLtmH9qKHo6SBA5ix/YPThZrl6O0g6UKtpvTqtczeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFADvmcajYedNPgylNy63wpU7ai02kwgAp9fSOX7FCA=;
 b=C7EeAEhY06bsnVDzAG34VUQbF4dAd7hl5AiDwsH98ZkXH8BEIDvCa0klCHr3YDLUeDyGiCrRSL68VF2GC/lanKVJ8OVm/KRxTWTdxV478/wOfFlQxdesfN6ca++/NNN94xnz3IOSHn74vnawC9CiNItg69GVdZ/mAu3IG8imogdmcWrQKuC42gWRQommKxCmj3LfnwSIXZaZRqN4jU6IPI8kToYUXcTnSQyV0zrRn49UregrSP2rtrOOYt+t3XBcHs7PU0FbS2qmf/sPULvAAwvp6mMhad/rT6aTF9bU3nSI2ZfGNnQyA1YQwvQ1V0NdO1UiflYwePPJeU4qsHo40Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFADvmcajYedNPgylNy63wpU7ai02kwgAp9fSOX7FCA=;
 b=hqsCcoC9D5Y8GTSysR6C58nIqLl3p0/N/wgHgMrOjlmiNF75f9/A9H4drM0MzZUfBFAkmyy27HSO8rYemTy+OsE6DoiV5DKSvx/1uPSrT0v/fjQv+M9ApcZm0sTzJ28i5Mhou/M77kjK8Q7MUu5eGvTGD/5PB6+WVaMqIsqyVJidxBCnGJWwf1mJHTIhqnKmT9cyuBrHmCBl22+AYngMXhU5MJM1dkKvyHRMqfuCjhWeXhu4rOjBhNNmu1ewL2D9Qih143wnOh5aRZqsvjQ/gAe0ZyB7GfRcVormZ3iuMWXGivAYabEO86FsuyMNjolefIVbeSw+0l+l1r2Kmo6d5A==
Received: from MW2PR2101CA0034.namprd21.prod.outlook.com (2603:10b6:302:1::47)
 by PH7PR12MB5656.namprd12.prod.outlook.com (2603:10b6:510:13b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 08:16:37 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::29) by MW2PR2101CA0034.outlook.office365.com
 (2603:10b6:302:1::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.7 via Frontend
 Transport; Fri, 11 Feb 2022 08:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 08:16:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 08:16:36 +0000
Received: from [172.27.1.47] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 00:16:34 -0800
Message-ID: <50f74e7b-1b20-bf02-f5a8-b1667b834190@nvidia.com>
Date:   Fri, 11 Feb 2022 10:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 1/2] net: bridge: add knob for filtering rx/tx BPDU packets
 on a port
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, <netdev@vger.kernel.org>
References: <20220210142401.4912-1-nbd@nbd.name>
 <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
 <8feee888-491a-9324-6437-07f33d0d5584@nbd.name>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <8feee888-491a-9324-6437-07f33d0d5584@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ec27167-30f7-4c0c-0e5f-08d9ed36d2c0
X-MS-TrafficTypeDiagnostic: PH7PR12MB5656:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB565618435D6B7E631DEEF5ADDF309@PH7PR12MB5656.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPLBGlA5Z3uJfaQfHZsRHqaaTbdvEbQhW53xgBfAhUGx2tMhsrAF6+m9F2r7PhOSCZBIYRLPAFweLqd5a35R7K0hLL6ijbUB6EA7eWZ1raB7i9dankQmuEaujLMkiqZky1gRHIob+y/fNFb6TE+96st75HjgzPumh1p0iGmRniLCR1Azo7roEqB7Qzka30L+rodIYoyXxs6Z4B0+l5eKUlh9Ec+RTc46ZNmwtZ1hu49yDo8L2cjQuywSLzothefegbgUku+oPoCImG7FmBLBxPJCoAMCG2kTTVOP0EqRcIbCcABI3xc07ASSIPe6ul1Ht+0h6RwVEY3Qhyzwx/AFR1mC8O8+nbE/Qn8hSsvO70kSXTFdO+8vj5I8pDsfZJyxKbA43PiQQsmeLJgyLtSQxzryGhdl3DyZQ51QjmrhQAAVP0M7cFAxg5SW/41yV/ezybLmP/BLWReiQpcsICHoKWhWJ535oigE+o3lYyaJxnMrGf8r3ykrV0exdXOA/pMZi55whnd+dzmU/59PosYdiSYgoUIiaxNh+/FkkQLNBiJkHyYlpUBklHLiNABdjH6oPlapc4RUujhEvRskxtCKsQONkd1UObEJ4Xz100KB0z8UfLdZFl/s5COw+lmZfBsHytRI5PpYRu3xMmvdZRG5ScJAmR7mpU4EPsn/6//8zcZKWomMoM8VxcMZ8sYNR0/HqJYWKswdcNUNudI39Vws+a5IO74I51RtOTjvdxKtP2SzoM85Lz9H2dBvNtYTT0169Ssh6UXF1fND2gLuiTLUzQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(36756003)(31696002)(26005)(2906002)(426003)(31686004)(5660300002)(508600001)(47076005)(316002)(110136005)(336012)(16576012)(8676002)(186003)(70586007)(86362001)(6666004)(36860700001)(82310400004)(81166007)(83380400001)(356005)(53546011)(40460700003)(70206006)(16526019)(8936002)(36900700001)(2101003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:16:36.8361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec27167-30f7-4c0c-0e5f-08d9ed36d2c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5656
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

(resending, for some reason my first email didn't make it to the mailing list)

On 10/02/2022 18:06, Felix Fietkau wrote:
> 
> On 10.02.22 15:55, Nikolay Aleksandrov wrote:
>> On 10/02/2022 16:24, Felix Fietkau wrote:
>>> Some devices (e.g. wireless APs) can't have devices behind them be part of
>>> a bridge topology with redundant links, due to address limitations.
>>> Additionally, broadcast traffic on these devices is somewhat expensive, due to
>>> the low data rate and wakeups of clients in powersave mode.
>>> This knob can be used to ensure that BPDU packets are never sent or forwarded
>>> to/from these devices
>>>
>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> ---
>>>  include/linux/if_bridge.h    | 1 +
>>>  include/uapi/linux/if_link.h | 1 +
>>>  net/bridge/br_forward.c      | 5 +++++
>>>  net/bridge/br_input.c        | 2 ++
>>>  net/bridge/br_netlink.c      | 6 +++++-
>>>  net/bridge/br_stp_bpdu.c     | 9 +++++++--
>>>  net/core/rtnetlink.c         | 4 +++-
>>>  7 files changed, 24 insertions(+), 4 deletions(-)
>>>
>>
>> Why can't netfilter or tc be used to filter these frames?
> netfilter is slow as hell, and even adding a tc rule that has to look at all frames to check for useless BPDU packets costs a lot more CPU cycles than simply suppressing them at the source.
> 
> - Felix

You can use XDP, should be much faster. I don't want new tests in the fast path
for something that is already solved and doesn't need anything bridge-specific.
 
Tomorrow someone will try the same with some other packet type,
sorry but absolutely unacceptable.

Cheers,
 Nik

