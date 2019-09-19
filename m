Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4FB835C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 23:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404814AbfISVaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 17:30:18 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34786 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404788AbfISVaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 17:30:18 -0400
Received: by mail-vs1-f67.google.com with SMTP id d3so3324863vsr.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=UqsuE1mF0J4skun8jPXUyS/rCN1cC2ynmHjXcv5JGu4=;
        b=X8vrtA8ae9IuYbUgmBmNxNM2hA8+hLBnoHiOxLVwhzggSxryHZucei1dLRvNtzbKI/
         LNLDOPV6OyzNZyxiqyeGGOOUN1v79Y6zLnO4HC/REz22kMmBjtEzdA7+qVA0LSoBPitp
         zTVGrnQ3a73CwKmrjWd/7TMoz9G+K5WpvnXAuu7+qS7iQefsqZ/ZfTD8Pn35aM7QOjuB
         JcHoN/lCeI1s4TzrdHi44feq3tOWwIupPKd2t9nlzCra6M5x/gxHD3W7t5Gp7wqxfVPe
         N86/+tEFbuJQMREOilP89lWW1jjnDu1TZuFclYP2PW5/dziZ1UVz+mWPhAjAwBRmaRK2
         MemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=UqsuE1mF0J4skun8jPXUyS/rCN1cC2ynmHjXcv5JGu4=;
        b=apWG4jbxepC5BmLfCqEjVNm4e/I4rJYkYlMAUqjjEDv2A6Mb6xp+dr+eHIE++apKfj
         p5NA/6gZHsnykQJcUMG8+2CAG0NIftpZvP7rKPHH53tFBffz8bw7PXtgIhA+p36ejxU/
         w9hBM52sLCJNgXX//HiQs7VIrVFX6ZMB0xy4BZZlfFVsGU2MA4PDn6eJAUnfwKtNmYvN
         jyBpAc8gvqjAI/zu8R0i4b7VDkhcKAdlzRnMxzKSsD9VhxXc1gs2zYSue8BLS/nbg2w6
         Ro/7FnyCb6a6a3ky05XfgK6jS+lNU4eMKHGuxeyfOGxgjVLRaWYeWta+TBh8Qh5C/FeE
         rg1A==
X-Gm-Message-State: APjAAAXNSkkELO2z+7VgFx7zSY+7raFAusfPxURjwwBMTwPQKii682IR
        cOpiBle7YFk+x06GsBHs35z2sqF0QQDJxQPScP0=
X-Google-Smtp-Source: APXvYqxngMrxe1MS2/mwxn1bHVUOSVXlkcj62g1OSaKRuN1IFC6ysZh51c5FmSktRoEU/ccn45DuM+w950GwAvuYeWA=
X-Received: by 2002:a67:d304:: with SMTP id a4mr110111vsj.156.1568928617383;
 Thu, 19 Sep 2019 14:30:17 -0700 (PDT)
MIME-Version: 1.0
From:   Jason Cobham <cobham.jason@gmail.com>
Date:   Thu, 19 Sep 2019 14:30:06 -0700
Message-ID: <CAKu_b=+0=KXnT-b8L2qkUxT2jSMAJaiMBNAeSjJ3hPqZgx4PGw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add support for port mirroring
To:     Iwan R Timmer <irtimmer@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Iwan,

>Hi Andrew,
>
>I only own a simple 5 ports switch (88E6176) which has no problem of mirro=
ring the other ports to a single port. Except for a bandwith shortage ofcou=
rse. While I thought I checked adding and removing ports, I seemed to forgo=
t to check removing ingress traffic as it will now >disable mirroring egres=
s traffic. Searching for how I can distinct ingress from egress mirroring i=
n port_mirror_del, I saw there is a variable in the mirror struct called in=
gress. Which seems strange, because why is it a seperate argument to the po=
rt_mirror_add function?
>
>Origally I planned to be able to set the egress and ingress mirror seperat=
ly. But in my laziness when I saw there already was a function to configure=
 the destination port this functionality was lost.
>
>Because the other drivers which implemented the port_mirror_add (b53 and
>ksz9477) also lacks additional checks to prevent new mirror filters from b=
reaking previous ones I assumed they were not necessary.
>
>At least I will soon sent a new version with at least the issue of removin=
g mirror ingress traffic fixed and the ability to define a seperate ingress=
 and egress port.
>
>Regards,
>Iwan

I have a similar patch set for port mirror from a few years ago. I'd
also like to see this functionality in mainline. One issue I ran into
is when doing port mirror in a cross-chip dsa configuration. If the
ingress and egress ports are on different chips, the ingress chip
needs to set the egress to the cross-chip dsa port and the cross-chip
egress port needs to be set appropriately. I also had the
functionality to mirror egress from a port to a destination port.

Is it appropriate to send my patch to the mailing list for review or
should we work on this off-line?

Thanks,
Jason
