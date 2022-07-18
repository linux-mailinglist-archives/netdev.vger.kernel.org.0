Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67E1578677
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiGRPd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiGRPd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:33:56 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E985FEE;
        Mon, 18 Jul 2022 08:33:54 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso5968696wma.2;
        Mon, 18 Jul 2022 08:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vBxJcVDI+MBiYNM9PJpNBxYIwPjkJMaPy5JiLonNMLo=;
        b=iYon2gh8luEPcsrVrG8BU368mG1Xk+kpfwLOv21BTASSf/FolHFJHb4XxIYH5umRYa
         zr0UthJuQaLVhROiBEvlQktyIE7eYmbgro+yEjRd+6CZJSHlknFMCgBjXRmCUWOHBm/P
         9/DSNmN0/gHbMnAx7ETnBpEfMWD0QCnMSNxBCIty24/q4j0xaFUSh3yftS0/4g1n4h5d
         VubnTpp714okHPzwVlGSPQOygqV6ygMkaUNkO9GGnB9MeNOHEDk3GOzcCLsmQBZAfl2J
         X/DTwHmqA8CtjcT8u2HJD0mut8B97uGLsFVeMyhKlDub3iGCmBDp5epVGKipMnotXK/y
         DqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vBxJcVDI+MBiYNM9PJpNBxYIwPjkJMaPy5JiLonNMLo=;
        b=HdxspePG3GAm2gxAkOQ0TwmDGJfOmgvIfFBSHTV25Y7QKrIiTDuhpH1agPQLHJfkfj
         moh30icJ3m2pC8HPpxG9DdaGqVcCXLk1v1Xu04ObTF1QiD+YH4Wt15zLCAfmcqa/ip8q
         XWfGEymabk9MGtyceIGwX8YRw0c4QkC3uB1X7o+GZroFKWhU0FHrSOwA5UXZpzCcWHm6
         GIM6fJjCmv4etQ0c5hQj3zhMcN6VZCjkGV9Nl6YCYRuiKYFM0nQ2ehKT99VpTp9SIx/Z
         e4/YllupI4DFcLyr3wEfw3gndP5HOoRdpbka4lM5RmSWk5WPI+XWnnI9qQ1YeDAJwkTM
         Qtgg==
X-Gm-Message-State: AJIora+fcYBHuU6WxdTJVwRR0DwVCNkI+1aturI5peefx5pQeF3E1jU3
        nE+G61yt1kRkPuSgTWoDcqlTojBuw42ty3hF2qgtJnVO
X-Google-Smtp-Source: AGRyM1syWxjt15tB51xzmEK68Mm/SO0RQGXRyezFoFVwKyOltT3WigrGsVUUL7GkjaYGwvm2AhrvEvj95kRwd2wE9E8=
X-Received: by 2002:a05:600c:1c83:b0:3a3:1f70:25a5 with SMTP id
 k3-20020a05600c1c8300b003a31f7025a5mr2504212wms.54.1658158433376; Mon, 18 Jul
 2022 08:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
 <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com> <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
In-Reply-To: <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 18 Jul 2022 08:33:42 -0700
Message-ID: <CAKgT0Uejy66aFAdD+vMPYFtSu2BWRgTxBG0mO+BLayk3nNuQMw@mail.gmail.com>
Subject: Re: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Chen Lin <chen45464546@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 8:25 AM Maurizio Lombardi <mlombard@redhat.com> wro=
te:
>
> po 18. 7. 2022 v 16:40 odes=C3=ADlatel Chen Lin <chen45464546@163.com> na=
psal:
> >
> > But the original intention of page frag interface is indeed to allocate=
 memory
> > less than one page. It's not a good idea to  complicate the definition =
of
> > "page fragment".
>
> I see your point, I just don't think it makes much sense to break
> drivers here and there
> when a practically identical 2-lines patch can fix the memory corruption =
bug
> without changing a single line of code in the drivers.
>
> By the way, I will wait for the maintainers to decide on the matter.
>
> Maurizio

I'm good with this smaller approach. If it fails only under memory
pressure I am good with that. The issue with the stricter checking is
that it will add additional overhead that doesn't add much value to
the code.

Thanks,

- Alex
