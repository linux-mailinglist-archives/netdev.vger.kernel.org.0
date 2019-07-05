Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581FD60A0F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfGEQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbfGEQRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 12:17:39 -0400
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2339E2184C;
        Fri,  5 Jul 2019 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562343458;
        bh=H6tDqYKMF/2NaM/h0ZVQVf4oFzxi6+/QKMPx7YhsTuc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o/2F8PIegQp/xme+S+RNN2VC+iDUdh+8g7YcwLhyneP0szxQ0HDCXP+s3GHl3cyE5
         cxNSO5nl6j7sZyFXbBm3QBCukSjo3oIfSNquXjoA7TjBxusW5O1D0IoVotwYesn5UG
         UleL6uRyTX33vHAE2aEngvkkq9UE8a7kcoh6DS2s=
Received: by mail-qk1-f179.google.com with SMTP id d15so8268892qkl.4;
        Fri, 05 Jul 2019 09:17:38 -0700 (PDT)
X-Gm-Message-State: APjAAAVMcOsiFFglFIuyUNVy8mSdCFxqCUG84UbKBo11LT3IVXVbHC+L
        8Ms1OVJC23nKDOk3OVrzZxSOkUpqgNKrY1Msbg==
X-Google-Smtp-Source: APXvYqzgPfHQG2c3ABuTDNT/J6OXfIfQUvkwb422jsFiHK5hWlAEx78SdNgq/woPbH/Pt0ngvXm4oWTd3yxpFXqfkNI=
X-Received: by 2002:a37:6944:: with SMTP id e65mr3476197qkc.119.1562343457359;
 Fri, 05 Jul 2019 09:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190703193724.246854-1-mka@chromium.org> <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
 <20190703213327.GH18473@lunn.ch>
In-Reply-To: <20190703213327.GH18473@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 5 Jul 2019 10:17:16 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+dqz7n0_+Y5R4772-rh=9x=k20A69hnDwxH3OyZXQneQ@mail.gmail.com>
Message-ID: <CAL_Jsq+dqz7n0_+Y5R4772-rh=9x=k20A69hnDwxH3OyZXQneQ@mail.gmail.com>
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

On Wed, Jul 3, 2019 at 3:33 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I think if we're going to have custom properties for phys, we should
> > have a compatible string to at least validate whether the custom
> > properties are even valid for the node.
>
> Hi Rob
>
> What happens with other enumerable busses where a compatible string is
> not used?

We usually have a compatible. USB and PCI both do. Sometimes it is a
defined format based on VID/PID.

> The Ethernet PHY subsystem will ignore the compatible string and load
> the driver which fits the enumeration data. Using the compatible
> string only to get the right YAML validator seems wrong. I would
> prefer adding some other property with a clear name indicates its is
> selecting the validator, and has nothing to do with loading the
> correct driver. And it can then be used as well for USB and PCI
> devices etc.

Just because Linux happens to not use compatible really has nothing to
do with whether or not the nodes should have a compatible. What does
FreeBSD want? U-boot?

I don't follow how adding a validate property would help. It would
need to be 'validate-node-as-a-realtek-phy'. The schema selection is
done for each schema on a node by node basis and has to be based on
some data in the node (or always applied). Using compatible or node
name are just the default way.

Rob
