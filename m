Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E01338EFD
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfFGP0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:26:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40726 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfFGP0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:26:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so962164pla.7;
        Fri, 07 Jun 2019 08:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVGisPA/tmje+GMmiDK8OnPmVMVeg+5zpouDsmuezH0=;
        b=Ng9VAdE1hknVxgMRmGjp2lDv/vnEMUT819mfzZMuI8Vo6TE0MQGzCyXQIXbFSQSR9d
         mKrNlvkbRFOoWrF67ukGOUJy4jylKGdkI6hIa+PapCfYavrA91o8rolb+/2gcZ89PHi4
         TCKXDiJaTwa1LK8hu36NqCpMeFdtpAHiDM4lDcBoesgsWJUQKalZSIuLylNn8fC6ZpPa
         jrw8KWHCbIrHI4lj+eQDHSVFYpOVYAS1GI7rAz/OImckqC1LWeXKUjZlS5GZhLJXoIQy
         Q7PudF+uPC57APLwcHvHZjgTe0n5U3Fn6YNewGQKV/dgVXu9sEBuf67YsfvDIaQIy+MF
         eFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVGisPA/tmje+GMmiDK8OnPmVMVeg+5zpouDsmuezH0=;
        b=e3CBz1lCutw2gZP9krwcp9x8ZSoI7pD4t8A+sFMv1QK8iRNJH9kDcXmYV0z1IGK+ER
         1w7BalgPNMKxhl/R/4S9yQDA1LPW/KvsNRuNCoJBwTrmV+1g8rT1a7d/gpQq2Hxx5CfW
         9N2hep08BUmdJ4nLLZ90l249s9YOBW2APIe4r67x72KkrOfKaSJkrm8aPq+9+e2EebU9
         eZLg2v/k+8MM5Zp7JlB6DGwckvfIhVnOTQQ+vOHmHr7Yw1BzEambZ2tO0z2uAcrEzvtl
         F1ciCatdsfK8+CJyoiSyBAPKYKj+qpmyNCTG8uRZq3Jk4C/J/DKc+3dEHI3GGuk9KUWZ
         jV1w==
X-Gm-Message-State: APjAAAWi1FHCt3IfbltsoEJ7c0eehGtAG0dJGabnOx8jK9wGHa37Zzz8
        wg5swwcovmIgE7ttHj5apqyX1Brt
X-Google-Smtp-Source: APXvYqyb+ly9dDrO0mjWbQvwYi45rypLj3ZwkYwj101gOR+IwU70sx8VUSNY5cgcVG4+h34ABuZAJw==
X-Received: by 2002:a17:902:294a:: with SMTP id g68mr57385663plb.169.1559921174428;
        Fri, 07 Jun 2019 08:26:14 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j7sm2461679pfa.184.2019.06.07.08.26.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 08:26:13 -0700 (PDT)
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
Date:   Fri, 7 Jun 2019 08:26:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/19 7:09 AM, Herbert Xu wrote:
> On Tue, Jun 04, 2019 at 09:04:55AM -0700, Linus Torvalds wrote:
>>
>> In fact, the alpha port was always subtly buggy exactly because of the
>> "byte write turns into a read-and-masked-write", even if I don't think
>> anybody ever noticed (we did fix cases where people _did_ notice,
>> though, and we might still have some cases where we use 'int' for
>> booleans because of alpha issues.).
> 
> This is in fact a real bug in the code in question that no amount
> of READ_ONCE/WRITE_ONCE would have caught.  The field fqdir->dead is
> declared as boolean so writing to it is not atomic (on old Alphas).
> 
> I don't think it currently matters because padding would ensure
> that it is in fact 64 bits long.  However, should someone add another
> char/bool/bitfield in this struct in future it could become an issue.
> 
> So let's fix it.


There is common knowledge among us programmers that bit fields
(or bool) sharing a common 'word' need to be protected
with a common lock.

Converting all bit fields to plain int/long would be quite a waste of memory.

In this case, fqdir_exit() is called right before the whole
struct fqdir is dismantled, and the only cpu that could possibly
change the thing is ourself, and we are going to start an RCU grace period.

Note that first cache line in 'struct fqdir' is read-only.
Only ->dead field is flipped to one at exit time.

Your patch would send a strong signal to programmers to not even try using
bit fields.

Do we really want that ?

> 
> ---8<--
> The field fqdir->dead is meant to be written (and read) atomically.
> As old Alpha CPUs can't write a single byte atomically, we need at
> least an int for it to work.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index e91b79ad4e4a..8c458fba74ad 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -14,7 +14,9 @@ struct fqdir {
>  	int			max_dist;
>  	struct inet_frags	*f;
>  	struct net		*net;
> -	bool			dead;
> +
> +	/* We can't use boolean because this needs atomic writes. */
> +	int			dead;
>  
>  	struct rhashtable       rhashtable ____cacheline_aligned_in_smp;
>  
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 35e9784fab4e..05aa7c145817 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -193,7 +193,7 @@ void fqdir_exit(struct fqdir *fqdir)
>  {
>  	fqdir->high_thresh = 0; /* prevent creation of new frags */
>  
> -	fqdir->dead = true;
> +	fqdir->dead = 1;
>  
>  	/* call_rcu is supposed to provide memory barrier semantics,
>  	 * separating the setting of fqdir->dead with the destruction
> 
