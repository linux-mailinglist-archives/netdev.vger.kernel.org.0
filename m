Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D32259B1
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGTILB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTILA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:11:00 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FECAC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:11:00 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a15so1904513wrh.10
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WR57WnJyV0K0wq4/9PfaesBjzOPTqBTcVQbQmQ7WcGI=;
        b=RDzTM6jOvU+TqBAbMGsMaKtIMwIy1H+oq6k6M0YsTibseerOj/UJ38nIc03Tclnbzr
         LrF5WOKGSOG03cepYTlruY8tTWm1JO07rSAqPfBmXgI2gmDtptK+HTyiQCuamN2pn9JN
         Ba2yZu1bkhowMtITFtezFn3TZZypfFVmFSkXTA9cZrGHAJYGmO5TP6Ly5ngPzCWCtDPk
         SZZUJ2QoAZhUkwXAqJOrDJ/q40B2eJVGotFG9LzLo1ST3BFKfRoOBozlA7FQMSpymbyG
         D2JzPf8ydvhmX1WJ394IOXOuSMfGXUlQCCjWenD6R/dyCBOp2HHjm+Jlw/lgwlXmc45h
         phMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WR57WnJyV0K0wq4/9PfaesBjzOPTqBTcVQbQmQ7WcGI=;
        b=R1/qYLcLkX9XVKQBHvx05erfkPOzELEfntIV5c9xJhl9UvKCGrDRW6OMLNAiliXfQr
         FtyWK5DNc1+37BPLbCH2BsHobeJkkYeQkui7JImSmNHojkKHV6mAW+EDiEc8EKOb7x3G
         ysJFrzT/zLKWbwj6VqDl5VJKyIygDqlCbzkDY3UwPcMFmPj/wK1qo5Z+NVuHDajQcjgH
         2sTMmNmK/AgV8+9OU5gwaAm3gyTub9TlalbjD/I63RlRXlJ8KANQGFK2kpnm99/G0RU5
         yUIJ3MWo/f4VpKDmUPHh3Q4TWLOjYwCHLMd2eGN2ijRywn0NW2YSWKeOKf+B9jR8yk4p
         3erg==
X-Gm-Message-State: AOAM531dbb3rCHz1VBRiC/w+++c/Xrv2JLfy1yPMr3TkxKZz9KPX5pkr
        IR+0UNUd9hSqPIlZA5qufaiMdA==
X-Google-Smtp-Source: ABdhPJzWkg4JH8KUmy6xpWzc0saLikidTIeJ22nxDGCIhl5Vr5vGhpQOzqDHlPMu1OW+XhNucfAMJA==
X-Received: by 2002:adf:80c2:: with SMTP id 60mr19246396wrl.388.1595232659274;
        Mon, 20 Jul 2020 01:10:59 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id y6sm31498842wrr.74.2020.07.20.01.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 01:10:58 -0700 (PDT)
Date:   Mon, 20 Jul 2020 10:10:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] sched: sch_api: add missing rcu read lock to
 silence the warning
Message-ID: <20200720081058.GA2235@nanopsycho>
References: <20200720072248.6184-1-jiri@resnulli.us>
 <20200720075000.GA352399@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720075000.GA352399@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 20, 2020 at 09:50:00AM CEST, idosch@idosch.org wrote:
>On Mon, Jul 20, 2020 at 09:22:48AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> In case the qdisc_match_from_root function() is called from non-rcu path
>> with rtnl mutex held, a suspiciout rcu usage warning appears:
>> 
>> [  241.504354] =============================
>> [  241.504358] WARNING: suspicious RCU usage
>> [  241.504366] 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32 Not tainted
>> [  241.504370] -----------------------------
>> [  241.504378] net/sched/sch_api.c:270 RCU-list traversed in non-reader section!!
>> [  241.504382]
>>                other info that might help us debug this:
>> [  241.504388]
>>                rcu_scheduler_active = 2, debug_locks = 1
>> [  241.504394] 1 lock held by tc/1391:
>> [  241.504398]  #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0
>> [  241.504431]
>>                stack backtrace:
>> [  241.504440] CPU: 0 PID: 1391 Comm: tc Not tainted 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32
>> [  241.504446] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
>> [  241.504453] Call Trace:
>> [  241.504465]  dump_stack+0x100/0x184
>> [  241.504482]  lockdep_rcu_suspicious+0x153/0x15d
>> [  241.504499]  qdisc_match_from_root+0x293/0x350
>> 
>> Fix this by taking the rcu_lock for qdisc_hash iteration.
>> 
>> Reported-by: Ido Schimmel <idosch@mellanox.com>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  net/sched/sch_api.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>> index 11ebba60da3b..c7cfd8dc6a77 100644
>> --- a/net/sched/sch_api.c
>> +++ b/net/sched/sch_api.c
>> @@ -267,10 +267,12 @@ static struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
>>  	    root->handle == handle)
>>  		return root;
>>  
>> +	rcu_read_lock();
>>  	hash_for_each_possible_rcu(qdisc_dev(root)->qdisc_hash, q, hash, handle) {
>>  		if (q->handle == handle)
>>  			return q;
>
>You don't unlock here, but I'm not sure it's the best fix. It's weird to
>return an object from an RCU critical section without taking a
>reference. It can also hide a bug if someone calls
>qdisc_match_from_root() without RTNL or RCU.
>
>hash_for_each_possible_rcu() is basically hlist_for_each_entry_rcu()
>which already accepts:
>
>@cond:       optional lockdep expression if called from non-RCU protection.
>
>So maybe extend hash_for_each_possible_rcu() with 'cond' and pass a
>lockdep expression to see if RTNL is held?

Makes sense. Sent v2. Thanks!


>
>>  	}
>> +	rcu_read_unlock();
>>  	return NULL;
>>  }
>>  
>> -- 
>> 2.21.3
>> 
