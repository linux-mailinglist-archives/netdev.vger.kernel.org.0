Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC513EDA80
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhHPQFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:05:02 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:38539 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhHPQE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 12:04:59 -0400
Received: by mail-lf1-f45.google.com with SMTP id x27so35475170lfu.5;
        Mon, 16 Aug 2021 09:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yi1rPJlrOI0Zb+qMCwHDNyzTUMLukI8qhEPNSow1wbY=;
        b=sFF8Uu2ZOMWJ7+vjwIIOorPPjQ8noq6JJdllVDapE1i6mm4hxgC4WUXhYf8s+Czj14
         5RHaynaA4qUiYEFsbcMFnJiifo4UhACmGCRgi+XQrrdRMjnCnHgFyeyxhvDiBzI0iZrk
         1K4bHkya/HZfwszp+0kMI2L9YfA/N8WHE4OK9WdbwoAM6O55WOVCfH4Pz6QSnNfLPsNB
         oQIdr+eR07Tjpl65fcDhhy+7J1OEkCMbr/MUrIas1qdtt/93oBePxkZPB0/rrk2qq/Oi
         ir/SLcIjCSSpeWKQeXyIqyQckcRAOlT5d1SlCSIQOtaOzAPEVst1Lv5CYiEtJHEZgfoB
         MNag==
X-Gm-Message-State: AOAM531b2ICDPwQJ6sSnq3GNXvYYKBbSVK56SDLd6n3SqYBSk/qZz461
        iImEfefNcTypIJz1Q1QlzizgQ7AxDAcAVNkbQB4=
X-Google-Smtp-Source: ABdhPJz9GpCD8iLFOj3pDz5tFDSNpELUkrF3i8ie1qxjQMUiA0RH832HypDp5KYle/2ymN2W4EJdOxkv7BayEB6rFSs=
X-Received: by 2002:ac2:5ec7:: with SMTP id d7mr12001414lfq.234.1629129866802;
 Mon, 16 Aug 2021 09:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de> <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
In-Reply-To: <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 Aug 2021 01:04:15 +0900
Message-ID: <CAMZ6Rq+ZtN+=ppPEYYm0ykJWP8_LtPNBtOM6gwM1VrpM3idsyw@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

I answered too quickly in one paragraph.

On Tue. 17 Aug 2021 at 00:49, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> On Mon. 16 Aug 2021 at 22:43, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
...
> > Oh, I just noticed:
> >
> > | ip link set dev mcp251xfd0 down; \
> > | ip link set mcp251xfd0 txqueuelen 10 up type can \
> > |     sample-point 0.8 bitrate 500000  \
> > |     dsample-point 0.8 dbitrate 2000000 fd on \
> > |     tdc-mode manual tdco 11 tdcv 22
> >
> > followed by:
> >
> > | ip link set dev mcp251xfd0 down; \
> > | ip link set mcp251xfd0 txqueuelen 10 up type can
> >
> > We stay in manual mode:
> >
> > | Aug 16 15:27:47 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=11 tdcv=22 mode=manual
> >
> > | 8: mcp251xfd0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
> > |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> > |     can <FD,TDC_AUTO,TDC_MANUAL> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 100
>
> That's a bug. It should be impossible to have both TDC_AUTO and
> TDC_MANUAL at the same time.
>
> > |           bitrate 500000 sample-point 0.800
> > |           tq 25 prop-seg 31 phase-seg1 32 phase-seg2 16 sjw 1 brp 1
> > |           mcp251xfd: tseg1 2..256 tseg2 1..128 sjw 1..128 brp 1..256 brp_inc 1
> > |           dbitrate 2000000 dsample-point 0.800
> > |           dtq 25 dprop-seg 7 dphase-seg1 8 dphase-seg2 4 dsjw 1 dbrp 1
> > |           tdcv 22 tdco 11
> > |           mcp251xfd: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp_inc 1
> > |           tdcv 0..63 tdco 0..63
> > |           clock 40000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus spi parentdev spi0.0
>
> Sorry, but can I confirm what you did here? You stated that you
> did those four commands in this order:
>
> > | ip link set dev mcp251xfd0 down; \
> > | ip link set mcp251xfd0 txqueuelen 10 up type can \
> > |     sample-point 0.8 bitrate 500000  \
> > |     dsample-point 0.8 dbitrate 2000000 fd on \
> > |     tdc-mode manual tdco 11 tdcv 22
> > | ip link set dev mcp251xfd0 down; \
> > | ip link set mcp251xfd0 txqueuelen 10 up type can
>
> So now, you should be in Classical CAN (fd flag off) but the
> results of iproute2 shows that FD is on... Is there one missing
> step?

Please ignore this part. I misread the latest command and thought
you were configuring it as classical CAN. You just did a network
down / up.

I will troubleshoot this tomorrow.

> > I have to give "fd on" + the bit timing parameters to go to the full
> > automatic mode again:
> >
> > | Aug 16 15:32:46 rpi4b8 kernel: mcp251xfd spi0.0 mcp251xfd0: mcp251xfd_set_bittiming: tdco=16 tdcv=22 mode=automatic

Yours sincerely,
Vincent
