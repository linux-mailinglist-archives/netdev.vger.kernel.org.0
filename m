Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1898210218
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGACdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:33:40 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12088 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGACdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 22:33:40 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4EFF641D08;
        Wed,  1 Jul 2020 10:33:36 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
Date:   Wed, 1 Jul 2020 10:33:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlIS0tLS09CTkJKS01ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw*MyMrIjpCDQ8eEgkeSjocVlZVSEooSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRw6Fhw4Vjg2DSxDEg0oD048
        OCIKFD1VSlVKTkJITkxLQ0pNTUlOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJSUxKNwY+
X-HM-Tid: 0a730838f1a42086kuqy4eff641d08
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/1/2020 3:02 AM, Cong Wang wrote:
> On Mon, Jun 29, 2020 at 7:55 PM <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The fragment packets do defrag in act_ct module. The reassembled packet
>> over the mtu in the act_mirred. This big packet should be fragmented
>> to send out.
> This is too brief. Why act_mirred should handle the burden introduced by
> act_ct? And why is this 158-line change targeting -net not -net-next?

Hi Cong,

In the act_ct the fragment packets will defrag to a big packet and do conntrack things.

But in the latter filter mirred action, the big packet normally send over the mtu of outgoing device.

So in the act_mirred send the packet should fragment. 

I think this is a bugfix in the net branch the act_ct handle with fragment will always fail.  


BR

wenxu

>
> Thanks.
>
