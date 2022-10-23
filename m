Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7C6090AA
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 03:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJWBTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 21:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJWBTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 21:19:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4077C1F8;
        Sat, 22 Oct 2022 18:19:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a67so19163199edf.12;
        Sat, 22 Oct 2022 18:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RoTU0umGQVEZvhAClaxNh7Mk1tT8X/VlHXj38H74iSI=;
        b=VC9et0qMuGTPQ4IflUlCn5HUN9nPdCTCy01doLtRhBpN3C6lTOZDKFMemaH2jLGyqd
         w4emN5KnPePivXoymosyP41Oc+MtGPR1Fwlx0EHkCPGfITG0KSvq39F5maKYJKVdVA/R
         zd0vfjIyks8k7B7ECVQOirM+8xyYymgs8YzruoJ7LHKE8FDJCsxKq3Elk5/oN43xrvNP
         cCR6K/aggDvSnORrIa7sFvWNrauQR9Y+hglhUo8X5VGC8qxzFmavQIecY/2zxZWKxh4v
         0bNhJyOvn2OVsxuRllNpJTs3FjI86nPPMccdM3JjPDM2iIQLXc7A5QOcQ6OWwI+knCdD
         8jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RoTU0umGQVEZvhAClaxNh7Mk1tT8X/VlHXj38H74iSI=;
        b=2HLsxOkHXIzfe6l9U7qnrJzx8YHcpRDS06g16STfD9pT/3SSJZ1i6xPuY0Bcz+ilNn
         k3WLuY/PCIh5oIqvh78t3o20tFgVAfW06B7uICXLDSiwBzo+cYaPYxxQcVqNGfH7XCbg
         3Ic1tqjDnStcAmt8d0NQP6X55GU9ggC5W9R83MLMHD8JPZTf/F8gQiXB3pCjW4H0NVa+
         N+v4sIL5en1MHo6Q1wj7B5CGZpGVAdyRgnwFW3Vn1cd34LoZ05ZpUh7Cud3hdbXOpdO7
         uEyMOJiZH2a0di1tLqEQHpShNc4aLG5Z3+MaFmpsK6/XEpbWqWoTqbZd6P8J46t6xdV6
         Jvlg==
X-Gm-Message-State: ACrzQf3qathhJabLChU2O8wh5cFzyTZZE/YIJBHJeCcMnBmOOGxTp0bU
        nOpkOfHkBA/E+Vs29zhVdGECEVr3/L3snOWQxHM=
X-Google-Smtp-Source: AMsMyM6LJKt5F9wxw/SiSYElodduNKYvIxrmHZ05o2BoMzJiOhAbDl+8j7cnTgVLRf6q7h9BXlub/MOIeEzG/3kM64M=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr22119631ejb.633.1666487940665; Sat, 22
 Oct 2022 18:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221004072522.319cd826@kernel.org> <Yz1SSlzZQhVtl1oS@krava>
 <20221005084442.48cb27f1@kernel.org> <20221005091801.38cc8732@kernel.org>
 <Yz3kHX4hh8soRjGE@krava> <20221013080517.621b8d83@kernel.org>
 <Y0iNVwxTJmrddRuv@krava> <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
 <Y0kF/radV0cg4JYk@krava> <CAEf4BzZm2ViaHKiR+4pmWj6yzcPy23q-g_e+cJ90sXuDzkLmSw@mail.gmail.com>
 <Y1MQVbq2rjH/zPi2@krava> <20221021223612.42ba3122@kernel.org>
In-Reply-To: <20221021223612.42ba3122@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 22 Oct 2022 18:18:49 -0700
Message-ID: <CAADnVQKUSfGUM5WBsbAN00rDO9hKHnMFdEin7MbW4an03W3jGg@mail.gmail.com>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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

On Fri, Oct 21, 2022 at 10:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 21 Oct 2022 23:34:13 +0200 Jiri Olsa wrote:
> > > You are right, they should be identical once PTR is deduplicated
> > > properly. Sorry, was too quick to jump to conclusions. I was thinking
> > > about situations explained by Alan.
> > >
> > > So, is this still an issue or this was fixed by [0]?
> > >
> > >   [0] https://lore.kernel.org/bpf/1666364523-9648-1-git-send-email-alan.maguire@oracle.com/
> >
> > yes, it seems to be fixed by that
> >
> > Jakub,
> > could you check with pahole fix [1]?
>
> If you mean the warning from the subject then those do seem to be gone.
> But if I'm completely honest I don't remember how I triggered them in
> the first place :S There weren't there on every build for me.
>
> The objtool warning is still here:
>
> $ make PAHOLE=~/pahole O=build_allmodconfig/ -j 60 >/tmp/stdout 2>/tmp/stderr; \
>     cat /tmp/stderr
>
> vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0

The effect of the compiler bug was addressed by this fix:
https://lore.kernel.org/all/20221018075934.574415-1-jolsa@kernel.org/

It's in the bpf tree, but the warning will stay.
While the compiler is broken the objtool should keep complaining.
