Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7349E84281
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfHGCdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:33:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40354 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfHGCdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:33:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so38582917pla.7
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y3xlr/twMRjifJJwHicZ/zGb4bZF7oYO+weWTAwoLNk=;
        b=qlGFDq71m4NliRtGnTsnHMBiz4wTaXlSikVDuUpsuTTM7Xddo2Z7XaqSEssSeBOW96
         g13SQv287zcfCuU1J9AGj/FXiPXp2OKj4NR/7UHZmXEAF4iEU8BWSp3TfO6ETPIiyV/n
         Tr7mryL6Sgvvs5+0yqztZjHSLxszZDXMRQyMEhQ+qbaYvHkeXwzsjKaDj50VclV2v0XX
         j1vDLOEW2legAOPua/yuf3r8XgaSy7QT0fQ+g5p8miDZHRf0qRisDqVMXcLoe3583G/U
         dcMXh5kmm79Q1lTEDLalE6c6v08ksW70xmV3eIoA+qrl9NvEnygSu+wZtXtsJcTxWAEL
         LSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3xlr/twMRjifJJwHicZ/zGb4bZF7oYO+weWTAwoLNk=;
        b=gZhWJiy99pixQla4ChkICWsSqbOFKtuU3GZ4I9oPv473aSwPyQtUzuEX7oLfd/jjlZ
         keU0We+75/yV8Qj3PtHN8DVbJGvo4225i/jX59obeBL2sGef1eNz/4aOVYHFVWgtj8s4
         Q2GWJ3xrwlmyIwlOVN6uF27NqfQr83zGb+XRLS99IriPntv7kVezgGlMTH3JGzEMQ/d4
         XBH1pp7bKVvL6MlsLWwI33WmYEtMDKeddxznUC1ioUjBSmpidKe7elD09TRUm4+0rgM9
         xjcj/VoT2yCKYIOetsYyTXZNjBQt8A7uJ6zzEDjtBiOroydv7bLjayAAbkZ+vsAU/n/5
         ppmg==
X-Gm-Message-State: APjAAAVc2UTbxDLm5AjKBldeLWEg9v2hK22B1E25ohfo9YLplJrhO4DH
        iNdulehI4KL3bHmO8P/4PZM=
X-Google-Smtp-Source: APXvYqyyO/tkvCBgmdiFadBm9cP1crhyZ0UsAUThlKWTgRr2iQ+tug+7rUnWBqmMpt1yaVB06n98gw==
X-Received: by 2002:a17:902:403:: with SMTP id 3mr5986900ple.66.1565145230945;
        Tue, 06 Aug 2019 19:33:50 -0700 (PDT)
Received: from [172.27.227.229] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id p19sm100104185pfn.99.2019.08.06.19.33.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 19:33:49 -0700 (PDT)
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190806164036.GA2332@nanopsycho.orion>
 <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
 <20190806180346.GD17072@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
Date:   Tue, 6 Aug 2019 20:33:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190806180346.GD17072@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some time back supported was added for devlink 'resources'. The idea is
that hardware (mlxsw) has limited resources (e.g., memory) that can be
allocated in certain ways (e.g., kvd for mlxsw) thus implementing
restrictions on the number of programmable entries (e.g., routes,
neighbors) by userspace.

I contend:

1. The kernel is an analogy to the hardware: it is programmed by
userspace, has limited resources (e.g., memory), and that users want to
control (e.g., limit) the number of networking entities that can be
programmed - routes, rules, nexthop objects etc and by address family
(ipv4, ipv6).

2. A consistent operational model across use cases - s/w forwarding, XDP
forwarding and hardware forwarding - is good for users deploying systems
based on the Linux networking stack. This aligns with my basic point at
LPC last November about better integration of XDP and kernel tables.

The existing devlink API is the right one for all use cases. Most
notably that the kernel can mimic the hardware from a resource
management. Trying to say 'use cgroups for s/w forwarding and devlink
for h/w forwarding' is complicating the lives of users. It is just a
model and models can apply to more than some rigid definition.

As for the namespace piece of this, the kernel's tables for networking
are *per namespace*, and so the resource controller must be per
namespace. This aligns with another consistent theme I have promoted
over the years - the ability to divide up a single ASIC into multiple,
virtual switches which are managed per namespace. This is a very popular
feature from a certain legacy vendor and one that would be good for open
networking to achieve. This is the basis of my response last week about
the devlink instance per namespace, and I thought Jiri was moving in
that direction until our chat today. Jiri's intention is something
different; we can discuss that on the next version of his patches.

###

As for the current controller put into netdevsim...

When I started down this road 18-20 months ago, I was copying a lot of
netdevsim code to create a fake device from which I could have a devlink
instance to implement the devlink resources. At some point it was silly
to keep duplicating the code - just make it part of netdevsim. After all
it really mirrors mlxsw and the resource limits for fib notifier
handling, it allows testing of the userspace APIs and in kernel notifier
APIs which allow an entity to veto a change. This is all consistent with
the intent of netdevsim - s/w based implementation for testing of APIs
that otherwise require hardware.
