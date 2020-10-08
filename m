Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03347287CE3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgJHUKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgJHUKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:10:54 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A9EC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 13:10:53 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t18so3315604plo.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PDZcffR2tzwj3aTCQ6MKazr5yV1RHW/jCgETqoYs/J0=;
        b=LqdL7Zc0Q80PnT1Ioz/oslZrYCRmoC+Euqsumc8b4+4VvJ2hOpgBDDQ5LjXFmTsu6P
         exs7J6ARq+cYJRq5mMXQpygZdvoCj6QyFmMHgHhKAvd7LzCgBImQVlOAsgny226tjW4d
         05UMoVyHsvUqyHF1lsTGUtRftK3R50hN23f3VApk+Xexz6xht7mU726KR3D/9Gr+JX52
         gqGh77k9ao96zcvfExRlFXGYoRoxrrL0q4t08/nOLgzN6Uw3gut5V3XQCuiEY9d/spRA
         rKTkkV2wfGPfmxyQgwSq7nZQTSlPvzVdAGRF9NzgEi396IFJ0zO3A2tNc+B+ZcwPUj5s
         RNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PDZcffR2tzwj3aTCQ6MKazr5yV1RHW/jCgETqoYs/J0=;
        b=YH31tvrbL+7KpK5PxW/EhCvTMTWLDtNsrBL31ZnW9u0zDZk+e9CAChb3rgcaTcvreI
         Lm/kaidN9Y6xe/9BBgWavZDWsgc2bjHPY52G4RUjdfey+3s6Fqsu5UyZU2xQWnFrAS5O
         8voaBhn7AAsRacs2YNlTYOj9QUrO+5yVZyuKsHToxLFMz3SS+yGoo0hxM2n5W4+N2AaH
         GS9LXFEnFjP7xqUVCblSjfKnt/+yWRHFDIeEpUZxa5JG6H7m2wfL4ra8jZHq+drT9ffU
         7GsBiplQlp6UIRQ8ZzXJs3nsG1k1NX05CupbFzFh/VeULmwcuaIf/+WvEhzkyEkzHLJN
         tomg==
X-Gm-Message-State: AOAM53057O82R+fGdeWZTjpdVb884VisMRSrllb5OO3KV03QDUtdg6DD
        O9iSPYgNvdYHcHZHZNGn2tsQ09NStjefYpGxJOA=
X-Google-Smtp-Source: ABdhPJximHFkhZE7D2aVYUzyxMCQcu4KP2aznZAAGcJC83R8HBKkTxBvb2jJ63mFQkRmV+XuXMM0IHnVMmM6TPvzI2g=
X-Received: by 2002:a17:902:c154:b029:d4:bb6f:6502 with SMTP id
 20-20020a170902c154b02900d4bb6f6502mr2377303plj.23.1602187853244; Thu, 08 Oct
 2020 13:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com> <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
In-Reply-To: <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Oct 2020 13:10:42 -0700
Message-ID: <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:20 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 3:17 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > However, there's something I don't understand in the GRE code. The
> > ipgre_header function only creates an IP header (20 bytes) + a GRE
> > base header (4 bytes), but pushes and returns "t->hlen +
> > sizeof(*iph)". What is t->hlen?
>
> GRE is variable length depending on flags:
>
>         tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);
>
>
> > It seems to me it is the sum of
> > t->tun_hlen and t->encap_hlen. What are these two?

OK. I understand that t->tun_hlen is the GRE header length. What is
t->encap_hlen?
