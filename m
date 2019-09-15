Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E1CB2F65
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfIOJhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 05:37:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45383 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfIOJhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 05:37:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so1941072wrm.12
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3jqN6Z6vM/0viv74uObMJuTeu3o7OvGHRH/GMMjtn2o=;
        b=KBGdOkANZeeKoZ7Kk5q6MYWicrFNg+vL4iSBHEKVXK/z4dFTU0+kJGBz1ScThCW839
         Um4oegi0vMAz4OdX3DEwj+WmzFBD0cM6GtgOCSCNKpZd67bF+EDx/SOe/SqiLb+MugiH
         e084wLQ/3Vmgf5+5goeJ9oxEUSNaiNYU9tWBidoU0W9sHv7a5siiR9sPrxWq6BAP1Ive
         gr6ZtGmFTMXxzxr7zxWn3Lk/PkbnVjB2BbEH4hilzu6DHfOXhtGnJ66RJpy4EAJ0/HsR
         pwcKW1ad2uiVy++1djVVBJTlv175bGmcAEld/vzDsJL30m3WxB0unxfTE8yzpTO6TwYd
         BiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3jqN6Z6vM/0viv74uObMJuTeu3o7OvGHRH/GMMjtn2o=;
        b=CG6ghbFlXp5CN3aOmjDB/Nd18HvQIjgdNS+jRCB4ZjyizOp/Ei68iV9aUByJQUT31G
         uCfHvl9o2t9wmAkPXRgvi9cI2nCg0dAyjaz6OjYtzIRYHs3mUwhr8oRq9Slq1ftu+/kU
         zCjEAPnvaW01y1rLKMELaUDi9Q8uu0G7W1Qm9iKr2LCsH9VPv2UfiRwKTTi+JJHtrvps
         ifdY32VEQWg/Xlf1jCJX/s38m9BeVi7m56VUF0+IbnxvsrjyUYHbZodHlqDQ17vZIsJo
         FVRYSOAeRevLKWN1Xk03v0n83RjuyuHldLQxCmfEAHt0gYUwHoMEt1XRzNns0/DNKJA1
         zRcQ==
X-Gm-Message-State: APjAAAX/lJRcjHSmjw7qpfVrBgucMbOP/sM3lWGL2B5siYYdhglG0/ju
        xw9059O1H9MpgQe9SC/7A4Ok0g==
X-Google-Smtp-Source: APXvYqyEl+gydkdv96Ksnn4AOV2SRFY5Xp6WFEVvtQkWIAPZnb7scO95t4e42vRCYoYKIDp+0OoYlQ==
X-Received: by 2002:adf:fd10:: with SMTP id e16mr1488079wrr.17.1568540236845;
        Sun, 15 Sep 2019 02:37:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y72sm10757176wmc.26.2019.09.15.02.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 02:37:16 -0700 (PDT)
Date:   Sun, 15 Sep 2019 11:37:14 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 02/15] net: fib_notifier: make FIB notifier
 per-netns
Message-ID: <20190915093714.GB2286@nanopsycho.orion>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-3-jiri@resnulli.us>
 <20190915080602.GA11194@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915080602.GA11194@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 15, 2019 at 10:06:02AM CEST, idosch@idosch.org wrote:
>On Sat, Sep 14, 2019 at 08:45:55AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently all users of FIB notifier only cares about events in init_net.
>
>s/cares/care/

ok


>
>> Later in this patchset, users get interested in other namespaces too.
>> However, for every registered block user is interested only about one
>> namespace. Make the FIB notifier registration per-netns and avoid
>> unnecessary calls of notifier block for other namespaces.
>
>...
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
>> index 5d20d615663e..fe0cc969cf94 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
>> @@ -248,9 +248,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
>>  	struct net_device *fib_dev;
>>  	struct fib_info *fi;
>>  
>> -	if (!net_eq(info->net, &init_net))
>> -		return NOTIFY_DONE;
>
>I don't see anymore uses of 'info->net'. Can it be removed from 'struct
>fib_notifier_info' ?

correct. I missed that.

