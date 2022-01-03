Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BF14830AD
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiACLnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiACLnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 06:43:03 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF7CC061761;
        Mon,  3 Jan 2022 03:43:03 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d9so69448514wrb.0;
        Mon, 03 Jan 2022 03:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aPS6KYT8HDzSVLi9dYZW0290KgEUx0odBCGRdWGGbmA=;
        b=RhQoXZQGhW+n8fbQRI6HZ2Vk1rCJW3oJIAhklT3BtSw9ljwr73+gPoJumo5N90v9Br
         ZtxgV5xQxAf9+T4GDdfT7yiPugQrWkxBJT0O47f19IFHw66EAkO8CumDcAs6GkF9uY0S
         e6gxcEKqCkt6aDa/LGJ/Z/jCZliO04gX5QE6N6NMSX7zezRskUur0mLRwxi0NHPFKgsG
         FlMen61FgDno0drxB2HXLc8vp7dQj2V02QND4krsDYibROly3MT+RDITuifK8s1PjyeW
         JS9i8v5hUrPALrwI977Vg6tC1QFu53HWy2pfG+3wGyClJSW/3wdHx3zs/oGMAukpt9qo
         HGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aPS6KYT8HDzSVLi9dYZW0290KgEUx0odBCGRdWGGbmA=;
        b=d5ZAv2XzWc4g5AbSodCLT3xaDqKHDetutEhrD2NO2kQZ40YBbpMs1xPdY6wzSeJRWM
         fOQNiSMdeVR4n3rTKs3c2MnNurdUS9+EioEPFpAmUkN18ymWwAj5xMIGO6Eh5pUSVcJZ
         Fkkn3+vUclXiBmR41FkcgHpjsavKXXcm+0ogQnOt05Tnn13Mo6/UhQ4NmveLaKdD5Lq1
         eWhqVaRoYzbMZcPJy3jxyXUsVErzGMbBTYjidG9EZGxtADHkPPa6yqT2Uilql0GYEMtl
         T/lEKYs5WW8v/8BywYF98XtqcIhvLkA7UEK16fXXWhxXdq9qOtoDyljBQ5XaO89aneoM
         mffQ==
X-Gm-Message-State: AOAM533Vqqh1CA6jQREO+yQhHvXKoEIlnXLMDgeZvx87caQpJRzQpG5v
        sJonNh+QxCXSmGz+RgkXYPr8f8lhpMY=
X-Google-Smtp-Source: ABdhPJy/h/Spn2vlWYfowVvuzEWHSRLKESCvh3uQMdUybgLIjY+pVyXq8leo4KCUBQqC2p30fnwJqw==
X-Received: by 2002:adf:dd8b:: with SMTP id x11mr27986945wrl.626.1641210181646;
        Mon, 03 Jan 2022 03:43:01 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m17sm38946504wms.25.2022.01.03.03.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 03:43:01 -0800 (PST)
Date:   Mon, 3 Jan 2022 12:42:58 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <YdLhQjUTobcLq73j@Red>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
 <Yc7e6V9/oioEpx8c@Red>
 <tencent_57960DDC83F43DA3E0A2F47DEBAD69A4A005@qq.com>
 <YdHjK+/SzaeI/V2Q@Red>
 <tencent_67023336008FE777A58293D2D32DEFA69107@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_67023336008FE777A58293D2D32DEFA69107@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, Jan 03, 2022 at 10:55:04AM +0800, Conley Lee a écrit :
> On 01/02/22 at 06:38下午, Corentin Labbe wrote:
> > Date: Sun, 2 Jan 2022 18:38:51 +0100
> > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > To: Conley Lee <conleylee@foxmail.com>
> > Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
> >  wens@csie.org, netdev@vger.kernel.org,
> >  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
> >  linux-sunxi@lists.linux.dev, jernej.skrabec@gmail.com
> > Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> > 
> > Le Sat, Jan 01, 2022 at 03:09:01PM +0800, Conley Lee a écrit :
> > > On 12/31/21 at 11:43上午, Corentin Labbe wrote:
> > > > Date: Fri, 31 Dec 2021 11:43:53 +0100
> > > > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > To: conleylee@foxmail.com
> > > > Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
> > > >  wens@csie.org, netdev@vger.kernel.org,
> > > >  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
> > > > 
> > > > Le Wed, Dec 29, 2021 at 09:43:51AM +0800, conleylee@foxmail.com a écrit :
> > > > > From: Conley Lee <conleylee@foxmail.com>
> > > > > 
> > > > > Thanks for your review. Here is the new version for this patch.
> > > > > 
> > > > > This patch adds support for the emac rx dma present on sun4i. The emac
> > > > > is able to move packets from rx fifo to RAM by using dma.
> > > > > 
> > > > > Change since v4.
> > > > >   - rename sbk field to skb
> > > > >   - rename alloc_emac_dma_req to emac_alloc_dma_req
> > > > >   - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
> > > > >     sleeping
> > > > >   - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
> > > > >   - fix some code style issues 
> > > > > 
> > > > > Change since v5.
> > > > >   - fix some code style issue
> > > > > 
> > > > 
> > > > Hello
> > > > 
> > > > I just tested this on a sun4i-a10-olinuxino-lime
> > > > 
> > > > I got:
> > > > [    2.922812] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): get io resource from device: 0x1c0b000, size = 4096
> > > > [    2.934512] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): failed to request dma channel. dma is disabled
> > > > [    2.945740] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): configure dma failed. disable dma.
> > > > [    2.957887] sun4i-emac 1c0b000.ethernet: eth0: at (ptrval), IRQ 19 MAC: 02:49:09:40:ab:3d
> > > > 
> > > > On which board did you test it and how ?
> > > > 
> > > > Regards
> > > 
> > > Sorry. I sent the email with text/html format. This email is an clean version.
> > > 
> > > In order to enable dma rx channel. `dmas` and `dma-names` properties
> > > should be added to emac section in dts:
> > > 
> > > emac: ethernet@1c0b000 {
> > > 	...
> > > 	dmas = <&dma SUN4I_DMA_DEDICATED 7>;
> > > 	dma-names = "rx";
> > > 	...
> > > }
> > 
> > Helo
> > 
> > Yes I figured that out. But you should have done a patch serie adding this.
> > Your patch is now applied but it is a useless change without the dtb change.
> > You should also probably update the driver binding (Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml) since you add new members to DT node.
> > 
> > Furthermore, why did you add RX only and not TX dma also ?
> > 
> > Probably it is too late since patch is applied but it is:
> > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Tested-on: sun4i-a10-olinuxino-lime
> > 
> > Regards
> 
> Thanks for your suggestion. I will submit a patch to add those changes
> later. 
> 
> And the reason why I didn't add TX support is becasuse there is no any
> public page to describe sun4i emac TX DMA register map. So, I don't known
> how to enable TX DMA at hardware level. If you has any page or datasheet
> about EMAC TX DMA, can you share with me ? Thanks.

Hello

You can find TX DMA info on the R40 Use manual (8.10.5.2 Register Name: EMAC_TX_MODE)

You should keep all people in CC when you answer to someone.

Regards
