Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1401694644
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjBMMs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBMMsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:48:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07993C21;
        Mon, 13 Feb 2023 04:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676292535; x=1707828535;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7oMYgm31AovDGuhY6Au2XWEgmwZFFXBCIB3lA0VEnmQ=;
  b=TsSTNkJjgPr0s2XzyOtEIsk3qqKp3a2tIVdoAzOP+fIYRXBOle2zIePj
   G2gWuonsFV3pJEq2GCn7N979OU7GFJnZWKdjD9AsyeEjBuwT/IdzZtwbx
   wu3QO7K8y8aFYhJbjHfVvCnSE/9aAsD5A51C5jEsqMyMv846vVMH9xKuN
   9R/lm95N/4nEi0g+ExmgadJEsso/puGeXOdH6ydO2lmzFDeqe6/C0D3Ca
   RKy8ITnBvDhDdi7r5aEuXj5OU61dwWaUimoALo3WqiHhXRxdoarnTgb7K
   hNMcSCDMJNMX4pXiRLsZvVBwLMIlUGiCA1b/NNOadRyDjYMYBdUDSMevI
   w==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="200689283"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 05:48:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 05:48:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 05:48:50 -0700
Message-ID: <b755fa1c818639a1e7c11ab3b2ac56443757ac3c.camel@microchip.com>
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids
 without offsets when enabling rules
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Date:   Mon, 13 Feb 2023 13:48:50 +0100
In-Reply-To: <Y+oZjg8EkKp46V9Z@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
         <20230213092426.1331379-5-steen.hegelund@microchip.com>
         <Y+oZjg8EkKp46V9Z@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Mon, 2023-02-13 at 14:05 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Feb 13, 2023 at 10:24:20AM +0100, Steen Hegelund wrote:
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > index 68e04d47f6fd..9ca0cb855c3c 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > @@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct
> > vcap_rule_internal *ri,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > =C2=A0}
> >=20
> > +/* Return the chain id rounded down to nearest lookup */
> > +static int vcap_round_down_chain(int cid)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0 return cid - (cid % VCAP_CID_LOOKUP_SIZE);
> > +}
> > +
> > +/* Return the chain id rounded up to nearest lookup */
> > +static int vcap_round_up_chain(int cid)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0 return vcap_round_down_chain(cid + VCAP_CID_L=
OOKUP_SIZE);
>=20
> Just use the round_up/down() macros.

The only round up/down macros that I am aware of are:

 * round_up - round up to next specified power of 2
 * round_down - round down to next specified power of 2

And I cannot use these as the VCAP_CID_LOOKUP_SIZE is not a power of 2.

Did I miss something here?

>=20
>=20
> > +}
> > +
>=20
> regards,
> dan carpenter
>=20

BR
Steen
