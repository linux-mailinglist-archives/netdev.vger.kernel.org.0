Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBCF1321F2
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgAGJLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:11:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46291 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgAGJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:11:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so52932190wrl.13
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DykfsJMTrlBsOmof65s5+53qX785X3Wsx6L7OIVas9c=;
        b=Bh5qVeLk4iQqGpEKpGmk37AHNeRtl4TqWn34Yul2N/w+NoPbgaWbqnadHz8WCg03oC
         z9d+M8Vb2znalEf+GIy6uHBQAZM8JReU3JWvk2Cxda4F7BHzKBX/jqIQ83N8MOV1FtUK
         KjOfr9vbCicC4KzTnaYAztWZQqi2Safosbge8NlQLt8avIS1nxz+nUYLA8g2drC1O0SM
         Qo1RC3o/7bxUxc4NuyDXOcuesPzbIToAmXGk6eW08LFpi6BuvD8JVdb4jh7R9i8ReyJu
         C7YODZglKtS/SzBoXTm6tHMuN2qEscqUwq3DHgLAqp/zQ1T/xUjS9HMll8Ic469smGG6
         kF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DykfsJMTrlBsOmof65s5+53qX785X3Wsx6L7OIVas9c=;
        b=d3argzqS6TI+PxGJ3T0U7yS6jgvcDMUrCjTmiGHJ3v+KkyYKpCzVfFNHi+pWdUwnlb
         6ia9FTx3YjuzG4gEXmQv9GVAymcRDK2uYJ2fLKsCElH/Y8R5FkmYrLBcG4WueUY6IpBG
         cOR4voF1MLf5ARN7eRnjPDXKgVRRevBNz8XNBfmTrarnhvWiFWV3HWYmNE0sdFgBNgDK
         tmo8mUV9RqHCUxj1UnysJA3quwTbMiIstsMwN6H5o91d6oR1hug5h72r96ydEArpHUPU
         ySFDri+L9TvDtGZkOikvhxxqKYBLo36+3pSd4ka2NWN+Oal11ERvpVfjo7p+FRxVzibl
         3qfA==
X-Gm-Message-State: APjAAAXCayCEAbMceEWiLiLhVXq2JtcoWnDaMWO/W3CqhgaNTmq8tDnk
        ANBHZ9B7FPJ2f6C6U6xgF6QoOA==
X-Google-Smtp-Source: APXvYqzB5YH6tW2N9qwoZ6NzyHxd8hhXAq7jAtUrKeSOTXmw+pgYgzkqK+fAn6zOwCC8T6+8LoxIrQ==
X-Received: by 2002:a5d:4281:: with SMTP id k1mr111528745wrq.72.1578388292513;
        Tue, 07 Jan 2020 01:11:32 -0800 (PST)
Received: from localhost (ip-89-176-199-63.net.upcbroadband.cz. [89.176.199.63])
        by smtp.gmail.com with ESMTPSA id u1sm25761422wmc.5.2020.01.07.01.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 01:11:31 -0800 (PST)
Date:   Tue, 7 Jan 2020 10:11:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow
 netdev into namespace
Message-ID: <20200107091130.GB2185@nanopsycho>
References: <20191220123542.26315-1-jiri@resnulli.us>
 <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
 <20191221081406.GB2246@nanopsycho.orion>
 <e66fee63-ad27-c5e0-8321-76999e7d82c9@gmail.com>
 <20200106091519.GB9150@nanopsycho.orion>
 <b3fe2a66-baaf-86bb-5347-1ffcaadb3d14@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3fe2a66-baaf-86bb-5347-1ffcaadb3d14@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 06, 2020 at 05:37:21PM CET, dsahern@gmail.com wrote:
>On 1/6/20 2:15 AM, Jiri Pirko wrote:
>> 
>> I do not follow. This patchset assures that driver does not get
>> notification of namespace it does not care about. I'm not sure what do
>> you mean by "half of the problem".
>
>originally, notifiers were only global. drivers registered for them, got
>the replay of existing data, and notifications across namespaces.

Not sure what do you mean by "replay of existing data".


>
>You added code to allow drivers to register for events in a specific
>namespace.

For some drivers, like "mlxsw" this is just enough as it does not
support move of netdevices to different namespaces and the namespace of
all netdevices is taken according to namespace of parent devlink
instance.


>
>Now you are saying that is not enough as devices can be moved from one
>namespace to another and you want core code to automagically register a
>driver for events as its devices are moved.
>
>My point is if a driver is trying to be efficient and not handle events
>in namespaces it does not care about (the argument for per-namespace
>notifiers) then something needs to track that a driver no longer cares
>about events in a given namespace once all devices are moved out of Only
>the driver knows that and IMHO the driver should be the one managing
>what namespaces it wants events.

Definitelly. This would be the case for per-driver notifiers.
However, the ones in mlx5 I'm taking care of are per-netdevice
notifiers. Each netdev registers a separate notifier.


>
>Example:
>driver A has 2 devices eth0, eth1. It registers for events ONLY in
>init_net. eth0 is moved to ns0. eth1 is moved to ns1. On the move, core
>code registers driver A for events in ns0 and ns1.
>
>Driver A now no longer cares about events in init_net, yet it still
>receives them. If this is not a big concern for driver A, then why the
>namespace only registration? ie., just use the global and move on. If it
>is a concern (your point in this thread), you have not solved the
>unregister problem.

Wait, why do you think that there is a "unregister problem"?
move_netdevice_notifiers_dev_net() unregisters from the original netns.


>
>ie., I don't like the automagic registration in the new namespace.
>drivers should be explicit about what it wants.
>
>> 
>> 
>>> driver cares for granularity, it can deal with namespace changes on its
>>> own. If that's too much, use the global registration.
>
