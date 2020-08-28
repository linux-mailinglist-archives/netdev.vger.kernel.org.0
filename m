Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C752025638D
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 01:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH1XmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 19:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbgH1XmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 19:42:19 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F70DC061264;
        Fri, 28 Aug 2020 16:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=sJO6zPU113docaHLc9V1IgRkQ/8ndDDRf6lClTOXy8A=; b=cl2YYh2XhhyHrjF6cjPtHRfL4w
        a9bZacq5X4pQT+e4sw3dJFFnG372xlZsICmZ3p5dDFKy0QtC9kHNdG1fUYIEWH+VE1w/UiiAAohoJ
        Y3yI8R7JM69uD0/MA7NQZc3ffuX2+Cept29LMA8KM1Tkg62ho9z1aghXS+5wQr4KVns+QM1rIVmbH
        P3GyTSx6Pema1BWPF0PpNUWP+YLeW1eGwWjsypc+Pi1vZpeE8xLKVz2RolUlBDlLW18qyMxFJDzoA
        SfuxqBKym0IrDb+Bbo1vIv9ykplJwEpy4+FhkgFrvahE+97odJF6MxeyyckAwZJ29PqQ7pLJBSOm8
        bIGUbw9g==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBo0T-0001Bv-OP; Fri, 28 Aug 2020 23:42:06 +0000
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Brian Vazquez <brianvv@google.com>
Cc:     Sven Joachim <svenjoac@gmx.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200729212721.1ee4eef8@canb.auug.org.au>
 <87ft8lwxes.fsf@turtle.gmx.de>
 <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
 <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
 <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
 <878sdyn6xz.fsf@turtle.gmx.de>
 <49315f94-1ae6-8280-1050-5fc0d1ead984@infradead.org>
 <CAMzD94QKnE+1Cmm0RNFUVAYArBRB0S2VUUC5c4jTY9Z4xdZH0w@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4dce5976-d4a1-1fbf-8824-a92adfc542b5@infradead.org>
Date:   Fri, 28 Aug 2020 16:42:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAMzD94QKnE+1Cmm0RNFUVAYArBRB0S2VUUC5c4jTY9Z4xdZH0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 4:16 PM, Brian Vazquez wrote:
> On Fri, Aug 28, 2020 at 8:12 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 8/28/20 8:09 AM, Sven Joachim wrote:
>>> On 2020-08-27 11:12 -0700, Brian Vazquez wrote:
>>>
>>>> I've been trying to reproduce it with your config but I didn't
>>>> succeed. I also looked at the file after the preprocessor and it
>>>> looked good:
>>>>
>>>> ret = ({ __builtin_expect(!!(ops->match == fib6_rule_match), 1) ?
>>>> fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })
>>>
>>> However, in my configuration I have CONFIG_IPV6=m, and so
>>> fib6_rule_match is not available as a builtin.  I think that's why ld is
>>> complaining about the undefined reference.
>>
>> Same here FWIW. CONFIG_IPV6=m.
> 
> Oh I see,
> I tried this and it seems to work fine for me, does this also fix your
> problem? if so, I'll prepare the patch, and thanks for helping!
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index 51678a528f85..40dfd1f55899 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -16,7 +16,7 @@
>  #include <net/ip_tunnels.h>
>  #include <linux/indirect_call_wrapper.h>
> 
> -#ifdef CONFIG_IPV6_MULTIPLE_TABLES
> +#if defined(CONFIG_IPV6_MULTIPLE_TABLES) && defined(CONFIG_IPV6)


Yes, that works for me.
You can add this to your patch:

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

thanks.
-- 
~Randy

