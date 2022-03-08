Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4165B4D1A4E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiCHOWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiCHOWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:22:44 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241594B413;
        Tue,  8 Mar 2022 06:21:48 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bi12so26484836ejb.3;
        Tue, 08 Mar 2022 06:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eiuLq9YhRrYN0FpJ7mTqNGyJkUH/vrr7SSWu39B1rkk=;
        b=DHPRtv8bf5XL0wSnjyq/223qiCx2+c0HD4LGpwpDw8yQYqAcbEFl1AUh9EDG4oUVX0
         FdBkiFBEyU++sUleXZPCAYnocTqhZkx+rT/2jCAnEMIBw7NgQ0lYxsleIODTOzOFTNM7
         0o8r10K0yVy9pMJUPI6F2/BUoEJN4kW9G4WEBF3ST1J/+lG0TinTXDXjR5xSwrZ4uhFr
         rf/c2M8oA2VAlued+b28tvqO+FQGY60kB5ZgbBfLTWeWkt4Wju39LlabLBVubH3TFuzl
         EI/wyZ840EeWv9ALhewWyGBOm1lvNZYehQ4u5EwN+UL0r/quBRRqapDUOwxSMn+ej00T
         FalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eiuLq9YhRrYN0FpJ7mTqNGyJkUH/vrr7SSWu39B1rkk=;
        b=lYP+eM3i9GQGgyRlZa5w+Kd1r3dCCmumy+OuAA+Tftuv4ohcKijWXsOPvhmG1hoGlU
         CRcZXBrQ7sECLvv3DGeSqh3kUOYU4KhGmuy1v4EYX15IUIK32GDQEbb0MNhBl73UTEao
         OGEgK5N/5R5GD6jAwXD2bMWt0iqUzeLVBOy5U2u24Bqg5QXPiNKgG3utba86B+/QYpAe
         4XNzF23waSGiLhpx71WTJWqjd0CaK/+dEPK8dk980Bvwv/9rFad8IxWRhInHB54RcxqK
         xFzOq3OPTYtWoo762VyTHyFOwF/ygEYcBQ6O2H0yjcND5fpO9UXgUBJv+ZeBP82ByCzz
         tJgg==
X-Gm-Message-State: AOAM530vc5bWgW2TcjCH3GlihIq0GCXQELr0FGEmyBo0W2sETZ2k0LOZ
        wgbtIkaOQDhGFkCEZu6dlLU=
X-Google-Smtp-Source: ABdhPJzSIpzp3q880unq3ypBGGnte9cfn22Luoe7SMZKsULuoMfoloIXXT6MbLLn+mfJEfI7MooDNQ==
X-Received: by 2002:a17:907:7b9e:b0:6db:2b7f:3024 with SMTP id ne30-20020a1709077b9e00b006db2b7f3024mr8522631ejc.29.1646749306525;
        Tue, 08 Mar 2022 06:21:46 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id m10-20020a056402510a00b00415eee901c0sm7018115edd.61.2022.03.08.06.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:21:46 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:21:43 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 02/10] bpf: Add multi kprobe link
Message-ID: <Yidmd3I2eHoZo/Wv@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-3-jolsa@kernel.org>
 <CAEf4BzadsmOTas7BdF-J+de7AqsoccY1o6e0pUBkRuWH+53DiQ@mail.gmail.com>
 <YiTvT0nyWLDvFya+@krava>
 <CAEf4BzaJoa=N4LgT55oraJkJtBds4BmKBCpJ1wmyqZCfjdo3Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaJoa=N4LgT55oraJkJtBds4BmKBCpJ1wmyqZCfjdo3Pw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 05:23:34PM -0800, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 9:28 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Mar 04, 2022 at 03:11:01PM -0800, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > +static int
> > > > +kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
> > > > +                         unsigned long *addrs)
> > > > +{
> > > > +       unsigned long addr, size;
> > > > +       const char **syms;
> > > > +       int err = -ENOMEM;
> > > > +       unsigned int i;
> > > > +       char *func;
> > > > +
> > > > +       size = cnt * sizeof(*syms);
> > > > +       syms = kvzalloc(size, GFP_KERNEL);
> > > > +       if (!syms)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> > > > +       if (!func)
> > > > +               goto error;
> > > > +
> > > > +       if (copy_from_user(syms, usyms, size)) {
> > > > +               err = -EFAULT;
> > > > +               goto error;
> > > > +       }
> > > > +
> > > > +       for (i = 0; i < cnt; i++) {
> > > > +               err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> > > > +               if (err == KSYM_NAME_LEN)
> > > > +                       err = -E2BIG;
> > > > +               if (err < 0)
> > > > +                       goto error;
> > > > +
> > > > +               err = -EINVAL;
> > > > +               if (func[0] == '\0')
> > > > +                       goto error;
> > >
> > > wouldn't empty string be handled by kallsyms_lookup_name?
> >
> > it would scan and compare all symbols with empty string,
> > so it's better to test for it
> 
> I don't mind, but it seems like kallsyms_lookup_name() should be made
> smarter than that instead, no?

true, I'll do that

jirka
