Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F432F8155
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbhAOQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhAOQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:56:42 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FFC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:56:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g12so14243122ejf.8
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UILDa8SqGATtbJ28+3LMnujwv4R5btTkusISu2E5BSY=;
        b=MkR9sQfgeAKucaJx7aCHN3OEf2IfCiuKufocakz3tWFdYV4sBVDtHmX57i5ZyutsUp
         Syz+mkNP9GV+RSjRx/9PNigbxcYe4rNX5mZI4Y6FWHWFCaYYbYrbX/AHYYrBN9XgiZqy
         E9ygn8EVsvZcm+jwh4O3oYSPznDtAaPi0RgB4QODI/cNRTJINt5CpeT0Wch2FnH+edGX
         wu3iJzSypXPof4X0VlNe1kusA29TY7NrK1CERanKC/cKzex2DaxqsiQE2v3jJDolBku2
         pMzRqQiSk0FK1ZD/CRGoGb/EFkpRKwgec7qQ0nwZqagzo9Pk7nbbtqr7avVPvDrr2/+T
         KqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UILDa8SqGATtbJ28+3LMnujwv4R5btTkusISu2E5BSY=;
        b=B7aE9nuowpssaeGz3NwRenDHVcXQeChJg77pQGVbTT1PcWTOLfOnR0XKZ1wB522eO0
         iSC246esX35AetxFGPNwPUPECcXLXQ9J0zgJuu3+cMVQ7EhZTPn+KJu7v273MgxP5qD0
         DHXRp6r578Qbs4aVyrQbSB/RlzLsgaEY2FP4tIexACDW9Y3M3yooNrhTd5gqespQlSyb
         qe7uCGvwrEB6FteVixQRvKXufLPVerB//jS0kzDwSjaeV1oIn1CIl/fPvWZtUpyRrEDo
         LSBS0qQ5mEzAP+2XadZ5DsfM+taz7oZw1Eiplr0iQ7jD3WfWJSGcS31mJYljbvkRriZ/
         o4wA==
X-Gm-Message-State: AOAM53123P52rSO+Jdwl3ENnM10bQKl69xTaPIFHIiFCn+xyMM0FjII+
        1mkPTTc5A6tH5+fdbancDvpG7eao4+t00wyezxg=
X-Google-Smtp-Source: ABdhPJwFXltBn7Sgb59MyuuY9qFCEEqsBlxXrrnICxX7u99MzpWvlxxR33eCcMYZsBpvLw8FLovPWg==
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr9477743ejc.120.1610729761162;
        Fri, 15 Jan 2021 08:56:01 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z6sm2174978ejx.17.2021.01.15.08.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:56:00 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:55:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115165559.GS3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210115154357.GA2064789@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115154357.GA2064789@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 04:43:57PM CET, idosch@idosch.org wrote:
>On Wed, Jan 13, 2021 at 01:12:12PM +0100, Jiri Pirko wrote:
>> # Create a new netdevsim device, with no ports and 2 line cards:
>> $ echo "10 0 2" >/sys/bus/netdevsim/new_device
>> $ devlink port # No ports are listed
>> $ devlink lc
>> netdevsim/netdevsim10:
>>   lc 0 state unprovisioned
>>     supported_types:
>>        card1port card2ports card4ports
>>   lc 1 state unprovisioned
>>     supported_types:
>>        card1port card2ports card4ports
>> 
>> # Note that driver advertizes supported line card types. In case of
>> # netdevsim, these are 3.
>> 
>> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>
>Why do we need a separate command for that? You actually introduced
>'DEVLINK_CMD_LINECARD_SET' in patch #1, but it's never used.
>
>I prefer:
>
>devlink lc set netdevsim/netdevsim10 index 0 state provision type card4ports

This is misleading. This is actually not setting state. The state gets
changed upon successful provisioning process. Also, one may think that
he can set other states, but he can't. I don't like this at all :/


>devlink lc set netdevsim/netdevsim10 index 0 state unprovision
>
>It is consistent with the GET/SET/NEW/DEL pattern used by other
>commands.

Not really, see split port for example. This is similar to that.

>
>> $ devlink lc
>> netdevsim/netdevsim10:
>>   lc 0 state provisioned type card4ports
>>     supported_types:
>>        card1port card2ports card4ports
>>   lc 1 state unprovisioned
>>     supported_types:
>>        card1port card2ports card4ports
>> $ devlink port
>> netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
>> netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
>> netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
>> netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
>> #                                                 ^^                    ^^^^
>> #                                     netdev name adjusted          index of a line card this port belongs to
>> 
>> $ ip link set eni10nl0p1 up 
>> $ ip link show eni10nl0p1   
>> 165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> 
>> # Now activate the line card using debugfs. That emulates plug-in event
>> # on real hardware:
>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>> $ ip link show eni10nl0p1
>> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> # The carrier is UP now.
>> 
>> Jiri Pirko (10):
>>   devlink: add support to create line card and expose to user
>>   devlink: implement line card provisioning
>>   devlink: implement line card active state
>>   devlink: append split port number to the port name
>>   devlink: add port to line card relationship set
>>   netdevsim: introduce line card support
>>   netdevsim: allow port objects to be linked with line cards
>>   netdevsim: create devlink line card object and implement provisioning
>>   netdevsim: implement line card activation
>>   selftests: add netdevsim devlink lc test
>> 
>>  drivers/net/netdevsim/bus.c                   |  21 +-
>>  drivers/net/netdevsim/dev.c                   | 370 ++++++++++++++-
>>  drivers/net/netdevsim/netdev.c                |   2 +
>>  drivers/net/netdevsim/netdevsim.h             |  23 +
>>  include/net/devlink.h                         |  44 ++
>>  include/uapi/linux/devlink.h                  |  25 +
>>  net/core/devlink.c                            | 443 +++++++++++++++++-
>>  .../drivers/net/netdevsim/devlink.sh          |  62 ++-
>>  8 files changed, 964 insertions(+), 26 deletions(-)
>> 
>> -- 
>> 2.26.2
>> 
