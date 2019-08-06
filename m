Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45BA83D71
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 00:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfHFWmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 18:42:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38559 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfHFWmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 18:42:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id h28so62436997lfj.5
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 15:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bg9l25MZXCLBavPa1Xcht1mcBKk1O8xgdDiwYfA9R+M=;
        b=JJY6nPS85x66wkTFhBIBjdKhhkkLPQFUZw0r059VeTp2vjRfC/wfecQL//CatE2Vyx
         PBcegEyGJneDVZ3DnaJ2v77pKmDmh9V49sVzPJpXWNdsHNA6ohSTXzh1He/n3PnmPHaw
         o7N8T9pitJ9SObN5HFAKeyPS0O7uABRm1/pZgHrLMDfUOhluVeNlupGB/EO/jCTe/Wiw
         aYlUyGIJAW5+4+yuWl5jwSliz9hlrXRBNxMKnUxLJK9csZAsSAgbj+1Bql0+DEzYgWM5
         xdsn0IAvsstlzMMLIx3ekiHl5/9WjD2WAl3MNfVyAm6Q8/foEc/qQtB0l8+iea2S7Jib
         EJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Bg9l25MZXCLBavPa1Xcht1mcBKk1O8xgdDiwYfA9R+M=;
        b=IVe+pdXLBA3kPVT1oVrqBa/hxIZplFNXPIJGQR5ty3BIFypwx0HfCHcXFzxB3meonz
         c7hRcMfnemd9WJdToQV2OIVzQAl7s5fvDgYC6mJV5HLal5MBii9q0s91ZDZ+xB+CCFxY
         t7KMsFoTEmnH4PvEOgFIRs+MpAuK8ty6+62engf4zWJ9+5nFskbYn7zoREOboxMIMNN3
         jjZ8Ppxx07QzzJT0ERNwHH/gsJBagO1p5WG2PanAJ+tiGzlDkItt2p+/jEfvP3VqCBsL
         by++x6H14eO5GlqWc0MTYm7gPBbtHmUi5Xn59W+vmK4hZq6+TP0faTW8zVLI5gEyLus0
         Me4g==
X-Gm-Message-State: APjAAAVJtr9S+CuIBu86J7dvxwpzQnlFoQvvyqvjZpKEgP8t10ZEjsgp
        nm8OSSZdbBIbVp+yjXx1Ej0qBw==
X-Google-Smtp-Source: APXvYqwYTs7LWhmtUbtUFhGAvJ21ypzWI/Pod1LBe93/FlReUU8ZvVqNDMq6pquwO7azhfrbX6K/Pg==
X-Received: by 2002:ac2:4824:: with SMTP id 4mr3905799lft.161.1565131335044;
        Tue, 06 Aug 2019 15:42:15 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id p87sm17941584ljp.50.2019.08.06.15.42.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 15:42:14 -0700 (PDT)
Date:   Wed, 7 Aug 2019 01:42:12 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: sch_taprio: fix memleak in error path for
 sched list parse
Message-ID: <20190806224210.GA3337@khorivan>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190806100425.4356-1-ivan.khoronzhuk@linaro.org>
 <20190806.114114.1672670570404825284.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190806.114114.1672670570404825284.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 11:41:14AM -0700, David Miller wrote:
>From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>Date: Tue,  6 Aug 2019 13:04:25 +0300
>
>> Based on net/master
>
>I wonder about that because:
Applies cleanly on net/master, but line num is not correct.
I've sent v2.

>
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -1451,7 +1451,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>  	spin_unlock_bh(qdisc_lock(sch));
>>
>>  free_sched:
>> -	kfree(new_admin);
>> +	if (new_admin)
>> +		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
>>
>>  	return err;
>
>In my tree the context around line 1451 is:
>
>	nla_nest_end(skb, sched_nest);
>
>done:
>	rcu_read_unlock();
>
>	return nla_nest_end(skb, nest);
>
>
>which is part of function taprio_dump().
>
>Please respin this properly against current 'net' sources.

-- 
Regards,
Ivan Khoronzhuk
