Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F3A6BB4C0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjCONeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjCONeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:34:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C4C87370;
        Wed, 15 Mar 2023 06:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678887226; x=1710423226;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bm5CrxXBMyPGF6W0vq3Z1zD+VKHabI1rS2Cvu828UHo=;
  b=nRGiQ3mseSKsdvMEprRxMF1+GCKFAYZweRTVYTlkmwhElD/0CKrMPKw3
   KLiEixn9KXr0qqdFpJi/Td+Vwc5vJn7uUh9SLnG/cue8M92tUwOm/CKXL
   cflNJkjA11W76tTYXaGCAvxf8zpMH3STwQHN87lrYBDWhwsXCSonuVGw1
   /rUmv3MoszsOzrA2alDPcl1yGxXlLu/K1nbFqA8eNk+YoMcUEy9L6dudf
   v8Ug8OzmT3Gqyj1xlJ5PLgctv6I29N3m0heJOQNpFveptp0k7wyhDoI/H
   i+bMDTDd1ai0z8r9UwVkd2om1UULlOF29FQ+I1L2tVm4xSCoSE134kbdQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673938800"; 
   d="scan'208";a="142174611"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Mar 2023 06:33:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 06:33:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 15 Mar 2023 06:33:28 -0700
Date:   Wed, 15 Mar 2023 14:33:27 +0100
From:   'Horatiu Vultur' <horatiu.vultur@microchip.com>
To:     David Laight <David.Laight@aculab.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: lan966x: Stop using packing library
Message-ID: <20230315133327.akf4lkdxt67eh3nd@soft-dev3-1>
References: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
 <20230312202424.1495439-3-horatiu.vultur@microchip.com>
 <cad1c4aac9ae4047b8ed29b181c908fd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cad1c4aac9ae4047b8ed29b181c908fd@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/13/2023 17:04, David Laight wrote:
> 
> From: Horatiu Vultur
> > Sent: 12 March 2023 20:24
> >
> > When a frame is injected from CPU, it is required to create an IFH(Inter
> > frame header) which sits in front of the frame that is transmitted.
> > This IFH, contains different fields like destination port, to bypass the
> > analyzer, priotity, etc. Lan966x it is using packing library to set and
> > get the fields of this IFH. But this seems to be an expensive
> > operations.
> > If this is changed with a simpler implementation, the RX will be
> > improved with ~5Mbit while on the TX is a much bigger improvement as it
> > is required to set more fields. Below are the numbers for TX.
> ...
> > +static void lan966x_ifh_set(u8 *ifh, size_t val, size_t pos, size_t length)
> > +{
> > +     u32 v = 0;
> > +
> > +     for (int i = 0; i < length ; i++) {
> > +             int j = pos + i;
> > +             int k = j % 8;
> > +
> > +             if (i == 0 || k == 0)
> > +                     v = ifh[IFH_LEN_BYTES - (j / 8) - 1];
> > +
> > +             if (val & (1 << i))
> > +                     v |= (1 << k);
> > +
> > +             if (i == (length - 1) || k == 7)
> > +                     ifh[IFH_LEN_BYTES - (j / 8) - 1] = v;
> > +     }
> > +}
> > +
> 
> It has to be possible to do much better that that.
> Given  that 'pos' and 'length' are always constants it looks like
> each call should reduce to (something like):
>         ifh[k] |= val << n;
>         ifk[k + 1] |= val >> (8 - n);
>         ...
> It might be that the compiler manages to do this, but I doubt it.

Thanks for the review. I will update this in the next version.

Do you think it is worth updating the code in lan966x_ifh_get to use
byte access and not to read each bit individually?
As there is no much improvement on the RX side that is using lan966x_ifh_get.

> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
/Horatiu
