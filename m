Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D628168F2D
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 14:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgBVNjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 08:39:39 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33470 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgBVNji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 08:39:38 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so2839381pfn.0;
        Sat, 22 Feb 2020 05:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vpxT9jClDrKoKxPt0kmgtgiiuZoHxIxpAJPkebvXON0=;
        b=GXLKlRfcHhBTYgl1ilH4o6mibl1xTvcNCPXZFQNec8/NOTrpQtsfA1JP8KaNs3aYYg
         IKfHktkagA44VixY1m/yaksXVZI5mnnwvskjvQ1JJWZKSVnvNsI/JcinID87RR5f7yjq
         rHGb0hKXst4/I4k0njMJlneWTL1tuJdQbyMx/seEwj0Zf3U4AsBFvjnM2hGQyFL6APOV
         TtrndIYAHC20+ueeYgIK9XVKf6e1xpCSPWecjH8LXHahEI3yc98+initYn99IdzOFo27
         yid+lJqWR0oJoKtaGJcH7Tp8DfuMUG4Vdg6vkiq9v8McSlvmfVPiknC3XDMcYiyKlgA6
         ASdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vpxT9jClDrKoKxPt0kmgtgiiuZoHxIxpAJPkebvXON0=;
        b=mr+7nvDcu/+zJwSEOSpAms3QJdZJ4/bXNBfYJf5Ne5yrHhuKxFEF/U0zgz5/fv67uC
         2uAv05UOdF7hyFPUc9p1Bs+jWCtKguincnNl8ZSsJfHfU1cQ+P5DBG96AqzKndc3da7i
         9CC4EkRo7KzDGM8cUBMzsmdhLJp7YFmpzNWr+5SO76X3NGHnR+vxt0x5gqjX7zFg09r4
         vFq7wbKjB4lJ7BpigwXOARjmp75wOS19vVYuceTxFNtXtiSqTKVhYbGuaspB+wAOugBe
         XQyUfXTIs7NhrqRTp0A9LclFU/SBmNUjfaCMJKc97xWEU+aCMhnkMXlLH8CLG9RNrtmu
         AGeg==
X-Gm-Message-State: APjAAAUkLars2E33PNLm6aqvtFeiAaXMNdhJe2Qhm8OtPa1dRqpXlsHN
        FdtjVXS92p6ayZPgYhPT3Q==
X-Google-Smtp-Source: APXvYqwEKQ41EVLj6CR4+LTHf/M95sWALC35qShHEDBl/TpwOUcje2MB0Kb3HNksVa1H25ZDOgRBJg==
X-Received: by 2002:a62:f243:: with SMTP id y3mr43858640pfl.146.1582378776499;
        Sat, 22 Feb 2020 05:39:36 -0800 (PST)
Received: from madhuparna-HP-Notebook ([42.109.145.199])
        by smtp.gmail.com with ESMTPSA id b12sm6517235pfr.26.2020.02.22.05.39.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Feb 2020 05:39:35 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sat, 22 Feb 2020 19:09:28 +0530
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     madhuparnabhowmik10@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: mac80211: rx.c: Use built-in RCU list checking
Message-ID: <20200222133928.GA10397@madhuparna-HP-Notebook>
References: <20200222101831.8001-1-madhuparnabhowmik10@gmail.com>
 <f1913847671d0b7e19aaa9bef1e1eb89febfa942.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1913847671d0b7e19aaa9bef1e1eb89febfa942.camel@sipsolutions.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 22, 2020 at 01:53:25PM +0100, Johannes Berg wrote:
> On Sat, 2020-02-22 at 15:48 +0530, madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > list_for_each_entry_rcu() has built-in RCU and lock checking.
> > 
> > Pass cond argument to list_for_each_entry_rcu() to silence
> > false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> > by default.
> 
> Umm. What warning?
>
If list_for_each_entry_rcu() is called from non rcu protection
i.e without holding rcu_read_lock, but under the protection of
a different lock then we can pass that as the condition for lockdep checking
because otherwise lockdep will complain if list_for_each_entry_rcu()
is used without rcu protection. So, if we do not pass this argument
(cond) it may lead to false lockdep warnings.

> > +++ b/net/mac80211/rx.c
> > @@ -3547,7 +3547,8 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
> >  	skb->pkt_type = PACKET_OTHERHOST;
> >  	skb->protocol = htons(ETH_P_802_2);
> >  
> > -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +	list_for_each_entry_rcu(sdata, &local->interfaces, list,
> > +				lockdep_is_held(&rx->local->rx_path_lock)) {
> >  		if (!ieee80211_sdata_running(sdata))
> >  			continue;
> 
> This is not related at all.

I analysed the following traces:
ieee80211_rx_handlers() -> ieee80211_rx_handlers_result() -> ieee80211_rx_cooked_monitor()

here ieee80211_rx_handlers() is holding the rx->local->rx_path_lock and
therefore I used this for the cond argument.

 If this is not right, can you help me in figuring out that which other
 lock is held?

and 
__ieee80211_rx_handle_packet() -> ieee80211_prepare_and_rx_handle() -> ieee80211_invoke_rx_handlers() -> 
ieee80211_rx_handlers_result() -> ieee80211_rx_cooked_monitor()

Here __ieee80211_rx_handle_packet() should be called under
rcu_read_lock protection.
So this trace seems okay and no need to pass any cond.

I may have missed something, please correct me in that case.

> > @@ -4114,7 +4115,8 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
> >  
> >  	lockdep_assert_held(&local->sta_mtx);
> >  
> > -	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> > +	list_for_each_entry_rcu(sta, &local->sta_list, list,
> > +				lockdep_is_held(&local->sta_mtx)) {
> 
> And this isn't even a real RCU iteration, since we _must_ hold the mutex
> here.
>
Yeah exactly, dropping _rcu (use list_for_each_entry()) would be a good option in this case.
Let me know if that is alright and I will send a new patch with all the
changes required.

Thank you,
Madhuparna

> johannes
> 
