Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87742AE314
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgKJWQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731709AbgKJWQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:16:28 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA6EC0613D1;
        Tue, 10 Nov 2020 14:16:28 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id b9so110944edu.10;
        Tue, 10 Nov 2020 14:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v6CRPmglpMlSJ75sQnTKtdS5nqeOdDA0Y1YvrDC2da4=;
        b=gH0IZdzgQhsqaFGF8ZZb9QoK4FE3+FZKe+BtbDubggQQdqKrh7ZhVb247f30azIZlq
         V+YnionkOfi3vP5JB5URskoox0o/S6veRihgpd00/8J/bCXs3DpjimbHiRoFfheNq9++
         gl1RF/UvaQm//IA0TuqBl4Yw9D9aXVqRm0qr0QFHCAL19+VU6a3QaBe6fADUBZe9lTMs
         FgA6vfRGF69eM7llD9MywtJ+W+Th+sGQYn0Uk/9c4jGKop8bRsg5R6Ne3AXsHQPpciEc
         dyrUCiddNb+/sLy3TQ7aAs8iHprgQlzFa8VDPdLLK7BbNhogzBIs3RNPpEqL7nhfVPhy
         ONFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v6CRPmglpMlSJ75sQnTKtdS5nqeOdDA0Y1YvrDC2da4=;
        b=tLaCBRGruJLb4qnJsrtCMzWgb6T40kruvYNZ3+bX8kKrnFAvJA/Bkj3EodMBpDnor3
         RQtbeHIu4RAemMW0ktR/KBStmL84R+ITXP+zq32Dw9Qka/hsUEnIeWhFKv5WIDDlCPaU
         gmKcvoLlbNzmRjH4w4BHn+UXKXj0aJFdeXWc0WvQ/43my0FfHfJ96NYN422z147Ht7ut
         jSHDv3wwyCQ9XEi/0vElOaa70iDsM/ay+aaKe7J+svdd3zS2UPg9wNTsG6S8hMypbqfq
         OhPt1ytHiGEleX04c01uw1Q1LiBZmMkledcHRhsT/nd+3M+omhjnqA/UIZSETzFeW+qQ
         WkeQ==
X-Gm-Message-State: AOAM532XuyuUHnVq6i6FlvZQf3axPgF0tuFAmZeoT4EnTc4exMpqzbNV
        xq2BBTQTneLgdc52ejzGXJUfDrWkssk=
X-Google-Smtp-Source: ABdhPJyg9VSS3mI3bi3KGq/VLVTotOHKfvclO2y+Lb0exsYvmdRhjn+hWCHlyWRQ0J7mhAevGxHX8g==
X-Received: by 2002:a50:8b65:: with SMTP id l92mr1679462edl.132.1605046586949;
        Tue, 10 Nov 2020 14:16:26 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h24sm60762ejg.15.2020.11.10.14.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:16:26 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:16:24 +0200
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
Subject: Re: [PATCH 06/10] ARM: dts: NSP: Update ethernet switch node name
Message-ID: <20201110221624.ekrvzj7bgeiurzs7@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-7-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-7-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:09PM -0800, Florian Fainelli wrote:
> Update the switch unit name from srab to ethernet-switch, allowing us
> to fix warnings such as:
> 
>      CHECK   arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml
>     arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml:
>     srab@18007000: $nodename:0: 'srab@18007000' does not match
>     '^(ethernet-)?switch(@.*)?$'
>             From schema:
>     Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
> index e895f7cb8c9f..e7d08959d5fe 100644
> --- a/arch/arm/boot/dts/bcm-nsp.dtsi
> +++ b/arch/arm/boot/dts/bcm-nsp.dtsi
> @@ -385,7 +385,7 @@ ccbtimer1: timer@35000 {
>  			clock-names = "apb_pclk";
>  		};
>  
> -		srab: srab@36000 {
> +		srab: ethernet-switch@36000 {
>  			compatible = "brcm,nsp-srab";
>  			reg = <0x36000 0x1000>,
>  			      <0x3f308 0x8>,
> -- 
> 2.25.1
> 
