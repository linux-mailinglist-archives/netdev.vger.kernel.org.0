Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804D74C1DEB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiBWVrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbiBWVre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:47:34 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A828647068;
        Wed, 23 Feb 2022 13:47:05 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z16so119500pfh.3;
        Wed, 23 Feb 2022 13:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2lATso70eG3960V6J5MpLozbEFA6AKGlwdDi3d4QWVI=;
        b=oypADOMGbjhqN+O1rKyaiAI1Hb27EgBU6MaJ2HX1kE9LbbH8GQgXjyjUviKib6xwzK
         6mO8Uysvffjgq+qjuuv0PkmYTPTzgOf295suMpe3BDSyRAJu01XRc+eqxjmSqX6Qgdl9
         usChEAbEFF076j13N3mgoJghycQ37R9ZGP2SLfMt34Pa8JuTV5TUZSKHlYJkM5bmgZvr
         f+yfpC9urJWo156DqsWeDoH7ruhfToxmxsRcJR3uZ8PgSxhGCj6J49odSuWXVJoZayhA
         v4OJzhmAv6p2E978ls90IAN5rb20x6fhkDlhkzs7FNNHQXmnSWyYhwBtV80L6z0stb2m
         7uFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2lATso70eG3960V6J5MpLozbEFA6AKGlwdDi3d4QWVI=;
        b=605leE4H6z1BCwEOIjwt5Xns+YXSFNTw1n1Yb3ecZnm8pJYI+UsLE34bORV8biG6vr
         HMOZ71PV+SFk/mW39StEec69mD188x+Pl9RCA97Nt9UYpbCQ6mZ3xjbF00lvjnu52M1b
         Jyvh7shzCJEri+I5CRcFnumLIqD0UjGJZGAfqAk1XLz+u1YqkF11fTVk5yODFd56oDGe
         iCRCZ0A+ACbSav/GYumKTM5WLcNotfEq2+HzwU5SEX3Us17wCTpzLZy4EEK48915B2Vh
         GVc0z6RiMnpKQ3JBFAjFS6i2npOCeQvigUjJhGv6tuxiHryNI6YLcxMM7CJM2zIgLuew
         gyZA==
X-Gm-Message-State: AOAM530fW8aTNehdqQA/bPCZaqklwQatCH1ZdGkjw/k1ymBoelHjHZ9J
        zgm0NeE2BdEm2APaF7SBeOzZU1Z2o6s6iIpuz/1HNy+Z
X-Google-Smtp-Source: ABdhPJyEAA1y6b6besauwUO5STvtvzRJWpfWkWiEX3an9FEdB1DaYdbo5PPj9Y4Pd/Ih1utVKuLdnHYMcr/GM4zQOi8=
X-Received: by 2002:a63:e657:0:b0:34b:e1da:c2c with SMTP id
 p23-20020a63e657000000b0034be1da0c2cmr1202370pgj.543.1645652825197; Wed, 23
 Feb 2022 13:47:05 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com> <20220220134813.3411982-4-memxor@gmail.com>
 <20220222064619.hsadxbwzeg3go6jb@ast-mbp.dhcp.thefacebook.com> <20220223030925.uxevhkloz7dznkal@apollo.legion>
In-Reply-To: <20220223030925.uxevhkloz7dznkal@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Feb 2022 13:46:54 -0800
Message-ID: <CAADnVQLdLmD1BUfDozvFs4YiTD=4aN43iJdn4TZ9hB7SBM-bAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 03/15] bpf: Allow storing PTR_TO_BTF_ID in map
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 7:09 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
> > > +                   }
> > > +                   btf_id_tag = true;
> > > +           } else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
> > > +                      sizeof("kernel.") - 1)) {
> > > +                   /* TODO: Should we reject these when loading BTF? */
> > > +                   /* Unavailable tag in reserved tag namespace */
> >
> > I don't think we need to reserve the tag space.
> > There is little risk to break progs with future tags.
> > I would just drop this 'if'.
> >
>
> Fine with dropping, but what is the expected behavior when userspace has set a
> tag in map value BTF that we give some meaning in the kernel later?

All of these features fall into the unstable category.
kfuncs can disappear. kernel data structs can get renamed.
dtor, kptr_get functions not only can change, but can be removed.
When bpf progs are so tightly interacting with the kernel they
have to change and adjust.
Eventually we might bolt a bit of CO-RE like logic to kfunc and kptr
to make things more portable, but it's too early to reserve a btf_tag prefix.
Progs will change. We're not saving users any headache with reservation.
Tracing bpf progs are not user space. That's the key.
