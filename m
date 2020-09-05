Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1625E5E3
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 08:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgIEGya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 02:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgIEGy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 02:54:29 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A7AC061244;
        Fri,  4 Sep 2020 23:54:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c19so8826228wmd.1;
        Fri, 04 Sep 2020 23:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kvYXN84wde1jlinAnF1ZcIYTFqYeHdrpYuFHUVhFm0g=;
        b=usc1oNoHgDNG5tf2zCPfwMCO5CgyBslue6TggjJa1/Xfuuu11eRz5jWEQdWkTRNVBO
         o1Azzctwf2vnLYCa1i59QHjP1fpX4od6K1gL9XgAsmwq5kCg0p0FHA73hiSkpmZ3VYqW
         0Q5VIrCy2XVuDbzel+U27tU9HyfzPSPSWbw1NuxwutXixjzMv5sy7qKQtLmesBYZdfTb
         Ez9/r98dbv9JtioYpltjKD2/MnOdBWzVj60WtiGb38htMUKNBLVrursdSu6SBCi4Lru/
         NIDbGEaedZs7B219WcG/7Qm4nfTij3kNOXyzp47GuItRfMxHf1B4wMXSNeJGdrNqSNAh
         bkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=kvYXN84wde1jlinAnF1ZcIYTFqYeHdrpYuFHUVhFm0g=;
        b=MRuB4OIQMuRMmdDeHCWvJ2sw1PQ2suAxWyqh/jaRfjt64NnKGFgCuu5EXJRJsGRYSY
         SLknokFEmdf1VU3xrIrT3hbsg5mke9MM8mPiKrGI+ZBzTDuaee3+FtXlLdZz5lU8z5WR
         B8HUgl2HhXLWxrocqt3oE1HULmM2hgooRihEZYFTqVHT2DyXpTpgPT6GFgDP/70G8RjD
         sdWO8RcegpZ6We+fmDUlJy8whf6Gweko04SP3BlMstdcMFx0JudhEV6mpNKIaWA61I4i
         NBoiU/9NysMKhmmDhRqtCoOUiZA18dksMBdqKU3oZ80Oqt7T79d1iPZikpDT2GAYOx6J
         j6vw==
X-Gm-Message-State: AOAM533UnXIph1vVJ89EJMTMFTHa+L+em/SfiCZtjjZT/1rUxouY9BYk
        C1bwRM1CXs9oK8Ql38zyYWw=
X-Google-Smtp-Source: ABdhPJwJJ4EZqnR8kYnSgNN0KB8TCFB+aO8v6c2OneK1mbS7GpnfH1awHDHc2yM5JB3V6tuwulvLFA==
X-Received: by 2002:a1c:4943:: with SMTP id w64mr10581333wma.62.1599288865175;
        Fri, 04 Sep 2020 23:54:25 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q12sm15742518wrp.17.2020.09.04.23.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 23:54:23 -0700 (PDT)
Date:   Sat, 5 Sep 2020 08:54:22 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Nuernberger, Stefan" <snu@amazon.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "orcohen@paloaltonetworks.com" <orcohen@paloaltonetworks.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Shah, Amit" <aams@amazon.de>
Subject: Re: [PATCH] net/packet: fix overflow in tpacket_rcv
Message-ID: <20200905065422.GA556394@eldamar.local>
References: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
 <20200904133052.20299-1-snu@amazon.com>
 <20200904141617.GA3185752@kroah.com>
 <1599229365.17829.3.camel@amazon.de>
 <20200904143648.GA3212511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200904143648.GA3212511@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Sep 04, 2020 at 04:36:48PM +0200, gregkh@linuxfoundation.org wrote:
> On Fri, Sep 04, 2020 at 02:22:46PM +0000, Nuernberger, Stefan wrote:
> > On Fri, 2020-09-04 at 16:16 +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Sep 04, 2020 at 03:30:52PM +0200, Stefan Nuernberger wrote:
> > > > 
> > > > From: Or Cohen <orcohen@paloaltonetworks.com>
> > > > 
> > > > Using tp_reserve to calculate netoff can overflow as
> > > > tp_reserve is unsigned int and netoff is unsigned short.
> > > > 
> > > > This may lead to macoff receving a smaller value then
> > > > sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
> > > > is set, an out-of-bounds write will occur when
> > > > calling virtio_net_hdr_from_skb.
> > > > 
> > > > The bug is fixed by converting netoff to unsigned int
> > > > and checking if it exceeds USHRT_MAX.
> > > > 
> > > > This addresses CVE-2020-14386
> > > > 
> > > > Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
> > > > Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > 
> > > > [ snu: backported to 4.9, changed tp_drops counting/locking ]
> > > > 
> > > > Signed-off-by: Stefan Nuernberger <snu@amazon.com>
> > > > CC: David Woodhouse <dwmw@amazon.co.uk>
> > > > CC: Amit Shah <aams@amazon.com>
> > > > CC: stable@vger.kernel.org
> > > > ---
> > > >  net/packet/af_packet.c | 9 ++++++++-
> > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > What is the git commit id of this patch in Linus's tree?
> > > 
> > 
> > Sorry, this isn't merged on Linus' tree yet. It's a heads up that the
> > backport isn't straightforward.
> 
> Ok, please be more specific about this when sending patches out...

The commit is in Linux' tree now as
acf69c946233259ab4d64f8869d4037a198c7f06 .

Older stable series, which do not have 8e8e2951e309 ("net/packet: make
tp_drops atomic") will though need a backport as per above AFICS.

Regards,
Salvatore
