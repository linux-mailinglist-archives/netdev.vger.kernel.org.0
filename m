Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63D1DBE3F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgETTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETTqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:46:34 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF20C061A0E;
        Wed, 20 May 2020 12:46:33 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 190so4932136qki.1;
        Wed, 20 May 2020 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mcSZw5KQg0kqjmS62PMSqZhL7vTqW0Zf7EDd/hel+bo=;
        b=V3E1P7uOlaVf4R+IBcr4uVVWw6zRKqHOzbqulZ5klHKdMDjgUjLp3/shiXJ8A3YkqT
         jt4nuktv10HrLWttY1hUvskeRfk3UnDrskbBhWPmWWwZTnkr1lPN6UyJHQJBgU2t7m3e
         WWA0nNMTIlEv93GHftDRHYPd3Hwgf/heUClrsaeOAHy/qPftOS0Oszdw/30MmaSNZkFK
         OKH6Q8BV7ulPqbY01vgPaqTzLsoX/T56DJEwCuecpLrN7YqvPLonkSd+EeL94HETyQbg
         iI4yAfSSse0pgwh5jhOHv0CbvCRBHKWIBChFjgJFPOSDixblLFpsbeNE7mgesaUyF5tP
         /PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mcSZw5KQg0kqjmS62PMSqZhL7vTqW0Zf7EDd/hel+bo=;
        b=O3T0uslRaBe1lTZFHb+FrGbSAfjr03Q3UvzONVy6npQr9Iv7bjDTC5XKrPPWYda/kM
         AdCMYw3DdgVLVhiAJRggpxuAYAME1VIjng5A7tt1eQc/aQGiQovmJYUGo1ZcPYwcK5sI
         5OeM7thvNdG053s5iQKvPA/anGMV0CMW+/NCZr8Hv+BAKf2zbJ0xBvzZSZgvAKzGaSs8
         GpDjfaHBw827+OkWXIuDyT0Q5RoHQ3qjZuygYymFlC6U5rdz3tXJvyqCZvqxyT9pI2eM
         9is3CXU8mpbMlI0a4xMRfoe9pGOTVAGDenLXcGxXCu9zkyuzeXRfXEYbhnay+cG4p3jA
         OfLg==
X-Gm-Message-State: AOAM530nfrkXjPFB3fT1x4XdXI6nhFLB8ikVfFPI/O0P4t8FsDb8T2rz
        0Keo4QIXxZeRmGJXarZPD5U=
X-Google-Smtp-Source: ABdhPJwXMNHYdNUmsn0BkW9kEShhhi96KYLxfmtDHutfxLF7tn3wmi/HCvfCxR0EDpk8Fa3jPBgM+A==
X-Received: by 2002:a05:620a:846:: with SMTP id u6mr3993303qku.346.1590003993045;
        Wed, 20 May 2020 12:46:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:fa5d:572c:344c:b561:94e0])
        by smtp.gmail.com with ESMTPSA id k25sm2884082qki.135.2020.05.20.12.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:46:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9698DC0A6B; Wed, 20 May 2020 16:46:29 -0300 (-03)
Date:   Wed, 20 May 2020 16:46:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jere =?iso-8859-1?Q?Lepp=E4nen?= <jere.leppanen@nokia.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH net 1/1] sctp: Start shutdown on association restart if
 in SHUTDOWN-SENT state and socket is closed
Message-ID: <20200520194629.GS2491@localhost.localdomain>
References: <20200520151531.787414-1-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200520151531.787414-1-jere.leppanen@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 06:15:31PM +0300, Jere Leppänen wrote:
> Commit bdf6fa52f01b ("sctp: handle association restarts when the
> socket is closed.") starts shutdown when an association is restarted,
> if in SHUTDOWN-PENDING state and the socket is closed. However, the
> rationale stated in that commit applies also when in SHUTDOWN-SENT
> state - we don't want to move an association to ESTABLISHED state when
> the socket has been closed, because that results in an association
> that is unreachable from user space.
> 
> The problem scenario:
> 
> 1.  Client crashes and/or restarts.
> 
> 2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.
> 
> 3.  Client reconnects using the same addresses and ports.
> 
> 4.  Server's association is restarted. The association and the socket
>     move to ESTABLISHED state, even though the server process has
>     closed its descriptor.
> 
> Also, after step 4 when the server process exits, some resources are
> leaked in an attempt to release the underlying inet sock structure in
> ESTABLISHED state:
> 
>     IPv4: Attempt to release TCP socket in state 1 00000000377288c7
> 
> Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
> an association is restarted in SHUTDOWN-SENT state and the socket is
> closed, then start shutdown and don't move the association or the
> socket to ESTABLISHED state.
> 
> Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
> Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>
> ---
>  net/sctp/sm_statefuns.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 26788f4a3b9e..e86620fbd90f 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1856,12 +1856,13 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
>  	/* Update the content of current association. */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
>  	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
> -	if (sctp_state(asoc, SHUTDOWN_PENDING) &&
> +	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
> +	     sctp_state(asoc, SHUTDOWN_SENT)) &&
>  	    (sctp_sstate(asoc->base.sk, CLOSING) ||
>  	     sock_flag(asoc->base.sk, SOCK_DEAD))) {
> -		/* if were currently in SHUTDOWN_PENDING, but the socket
> -		 * has been closed by user, don't transition to ESTABLISHED.
> -		 * Instead trigger SHUTDOWN bundled with COOKIE_ACK.
> +		/* If the socket has been closed by user, don't
> +		 * transition to ESTABLISHED. Instead trigger SHUTDOWN
> +		 * bundled with COOKIE_ACK.
>  		 */
>  		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
>  		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
> 
> base-commit: 20a785aa52c82246055a089e55df9dac47d67da1

This last line is not standard, but git didn't complain about it here.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
