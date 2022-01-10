Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD0A489E57
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbiAJR2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbiAJR2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:28:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75967C06173F;
        Mon, 10 Jan 2022 09:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44B27B815CC;
        Mon, 10 Jan 2022 17:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0AEC36AE9;
        Mon, 10 Jan 2022 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641835718;
        bh=opzDGK+ViLVnOVOfbQYJqhicF7L9nKgZ+TiZTd6lJCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AW+th6gMKIkDZX7FLvaFA/YTQu0akD35wnfT4YxOVYKtpQ+zS7txT5mMUpm+rmafA
         YR3gmpasiNIaE3/7lHxbuXBQregMm6u0r/l1NALvOxpTtKZkwGee5GQ9onzZPVy0bV
         KCjMV5s40lWFTYDbTnSwrtOejO9g78DINJwziJ1c0D1OhY1F1wVSZX5F1wFc691jjb
         BU0mewb5pM8uUMGAJBbdyaV6ggSKHZw6c9n37Bg8blgpyOUZm66he7m8SSzLvtB3MN
         qkgj8URNaAZJSkP/U+54SACWnQMkUzs2S+Eg5Ds16ciZsDqqwfCPXjFqOd3Eqsl5CU
         k18B4czb32cvA==
Date:   Mon, 10 Jan 2022 09:28:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Conley Lee <conleylee@foxmail.com>, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
Message-ID: <20220110092836.113dbae1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <Ydw7EzPvwArW/siQ@Red>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
        <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
        <Ydw7EzPvwArW/siQ@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 14:56:35 +0100 Corentin Labbe wrote:
> > @@ -61,7 +62,21 @@
> >  #define EMAC_RX_IO_DATA_STATUS_OK	(1 << 7)
> >  #define EMAC_RX_FBC_REG		(0x50)
> >  #define EMAC_INT_CTL_REG	(0x54)
> > +#define EMAC_INT_CTL_RX_EN	(1 << 8)
> > +#define EMAC_INT_CTL_TX0_EN	(1)
> > +#define EMAC_INT_CTL_TX1_EN	(1 << 1)
> > +#define EMAC_INT_CTL_TX_EN	(EMAC_INT_CTL_TX0_EN | EMAC_INT_CTL_TX1_EN)
> > +#define EMAC_INT_CTL_TX0_ABRT_EN	(0x1 << 2)
> > +#define EMAC_INT_CTL_TX1_ABRT_EN	(0x1 << 3)
> > +#define EMAC_INT_CTL_TX_ABRT_EN	(EMAC_INT_CTL_TX0_ABRT_EN | EMAC_INT_CTL_TX1_ABRT_EN)
> >  #define EMAC_INT_STA_REG	(0x58)
> > +#define EMAC_INT_STA_TX0_COMPLETE	(0x1)
> > +#define EMAC_INT_STA_TX1_COMPLETE	(0x1 << 1)
> > +#define EMAC_INT_STA_TX_COMPLETE	(EMAC_INT_STA_TX0_COMPLETE | EMAC_INT_STA_TX1_COMPLETE)
> > +#define EMAC_INT_STA_TX0_ABRT	(0x1 << 2)
> > +#define EMAC_INT_STA_TX1_ABRT	(0x1 << 3)
> > +#define EMAC_INT_STA_TX_ABRT	(EMAC_INT_STA_TX0_ABRT | EMAC_INT_STA_TX1_ABRT)
> > +#define EMAC_INT_STA_RX_COMPLETE	(0x1 << 8)  
> 
> As proposed by checkpatch, I thing there are several place (like all
> EMAC_INT_STA) where you could use BIT(x) instead of (0xX << x)

That's not a hard requirement, if the driver already uses the shift you
can leave your code as is, some upstream developers actually prefer to
avoid the BIT() macro.
