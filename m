Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1291E2773DD
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgIXO0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgIXO0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 10:26:02 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B255C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:26:02 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z26so3787471oih.12
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PsRplXrcrp4vuGXjzx0lobgf5oy1yJOyhOffJwhM/uU=;
        b=Aj8GS1bZqKjdkYI6p+ctzqfxDLXUiSnEh7PCr7fe+mLAVbnj91zwK9BCD8aG2ly53u
         oVfG6ExJrV+iPjgAjKVrd4rOzcZlZUfiOhjgEGtqW/5ABpOFyvP6D79Cl8ypDh6ChXk+
         ycjW/85v0XhRfu3VtQBdn3oqtOFK4/6oKIfz79w0asMQ8nCogi3ORpOw5QSAUplW4RWi
         OrDqFrmKKHMo1yvGDdF1/RLk+lF2RPPEBaaruvs1l4JCUvToOWn3xq5lNGiBihIqy6pQ
         BTuLcwmT4lP/+YMAEcW9eMSZrV/a7qi3xqbT3hKGK+D/AQXZAVQTt3WFVu5AMf670en5
         4whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PsRplXrcrp4vuGXjzx0lobgf5oy1yJOyhOffJwhM/uU=;
        b=BR284+g6g4abuDm5WIMauMCFxaDLnhE3atc2UQypKLbkpsJPvRrdJO3TF4jw28+6iH
         fVRz92mzu2ZUzVmNeVyZ7G4f2WCDTyLgzso8C0/JHVJFanBDNcGWwq1ONfRJ0Bz69CP1
         89gfz+GDcbdFhoJiqiwHr0vG9Wdc5QmEOj6jSkXoaNY85nJvvAQIAdRTDU2QGtHT6k3h
         5gg6O72dZ0MRe1AKg4oBECLhBMSZ7sfE5I/u+uIkgKD9d+buctL0E4qF0S+PxPgvSOzd
         r7IBKxOQXFik48L0qu7Ot6TuwBT8NTopnWKR028mWdtUaDtlRC3W8FppjN5M702UeNyz
         oeyA==
X-Gm-Message-State: AOAM533FKONhTojkONXTXA73MWy5b0VO9jdcze5xhcE9b7jy7KdBfF0d
        ahS9ER9Fsa/23g6xRArAglnqKQ==
X-Google-Smtp-Source: ABdhPJyZfo7HHzknUMJO7v9as9lU3hFfKxErDpk0EZaNx9IPZWZc5CexTTR+cCEJ4uVVuNI65zwGbA==
X-Received: by 2002:aca:72d0:: with SMTP id p199mr2495848oic.140.1600957561902;
        Thu, 24 Sep 2020 07:26:01 -0700 (PDT)
Received: from yoga (99-135-181-32.lightspeed.austtx.sbcglobal.net. [99.135.181.32])
        by smtp.gmail.com with ESMTPSA id q24sm663236oij.19.2020.09.24.07.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 07:26:01 -0700 (PDT)
Date:   Thu, 24 Sep 2020 09:25:59 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>, clew@codeaurora.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH] net: qrtr: Fix port ID for control messages
Message-ID: <20200924142559.GD40811@yoga>
References: <1600941239-19435-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600941239-19435-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 24 Sep 04:53 CDT 2020, Loic Poulain wrote:

> The port ID for control messages was uncorrectly set with broadcast
> node ID value, causing message to be dropped on remote side since
> not passing packet filtering (cb->dst_port != QRTR_PORT_CTRL).
> 

This does indeed make more sense. Unfortunately after reading the
documentation a few times I do believe that it doesn't actually specify
the expected port (only the node id) - and that the recipient shall
ignore "the field"...

Chris, can you please let us know what the actual expectation of the
modem is? (SDX55 in this case, but Arun must have tested this on
something with more lax expectations?)

Regards,
Bjorn

> Fixes: d27e77a3de28 ("net: qrtr: Reset the node and port ID of broadcast messages")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  net/qrtr/qrtr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index b4c0db0..e09154b 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -348,7 +348,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  	hdr->src_port_id = cpu_to_le32(from->sq_port);
>  	if (to->sq_port == QRTR_PORT_CTRL) {
>  		hdr->dst_node_id = cpu_to_le32(node->nid);
> -		hdr->dst_port_id = cpu_to_le32(QRTR_NODE_BCAST);
> +		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
>  	} else {
>  		hdr->dst_node_id = cpu_to_le32(to->sq_node);
>  		hdr->dst_port_id = cpu_to_le32(to->sq_port);
> -- 
> 2.7.4
> 
