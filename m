Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB62213C3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 19:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgGORxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 13:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGORxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 13:53:03 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9304CC061755;
        Wed, 15 Jul 2020 10:53:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g139so1543123lfd.10;
        Wed, 15 Jul 2020 10:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kzxx9RCldh3DF2JWeX19dZw4RjKkD4KoJuSfX3PHNJQ=;
        b=qW5AXC2Yja3W1A52gYUqCskX1FKrCdiGVWVNMlxPUBjnPRwxvtff4mZwg1L9SpEveC
         Qd9WuJkImx2UkE9WoLAeC/xt90kYdvlnYqJ85anwQek1YJ+HMuh8AvJE2oOgnltweKGf
         X4uU8Uok/qkEv5fs9u8TvLfuzCfyXt2XGj/VMCmAuc9UuGVpH5+Dih9Bnpp19w3jZotM
         OonXlr/J4Nt3RxxEKTSmqbnuI6NvRcY/NVEKtt22KilDY0pzxGRnQkashBBjJ7puNLYR
         xM9Bb/+hNPuUFtrBVnPZlSiurBb5NxGOUvgo1U8//1obKXoZ5mZIjb2gaIQsPxvMbJrb
         FxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kzxx9RCldh3DF2JWeX19dZw4RjKkD4KoJuSfX3PHNJQ=;
        b=kmVgpxXRDg6JTAKKo3Z7V8Jk7zxbStQXLql0YKqPGVN4oAgX+yJB3dxsXnRCQrQr5Y
         n9ZRPsBDfM+KjZIwOE4MoyQfBYivVMZHezBmWl864Q5OfnBKI4nQFe8jmToCzk7UA3Cm
         JCVAGg1gX/dzFDxXf+LX9rcfUGT/L1sii+FCcPjEAKPNwBUos1lMRvAomHPgjTXz5y1y
         JJ/s1uKKiouyzmYRFJXsC8/kn6Y8OAsEgfH8bZWbtKaIrDTlgiG99ykIHC8mitWv6K0t
         WP1hNXRS/t67YzUPSQYLU2tEgKMWhhkxjn9fdBag1lfmqbS3yPMJzSELf2mo1VeKyRmj
         xoQQ==
X-Gm-Message-State: AOAM531jtRKfa3/hVUKoVCO21zUAzcGLnilV7TSKNVCsK2KQtKGAj1rw
        oC+Ddep/z7OCnM3k+XvhoJceAyZ7J9GwtHP+WaI=
X-Google-Smtp-Source: ABdhPJxeXRyiSlooQK4CZ0BwYELn9wcNO6PMpKVr0ehAqhKnTARZVOCc3oCHuE2p+cWx+UVz2bWL8Vck7IoMJMq4LDY=
X-Received: by 2002:a19:a95:: with SMTP id 143mr109682lfk.174.1594835581993;
 Wed, 15 Jul 2020 10:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200713161739.3076283-1-yhs@fb.com> <20200713161742.3076597-1-yhs@fb.com>
 <20200713232545.mmocpqgqpiapcdvg@ast-mbp.dhcp.thefacebook.com> <2b641c41-fd6e-b1fa-4043-02b92776140e@fb.com>
In-Reply-To: <2b641c41-fd6e-b1fa-4043-02b92776140e@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jul 2020 10:52:50 -0700
Message-ID: <CAADnVQKYGF+KY5LTq-OAdWNmGc5dw1=BmftkP8n++pfEMyNWMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/13] bpf: support readonly buffer in verifier
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 10:48 AM Yonghong Song <yhs@fb.com> wrote:
>
> > PTR_TO_TP_BUFFER was a quick hack for tiny scratch area.
> > Here I think the verifier should be smart from the start. >
> > The next patch populates bpf_ctx_arg_aux with hardcoded 0 and 1.
> > imo that's too hacky. Helper definitions shouldn't be in business
> > of poking into such verifier internals.
>
> The reason I am using 0/1 so later on I can easily correlate
> which rdonly_buf access size corresponds to key or value. I guess
> I can have a verifier callback to given an ctx argument index to
> get the access size.

I see. Hardcoding key vs value in some way is necessary, of course.
Some #define for that with clear name would be good.
I was pointing out that 0/1 were used beyond that need.
