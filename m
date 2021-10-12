Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743A842A9D8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhJLQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhJLQqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEAB610C7;
        Tue, 12 Oct 2021 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634057077;
        bh=KeX+BG4wAcsB9J5AKsMPYn5iNld2NIip98TVnq2Z0WM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bzqNCCj15wa0+D8MWLENv52AaNWC1A/NPf/sILxVwYOLC3MRs10VSb2xs6zhaD4M1
         x2pdMr2wT5BQyhfR3MSCGEajP+zN+WFxlVKVozq2dcUfA2RXL4+3F4vTdbg/NLimSr
         qLhb6tGLi4JBTn2q4hSPLlJBdOfh6PhKN9Z9KkHGSC+2q6FfX1EzQ/e1TA9TzBwY/b
         KnGKSkw0HUk4DZ5n3CySDkvjah0KKgNStnapHXbCGKFeZ5LhBSANu+M4ckiIe6A7Su
         uP2CV2g8PxpSosVJAtJEfmGi759V13bqC6Dn2tYDpDJNcxjuW341KICuRw0h725V/p
         Ekn5szpAmzzYA==
Received: by mail-ed1-f51.google.com with SMTP id r18so1776361edv.12;
        Tue, 12 Oct 2021 09:44:37 -0700 (PDT)
X-Gm-Message-State: AOAM531lou5G5Rn9peUsQtvZ1v96B9UXdRp1u/1PIKAAthq1xhZ8diDQ
        XgxBA0VLTYC/CmiQqYEfqV2f79UsuW9s6rNy1Q==
X-Google-Smtp-Source: ABdhPJwqVR2jSft1mVnG3jdDc3khbpgABAtQS3jjxS6wPg6456KrVt92ooA7hgnvi21CRcYK35xXx5mEk5b+0PZHFGo=
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr35736927ejc.84.1634057075915;
 Tue, 12 Oct 2021 09:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com> <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
 <YWWKuhn4FfgbcqO/@robh.at.kernel.org> <2e5ebf4e-bc97-1b8b-02e2-fe455aa1c100@seco.com>
In-Reply-To: <2e5ebf4e-bc97-1b8b-02e2-fe455aa1c100@seco.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 12 Oct 2021 11:44:23 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+MAy8CRjLvqAg5oC53=ZO2UZcH_s0kMnaYD8M+y8+dLw@mail.gmail.com>
Message-ID: <CAL_Jsq+MAy8CRjLvqAg5oC53=ZO2UZcH_s0kMnaYD8M+y8+dLw@mail.gmail.com>
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 11:18 AM Sean Anderson <sean.anderson@seco.com> wrote:
>
> Hi Rob,
>
> On 10/12/21 9:16 AM, Rob Herring wrote:
> > On Tue, Oct 05, 2021 at 10:39:36AM +0100, Russell King (Oracle) wrote:
> >> On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
> >> > Add a property for associating PCS devices with ethernet controllers.
> >> > Because PCS has no generic analogue like PHY, I have left off the
> >> > -handle suffix.
> >>
> >> For PHYs, we used to have phy and phy-device as property names, but the
> >> modern name is "phy-handle". I think we should do the same here, so I
> >> would suggest using "pcs-handle".
> >
> > On 1G and up ethernet, we have 2 PHYs. There's the external (typically)
> > ethernet PHY which is what the above properties are for. Then there's
> > the on-chip serdes PHY similar to SATA, PCIe, etc. which includes the
> > PCS part. For this part, we should use the generic PHY binding. I think
> > we already have bindings doing that.
>
> In the 802.3 models, there are several components which convert between
> the MII (from the MAC) and the MDI (the physical protocol on the wire).
> These are the Physical Coding Sublayer (PCS), Physical Medium Attachment
> (PMA) sublayer, and Physical Medium Dependent (PMD) sublayer. The PMD
> converts between the physical layer signaling and the on-chip (or
> on-board) signalling. The PMA performs clock recovery and converts the
> serial data from the PMD into parallel data for the PCS. The PCS handles
> autonegotiation, CSMA/CD, and conversion to the apripriate MII for
> communicating with the MAC.
>
> In the above model, generic serdes devices generally correspond to the
> PMA/PMD sublayers. The PCS is generally a separate device, both
> on the hardware and software level. It provides an ethernet-specific
> layer on top of the more generic underlying encoding. For this reason,
> the PCS should be modeled as its own device, which may then contain a
> reference to the appropriate serdes.

On the h/w I've worked on, PCS was an additional block instantiated
within the PHY, so it looked like one block to s/w. But that's been
almost 10 years ago now.

If you do have 2 h/w blocks, one option is doing something like this:

phys = <&pcs_phy>, <&sgmii_phy>;

I'm okay with 'pcs-handle', but just want to make sure we're not using
it where 'phys' would work.

> The above model describes physical layers such as 1000BASE-X or
> 10GBASE-X where the PCS/PMA/PMD is the last layer before the physical
> medium. In that case, the PCS could be modeled as a traditional PHY.
> However, when using (e.g.) SGMII, it is common for the "MDI" to be
> SGMII, and for another PHY to convert to 1000BASE-T. To model this
> correctly, the PCS/PMA/PMD layer must be considered independently from
> the PHY which will ultimately convert the MII to the MDI.
