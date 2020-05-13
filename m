Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400F71D22BF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732345AbgEMXIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:08:10 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A066C061A0C;
        Wed, 13 May 2020 16:08:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z22so995973lfd.0;
        Wed, 13 May 2020 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNbuJHQ2FyMpxkHjtWoncecO6OPO6CjKMW+uX9gNJuQ=;
        b=E3f+UENdQ+llqDktR8oL/X0mOcgxPl6XbzV5tFLaI/nTPWhDA2VjiutLqRr4Gr2FnX
         00wJ8JO8WMM6MBChTqTWfE9HLK2+N+RuNAVO0oq1nS3XBhFi8RlNmtkDxar0IxTKrVB4
         ztVuXFUMCVH2CIVVU2Cm8JyINivplXWk18yURJaCGUR5X3+XSJU4DXzT8Q6AGciXzVAZ
         xBB1+YLGz7ZWc4ZQoVr//c05cXlVbv0ePt+jilX54a3FDpy+bq9YeKF019uwtF3Wsm45
         aVaParymfJI9xz+Hu7rcYArTFQ8us08jvY4IcMuH/D68ENkg9NJjHSn3HL/owL+lmYFO
         bIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNbuJHQ2FyMpxkHjtWoncecO6OPO6CjKMW+uX9gNJuQ=;
        b=hFi4HdJ3SQT5yI+MGhjc182ymQ2hJEkPYCDH6ZOAgJPJQv0iESFOWXrXdP/VIzIGm9
         AKhOsDN3/GjolMSapNMxsGxLKnutME2iL8vY26NxxgluwcoEcunLzdTrlP+Ep4Jy+q64
         48yPtZMh04Nh4lIAOldTM+2KRzGxqBoK3zS+frUR60lKVWcAGg5QFmlzAXnSsQgFS5Kv
         szB4bKKLkjvivJo4ejqAs8EiUiyiStlXPYvr6QzSL/0KWvw+jEKgTjNPMpzEkxErxbuq
         pPpRWWCYYOhSscPk/LFmwCQOYwqh7nvfy+74rFnbZfDTEcccekzl/9Lf7t33jOSGVqMu
         Hj+Q==
X-Gm-Message-State: AOAM533oWTbFr2d/Aa093YOsHVCPGq6GIcFzmENw/7A0luYkyi9gsDaf
        rADm5khoC2XMK/yze6ISBjx/HNHfjMLghQA6vkg=
X-Google-Smtp-Source: ABdhPJxOj/yNtDM4jllZ+Qm0VoLlQbd+IYNXmhoTbj6xmFms5ShIIy5gKzrb6laWPJ6tbihcce9QXElpMpGV2RwJmpc=
X-Received: by 2002:ac2:58d7:: with SMTP id u23mr1081920lfo.119.1589411288282;
 Wed, 13 May 2020 16:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-5-git-send-email-alan.maguire@oracle.com> <1b63a6b193073674b6e0f9f95c62ce2af1b977cc.camel@perches.com>
In-Reply-To: <1b63a6b193073674b6e0f9f95c62ce2af1b977cc.camel@perches.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 May 2020 16:07:56 -0700
Message-ID: <CAADnVQK8osy9W8-u-K=ucqe5q-+Uik41fBw6d-SfG-m6rgVwDQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
To:     Joe Perches <joe@perches.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 4:05 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-05-12 at 06:56 +0100, Alan Maguire wrote:
> > printk supports multiple pointer object type specifiers (printing
> > netdev features etc).  Extend this support using BTF to cover
> > arbitrary types.  "%pT" specifies the typed format, and the pointer
> > argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> >
> > struct btf_ptr {
> >       void *ptr;
> >       const char *type;
> >       u32 id;
> > };
> >
> > Either the "type" string ("struct sk_buff") or the BTF "id" can be
> > used to identify the type to use in displaying the associated "ptr"
> > value.  A convenience function to create and point at the struct
> > is provided:
> >
> >       printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> >
> > When invoked, BTF information is used to traverse the sk_buff *
> > and display it.  Support is present for structs, unions, enums,
> > typedefs and core types (though in the latter case there's not
> > much value in using this feature of course).
> >
> > Default output is indented, but compact output can be specified
> > via the 'c' option.  Type names/member values can be suppressed
> > using the 'N' option.  Zero values are not displayed by default
> > but can be using the '0' option.  Pointer values are obfuscated
> > unless the 'x' option is specified.  As an example:
> >
> >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> >   pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> >
> > ...gives us:
> >
> > (struct sk_buff){
> >  .transport_header = (__u16)65535,
> >        .mac_header = (__u16)65535,
> >  .end = (sk_buff_data_t)192,
> >  .head = (unsigned char *)000000006b71155a,
> >  .data = (unsigned char *)000000006b71155a,
> >  .truesize = (unsigned int)768,
> >  .users = (refcount_t){
> >   .refs = (atomic_t){
> >    .counter = (int)1,
>
> Given
>
>   #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
>
> Maybe
>
>   #define BTF_INT_SIGNED  (1 << 0)
>   #define BTF_INT_CHAR    (1 << 1)
>   #define BTF_INT_BOOL    (1 << 2)
>
> could be extended to include
>
>   #define BTF_INT_HEX     (1 << 3)
>
> So hex values can be appropriately pretty-printed.

Nack to that.
