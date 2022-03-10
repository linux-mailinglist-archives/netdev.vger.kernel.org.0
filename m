Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9BB4D5389
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbiCJVU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 16:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiCJVU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 16:20:57 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6468B5BE66
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 13:19:55 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1D4343F1AF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646947187;
        bh=9DmBnTPJmgfr8wJC4s2tQqC5+M2g/VQlbp1lfsPPtrg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=TbYxkSGDGpB+9LWMIcVrg/bKxfcGPedih+1jROjbklTGSPGnT8HSP3sgc8bZ6/LkS
         rOyeRbCE4m31eogGMA8HknzxDE9ntuUwsfoqtUL4XLQR3K/uIlBPg8tJQqjgeWwPNg
         NFyle0JOpc7uViUfkSixVt881DBA2mfBmfIu2ZOr7wIyKO7hxXCEIN6RTqu/IEOMaa
         uiob7bceabyF7HlIlNWLngGVTisQgQIgJx5IPZExaKB6xe7jAh178Hv930En95ltg8
         lmxguayBsyolhw/kyqh5IY45ySP8KH4OJX3aF8QfVpRr7EYLuj2G9ythIqYZILjIl6
         8I+KsxVWG/vhg==
Received: by mail-ej1-f70.google.com with SMTP id m4-20020a170906160400b006be3f85906eso3777270ejd.23
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 13:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9DmBnTPJmgfr8wJC4s2tQqC5+M2g/VQlbp1lfsPPtrg=;
        b=MgNQXEPBYx6yXt52itfuu4oAJ3cuqvneoGyGgy1sZrP6LBd4aMjukEWEHpOq7kEusb
         G+5Exp333AKFMatdT7/jzuCor4ub81DdVcheNFWFC0SsZhzDkbGm+nd7hvxpt4/PZ9+e
         ukKNZFCpVLBUqHDCLfFn2sXG8gn/H5DsEO8Ya14gZS1AJEA+7VbUFmFP+1PfON8m38E+
         z1oGRoY3FO9OCPhvL3+IA4qK7P1ezmItmKG4UqIwiRNphVo6ZNGJcEPRF0Yk4OC6ZvV9
         P0aajFRSljT1nJWLGUpm4elW+DcgxZYdYoxcJ8EQJxQuBSxnMJSuR8oK3vaCv9b+dNOb
         azEg==
X-Gm-Message-State: AOAM530iCAX77XN3pyldnIlICgV+piiliF96rgKcb4NaP8ZtBJHtviNz
        ruUKI2q3DS8cuApCW/b+/YvbXJKYt6oDj8IQQH06lvQTgxLnTdf38bubjZKIzTOhe4021NWksUZ
        8TiyjbTJeRYgzTEjXSRJmnAddICahYUAjzA==
X-Received: by 2002:a17:906:4108:b0:6db:867c:f3ab with SMTP id j8-20020a170906410800b006db867cf3abmr4064710ejk.708.1646947186744;
        Thu, 10 Mar 2022 13:19:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpPhoEYeMm5ZEZqUHmwNDHKl/pnXpf7yeFjdCLVUvg18iW5ZSftFmEY3A2p0wQ8bC7jpG3FA==
X-Received: by 2002:a17:906:4108:b0:6db:867c:f3ab with SMTP id j8-20020a170906410800b006db867cf3abmr4064700ejk.708.1646947186550;
        Thu, 10 Mar 2022 13:19:46 -0800 (PST)
Received: from [192.168.0.147] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id yy18-20020a170906dc1200b006d6e5c75029sm2114790ejb.187.2022.03.10.13.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 13:19:46 -0800 (PST)
Message-ID: <c5791ed0-1bde-3b55-1237-822111bd6251@canonical.com>
Date:   Thu, 10 Mar 2022 22:19:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Hongxing Zhu <hongxing.zhu@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-3-ioana.ciornei@nxp.com>
 <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
 <20220310173223.pl2asv55iqfmbasq@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220310173223.pl2asv55iqfmbasq@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 18:32, Ioana Ciornei wrote:
> On Thu, Mar 10, 2022 at 05:47:31PM +0100, Krzysztof Kozlowski wrote:
>> On 10/03/2022 15:51, Ioana Ciornei wrote:
>>> Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
>>> driver on Layerscape based SoCs.
>>
>> The message is a bit misleading, because it suggests you add only
>> compatible to existing bindings. Instead please look at the git log how
>> people usually describe it in subject and message.
> 
> Sure, I can change the title and commit message.
> 
>>> +patternProperties:
>>> +  '^phy@[0-9a-f]$':
>>> +    type: object
>>> +    properties:
>>> +      reg:
>>> +        description:
>>> +          Number of the SerDes lane.
>>> +        minimum: 0
>>> +        maximum: 7
>>> +
>>> +      "#phy-cells":
>>> +        const: 0
>>
>> Why do you need all these children? You just enumerated them, without
>> statuses, resources or any properties. This should be rather just index
>> of lynx-28g phy.
> 
> I am just describing each lane of the SerDes block so that each ethernet
> dts node references it directly.

Instead, phy user should reference phy device node and phy ID. Just like
we do for other providers (everything with #xxxxx-cells).

> Since I am new to the generic PHY infrastructure I was using the COMPHY
> for the Marvell MVEBU SoCs (phy-mvebu-comphy.txt) as a loose example.

I don't know it but it might not be the best example... Just because we
have already some solution it does not mean it is good. :)

> Each lane there is described as a different child node as well. The only
> difference from the COMPHY is that Lynx 28G does not need #phy-cells =
> <1> to reference the input port, we just use '#phy-cells = <0>' on each
> lane.
> 
> What is wrong with this approach? Or better, is there an easier way to
> do this?

Because the nodes look artificial. It looks like you have nodes only
differentiate by index. As I said before - there are no other properties
in these nodes.

Imagine now a clock provider with 500 clocks like this...

The easier approach, especially since you have a shared registers, is to
use phy-cells = 1, without artificial nodes just to pass the index.

It would be entirely different if you actually had any properties in the
children. IOW, if these were actually some blocks with their own
characteristics and programming model.

Best regards,
Krzysztof
