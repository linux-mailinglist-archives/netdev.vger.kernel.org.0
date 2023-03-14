Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3A6B9C09
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCNQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCNQrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:47:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848B48E08
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Prp1lolrKVsCHObse4oc+b+3WGbiovCOu+YwzIgAYc7jsCMRtuZpRn308dsU7Mp6MkrucsRn++7x8Royuknp368fp245ev/9Ddpg5jnzv29Gg9C3UApjUNCvQFy44pPZukFtJNw7fmlYHXatPuXWmZ+koExSCHg/SpgIi90Ivwac/E4tVk1/W2wyW1h4iLqS0n1v/Rm8MbkAwhz0te5Y4zUxsSVOmFeWK6jjE6zHH3bZ/1072n0KqXDigy3ByGBPJK1YR/NsQEzX3SsmGq0quPmjxymtE2hpcNMGhOih/hO8zhGEsGkvCLFF66mxUWXzMgEOOfo4eLAESn1l8iuefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DF8Ec3Es4u/Y2eFiwktdkU2AqffNdcq1rX/kD2ed0o=;
 b=OAhmxOuMgWiCUZnt8vbPMxo6gY8wV59TmzZoZ1nhTgYwdDbSsx98eppSpVn2u0OWM44upLX65p2f8UM4hCkoOid9zYuhqiA08o19hhfpMPgJjq5nT24S2w4gnGo7M0S4H/2DU83Pho3Hx/2N+LywHuXRLdtEgkhZiduvKCB4CC9EaFFozhtrZ5YDoU8oozVnf1f8WCdoMGYrSkLvSOhK5UFRnqksg4dqeSTm5P6DiwkdZNMuGOvS2eON7VGPZ0l1o3VR2EmPXCwKdETAMZzzwQO44TleF3vHnNiGirWVHOuvtJu3KmKEuxfEDnoGRIIZyNFrkMwjVhaONorJVe/Bmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DF8Ec3Es4u/Y2eFiwktdkU2AqffNdcq1rX/kD2ed0o=;
 b=UQY0WtIYYOVwG0xsJw4mCzxTzeCGBLmxVcju+Nt9PWqMTecN64y5lDu73wOiVlzFuMHfjCpds22FFJ+NISmV7EI14L4sZVFPznARVA40vxtzV9ctC8uEnfELWgzJMRvgu+qZ748n54qMA0Xp8JbLWY3x9v+KaXK8rjbOV/zRSx8HYeCbw79RSjC16L3cFZH0LH8lM5s0iim/SCtI1rBjV1DwLFyzUDByoUcPKPNtxdAhK4UfjZkfXcCLIphrW1EPw6+3RnoyY+o5enN2j/1p1dBrD59XoDaHonSSTzawvNXFFmHmbciCbjavzONQKBUeR3KFd9oGV2ijSM86NcPIUw==
Received: from BN9PR03CA0135.namprd03.prod.outlook.com (2603:10b6:408:fe::20)
 by PH0PR12MB8050.namprd12.prod.outlook.com (2603:10b6:510:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 16:47:08 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::79) by BN9PR03CA0135.outlook.office365.com
 (2603:10b6:408:fe::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 16:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Tue, 14 Mar 2023 16:47:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 09:46:52 -0700
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 09:46:49 -0700
References: <cover.1678448186.git.petrm@nvidia.com>
 <20230310171257.0127e74c@kernel.org> <87sfe8sniw.fsf@nvidia.com>
 <20230313151028.78fdfec6@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Date:   Tue, 14 Mar 2023 10:44:00 +0100
In-Reply-To: <20230313151028.78fdfec6@kernel.org>
Message-ID: <87a60fs2kp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|PH0PR12MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b36af1-1dd4-4b6e-34d6-08db24abbf98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBg+WQM8p196jTQEGlHLiafhZ7Ayt9pDkXeo9Z33wM2IsyDFSrDAQb1qq0a/qJvolnNROhdoUA2sV9bxt++WUsJeGauD9VWYPZNAn/BewjqhxAU5Pe4Gf62NdjZ0aLAR3nB0gEXUSpjo29iG/lmPswenwcDKDHdeVi92zQYeK91mHzivsTdHbpFaXXZSJeU/Qu0VPvY1Sqo7BgIET1jYsDo8Nw+oxy8NVkpt39soEImlStvbDLkBFXU+vtf9KvyIg8/GPfzkZFFkK9SAf7fIzXNBOzyTG+EGzCdn5aZNoQJZ7wgH3qXG0Lk/ifNffjbwHroPGtqsuZj9DmxwXE/dFzxPKzKziUREtRiF8Yq89/9MYvsp6dNi4jr3EuEgl2+HDYQvCyAv1Lt1/c+XhMHKmtUfMcfiY61+QaI5t+9+ukwgxffFPabg0F5Y4q/L8+szfHft7+Z0tA2XKagXQ2Z+iHHR9mkkAflxh43OMt2WWjnApzOTP78jYDqzW5zybtno8/MI2jddcOplzPyRUZlY85nke19S1rbyYz5C8KkNGmblpBPFHsqTKzGJW13cEVkU3QkthE+VfL0FxCmvuiRf9mQhzuzkEB26FAIMpmWOaZWXWHG//G2GVHcCawT0RrKn5J+HFX9SAiX41+86MtPfDxVjAbISCcg0uby6FAVdkisc4qufxHZ8RxzcDvN9X4tomkdebg09Z14jV4UVI3S5bfm93rPC7ke/LWsGjyk2rIPogOCqzgX4Dq16p6hDHuzt
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(82740400003)(426003)(36860700001)(82310400005)(356005)(2906002)(70586007)(40480700001)(41300700001)(8676002)(70206006)(40460700003)(54906003)(4326008)(36756003)(478600001)(316002)(6916009)(86362001)(7636003)(47076005)(5660300002)(26005)(2616005)(336012)(186003)(16526019)(6666004)(107886003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:47:07.3300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b36af1-1dd4-4b6e-34d6-08db24abbf98
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8050
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 13 Mar 2023 14:26:56 +0100 Petr Machata wrote:
>> > Feels a bit like we're missing motivation for this change.
>> > I thought address labels were legacy cruft.  
>> 
>> The immutability and lack of IPv6 support is seriously limiting, so the
>> fact nobody is using this is not that surprising.
>> 
>> > Also the usual concern about allowing to change things is that some
>> > user space will assume it's immutable. The label could until this 
>> > set be used as part of a stable key, right?  
>> 
>> Maybe. But to change a label, you need to be an admin, so yeah, you can
>> screw things up if you want to. You could e.g. delete the address
>> outright. In the end it should be on me as an admin to run a stack that
>> is not stumbling over itself.
>
> I haven't seen that caveat under the "no uAPI-visible regressions"
> rule book...  Have you done a github grep for uses of this attr?

I didn't realize this before, but the labels do change today as a result
of interface renames. That's... not good. One thing is an admin coming
along and changing a label, which yeah, would change a label. A change
in netdevice name screwing up all the labels is a whole different level.
I guess whatever the original use case for labels was leaks through too
much at this point.

So scratch all this.

I think we will have to use address protocol to do this. IPv6 protocol
already supports replace semantics. Any objections to adding the same
for IPv4?

Like with the labels, address replacement messages with an explicit
IFA_PROTO are not bounced, they just neglect to actually change the
protocol. But it makes no sense to me that someone would issue address
replacement with an explicit proto set which differs from the current
one, but would still rely on the fact that the proto doesn't change...
