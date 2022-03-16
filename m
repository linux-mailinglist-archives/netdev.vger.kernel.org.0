Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5444DAF53
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355561AbiCPMFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355524AbiCPMFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:05:40 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD005344DE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:04:25 -0700 (PDT)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2E6D43F220
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647432264;
        bh=VR4T4m/maLXD8jmNp+9fCSIbE3x9FwCSeTpeAm3YpIg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=gMI8S1NogTr6z8wLsabeGmpFZjwXzMWmoHzuYXaNrd/zlwSZEYA5MO1TYeFiKUAD2
         QsGFkYJmexLawO+TLvX2Qhj7fEScWK6ECHb/lEBwxi7LoUO2H5/Ycj8VXnzrPNckZH
         sJ2cdPj7dU0Mt+esDSbiXOElifC62ZrraYSbDfNbdqboXnGWeJ0kZGv694h8MfZGdi
         vFLLES730NoTnkJFTOVaNQElmPH7fSPqgKMzQjvhP5pL+MH/HIFKMFwodgfWIL9Ace
         8dd8ioXhUko5fPDnsb90Uipxf12ZewNsH5VdRH29DbHy7dIL883hHEdpkFk5dhp9CK
         6FmdFl/0wS5fQ==
Received: by mail-wm1-f72.google.com with SMTP id 14-20020a05600c104e00b003897a167353so964972wmx.8
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VR4T4m/maLXD8jmNp+9fCSIbE3x9FwCSeTpeAm3YpIg=;
        b=qTxwubScPdnUg96Z1tLdloBCM7QS1Wsp8u2rGF4pI2GBYhZtaX8BDyJCI4kwDiO1Pb
         TSbxWF+EsJR66/hguOPY7Ty8RkOsRujhnfMcbGBht+oxA0wvrWkHV//0rh14l0oYzGyp
         RDTfmeBTyIqNyKHyMRBvIrRKMKy872jn0NUsU/peB+3WfmgXv/zp5lbMSqy0kzyg+SjV
         kJeY+5n35t/X9x3zVpiTr8JpL2cYoMN1MUH24tDFS/+4kwNTzmsh/qZRxhWyBo6Zdmhc
         aWIixTXeONyDsjWws5WguIDADkdbebGw+nUx2kUViMMj3g+TKpSg8WjNKWXqB8x5daZS
         mZYw==
X-Gm-Message-State: AOAM53213zoSKrL4R/qFhV3xerShKnGg/pS5YgWlwnl6R9sIkZ++IMMu
        tn00rfh++KZcCnP+H3xUiwUmnxa0KhWeynM0r4rm/GOY8lWp5B1kW0l9M1CBk6GOk2sArEzoiX0
        z0pmVa6QFpxjpzO/vMh9pGTAFlLtV240Aeg==
X-Received: by 2002:a5d:5241:0:b0:1f0:1842:efbd with SMTP id k1-20020a5d5241000000b001f01842efbdmr22766488wrc.320.1647432263895;
        Wed, 16 Mar 2022 05:04:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR/RI7gdDSyNR4qg14GOx7FT6D7OSJDIU5e+OaZsWlBPzeiyHn2UFyaDlgs9XEy1ItuNVOOw==
X-Received: by 2002:a5d:5241:0:b0:1f0:1842:efbd with SMTP id k1-20020a5d5241000000b001f01842efbdmr22766466wrc.320.1647432263600;
        Wed, 16 Mar 2022 05:04:23 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id d1-20020adffbc1000000b00203de0fff63sm1524316wrs.70.2022.03.16.05.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 05:04:22 -0700 (PDT)
Message-ID: <b45dabe9-e8b6-4061-1356-4e5e6406591b@canonical.com>
Date:   Wed, 16 Mar 2022 13:04:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
 <20220316101854.imevzoqk6oashrgg@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220316101854.imevzoqk6oashrgg@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 11:18, Ioana Ciornei wrote:
>>>
>>> It's related since it shows a generic usage pattern of the sfp node.
>>> I wouldn't just remove it since it's just adds context to the example
>>> not doing any harm.
>>
>> Usage (consumer) is not related to these bindings. The bindings for this
>> phy/mac should show the usage of sfp, but not the provider bindings.
>>
>> The bindings of each clock provider do not contain examples for clock
>> consumer. Same for regulator, pinctrl, power domains, interconnect and
>> every other component. It would be a lot of code duplication to include
>> consumers in each provider. Instead, we out the example of consumer in
>> the consumer bindings.
>>
>> The harm is - duplicated code and one more example which can be done
>> wrong (like here node name not conforming to DT spec).
> 
> I suppose you refer to "sfp-eth3" which you suggested here to be just
> "sfp". 

I refer now to "cps_emac3" which uses specific name instead of generic
and underscore instead of hyphen (although underscore is actually listed
as allowed in DT spec, dtc will complain about it).

>In an example, that's totally acceptable but on boards there can
> be multiple SFPs which would mean that there would be multiple sfp
> nodes. We have to discern somehow between them. Adding a unit name would
> not be optimal since there is no "reg" property to go with it.

The common practice is adding a numbering suffix.

> 
> So "sfp-eth3" or variants I think are necessary even though not
> conforming to the DT spec.
> 
>>
>> If you insist to keep it, please share why these bindings are special,
>> different than all other bindings I mentioned above.
> 
> If it's that unheard of to have a somewhat complete example why are
> there multiple dtschema files submitted even by yourself with this same
> setup?

I am also learning and I wished many of my mistakes of early DT bindings
conversion were spotted. Especially my early bindings... but even now I
keep making mistakes. Human thing. :)

I converted quite a lot of bindings, so can you point to such examples
of my schema which includes consumer example in a provider bindings? If
you find such, please send a patch removing trivial code.


> As an example for a consumer device being listed in the provider yaml
> file is 'gpio-pca95xx.yaml'

Indeed, this is trivial and useless code which I kept from conversion,
should be removed.

>
 and for the reverse (provider described in
> the consumer) I can list 'samsung,s5pv210-clock.yaml',
> 'samsung,exynos5260-clock.yaml' etc.

These are different. This is an example how to model the input clock to
the device being described in the bindings. This is not an example how
to use the clock provider, like you created here. The input clock
sometimes is defined in Exynos clock controller, sometimes outside. The
example there shows the second case - when it has to come outside. It's
not showing the usage of clocks provided by this device, but I agree
that it also might be trivial and obvious. If you think it is obvious,
feel free to comment/send a patch.

Best regards,
Krzysztof
