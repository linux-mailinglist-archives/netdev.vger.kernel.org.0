Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90724271339
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgITJpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:45:16 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF82C061755;
        Sun, 20 Sep 2020 02:45:16 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id j3so5740864qvi.7;
        Sun, 20 Sep 2020 02:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=bI+KOrtm+DSOj1ybD5+aMPXLAeGAqLLQ4CXe7B48ZTE=;
        b=NxAC5HjLQiiQOxYG1GSo4Va4sls7g1uaLOZZTDnvfUHeEzmqLO0BYQKz1TLdRixF3E
         KbeMAmB3eCmXKcWTICE0OGJZrOpxm8DglmaSkqQzVoipcIbiO5ReHxTAyBhgg+iOs9zy
         H7aMX0gyIxbIusGhjGvyD+tJKqezSxj50OGbo544PUDnOD+entJF548NRPSMCbT/Oyhq
         oqzMY9cO6zakK6R2FVd//CwE3Tx+1YLTFk/syGN2r6Mq0VxoeN6mXKtRpJzXyXGE1X8B
         ds5hzde/kJ6sdRDk9mT/SanfRkT4mBzMtp9q4Tu3KvaovtT2dzMyASKRsTFbKHCTFfPR
         MXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=bI+KOrtm+DSOj1ybD5+aMPXLAeGAqLLQ4CXe7B48ZTE=;
        b=n8StgzuvedLKtEnktbROVhpuRtW+v7cO51LJ50ui8mLtOozsglv1rLzMVnMGKX/F0N
         gL6rQftvRms0jCKuxQEKknW33IsObjDVfL1RUB1QvqX0l/XneUJpjcfnO9pbKmyOvn6B
         t5P8X+v9xD4x7NEE6bYx7w3Py3uhjmi2oVPOd5R4cN23F+2BnPN7Yh8WSbuW/tkWamci
         RdpLeeeEFG1G5uIaJO+nRRcFImoSVqmdMGHJw6vzK2/GxCNYhPi3s8sxkn6wE5yjtv0F
         +5ZW8XUDOEROuGAVQ6HEjvkLzwRcAUIBKpPtyHzeHgNEKIa4pkOYrj+qwmzJfA1JUnUT
         m8OQ==
X-Gm-Message-State: AOAM531l62iDKsUtO21z1nhU2Xe4zoJbqsmzpXBzrZz3nTxJ38XS+MYe
        c44epIe6MsFQPZXgfFUP5tO1EQ39TOvGtg==
X-Google-Smtp-Source: ABdhPJydcBHGJIrOrtEfrenLSKbouJBsnyeBUGfdfMaMGB5KmQOskprwcIhcZLog9QuzQ3/4vEGcdQ==
X-Received: by 2002:a0c:9a01:: with SMTP id p1mr24371120qvd.61.1600595115198;
        Sun, 20 Sep 2020 02:45:15 -0700 (PDT)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id n144sm6257632qkn.69.2020.09.20.02.45.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 02:45:14 -0700 (PDT)
From:   <ansuelsmth@gmail.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Miquel Raynal'" <miquel.raynal@bootlin.com>,
        "'Richard Weinberger'" <richard@nod.at>,
        "'Vignesh Raghavendra'" <vigneshr@ti.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'Russell King'" <linux@armlinux.org.uk>,
        "'Frank Rowand'" <frowand.list@gmail.com>,
        "'Boris Brezillon'" <bbrezillon@kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200919223026.20803-1-ansuelsmth@gmail.com> <20200919223026.20803-5-ansuelsmth@gmail.com> <20200920003128.GC3673389@lunn.ch> <006301d68ee6$87fcc400$97f64c00$@gmail.com> <20200920012216.GE3673389@lunn.ch>
In-Reply-To: <20200920012216.GE3673389@lunn.ch>
Subject: RE: R: [PATCH v2 4/4] dt-bindings: net: Document use of mac-address-increment
Date:   Sun, 20 Sep 2020 11:45:08 +0200
Message-ID: <002a01d68f32$bc737bb0$355a7310$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJTwTIROpBsKHcYsKMkb8exrd/FtgHUg4PZAkc+4zACC3fAJQJmQYzGqDJ2ekA=
Content-Language: it
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sun, Sep 20, 2020 at 02:39:39AM +0200, ansuelsmth@gmail.com
> wrote:
> >
> >
> > > -----Messaggio originale-----
> > > Da: Andrew Lunn <andrew@lunn.ch>
> > > Inviato: domenica 20 settembre 2020 02:31
> > > A: Ansuel Smith <ansuelsmth@gmail.com>
> > > Cc: Miquel Raynal <miquel.raynal@bootlin.com>; Richard Weinberger
> > > <richard@nod.at>; Vignesh Raghavendra <vigneshr@ti.com>; Rob
> Herring
> > > <robh+dt@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub
> > > Kicinski <kuba@kernel.org>; Heiner Kallweit <hkallweit1@gmail.com>;
> > > Russell King <linux@armlinux.org.uk>; Frank Rowand
> > > <frowand.list@gmail.com>; Boris Brezillon <bbrezillon@kernel.org>;
> linux-
> > > mtd@lists.infradead.org; devicetree@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Oggetto: Re: [PATCH v2 4/4] dt-bindings: net: Document use of mac-
> > > address-increment
> > >
> > > > +  mac-address-increment:
> > > > +    description:
> > > > +      The MAC address can optionally be increased (or decreased
using
> > > > +      negative values) from the original value readed (from a nvmem
> > cell
> > >
> > > Read is irregular, there is no readed, just read.
> > >
> > > > +      for example). This can be used if the mac is readed from a
> > dedicated
> > > > +      partition and must be increased based on the number of device
> > > > +      present in the system.
> > >
> > > You should probably add there is no underflow/overflow to other bytes
> > > of the MAC address. 00:01:02:03:04:ff + 1 == 00:01:02:03:04:00.
> > >
> > > > +    minimum: -255
> > > > +    maximum: 255
> > > > +
> > > > +  mac-address-increment-byte:
> > > > +    description:
> > > > +      If 'mac-address-increment' is defined, this will tell what
byte
> > of
> > > > +      the mac-address will be increased. If 'mac-address-increment'
is
> > > > +      not defined, this option will do nothing.
> > > > +    default: 5
> > > > +    minimum: 0
> > > > +    maximum: 5
> > >
> > > Is there a real need for this? A value of 0 seems like a bad idea,
> > > since a unicast address could easily become a multicast address, which
> > > is not valid for an interface address. It also does not seem like a
> > > good idea to allow the OUI to be changed. So i think only bytes 3-5
> > > should be allowed, but even then, i don't think this is needed, unless
> > > you do have a clear use case.
> > >
> > >     Andrew
> >
> > Honestly the mac-address-increment-byte is added to give user some
> control
> > but I
> > don't really have a use case for it. Should I limit it to 3 or just
remove
> > the function?
> 
> If you have no use case, just remove it and document that last byte
> will be incremented. I somebody does need it, it can be added in a
> backwards compatible way.
> 
>      Andrew

I just rechecked mac-address-increment-byte and we have one device that
use it and would benefits from this.  I will change the Documentation to
min 3 and leave it.

