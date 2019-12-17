Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F3B122B91
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfLQMdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:35 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34322 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfLQMdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:33:35 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so5618003pgf.1;
        Tue, 17 Dec 2019 04:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X+tkJq6Kzzh3Efylf4X2AGgl5igvnPDcCDms+mWzq/k=;
        b=nPcGr0WCYv6KwKLUxJ7vIyNIGtc3QuGkIp+sjgQdm7Ktwi2bGeLb89akYLBWJ9xeKW
         W+6E+exIFts32JN6d5pI/A82yC2Zkw1tTK0mLo0biG635Obtk1RV4oPmwaIXfzzlGwql
         Ref8WGVUQe6g8clWAVEONJ+NrQY4jUsTclxpJlMQhUjmoOb6qwJJRqZi7k8meC6MeyGv
         g1zf98NMUbaQNrpcqeHwRBYRkX16fJavCmooVoA57neu0Uioy3G2cT0aSAb3/geHoqfN
         ir/k68498+l/+FFn4Lm4seArLGPvH6cOVdYxFdSXk3GmxLb4elz0bqxqArGi+uN7uXuD
         KDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X+tkJq6Kzzh3Efylf4X2AGgl5igvnPDcCDms+mWzq/k=;
        b=UmDwTzChwi3Ul2P/vvW+U5zm89hK3puImTTyVbI4wcWcxI4b46VuLDc15EDt8SMdDL
         mbutpRHhBfJ3Dkl2VwBzXU3WKZEhXSDrYuml+J6QmGcU6D4yHtrTt45QHipmvOh7yghx
         OMh1W29Vmp09fGl+HMBhp5mOWWXm5bu9HObAUq5raUakvxj8EPLTpVDVP70wuHs+wxFQ
         2G9mHCVV5Da8oK60z1dY+YdN/UCmVOHYFLUMbW8z1Rmg9YnYrvB9HZV89v4hUCKKcpG8
         Odl6m+lOUkccA8iGMT5vz3SyNMjf7cWfk+bF/OD0Q6SWC4yLyxirMUjDntn6GyANioUh
         7qyQ==
X-Gm-Message-State: APjAAAU3RIi3be2cE7Qoig5gytsPlYE6ckLULAkPFi2LGpjKheh9pbja
        2LOV8W6ELb1wBd2osMlTeEjs9om4FWI=
X-Google-Smtp-Source: APXvYqzKmvWTZ2n6m85CaC93Aq2oU91CazQm2mqGrYGx907zBKYfSu17ATEFxlr/Cg5M/Wap9XZKfw==
X-Received: by 2002:a63:cf14:: with SMTP id j20mr24547766pgg.430.1576586014409;
        Tue, 17 Dec 2019 04:33:34 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.83])
        by smtp.gmail.com with ESMTPSA id bo9sm3378228pjb.21.2019.12.17.04.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 04:33:33 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 142E3C0DD5; Tue, 17 Dec 2019 09:33:30 -0300 (-03)
Date:   Tue, 17 Dec 2019 09:33:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream
 initialization
Message-ID: <20191217123329.GH4444@localhost.localdomain>
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
 <20191217115513.GB730@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217115513.GB730@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 06:55:13AM -0500, Neil Horman wrote:
> On Mon, Dec 16, 2019 at 10:01:16PM -0300, Marcelo Ricardo Leitner wrote:
> > syzbot reported a memory leak when an allocation fails within
> > genradix_prealloc() for output streams. That's because
> > genradix_prealloc() leaves initialized members initialized when the
> > issue happens and SCTP stack will abort the current initialization but
> > without cleaning up such members.
> > 
> > The fix here is to always call genradix_free() when genradix_prealloc()
> > fails, for output and also input streams, as it suffers from the same
> > issue.
> > 
> > Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> > Fixes: 2075e50caf5e ("sctp: convert to genradix")
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >  net/sctp/stream.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index df60b5ef24cbf5c6f628ab8ed88a6faaaa422b6d..e0b01bf912b3f3cdbc3f713bcfa50868e4802929 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> > -	if (ret)
> > +	if (ret) {
> > +		genradix_free(&stream->out);
> >  		return ret;
> > +	}
> >  
> >  	stream->outcnt = outcnt;
> >  	return 0;
> > @@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
> >  		return 0;
> >  
> >  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> > -	if (ret)
> > +	if (ret) {
> > +		genradix_free(&stream->in);
> >  		return ret;
> > +	}
> >  
> >  	stream->incnt = incnt;
> >  	return 0;
> > -- 
> > 2.23.0
> > 
> > 
> As mentioned in the other thread, shouldn't genradix_prealloc clean this up
> internal to its function.  It seems odd having to free memory allocated on
> error.

Depends on how fatal you're considering that it is.  With the current
version of genradix_prealloc() there could be a place that attempted
to pre-allocate it, it failed, and then resumed later on. SCTP can't
do that, because right after this prealloc it will write to each
and every element in there, but someone could.

  Marcelo
