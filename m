Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D219A2AE527
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgKKAxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732209AbgKKAxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:53:52 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7694CC0613D4;
        Tue, 10 Nov 2020 16:53:52 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id s2so71391plr.9;
        Tue, 10 Nov 2020 16:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UGVZxWtplI1LKFEP/8Lld41IZAYJJ+5e2V/gW52DdHk=;
        b=VH7KERUn7tIP7PEK6mMPk9FS7Kem9K0PWNl+pIgA/QtndXr5Zyef6GPJU8NQ7zPppu
         8jCnI2JRoTjlijM2bQzm8CBU2uXlP1iArecPHYQ6z0REiih43j3AatHjo/KMTGrqKCI3
         Z0M6MN6jJCKYWor0xyxUwrrK/i54bqhHFvg4yIvG6En5VMiL76UexRrvcCLihftC7Zpp
         sDdjjB5gwmfs7z5umd7XWwA2UpXSpCSHyoIRsREZWlhXeu1MxznBge3DiRszKBteP1af
         3nPAUGTdcHGN2EZGgbQ1kymOXeqVJt6zy4EuTTx4DdztsvV38oiOPrn1hnfPaSMHRPaD
         6xgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UGVZxWtplI1LKFEP/8Lld41IZAYJJ+5e2V/gW52DdHk=;
        b=ChfvzashE2mfckCL22x7W297EySza6kB4LTLb2BKUMtHzPQQ9cELyXrgn+MZuK2QeH
         mUNgG+DZcHIoFiy0CCMjEPtRcBlMNCFmUd9Es/N/YWbMltpZ6ZWy0cEfwEsa3NwEtoK+
         /H8Q6EVdh6VUksyV5ewa2WQisw+Uy7UVdiNx6WS12wCl9KUhleEnxmhu423CGuFqSGRy
         wEUbaSfxI8k3RNVqblG6hjQn5Nftebvnvvn8VIhtOxqNdujxAolEhS1WJOuAnRuOWpAT
         TUYC3NDGEQ+lGo9O7BrpFlCd/RwRtUu5ytptVdE9lP6FopQDaLJxPwm8oP0SjzvmbxYd
         TXLw==
X-Gm-Message-State: AOAM530VJ+WW5FC5odXbP5p4xar78gDgayB/qOtFpglLhvMcn57i+avl
        LhtUBRRaLKhY5WIJ5nUzdQs=
X-Google-Smtp-Source: ABdhPJya4gAZatOtyuzaT1hSgZNTf5zvhCXK2o4SD8ZlI+yX3wgu5KfyTeXHrTZ6E7ExlVms/EQqjQ==
X-Received: by 2002:a17:902:d901:b029:d6:9796:514e with SMTP id c1-20020a170902d901b02900d69796514emr15454123plz.84.1605056031882;
        Tue, 10 Nov 2020 16:53:51 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:8fc0])
        by smtp.gmail.com with ESMTPSA id gp22sm193181pjb.31.2020.11.10.16.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 16:53:51 -0800 (PST)
Date:   Tue, 10 Nov 2020 16:53:48 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <haliu@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201111005348.v3dtugzstf6ofnqi@ast-mbp>
References: <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
 <11c18a26-72af-2e0d-a411-3148cfbc91be@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11c18a26-72af-2e0d-a411-3148cfbc91be@solarflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 12:47:28PM +0000, Edward Cree wrote:
> On 05/11/2020 14:05, Jamal Hadi Salim wrote:
> > On 2020-11-04 10:19 p.m., David Ahern wrote:
> >
> > [..]
> >> Similarly, it is not realistic or user friendly to *require* general
> >> Linux users to constantly chase latest versions of llvm, clang, dwarves,
> >> bcc, bpftool, libbpf, (I am sure I am missing more)
> >
> > 2cents feedback from a dabbler in ebpf on user experience:
> >
> > What David described above *has held me back*.
> If we're doing 2¢... I gave up on trying to keep ebpf_asmabreast
>  of all the latest BPF and BTF features quite some time ago, since
>  there was rarely any documentation and the specifications for BPF
>  elves were basically "whatever latest clang does".
> The bpf developers seem to have taken the position that since
>  they're in control of clang, libbpf and the kernel, they can make
>  their changes across all three and not bother with the specs that
>  would allow other toolchains to interoperate.  As a result of
>  which, that belief has now become true — while ebpf_asm will
>  still work for what it always did (simple XDP programs), it is
>  unlikely ever to gain CO-RE support so is no longer a live
>  alternative to clang for BPF in general.
> Of course the bpf developers are well within their rights to not
>  care about that.  But I think it illustrates why having to
>  interoperate with systems outside their control and mix-and-match
>  versioning of various components provides external discipline that
>  is sorely needed if the BPF ecosystem is to remain healthy.

I think thriving public bpf projects, startups and established companies
that are obviously outside of control of few people that argue here
would disagree with your assessment.
