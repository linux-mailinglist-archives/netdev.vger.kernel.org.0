Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A750247846
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 22:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHQUn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHQUnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 16:43:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6B7C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=iO3xqP7te8z66ftSGeoWPKMsbPuLBk2Um4g86TIl1SY=; b=Bo6MaBUVdGSk0e/yxyA24+297n
        RUXNp4aVZxxBS3rIXH0vbI724i/wuAppS/ynNN396FFmRSOVNXbtA5Bs5/rM1kYNwodeHZHzvkq2D
        v1RjZZnEq6iq03Mlxgy3pHmkhzzadGveH4Hc2BioJjn99v3peZz3KUy12OanMLFZbWpwKlcb/0e51
        oxZd/ZvydKOe8+VlsPMn5qKc2v78sknmss+9HBalz5yc3UBx3YwxbgG8YVzM7OZLOu38agT3igQtV
        XNxYstbWQPWGL8W36sAYgLkr+sQsZu+eWLQ9CunhAP1FJIMvoxa0xFFuomVyLv22KRQonoMgKkU0l
        XdFhztWQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7lyK-0007Iv-Dy; Mon, 17 Aug 2020 20:43:13 +0000
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
 <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org>
 <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org>
Date:   Mon, 17 Aug 2020 13:43:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20 1:29 PM, Cong Wang wrote:
> On Mon, Aug 17, 2020 at 12:55 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> TIPC=m and IPV6=m builds just fine.
>>
>> Having tipc autoload ipv6 is a different problem. (IMO)
>>
>>
>> This Kconfig entry:
>>  menuconfig TIPC
>>         tristate "The TIPC Protocol"
>>         depends on INET
>> +       depends on IPV6 || IPV6=n
>>
>> says:
>> If IPV6=n, TIPC can be y/m/n.
>> If IPV6=y/m, TIPC is limited to whatever IPV6 is set to.
> 
> Hmm, nowadays we _do_ have IPV6=y on popular distros.
> So this means TIPC would have to be builtin after this patch??

No, it does not mean that. We can still have IPV6=y and TIPC=m.

Hm, maybe I should have said this instead:

  If IPV6=y/m, TIPC is limited _by_ whatever IPV6 is set to.
                (instead of    _to_ )

Does that help any?

The "limited" in Kconfig rules is a "less than or equal to"
limit, where 'm' < 'y'.



> Still sounds harsh, right?
> 
> At least on my OpenSUSE I have CONFIG_IPV6=y and
> CONFIG_TIPC=m.
> 
>> TIPC cannot be =y unless IPV6=y.
> 
> Interesting, I never correctly understand that "depends on"
> behavior.
> 
> But even if it builds, how could TIPC module find and load
> IPV6 module? Does IPV6 module automatically become its
> dependency now I think?

Sorry, I don't know about this.


-- 
~Randy

