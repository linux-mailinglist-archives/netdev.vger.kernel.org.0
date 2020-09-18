Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97835270401
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIRSbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:31:23 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BB1C0613CE;
        Fri, 18 Sep 2020 11:31:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z9so6501328wmk.1;
        Fri, 18 Sep 2020 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=aq4S41RXE1vAQKwL/QYWeFUP5HTyFU3O/6rS50qdZsE=;
        b=fTNJQYUPRjCv2jqehMXxCqoGu4qw4qcHntIzB6h/UkQq6e+wiXyKftBV4EgCPvHw53
         LJzF6I7V2XJNSiiyZIQiTDyTuX+oey6c9gME8nBPQ3jpc3A+DsjTWkq16BC7SMYywtEd
         7HroLi6axJlnSoWmbbkU+JHcZOwpWdfnSyagXLieeDNXPKJYgpI2xgEshv/URf4HCyc8
         nI1WCxEBuxh7sfUEKHeng/28wAEP5EzruotnCQ5XFbizYjfuwfPyjCguXwQLaFDsWOPi
         Um2/1v0Sip/meE/W1PMmB6KHrCrQ4HlvDihF362x19MMyR26WSLNJNA1kCySf4dH60+N
         QmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=aq4S41RXE1vAQKwL/QYWeFUP5HTyFU3O/6rS50qdZsE=;
        b=huQJx6kb7nsqVQf989CYTg1VITUSxOqndOB00kvi6jjNW/AeOezGG8PlmiboBN5PGx
         odQlcAh0IuqXDNVkVPN/J5TbugF0DNf1f4dTt/tw1ZB86a1HJcZqY+rC6AAPdc4n5sOD
         VOmd7Yy0sZ8R+LiZCnSL/pFIp4uIN05RUvq0XtOpRXm7aG+OTZwfssdYjPCYmp5ipr4k
         GpJpqsFhA1Qy99MLbP0oS/IQsexJhc40P2+IjZC4Yp7sP4QSfrJXDmC/QuSWkOvYzMX9
         YgM06npkfnopAzjckc/QUYHuFsK0GHWH2gIILCQ8OpfZkh27BO1AR8mtCruO/QPyJXOc
         D+8w==
X-Gm-Message-State: AOAM5314scLH2t3VkJd0ASC63QB0r8Bpd317LF4Efa6cM7aKxEbH2tGS
        /WyaZbmMH/RTrzG55p1OcsM=
X-Google-Smtp-Source: ABdhPJy3Ubjg/Kg+A3AeGariVlXaUlhZ7Hiy38mgi+9UBFB8tesMKZR+49HLkc2mbq7LGh/ZOWVzwA==
X-Received: by 2002:a7b:c3c8:: with SMTP id t8mr16894073wmj.101.1600453881837;
        Fri, 18 Sep 2020 11:31:21 -0700 (PDT)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id d9sm61650wmb.30.2020.09.18.11.31.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 11:31:20 -0700 (PDT)
From:   <ansuelsmth@gmail.com>
To:     "'Christian Lamparter'" <chunkeey@gmail.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>
Cc:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@linaro.org>,
        "'Bartosz Golaszewski'" <bgolaszewski@baylibre.com>
References: <20200918162928.14335-1-ansuelsmth@gmail.com> <20200918162928.14335-2-ansuelsmth@gmail.com> <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
In-Reply-To: <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
Subject: R: [PATCH 2/2] dt: bindings: ath10k: Document qcom, ath10k-pre-calibration-data-mtd
Date:   Fri, 18 Sep 2020 20:31:18 +0200
Message-ID: <000001d68de9$e7916450$b6b42cf0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJEWVdigiv7VEZfce04PgG7d9c+lQHuGaaaAYeoZCCod3HyIA==
Content-Language: it
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Messaggio originale-----
> Da: Christian Lamparter <chunkeey@gmail.com>
> Inviato: venerd=C3=AC 18 settembre 2020 18:54
> A: Ansuel Smith <ansuelsmth@gmail.com>; Kalle Valo
> <kvalo@codeaurora.org>
> Cc: devicetree@vger.kernel.org; netdev@vger.kernel.org; linux-
> wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> ath10k@lists.infradead.org; David S. Miller <davem@davemloft.net>; Rob
> Herring <robh+dt@kernel.org>; Jakub Kicinski <kuba@kernel.org>; linux-
> mtd@lists.infradead.org; Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org>; Bartosz Golaszewski
> <bgolaszewski@baylibre.com>
> Oggetto: Re: [PATCH 2/2] dt: bindings: ath10k: Document qcom, ath10k-
> pre-calibration-data-mtd
>=20
> On 2020-09-18 18:29, Ansuel Smith wrote:
> > Document use of qcom,ath10k-pre-calibration-data-mtd bindings used =
to
> > define from where the driver will load the pre-cal data in the =
defined
> > mtd partition.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>=20
> Q: Doesn't mtd now come with nvmem support from the get go? So
> the MAC-Addresses and pre-caldata could be specified as a
> nvmem-node in the devicetree? I remember seeing that this was
> worked on or was this mtd->nvmem dropped?
>=20
> Cheers,
> Christian

Sorry a lot for the double email... I think I found what you are talking =
about.
It looks like the code was merged but not the documentation.
Will do some test and check if this works.

This should be the related patch.
https://patchwork.ozlabs.org/project/linux-mtd/patch/1521933899-362-4-git=
-send-email-albeu@free.fr/


