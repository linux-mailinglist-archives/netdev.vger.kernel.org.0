Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99641EA81F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJaAOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:14:44 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50295 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfJaAOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:14:43 -0400
Received: from [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1] (unknown [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3F17222178;
        Thu, 31 Oct 2019 01:14:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572480880;
        bh=b2Lpx68dP8w+wDSl2KFVImOy9LT1HJJtztLSFbPe3FI=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=UNLj984znRLoYmfd8aM3tAtP7o9siVUkcAad1OJzA3L2z6JiB+EgNdaVZbtWX8kXg
         UXuC1983De9jAXw83M28WhA5YXn19MOxwDup3FFM9xm8d7+YgCEVUWHpYYEGpBN+KX
         c7so48QdKnM12QOYIvnKfM3A4AyJOS7cByQq6Ew4=
Date:   Thu, 31 Oct 2019 01:14:38 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20191030231706.GG10555@lunn.ch>
References: <20191030224251.21578-1-michael@walle.cc> <20191030224251.21578-3-michael@walle.cc> <20191030231706.GG10555@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
To:     Andrew Lunn <andrew@lunn.ch>
CC:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
From:   Michael Walle <michael@walle.cc>
Message-ID: <9C1BD4CD-DB02-40CA-940E-3F5579BAE5F4@walle.cc>
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 31=2E Oktober 2019 00:17:06 MEZ schrieb Andrew Lunn <andrew@lunn=2Ech>:
>On Wed, Oct 30, 2019 at 11:42:50PM +0100, Michael Walle wrote:
>> Document the Atheros AR803x PHY bindings=2E
>>=20
>> Signed-off-by: Michael Walle <michael@walle=2Ecc>
>> ---
>>  =2E=2E=2E/bindings/net/atheros,at803x=2Eyaml          | 58
>+++++++++++++++++++
>>  include/dt-bindings/net/atheros-at803x=2Eh      | 13 +++++
>>  2 files changed, 71 insertions(+)
>>  create mode 100644
>Documentation/devicetree/bindings/net/atheros,at803x=2Eyaml
>>  create mode 100644 include/dt-bindings/net/atheros-at803x=2Eh
>>=20
>> diff --git
>a/Documentation/devicetree/bindings/net/atheros,at803x=2Eyaml
>b/Documentation/devicetree/bindings/net/atheros,at803x=2Eyaml
>> new file mode 100644
>> index 000000000000=2E=2E60500fd90fd8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/atheros,at803x=2Eyaml
>> @@ -0,0 +1,58 @@
>> +# SPDX-License-Identifier: GPL-2=2E0+
>> +%YAML 1=2E2
>> +---
>> +$id: http://devicetree=2Eorg/schemas/net/atheros,at803x=2Eyaml#
>> +$schema: http://devicetree=2Eorg/meta-schemas/core=2Eyaml#
>> +
>> +title: Atheros AR803x PHY
>> +
>> +maintainers:
>> +  - TBD
>
>Hi Michael
>
>If you don't want to maintain it, then list the PHY maintainers=2E
>
>> +
>> +description: |
>> +  Bindings for Atheros AR803x PHYs
>> +
>> +allOf:
>> +  - $ref: ethernet-phy=2Eyaml#
>> +
>> +properties:
>> +  atheros,clk-out-frequency:
>> +    description: Clock output frequency in Hertz=2E
>> +    enum: [ 25000000, 50000000, 62500000, 125000000 ]
>> +
>> +  atheros,clk-out-strength:
>> +    description: Clock output driver strength=2E
>> +    enum: [ 0, 1, 2 ]
>> +
>> +  atheros,keep-pll-enabled:
>> +    description: |
>> +      If set, keep the PLL enabled even if there is no link=2E Useful
>if you
>> +      want to use the clock output without an ethernet link=2E
>> +    type: boolean
>> +
>> +  atheros,rgmii-io-1v8:
>> +    description: |
>> +      The PHY supports RGMII I/O voltages of 2=2E5V, 1=2E8V and 1=2E5V=
=2E By
>default,
>> +      the PHY uses a voltage of 1=2E5V=2E If this is set, the voltage
>will changed
>> +      to 1=2E8V=2E
>> +      The 2=2E5V voltage is only supported with an external supply
>voltage=2E
>
>So we can later add atheros,rgmii-io-2v5=2E That might need a regulator
>as well=2E Maybe add that 2=2E5V is currently not supported=2E

There is no special setting for the 2=2E5V mode=2E This is how it works: t=
here is one voltage pad for the RGMII interface=2E Either you connect this =
pad to a 2=2E5V voltage or you leave it open (well you would connect some d=
ecoupling Cs)=2E If you leave it open the internal LDO, which seems to be e=
nabled in any case takes over, supplying 1=2E5V=2E then there is a bit in t=
he debug register which can switch the internal LDO to 1=2E8V=2E So if you'=
ll use 2=2E5V the bit is irrelevant=2E=20

Like I said maybe a "rgmii-io-microvolts" is a better property and only in=
 the 1800000 setting would turn on this bit=2E but then both other setting =
would be a noop=2E=20

-michael=20

