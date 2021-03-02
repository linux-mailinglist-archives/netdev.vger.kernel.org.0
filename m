Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24D32A2D8
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837697AbhCBIdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241535AbhCBCJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:09:11 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F4C0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:05:05 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p16so20084547ioj.4
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lShKGzJkTzSpuSC/KuZ9tUSmtNjp0IXSW8EKOFz63GY=;
        b=JQLqCtKm0J1NtDMqYPUP3AFphigmwPcsFkforr738h4L+vV7zy9PyTvRVKhJHM+mqJ
         jQ98Yfw7gvOL4w515Xi+DsMT4RaiYJnW3JIXEiiLXFMFkixAkKBS5wsRzG+50gJhN5wB
         w6OEVUdXYvY1vojHdKd/oVTyXyerWWjxZa/jM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lShKGzJkTzSpuSC/KuZ9tUSmtNjp0IXSW8EKOFz63GY=;
        b=XjNG6W7o+NnQ2Rp6OtSFdn8sFRys5mN7ueQzDMq5MOR6AUCUWlTpgYaLDoVL/MJg3l
         Hn0+aVJ2L1+eDbwR4RnlUdpSYJaoPeaLu3W6JDYvH80fahe7BPSBDiAzRM+7n677rCp9
         KRIIuCzEO9hQtbUBh4AyqcWLUKtAjjxDlwnh0WEPtR3IhpZgtb5Cwa9vOMSDaAsPTGYB
         IJvNzIdqWwS4zGjTM8mWaB3AVMaXktMQUZu6iSSY5tdUiQNRtDoleWqAJ8UtMasisvYE
         fLTJdKzrRg+sgOB+Hqa1xN57SV//5jG0jF6sa2BUPFeg/nrI7om0OgKQX+dBOrN91Ndg
         rujQ==
X-Gm-Message-State: AOAM533QcQJ4KN4ZPbayBRJXnXI9zxx2CECaV+UyofocIq0Lk0XTTzxC
        bv3CjuxmBRIhWN+YFOkpIP+O+w==
X-Google-Smtp-Source: ABdhPJyUL49sp6S9EK1ZvwtCMcYhEmHCmQNlOyGbNtRGezfLN8L0jawaBDPMHObtCHJG/CLOenrbtw==
X-Received: by 2002:a5e:9612:: with SMTP id a18mr16035795ioq.209.1614650704475;
        Mon, 01 Mar 2021 18:05:04 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k14sm9306568iob.34.2021.03.01.18.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 18:05:03 -0800 (PST)
Subject: Re: [PATCH v1 1/7] net: ipa: Add support for IPA v3.1 with GSI v1.0
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-2-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <7fdac2c4-b599-6db5-21e2-676c850edcf8@ieee.org>
Date:   Mon, 1 Mar 2021 20:05:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-2-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> In preparation for adding support for the MSM8998 SoC's IPA,
> add the necessary bits for IPA version 3.1 featuring GSI 1.0,
> found on at least MSM8998.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

Overall, this looks good.  As I mentioned, I've
implemented a very similar set of changes in my
private development tree.  It's part of a much
larger set of changes intended to allow many
IPA versions to be supported.

A few minor comments, below.

					-Alex

> ---
>  drivers/net/ipa/gsi.c          |  8 ++++----
>  drivers/net/ipa/ipa_endpoint.c | 17 +++++++++--------
>  drivers/net/ipa/ipa_main.c     |  8 ++++++--
>  drivers/net/ipa/ipa_reg.h      |  3 +++
>  drivers/net/ipa/ipa_version.h  |  1 +
>  5 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 14d9a791924b..6315336b3ca8 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -794,14 +794,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
>  
>  	/* Max prefetch is 1 segment (do not set MAX_PREFETCH_FMASK) */
>  
> -	/* We enable the doorbell engine for IPA v3.5.1 */
> -	if (gsi->version == IPA_VERSION_3_5_1 && doorbell)
> +	/* We enable the doorbell engine for IPA v3.x */
> +	if (gsi->version < IPA_VERSION_4_0 && doorbell)

My version:
        if (gsi->version < IPA_VERSION_4_0 && doorbell)

So... You're doing the right thing.  Almost all changes I made
like this were identical to yours; others were (I think all)
equivalent.

>  		val |= USE_DB_ENG_FMASK;
>  
>  	/* v4.0 introduces an escape buffer for prefetch.  We use it
>  	 * on all but the AP command channel.
>  	 */
> -	if (gsi->version != IPA_VERSION_3_5_1 && !channel->command) {
> +	if (gsi->version >= IPA_VERSION_4_0 && !channel->command) {
>  		/* If not otherwise set, prefetch buffers are used */
>  		if (gsi->version < IPA_VERSION_4_5)
>  			val |= USE_ESCAPE_BUF_ONLY_FMASK;

. . .

> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 84bb8ae92725..be191993fbec 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c

. . .

> @@ -276,6 +276,7 @@ static void ipa_hardware_config_qsb(struct ipa *ipa)
>  
>  	max1 = 12;
>  	switch (version) {
> +	case IPA_VERSION_3_1:

I do this a little differently now.  These values will be
found in the "ipa_data" file for the platform.

Also I think you'd need different values for IPA v3.1 than
for IPA v3.5.1.

>  	case IPA_VERSION_3_5_1:
>  		max0 = 8;
>  		break;
> @@ -404,6 +405,9 @@ static void ipa_hardware_config(struct ipa *ipa)
>  		/* Enable open global clocks (not needed for IPA v4.5) */
>  		val = GLOBAL_FMASK;
>  		val |= GLOBAL_2X_CLK_FMASK;
> +		if (version == IPA_VERSION_3_1)
> +			val |= MISC_FMASK;

I see this being set for a workaround or IPA v3.1 in the
msm-4.4 tree, but the other two flags aren't set in that
case.  So this might not be quite right.

> +
>  		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
>  
>  		/* Disable PA mask to allow HOLB drop */

. . .
