Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4960E65C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiJZRWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 13:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbiJZRWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 13:22:16 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232F9A2B9
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 10:22:11 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id f8so11106494qkg.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 10:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oLlW1kscCZqIaTOlPcJH/jgt0YbKOWqVS01M6qgp7Uw=;
        b=w/j7e/fNOCN2iVFnKD8fD8BvhEM2bJk4xOdewSXDEFnHOZGff4bZ5IRRwFooNK/vjC
         RLiABqYXJAOzFl9nB1Ripgvl6j73RDhtXxtZxKy1HUQjPS3roj9630mO1NdwfExyW2+d
         HXxquLZV361r+bxmEtPw3jUC5jkvTL0RwdZfeF/BIEMyFD2OGfDjeVP8ynKMTEyvvx+F
         hHREYvY8RKqLJB1wC9fMSMlldzP0FJ6airbjaRnek0EUrBeMRv08K247pG/GijAS5za6
         K8+QAhtZhWb5xN/OVXIvTs3nJOuGnDqodc1MNQjfwsDZeWnnHRUSNK5VNxWL/P4yUdAd
         3sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLlW1kscCZqIaTOlPcJH/jgt0YbKOWqVS01M6qgp7Uw=;
        b=6bOiZCdGATxVd47agHPw47LKVDkHgTw0ik2wOHoh/wP3eF1VIwkXy/IHhc3500NfEe
         D7XkdVeHSGJD6lte/HUMMMn7xQBgcsUVkcsv+yOvXmk5spNWPfv0PiPJv4ugn7NXRhL5
         +vNyyX2MENGJ8nEFKq2Hf7ogCohwSU2r3Uu1+7+askgY3QuKD/G4avfoZncVeGlfHK04
         ivHZZqI/0SD35zuvWYpjGzl6y+hKAQo7g4OYQgfOZ3roRevJNiluVf0SGv2+fgeD1ViN
         3icCHCQCQtamedkgh3rV1UiYWpzKfTKrk9o/L5SP6BOjHdq9Bvp9T6uDZAI2BZe9mKL2
         zoxA==
X-Gm-Message-State: ACrzQf1CvAzte24MvPLpNIANwZnc70WNiM/AuMr+pdGxCAjEVLQKscXI
        8lWnO6h9aTqMuBQak5CP/CxlrA==
X-Google-Smtp-Source: AMsMyM6Kf2jYy3iJqZeqVyXShFrqXF8kTcxCcGJu4mG93deokS9fXIamGA2nuPqOdQnS49zUo6CUpQ==
X-Received: by 2002:ae9:dd04:0:b0:6e0:ae86:b4 with SMTP id r4-20020ae9dd04000000b006e0ae8600b4mr31724032qkf.146.1666804930281;
        Wed, 26 Oct 2022 10:22:10 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id x22-20020a05620a0ed600b006b61b2cb1d2sm4130569qkm.46.2022.10.26.10.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 10:22:09 -0700 (PDT)
Message-ID: <fe9b34f9-68f8-0d5d-4085-33a227b7c363@linaro.org>
Date:   Wed, 26 Oct 2022 13:22:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC 5/5] bluetooth: hci_mrvl: allow waiting for firmware load
 using notify-device
Content-Language: en-US
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
 <fa9cdbe5906fdcfcb37dbe682f3f46ce4b2e1b73.1666786471.git.matthias.schiffer@ew.tq-group.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <fa9cdbe5906fdcfcb37dbe682f3f46ce4b2e1b73.1666786471.git.matthias.schiffer@ew.tq-group.com>
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

On 26/10/2022 09:15, Matthias Schiffer wrote:
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
>  drivers/bluetooth/hci_mrvl.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
> index b7d764e6010f..dc55053574a9 100644
> --- a/drivers/bluetooth/hci_mrvl.c
> +++ b/drivers/bluetooth/hci_mrvl.c
> @@ -12,6 +12,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/firmware.h>
>  #include <linux/module.h>
> +#include <linux/notify-device.h>
>  #include <linux/tty.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> @@ -433,9 +434,25 @@ static int mrvl_serdev_probe(struct serdev_device *serdev)
>  		return -ENOMEM;
>  
>  	if (IS_ENABLED(CONFIG_OF)) {
> +		struct device_node *firmware_ready_node;
> +		struct device *firmware_ready;
> +
>  		mrvldev->info = of_device_get_match_data(&serdev->dev);
>  		if (!mrvldev->info)
>  			return -ENODEV;
> +
> +		firmware_ready_node = of_parse_phandle(serdev->dev.of_node,
> +						       "firmware-ready", 0);

So you want us to go through five patches, find properties and OF-code,
create in our minds bindings you think about and comment on that
imaginary bindings.

I think it should work otherwise - send bindings for all of your DT
properties.

Best regards,
Krzysztof

