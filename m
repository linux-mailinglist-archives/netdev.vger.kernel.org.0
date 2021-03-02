Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9932A2DB
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837718AbhCBIdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbhCBCJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:09:19 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0D7C061221
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:05:09 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id k2so14614985ioh.5
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YuUOZilAPqtQ1SZQR/vTqn0A0mCysPgz4pmCeU7TVwA=;
        b=CSXUqM6rGhHKiQX2k8GL6zA4oMI4IxoVfDmGlYXBm2crqJfK0V5wqHl/US8WkpZ0Ak
         F++JeQlUo36xDmY1/EAjeu6lPL9vMzW2hsEAb23KK7C/VpVEsyVCQY3SPE6xXISgEtT7
         Px/dEzdrPFrlgENwv+uq4DE/Soj11T57VRLnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YuUOZilAPqtQ1SZQR/vTqn0A0mCysPgz4pmCeU7TVwA=;
        b=jFLF2wjjVOJ4D9Kvnd2h+wWPfbNUAW7GJeF9vau9XB0GmmBI5zYE1h0W5Hpp33p9CO
         9mYHUZFNaG9I81T6qd2QeL1xfAqp928inF1kTdaJGKGIe/5Hm8xDnzxG6q+flJOq2cCo
         V/xPsNvvlsLdAvSSI6v6XeeAWuwyPi3pEytXcYCBeperoyev57oV1lfdGfWeGLTPjIBI
         glcX1afO05zgW/f5QF2xKr1EmlWF0DHKpWqBBrwAaOUiaKb2q+wYDMP4uveHP0vkHEtX
         kUhO9DGJOMGe7pBA212Lp/S22Gzt+15iVNhCiQixhuD4KFjVIrlTU/qen/NJmYHdJJXa
         wYNg==
X-Gm-Message-State: AOAM531KXcHHVcxsspx4YtYSGRTJo/z9q8u03iq+T7ODwcxvukUaqKE5
        6hiRGqMIgTFH5zTE8ieojVLrtQ==
X-Google-Smtp-Source: ABdhPJwCRrdGCnsEA1cgycV1Nefbv3RWZiKM6W4aDW+mGlSmGj069gmdSe+Z46hECvP08Gsux5qADQ==
X-Received: by 2002:a5e:cb4b:: with SMTP id h11mr16540014iok.108.1614650708781;
        Mon, 01 Mar 2021 18:05:08 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h13sm10921008ioe.40.2021.03.01.18.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 18:05:08 -0800 (PST)
Subject: Re: [PATCH v1 2/7] net: ipa: endpoint: Don't read unexistant register
 on IPAv3.1
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-3-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <73d19c5a-fddb-05d8-4787-de613091cbeb@ieee.org>
Date:   Mon, 1 Mar 2021 20:05:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-3-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> On IPAv3.1 there is no such FLAVOR_0 register so it is impossible
> to read tx/rx channel masks and we have to rely on the correctness
> on the provided configuration.

This works, and is simple.

I think I would rather populate the available mask here
with a mask containing the actual version-specific available
endpoints.  On the other hand, looking at the downstream code,
it looks like almost any of these endpoints could be used.

So, while I don't know for sure the all-1's value here is
*correct*, it's more of a validation check anyway, so it's
probably fine

					-Alex

> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>  drivers/net/ipa/ipa_endpoint.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 06d8aa34276e..10c477e1bb90 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -1659,6 +1659,15 @@ int ipa_endpoint_config(struct ipa *ipa)
>  	u32 max;
>  	u32 val;
>  
> +	/* Some IPA versions don't provide a FLAVOR register and we cannot
> +	 * check the rx/tx masks hence we have to rely on the correctness
> +	 * of the provided configuration.
> +	 */
> +	if (ipa->version == IPA_VERSION_3_1) {
> +		ipa->available = U32_MAX;
> +		return 0;
> +	}
> +
>  	/* Find out about the endpoints supplied by the hardware, and ensure
>  	 * the highest one doesn't exceed the number we support.
>  	 */
> 

