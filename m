Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B5DA0C55
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH1V0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:26:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40456 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1V0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:26:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id g4so1266250qtq.7
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=23YNlEsDbObULfKEr/tFp6pmJb4nAmXiy8Gowl0MM1A=;
        b=uXX9nWHWrgyV5xAXfOUjwqqhwWFPwlLx3vjcMxsz2RIZeuYdLtknGNcRrR2zWs2PBa
         GeE1OizG35cSCq7tuqRh0rJq4dLWJK5/sGKnBeYqR+7j6xE7lS2LoAT/a54v4Yoh7CVj
         o9BTRp5pBh3CenondQ0nVjxF7avHKahkqkG1bDFga0PV+P87lcI1v/I69MeqWQhWeqP/
         XlhNdVS0LgjUO/ZN7oFR6p8BWtXva8iso2KoVdK6evCVNdBtGmcGjdoICW56F0m6FjfJ
         3ZON+xaSVjaMBkuWzk7n0EISyyFW/Z+Bi0vnhrj9y2RQjZ+F/ryZ745bsFFGn3gUOseC
         ysQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=23YNlEsDbObULfKEr/tFp6pmJb4nAmXiy8Gowl0MM1A=;
        b=TORYxy+FoGdCzuim8Z5rY3CH+HZl7DYsCW6DMFfHjKMouSpADbizcnYp54QL9NAm/B
         MO/KduuxFVVuAf+vPNwOLLQY+rNeZ4e9gyWvcmi+y9cPsZ5in/8OJ7Gr6gGdzbpiqgyr
         TCGdKNgoWKsYUZIOi9AkZxHOK+l4LCivDPTAPWXgo4KAGkdz7h7/VZ+pCKQt37JcT4Yj
         hA8tbbpGOXqve0pTg7jDsWkyZ4DNLYVMjhbt//73awOq+sn05HXMkVm10fL4tYUbzU9D
         0xgvEmtBe3sjopr55VlLnVT0MSCDjaYiSAEqKsQ6EISNQ9e2EWyZXCoZlaa5g0Jm9iu2
         NOaQ==
X-Gm-Message-State: APjAAAUdtc1ir+DUf2JkXe3hwsdBgQQKVe/6MfDMhql7S65mu2xlW/se
        kEc3m4d61JqgIcryllMcjLiYMdDurTw=
X-Google-Smtp-Source: APXvYqyTcHyedWAXGbrpw2Djq4w6jM1KjA8nIMTBiqOWrLjeWHPH5XEmncBd2vKdjoMudZ+9Ik95RA==
X-Received: by 2002:ac8:41d7:: with SMTP id o23mr6782604qtm.268.1567027565813;
        Wed, 28 Aug 2019 14:26:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:d116:2abc:e3ba:ad78])
        by smtp.googlemail.com with ESMTPSA id r15sm200507qtp.94.2019.08.28.14.26.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 14:26:04 -0700 (PDT)
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
To:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190828103718.GF2312@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2c561928-1052-4c33-848d-ed7b81e920cf@gmail.com>
Date:   Wed, 28 Aug 2019 15:26:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828103718.GF2312@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/19 4:37 AM, Jiri Pirko wrote:
> Tue, Aug 06, 2019 at 09:15:17PM CEST, dsahern@kernel.org wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>> tracked fib entries and rules per network namespace. Restore that behavior.
> 
> David, please help me understand. If the counters are per-device, not
> per-netns, they are both the same. If we have device (devlink instance)
> is in a netns and take only things happening in this netns into account,
> it should count exactly the same amount of fib entries, doesn't it?

if you are only changing where the counters are stored - net_generic vs
devlink private - then yes, they should be equivalent.

> 
> I re-thinked the devlink netns patchset and currently I'm going in
> slightly different direction. I'm having netns as an attribute of
> devlink reload. So all the port netdevices and everything gets
> re-instantiated into new netns. Works fine with mlxsw. There we also
> re-register the fib notifier.
> 
> I think that this can work for your usecase in netdevsim too:
> 1) devlink instance is registering a fib notifier to track all fib
>    entries in a namespace it belongs to. The counters are per-device -
>    counting fib entries in a namespace the device is in.
> 2) another devlink instance can do the same tracking in the same
>    namespace. No problem, it's a separate counter, but the numbers are
>    the same. One can set different limits to different devlink
>    instances, but you can have only one. That is the bahaviour you have
>    now.
> 3) on devlink reload, netdevsim re-instantiates ports and re-registers
>    fib notifier
> 4) on devlink reload with netns change, all should be fine as the
>    re-registered fib nofitier replays the entries. The ports are
>    re-instatiated in new netns.
> 
> This way, we would get consistent behaviour between netdevsim and real
> devices (mlxsw), correct devlink-netns implementation (you also
> suggested to move ports to the namespace). Everyone should be happy.
> 
> What do you think?
> 

Right now, registering the fib notifier walks all namespaces. That is
not a scalable solution. Are you changing that to replay only a given
netns? Are you changing the notifiers to be per-namespace?

Also, you are still allowing devlink instances to be created within a
namespace?
