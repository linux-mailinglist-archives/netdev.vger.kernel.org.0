Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3129556D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507419AbgJVAQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507390AbgJVAQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 20:16:43 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75443C0613CE;
        Wed, 21 Oct 2020 17:16:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id t25so5725001ejd.13;
        Wed, 21 Oct 2020 17:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7b2u20oLzpg5xmAK+uboOrAZqd6ZJqxePLoN4+CIlJo=;
        b=F1Z+pBO+HHWdKgWOUyNMIX9FcvSi9R/EvzqVBDLeMeJRxYdPs2Yf20HaBrNmGzautS
         cwLoJr1DXi5N69PCmZhIrxXXdbg9jI0ALeR8ldsERvEADOh+kpLq5E2mz6fDh05SGeMw
         mqk2KAHNtv06U9vCWYdrZqw/LSRe5v53POgGkvERFAtpfzLdp2vzoXqf5PcROBjRmYD4
         JZZGlNzqh+C6P3e7iV0XITUV6Sgx474irZhJ5LLdbeurfKDSHSffVhW3V0zWjWwYpkBQ
         dsY86wBT2EyYdsd2AIqgPNAwHLHstpxBi3fIfx+dZCNbFhMyLQR+aygqUR83WYxos9D4
         gyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7b2u20oLzpg5xmAK+uboOrAZqd6ZJqxePLoN4+CIlJo=;
        b=IfYygW/4jH8eFNTYTEzR4LyP+n8g8Mm3+A1sSCfnorifx49WtY1dlrhkvyiNPF+FUe
         QJ3alB95TM/4MFsJOB2cpeM3xFh5kHgkt/VwySo7Z9DE7G/HyOKD7esVqr5nIuEhmMKE
         +KVZXjSKaJETg9DqFQRVGWXXqLHO0zFYDs97IjlGYisfxyeDKYovWnd94+UmKmj32Phx
         AUz4Y21CINa4ymMtxlEjBLiPX6xsfzun1MXa8eB80PhWPszsojvRfDaBM6MG+Y1zxew1
         8gI1hTgUgOhWv/4olKs+hO0dJhaLDBifMhUgxs9hPRqMX690VV7EcB6JaZXMuCYTPK/o
         FIkg==
X-Gm-Message-State: AOAM533r4Z0ueQmbQ/EcVzX26byoYqRnAfo8i9PVKK90aaGc9bs9/Fop
        fbwg59mD5soZvswB7Z34oyU=
X-Google-Smtp-Source: ABdhPJwcQwIDkW+sZoPbYSiYr6zhbCieIzNCaCk5TpAGDifLXmyu7L8gx1ZdNrYVX8jCw1vo8ot5sQ==
X-Received: by 2002:a17:907:2041:: with SMTP id pg1mr5911132ejb.321.1603325802173;
        Wed, 21 Oct 2020 17:16:42 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id g18sm2926116eje.12.2020.10.21.17.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 17:16:41 -0700 (PDT)
Date:   Thu, 22 Oct 2020 03:16:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Christian Eggers <ceggers@arri.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20201022001639.ozbfnyc4j2zlysff@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-2-ceggers@arri.de>
 <87lfg0rrzi.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfg0rrzi.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 08:52:01AM +0200, Kurt Kanzenbach wrote:
> On Mon Oct 19 2020, Christian Eggers wrote:
> The node names should be switch. See dsa.yaml.
> 
> > +            compatible = "microchip,ksz9477";
> > +            reg = <0>;
> > +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> > +
> > +            spi-max-frequency = <44000000>;
> > +            spi-cpha;
> > +            spi-cpol;
> > +
> > +            ports {
> 
> ethernet-ports are preferred.

This is backwards to me, instead of an 'ethernet-switch' with 'ports',
we have a 'switch' with 'ethernet-ports'. Whatever.
