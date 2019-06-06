Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F9436E51
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfFFIRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:17:06 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:35883 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbfFFIRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 04:17:06 -0400
Received: by mail-wr1-f51.google.com with SMTP id n4so1404182wrs.3
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 01:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xBbVTGFBPyoozI6PnJzeKlugKc/WGoW+LUVu4QHH1d4=;
        b=WYMo99SVFkTvGA9Zt37cdMnR9ADrz+NkyZ2CbqrHFLx9y9H45y5QkEfbiYPeWFr2vR
         pXWQ4GexdZaM9gH7QBfxTy2AtdndSp7VdLuivf3HQm0Z7rydWHB7Vh/DhwrvzIvPc3I5
         IKuvJd3AFxGmNmSBAdUSucdTDV5caep8ctff4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xBbVTGFBPyoozI6PnJzeKlugKc/WGoW+LUVu4QHH1d4=;
        b=WDdxYdl95y4c11FmntaRd56FIesPhl0N/utrRry/T15sEBXqgg4FBAShSLnPOxjlz2
         RZfkaRo+lAzx6/LwnNvRWaYsbf+kptN8t5qcr05PXnviolSMX3bBtyzHlSQbU5p3oLMQ
         lu+k4T4XMZAVRrz5mztKB1eQ9zR9Miz9IFI0KssowmatBJawufahPknXkTBdZZ+zQw/L
         BzSJ1faiVJaWY7KM/xy+jMIs9Fsa8Rn6DRf1IEgGB8LDkQF+DqkBBpICzMYaf2Kgsmq1
         9DZQ3o3xGjG9gqSqrhK9fKmnNGGdS/dhUQhwE+FWjoOPevqo20unW1IbZZzyJqFMbIK7
         QCZQ==
X-Gm-Message-State: APjAAAUCf45zA3P0NFgAh+KnTyjqvtNKoqwz4uJ10VqQUgm+iPLzBXr8
        8QJ/FmqqThE9xoCIw5XrYMvb1A==
X-Google-Smtp-Source: APXvYqyCvJyLgsTzU5WwYciEIG85vyQHFaxQGkPZYjpIySUQ5B7lOY0gnGHyW2EgRTznsPfhZxn+tg==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr16132368wrv.61.1559809024323;
        Thu, 06 Jun 2019 01:17:04 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id p16sm1681171wrg.49.2019.06.06.01.17.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 01:17:03 -0700 (PDT)
Date:   Thu, 6 Jun 2019 10:16:57 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606081657.GA4249@andrea>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This example really does point out a weakness in the LKMM's handling of 
> data races.  Herbert's litmus test is a great starting point:
> 
> 
> C xu
> 
> {}
> 
> P0(int *a, int *b)
> {
> 	WRITE_ONCE(*a, 1);
> 	synchronize_rcu();
> 	*b = 2;
> }
> 
> P1(int *a, int *b)
> {
> 	rcu_read_lock();
> 	if (READ_ONCE(*a) == 0)
> 		*b = 1;
> 	rcu_read_unlock();
> }
> 
> exists (~b=2)
> 
> 
> Currently the LKMM says the test is allowed and there is a data race, 
> but this answer clearly is wrong since it would violate the RCU 
> guarantee.
> 
> The problem is that the LKMM currently requires all ordering/visibility
> of plain accesses to be mediated by marked accesses.  But in this case,
> the visibility is mediated by RCU.  Technically, we need to add a
> relation like
> 
> 	([M] ; po ; rcu-fence ; po ; [M])
> 
> into the definitions of ww-vis, wr-vis, and rw-xbstar.  Doing so
> changes the litmus test's result to "not allowed" and no data race.  
> However, I'm not certain that this single change is the entire fix;  
> more thought is needed.

This seems a sensible change to me: looking forward to seeing a patch,
on top of -rcu/dev, for further review and testing!

We could also add (to LKMM) the barrier() for rcu_read_{lock,unlock}()
discussed in this thread (maybe once the RCU code and the informal doc
will have settled in such direction).

It seems worth stressing the fact that _neither_ of these changes will
prevent the test below from being racy, considered the two accesses to
"a" happen concurrently / without synchronization.

Thanks,
  Andrea

C xu-2

{}

P0(int *a, int *b)
{
	*a = 1;
	synchronize_rcu();
	WRITE_ONCE(*b, 2);
}
 
P1(int *a, int *b)
{
	rcu_read_lock();
	if (*a == 0)
		WRITE_ONCE(*b, 1);
	rcu_read_unlock();
}
 
exists (~b=2)
