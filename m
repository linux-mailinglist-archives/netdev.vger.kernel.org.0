Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18CE48EDEE
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243275AbiANQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbiANQTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:19:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8203DC061574;
        Fri, 14 Jan 2022 08:19:24 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x83so3153585pfc.0;
        Fri, 14 Jan 2022 08:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+XOS+yU1t+lk/sHk/LsTZqTmWmSghHZu/3OGRdz47g=;
        b=drxOjeeoSjznU61kIKfsu032f1Gk8Zs444uZ5DUVkCUkjSZKwKkaLfuCSHTf0SbPC6
         pFbx+qhh58QvXOE4m37VpgeVxeT9h1j7lm3OoFdRq6hz3rCFP+b2fFB8L1HEnYE3Xajq
         tUkE9pouzRaNAEDXDlNmd/NiboXQGofTPXSnIR16a6g9V//KtR88Ckco2aPt+GQpmWtK
         dZ7F3nEvqOL4d+qALt+HZT513QDgp2M30hfU8bNJbbQYWkniBJDtovhZPiR89SbeFBHu
         LcLzpkifurEdffTm5aV5bRu3qSag+mAIoAjfrZtMGmHsdp2jPslCIdXCiL1tY0/FFiXh
         dJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+XOS+yU1t+lk/sHk/LsTZqTmWmSghHZu/3OGRdz47g=;
        b=J9aWyV147EPZQKtLCitk6gzVmtUhRMuvvhvBWkDchq5ertdCFvLqjdIWx5L8+4pp0L
         VOWAS65PfuczL2KtZAaMjKwzstYx8Hs6XKjeOvSjud+vFbcgzc1Usoaz5X5u8uSTMg8/
         LnXeQREVrvfY0WkBQ6AV9MWvWCegpwwVBbaMqd2bmBbGwimmgro+DV42fbdIBbpzfn5H
         stw6zusnfD+nbsPgVvHK/uytXGnhpl8otduWPxmpBm9GBHPtwBw+ofGFhIZGfHKFdtUM
         KuiEmBgKUEuRd/nrimUF2816setAFwAvlbn/3ai+99ykDUpRCVWhI3aWPp3tHYMO8cS7
         0IoA==
X-Gm-Message-State: AOAM530/3I06N6SjL7JHxhVNudzNJa7/MYhhXNCQFTHbOlGklIbf+JiA
        AI0CSexQE1k5Gdmrw17TN7mtv7sGYUqHfJKBQs4=
X-Google-Smtp-Source: ABdhPJzTvJtyVk8UXspHT1nQqMFqp1dXQyjp2xL0d7KspMxr89t/AxZe9dEGxZT2BGgXxtNmfFzZzkOIITNoEO1tVXg=
X-Received: by 2002:a63:1ca:: with SMTP id 193mr8398425pgb.497.1642177163942;
 Fri, 14 Jan 2022 08:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
 <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com> <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
In-Reply-To: <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jan 2022 08:19:12 -0800
Message-ID: <CAADnVQKCSJi=U4gNv48vsS8Guu7_JP946yMuNqVAJ-D=rAme7w@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 7:08 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Yeah, so the issue is that, at *some* point, SHA-1 is going to have to
> go.

sha1 cannot be removed from the kernel.
See AF_ALG and iproute2 source for reference.
