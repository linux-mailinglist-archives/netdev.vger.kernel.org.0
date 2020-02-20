Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB671655D9
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 04:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgBTDrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 22:47:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43754 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgBTDrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 22:47:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id p11so980491plq.10;
        Wed, 19 Feb 2020 19:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4aa14Qa/BJ5gvTUkltBz2vTcHHykju1Xj4YvXyFnul4=;
        b=CltrD+f29h4W+dpxHPNv1JveX0Lnoy95RgKNGY+7Zfo42vMKUAl3DpBhUFtpbKAmo+
         QfpevgV35ksKPP2cMOjxPBJDtzA+6EXmzzPFR2GcqcmVNmp5e166xRJzoymejEvelyR/
         fPPNNfBs1MH6q+PVxSV6pB5HX8rk1Bv5c8QgpYrSqtgPqO8x+oROOZDOazO8zj+S78Wh
         DAtjtQ5KUMhzVWSa2lEpHychqhfRQOPT2dFb4IiGc1r+w1dqS32b9rrb4lOBJWHUouDJ
         CYRUTYxUYmv2miBH7fb+ahq0k67y4Y5LlQxzuOSdBrXbmZzuvcGoIo8eSS/u2MaI6Bz6
         bI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4aa14Qa/BJ5gvTUkltBz2vTcHHykju1Xj4YvXyFnul4=;
        b=iEw5A1bWoHTgKzL/nmw5CCM81D8Sy8GR9L2PFxmdFMWOcb04HHCuK4pTKan+3+P2UM
         tQp25DDHwjdnzJyeQ0OwQy+bnDntej2XVHfjJj1lsabdQhpSptX2n8ttntQjRTCZX1Ii
         vQETOhEAFJOFS63E/n6RsusKGeZ1EELfbGvAlb9oOEXEhCC10qph1r2RO1Gjf69/M6VW
         to6dTz9VSXSaZXhuTNasVbNrsBvPkVqMQvXJLYBTonQO4+eyJvncX/52+ITI3Zo9fNY2
         n43cZe1myhJfTsEQpxjRQ8wKfbh5JEVadCA98BwmnZf7+bn6s8qscdnqwClNNGfRk63D
         9IZw==
X-Gm-Message-State: APjAAAUz3hzJMlDhluAcU9ll1L+RgaEbXVGMapyi09QcUhnaqigaD4DN
        3+4Aw/hmquWvQMg/S95Li8M=
X-Google-Smtp-Source: APXvYqx16VVAaiK+h04cWWoZZpTCTSCoAlLhOl9vCeFcmuJ7Z2LuULb7kQPW+C4OELuYq1yxtGtpRQ==
X-Received: by 2002:a17:90a:868b:: with SMTP id p11mr1219499pjn.60.1582170429686;
        Wed, 19 Feb 2020 19:47:09 -0800 (PST)
Received: from workstation-portable ([146.196.37.60])
        by smtp.gmail.com with ESMTPSA id v25sm1099083pfe.147.2020.02.19.19.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 19:47:09 -0800 (PST)
Date:   Thu, 20 Feb 2020 09:17:02 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: Pass lockdep expression to RCU lists
Message-ID: <20200220034702.GA2349@workstation-portable>
References: <20200219100545.27397-1-frextrite@gmail.com>
 <b628d0ad-e066-46f5-5746-74dfba1816a8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b628d0ad-e066-46f5-5746-74dfba1816a8@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 11:35:21AM -0800, Eric Dumazet wrote:
> 
> 
> On 2/19/20 2:05 AM, Amol Grover wrote:
> > tcp_cong_list is traversed using list_for_each_entry_rcu
> > outside an RCU read-side critical section but under the protection
> > of tcp_cong_list_lock.
> >
> 
> This is not true.
> 
> There are cases where RCU read lock is held,
> and others where the tcp_cong_list_lock is held.
> 

That's true but this patch specifically fixes those occurences of
list_for_each_entry_rcu() that are traversed under tcp_cong_list_lock.
Moreover, an implicit check is done for being inside RCU read-side
critical section along with testing for this newly added lockdep
expression.

> I believe you need to be more precise in the changelog.
> 
> If there was a bug, net tree would be the target for this patch,
> with a required Fixes: tag.
> 
> Otherwise, if net-next tree is the intended target, you have to signal
> it, as instructed in Documentation/networking/netdev-FAQ.rst
> 

I don't think this fixes a "bug". However, this may fix potential bugs
that may creep in. Should I send it against net-next tree?

Thanks
Amol

> Thanks.
> 
>  
> > Hence, add corresponding lockdep expression to silence false-positive
> > warnings, and harden RCU lists.
> > 
> > Signed-off-by: Amol Grover <frextrite@gmail.com>
> > ---
> >  net/ipv4/tcp_cong.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> > index 3737ec096650..8d4446ed309e 100644
> > --- a/net/ipv4/tcp_cong.c
> > +++ b/net/ipv4/tcp_cong.c
> > @@ -25,7 +25,8 @@ static struct tcp_congestion_ops *tcp_ca_find(const char *name)
> >  {
> >  	struct tcp_congestion_ops *e;
> >  
> > -	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
> > +	list_for_each_entry_rcu(e, &tcp_cong_list, list,
> > +				lockdep_is_held(&tcp_cong_list_lock)) {
> >  		if (strcmp(e->name, name) == 0)
> >  			return e;
> >  	}
> > @@ -55,7 +56,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
> >  {
> >  	struct tcp_congestion_ops *e;
> >  
> > -	list_for_each_entry_rcu(e, &tcp_cong_list, list) {
> > +	list_for_each_entry_rcu(e, &tcp_cong_list, list,
> > +				lockdep_is_held(&tcp_cong_list_lock)) {
> >  		if (e->key == key)
> >  			return e;
> >  	}
> > @@ -317,7 +319,8 @@ int tcp_set_allowed_congestion_control(char *val)
> >  	}
> >  
> >  	/* pass 2 clear old values */
> > -	list_for_each_entry_rcu(ca, &tcp_cong_list, list)
> > +	list_for_each_entry_rcu(ca, &tcp_cong_list, list,
> > +				lockdep_is_held(&tcp_cong_list_lock))
> >  		ca->flags &= ~TCP_CONG_NON_RESTRICTED;
> >  
> >  	/* pass 3 mark as allowed */
> > 
