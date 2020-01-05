Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43B1130A9F
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgAEW6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:58:23 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39002 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAEW6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:58:22 -0500
Received: by mail-ed1-f67.google.com with SMTP id t17so46049394eds.6
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 14:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8km+lSvTKp3RhaRszEhht8i869ACG11++UL7vOhjhhw=;
        b=sqJA2YgPvmUxiF0uEtRp15Tx6pMA05s401ZoBjEF5rBgpDsDQu19Yafhyoj+sirtDb
         cuX/oM/ZogxWQekSEx0iA4pB1KRxq6+y4fHKr4CgRT1UmEq1rEbewt6FBfN6wMlHVRjq
         wUwMT78LecbO9BKUPxd0iIyrr7bJTrVnCtWqEuM6qRxcJS4TW3H0BX40q7kBAtbwXWgf
         prXoxFiagTKce9c3/FNdrSsJFHnm9h8WzD+/xchcbBmT7CvZzJu9S8cMBVGRP5oGMCmr
         0Cc/TvLqC3otNLbSeIAy3JyNc+CdVMQRB3Pl05n969hlcEuSVwJzw+NVycWHKpGD8SYZ
         BU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8km+lSvTKp3RhaRszEhht8i869ACG11++UL7vOhjhhw=;
        b=Zr14y+ALxsPx/tUnaSs7Mui1kTGzQynVkaCNHvPUENfMpXpwIbYWxuYyl2rb02tFtF
         /rODjOrbqHvhHB2E4sHrpPtfL+QcF4QnU0w7ozeU36UlFp8Q54bxKL7Wuhstx6M1BHqW
         LtuKzhyR9jda6aFtt94fIfb6iGZvc99iswtlMHqg6O2GS2uWIlGJ9N8BQvcZB5JDG6XP
         p7BOqzaRgZ2G0obInRNCWPA1LZF6aHuvwJ2MRYQkbrI52wHYKLl5tKzjmSt2OzX3I2cP
         rw+Y2HOsTWg+ak5u/39TEULea4ahagkkXGafr+E7cPKfW19eWkuhM/9i9VDa8ccMu+O5
         4f3Q==
X-Gm-Message-State: APjAAAUR0ZDLyP9EFvor8+SZq/LaTIeuNTCaP77AGAV339xT7DZyO/ND
        DVFSAKnU7gno2QWf2PyB5hxPGZ+taLlQfu1lYXg=
X-Google-Smtp-Source: APXvYqxxUTCtCfYdFldVzRZTm/XL8VP2aRt7Ql+RIdY5snZmn5ILJSvej0mGoU0uFiYQGv8zzioo4o2WE2NBvu9kdQo=
X-Received: by 2002:aa7:cccf:: with SMTP id y15mr104092844edt.108.1578265101282;
 Sun, 05 Jan 2020 14:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20200103200127.6331-1-olteanv@gmail.com> <20200105.145620.1374612953471751229.davem@davemloft.net>
In-Reply-To: <20200105.145620.1374612953471751229.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 6 Jan 2020 00:58:10 +0200
Message-ID: <CA+h21hoqE2RxsmUUoS6DKYZMMnfHRVf1S9dw3jHsHvNnxGjqgw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 0/9] Convert Felix DSA switch to PHYLINK
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jan 2020 at 00:56, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Fri,  3 Jan 2020 22:01:18 +0200
>
> > Unlike most other conversions, this one is not by far a trivial one, and should
> > be seen as "Layerscape PCS meets PHYLINK". Actually, the PCS doesn't
> > need a lot of hand-holding and most of our other devices 'just work'
> > (this one included) without any sort of operating system awareness, just
> > an initialization procedure done typically in the bootloader.
> > Our issues start when the PCS stops from "just working", and that is
> > where PHYLINK comes in handy.
> >
> > The PCS is not specific to the Vitesse / Microsemi / Microchip switching core
> > at all. Variations of this SerDes/PCS design can also be found on DPAA1 and
> > DPAA2 hardware.
> >
> > The main idea of the abstraction provided is that the PCS looks so much like a
> > PHY device, that we model it as an actual PHY device and run the generic PHY
> > functions on it, where appropriate.
>  ...
>
> Series applied, please address any follow-up feedback you receive.
>
> Thank you.

Thanks David, sure, ready for action.

-Vladimir
