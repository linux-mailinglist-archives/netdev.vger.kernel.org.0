Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2D2DA39
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfE2KRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:17:00 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:41796 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbfE2KRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:17:00 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 26E42C0B58;
        Wed, 29 May 2019 10:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559125028; bh=qAsqi8gX5SUaVnl2yseXi4eGkqxzuYPQST0EcBGFiwk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ih+BF/HhLRpZoP3ea08rPVyFlnL16rjTQLdog92/33d09M2v38RE3mQA0P+dP7Zsv
         W4EDk1P+4225x5TACrIGDqdWwMLpBg55BjmxyUhzS0ksEC5fHn+w1LSRsD+Z+uQ+sr
         cln2Sisj/46hpGvIwQi7fhJeVDLofIE7LZJbgvsAizgKdtdi6JhqdFTzIS2bWSzRj0
         LlogmNWN5pxa1bGHcEIpLeGfJr/7el9C60Z4Bvr0c9SnhmYlvPi87AeYQk2pOcPKiQ
         Mu9jKXa3qsr6fxFuy8en3cLyD7p/1OCoCP9Dc3Llt65zEZRBXy3V0MYYE1ub98tVUC
         3IKFQqjqnrxPg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 55990A0104;
        Wed, 29 May 2019 10:16:53 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 03:16:53 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 12:16:50 +0200
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
Subject: RE: [PATCH net-next v4 1/5] net: stmmac: enable clause 45 mdio
 support
Thread-Topic: [PATCH net-next v4 1/5] net: stmmac: enable clause 45 mdio
 support
Thread-Index: AQHVFfyg4wQZ8d4GK06AR51mcY/UpqaB4qwA
Date:   Wed, 29 May 2019 10:16:50 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9333BC@DE02WEMBXB.internal.synopsys.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-2-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559149107-14631-2-git-send-email-weifeng.voon@intel.com>
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
Date: Wed, May 29, 2019 at 17:58:23

> +static void stmmac_mdio_c45_setup(struct stmmac_priv *priv, int phyreg,
> +				  u32 *val, u32 *data)
> +{
> +	unsigned int reg_shift =3D priv->hw->mii.reg_shift;
> +	unsigned int reg_mask =3D priv->hw->mii.reg_mask;

Reverse christmas tree here. You also should align the function variables=20
with the opening parenthesis of the function here and in the remaining=20
series.

Otherwise this patch looks good to me.

Thanks,
Jose Miguel Abreu
