Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B55B3475
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 07:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfIPFiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 01:38:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55877 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfIPFiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 01:38:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id g207so8508197wmg.5
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 22:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NYdi4GX237KM+O+EVypoAMLBZrFvfW0XoqlJBdznIcI=;
        b=iT7vNN1fcqnI4KLfsjeEy5vZ8SYMZkVvogxYGCOR2foGArCXrZa1XmxUit6iwbIJX6
         5vT0yxU+Y21wQ7bK1sibnvfQ7IVyZYx5bV5ImMnwRy+2J23TikwYqy3SSHariJKKmf46
         AYKTLc8OsPLpF+NsLOD8LWY5cq8y29VsTTsorTx/0ZZL2SjNTmgPG9+k+Pm+RX1QRGiN
         9BGs1CeGhbgfeEyaUvYuLyIqVizFZ3FNvNYbt29Z7idw5/gQ8hd9ahMCMbCdHTyMActm
         hi8y13fpMxKE8W7kttN5jjZdE6utfBN+hNUzQV2KdxHuziYUHGu7ZvVz9cE984sBTcO3
         Ssbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NYdi4GX237KM+O+EVypoAMLBZrFvfW0XoqlJBdznIcI=;
        b=tFJkc9haFjp30UeTduCycsRuq2HOJg673ovLZS8bapuS8R3wygNBvLmN/LDcBSK+1q
         ZB69XxCYoGOWC9UPRv398XKF7lkvuojcTMKUXPkVBGVH+XCaxwGyIkluqVmSZJseeY35
         QmdfkYuZB0zq88tmHIXbksuD0KWT6oSWpAroo0qXx6BDojYBytQ0+Umufh0kMiYtS1OV
         erF0TaIf4DJONKuH1yWqf81nKiA1PoAvK3zwETAhC2Ixwy4hPq8WW7fuMGzjekaBljVc
         wTtb+Di2XCpLWMbm+fZyTtgAdmpkmD033lgS2iDcqQhWihXQtPxfTooxDmWI+KvUmKwJ
         Bnvw==
X-Gm-Message-State: APjAAAWjYglg0pOkO1PrRZ1Ns3/zl28bzIiImRCsDO8/JbMRTokpyCdE
        NdFIQBafotzc+PkLdLQga5XJmw==
X-Google-Smtp-Source: APXvYqwF/OAxBtQy2mHia1O+s8XWWu1hneo0sMwEe9f0MzXTdyNcVIbgSNnKfF30zBBEjAWC/2YYZg==
X-Received: by 2002:a1c:c14a:: with SMTP id r71mr7371149wmf.46.1568612282780;
        Sun, 15 Sep 2019 22:38:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v7sm33741203wru.87.2019.09.15.22.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 22:38:01 -0700 (PDT)
Date:   Mon, 16 Sep 2019 07:38:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 02/15] net: fib_notifier: make FIB notifier
 per-netns
Message-ID: <20190916053801.GG2286@nanopsycho.orion>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-3-jiri@resnulli.us>
 <87139e84-4310-6632-c5d5-64610d4cc56e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87139e84-4310-6632-c5d5-64610d4cc56e@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 15, 2019 at 10:05:47PM CEST, dsahern@gmail.com wrote:
>On 9/14/19 12:45 AM, Jiri Pirko wrote:
>>  #define FIB_DUMP_MAX_RETRIES 5
>> -int register_fib_notifier(struct notifier_block *nb,
>> +int register_fib_notifier(struct net *net, struct notifier_block *nb,
>>  			  void (*cb)(struct notifier_block *nb))
>>  {
>>  	int retries = 0;
>>  	int err;
>>  
>>  	do {
>> -		unsigned int fib_seq = fib_seq_sum();
>> -		struct net *net;
>> -
>> -		rcu_read_lock();
>> -		for_each_net_rcu(net) {
>> -			err = fib_net_dump(net, nb);
>> -			if (err)
>> -				goto err_fib_net_dump;
>> -		}
>> -		rcu_read_unlock();
>> -
>> -		if (fib_dump_is_consistent(nb, cb, fib_seq))
>> +		unsigned int fib_seq = fib_seq_sum(net);
>> +
>> +		err = fib_net_dump(net, nb);
>> +		if (err)
>> +			return err;
>> +
>> +		if (fib_dump_is_consistent(net, nb, cb, fib_seq))
>>  			return 0;
>>  	} while (++retries < FIB_DUMP_MAX_RETRIES);
>
>This is still more complicated than it needs to be. Why lump all
>fib_notifier_ops into 1 dump when they are separate databases with
>separate seq numbers? Just dump them 1 at a time and retry that 1
>database as needed.

Well I think that what you describe is out of scope of this patch. It is
another optimization of fib_notifier. The aim of this patchset is not
optimization of fib_notifier, but devlink netns change. This patchset is
just a dependency.

Can't we do optimization in another patchset? I already struggled to
keep this one within 15-patch limit.

Thanks

>
>ie., This:
>    list_for_each_entry_rcu(ops, &net->fib_notifier_ops, list) {
>should be in register_fib_notifier and not fib_net_dump.
>
>as it stands you are potentially replaying way more than is needed when
>a dump is inconsistent.
>
>
>>  
>>  	return -EBUSY;
>> -
>> -err_fib_net_dump:
>> -	rcu_read_unlock();
>> -	return err;
>>  }
>>  EXPORT_SYMBOL(register_fib_notifier);
>>  
>> -int unregister_fib_notifier(struct notifier_block *nb)
>> +int unregister_fib_notifier(struct net *net, struct notifier_block *nb)
>>  {
>> -	return atomic_notifier_chain_unregister(&fib_chain, nb);
>> +	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
>> +
>> +	return atomic_notifier_chain_unregister(&fn_net->fib_chain, nb);
>>  }
>>  EXPORT_SYMBOL(unregister_fib_notifier);
>>  
>
>
>
>
>
