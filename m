Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67A01C7867
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgEFRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbgEFRog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:44:36 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B543C0610D5
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 10:44:36 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t2so2091370lfc.3
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNt2KHwB8PiMSyUUcvWbb3LmQf/yl99wmVRwAMCe6Sw=;
        b=QfIhp8bnkHziXy45j6AZQvnQuPZVCBRmkYNh4Qk1yBWY/AbDih3c468GHPPi0NxUWC
         +RsQItHsCm4TW5y+JMWQZhOFGKrkw/OMHO8k0Ff3ChO35z8KVI8vHTXhfxO6dpDN2zOT
         R/3GLd58rAk/zgyKNOtvPikt/JEPwM8VJVw+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNt2KHwB8PiMSyUUcvWbb3LmQf/yl99wmVRwAMCe6Sw=;
        b=eksM0LxyXAfaSE1Y6VrD5o9Qsg2dZ4R9ZuN/XJmGCnpMqF62gp5NBqXQfdka3f1/wX
         Zdj8hEz1AqfbGYIbeiaKLc/4EWGTeOZLC1pO/A9AcjDll+isUzfQ1szOVij3jV0+Dm4+
         mgFrgRWRfgzRDKJSCgUtjhYy5T/AfCqevDJB63PdKWkk8VC8vsjdPSqH4G2hP8hg/FCj
         GosM2zxWEUT/8wGKVqNiFwODS/SCQNX5yRgSvNxKc5BuytR0D+PsbHi3IzAP/qz0r79P
         HRBYJtu6YpmwX5js867rOA5vymx+o3P4O4A1aOX2bE4usfmL6ivrccEv1bwYJxmWzFD9
         ii2g==
X-Gm-Message-State: AGi0PubjLlYrA3bxEJDM028p2r6GbDv3ytdh1+iXYM5RCwlJaizZ80fq
        jXgR2dZQshKdrDSwBGIh56XMGQUzhrE=
X-Google-Smtp-Source: APiQypLcGuBST19irUGYXyKG6WPrAPJwpq9CJ7Q0omLAl+YGc3Zb7Wf4hjOQA88H4p467BmKHh2iDw==
X-Received: by 2002:ac2:5282:: with SMTP id q2mr4690973lfm.100.1588787073209;
        Wed, 06 May 2020 10:44:33 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id b4sm2021069lfo.33.2020.05.06.10.44.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 10:44:32 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id d25so2072345lfi.11
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:44:31 -0700 (PDT)
X-Received: by 2002:a19:6e4e:: with SMTP id q14mr5836440lfk.192.1588787071388;
 Wed, 06 May 2020 10:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-9-hch@lst.de>
In-Reply-To: <20200506062223.30032-9-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 May 2020 10:44:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3T6u_kj8r9f3aGXCjuyN210_gJC=AXPFm9=wL-dGALA@mail.gmail.com>
Message-ID: <CAHk-=wj3T6u_kj8r9f3aGXCjuyN210_gJC=AXPFm9=wL-dGALA@mail.gmail.com>
Subject: Re: [PATCH 08/15] maccess: rename strnlen_unsafe_user to strnlen_user_unsafe
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 11:22 PM Christoph Hellwig <hch@lst.de> wrote:
>
> This matches the convention of always having _unsafe as a suffix, as
> well as match the naming of strncpy_from_user_unsafe.

Hmm. While renaming them, can we perhaps clarify what the rules are?

We now have two different kinds of "unsafe". We have the
"unsafe_get_user()" kind of unsafe: the user pointer itself is unsafe
because it isn't checked, and you need to use a "user_access_begin()"
to verify.

It's the new form of "__get_user()".

And then we have the strncpy_from_user_unsafe(), which is really more
like the "probe_kernel_read()" kind of funtion, in that it's about the
context, and not faulting.

Honestly, I don't like the "unsafe" in the second case, because
there's nothing "unsafe" about the function. It's used in odd
contexts. I guess to some degree those are "unsafe" contexts, but I
think it might be better to clarify.

So while I think using a consistent convention is good, and it's true
that there is a difference in the convention between the two cases
("unsafe" at the beginning vs end), one of them is actually about the
safety and security of the operation (and we have automated logic
these days to verify it on x86), the other has nothing to do with
"safety", really.

Would it be better to standardize around a "probe_xyz()" naming?

Or perhaps a "xyz_nofault()" naming?

I'm not a huge fan of the "probe" naming, but it sure is descriptive,
which is a really good thing.

Another option would be to make it explicitly about _what_ is
"unsafe", ie that it's about not having a process context that can be
faulted in. But "xyz_unsafe_context()" is much too verbose.
"xyz_noctx()" might work.

I realize this is nit-picky, and I think the patch series as-is is
already an improvement, but I do think our naming in this area is
really quite bad.

The fact that we have "probe_kernel_read()" but then
"strncpy_from_user_unsafe()" for the _same_ conceptual difference
really tells me how inconsistent the naming for these kinds of "we
can't take page faults" is. No?

                   Linus
