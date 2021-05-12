Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB2B37C368
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 17:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhELPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 11:18:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54191 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234069AbhELPQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 11:16:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D7755C0089;
        Wed, 12 May 2021 11:14:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 May 2021 11:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=v
        dMf60Saph/emOVT1xf9TpZDrVMBXzuMGESNTJ768bY=; b=gpIGKjyipdtfL41WC
        ANR5rzw167MdJR0gkbDk8dXS5XUuVynL1BoAnTNxDvEMvgU6dMlsQE9vm+a/MArT
        vUidNnTEqQzL5JexovNFcRzSryEdoMzWxwSyORqpDNrTHMIE4us0kjJPlddkyDuu
        r5SNDMIUP8hJWYsegkD0i3ilUjIABbiUFLMbz6xJgEwLv87/EB3eearBpqpKfwdH
        kEdBM1EW7AoUelefTLdXNbznFYysK2CeaiKTkBhawUF+/OHFrXa1dOdOes6TXG2h
        CBPMUbpJesrt8CfsA8KXy31upeQU56cJ/Vgjj7NATMOAhXkjNo48xXCLCnXT5qZ6
        /z4gA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=vdMf60Saph/emOVT1xf9TpZDrVMBXzuMGESNTJ768
        bY=; b=qLPnk0juzOmjqFqGknKoMmqY4zPHOnpFX9Oh//ml5d190WematB2595oI
        K2YSbWeS7FklkxX1fBBhrNOi9gGJ+A2UmKI48OyQHSRKljH13XH2+hUdo7e1iJDs
        S77GFH7ENL8Y58FJ4LvoXKFJnYx2dSS+6+Y43LsFuuNWxnywUVKmzOHF9pFVls0Q
        glXLqQlM67wc8aO6zRPTWiLmvyV3UXZKcDmDYbip0phHPzSaurDTCOHI/9ZdlABX
        /t82MFDrrDYifvSjR7JzTV+SHT3KPD3GxgmC3lOrCmUKxlsqfs8WoF/SOZpBtV7t
        aolVzQdJuhv7v7F+EThLQFO8uteMw==
X-ME-Sender: <xms:6_CbYJBR2UNejqJmf-v73t7IL8qo-cFx9ZoxpHBDdYEgfc-0rgbT_g>
    <xme:6_CbYHg2hXshWn-URE8KnejoHl11OmYMbn_oXsSfz6YbEGZ8d8UTTy9s4LFoGHAjj
    5PxLfpN60Mb8fC8Mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjghosehtkeertddttddunecuhfhrohhmpeforghr
    khcuifhrvggvrhcuoehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomheqnecugg
    ftrfgrthhtvghrnheptedtfefhhffghfehheeikedvteehueetkeeitdejudffudeuudfh
    leevudejffetnecukfhppeejtddrudejvddrfedvrddvudeknecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhhgrhgvvghrsegrnhhimhgrlhgt
    rhgvvghkrdgtohhm
X-ME-Proxy: <xmx:6_CbYElZqISeeZ5VbyMfTOxy2oR_hyq5JK2PG5M2RDssYe_NtURbbQ>
    <xmx:6_CbYDwGFZ6_SPx6-BNo_4UbVPwNvsjZ0MBMHNWUqH5BpHNhUWtt2Q>
    <xmx:6_CbYORTITbKTgUcWax8RqHdL30wuXl2c9qBgYbRx-uFJ2fGE57FvQ>
    <xmx:7fCbYNE6fo1XnFX5X_6muhpcMok7dtpitrp2qrw6V9yHpUqk-iW4Aw>
Received: from blue.animalcreek.com (ip70-172-32-218.ph.ph.cox.net [70.172.32.218])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 11:14:51 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 9DD90136008B; Wed, 12 May 2021 08:14:50 -0700 (MST)
Date:   Wed, 12 May 2021 08:14:50 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [linux-nfc]  [PATCH] =?iso-8859-1?Q?MA?=
 =?iso-8859-1?Q?INTAINERS=3A_nfc=3A_drop_Cl=E9ment?= Perrochaud from NXP-NCI
Message-ID: <20210512151450.GA215713@animalcreek.com>
References: <20210512140046.25350-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210512140046.25350-1-krzysztof.kozlowski@canonical.com>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 10:00:46AM -0400, Krzysztof Kozlowski wrote:
> Emails to Clément Perrochaud bounce with permanent error "user does not
> exist", so remove Clément Perrochaud from NXP-NCI driver maintainers
> entry.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index efeaebe1bcae..cc81667e8bab 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13208,7 +13208,6 @@ F:	Documentation/devicetree/bindings/sound/tfa9879.txt
>  F:	sound/soc/codecs/tfa9879*
>  
>  NXP-NCI NFC DRIVER
> -M:	Clément Perrochaud <clement.perrochaud@effinnov.com>
>  R:	Charles Gorand <charles.gorand@effinnov.com>
>  L:	linux-nfc@lists.01.org (moderated for non-subscribers)
>  S:	Supported
> -- 
> 2.25.1

FWIW,

Acked-by: Mark Greer <mgreer@animalcreek.com>
