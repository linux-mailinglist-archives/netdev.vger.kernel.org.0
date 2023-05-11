Return-Path: <netdev+bounces-1729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A446FEFE0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CA5C28151E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EF51774C;
	Thu, 11 May 2023 10:26:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0461C76A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:26:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E983383D4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683800798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhczK8dDlliuVGSzk9PMw10+gj4mVel9O/McDJEwOJU=;
	b=EF2rTFtKHpYPtx5zEDGOUUfkZRkyekOqvYV/on4dlZWQ7l42Leku1X0q56iZ/YTlllhHjx
	b97rxe7DGAwwDq+ZmzHKynkMT/Bhg6Xdaizuy/vjKaUvTsFD6I4yX+uDex+VlfKnz9gmUD
	ctGFlHpOaVKzvSsi9CNsPm6oyBwd1+Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-bX8gkjQ3PkmyWCETutbSDw-1; Thu, 11 May 2023 06:26:37 -0400
X-MC-Unique: bX8gkjQ3PkmyWCETutbSDw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3079087c27eso228668f8f.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683800796; x=1686392796;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RhczK8dDlliuVGSzk9PMw10+gj4mVel9O/McDJEwOJU=;
        b=RdFIV9Lp4tgA/PSAOEVl+fgEvNgyBIfOG7eYWX5QN4FlN/It3PHnJjODIdqDsaqCUO
         kdeUDksAEeeBDIXjx12xpxIE5gQZTYMBSAY28zscOHwn/kvZscp9oCotYOv3beBAoEnV
         91ij7Qp2GFkBL5BdbS8kTt/AM+koxRM3iI3aJhY/KcNVSSBwzKaoalPIKqDq/aFeL5y7
         gE30RWsJmqibjF63UwzFV7Zj6xqDf7I2ixHxVxsElLbyv/uyYMhVeyioJvRltKzLwgAO
         9mcEoXAzXiwSYd/Qd6Q+zyZigtRz7xZK8P6r0yHQg0JZxx6Dlou0vg4zhZkrTGVKoUxM
         TUEA==
X-Gm-Message-State: AC+VfDy+3Q3Hu4CJiovPAtsWopdEotqJ15rJq9j9n9BWIx9mt4qP3pTW
	seDYrQrbhgUlvJLkicODTX/VfaVcvZJD7RS2TAIRyg9Uxlsg7EkGNdWMuwso0YEEcuIeqLfMEkl
	pfSdthAotytcZNWGt
X-Received: by 2002:a05:600c:350a:b0:3f1:78bd:c38b with SMTP id h10-20020a05600c350a00b003f178bdc38bmr14676289wmq.4.1683800796459;
        Thu, 11 May 2023 03:26:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63NU4Oof1bATaeQhgP8Iy50937zSMDTB6Qrx0C92vLioRIcxbSK8LmdgeNCuXGMWSrGWa1Qw==
X-Received: by 2002:a05:600c:350a:b0:3f1:78bd:c38b with SMTP id h10-20020a05600c350a00b003f178bdc38bmr14676270wmq.4.1683800796103;
        Thu, 11 May 2023 03:26:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-149.dyn.eolo.it. [146.241.243.149])
        by smtp.gmail.com with ESMTPSA id n2-20020a5d4c42000000b003063db8f45bsm19893247wrt.23.2023.05.11.03.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 03:26:35 -0700 (PDT)
Message-ID: <8aebd38cf057cf659d5133527f55e1ced0e6f70c.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
From: Paolo Abeni <pabeni@redhat.com>
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc: Doug Berger <opendmb@gmail.com>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit
 <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, Marek
 =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>, Peter Geis
 <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Thu, 11 May 2023 12:26:34 +0200
In-Reply-To: <20230509223403.1852603-3-f.fainelli@gmail.com>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
	 <20230509223403.1852603-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Tue, 2023-05-09 at 15:34 -0700, Florian Fainelli wrote:
> @@ -821,7 +917,28 @@ static int bcm54xx_phy_probe(struct phy_device *phyd=
ev)
>  	if (IS_ERR(priv->ptp))
>  		return PTR_ERR(priv->ptp);
> =20
> -	return 0;
> +	/* We cannot utilize the _optional variant here since we want to know
> +	 * whether the GPIO descriptor exists or not to advertise Wake-on-LAN
> +	 * support or not.
> +	 */
> +	wakeup_gpio =3D devm_gpiod_get(&phydev->mdio.dev, "wakeup", GPIOD_IN);
> +	if (PTR_ERR(wakeup_gpio) =3D=3D -EPROBE_DEFER)
> +		return PTR_ERR(wakeup_gpio);
> +
> +	if (!IS_ERR(wakeup_gpio)) {
> +		priv->wake_irq =3D gpiod_to_irq(wakeup_gpio);
> +		ret =3D irq_set_irq_type(priv->wake_irq, IRQ_TYPE_LEVEL_LOW);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* If we do not have a main interrupt or a side-band wake-up interrupt,
> +	 * then the device cannot be marked as wake-up capable.
> +	 */
> +	if (!bcm54xx_phy_can_wakeup(phydev))
> +		return ret;

AFAICS, as this point 'ret' is 0, so the above is confusing. Do you
intend the probe to complete successfully? If so, would not be
better/more clear:

		return 0;

?

Thanks,

Paolo


