Return-Path: <netdev+bounces-6614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C7C7171E7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F98D2812F4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602A434CFE;
	Tue, 30 May 2023 23:43:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523BBA927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:43:58 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73162EC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:43:56 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-77496b0b345so124897939f.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685490235; x=1688082235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3ypystYzBp0z6BGyUyrOubrVmHDSkpBeVSSYpzrgNU=;
        b=y9u0NB4kWnHYwt549HNPXWJTG3IRqe8/i0EgPjGKGvZyD3aP2NoPLebMVxLbcZdGoI
         B+1piYrPAfQVtfFMiqq4dy3hooHR5gQ2g1kves8qith5oI92YNMOzgnj/Q9RS/f7M9YH
         typUsW4DaeYZdS011PpV+S5goYadVJHRJ4mmOdUmWKHHgxFr2ch2RTCVA5C/6OpAHbbP
         zZSV8SaEUhvODRyfGj50W5/Pbe+d81pHxDxWupxNAcEFlKHLZ4IArqaV1NhbJ8aYjuB0
         ICsS+U4VmwCuLpSyNSeNDLk4yaRC62eZ1VzHy0kFHfpSYmt2RsnWTRukVJ11lVyEKiqo
         4dZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685490235; x=1688082235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3ypystYzBp0z6BGyUyrOubrVmHDSkpBeVSSYpzrgNU=;
        b=TchA8wrojDMdHVJ1DSgnIj1xow0dSN7vN/2KIA8x54VRwjuNJV7dEZ3LK75b/7A9xO
         lvETYiDGNbBFnOUjjkpAjvP+njcCpjgTXcq+Qcyre2eIC3McL1sSn/j6CGFK6eFjrCDh
         abf02js/R0jJ/cJbhQK1KJHYfhixH9PBLGwhggo+ml0riThvEZnIqnJTBUXOeuW1OkRu
         vhMzpdvPGc5kzF2k/dNbzhtwOWppAHpVMovHL9pf22F5SJnCCAHg6/QtrDSt9Z+vfohn
         PbVu3FpZgjiJe/XFDlvHFm+37gkBtXkUQH03wAI3t0srrZjHpyPQiHtRv5hxaMQe7/Ij
         zRzQ==
X-Gm-Message-State: AC+VfDyix9tLS7mJro+XGV52hzhhgdQeVu2MPs6+ho8HnyySZ8LA4FvT
	e20kCPeMiRvCCenCFdLN7YaIoA==
X-Google-Smtp-Source: ACHHUZ5eAUPfBfmQO0GDa5baK1HyIohLoaAUddvYA3t+pGk/ntaEhQaO5j0ioafC/00n6ndwS115vA==
X-Received: by 2002:a5d:87c2:0:b0:76c:65df:a118 with SMTP id q2-20020a5d87c2000000b0076c65dfa118mr2397211ios.6.1685490235653;
        Tue, 30 May 2023 16:43:55 -0700 (PDT)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id l5-20020a5e8805000000b0076c5c927acesm3522902ioj.13.2023.05.30.16.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 16:43:55 -0700 (PDT)
Message-ID: <694f1e23-23bb-e184-6262-bfe3641a4f43@linaro.org>
Date: Tue, 30 May 2023 18:43:54 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2] net: ipa: Use the correct value for
 IPA_STATUS_SIZE
Content-Language: en-US
To: Bert Karwatzki <spasswolf@web.de>, Alex Elder <elder@linaro.org>,
 Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
 <ZHWhEiWtEC9VKOS1@corigine.com>
 <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
 <3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
 <8d0e0272c80a594e7425ffcdd7714df7117edde5.camel@web.de>
 <f9ccdc27-7b5f-5894-46ab-84c1e1650d9f@linaro.org>
 <dcfb1ccd722af0e9c215c518ec2cd7a8602d2127.camel@web.de>
From: Alex Elder <alex.elder@linaro.org>
In-Reply-To: <dcfb1ccd722af0e9c215c518ec2cd7a8602d2127.camel@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 6:25 PM, Bert Karwatzki wrote:
>  From 2e5e4c07606a100fd4af0f08e4cd158f88071a3a Mon Sep 17 00:00:00 2001
> From: Bert Karwatzki <spasswolf@web.de>
> To: davem@davemloft.net
> To: edumazet@google.com
> To: kuba@kernel.org
> To: pabeni@redhat.com
> Cc: elder@kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Date: Wed, 31 May 2023 00:16:33 +0200
> Subject: [PATCH net v2] net: ipa: Use correct value for IPA_STATUS_SIZE
> 
> IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
> for the size of the removed struct ipa_status which had size
> sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.

If the network maintainers can deal with your patch, I'm
OK with it.  David et al if you want something else, please
say so.

Reviewed-by: Alex Elder <elder@linaro.org>

> Fixes: b8dc7d0eea5a ("net: ipa: stop using sizeof(status)")
> Signed-off-by: Bert Karwatzki <spasswolf@web.de>
> ---
>   drivers/net/ipa/ipa_endpoint.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 2ee80ed140b7..afa1d56d9095 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -119,7 +119,7 @@ enum ipa_status_field_id {
>   };
>   
>   /* Size in bytes of an IPA packet status structure */
> -#define IPA_STATUS_SIZE			sizeof(__le32[4])
> +#define IPA_STATUS_SIZE			sizeof(__le32[8])
>   
>   /* IPA status structure decoder; looks up field values for a structure */
>   static u32 ipa_status_extract(struct ipa *ipa, const void *data,


