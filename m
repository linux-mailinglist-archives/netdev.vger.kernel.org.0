Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC4A308441
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhA2DeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2DeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:34:05 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7AC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:33:25 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id a77so8494324oii.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z/TivoGMyONfRhrZdz8Qb23JaSHJZwMUF0UJ2J1X9K4=;
        b=sfhMveMuv6hn2MCYxCLIodjHCDRZ1ieGcJkWnVHdyBY2XWBEvhqiEXdR1db4+JfqK2
         EdbZPo/WKuUm12UWdFI6/0rdmvyNuDHAFNsFvMgjRLRzfo5CBePBEaZZSBPafLdIHYvN
         0Jp1uOra10PghPuEFKu3TARBos6O56Exx5mUVl1Sn5jOxSHGf4QQLRFnpKThMHUG0pzR
         6iOKgsfdM4ijopfxezzUDe0b8LvuzknToo2ePXv30+hy0I+puEfJjfc3Hmi72Gf90cn9
         Pz7rTUUBqC4BBGcihB8Qe6CCY+yHAjzMASedrwqzdpzkw9SanzBDAz5bOr4yaAYCvDWO
         WYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z/TivoGMyONfRhrZdz8Qb23JaSHJZwMUF0UJ2J1X9K4=;
        b=Z/i1+VyMePdIK3Kvz371R75LEHN3GWt6gkRBXAIygBwfmEh113eAFJ1jRdD7aZnNav
         OLG/rc1/8e3qiZLgyYl658r8xhiMdIwJO4gc5SZT2Hjq3XRRlwkDHdKlUgGiUNvFI0iy
         3ac/yEVwWVTc6H1KSc1VVjdKgwEGJoR18Tw1OYvDinWos4dqjoZV2RgBy6ZE/lthyhA1
         cwswSJu1TlD+Xq/zYqp9DDGdv+I4U6DtgP6Dnj2bc9Zq1r/3A19nxZo0DmpFe5a3VHio
         nB3Kt6u5mQ4VXeXJ0tZMOLBH49VYa1VVFXtjkgmKz8YO6jUzgRbcuR+Ug4IBYK5eO5vR
         CAtw==
X-Gm-Message-State: AOAM5322GCIwMpBKeR507mxAtQEWMJlfUBVmif/5B+BlOZqJsQEVY7G/
        /ceOD/AKg7mlLmtTwHOVVjs=
X-Google-Smtp-Source: ABdhPJyabc6cm6trgxW+hmU5Fbn0ChpkZE0NvpHI9Hrcn4rtajodtxvaj4BuhdjsF3y2g/lab1Z5AQ==
X-Received: by 2002:aca:f40c:: with SMTP id s12mr1473523oih.105.1611891205034;
        Thu, 28 Jan 2021 19:33:25 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id l2sm1552885oig.48.2021.01.28.19.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:33:24 -0800 (PST)
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
 <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
Date:   Thu, 28 Jan 2021 20:33:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 8:04 PM, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 15:23:06 +0200 Ido Schimmel wrote:
>> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
>> are changed. The aim is to provide an indication to user-space
>> (e.g., routing daemons) about the state of the route in hardware.
> 
> What does the daemon in the user space do with it?

You don't want FRR for example to advertise a route to a peer until it
is really programmed in h/w. This notification gives routing daemons
that information.

> 
> The notification will only be generated for the _first_ ASIC which
> offloaded the object. Which may be fine for you today but as an uAPI 
> it feels slightly lacking.
> 
> If the user space just wants to make sure the devices are synced to
> notifications from certain stage, wouldn't it be more idiomatic to
> provide some "fence" operation?
> 
> WDYT? David?
> 

This feature was first discussed I think about 2 years ago - when I was
still with Cumulus, so I already knew the intent and end goal.

I think support for multiple ASICs / NICs doing this kind of offload
will have a whole lot of challenges. I don't think this particular user
notification is going to be a big problem - e.g., you could always delay
the emit until all have indicated the offload.
