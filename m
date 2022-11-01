Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1661450E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiKAHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAHbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:31:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666EA14009;
        Tue,  1 Nov 2022 00:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667287881; x=1698823881;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eMtIlU9F4D5ldNUDMy/uDawq9fDt32Jeq5I/BgKOwX0=;
  b=M867ufJtod1EdI2bCdp2YVXMxYHfBGEORk1kPm4SpvSPaxOrTjuj6Xaq
   P4TbOcFTuXzWCreJylYGKNMTbmOVudKe31qHoHuksk3g9W2m5meV7FCcZ
   t+58BnNytSzCcSMIXb+T2nV75nWx+tIEli1ao7uIOudtIPu5oAEPTGX0n
   byOhLfI2F5FrUoOfLikwTC6rKt8+7PsNbVexQ0E+sEvbYNCIjO3cx7kUX
   YrVSpQjuucFgCJJWeVvpRL4+nD3mYwt4Jx+UpKNOxuIMOfrT5Y7Cn09Tp
   yR+9DiYWulUMW2oI8LphBIDyJ2QChRh9K6H7pfq7vsWJKFvYHPgwfXLoB
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="184781964"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 00:31:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 00:31:20 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 00:31:16 -0700
Message-ID: <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Tue, 1 Nov 2022 08:31:16 +0100
In-Reply-To: <20221031184128.1143d51e@kernel.org>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
         <20221028144540.3344995-3-steen.hegelund@microchip.com>
         <20221031103747.uk76tudphqdo6uto@wse-c0155>
         <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
         <20221031184128.1143d51e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,


On Mon, 2022-10-31 at 18:41 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 31 Oct 2022 13:14:33 +0100 Steen Hegelund wrote:
> > > I'm not able to get this working on PCB135. I tested the VLAN tags and
> > > did not work either (did not test the rest). The example from the
> > > previous patch series doesn't work either after applying this series.
> 
> Previous series in this context means previous revision or something
> that was already merged?

Casper refers to this series (the first of the VCAP related series) that was merged on Oct 24th:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/

> 
> > tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
> 
> How are you using chains?

The chain ids are referring to the VCAP instances and their lookups.  There are some more details
about this in the series I referred to above.

The short version is that this allows you to select where in the frame processing flow your rule
will be inserted (using ingress or egress and the chain id).

> 
> I thought you need to offload FLOW_ACTION_GOTO to get to a chain,
> and I get no hits on this driver.

I have not yet added the goto action, but one use of that is to chain a filter from one VCAP
instance/lookup to another.

The goto action will be added in a soon-to-come series.  I just wanted to avoid a series getting too
large, but on the other hand each of them should provide functionality that you can use in practice.

BR
Steen


