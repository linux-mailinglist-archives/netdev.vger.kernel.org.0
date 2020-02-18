Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756CB161FA8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgBRDs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:48:27 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39578 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgBRDs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:48:26 -0500
Received: by mail-qv1-f67.google.com with SMTP id y8so8549193qvk.6;
        Mon, 17 Feb 2020 19:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vu6CU59Cz7sEnbzV237zGVka9ncms1GdBGbJ0ZwzOXI=;
        b=YoayJ2jin/ywHSPWozpZVY7OyPqp9PSeR3oV6sEk6H3k4K3bCH/QJPlgWlPRXr7KSj
         FD02EDAcEy9IdipC2iyMDeFveQm4OpK37p3IVGHHKoNnvWs9lSA4R1eFk036gVm1OyBf
         /xI6V4dP6WwUVnOlqxIdgxIBXdjUq39wGqFh+xEdclIKXW36ZKT9erVHJMnZbGe+3q7t
         cpdPVJBC7D3Ek/+CUXQqaOkaDXSSVHgj/FgJZhELvhoSq90LyCdh87V9hsY8OGWarXK2
         gv5uZ3V4dtQaWKZH//defMevIr1eGxdGZtp2u7d8PMVbw9QrWjjuvc0dB7XzjvxLg/5i
         Xc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vu6CU59Cz7sEnbzV237zGVka9ncms1GdBGbJ0ZwzOXI=;
        b=rXBJbzuc4OG+R00oTAJ4OxwDVbqXj1Q4miwlOVvfacJPRaGlCJ37jseQafNKp0rytf
         qTH6/mmcbifsgA08Hk3e/8aVcSeqDkCxK3Aly0zighHBlr8IOVhOKMY48u5MgjQ6oS7n
         IZFDbZ4fc4XiFvevVcaT+qv1ax2LcwdZME2HaWB/xO9YGNQSSdZSMPNkIt6MT2zjw3MK
         v7tst+Vu/1o7PiVu+qM2NZnfHJ6cyz5QFcn5ChRi2Z5stA2QGut1HJtRc36Bhm7WBbpt
         H995t5hlyBXUhtOeyc4visex3yx/Q3TMsCAowchnUODDtOIRvQhg0D+Xl1q9U8MqmGL1
         Zuhg==
X-Gm-Message-State: APjAAAWsdu9l4dwXtvK+/FvkkIuN00eerCqfqFsvBGhDjm34OfLsoi6b
        DUt+uiAdnOB4c7+cyMiuwbccEdh8r0c=
X-Google-Smtp-Source: APXvYqyAsbVlr3ckRyhbQymQ/+etK6giDEhUcEvgTUQVlQfxn7xacKiFXxd9POzuib8CSn/p+M0nHg==
X-Received: by 2002:ad4:55a4:: with SMTP id f4mr15069472qvx.221.1581997705642;
        Mon, 17 Feb 2020 19:48:25 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:d58:b2a5:6cad:97fb:fa6f])
        by smtp.gmail.com with ESMTPSA id 24sm1342916qka.32.2020.02.17.19.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 19:48:25 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9201AC0DD6; Tue, 18 Feb 2020 00:48:22 -0300 (-03)
Date:   Tue, 18 Feb 2020 00:48:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net] sctp: move the format error check out of
 __sctp_sf_do_9_1_abort
Message-ID: <20200218034822.GB2547@localhost.localdomain>
References: <1833bf6abc2610393666b930fe629534cd21e0fa.1581957292.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1833bf6abc2610393666b930fe629534cd21e0fa.1581957292.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 12:34:52AM +0800, Xin Long wrote:
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
> Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 748e3b1..e2b2b41 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -170,6 +170,16 @@ static inline bool sctp_chunk_length_valid(struct sctp_chunk *chunk,
>  	return true;
>  }
>  
> +/* Check for the format error in an ABORT chunk */

Can we just change this comment to:
+/* Check for format error in an ABORT chunk */
(just s/the //)
It is slightly misleading otherwise.

Rest of the patch LGTM.

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
