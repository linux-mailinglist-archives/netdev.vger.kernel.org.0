Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B279262C81C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiKPSss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbiKPSsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:48:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A3B663D2;
        Wed, 16 Nov 2022 10:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668624350; x=1700160350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AMuvxwNHO0fNaYeLhzmRSMCbspfcBN0bchXkHT8SYbI=;
  b=DGxwEjYaeekSI41cNNrrJCFEyMO/HdmtwiXDZfQ9zmcGkA690onoxeee
   0JE6TL7bbsz93J4tf2xA1yt45LBs/KZdhWpyGYk8uiSAZuAMMy4BPJY0T
   iRGvLNH123t3iNcH7cyay5r+6SY7fJo+ijpb1u5vqoQhLTddRc0hz5/IK
   Q9uFFBJ9jDEap6hMBAhwlfHRlww837/wyVFQh8fG+V5vCARa7O72UcGws
   tP7rNwNFHln7Kpuj6PjHYyQS57UihE9bAoDm4ttijgwNhmCH8kkQFythq
   B2tIRrOqoObdv6L4haCMGumQ7gFA9NWKc1uN9lwdP7HB58AHQ+tAbnEzy
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="189305689"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 11:45:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 11:45:47 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 16 Nov 2022 11:45:46 -0700
Date:   Wed, 16 Nov 2022 19:50:35 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Message-ID: <20221116185035.ibrby6dghiva5qdi@soft-dev3-1>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
 <20221115214456.1456856-2-horatiu.vultur@microchip.com>
 <20221116154528.3390307-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221116154528.3390307-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/16/2022 16:45, Alexander Lobakin wrote:
> [Some people who received this message don't often get email from alexandr.lobakin@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Tue, 15 Nov 2022 22:44:52 +0100
> 
> > Update the page_pool params to allocate XDP_PACKET_HEADROOM space as
> > headroom for all received frames.
> > This is needed for when the XDP_TX and XDP_REDIRECT are implemented.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]
> 
> > @@ -466,6 +470,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
> >
> >       skb_mark_for_recycle(skb);
> >
> > +     skb_reserve(skb, XDP_PACKET_HEADROOM);
> 
> Oh, forgot to ask previously. Just curious, which platforms do
> usually have this NIC? Do those platforms have
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS set?

I am running on ARM and I can see that
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set.

> If no, then adding %NET_SKB_PAD to the headroom can significantly
> improve performance, as currently you have 28 bytes of IFH + 14
> bytes of Eth header, so IP header is not aligned to 4 bytes
> boundary. Kernel and other drivers often expect IP header to be
> aligned. Adding %NET_SKB_PAD to the headroom addresses that.
> ...but be careful, I've just realized that you have IFH in front
> of Eth header, that means that it will also become unaligned after
> that change, so make sure you don't access it with words bigger
> than 2 bytes. Just test all the variants and pick the best :D

Thanks for a detail explanation!

> 
> >       skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> >
> >       lan966x_ifh_get_timestamp(skb->data, &timestamp);
> > @@ -786,7 +791,8 @@ static int lan966x_fdma_get_max_frame(struct lan966x *lan966x)
> >       return lan966x_fdma_get_max_mtu(lan966x) +
> >              IFH_LEN_BYTES +
> >              SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
> > -            VLAN_HLEN * 2;
> > +            VLAN_HLEN * 2 +
> > +            XDP_PACKET_HEADROOM;
> >  }
> 
> [...]
> 
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
