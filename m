Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F20633826
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiKVJRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiKVJRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:17:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDD926F3;
        Tue, 22 Nov 2022 01:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669108659; x=1700644659;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ju1JyQTn92u4HvUI5+WxNM5kNBlJYD4Eh6lJkA3+1pw=;
  b=Oq7BQn6mlzlbISruwZjrEh64CH5T406xTR7b15XneT/bR8CZHbq4mO2d
   OIUI2IsjcsvkSDuGtURO0WZRmX+Hbxb4rgMzLDJwudNVp36hmtEWmwg5J
   36u2ODg2aO9rKJNH/mQ0g+B0TQOcBtOI8uhgKVvvNIUI06XRXgQh0PU/R
   gScHhomVK1dTQmMGBXg1hGBSZ2co4T0QjIjyRbfO2W3uGBttlkWP/2KPr
   gKWtmhjc8zl1DcMSd/32fK43ilX44hUn6WXDP2uUJPJmZ0FWjJLl9z3ke
   0Tyox/3RM3Zf3mPyNhH0kljMkAOozPMezEo3V0HQtgku4T4TnVimVLaSz
   A==;
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="188113651"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 02:17:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 02:17:26 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 02:17:23 -0700
Message-ID: <994f72742a15bec5a93d57324b749b71d0709035.camel@microchip.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for VCAP debugFS in Sparx5
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
Date:   Tue, 22 Nov 2022 10:17:22 +0100
In-Reply-To: <20221121110154.709bed49@kernel.org>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
         <20221121110154.709bed49@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

On Mon, 2022-11-21 at 11:01 -0800, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Thu, 17 Nov 2022 22:31:06 +0100 Steen Hegelund wrote:
> > This provides support for getting VCAP instance, VCAP rule and VCAP por=
t
> > keyset configuration information via the debug file system.
>=20
> Have you checked devlink dpipe? On a quick scan it may be the right API
> to use here? Perhaps this was merged before people who know the code
> had a chance to take a look :(

No I was not aware of the scope of devlink-dpipe, but it looks like the Spa=
rx5
VCAP feature would fit in.

I need to take a closer look at the model and see if I can make ends meet, =
but
if so, then I could send support for devlink-dpipe at a later stage...

BR
Steen
