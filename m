Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B76308D5
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiKSBxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiKSBw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:52:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DA8C622F;
        Fri, 18 Nov 2022 17:36:43 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x2so9455848edd.2;
        Fri, 18 Nov 2022 17:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=83d8Sesnunr+hRGPm9723ZzIcrO1pd7HQn5mMps4VUU=;
        b=oTaUSXNyESqaleRxe/fBbCQ3ybvPTU8zftHi+nWmGdUtWMvEyMvH46iRf8tCgeBtgh
         gz4pBbHxEMlq4CKiMSwvF9VBkQmiO6CWi9QbQvdbGPG+lX8yqYn4hElOeBOhsQ/wOrp+
         vMNU/ZE5iu2Wwr4b6IoGs9Z99/gx8e1J1TZ2pEjYSlb49xBVyRlsKA3a/F9cohfs9X6d
         cpvlma/vE5msLyrHj3K911MQFwQKnqzGAZq8dDu1NlhffsVJnZcwoaGNX7Ra2lD0LIGP
         fO3qNubLpkdgYY/3EQsVLovaK3CdE8+YEHsFGfyyWfNYjmNi9f2BUKzxI4g/DMZhJ7ju
         hksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83d8Sesnunr+hRGPm9723ZzIcrO1pd7HQn5mMps4VUU=;
        b=32/awBVXA9nOW+Nu+emHh41qMyxs6DK9eTGmgYEpgmmMBzGEkOoK3dn0bAJ1m94b2n
         jPwJWC05jeDvwMQufwHmEGnt6/wu5JUhD/u6JSrZBYgiuU6v4uuEH5WQKdJ8GKtZCGq8
         CzxAIIAKYjcZlKLrtWr88wopoRmkeIzL8df8GAYM8i4ww3s1Q88LyEI53fOXA2+FqnU4
         1tRylaZNFdWHc79hVsFl5/7opFgiVxhwcl4SMB4gjoZX6ASVWqllbuwHxShCrwgZOSTo
         b9Avm6MvesBEfl9hG1QuYtp7uZ5JwmzfGj+87gcqRzt0nryCK5KXI6/4b0W9yYO3zSq6
         OFWA==
X-Gm-Message-State: ANoB5pkzvjx/8QM53Dvarz8T7/izu2NKBZWVRyZN2cV/2lto8oRKNzJw
        RRA+TFFKWlz5nO0ZGqmNryP4M6eJYx4WwQ==
X-Google-Smtp-Source: AA0mqf5lRirvVKif3H699fIn6g7xywiXHj9A30EqfCEybWCCCeAtk3UI+uiSDLG556dm3cJLbEz70w==
X-Received: by 2002:a05:6402:3ce:b0:469:40c:ecfb with SMTP id t14-20020a05640203ce00b00469040cecfbmr5450442edw.164.1668821801677;
        Fri, 18 Nov 2022 17:36:41 -0800 (PST)
Received: from shift.daheim (pd9e2965c.dip0.t-ipconnect.de. [217.226.150.92])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709060cc200b0072f112a6ad2sm2329995ejh.97.2022.11.18.17.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 17:36:41 -0800 (PST)
Received: from localhost ([127.0.0.1])
        by shift.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1owCme-0002ms-0Q;
        Sat, 19 Nov 2022 02:36:40 +0100
Message-ID: <db584852-b6a6-f479-d073-1236ba1f3c0c@gmail.com>
Date:   Sat, 19 Nov 2022 02:36:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] p54: Replace zero-length array of trailing structs
 with flex-array
To:     Kees Cook <keescook@chromium.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20221118234240.gonna.369-kees@kernel.org>
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20221118234240.gonna.369-kees@kernel.org>
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

On 11/19/22 00:42, Kees Cook wrote:
> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member.
> 
> This results in no differences in binary output (most especially because
> struct pda_antenna_gain is unused). The struct is kept for future
> reference.
> 
> [1] https://github.com/KSPP/linux/issues/78
> 

Thank you!

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
Acked-by: Christian Lamparter <chunkeey@gmail.com>
> ---
> v2:
> - convert normally (chunkeey)
> v1: https://lore.kernel.org/lkml/20221118210639.never.072-kees@kernel.org/
> ---
>   drivers/net/wireless/intersil/p54/eeprom.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/eeprom.h b/drivers/net/wireless/intersil/p54/eeprom.h
> index 1d0aaf54389a..641c4e79879e 100644
> --- a/drivers/net/wireless/intersil/p54/eeprom.h
> +++ b/drivers/net/wireless/intersil/p54/eeprom.h
> @@ -108,10 +108,10 @@ struct pda_country {
>   } __packed;
>   
>   struct pda_antenna_gain {
> -	struct {
> +	DECLARE_FLEX_ARRAY(struct {
>   		u8 gain_5GHz;	/* 0.25 dBi units */
>   		u8 gain_2GHz;	/* 0.25 dBi units */
> -	} __packed antenna[0];
> +	} __packed, antenna);
>   } __packed;
>   
>   struct pda_custom_wrapper {

