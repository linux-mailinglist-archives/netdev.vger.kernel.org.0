Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D814E104293
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfKTRxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:53:06 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44136 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbfKTRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:53:06 -0500
Received: by mail-ot1-f67.google.com with SMTP id c19so324608otr.11;
        Wed, 20 Nov 2019 09:53:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uwv8oDObgXlOHyppocybq9RAMpKlTk5h/NeR2cnrypw=;
        b=SLo2M2SrfMO0joR4Vi096PRmD1SA0rKm0JSdxaK4CNATZCVgPHzjySrCsyQt78pljL
         XlawP6bVlLgkXjKJ1oW/awX+PrBQFlJY2G6R5t/4CIBWn/lAIIK3kDe3y/VvGpsxRerS
         rtzuPJqpNW9RtKyTFZqJybtXWvt8k6BJBwjBlpLiYwhN63myP91D2KS85DXEsA5pGOIN
         Ghn1MGLQzURbo41KD0KNmbAnxdTvYY8iLZOmNlRc5LKBR4qIguqUcRFzjD4pzN6nbfrr
         T7pZ6KkyFjtsAKOtneu+qzFY+TOkcPL30IKwjmh1yT7vRE42LAWZsGO1XaslIgCTjpar
         vpaA==
X-Gm-Message-State: APjAAAVdX26L1m8bhAyKJ1adxv3FsEDaYCMyMoWmrBs0DRroxs25iOVd
        0X08H+rJx0jsX/IzTJwO39gUNpS4
X-Google-Smtp-Source: APXvYqyYxpO+Yok/l/BmbsETZT/OFjJIE4+Qicr0Tx22dVgGKtoXrmGUpNs3GpfhXq/uvndGbsFHkg==
X-Received: by 2002:a9d:f45:: with SMTP id 63mr2959739ott.214.1574272385455;
        Wed, 20 Nov 2019 09:53:05 -0800 (PST)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id h39sm8799317oth.9.2019.11.20.09.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:53:04 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id c19so324551otr.11;
        Wed, 20 Nov 2019 09:53:04 -0800 (PST)
X-Received: by 2002:a9d:7f12:: with SMTP id j18mr2846999otq.221.1574272384642;
 Wed, 20 Nov 2019 09:53:04 -0800 (PST)
MIME-Version: 1.0
References: <20191118112324.22725-1-linux@rasmusvillemoes.dk> <20191118112324.22725-46-linux@rasmusvillemoes.dk>
In-Reply-To: <20191118112324.22725-46-linux@rasmusvillemoes.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Wed, 20 Nov 2019 11:52:53 -0600
X-Gmail-Original-Message-ID: <CADRPPNTgNtFL9Wok_ZNJSoo=4vokdU7c7z9JM-_e-w=pcDfwDg@mail.gmail.com>
Message-ID: <CADRPPNTgNtFL9Wok_ZNJSoo=4vokdU7c7z9JM-_e-w=pcDfwDg@mail.gmail.com>
Subject: Re: [PATCH v5 45/48] net/wan/fsl_ucc_hdlc: fix reading of __be16 registers
To:     David Miller <davem@davemloft.net>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, Timur Tabi <timur@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 5:26 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>

Hi David,

What do you think about the patch 45-47 from the series for net
related changes?  If it is ok with you, I can merge them with the
whole series through the soc tree with your ACK.

Regards,
Leo

> When releasing the allocated muram resource, we rely on reading back
> the offsets from the riptr/tiptr registers. But those registers are
> __be16 (and we indeed write them using iowrite16be), so we can't just
> read them back with a normal C dereference.
>
> This is not currently a real problem, since for now the driver is
> PPC32-only. But it will soon be allowed to be used on arm and arm64 as
> well.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/net/wan/fsl_ucc_hdlc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
> index 405b24a5a60d..8d13586bb774 100644
> --- a/drivers/net/wan/fsl_ucc_hdlc.c
> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> @@ -732,8 +732,8 @@ static int uhdlc_open(struct net_device *dev)
>
>  static void uhdlc_memclean(struct ucc_hdlc_private *priv)
>  {
> -       qe_muram_free(priv->ucc_pram->riptr);
> -       qe_muram_free(priv->ucc_pram->tiptr);
> +       qe_muram_free(ioread16be(&priv->ucc_pram->riptr));
> +       qe_muram_free(ioread16be(&priv->ucc_pram->tiptr));
>
>         if (priv->rx_bd_base) {
>                 dma_free_coherent(priv->dev,
> --
> 2.23.0
>
