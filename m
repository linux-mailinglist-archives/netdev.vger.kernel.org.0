Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5B51DA52D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgESXL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgESXLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:11:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE0AC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 16:11:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so374718pjh.2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 16:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+7QJAXBjfTJ+AlH8byb/3GiDycgpsRF9Sq5WXCPucY=;
        b=gP5wxnBJxBWcrtjyMluDLMiPyewrNncS64EHHgPp+B5M8VlvjmUGx3plaFVco31aMq
         RpFy1n//+8JzRGeWcxluhSfKMAb4bNWo7nwYZzBfU8POB1X1AmxCynz0skXCltH2HQEc
         7rTCq5vn0/i63H17WVk0pZRzPfQDeXMnCyl8akbVKV0twSLso7DvVGxJ39T5EpPoWFIg
         +CO+9Vv9YQe4Y6IR1i0xtrt/IiYjROFyjYoaUwA7Fzh/h9FK36M7fWdKjXoJANNSQ1Og
         hATkgP4m864O55Qhe5bEq83CnP7uAAZ2b4wekCdoeL/zGL4u1qJUi/9loHAQGjjg/B+e
         303Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L+7QJAXBjfTJ+AlH8byb/3GiDycgpsRF9Sq5WXCPucY=;
        b=o+5yBIoT9GIfpVlWn4aMK2VgmrUtzJxrl10vQfc9RxoJmwLl4WdzkN4tV02r58AjeA
         CVkLHheFhtzmtZ4XLRNRrsMGml2c48ZXgMfCXGFKSlgoWfBnB6MUZRk1LHShvtjPZG+K
         FaEzk/jmRXZGJudpmhyZpFDX6+DpPBDaJvQPf09aOxkiB94bhdybRPAvwwA0Cx5jaBCL
         q6ZNZWYSpSqkblcDAHrmjpzIMdAC7XPCrjH6Ee7w0jQcbHUfLZtdB/pk5k2EqKaxVspN
         Fk2KuH5DmEiHCW1MW7fpznQQycbxvb4urErbCeEdqoBf77tBuAxAddy0+On0hso90IfE
         B7UA==
X-Gm-Message-State: AOAM531RakgMCqYN43g8rNpLZwftAoBSj6DSQi+u1MUbM8UOJStHLLXN
        POcJxn22GndEHjfj5C4Tg3xvEJ5cxMY=
X-Google-Smtp-Source: ABdhPJys9s8J9INgrU+CaIvU8ZNjpSsags3R398v5suCHgwKjLcqI84WmnxzgQHtjdRMxu8rJp4+Dw==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr1953058pjc.230.1589929884107;
        Tue, 19 May 2020 16:11:24 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id s2sm473945pjs.9.2020.05.19.16.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 16:11:23 -0700 (PDT)
Date:   Tue, 19 May 2020 16:10:02 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Fix passing invalid reference to
 qrtr_local_enqueue()
Message-ID: <20200519231002.GD2165@builder.lan>
References: <20200519181416.4235-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519181416.4235-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 19 May 11:14 PDT 2020, Manivannan Sadhasivam wrote:

> Once the traversal of the list is completed with list_for_each_entry(),
> the iterator (node) will point to an invalid object. So passing this to
> qrtr_local_enqueue() which is outside of the iterator block is erroneous
> eventhough the object is not used.
> 
> So fix this by passing NULL to qrtr_local_enqueue().
> 
> Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/qrtr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 7ed31b5e77e4..2d8d6131bc5f 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -854,7 +854,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  	}
>  	mutex_unlock(&qrtr_node_lock);
>  
> -	qrtr_local_enqueue(node, skb, type, from, to);
> +	qrtr_local_enqueue(NULL, skb, type, from, to);
>  
>  	return 0;
>  }
> -- 
> 2.17.1
> 
