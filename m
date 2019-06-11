Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9913CA3E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbfFKLof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:44:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42770 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbfFKLof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:44:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so7382838qkc.9;
        Tue, 11 Jun 2019 04:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DgmcLe/CP1dvQR6VvwyBkxmhRQqBzugZEX3K/e42wLE=;
        b=JoFt1T3kpO1qtWgU/8LPHEK05Z+w6E2uJwUAT4HpnMJ6r4oDzCfR4qPoPG6uNIc6l7
         EEKcLzSAYyo2PBfBfTuEYzdNeP10TT76gGGskwHRXwlavaXhF5qtEU90Y1cgM+6V6hay
         a+zKuu8ZQbXWQPacTfmeEebKk/cQJmHFTcz1Bd0QAgF9QpPDuKMjfpzgALZfsrHouEet
         XWWgw6Z8xNq1/sLKqkKJ4Q2T2kYt90AitfrYGBIlsK+j9ipVoYq7CDUyF15CDXRKA32x
         VX9gzeOfDbHtIWrlV4ewC6dMvSA5oaKxtnmCjhcsXtxohb5sb/xM8U67jPKjg858Iw6w
         BMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DgmcLe/CP1dvQR6VvwyBkxmhRQqBzugZEX3K/e42wLE=;
        b=CCaOOzP25IpU2zar/a9V2++4mQMJXQe+q95V/BO7yRcAUbwzN+AHCzf1k4oRaET88G
         DDDO//BaE0da4ytJPUCzVG5kPcVJqCimjbawYziYJNZdz6RCRda5GYWPdnJFd/ngbtG0
         0nlM9mmLecsMMtqqV3b7UZOQxdvMld+CvbTPugu9aBruhHTIpQuDOP34thmezaHcKb/z
         dr5qCl0fN1uflx7mK7Ku6nJsRHNQ29cM+ROCFp8dqqf4LjF0OI8p1gYo6FquH+WcsKHt
         K+xOaxEDydTB+80dOzlo5k/SNvTSQFn4Ji4sIW0LSnr5NsqRx59ExbXSQ0kwxPm0F3aQ
         TpIw==
X-Gm-Message-State: APjAAAWD3E1MPVps9XvVZIoaPVAanrVox3WTt7dMKzTfU81qozPoDnCi
        0D4bQO/n61MI8EBLPsOeTlHYHaWosCI=
X-Google-Smtp-Source: APXvYqx+e8c1g6jD9brWArl1lW2pcp+Fs4QR3ag7iYdVqkVbNIXA2VwQwErINWS8kIkZA0GBjaCGzA==
X-Received: by 2002:a37:9d1:: with SMTP id 200mr11746756qkj.306.1560253474106;
        Tue, 11 Jun 2019 04:44:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:7487:3cda:3612:d867:343f])
        by smtp.gmail.com with ESMTPSA id v184sm6194106qkd.85.2019.06.11.04.44.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 04:44:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9C7BFC087D; Tue, 11 Jun 2019 08:44:29 -0300 (-03)
Date:   Tue, 11 Jun 2019 08:44:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] [net] Free cookie before we memdup a new one
Message-ID: <20190611114429.GB3436@localhost.localdomain>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190611112128.27057-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611112128.27057-1-nhorman@tuxdriver.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 07:21:28AM -0400, Neil Horman wrote:
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> ---
> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)

They are actually 4 vars. The 4th one being peer_chunks.
And a syzkaller Fixes tag would be welcomed as well, so that if
someone backports the fix for it will have a hint to backport this
patch also.

> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org
> ---
>  net/sctp/sm_make_chunk.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index f17908f5c4f3..0992ec0395f8 100644
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
> -- 
> 2.20.1
> 
