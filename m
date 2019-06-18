Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DD04AEA8
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfFRXVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:21:43 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36113 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRXVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:21:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so5365636plt.3
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 16:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZfTdJ6aIMQJwzS251totZH4e8j1+FtxwNBavU5ugzX0=;
        b=BWagP6n0G1NjyfU/oMaA7agnVZ13RCCqLjCJU2wb+tXdmO3OeRVmyIS0C9gL88kMWW
         oKfMAx6mOUslDdEEVJiSJnquNzAFc/dNtlqfk2lxX/CNm0cTrTgkWuTQ4sOXMbFUbfzM
         nXdNtDkVdE3DbEu78vCn/NuK/IUDhm1tY37Ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZfTdJ6aIMQJwzS251totZH4e8j1+FtxwNBavU5ugzX0=;
        b=g/sgMAVhyGc5yPJss1QIrOKC5qazluxnFUERGtHczOvxcG274HnO4bU19BGEdVSMhE
         wkieNnVz+8q6Se5n/7MJHdt30zwPrOhZx7qGsl/D0bRdA7jdPDNg7OoDZ4cT4MjzI2JM
         lmTszbTy8rAVHMlAXx6J7w7cKv/AjfVDyuGQftMclyr37husjubOXfe+7cUAtsZa/OQh
         B3eMuKSZxsu8Hj8bgZDHibdVHb81gWOLdWLJ8yCv0/y4SF5KdMHV5lhTNQBo/nrbm1qH
         1YwOQaoT03HgafTct5auGwNXno5A8tAya7qcEyyQEFq6BTP5Uhx0eAjKoVeCrOi15p9R
         Wfng==
X-Gm-Message-State: APjAAAUdnK33z7VMDA7QTgVeLUPfFbGHbpGriJLgHa9VlERLFkgCT5M+
        G5UV2aI0HOitCKFeaIk0RSZK5Q==
X-Google-Smtp-Source: APXvYqzdlHfV2fjLKGboX1eKMLPkGFHswhIcGmdKWcLzHWynvJozKLsUlgfUdQogShJa1wssgZAOUg==
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr113081435pls.179.1560900102987;
        Tue, 18 Jun 2019 16:21:42 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id b26sm17983691pfo.129.2019.06.18.16.21.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 16:21:42 -0700 (PDT)
Date:   Tue, 18 Jun 2019 16:21:40 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Message-ID: <20190618232140.GW137143@google.com>
References: <20190618211440.54179-1-mka@chromium.org>
 <20190618230420.GA84107@archlinux-epyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190618230420.GA84107@archlinux-epyc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 04:04:20PM -0700, Nathan Chancellor wrote:
> On Tue, Jun 18, 2019 at 02:14:40PM -0700, Matthias Kaehlcke wrote:
> > empty_child_inc/dec() use the ternary operator for conditional
> > operations. The conditions involve the post/pre in/decrement
> > operator and the operation is only performed when the condition
> > is *not* true. This is hard to parse for humans, use a regular
> > 'if' construct instead and perform the in/decrement separately.
> > 
> > This also fixes two warnings that are emitted about the value
> > of the ternary expression being unused, when building the kernel
> > with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> > (https://lore.kernel.org/patchwork/patch/1089869/):
> > 
> > CC      net/ipv4/fib_trie.o
> > net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
> >         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> > 
> 
> As an FYI, this is also being fixed in clang:
> 
> https://bugs.llvm.org/show_bug.cgi?id=42239
> 
> https://reviews.llvm.org/D63369

Great, thanks!

In this case it was actually useful to get the warning, even though it
didn't point out the actual bug. I think in general it would be
preferable to avoid such constructs, even when they are correct. But
then again, it's the reviewers/maintainers task to avoid unnecessarily
cryptic code from slipping in, and this just happens to be one instance
where the compiler could have helped.
