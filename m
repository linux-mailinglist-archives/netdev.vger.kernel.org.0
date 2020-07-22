Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCAF22A0DC
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbgGVUmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVUmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:42:36 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FA6C0619DC;
        Wed, 22 Jul 2020 13:42:36 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id o2so1648269qvk.6;
        Wed, 22 Jul 2020 13:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7nZNWjLqJ0D5sOjFQbHfG87wkEolo85RPk9Z6kp/ytc=;
        b=khTCCzW3E6Dk5KskWoX50Mju/0CtFCcalJxJWF9H1r60i0v8EtvUN5HsHgwez0hBaz
         yCFH9uglcgYgZ0wWnc5I6xk+uJj1JHQ5U7Zg8kT6wjVAf4pD/oTh7a2Gv3TfknsUsDjM
         Bczvt71B/uSq3yxvGlRjf1JoaZz6BjymEyjOJAPqk+6T+jEiOvZMJywJglwug9AWTxgE
         LG2y2P9FkHZ6flyxYQvqlRrmZGJTwODE8NPlYxKXvhu6YVwBKRj7rivlR5azwBNFFMVo
         fhMRNOA43jnKUGzMCj8PJuTpdU++IRzuMgm23vPs7PifTVmSBrfL+vCioHsL9SDRbTKA
         ybYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7nZNWjLqJ0D5sOjFQbHfG87wkEolo85RPk9Z6kp/ytc=;
        b=j14iyEI7S4Hl/IQDOc08UvFCLtSMt7xp29fxFth9wdcN8XHLfDXymRWq0J6WjM2Aos
         E1W28Awz23kztIbqzDsZkYXhmcd1l5xo1/IbgCpsVRwsQqisOjT2s5H1OFONpfOjZIGJ
         F7QmPbbqg65HkXvid6plsJ6b3mb4XTRR7PpNfq2pOTQ4nqiJ9s99tIUvSoXloFB6Jdtp
         s8P8siLlt+0Hp2v94ukUk6kQPUvYeD/1LtEKQLzNRCWgHZ9l8y2u+cIJ6tIjDcnSnxLF
         weKwiuipgbd04A7z63t+PZd1nGTqperQRxuttJDSyrOVRjTJfaMiEwFH03XYkG/+gSep
         ZFhA==
X-Gm-Message-State: AOAM530icOQJPCUzUlhl1MpylMRRvVDVtGSBtK9JOMXA76XjS2sK/iEo
        sUOZtIncLUmhA5mTKhsmVQBv2vBK
X-Google-Smtp-Source: ABdhPJzq2amLTw+BDxUKKCEVqbE2WSYz5u5t4BdzTKsMsXoW8MI/Qg2BDubtp40nFT4gcfbbpN5Pug==
X-Received: by 2002:ad4:4b6d:: with SMTP id m13mr1830201qvx.33.1595450555197;
        Wed, 22 Jul 2020 13:42:35 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a4f2:f184:dd41:1f10:d998])
        by smtp.gmail.com with ESMTPSA id s190sm783587qkh.116.2020.07.22.13.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 13:42:34 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F1909C18B3; Wed, 22 Jul 2020 17:42:31 -0300 (-03)
Date:   Wed, 22 Jul 2020 17:42:31 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in
 SCTP_DELAYED_SACK processing
Message-ID: <20200722204231.GA3398@localhost.localdomain>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc'ing linux-sctp@vger.kernel.org.

On Wed, Jul 22, 2020 at 05:38:58PM -0300, Marcelo Ricardo Leitner wrote:
> This sockopt accepts two kinds of parameters, using struct
> sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
> notice an implicit cast from the smaller (latter) struct to the bigger
> one (former) when copying the data from the user space, which now leads
> to an attempt to write beyond the buffer (because it assumes the storing
> buffer is bigger than the parameter itself).
> 
> Fix it by giving it a special buffer if the smaller struct is used by
> the application.
> 
> Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
> Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/socket.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9a767f35971865f46b39131fc8d96d8c3c2aa1a8..b71c36af7687247b4fc9e160219b76f5c41b2fe2 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2756,6 +2756,7 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	struct sctp_association *asoc;
> +	struct sctp_sack_info _params;
>  
>  	if (optlen == sizeof(struct sctp_sack_info)) {
>  		if (params->sack_delay == 0 && params->sack_freq == 0)
> @@ -2767,7 +2768,9 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
>  				    "Use struct sctp_sack_info instead\n",
>  				    current->comm, task_pid_nr(current));
>  
> -		if (params->sack_delay == 0)
> +		memcpy(&_params, params, sizeof(struct sctp_assoc_value));
> +		params = &_params;
> +		if (((struct sctp_assoc_value *)params)->assoc_value == 0)
>  			params->sack_freq = 1;
>  		else
>  			params->sack_freq = 0;
> -- 
> 2.25.4
> 
