Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706802473C1
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404006AbgHQTAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404003AbgHQTAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:00:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5495DC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=FayMUQJBop6kyJcq2SFmt5tGAJLARBp2rPUdNLh6+WM=; b=bcPFB6dC+zjdjlR/SWypeJxYEX
        VkRnu5P09cUuVmHwgNmwhCkjr86IXcj/NhQiRhxGPtUvEb775QwIAhMNqMoHQySyBLHLawYkkweXw
        HrgZ6foyNqKP81pkx0+GzHVmb3fKAOtfzoE1V/jqnL2gAnTw5XRnA6qFDGgRCn8KrlIwBmY7v8h+0
        yM3a5hkiN4pcB7ddvAgnc5zW52tTvH4uu0+ilS8NMwHfJoiYmadLEx1T8IPH+jPvNkI77kAHkq0ME
        irj9bBWB33LHZRTZxQN5s/C3xldTnTHrW5/ZNWZj22sA49KBPB9kLRkOQGID4YfKr68RHCk1E7DhS
        2W129Omg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7kMs-00080u-Ub; Mon, 17 Aug 2020 19:00:29 +0000
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
 <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
 <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
 <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org>
 <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org>
Date:   Mon, 17 Aug 2020 12:00:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20 11:55 AM, Cong Wang wrote:
> On Mon, Aug 17, 2020 at 11:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 8/17/20 11:31 AM, Cong Wang wrote:
>>> On Sun, Aug 16, 2020 at 11:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>
>>>> On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>>
>>>>> Or put it into struct ipv6_stub?
>>>> Hi Cong,
>>>>
>>>> That could be one way. We may do it when this new function becomes more common.
>>>> By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.
>>>
>>> I am not a fan of IPV6=m, but disallowing it for one symbol seems
>>> too harsh.
>>
>> Hi,
>>
>> Maybe I'm not following you, but this doesn't disallow IPV6=m.
> 
> Well, by "disallowing IPV6=m" I meant "disallowing IPV6=m when
> enabling TIPC" for sure... Sorry that it misleads you to believe
> completely disallowing IPV6=m globally.
> 
>>
>> It just restricts how TIPC can be built, so that
>> TIPC=y and IPV6=m cannot happen together, which causes
>> a build error.
> 
> It also disallows TIPC=m and IPV6=m, right? In short, it disalows
> IPV6=m when TIPC is enabled. And this is exactly what I complain,
> as it looks too harsh.

I haven't tested that specifically, but that should work.
This patch won't prevent that from working.

We have loadable modules calling other loadable modules
all over the kernel.

-- 
~Randy

