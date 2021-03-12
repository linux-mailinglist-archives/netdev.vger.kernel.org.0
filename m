Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595FC339411
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhCLQ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhCLQ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:58:07 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14426C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:58:07 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id n6-20020a4ac7060000b02901b50acc169fso1685674ooq.12
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qVuuNGDLx6k4Abwg+RRmN1Jl6kD7Q5l7TCjYKqrpuOU=;
        b=LJXZVmRXs/D6H7AgVcnwAm0foD4fL2uRbutcsS2iWNVipIfP+2z8Njpe4TfwWQutLa
         OIEfr1gnL+DfztnozxjqSl5k3lqOsududGZJsziYdFiRKakHcPFEpD2gm2yoDb5PncXk
         Gep0oSHQbCthu9GSYwIQ9fGeFD9Y8WPcJhruNaotVQS41ngXtG1CyR0QAJgDFDpXnzbh
         DtBy6XcYm9v4m5zBQGgUZBWPgYUNE9ZV8+yfzE1zv1+3kgluQqwLe58K107B4BgaPGmn
         QYdWex2GTkbq66yCyopOXgMV74klPai6bL1NRSAxsyDsHQeI5jx7k+bqgQWphKFCc8E7
         2x7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qVuuNGDLx6k4Abwg+RRmN1Jl6kD7Q5l7TCjYKqrpuOU=;
        b=Ls/wfTRrjB0onoAuTrTXmfJ/EecEOjpF1Mak7B0ZHS+kEvGvgLtCXvT8B9PkevFoPi
         g7nbqZmXSp+BAS5wj6YXoqRxpfkycJNId0hxEC+2ydSuYznCGQWNVRDBM4hohh4bPhs8
         IPxJWcsriBmmdmvkLNclSzyrJhmjZq6jQXlXTwdI1kEBa33tkhi2tBcPbArv1MfyNzFD
         GQEAQT0Y/TauGzrrm/rSXPyM8jIlvE78BIRv1oRI+ulXsbBo71q3v3tLsmt2Nc9ViA7/
         VM8FQU9QSmi5AUiimbkUceewHSdWHeB/eH9DnzDtL1FVZPiait2ZZlNr32gu7himLX5/
         PDdg==
X-Gm-Message-State: AOAM531tWV96MifULdUP5Z5zyaD7q8C9g4+/jn1rD+xN7YYdAAqSebD0
        TjlxRpiraXGocT5zmtdw6/zNEruWuW2A5A==
X-Google-Smtp-Source: ABdhPJwkUz8VtF/1ga3zDUSbbRLCDuAk71Jyab+HV8C1bKwWfIm4xGKsQgIhwVLR/fgWao9blKua6w==
X-Received: by 2002:a4a:d994:: with SMTP id k20mr3963379oou.70.1615568286337;
        Fri, 12 Mar 2021 08:58:06 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id s33sm1393758ooi.39.2021.03.12.08.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:58:05 -0800 (PST)
Date:   Fri, 12 Mar 2021 10:58:03 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, sujitka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: terminate message handler arrays
Message-ID: <YEudm0TJUwq5x/Pe@builder.lan>
References: <20210312151249.481395-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312151249.481395-1-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 12 Mar 09:12 CST 2021, Alex Elder wrote:

> When a QMI handle is initialized, an array of message handler
> structures is provided, defining how any received message should
> be handled based on its type and message ID.  The QMI core code
> traverses this array when a message arrives and calls the function
> associated with the (type, msg_id) found in the array.
> 
> The array is supposed to be terminated with an empty (all zero)
> entry though.  Without it, an unsupported message will cause
> the QMI core code to go past the end of the array.
> 
> Fix this bug, by properly terminating the message handler arrays
> provided when QMI handles are set up by the IPA driver.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
> Reported-by: Sujit Kautkar <sujitka@chromium.org>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_qmi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> index 2fc64483f2753..e594bf3b600f0 100644
> --- a/drivers/net/ipa/ipa_qmi.c
> +++ b/drivers/net/ipa/ipa_qmi.c
> @@ -249,6 +249,7 @@ static const struct qmi_msg_handler ipa_server_msg_handlers[] = {
>  		.decoded_size	= IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ,
>  		.fn		= ipa_server_driver_init_complete,
>  	},
> +	{ },
>  };
>  
>  /* Handle an INIT_DRIVER response message from the modem. */
> @@ -269,6 +270,7 @@ static const struct qmi_msg_handler ipa_client_msg_handlers[] = {
>  		.decoded_size	= IPA_QMI_INIT_DRIVER_RSP_SZ,
>  		.fn		= ipa_client_init_driver,
>  	},
> +	{ },
>  };
>  
>  /* Return a pointer to an init modem driver request structure, which contains
> -- 
> 2.27.0
> 
