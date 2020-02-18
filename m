Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE0161FC5
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 05:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgBRESo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 23:18:44 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:46004 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgBRESn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 23:18:43 -0500
Received: by mail-qv1-f67.google.com with SMTP id l14so8550987qvu.12;
        Mon, 17 Feb 2020 20:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rrl2PGiVKhiS3+BWSYzKqXLa18ZV5zl04M5paHTNB9w=;
        b=VN165w2rOIwUpLADVTNCGoUNRpIT460bdknzHNDWEjIyo6Zb2Aic5q9XEN9hxLF/kD
         ElpwQ0iMrt4fY0cvAeDHEQcMmosGbtMboL7IkvZxvbCtHPaJUr5HtXnY1YFYblK7+G/H
         +uJH7LFL9W/mAZPN3ERlieloSJ9re046dKgOtUlVowPg9XVoPItmAJ9h8w894y93xad2
         tidudO0viF0uTe/51xwqRWlzwQHj9exP5QGv/UXxYESV0v4jnveLmVENlmByNJ0kocbh
         /E4AiJfKMcL8HH5FsOPD353XwRMPlFR2cbqtZOl3+KPs0CzsuYtcW/tQOjaG1SlH93ie
         4MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rrl2PGiVKhiS3+BWSYzKqXLa18ZV5zl04M5paHTNB9w=;
        b=lW+plZenF5vxtUmHfO5d4YgV4veX+BCyjS2WAYYcx/bmXTV9ZP8vIvoGd2QP0hsUnu
         Hao0a1M0ci5Shr8/66pSqppMTQsR7SF2EYVwmb+WK3jS6dJ+24K8w0YgT6ieOlOsrs1L
         NZ2homqhvB3izMiaJ+YoLmwoBvuYD55m3QaJPRcqHEpTtBXyPTo9zyYAUgN1yr74gH0Q
         ABAnfsRUBQC+RUz1Sw1Sd4mAAuUDVik2/DMfLo2f7Da7b27HEkh6gp5QVnICwnt0ocJo
         nMtJyEZOgoiGyXRaMCDeeFQ7gtbAIF3/gQ+Cye5Fr5C7bElhEpFDxBe1vbFWK8Auos6F
         ErOQ==
X-Gm-Message-State: APjAAAXu2LqGGhuPO+VWFrom9qOD9o1kxDxsacA/1dqJ8po8W8id5YvX
        yxWG/UVpc35oTwLcX/xYyBA=
X-Google-Smtp-Source: APXvYqyCfGp0PYo9Yhgnqnbv0dVtKt4qlsVl3vjv4wjcYHNLaPFjso4D+5mstpBxxHMkNoiBVod4Kw==
X-Received: by 2002:a0c:e2cf:: with SMTP id t15mr15437971qvl.127.1581999522385;
        Mon, 17 Feb 2020 20:18:42 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:d58:b2a5:6cad:97fb:fa6f])
        by smtp.gmail.com with ESMTPSA id k37sm1277690qtf.70.2020.02.17.20.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 20:18:41 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5F35FC0DD6; Tue, 18 Feb 2020 01:18:39 -0300 (-03)
Date:   Tue, 18 Feb 2020 01:18:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 net] sctp: move the format error check out of
 __sctp_sf_do_9_1_abort
Message-ID: <20200218041839.GC2547@localhost.localdomain>
References: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0002ee4446436104eb72bcfa9a4cf417570f7e.1581998873.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 12:07:53PM +0800, Xin Long wrote:
> When T2 timer is to be stopped, the asoc should also be deleted,
> otherwise, there will be no chance to call sctp_association_free
> and the asoc could last in memory forever.
> 
> However, in sctp_sf_shutdown_sent_abort(), after adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer, it may return error due to the
> format error from __sctp_sf_do_9_1_abort() and miss adding
> SCTP_CMD_ASSOC_FAILED where the asoc will be deleted.
> 
> This patch is to fix it by moving the format error check out of
> __sctp_sf_do_9_1_abort(), and do it before adding the cmd
> SCTP_CMD_TIMER_STOP for T2 timer.
> 
> Thanks Hangbin for reporting this issue by the fuzz testing.
> 
> v1->v2:
>   - improve the comment in the code as Marcelo's suggestion.
> 
> Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks :-)

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 748e3b1..6a16af4 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -170,6 +170,16 @@ static inline bool sctp_chunk_length_valid(struct sctp_chunk *chunk,
>  	return true;
>  }
>  
> +/* Check for format error in an ABORT chunk */
> +static inline bool sctp_err_chunk_valid(struct sctp_chunk *chunk)
> +{
> +	struct sctp_errhdr *err;
> +
> +	sctp_walk_errors(err, chunk->chunk_hdr);
> +
> +	return (void *)err == (void *)chunk->chunk_end;
> +}
> +
>  /**********************************************************
>   * These are the state functions for handling chunk events.
>   **********************************************************/
> @@ -2255,6 +2265,9 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
>  		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
>  		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
>  
> +	if (!sctp_err_chunk_valid(chunk))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
>  }
>  
> @@ -2298,6 +2311,9 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
>  		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
>  		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
>  
> +	if (!sctp_err_chunk_valid(chunk))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	/* Stop the T2-shutdown timer. */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
>  			SCTP_TO(SCTP_EVENT_TIMEOUT_T2_SHUTDOWN));
> @@ -2565,6 +2581,9 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
>  		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
>  		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
>  
> +	if (!sctp_err_chunk_valid(chunk))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
>  }
>  
> @@ -2582,16 +2601,8 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
>  
>  	/* See if we have an error cause code in the chunk.  */
>  	len = ntohs(chunk->chunk_hdr->length);
> -	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
> -		struct sctp_errhdr *err;
> -
> -		sctp_walk_errors(err, chunk->chunk_hdr);
> -		if ((void *)err != (void *)chunk->chunk_end)
> -			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
> -						commands);
> -
> +	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
>  		error = ((struct sctp_errhdr *)chunk->skb->data)->cause;
> -	}
>  
>  	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
>  	/* ASSOC_FAILED will DELETE_TCB. */
> -- 
> 2.1.0
> 
