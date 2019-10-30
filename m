Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AF6EA7DC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfJ3Xgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:36:31 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50453 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfJ3Xgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:36:31 -0400
Received: from [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1] (unknown [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D5BA622178;
        Thu, 31 Oct 2019 00:36:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572478587;
        bh=xPtd4XvDvd62hfTGjUNo7H2JnIYd89hVqNAIqvYCFVI=;
        h=Date:In-Reply-To:References:Subject:To:From:From;
        b=AYMx7ysW3/vYcP4eraRkeirr/686UuYJM5R+pH34CrTjappSz7K2XZk6/8JY6akc1
         sFab5UvkC7oy0LXd1cqdZx3HIXocUWRv1YLiNN8l4fvTPyfPQ2tma7P0PLPZyqXNmG
         srG/xMxx4MRrPdxOxlCqhm/CsN9X0zg8Fxhj+PMA=
Date:   Thu, 31 Oct 2019 00:36:26 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <408bb56b-efe9-21c4-0177-2d433a7c20ce@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc> <20191030224251.21578-3-michael@walle.cc> <408bb56b-efe9-21c4-0177-2d433a7c20ce@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
From:   Michael Walle <michael@walle.cc>
Message-ID: <A61073BA-743E-499F-A1D0-BFE40F0ED05A@walle.cc>
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 31=2E Oktober 2019 00:28:47 MEZ schrieb Florian Fainelli <f=2Efainelli@g=
mail=2Ecom>:
>On 10/30/19 3:42 PM, Michael Walle wrote:
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
>
>This is more of a policy than a hardware description=2E Implementing this
>has a PHY tunable, possibly as a form of auto-power down
>
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
>
>will be changed?

oh=2E=2E yes of course=2E=20

>This looks like a possibly dangerous configuration as it really can
>lead
>to some good damage happening on the pins if there is an incompatible
>voltage on the MAC and PHY side=2E=2E=2E of course, you have no way to te=
ll
>ahead of time other than by looking at the board schematics, lovely=2E

correct=2E=2E although the standard mode of 1=2E5V has a max high voltage =
of 1=2E8V so this seems to be safe=2E But I guess no one has ever really th=
ough about how to really configure that safely=2E

>Does the PHY come up in some sort of super isolatation mode by default
>at least?

not that I'm aware of=2E also=2E=2E the rgmii mode just works without any =
setup (apart from the delay and voltage settings)=20

-michael=20

