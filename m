Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346BE2C3442
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgKXW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgKXW4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:56:01 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA8EC0613D6;
        Tue, 24 Nov 2020 14:56:00 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y10so228675ljc.7;
        Tue, 24 Nov 2020 14:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IaRJyPDA5/9B1ghHQFyB4uxgHg8PkkBWXKGuQGfKgrY=;
        b=G9VRwLKbulZFodDch1sh0/T9WnGdZ9tZwHP49t8XXsXFVdRXsKxo4UcmFIbTa231ox
         Gt6CTHWbfFwJoSVxpvybKclkOVQ8fBNMytvtEiwj9CT2O3Hy2xVMtEg8lFaugEDL0RPu
         YIyoXb3CZgGHyU08UWDgI0oLVyWSlEawDjO//3iE3xm8jjbc0gdAfz+dGOx8mnFQjQDp
         YnEXFReMA7fGJIJCCA/U/PPPkRTTDdi47LV+rs/GLKSUwl2Z4EfikXf0zpYimlbDP7uo
         j5GXXSyG8jRRHCZa2M4Vt1//KKZbae49z4kjRQfbz/VgTV16g9IEUkrC739rz3drpMl/
         t3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IaRJyPDA5/9B1ghHQFyB4uxgHg8PkkBWXKGuQGfKgrY=;
        b=YcL9m9YSTIkKDHJy3FWHXQNbmuc0uujF4is3ZFB/srQXvLhHGk2cTcZ6TcUGZGCKbx
         AWTR3sjzpTsMoNrm0GGcOnNKjPCDIID9V7aBOSjN35Zsno5ROzrZj0cVItVWAI87LCdL
         no/fx60RXR/rZGaujW3/4d8Skl5/91foKfjombrEWUCpgoT49am/e1qAPXbbTNoNd8uN
         BQHolgFBxisA5tjivRMR38wh5+ShcnPdy8KXl6sVap7KTvDC4Ab5NdaPrPQUBw5nVRio
         GxnkHOsrc0hNgmeMICobeAWUoXxVzq+sClBnKAN/fdX8nJs2rHUAGCL+NxXigFBmhI+5
         y3ZQ==
X-Gm-Message-State: AOAM533teAOO6k0PBo2F0pBsNwOHkc0f3XXFS+/FmFydS+fgxP6D6fL8
        9pooCUJFwjX2U9xdqz4cDE5Z2Yl/2WdHSk1eOoI=
X-Google-Smtp-Source: ABdhPJyMP1IETLXeWKd5cnTTU7R11xecNPej6rum8RjXC/wDFhspXzkC1ezEIUkaBzYhIRtn3MUurtCM8P442ScifRc=
X-Received: by 2002:a2e:9681:: with SMTP id q1mr218765lji.2.1606258558437;
 Tue, 24 Nov 2020 14:55:58 -0800 (PST)
MIME-Version: 1.0
References: <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net> <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net> <20201011082657.GB15225@wunner.de>
 <20201121185922.GA23266@salvia> <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
 <20201122110145.GB26512@salvia> <20201124033422.gvwhvsjmwt3b3irx@ast-mbp> <20201124073126.GA4856@wunner.de>
In-Reply-To: <20201124073126.GA4856@wunner.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Nov 2020 14:55:47 -0800
Message-ID: <CAADnVQKVgReNjf2gO1EKLX=tB7YaORQPG1SDWAv_Q_4S-mVsUw@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 11:31 PM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Mon, Nov 23, 2020 at 07:34:22PM -0800, Alexei Starovoitov wrote:
> > It's a missing hook for out-of-tree module. That's why it stinks so much.
>
> As I've said before, the motivation for these patches has pivoted away
> from the original use case (which was indeed an out-of-tree module by
> a company for which I no longer work):
>
> https://lore.kernel.org/netdev/20200905052403.GA10306@wunner.de/
>
> When first submitting this series I also posted a patch to use the nft
> egress hook from userspace for filtering and mangling.  It seems Zevenet
> is actively using that:
>
> https://lore.kernel.org/netdev/CAF90-Wi4W1U4FSYqyBTqe7sANbdO6=zgr-u+YY+X-gvNmOgc6A@mail.gmail.com/
>
>
> > So please consider augmenting your nft k8s solution with a tiny bit of bpf.
> > bpf can add a new helper to call into nf_hook_slow().
>
> The out-of-tree module had nothing to do with k8s, it was for industrial
> fieldbus communication.  But again, I no longer work for that company.
> We're talking about a hook that's used by userspace, not by an out-of-tree
> module.
>
>
> > If it was not driven by
> > out-of-tree kernel module I wouldn't have any problem with it.
>
> Good!  Thank you.  Let me update and repost the patches then.

That's not what I said.
