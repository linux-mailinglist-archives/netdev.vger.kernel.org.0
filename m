Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674403B223E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFWVLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:11:55 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993B9C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:09:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ot9so5090066ejb.8
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d53Qv8iAWYfi6ebO5/PMg7M8UrdqasY7sqYuTmSbVyA=;
        b=sOFWZZ/7qk/1eJoTc7god9j7ZJn4p0EuAYfJL+9Hk/mwvbk8llOsGXOs4rDdaQmqoC
         msPuu0ZMm2myNFqY8EV2ieT8iEPKZfxSdXakk2wGWUxMNYvP/eZhRin8HdMqfD4yEt6p
         2aJwDxCpHH64lpmrFm+oLwNUT/LCI7atYChL4bdsZsCSARyyFZYk2NRGq4n8gaLLzdQl
         cvTPBn+y5DZRnl/Q0gV5OYpdRhY9JhbkRXXVJhcrNSVX+D9vXlE5eW1noBDkyQ3pThSS
         PNR+BXX/wibDSkkaZm8/lgzLls6afKuQoGWnSB8LGAqTlVxr9ECQvQ2t6FLo2pKK9G2d
         Oldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d53Qv8iAWYfi6ebO5/PMg7M8UrdqasY7sqYuTmSbVyA=;
        b=YV5WosLPyY16O7Oz8wC324k7TXgpPrrw5eU8M5y+nWG7rrYLeuR6JtrRI5kl8sa2hB
         yRWJn2vlvT/BRlLyRIPqH3Slyf7xwZfiKknayRRlGyybBt0fpaB1VIOjjLdB1Dgnxeqy
         B36Aj6vMEYEqMliFBG4k3ZOxmAZsR6X/TI5OKS/9WVX+z9BX64lw8oIEl9+EDxdQXxxK
         IbHEGwbJ7NRb8MltczWIyt0rlxvXmT+dmeug7CiS2+zJ4hI1s6fdWj2cTG8CvKYQTKc9
         ug8W3LY9mI57hG24/uV3XrnK5olnV5cYpY8TX+bV+rKjhOMOXK36cabSYXURNghIo916
         nyvw==
X-Gm-Message-State: AOAM532YjCprsZEJe9plCxRUC8Bpfsjv+CVbPxbzHI6/La9JvAVT5Ecb
        dgJ/vF3owfSahrDxEyMFjPND1YNPFjkVjmvpbwo=
X-Google-Smtp-Source: ABdhPJzpsqBNLPoeT+ZCjoO9mWKFiBMu5pcgeN2ZlL+8jCr6MBJ4ZHAGwLF/oDLJ7trK9Se7AS2BvT+MrYD3U3Sw3C4=
X-Received: by 2002:a17:906:25cb:: with SMTP id n11mr1925747ejb.539.1624482574155;
 Wed, 23 Jun 2021 14:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210604161250.49749-1-lxu@maxlinear.com> <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
 <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com> <YLuzX5EYfGNaosHT@lunn.ch>
 <9ecb75b8-c4d8-1769-58f4-1082b8f53e05@maxlinear.com> <CAFBinCARo+YiQezBQfZ=M6HNwvkro0nK=0Y9KhhhRO+akiaHbw@mail.gmail.com>
 <MWHPR19MB0077D01E4EAFA9FE521D83ECBD0D9@MWHPR19MB0077.namprd19.prod.outlook.com>
 <766ab274-25ff-c9a2-1ed6-fe2aa44b4660@maxlinear.com>
In-Reply-To: <766ab274-25ff-c9a2-1ed6-fe2aa44b4660@maxlinear.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 23 Jun 2021 23:09:23 +0200
Message-ID: <CAFBinCBCPcCD3uxO5iJF11LBhdMe32nzMLvnD1xyLvpT2HZt_Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Liang,

On Wed, Jun 23, 2021 at 12:56 PM Liang Xu <lxu@maxlinear.com> wrote:
[...]
> Hi Martin,
>
> 1) The legacy PHY GPY111 does not share the same register format and addr=
ess for WoL and LED registers. Therefore code saving with a common driver i=
s not possible.
> 2) The interrupt handling routine would be different when new features ar=
e added in driver, such as PTP offload, MACsec offload. These will be added=
 step by step as enhancement patches afte initial version of this driver up=
streamed.
I think that would leave only few shared registers with the older PHYs
(and thus the intel-xway driver). Due to the lack of a public
datasheet however I have no way to confirm this.
So with this information added to the patch description having a
different driver is fine for me

Maybe Andrew can also share his opinion - based on this new
information - as he previously also suggested to extend the intel-xway
driver instead of creating a new one

> 3) The new PHY generation comes with a reasonable pre-configuration for t=
he LED registers which does not need any modification usually.
>    In case a customer needs a specific configuration (e.g. traffic pulsin=
g only, no link status) he needs to configure this via MDIO. There is also =
another option for a fixed preconfiguration with the support of an external=
 flash. However, this is out of scope of the driver.
older PHYs also do this, but not all boards use a reasonable LED setup

> 4) Many old products are mostly used on embedded devices which do not sup=
port WoL. Therefore there was no request yet to supported by the legacy XWA=
Y driver.
my understanding of Andrew's argument is: "if the register layout is
the same for old and new PHY then why would we do some extra effort to
not add WoL support for the old PHYs"
Based on your information above the register layout is different, so
that means two different implementations are needed anyways.


Best regards,
Martin
