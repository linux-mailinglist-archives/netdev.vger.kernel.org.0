Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9736D05B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhD1BnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhD1BnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:43:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC2FC061574;
        Tue, 27 Apr 2021 18:42:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c17so8010712pfn.6;
        Tue, 27 Apr 2021 18:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MS5x3+ZEtIskpim4Vzfxk1Jz976cepvfOa6Z0/YRg+Y=;
        b=sk9HDGQk/90rHZgNpFCG/IU2pgH3i6WO6p/TUEo/E+esFTyzd6oAnYbAwLMZu2S9iI
         FtRtT1d6wpL5vJIoMTsvZ73P3eyVR+2j6g10q5HVhyMAEZ7wufFLCSdOOlF6+jIlOvgZ
         /uLAqrT2CgjRVgZf/Se5ym1tCKnrtpaS1RR+IZkvhjnv4AyXZA+nPXQWXkdLJgXrER52
         T9IznXYPzoQe5KogOjeV+UKKtQpFJtJ3bvohAMlujtDjljcZ82xY4bIcwTf8KcINOiG+
         ac1YVYUmb2MCOv94jBCjZPR3yH51tJZW2M16cRBF3rWjK9wCGeSY/eaEyHlOcLec6HJC
         c95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MS5x3+ZEtIskpim4Vzfxk1Jz976cepvfOa6Z0/YRg+Y=;
        b=bWcXNQF5BuoucEOlPOODjXW2YO9C/4tFiSG780RpMNXA/+bxRiu2xF4MZ9Pb4PHn6O
         NxIEwIkWECdikfon4eJbilB4OAMJX8tEk3cDaxGPSGR4UOdQY3RV/pOLnmgpBe3RXlEA
         t7sgUhq8sBzQdrOBHeGNEtr5vB/HVWRKCKayep3zDwldtMQvxPb5NgTbhfksugj5JSqI
         hv4UijNtGbzZTcocQ8Rc2CzXR3T4AEm7Q/GAdDV2HqZdsJhGNIOEIXEHsmkvSDNW7Gxa
         yhO6OTuS1TBB1gIv/FDsaidOHLBdeycLp+qdQ+a215DPOXelrP6b87LdA4ZkzM379KkN
         JjhQ==
X-Gm-Message-State: AOAM530iTFSm4gErMhzh1vab8b93Ya7i2cj4j2ZRtzuzYmJiInRIu6vs
        synC4PKnqxQWTHokr5ecq0E=
X-Google-Smtp-Source: ABdhPJw8IQ6/+2geCtoJ95tZje/orU0jat8a13ZimyT8MNpvfc+54YmTa3uEVEAwbUVUGA1SRofcFA==
X-Received: by 2002:a63:ea04:: with SMTP id c4mr24068346pgi.243.1619574144725;
        Tue, 27 Apr 2021 18:42:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2e71])
        by smtp.gmail.com with ESMTPSA id in1sm3164748pjb.23.2021.04.27.18.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 18:42:24 -0700 (PDT)
Date:   Tue, 27 Apr 2021 18:42:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 14/16] libbpf: Generate loader program out of
 BPF ELF file.
Message-ID: <20210428014222.7m5ndlmtbn4msj7y@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-15-alexei.starovoitov@gmail.com>
 <CAEf4BzaQb=_aOL26syfsUWA9ewi6xOC1frzP27cOWz=_5Cz1iA@mail.gmail.com>
 <20210427032504.z7wvdgai3fxvk7fw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzar2hyghkV-HFfPgUDJs9EjsS2v0iDCGEd+M2s7wO+b5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzar2hyghkV-HFfPgUDJs9EjsS2v0iDCGEd+M2s7wO+b5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 10:34:50AM -0700, Andrii Nakryiko wrote:
> > > > +void bpf_gen__load_btf(struct bpf_gen *gen, const void *btf_raw_data, __u32 btf_raw_size)
> > > > +{
> > > > +       union bpf_attr attr = {};
> > >
> > > here and below: memset(0)?
> >
> > that's unnecessary. there is no backward/forward compat issue here.
> > and bpf_attr doesn't have gaps inside.
> 
> systemd definitely had a problem with non-zero padding with such usage
> of bpf_attr recently, but I don't remember which command specifically.
> Is there any downside to making sure that this will keep working for
> later bpf_attr changes regardless of whether there are gaps or not?

I'd like to avoid cargo culting memset where it's not needed,
but thinking more about it...
I'll switch to memset(, cmd_specific_attr_size) instead.
I wanted to do this optimization forever in the rest of libbpf.
That would be a starting place.
Eventually when bpf.c will migrate into bpf.h I will convert it to
memset(, attr_size) too.
The bpf_attr is too big to do full zeroing.
Loader gen already taking advantage of that with partial bpf_attr for everything.

> > unfortunately there are various piece of the code that check <0
> > means not init.
> > I can try to fix them all, but it felt unncessary complex vs screwing up stdin.
> > It's bpftool's stdin, but you're right that it's not pretty.
> > I can probably use special very large FD number and check for it.
> > Still cleaner than fixing all checks.
> 
> Maybe after generation go over each prog/map/BTF and reset their FDs
> to -1 if gen_loader is used? Or I guess we can just sprinkle
> 
> if (!obj->gen_loader)
>     close(fd);
> 
> in the right places. Not great from code readability, but at least
> won't have spurious close()s.

Interesting ideas. I haven't thought about reseting back to -1.
Will do and address the rest of comments too.
