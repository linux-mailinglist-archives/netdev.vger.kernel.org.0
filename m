Return-Path: <netdev+bounces-1115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE616FC3D8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BA7D1C20AF2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DFCDDD9;
	Tue,  9 May 2023 10:27:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F6AD39
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:27:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0018DDC65
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683628058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uwJ3DY9RdcSd+YOIHggeltEqU051lT22jrjPoxOONus=;
	b=S19gNRw6CeB9mvSl7AlV7Y8uhMOpnC8rCnQYSUld7s4aJc0YS8Ktjt4NCxlpZfYeTwa+bl
	DVuESs49q/iDaQyVwwK2qEy62k/1a5snpQHdF4fSkaRv5cVkJQnGqaJdaI3CY9xZ+/m18+
	qsQSycUfFhljjYQZd7Z/LzLFuI4dxu0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-t9dB72JoNumWCF1x8ZElug-1; Tue, 09 May 2023 06:27:37 -0400
X-MC-Unique: t9dB72JoNumWCF1x8ZElug-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9662fbb79b3so300772666b.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628056; x=1686220056;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwJ3DY9RdcSd+YOIHggeltEqU051lT22jrjPoxOONus=;
        b=guct1GYOwTu+wpo/L0wQtkW6AiXNSEukKpTFv2XmUw0swBeLpMPEwyWh3/krteBYqQ
         jTMZkyKxxiDHRKitnfAaLfHqeeZcpf0DVEye1HLasA89GB4/nNdK3EYGYb9c8JRf1Gmo
         TjAwNuW8L9UeCiXhqKsxPWsodi/xqADja+yRAjEfY9cD6pYpuOvlvcXPnbJHL0FdJlY3
         0SZEOj6PIXhJ8vmTbQI/FCbe1+MvM4m7DkUnbO5JxMbMbMcb1us05CxrF6eghPWMdZN/
         BDynURWc46lzL8FJAvwLXJRDuo3wg+qg06XfyJS3GCFGKTOtlXwGY7eKNkug/qbk/dIp
         YhZQ==
X-Gm-Message-State: AC+VfDw6kDf7rPxVzqJNnaPe8az3neVz/jX509HMGHOqoHQdFuJA/Ph0
	5HS2fRgvfuPfyMRGZIMvd/q3U9xpHAmmOmpAFuXMIhemG88VO8MEjyWnd7bf7kC3mWSGRihKqWw
	9u5CiyagHm8KSewTT
X-Received: by 2002:a17:907:7d9e:b0:969:f54c:dee2 with SMTP id oz30-20020a1709077d9e00b00969f54cdee2mr1339922ejc.26.1683628055929;
        Tue, 09 May 2023 03:27:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dBcF0PeeSSPZxUvJ2br+FqbE5k+D1T5jX/3UjFICYV5HGVZEnqvbF6oMuzkxkJk9L157EPQ==
X-Received: by 2002:a17:907:7d9e:b0:969:f54c:dee2 with SMTP id oz30-20020a1709077d9e00b00969f54cdee2mr1339892ejc.26.1683628055613;
        Tue, 09 May 2023 03:27:35 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id mc27-20020a170906eb5b00b00966330021e9sm1146359ejb.47.2023.05.09.03.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 03:27:35 -0700 (PDT)
Message-ID: <3e87dd49-b2c0-c6a9-5385-c075e5264de1@redhat.com>
Date: Tue, 9 May 2023 12:27:34 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: brcmfmac: wcc: Add debug messages
Content-Language: en-US, nl
To: matthias.bgg@kernel.org, Arend van Spriel <aspriel@gmail.com>,
 Franky Lin <franky.lin@broadcom.com>,
 Hante Meuleman <hante.meuleman@broadcom.com>, Kalle Valo <kvalo@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 SHA-cyfmac-dev-list@infineon.com,
 Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
 Matthias Brugger <mbrugger@suse.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
References: <20230509100420.26094-1-matthias.bgg@kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230509100420.26094-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On 5/9/23 12:04, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> The message is attach and detach function are merly for debugging,
> change them from pr_err to pr_debug.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>

Thank you, I had writing this same patch on my own TODO list :)

Patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans






> ---
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
> index 02de99818efa..5573a47766ad 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
> @@ -12,13 +12,13 @@
>  
>  static int brcmf_wcc_attach(struct brcmf_pub *drvr)
>  {
> -	pr_err("%s: executing\n", __func__);
> +	pr_debug("%s: executing\n", __func__);
>  	return 0;
>  }
>  
>  static void brcmf_wcc_detach(struct brcmf_pub *drvr)
>  {
> -	pr_err("%s: executing\n", __func__);
> +	pr_debug("%s: executing\n", __func__);
>  }
>  
>  const struct brcmf_fwvid_ops brcmf_wcc_ops = {


