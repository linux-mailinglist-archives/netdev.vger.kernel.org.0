Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802B234E9C4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhC3OAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:00:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32419 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhC3OAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617112799; x=1648648799;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+6jqtFQoj20JBsWq8UPo3OQgLckANKu/lmxYFx4keo=;
  b=QdTT/eCSM7RP6DgwgfxgdJLKd3D41vuUyLZcj4GKTtJUzg+ULFMieba1
   sCRxsLlmv0269/dYzPOs3Jg5Jfl1kiXwu20uCvknRwOVa9pOxCe6h6r2j
   8Si0mfpffrInL5/Hw7U+mMbzHbOlSa1kZlkU41V0FsCVirl9Dx7wofaVF
   JPT2mc1dsArrnr4qfWdjwU131AHXM1Ze/7E7LRDT/kutrgIxuGWwbJKNK
   4ETfXRXCDAEtdjfXBMpNGP6KD3pnyeMLOdO0LhU3wJdqq6eyflXBgIeQl
   ASTqoNxjUHuN/aZ3e9GPmKIfhvdVTlkXMGiZIuDiJeapQuEGGDi3Z1wX5
   w==;
IronPort-SDR: gzEjrJ7oqBzGCwd6nagMfuxvtAGgAyN1W6iBwnIxPaMSLfrzjL6siLRVpuO2numufDdnC4IoS8
 XQce2O0/NbtaFZZ+JIDwEDVzrio+AzIm4K2cS1+qVaB6PWE9dDccdh0CISAfTRaBCVLzWKNx0v
 EpJOQvCttsKFWWncdwb4dav/J3aCmP70M/u196PFoEOlOtYWBfGBZO1fM6Vt9/NklrQCQeNB9l
 O4MdNj6OZtPomDEQ86LtgzmjDCwBJzf9RSJjBaU6QNJ1C5vlXfDW1s+9vIK2ckz0a+GsPOpCKt
 KTc=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="115182180"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Mar 2021 06:59:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 06:59:59 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 30 Mar 2021 06:59:56 -0700
Message-ID: <807aa02ed3d54c2f9b31343e19df91526cc3c14e.camel@microchip.com>
Subject: Re: [PATCH linux-next 1/1] phy: Sparx5 Eth SerDes: Use direct
 register operations
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Date:   Tue, 30 Mar 2021 15:59:55 +0200
In-Reply-To: <YGMo4K4b9GIUIGu8@lunn.ch>
References: <20210329081438.558885-1-steen.hegelund@microchip.com>
         <20210329081438.558885-2-steen.hegelund@microchip.com>
         <YGIimz9UnVYWfcXH@lunn.ch>
         <2356027828f1fa424751e91e478ff4bc188e7f6d.camel@microchip.com>
         <YGMo4K4b9GIUIGu8@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 2021-03-30 at 15:34 +0200, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > > > +static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
> > > > +                                    struct sparx5_sd25g28_params *params)
> > > >  {
> > > > -     struct sparx5_serdes_regval item[] = {
> > > 
> > > Could you just add const here, and then it is no longer on the stack?
> > > 
> > >    Andrew
> > 
> > No it still counts against the stack even as a const structure.
> 
> I'm surprised. Maybe it needs static as well?
> 
> I'm just thinking you can get a much smaller patch if you don't need
> to modify the table, just add additional qualifiers.
> 
>    Andrew


I get your point, but the problem is that the initialization depends on the input parameters: serdes
index, port index, media type, speed etc, so it cannot be made static, and making it const still
uses the stack.

BR
Steen



