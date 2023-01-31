Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB502683866
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjAaVLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjAaVLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:11:04 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9C53E70;
        Tue, 31 Jan 2023 13:11:03 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gr7so20907064ejb.5;
        Tue, 31 Jan 2023 13:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mZ+EfdGoneEgPdpzwa991bp+XLQi7R5BmAQzM+ojBhM=;
        b=b3T4Qclicuupe7pt2buXAQXzJQiuekMXFfFlKeaWTj6LqlDBWF0oqshDFKAYCKnoSf
         J90hg4LIaqs5uPiG9qnHxTOGLXaOpNvzjLRvXcKWrCq3XzKNic5cnR+g31clFP/90ktt
         emyPXZfO/bu0cmaBk/AxxsOxlwO630Fx+s3NH3+rPuTSnO9zyfvo3P4oKUJMFZXwhfYb
         E9HhMIog6Gi1nKBgHsLqKoiMjJSLW26BMtr3nsXOsIc2XlIHObbDL/CN0WfIpmMACqJQ
         b8iMGM3EK3WAX7J7pbn9ybLBtM+2Qu42qiHE3e7RVJsM2Flj4b0QDlaYGVEIGbZ4O/LI
         yJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZ+EfdGoneEgPdpzwa991bp+XLQi7R5BmAQzM+ojBhM=;
        b=xIEKNQpLC9JG6ksNLJ2nHt5inBeYe6U65SYRXSt9MloMwmjXVPns0BGYKcjJe/zdEX
         WZgGJh9xL9dGqNWrzCy/UPnWxaFNFbkOz3YnD0YATHu+mX3ENAF5aAt4WmbJcbjtGYWV
         HJifNKsmMGGUCBkCOgdDSgbaOjg0SHz9XIrjfGcZyTM5mB6Hur4w2UaJqjKafWhp/lSQ
         pJZ+AIipxs9IunWL4Q7FC4BRuilM/T+2W7V9MO2ipNcZr/fuJ6OkSA0bmJppyxPF9xie
         Z0PHl8JXZN7rYdZ/PjfdRwRAV7IAFoUgsle/3wq9CXvWVxjK2PEe3mpMOuszkL6tzKjD
         dIeQ==
X-Gm-Message-State: AFqh2krrnzKReJW6NXZmRDwKg4gGZh516TIFoB+43VPjWABMsHeCPTrd
        uuHHF9wMh58IeuBAHdADHSnlZEGReT2+ztIq4lLOEUH9
X-Google-Smtp-Source: AMrXdXtIiK2uDbrQWfFeTSFwHnPvVhv1FJ3p78bPbh6GTN5FGoPjS+ke7sjaQoZyStRGBGdcUQwyykSvMPGS+cKyTtI=
X-Received: by 2002:a17:906:7ac2:b0:86e:429b:6a20 with SMTP id
 k2-20020a1709067ac200b0086e429b6a20mr9169550ejo.247.1675199461331; Tue, 31
 Jan 2023 13:11:01 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <CAJnrk1Y9jf7PQ0sHF+hfW0TD+W8r3WzJCu-pJjT3zsZCGt343w@mail.gmail.com>
 <CAADnVQJ9Pb10boAR=ZVaXOJwjHPkFXKn9n9RWrzXgK3GaQ1N0g@mail.gmail.com> <CAJnrk1a2SY5NqhibczOhd+jqL3W9U1rbTeiQpYw-oUS8_Cr1_g@mail.gmail.com>
In-Reply-To: <CAJnrk1a2SY5NqhibczOhd+jqL3W9U1rbTeiQpYw-oUS8_Cr1_g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 31 Jan 2023 13:10:49 -0800
Message-ID: <CAADnVQ+N76ed0h9GJyQfVQiN2pmcqJdjeM5rOPdFv2LfZ9eahQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 12:48 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > p = bpf_dynptr_slice(dp, off, 16, buf);
> > > > if (p == NULL) {
> > > >    /* out of range */
> > > > } else {
> > > >    /* work with p directly */
> > > > }
> > > >
> > > > /* if we wrote something to p and it was copied to buffer, write it back */
> > > > if (p == buf) {
> > > >     bpf_dynptr_write(dp, buf, 16);
> > > > }
> > > >
> > > >
> > > > We'll just need to teach verifier to make sure that buf is at least 16
> > > > byte long.
> > >
> > > I'm confused what the benefit of passing in the buffer is. If it's to
> > > avoid the uncloning, this will still need to happen if the user writes
> > > back the data to the skb (which will be the majority of cases). If
> > > it's to avoid uncloning if the user only reads the data of a writable
> > > prog, then we could add logic in the verifier so that we don't pull
> > > the data in this case; the uncloning might still happen regardless if
> > > another part of the program does a direct write. If the benefit is to
> > > avoid needing to pull the data, then can't the user just use
> > > bpf_dynptr_read, which takes in a buffer?
> >
> > There is no unclone and there is no pull in xdp.
> > The main idea of this semantics of bpf_dynptr_slice is to make it
> > work the same way on skb and xdp for _read_ case.
> > Writes are going to be different between skb and xdp anyway.
> > In some rare cases the writes can be the same for skb and xdp
> > with this bpf_dynptr_slice + bpf_dynptr_write logic,
> > but that's a minor feature addition of the api.
>
> bpf_dynptr_read works the same way on skb and xdp. bpf_dynptr_read
> takes in a buffer as well, so what is the added benefit of
> bpf_dynptr_slice?

That it doesn't copy most of the time.
