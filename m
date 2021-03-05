Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3301732E7C8
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCEMUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhCEMTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:19:53 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C576C061756
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 04:19:52 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a18so1828966wrc.13
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 04:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0YBjnh9sRcW5SiNs3e12Ik4FV9ZcvnWgirhrfzXeMbg=;
        b=RNELQySBCYYkbbv0Dq8kJsUVA66c6RVE3zRqU3mGO29wBK0EeUUVd+Dgyu+Kl+BPR7
         Epl3E2sBVP8wAgVVLtIPpVduN4Bw4VMr5ruLM9uv18L2YS960izrRxi1zB0Pqp2aGMAo
         bKEf2JOKYKaWTNhv4cCzyPSNl7TWhaFY9+n1VNev1U+tj/ZZ6vDRKlweQ0TsEbvCBSQk
         96Lv9EHhl+vyRJGp48fDQpP6JBiAHF7Qap7rppNekNrgPpK1P8AWN8sOj8qE8iLnkxcP
         /mXhm/yfNcflyKZ1pGq8diRl9BJhHMTL2+GVW0xHoSIy3UYa9RTi5amAe4UzzOijGe3h
         233Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0YBjnh9sRcW5SiNs3e12Ik4FV9ZcvnWgirhrfzXeMbg=;
        b=A2QcNp28GXmTdy6jyU3byL9jLuDe9OYlru6RsWQxLTk0DLSeKzLid82B75BYCN1RN+
         VHv/Iw1KimEAU05f6+b0/eFIdlVhEcZdpaA3Jptef6FFIn/pBNyW0VyRB4FJQwni6yKE
         Ko8g6510Ef3zPpB+hKFeYYd2YGU+cHwc6f3L5cZs/aX8tZdg1lCidDQp8RGebD5qxvK2
         8vZf5LEQRVYX38N1Z4JmlaAnS68LhDYT5U2lhLMme+1jSCmNwPbudGZlZcopvAOEOU3t
         MQ00AcDpDCBSoH6U5wXAzj8uc8dbiPlsytP773e6MDnGhGlAWg5PVh49B4TTq67Vre1Z
         KERA==
X-Gm-Message-State: AOAM530vrn213QIYIcv5u0WcGmULZNbWpgwRQauOFIs4Xs9+XunHpUJ3
        bATO2F/T/t104bWvvz1dcYtdcg==
X-Google-Smtp-Source: ABdhPJzCO1AQHSr/Rir1FDEysAjCPswJzHXnMpaDagDgQT7WP0KlJxSvPrq6AapamF5qzUkzXdwg+w==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr9429695wrs.98.1614946791306;
        Fri, 05 Mar 2021 04:19:51 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id f22sm4401729wmc.33.2021.03.05.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 04:19:50 -0800 (PST)
Date:   Fri, 5 Mar 2021 13:19:50 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] nfp: Fix fall-through warnings for Clang
Message-ID: <20210305121949.GF8899@netronome.com>
References: <20210305094937.GA141307@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305094937.GA141307@embeddedor>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 05, 2021 at 03:49:37AM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks Gustavo,

this looks good to me.

Acked-by: Simon Horman <simon.horman@netronome.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index b3cabc274121..3b8e675087de 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -103,6 +103,7 @@ nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
>  	case NFP_PORT_PF_PORT:
>  	case NFP_PORT_VF_PORT:
>  		nfp_repr_vnic_get_stats64(repr->port, stats);
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.27.0
> 
