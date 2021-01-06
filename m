Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434B2EC1E6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbhAFRQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbhAFRQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:16:44 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB8BC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 09:16:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u19so5125431edx.2
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 09:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DyD8tstrMMc5XKutiJ2Mx/Pmhmh9xEbsr81ZqRpVT1E=;
        b=l2+M+HwfUElLzBrUVjAbCWhwrCDZnPTuLSlV/UE93XSeu5gTfEWqhWmJnhB4gwtFYy
         L4Tj5MC5cb3aHPLM8gPMGoTayLtELLlYY6X2JYmVb0qi+sxeRln6W2AFWNM1rRpkwxrD
         pddeSmN/ac4b3AROgpIdxeOf29H3YvQiKylzOvpOvkPUlxMThImW1CrpYHAdrfiIzn23
         L36V2J/n0HAeeyJzqNOnmcuGNZG/laItCNUQejnOvqziGXs5UUPsyi1nhnax22hF7ovy
         X6jVCGj5LFUbduPCValsOC4sjiKMPN++hUl4nPOBjuxnMIHHlhMfEHxw5eZHpSEwdjVO
         r56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DyD8tstrMMc5XKutiJ2Mx/Pmhmh9xEbsr81ZqRpVT1E=;
        b=Vjcb7DF5m1PrbL93brIECJ0gV4ol7wmM75bpiL6KeJQhBG6r5tAp0gbxXYp9Tk+5rR
         rIGXlwApFo/q7Lrk6L6hRJf778beFm6mmBPDLzzU7OHrg1SNAzySAQqHwQ8+JZm/TuvW
         4UEnXns5Fx3vhsgetzj2ftHMdN+iTHIi4y/D9ICBhpdhZWH8nOTZ+FFOknP9OUbZHWTl
         8mb1sLXNxYVrO2QxvyrRMK26ew86TPlAYgzsTzrefS1Zgy4PslzZRs7cE1Ihx2sOMUfO
         bCTmAzu3MbO74abYqDAE99yRf/bTODVseTAFZSUEetgM7Bb/dXiBDifq/5sokxUfxNKh
         I9dA==
X-Gm-Message-State: AOAM5333hio/1RjAvvuFe9cR8nQ1TuCjrpELBrvGWL6zENPf2d8Luseu
        oZD385JKe0eTCOS8XaNqQRs=
X-Google-Smtp-Source: ABdhPJwY6xkRqfF+/g76PbL9aoWgYkkvRB5ywZrVyPTeFDl0bdpeElbvcDBkcJxYQkhFs5/L+sYgEA==
X-Received: by 2002:a50:d2c8:: with SMTP id q8mr4324484edg.375.1609953362366;
        Wed, 06 Jan 2021 09:16:02 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d22sm1503825eja.72.2021.01.06.09.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:16:01 -0800 (PST)
Date:   Wed, 6 Jan 2021 19:15:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 01/10] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
Message-ID: <20210106171559.abu2jffskjsry77b@skbuf>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-2-olteanv@gmail.com>
 <20210106170818.GA1080217@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106170818.GA1080217@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 07:08:18PM +0200, Ido Schimmel wrote:
> On Wed, Jan 06, 2021 at 03:09:57PM +0200, Vladimir Oltean wrote:
> > Let's go off and finish the job of commit 29ab586c3d83 by deleting the
> > bogus iteration through the VLAN ranges from the drivers. Some aspects
> > of this feature never made too much sense in the first place. For
> > example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
> > flag supposed to mean, when a port can obviously have a single pvid? The
> > switchdev drivers have so far interpreted this to mean that the last
> > VLAN in the range should be the only one which should get programmed
> > with that attribute.
> 
> See commit 6623c60dc28e ("bridge: vlan: enforce no pvid flag in vlan
> ranges")

No, I agree, but still it changes nothing in terms of the hoops that a
driver must go through. It should still only program vlan->vid_end as
pvid either way. Which is strikingly odd.

> > Of the existing switchdev pieces of hardware, it appears that only
> > Mellanox Spectrum supports offloading more than one VLAN at a time.
> > I have kept that code internal to the driver, because there is some more
> > bookkeeping that makes use of it, but I deleted it from the switchdev
> > API. But since the switchdev support for ranges has already been de
> > facto deleted by a Mellanox employee and nobody noticed for 4 years, I'm
> > going to assume it's not a biggie.
> 
> Which code are you referring to?

mlxsw_sp_port_vlan_set

> For the switchdev and mlxsw parts:
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> 
> I applied the series to our queue, so I should have regression results
> tomorrow

Thanks. Could you wait for me to send a v3 though, with that small fixup
in mv88e6xxx? I'm sure it will raise some red flags for your testing too.
