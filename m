Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD3E33D736
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhCPPSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbhCPPSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:18:21 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED17DC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:18:20 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l11so5697283otq.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GXDMff0vDxFl6i/sK1rnnheubiN9R7OFtDT29Domi+Q=;
        b=SYTvPczz5krDfTE09UJC0IvIhEKs+MNXkxYrM38YZMozj84rFYQwFVlzHQ81XYBduv
         L5CZ70dQxsNhpC27qVM+Oz1IvnST+deQckkXLaV75yALdh1ibXvXFGqH9O3fshPY981m
         1utnf8JF98hOdJ6WBZ8HAF135OlJgZAF7o2m6Xy8kCYz0BQfX4HgI+iqkt5zdF4RV+jk
         AgUO4r7Qe3mgZoW8GxIm2aaYIMNL6bMMrN+Z/qewMQmkEM4oWT4/5CrA1IyWGF1EHu8o
         HJejBkNyVlEw2Vm/64T6vFmi8BUOuzfqpGKpVJdQ+eEmoCuE5AgG4pjuWsO1gzeeA9h1
         YxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GXDMff0vDxFl6i/sK1rnnheubiN9R7OFtDT29Domi+Q=;
        b=MN8HsT3hGwGSoL8C/nvkRRc5UHvyz3l4zox4F7waqFLdGOrC40J9Ut9KVLnKDMFLrV
         L6xZHRcby3hNid7SNqslggqgD2tz9swT0CENPed5gyZj9ldkpWjNFyRmfUZHJmkkmsyU
         UJt9xdp3s+WZvDwfR7jCIXLU94dx+3pCyQd+jCSUh9JUJj58J8iwPTMp5IZCuw5Riwuq
         Y0YbMwAZN4H8cpGdphlvjC7GQWqBbEnDBCGq/nKH1pYYlQwNIfMXOBRDKJtDaOZaiW+e
         iKJYkjPdAFTQwQl1MPjZHXte1FdCAxKxE/OogCtyNQygJhdFF3vBGuMgPGdU70mDeHZ1
         NSpg==
X-Gm-Message-State: AOAM530DD5NjG31Fl7c3Fyr5/693lWvOAOusNdR031XYCC0mC0I7SURB
        GU6aJRlkhLiDbokmxruSzNinBcsjvNI=
X-Google-Smtp-Source: ABdhPJyQmpyip8zLhFn4AA8e5+c8JbY66l/nieUklTzawRT2djwsMTpGAgogUuOdKy1Yxkm4YBtOKA==
X-Received: by 2002:a9d:5c0c:: with SMTP id o12mr3815669otk.367.1615907900288;
        Tue, 16 Mar 2021 08:18:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id r22sm8115884otg.4.2021.03.16.08.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 08:18:19 -0700 (PDT)
Subject: Re: [BUG] Iproute2 batch-mode fails to bring up veth
To:     Tim Rice <trice@posteo.net>, netdev@vger.kernel.org,
        Petr Machata <petrm@nvidia.com>
References: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <be8904d6-4313-250d-1557-10c759a36ff3@gmail.com>
Date:   Tue, 16 Mar 2021 09:18:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 1:22 PM, Tim Rice wrote:
> Hey all,
> 
> Sorry if this isn't the right place to report Iproute2 bugs. It was
> implied by README.devel as well as a couple of entries I saw in bugzilla.
> 
> I use iproute2 batch mode to construct network namespaces. Example script:
> 
>   $ cat ~/bin/netns-test.sh
>   #! /bin/bash
> 
>   gw=192.168.5.1
>   ip=192.168.5.2
>   ns=netns-test
>   veth0=${ns}-0
>   veth1=${ns}-1
> 
>   /usr/local/sbin/ip -b - << EOF
>   link add $veth0 type veth peer name $veth1
>   addr add $gw peer $ip dev $veth0
>   link set dev $veth0 up
>   netns add $ns
>   link set $veth1 netns $ns
>   netns exec $ns ip link set dev lo up
>   netns exec $ns ip link set dev $veth1 up
>   netns exec $ns ip addr add $ip/24 dev $veth1
>   netns exec $ns ip addr add $ip peer $gw dev $veth1
>   netns exec $ns ip route add default via $gw dev $veth1
>   netns exec $ns ip route add 192.168.0.0/24 via $gw dev $veth1
>   EOF
> 
> 
> I noticed when version 5.11.0 dropped that this stops working. Batch
> mode fails to bring up the inner veth.
> 
> Expected usage (as produced by v5.10.0):
> 
>   $ sudo ./bin/netns-test.sh
>   $ sudo ip netns exec netns-test ip route
>   default via 192.168.5.1 dev netns-test-1
>   192.168.0.0/24 via 192.168.5.1 dev netns-test-1
>   192.168.5.0/24 dev netns-test-1 proto kernel scope link src 192.168.5.2
>   192.168.5.1 dev netns-test-1 proto kernel scope link src 192.168.5.2
> 
> Actual behaviour:
> 
>   $ sudo ./bin/netns-test.sh
>   $ sudo ip netns exec netns-test ip route  # Notice the empty output
>   $ sudo ip netns exec netns-test ip link
>   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
> mode DEFAULT group default qlen 1000
>       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>   39: netns-test-1@if40: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state
> DOWN mode DEFAULT group default qlen 1000
>       link/ether 1a:96:4e:4f:84:31 brd ff:ff:ff:ff:ff:ff link-netnsid 0
> 
> System info:
> 
> * Distro: Void Linux
> * Kernel version: 5.10.23
> * CPU: AMD Ryzen 7 1800X and Ryzen 5 2600. (Reproduced on both.)
> 
> Git bisect pinpoints this commit:
> https://github.com/shemminger/iproute2/commit/1d9a81b8c9f30f9f4abeb875998262f61bf10577
> 

Petr, can you take a look at this regression?

