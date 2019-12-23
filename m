Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821A712961C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLWMvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:51:14 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43416 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWMvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:51:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so7156122pli.10;
        Mon, 23 Dec 2019 04:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BDrakKfjDi3WQg7svO46nFeOsEVCfLTsGK9tRf9Bdsg=;
        b=frWCb9gW6bRSEk7PZvfkeuLfy1ZU9C3+TbVucys73Qa5kFPyLAVrbdT4zxfb5zPPed
         EQdpXFlysWTP4NPkC6+xPaYhVjpBHvj27AwSyW5Pse93H+S4Jteqv1sFeq4jUVleOMpA
         tY9aZqoERjTqBSTg6++IlicJACFTAiYA7SLmlmcx1NGXYXu0udA1ypBZQKtQRATTrIH9
         gJ5rO2D89uTnpvMYixjsNnts/AmyR+UJ6xL2vByl417fF9xsNHrHAyfZijt1oZwAIzJV
         dQtGEzwMepdlHNRaI4gRAAqBujjINT1bWmHQzvs+m5DWRakaL8oDODT1QMehuaHGzuVQ
         wppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BDrakKfjDi3WQg7svO46nFeOsEVCfLTsGK9tRf9Bdsg=;
        b=eTbyYcezRQPKB0Lcy94Zo/z/WlR1rfARPGnKzIC9qoG7d+zwVxCfd285qMyhsR5Ean
         hQWtaRih6pJe6K3LWS44qau571sDZABFg48hULe8JJqrLl0GsfD8ryFORHpWfYmWPWqT
         NPsqvfPMbrBJemBc/pZDXLbEMXZRJ/pTwa38Yea/k1C8AYCUDDKaMLXp/niNLRD0Bb2m
         omdYx9j9xazdezDBss575DrBJLENaFXZryYiUea+n+6IOitObkpNSV/GTOjPFtE0TGr9
         aw0AuuZ9cOAFBR2yQGP1EXQj1+g3Exj3syI9PwohOveOtTLZiOOAfv6cKPFNikY2fLT8
         9G5g==
X-Gm-Message-State: APjAAAW0k3/9MHQH/Gkqvcaq5Vwr5Qon5E3tL589+YSwL39xEJr1rDbD
        HareF/LZe7wAphRNHa0Z4sg=
X-Google-Smtp-Source: APXvYqzh9qqH16ZJGV1USVM9xH19Nh8MswnQuCqQqdflmUWB5ep7NYci9ly9B5eHfXR0iHKYadWlrg==
X-Received: by 2002:a17:902:b709:: with SMTP id d9mr30610916pls.235.1577105472849;
        Mon, 23 Dec 2019 04:51:12 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id bo19sm7721910pjb.25.2019.12.23.04.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 04:51:12 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B6E3EC16F2; Mon, 23 Dec 2019 09:51:08 -0300 (-03)
Date:   Mon, 23 Dec 2019 09:51:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: fix err handling of stream initialization
Message-ID: <20191223125108.GK4444@localhost.localdomain>
References: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
 <20191223124609.GA30462@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223124609.GA30462@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 07:46:09AM -0500, Neil Horman wrote:
> On Fri, Dec 20, 2019 at 03:03:44PM -0300, Marcelo Ricardo Leitner wrote:
> > The fix on 951c6db954a1 fixed the issued reported there but introduced
> > another. When the allocation fails within sctp_stream_init() it is
> > okay/necessary to free the genradix. But it is also called when adding
> > new streams, from sctp_send_add_streams() and
> > sctp_process_strreset_addstrm_in() and in those situations it cannot
> > just free the genradix because by then it is a fully operational
> > association.
> > 
> > The fix here then is to only free the genradix in sctp_stream_init()
> > and on those other call sites  move on with what it already had and let
> > the subsequent error handling to handle it.
> > 
> > Tested with the reproducers from this report and the previous one,
> > with lksctp-tools and sctp-tests.
> > 
> > Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
> > Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >  net/sctp/stream.c | 30 +++++++++++++++---------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> > 
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 6a30392068a04bfcefcb14c3d7f13fc092d59cd3..c1a100d2fed39c2d831487e05fcbf5e8d507d470 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> > -	if (ret) {
> > -		genradix_free(&stream->out);
> > +	if (ret)
> >  		return ret;
> > -	}
> >  
> >  	stream->outcnt = outcnt;
> >  	return 0;
> > @@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> > -	if (ret) {
> > -		genradix_free(&stream->in);
> > +	if (ret)
> >  		return ret;
> > -	}
> >  
> >  	stream->incnt = incnt;
> >  	return 0;
> > @@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
> >  	 * a new one with new outcnt to save memory if needed.
> >  	 */
> >  	if (outcnt == stream->outcnt)
> > -		goto in;
> > +		goto handle_in;
> >  
> >  	/* Filter out chunks queued on streams that won't exist anymore */
> >  	sched->unsched_all(stream);
> > @@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
> >  
> >  	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
> >  	if (ret)
> > -		goto out;
> > +		goto out_err;
> >  
> >  	for (i = 0; i < stream->outcnt; i++)
> >  		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
> >  
> > -in:
> > +handle_in:
> >  	sctp_stream_interleave_init(stream);
> >  	if (!incnt)
> >  		goto out;
> >  
> >  	ret = sctp_stream_alloc_in(stream, incnt, gfp);
> > -	if (ret) {
> > -		sched->free(stream);
> > -		genradix_free(&stream->out);
> > -		stream->outcnt = 0;
> > -		goto out;
> > -	}
> > +	if (ret)
> > +		goto in_err;
> > +
> > +	goto out;
> >  
> > +in_err:
> > +	sched->free(stream);
> > +	genradix_free(&stream->in);
> > +out_err:
> > +	genradix_free(&stream->out);
> Isn't this effectively a double free in the fall through case?

Hm, if you got you right, the line 3 lines above is freeing '->in' and
the right above one, '->out', so no.
No other calls to genradix_free() are left in this function, too.

  Marcelo

> Neil
> 
> > +	stream->outcnt = 0;
> >  out:
> >  	return ret;
> >  }
> > -- 
> > 2.23.0
> > 
> > 
