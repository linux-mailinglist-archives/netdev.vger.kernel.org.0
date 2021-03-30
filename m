Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8914534EBEB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhC3PPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhC3PPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:15:14 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52F2C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:15:14 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id m13so16782842oiw.13
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YuXWsrFcRL57FSUxA2I+pdf2CWfWtObERgbIXPS3YmA=;
        b=Rumfx9uDKaP+3q+gCT6yKP4KUK/Q19TUgDFAedG7g9JU3xhb/s9OfFc3VfPiaIs7yq
         N9zgO4PM928M7wwkyAzJ0dYX4T07TU++l9O63PS1+qp4jKmNP3hp/bfu7vxx8uBJWC6o
         eKGXYA0lgnHEBGo+XCZelgFvxRXGFVnmjqLJSxrOcJyOxiJX9VEYPGdNU5oGpqsktlAY
         sobOEXhBjjHjP101JXwsJW6bsno5vqQgNEHx2pGmrD0VEmZJuc+5FVHFdGdPDuJIY0jX
         UsyC9wOfkZBhPRviBv3Retdwx/IuieUjZgnsH534ekgndOhCQsJudmPCAi2qKQcgFFjK
         yP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YuXWsrFcRL57FSUxA2I+pdf2CWfWtObERgbIXPS3YmA=;
        b=R6l3/lZhvsPDZ11t5k1gth9tkyQYZyGtprw/HfSIKy1AILw2fN5LJQpBnS9pJLfPHo
         iQH5ZPvhXchtuhdsmnwyHNiYxhi80B4uHNYN+maopslzzZQPB3DVKKsxiJrGH5mfO48L
         /USU7BSfWMfxcaY6eKGOwE+w4/Zu+B69xTV7HIC2vIbO/APxYsIDHs114rFnOp0h9KfI
         0gtcBzFq4m9La+4IivfnlPoCEDlAPQpEmEF2dyWWXnA0v5Fk4+xSmGOcqlALKNHDSLJ1
         hHeyn0rtZL9SZKz6qTA9hKy2odzeNYrVwUnZv6K5PWAaJ+GXnVu5KbZ8IfhtnTQo1S+p
         FmNw==
X-Gm-Message-State: AOAM533YFiKs/d1pKjIAfssd0bBAf4X8a/q07Xe4cJcbT3rvYTu6Tumb
        FXEYEP9YUDgEIdm9Re35DrOn48d7KWWNPA==
X-Google-Smtp-Source: ABdhPJyAhq5ZPfCqTJToYQlfNEv48v8C+0uAFsUnoAQQOZgKWoW7FGnwaZ+LkDtOUVuyKZX/iWk8pA==
X-Received: by 2002:a05:6808:57a:: with SMTP id j26mr3641508oig.122.1617117314166;
        Tue, 30 Mar 2021 08:15:14 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id r16sm3960084oij.13.2021.03.30.08.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 08:15:13 -0700 (PDT)
Date:   Tue, 30 Mar 2021 10:15:11 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: qrtr: Fix memory leak on qrtr_tx_wait failure
Message-ID: <20210330151511.GE904837@yoga>
References: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 30 Mar 09:11 CDT 2021, Loic Poulain wrote:

> qrtr_tx_wait does not check for radix_tree_insert failure, causing
> the 'flow' object to be unreferenced after qrtr_tx_wait return. Fix
> that by releasing flow on radix_tree_insert failure.
> 
> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
> Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  net/qrtr/qrtr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index f4ab3ca6..a01b50c7 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -271,7 +271,10 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
>  		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
>  		if (flow) {
>  			init_waitqueue_head(&flow->resume_tx);
> -			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
> +			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
> +				kfree(flow);
> +				flow = NULL;
> +			}
>  		}
>  	}
>  	mutex_unlock(&node->qrtr_tx_lock);
> -- 
> 2.7.4
> 
