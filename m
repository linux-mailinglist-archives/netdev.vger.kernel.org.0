Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5735254CA8
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgH0SNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgH0SNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:13:09 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28C0C061232
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:13:08 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id j10so3045712qvo.13
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssRaouXMj2o/HtEZZ3R9vlEAQEleSnlrqRH6Z6mK0YM=;
        b=hTYxcSPYcs/JpYjOgeSQeg6Xl3LxylMwCdjgvYwx1aZ0q9UMPVlNcB95FXYna3al52
         IbTaBhRvKMuLTqjFu5nwJvvcRfM5hlW4mr0CAIw5t/TZ9K03o40d9+HsdyT9aHbx1V9u
         6lZyigyUUK6y9vpQiHxICC3q0LPAv4EOwqGca0jbl9DK/0ufdjWzxlzp4M+vIrJCDfLD
         rTLXzM7s1yCsMnkF3SLfrSOCuq2rWL6RINgYVQ1ynhxBGMt2E2ZfHWhIMvb97fvURbWm
         /4HAoGwQtJz95MMLCIXruMdQ2RP37flfW+Z+PMdo9OixEUHbUjbtaq1V5cLjd1XtAf10
         iwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssRaouXMj2o/HtEZZ3R9vlEAQEleSnlrqRH6Z6mK0YM=;
        b=cZ/ZMon13EI8AXE0LAOLfZzdHUzOS8ohYxQ027zu6uALO0GXwloe1fa0pJxwXg/QD3
         +1xm+ZoX3Un/FtkltTONHXpJKEOe0soGMAlETSqFHrSx+wa7Lpe92LDf1lFln20QaQez
         pBfBYrgpX8qHxsmQS7XUX6CW2HYejLaPafnHUrmUPNNAWib/XcoktZEyeUCdhlvNrQ0s
         MXw+W1eiz+mUrcFxyLt+ZKW/E/tBJ2oOUgVYOChqAMRmDMU3ILcUPy/4u8iWIcU3l9cG
         DitYukcpo6dBSi2XtwHOx0aTJNFJTVpUmdM0lDaMWzPyzQINqcnRQ0d8z/Mz25OiyT8C
         83TQ==
X-Gm-Message-State: AOAM5314X63wjLQ354kx3Gka+pQ91sj7UT91wpJGvYaUQXkwn7VAv8e+
        T2YU4XDHdph9fPuzpR52JmdhNWGS9a7/9IKQSt1CUb7kriRLrFTC
X-Google-Smtp-Source: ABdhPJy+icwO9xKN//159CWIuCBqk8MV0Dp0jEhUL4JCTuBiRCitMg1ap+ZOEoYO7Yy4bHcgdPptWx3uVVGIwM6G+34=
X-Received: by 2002:a05:6214:10ca:: with SMTP id r10mr232930qvs.185.1598551987724;
 Thu, 27 Aug 2020 11:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200729212721.1ee4eef8@canb.auug.org.au> <87ft8lwxes.fsf@turtle.gmx.de>
 <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
 <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
In-Reply-To: <87pn7gh3er.fsf@turtle.gmx.de>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 27 Aug 2020 11:12:56 -0700
Message-ID: <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Sven Joachim <svenjoac@gmx.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven,

I've been trying to reproduce it with your config but I didn't
succeed. I also looked at the file after the preprocessor and it
looked good:

ret = ({ __builtin_expect(!!(ops->match == fib6_rule_match), 1) ?
fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })

Note that fib4_rule_match doesn't appear as the
CONFIG_IP_MULTIPLE_TABLES is not there.

Could you share more details on how you're compiling it and what
compiler you're using??

Thanks,
Brian



On Mon, Aug 24, 2020 at 1:08 AM Sven Joachim <svenjoac@gmx.de> wrote:
>
> On 2020-08-22 08:16 +0200, Sven Joachim wrote:
>
> > On 2020-08-21 09:23 -0700, Brian Vazquez wrote:
> >
> >> Hi Sven,
> >>
> >> Sorry for the late reply, did you still see this after:
> >> https://patchwork.ozlabs.org/project/netdev/patch/20200803131948.41736-1-yuehaibing@huawei.com/
> >> ??
> >
> > That patch is apparently already in 5.9-rc1 as commit 80fbbb1672e7, so
> > yes I'm still seeing it.
>
> Still present in 5.9-rc2 as of today, I have attached my .config for
> reference.  Note that I have CONFIG_IPV6_MULTIPLE_TABLES=y, but
> CONFIG_IP_MULTIPLE_TABLES is not mentioned at all there.
>
> To build the kernel, I have now deselected IPV6_MULTIPLE_TABLES.  Not
> sure why this was enabled in my .config which has grown organically over
> many years.
>
> Cheers,
>        Sven
>
>
> >> On Mon, Aug 17, 2020 at 12:21 AM Sven Joachim <svenjoac@gmx.de> wrote:
> >>
> >>> On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:
> >>>
> >>> > Hi all,
> >>> >
> >>> > After merging the net-next tree, today's linux-next build (i386
> >>> defconfig)
> >>> > failed like this:
> >>> >
> >>> > x86_64-linux-gnu-ld: net/core/fib_rules.o: in function
> >>> `fib_rules_lookup':
> >>> > fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to
> >>> `fib6_rule_match'
> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to
> >>> `fib6_rule_action'
> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to
> >>> `fib6_rule_action'
> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to
> >>> `fib6_rule_suppress'
> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to
> >>> `fib6_rule_suppress'
> >>>
> >>> FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
> >>> 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
> >>> apparently not sufficient.
> >>>
> >>> ,----
> >>> | $ grep IPV6 .config
> >>> | CONFIG_IPV6=m
> >>> | # CONFIG_IPV6_ROUTER_PREF is not set
> >>> | # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> >>> | # CONFIG_IPV6_MIP6 is not set
> >>> | # CONFIG_IPV6_ILA is not set
> >>> | # CONFIG_IPV6_VTI is not set
> >>> | CONFIG_IPV6_SIT=m
> >>> | # CONFIG_IPV6_SIT_6RD is not set
> >>> | CONFIG_IPV6_NDISC_NODETYPE=y
> >>> | CONFIG_IPV6_TUNNEL=m
> >>> | CONFIG_IPV6_MULTIPLE_TABLES=y
> >>> | # CONFIG_IPV6_SUBTREES is not set
> >>> | # CONFIG_IPV6_MROUTE is not set
> >>> | # CONFIG_IPV6_SEG6_LWTUNNEL is not set
> >>> | # CONFIG_IPV6_SEG6_HMAC is not set
> >>> | # CONFIG_IPV6_RPL_LWTUNNEL is not set
> >>> | # CONFIG_NF_SOCKET_IPV6 is not set
> >>> | # CONFIG_NF_TPROXY_IPV6 is not set
> >>> | # CONFIG_NF_DUP_IPV6 is not set
> >>> | # CONFIG_NF_REJECT_IPV6 is not set
> >>> | # CONFIG_NF_LOG_IPV6 is not set
> >>> | CONFIG_NF_DEFRAG_IPV6=m
> >>> `----
> >>>
> >>> > Caused by commit
> >>> >
> >>> >   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
> >>> fib_rules_ops")
> >>> >
> >>> > # CONFIG_IPV6_MULTIPLE_TABLES is not set
> >>> >
> >>> > I have reverted that commit for today.
> >>>
> >>> Cheers,
> >>>        Sven
> >>>
