Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8146B9A3B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjCNPra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCNPrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:47:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDABB1A73
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:46:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so32663827edb.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678808783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F24AUykmoujwlu8bPOT15t+HLTs3ektTBSdrQH1BgNE=;
        b=ijHfhSTXyeSBzyOnBwOobVBn6aXLUp9QNdlEdC0nv5pfH35PxfBcLhGAdrG6iyqL4/
         nMy6dZH4OGdGWCFXiLgM/hO1vEZQaWRdG/mygie3WM1BuznKD7cE/XfCZMv5w4dwx3UN
         vOdHtSZNCmJBfV6BywNYkd8RSGtIqi0frUGpfC2RS+1aTnsHl3wxuf5vk0aPnDJxgBF3
         t7Fm5XG9Z12OeB559JsPajSoGiOmrhrI8G9Wz/kP5+gJ4X2np7DgoHvJ/0LmjN8xTuDE
         32ZorLaQCP9vWjwJ4ovLLJF5+2QwaOWU3zhLwNlfUp0t4b9YtT+YXUGu0cQ2602vtBtd
         +9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F24AUykmoujwlu8bPOT15t+HLTs3ektTBSdrQH1BgNE=;
        b=nibmQDB+C0mhXsJVxG0Lld41TijBwc/TsIKg2bodWUJVvlS9Qm+xC2Jy6qr5w+CYGW
         TPnzFtNGxqo1a01/SdLMmVzL6FZTpRQhukiLSBwjr4EVXN6M43dVR0Ys73LvAtB18qKA
         fEM5OjscBK+jRO9TWwuJVbb3iVIGoHo6lXMNNfPlj+ZytS1GpuZ77oe03hrKeEHJJFmM
         kLJUaQ/zENGsb25TLmQNwGmcEn9qTLkjqBXwDHa9c/EC9uhLKdHBcycAiPttFAZ7b2UE
         TwcxWtv7wjubL9c0UipYiKnD5RemkDPz0tyWjLVWLQfmMFJy9EJCLR7hrPlUlf+POJec
         63hg==
X-Gm-Message-State: AO0yUKU9Mf9x9c23ft31mqm1DqHGxxlBg3nJ8PCV/FTeIAQtqKKv6oaz
        5sjPkmTG0qgxLJ0w8IzEp2DHXA==
X-Google-Smtp-Source: AK7set/huwM8TSsgEcLmJAmj81UQJX00g4nQcBlm5bflAXgoDF1dcRvB6W3X97H7hFulTkAnNip3pQ==
X-Received: by 2002:a17:906:12d8:b0:923:6558:84fb with SMTP id l24-20020a17090612d800b00923655884fbmr2667694ejb.3.1678808783068;
        Tue, 14 Mar 2023 08:46:23 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:59be:4b3f:994b:e78c? ([2a02:810d:15c0:828:59be:4b3f:994b:e78c])
        by smtp.gmail.com with ESMTPSA id r6-20020a17090638c600b00925d50190a3sm1298371ejd.80.2023.03.14.08.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:46:22 -0700 (PDT)
Message-ID: <c2773010-2367-ba20-e0fa-2e060cb95128@linaro.org>
Date:   Tue, 14 Mar 2023 16:46:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, richardcochran@gmail.com
Cc:     krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
 <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2023 06:44, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptp-hardware-clock property will contain phandle to PTP clock node.
> 
> Its a generic (optional) property name to link to PTP phandle to
> Ethernet node. Any future or current ethernet drivers that need
> a reference to the PHC used on their system can simply use this
> generic property name instead of using custom property
> implementation in their device tree nodes."
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> ---
> 
> Freescale driver currently has this implementation but it will be
> good to agree on a generic (optional) property name to link to PTP
> phandle to Ethernet node. In future or any current ethernet driver
> wants to use this method of reading the PHC index,they can simply use
> this generic name and point their own PTP clock node, instead of
> creating separate property names in each ethernet driver DT node.

Again, I would like to see an user of this. I asked about this last time
and nothing was provided.

So basically you send the same thing hoping this time will be accepted...

> 
> axiethernet driver uses this method when PTP support is integrated.
> 
> Example:
>     fman0: fman@1a00000 {
>         ptp-hardware-clock = <&ptp_timer0>;
>     }
> 
>     ptp_timer0: ptp-timer@1afe000 {
>         compatible = "fsl,fman-ptp-timer";
>         reg = <0x0 0x1afe000 0x0 0x1000>;
>     }
> 
> DT information:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23
> 
> Freescale driver:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n407
> 
> Changes in V3:
> 1) Updated commit description.
> 2) Add Acked-by: Richard Cochran.
> 
> Changes in V2:
> 1) Changed the ptimer-handle to ptp-hardware-clock based on
>    Richard Cochran's comment.
> 2) Updated commit description.
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 00be387984ac..a97ab25b07a5 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -161,6 +161,11 @@ properties:
>        - auto
>        - in-band-status
>  
> +  ptp-hardware-clock:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Specifies a reference to a node representing a IEEE1588 timer.


https://lore.kernel.org/all/cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org/

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Thank you.

Best regards,
Krzysztof

