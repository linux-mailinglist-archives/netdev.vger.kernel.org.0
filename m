Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0582B242F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgKMTAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMTAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:00:50 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EBCC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:00:48 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id m65so7388524qte.11
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q61m3Kag5Q/urXoUxGuvFJyxhAGq2M6Yw4QQ7h8f4/g=;
        b=eVH8SOcg6etopMOqefnzlfuv5HXkjkjMe1tD5L0XY7MOc6IippCXQdP+jpKt7m3eNZ
         Sb0DMS4u2JX5zPwtkpb8JtYJsYxeqhwRxLUsoPURERHWv7LzlF1G0jJS9C8gzZSLrgB1
         Ep1UKsbNojq1/JV7pQcLxJEP3PDEUfMw28MmThalTfbVmbEvDQ1TDI/018/Bx68mP9KH
         L7TZT6ToaOMk56dvLG7Td8NK6uGlfP5hBz3IiyHUoLwfur068au3UJFTgZ/I50NHaVQ0
         W/SPNOPqH4njhufkgTseQYVHDHZi+Dl2rSloiXc7CKgpnB671vmekHAuNuXNjTQ0fQRn
         OLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q61m3Kag5Q/urXoUxGuvFJyxhAGq2M6Yw4QQ7h8f4/g=;
        b=rXa/u2009tdP4KPo6GQjxtC6Nj1jGFmt4NPqtgCQ3AafuAEel5e41CloIlW1mPWB8L
         qfQDmZnuj2ErBYwRHyyL0IdnjmNzbOuQ3aEs+/ZYcJsBQdxDBaqh2R6eGDoh8M0/tGRs
         ABbpBb+d7L6Gw8w2rD/PV747vu8q4d+tdWhACSsk+NZHAVfOncNBkTwOC0DVlSS9SM+6
         iI4VaFTmBho8zNFDjcJSxJ259Y56oigrrq0qQ0ODhjkQ9uSQYCqEakr86m1AU6IA1b4h
         ZofzDbznT+n5uuUqS9EmA9n1M1yYKLwmTZ54nsfilvG7QIrWUhqSzX+bQBZwmzMgDA/g
         zssw==
X-Gm-Message-State: AOAM531eR6d+JT0wgF6nojSGWN+5WF7ny20Im2n5AlbgBxKipJMtHt+a
        CUUKHwPjEtqyzUnRIsVh0h0=
X-Google-Smtp-Source: ABdhPJwP7QlRqii+5SQW4s1ykFWMwN0N20UOg1l/k6i0L/9JLQrDwaBNMuWYyzfgZm+lX9P8KjQ58g==
X-Received: by 2002:ac8:6898:: with SMTP id m24mr3404486qtq.157.1605294047936;
        Fri, 13 Nov 2020 11:00:47 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id k4sm3314691qki.2.2020.11.13.11.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 11:00:47 -0800 (PST)
Date:   Fri, 13 Nov 2020 12:00:45 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
Message-ID: <20201113190045.GA1463790@ubuntu-m3-large-x86>
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <202011131747.puABQV5A-lkp@intel.com>
 <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c7623978-5586-5757-71aa-d12ee046a338@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7623978-5586-5757-71aa-d12ee046a338@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 10:05:56AM -0700, David Ahern wrote:
> On 11/13/20 9:57 AM, Jakub Kicinski wrote:
> > Good people of build bot, 
> > 
> > would you mind shedding some light on this one? It was also reported on
> > v1, and Andrea said it's impossible to repro. Strange that build bot
> > would make the same mistake twice, tho.
> > 
> 
> I kicked off a build this morning using Andrea's patches and the config
> from the build bot; builds fine as long as the first 3 patches are applied.
> 

I can confirm this as well with clang; if I applied the first three
patches then this one, there is no error but if you just apply this one,
there will be. If you open the GitHub URL, it shows just this patch
applied, not the first three, which explains it.

For what it's worth, b4 chokes over this series:

$ b4 am -o - 20201107153139.3552-1-andrea.mayer@uniroma2.it | git am
Looking up https://lore.kernel.org/r/20201107153139.3552-1-andrea.mayer%40uniroma2.it
Grabbing thread from lore.kernel.org/linux-kselftest
Analyzing 18 messages in the thread
---
Writing /tmp/tmp8425by7fb4-am-stdout
  [net-next,v2,3/5] seg6: add callbacks for customizing the creation/destruction of a behavior
---
Total patches: 1
---
 Link: https://lore.kernel.org/r/20201107153139.3552-1-andrea.mayer@uniroma2.it
 Base: not found
---
Applying: seg6: add callbacks for customizing the creation/destruction of a behavior
error: patch failed: net/ipv6/seg6_local.c:1015
error: net/ipv6/seg6_local.c: patch does not apply
Patch failed at 0001 seg6: add callbacks for customizing the creation/destruction of a behavior
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Even if I grab the mbox from lore.kernel.org, it tries to do the same
thing and apply the 3rd patch first, which might explain why the 0day
bot got confused.

Cheers,
Nathan
