Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCB2E97B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfE2XiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:38:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34000 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfE2XiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:38:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id h1so4849225qtp.1;
        Wed, 29 May 2019 16:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B1MrhhjH6sWxyQ53mVFEQj+9Um0+fhEmxAR3L3EopPc=;
        b=DHlFMUMpvllwAJIYg6fpDk105AumKUw/r+oGLZw6+05VcVuUFh/vqSlVoBK0IhzRc9
         scGLyiBlj16Y45fO4pmyEKZJT6m8HdbnwAFu3PL8lRtSPvSRZRmhMXidQj+rlzztDInk
         LzSr2kvTJSQT34kyIdXElc5fvmIXnM5Jm3U5ZfZ7Gz9kTTeoHy9cawnuV43oyUWk/iMq
         sIhkc+iO8zp4uvTokRAdlTrFeOEd/skT/N+vPXDC1DFWQI50ey6/aJoBKfzeZFqszJve
         QyuulHc7s7pbNvX8mZtVsFDJFq1hou0PlYNZr/KUJ4EslEpQasWLUHQq0QWxWHL2FufU
         EzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B1MrhhjH6sWxyQ53mVFEQj+9Um0+fhEmxAR3L3EopPc=;
        b=ejwWw2yC6RtSuo+uFsXqKQoZzr6GOVDPtnELh4wpwJ4QmxKYwa/5QzYLHXi7DCXSq+
         FJ4kObuHUWrpL4ET3m9V8PgngQ+R8cL5oWVVv+dwgiIBpbPu/skiVROCcl7usppbBwk1
         AzM9r2192n0o067ochZw4GHMCsoxXWabtgMq43bE2jUAJBugvRllYYNcA0tkK1Vrm1G/
         vQtiTZq7pTywvMMX9xCFLVhZkrIwCLxZnuwKj2KWRK0YAW3ERqP+IvioKoVmcjkvVLHc
         0E06mLHpIElRRBJZhqhzvqI84QNy2NCplB2sHBhUXWVSbBmnD1iYyRLxBudj5LmSjIuo
         Dviw==
X-Gm-Message-State: APjAAAVfnWe86tvjSrevbvQdP1zokcj8XLm0YHnOqSOz3VY//oEcCvpO
        T7M5SvsGNEKvRoCnjuttcio=
X-Google-Smtp-Source: APXvYqzpyfKqjuPxqMSE8Zk4DACc0lSPIyI5UdHuRTOcKITWxv7uiNIIFp4w/jM/Pxs6Ia50u1/PJA==
X-Received: by 2002:aed:3a45:: with SMTP id n63mr641119qte.109.1559173081297;
        Wed, 29 May 2019 16:38:01 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.91])
        by smtp.gmail.com with ESMTPSA id x2sm555452qke.92.2019.05.29.16.37.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 16:38:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9498FC1BD8; Wed, 29 May 2019 20:37:57 -0300 (-03)
Date:   Wed, 29 May 2019 20:37:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190529233757.GC3713@localhost.localdomain>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529190709.GE31099@hmswarspite.think-freely.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 03:07:09PM -0400, Neil Horman wrote:
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2419,9 +2419,12 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
>  	/* Copy cookie in case we need to resend COOKIE-ECHO. */
>  	cookie = asoc->peer.cookie;
>  	if (cookie) {
> +		if (asoc->peer.cookie_allocated)
> +			kfree(cookie);
>  		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			goto clean_up;
> +		asoc->peer.cookie_allocated=1;
>  	}
>  
>  	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily

What if we kmemdup directly at sctp_process_param(), as it's done for
others already? Like SCTP_PARAM_RANDOM and SCTP_PARAM_HMAC_ALGO. I
don't see a reason for SCTP_PARAM_STATE_COOKIE to be different
here. This way it would be always allocated, and ready to be kfreed.

We still need to free it after the handshake, btw.

  Marcelo
