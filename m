Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70024BEAD
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgHTN34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgHTN3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:29:15 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF12EC061385;
        Thu, 20 Aug 2020 06:29:14 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id p25so1499514qkp.2;
        Thu, 20 Aug 2020 06:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJlPxByGZ4WZhAkynFej/mh+RMtilImvZkFQgBD/C0g=;
        b=f2thofSJ+Y8TZYCpg+jRj2SZuEOKiFKTf6HceJnlrJx9y/XyqKMbo3wiqU/aszLgYU
         IQS1xITJxKjcdaLzV3jbjPdNVitJBuqZvG+dSU65YNk+d0X8UpIStqbXp7Plszbi6Pi2
         GHxoN6irFBO8csBfUitUhv8y/fPkoDqEnZBi8n/jRZfdJAxkhALYtCfgllRzcA3S3cPa
         pKLC3s7UhPG2PS11+roFpN7FlG+xs6IUA9hBVPePzvTRReQ59qIrHuDHxc86S51qVAum
         q6vpT/dak14+tGBuBP1G+XQgRm9+uYRnnAcXgJNkkmhEmNJsUrPDY2zrNG4o4xUcEnv8
         xbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NJlPxByGZ4WZhAkynFej/mh+RMtilImvZkFQgBD/C0g=;
        b=pzIJXOhxR/bqZ+GkSqndd5rsR76lcHy7BuA5dzkj/w6iM0FDwHUfZXOxGRz8jiaQ8u
         rywgHbxJQflPu2HX3PTDUZ3PtK3/kMFlZ9Q2Nx6uYJhkR4EmFmqwPy4If9qLlJu6gi0K
         ISav50v3/F8suN3Xgy+A+m1ry4LL7m0/5Rjuvbe64DZkXQLKj6O9hzEiOmxDgBiaRHup
         DEeqn20twKFf9FAZRVRPnUQ8I47e5PcAdI9Mkq0UHeAf7YFCvvLaQVe4l6nFLat2CcED
         xeAIoWrCNsYAIo6hvRz0Nz6D/raXPkluMlxJ+l6rg4TF9YD2ySNIJARJvzael4x7af1C
         fqpQ==
X-Gm-Message-State: AOAM531cAH1df0cTEfAvhJa3gcvmFBmthvo0rwD6ZUDQKeHh+rw6c5cx
        4XP1FrnsDr4ZH6UixS20EgbCEZ8tqq33zw==
X-Google-Smtp-Source: ABdhPJwr9emjU2mlyMIMr5MuZzuOuHkouQmBGDscZorqaDtkl6i1EEJvAM6AhjdGpTxZn7319aoVHA==
X-Received: by 2002:a05:620a:1285:: with SMTP id w5mr2528506qki.21.1597930153758;
        Thu, 20 Aug 2020 06:29:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:8002:1323:e13e:9d76:7bc8])
        by smtp.gmail.com with ESMTPSA id g11sm2077970qke.128.2020.08.20.06.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:29:12 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A8A27C35FC; Thu, 20 Aug 2020 10:29:10 -0300 (-03)
Date:   Thu, 20 Aug 2020 10:29:10 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Message-ID: <20200820132910.GK3399@localhost.localdomain>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
 <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 02:40:52PM +0000, David Laight wrote:
> 
> The number of output and input streams was never being reduced, eg when
> processing received INIT or INIT_ACK chunks.
> The effect is that DATA chunks can be sent with invalid stream ids
> and then discarded by the remote system.
> 
> Fixes: 2075e50caf5ea ("sctp: convert to genradix")
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  net/sctp/stream.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> This needs backporting to 5.1 and all later kernels.
> 
> (Resend without the RE:)
> 
> Changes since v1:
> - Fix 'Fixes' tag.
> - Improve description.
>

"[PATCH net v2] ..."
        ^^^-- the tree tag I had mentioned :-)

Anyhow, the rest looks fine.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks David.

> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index bda2536dd740..6dc95dcc0ff4 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -88,12 +88,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>  	int ret;
>  
>  	if (outcnt <= stream->outcnt)
> -		return 0;
> +		goto out;
>  
>  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
>  	if (ret)
>  		return ret;
>  
> +out:
>  	stream->outcnt = outcnt;
>  	return 0;
>  }
> @@ -104,12 +105,13 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
>  	int ret;
>  
>  	if (incnt <= stream->incnt)
> -		return 0;
> +		goto out;
>  
>  	ret = genradix_prealloc(&stream->in, incnt, gfp);
>  	if (ret)
>  		return ret;
>  
> +out:
>  	stream->incnt = incnt;
>  	return 0;
>  }
> -- 
> 2.25.1
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
