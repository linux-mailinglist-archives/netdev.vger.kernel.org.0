Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230194C7FE7
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiCABBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiCABBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:01:04 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BC42DE1
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:00:24 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id g39so24249150lfv.10
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ud5/y/EBwvp8QN7vw5ZxaiWuDsWQaCGba2UHh4N4mec=;
        b=QDNLH8KOj2N5elfQIiFc9ZMVPG667ughU6MItd4VPmNt6fV069Cvzy3GNDu1LboIOU
         /ukem7qn980/nnuqsEKTwz+sJAAGQSBr/OuNtNkm7jqBwkXZFdDq4KuXeUYSVdjS5Ygf
         UbLkNglYiw3uAvK1jhMlolPsp6Bm5sW2kE0eY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ud5/y/EBwvp8QN7vw5ZxaiWuDsWQaCGba2UHh4N4mec=;
        b=XZ3rfTB0XeMftmMNkzqetZElAJAnb3vK744uzdQWfquM8D3B0gpsoqFZm3s+3emIg6
         fMQKTGV+VJmn8b82dZgZzwQejKbUsasxpAVmIweq2AcEu6Nd6Frycz1qNILg7qStr8Ez
         tmCr10XNxbudy6jXoMyicDjAZULGTMS+sDbl/n4qiESFUI9W2+HihzzYQ8SqARNGEmqB
         y6eEZZA2+Q9QTVZRQXrCHoPOyIBZ8hBhJQtRtOXiti4FeM3DTvNN8iRFQJLrxgT9n0DG
         dRYQxncg/afBlX9CBejHlgu9BbYQjXBMSSEtu6eG8IoeVk67AOV7IqPfy79liCzddTPs
         Elkg==
X-Gm-Message-State: AOAM531OiLYVaCbCtHvjGP8XABwgatW82uwInopF0r/17ZEKhKdwyLtP
        WESJonFNM9O6DiF8rBao2sQay5lZMSNpR1/UfwE=
X-Google-Smtp-Source: ABdhPJzcIIN3b2dIlY0cPl6GN1bwzG8JNBYrEdYy3Xvx7uxkZY50JEmppQ7OFVobHVG3cFri+wmb0w==
X-Received: by 2002:a05:6512:3f07:b0:443:c110:2605 with SMTP id y7-20020a0565123f0700b00443c1102605mr13918588lfa.173.1646096422538;
        Mon, 28 Feb 2022 17:00:22 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id v21-20020a2e9915000000b002452577587esm1629334lji.16.2022.02.28.17.00.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 17:00:22 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id d23so24252199lfv.13
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:00:22 -0800 (PST)
X-Received: by 2002:a2e:aaa2:0:b0:244:bf42:3e6e with SMTP id
 bj34-20020a2eaaa2000000b00244bf423e6emr16240083ljb.176.1646096101617; Mon, 28
 Feb 2022 16:55:01 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com> <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org> <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <20220301003059.GE614@gate.crashing.org>
In-Reply-To: <20220301003059.GE614@gate.crashing.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 16:54:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLYqYcw0xv65xrLSR7KDpS_6M+S9737m6NQorHGWsXYQ@mail.gmail.com>
Message-ID: <CAHk-=wgLYqYcw0xv65xrLSR7KDpS_6M+S9737m6NQorHGWsXYQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mike Rapoport <rppt@kernel.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        alsa-devel@alsa-project.org, KVM list <kvm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, linux1394-devel@lists.sourceforge.net,
        drbd-dev@lists.linbit.com, linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-aspeed@lists.ozlabs.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        samba-technical@lists.samba.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 4:38 PM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> In C its scope is the rest of the declaration and the entire loop, not
> anything after it.  This was the same in C++98 already, btw (but in
> pre-standard versions of C++ things were like you remember, yes, and it
> was painful).

Yeah, the original C++ model was just unadulterated garbage, with no
excuse for it, and the scope was not the loop, but the block the loop
existed in.

That would never have been acceptable for the kernel - it's basically
just an even uglier version of "put variable declarations in the
middle of code" (and we use "-Wdeclaration-after-statement" to
disallow that for kernel code, although apparently some of our user
space tooling code doesn't enforce or follow that rule).

The actual C99 version is the sane one which actually makes it easier
and clearer to have loop iterators that are clearly just in loop
scope.

That's a good idea in general, and I have wanted to start using that
in the kernel even aside from some of the loop construct macros.
Because putting variables in natural minimal scope is a GoodThing(tm).

Of course, we shouldn't go crazy with it. Even after we do that
-std=gnu11 thing, we'll have backports to worry about. And it's not
clear that we necessarily want to backport that gnu11 thing - since
people who run old stable kernels also may be still using those really
old compilers...

            Linus
