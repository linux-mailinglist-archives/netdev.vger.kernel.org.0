Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25BF4AA59D
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 03:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378945AbiBECSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 21:18:43 -0500
Received: from mail-oo1-f48.google.com ([209.85.161.48]:45670 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378927AbiBECSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 21:18:42 -0500
Received: by mail-oo1-f48.google.com with SMTP id u25-20020a4ad0d9000000b002e8d4370689so6732467oor.12;
        Fri, 04 Feb 2022 18:18:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dh+lEqNlO5YoCM8DAnReukIGw+hgF+pQdL2dapiz1tw=;
        b=KQezzCuYBAqkqb+jut4BySf55xuoCZGl4ECzYUqKUdwAAVEq6xjLQB1tarR4rxoHof
         ySTn9A84nJOrhtQsWxt8IgELQ1CSc+oofEokf20PVv+IBwIX0NsKVtFtK+FVMCFAv/nR
         XthWser9qqDgbSTg8UzVYmBaGrfgn45ogGqzNVzgzljvoCKJ27IZhpAAtRz4Slkqzlh4
         sTZxQ7AcrXMO+s/l3MN0cfBIqNoxrt4frkgmUQZg1XI8vbO0gWNcZKC52oQXVNYNF2M6
         sXc+wM34q7NI2gbjKkxLQ0Uqob0MHbgUIspu/sNUcBQtZcQNp+bWKN4+RHbGUsO8Z+By
         fyxg==
X-Gm-Message-State: AOAM533O7Kma0BLSs/smvVwGoFlaT3RxwZIPNedIC3nBfQuaTY3c0iNF
        0XForOKyE/wvaTfJ0maQ4g==
X-Google-Smtp-Source: ABdhPJzVNBt81cbdJTvk5Ro3frSpSh5Zi976G6ToD+gWG8jKQFJyo6E99hWEtAccWCoNG6CR6ss2dw==
X-Received: by 2002:a05:6870:37c5:: with SMTP id p5mr1411350oai.252.1644027522457;
        Fri, 04 Feb 2022 18:18:42 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id h9sm1425584otk.42.2022.02.04.18.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 18:18:41 -0800 (PST)
Received: (nullmailer pid 3624417 invoked by uid 1000);
        Sat, 05 Feb 2022 02:18:40 -0000
Date:   Fri, 4 Feb 2022 20:18:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <Yf3egEVYyyXUkklM@robh.at.kernel.org>
References: <20220119131117.30245-1-kabel@kernel.org>
 <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 11:18:09AM -0800, Florian Fainelli wrote:
> On 1/19/22 5:11 AM, Marek Behún wrote:
> > Common PHYs and network PCSes often have the possibility to specify
> > peak-to-peak voltage on the differential pair - the default voltage
> > sometimes needs to be changed for a particular board.
> > 
> > Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> > purpose. The second property is needed to specify the mode for the
> > corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> > is to be used only for speficic mode. More voltage-mode pairs can be
> > specified.
> > 
> > Example usage with only one voltage (it will be used for all supported
> > PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> > case):
> > 
> >   tx-p2p-microvolt = <915000>;
> > 
> > Example usage with voltages for multiple modes:
> > 
> >   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
> >   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> > 
> > Add these properties into a separate file phy/transmit-amplitude.yaml,
> > which should be referenced by any binding that uses it.
> 
> p2p commonly means peer to peer which incidentally could be confusing,
> can you spell out the property entire:
> 
> tx-peaktopeak-microvolt or:
> 
> tx-pk2pk-microvolt for a more compact name maybe?

Peer to peer makes little sense in terms of a voltage. I think this is 
fine as-is.

Rob
