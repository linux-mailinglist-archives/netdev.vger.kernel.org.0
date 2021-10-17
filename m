Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E810D430929
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbhJQMyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhJQMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:54:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CCCC061765;
        Sun, 17 Oct 2021 05:52:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w14so58901385edv.11;
        Sun, 17 Oct 2021 05:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcKNMpIu/CxYg6y5WrlzjtXsA7RyD9Ka9kXb+oqwfng=;
        b=far4EBP95mrfBat4/xMz28TF89+ISBdEv+wcEZhGEBM7zIeN2rd5Zju2Q1zhuHLYLT
         /rcleHlIEIM5wp+Xhyl2QUSs5/WdbKab4sWIrxfzsxlqdvR/wM9xstCHENfr6Jn1nVYa
         st+8nbcy/lghqszR5H8ATwvn9z5eFK+awX/FXCfxXrgY0pgiXwJ05CZ47s+XGBLt14lx
         KjqrRTnsE2v1NltaL5ksbPUpkFihFRNseiyYpfwr+r/49q0krYPQOOQhjs7H/FP+hJgz
         cL78BEndilGrL1CXAWrJ2YHf2Mlexs8Hy2mJEDXiksbqpNMcfYm2H5LiHM5B2uyRVn/B
         kKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcKNMpIu/CxYg6y5WrlzjtXsA7RyD9Ka9kXb+oqwfng=;
        b=qyLu6YvYTZbI41FPErXeH5/RigyA2DXrnzZz1ZqhBhDhNrm2Hln0FE8N/ejfmKZMgc
         sPKFTL8AQ720yUEJObaYNopBVfflCiNeb9a3ESAq1ekQ8GlZ+7l9XTlYqsXcyz36XOkG
         PkObRmkf4V0VBaVBhZ1sMPVTaPfzzozU0HpkHhqU/Zxt/R687B25gp/ydGCtzMO/8FMQ
         DU9qhq60iezYNggcV1GQZJuavw3ANH2dXgmeg2yEKjhid8w1aXN9sJ0u8IMSAELRSqJe
         9oRLbWK56QrjeTv8W7RMjl8+orlzRn666j/IgPhTVVcr5Eb4Kx6JDrBIKD1uhMgbMTjn
         xbmA==
X-Gm-Message-State: AOAM532FfDw84n+i6yp4HXGUBua1CukF8t4wr14tXHRE94oO5A8+AD/U
        5BzchwQhxaOMrjE2OeLCUSg95cOzE8oyA/NB580wRckdWq/QuBMLEpQ2pg==
X-Google-Smtp-Source: ABdhPJzij32hvS0NsE0C37rPDtMtoA0A2PgvSzyqiVc5Dc1EALsAR/qOiJbsYCBuOO2a7B5ye7fFtH/9v2K/Gc7xeIo=
X-Received: by 2002:aa7:c783:: with SMTP id n3mr35243349eds.122.1634475160794;
 Sun, 17 Oct 2021 05:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
 <CAD-N9QWTP8DLtAN70Xxap+WhNUfh9ixfeDMuNaB2NnpFhuAN8A@mail.gmail.com> <20211017123622.nfyis7o235tb2qad@pengutronix.de>
In-Reply-To: <20211017123622.nfyis7o235tb2qad@pengutronix.de>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sun, 17 Oct 2021 20:52:14 +0800
Message-ID: <CAD-N9QXwHgTdPdp+RN4sDfzxx0oa9T0TNbSt1x9D3vddbY4CQw@mail.gmail.com>
Subject: Re: [PATCH] driver: net: can: delete napi if register_candev fails
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 8:36 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 13.10.2021 13:21:09, Dongliang Mu wrote:
> > On Wed, Oct 13, 2021 at 12:04 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > If register_candev fails, xcan_probe does not clean the napi
> > > created by netif_napi_add.
> > >
> >
> > It seems the netif_napi_del operation is done in the free_candev
> > (free_netdev precisely).
> >
> > list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
> >           netif_napi_del(p);
> >
> > And list_add_rcu(&napi->dev_list, &dev->napi_list) is done in the
> > netif_napi_add.
> >
> > Therefore, I suggest removing "netif_napi_del" operation in the
> > xcan_remove to match probe and remove function.
>
> Sounds reasonable, can you create a patch for this.

I have submitted one patch - https://lkml.org/lkml/2021/10/17/181

>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
