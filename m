Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0732E48ADA
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFQR4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:56:49 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33849 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFQR4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:56:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id p17so10223051ljg.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTIMaymR2g7ReedoWbXicVhALRP9n80T++Kcv0+9jtg=;
        b=e0tz/APC5r77SqUGRyfs/Mwa7FuxmPdocJvVwqMgopem89HfOL1bhcEpLKWmjogU8K
         7tnCaXIJLhABAdqAJmR5Xrk33u93+x+oVv8LofRf9OgNyy1lfVfpWErV7PeDRcYYQW6c
         63h5TyhdbeMvuJ21173JUk65/NyRsTxCQcS+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTIMaymR2g7ReedoWbXicVhALRP9n80T++Kcv0+9jtg=;
        b=cHQNacQF40Vuq6U3mvPB+jp5PI9nifDL0i6JC96wYWpg59HAAJvvHda8ZT6Q9qhacr
         Bs6lXi/PjJm0JZxp+Uxkr+M3cVLCUBc9yoHf36OVU56PoFGbgSZjvapPpa8aUfVtPUtF
         EfPjzwQx8Uhpy0P7+k19JC7yxPpAzEW92kICoGc2iHvrgugYJdmQdKf/6jhPQCy6qkYa
         p+ZcTD4EouPDkDxCxw4XpWtKA4lLWOy3uRjb3t1WTbIGiy2LrIVSK8cG2tKYYgp3DfMO
         gFJpAyzfF1LeYxkAZ+miID2v4a5rEfgBVBG+/8DHliZiq/Hib3/XlG/kblwTF9dvkHdl
         dAPQ==
X-Gm-Message-State: APjAAAWZ+NyI2C4tGAYYTjrU4e1V7TkYzNRMwb4ZHujZ3xukfE+gTIIc
        qt/8Cjsi9HQPNDHmUcIIzw1XTvUhWfA=
X-Google-Smtp-Source: APXvYqx/vlUgbYFPYL1vsi+MSCSrHS8lE372ta5cwDrkwlERJa7/EIDhZzSwP3Q3QEpZm6uWZz9i2A==
X-Received: by 2002:a2e:4794:: with SMTP id u142mr14026720lja.222.1560794206516;
        Mon, 17 Jun 2019 10:56:46 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id m10sm1865388lfd.32.2019.06.17.10.56.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:56:46 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id p17so10222907ljg.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:56:46 -0700 (PDT)
X-Received: by 2002:a2e:9bc6:: with SMTP id w6mr17389201ljj.156.1560793800661;
 Mon, 17 Jun 2019 10:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com> <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
 <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jun 2019 10:49:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
Message-ID: <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 4:45 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> I wanted to introduce a new header, <asm/kernel_long_t.h>, and include
> it where the definition of __kernel_long_t is needed, something like
> this (incomplete, untested):

So this doesn't look interesting to me: __kernel_long_t is neither
interesting as a type anyway (it's just a way for user space to
override "long"), nor is it a namespace violation.

So honestly, user space could do whatever it wants for __kernel_long_t anyway.

The thing that I think we should try to fix is just the "val[]" thing, ie

> A different approach would rename <asm/posix_types.h> to something more
> basic, exclude the two structs, and move all internal #includes which do
> need the structs to the new header.

In fact, I wouldn't even rename <posix_types.h> at all, I'd just make
sure it's namespace-clean.

I _think_ the only thing causing problems is  '__kernel_fsid_t' due to
that "val[]" thing, so just remove ity entirely, and add it to
<statfs.h> instead.

And yeah, then we'd need to maybe make sure that the (couple) of
__kernel_fsid_t users properly include that statfs.h file.

Hmm?

               Linus
