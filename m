Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF52FDFC6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393273AbhAUCwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:52:18 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:13049 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbhAUCjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:39:18 -0500
Received: from [192.168.188.110] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id C546A5C1D3F;
        Thu, 21 Jan 2021 10:37:39 +0800 (CST)
Subject: Re: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID
 flag support
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVs5WOS0-Y7RvpOr12F8u84Rwna8EQ0NzuFof7Suc7Wyw@mail.gmail.com>
 <20210120234045.GC3863@horizon.localdomain>
 <CAM_iQpX7TSB1f4SY-tapnsGQr6HXv=sfGod9wcFvEd0oign6PQ@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7dface47-2e18-ffc3-3f11-39a996befb91@ucloud.cn>
Date:   Thu, 21 Jan 2021 10:37:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX7TSB1f4SY-tapnsGQr6HXv=sfGod9wcFvEd0oign6PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGElCHRpLS01KGU5MVkpNSkpKQk1NTkJCTEtVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MAg6Lyo6Ij0#UQtWSEM#Mkgs
        EA9PFBJVSlVKTUpKSkJNTU1LSklMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFISk9MNwY+
X-HM-Tid: 0a7722cdf8d12087kuqyc546a5c1d3f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/21/2021 9:09 AM, Cong Wang wrote:
> On Wed, Jan 20, 2021 at 3:40 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
>> On Wed, Jan 20, 2021 at 02:18:41PM -0800, Cong Wang wrote:
>>> On Tue, Jan 19, 2021 at 12:33 AM <wenxu@ucloud.cn> wrote:
>>>> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
>>>> index 2d70ded..c565c7a 100644
>>>> --- a/net/core/flow_dissector.c
>>>> +++ b/net/core/flow_dissector.c
>>>> @@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
>>>>  void
>>>>  skb_flow_dissect_ct(const struct sk_buff *skb,
>>>>                     struct flow_dissector *flow_dissector,
>>>> -                   void *target_container,
>>>> -                   u16 *ctinfo_map,
>>>> -                   size_t mapsize)
>>>> +                   void *target_container, u16 *ctinfo_map,
>>>> +                   size_t mapsize, bool post_ct)
>>> Why do you pass this boolean as a parameter when you
>>> can just read it from qdisc_skb_cb(skb)?
>> In this case, yes, but this way skb_flow_dissect_ct() can/is able to
>> not care about what the ->cb actually is. It could be called from
>> somewhere else too.
> This sounds reasonable, it is in net/core/ directory anyway,
> so should be independent of tc even though cls_flower is its
> only caller.
yes. This is the same what I think.
>
> Thanks.
>
