Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E685152A4
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 19:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfEFRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 13:21:45 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35190 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfEFRVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 13:21:45 -0400
Received: by mail-oi1-f195.google.com with SMTP id w197so10210719oia.2;
        Mon, 06 May 2019 10:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKVzImXCcmmSR4PBm64334+BbWurjivsBjeqcoAIw88=;
        b=oSfjyoMJ5G7OKu/6fFU+HDKNPYOhOQfs3vy/yn9kYKv2ad1jZF1LZqq43IMEjrYyaM
         fYcFuscWz+HFdpO4yjlqZGuQ79Y++ipgRoO4BFAaq8CL21BIbnmzrRPrRcnbv+D3chn2
         HvNbVfTGqM+OnMnzKc82/xtPa96lkLu9PGXLrgPQXvNY850yp/hTmuvgFmFbbPbhUj/m
         6yGv0LkDe6CHx5WwC6vmaFgz0/R8Sg2PVwnLeBBEclV7u8nsLVbn+Xl64D6Zr+m2C9WM
         0OymDVjPACBQUo9k8lN0SUIlp8mpDSRTxTpB+QXRtV9UW9NYL5tOnuRfmT5AJoAYEkJ9
         Z1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKVzImXCcmmSR4PBm64334+BbWurjivsBjeqcoAIw88=;
        b=KyGi0O7xdxUwn2mV1VievZPgA9X4B/yz3oi0sNlAI2PyJgGsCCrhjF0KN/y4/ot9aX
         XpjfkCkNXMd9N7lNQEoMfhCyRErFWZe4kN4fym1VbdDmrI00Sa4sFOpEU951WcvYpch7
         AkEh4sIYF82sYZ97i1PAMifwjR3ee3hsFh1zgcEyXMhChX7RdwXHPg3Y/ovSnIgf4YV2
         ZG8Lg+859feS1IQ7pB7cLcvXZgWRT1oBxJ+tJ/KoeauqYPi6j5oPIfU2e6j1tDkOkb93
         G5ztqgM0gq7Ul8I45sc6/ycHtIDV8uE1OVtNdfei2ACPsj2Ur9naSk4s3uCumkxGDvrG
         pTqQ==
X-Gm-Message-State: APjAAAXcX3tgU/aiUBbaJ/Nf5W0TTiz0Cd0SX34MqryeBYPpAEKkdv2q
        MscuZo2vviIeoIiYqm0uYg9rL8dQrdfaBZVUfG6OQ/A6vu4=
X-Google-Smtp-Source: APXvYqw/5EzRUq6qMoDuISVurDVCeolxIe9JdfYA20Wk4H/7oFGg754E13XJyvZmNwhJDYUgu8Eo9B1HIAp43L3Hgs8=
X-Received: by 2002:aca:bdc4:: with SMTP id n187mr1971532oif.140.1557163304015;
 Mon, 06 May 2019 10:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation> <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
 <20190506143906.o3tublcxr5ge46rg@mobilestation>
In-Reply-To: <20190506143906.o3tublcxr5ge46rg@mobilestation>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 6 May 2019 19:21:32 +0200
Message-ID: <CAFBinCA=-oK3qhPv-sPge6qAo9jiv8me72_d8HCqKN3g0qiM-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Serge,

On Mon, May 6, 2019 at 4:39 PM Serge Semin <fancer.lancer@gmail.com> wrote:
[...]
> > the changes in patch 1 are looking good to me (except that I would use
> > phy_modify_paged instead of open-coding it, functionally it's
> > identical with what you have already)
> >
>
> Nah, this isn't going to work since the config register is placed on an extension
> page. So in order to reach the register first I needed to enable a standard page,
> then select an extended page, then modify the register bits.
I'm probably missing something here. my understanding about
phy_modify_paged is that it is equal to:
- select extension page
- read register
- calculate the new register value
- write register
- restore the original extension page

if phy_modify_paged doesn't work for your use-case then ignore my comment.

[...]
> > > (Martin, I also Cc'ed you in this discussion, so if you have anything to
> > > say in this matter, please don't hesitate to comment.)
> > Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
> > as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
> > there are multiple versions of this PHY. all RTL8211F I have seen so
> > far did behave exactly the same.
> >
> > I also don't know whether the RX delay is configurable (by pin
> > strapping or some register) on RTL8211F PHYs because I don't have
> > access to the datasheet.
> >
> >
> > Martin
>
> Ok. Thanks for the comments. I am sure the RX-delay is configurable at list
> via external RXD pin strapping at the chip powering up procedure. The only
> problem with a way of software to change the setting.
>
> I don't think there is going to be anyone revealing that realtek black boxed
> registers layout anytime soon. So as I see it it's better to leave the
> rtl8211f-part as is for now.
with the RTL8211F I was not sure whether interrupt support was
implemented correctly in the mainline driver.
I asked Realtek for more details:
initially they declined to send me a datasheet and referred me to my
"partner contact" (which I don't have because I'm doing this in my
spare time).
I explained that I am trying to improve the Linux driver for this PHY.
They gave me the relevant bits (about interrupt support) from the
datasheet (I never got the full datasheet though).

if you don't want to touch the RTL8211F part for now then I'm fine
with that as well


Regards
Martin
