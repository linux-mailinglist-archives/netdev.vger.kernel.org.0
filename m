Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371D31ABD15
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503936AbgDPJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503885AbgDPJla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 05:41:30 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E1C061A10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 02:41:29 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h25so7056931lja.10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=urM8neQX7XsUTgvN1mrENHwP+WlS7ZzAFP+q6PzZXxo=;
        b=LkCIZDutBrmDDKbUVTx2RtnA6XlHaVRydug3tKtMGC/HBlSKGXhT3gxXsv1XDdqIgN
         1Af0eq2RPSv2eZUjuHTRB0Vqus6MdxswJ+cBWh4Ud4MrHWa5Hj88CmEJ9XIAJNBxg/Ag
         l9fgrjpEhR4V/Hf40go+zO6kaklUdxIxSDCAZyHFM/XtyJd/ptPj7r1INASbv4P1Sshr
         uJMqDkCZAKFQcrcfxPFEFvWOmsM0VjLEdJH44oUkx6pUG46neTnQ0xzusRPeh0k7oXMr
         awyTJr9EiWUeV1oA010X5B+z8ErNQD2JSVPfLH6Fmz9q1ot0B9Wa3J+0z97UZf+2Zvys
         YC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=urM8neQX7XsUTgvN1mrENHwP+WlS7ZzAFP+q6PzZXxo=;
        b=KRYronuopzQuYWUhOOPLMtccfbkQumrXqb5HgrxXBp9ZVzazAcK746Hr/bw+0b7aQU
         ODZODEFsOZIIjl0l1Dq7iHLFpwdk0D3N1AoseBzxcmbM0zQOiu4MS0KUXFrZeTIt6yph
         830dJ5it30qu//lzbjmf+vuo4Ip3zabcHJjpk6A9OaNAp5mjr2dN8Ipw3QL2+ge/ybDQ
         7Sk+8IjwdbZ3AXL6w0UhSZJkrx1c+cmY4g3JZdEZPh9/LHUJFJz+rKw95OM3Sobjk+0N
         A59wBBSKPVwXqXBBakIgLTDNaHN4/I5EhNl4VH4Q9RYfUkcymeFL06iKKKB/u8G1W0nM
         4OVw==
X-Gm-Message-State: AGi0PubStB1LrHskayZpkVuUVSad7xyqIPZ8/q4jiAujb9lok1hniTDY
        gY5MCPMZdy6chNxFbh0iM9xQbeZRYfi0Jw==
X-Google-Smtp-Source: APiQypKCWCQ7+XVN1MizcqzPTxJU9XTQdBUO0O1evVS+6FDwdvxHe2dONv4OvKW2qsggO3FwfQs3Cg==
X-Received: by 2002:a2e:8884:: with SMTP id k4mr6006110lji.267.1587030088374;
        Thu, 16 Apr 2020 02:41:28 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4832:17d6:f588:52ab:5d6a:f5f3? ([2a00:1fa0:4832:17d6:f588:52ab:5d6a:f5f3])
        by smtp.gmail.com with ESMTPSA id b28sm14789625lfo.46.2020.04.16.02.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 02:41:27 -0700 (PDT)
Subject: Re: [PATCH v4 9/9] qedf: Get dev info after updating the params.
To:     Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        jhasan@marvell.com, netdev@vger.kernel.org
References: <20200416084314.18851-1-skashyap@marvell.com>
 <20200416084314.18851-10-skashyap@marvell.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <76d84546-1587-41dd-647a-0fbbc581a086@cogentembedded.com>
Date:   Thu, 16 Apr 2020 12:41:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416084314.18851-10-skashyap@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 16.04.2020 11:43, Saurav Kashyap wrote:

> An update to pf params can change the devinfo, get
> an updated device information.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> ---
>   drivers/scsi/qedf/qedf_main.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 52673b4..dc5ac55 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -3332,6 +3332,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
>   	}
>   	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
>   
> +	/* Learn information crucial for qedf to progress */
> +	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
> +	if (rc) {
> +		QEDF_ERR(&qedf->dbg_ctx, "Failed to dev info.\n");

    "to fill dev info", perhaps?

[...]

MBR, Sergei
