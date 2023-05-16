Return-Path: <netdev+bounces-3075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C88705575
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D40628163D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516A411C96;
	Tue, 16 May 2023 17:53:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DD6107A1
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:53:08 +0000 (UTC)
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ECF2103;
	Tue, 16 May 2023 10:53:06 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6ab032b33cdso9752356a34.0;
        Tue, 16 May 2023 10:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684259585; x=1686851585;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=tOI1hYW67SjZXfGOAMASjvbTwzn47DF5rYlXPgVWPpM=;
        b=VVHHTpRXqC3V+VFxXYETdejgUe3qThzYQe2uCdWp6NI61RxmRjSneqHbHEWIYh+29L
         WY+IAveCsBjw/t9lowHvkFDGfPuz8xmO2+nTC9SdEOoCjeQ0UFk8XklDCw2Vq/5PZePu
         rBBelLWarDf7lKhGEmA1BvWwhgeWbh7sQuzpKw4iq2CwKrPmbXCSVGHeGZACCyHTSTJh
         scIQVUOG7SJVEhBOqVFFES8Q8rMaK+69ueLAo1Lfn+h3HA6pkbkkgrC6TTGj7aRF79dT
         kzsy0t8rZgrkmFG79+CcwGQ/gij6ASjeURcVOGpj9f43PO1bK+vs/5eAm/TjyPMHdUmN
         XJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684259585; x=1686851585;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOI1hYW67SjZXfGOAMASjvbTwzn47DF5rYlXPgVWPpM=;
        b=CK1IcPAD4PFmHXOyomiiLDxGGXCax/HgnRVaUMLdbQxHocuWsmrnUWvGzGwhz44AnX
         M+U99fnsMjJaC0pMyr6iGYtcJwywSwx3AH9MzZ2sfXz9N+4ulqVXaswkaIu/hrV4I73D
         qPDPGPRQM10GJPLD3pts88f/c5NNtsG/BtGRMbBEf7KKNl+F1w9GiAK/lQ3L1VzFX0mt
         p3nyVj/8JvNSXOru8EIvtRWV/BpARHbycrVHrURpGtpnprt6mWG1/Dwg3IUezDKp61Tm
         VLaonJ4rCap4sw1Fyu64oKwlEkCxALVgCLajOMIhh1Zuk+5FlpJbB9YvFz5IVXJwsfjg
         0jxw==
X-Gm-Message-State: AC+VfDzeSl2iHdg8FUsbra/iXYzFWIrN1z0Tq/9BVizg9nvwyeneDSK/
	2iH9R0VO6Ljpwnes+KFrNz4=
X-Google-Smtp-Source: ACHHUZ5ZRxQEd6piT85OMVZwtPep8hK0vyFbEtWIgfKfIATKxhHVJs7wQvmtMQTt3s6kfkezMYepPQ==
X-Received: by 2002:a05:6830:3a8f:b0:6ab:30f3:6e69 with SMTP id dj15-20020a0568303a8f00b006ab30f36e69mr10718110otb.15.1684259585284;
        Tue, 16 May 2023 10:53:05 -0700 (PDT)
Received: from [192.168.0.200] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id g26-20020a9d6b1a000000b006a647f65d03sm4402113otp.41.2023.05.16.10.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 10:53:04 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <b8e61f82-bb1d-4778-3624-157890b1b8dd@lwfinger.net>
Date: Tue, 16 May 2023 12:53:03 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] wifi: b43: fix incorrect __packed annotation
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20230516074554.1674536-1-arnd@kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230516074554.1674536-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 02:45, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about an unpacked structure inside of a packed one:
> 
> drivers/net/wireless/broadcom/b43/b43.h:654:4: error: field data within 'struct b43_iv' is less aligned than 'union (unnamed union at /home/arnd/arm-soc/drivers/net/wireless/broadcom/b43/b43.h:651:2)' and is usually due to 'struct b43_iv' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
> 
> The problem here is that the anonymous union has the default alignment
> from its members, apparently because the original author mixed up the
> placement of the __packed attribute by placing it next to the struct
> member rather than the union definition. As the struct itself is
> also marked as __packed, there is no need to mark its members, so just
> move the annotation to the inner type instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/wireless/broadcom/b43/b43.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
> index 9fc7c088a539..67b4bac048e5 100644
> --- a/drivers/net/wireless/broadcom/b43/b43.h
> +++ b/drivers/net/wireless/broadcom/b43/b43.h
> @@ -651,7 +651,7 @@ struct b43_iv {
>   	union {
>   		__be16 d16;
>   		__be32 d32;
> -	} data __packed;
> +	} __packed data >   } __packed;

This change works on a BCM4306 and BCM4318=.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

To answer Michael's question, b43legacy has the same issue.

Larry


Larry



