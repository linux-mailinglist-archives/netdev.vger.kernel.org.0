Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF40648C5F
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 02:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLJB2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 20:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJB2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 20:28:14 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CDD3E0BD;
        Fri,  9 Dec 2022 17:28:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z92so5443876ede.1;
        Fri, 09 Dec 2022 17:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X+N9CA/m9fqtmBX/025t/1vBO4BTdHKMo/1JU+mFav4=;
        b=CytXyBiJvNUkvs3nNVIhlmROQY4r/wCSyZ9dHPUDGGATtN1iPS7Jd4rvR+i5E0xrbI
         k7ZXfejgU2HyE4sR4kZTIO79dt+pGxPLkfAcZKKsKiv0XzcazDuwyytc6KIvJNq8exd4
         qr5PaNan/I2TcfBfio2J4qpDjF/bBU3lVgUMImaDhkx1HHFYAGocMEMDOh/tlBG+3DNp
         fykG5rNT0UL+eU0mMAM4k16GFCZXM/h91BI5EQ3mnRitXDr3S8hxZAKuHfzw48ngSQ0N
         KxIs9e8JkFYnwNOq5lpEUy+gGg8VVazIeXXAfNUJMEHalLqzjBQTI2IXedQ6Nm1Trmkz
         9SvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+N9CA/m9fqtmBX/025t/1vBO4BTdHKMo/1JU+mFav4=;
        b=g7E2kiQrsIPrZcMsxASjGNplZBiztV0Bbw5TSn9+njTiWTkeVHQrzDksv50C5skJrk
         vP98Jqv0oi95tI1K18FXKEQeQJh8LAJLRYo1RjqxKEjCetlskQi0mWEsnBx9G8aAeHFJ
         QoGEE+maeNIIMIzURLD71dNS26n0jQ2VY72Qb/ZEeNOARK0+/j1J47wS1yHxVYojZWuw
         WEzFKLWDl3zlGfR/ekzbgDXtZ6zobgdzzTQb96AqXoMlOTKA+5qxY72A/yavQmPgmxhM
         ETllPWhgPtbDqg1sioRC+TmBsY8Xv2DK+2/2tYa7YAH+PLgNRv+IOEMd77qMq0BpiRaX
         lVfg==
X-Gm-Message-State: ANoB5pmloSbOFrqhiS/gUnHndIH3GXScI5jXY/tqC4l2jbRHAcPfHdXB
        hGtLnTqdZg36MgUbiiMRDDa1/lHo6uAfBgFb0EA=
X-Google-Smtp-Source: AA0mqf613nMQPGhYAYOJRZGXI88yKsZcYWcuVw6fk/od41TS4MRXXDnNZx7wdp5TJOSjoQvu/vGvUXvM1IkBY9UVIls=
X-Received: by 2002:a05:6402:142:b0:461:7fe6:9ea7 with SMTP id
 s2-20020a056402014200b004617fe69ea7mr4934177edu.94.1670635691257; Fri, 09 Dec
 2022 17:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20221208205639.1799257-1-kuba@kernel.org> <20221208210009.1799399-1-kuba@kernel.org>
 <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
 <20221209130001.0f90f7f8@kernel.org> <20221209140550.571e6b65@kernel.org>
In-Reply-To: <20221209140550.571e6b65@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 9 Dec 2022 17:27:59 -0800
Message-ID: <CAADnVQJmXAD3nC+TU7x2pL4tm07XupDDwf2thGcpfGSJ09u9+A@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.1 final / v6.1-rc9 (with the diff stat :S)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>
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

On Fri, Dec 9, 2022 at 2:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 9 Dec 2022 13:00:01 -0800 Jakub Kicinski wrote:
> > On Fri, 9 Dec 2022 10:25:09 -0800 Linus Torvalds wrote:
> > > > There is an outstanding regression in BPF / Peter's static calls stuff,
> > >
> > > Looks like it's not related to the static calls. Jiri says that
> > > reverting that static call change makes no difference, and currently
> > > suspects a RCU race instead:
> > >
> > >   https://lore.kernel.org/bpf/Y5M9P95l85oMHki9@krava/T/#t
> > >
> > > Hmm?
> >
> > Yes. I can't quickly grok how the static call changes impacted
> > the locking. I'll poke the BPF people to give us a sense of urgency.
> > IDK how likely it is to get hold of Peter Z..
>
> Adding Alexei et al. to the CC.
> What I understood from off-list comments is the issue is not
> a showstopper and synchronize_rcu_tasks() seems like a good fix.

Confirming. The bug is not a show stopper.
The nature of the bug still needs to be understood though.
