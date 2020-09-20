Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7552711A1
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 02:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgITAjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 20:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgITAjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 20:39:45 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B9CC061755;
        Sat, 19 Sep 2020 17:39:45 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id p15so5315791qvk.5;
        Sat, 19 Sep 2020 17:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=213PH6EgWk1l6jbeXwi32jF2mR0ZroKqbGXcagQaHzw=;
        b=a9QkbF8dFjqcX59eKlRG8Z8WH7zWXFeGoj5bx89rxeJdrWjolaxA/WFJA4ub69MdY8
         aFKSPB0PwDAD2lLH7u6//rPCU/iTN03un0ZEs+5IcJyJlMQQBfPdRfKXiISP+nK9jFZM
         Oa7Hmk17p24+nwO1mK1y0QtO6jMdiPRjdjDdzsj7DhnauzyDgfPAAbFis0e1JZ7b3qj2
         vBHJ69ZI0t//QofQ10+chFiGupfS8C8uSnn9jaAP3BBO51KDOe6z0g9S4gOP0KvwsetK
         2tWVHjjworsQhuIzfJwxpHz3p6oVRcRyxwPpFI97U9uz5S9gWZqaalPa1pkTReaZX69g
         PmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=213PH6EgWk1l6jbeXwi32jF2mR0ZroKqbGXcagQaHzw=;
        b=QKaAjGcaW+aqIGd5CgJr9frQSFQM2x4AHzOPoDhIV2HTQqE9UHyHAlBGkMIz1dLChg
         5vlmoChJkDL4RlXyZP+c1llogW30e1XLhfWNaNDTmbFZ++Gb5oVROFiQoqTzAGNPFWjP
         oL7TmJIXeINI274SUBb9VYhDhoe7R/z9H8/QyoFoBKmpkBAtSV+cyJxv5rVsBmr2FBQp
         Mf6/10b0BjtoQrl1fsgHVSGp5Uy+2Og2LSNKZLRtP7cB5kxNwa7FWsI4koGFP6LbyvEz
         M7QtpyGa8MBwV+WCvKzIKnf44WSOwGbNLpbMc8mrAiSvVcH1588ftBGWmFHB6PQPNwV+
         Es+g==
X-Gm-Message-State: AOAM531HfjxpFvFxr8KcxPCBVI2tj0d5ee0V1GfbQVI2tiLKA4NsxUBT
        xDNKNR6tk1HVSBhw7v3/Zvc=
X-Google-Smtp-Source: ABdhPJyy+1H3RXGpW2J8hxvDWOoSU38MTeyHVAP8AqmacZJ93UPEZCrIIT/K8LGTEfD6dzBTCst89Q==
X-Received: by 2002:ad4:47cc:: with SMTP id p12mr39319748qvw.25.1600562384041;
        Sat, 19 Sep 2020 17:39:44 -0700 (PDT)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id t10sm5315485qkt.55.2020.09.19.17.39.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Sep 2020 17:39:43 -0700 (PDT)
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
References: <20200919223026.20803-1-ansuelsmth@gmail.com> <20200919223026.20803-5-ansuelsmth@gmail.com> <20200920003128.GC3673389@lunn.ch>
In-Reply-To: <20200920003128.GC3673389@lunn.ch>
Subject: R: [PATCH v2 4/4] dt-bindings: net: Document use of mac-address-increment
Date:   Sun, 20 Sep 2020 02:39:39 +0200
Message-ID: <006301d68ee6$87fcc400$97f64c00$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJTwTIROpBsKHcYsKMkb8exrd/FtgHUg4PZAkc+4zCoVWtPAA==
Content-Language: it
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Messaggio originale-----
> Da: Andrew Lunn <andrew@lunn.ch>
> Inviato: domenica 20 settembre 2020 02:31
> A: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>; Richard Weinberger
> <richard@nod.at>; Vignesh Raghavendra <vigneshr@ti.com>; Rob Herring
> <robh+dt@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Heiner Kallweit <hkallweit1@gmail.com>;
> Russell King <linux@armlinux.org.uk>; Frank Rowand
> <frowand.list@gmail.com>; Boris Brezillon <bbrezillon@kernel.org>; linux-
> mtd@lists.infradead.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Oggetto: Re: [PATCH v2 4/4] dt-bindings: net: Document use of mac-
> address-increment
> 
> > +  mac-address-increment:
> > +    description:
> > +      The MAC address can optionally be increased (or decreased using
> > +      negative values) from the original value readed (from a nvmem
cell
> 
> Read is irregular, there is no readed, just read.
> 
> > +      for example). This can be used if the mac is readed from a
dedicated
> > +      partition and must be increased based on the number of device
> > +      present in the system.
> 
> You should probably add there is no underflow/overflow to other bytes
> of the MAC address. 00:01:02:03:04:ff + 1 == 00:01:02:03:04:00.
> 
> > +    minimum: -255
> > +    maximum: 255
> > +
> > +  mac-address-increment-byte:
> > +    description:
> > +      If 'mac-address-increment' is defined, this will tell what byte
of
> > +      the mac-address will be increased. If 'mac-address-increment' is
> > +      not defined, this option will do nothing.
> > +    default: 5
> > +    minimum: 0
> > +    maximum: 5
> 
> Is there a real need for this? A value of 0 seems like a bad idea,
> since a unicast address could easily become a multicast address, which
> is not valid for an interface address. It also does not seem like a
> good idea to allow the OUI to be changed. So i think only bytes 3-5
> should be allowed, but even then, i don't think this is needed, unless
> you do have a clear use case.
> 
>     Andrew

Honestly the mac-address-increment-byte is added to give user some control
but I
don't really have a use case for it. Should I limit it to 3 or just remove
the function?
Will address the other 2 comment in v3.
Thx for review.

