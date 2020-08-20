Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E6724C1DE
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgHTPNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgHTPNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:13:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2C0C061385;
        Thu, 20 Aug 2020 08:13:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k20so1898922wmi.5;
        Thu, 20 Aug 2020 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r+6wCFKa8SGdi32yV32f+r2mcnJIjzitPz2Zc/AeqCg=;
        b=f/KrHytoPO1yGjZ58ymAbvA1U4YXXF9qwPj157aqVJZXc3O2JWNs94R9WxKbgsf4zU
         OXUXziHKzaGxoLhauioFun+joOHAyx11sNoS1Q1rTFPxILimrt8FC8bInNAdWzeHg/gR
         Wkkaku44v4psicXBuBqU6k+6DCApStKi8/VYCIvHcPX57gOh7ag4qbu8Lzihn/mrrvYO
         v0IbYSFMoHynyzKV+Cu3W1+8uZ63o/2Ikvg+dExkfM51JEp9SPZmqYni7vybDnem9/EG
         gIh+7Hn4yQnExznYLt2orUs637b/9PqpVEvMKfEX9cByBiF5MKVWCzyJeS7FpqveakBM
         27Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r+6wCFKa8SGdi32yV32f+r2mcnJIjzitPz2Zc/AeqCg=;
        b=uVm7ICj4WlIAQYwMl9piazF48KyLU8msTT6+nDSaLlsyRH6K+yw5H0So1+D2UyBrpc
         kO8BHwqW4GZAjl1b13TePgtu+q6o4gVaWENH/jamNmfnHbeWAxaUpzjRKj3tbV0YGUWk
         gvi2DqXBVGpDAxkk3jpbfMWsz+jQrxc6JYs7bJ3tQ5x8dYAx7qkiASZceS1E8zftKWLI
         wzTH3XNfzkIADwuPlfXk5z+spqOg4luIpBpZ2YbUwVAD8G1NH9vuAUdhlP696WKHnXgf
         9/zQHIQ0SMh+3rEk4w+ESXVkRMfhiJ6dHWCXXopt/XgGrXzAR/PLwXzMMV+42bvG1ptI
         vV1w==
X-Gm-Message-State: AOAM532MtkqFTpxwGF6dvaEZVBpAMBYTO8qwCYfewNbWSdHy8bLdJwkv
        8PVaplRfGpbVMAjsQy/cDaN/310zCUVjdqrlYbi9dUg9AovuOw==
X-Google-Smtp-Source: ABdhPJy2mCdw4lhoFf7YjVAIA/PYPCjhwuGS+RqZOtIe3jhyzy9jwavfqqt8COZzp1dCC0I4Ist9yqD9Vn9ITdf3OyY=
X-Received: by 2002:a05:600c:21cd:: with SMTP id x13mr4234963wmj.155.1597936408521;
 Thu, 20 Aug 2020 08:13:28 -0700 (PDT)
MIME-Version: 1.0
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com> <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
In-Reply-To: <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 20 Aug 2020 17:13:16 +0200
Message-ID: <CAJ+HfNjybUeN9v6N-pnupi32088PL+ZXu8CKWGWmowOaH4nmOw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 0/2] intel/xdp fixes for fliping rx buffer
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 at 16:04, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> On Fri, 17 Jul 2020 at 08:24, Li RongQing <lirongqing@baidu.com> wrote:
> >
> > This fixes ice/i40e/ixgbe/ixgbevf_rx_buffer_flip in
> > copy mode xdp that can lead to data corruption.
> >
> > I split two patches, since i40e/xgbe/ixgbevf supports xsk
> > receiving from 4.18, put their fixes in a patch
> >
>
> Li, sorry for the looong latency. I took a looong vacation. :-P
>
> Thanks for taking a look at this, but I believe this is not a bug.
>

Ok, dug a bit more into this. I had an offlist discussion with Li, and
there are two places (AFAIK) where Li experience a BUG() in
tcp_collapse():

            BUG_ON(offset < 0);
and
                if (skb_copy_bits(skb, offset, skb_put(nskb, size), size))
                    BUG();

(Li, please correct me if I'm wrong.)

I still claim that the page-flipping mechanism is correct, but I found
some weirdness in the build_skb() call.

In drivers/net/ethernet/intel/i40e/i40e_txrx.c, build_skb() is invoked as:
    skb =3D build_skb(xdp->data_hard_start, truesize);

For the setup Li has truesize is 2048 (half a page), but the
rx_buf_len is 1536. In the driver a packet is layed out as:

| padding 192 | packet data 1536 | skb shared info 320 |

build_skb() assumes that the second argument (frag_size) is max packet
size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)). In other words,
frag_size should not include the padding (192 above). In build_skb(),
frag_size is used to compute the skb truesize and skb end. i40e passes
a too large buffer, and can therefore potentially corrupt the skb, and
maybe this is the reason for tcp_collapse() splatting.

Li, could you test if you get the splat with this patch:

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..acfb4ad9b506 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2065,7 +2065,8 @@ static struct sk_buff *i40e_build_skb(struct
i40e_ring *rx_ring,
 {
     unsigned int metasize =3D xdp->data - xdp->data_meta;
 #if (PAGE_SIZE < 8192)
-    unsigned int truesize =3D i40e_rx_pg_size(rx_ring) / 2;
+    unsigned int truesize =3D rx_ring->rx_buf_len +
+                SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 #else
     unsigned int truesize =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info=
)) +
                 SKB_DATA_ALIGN(xdp->data_end -

I'll have a look in the other Intel drivers, and see if there are
similar issues. I'll cook a patch.


Bj=C3=B6rn
