Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CEA2FF34
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfE3PRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:17:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38333 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3PRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:17:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id a27so4081855qkk.5;
        Thu, 30 May 2019 08:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4A000il5T3jzbYsRqaA+7piiGaZhTSMA8bRbS6hmam4=;
        b=ti1Bco5a03yhkwzz1x/vtE5k3yPQ9pjgiDiB76maHMeQswqvVewwqqDlQtmj8nDZ4Z
         AjdL3x0cTNXoguUSFKXforFl8fWlKvMKRv8LAOK9Rz9qgBecyewG1R3WFVC40XdGIjtR
         6oMBcHnioALXukCdB0vx+9cPOBZ/FMKmdPSccbPEuetlGK/LqR818oT1Z5xQI8CCZ/aJ
         bOXG2MZdHHjDJMgvJP0eGdqsRqnAfOux5vyJa6jB6aRLyD16OoACSmRxWDnpU1WscP51
         q7ivnokVrrWv9mdX0FL8eV62tSqmq7l9fa26GYL2/a2UsaQtdRJtWjTLqdxqoFUYFMe2
         60NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4A000il5T3jzbYsRqaA+7piiGaZhTSMA8bRbS6hmam4=;
        b=hBWGKZAqos9kVR7JKBzLHe5ziH2NGvVeac4MYInAr1KL6x7JXaVsr+V2mxTzrxHcQC
         jQImAby6lr57T/F+cv7EG+SS8SHVimqOujy4BtAh0o74Uud/3q6ct6Wb2sLIvVhLh9r8
         lMG8ATlIcbfzS8nD3HvMtpiq+Ua3LwlAcrt61T/eM1I3s17N1wfcYfAIHY4YN1gfRdaM
         S+wFRHrfYQkA/rFdeVZHpkA5mHu/PI1m2DicxksT+FCNJcjC51lKniEvdRuBETowdLc9
         uJdTv11ypt3uMkSD/cckM4wal7ucuVTguLyVMrhLKDHAVezzWzUw9OvNjSRflha6nnSf
         2N2w==
X-Gm-Message-State: APjAAAXotAg9bpFviBaRCzg9+1QikTT/uIMLK3ZRUPeW5cGvTZtDkgzf
        Fj1aokUTxJBU3e6T8n0gQOQ=
X-Google-Smtp-Source: APXvYqxCD99bs2PZU3x0gd8+eKKKNHall5W3LxGwF3ZCxL+K8UgGYkntCNiWmbvDyBVdXojuqr1xLA==
X-Received: by 2002:a37:502:: with SMTP id 2mr3446513qkf.93.1559229429753;
        Thu, 30 May 2019 08:17:09 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:d534:113c:6e5f:4426:2d54])
        by smtp.gmail.com with ESMTPSA id 196sm1399167qkh.94.2019.05.30.08.17.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 08:17:08 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B67F9C1BC5; Thu, 30 May 2019 12:17:05 -0300 (-03)
Date:   Thu, 30 May 2019 12:17:05 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190530151705.GD3713@localhost.localdomain>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
 <20190529233757.GC3713@localhost.localdomain>
 <20190530142011.GC1966@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530142011.GC1966@hmswarspite.think-freely.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:20:11AM -0400, Neil Horman wrote:
> On Wed, May 29, 2019 at 08:37:57PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 29, 2019 at 03:07:09PM -0400, Neil Horman wrote:
> > > --- a/net/sctp/sm_make_chunk.c
> > > +++ b/net/sctp/sm_make_chunk.c
> > > @@ -2419,9 +2419,12 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> > >  	/* Copy cookie in case we need to resend COOKIE-ECHO. */
> > >  	cookie = asoc->peer.cookie;
> > >  	if (cookie) {
> > > +		if (asoc->peer.cookie_allocated)
> > > +			kfree(cookie);
> > >  		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
> > >  		if (!asoc->peer.cookie)
> > >  			goto clean_up;
> > > +		asoc->peer.cookie_allocated=1;
> > >  	}
> > >  
> > >  	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
> > 
> > What if we kmemdup directly at sctp_process_param(), as it's done for
> > others already? Like SCTP_PARAM_RANDOM and SCTP_PARAM_HMAC_ALGO. I
> > don't see a reason for SCTP_PARAM_STATE_COOKIE to be different
> > here. This way it would be always allocated, and ready to be kfreed.
> > 
> > We still need to free it after the handshake, btw.
> > 
> >   Marcelo
> > 
> 
> Still untested, but something like this?
> 

Yes, just..

> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index d2c7d0d2abc1..718b9917844e 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -393,6 +393,7 @@ void sctp_association_free(struct sctp_association *asoc)
>  	kfree(asoc->peer.peer_random);
>  	kfree(asoc->peer.peer_chunks);
>  	kfree(asoc->peer.peer_hmacs);
> +	kfree(asoc->peer.cookie);

this chunk is not needed because it is freed right above the first
kfree() in the context here.

>  
>  	/* Release the transport structures. */
>  	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 72e74503f9fc..ff365f22a3c1 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2431,14 +2431,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
>  	/* Peer Rwnd   : Current calculated value of the peer's rwnd.  */
>  	asoc->peer.rwnd = asoc->peer.i.a_rwnd;
>  
> -	/* Copy cookie in case we need to resend COOKIE-ECHO. */
> -	cookie = asoc->peer.cookie;
> -	if (cookie) {
> -		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
> -		if (!asoc->peer.cookie)
> -			goto clean_up;
> -	}
> -
>  	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
>  	 * high (for example, implementations MAY use the size of the receiver
>  	 * advertised window).
> @@ -2607,7 +2599,9 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len =
>  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> -		asoc->peer.cookie = param.cookie->body;
> +		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
> +		if (!asoc->peer.cookie)
> +			retval = 0;
>  		break;
>  
>  	case SCTP_PARAM_HEARTBEAT_INFO:

Plus:

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -898,6 +898,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
 						asoc->rto_initial;
 	}
 
+	if (sctp_state(asoc, ESTABLISHED)) {
+		kfree(asoc->peer.cookie);
+		asoc->peer.cookie = NULL;
+	}
+
 	if (sctp_state(asoc, ESTABLISHED) ||
 	    sctp_state(asoc, CLOSED) ||
 	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {

Also untested, just sharing the idea.

  Marcelo
