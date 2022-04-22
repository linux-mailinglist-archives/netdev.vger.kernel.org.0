Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852E150BF9B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiDVSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiDVSRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:17:11 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261ED53A69
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:14:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id r187-20020a1c44c4000000b0038ccb70e239so8476059wma.3
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IwAaEgvim3Bv/iqFhoDBjgWQ6L1JCGlkTm8pLnst+bg=;
        b=E7DUc7wbFMLQpiUeDfqR+rPuiIyYMFJeAJXt2L1NCsAU4hAQfeMAlcii6/ZC1V/Ym/
         LsNqDSpbnwLnRsdxJ6ZVNV3xA8zH7HD9thXbVDekfGvnEk+Jw0iHI7G++bBpxhtc/t+1
         5y/BYsI52QtGlGWVdk4B9G/xK7Mza6YolDE2xolyAcrzQPRoTa9W+I8fUGmINgmjdZ9d
         +yj0QbIqvzRu5ul6rjjsB7t8RMompA3kG26f9XuTkbI89pOXgnoicINLhr4a620CEjkW
         dJeK/KgTir/Qww5fTRYUNhpn0qxZ7Cg/djmiyMWsfJIMopEWYkiLtIgta2IT+SU3sh1g
         hvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IwAaEgvim3Bv/iqFhoDBjgWQ6L1JCGlkTm8pLnst+bg=;
        b=Ew7udVEThG7BUJs2+Qki6SEr8vlbT83pf4sat+tIHQrbRuJ71UKnolJgNt79qLUr9f
         umzb/kc4MPL/rZCOIiS7Pkwl34ykZihJpNRalfCM/SZ2rzy6Q6IUR4J+yWQCKn0cG60Q
         5drK/ujk4vFFIdJFwRM3o3r8q+OJ14Cno1tXJ7uQn8y4Rnpqe2e3tnbjiz2tU9YrZ+Iw
         Aj8m3AriPlICAGRR6mTsM8/eBD3PVSNhN81LvSY0D6jhJCkqpyCAA/a2w3yPVDn49NiO
         3S70kYz9KG2dEe1e4wreyIZbksVB5mQOM4wr0pC18sxGr/BYnyBFyeYM2m3VPk1UHi+a
         evDA==
X-Gm-Message-State: AOAM531risQBXSrAZqtLQk8NuSrHausYUz3NihOZ4QtSFyekEmbp+UMm
        M8BXdo/g8XJ7vUhqACqhj5OrPQ==
X-Google-Smtp-Source: ABdhPJwk8TIHjJt6H9TH1wuGjtisVPy8iG04eTknZMxUDdK3zSkORm7L9DEIUQmYIFh9NziSz4HwGw==
X-Received: by 2002:a05:600c:1f0f:b0:38e:c9c8:9983 with SMTP id bd15-20020a05600c1f0f00b0038ec9c89983mr5157645wmb.105.1650651073799;
        Fri, 22 Apr 2022 11:11:13 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b62:a490:1878:54e6:5bf:e9a9:8ad])
        by smtp.gmail.com with ESMTPSA id r25-20020adfa159000000b0020ac9758f17sm2115665wrr.23.2022.04.22.11.11.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 11:11:13 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next v2] net: phy: broadcom: 1588 support on
 bcm54210pe
From:   Lasse Johnsen <lasse@timebeat.app>
In-Reply-To: <20220422152209.cwofghzr2wyxopek@bsd-mbp.local>
Date:   Fri, 22 Apr 2022 19:11:12 +0100
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <567C8D9F-BF2B-4DE6-8991-DB86A845C49C@timebeat.app>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <20220421144825.GA11810@hoboy.vegasvil.org>
 <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
 <20220422152209.cwofghzr2wyxopek@bsd-mbp.local>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

I suspect you make the conflation I also made when I started working on =
this PHY driver. Broadcom has a number of different, nearly identical =
chips. The BCM54210, the BCM54210E, the BCM54210PE, the BCM54210S and =
the BCM54210SE.

It=E2=80=99s hard to imagine, but only the BCM54210PE is a first =
generation PHY and the BCM54210 (and others) are second generation. I =
have to be mighty careful not to breach my NDA, but I can furnish you =
with these quotes directly from the Broadcom engineers I worked with =
during the development:

24 March:

"The BCM54210PE is the first-gen 40-nm GPHY, but the BCM54210 is the =
second-gen 40-nm GPHY.=E2=80=9D

"The 1588 Inband function only applied to BCM54210 or later PHYs. It =
doesn't be supported in the BCM54210PE=E2=80=9D

So, I quite agree with you that in-band would be preferable (subject to =
the issue with hawking the reserved field used in 1588-2019 I described =
in my note to Richard), but I am convinced that it is not supported in =
the BCM54210PE. Indeed if you are looking at a document describing =
features based on the RDB register access method it is not supported by =
the BCM54210PE.

I would like nothing better than to be wrong, but you will need to =
provide me with something substantial to investigate further. (Offline =
is NDA requires it - happy to discuss any time).

In any event, I=E2=80=99m sure the time is not wasted and will be =
relevant when the Raspberry PI CM5,6&7 is launched=E2=80=A6 :-)

Thank you for your note and all the best,

Lasse

> On 22 Apr 2022, at 16:22, Jonathan Lemon <jonathan.lemon@gmail.com> =
wrote:
>=20
> On Fri, Apr 22, 2022 at 04:08:18PM +0100, Lasse Johnsen wrote:
>>> On 21 Apr 2022, at 15:48, Richard Cochran <richardcochran@gmail.com> =
wrote:
>>> Moreover: Does this device provide in-band Rx time stamps?  If so, =
why
>>> not use them?
>>=20
>> This is the first generation PHY and it does not do in-band RX. I =
asked BCM and studied the documentation. I=E2=80=99m sure I=E2=80=99m =
allowed to say, that the second generation 40nm BCM PHY (which - "I am =
not making this up" is available in 3 versions: BCM54210, BCM54210S and =
BCM54210SE - not =E2=80=9CPE=E2=80=9D) - supports in-band rx timestamps. =
However, as a matter of curiosity, BCM utilise the field in the header =
now used for minor versioning in 1588-2019, so in due course using this =
silicon feature will be a significant challenge.
>=20
> Actually, it does support in-band RX timestamps.  Doing this would be
> cleaner, and you'd only need to capture TX timestamps.
> --=20
> Jonathan

