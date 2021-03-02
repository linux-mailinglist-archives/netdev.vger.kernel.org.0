Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F48B32B3A5
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449871AbhCCEEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580263AbhCBSBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:01:49 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6F2C061226;
        Tue,  2 Mar 2021 09:59:34 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p21so14336535pgl.12;
        Tue, 02 Mar 2021 09:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTbTJoWM2Ti8wB3Yd2g29WD4PXDki7GTC9QKAy0vUio=;
        b=cP3BqPzQcefPfNMnKQbmorYbMnFu1o0MTUfmK+lWBL9D2saTF4BEcVk1VSLtUlOFTw
         qFfioBBwOJWVzKUtKSdr/QNFG9rP3CSpP9zCLwX5mqnIRZd5XeElkShgd5Lrmfy/Hs2G
         OwCaKmVpMg8Ui88ZR0n9thmIibBOfVDt8rgwHYwy0WevljwLDH7FYrDG8ZiYRDuf8v1D
         entL1bNte0XSwqsby+Uy7fW2ymA7fLf2OYEKMV0Tt82ayN5PlurRXWj0buso5GHADfKZ
         +ydaEgQD5MFqZJO4B3DP/BK5/WDfzOWc6K844R7/fWE5L4+C/iLAe8FvqhYkwDhvYFzp
         0i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTbTJoWM2Ti8wB3Yd2g29WD4PXDki7GTC9QKAy0vUio=;
        b=oxZgJZTJliSxS1ha2vJ7HQmW7o30VSPhivMURtwdLfvP1BCD757cvDNRhSjcVUh6t1
         uybOOkhhtim/ukY0f58286Ocjph6sakl07v+ibEfyVsfyRP8J8ZGT+DxTrJRiPXPe44t
         vZVEaM7BoqeseIwau27rqBCS8y9pyj2HJVPNUduI1oq+09YJEe15O58QLiDpBvaJyPQq
         OwVo57c0Lbg9o047W0oArVmZ5HeO9KvlWuo4+isEBJlgv/9nuNlhYmamwtRReGzjFVf8
         q8dIJCFLjEuBouIAwrMsCClitPXjwWn3dMhO0CThcPxSA3mVQHUnVyifOmyMF/0j1bxM
         fQbQ==
X-Gm-Message-State: AOAM533XCA6OO0yxcA8Pz5LR2yPlMsVEtBAHW0sycnFD3u4oI+qyuIRF
        QUiLEXRH13kRhkrcjRV9Zj2tq6yebam6THrmlec=
X-Google-Smtp-Source: ABdhPJyiuPICnbWEF/BGMykjsHKV0EP/3krrDCtoXpBTgfQ5SVT9PEVfc7PrIJ0TjJM4dD4zd94B46V7RpTgk4KyRUk=
X-Received: by 2002:a63:e109:: with SMTP id z9mr19036348pgh.5.1614707974520;
 Tue, 02 Mar 2021 09:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-6-xiyou.wangcong@gmail.com> <CACAyw98C99sjOompq59Aa-uuaeyJc0pXAEBiBCVJ+1Ds4_h=jA@mail.gmail.com>
In-Reply-To: <CACAyw98C99sjOompq59Aa-uuaeyJc0pXAEBiBCVJ+1Ds4_h=jA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 2 Mar 2021 09:59:23 -0800
Message-ID: <CAM_iQpUFB8ecD5XpDbtqb1SEn82u0_CvV5tQ5YnOKijvbpFptQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 5/9] udp: add ->read_sock() and
 ->sendmsg_locked() to ipv6
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 8:23 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 2 Mar 2021 at 02:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 54f24b1d4f65..717c543aaec3 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1831,6 +1831,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >
> >         return copied;
> >  }
> > +EXPORT_SYMBOL(udp_read_sock);
>
> Should this be in the previous commit?

No, exporting this symbol is unnecessary until a module starts to
use it, which is IPv6 module in this patch. So, it is perfectly fine to
export it here.

Thanks.
