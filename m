Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E71C79D4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEFTBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgEFTBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:01:55 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC3EC061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 12:01:54 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u4so2267429lfm.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1YW5neYx+I7djIl9P+IGxfzCb/g7o5/jSWaOCUs8+Og=;
        b=GCmZceTe0bAxpUQhR6yPzoxL+CFuUYpbyX43pLbYRvXDmV1oNfPybKIyh9x2MgPLEa
         qpKspNJpMJPZ3YcRNr6quQhzNhYzGUbB3tJTkbf0hxTa9KzLjc8tj8vd7LdCWbyOwQlm
         2bdLxh+719yGT6LrvBVPW8JkltxIPBuRV4avc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1YW5neYx+I7djIl9P+IGxfzCb/g7o5/jSWaOCUs8+Og=;
        b=TWG0n7KvEA6S6qHt4Qt3daP7vYzORzJyQw6LOInkzCs5S26LizgxwaHM2p4mv0M7QM
         TKnak+SSQd7W6IN0o705O8I1E31dSMPedrQUNyk4Tm8zUO5u2gjDmo/lhInETAEa12Lw
         6M66gta2Y5m9Cl6bHqI2pKJ4VB4h0RFATpsQFZvPuG0WFTyYCi8KujDbbrTejGB4UJ7m
         KilNo0H8pvVBelO5W+ddPa6/yqbLGnDP3cL0VZ4inbOiDyU8yfM3Vc2N6pFqYvFQ76P8
         5h6xpWDfHDU/EUAzat22t092uvGRqT4haherpdkVHF9sda0FoGH04QuYr5/x25CeUKL6
         bcRA==
X-Gm-Message-State: AGi0PuYGEkwaKrDrThfa61P3owdefsLwuQ63JW90/S+mOPg93VWD7yl8
        shui3YIAKq0IYfzR7/kpldke+xP1OFE=
X-Google-Smtp-Source: APiQypKftyg2Mqj6mGlhdKImmDRnlmzUnDwG+3ZBOv0imx3Jpv9lR7ELYIsItMGKH5XrFwAQI+BtGQ==
X-Received: by 2002:a05:6512:46d:: with SMTP id x13mr6244855lfd.56.1588791712579;
        Wed, 06 May 2020 12:01:52 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id g11sm1879999ljg.24.2020.05.06.12.01.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 12:01:51 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id t11so2276694lfe.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:01:49 -0700 (PDT)
X-Received: by 2002:a19:6e4e:: with SMTP id q14mr6033958lfk.192.1588791708783;
 Wed, 06 May 2020 12:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-16-hch@lst.de>
 <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com> <20200506181543.GA7873@lst.de>
In-Reply-To: <20200506181543.GA7873@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 May 2020 12:01:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghKpGdTmD4EDfwX2uyppwxksU+nFyS1B--kbopcQAgwg@mail.gmail.com>
Message-ID: <CAHk-=wghKpGdTmD4EDfwX2uyppwxksU+nFyS1B--kbopcQAgwg@mail.gmail.com>
Subject: Re: [PATCH 15/15] x86: use non-set_fs based maccess routines
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006d706205a4ff6575"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006d706205a4ff6575
Content-Type: text/plain; charset="UTF-8"

On Wed, May 6, 2020 at 11:15 AM Christoph Hellwig <hch@lst.de> wrote:
>
> That was the first prototype, and or x86 it works great, just the
> __user cases in maccess.c are a little ugly.  And they point to
> the real problem - for architectures like sparc and s390 that use
> an entirely separate address space for the kernel vs userspace
> I dont think just use unsafe_{get,put}_user will work, as they need
> different instructions.

Oh, absolutely. I did *NOT* mean that you'd use "unsafe_get_user()" as
the actual interface. I just meant that as an implementation detail on
x86, using "unsafe_get_user()" instead of "__get_user_size()"
internally both simplifies the implementation, and means that it
doesn't clash horribly with my local changes.

Btw, that brings up another issue: so that people can't mis-use those
kernel accessors and use them for user addresses, they probably should
actually do something like

        if ((long)addr >= 0)
                goto error_label;

on x86. IOW, have the "strict" kernel pointer behavior.

Otherwise somebody will start using them for user pointers, and it
will happen to work on old x86 without CLAC/STAC support.

Of course, maybe CLAC/STAC is so common these days (at least with
developers) that we don't have to worry about it.

> Btw, where is you magic private tree and what is the plan for it?

I don't want to make it a public branch, but here's a private bundle.

It's based on top of my current -git tree - I just maintain a separate
tree that I keep up-to-date locally for testing. My "normal" tree I do
build tests on (allmodconfig etc), this separate tree I keep around to
actually do boot tests on, and I end up using "current Linus' tree
plus this" as the code I actually run om my main desktop.

But this *ONLY* works with clang, and only with current HEAD of the
clang development tree. So it's almosty entirely useless to anybody
else right now. You literally have to clone the llvm tree, build your
own clang, and install it to even _build_ this.

I'm not planning on going any further than my local testing until the
whole thing calms down. The llvm tree still has some known bugs in the
asm goto with output area, and I want there to be an actual release of
it before I actually merge anything like this (and I need to do the
small extra work to then have that conditional "does the compiler
support asm goto with outputs" so that it works with gcc too).

But here you see what it is, if you want to. __get_user_size()
technically still exists, but it has the "target branch" semantics in
here, so your patch clashes badly with it. (Well, those are the
semantics you want, so "badly" may not be the right word, but
basically it means that if you _had_ used unsafe_get_user(), there
wouldn't have been those kinds of semantic conflicts).

                Linus

--0000000000006d706205a4ff6575
Content-Type: application/octet-stream; name="asm-goto-outputs.bundle"
Content-Disposition: attachment; filename="asm-goto-outputs.bundle"
Content-Transfer-Encoding: base64
Content-ID: <f_k9vpfa000>
X-Attachment-Id: f_k9vpfa000

IyB2MiBnaXQgYnVuZGxlCi0zYzQwY2RiMGU5M2VjMTY2ZjFmYTRmZWUxZWI2MmQ0NWI1NDUxNTE1
IE1lcmdlIGJyYW5jaCAnbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9oZXJiZXJ0L2NyeXB0by0yLjYKY2QyZDZmYjI3NmY1YjMyMWE1ZDJhYjZi
NGVlOWZiMGQ0ZGMwZDE0MCBIRUFECgpQQUNLAAAAAgAAACCeEXicnc5BasMwEIXhvU4xZJ8yciRr
DKH0AF22BxhbI8dgS0EatT1+vegJunvww8fTKgJo3RwE2VEchkROIqZpEnTJSZg8s4ujBHHmyVWy
wnKzc7QogTjyHMLIN4zeL078yDKK9VPCwc+Guz5Khfct9wYfpX7xHhvc9W+97Wf4uabSc2TdSn4p
dX0F68mSdcESXJEQzVKOY1OV/0gUKCC5UwqnZD6bwIXbAWvRcoHvTR9Quj67Nkjn1WXnvIJK0y2v
5heJmVxtkhF4nJ2QQU4EIRBF95yiLjAGummgEjPxAC71ACVVNUPSA4amjd5eFp7A3cv7yVv80UWA
kbNVq26jyEsW8ux5SgrOY8asfgtOrZhP6lIHhIXVRtTMuApacRl1QY9+zUtYJpLillZr6Bz31uG1
1POAt9a/aOcDnscfvexz+L5oOyvTKK0+tX67gtuSwxBjQrjYZK3J7fEoY8h/SimmaJOfpThL5v0Q
yDvVG3z8AIvSuQ8oFca9HDDmGeYXoQRYGJwjeJyVkNtu2zAMQN/1FfyBdHaT6BIMQ4sM64ZtTYG4
zwYtUbZQxzQkOdn+fko7YMDe+sbbOSCZIxFIY5St1rLupCNj0bvaKFPfmrVx0jrpNG60RyVmjDRl
6JBQKW2NQltv117aW1S6Mg5RKtPZLUkt3cYJXPLAER6DfYHPlHAZp0AxwcfJ/cvueuZ+pBvLp09Q
b3Wtai1NDatKV5Uo1VPImSL8CNOSoOF4xtEVR/4b3Y2l8WvleZkc5sDTDcf+1aSVVpXeFJMqJvHd
8uRDvwN0Dt5i4PlKgC9bYjpBz5nh8gF4yfOSkxDNEBLgOPIlwb5AjqBMnPCFYEkE7EvtNIfxetUl
5AHSMs8c86vxzSLOGAN2I11FPPWQBwJfnHmIvPQDzFi4c0CYI82RLaVUYEc+TLQTAmB/ePzy7aHd
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
--0000000000006d706205a4ff6575--
