Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6C663029A
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiKRXHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiKRXHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:07:32 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ADFC6218;
        Fri, 18 Nov 2022 14:54:08 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n12so16390071eja.11;
        Fri, 18 Nov 2022 14:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XdefQbV4KQWf7G5K/DDDpCCNxVpSLz3UodB9zU/uFQE=;
        b=ApUq30QHHA0C+ITKGMtFAWSA1tBdXsKcI4oGVlGaakbYGfefiK7jtlQ+6m+7TbXdCM
         s/vpn1LPzf4htm8RrTjJKGKj10nD2Iu8++TmfcAPUQXxGtIS6v7e9ok4g97ylWCMhhlX
         J0nFy9DJ41MdZiX947qSRLqmZXvOKmWlLCniIx6Ehkwl2lBnk8Kgahv+oaAmlBrnMgF0
         nNyVUzxPk7v6olNQJQCau+HRCWVL+XZ5WitBzHwDGlDk5YLC2MAmp2CJwrXAeTe/Z2Hc
         Y/gW/Kg26TbcuFSESGtdKTjEvelFRC1xY2L7iJkixYp0kFkXJlHEq6xv+H9ta00vUmGX
         yI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XdefQbV4KQWf7G5K/DDDpCCNxVpSLz3UodB9zU/uFQE=;
        b=uU/Vhz/xKZhn91n0BVxqLq8ZyTv0p5iXlNpVflJfrb1Dq7okp2KRKXmxj5qSlVH2sc
         18P1dc9bvoulF/ldb4wpOlXu+ccrAyHQnonJ3ERkpZy5H5Z60DwFAZhy28wys9goh4bx
         b2SU0OoC5gQSk3LEIod/FpOQylrDPp/6ghxnCC1CJUa4HgAcBQ5x/UE2umFQa0yBOggQ
         L2a2I/oMmhqObGgEbZyL/gPtkp72A5rBK7nu1ZBDfgP6wU1DJHgZ04BIZSnONhoGvyNb
         /O4XbQyNkoPw4NPcR4bl6zTJ0K4xYhlVAVkAibMy4TmAqz+s9c5zH/Byfe5lFkqloEBO
         FVzA==
X-Gm-Message-State: ANoB5pnlILN5hKKOT2lAOSLbFpQwHf9ADj/EdnzXpjgAjgX9qa1DSoic
        HrleqJUMK4L77yYhUSXjX4ikbSMOyEtxEHZo
X-Google-Smtp-Source: AA0mqf7peM8/hiBpj5lBLM18EivMJTSdFBpGt93iH6t5mPPi/EtEOcBFnAAWHAAEXGIBl2WBUEnS+g==
X-Received: by 2002:a17:907:393:b0:78d:f308:1cd with SMTP id ss19-20020a170907039300b0078df30801cdmr7698731ejb.754.1668812029601;
        Fri, 18 Nov 2022 14:53:49 -0800 (PST)
Received: from debian64.daheim (pd9e2965c.dip0.t-ipconnect.de. [217.226.150.92])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906840400b0078d4e39d87esm2190030ejx.225.2022.11.18.14.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:53:49 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1ow9Ih-000KKJ-1y;
        Fri, 18 Nov 2022 23:53:48 +0100
Message-ID: <c7805e64-57b5-5fa6-ff93-e37dcc01c40c@gmail.com>
Date:   Fri, 18 Nov 2022 23:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] p54: Remove unused struct pda_antenna_gain
Content-Language: de-DE, en-US
To:     Kees Cook <keescook@chromium.org>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20221118210639.never.072-kees@kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20221118210639.never.072-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 22:06, Kees Cook wrote:
> Remove struct pda_antenna_gain. It was unused and was using
> deprecated 0-length arrays[1].


I would like to keep it around. This struct is documenting what's coded
in the PDR_ANTENNA_GAIN eeprom (specifically that units value
(0.25 dBi units)).

> [1] https://github.com/KSPP/linux/issues/78
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/net/wireless/intersil/p54/eeprom.h | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/eeprom.h b/drivers/net/wireless/intersil/p54/eeprom.h
> index 1d0aaf54389a..10b6d96aa49e 100644
> --- a/drivers/net/wireless/intersil/p54/eeprom.h
> +++ b/drivers/net/wireless/intersil/p54/eeprom.h
> @@ -107,13 +107,6 @@ struct pda_country {
>   	u8 flags;
>   } __packed;
>   
> -struct pda_antenna_gain {
> -	struct {
> -		u8 gain_5GHz;	/* 0.25 dBi units */
> -		u8 gain_2GHz;	/* 0.25 dBi units */
> -	} __packed antenna[0];
> -} __packed;
> -
>   struct pda_custom_wrapper {
>   	__le16 entries;
>   	__le16 entry_size;

