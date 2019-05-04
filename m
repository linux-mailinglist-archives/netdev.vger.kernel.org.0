Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E776B13B1C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfEDQIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:08:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44429 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:08:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so4236371pgv.11;
        Sat, 04 May 2019 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sC4Bm0S6AdzqPJDKFbvFqnZ8jJH7VxxKHL8X8WXctzY=;
        b=Qy5UvT9tK7aq1yH8lclXhft6+d/JDypXwBKIS31NCEoXBkkwBqtM1qmcroOAdjjzcJ
         HIcWozT8ShmM+S820CGLhDvYEYIj9LGR4pvCUhZ3MnaMo/fzYhnD3zmXYaE/OH78wgGY
         w3k1UMPOa62P3EkxJOpRdu7qi2sufU2olhywG5i/IrU3Bp2AoKkNwrjwbiBuqfx/5nTH
         Z4ASOr4Nb4nZyKKzhIY/IUTYrEsYufbhjIwiUTGx1mUILePaRxU96rrHkSnwwjUAzZTs
         RPoQIPRCWn2kTh57tIlOhUhYS6LGgjA0aToD2hIgNTUpqbgLfdYcfIVliR+xO2V9062k
         V8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sC4Bm0S6AdzqPJDKFbvFqnZ8jJH7VxxKHL8X8WXctzY=;
        b=VgG6Q5kE49RvqFCjyiEfuN14bVP7Ma8p5Du2YkgTrmampPbbOmgnBN6Llp2amtJ0Jt
         ngOGBZOhqpVG6/fdRqCreoQrgMmrhn24j615dbpBBempNigWMSfsuCxluJAfPfpFatBT
         OCqIhcDf/wUMZRCJQz/XT4vJUbRRFbUGkoPPPOYPxRSbmOx7mcYG/Hjdq1XCgRFhieoS
         Mqau+pfUm51AQ1bowmWS9t6FYBTVAjX55blNGYUBhJ34brQXkOYIyYWyC0amJt7TLxUm
         ppcWaPeNe9M5BNKaVyhU+jbusifoyUyxxAltEdqYXoXOqDl44iq1EYRp6mQX5kb00FK+
         78RA==
X-Gm-Message-State: APjAAAXDS+0B3/IacieCiZIpEgoupLQkvoqXW2iT/oXUu4vBmql35R9n
        1rh3G869ICOfFUeXPsnTvpY=
X-Google-Smtp-Source: APXvYqxBQfLA16cLdJkghpXZpM2fYIlOwAM8blNJzY1aoU3igmXWBnATMkuSzRW4vvs5XlcUhLJ6ig==
X-Received: by 2002:a63:243:: with SMTP id 64mr19321172pgc.214.1556986103844;
        Sat, 04 May 2019 09:08:23 -0700 (PDT)
Received: from bridge ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id j20sm8706452pfn.84.2019.05.04.09.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:08:23 -0700 (PDT)
Date:   Sun, 5 May 2019 00:08:17 +0800
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, bfields@fieldses.org, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/3] nsfs: add evict callback into struct
 proc_ns_operations
Message-ID: <20190504160817.GA15804@bridge>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1556692945-3996-2-git-send-email-wenbinzeng@tencent.com>
 <20190502030406.GT23075@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502030406.GT23075@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 04:04:06AM +0100, Al Viro wrote:
> On Wed, May 01, 2019 at 02:42:23PM +0800, Wenbin Zeng wrote:
> > The newly added evict callback shall be called by nsfs_evict(). Currently
> > only put() callback is called in nsfs_evict(), it is not able to release
> > all netns refcount, for example, a rpc client holds two netns refcounts,
> > these refcounts are supposed to be released when the rpc client is freed,
> > but the code to free rpc client is normally triggered by put() callback
> > only when netns refcount gets to 0, specifically:
> >     refcount=0 -> cleanup_net() -> ops_exit_list -> free rpc client
> > But netns refcount will never get to 0 before rpc client gets freed, to
> > break the deadlock, the code to free rpc client can be put into the newly
> > added evict callback.
> > 
> > Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>
> > ---
> >  fs/nsfs.c               | 2 ++
> >  include/linux/proc_ns.h | 1 +
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/fs/nsfs.c b/fs/nsfs.c
> > index 60702d6..5939b12 100644
> > --- a/fs/nsfs.c
> > +++ b/fs/nsfs.c
> > @@ -49,6 +49,8 @@ static void nsfs_evict(struct inode *inode)
> >  	struct ns_common *ns = inode->i_private;
> >  	clear_inode(inode);
> >  	ns->ops->put(ns);
> > +	if (ns->ops->evict)
> > +		ns->ops->evict(ns);
> 
> What's to guarantee that ns will not be freed by ->put()?
> Confused...

Hi Al, thank you very much. You are absolutely right.
->evict() should be called before ->put(), i.e.:

@@ -49,6 +49,8 @@ static void nsfs_evict(struct inode *inode)
	struct ns_common *ns = inode->i_private;
	clear_inode(inode);
+	if (ns->ops->evict)
+		ns->ops->evict(ns);
	ns->ops->put(ns);
 }

Does this look good?
