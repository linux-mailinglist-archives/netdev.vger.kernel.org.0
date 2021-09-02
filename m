Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39073FF4EE
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbhIBUbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhIBUbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:31:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2EEC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 13:30:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l6so4775113edb.7
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 13:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfhZSvcl10C5+8fiIHi5Jyp6UrZPVkc5bQgcIMkCCGw=;
        b=WweXf7JycQyADeYg1N1Iu3bXu3ttpUdsgn+YBVH3Wc9YFC9MKQJEXC6dSFrZ811Ng/
         F22VIcvPImmz3OqHjRxsCnoMhn1JL1SG6y253mW5hmtruaMCveSknQ0bUwBg73I2HPZx
         fHY5r0YrS+TZ+2EVAzTnh/xmB1lDh+uL+x4ZzEtaOsD0G1bj8wsMUGY8sxHqsOjYm+LS
         /X4zq8SHDClDzZ6y/Bu4HmOIF0bZlqarb5Vfk2HYW/FH2z68tegEJNABgk0ermbrz6+n
         Zn0svD/CuPJSlajL6fPSKsLXagFk0Sl43pWLib2/zIHMyBlQYV+vj/ufRoFCfFoUPRA0
         wB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfhZSvcl10C5+8fiIHi5Jyp6UrZPVkc5bQgcIMkCCGw=;
        b=pDd9pkb5mezwdMIqftK+S0BtX0RNbwD4/r9ESiMaIGkHhnw0DWg8JZav0mBO/zmQQK
         7+e29epgcJlrb8tWbW8Zz+oYinXyF/2j8NaFQSXaH5lGkAaTPAxuQDkRyqVABvkY1oqS
         V7Av2woNwrs79AjXviZjoCg/D7593FoeFDM9TuBJNWg0fzc91UmsBuHA6fJE+Bem8dcW
         l5lEWBUA8Hv6SC2qT/otJiwDRTzIp/WU9L+o2duf7z4Hbt43/ePzLVuoPZQN9EZstkNg
         +Iy32ESt+l1nrz09bUr9dYa0HV8IQPBO1aPzhvQ2TfQSvPw9nhagFWMKRAH1eAXA3P2D
         elVQ==
X-Gm-Message-State: AOAM532YALmnyj6VoBJldH1X4OC7a+m2bSTfbbzTpLtiT90IPBWlPMYZ
        AVdfJrNFFkZl0k66mBpROn0tqxnVgThkKw==
X-Google-Smtp-Source: ABdhPJx0aCIQLjyvUdecwhKvNMpwAK2s/00N9nC+CnJFC2Fhk9bALFEIZLe27SjsNbOU5FPEGhaCGg==
X-Received: by 2002:a50:fb08:: with SMTP id d8mr194380edq.160.1630614602040;
        Thu, 02 Sep 2021 13:30:02 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id cf11sm1803483edb.65.2021.09.02.13.30.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 13:30:01 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id g135so2117559wme.5
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 13:30:01 -0700 (PDT)
X-Received: by 2002:a7b:c351:: with SMTP id l17mr28900wmj.120.1630614600776;
 Thu, 02 Sep 2021 13:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
In-Reply-To: <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 2 Sep 2021 16:29:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
Message-ID: <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 4:25 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Only test integrity of csum_start if checksum offload is configured.
> >
> > With checksum offload and GRE tunnel checksum, gre_build_header will
> > cheaply build the GRE checksum using local checksum offload. This
> > depends on inner packet csum offload, and thus that csum_start points
> > behind GRE. But validate this condition only with checksum offload.
> >
> > Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> > Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  net/ipv4/ip_gre.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index 177d26d8fb9c..09311992a617 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
> >
> >  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
> >  {
> > -       if (csum && skb_checksum_start(skb) < skb->data)
> > +       /* Local checksum offload requires csum offload of the inner packet */
> > +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> > +           skb_checksum_start(skb) < skb->data)
> >                 return -EINVAL;
> > +
> >         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
> >  }

Thanks for taking a look.

> So a few minor nits.
>
> First I think we need this for both v4 and v6 since it looks like this
> code is reproduced for net/ipv6/ip6_gre.c.

I sent a separate patch for v6. Perhaps should have made it a series
to make this more clear.

> Second I don't know if we even need to bother including the "csum"
> portion of the lookup since that technically is just telling us if the
> GRE tunnel is requesting a checksum or not and I am not sure that
> applies to the fact that the inner L4 header is going to be what is
> requesting the checksum offload most likely.

This test introduced in the original patch specifically protects the
GRE tunnel checksum calculation using lco_csum. The regular inner
packet path likely is already robust (as similar bug reports would be
more likely for that more common case).

> Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
> the path triggering this should be fixed rather than us silently
> dropping frames. We should be figuring out what cases are resulting in
> us getting CHECKSUM_PARTIAL without skb_checksum_start being set.

We already know that bad packets can enter the kernel and trigger
this, using packet sockets and virtio_net_hdr. Unfortunately, this
*is* the fix.
