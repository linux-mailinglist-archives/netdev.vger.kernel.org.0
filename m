Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C112477BA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgHQTzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbgHQTzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:55:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB488C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=R4/mKF9SLfdokQkl9A497YjzGH+XhZd8/azQ3JBoLag=; b=qGg6ejxbK4v7X6/cwsM3yFkVOe
        tQO08uTqemsbnm5I/faigfRiPRUhhatyqUSpYRVj7/7AWyBlBKX+VBIt9UfQefKnVz44AqAimtW94
        44XgIRx0rciZiE9HGLsA66V+hSjXMlf6Z+Xxn/TiBL6V87XI+W1G2K+YXL78JirSA59a2QtVRrWeW
        AXX7F0Y1as7OI+jJmjfO75JuFEOxQSaApUOQwULhVr5JZlSzUkE6wjiR9eN7OuGB15T3CM3CHC1Zq
        bpELVZc3jRBlktRLHaXu9DMOf/IuC9rO3jB1r1uN/YHY65GnI4N0utqh+TEEarY5sk6lGCcTWXAnt
        5kv+WEPg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7lE7-00048q-I7; Mon, 17 Aug 2020 19:55:28 +0000
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
 <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org>
 <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org>
Date:   Mon, 17 Aug 2020 12:55:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20 12:26 PM, Cong Wang wrote:
> On Mon, Aug 17, 2020 at 12:00 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 8/17/20 11:55 AM, Cong Wang wrote:
>>> On Mon, Aug 17, 2020 at 11:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>>>
>>>> On 8/17/20 11:31 AM, Cong Wang wrote:
>>>>> On Sun, Aug 16, 2020 at 11:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>>>
>>>>>> On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>>>>
>>>>>>> Or put it into struct ipv6_stub?
>>>>>> Hi Cong,
>>>>>>
>>>>>> That could be one way. We may do it when this new function becomes more common.
>>>>>> By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.
>>>>>
>>>>> I am not a fan of IPV6=m, but disallowing it for one symbol seems
>>>>> too harsh.
>>>>
>>>> Hi,
>>>>
>>>> Maybe I'm not following you, but this doesn't disallow IPV6=m.
>>>
>>> Well, by "disallowing IPV6=m" I meant "disallowing IPV6=m when
>>> enabling TIPC" for sure... Sorry that it misleads you to believe
>>> completely disallowing IPV6=m globally.
>>>
>>>>
>>>> It just restricts how TIPC can be built, so that
>>>> TIPC=y and IPV6=m cannot happen together, which causes
>>>> a build error.
>>>
>>> It also disallows TIPC=m and IPV6=m, right? In short, it disalows
>>> IPV6=m when TIPC is enabled. And this is exactly what I complain,
>>> as it looks too harsh.
>>
>> I haven't tested that specifically, but that should work.
>> This patch won't prevent that from working.
> 
> Please give it a try. I do not see how it allows IPV6=m and TIPC=m
> but disallows IPV6=m and TIPC=y.

TIPC=m and IPV6=m builds just fine.

Having tipc autoload ipv6 is a different problem. (IMO)


This Kconfig entry:
 menuconfig TIPC
 	tristate "The TIPC Protocol"
 	depends on INET
+	depends on IPV6 || IPV6=n

says:
If IPV6=n, TIPC can be y/m/n.
If IPV6=y/m, TIPC is limited to whatever IPV6 is set to.
TIPC cannot be =y unless IPV6=y.


>> We have loadable modules calling other loadable modules
>> all over the kernel.
> 
> True, we rely on request_module(). But I do not see TIPC calls
> request_module() to request IPV6 module to load "ipv6_dev_find".


-- 
~Randy

