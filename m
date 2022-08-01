Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED959586FA0
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiHARgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiHARgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:36:16 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D861E12ADB;
        Mon,  1 Aug 2022 10:36:14 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 491585C00FC;
        Mon,  1 Aug 2022 13:36:12 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Mon, 01 Aug 2022 13:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1659375372; x=1659461772; bh=Y2
        57L4d6b5CFZRcEy4JTormzanQNT+CLmxVCxY4oXZQ=; b=g4bHXidTEQtZid/MiU
        Km2uU51ckhpdCCymYl9CZnQTKMlvu+uJpr/P5nW4iTzjl1vl2e8ieXlyrpXfYsrE
        i2ewUMNKuXi9h7fs6I8OyyJk0qdyz0Xk640DgQBehTA/5dbT41tICmzo3pwl4MJN
        4qpe3+T99uf2uQ4MKBtHYokvje5dVU2sSDThBGjByO5035SFXneWI6lJ+FF/Uc0+
        1bVfqKYJYBDnBiLDN/qochGDy/GLy5ca1FNe/dS5xehVIrakomdfjcE8K1fLkmu5
        O0Ef9GaLpCJATqeso3YDjcXku+INE8xh2w+SFu+u2YVr9qEXvP/A8H1fH6uqeXa7
        yM4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1659375372; x=1659461772; bh=Y257L4d6b5CFZRcEy4JTormzanQN
        T+CLmxVCxY4oXZQ=; b=W/FfjJ0eKIl/DnkCsoGQA8BXCbnS7+/bgS4IsH8VkUFc
        WEFgOu9seVvV32WdW8BXLdISTVnxmC7NrzewMn2cYqTWjICiGUdQkYwPmfDDM9i6
        7Q9OboAhiF4ugSPkxFtpJEzhhVL0L7qXDjAz4fKoZ5N74QHCR5ADne85PHBYZuHX
        BIwdNSA3kFt0PxjnvkCZoPIgcWYeEkzlLR/ILAHup3SzdbJrjeUUEzXobCU59M7L
        cEgRBI1hmwIPsAYi7F5pxUir5Azv8ZuckuDCSO0hGSl02LvCw0cOCwMpVXeYWJMi
        5YSILl8MsCgPKBAh1bKy42hWCyICXQYdT4jbAZaG+A==
X-ME-Sender: <xms:Cw_oYrr_5aCcl7cEE8iaunfu4F_D1TAzOMyG-iKFo2s8kzoT5W2JBQ>
    <xme:Cw_oYloaHXmrllphGVNjks4ob5Q4icuVgL8s2XahiBUYr-vwpeoE8npb7JMYNE4HD
    whi1wwhU0Gvmdg9Agc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfu
    vhgvnhcurfgvthgvrhdfuceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtf
    frrghtthgvrhhnpeefgedugffhjedvfffggfektedutdetueehudeitdfgudefvdduiedt
    vdeliedvgfenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhp
    vghtvghrrdguvghv
X-ME-Proxy: <xmx:Cw_oYoNsaQXZJY3jgsO6geqeaJyaheDOg96WD6T7KWUkt0bAAZh1uw>
    <xmx:Cw_oYu5RCO3SfaN-QC5_LwJh_uAEw1PVWJfcaW1L1IN4YHElfs-mOQ>
    <xmx:Cw_oYq560o3pp4JroCLxPVfRfAWjZK-k7L6lRy59B9UN7S__p0weBw>
    <xmx:DA_oYpQDEz816y26wyIy4v7InNIcT-9QSPcwrFPOFJfMwpZdBzLJTQ>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5A72EA6007C; Mon,  1 Aug 2022 13:36:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-758-ge0d20a54e1-fm-20220729.001-ge0d20a54
Mime-Version: 1.0
Message-Id: <de5f9eb8-9328-4c1c-a57c-a06d40ec203e@www.fastmail.com>
In-Reply-To: <20220801152338.GB1031441-robh@kernel.org>
References: <20220801103633.27772-1-sven@svenpeter.dev>
 <20220801103633.27772-2-sven@svenpeter.dev>
 <20220801152338.GB1031441-robh@kernel.org>
Date:   Mon, 01 Aug 2022 19:35:51 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Rob Herring" <robh@kernel.org>
Cc:     "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hector Martin" <marcan@marcan.st>,
        "Alyssa Rosenzweig" <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: net: Add generic Bluetooth controller
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 1, 2022, at 17:23, Rob Herring wrote:
> On Mon, Aug 01, 2022 at 12:36:29PM +0200, Sven Peter wrote:
>> Bluetooth controllers share the common local-bd-address property.
>> Add a generic YAML schema to replace bluetooth.txt for those.
>> 
>> Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> ---
>> I hope it's fine to list the current Bluetooth maintainers in here
>> as well.
>> 
>>  .../bindings/net/bluetooth-controller.yaml    | 30 +++++++++++++++++++
>>  .../devicetree/bindings/net/bluetooth.txt     |  6 +---
>>  2 files changed, 31 insertions(+), 5 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>> new file mode 100644
>> index 000000000000..0ea8a20e30f9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>> @@ -0,0 +1,30 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/bluetooth-controller.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Bluetooth Controller Generic Binding
>> +
>> +maintainers:
>> +  - Marcel Holtmann <marcel@holtmann.org>
>> +  - Johan Hedberg <johan.hedberg@gmail.com>
>> +  - Luiz Augusto von Dentz <luiz.dentz@gmail.com>
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^bluetooth(@.*)?$"
>> +
>> +  local-bd-address:
>> +    $ref: /schemas/types.yaml#/definitions/uint8-array
>> +    minItems: 6
>> +    maxItems: 6
>> +    description:
>> +      Specifies the BD address that was uniquely assigned to the Bluetooth
>> +      device. Formatted with least significant byte first (little-endian), e.g.
>> +      in order to assign the address 00:11:22:33:44:55 this property must have
>> +      the value [55 44 33 22 11 00].
>> +
>> +additionalProperties: true
>> +
>> +...
>> diff --git a/Documentation/devicetree/bindings/net/bluetooth.txt b/Documentation/devicetree/bindings/net/bluetooth.txt
>> index 94797df751b8..3cb5a7b8e5ad 100644
>> --- a/Documentation/devicetree/bindings/net/bluetooth.txt
>> +++ b/Documentation/devicetree/bindings/net/bluetooth.txt
>> @@ -1,5 +1 @@
>> -The following properties are common to the Bluetooth controllers:
>> -
>> -- local-bd-address: array of 6 bytes, specifies the BD address that was
>> -  uniquely assigned to the Bluetooth device, formatted with least significant
>> -  byte first (little-endian).
>> +This file has been moved to bluetooth-controller.yaml.
>
> There's one reference to bluetooth.txt. Update it and remove this file.

Sure, I've just checked and found Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.yaml
and Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml and will
update both for v2 and remove bluetooth.txt.


Thanks,


Sven
