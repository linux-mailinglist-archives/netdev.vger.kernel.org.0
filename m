Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE98280014
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgJAN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732016AbgJAN0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 09:26:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376C8C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 06:26:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b124so4455814pfg.13
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2EMrIGNVS4MgFv68qX+fAPlhxk5mm+oqUevhDT5L3eE=;
        b=zCoCieEgH8NwCzkzEJgG6hQZ+V9qskx0ShHFnAE6lXDWLqlxPg3HW7Ilu0S0WoE48v
         7BfgKJU3MiXb/QPLYHsTl9Dh9FNeJ7eIvq+TnflsCO19af3UVK4R3d7hEL1DKxt4JV8N
         ANZiuYdn54aErMbxtKcOqTN3tVb57leN56U2UsTjXK90eLfaB4gVfGCFuGP6zitApekW
         4Wzvn6zcGKONS2mYl50JWwrUQEiSIDNQDUBIkAbZtw20M69O18p6ZXdzLANRlSeUHVAO
         apUDlKqYFz1Bb/NdcHTNrKJPKAAPrug8vFlOMqSH0pyauUyQCszXx2Wfpvo1g1sd+aUZ
         uiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2EMrIGNVS4MgFv68qX+fAPlhxk5mm+oqUevhDT5L3eE=;
        b=UyFEKTP/aB/AtzsgqIYNA16F43FYk24YwVwDT2xgREReTPXlySyt5EJUS1DZ32WbGz
         sPK2QMahXM45s+w1GXHPeWrq1+RBhJtiETzDNNhabq4x2y6xkReKbGdviWvYuEFXMbP9
         DFDVAwlYCe5KrXNLzvJHy1IqB9OmHrbEhNudaCYxXYp3g8zJXx7JZaxWDSIB+JqIZKIe
         YxHYJtIBefG02XcVhgDun3cVIOhjuFy58F5eQBr1PxEBPUIgeivGCVwU4TSo2m1WrCDM
         Ycie9g0U8ijEK3RvW4xP7lNpSFQHPbis8/1DaOJiWfF4TLJ9T3mrYZtC5x+qoEhEF/fl
         vlpg==
X-Gm-Message-State: AOAM532hxs+nYCWp51bBCihAayGLx5XHtcuiVxzNJCjrBcCub82dQ3TB
        Nh/fG2ctsYrV4P8i/OjsyusX
X-Google-Smtp-Source: ABdhPJzwQZTC1FeY5qjx9oh+mJqJ+4yRiTpMbwmGPXQPTzJFqNiiQIj8uV/dbFZhc4gb6BiHn3Rd3A==
X-Received: by 2002:a62:b40c:0:b029:142:6a8f:c2f8 with SMTP id h12-20020a62b40c0000b02901426a8fc2f8mr7203786pfn.32.1601558768613;
        Thu, 01 Oct 2020 06:26:08 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:188:5adb:1423:88c1:4321:a364])
        by smtp.gmail.com with ESMTPSA id c127sm6364370pfa.165.2020.10.01.06.26.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Oct 2020 06:26:07 -0700 (PDT)
Date:   Thu, 1 Oct 2020 18:56:02 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn.andersson@linaro.org, davem@davemloft.net,
        netdev@vger.kernel.org, clew@codeaurora.org
Subject: Re: [PATCH 1/2] net: qrtr: Allow forwarded services
Message-ID: <20201001132602.GD3203@Mani-XPS-13-9360>
References: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:33:16PM +0200, Loic Poulain wrote:
> A remote endpoint (immediate neighbor node) can forward services
> from other non-immediate nodes, in that case ctrl packet node ID
> (offering distant service) can differ from the qrtr source node
> (forwarding the packet).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  net/qrtr/ns.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index d8252fd..d542d8f 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -469,10 +469,6 @@ static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
>  		port = from->sq_port;
>  	}
>  
> -	/* Don't accept spoofed messages */
> -	if (from->sq_node != node_id)
> -		return -EINVAL;
> -
>  	srv = server_add(service, instance, node_id, port);
>  	if (!srv)
>  		return -EINVAL;
> @@ -511,10 +507,6 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
>  		port = from->sq_port;
>  	}
>  
> -	/* Don't accept spoofed messages */
> -	if (from->sq_node != node_id)
> -		return -EINVAL;
> -
>  	/* Local servers may only unregister themselves */
>  	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
>  		return -EINVAL;
> -- 
> 2.7.4
> 
