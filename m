Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC54D701C
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 18:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiCLRUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 12:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCLRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 12:20:45 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFDAEB16B
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 09:19:39 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 6so10166302pgg.0
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 09:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vHg87Lf9dvBWlrB/awtWe477mXwsvDm+/Qcqu3QGI80=;
        b=P88T2Pc7DXzAMOhsmi4ll9qyZi+5Qpj2tcqNVzq4AvE3Btwe59iYCYxfuRIWU/4Uve
         eSt+8IeuNbi346lYRjc5pjNbZs9QlaNPhqJrRgLL8sTTv0dHf/kfRgnOmNsg7YDmPxwk
         KTnaxGL460jujbNG59nbcmLiJfJt8dpUQ3Pg8XUPATQvH6TJbUzShvaZwG3lcM65YD9J
         dUZVAhVIt6fQCKIZNv9mobfxRTiqBM6F4+x+uCbXhdQxRqLkWCyFoObDUTxU+s70GE76
         2YiJmulbX34OKn3HR27BxhQR8Da5veWA7SLJGdcbvUi+DIfeFaBRILiVVuMY3FSsyMNR
         E82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vHg87Lf9dvBWlrB/awtWe477mXwsvDm+/Qcqu3QGI80=;
        b=OI9nY9MNcu5ZnAoI97BP5bqkue51mEloeRgKFQ7jXUzaVENBqUkFSbAT5Y2rSMvhYJ
         P/PvNfFH2kb52xyFp89mvgaGuFq4SlGeEo55Yp85uHIxpkl6kr+jAxZUMwFVXf7jB5Xn
         hQj6gKhEYOvwRJkk4rpS4pvbzSjMUZdchEcQy6DFWDvplv08qgZwwDLwPoaSwVj/8t2U
         7ehwT/ErdRnYaP5MvVo+Unvo+VdVrGiBw5lA5c7w4e+Z4pa75Jx2hp/FLeukuiW/naSd
         +rkcKgBDgte4SzYlh1/hKDDXN/s/cewNxJwxSHkpnRDBbfXsK3bYqp7OSETir5CIMYT6
         Mt2w==
X-Gm-Message-State: AOAM531///AT6WIKAtZ1mwsRd6TbrF1uCZtZNvMvTwvO3gy0pI8Ls2gt
        SkmvFsqcLZNvqk/Ck85JL/vUSBn/Ebb4FQ==
X-Google-Smtp-Source: ABdhPJzAGbpjKN9uYdw3be5VX6wUc+PScuzlCc3yzyeyf4Kvzr9TeuhhGHSz0qLB5ZpfVGydWxWXyw==
X-Received: by 2002:a63:c156:0:b0:37c:9955:ab24 with SMTP id p22-20020a63c156000000b0037c9955ab24mr13289109pgi.90.1647105579096;
        Sat, 12 Mar 2022 09:19:39 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id e18-20020a056a001a9200b004f759dcd841sm13899457pfv.42.2022.03.12.09.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 09:19:38 -0800 (PST)
Date:   Sat, 12 Mar 2022 09:19:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Cc:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ipv4: tcp.c: fix an assignment in an if condition
Message-ID: <20220312091936.1f8c9289@hermes.local>
In-Reply-To: <20220312162744.32318-1-alexander.vorwerk@stud.uni-goettingen.de>
References: <20220312162744.32318-1-alexander.vorwerk@stud.uni-goettingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 17:27:44 +0100
Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de> wrote:

> reported by checkpatch.pl
> 
> Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
> ---
>  net/ipv4/tcp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 28ff2a820f7c..7fa6e7e6ea80 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -959,10 +959,10 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>  	struct sk_buff *skb = tcp_write_queue_tail(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	bool can_coalesce;
> -	int copy, i;
> +	int copy = size_goal - skb->len;
> +	int i;
>  
> -	if (!skb || (copy = size_goal - skb->len) <= 0 ||
> -	    !tcp_skb_can_collapse_to(skb)) {
> +	if (!skb || copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
>  new_segment:
>  		if (!sk_stream_memory_free(sk))
>  			return NULL;

Your new code will crash if skb is NULL.
