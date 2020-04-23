Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941231B587E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgDWJqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726953AbgDWJqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 05:46:33 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8831BC08C5F2
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 02:46:33 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j14so4220621lfg.9
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 02:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0bn5MZ3x1AZMueYLHBvYYK4+M4Vkn8wTCGTXb/d2uVE=;
        b=uUop0dX6USv5o0OS0FsApSO+QvBdobyuottPosBAc0udDrdY2SxeBV5a6bdeUQOx5z
         MKAs4zdQdfAKliIGLGt7qagS4L8LMq726kRgyEkwDLhU9B0M3BmDfK40bSEmf/rzTOie
         wV1L912Hhuw3qlbV+F3v2EKuxZfE0KY47fwcFWMR3ONnbF2N5wWRQNlTEr/XDrzT+Wwc
         LQOrdSoPSxQp7PPEkQPKs2MhYDuMizWLdfPkgG33tX2BUGytcxTPeUhZVCCf77Xb0J/Q
         +6o5wVcgQ6gCA9vaA7J3A25ZsnplIoIDyv5qQG6divGjAphr14PyAexwet/CDVpDhyqc
         g7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0bn5MZ3x1AZMueYLHBvYYK4+M4Vkn8wTCGTXb/d2uVE=;
        b=et1THJyYOdm5NagNG3wOEo0twwbIKvZPLXcyfnLQJsFmx+FZS/xFHNV9itAFn8IG27
         Uz1wm6pbcDxY9Hd8tCXIDDo1EblMcQfHa432XoUVWI+BV/ob8linCAOUD6D/T0Atm5v3
         ovFPP7hmwc52IiZgJdpH1NcaF0QK/JFDWU20kq6xQh2THFRvEE2JR9Xz3DWk2gQajzTF
         QdJrFlAs9pxstn/j+UVvo8I+xIme8I4BL032mbbj1ksviTr7K/9YoKyaj2R0lv9n7Zmb
         yljMeI3Lw7fbU8zh2eryQte51Wmj67xG2GFpeHpvYxpRk1iCEaCgJOCex889mLEzV+pT
         lE2A==
X-Gm-Message-State: AGi0PuaogWmwhBwfbAjFa6hUAPbn+5/k0leBCoTqczVqRUPyUEWGDo3P
        lRb56TMGRNe4wXnZArRHcEeiwA==
X-Google-Smtp-Source: APiQypLEwhN/y4/l8USQl+mMh50NmWYjOi6/qdBQHkmlNJmc+IJxk5qI719O25WlSoGqZjWR2xG1OA==
X-Received: by 2002:ac2:5930:: with SMTP id v16mr1893719lfi.103.1587635191938;
        Thu, 23 Apr 2020 02:46:31 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:46dc:a81c:1cf:8fa9:cce2:9ac2? ([2a00:1fa0:46dc:a81c:1cf:8fa9:cce2:9ac2])
        by smtp.gmail.com with ESMTPSA id o195sm1322097lfa.50.2020.04.23.02.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:46:31 -0700 (PDT)
Subject: Re: [PATCH] ipw2x00: Remove a memory allocation failure log message
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5868418d-88b0-3694-2942-5988ab15bdcb@cogentembedded.com>
Date:   Thu, 23 Apr 2020 12:46:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 23.04.2020 10:58, Christophe JAILLET wrote:

> Axe a memory allocation failure log message. This message is useless and
> incorrect (vmalloc is not used here for the memory allocation)
> 
> This has been like that since the very beginning of this driver in
> commit 43f66a6ce8da ("Add ipw2200 wireless driver.")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index 60b5e08dd6df..30c4f041f565 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
>   	struct pci_dev *dev = priv->pci_dev;
>   
>   	q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
> -	if (!q->txb) {
> -		IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
> +	if (!q->txb)
>   		return -ENOMEM;
> -	}
> +

    No need for this extra empty line.

>   
>   	q->bd =
>   	    pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, &q->q.dma_addr);

MBR, Sergei

