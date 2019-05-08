Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564C117474
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfEHJCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 05:02:09 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:35043 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfEHJCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 05:02:08 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 802DD4819;
        Wed,  8 May 2019 11:02:05 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 87e01008;
        Wed, 8 May 2019 11:02:04 +0200 (CEST)
Date:   Wed, 8 May 2019 11:02:04 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>
Subject: Re: [PATCH v2 1/4] of_net: Add NVMEM support to of_get_mac_address
Message-ID: <20190508090204.GN81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-2-git-send-email-ynezz@true.cz>
 <20190501201925.GA15495@bogus>
 <20190502090538.GD346@meh.true.cz>
 <CAL_JsqKLgEjgDOHaNHbu7Bqw1gYCBMRcdO_S98nASnCxtinZ=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKLgEjgDOHaNHbu7Bqw1gYCBMRcdO_S98nASnCxtinZ=g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh@kernel.org> [2019-05-07 11:06:43]:

Hi,

> > Honestly I don't know if it's necessary to have it, but so far address,
> > mac-address and local-mac-address properties provide this DT nodes, so I've
> > simply thought, that it would be good to have it for MAC address from NVMEM as
> > well in order to stay consistent.
> 
> If you want to be consistent, then fill in 'local-mac-address' with
> the value from nvmem. We don't need the same thing with a new name
> added to DT. (TBC, I'm not suggesting you do that here.)

Ok, got it.

> But really, my point with using devm_kzalloc() is just return the
> data, not store in DT and free it when the driver unbinds. 

Ok, I've simply misunderstood your point, sorry, I'll handle it in the follow
up fix series, along with the DT documentation update.

> Allocating it with devm_kzalloc AND adding it to DT as you've done in v4
> leads to 2 entities refcounting the allocation. If the driver unbinds, the
> buffer is freed, but DT code is still referencing that memory.

Indeed, I did it wrong, will fix that.

> 'nvmem-mac-address' is not a documented property. That would need to
> be documented before using upstream. Though, for reasons above, I
> don't think it should be.

Ok, it makes sense now. Thanks for the detailed explanation.

-- ynezz
