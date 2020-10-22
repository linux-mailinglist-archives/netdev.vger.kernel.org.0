Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E30295CFD
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896737AbgJVKvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896731AbgJVKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:50:18 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D74C0613CF;
        Thu, 22 Oct 2020 03:50:17 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u8so1624665ejg.1;
        Thu, 22 Oct 2020 03:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AqJYgFfxf1zWkOlgQREW7xW14ZLBvpYa1x30aNKm68E=;
        b=pbufEwGlldI/bNKzoAlD6JH/1Kgwp7LL9n0IaPmYRMej2U9bzqt6blEz40JNSaI7Lh
         2O682xKGy0D4TGwYimdte1eCaB73TcXuT/kE3v++8oLlmEb9N9Rm+jz9b9m7ThDmMQ8H
         GRdACCf/1DPz265510ArcI2ZKTPUGthTquqzLZt8UYV/Vl0qgSfAmxkdRjrb6nRNqYBA
         dGUHWDNuShmo3IYCrxndoMPak5+LWmhkl+EwHYH3M0Jvz2Qug22e3q2HCL8e6C1g76E/
         E0OOdFkCaAncynTartJBUe1oObiFSfir4TcxGNpQ7DHArFB0u17w4I0oMi6BXlKUiGoW
         SKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AqJYgFfxf1zWkOlgQREW7xW14ZLBvpYa1x30aNKm68E=;
        b=hn1cvuqNQyfNekRceOuAuZlX2ZfparHjXCcQxAf6+laesjsWgpt1nf36JRh07/Hwuu
         +xQZuLgH01Ine1B4YDjEVn6G8U985dabHYnaDF7v+lEE+B7rh3fWUViD4KnR9/NSVWX1
         AdBqQ/03ivyy24jcs/RwSkPN36hIWZJFcs07ZpygVAKVkMzukEQTidGBoSsyddjETA2q
         apcvQz4AsLNGEYONB+X2Wb5tcZYmCKyNxpuzbnGzMqEquNxYoiPWQRz6NjucdYwNRTGS
         /rnREPVjw335atVO7dAhAV4HCLGN4Pu5G72pCbPw9EpwbxghVOisJd5Wvw0lONch9B7F
         uH/w==
X-Gm-Message-State: AOAM532Ge3IybvfP0dEeW29jy1dREK5BlAZ3RxU+E4nYlcts9L3rV/U5
        JMLhAflRU+y+31nU8wAHvnw=
X-Google-Smtp-Source: ABdhPJxlaNs46tjTA8JqdR82AAN+XEw2zh8WIgYvHXdrCYzojKv7n/lWrrOyKNMRJG16aQh/eLKBXw==
X-Received: by 2002:a17:906:bc57:: with SMTP id s23mr1621953ejv.94.1603363816451;
        Thu, 22 Oct 2020 03:50:16 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id h13sm547472edz.43.2020.10.22.03.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 03:50:15 -0700 (PDT)
Date:   Thu, 22 Oct 2020 13:50:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
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
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201022105014.gflswfpie4qvbw3h@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
 <20201021233935.ocj5dnbdz7t7hleu@skbuf>
 <20201022030217.GA2105@hoboy.vegasvil.org>
 <20201022090126.h64hfnlajqelveku@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022090126.h64hfnlajqelveku@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:01:26PM +0300, Vladimir Oltean wrote:
> On Wed, Oct 21, 2020 at 08:02:17PM -0700, Richard Cochran wrote:
> > On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> > > So how _does_ that work for TI PHYTER?
> > >
> > > As far as we understand, the PHYTER appears to autonomously mangle PTP packets
> > > in the following way:
> > > - subtracting t2 on RX from the correctionField of the Pdelay_Req
> > > - adding t3 on TX to the correctionField of the Pdelay_Resp
> >
> > The Phyter does not support peer-to-peer one step.
> 
> Ok, that's my mistake for not double-checking, sorry.
> 
> > The only driver that implements it is ptp_ines.c.
> >
> > And *that* driver/HW implements it correctly.
> 
> Is there documentation available for this timestamping block? I might be
> missing some data, as the kernel driver is fairly pass-through for the
> TX timestamping of the Pdelay_Resp, so the hardware might just 'do the
> right thing'. I believe the answer lies within the timestamper's
> per-port RX FIFO. Just guessing here, but I suspect that the RX FIFO
> doesn't get cleared immediately after the host queries it, and the
> hardware caches the last 100 events from the pool and uses the RX
> timestamps of Pdelay_Req as t2 in the process of updating the
> correctionField of Pdelay_Resp on TX. Would that be correct?

Ah, no, I think I'm wrong. As per your own description here:
https://lwn.net/Articles/807970/

If the hardware supports p2p one-step, it subtracts the ingress time
stamp value from the Pdelay_Request correction field.  The user space
software stack then simply copies the correction field into the
Pdelay_Response, and on transmission the hardware adds the egress time
stamp into the correction field.

So we were correct about the behavior, just not about the target
hardware.

So, that's just not how this hardware works. What do you recommend?
Keeping a FIFO of Pdelay_Req RX timestamps, and matching them to
Pdelay_Resp messages on TX, all of that contained within tag_ksz.c?
