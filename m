Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822332AA592
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKGNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:50:31 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD19BC0613CF;
        Sat,  7 Nov 2020 05:50:30 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so764712wrx.2;
        Sat, 07 Nov 2020 05:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3gI9pU1kZniwydk4ZvLlbDT6BxnWoHXg3k1BNhrTFyc=;
        b=Kirt/neQW74qNAh3fFYjhxN3amR77VRAR1fZ01KiYOQ1XVGOkckuEhZDZqybsLdjX5
         OBiKq0omGN9l3aND5ocnL3dZ5zInNkpEIVwFaZb6NZGNwvrScUxukPB1SzJP3elx4EdB
         8N4oNx6+kxuQnt0osyxCZbxOrSm+hSNo6QF4me7R9i5vyq+tiZaegwDPK9CqWioZ7ge1
         mVV08QTMGTXjmG+HnuZ099DaR9sJLMGtr+HPbS7tDBbQCj2sRInHfF/XfDqk4BR7Eazm
         W3qpQ1Aq/UaCJSuK3TtgCIqaBlscjfBuvXFXv+IzplqkbSYDpaxEZj+gOqG4g1Yosmz+
         QrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3gI9pU1kZniwydk4ZvLlbDT6BxnWoHXg3k1BNhrTFyc=;
        b=qx5RqpQ1Pu6rS3jWzQKcQcH54DATh5bFUEhzGf3/AUiVKUdCaRNd3QIcoiPjKdQQn5
         bwRHnBKZa7Ni0YIiaTUtqtHlzcMseNAgvNMVo1XR5rJ1NJiDttKGjA4fR+9EoOZJ8XoV
         UuHT2V6GWndOt/769P5pIdliD2OfKfe6XqMncr9SGqZzqaXezfZkfrtz0MThNgiuJVnp
         7BZVs7EmlYwyFRS3Bkn+X/6idSc1oGYe16BIve0idylir711RlEns8ZqdhqDOJSDqE4v
         qwOfkhuHMl54pkoNJV4ZwaQcT1xJkB/6bSSoGW0jIKs2FRCFrfLMqQXnQTXojMOs3N7x
         iG5Q==
X-Gm-Message-State: AOAM533mM+FOKanE/z+bjYtNaNlAJcFSRNNNTiN5i/YJ6ZMwwe8RzUuq
        HQWjOokwJNok213ypsbwWC3EUqbe1wK8tQ==
X-Google-Smtp-Source: ABdhPJzoMfcGPK6u+pQmMBEGiGBvd2OEoxSS6Xhasy6Z/zewNH4j+o7Ytlo4E+7vx/oCod5nYTcdHQ==
X-Received: by 2002:a5d:5583:: with SMTP id i3mr4468814wrv.336.1604757029577;
        Sat, 07 Nov 2020 05:50:29 -0800 (PST)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id t199sm6467529wmt.46.2020.11.07.05.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:50:29 -0800 (PST)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Sat, 7 Nov 2020 13:49:40 +0000
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Artur Molchanov <arturmolchanov@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc: Fix return value from proc_do_xprt()
Message-ID: <20201107134940.c2hmfpcx743bqc5o@medion>
References: <20201024145240.23245-1-alex.dewar90@gmail.com>
 <20201106220721.GE26028@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106220721.GE26028@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:07:21PM -0500, J. Bruce Fields wrote:
> Whoops, got 3 independent patches for this and overlooked this one.  See
> https://lore.kernel.org/linux-nfs/20201106205959.GB26028@fieldses.org/T/#t
> 
> --b.

That looks like a cleaner fix. Thanks for looking anyhow and sorry for
the noise!

> 
> On Sat, Oct 24, 2020 at 03:52:40PM +0100, Alex Dewar wrote:
> > Commit c09f56b8f68d ("net/sunrpc: Fix return value for sysctl
> > sunrpc.transports") attempted to add error checking for the call to
> > memory_read_from_buffer(), however its return value was assigned to a
> > size_t variable, so any negative values would be lost in the cast. Fix
> > this.
> > 
> > Addresses-Coverity-ID: 1498033: Control flow issues (NO_EFFECT)
> > Fixes: c09f56b8f68d ("net/sunrpc: Fix return value for sysctl sunrpc.transports")
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > ---
> >  net/sunrpc/sysctl.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
> > index a18b36b5422d..c95a2b84dd95 100644
> > --- a/net/sunrpc/sysctl.c
> > +++ b/net/sunrpc/sysctl.c
> > @@ -62,6 +62,7 @@ rpc_unregister_sysctl(void)
> >  static int proc_do_xprt(struct ctl_table *table, int write,
> >  			void *buffer, size_t *lenp, loff_t *ppos)
> >  {
> > +	ssize_t bytes_read;
> >  	char tmpbuf[256];
> >  	size_t len;
> >  
> > @@ -70,12 +71,14 @@ static int proc_do_xprt(struct ctl_table *table, int write,
> >  		return 0;
> >  	}
> >  	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
> > -	*lenp = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
> > +	bytes_read = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
> >  
> > -	if (*lenp < 0) {
> > +	if (bytes_read < 0) {
> >  		*lenp = 0;
> >  		return -EINVAL;
> >  	}
> > +
> > +	*lenp = bytes_read;
> >  	return 0;
> >  }
> >  
> > -- 
> > 2.29.1
