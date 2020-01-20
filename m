Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE9E1430DC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgATReO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:34:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34989 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgATReN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:34:13 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so144120plt.2
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 09:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z+QrJanorr9UVl9xK1s8KePFfb6+RvxhEEGhXMh2RWc=;
        b=fWqIPxB6yDZgEx/XW1vmkftNcmNMPONb6f4njQOoEgEM/BmenOdDvRC+yKzwf35AN3
         M4Z/jZBQOyTS8+EkxvdNUrMjvM7nLhtcEswQEWqeS2jcPpNWyZA93N27CF7ar7kGmNgc
         chNWzTR+XtnDK7ZWPXOnHNOFWC2M4TYbFNacm0iSYcwLQrDU26VyAA0IXdOdapapZr+K
         csZYdrPYttDioBTq3W1FRt6oEQp6QZ/MslIcbkpopbb9KHAl1SYfK5lrSWDE6ZE6g0v6
         c5+Xg+SijF3adZrhBdIoRma2/FxBFpwSqG8rGdatFG8w77bCiUyNqHp1sodd1apwNxHT
         /RFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+QrJanorr9UVl9xK1s8KePFfb6+RvxhEEGhXMh2RWc=;
        b=At0ITQNOGKIh8uR2nYyQDmX21mLnhweZvxSnvcrWIoT6DrnHJJe7CwYnaSzFWsPfbd
         EMqMDmNUZfNBgzShbI5tkk6qOEWwp2BvJxse9Qgfe/gbxJzMF+euxglNMlwXLIfPUQ9/
         68gowNUdpxmpumPq8XY4dTmbOGNDUpDzYsclp2f/Hx4LGoreftF4p8o2F5Cxe5db/QiQ
         /lK0+im4fP/QXmjFtndkWK9XrfLW120IMxhWgQQPA7eTMx4f79cTa+AB4DeTHfpppuBy
         64GyEdpCC+7y/JwjwHn2Ms/4C/6jc5zA078y1Dp5h8VwcEopa5ej+sc7KwtOZSpwdnuz
         ICdQ==
X-Gm-Message-State: APjAAAUDT2Pyd7XDiP4zGXAAxM6wdJFzhmSzKwOp0lP0zZfwlZnyzsbI
        0ogow9Xp9K5MJlJ9u2VPCa4mwA==
X-Google-Smtp-Source: APXvYqyhn4daTyL4R3gK2dcVPR+gQluNmWJkuM8JOmX5IeXFHyLb+n/4II6kf5Bnb+zzIWYb9V7/AQ==
X-Received: by 2002:a17:902:8a8d:: with SMTP id p13mr787946plo.159.1579541653086;
        Mon, 20 Jan 2020 09:34:13 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id ep12sm76632pjb.7.2020.01.20.09.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:34:12 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:34:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        George Shuklin <george.shuklin@gmail.com>
Subject: Re: [PATCH iproute2] ip: fix link type and vlan oneline output
Message-ID: <20200120093404.172208c2@hermes.lan>
In-Reply-To: <20200119011251.7153-1-vdronov@redhat.com>
References: <20200119011251.7153-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jan 2020 02:12:51 +0100
Vladis Dronov <vdronov@redhat.com> wrote:

> Move link type printing in print_linkinfo() so multiline output does not
> break link options line. Add oneline support for vlan's ingress and egress
> qos maps.
> 
> Before the fix:
> 
> # ip -details link show veth90.4000
> 5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
>     vlan protocol 802.1Q id 4000 <REORDER_HDR>               the option line is broken ^^^
>       ingress-qos-map { 1:2 }
>       egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> 
> # ip -oneline -details link show veth90.4000
> 5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000\    link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 \    vlan protocol 802.1Q id 4000 <REORDER_HDR>
>       ingress-qos-map { 1:2 }   <<< a multiline output despite -oneline
>       egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> 
> After the fix:
> 
> # ip -details link show veth90.4000
> 5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>     vlan protocol 802.1Q id 4000 <REORDER_HDR>
>       ingress-qos-map { 1:2 }
>       egress-qos-map { 2:1 }
> 
> # ip -oneline -details link show veth90.4000
> 5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000\    link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 \    vlan protocol 802.1Q id 4000 <REORDER_HDR> \      ingress-qos-map { 1:2 } \      egress-qos-map { 2:1 }
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206241
> Reported-by: George Shuklin <george.shuklin@gmail.com>
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>

Applied with changes.
The change to ipaddress.c was incorrect. You can't change the order of things in the
output.

Second, you needed to have a Fixes tag. In this case, it went back to original
vlan support.
