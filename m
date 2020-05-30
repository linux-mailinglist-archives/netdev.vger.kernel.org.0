Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8C1E8D79
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgE3DPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 23:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgE3DPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 23:15:40 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4CEC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 20:15:40 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c14so3151787qka.11
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 20:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDeQuUgZpcwemOSefbr/9OponauChrQDmM372H20z9k=;
        b=u4+rPgIruKX+OIm9gdxKY/yhla5AuxE+DN/NqeRdsOHxIDR2/2HF4Z9vbU5X9KGv2e
         ZeTozkJ5iA56WgtbBOCDKGXL2iDa+nnGDS1rNcOB02xnLbgUV+WIo57s748EqlkRqJfP
         Z2szSX3MYj9q/301jjK9toEZbNj9Vjg07VHZ+AY7loRgd9FPNfD6wXWnQJV7Zvq3/peT
         jRYUkUD75V2s2TJl/EtswkYsY2qbrCGCMbhPeZ/54HRXYxpXbWf5+CLFpVoOo+mess8F
         aXHQ7e3zgmHbKxD0BTEHI1nkKKD/7ue5S1aXPuNo2parJ3nc8GRm9mJtebdprEsEDZg7
         HRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDeQuUgZpcwemOSefbr/9OponauChrQDmM372H20z9k=;
        b=pSp1CIq1wRflO1pqKFN5qm/Yx4+G7pxYZWeMsilJHx7ThCv84MTYDBisYAgRpElzkd
         dUOByn3SpndKyBjr7QaSFLu8DOI6e2v7iZFQcsYMrDMKmHuBsZDlAbIGFt8m4dQqOX2L
         UofkYa4KfSrSzOJ2pW6jtZ9Fjp9Cn69HUEv6SQr7AFcA4ov9tN9fscaS/OUuuVDC0fiC
         D0/iQoi+aNdnJNJ1jnj0msAVeT6jT1hU3cNIT2yt71dJ9m0tKbOHD+EPLvFrVMXJqkfe
         F4k0Jq2UE3HVRXBnCX3qiJ4yUU2w+pZLX0PlJLPsymdwkVrz6SgukkrK6Tu9rmYg3kNR
         0XdA==
X-Gm-Message-State: AOAM532s0QCXjN0hrFA9XtdUBJKVcrJfcXzjC2wQ0fPxqW4L8YFIJsvg
        DzRqpB2AU0Ya+lPx1s5F33wfwXfs
X-Google-Smtp-Source: ABdhPJwxUMaY2ndhFXI9ohYTIbI1YKWAQvAkp9EKrToMWil2+aNGNBQuFkVufTA+xg18a01LfAC8kw==
X-Received: by 2002:a05:620a:1029:: with SMTP id a9mr11316865qkk.65.1590808537999;
        Fri, 29 May 2020 20:15:37 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id h50sm6136636qte.25.2020.05.29.20.15.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 20:15:37 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id m16so1829751ybf.4
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 20:15:36 -0700 (PDT)
X-Received: by 2002:a25:3187:: with SMTP id x129mr19017820ybx.428.1590808536380;
 Fri, 29 May 2020 20:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com> <20200529.172719.1001521060083156258.davem@davemloft.net>
In-Reply-To: <20200529.172719.1001521060083156258.davem@davemloft.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 May 2020 23:14:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdmRQem9d8amUdYg=pdZCDHiMVHjCCmKh-3dxoKk3th9g@mail.gmail.com>
Message-ID: <CA+FuTSdmRQem9d8amUdYg=pdZCDHiMVHjCCmKh-3dxoKk3th9g@mail.gmail.com>
Subject: Re: [PATCH net] tun: correct header offsets in napi frags mode
To:     David Miller <davem@davemloft.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 8:27 PM David Miller <davem@davemloft.net> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Thu, 28 May 2020 13:05:32 -0400
>
> > Temporarily pull ETH_HLEN to make control flow the same for frags and
> > not frags. Then push the header just before calling napi_gro_frags.
>  ...
> >       case IFF_TAP:
> > -             if (!frags)
> > -                     skb->protocol = eth_type_trans(skb, tun->dev);
> > +             if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
> > +                     err = -ENOMEM;
> > +                     goto drop;
> > +             }
> > +             skb->protocol = eth_type_trans(skb, tun->dev);
>  ...
> >               /* Exercise flow dissector code path. */
> > -             u32 headlen = eth_get_headlen(tun->dev, skb->data,
> > -                                           skb_headlen(skb));
> > +             skb_push(skb, ETH_HLEN);
> > +             headlen = eth_get_headlen(tun->dev, skb->data,
> > +                                       skb_headlen(skb));
>
> I hate to be a stickler on wording in the commit message, but the
> change is not really "pulling" the ethernet header from the SKB.
>
> Instead it is invoking pskb_may_pull() which just makes sure the
> header is there in the linear SKB data area.
>
> Can you please refine this description and resubmit?

Of course. How is this

"
    Ensure the link layer header lies in linear as eth_type_trans pulls
    ETH_HLEN. Then take the same code paths for frags as for not frags.
    Push the link layer header back just before calling napi_gro_frags.

    By pulling up to ETH_HLEN from frag0 into linear, this disables the
    frag0 optimization in the special case when IFF_NAPI_FRAGS is
    called with zero length iov[0] (and thus empty skb->linear).
"

Seemed good to add the extra clarification. I don't see a reasonable way
to avoid that consequence, especially as I cannot restore the first skb frag
(iov[1]) if it was exactly ETH_HLEN bytes and thus freed by __skb_pull_tail.
