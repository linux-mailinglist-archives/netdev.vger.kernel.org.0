Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AF52AE2FB
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgKJWNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732857AbgKJWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:12:25 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64D0C0613D3;
        Tue, 10 Nov 2020 14:12:24 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id o20so138308eds.3;
        Tue, 10 Nov 2020 14:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P7+OdEtVINuaWn7XQg8+rcvcv6O3BqOjRYLAkjkwIXk=;
        b=hU6Mbm0+F75S0Q16vh/Wx9PCWHZWgSJrY8F78lbNJZrNCC3D5zNOZLMfJMC/u5vDXo
         y+hP01MmAeqhGFqgZsx+8rxYNek1qHsg8Ewm3Hij1Vny7WY0q7yCUaFf5/RJd9g84fIf
         QXBQaQRxyV0eCwNa9IJp5xDNoZlCJktDVHjaPHSux7c+grOOS6Kz75T9pkPjHAiLz2Hb
         ldWPJz8h2jPM2kcZ+7C/5WnOszNoQXpaTKatTeTTOwwgA7IQxI/9vWmQIkv4RAdWI3js
         CAGW8N33iM6hFUruvvgT607SzcQ2zoAxxcBDR7IOV9IqFjfhxMteF60VsJNyh03Og98C
         iQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7+OdEtVINuaWn7XQg8+rcvcv6O3BqOjRYLAkjkwIXk=;
        b=mu2ShALdSs2gAeWLPIfIDJsUuARHpRCHuY5VUu0yKnkdg9mHzo55V6Yz5zr83q7mtT
         58fcKM8wVBqZWkZA/v01uZV69ryRLjly7HgXnJy/3YFdZLVJaFOhV9lexHd+mV15ZnZt
         9W72A69wo3DG6u9mMzHny8PAHsi2NxjmZIn9tJSOp7x0nVJVZchK071NRmUa2e79yOpF
         w1KSKrOU4DD72Au8tm0t4ykm6e1Za6BtBWLC/3oxSD5T8WRG3gfqAHjQ787R7/MSj2FU
         cIiTnbHbpm4O7cfidFyRebIuZlzgKYBMJPZyWF03XtA8u4MNknjpAcz7YuTePCYZHVeb
         4gWA==
X-Gm-Message-State: AOAM533rHrmTqx4BDeC5cFEITM5899nVkkGGUCY3IDcxnNJHykYwXblZ
        fjthK2YtobPs8L+TnOpo1w8=
X-Google-Smtp-Source: ABdhPJyWbdsaRQBLaCOll12qGnDs4KmJNSvNWEhvwy/xD0a3MCdi+OcCpCKKRrObi9xNN3ccEeqHqA==
X-Received: by 2002:a50:ed14:: with SMTP id j20mr24037840eds.247.1605046343636;
        Tue, 10 Nov 2020 14:12:23 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y4sm12143edr.20.2020.11.10.14.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:12:23 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:12:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: Re: [PATCH 05/10] ARM: dts: BCM5301X: Provide defaults ports
 container node
Message-ID: <20201110221221.4sxx5h3346no7y3y@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-6-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-6-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:08PM -0800, Florian Fainelli wrote:
> Provide an empty 'ports' container node with the correct #address-cells
> and #size-cells properties. This silences the following warning:
> 
> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
> ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
>         'ports' is a required property
>         'ethernet-ports' is a required property
>         From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/boot/dts/bcm5301x.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
> index 807580dd89f5..89993a8a6765 100644
> --- a/arch/arm/boot/dts/bcm5301x.dtsi
> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
> @@ -489,6 +489,10 @@ srab: ethernet-switch@18007000 {
>  		status = "disabled";
>  
>  		/* ports are defined in board DTS */
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};

This look a bit 'lone wolf' here. Not sure how much time you intend to
spend on this, but FWIW, others prefer to declare all ports in the SoC
DTSI with status = "disabled", and just enable the ones used per-board,
and add labels and PHY handles also per-board. Example: fsl-ls1028a.dtsi
and fsl-ls1028a-rdb.dts.

>  	};
>  
>  	rng: rng@18004000 {
> -- 
> 2.25.1
> 
