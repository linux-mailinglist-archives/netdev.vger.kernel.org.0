Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC63B2754C0
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgIWJsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgIWJsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:48:03 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FEC0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:48:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 185so24352085oie.11
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kp9DB3yJ7n4fOK/Le2BJ41nn7yEKAT/fFpyjwGbKsMI=;
        b=heQpS1w19H1RTHI6oZ7jzHtWgTjOZyjB+oHEUjaEO5MsegnRy6P9r4NBBf7M8gIuQj
         ZPazzp642YTXlXdvscMv+G+KCF7OOkrG4g+giPfgeGbgSDGZZSNMSuTJVLdQteUFKWNf
         nyBo9Yos1kscihElwDTU0Dof82hYkXY6o8l/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kp9DB3yJ7n4fOK/Le2BJ41nn7yEKAT/fFpyjwGbKsMI=;
        b=GiJsGURSMYLq7ChG5HRDlSX0rU+XwMDl8dySFg5NbXlGC3IPjEAme8uLhLlVGxlI3L
         /eHGI36Un1TfhZ8q3/uGYBK4Y+SDykR/tKCP+M3mEp3xQRLJE+2ASuZEoejIb1/LGiur
         GMUhEClS87IQH0qyVk6sZwDNQ1qCftR9yqSrbzw08awF7yprdfBABXOSncTCFpYScdHH
         uROsinefKAUAiQ+bgQravo4sbJqhSGaFAHsMI0HzsrGf63W3jyQcd6PT4KzFBLtVRpqh
         JZ7TkddUoukzdbz6dFwcdLITBQ0qZKVygXBr5ugUHi3RKkhFFaR7vM5By8mP1LlSl9L0
         7xkg==
X-Gm-Message-State: AOAM533vLmLL46obyDbF7Sxxmmc6Lu8wtvlKdkh+7ngVzZE1rnX2Cyg5
        2UwebZDpRTQVJP5N5eJJS/iXpEYpsxxhBM8MXKbxDg==
X-Google-Smtp-Source: ABdhPJw3YAbMdYlUq9nhIyxrwRkQ+KL7befsxSwMfEZS1z9eQAjO1pJpmRqQKw3b6kcjcfvpWgVgYMavizM1/C7F0fM=
X-Received: by 2002:aca:3087:: with SMTP id w129mr4959586oiw.102.1600854482691;
 Wed, 23 Sep 2020 02:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070415.1916194-1-kafai@fb.com>
 <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com> <20200922183805.l2fjw462hukiel4n@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200922183805.l2fjw462hukiel4n@kafai-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 23 Sep 2020 10:47:51 +0100
Message-ID: <CACAyw9_ZeCVTmF7XxTKEiK3aj47KaJ7Jb8JaTPTU2-XrXRutdw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 01/11] bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 at 19:38, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Sep 22, 2020 at 10:56:55AM +0100, Lorenz Bauer wrote:
> > On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > check_reg_type() checks whether a reg can be used as an arg of a
> > > func_proto.  For PTR_TO_BTF_ID, the check is actually not
> > > completely done until the reg->btf_id is pointing to a
> > > kernel struct that is acceptable by the func_proto.
> > >
> > > Thus, this patch moves the btf_id check into check_reg_type().
> > > The compatible_reg_types[] usage is localized in check_reg_type() now.
> > >
> > > The "if (!btf_id) verbose(...); " is also removed since it won't happen.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  kernel/bpf/verifier.c | 65 +++++++++++++++++++++++--------------------
> > >  1 file changed, 35 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 15ab889b0a3f..3ce61c412ea0 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -4028,20 +4028,29 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
> > >         [__BPF_ARG_TYPE_MAX]            = NULL,
> > >  };
> > >
> > > -static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> > > -                         const struct bpf_reg_types *compatible)
> > > +static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
> > > +                         enum bpf_arg_type arg_type,
> > > +                         const struct bpf_func_proto *fn)
> Yes. I think that works as good.
>
> An idea for the mid term, I think this map helper's arg override logic
> should belong to a new map_ops and this new map_ops can return the whole
> "fn" instead of overriding on an arg-by-arg base.

Yeah, agreed. I've had a similar idea, but no time to implement it yet.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
