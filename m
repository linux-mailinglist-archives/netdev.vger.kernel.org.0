Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64A594F35
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfHSUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:41:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35284 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfHSUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:41:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so2639348qke.2
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=i1QyQWhoM3Qmw7JUjKggfzWHZbx+tCHV+wohd71bQKw=;
        b=ed8hbIrBmZGYlVaI0jCLF5xizyk8mVTXvUr/dcJJ0MgwVEnnYDHh8fVF4Vz+BH0rd5
         PSUEe2Jm+JGNNpfu33JUHSFgYQbdGhtYAdRvpR72wp48yTkO8ozWmZv9VWJLa/bfW0Mf
         UAPWEp/4B8Z3EDKrim8YC16mKVcoMAkyn6iahS/uPmwwzCxZFFQ2rMVwZHK3soXqtwWu
         MNrYSaJQELjyvjVn8nDAdvRPz4SzVtjB4Z25zjZZ6gkrNlpU5evYYqRZQ/ZYcxDaWRdG
         P/PTci3g2k+QgPWD56dcfclKNHyit/AGDkUn+ReyiasRaIhIXvg56T93NwMJ5uss+er1
         1dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=i1QyQWhoM3Qmw7JUjKggfzWHZbx+tCHV+wohd71bQKw=;
        b=A5kTxrvuKmzpA1kywg9ap5pLkqXDL4QGgJdaxbfzNTnWMJS6pTpVUaSO2O0VWFPXNz
         9bguQv/iz+W3G9Y8mpbz4HWhvAe/xePlztCV5jIsYf8OrNp9877Msemn7I+2mx5/vmKq
         HU8FrqXuxgYjvGz4zNttPydH5nITYrRlxVfQAL1e98BFVO0HbRcrwBS8BQfbjbe3d3Ph
         FABQfDQePMxPV2V05Yeu0sa7pAxLYtS4dlWfCNIYd3Hc3WdVvxT+wW3szz6zUtpHkIZX
         GtQE3CUV8dZ1oogVi8Yo2YZD5BNarne0YMyPCZ/sbtGqPv/QD1KuF1EJK239XtDaRUO+
         7/OQ==
X-Gm-Message-State: APjAAAWnywjPdfyHKW/REkoIvzlC27qSlyWeoZbWfnGD7+dLPRNKSg72
        g5rzLTyCOU4BQ3RkEE6F9IaWXw==
X-Google-Smtp-Source: APXvYqytGQvHU9QifypFbHdFtn+YWLefEL14xyXLliESSSkx3KqdAa1hbsXb0+zV57UYHKtUPxdq9A==
X-Received: by 2002:a37:4791:: with SMTP id u139mr21918654qka.386.1566247266360;
        Mon, 19 Aug 2019 13:41:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c13sm7198142qtn.77.2019.08.19.13.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:41:06 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:40:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] tcp: ulp: add functions to dump
 ulp-specific information
Message-ID: <20190819134058.575c243c@cakuba.netronome.com>
In-Reply-To: <b765aa08456ef258615a46e7ff106703a240ddb5.camel@redhat.com>
References: <cover.1565882584.git.dcaratti@redhat.com>
        <f9b5663d28547b0d1c187d874c7b5e5ece8fe8fa.1565882584.git.dcaratti@redhat.com>
        <228db5cc-9b10-521f-9031-e0f86f5ded3e@gmail.com>
        <20190815143810.3a190c81@cakuba.netronome.com>
        <b765aa08456ef258615a46e7ff106703a240ddb5.camel@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 15:32:09 +0200, Davide Caratti wrote:
> On Thu, 2019-08-15 at 14:38 -0700, Jakub Kicinski wrote:
> > On Thu, 15 Aug 2019 20:46:01 +0200, Eric Dumazet wrote:  
> > > On 8/15/19 6:00 PM, Davide Caratti wrote:
> > > > +	if (net_admin) {
> > > > +		const struct tcp_ulp_ops *ulp_ops;
> > > > +
> > > > +		rcu_read_lock();
> > > > +		ulp_ops = icsk->icsk_ulp_ops;
> > > > +		if (ulp_ops)
> > > > +			err = tcp_diag_put_ulp(skb, sk, ulp_ops);
> > > > +		rcu_read_unlock();
> > > > +		if (err)
> > > > +			return err;
> > > > +	}
> > > >  	return 0;    
> > > 
> > > Why is rcu_read_lock() and rcu_read_unlock() used at all ?
> > > 
> > > icsk->icsk_ulp_ops does not seem to be rcu protected ?
> > > 
> > > If this was, then an rcu_dereference() would be appropriate.  
> > 
> > Indeed it's ulp_data not ulp_ops that are protected.   
> 
> the goal is to protect execution of 'ss -tni' against concurrent removal
> of tls.ko module, similarly to what was done in inet_sk_diag_fill() when
> INET_DIAG_CONG is requested [1]. But after reading more carefully, the
> assignment of ulp_ops needs to be:
> 
> 	ulp_ops = READ_ONCE(icsk->icsk_ulp_ops);
> 
> which I lost in internal reviews, with some additional explanatory
> comment. Ok if I correct the above hunk with READ_ONCE() and add a
> comment?

Seems like a forth while future-proofing. Currently the ULP can't
change, and is only released when socket is destroyed, so we should 
be safe (unlike CC which can be changed at any moment). 

We should mark the pointer as RCU tho, I find it hard to wrap my head
around these half-way RCU pointers with just READ_ONCE() on them :S

> > Davide, perhaps we could push the RCU lock into tls_get_info(), after all?  
> 
> It depends on whether concurrent dump / module removal is an issue for TCP
> ULPs, like it was for congestion control schemes [1]. Any advice?

If we're willing to mark icsk->icsk_ulp_ops as RCU I think it's fine.
But I'm not 100% sure its worth the churn :S

> > And tls_context has to use rcu_deference there, as Eric points out, 
> > plus we should probably NULL-check it.  
> 
> yes, it makes sense, for patch 3/3, in the assignment of 'ctx'. Instead of
> calling tls_get_ctx() in tls_get_info() I will do
> 
> 	ctx = rcu_dereference(inet_csk(sk)->icsk_ulp_data);
> 
> and let it return 0 in case of NULL ctx (as it doesn't look like a faulty
> situation). Ok? 

SGTM!
