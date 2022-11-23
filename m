Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5C6357B7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiKWJpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiKWJpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:45:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480292B184;
        Wed, 23 Nov 2022 01:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669196563; x=1700732563;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SCfTb+mbXqvYnjROomS2ofDscv9/hIdAV5b4EqXaNWI=;
  b=Q5yZXb2Ba8yV3iE6SUEJg1QRGMdlS+f3W+i79YzQybgOI8keB1uuEszI
   qZCjHCMOZ6fVpS6eGCL6yS1P/7YELbU9xIX6W3/XJDWsnC54mmHqsrUqh
   1KQwmIAnEacM10b3BuMtO81OGLkn8pfV8nF14hI+Vu93ptcAFlZvEl7d8
   fFvhCwDh43tcsTN+YogRBMxC+tlS08zvipqdhmtBd3zlww3Mfg12PmASv
   gg3OkncpMQPwFkYSNyU/HZ7MffLvEksf3iIU3YbvSHFChZZwoZiUtTGPc
   3ZeCG3cx6cnN32JghXSUeDRbflpmaUTnL/beHI8OjqRJQIrRwxPjhuFDM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184823755"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 02:42:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 02:42:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 02:42:30 -0700
Message-ID: <582f747ea6965b07b4a389dbbc0d86983daffcf7.camel@microchip.com>
Subject: Re: [PATCH net-next 1/4] net: microchip: sparx5: Support for
 copying and modifying rules in the API
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 23 Nov 2022 10:42:29 +0100
In-Reply-To: <20221122204545.40597627@kernel.org>
References: <20221122145938.1775954-1-steen.hegelund@microchip.com>
         <20221122145938.1775954-2-steen.hegelund@microchip.com>
         <20221122204545.40597627@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

Thanks for the feedback.

I needed an update of the sparse tool to allow me to spot this among all th=
e
"unreplaced" warnings...

I will send a new series.

On Tue, 2022-11-22 at 20:45 -0800, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, 22 Nov 2022 15:59:35 +0100 Steen Hegelund wrote:
> > This adds support for making a copy of a rule and modify keys and actio=
ns
> > to differentiate the copy.
>=20
> gcc says:
>=20
> drivers/net/ethernet/microchip/vcap/vcap_api.c:1479:16: warning: Using pl=
ain
> integer as NULL pointer

BR
Steen

