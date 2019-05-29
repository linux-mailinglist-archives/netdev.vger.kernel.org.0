Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1A72DA67
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfE2KYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:24:02 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46054 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbfE2KYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:24:01 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8DFE7C2177;
        Wed, 29 May 2019 10:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559125424; bh=EaIlXg4+87vZfZa76Eds7saCbr0RrMdv8qglDo5oEUg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=A9xTu63HZPXHp9sxs/90ChTBkUIiFdJnwJFWZEd/rtWfZge+xMXtZ2qsUB7iwUzFa
         VAw3IfeqBGl63sFkyplgnUxhzv7nNpD26WwQsR00GICnkCWQRzQPFx4a2S0czRVt3X
         sFFMlcnjYQGmoeIlwAWI39c7jTcJ0AzuipTDoKzGODB7GU2xB/u+lvB45cmsMfHTPw
         ZgfUL64N5QeUvPmjhXRWoeuoEfNZBeKwt8fLRvGmc6eiWTTp3L+n0DGVXk9+hjUs7u
         9UszmMSz+YQ9BXRBCcJUXUzLRa8SNvXAg/oD5bZTf801XjDSFaUdjtKj/jiXpgy9zS
         21jVreUga/0ww==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id F3823A006D;
        Wed, 29 May 2019 10:23:59 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 03:23:59 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 12:23:57 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v4 3/5] net: stmmac: add xpcs function hooks
 into main driver and ethtool
Thread-Topic: [PATCH net-next v4 3/5] net: stmmac: add xpcs function hooks
 into main driver and ethtool
Thread-Index: AQHVFfyla7qF4cEoq0uy/2sja8vl2aaB5Egw
Date:   Wed, 29 May 2019 10:23:57 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B933429@DE02WEMBXB.internal.synopsys.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-4-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559149107-14631-4-git-send-email-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, May 29, 2019 at 17:58:25

> +/**
> + *  xPCS_interrupt - xPCS ISR
> + *  @irq: interrupt number.
> + *  @dev_id: to pass the net device pointer.
> + *  Description: this is the xPCS interrupt service routine.
> + */

Please remove all JAVA docs from the series unless they are really=20
useful. This looks like it's stating the obvious and just pollutes the=20
eyes.

> +static irqreturn_t xpcs_interrupt(int irq, void *dev_id)
> +{
> +	struct net_device *ndev =3D (struct net_device *)dev_id;
> +	struct stmmac_priv *priv =3D netdev_priv(ndev);
> +	irqreturn_t ret =3D IRQ_NONE;
> +
> +	if (unlikely(!ndev)) {

This is a useless check because you already dereference the pointer when=20
you assign "priv" variable.

Thanks,
Jose Miguel Abreu
