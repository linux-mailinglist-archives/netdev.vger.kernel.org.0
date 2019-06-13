Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571674466B
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFMQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:51:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44795 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfFMQvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:51:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so23304042qtk.11;
        Thu, 13 Jun 2019 09:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4bYDz3KWsV5Knp+WIDXyIDkyFa8fxFXYjH3Hm9bQxyE=;
        b=faifONQj49ZFgKruY2TCMJgN5FBj6KRHIZkz4wbzoH4dRM/bAwjRT7YmLYxwDqhlQD
         0Eevmz5hpjzwWAr0CPc6NuJrp2Nt9Atw/uL4uoJUQUs3ejGTxGNcJ9Yv/vFJ2QwNEMPZ
         0MpwFWlHApnct4RFYlHbA5DZ/jAyZmhRipFUMHMUehbKkj5MsrGeRtav5PuRpjdT8WH0
         64Ett5TmOB+E072o1dHeVbnmsFdigX8qNhfqKPqHTAn16kezURBxW21+ihoIneOoc+ji
         h0+jr4DxtiaGkXc8iiS4MJiEzRxp+wjOzzY15rHihYF/R6IkGrobxSgD48gZ6vs19XeQ
         ZNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4bYDz3KWsV5Knp+WIDXyIDkyFa8fxFXYjH3Hm9bQxyE=;
        b=V1eZO/9wQwaOY5sqAbXsiUwNT9L3EgrTUdpK66cH35aYL1KWZeS0OuRkz+B2ytZXlL
         eYPxOa3EOlHymfBzqtQ/1L3/k3aApXzss5CTOzGujB+OCYvBPF3v7rsLzNyGQDXJGPLq
         llmDRMOOxaFjnapffjhh/hy/+d80IquyceihsFAULEuLf2JZVDqKCKWnV52ZsvpMlwmr
         r4v4zMhCQBpT0wtZNYNEnUiU06hY9o3heKe4QOPfT0388ekUXXZa0rPupZAgVmJZ9xoN
         Rb1l6VknRK37lt+UHV7Ey26nLkkstXeRX4yU/21xpIy96HdkB0FBqXMd75CHb2Q4sFjt
         Wivg==
X-Gm-Message-State: APjAAAWfamhDfZ29GImF86v1vD+csPhXVaVex/tB9vvQD5110cTOFbhg
        2Wcy65QhyC6ld15xTllObXY=
X-Google-Smtp-Source: APXvYqyo5Lk0Bs+9Rji9YmDTbc2gLdKcGIpFr53k1axFRi1GjjPbr8hwolW2qw9D9uZdCeXEe6fJ4w==
X-Received: by 2002:a0c:afd5:: with SMTP id t21mr4524601qvc.105.1560444697482;
        Thu, 13 Jun 2019 09:51:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:278e:68eb:7f4f:8f57:4b3a])
        by smtp.gmail.com with ESMTPSA id 39sm74166qtx.71.2019.06.13.09.51.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 09:51:36 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0E566C1BC7; Thu, 13 Jun 2019 13:51:34 -0300 (-03)
Date:   Thu, 13 Jun 2019 13:51:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 net] sctp: Free cookie before we memdup a new one
Message-ID: <20190613165133.GD3500@localhost.localdomain>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190613103559.2603-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613103559.2603-1-nhorman@tuxdriver.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 06:35:59AM -0400, Neil Horman wrote:
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)
> 
> v2->v3
> net->sctp
> also free peer_chunks
> 
> v3->v4
> fix subject tags
> 
> v4->v5
> remove cut line
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_make_chunk.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index f17908f5c4f3..9b0e5b0d701a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2583,6 +2583,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len =
>  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> +		if (asoc->peer.cookie)
> +			kfree(asoc->peer.cookie);
>  		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			retval = 0;
> @@ -2647,6 +2649,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's random parameter */
> +		if (asoc->peer.peer_random)
> +			kfree(asoc->peer.peer_random);
>  		asoc->peer.peer_random = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_random) {
> @@ -2660,6 +2664,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's HMAC list */
> +		if (asoc->peer.peer_hmacs)
> +			kfree(asoc->peer.peer_hmacs);
>  		asoc->peer.peer_hmacs = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_hmacs) {
> @@ -2675,6 +2681,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>  		if (!ep->auth_enable)
>  			goto fall_through;
>  
> +		if (asoc->peer.peer_chunks)
> +			kfree(asoc->peer.peer_chunks);
>  		asoc->peer.peer_chunks = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_chunks)
> -- 
> 2.20.1
> 
