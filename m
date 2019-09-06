Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3614EAB238
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 08:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389077AbfIFGFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 02:05:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37294 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbfIFGFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 02:05:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id r195so5595861wme.2
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 23:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u3xop73voN5t+H1zOjf4whXixLu0Xg3mQaakczC8GoE=;
        b=YoHI0sEBKh/IqHcUUQzXa8LStgtc1MpJSwovg5TO6ccdClihlMUSGpZTMzlUx3tw2W
         ik7AnbmKhPakyF2eVh/cViJhehY08aSDH5JUzgnqrC99TuVGver57ExGcefbr5PnP40V
         jhZqHCGTo1k9+0yZ6Mgn7y68D6p4vUuaop3TIninNrgNDdSIkupnygC7wOu9RrGVltVp
         BmtYW6yRhgRO8iWUCWtZCmtA/vpKlWOQmkFoPt+U/VFbndw9ZgBoMGvNHcWJvxg8YhH8
         nXV7nTExacJ8hMex3gZ88LRtLLPmK88aZ01jT1m9rZOLh+Zb3PGpJflkUcjJRuqcJn6P
         faTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u3xop73voN5t+H1zOjf4whXixLu0Xg3mQaakczC8GoE=;
        b=b1K7rTQy/GdMclOwbCG0YkAJ8loB0oNhOUJRkMOIkOUjxqXyNcVtsGqo9igHANm3oL
         hZYBA5Cxe1NUc5zrpwPFh60TseArZKLH4SwDMKhsqXUOEZ6xZjRXb5PRGmRABMXckLgF
         mvubAFrKr+S26+s9PznXzofdvcMXrE/UbsxCV0YLZtNf4uwNgXR+nEqMuLOXKk7kcKT9
         eh5YQ4pvNKzueiOt99wsnD8R+ycf3lzNWQ7l7Lw8F3zT/wBI0S9EwjmLUdlp2noi49cr
         274bfrmfdPxUSphnzM1tqbw7yRpxWXXiEKzpeftl6lb+6+trPwMuF+0T4Nnv68EhXD/2
         xoYg==
X-Gm-Message-State: APjAAAUZzvtasl0f8ggbOiDPUFVBu3FZjmpRZK+dgQ/Vel2t6omvZk9n
        bzSFqXosVtE8wWYHH35YuFwIJA==
X-Google-Smtp-Source: APXvYqyeD592Tdecw+ops8SFwuo4jwPtVf6gbbWCxhmfMHWYcEzsBQTSsXFK0bo2msaHyZMyXbg8Ew==
X-Received: by 2002:a1c:f50c:: with SMTP id t12mr5873528wmh.49.1567749945897;
        Thu, 05 Sep 2019 23:05:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b194sm9181776wmg.46.2019.09.05.23.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 23:05:45 -0700 (PDT)
Date:   Fri, 6 Sep 2019 08:05:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: fib_notifier: move fib_notifier_ops from
 struct net into per-net struct
Message-ID: <20190906060544.GA2264@nanopsycho.orion>
References: <20190905180656.4756-1-jiri@resnulli.us>
 <bb24e9d5-24c6-d590-e490-be2226016288@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb24e9d5-24c6-d590-e490-be2226016288@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 06, 2019 at 07:54:39AM CEST, eric.dumazet@gmail.com wrote:
>
>
>On 9/5/19 8:06 PM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> No need for fib_notifier_ops to be in struct net. It is used only by
>> fib_notifier as a private data. Use net_generic to introduce per-net
>> fib_notifier struct and move fib_notifier_ops there.
>> 
>>
>
>...
>
>>  static struct pernet_operations fib_notifier_net_ops = {
>>  	.init = fib_notifier_net_init,
>>  	.exit = fib_notifier_net_exit,
>> +	.id = &fib_notifier_net_id,
>> +	.size = sizeof(struct fib_notifier_net),
>>  };
>>  
>>  static int __init fib_notifier_init(void)
>> 
>
>Note that this will allocate a block of memory (in ops_init()) to hold this,
>plus a second one to hold the pointer to this block.
>
>Due to kmalloc() constraints, this block will use more memory.

I'm aware. But we have net_generic for exactly this purpose not to
pullute struct net.


>
>Not sure your patch is a win, since it makes things a bit more complex.
>
>Is it a preparation patch so that you can add later other fields in struct fib_notifier_net ?

Yes.


>
