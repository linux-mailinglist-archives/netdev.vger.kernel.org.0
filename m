Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311002790DE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgIYSjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYSjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:39:36 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF600C0613CE;
        Fri, 25 Sep 2020 11:39:35 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id p15so1896235qvk.5;
        Fri, 25 Sep 2020 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=dUf435LeWetQI7T/0I6jtCo+Jj+pjMiRIhsGBhL9+Ks=;
        b=Syf7hE4/NbuBopE4fj6R7YVeAw1e4pC/XFomn9rGC5Ic4Bh3BmIc7Zc/UekYCw1o93
         Dm+HkmALXxcv5YP8ZaMqGfeKvNBhSiCn+iUtJj0Ep3jYIKs76Hcmxo3+3fgpxhs4nBrn
         bv0dMWeZmnnCRhJqZAql9w2z4SXxuLEx+hh7WxFxoiIUOVj7TImZIVO3viYDiBSlq479
         2hlCSo59GqQs/gdzdRyHR+EztEPckFxKLOC4rbC9ddTLL0HdLGewAi4SB3B04SNcfBAQ
         s3/e2ZATvE1MSNVzS+kmjMoyXqpVY8+IE7Je5CeREbCohS232UOb2uNaGbIyKQzLeYzq
         k/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=dUf435LeWetQI7T/0I6jtCo+Jj+pjMiRIhsGBhL9+Ks=;
        b=lqYvbUEAshwrZOqw9cf1dsKIzCk0smgu7KJo1wBF3umDN4rAuNJxnWfrkRUIpq3kwN
         WQASy6rWfm6tOgBEdgpt2bpBkhE6eA7TBuOPrJE0jSNcZTAxVK9JnFIQN8mU8wzaloew
         5rsXU2Vw/BPdW18hnAVL+gGaJiSz46CKf/yYbB8ZjDhKs7bMeGuOjPeck6yEPKn0NMaj
         uByI0+hUnXLWuW7YGufh1g2apBs37XkWcPaNtbsnpPv2tDwPnho/rZ5nB4JBQGI6VXNQ
         mc59Gv/ev7kY7zgMryj3YBXzzGYbPBufCaYO2j0JhnsPGdmhKnzRfMJR9EQt95u3kZR+
         pemg==
X-Gm-Message-State: AOAM531j8glFrCjUZ89mqB4XXfAi7Ywci1Ez+83RVVJXHOFeuTpxcbt0
        fWUSBkf6YS9fLZlsIa325Eo=
X-Google-Smtp-Source: ABdhPJxDhaiOVjVfIGD8RWeyXsIunrWwPzE9wLn+BAfnkudkko5iSAi6Y/tH4RMK/XBVIPZAxiNCkA==
X-Received: by 2002:a0c:b251:: with SMTP id k17mr799820qve.53.1601059174715;
        Fri, 25 Sep 2020 11:39:34 -0700 (PDT)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id g19sm2208622qka.84.2020.09.25.11.39.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Sep 2020 11:39:33 -0700 (PDT)
From:   <ansuelsmth@gmail.com>
To:     "'Rob Herring'" <robh+dt@kernel.org>
Cc:     "'Miquel Raynal'" <miquel.raynal@bootlin.com>,
        "'Richard Weinberger'" <richard@nod.at>,
        "'Vignesh Raghavendra'" <vigneshr@ti.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'Russell King'" <linux@armlinux.org.uk>,
        "'Frank Rowand'" <frowand.list@gmail.com>,
        "'Boris Brezillon'" <bbrezillon@kernel.org>,
        "'MTD Maling List'" <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'netdev'" <netdev@vger.kernel.org>
References: <20200920095724.8251-1-ansuelsmth@gmail.com> <20200920095724.8251-4-ansuelsmth@gmail.com> <CAL_JsqKhyeh2=pJcpBKkh+s3FM__DY+VoYSYJLRUErrujTLn9A@mail.gmail.com>
In-Reply-To: <CAL_JsqKhyeh2=pJcpBKkh+s3FM__DY+VoYSYJLRUErrujTLn9A@mail.gmail.com>
Subject: RE: [PATCH v3 3/4] of_net: add mac-address-increment support
Date:   Fri, 25 Sep 2020 20:39:30 +0200
Message-ID: <00f801d6936b$36551e20$a2ff5a60$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: it
Thread-Index: AQKM5RC4rgXeqQ5LopEy1q5Nkk2f7gIPbdkoAY21rs6n8B/RMA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rob Herring <robh+dt@kernel.org>
> Sent: Friday, September 25, 2020 8:24 PM
> To: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>; Richard Weinberger
> <richard@nod.at>; Vignesh Raghavendra <vigneshr@ti.com>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Frank
> Rowand <frowand.list@gmail.com>; Boris Brezillon
> <bbrezillon@kernel.org>; MTD Maling List =
<linux-mtd@lists.infradead.org>;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; netdev
> <netdev@vger.kernel.org>
> Subject: Re: [PATCH v3 3/4] of_net: add mac-address-increment support
>=20
> On Sun, Sep 20, 2020 at 3:57 AM Ansuel Smith <ansuelsmth@gmail.com>
> wrote:
> >
> > Lots of embedded devices use the mac-address of other interface
> > extracted from nvmem cells and increments it by one or two. Add two
> > bindings to integrate this and directly use the right mac-address =
for
> > the interface. Some example are some routers that use the gmac
> > mac-address stored in the art partition and increments it by one for =
the
> > wifi. mac-address-increment-byte bindings is used to tell what byte =
of
> > the mac-address has to be increased (if not defined the last byte is
> > increased) and mac-address-increment tells how much the byte decided
> > early has to be increased.
>=20
> I'm inclined to say if there's a platform specific way to transform
> MAC addresses, then there should be platform specific code to do that
> which then stuffs the DT using standard properties. Otherwise, we have
> a never ending stream of 'generic' properties to try to handle
> different platforms' cases.
>=20
> Rob

I agree about the 'never ending stream'... But I think the increment =
feature
is not that platform specific. I will quote some number by another patch
that tried to implement the same feature in a different way, [1]

* mtd-mac-address                used 497 times in 357 device tree files
* mtd-mac-address-increment      used  74 times in  58 device tree files
* mtd-mac-address-increment-byte used   1 time  in   1 device tree file

The mtd-mac-address is what this patchset is trying to fix with the =
nvmem
support. The increment is much more than 74 times since it doesn't count
SoC that have wifi integrated (it's common practice for SoC with =
integrated
wifi to take the switch mac and use it to set the wifi mac)
Actually what is really specific is the increment-byte that can be =
dropped
if we really want to.
I still think the increment feature would be very useful to add full =
support
for mac-address extracted from nvmem cell.

[1] =
https://patchwork.ozlabs.org/project/netdev/patch/1555445100-30936-1-git-=
send-email-ynezz@true.cz/

