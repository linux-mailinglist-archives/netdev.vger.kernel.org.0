Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6085B63029B
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiKRXJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiKRXJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:09:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A008EB8FA4;
        Fri, 18 Nov 2022 14:55:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s12so9110250edd.5;
        Fri, 18 Nov 2022 14:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1qjgFJ0JXZDD6fWRRqloiYHoC/E34P1QmiV3KDfZuBI=;
        b=OOg1Rcz7toSvUPccmUwF974bx0zmaJBIk/Vc27zRfSqlFqjOv/Qo4kZLNYnYp6Q0J/
         EMwwKn75MEY+lSJx15TaOSGFXXcM1qUhW7THdmv28JRUB3XsmNFqxJOh+zvbQoXgfrBl
         fqlsZ+7s9qWg9QGbhSmJOxBqMT3egYCxi4My1mWBsUcmbWHbsY0oHZCDK1qKonS9MPXd
         lGjNi5biCbHhBlC7hKuRGghyWYOmRORgkS1AOnvAZApRvWicRlVBnZsksq6IuC3xQlmj
         EHeDmIAM1jIqI8aJoasBBsaTcu6Cu6++Cacl8PcjgccMEU3P4irywphkDQOVZO0QEQrl
         6c+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1qjgFJ0JXZDD6fWRRqloiYHoC/E34P1QmiV3KDfZuBI=;
        b=uJ4+HC4KDYo5pJqQjmkVpilFFXCVl6h9EqIuBvSoFr6nJSyp5jXIREAn3TydEMH9CX
         HBwqC1NunGmTrpHRD4g1rceCFyhOWp4EL4J+qoo97Enk0kJCmVodmnRh2Ua3ZPfAz/9r
         9UJFyJqLzmDySzYteTVZBGMY/NN7WTOtiSYA9eSjuwdFsWz6IM18o1Qk0w1Vi/yXk0tQ
         iDE2xpIvRrF0JpJY7/c4c/65KOv5Szfm380nLdi9onDS4C5g4d9/rCEqPXTOmH5DGmKC
         XzbWbSz2JNQy0Cvk4ohvD2DJddG66XnueCWGvr1zs53B7fZ5JzBo50CJy+U8SIintZBK
         8EPQ==
X-Gm-Message-State: ANoB5plefHex7fzOIzz611ZWx2Wu8XlbjwQ5rCfazYyMVnTJe1GTpZpS
        d7Y8+R78+Mo3YvfJDTtMueWdY9WrOd/xf4AG
X-Google-Smtp-Source: AA0mqf7NqziDnizpHxdgZ1kaJhUQjX2zTeaf6RITlBvgkhBwWR2+weiwpwgwSZBLdavgDyRTGydKqg==
X-Received: by 2002:a05:6402:2b8c:b0:468:ebc8:7476 with SMTP id fj12-20020a0564022b8c00b00468ebc87476mr7194147edb.223.1668812096381;
        Fri, 18 Nov 2022 14:54:56 -0800 (PST)
Received: from debian64.daheim (pd9e2965c.dip0.t-ipconnect.de. [217.226.150.92])
        by smtp.gmail.com with ESMTPSA id da11-20020a056402176b00b00462bd673453sm2328304edb.39.2022.11.18.14.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:54:56 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1ow9Jm-000KLX-1i;
        Fri, 18 Nov 2022 23:54:55 +0100
Message-ID: <0500eccc-412b-40f3-e19b-251f383ff903@gmail.com>
Date:   Fri, 18 Nov 2022 23:54:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] carl9170: Replace zero-length array of trailing structs
 with flex-array
Content-Language: de-DE
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
References: <20221118211146.never.395-kees@kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20221118211146.never.395-kees@kernel.org>
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

On 11/18/22 22:11, Kees Cook wrote:
> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member.
> 
> This results in no differences in binary output.
> 
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
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/fwcmd.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
> index 4a500095555c..ff4b3b50250c 100644
> --- a/drivers/net/wireless/ath/carl9170/fwcmd.h
> +++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
> @@ -118,10 +118,10 @@ struct carl9170_reg_list {
>   } __packed;
>   
>   struct carl9170_write_reg {
> -	struct {
> +	DECLARE_FLEX_ARRAY(struct {
>   		__le32		addr;
>   		__le32		val;
> -	} regs[0] __packed;
> +	} __packed, regs);
>   } __packed;
>   
>   struct carl9170_write_reg_byte {

