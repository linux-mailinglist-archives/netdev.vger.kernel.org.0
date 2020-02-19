Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D9164499
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgBSMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgBSMrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 07:47:13 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454C024654;
        Wed, 19 Feb 2020 12:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582116433;
        bh=78L7q3X7/Zxk9esBo61a/shxQzMYU6nTCnPnkYfB+2E=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=hdwT7jwDCL5ZqQeaRjVdSYu3jP9wC7ywHEszxyECjNhODNCOWO/jdTrdN/TGO8Kw/
         iNKq3SBrMzxKe4QcElRQHoD8SJkqLj6UKXd0KzIZM+iwcWfLUOy2jOAHx9O46Ma8Ny
         OcmmNN29hL1xJorshLjE+GHcL7gPtAHmxirgx1EY=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1E9FE35229ED; Wed, 19 Feb 2020 04:47:13 -0800 (PST)
Date:   Wed, 19 Feb 2020 04:47:13 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: Re: [PATCH] cfg80211: Pass lockdep expression to RCU lists
Message-ID: <20200219124713.GU2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200219091102.10709-1-frextrite@gmail.com>
 <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 10:13:36AM +0100, Johannes Berg wrote:
> On Wed, 2020-02-19 at 14:41 +0530, Amol Grover wrote:
> >  
> > -	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
> > -
> > -	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
> > +	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
> > +				lockdep_rtnl_is_held()) {
> 
> Huh, I didn't even know you _could_ do that :)

It is a fairly recent addition, courtesy of Joel Fernandes.  ;-)

							Thanx, Paul
