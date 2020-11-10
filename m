Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA64D2AE367
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbgKJWhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJWhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:37:13 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E781EC0613D1;
        Tue, 10 Nov 2020 14:37:12 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id cw8so15942ejb.8;
        Tue, 10 Nov 2020 14:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p7/DVWJXM3Y0l3Wn3I9BigYCth6XPlOyjvs+pJAWiAc=;
        b=oTU4KW0NIj1Gcr9fhmtUD7bMDrRQ3hiFp2lVi1vOs4ZThWjwmXuyh0FQwfJ4NcTx7s
         ZkbZpPe9CgzWdgd3XSNEWjjn1IMH6xQ8ZqkQfBLt3S0MuqBvjWkcVRgIgC+o7vh3N5cC
         +NnyCDYstJgBRxTzcPfcuroB7gtjsQeTJEcbSjiVCO1Sy/073/qKB7Kms63llNvwBfWy
         Ow6W1hXmD51m/lZF4CXZtmhOXFJ0YLzsmTL4mgKklIJoXQFSVJJN1A/TCkKUSrQByGbe
         59WK2G9Z/2YE9kMh1nQ9e3v36pq1mhTIMXyESFbZMHdNkJfjldxlf2qIKRloh23E2zTf
         hL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p7/DVWJXM3Y0l3Wn3I9BigYCth6XPlOyjvs+pJAWiAc=;
        b=CxWu1MEiR52b1QYQqaGqZkT5tglX+0+IHDCBsLWvnebk6NbDH1zYD73BQsiPu9ToGa
         ve7NhkAFx2XWsORXJ0AJ2X0yZ6LlMVOZIyeUg+Q9hqNMMMHd1ZYb50etTpQqvwsqJteE
         uvBS8rxg74CZji2CSzt2icf2DhnG14WYa7idzNwSXNXBzghsL+eiXAwsafzdpeks1eLH
         3PFbmsxss/x22bGcajJIro5UiCy8Ga5eTTLXivCN+8hKwyfiD/eb9rjRTB1eK2URzOTG
         Szodc3U7ZlZer+25Uj0TJV/26yjQUJ+vQ90BlCYPCHA9n8hugcb3XxmU7M+tFlhqJvNV
         GBqw==
X-Gm-Message-State: AOAM531adDms1b4wDU7YLjWOB38PJHNpdxb2mkry139slchCCG6UmdWG
        xrVm+bUw9K9xiE3g0kVyFdc=
X-Google-Smtp-Source: ABdhPJzzw/2ZXL0N52GYFiDvsV6F6t+RJvNY7RGOGb0I5zNdyadnQGa0N5VFcPB++q+tti0CSgFS3w==
X-Received: by 2002:a17:906:a14c:: with SMTP id bu12mr22892989ejb.444.1605047831591;
        Tue, 10 Nov 2020 14:37:11 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k11sm23320edh.72.2020.11.10.14.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 14:37:11 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:37:09 +0200
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
Subject: Re: [PATCH 08/10] ARM: dts: NSP: Add a default compatible for switch
 node
Message-ID: <20201110223709.vca534wynwgfkz77@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-9-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-9-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 07:31:11PM -0800, Florian Fainelli wrote:
> Provide a default compatible string which is based on the 58522 SRAB
> compatible, this allows us to have sane defaults and silences the
> following warnings:
>
>  arch/arm/boot/dts/bcm958522er.dt.yaml:
>     ethernet-switch@36000: compatible: 'oneOf' conditional failed,
> one
>     must be fixed:
>             ['brcm,bcm5301x-srab'] is too short
>             'brcm,bcm5325' was expected
>             'brcm,bcm53115' was expected
>             'brcm,bcm53125' was expected
>             'brcm,bcm53128' was expected
>             'brcm,bcm5365' was expected
>             'brcm,bcm5395' was expected
>             'brcm,bcm5389' was expected
>             'brcm,bcm5397' was expected
>             'brcm,bcm5398' was expected
>             'brcm,bcm11360-srab' was expected
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
>     'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
>     'brcm,bcm53019-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
>     'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
>     'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
>     'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
>     'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
>     'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
>             From schema:
>     Documentation/devicetree/bindings/net/dsa/b53.yaml
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
> index 09fd7e55c069..8453865d1439 100644
> --- a/arch/arm/boot/dts/bcm-nsp.dtsi
> +++ b/arch/arm/boot/dts/bcm-nsp.dtsi
> @@ -386,7 +386,7 @@ ccbtimer1: timer@35000 {
>  		};
>
>  		srab: ethernet-switch@36000 {
> -			compatible = "brcm,nsp-srab";
> +			compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
>  			reg = <0x36000 0x1000>,
>  			      <0x3f308 0x8>,
>  			      <0x3f410 0xc>;
> --
> 2.25.1
>

I am not getting this.
The line:
#include "bcm-nsp.dtsi"

can be found in:

arch/arm/boot/dts/bcm988312hr.dts
arch/arm/boot/dts/bcm958625hr.dts
arch/arm/boot/dts/bcm958622hr.dts
arch/arm/boot/dts/bcm958625k.dts
arch/arm/boot/dts/bcm958522er.dts
arch/arm/boot/dts/bcm958525er.dts
arch/arm/boot/dts/bcm958623hr.dts
arch/arm/boot/dts/bcm958525xmc.dts


The pattern for the other DTS files that include this seems to be to
overwrite the compatible locally in bcm958522er.dts, like this:

&srab {
	compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
};

Is there a reason why you are choosing to put an SoC specific compatible
in the common bcm-nsp.dtsi?
