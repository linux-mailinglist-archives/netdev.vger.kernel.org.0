Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A3BC2319
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbfI3OXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:23:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38978 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfI3OXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:23:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so11591471wrj.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 07:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nz/sIGgFTrFkGWTVXO5C9jBhk5XQguq9Cz1Inzjnet4=;
        b=PovVai4E/1538Hgt0t2Mkq21Muxb1CmotJ9Lgd138s7XmMmdfRbyrFFDTHQl+Mdx/E
         iDPTtei3HtbUlUkczaS1TsBeLsONSpjZm1YsGaO8EXDelrZgdG9EgxdpLhnf7kRdfRLK
         DvvejKZTykxxWbcbsWwhCQy70m6nG9g5uUUiFZeVYEOd2dTfm7whyFIWybAogKx3OAME
         u0ZrhHgQigWnm0hQ55gmIEXh+53mbvpmklSu1MwMimMsPLijOfQeZyqsNL4Z3PwSPNnB
         Kt24mjEKNMP2Rbk8TEZi2aG/BmKJNKzmmRUwuLaJq1I/3ExmcgUj3K/Ms+k3IbFkcgDN
         o7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nz/sIGgFTrFkGWTVXO5C9jBhk5XQguq9Cz1Inzjnet4=;
        b=tl2kHvR4sn3uCX83KGJj3b3lUcDHCEIdD9UhP3wz5BOxxEx2usJBHb14JWtHnRPqp6
         7PaZDlnTN/vFpuaqQX+JPVW1NiUFS5cNSjyUusT3l9DmCyfnTholHDTBFtO2pH7y72or
         y+mQkPwl9bdbm95o7/HbvshDybGpp2QxLOfP0eYiWXrTI4dQt2Xj3VNJYcmEI1aslA+L
         vzwXGa/T/F5iTIEzQquilJuXy7ONDsTUXD9wVnqALsz2tXFvNRWTSIkNrmgKopBq9slJ
         OfQPyr0UprZPiGDXEoxvICvepYnmmzu1LM18i/jptZE1lxwDdi+jn7BiuVuraxdiVj77
         GenA==
X-Gm-Message-State: APjAAAXnwbDJ3oIyWkVgl9cVPUY8StaD4qjOAyr3EZmCmR+2sEsk1g6A
        conjCIRmaoEed3IrOwRE/hK2jg==
X-Google-Smtp-Source: APXvYqxOj7f++MQsyQ+rQxwM4W4SfBn+SjI7VC4bE+TeGLfCv+Ranlhg3NDAb4KiS8KWec5hn90iJg==
X-Received: by 2002:adf:f343:: with SMTP id e3mr13645191wrp.268.1569853430739;
        Mon, 30 Sep 2019 07:23:50 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id e20sm28003734wrc.34.2019.09.30.07.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 07:23:50 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:23:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        pabeni@redhat.com, edumazet@google.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/3] net: introduce per-netns netdevice notifiers
Message-ID: <20190930142349.GE2211@nanopsycho>
References: <20190930081511.26915-1-jiri@resnulli.us>
 <20190930081511.26915-3-jiri@resnulli.us>
 <20190930133824.GA14745@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930133824.GA14745@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 30, 2019 at 03:38:24PM CEST, andrew@lunn.ch wrote:
>>  static int call_netdevice_notifiers_info(unsigned long val,
>>  					 struct netdev_notifier_info *info)
>>  {
>> +	struct net *net = dev_net(info->dev);
>> +	int ret;
>> +
>>  	ASSERT_RTNL();
>> +
>> +	/* Run per-netns notifier block chain first, then run the global one.
>> +	 * Hopefully, one day, the global one is going to be removed after
>> +	 * all notifier block registrators get converted to be per-netns.
>> +	 */
>
>Hi Jiri
>
>Is that really going to happen? register_netdevice_notifier() is used
>in 130 files. Do you plan to spend the time to make it happen?

That's why I prepended the sentency with "Hopefully, one day"...


>
>> +	ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
>> +	if (ret & NOTIFY_STOP_MASK)
>> +		return ret;
>>  	return raw_notifier_call_chain(&netdev_chain, val, info);
>>  }
>
>Humm. I wonder about NOTIFY_STOP_MASK here. These are two separate
>chains. Should one chain be able to stop the other chain? Are there

Well if the failing item would be in the second chain, at the beginning
of it, it would be stopped too. Does not matter where the stop happens,
the point is that the whole processing stops. That is why I added the
check here.


>other examples where NOTIFY_STOP_MASK crosses a chain boundary?

Not aware of it, no. Could you please describe what is wrong?


>
>      Andrew
