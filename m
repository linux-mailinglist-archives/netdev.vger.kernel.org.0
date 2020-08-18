Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31555249058
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHRVqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHRVqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:46:52 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCDEC061389;
        Tue, 18 Aug 2020 14:46:52 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t23so16357994qto.3;
        Tue, 18 Aug 2020 14:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+NPoKFR14sGrBIsKe2eHB6lpYI4FJRNAke2pPgTjg8o=;
        b=MrjLTFlqng8dJIRh6g3fZqEog7z4bG3gbHfhoNA+O5HtIj37LRmmYkf+BdSpniRCxI
         ijS4+pX5EteofJZThG8wzkaS9XbX/jJ1uLiOKe0htV0pUDn4PsVCJ3FTIpgwfPBbYoiq
         hC/9AWu8YDQmDj3q6ghfoT+IpS4RU5yD6Cp3w0viHHDGNYnQ6HOB62uOEbhQI0DdgGt5
         qDzq7QslBfAzpx6hHMk3mQwe8+x/NlApbmpLuqf4exxvboFzP5OWNS0LkDqmuyRQGehv
         F6xwHnCzwp+YwDaxInK9oGGRt+ZMHd9unLSe50CE92wQ0e8c1sJpEoeNM8xnR83zG8pC
         kdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+NPoKFR14sGrBIsKe2eHB6lpYI4FJRNAke2pPgTjg8o=;
        b=jPrAAP4/ZRSR7Vd2aTKfVD0yZnOHrN2eYq+Q17DapVMcqOqUKJVhbwga4vRBM3fj1P
         S/mnzKLceK7li2TRwzFxf0NZBuDaEEiD2xjMZXejGG7AkCOdYZc/NGZcVRk0mhDEn4yl
         iLrnz8kS5/j1UjnPuO2wr+fzXmG6vD5NIO5duVj6kBk+882Bu4Nwj/yeVZy4u2baIpNO
         NtwQ1kdzIfgVP10eXddcgcUEprcNMqxiWCivEBJ1dFDON+vcwWOWz6FKy9lDvMrAtW9/
         4crRGI3lJoM37cbFClLuilG9btnGSQU8GsWZb1p6j0I64SfBxObQVzYv7Bw165jFf3G+
         PFtg==
X-Gm-Message-State: AOAM530vl8ezBt2hiepnC58bu4NEeQDOXD8UqgTxt6oYHKQwAFNtktQg
        Xs9s+DJIYlfw0zUAcDmExKS0PsCAv3oK2w==
X-Google-Smtp-Source: ABdhPJxkwum6RPYxrEcTVeO4v+CdIN55d9AYvAwoURruzCNhUjUm8HFxJK4RYJDwDV+cL5vAMSeMaQ==
X-Received: by 2002:ac8:4b78:: with SMTP id g24mr20349871qts.248.1597787211844;
        Tue, 18 Aug 2020 14:46:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:8002:1323:e13e:9d76:7bc8])
        by smtp.gmail.com with ESMTPSA id l45sm26034299qtf.11.2020.08.18.14.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 14:46:51 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0056EC18A0; Tue, 18 Aug 2020 18:46:48 -0300 (-03)
Date:   Tue, 18 Aug 2020 18:46:48 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Message-ID: <20200818214648.GJ3399@localhost.localdomain>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 02:36:58PM +0000, David Laight wrote:
> The number of streams offered by the remote system was being ignored.
> Any data sent on those streams would get discarded by the remote system.

That's quite brief and not accurate: it was only ignored if 'Xcnt <=
stream->Xcnt'.

Other than this and the Fixes tag, LGTM. Passes the tests here. I'll
ack the v2 then.

> 
> Fixes 2075e50caf5ea.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  net/sctp/stream.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> This needs backporting to 5.1 and all later kernels.

A 'net' tree tag in patch tags is welcomed.

> 
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
> 
