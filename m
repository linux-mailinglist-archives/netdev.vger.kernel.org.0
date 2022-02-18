Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715654BB9CF
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 14:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiBRNGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 08:06:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiBRNFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 08:05:53 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B92B4620
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:05:37 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2d625082ae2so65567017b3.1
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=93CVqQreNey4UxGTD3l51x3Bbik2BD7CmQHLf6XaIHw=;
        b=SehDqi+GFuUda/fggyakKXC3GucwEVDzfyQ+XB9SegLzhnRdrEK7aOvlk06jwkzCsS
         aNaSLYT+u+8pGDTa6UjxHl1z8UdBLaj0G/HWoaslLDhTyhLJg9cGPFP+Y6it77yj34pM
         tFCzlWkyBqHljmskcdiiY81P7bZ5VzAUc2D5oDJkUhlSsNIDaEDZqmc6HVSKvgvsGWwa
         nEx03mCYzfg4NNLI/TK2UKoqYUJ/BWOdpZ4uoww3tVdfX3l5hbuamJYD5Ic9lKdNcPPA
         6yHpMj89muImtCYlQ/NSY24a+GuI562an7j8znatM/94Eb4hg1AvJQIlfSgm/3qAqJid
         zvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=93CVqQreNey4UxGTD3l51x3Bbik2BD7CmQHLf6XaIHw=;
        b=zatolq9MpH+kISUqa9/Bobt4Z4YV8mczfmsWx1Nf0+XaSEvapbPAPnfohV2K5glVI8
         oZ4oBnnMHYhsGGDArV6bPUF98jmchzKPdEUcpeEqpdCB8wdNlnsPDZbtnla1FOsHFmMU
         x0x2g2sQc/sleDp3e9GzUXlHgiHmcaiCOvmlCgKMPm04Z26f3v52GhkZC2eD673g85tO
         l/i5/MS0PgR3yOaYd6NBwZidvfD+5zyPyJkhc3KR09XV9LLdA0kPHlcSf0hLao7jUtjH
         1Jja59t7EhDk3mEw+XB+jRIMCho5q2Jg6VdPC7IKe13MLMP+D5bGA0GGWqLS+WNwGoEO
         Lrcg==
X-Gm-Message-State: AOAM5315VPE1CdGxLlWg1Xv/St4SE8skdDjtocdQtEyOBCZJlW+vSuXp
        rqXG3vLHnvo8Nj5ZUm76NWFtHxyJEahbktf12WP2DQ==
X-Google-Smtp-Source: ABdhPJzQYHdum9Us26v+wAaJ5eNXNrTZvi6ppwsd2WRgDYD9Vt2zVCDpVIbdO7xcL4XMVutgalQNlOxbsGcJqi6X7k0=
X-Received: by 2002:a81:1516:0:b0:2d0:e7ca:2a5 with SMTP id
 22-20020a811516000000b002d0e7ca02a5mr7291377ywv.55.1645189536473; Fri, 18 Feb
 2022 05:05:36 -0800 (PST)
MIME-Version: 1.0
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-6-andrzej.hajda@intel.com> <CANn89i+nCZ6LV_1E2OnJ4qWE0XkO2FGW+A6_tkmQpdxiiEh=LQ@mail.gmail.com>
 <8f6fb098-d0d9-910e-7d42-9fbc541f9891@intel.com>
In-Reply-To: <8f6fb098-d0d9-910e-7d42-9fbc541f9891@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Feb 2022 05:05:25 -0800
Message-ID: <CANn89iLHd+Y=7xqx0OqfHXmqnUhhRycTARGfgq-y79Xhy5OQew@mail.gmail.com>
Subject: Re: [PATCH 5/9] lib/ref_tracker: improve allocation flags
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev <netdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 2:28 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
> > git log --oneline 5740d0689096..4d449bdc5b26 --no-merges -- lib/ref_tracker.c
> > c2d1e3df4af59261777b39c2e47476acd4d1cbeb ref_tracker: remove
> > filter_irq_stacks() call
> > 8fd5522f44dcd7f05454ddc4f16d0f821b676cd9 ref_tracker: add a count of
> > untracked references
> > e3ececfe668facd87d920b608349a32607060e66 ref_tracker: implement
> > use-after-free detection
>
>
> So I will cherry-pick these patches into next version of patchset, with
> "NO MERGE" annotation (to allow testing), and if my ref_track patches
> will be accepted then they can go via net-dev tree and intel patches
> will wait till update of drm-tip.
> Is this scenario OK?

One possibility would be to split your patch series in two, to merge
the ref_tracker changes directly in net-next asap.

But I have no strong opinion, maybe Jakub/David have some guidance.
