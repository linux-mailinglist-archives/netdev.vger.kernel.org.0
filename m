Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F0B1DEBC9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgEVP1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbgEVP1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:27:11 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A706C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:27:11 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id m64so8581116qtd.4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SRsdOjWWL+ErLjyMojixNVl7s3eXgVVstDINvK3dtXg=;
        b=jfK/zDIFzAwRiPF5rSe1xq8YO+ZE0VL+EQPe6K4YPFRj9xXRozQLQi0tJM2zyK91BM
         w6Q6wyRRRq4Qq46NUYu/kcCX1f78ojBrzaVsc9LDiIYA/RuUiiX8vfA7GBkol9Finv11
         mQ7Ox5f4M3JlcOOKELjHlwqAPzd7yc/GQhYmlEdYOXV+xnBdH0/HrN2sD/BWNxqHT91u
         rAo5gUjweaCu8QoaGEUC5QVe8xt2NF2nAQIlJ5w++VFJJpSUf/6ig5/aEe3d+a7IVzuF
         82wUAcK7HdnhoZthoiL4FwdoJXIAvTjfiqfV6kii/d5yWsSktVexR4BbOAqcqg9hjBrg
         Vgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SRsdOjWWL+ErLjyMojixNVl7s3eXgVVstDINvK3dtXg=;
        b=rOiaRXSgcNKIt1vXbL+RsCt0KBIRXxmfBcmOeM08o+jkV73YnXo8FCUgaQm+p+0wYO
         Ir8DmeXrhldr3Dmg+8GU60cqChJv7dZHwn3qiBxzYWJO28NV6kfiN+M4m5ksVNPUNiBS
         7O7U/ypPUiT0Uao3gQY/Q0af/8MFYR7EkahkXbr547KGss3+7uo5Yk7Omtj/CTf07ksZ
         8HUGX14IEk7OFzr3KER8qLnEHlnMj9ixy8ZHiZKhS1xCJFoAysJ9PgFyhDoKXc8wnoN/
         UZz9zqYL0BHuUva3QuGTHULPjnKFCPmuymjDV6uYGistZGtZCk3yS62+GUAgSei46kmq
         MxwA==
X-Gm-Message-State: AOAM530SRUnHZwDWW0C1Wg2wgSObp7K2hTo191GaDHqID1fc6gYyt/wq
        JDG3rCwlHPD+2cLO5S+mqQjgoO39Gn28elsg+mjMOA==
X-Google-Smtp-Source: ABdhPJy8zE09hP3ssAEXIS8PrMxrdtczpkONJnriZwX1UvQjiBseW1fjfukwynTIX1jUsud00Bk+uIw6wPtBlxqVO3Q=
X-Received: by 2002:aed:37e7:: with SMTP id j94mr16165439qtb.57.1590161230357;
 Fri, 22 May 2020 08:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200522120700.838-1-brgl@bgdev.pl> <20200522120700.838-7-brgl@bgdev.pl>
 <5627e304-3463-9229-fa86-d7d31cad7a61@gmail.com>
In-Reply-To: <5627e304-3463-9229-fa86-d7d31cad7a61@gmail.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Fri, 22 May 2020 17:26:59 +0200
Message-ID: <CAMpxmJVCE0RBNqBQw03bT5uqnCk3vDi1ncbNeWj=VvcN1wEaZg@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] net: ethernet: mtk-star-emac: new driver
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 22 maj 2020 o 17:06 Matthias Brugger <matthias.bgg@gmail.com> napisa=
=C5=82(a):
>
> On 22/05/2020 14:06, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > This adds the driver for the MediaTek STAR Ethernet MAC currently used
> > on the MT8* SoC family. For now we only support full-duplex.
>
> MT85** SoC family, AFAIU it's not used on MT81** devices. Correct?
>

MT81** and MT85** are very closely related. This IP is currently used
on MT85**, MT81** and MT83**. It may be used in new designs in the
future too.

Bart
