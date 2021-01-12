Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919D2F3230
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbhALNu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhALNu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 08:50:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CDFC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 05:49:45 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g3so1436615plp.2
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 05:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bMkkPxF9XWnGx8mzEpkx8vZcHzj7z6YHfyCng4Z6LK8=;
        b=QCv83yLJIwZBxAxoOaS2pIr0oZTZf9uX6ii1dIhUUYDNVc6sMnh2m2QsLswZhvzLF9
         GYTnDDULAlyL1YTikamOcuJsoK/IpLpt4HO/qSuURPEBc8D8nf4/v9nU/jntzfNUgCeY
         olfc1pPBUr1nMws2Gj3l+9dWKdEx2mlrD1cX2pbdEUBB+92062L+XoYuha0SE5jj2cmJ
         3Tv+P8W1kHr456Q/ubYEYTTIZK/0+EhHyh2npkJymPQmci/z7ofesIovWJKsYiwbRYpY
         pECxRDcJ7AyFTizQNet/xLvIEH2vqt/2hb9yXBusNrZqLoK1+qNlrDQ9ykXwFNe4ffJ+
         sYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bMkkPxF9XWnGx8mzEpkx8vZcHzj7z6YHfyCng4Z6LK8=;
        b=pm/OflLUVMom7FO2790iTY4fldHh3kyAQ2KqO0a37353ZYdglWnSiW2twt2g5bQLxE
         8teTlcmq0vg5+jH9aRndXv2zbDb4Xc7Q8o1dPoaHkBKFrTG8/leorh8cUNAiq+RTcKf5
         Re4MrHDCtlN4Nmc3ZnyBqkYC2o9HJ7jNlHZEr1o9/ABHthCooSta0JnrOWqVJyxBVCRS
         PpiP0S1C0xhI9btRxR3zgbSD+qQ8QEplObrKvvj2fyGlkKN+ba+yILhj0RKofEWOKTOB
         SQ67g+sp/TZhQmFAhvA/22fZPBKJaWC3EjEdCQs8pZKUvzpW2dwxSsgJU7yjQkoalk9h
         iSLQ==
X-Gm-Message-State: AOAM533Hj3alQ1Lmu759Do2BRhDmw7rHrqSVBMqLQK1rSkJRiNF5ioQV
        VMJdazeJ3sixep3zKlz/Uv0=
X-Google-Smtp-Source: ABdhPJwsX1rXDv+wVh+aSf5gdv/ropyNKBKh5uCctnpcoSk9CQeOvLQJ/+CmXpOpFTlqRUGYWlgz3A==
X-Received: by 2002:a17:90a:cb97:: with SMTP id a23mr4824403pju.146.1610459385319;
        Tue, 12 Jan 2021 05:49:45 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q12sm2773957pjf.22.2021.01.12.05.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 05:49:44 -0800 (PST)
Date:   Tue, 12 Jan 2021 05:49:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/2] net: flow_dissector: Parse PTP L2 packet
 header
Message-ID: <20210112134941.GA24407@hoboy.vegasvil.org>
References: <1610389068-2133-1-git-send-email-eranbe@nvidia.com>
 <1610389068-2133-3-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610389068-2133-3-git-send-email-eranbe@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 08:17:48PM +0200, Eran Ben Elisha wrote:
> Add support for parsing PTP L2 packet header. Such packet consists
> of an L2 header (with ethertype of ETH_P_1588), PTP header, body
> and an optional suffix.
> 
> Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/flow_dissector.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 6f1adba6695f..fcaa223c7cdc 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -23,6 +23,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/mpls.h>
>  #include <linux/tcp.h>
> +#include <linux/ptp_classify.h>
>  #include <net/flow_dissector.h>
>  #include <scsi/fc/fc_fcoe.h>
>  #include <uapi/linux/batadv_packet.h>
> @@ -1251,6 +1252,21 @@ bool __skb_flow_dissect(const struct net *net,
>  						  &proto, &nhoff, hlen, flags);
>  		break;
>  
> +	case htons(ETH_P_1588): {
> +		struct ptp_header *hdr, _hdr;
> +
> +		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data,
> +					   hlen, &_hdr);
> +		if (!hdr || (hlen - nhoff) < sizeof(_hdr)) {

I'm not really familiar with the flow dissector, but why check (hlen - nhoff) here?
None of the other cases do that.  Doesn't skb_copy_bits() in
__skb_header_pointer() already handle that?

Thanks,
Richard


> +			fdret = FLOW_DISSECT_RET_OUT_BAD;
> +			break;
> +		}
> +
> +		nhoff += ntohs(hdr->message_length);
> +		fdret = FLOW_DISSECT_RET_OUT_GOOD;
> +		break;
> +	}
> +
>  	default:
>  		fdret = FLOW_DISSECT_RET_OUT_BAD;
>  		break;
> -- 
> 2.17.1
> 
