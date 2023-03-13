Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063E76B7B6B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjCMPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjCMPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:03:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D321115C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9ZJlM7pLCAKWboAUjVJ8bW59hCiTmJyd+qePe0UkXXJ2XFNa1qMNgHkmNKRi8vRm4hoWrWNQfPJY5yjnXoYnolv1f3UaFH2xte3YY+dVge4041mB19+osd91z1Z+WZI1upOrC1LGbrqHyF1ngN6tSH5WmNwebEj2CyluaFo7aX72/cGELrGfOfF595wuB05ycOo/KYNs2hpMwvZaP30KPkrGGqrxRBhR4KStsiax7U6rTxhidUa8M1w7ClJW26eOaowQf4qU0WrjXHD37i6oYSeDEuaId3Oj2EWvTfFlQAaWOw1/xA9as8rLpdSQgUoMqV8wW9O6+/3oi/kUaMmBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDVjL8r8/PVXGeAxLJc8oDxKNtzEd01y+07wVbk2FKY=;
 b=HOxRFVn2nxOEAyCAB3JxzdlyofkpC4gogIUbrPLO48R9+Fr1DsaKbSmPT3Qs/IcQBApRO1PRjiXl0UCTJ6wB3PKgah0zEV1w4nfhX0x5MtHCOYmOyZmM5GdFusUHdCAvwTCC6rT7YEVC5FD7HaTqKZx8SBrtm1crc+lCo9mAo9GA5M84XNilU/6mzZeqvMlb79TTRaSLUNIsmQmiQ8b8/1Rif5BUdUYsbV9mKY6iQ/25pKdLMhVybvfBIdAQyvbUn5J3dioJCvaMqYcThMFi5IclvZRk3DLwsuwIC2bW+LtxwdehK2oFTeNsrNKIDp1GgwifdAxF3ocdD2tmmQ84tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDVjL8r8/PVXGeAxLJc8oDxKNtzEd01y+07wVbk2FKY=;
 b=FzyXaH8KO1i4JX/A2liWYtbW+L6c2sRKtlyTjZOKXs3/SmqZD7FnYOFKaS/n0MHJBbKHWo7KIAWPwEO3TBZfvUJjveQYpPeWRtyL2/ikMRF2O38fs0tJvgCGJmxA7Jn52B/1DsLM4Ftdazib01TdvUAN7zvK1Chw44D90lOuYmVjyHq2xU6zM5xbzBAKDq0ZjBdknT/n4W8e8nW/PaN7deiskBv+rDb+8ezoZ496gps7Fxa1K8RbmxLxbuo45BMrAAqVf/w9sf01Vi4bToiBfQPbS5t2GILJcgTaigD9k8ohJMY3RI3Nn/OZ14KWtwtz1uT7dRgkILXpGjCwrGpb/w==
Received: from MW4PR03CA0294.namprd03.prod.outlook.com (2603:10b6:303:b5::29)
 by SJ2PR12MB7847.namprd12.prod.outlook.com (2603:10b6:a03:4d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Mon, 13 Mar
 2023 15:02:28 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::9d) by MW4PR03CA0294.outlook.office365.com
 (2603:10b6:303:b5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 15:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24 via Frontend Transport; Mon, 13 Mar 2023 15:02:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 08:02:05 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 08:02:02 -0700
References: <cover.1678448186.git.petrm@nvidia.com>
 <20230310171257.0127e74c@kernel.org>
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
Date:   Mon, 13 Mar 2023 14:26:56 +0100
In-Reply-To: <20230310171257.0127e74c@kernel.org>
Message-ID: <87sfe8sniw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|SJ2PR12MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: 594af7e5-a959-45d2-c587-08db23d3f6c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xz6GGgjv7IoI36N5w1snmJjNDrzZNfAPpmPUhp6m5p2RN+LWSNdiZy3n1IUY5yO4rumH97EJBSGFWvBH2Gl28MKmF878N1hz/iCBnCblqq3zeZHa5z+8o2c5/tTMBn3BBnDmbdPRS796G7Kzvj9OgNldULqFKgpxKZTQa/knIDBmYLpoMsn5qyJzjkw75iWeyrNvw7emM0rr1OJ0JCtEDlcL04M9duYTGDgvQhSvj4VbXiLqJs5E0iO/BKnQPHKmN7ChnPivC5pz31SzzH4nIFu0ys5KCm3DDoIFgytqrtxvw/9ujvMJ6HirlZDRZtYlRsZNDKLMQJFvVI51fo3ic1T/paMmJ9jB0k/JyBNdngtm4Ryxj+vJK0u4rxXsoXkaTgNuNlZsdrzkNNrOHFv9sMcRQNFGgrcb1ZHQPR2qL61FaNRXjXMEJcinz6b4pbrepDvqbGAKoh1zTLRXF0cQZQ8i5XvTjlRYcHIqDLUBrh76xLp7GGd0AnrndRxFlGkBn6JsADzPrkuGJxaZ326xdxP9MCercQu8lyLnEoFUXhv3NR1NeXZk5+PyRFDSSn+6EAvywKRsHhsD597GglpLE2s0Tvs48rSzNWh6f0sBO2Yk1OuTyhaLR9GyxM0tnNa7sHUgeUYrFJ+xr5cJ5zeOvkK99U43HobqmI/Ukqi1PkKudA4trJ2KamuLTh6KegEAWPmpKJnZCEHDxdl4QMMEGVom5jCInpcEaexuLT3Ov3xJF2J0FEmUBPfalG/21/o3
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(478600001)(356005)(4326008)(70586007)(6916009)(8676002)(16526019)(70206006)(82740400003)(7636003)(54906003)(5660300002)(36860700001)(316002)(40460700003)(8936002)(2616005)(186003)(26005)(82310400005)(41300700001)(83380400001)(426003)(336012)(40480700001)(86362001)(36756003)(47076005)(2906002)(107886003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 15:02:28.7009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 594af7e5-a959-45d2-c587-08db23d3f6c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7847
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 10 Mar 2023 12:44:53 +0100 Petr Machata wrote:
>> IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
>> which are used for prioritization of IPv6 addresses, these "ip address
>> labels" are simply tags that the userspace can assign to IP addresses
>> arbitrarily.
>> 
>> IPv4 has had support for these tags since before Linux was tracked in GIT.
>> However it has never been possible to change the label after it is once
>> defined. This limits usefulness of this feature. A userspace that wants to
>> change a label might drop and recreate the address, but that disrupts
>> routing and is just impractical.
>> 
>> IPv6 addresses lack support for address labels (in the sense of address
>> tags) altogether.
>> 
>> In this patchset, extend IPv4 to allow changing the label defined at an
>> address (in patch #1). Then, in patches #2 and #3, extend IPv6 with a suite
>> of address label operations fully analogous with those defined for IPv4.
>> Then in patches #4 and #5 add selftest coverage for the feature.
>
> Feels a bit like we're missing motivation for this change.
> I thought address labels were legacy cruft.

The immutability and lack of IPv6 support is seriously limiting, so the
fact nobody is using this is not that surprising.

> Also the usual concern about allowing to change things is that some
> user space will assume it's immutable. The label could until this 
> set be used as part of a stable key, right?

Maybe. But to change a label, you need to be an admin, so yeah, you can
screw things up if you want to. You could e.g. delete the address
outright. In the end it should be on me as an admin to run a stack that
is not stumbling over itself.

As for the motivation: the use case we are eying in particular is
advertisement of MLAG anycast addresses. One label would be used to mark
anycast addresses if they shouldn't be advertised by the routing stack
yet, a different label for those that can be advertised. Which labels
mean what would be a protocol between the two daemons involved.

Other userspace stacks might use this to their own ends to annotate sets
of addresses according to their needs. Like they can today, if the sets
only involve IPv4 addresses that never migrate from set to set :)
