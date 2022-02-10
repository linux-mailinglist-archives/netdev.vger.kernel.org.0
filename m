Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD874B1125
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiBJPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:02:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243267AbiBJPCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:02:14 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2045.outbound.protection.outlook.com [40.107.102.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97160C15
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:02:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/i+kZ08SwkaydjgUG5M41+2SmD6beAMKYotVsvyUEGbcut/YLt9SDXbsr7Pm4Ome0J93FcAng3aCimtBTJqKeSKf+kju/SYiDYBYLYggsvZ8BkajlTeRbpS9rsnsm5is1k7JdQ/zi63wzNw2SpPx76th3ZjsDepoZdv5bxr1MhhxS3ejm4uOZfia8EAUQBP5oCIm6rOP7S3CA+EfO9XVi0sBQrVnJI1eEiQ0p1YTGwNuqPfOSEssaEz7TYTKpzivLD/ZQ2bhNVCFf3E2ZK57qAyI8Y4k1WvtCWCabvJjrEoZaQwhs2EV8m2sGL9rJxTrO27LDjOiS/G8ZvOt90pew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSWzkXTPPvAorIVLx5To37zCnpEc2FOwmACsPcKJX8U=;
 b=cu2Y3uK8LUoW4zewbEsuvK7rogjdo9A9pWvSbls8swtN8inJV0nsCRTXja0lncYoMi5imoK+KiusbjgTxWpGhDeVIaYCwmuQ8TWJBjUg2m+l2RY8mx6TXHyY6SZFrXrHmZc3gtLmVzu0t0zQdZOqLH5EGGH1xCFDAd4fgPrhIfafMgNy//TFPen2mQrKALKIjA3oxfsjIfvPYxcfqIbhu7BUBDu7Vq/kR6G8IuI7dLlufQWeOi7U9J8Ne/SaMcFr2KhpnTmV6Vnk1g1wt4rAX05xiqna+UT5jS6nkYp9RZCGcTn9WMlobCm9DwMcahEQa54IkBgmdNT+mXgRRcrwfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSWzkXTPPvAorIVLx5To37zCnpEc2FOwmACsPcKJX8U=;
 b=ZKJxLH2Rv7fEhkkIqyUugxtOyCw2WgZ+7GecfTIHPqPu5aQkVZWh/NVY7+LjotpjZ9YCNH1vaptISGnQyDgkW5pfi9ZT0RB8mO6814N17Vr/Qn/ByWhZL6KpQNFCDjDxpr49u6lVo9ui5MSklcrS6UkachHvvxb7JRWwNdsvSLNk8Gh0uIaFAT0DmdoMdFALbDvy1mrVN88mufNypenJqP1Wmf3URRpE1HOABJhjqK7Ak7QXBFyRNGE4yjAQoOc88ZerZddqyESNFOXczMYBtC5FiwBs2Jdu6dtkgYBr2Gfk5zDaqXmExPi9g/7pGBNU9o/vMmvdz0Y6772fyia7KQ==
Received: from MWHPR03CA0004.namprd03.prod.outlook.com (2603:10b6:300:117::14)
 by MN2PR12MB2958.namprd12.prod.outlook.com (2603:10b6:208:aa::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 15:02:12 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:117::4) by MWHPR03CA0004.outlook.office365.com
 (2603:10b6:300:117::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 10 Feb 2022 15:02:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 15:02:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 15:02:11 +0000
Received: from [172.27.13.180] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 07:02:09 -0800
Message-ID: <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
Date:   Thu, 10 Feb 2022 17:02:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, <netdev@vger.kernel.org>
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220210142401.4912-2-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c14b129c-aab2-447e-54d4-08d9eca65154
X-MS-TrafficTypeDiagnostic: MN2PR12MB2958:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2958FFE96C57C1FF53B51EA8DF2F9@MN2PR12MB2958.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJlO1HjBmUP8R0GeCyA88DDGsmlypqR676H5fmu4wD9jfvl4Ha2rFR1coD295C7n3gRCAtaRtrOj28dblk4Xv4OyWR9mMKMDb2q78JbfS4hIbSS6M3zCmvujfXhUrcaH7CKcLJH8SdJMlWCw97mcixQneLWqDZHpk0NH/zqlSkga1IeDO4Hf/nLbYYp7fJKKNbRZZZJcsTwe7LQC2uSMkeHZKMRkz3Tb2VRSX27rtf9LTqlwASdXf1AiBmvqHW4mc0thQDPaDSaiGmrohILiRPFryiMMP88txOVCsYC7oqUuabqAaOQcLOxOtuDdV5YZ7tBhWJ76mF85oK8F1E5b8sTC6q0N0MGKg1QmRRx1pxjXzBGmzqvrKANuX8dbM7tzEwAL5kSpNJyhXrQ3JKpfRZamaPQN6ExvFpsehXDg9Xaz3K/CqPCRb4VmrIv2UWJjI+rmUj6/m/G5mTqkS+QCQT1fHPhqxzzrMbvacwFxzuxYJC99ufqGi+TcVoIA9/xIevoq49vAHDC+l9GvErvfcmXDzXPBqpvEQX7+UpnVq6ptIWWdFpPRCQH1D1zc+RGhTJ31PFG8XeMDbuuV0zEY4pa8AAe9GJ1pyUK+MTakeCZ2dqMXcCtAoxN8g40Sv1XT+e99qKVutqnX45vTqQeazuc3svCu+2SDt+2okIE98uDNJs8OFPW1D8D7jcmqw99R9ISwUFCSezpVVx+fZKQeUjug7xeYFwjA1chSG06G92dpezeZ1yNWJ8ob9raAbL7LXVoL/prIsAkR3HXHlHiX3w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(8676002)(2906002)(81166007)(356005)(8936002)(316002)(82310400004)(16576012)(110136005)(47076005)(36860700001)(5660300002)(31686004)(26005)(16526019)(6666004)(53546011)(36756003)(186003)(40460700003)(2616005)(70206006)(426003)(70586007)(336012)(83380400001)(31696002)(508600001)(36900700001)(2101003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:02:12.1280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c14b129c-aab2-447e-54d4-08d9eca65154
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2958
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
> This opt-in feature creates a per-port cache of dest_mac+src_mac+vlan tuples
> with enough information to quickly push frames to the correct destination port.
> It can be enabled per-port
> 
> Cache entries are automatically created when a skb is forwarded from one port
> to another, and only if there is room and both ports have the offload flag set.
> 
> Whenever a fdb entry changes, all corresponding cache entries associated with
> it are automatically flushed.
> 
> In my test on MT7622 when bridging 1.85 Gbit/s from Ethernet to WLAN, this
> significantly improves bridging performance, especially with VLAN filtering
> enabled:
> 
> CPU usage:
> - no offload, no VLAN: 79%
> - no offload, VLAN: 84%
> - offload, no VLAN: 73-74%
> - offload, VLAN: 74%
> 
> MT7622 has support for hardware offloading of packets from LAN to WLAN, both
> routed and bridged. For bridging it needs source/destination MAC address entries
> like the ones stored in this offload cache. This code will be extended later
> in order to create appropriate flow_offload rules to handle this
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  include/linux/if_bridge.h       |   1 +
>  include/uapi/linux/if_link.h    |   3 +
>  net/bridge/Kconfig              |  10 +
>  net/bridge/Makefile             |   1 +
>  net/bridge/br.c                 |   8 +
>  net/bridge/br_device.c          |   4 +
>  net/bridge/br_fdb.c             |  20 +-
>  net/bridge/br_forward.c         |   3 +
>  net/bridge/br_if.c              |   4 +
>  net/bridge/br_input.c           |   5 +
>  net/bridge/br_netlink.c         |  31 ++-
>  net/bridge/br_offload.c         | 466 ++++++++++++++++++++++++++++++++
>  net/bridge/br_private.h         |  30 +-
>  net/bridge/br_private_offload.h |  53 ++++
>  net/bridge/br_stp.c             |   3 +
>  net/bridge/br_vlan_tunnel.c     |   3 +
>  net/core/rtnetlink.c            |   2 +-
>  17 files changed, 641 insertions(+), 6 deletions(-)
>  create mode 100644 net/bridge/br_offload.c
>  create mode 100644 net/bridge/br_private_offload.h
> 

Hi Felix,
that looks kind of familiar. :) I've been thinking about a similar optimization for
quite some time and generally love the idea, but I thought we'd allow this to be
implemented via eBPF flow speedup with some bridge helpers. There's also a lot of low
hanging fruit about optimizations in bridge's fast-path.

Also from your commit message it seems you don't need to store this in the bridge at
all but can use the notifications that others currently use and program these flows
in the interested driver. I think it'd be better to do the software flow cache via
ebpf, and do the hardware offload in the specific driver.

I can't do a thorough review of the patch right now and obviously it will have to be
broken up in smaller pieces. When I get a chance I'll comment on the details.

Thank you,
 Nik
