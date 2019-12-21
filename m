Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB9128814
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 09:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLUIVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 03:21:18 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33284 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLUIVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 03:21:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so11608285wrq.0
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 00:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2DUrOXPYqEcNeO1u8Fn6f23GoEprvO2sOcUgAOBOqDI=;
        b=LNJ75JviYTkOP20dpL07YrJ7lFnWyWN6CQP+O0TmFJoAQJSFh11MG02cZqRWwt6ivA
         Umhr3Xx2YJ0MMyaOEYMntzZZxnWpyyH45PFSUc2G6ToHH5NLzQ+LT0LxHjPi/02ls53r
         3WX21X2iZubPrY8v5jVMz3/aAkZtnkyw0XBuzUUWHZM6u/z+GgEGC1jMO7hSJilTzpsF
         qGJ224x2lFp3jq9gO7EHXj3D+IOkZ+rKPv4ABVx+xoQpvNRtSz1+NUXAnawGynnT89Gz
         smaKfGFP/TsFHQn9skLNWfDRQzo5zR88L7mA2zD2MTlCpCxPzFUY5l+v+863azK7vIev
         kvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2DUrOXPYqEcNeO1u8Fn6f23GoEprvO2sOcUgAOBOqDI=;
        b=omkmheeSlcbKSDnTDat9rMzuLZm6l3cakR4e4fnF7e2kXTYeV5ZDdAIJGljdqj5gpu
         iJe1JCHYkWtXJ1DsWjooo2SyG89mqTziYuLGn2aNUm7iLYzS+oG4hPmYLJkp8T0j23r7
         fjjU1HtcZtQpLXcYcszxtN7kY4z0vuZi9NVt5MqAKXArFq2bL5UQ/Z/FQz7iUnXLxBrN
         YuGKB7YKMIfy3l+xinoFrIW7xg5OWHdxwVXXdJe6sJrf86jLHKRgl9WCD53yP328+lv3
         flftDwqmKmYVLernJOpyneA5QwkqMZa0qhh4mtJGVjPDXvRtS6onW9cC024xuHuiqTEe
         L5Aw==
X-Gm-Message-State: APjAAAUB6Wc2HEkgUQhi9fqR2dtSH85udZJIfKFpSwUjNP9uxGT7OEQP
        1s3y2dSIU7J42qIVWUSiem5ung==
X-Google-Smtp-Source: APXvYqyS0oH+XwWD3/VuQDIEPeTXegEDtiLQQock6r0Hlx1k5HzvRbxW/VUCNfi3mS4RBiWgT8TPuw==
X-Received: by 2002:a5d:620b:: with SMTP id y11mr19186746wru.230.1576916475882;
        Sat, 21 Dec 2019 00:21:15 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d12sm12389440wrp.62.2019.12.21.00.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 00:21:15 -0800 (PST)
Date:   Sat, 21 Dec 2019 09:21:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next 3/4] net: introduce dev_net notifier
 register/unregister variants
Message-ID: <20191221082114.GC2246@nanopsycho.orion>
References: <20191220123542.26315-1-jiri@resnulli.us>
 <20191220123542.26315-4-jiri@resnulli.us>
 <2f2b193761ed53f8a529a146e544179864076ce2.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f2b193761ed53f8a529a146e544179864076ce2.camel@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 20, 2019 at 08:29:31PM CET, saeedm@mellanox.com wrote:
>On Fri, 2019-12-20 at 13:35 +0100, Jiri Pirko wrote:

[...]


>> +int register_netdevice_notifier_dev_net(struct net_device *dev,
>> +					struct notifier_block *nb,
>> +					struct netdev_net_notifier *nn)
>> +{
>> +	int err;
>> +
>> +	rtnl_lock();
>> +	err = __register_netdevice_notifier_net(dev_net(dev), nb,
>> false);
>> +	if (!err) {
>> +		nn->nb = nb;
>
>looks like there is 1 to 1 mapping between nn and nb, 
>to save the driver developers the headache of dealing with two objects
>just embed the nb object into the nn object and let the driver deal
>with nn objects only.

Sure. That was my thinking too. The problem is that in event handler,
the arg is struct notifier_block *nb.
So the user would have to know the struct netdev_net_notifier internals
in order to extract the container of struct notifier_block.

I think is is better to not to hide this.

[...]
