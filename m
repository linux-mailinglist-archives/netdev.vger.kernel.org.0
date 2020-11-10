Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA082AE3DD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732378AbgKJXGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731805AbgKJXGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 18:06:44 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F3EC0613D1;
        Tue, 10 Nov 2020 15:06:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so113997ejy.6;
        Tue, 10 Nov 2020 15:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SmORY5VYIbu+3sCJt6w8Nrmhwl2bckCo6RS1zo++7Sw=;
        b=jgGYW95ou/hRhqgwdufoUaNm8PBkg2U97a6aRBnyMFHIjpOQ/kwxQ5pqAN28rZgbVv
         p5vUlvfkpWFaCxRv3VNk/xkJDzkIVLl/FJlc99MZ/nxsiM3DPx4Svw+vZKHIklUgW3xi
         uRwal5DXgFkL57kG1zgXJKCC57cOcEA0YsPdsmycraMYLoDfqljJYCZiyXHP1QgqbDGL
         fRlRtSDoSkRsCF61Nq0NAKeCe6CIYsHVOwTVFJSWX30oip7IY8VgKzV5MCUAx0uCZ4lW
         vlxrG3vxLEt4mTPYfYTKMWg47JA2trHYttF58+APohAmhn4e5HAa9rZ40PP3omgH7tAm
         qKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SmORY5VYIbu+3sCJt6w8Nrmhwl2bckCo6RS1zo++7Sw=;
        b=F/8rONpFDahFRp0cHpcAoeQ1GkYY0R0vxt1AeJDusGneeWVtwly07gUEDAwNRpG+e4
         FHaTaSz8+2mpLs9dops3bPBrUak5zFzpzCvoL7bF8wZz4gkpj80XgSW8/Km1oEl4x3YO
         tUjdUzrJo5L9NekP3ZBuf+UKcSfdhYlobk9g+bzkLGelQT3ICLcHxbQhx3YeUD6RrAIU
         Jgnp/Igfki1JBL4jW12wSrX+evB/0BVbiuXCVxZmyzJPC/lXse9nPx3s4hs/7yvv5dCm
         8eT71pxfBZjHasJ/ouEBix2FcZyy13HRiYBtdgsUj17ynsponzWsY7uRURMx+0h3Hljn
         v4uQ==
X-Gm-Message-State: AOAM531AmkFKtzjuQ5sxnxVntO8ePaSog6uiCBqRXWHfBmMB4lyzOqLV
        K2aKpG6CRrB+0Qvh1e7MLJY=
X-Google-Smtp-Source: ABdhPJw4dSSVXa5gQV5aoC/yeC49D1O0Er+XuqWl7AgeBZ0WjL9K+L/3v9Iy5r+StoBv4H2pwOB4HA==
X-Received: by 2002:a17:906:60c8:: with SMTP id f8mr23196957ejk.14.1605049600712;
        Tue, 10 Nov 2020 15:06:40 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h23sm48382edv.69.2020.11.10.15.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 15:06:40 -0800 (PST)
Date:   Wed, 11 Nov 2020 01:06:38 +0200
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
Message-ID: <20201110230638.6vlq55zsd3s36t3i@skbuf>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-9-f.fainelli@gmail.com>
 <20201110223709.vca534wynwgfkz77@skbuf>
 <ff118521-6317-b75f-243d-bcd6bbe255d5@gmail.com>
 <20201110224820.gbz3tcl6lzjbe3zo@skbuf>
 <d20db936-31f2-97d7-7db2-57b5599107f1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d20db936-31f2-97d7-7db2-57b5599107f1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 02:52:57PM -0800, Florian Fainelli wrote:
> On 11/10/20 2:48 PM, Vladimir Oltean wrote:
> > On Tue, Nov 10, 2020 at 02:40:43PM -0800, Florian Fainelli wrote:
> >> On 11/10/20 2:37 PM, Vladimir Oltean wrote:
> >>> On Mon, Nov 09, 2020 at 07:31:11PM -0800, Florian Fainelli wrote:
> >>>> Provide a default compatible string which is based on the 58522 SRAB
> >>>> compatible, this allows us to have sane defaults and silences the
> >>>> following warnings:
> >>>>
> >>>>  arch/arm/boot/dts/bcm958522er.dt.yaml:
> >>>>     ethernet-switch@36000: compatible: 'oneOf' conditional failed,
> >>>> one
> >>>>     must be fixed:
> >>>>             ['brcm,bcm5301x-srab'] is too short
> >>>>             'brcm,bcm5325' was expected
> >>>>             'brcm,bcm53115' was expected
> >>>>             'brcm,bcm53125' was expected
> >>>>             'brcm,bcm53128' was expected
> >>>>             'brcm,bcm5365' was expected
> >>>>             'brcm,bcm5395' was expected
> >>>>             'brcm,bcm5389' was expected
> >>>>             'brcm,bcm5397' was expected
> >>>>             'brcm,bcm5398' was expected
> >>>>             'brcm,bcm11360-srab' was expected
> >>>>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
> >>>>     'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
> >>>>     'brcm,bcm53019-srab']
> >>>>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
> >>>>     'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
> >>>>     'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
> >>>>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
> >>>>     'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
> >>>>     'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
> >>>>             'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
> >>>>     'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
> >>>>             From schema:
> >>>>     Documentation/devicetree/bindings/net/dsa/b53.yaml
> >>>>
> >>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>>> ---
> >>>>  arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
> >>>> index 09fd7e55c069..8453865d1439 100644
> >>>> --- a/arch/arm/boot/dts/bcm-nsp.dtsi
> >>>> +++ b/arch/arm/boot/dts/bcm-nsp.dtsi
> >>>> @@ -386,7 +386,7 @@ ccbtimer1: timer@35000 {
> >>>>  		};
> >>>>
> >>>>  		srab: ethernet-switch@36000 {
> >>>> -			compatible = "brcm,nsp-srab";
> >>>> +			compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
> >>>>  			reg = <0x36000 0x1000>,
> >>>>  			      <0x3f308 0x8>,
> >>>>  			      <0x3f410 0xc>;
> >>>> --
> >>>> 2.25.1
> >>>>
> >>>
> >>> I am not getting this.
> >>> The line:
> >>> #include "bcm-nsp.dtsi"
> >>>
> >>> can be found in:
> >>>
> >>> arch/arm/boot/dts/bcm988312hr.dts
> >>> arch/arm/boot/dts/bcm958625hr.dts
> >>> arch/arm/boot/dts/bcm958622hr.dts
> >>> arch/arm/boot/dts/bcm958625k.dts
> >>> arch/arm/boot/dts/bcm958522er.dts
> >>> arch/arm/boot/dts/bcm958525er.dts
> >>> arch/arm/boot/dts/bcm958623hr.dts
> >>> arch/arm/boot/dts/bcm958525xmc.dts
> >>>
> >>>
> >>> The pattern for the other DTS files that include this seems to be to
> >>> overwrite the compatible locally in bcm958522er.dts, like this:
> >>>
> >>> &srab {
> >>> 	compatible = "brcm,bcm58522-srab", "brcm,nsp-srab";
> >>> };
> >>>
> >>> Is there a reason why you are choosing to put an SoC specific compatible
> >>> in the common bcm-nsp.dtsi?
> >>
> >> It is necessary to silence the warnings provided in the commit message
> >> even when the srab node is disabled, since the dt_binding_check rule
> >> will check all of the nodes matching the pattern. If there is a better
> >> way to do this, I would gladly do it differently.
> >> -- 
> >> Florian
> > 
> > I am still not getting it. The exact 3 lines from above will not change
> > the "status" property from "disabled" to "okay", so I don't understand
> > why it matters whether it's enabled or not. The dt_binding_check error
> > isn't in the DTSI, it's in bcm958522er.dts. All that needs to be done is
> > that the bcm958522er.dts needs to override the compatible from the DTSI
> > and only the compatible, I believe. With no occurrence of an incomplete
> > list of compatibles in any final DTS, the dt_binding_check should not
> > complain about that single occurrence in the DTSI as far as I know (and
> > I did not test this).
> 
> There is not a switch being enabled in
> arch/arm/boot/dts/bcm958522er.dts, so sure, I could add the 3 lines you
> quote above and that would silence the warning, but that does not scale
> at all across DTS files including bcm5301x.dtsi for instance, it sort of
> does for those including bcm-nsp.dtsi.
> -- 
> Florian

I see only bcm47081.dtsi and bcm4708.dtsi to include bcm5301x.dtsi, and
you did point out in the other email that the BCM4708* SoCs always
contain a BCM53010 switch, so that would make the other patch not wrong.

Either way, it's up to you and Rafal.
