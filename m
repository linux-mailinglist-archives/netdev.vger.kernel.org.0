Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AEB1DCEAC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgEUNyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 09:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEUNyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 09:54:47 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73B3C061A0E;
        Thu, 21 May 2020 06:54:47 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z18so5525526qto.2;
        Thu, 21 May 2020 06:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4AWH1AUEd7Au/qvsJAY3f3OpE4viRwDzW+yF47F593Y=;
        b=MadH9FDDGvoxe4fUbjh7p4mwB3ng32aoog6jBUA4hFSZAKoaWEKqesMpS8Mdgd0nR2
         mDTgZteXtTpdXw8EluT3/45VBYy3VnVHtEsyutIuba5pFOT1ONq06EfpFZxfbAM+uqBt
         ivy6cbOcjc9wKcedTtgupAWJ4hGHRK6MDbC5Mf63igyieBqM3YqmiNMYpXIlyth7uy+c
         dK6YjZCUy66fZodoZfuNm2c+b7Jy5HP8GX2o3qqoiVU9U/KOnqcAZfrpq9vj9G7eqhyl
         9Xb6Y7o7onhxN0YVZPLVzb6piACyAq9ppSHsg5oJrX7hlGZSAgGYua7uGRRSN/cVwcZH
         Oc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4AWH1AUEd7Au/qvsJAY3f3OpE4viRwDzW+yF47F593Y=;
        b=mXMOWKlrZvLCbcgKEzph9yyz/zTs5isoK66wATfJh4htpPeKHv9j922MHlgkRCSFeb
         jsFsuGxaZOyUke0tX674r9G4tD3ccKyuUo/pw9mvzHbfbTD6fjHgeIPtLD95vmYwS/wx
         SkJfTD58bRl5DdguxYlLT0uIixgFP20ugPlC+tjU7amlB4c3PXDiQuwl35lwovMjYuiy
         LAmdqKcnvHhsWS3Et2O74KYp7kbfy3TDe44xsolC5oW4rF67BioH+iuD8Rgnbsn02tlO
         llqE5r+rulEaOcRpgc0TWksYyPKJ21CRsb1qXBwshVRpmVukG9YmLrAKq4VakQFBmR5Y
         YkUA==
X-Gm-Message-State: AOAM533saCmpPiGdq7RPXkKb8Lgp9xNnmbAGiGgFtSSlbCNzvyEcL5g/
        UoPZbSH1K43bxPlfb8g8DyI=
X-Google-Smtp-Source: ABdhPJwr1XLsFhpL67QfydZyYFncpQXNqgVtdQK2lUSy7K4tdF1oTZiVeuf1ITYdnePhr53SYWBElg==
X-Received: by 2002:ac8:4c8b:: with SMTP id j11mr10385232qtv.58.1590069286825;
        Thu, 21 May 2020 06:54:46 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id n85sm1682417qkn.31.2020.05.21.06.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 06:54:46 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7AEDAC0BEB; Thu, 21 May 2020 10:54:43 -0300 (-03)
Date:   Thu, 21 May 2020 10:54:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 32/33] net: add a new bind_add method
Message-ID: <20200521135443.GY2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-33-hch@lst.de>
 <20200520230025.GT2491@localhost.localdomain>
 <20200521084224.GA7859@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521084224.GA7859@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 10:42:24AM +0200, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 08:00:25PM -0300, Marcelo Ricardo Leitner wrote:
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	lock_sock(sk);
> > > +	err = sctp_do_bind(sk, (union sctp_addr *)addr, af->sockaddr_len);
> > > +	if (!err)
> > > +		err = sctp_send_asconf_add_ip(sk, addr, 1);
> > 
> > Some problems here.
> > - addr may contain a list of addresses
> > - the addresses, then, are not being validated
> > - sctp_do_bind may fail, on which it requires some undoing
> >   (like sctp_bindx_add does)
> > - code duplication with sctp_setsockopt_bindx.
> 
> sctp_do_bind and thus this function only support a single address, as
> that is the only thing that the DLM code requires.  I could move the

I see.

> user copy out of sctp_setsockopt_bindx and reuse that, but it is a
> rather rcane API.

Yes. With David's patch, which is doing that, it can be as simple as:

static int sctp_bind_add(struct sock *sk, struct sockaddr *addr,
               int addrlen)
{
	int ret;
	lock_sock(sk);
	ret = sctp_setsockopt_bindx(sk, addr, addrlen, SCTP_BINDX_ADD_ADDR);
	release_sock(sk);
	return ret;
}

and then dlm would be using code that we can test through sctp-only tests as
well.

> 
> > 
> > This patch will conflict with David's one,
> > [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
> 
> Do you have a link?  A quick google search just finds your mail that
> I'm replying to.

https://lore.kernel.org/netdev/fd94b5e41a7c4edc8f743c56a04ed2c9%40AcuMS.aculab.com/T/

> 
> > (I'll finish reviewing it in the sequence)
> > 
> > AFAICT, this patch could reuse/build on his work in there. The goal is
> > pretty much the same and would avoid the issues above.
> > 
> > This patch could, then, point the new bind_add proto op to the updated
> > sctp_setsockopt_bindx almost directly.
> > 
> > Question then is: dlm never removes an addr from the bind list. Do we
> > want to add ops for both? Or one that handles both operations?
> > Anyhow, having the add operation but not the del seems very weird to
> > me.
> 
> We generally only add operations for things that we actually use.
> bind_del is another logical op, but we can trivially add that when we
> need it.

Right, okay.
