Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885BE4DE7A7
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiCSLmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbiCSLmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:42:43 -0400
X-Greylist: delayed 175 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 19 Mar 2022 04:41:22 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8466F1E97;
        Sat, 19 Mar 2022 04:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647689900;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=LUPpJL4caDcGsF8P6jMOa7sqd6B01qkMcy8m39HchoM=;
    b=R3+VUoApr3oMqq0AxbpYRFI7eO1jxfQwWeLuM+IDpdSb6h+mYkKdjAmRd/6r6d+Y2o
    F/Pvrw7SYMRxabzCeW1DL+tRAVO3UO71wbOEzIbghQF3hlgSajNM9k2pg0zOLbVXslEb
    itnMzqI4RZchzddHtYlb2Gk/uPYJsqJt5lxqwSkcz70TP+avZS+GViHr4I6dzalIky+S
    tEjBPxNUJB6VbLJdZ3tGcO5X3LKlmGqOWMElYcNzFNIBAXg8A3B6qzoUlzgQKjpNQxpT
    brDdy/k6DwM2vtaQbDujf/4lQ38QSheu3cJSfJpXtv1cXPDrRbYTfjYWJZFeXzkdtQZy
    +N+Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLUrK85/aY="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id 0aea5dy2JBcJDO7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 19 Mar 2022 12:38:19 +0100 (CET)
Date:   Sat, 19 Mar 2022 12:38:13 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next] net: wwan: qcom_bam_dmux: fix wrong pointer passed
 to IS_ERR()
Message-ID: <YjXApWvAnGUeTpPt@gerhold.net>
References: <20220319032450.3288224-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319032450.3288224-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 11:24:50AM +0800, Yang Yingliang wrote:
> It should check dmux->tx after calling dma_request_chan().
> 
> Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Good catch, thanks!

Reviewed-by: Stephan Gerhold <stephan@gerhold.net>

I'm a bit confused by the -next suffix in the subject though,
this should probably go into "net" (not "net-next") since it is a fix.

> ---
>  drivers/net/wwan/qcom_bam_dmux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
> index 5dfa2eba6014..17d46f4d2913 100644
> --- a/drivers/net/wwan/qcom_bam_dmux.c
> +++ b/drivers/net/wwan/qcom_bam_dmux.c
> @@ -755,7 +755,7 @@ static int __maybe_unused bam_dmux_runtime_resume(struct device *dev)
>  		return 0;
>  
>  	dmux->tx = dma_request_chan(dev, "tx");
> -	if (IS_ERR(dmux->rx)) {
> +	if (IS_ERR(dmux->tx)) {
>  		dev_err(dev, "Failed to request TX DMA channel: %pe\n", dmux->tx);
>  		dmux->tx = NULL;
>  		bam_dmux_runtime_suspend(dev);
> -- 
> 2.25.1
> 
