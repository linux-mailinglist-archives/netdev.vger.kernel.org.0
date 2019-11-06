Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3062F0DFE
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfKFEsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:48:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43155 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKFEsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:48:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id 3so17882719pfb.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 20:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=v42+MZ4UPr2BbMb1do1OwGpbKR7cuUfnceiZ2TOesAA=;
        b=TUtrAaorujmhuhm1YjFYb2sU0UYhyPfM7NM0lNwVtJp/1giWr3dXvcrnXEd+4JxuxA
         zLdSi7oLUsezTVPEGi1GnfYFmKruFbqOVLoijxHY49iSLLbyooFDs3y0a2cf9ALLiVuo
         JnqEB5NzNkDIOqm6zjqYIFuHB4FNuuWKSQRMZRMAaojdg9v9CmIsQx9mClBxM/PGLjqO
         uO65/xRKdfY4g2m3nBYcvIqT6fJFlMDxmrRkSDkwZwTW7e3LIJl8Moe/RoamTzNN5MU3
         P3yfefiBPAoVgfAYLQWujOqAaYqaWNbeEunGvZGOJ96EfmQRY149licwfXF09kXTr1k3
         9XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=v42+MZ4UPr2BbMb1do1OwGpbKR7cuUfnceiZ2TOesAA=;
        b=KcNWrqa37/dkv+JjdVeYIz2nwvMhltj0YUkt/hidqboW3qtlDJUfyQ1MU6m4f2Rp5y
         Mrm/d8nZTn1SS45SGe8NUIMc7yP1tkmSzYNN/HKBbQQTiJMS/mOVBakfKGjvJ/V4XLRu
         5D9vz7i8YBwUxHRdLMhdQafGaYoV/OjaJuS5NgHdyuf9fu5NLJVdXdkffkfGfCp0Zmn3
         RuZxwlhdpJCei5/TvWCNHcIfIK7lzkLs8HiE1cBP2j/QLdzNFH0g81rOGpdjniSaHsx2
         nLYqY4hwGElmIolA7OuBMC8IxuqPrgXZnpWe6iyUXgsjVD9ntjsiw7+vHXeIsE4+n+aG
         uRsg==
X-Gm-Message-State: APjAAAUQysDazXHjTyLJG30XOYUpAEIQjn+wIhWXrqw3Wr2+Qw+ZTtew
        Wourlqr9vBGIeJyoodrgKdQtnA==
X-Google-Smtp-Source: APXvYqx1ojAqJ1CtapSYBt0gnrXLNo6/lygWhMXOzTqIO7v2NYaBzgG6BMH0BV98S4+mJjAXS+c6Mg==
X-Received: by 2002:a17:90a:19dc:: with SMTP id 28mr1160569pjj.32.1573015720402;
        Tue, 05 Nov 2019 20:48:40 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x70sm26333855pfd.132.2019.11.05.20.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:48:40 -0800 (PST)
Date:   Tue, 5 Nov 2019 20:48:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCHv4 1/1] net: forcedeth: add xmit_more support
Message-ID: <20191105204837.63fe5b70@cakuba.netronome.com>
In-Reply-To: <f389d645-384f-73a5-4d15-af388520446f@oracle.com>
References: <1572928001-6915-1-git-send-email-yanjun.zhu@oracle.com>
        <20191105094841.623b498e@cakuba.netronome.com>
        <f389d645-384f-73a5-4d15-af388520446f@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Nov 2019 12:47:29 +0800, Zhu Yanjun wrote:
> On 2019/11/6 1:48, Jakub Kicinski wrote:
> > On Mon,  4 Nov 2019 23:26:41 -0500, Zhu Yanjun wrote: =20
> >> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/eth=
ernet/nvidia/forcedeth.c
> >> index 05d2b47..0d21ddd 100644
> >> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> >> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> >> @@ -2259,7 +2265,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff=
 *skb, struct net_device *dev)
> >>   			u64_stats_update_begin(&np->swstats_tx_syncp);
> >>   			nv_txrx_stats_inc(stat_tx_dropped);
> >>   			u64_stats_update_end(&np->swstats_tx_syncp);
> >> -			return NETDEV_TX_OK;
> >> +
> >> +			writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
> >> +			       get_hwbase(dev) + NvRegTxRxControl);
> >> +			ret =3D NETDEV_TX_OK;
> >> +
> >> +			goto dma_error; =20
> > You could goto the middle of the txkick if statement here, instead of
> > duplicating the writel()? =20
> As your suggestion, the change is like this:
>=20
> @@ -2374,7 +2374,9 @@ static netdev_tx_t nv_start_xmit(struct sk_buff=20
> *skb, struct net_device *dev)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&np->l=
ock, flags);
>=20
>  =C2=A0txkick:
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (netif_queue_stopped(dev) || !ne=
tdev_xmit_more()) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (netif_queue_stopped(dev) || !ne=
tdev_xmit_more())
> +dma_error:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 u32 txrxctl_kick =3D NVREG_TXRXCTL_KICK | np->txrxctl_bi=
ts;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
>=20
> The opening brace on the first of the line. It conflicts with the followi=
ng:
>=20
> Documentation/process/coding-style.rst:
> "
>  =C2=A0 98 3) Placing Braces and Spaces
>  =C2=A0 99 ----------------------------
>  =C2=A0100
>  =C2=A0101 The other issue that always comes up in C styling is the place=
ment of
>  =C2=A0102 braces.=C2=A0 Unlike the indent size, there are few technical =
reasons to
>  =C2=A0103 choose one placement strategy over the other, but the preferre=
d=20
> way, as
>  =C2=A0104 shown to us by the prophets Kernighan and Ritchie, is to put t=
he=20
> opening
>  =C2=A0105 brace last on the line, and put the closing brace first, thusl=
y:
> "
> So I prefer to the current code style.
>=20
> Thanks for your suggestions.

	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
		u32 txrxctl_kick;

txkick:
		txrxctl_kick =3D NVREG_TXRXCTL_KICK | np->txrxctl_bits;
		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
	}
