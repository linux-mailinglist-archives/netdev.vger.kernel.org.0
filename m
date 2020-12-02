Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA92CC9AD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgLBWfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgLBWfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:35:39 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0469AC0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:34:53 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so157478pga.7
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yj9uJKclERcz+3dgssLnxEsO561b5XP4e0V1kaqzzHU=;
        b=DeLWj512JCeqOATOifyLs3tV6W2ShtE1ozKCsCMSU6b/dQCrePNDDDeloHg6HKDTOn
         1tXXfhZpOM/qfpu/4uKGDZMdpt5+G1ACRIweOcs/IRUi1XkMbPofQLszlPUQOXU20LIa
         Mx+8bJ0ThXdxQoCDmjayo7oGrdsQBjuo4jxBM5pE5LAc9xLqX+4aelFrlcETUey4cPYf
         hmyloKX82XTEqwlYl+6VSFyn/0LCFwvTILiXeQeA3DO6PpzpRTalSglVTGDaojWaoh6w
         +nrj9HgM0DemgHvCXLIJZAWbPpx3SFiT199P0bSAaXdge0N4Jj5mWI0x97sLV553ptbE
         h3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yj9uJKclERcz+3dgssLnxEsO561b5XP4e0V1kaqzzHU=;
        b=TwT1agyE06/nSAc15PnFcGUWraeUOXsRxKrd0/zZRgxW8m2JRI9krt3yCmq3p0hSQ2
         ZI2f45Bf+KJKp8mQNHoG8V+xENVGcxo1PYlEhVxOtO+IIXHLoriYgmLBIE9QcQleZdJZ
         xPy1NgDNmcki5/iH3GhbsUJIXBr2DHcpJfHHhOiohnnl+JaSoOLQELzPwF3qBPsJxZPp
         zfJTNl/zfwGWOm7R/4kXFhyBezJ4T9JnCZqjY553WXX8g3g+wwAS/gBjXw2M8yVztsxT
         +PS1M7gF8pR3Cnbt42csApA5XBaGMcz90VLlCVzAawjmFdctccWwMFfUneh80nrNaQOU
         Lvxg==
X-Gm-Message-State: AOAM530g67f2Qs2Srgm/LR0A4nqLOjViBULmKEORVFUhd+2McheLOiDf
        xuJgAu6HQp+KO1S8iiw0/4QwBzs+/uklGra952yowg==
X-Google-Smtp-Source: ABdhPJwk9EgW3Fj29T0FZY+jliaMst7k9i/OfQ+jUCLl2350gsCT+2SSH1KV/nTldfxvpeHL5TQcjXv3gozBbabP5u4=
X-Received: by 2002:a63:3247:: with SMTP id y68mr437000pgy.10.1606948492350;
 Wed, 02 Dec 2020 14:34:52 -0800 (PST)
MIME-Version: 1.0
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com> <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
In-Reply-To: <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 2 Dec 2020 14:34:40 -0800
Message-ID: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Joe Perches <joe@perches.com>, Tom Rix <trix@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>
> > Yeah, we could go through and remove %h and %hh to solve this, too, right?
>
> Yup.
>
> I think one of the checkpatch improvement mentees is adding
> some suggestion and I hope an automated fix mechanism for that.
>
> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/

+ Tom, who's been looking at leveraging clang-tidy to automate such
treewide mechanical changes.
ex. https://reviews.llvm.org/D91789

See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
related context.
-- 
Thanks,
~Nick Desaulniers
