Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3D4A44A5
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358963AbiAaLby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:31:54 -0500
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:24161
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359356AbiAaL1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 06:27:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mw5H1kNsHDOHtT2uGs7owE4kQ8TTVTGIDfaK5SlgiAD0AjF/Wt54ANeT+zOFL4xQQk3RILMYPHHAvHQztjXEz2pUd5mIlFUsDrvIS2gZO4yp34a1Dl0X5zdZ1s3C9UixAcdVG7nx7Zu9u2KwYhd1zBuEHCf336lloXtbIs+edV3fwxvAuTdzwdAGuAiIM8UmGSq6M5nCwkqe/Gu8lAgqiVK9W9WcBv+Ze4MZINhaA6+sb/WM/B+kKfdoKDyTf3e1KHgSOkncMUSgw/35wiSag9p5ZHFbDU1RAHjNmGeMsBgJdjexbB6p5YuIqWNIgFa2+C/PWAcH1CWXtJX7Np1nlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqyM6Q4910zISBflPaLGhU19M2oBOCrEX4i4W0k5OZ4=;
 b=ev/3y85Uv6+j8723PCAGhocx3g5/FktWufdXXqalJo1VaT1JdMmPXECfoXK8oawpOK/wS+yNCZFaGR3sliTHYpcSUCIBIfzfmRZyXt5imQYbd2Y6rZiPXhN1i90t9Se7kjHJJwKi7WzyL3gOvAtiilv2Bkp2hsBDDpK3EAilswoTT7paxtQqhws99XeMB76qHJpJhlGnl38O9zECWLOFza/PVALDegJa3mTgjE1Fm16LhjNzzzIdKBeCBH6SRpgTEBbM2QcmaN5RR3PPhKQlaD9ixT4wgDeoI3f6rlYfpIgUFkqg9C+AndMQxiL8pXEyfhXyZb+UaDub+wxwLu/nUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqyM6Q4910zISBflPaLGhU19M2oBOCrEX4i4W0k5OZ4=;
 b=IXQZl4/B3uxkIv3nDVIOzKrWTAHZPU4Vqox54LxQZSCbG3x+0SGKgj/OwPwa2cG/WFhqjEiapbRoJU7jM+pfY3luG38FWt9v+IFOCIZc1HpKKab/8z24n3fCV3pyoxWZJvjuGpeKIy0TB8j/cwijxPS4pOxr4Wal2BuT4Gq7ecA+n/G3YbPAAFsIp3wtERxMvJkNf/Tc5lrfd66zYpBKFATjyZWhSNOYzT0oHP79i/MspOJqg6DX/+tSJR5SELnHb+JPz4LqVYMQNKFmrPSzrg9LplWlrnv1OGpqzGvvXd6clb8AFXJIGDR6E1Xt4JlNPhgMNHeIw6vXIR7RJbmHKQ==
Received: from BN9P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::10)
 by BN9PR12MB5116.namprd12.prod.outlook.com (2603:10b6:408:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 11:26:53 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::20) by BN9P222CA0005.outlook.office365.com
 (2603:10b6:408:10c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 11:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 11:26:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 11:26:52 +0000
Received: from localhost.localdomain.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 03:26:50 -0800
References: <20210325153533.770125-1-atenart@kernel.org>
 <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com>
 <164267447125.4497.8151505359440130213@kwain>
 <ygnhee52lg2d.fsf@nvidia.com>
 <164338929382.4461.13062562289533632448@kwain>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <echaudro@redhat.com>,
        <sbrivio@redhat.com>, <netdev@vger.kernel.org>, <pshelar@ovn.org>
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info
 when PMTU triggers an ICMP reply
In-Reply-To: <164338929382.4461.13062562289533632448@kwain>
Date:   Mon, 31 Jan 2022 13:26:47 +0200
Message-ID: <ygnhsft4p2mg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf76ef2a-5735-4b5b-c183-08d9e4ac94c4
X-MS-TrafficTypeDiagnostic: BN9PR12MB5116:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5116F7D27F9E2428B527A1F5A0259@BN9PR12MB5116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXv/lQDlSbmjTzE0GwzbZrpjUkDuniRvsFNdsa/uN6g9q3Nt1Ah64cGWxD1U7dUNFULdfxW/2gfFB6iVXUATNmaDNzmjS8OThgC7AETQGDEMHQOKQpp5Y2uPaNulvQjZ0+z8lm9koADl7o1CzvmZJovoq6FWdO5pozgxaYwBW61Fky+7AipNE+HSypdRYCWX+YTQp3zmSc9buezFQHWX3okh9B4LXgvQzM+tuyE76VHE3D9IB4do6zj5jRc0vajZ+5a38HQdCaViUMylMqbCVAuDFzcL+nzNBHGFbK6qCbR8/L1XZwL4aDkh2ddy0wD8eJDP7/zueuwtMHMgFIq27FAbgkXvn41vfI8nXlWsTXdfuWM1gXVJeuN4N+o9lA/8N3Dlcu3NiYjPO7Yh8tHHr4mvMR0kenfd8XMPQhE+RGzAv4AUYvmWh1FIrUBn60+M1pCbUVL4osRyWleJDtdzqALX2WnkPcr1EaLjrZihwW3M2n8dAKUL3mYCrDwLOVC5UN+/OYUzITDVFv6R+trClgfWIFUjvvwMbI943i1c3YrYLpe7FjLAHfF60BDmDpfFdCA2bOz3VcoX2Z5ArBTm9C0B1zytAwUz5HnC+poid5tRB37uHNlkoJlQqKGgnC6/S/WjO+jSBlQoCrOuFx6QGjZ6NMxJNRWuerPwW+7yoQzpwzXKxP5h50cKNZCxdgMwxQ657/PRIzBt0LN79hY88Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(8936002)(316002)(86362001)(6666004)(4326008)(356005)(36756003)(81166007)(47076005)(8676002)(70206006)(70586007)(54906003)(6916009)(508600001)(426003)(16526019)(186003)(26005)(5660300002)(36860700001)(2616005)(82310400004)(2906002)(83380400001)(336012)(7696005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 11:26:52.9347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf76ef2a-5735-4b5b-c183-08d9e4ac94c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 28 Jan 2022 at 19:01, Antoine Tenart <atenart@kernel.org> wrote:
> Hi Vlad,
>
> Quoting Vlad Buslov (2022-01-20 13:58:18)
>> On Thu 20 Jan 2022 at 12:27, Antoine Tenart <atenart@kernel.org> wrote:
>> > Quoting Vlad Buslov (2022-01-20 08:38:05)
>> >> 
>> >> We have been getting memleaks in one of our tests that point to this
>> >> code (test deletes vxlan device while running traffic redirected by OvS
>> >> TC at the same time):
>> >> 
>> >> unreferenced object 0xffff8882d0114200 (size 256):
>> >>     [<0000000097659d47>] metadata_dst_alloc+0x1f/0x470
>> >>     [<000000007571c30f>] tun_dst_unclone+0xee/0x360 [vxlan]
>> >>     [<00000000d2dcfd00>] vxlan_xmit_one+0x131d/0x2a00 [vxlan]
>
> [...]
>
>> >> Looking at the code the potential issue seems to be that
>> >> tun_dst_unclone() creates new metadata_dst instance with refcount==1,
>> >> increments the refcount with dst_hold() to value 2, then returns it.
>> >> This seems to imply that caller is expected to release one of the
>> >> references (second one if for skb), but none of the callers (including
>> >> original dev_fill_metadata_dst()) do that, so I guess I'm
>> >> misunderstanding something here.
>> >> 
>> >> Any tips or suggestions?
>> >
>> > I'd say there is no need to increase the dst refcount here after calling
>> > metadata_dst_alloc, as the metadata is local to the skb and the dst
>> > refcount was already initialized to 1. This might be an issue with
>> > commit fc4099f17240 ("openvswitch: Fix egress tunnel info."); I CCed
>> > Pravin, he might recall if there was a reason to increase the refcount.
>> 
>> I tried to remove the dst_hold(), but that caused underflows[0], so I
>> guess the current reference counting is required at least for some
>> use-cases.
>> 
>> [0]:
>> 
>> [  118.803011] dst_release: dst:000000001fc13e61 refcnt:-2                             
>
> [...]
>
> I finally had some time to look at this. Does the diff below fix your
> issue?

Yes, with the patch applied I'm no longer able to reproduce memory leak.
Thanks for fixing this!

>
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 14efa0ded75d..90a7a4daea9c 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>  static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  {
>         struct metadata_dst *md_dst = skb_metadata_dst(skb);
> -       int md_size;
>         struct metadata_dst *new_md;
> +       int md_size, ret;
>  
>         if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
>                 return ERR_PTR(-EINVAL);
> @@ -123,8 +123,15 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  
>         memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>                sizeof(struct ip_tunnel_info) + md_size);
> +#ifdef CONFIG_DST_CACHE
> +       ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> +       if (ret) {
> +               metadata_dst_free(new_md);
> +               return ERR_PTR(ret);
> +       }
> +#endif
> +
>         skb_dst_drop(skb);
> -       dst_hold(&new_md->dst);
>         skb_dst_set(skb, &new_md->dst);
>         return new_md;
>  }
>
> Antoine

