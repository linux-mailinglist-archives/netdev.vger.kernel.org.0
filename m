Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3249862BAE1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiKPLGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238613AbiKPLFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:05:44 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BE13F069
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:20 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id b131so19812934yba.11
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YoRuKDvRtfqyxGXCloGQzrbnsQ9lUzIfiyzXfdm3sb0=;
        b=EQyRpq6xCb5QSFzpsfric99YN0ZsQ9Us/A8yUiBkDqeQa69Af3/Ws27dLusUvjCwVj
         lbPyWiX1rvCAeMXcEEj4sEH6wrFNffdMYIdk2jECYf+YzbvKgO3U5Jnfk0GDyPsAE+5j
         tbjbxhTXMGVfynN1opiPyTSjpthCHKwA/QuuA+i+y7BR/F+kOX6qc9UAlhTF+ciu709T
         15Z+YPwKtf1oMMZoKOyoc/VYzbsqssNVw/cvMQ3LpYu4n+DJB1E/BAgqD2ULpPPlbmGG
         QCWzrdyTxoLggYsxp/93kgxKxabb6kmRrlGn1qUBhr+tEAMLVzJfHZ72sCrNvgEkW5kR
         kdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YoRuKDvRtfqyxGXCloGQzrbnsQ9lUzIfiyzXfdm3sb0=;
        b=JZ0vAsQVWlsoVnu5y3G5Q50GXyt3RAxFMiIzlEAS88MEXBDa9/d04dM59lmreNe+og
         BBtqRmPX9XzXpcRRhz63urfcJGCTP9/56FxlfXFzHl3k6sqTy1d++LcZTW/XkUjKJuXy
         ylZH2/oHiSb7fiWS8z2KMIFfU1rCiDaXbGxKUPmgwNSGb2cgh3ytdZsitSwdXGmj2zpb
         bGYMGYQMNWMsC1wLzJQ0OdwUYIPUkJVYXeP0D+F2P/3lSPhsMnsORJ7HQRoK/Et5ugfJ
         SpqEqU+FlzV9DM7OqQre2YurNS/MXeYToAW0CSFNGcHDklQMKDkXCkuIb7ibxfHahPky
         J2hw==
X-Gm-Message-State: ANoB5pm7QyW8DFX14Ws0AcN4vTzp2HKek9ryhFz1SLxun8xFsJ+Ahdwp
        6x7kgr75RpVho3X4irDBqHXMGyWY0+BddzI51PMF6Q==
X-Google-Smtp-Source: AA0mqf670K8oXK4BKY3rGd4/pry5UiYhbONNHWXWMaIp6wf/HClXcTpOxNUWLRinurA/uSVisGW1IKI3bgfLq1d+9gU=
X-Received: by 2002:a25:828a:0:b0:6cf:cfa9:94e9 with SMTP id
 r10-20020a25828a000000b006cfcfa994e9mr21818067ybk.35.1668595939679; Wed, 16
 Nov 2022 02:52:19 -0800 (PST)
MIME-Version: 1.0
References: <20221108181144.433087-1-nfrayer@baylibre.com> <20221108181144.433087-5-nfrayer@baylibre.com>
 <575fa0c61cb55845c4d3a646d0b1f48d782588a0.camel@redhat.com>
In-Reply-To: <575fa0c61cb55845c4d3a646d0b1f48d782588a0.camel@redhat.com>
From:   Nicolas Frayer <nfrayer@baylibre.com>
Date:   Wed, 16 Nov 2022 11:52:08 +0100
Message-ID: <CANyCTtRCY3_DUDbwHUt39toeUtUJDMQmV4Q9bxz+enyJkY5OWg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] net: ethernet: ti: davinci_mdio: Deferring probe
 when soc_device_match() returns NULL
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     nm@ti.com, ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peter.ujfalusi@gmail.com,
        vkoul@kernel.org, dmaengine@vger.kernel.org,
        grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, khilman@baylibre.com, glaroque@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le jeu. 10 nov. 2022 =C3=A0 12:21, Paolo Abeni <pabeni@redhat.com> a =C3=A9=
crit :
>
> Hello,
>
> On Tue, 2022-11-08 at 19:11 +0100, Nicolas Frayer wrote:
> > When the k3 socinfo driver is built as a module, there is a possibility
> > that it will probe after the davinci mdio driver. By deferring the mdio
> > probe we allow the k3 socinfo to probe and register the
> > soc_device_attribute structure needed by the mdio driver.
> >
> > Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
>
> I guess this one will go via the arm tree, right?
>
> I'm dropping it from the netdev PW.
>
> Thanks,
>
> Paolo
>
Hello Paolo,

I will resend this series as individual patches, so can you please
apply this mdio patch individually as it's independent from the others ?

Thanks,

Nicolas
