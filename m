Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5C279DA2
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgI0DCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgI0DC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 23:02:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F62C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 20:02:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so5477483pgm.0
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 20:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1EfFdh0G6uDcT4tACCd+6qjaHkAc/Frt5l+G/B6yhuY=;
        b=B1MNzsNNEZHh0MOTAJNnzQVDz6ZBB6r5AHOQ3cODNKm8LSxqrvE4Y+RQ+xKVruLczp
         Y0dcgJ4wDOcueC9YRs3oh0v3U3H0IUZf92clmVH455QFaFs9inw1NkeXJlER8RjTGXWm
         pn4c0XnmpIjAb1X+XtUsp0onJyUobN4Z7Eg+a21wSNEH26sGHti60d0i2+/lPgCo3XBa
         jGGWIE4WDa4C1fGkFnI9talIlLMU5UCbhqTBCbsOHHmSQzt/Qaov8RO2lRzafM5x7L/D
         dhUcJMWZh/8ka5IIhEXilJz2h6PJ4yGjklGpZltiTHX3JWnqhYN7+IDC4WmsTrLBfrGf
         XtHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1EfFdh0G6uDcT4tACCd+6qjaHkAc/Frt5l+G/B6yhuY=;
        b=WgPc/XSWy+QsYGcX/QDzqUu3pcHhIJOJsAeEjbr4Gch2ABOJTTOJ1sUkwd/mI5BlS3
         htGB2ukjPAm7e5hI+YI1UBirrl9WrNjaBdkwWJTnDJZik4GTisRS7Qox6vEPAMWMwNvN
         g1yyyUWeQr06XZBywIQ8UwB9apPWn0FsAa1VFtSD6z/8yxcaY6KJ0jrEjHNVjaQyY/ct
         7SCGvaKKSqSL9BYrpF8YcLLIyfaL3e8PVyjN74vTOHxvEtiR3DYxk+usqBNri9gTcMOK
         jVhTS96D0WZ5vHbAKhPBVMzaprdzNqUxZaQ1Y1E/06yXOzakSNwxGuau9wdqFhGDoWj3
         OaLQ==
X-Gm-Message-State: AOAM530F8ZgbZllB/OStvN5p3VoFNY+OTuYI2nSbL8Xf77gFdTxEJmrd
        Y1sCu748yMLvLgh63g29IiNR
X-Google-Smtp-Source: ABdhPJxtqSMQ+j1jAs0RWkmcSy4sb+BSLq9ImuMp7FEkpbKkHLwq99Y3/dZmaXeSOBFefalA5scHWg==
X-Received: by 2002:a63:fa45:: with SMTP id g5mr4377691pgk.448.1601175749115;
        Sat, 26 Sep 2020 20:02:29 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:198:cd53:8f:5b5c:829a:cfde])
        by smtp.gmail.com with ESMTPSA id x4sm6987133pfm.86.2020.09.26.20.02.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 20:02:28 -0700 (PDT)
Date:   Sun, 27 Sep 2020 08:32:22 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 2/2] net: qrtr: Start MHI channels during init
Message-ID: <20200927030222.GC3213@Mani-XPS-13-9360>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
 <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:43:04AM +0200, Loic Poulain wrote:
> Start MHI device channels so that transfers can be performed.
> The MHI stack does not auto-start channels anymore.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Applied to mhi-next!

Thanks,
Mani

> ---
>  v2: split MHI and qrtr changes in dedicated commits
> 
>  net/qrtr/mhi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index ff0c414..7100f0b 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -76,6 +76,11 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	struct qrtr_mhi_dev *qdev;
>  	int rc;
>  
> +	/* start channels */
> +	rc = mhi_prepare_for_transfer(mhi_dev);
> +	if (rc)
> +		return rc;
> +
>  	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
>  	if (!qdev)
>  		return -ENOMEM;
> -- 
> 2.7.4
> 
