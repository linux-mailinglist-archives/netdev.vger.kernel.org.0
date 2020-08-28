Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC004256367
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 01:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgH1XQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 19:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgH1XQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 19:16:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABC6C06121B
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 16:16:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z2so805448qtv.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 16:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUiusd1WVdha2EfIkzMSJdUrei8ON9hbpIBb4XxxaCI=;
        b=iI2La+ZvveBSC07B6Qw6ujjE0TnkENEdYY7iqIdsD9PjSI+El+bFJloTtBL2jzfPBs
         4w+4yCRpKW4XpccZVIwh8b2/3VeKDrlJEnvSiFUNDbQmSVRopcePppU/9P1w9gZVdWbq
         Daa2eRMdRUd/NGrrCSsXGIW/EqDw6JefvjlLRtFWMnNUtMHvpiTc1Ny6G73q4GhzysYx
         BTg7FwpruP/CsWFV5JIvjobvC89LlpKBBvPPLnE7i1GvOPrShO/R0PdZzoAPhQtyOqhr
         0cb2/CiIgHsTSzyxgjZIjJzRFeRcx0GElwSA9P6mykp8GSE4/C/knH2pXxci7CS1aJxY
         HfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUiusd1WVdha2EfIkzMSJdUrei8ON9hbpIBb4XxxaCI=;
        b=qIkVnECrUjuZioYc9cfYPtbDyzKKfkddvaH7j5dN+F4H41Y/NxpA9OSFMDER/qg5BU
         +LWLlPjZ1FK4NCWNPx3+wRk2ObCBmr5DXL4ITeKNQ3bBD/DKMqJokXifIPF4RZU5n8oq
         IQ7tt1wrK9g4MrPCbaYTlV4aaraxq8au7JPAX5LymyaRh+KTbc4WohzokasY+viIBXPR
         NkYTYKiivUoaqIVsoPocXO8rPGPGwK3bdj8p1ONty8yB7C59gislEnM42tJLNibJGyfn
         33peNtZuBUUOphzNN794BQwNwbufcBcBLTzY+p60c0wGs0kGb2dj9Q6SIbmltWIxI6tC
         RQ1A==
X-Gm-Message-State: AOAM530GcBYFpjwjmZJ58fXMscTUhhwacKYQ/jgFR5z97TEROdFS8MuC
        ZcpdwOWhrfi0uO7/TpJt/KW0I85w2XZd7WvGYzH5Dw==
X-Google-Smtp-Source: ABdhPJzk3HhQJ+PBTgzg+a2kvBqGs9IZusZmReJJbwBL8DCVy5Ia0OqzaniEgfbBrgaqBqaTYzvAEhEnK3ZrPZzhYB0=
X-Received: by 2002:ac8:7959:: with SMTP id r25mr3570738qtt.85.1598656607627;
 Fri, 28 Aug 2020 16:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200729212721.1ee4eef8@canb.auug.org.au> <87ft8lwxes.fsf@turtle.gmx.de>
 <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
 <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
 <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
 <878sdyn6xz.fsf@turtle.gmx.de> <49315f94-1ae6-8280-1050-5fc0d1ead984@infradead.org>
In-Reply-To: <49315f94-1ae6-8280-1050-5fc0d1ead984@infradead.org>
From:   Brian Vazquez <brianvv@google.com>
Date:   Fri, 28 Aug 2020 16:16:36 -0700
Message-ID: <CAMzD94QKnE+1Cmm0RNFUVAYArBRB0S2VUUC5c4jTY9Z4xdZH0w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Sven Joachim <svenjoac@gmx.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 8:12 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/28/20 8:09 AM, Sven Joachim wrote:
> > On 2020-08-27 11:12 -0700, Brian Vazquez wrote:
> >
> >> I've been trying to reproduce it with your config but I didn't
> >> succeed. I also looked at the file after the preprocessor and it
> >> looked good:
> >>
> >> ret = ({ __builtin_expect(!!(ops->match == fib6_rule_match), 1) ?
> >> fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })
> >
> > However, in my configuration I have CONFIG_IPV6=m, and so
> > fib6_rule_match is not available as a builtin.  I think that's why ld is
> > complaining about the undefined reference.
>
> Same here FWIW. CONFIG_IPV6=m.

Oh I see,
I tried this and it seems to work fine for me, does this also fix your
problem? if so, I'll prepare the patch, and thanks for helping!
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 51678a528f85..40dfd1f55899 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -16,7 +16,7 @@
 #include <net/ip_tunnels.h>
 #include <linux/indirect_call_wrapper.h>

-#ifdef CONFIG_IPV6_MULTIPLE_TABLES
+#if defined(CONFIG_IPV6_MULTIPLE_TABLES) && defined(CONFIG_IPV6)

>
>
> > Changing the configuration to CONFIG_IPV6=y helps, FWIW.
> >
> >> Note that fib4_rule_match doesn't appear as the
> >> CONFIG_IP_MULTIPLE_TABLES is not there.
> >>
> >> Could you share more details on how you're compiling it and what
> >> compiler you're using??
> >
> > Tried with both gcc 9 and gcc 10 under Debian unstable, binutils 2.35.
> > I usually use "make bindebpkg", but just running "make" is sufficient to
> > reproduce the problem, as it happens when linking vmlinux.
> >
> > Cheers,
> >        Sven
> >
> >
> >> On Mon, Aug 24, 2020 at 1:08 AM Sven Joachim <svenjoac@gmx.de> wrote:
> >>>
> >>> On 2020-08-22 08:16 +0200, Sven Joachim wrote:
> >>>
> >>>> On 2020-08-21 09:23 -0700, Brian Vazquez wrote:
> >>>>
> >>>>> Hi Sven,
> >>>>>
> >>>>> Sorry for the late reply, did you still see this after:
> >>>>> https://patchwork.ozlabs.org/project/netdev/patch/20200803131948.41736-1-yuehaibing@huawei.com/
> >>>>> ??
> >>>>
> >>>> That patch is apparently already in 5.9-rc1 as commit 80fbbb1672e7, so
> >>>> yes I'm still seeing it.
> >>>
> >>> Still present in 5.9-rc2 as of today, I have attached my .config for
> >>> reference.  Note that I have CONFIG_IPV6_MULTIPLE_TABLES=y, but
> >>> CONFIG_IP_MULTIPLE_TABLES is not mentioned at all there.
> >>>
> >>> To build the kernel, I have now deselected IPV6_MULTIPLE_TABLES.  Not
> >>> sure why this was enabled in my .config which has grown organically over
> >>> many years.
> >>>
> >>> Cheers,
> >>>        Sven
> >>>
> >>>
> >>>>> On Mon, Aug 17, 2020 at 12:21 AM Sven Joachim <svenjoac@gmx.de> wrote:
> >>>>>
> >>>>>> On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:
> >>>>>>
> >>>>>>> Hi all,
> >>>>>>>
> >>>>>>> After merging the net-next tree, today's linux-next build (i386
> >>>>>> defconfig)
> >>>>>>> failed like this:
> >>>>>>>
> >>>>>>> x86_64-linux-gnu-ld: net/core/fib_rules.o: in function
> >>>>>> `fib_rules_lookup':
> >>>>>>> fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
> >>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to
> >>>>>> `fib6_rule_match'
> >>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to
> >>>>>> `fib6_rule_action'
> >>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to
> >>>>>> `fib6_rule_action'
> >>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to
> >>>>>> `fib6_rule_suppress'
> >>>>>>> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to
> >>>>>> `fib6_rule_suppress'
> >>>>>>
> >>>>>> FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
> >>>>>> 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
> >>>>>> apparently not sufficient.
> >>>>>>
> >>>>>> ,----
> >>>>>> | $ grep IPV6 .config
> >>>>>> | CONFIG_IPV6=m
> >>>>>> | # CONFIG_IPV6_ROUTER_PREF is not set
> >>>>>> | # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> >>>>>> | # CONFIG_IPV6_MIP6 is not set
> >>>>>> | # CONFIG_IPV6_ILA is not set
> >>>>>> | # CONFIG_IPV6_VTI is not set
> >>>>>> | CONFIG_IPV6_SIT=m
> >>>>>> | # CONFIG_IPV6_SIT_6RD is not set
> >>>>>> | CONFIG_IPV6_NDISC_NODETYPE=y
> >>>>>> | CONFIG_IPV6_TUNNEL=m
> >>>>>> | CONFIG_IPV6_MULTIPLE_TABLES=y
> >>>>>> | # CONFIG_IPV6_SUBTREES is not set
> >>>>>> | # CONFIG_IPV6_MROUTE is not set
> >>>>>> | # CONFIG_IPV6_SEG6_LWTUNNEL is not set
> >>>>>> | # CONFIG_IPV6_SEG6_HMAC is not set
> >>>>>> | # CONFIG_IPV6_RPL_LWTUNNEL is not set
> >>>>>> | # CONFIG_NF_SOCKET_IPV6 is not set
> >>>>>> | # CONFIG_NF_TPROXY_IPV6 is not set
> >>>>>> | # CONFIG_NF_DUP_IPV6 is not set
> >>>>>> | # CONFIG_NF_REJECT_IPV6 is not set
> >>>>>> | # CONFIG_NF_LOG_IPV6 is not set
> >>>>>> | CONFIG_NF_DEFRAG_IPV6=m
> >>>>>> `----
> >>>>>>
> >>>>>>> Caused by commit
> >>>>>>>
> >>>>>>>   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
> >>>>>> fib_rules_ops")
> >>>>>>>
> >>>>>>> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> >>>>>>>
> >>>>>>> I have reverted that commit for today.
> >>>>>>
> >>>>>> Cheers,
> >>>>>>        Sven
>
>
> --
> ~Randy
>
