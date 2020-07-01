Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA08421038C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgGAGCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:02:08 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:45005 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGAGCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:02:08 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D593141611;
        Wed,  1 Jul 2020 14:02:04 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
Date:   Wed, 1 Jul 2020 14:02:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSk5PS0tLSk1IS0xDSEpZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw*Ix8ILxgxDQMeSiswSTocVlZVSE9MKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PhQ6Mio4QzgwSiw1PikUOiIp
        KT1PFDpVSlVKTkJITkNISElOS0lOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJQ01KNwY+
X-HM-Tid: 0a7308f7cf222086kuqyd593141611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/1/2020 1:52 PM, Cong Wang wrote:
> On Tue, Jun 30, 2020 at 7:36 PM wenxu <wenxu@ucloud.cn> wrote:
>>
>> On 7/1/2020 3:02 AM, Cong Wang wrote:
>>> On Mon, Jun 29, 2020 at 7:55 PM <wenxu@ucloud.cn> wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> The fragment packets do defrag in act_ct module. The reassembled packet
>>>> over the mtu in the act_mirred. This big packet should be fragmented
>>>> to send out.
>>> This is too brief. Why act_mirred should handle the burden introduced by
>>> act_ct? And why is this 158-line change targeting -net not -net-next?
>> Hi Cong,
>>
>> In the act_ct the fragment packets will defrag to a big packet and do conntrack things.
>>
>> But in the latter filter mirred action, the big packet normally send over the mtu of outgoing device.
>>
>> So in the act_mirred send the packet should fragment.
> Why act_mirred? Not, for a quick example, a new action called act_defrag?
> I understand you happen to use the combination of act_ct and act_mirred,
> but that is not the reason we should make act_mirred specifically work
> for your case.

Only forward packet case need do fragment again and there is no need do defrag explicit.


