Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A332C8597
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgK3Neg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:34:36 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:31379 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgK3Nef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606743276; x=1638279276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BKNUgIHWG9qidpYWQM9NDa/UdTifWn8MPgHmmyfA1uA=;
  b=YvOVDVq6PrPYNNKvsMBfoVVk79TGQpLplbnpuAMexN9GKPb6HxrvXLYP
   bj4rmTH3fVYLekxqP/csQwo77gl0KKrMegBMBmPzntNLMR1ta9Xd57L1k
   dioizX0w5pJ24qtXaFrnx8gb4FL8P8tzth7c+fXxUr2KCmBdptYUcA/E7
   g8XXK6afQeTRrv94FcG1WDRx0BzTurtZ9sm/zejCp27qGc2mXerFB2YkH
   /YDN/DvTBfNm2F5eCJjQAOJsQCGrpOPNWbOHn2I0FabE6iWKfzCRr4red
   9uFZRg7iMqmrbTwXgv2Q81pDA+Mx7u2hBFGhGz0Rb57Ow+Si9h6CmqXj8
   A==;
IronPort-SDR: hogrOpsb1wrRmB0qcNYbM/TKDBg7utWwXa0m6vcOK0cs9El+mmtzEEerwMHiOBO/3AEm7VW7tz
 UlYvfVTvpoPkgh4IlIViadm4d7XTGLaV0kVeShOFgGPNhrlOutbaILbEjDsj2va931vr1QM4LO
 D2aEeZeuGbNYpF20q34HckJ+OMNJIokGr6YLGEF+OiOZtwcCUPjmyS/PMixntqsu0c2Uo+Wipt
 5JQRYtEKa2wLShnfNJxHce2rngAAYCgjjo2Gav7kMQYUenprDekBQdkWEhzPxJWvIbjN1KCk+T
 PI0=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="100225499"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:33:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:33:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:33:29 -0700
Date:   Mon, 30 Nov 2020 14:33:28 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130133328.u6gbcttmaeknadip@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201129171634.GD2234159@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129171634.GD2234159@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 18:16, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
>> new file mode 100644
>> index 000000000000..a91dd9532f1c
>> --- /dev/null
>> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
>> @@ -0,0 +1,1027 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/* Microchip Sparx5 Switch driver
>> + *
>> + * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
>> + */
>> +
>> +#include <linux/ethtool.h>
>> +
>> +#include "sparx5_main.h"
>> +#include "sparx5_port.h"
>> +
>> +/* Add a potentially wrapping 32 bit value to a 64 bit counter */
>> +static inline void sparx5_update_counter(u64 *cnt, u32 val)
>> +{
>> +     if (val < (*cnt & U32_MAX))
>> +             *cnt += (u64)1 << 32; /* value has wrapped */
>> +
>> +     *cnt = (*cnt & ~(u64)U32_MAX) + val;
>> +}
>
>No inline functions in C files. Let the compiler decide.
>
>And i now think i get what this is doing. But i'm surprised at the
>hardware. Normally registers like this which are expected to wrap
>around, reset to 0 on read.
>
>        Andrew

Hi Andrew,

I will remove the inline.

In our case the counters just wraps around (at either 32 or 40 bit).

Thanks for your comments

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
