Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D095E2E0D2C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgLVQTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgLVQTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:19:09 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0D5C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:18:29 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t16so15077433wra.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=l5JYdO0G6caKQkYVzVbQBX05/Mxdx7EgBcRxn9TVNGI=;
        b=Ck6iSSIq+tj4lktml/7YRcKCyqQ69s/LQqs0ziBFGo66Q/OtQigez0gK8x/iepV+IP
         8+K2YAVKM2MWnZ4DcarCqKEIv/TE8qN/0F3bqHufQC76QDO8krjDa6OMmOkNobmcvmaZ
         vzj6IQnZUT1eu4DQY67Rkr5AZy5MLSIPD8PgIAO9mKFTQ5Qiv6Pi10BK3EFI1dGkAU33
         plfYRRByLPa9ioWo86am4Yl5ZrmY0vZEPysFvc/cRw5JKgIh+QJ1+l9dXOMCiBuQZ8RU
         U6euyvK+k3G2HcGk8X3/ncLXQUvmEm2oIrZWmiuSj/CWOTYk5SVJITshqDr7GOmmE3KO
         +Qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l5JYdO0G6caKQkYVzVbQBX05/Mxdx7EgBcRxn9TVNGI=;
        b=SsR5Y/ACdb7vGb03ukvNWL0p4eakDHi1plDcaHm0t483SnE93ugw8uBBHU4BrsZ94t
         uQOb/52+eIwpfSJH+kfXBB6n8jCAoVUjOqHBtFuvFBBPwF2YLWePvgeOJ+7hbKzJ3BDM
         I37vlIcvJjKievebYxIJQ1oSSykAsjmEmv7OYs4UJxPaYHATdKUi6avclGoLBfkxfeUd
         feiVvRvl4+TGuJbiCx28utWtYM5dLLz8hIBXR1E6zntpRivdqFCKD9OP+nt2kpz7YsKO
         MCHf2Z+nADqQJMldo47uls8RgGIpwOKEPhgEr0UMa78dYcAk32zwSbMOXbBNZKSzp1hR
         wPtA==
X-Gm-Message-State: AOAM533UVxdNNgzQWeL1/8/0PpbDAt22jF2QhRSsa7vc4aEzjHKBnbKv
        tdpDNs9upxZVraakeiKRoSH1Cw==
X-Google-Smtp-Source: ABdhPJz0wfW54G46MT0SadD6GsZhf1tqvvXVF5nyJB8xMGHN4Itozx8PRRrdDIgJdQHPQSS6qD8MGg==
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr24388176wro.81.1608653908078;
        Tue, 22 Dec 2020 08:18:28 -0800 (PST)
Received: from [10.44.66.8] ([212.45.67.2])
        by smtp.googlemail.com with ESMTPSA id l16sm32592752wrx.5.2020.12.22.08.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:18:27 -0800 (PST)
Subject: Re: [PATCH net] net: ipa: fix interconnect enable bug
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201222151613.5730-1-elder@linaro.org>
From:   Georgi Djakov <georgi.djakov@linaro.org>
Message-ID: <9601b599-3edb-8fff-5b22-904cca62fbda@linaro.org>
Date:   Tue, 22 Dec 2020 18:18:31 +0200
MIME-Version: 1.0
In-Reply-To: <20201222151613.5730-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/20 17:16, Alex Elder wrote:
> When the core clock rate and interconnect bandwidth specifications
> were moved into configuration data, a copy/paste bug was introduced,
> causing the memory interconnect bandwidth to be set three times
> rather than enabling the three different interconnects.
> 
> Fix this bug.
> 
> Fixes: 91d02f9551501 ("net: ipa: use config data for clocking")
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Georgi Djakov <georgi.djakov@linaro.org>

> ---
>   drivers/net/ipa/ipa_clock.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
> index 9dcf16f399b7a..135c393437f12 100644
> --- a/drivers/net/ipa/ipa_clock.c
> +++ b/drivers/net/ipa/ipa_clock.c
> @@ -115,13 +115,13 @@ static int ipa_interconnect_enable(struct ipa *ipa)
>   		return ret;
>   
>   	data = &clock->interconnect_data[IPA_INTERCONNECT_IMEM];
> -	ret = icc_set_bw(clock->memory_path, data->average_rate,
> +	ret = icc_set_bw(clock->imem_path, data->average_rate,
>   			 data->peak_rate);
>   	if (ret)
>   		goto err_memory_path_disable;
>   
>   	data = &clock->interconnect_data[IPA_INTERCONNECT_CONFIG];
> -	ret = icc_set_bw(clock->memory_path, data->average_rate,
> +	ret = icc_set_bw(clock->config_path, data->average_rate,
>   			 data->peak_rate);
>   	if (ret)
>   		goto err_imem_path_disable;
> 
