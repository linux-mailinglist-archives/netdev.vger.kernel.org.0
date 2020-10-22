Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB640295E79
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898274AbgJVMhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898263AbgJVMhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 08:37:40 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FDCC0613CE;
        Thu, 22 Oct 2020 05:37:39 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id c15so2081137ejs.0;
        Thu, 22 Oct 2020 05:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Of9gR7+alpUYr+QS/dPqMyV5JIcvv8ObtrAkaPg8ZQg=;
        b=V4mejo6IOjWjLn+Wmkukq7fTAQSOFlVyGGbLV8CDdpxEuTM6PLqgmoUQo6zqLMyXQ6
         PPszwvOze3p5bXON2FM+n6BAOr8OMXj6Air9zAnjoJavcb2N9uYKMPCDpLw5Uw1j0B6R
         AQ8cZRny/9R0mmpSMs81jauyl+cyYh5wbOZ+2qshA2HEl68tXQYvZw/cq0XEPz90wGDm
         UvQdSttqXgq+vw19ylBVEq0Slk26kqbLbm2Ok5A+RXDpyQEFdHSFAzC6lKwVWXhTCMqT
         9xcZ9ijnPkCcLytsh2NkpJYdUCySlM+LwkmkP0yn5BAjMGEelzsizmKfbaT34frS0vVN
         kLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Of9gR7+alpUYr+QS/dPqMyV5JIcvv8ObtrAkaPg8ZQg=;
        b=umvcE0MnOcgIyfPOoIgD67SHiFhLyES55cXHnoZjMrqjWvu0frSobjf9zgRexSliXC
         0uDY7QOu00iuh8Ijc4GaJBZbk80qH9JPjpKhbfDhbEi2mC5gCFC3kq+/sWJSuQoKSChA
         pmfBKobUuRM2qMSVAzG0n0GEMETduNRZO8wB4UlnSyBjpK2i8gTPi0V3zCg/ULydC43I
         sOdEzrQavFU2aAa7hJ8yk3oUObf/rVigzXysdfHZnJIpfy0tmOCG5QVGGGUsLrnmRvge
         IkQT5uLfrV/8agoHe/x9y4vZAn+brj1kizX39oie6ZGrMCKPDbKdSeBKMK8T3KKZiYwL
         9joA==
X-Gm-Message-State: AOAM533GwnMLO/179GdPq7eF1j7ffyFng4MW+LvJ+TkS7+JFEcUDi32C
        /KSQYXrrIP4BZXGgOLBLgzM=
X-Google-Smtp-Source: ABdhPJwLPw6DYZxywEBJg8d1MKBLabehYnfyjvNlHAyAZ7OG3xfj5H67dR2zm8FCDNxKpmSOhbFjSA==
X-Received: by 2002:a17:906:48b:: with SMTP id f11mr2108309eja.293.1603370257906;
        Thu, 22 Oct 2020 05:37:37 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id bx24sm799025ejb.51.2020.10.22.05.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 05:37:37 -0700 (PDT)
Date:   Thu, 22 Oct 2020 15:37:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Christian Eggers <ceggers@arri.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201022123735.3mnlzkfmqqrho6n5@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-2-ceggers@arri.de>
 <87lfg0rrzi.fsf@kurt>
 <20201022001639.ozbfnyc4j2zlysff@skbuf>
 <3cf2e7f8-7dc8-323f-0cee-5a025f748426@gmail.com>
 <87h7qmil8j.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7qmil8j.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:54:52PM +0200, Kurt Kanzenbach wrote:
> On Wed Oct 21 2020, Florian Fainelli wrote:
> > On 10/21/2020 5:16 PM, Vladimir Oltean wrote:
> >> On Wed, Oct 21, 2020 at 08:52:01AM +0200, Kurt Kanzenbach wrote:
> >>> On Mon Oct 19 2020, Christian Eggers wrote:
> >>> The node names should be switch. See dsa.yaml.
> >>>
> >>>> +            compatible = "microchip,ksz9477";
> >>>> +            reg = <0>;
> >>>> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> >>>> +
> >>>> +            spi-max-frequency = <44000000>;
> >>>> +            spi-cpha;
> >>>> +            spi-cpol;
> >>>> +
> >>>> +            ports {
> >>>
> >>> ethernet-ports are preferred.
> >> 
> >> This is backwards to me, instead of an 'ethernet-switch' with 'ports',
> >> we have a 'switch' with 'ethernet-ports'. Whatever.
> >
> > The rationale AFAIR was that dual Ethernet port controllers like TI's 
> > CPSW needed to describe each port as a pseudo Ethernet MAC and using 
> > 'ethernet-ports' as a contained allowed to disambiguate with the 'ports' 
> > container used in display subsystem descriptions.
> 
> Yes, that was the outcome of previous discussions.

And why would that disambiguation be necessary in the first place? My
understanding is that the whole node path provides the necessary
namespacing to avoid the confusion. For example, the 'reg' property
means 100 things to 100 buses, and no one has an issue with that. I am
not expecting an Ethernet switch to have an HDMI port, I might be wrong
though.
