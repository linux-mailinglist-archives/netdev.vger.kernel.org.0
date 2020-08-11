Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB97241DEA
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgHKQLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:11:06 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14353 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgHKQLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 12:11:05 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f32c30c0000>; Tue, 11 Aug 2020 09:10:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 11 Aug 2020 09:11:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 11 Aug 2020 09:11:05 -0700
Received: from [10.2.60.121] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Aug
 2020 16:10:56 +0000
Subject: Re: VDPA Debug/Statistics
To:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        "Maor Dickman" <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "Parav Pandit" <parav@mellanox.com>
References: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
 <20200811073144-mutt-send-email-mst@kernel.org>
 <BN8PR12MB34259F2AE1FDAF2D40E48C5BAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
 <20200811083803-mutt-send-email-mst@kernel.org>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <16cef93e-7421-a151-65ab-ba21e44cd00f@nvidia.com>
Date:   Tue, 11 Aug 2020 09:10:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811083803-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597162252; bh=EK1sbFulOF0V9vRXAL3GbYbkOAW9ujbZSox8NAhaWus=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=gS19uwfsH12QJJzg9ZODa7mhQbKSP1lVW35d0TgX5+PAr7ToMbjpXXuaq/R2J2vnZ
         sEYD47GIu0nqR+rJQtdkjFLU+Yl83CqM3MN7b7BonSD8L5BanYpKbg81YS7Nz8UXL7
         YlKbwRcNK5liipinpMS67fkeNt6gw9WLVwW6mG+z5419Q78JxjOSAY+U4XHVbghojA
         PHyzitc4Y9iftdDW7ymuUOn22mRkk3QQ9KI/LJ80d4bAZc6GChOwJkxndt4l4gPuHU
         fEmP4ctUu244HPPdLw8pmcBQNnlxbwGUPeM1l0YgXZJr830nTrYW/lb0oD+9sa+XmV
         61sTlM6BQOFDA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/11/20 5:44 AM, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
>
>
> On Tue, Aug 11, 2020 at 11:58:23AM +0000, Eli Cohen wrote:
>> On Tue, Aug 11, 2020 at 11:26:20AM +0000, Eli Cohen wrote:
>>> Hi All
>>>
>>> Currently, the only statistics we get for a VDPA instance comes from the virtio_net device instance. Since VDPA involves hardware acceleration, there can be quite a lot of information that can be fetched from the underlying device. Currently there is no generic method to fetch this information.
>>>
>>> One way of doing this can be to create a the host, a net device for
>>> each VDPA instance, and use it to get this information or do some
>>> configuration. Ethtool can be used in such a case
>>>
>>> I would like to hear what you think about this or maybe you have some other ideas to address this topic.
>>>
>>> Thanks,
>>> Eli
>> Something I'm not sure I understand is how are vdpa instances created on mellanox cards? There's a devlink command for that, is that right?
>> Can that be extended for stats?
>>
>> Currently any VF will be probed as VDPA device. We're adding devlink support but I am not sure if devlink is suitable for displaying statistics. We will discuss internally but I wanted to know why you guys think.
> OK still things like specifying the mac are managed through rtnetlink,
> right?
>
> Right now it does not look like you can mix stats and vf, they are
> handled separately:
>
>          if (rtnl_fill_stats(skb, dev))
>                  goto nla_put_failure;
>
>          if (rtnl_fill_vf(skb, dev, ext_filter_mask))
>                  goto nla_put_failure;
>
> but ability to query vf stats on the host sounds useful generally.
>
> As another option, we could use a vdpa specific way to retrieve stats,
> and teach qemu to report them.

If you are looking for a place to add additional stats, please, check 
the RTM_*STATS api

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/core/rtnetlink.c#n5351
(Its a place where new interface and protocol stats are being added)
