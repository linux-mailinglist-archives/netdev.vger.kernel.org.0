Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480694D6231
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348832AbiCKNQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348815AbiCKNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:16:09 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716DD1C2F58
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:15:06 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7C2ED3F1A4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 13:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647004504;
        bh=xOL5KCXZ0SGH69gklhacxZ/8cP5ta3EREGmzsgqE7XU=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=TgjhHn5oqeAAfU45+JdYLW+/h0w5A8SfE4444bjg3ARfpL7FqHi/Qj07EgGcDhsvh
         IxYdFwPQcz3jboT0CT+lY2CTa3BUJpCdJDHKrLo0JrbfXWwdqhDz4xrFXpf+lC5Lh2
         uS3bnCKQDVJdtjs3Utw6fsZYP6/7mQEb+/HIuhcezS5O1xeJufvB2jjyCY9+nCVqGM
         GQDmVGEZ0DmfTrPgi/8lZQEEEqU+JmVgdUtk8r5zPSxZcr3Vht27zO5V1K+5EZsZRz
         UivPEN6NcGjY0vP3FmUgupKZm6BDQwO+OPxcjhttP2VilpHMI5q4t9oJng1LZsksdh
         4iJcCPLT8tWlA==
Received: by mail-ej1-f70.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso4899995eje.20
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:15:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xOL5KCXZ0SGH69gklhacxZ/8cP5ta3EREGmzsgqE7XU=;
        b=ZtV8drTjHRrCq55QqFMMP+PgEzrW9Km9E2t0yi3Ae2O/cD+HcAbtcRp6GBw5qCNwM8
         1QQUP2kwAQULkML5QkbaMjTttiw77saNwP4P5allpujgWzXwNnQSf9dTKaN7E90s+MMy
         mw0IADlfoZIFzPzwdLXClIKpWN1kXeahPWxJUCudKbvhPwxdSMSGPWp5wzRw5P6mMpjT
         zfTlk2Hi/qP5qrkiSc2eQGeQR8/rdWhwnFHOBo9NP8MC8epQ2QP0UtehX7A0fR5SdKGI
         uxsAIxeIHUB+CWhWp8e/qwFWaSYmO8B6w5QTBZgbRKayVxljugDfzzTmsswzB1XGtLby
         Wk1A==
X-Gm-Message-State: AOAM533d6Chzvex0mD6+dzjZCm1/r7SFILEHZX2qs6HG6NjQnID2jQRN
        8Rav9LfHa4HjcIn6Xb/zlKiuSmWEydXVlqDe5n0GL66jKTRaBejwdwk7lVGnxlXastaftKyTUJz
        JtLxr/HuJvIFoBMoqDGOCyjgVbTZ3XoIpAw==
X-Received: by 2002:a17:906:d29b:b0:6da:9e4d:bb7c with SMTP id ay27-20020a170906d29b00b006da9e4dbb7cmr8769373ejb.155.1647004504119;
        Fri, 11 Mar 2022 05:15:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5gVuyZQARyT4Ih8qZYzFfz39imMgrNy/pXVuj7BFtK1eQuAfgpviPhn6BRSfABhPjTA82iw==
X-Received: by 2002:a17:906:d29b:b0:6da:9e4d:bb7c with SMTP id ay27-20020a170906d29b00b006da9e4dbb7cmr8769338ejb.155.1647004503614;
        Fri, 11 Mar 2022 05:15:03 -0800 (PST)
Received: from [192.168.0.148] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id m26-20020a1709060d9a00b006da81fb9d72sm2917192eji.100.2022.03.11.05.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 05:15:03 -0800 (PST)
Message-ID: <f0e07031-2f4d-0625-201b-f65fa69107a5@canonical.com>
Date:   Fri, 11 Mar 2022 14:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
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
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
 <20220311125437.3854483-3-ioana.ciornei@nxp.com>
 <f782bf45-3a69-18b4-de0b-f53669aec546@canonical.com>
 <20220311131324.uzayrpnp2mifox23@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220311131324.uzayrpnp2mifox23@skbuf>
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

On 11/03/2022 14:13, Ioana Ciornei wrote:
> On Fri, Mar 11, 2022 at 02:09:05PM +0100, Krzysztof Kozlowski wrote:
>> On 11/03/2022 13:54, Ioana Ciornei wrote:
>>> +examples:
>>> +  - |
>>> +    soc {
>>> +      #address-cells = <2>;
>>> +      #size-cells = <2>;
>>> +      serdes_1: serdes_phy@1ea0000 {
>>
>> Comment from v3 still unresolved. Rest looks good.
> 
> Uhhh, I forgot to change the name. Sorry.
> 
> Do you have in plan to look at any other patch? I am asking just so I
> know when to send a v4.
> 

No, I am just checking the bindings. Maybe wait a bit before sending v4
to give other people chance to review :)


Best regards,
Krzysztof
