Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706B968BA49
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBFKfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjBFKe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:34:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CAAB47E;
        Mon,  6 Feb 2023 02:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675679657; x=1707215657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sj5A8Z7Z+drMjnjo1y5Ike8eKTC/Af3wqHn1hQREuec=;
  b=1p56t+MGTu8Nr23qgblGj8ULKjIufsEC44QawNtoxyBLV6SAhpJ6vIWZ
   ktdFrSzV38R0U8bEjVqRHs0Q346qn6HMKMDLaWNVOOy1S43GvGKeTn0Gp
   y+dejBg4XcFMtjurNC/KNC5Tj9VoFDP7cJ8YeTWszlHocX3tZE3sB0L4L
   lwO4+loScPnUbu/fDiyKVLtEs/XHPThZQ/uFPoSlq6GH2i/Ef9PiDnDgl
   VV+aUxQGj05lbEXA7irvJ0JniogEMXlxglv3KE2Hp21/p18G6hiXA8atp
   Wrujk7RwYQYdDI74o1Z5GMc8DmJXbkQBle3Ip4WwYyygDWobvictW5Yjo
   w==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="135726078"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 03:32:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 03:32:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Mon, 6 Feb 2023 03:32:53 -0700
Date:   Mon, 6 Feb 2023 11:32:52 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Add support for TC flower filter
 statistics
Message-ID: <20230206103252.xxqd5zvhvfdium4a@soft-dev3-1>
References: <20230203135349.547933-1-horatiu.vultur@microchip.com>
 <Y96R+oEaZijtdaFH@corigine.com>
 <20230206095227.25jh3cpix5k55qv3@soft-dev3-1>
 <Y+DPbbqPyskMBsSJ@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y+DPbbqPyskMBsSJ@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/06/2023 10:59, Simon Horman wrote:
> 
> > > Also, not strictly related, but could you consider, as a favour to
> > > reviewers, fixing the driver so that the following doesn't fail:
> > >
> > > $ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> > >   DESCEND objtool
> > >   CALL    scripts/checksyscalls.sh
> > >   CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> > > In file included from drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c:3:
> > > drivers/net/ethernet/microchip/lan966x/lan966x_main.h:18:10: fatal error: vcap_api.h: No such file or directory
> > >    18 | #include <vcap_api.h>
> > >       |          ^~~~~~~~~~~~
> > > compilation terminated.
> >
> > I will try to have a look at this.
> 
> Thanks, much appreciated.

Sorry for coming back to this, but it seems that I can't reproduce the
issue:

$ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
  CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o

I have tried different configurations without any luck. Any suggestion
on how to reproduce the issue?

-- 
/Horatiu
