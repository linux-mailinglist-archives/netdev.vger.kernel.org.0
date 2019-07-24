Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44BF73748
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfGXTFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:05:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39987 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfGXTFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:05:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so46568674qtn.7;
        Wed, 24 Jul 2019 12:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U1BY5u1Dhbf0nVijwCOksJyWDz8otzZNHxVFWbabBgc=;
        b=U/RH3OA/sTAlxlAsSh2j8mw+RjPttJjCf7Sur21d7XJwnq7HhyZEcKoFZVn2wkEiMN
         DmHfIs8Ur8wf4rzpgeaSbBDNdVfuKBQX0G2rDhkRn6IgZbyji68j9djwJd5b/S8pwMfB
         cV2dNthjateQVCWQl3FCnlSoVhLQMmgO1yTtO+zlHrvCTIGxezmdulpshnExjOsEG35Q
         foTsjS35SnpqHo+lomvFPd3hTL434YMjF/DZCLJbb19vHMnYrmZJHmEszk0+sCHb1vKu
         EXY22NBPJuRPL9bgf7K2KTXBfaNKFvpPsDqgIdkYXiIB/SWRVhtA3+dHPU0p9cSK6XmF
         yL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U1BY5u1Dhbf0nVijwCOksJyWDz8otzZNHxVFWbabBgc=;
        b=ckW5jTPSV5J7Xdyat7Hm9oCS/qGlE7yNX3ZWmV/25n2T2bXSHBWQI6/IVFgy+mM8dj
         RCGkbrobbFsT01h3e5n5AnIf0+pygndyQPYcwTUDhhYOz4w3ixu/i7UvTgKUcSXlJvFA
         pn1QlVjjxFeLAfJunf6himiVUD8SqRI6tosm2T2ob5yRFaQLQbsPngbP6lYAqWTlY1vv
         r4Kt4mpiWt9jdvs9HGn200WeCFTS0cv0ZtfIS+m38Z81DwjmpweS/gv+kezWhif2vG6O
         jH1IWTz0u6+TDy2Xi9WTYc0pqvp43lxOOY+eMChCIlhSwJBAc/W6EkYRQX9HKXd13Rrj
         qS+w==
X-Gm-Message-State: APjAAAVyk9zwBppwBMMbpr1TKZXua9/EG1sTuk7UfCt2XZRzVxazC2kI
        RGIQC1HA14YCfb7J6Z42fLonbo4hloM=
X-Google-Smtp-Source: APXvYqzzvlHN45l8HuOcRUXa7bWr+B/CA1c8e+GnKCcpdaWE4a4llL30kn3vO8Suo2CnfoxknHQb6Q==
X-Received: by 2002:a0c:fa8b:: with SMTP id o11mr60455734qvn.6.1563995147069;
        Wed, 24 Jul 2019 12:05:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:2135:7c3d:d61c:7f11:969d])
        by smtp.gmail.com with ESMTPSA id b23sm28947286qte.19.2019.07.24.12.05.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 12:05:46 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C54C9C1BD5; Wed, 24 Jul 2019 16:05:43 -0300 (-03)
Date:   Wed, 24 Jul 2019 16:05:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
Message-ID: <20190724190543.GH6204@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
 <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
 <20190724112235.GA7212@hmswarspite.think-freely.org>
 <20190724123650.GD6204@localhost.localdomain>
 <20190724124907.GA8640@localhost.localdomain>
 <20190724184456.GC7212@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724184456.GC7212@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 02:44:56PM -0400, Neil Horman wrote:
> On Wed, Jul 24, 2019 at 09:49:07AM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, Jul 24, 2019 at 09:36:50AM -0300, Marcelo Ricardo Leitner wrote:
> > > On Wed, Jul 24, 2019 at 07:22:35AM -0400, Neil Horman wrote:
> > > > On Wed, Jul 24, 2019 at 03:21:12PM +0800, Xin Long wrote:
> > > > > On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > >
> > > > > > On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > > > > > > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > > > > > > sctp_inet_connect(), the latter has done addr_size check with size
> > > > > > > of sa_family_t.
> > > > > > >
> > > > > > > In the next patch to clean up __sctp_connect(), we will remove
> > > > > > > addr_size check with size of sa_family_t from __sctp_connect()
> > > > > > > for the 1st address.
> > > > > > >
> > > > > > > So before doing that, __sctp_setsockopt_connectx() should do
> > > > > > > this check first, as sctp_inet_connect() does.
> > > > > > >
> > > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > > ---
> > > > > > >  net/sctp/socket.c | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > > index aa80cda..5f92e4a 100644
> > > > > > > --- a/net/sctp/socket.c
> > > > > > > +++ b/net/sctp/socket.c
> > > > > > > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> > > > > > >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> > > > > > >                __func__, sk, addrs, addrs_size);
> > > > > > >
> > > > > > > -     if (unlikely(addrs_size <= 0))
> > > > > > > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> > > > > > I don't think this is what you want to check for here.  sa_family_t is
> > > > > > an unsigned short, and addrs_size is the number of bytes in the addrs
> > > > > > array.  The addrs array should be at least the size of one struct
> > > > > > sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> > > > > > sizeof(struct sockaddr)
> > > > > sizeof(struct sockaddr) is not the right value to check either.
> > > > > 
> > > > > The proper check will be done later in __sctp_connect():
> > > > > 
> > > > >         af = sctp_get_af_specific(daddr->sa.sa_family);
> > > > >         if (!af || af->sockaddr_len > addrs_size)
> > > > >                 return -EINVAL;
> > > > > 
> > > > > So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
> > > > > just to make sure daddr->sa.sa_family is accessible. the same
> > > > > check is also done in sctp_inet_connect().
> > > > > 
> > > > That doesn't make much sense, if the proper check is done in __sctp_connect with
> > > > the size of the families sockaddr_len, then we don't need this check at all, we
> > > > can just let memdup_user take the fault on copy_to_user and return -EFAULT.  If
> > > > we get that from memdup_user, we know its not accessible, and can bail out.
> > > > 
> > > > About the only thing we need to check for here is that addr_len isn't some
> > > > absurdly high value (i.e. a negative value), so that we avoid trying to kmalloc
> > > > upwards of 2G in memdup_user.  Your change does that just fine, but its no
> > > > better or worse than checking for <=0
> > > 
> > > One can argue that such check against absurdly high values is random
> > > and not effective, as 2G can be somewhat reasonable on 8GB systems but
> > > certainly isn't on 512MB ones. On that, kmemdup_user() will also fail
> > > gracefully as it uses GFP_USER and __GFP_NOWARN.
> > > 
> > > The original check is more for protecting for sane usage of the
> > > variable, which is an int, and a negative value is questionable. We
> > > could cast, yes, but.. was that really the intent of the application?
> > > Probably not.
> > 
> > Though that said, I'm okay with the new check here: a quick sanity
> > check that can avoid expensive calls to kmalloc(), while more refined
> > check is done later on.
> > 
> I agree a sanity check makes sense, just to avoid allocating a huge value
> (even 2G is absurd on many systems), however, I'm not super comfortable with
> checking for the value being less than 16 (sizeof(sa_family_t)).  The zero check

16 bits you mean then, per
include/uapi/linux/socket.h
typedef unsigned short __kernel_sa_family_t;
include/linux/socket.h
typedef __kernel_sa_family_t    sa_family_t;

> is fairly obvious given the signed nature of the lengh field, this check makes
> me wonder what exactly we are checking for.

A minimum viable buffer without doing more extensive tests. Beyond
sa_family, we need to parse sa_family and then that's left for later.
Perhaps a comment helps, something like
	/* Check if we have at least the family type in there */
?

  Marcelo

> 
> Neil
> 
> > > 
> > > > 
> > > > Neil
> > > > 
> > > > > >
> > > > > > Neil
> > > > > >
> > > > > > >               return -EINVAL;
> > > > > > >
> > > > > > >       kaddrs = memdup_user(addrs, addrs_size);
> > > > > > > --
> > > > > > > 2.1.0
> > > > > > >
> > > > > > >
> > > > > 
> > 
