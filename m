Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24E734FD65
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhCaJpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbhCaJo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:44:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB0AC06175F;
        Wed, 31 Mar 2021 02:44:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l76so13810919pga.6;
        Wed, 31 Mar 2021 02:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSJos4Uld54OenplRvSKzdWrdWdUO1hcjvqzsTx68YE=;
        b=MdP4BRhTqIit2P3ZQtowMxJBDQc24KS+05aG0D6Pocc+N3CZlWJgco7d9Y939a3Mih
         Vxe+LDXQ4tAigBf1dPYug8FNom5ZDZo15DZkphkhEYmwaGEg+9gfgTs8gpLEvglP4DsI
         HLHEySd3h9xdQhb0Y8WiCWo2/JyLAEN8XJfu4EOaqESnFlNlDtOSQPPwoVNSwymHndkH
         jFeFwBkdAanBPKgR+JN7YkhcKNWW7XUvbC9KpoetkBmQldNIV5DhFcAIV2hD1n0+B+CA
         WGQAyiFX/nseIvOyPazF/OFMPgwGyKZL2A4q14Tn8PcjDOxAggH10MSfaBTPuI/e2GyB
         zoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSJos4Uld54OenplRvSKzdWrdWdUO1hcjvqzsTx68YE=;
        b=P0Wk4w3aYZ/3e74BE3uDS+9FmDefVwBMxsoDh2j3CglR5drXl1anKesDHvxB4ZSGnW
         wySASp1K5SFBuCWdWyKXocYah4zUbQFR/Qfzd94FXgAHbD6pktLp1rLuz3tBOpBLgF4U
         AMhcjBI84FuOGmXbm7ziJW9LgsYim+XrYRROyp8g1+yvCa8hQxmvFmqLn7GrwI4Km/w9
         LxmUCT3aY8I5JbGVRNxa6OLyfSwxx5vN46ZJpH5uQ4TyevJCahRh4CSpmHVeJiPyZxa1
         7EIe2i1Kqu7p1kA1DIBHo2Raxp4WCL98UOsFcAa0+3eE27NQ8nqn8B+H0EqrlbBaC91N
         mL9w==
X-Gm-Message-State: AOAM532SLTKLPykf3P9BNypjGhsqBfxpGzeNTJO611K1ssuqeGwaWT09
        ZqLpxBJ4xNmYG47alEkBlCBpM/jLKKl5mCulk+WqLoyyIiGR0vTC
X-Google-Smtp-Source: ABdhPJzBkNTdUIbhoLTRrIbmYcXaanIoCGFqfAPqOk+7kh55cnuAreoYPr/Lmdq/8WJblbN3WkLDSFRP94wvWjjTqYw=
X-Received: by 2002:a63:6fc1:: with SMTP id k184mr2550769pgc.292.1617183896059;
 Wed, 31 Mar 2021 02:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210330231528.546284-1-alobakin@pm.me>
In-Reply-To: <20210330231528.546284-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 31 Mar 2021 11:44:45 +0200
Message-ID: <CAJ8uoz2UNABjfpvHOopzvRfW4RJGSS2P=0MUZRkyg-e+S1OdHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 1:17 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This series is based on the exceptional generic zerocopy xmit logics
> initially introduced by Xuan Zhuo. It extends it the way that it
> could cover all the sane drivers, not only the ones that are capable
> of xmitting skbs with no linear space.
>
> The first patch is a random while-we-are-here improvement over
> full-copy path, and the second is the main course. See the individual
> commit messages for the details.
>
> The original (full-zerocopy) path is still here and still generally
> faster, but for now it seems like virtio_net will remain the only
> user of it, at least for a considerable period of time.
>
> Alexander Lobakin (2):
>   xsk: speed-up generic full-copy xmit
>   xsk: introduce generic almost-zerocopy xmit
>
>  net/xdp/xsk.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> --
> Well, this is untested. I currently don't have an access to my setup
> and is bound by moving to another country, but as I don't know for
> sure at the moment when I'll get back to work on the kernel next time,
> I found it worthy to publish this now -- if any further changes will
> be required when I already will be out-of-sight, maybe someone could
> carry on to make a another revision and so on (I'm still here for any
> questions, comments, reviews and improvements till the end of this
> week).
> But this *should* work with all the sane drivers. If a particular
> one won't handle this, it's likely ill.

Thanks Alexander. I will take your patches for a spin on a couple of
NICs and get back to you, though it will be next week due to holidays
where I am based.

> --
> 2.31.1
>
>
