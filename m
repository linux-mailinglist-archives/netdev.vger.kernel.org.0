Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C814A61CA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbiBARBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiBARBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:01:34 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABA3C061714;
        Tue,  1 Feb 2022 09:01:34 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 413A1223E9;
        Tue,  1 Feb 2022 18:01:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1643734891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5X2u4lEgQtTxZHB9dZgOZUr72b3urORwKvx6DLRKSKo=;
        b=Xtwf8qsIL/iNo12NTMXqIzHHDHIMlkd3us+sYRK/KL/0QshdHLNBm68CR9CFPom2rpXGes
        1pfpPO/70vqybvrgKiyw5Jcr6FRpPiGjL8KBnyMFrDuiQ8Rk86YSYlKyTnnpqAdYk0vXes
        b123jqaWMyTKTN/bVJITivH86FGKwHk=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 01 Feb 2022 18:01:28 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?Q?R?= =?UTF-8?Q?afa=C5=82_Mi=C5=82ecki?= 
        <rafal@milecki.pl>
Subject: Re: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address
 cell
In-Reply-To: <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
 <20220126070745.32305-2-zajec5@gmail.com>
 <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <0b7b8f7ea6569f79524aea1a3d783665@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-02-01 16:55, schrieb Rob Herring:
> On Wed, Jan 26, 2022 at 08:07:45AM +0100, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This adds support for describing details of NVMEM cell containing MAC
>> address. Those are often device specific and could be nicely stored in
>> DT.
>> 
>> Initial documentation includes support for describing:
>> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
>> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
>> 3. Source for multiple addresses (very common in home routers)
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>  .../bindings/nvmem/cells/mac-address.yaml     | 94 
>> +++++++++++++++++++
>>  1 file changed, 94 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml 
>> b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> new file mode 100644
>> index 000000000000..f8d19e87cdf0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> @@ -0,0 +1,94 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NVMEM cell containing a MAC address
>> +
>> +maintainers:
>> +  - Rafał Miłecki <rafal@milecki.pl>
>> +
>> +properties:
>> +  compatible:
>> +    const: mac-address
>> +
>> +  format:
>> +    description: |
>> +      Some NVMEM cells contain MAC in a non-binary format.
>> +
>> +      ASCII should be specified if MAC is string formatted like:
>> +      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 
>> 39 3a 41 42)
>> +      - "01-23-45-67-89-AB"
>> +      - "0123456789AB"
>> +    enum:
>> +      - ascii
>> +
>> +  reversed-bytes:
>> +    type: boolean
>> +    description: |
>> +      MAC is stored in reversed bytes order. Example:
>> +      Stored value: AB 89 67 45 23 01
>> +      Actual MAC: 01 23 45 67 89 AB
>> +
>> +  base-address:
>> +    type: boolean
>> +    description: |
>> +      Marks NVMEM cell as provider of multiple addresses that are 
>> relative to
>> +      the one actually stored physically. Respective addresses can be 
>> requested
>> +      by specifying cell index of NVMEM cell.
> 
> While a base address is common, aren't there different ways the base is
> modified.
> 
> The problem with these properties is every new variation results in a
> new property and the end result is something not well designed. A 
> unique
> compatible string, "#nvmem-cell-cells" and code to interpret the data 
> is
> more flexible.

I actually like having a unique compatible for anything but the basic
operations. For example, the sl28 vpd area also has a checksum, which
could be handled if there is an own compatible. I don't think this is
possible with this proposal. Also there is a version field, what if
we change the layout of that thing? Am I supposed to change the
device tree? The more I think about Rob's proposal to have a compatible
the more I like it.

One of Rafałs concerns are code duplication. I.e. if everything needs
its own compatible string, the driver will also have to have all of 
these.
But I'd say, this is a common thing in most drivers.

That being said, I'd really like to have a consens here as this topic
is open like forever and I was under the impression that at least we
were clear on the device tree side.

-michael

> For something like this to fly, I need some level of confidence this is
> enough for everyone for some time (IOW, find all the previous attempts
> and get those people's buy-in). You have found at least 3 cases, but I
> seem to recall more.
> 
> Rob
