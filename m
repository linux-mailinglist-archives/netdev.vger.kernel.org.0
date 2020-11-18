Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8962B8391
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgKRSDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgKRSDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:03:32 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB6CC0613D4;
        Wed, 18 Nov 2020 10:03:32 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id c80so3197429oib.2;
        Wed, 18 Nov 2020 10:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3m6ruzi8yrhRHKgf6niw2+ejefydMk6FVAeq//2cpU=;
        b=aTLnDIWWm5gpNqVlc2HNkReacSRkboHtJIdRaw6TzV0g3BlT/oLQ0twbZqCndMKLAU
         XfZ/M7/4y1MC/jm3VsHP69lzkXxUXS1+qMkrvhT11vIGLuVJINebCzAFq9dwEnencEc/
         7llczIMBEKOZJ32KzKSzqZPnXw+KIUk4s+tAOd3V2htPUIeAkk3MPs5wmpdkonbefUx8
         YOVcK8vM6C+j05Q81C6uEKSpBSeEd0wlRo6h4xInFYiCsaQARQ5BIji2DdhRxB7zAVD0
         ddMhC+vnMiswFIRElF6orI+zeCyiFwma+4aOkkPeKbSkV2VBYgaWmYUGDfx56AQ0xLRE
         ZQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3m6ruzi8yrhRHKgf6niw2+ejefydMk6FVAeq//2cpU=;
        b=NY5VCzI70MKVUcBSxjQ8SIenRshHbQOcq4sXAwgLdxJ0yVcdKyJXVGRLFuRbrnmpDR
         GQVXP3RXLyI4MWKYye+To0JoF3DBX0fWnRYxXKWwlShxa5o0ZGlsRZ/zasJm9+YsDuZh
         xuj10oUoF9kyKbZ3g6G35p8P/bzlfZNijIEf/GU/J9mWQCPnF4z/0EhKoxVOOa3KKqSL
         TelgXGFz8qTvL9UvFnv7rTqneBQxIfrwSJHtRBBbzI5jZxYCPZ4mEtGEZAQCKA9SuvQG
         sa9Mu7gFJ4OtRZ06W/ZbCQRVKN4gZofBCGvtKx/L9eaKU+mVIPHgyYYdH+UMwBzr7Sz8
         CqTA==
X-Gm-Message-State: AOAM533G+Ahi7viRFnZBl3LrHe4gmcmIrMsezZ5dNiOyrfCfNL4ILG1+
        QmsT1aLnIJSxvUNZa/qpUNZIqclQe02Q++Urkw==
X-Google-Smtp-Source: ABdhPJzmBNIoXXZbyojhg5Y/QQvf3z/tuCLen5M9CZ7k0R1GGJhBqqikqGnvn3wCelMQ00kbmxhVb7ionuqu+0UppIc=
X-Received: by 2002:aca:e007:: with SMTP id x7mr241667oig.40.1605722611397;
 Wed, 18 Nov 2020 10:03:31 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-4-danieltimlee@gmail.com> <20201118055832.q5zsgulnsbjawgyq@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201118055832.q5zsgulnsbjawgyq@kafai-mbp.dhcp.thefacebook.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 18:03:14 +0900
Message-ID: <CAEKGpzjXUhnOVbamcysTX7KOrmEZ_JEzZMah3f9sLM2h+OkXsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] samples: bpf: refactor test_cgrp2_sock2
 program with libbpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 2:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 17, 2020 at 02:56:38PM +0000, Daniel T. Lee wrote:
> [ ... ]
>
> > +     err = bpf_link__pin(link, link_pin_path);
> > +     if (err < 0) {
> > +             printf("err : %d\n", err);
> > +             goto cleanup;
> > +     }
> > +
> > +     ret = EXIT_SUCCESS;
> > +
> > +cleanup:
> > +     if (ret != EXIT_SUCCESS)
> > +             bpf_link__destroy(link);
> This looks wrong.  cleanup should be done regardless.
>

At first, I thought destroying the link after the link__pin might unpin
the link, but I just tested it and confirmed that it actually didn't
and that the link kept pinned.

Thanks for pointing it out! I will stick to this method.

> > +
> > +     bpf_object__close(obj);
> > +     return ret;
> >  }



-- 
Best,
Daniel T. Lee
