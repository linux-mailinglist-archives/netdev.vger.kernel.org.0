Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD27516D9A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384321AbiEBJoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 05:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384427AbiEBJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 05:44:04 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39ADBF67
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 02:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgYpdqfPzpNUK+7R9NY2iVBsZSQJ2zALjRCVyPiCdGE97dSqaFADC3pOuZCupxsqfUb8+RB+lgxQniTXYpmyV1nbUdY6ezAPuc6dbHcfC0czrCZvjoxsMDH+W/crFdZVNEzuZefM+FJLsK8gMXZA86NTRIEuCF/lLhrtr6iG0bgL6vVQ7c4hNVZdsJvOOd/rs0Dtd4P4px5/I6ulL74ZxJCqSLAh4TKlJci8KARwl+gK+Or0JutV3kImf9k74pCYi/szspwA7hKcGDxHWgA36JKog9ZXPgSEt9PVG+KZXBTv7fbJtMIIXXL8ohFJQHzCrUmmTu7CzhNBh1VVNafA8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+h4wfNrBzkt/R9+doAwZ6UUFv6+TDEdRzYLpceQbLE=;
 b=JRz+sApn9B8tO+peMBmrHyYeW8UGX8BiEVTSz1X1iAcxfNTnlZUJfHC4DWLuKARtJfvikhWEvX16B2C4Ah8s+zpsybj91zs9yloHZnzwHY3M4WE70Q18OmWChlHpda6xTq4C/ocCMb1PbXM8826YjUj+Np8HIS6owY2g1hMfBRq+CdFPLPGlQFuV5F2za2CpufRGYcxZx+2+tqP47Sb2PuClQAyCxItedPO9jX+CohhAitNbK1vlk1xqucpgarsIFJI0Gqnb6SzG+ei4HEq0f1zL+lh6eMrJmL94OjfaN8scI5QNTSzX/a9sTVx2oUqX1twTIXgkED/P7zt2GWxVNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+h4wfNrBzkt/R9+doAwZ6UUFv6+TDEdRzYLpceQbLE=;
 b=V5RNvIrt4W1hAyhzyJKUksoafa7/JN67g9x/U3A1fCtJlM3l1wXmQLcSd/yBIYkGht6xdeWhRPcMrqMldv9dUh9paguFxBJETid7Is01LTF4+9e3HMxtnLbQjb1DLms4JD8Hd04nHS7nqEVwqwhB9CqUxZpCOJTLVPVTOxezSuR5GV3yyQT1y0d5YCW/vGVsO9jVgjOqAaOtbLzJ6mA+aS+MOpUDrGBDTv6F/OSLS/dIqodXtvh3zYRTy2nYE3I1C9qR+4zu2ROGsZCd76S15DYzho8n9fMpZ1QbHNgqNKZIg1vviIGXFLrBNnKOKqitk5So6UkBcev4bKNeT5y3Tw==
Received: from DM6PR02CA0053.namprd02.prod.outlook.com (2603:10b6:5:177::30)
 by DM5PR12MB1289.namprd12.prod.outlook.com (2603:10b6:3:79::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 09:40:33 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::2) by DM6PR02CA0053.outlook.office365.com
 (2603:10b6:5:177::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 2 May 2022 09:40:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Mon, 2 May 2022 09:40:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 2 May
 2022 09:40:33 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 2 May 2022
 02:40:31 -0700
References: <cover.1650615982.git.petrm@nvidia.com>
 <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
 <Ym6ek66a6kMH3ZEu@shredder>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 06/11] ipstats: Add a group "link"
Date:   Mon, 2 May 2022 11:37:32 +0200
In-Reply-To: <Ym6ek66a6kMH3ZEu@shredder>
Message-ID: <875ymop90z.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 698946fd-268d-4101-7f11-08da2c1fce0f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1289:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB128949ACE3807F8773975F67D6C19@DM5PR12MB1289.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CalVYuCsFlIWQ4fTgyAn+JcQFiTeyL8WBcLqOL+3rupo00M9C5iMLXYpie86IWbjN4HnzWHXEFluIQzq+EyovC9qUYrDA0Uf7SGYDTjHMGNaObkMv3JqQyi+CqCeRrmEcO8nawHq9Z1zjaF5+XHYWPsp0GQT9SKpoCverbHxa6aRUwG+YMLXDZkkGEDPZVQR3ZgIxKz/GCSzJHFxrsVGlHoOhrfiDI+p2a0IpP/2qC6muUEOpaxSiTsbKV3WKCf38x8U/XOTp5ci/MMTeUGemFqkwOJRzIoFFU9Yx6R0cMFXm5l/kZoqkd6q1hk+Yk4mJkchrv2562mCpn9wjL2h/ogZTiZpdTh5I/qGgdVOlIQZ2T2cG+qxq/gkEcuqntbjSMxowZIVkIqkfB2bKLkqoLBxyjpqfIq8H8OIudF9GdDtHrLbD5D0oH+bAp4AhsvB+WVSrtK4UcncBB/KmVH5T/znZ9BesluT5Qe0IyiEBkoZOhtruoaRqqLHOD8RStws8juZVPEe+kNKJIvlWyUkR0Ro84NnP9Xlr5Z/rnjxL2P6FJkHjbMiUuzjdK+f82mUcTpWJO5Z09Mhhwv8AokIgOtz/DDvLFCafkhL+/U8CZyJE0z0vpnHH79+VXr7JnSwUw9ce1/zwGiXy9Amc2FsgJjbZiT1BFT/GWhIJCy4FzEPM+FM6Bs9eBfAFRDGNn87wPX+JaskErPFOgKJBbnWLoXYI2XCnhqUVJzFExGVjtZ1zIhycWiL+8inOL+rt+CXsMaX7mGin36WvG9yNkPUH4o4y92DnaNmZ6WajxGk/q5h8IBY84kvVaQgji8zE1fWdytsgmKEFzVfzQs4cLs66w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(4326008)(8676002)(47076005)(2906002)(86362001)(70586007)(36756003)(70206006)(82310400005)(8936002)(316002)(356005)(81166007)(6916009)(40460700003)(5660300002)(26005)(426003)(36860700001)(508600001)(966005)(2616005)(54906003)(336012)(16526019)(186003)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 09:40:33.7826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 698946fd-268d-4101-7f11-08da2c1fce0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1289
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@idosch.org> writes:

> When I tested this on 5.15 / 5.16 everything was fine, but now I get:
>
> $ ip stats show dev lo group link
> 1: lo: group link
> Error: attribute payload too short
>
> Payload on 5.16:
>
> recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=224, nlmsg_type=RTM_NEWSTATS, nlmsg_flags=0, nlmsg_seq=1651407379, nlmsg_pid=330213}, {family=AF_UNSPEC, ifindex=if_nametoindex("lo"), filter_mask=1<<IFLA_STATS_UNSPEC}, [{nla_len=196, nla_type=IFLA_STATS_LINK_64}, {rx_packets=321113, tx_packets=321113, rx_bytes=322735996, tx_bytes=322735996, rx_errors=0, tx_errors=0, rx_dropped=0, tx_dropped=0, multicast=0, collisions=0, rx_length_errors=0, rx_over_errors=0, rx_crc_errors=0, rx_frame_errors=0, rx_fifo_errors=0, rx_missed_errors=0, tx_aborted_errors=0, tx_carrier_errors=0, tx_fifo_errors=0, tx_heartbeat_errors=0, tx_window_errors=0, rx_compressed=0, tx_compressed=0, rx_nohandler=0}]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 224
> 1: lo: group link
> Error: attribute payload too short+++ exited with 22 +++
>
> Payload on net-next:
>
> recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=232, nlmsg_type=RTM_NEWSTATS, nlmsg_flags=0, nlmsg_seq=1651407411, nlmsg_pid=198}, {family=AF_UNSPEC, ifindex=if_nametoindex("lo"), filter_mask=1<<IFLA_STATS_UNSPEC}, [{nla_len=204, nla_type=IFLA_STATS_LINK_64}, {rx_packets=0, tx_packets=0, rx_bytes=0, tx_bytes=0, rx_errors=0, tx_errors=0, rx_dropped=0, tx_dropped=0, multicast=0, collisions=0, rx_length_errors=0, rx_over_errors=0, rx_crc_errors=0, rx_frame_errors=0, rx_fifo_errors=0, rx_missed_errors=0, tx_aborted_errors=0, tx_carrier_errors=0, tx_fifo_errors=0, tx_heartbeat_errors=0, tx_window_errors=0, rx_compressed=0, tx_compressed=0, rx_nohandler=0}]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 232
> 1: lo: group link
>     RX:  bytes packets errors dropped  missed   mcast           
>              0       0      0       0       0       0 
>     TX:  bytes packets errors dropped carrier collsns           
>              0       0      0       0       0       0 
> +++ exited with 0 +++
>
> Note the difference in size of IFLA_STATS_LINK_64 which carries struct
> rtnl_link_stats64: 196 bytes vs. 204 bytes
>
> The 8 byte difference is most likely from the addition of
> rx_otherhost_dropped at the end:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=794c24e9921f32ded4422833a990ccf11dc3c00e
>
> I guess it worked for me because I didn't have this member in my copy of
> the uAPI file, but it's now in iproute2-next:
>
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bba95837524d09ee2f0efdf6350b83a985f4b2f8

Thanks, I'll send a fix.
