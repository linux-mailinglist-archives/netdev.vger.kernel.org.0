Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2EA60ABC
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfGERHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfGERHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 13:07:43 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7438E2184C;
        Fri,  5 Jul 2019 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562346462;
        bh=OZxT04gFLaytkGm/DzGBYCBCGqk5NGXSEVy2rS3EiwI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cL1wObRoQenEIXsCCKDarEPhPCAIkA44+i28Z4Iwx050I/EAAm3u/7u7xuHLnObdI
         ZU+TI07MpefFoZRe1d4xMc5kGx6FJr1p8BDAYGn46woqrkYBlEC85vbgHFzMHO8Vok
         NYLz4M8AaxPGX0zlpAmVfjD/GXa4Py27Czdb4BiI=
Received: by mail-qt1-f180.google.com with SMTP id l9so3548318qtu.6;
        Fri, 05 Jul 2019 10:07:42 -0700 (PDT)
X-Gm-Message-State: APjAAAUtqXHCK9RNtUBzCxP/6rBRdZ182qN9hCSGHTblXkusGrDnhY0/
        +jFwyrrkz6uEezXyMZ14QHbj0JULIgCs77h5Ig==
X-Google-Smtp-Source: APXvYqzRPnqHPiK5FtXZdlxd9J+MzOxznX+s3EKmFaJzKSLY3lHZQBXNK8cSmAjCk9VbXcP6xQOkNISe2GnXfNFemLc=
X-Received: by 2002:ac8:36b9:: with SMTP id a54mr3646411qtc.300.1562346461718;
 Fri, 05 Jul 2019 10:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190703193724.246854-1-mka@chromium.org> <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
 <20190703213327.GH18473@lunn.ch> <CAL_Jsq+dqz7n0_+Y5R4772-rh=9x=k20A69hnDwxH3OyZXQneQ@mail.gmail.com>
 <20190705162926.GM18473@lunn.ch>
In-Reply-To: <20190705162926.GM18473@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 5 Jul 2019 11:07:29 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+bS5qAGhFa0q5sjOaajokDoO-5yc23MkrrCE=Y-jt=ZQ@mail.gmail.com>
Message-ID: <CAL_Jsq+bS5qAGhFa0q5sjOaajokDoO-5yc23MkrrCE=Y-jt=ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 10:29 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Jul 05, 2019 at 10:17:16AM -0600, Rob Herring wrote:
> > On Wed, Jul 3, 2019 at 3:33 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > I think if we're going to have custom properties for phys, we should
> > > > have a compatible string to at least validate whether the custom
> > > > properties are even valid for the node.
> > >
> > > Hi Rob
> > >
> > > What happens with other enumerable busses where a compatible string is
> > > not used?
> >
> > We usually have a compatible. USB and PCI both do. Sometimes it is a
> > defined format based on VID/PID.
>
> Hi Rob
>
> Is it defined what to do with this compatible? Just totally ignore it?
> Validate it against the hardware and warning if it is wrong? Force
> load the driver that implements the compatible, even thought bus
> enumeration says it is the wrong driver?

The short answer is either the problems get fixed or if DTs exist and
need to be supported which are wrong then the OS deals with the
problem to make things work as desired (see PowerMac code).

If the ethernet phy subsystem wants to ignore compatible, that is totally fine.

> > > The Ethernet PHY subsystem will ignore the compatible string and load
> > > the driver which fits the enumeration data. Using the compatible
> > > string only to get the right YAML validator seems wrong. I would
> > > prefer adding some other property with a clear name indicates its is
> > > selecting the validator, and has nothing to do with loading the
> > > correct driver. And it can then be used as well for USB and PCI
> > > devices etc.
> >
> > Just because Linux happens to not use compatible really has nothing to
> > do with whether or not the nodes should have a compatible. What does
> > FreeBSD want? U-boot?
> >
> > I don't follow how adding a validate property would help. It would
> > need to be 'validate-node-as-a-realtek-phy'.
>
> This makes it clear it is all about validating the DT, and nothing
> about the actual running hardware. What i don't really want to see is
> the poorly defined situation that DT contains a compatible string, but
> we have no idea what it is actually used for. See the question above.

What's poorly defined are the current bindings, type definitions of
properties, and what properties are valid or not in specific nodes. If
we only had to better define the rules around compatible use or
mismatches, we'd be a lot better off.

I'm not going to add properties solely for validation when we already
have a well defined, 15 year+ pattern for defining what a node
contains that practically every other subsystem and node uses. I guess
we just won't worry about validating ethernet phy nodes beyond some
basic checks.

Rob
