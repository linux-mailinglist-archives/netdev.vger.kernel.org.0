Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD45639CA8F
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 20:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFES7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 14:59:49 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:44640 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFES7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 14:59:48 -0400
Received: by mail-oi1-f173.google.com with SMTP id d21so13441461oic.11
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/Cd7gosmrjTEifjB0QXLp6J3scNCjAKkHX0bFnjXAQ=;
        b=D4KKrs3DLTR258o6w7HYC/SqqDg6wDuq+kWuXzKsmWFAyBewHAD/H5tQ/48jDimWU6
         wpi8WLhhSPsRsdYS+zbRIRf0cJ+ngRVWmm1cqZ/hx4V1nEBi1a7QczzGh7B014KoID5h
         d6LpZnC4Nv1SWtH8QM1UAl2Bop3ZZzVyTzTEcJgKwsOnfnRyTC+D3MvMctkkTgRIvgpF
         +VuIW25DtAs02aG035X0uDjybkX3KYxdyUrUnIqXW60RyUfaEakAJFpQSPFKDJKYjabp
         p0Zti59jCSGKMmZHf3lPqyHsic6dkWZl2dCrWJv0GB1H7KU8DkZfgiN+DVbYherELMP7
         QAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/Cd7gosmrjTEifjB0QXLp6J3scNCjAKkHX0bFnjXAQ=;
        b=aczjRCOYlkr9eNrDypPCXWOPB9TKFbLWIKgNQfFN+aHiPMlA6slFU4bVCHNjQtDQOr
         aABuNsZJtz3ufE15XWmAJ2TNyQ1YE3Z9XUKR/QeO2DbLK+Av8AZivdx3Br9Fqo8wpE+C
         yK0leSWlfoAPdH4CR9Z8Y8cemYZqpQfGtPOx0sv7ZoWHag/7fCO4lpPzmUXLLA2gk1CB
         fJT6yWv2k6+qw5nYvmGR67UcZGJN3u5De+s+Psu8Vj2ovzuP5bTSv4soHrLa+n36v5Rv
         Z/hSiAhdU8kA8CR3WzmDzMOJyJfOx1uzKr1Y6X7FDicwDDKjbfIFqhsQAiZ6KgbgV8hq
         iUrw==
X-Gm-Message-State: AOAM530tSpp1A/QeU1yKorIIXFPM7M/aTHkNThZSB/mrXu/c4n6NmPib
        2uuy1djI4GDS3z2SQF7/KHY=
X-Google-Smtp-Source: ABdhPJweCmlh4FNpYWHgOeoH8wk07vVY7CI36WMy2ZNC4DNdcPjjpAZfpOvZkibLTd6ZHn+uQNsFoA==
X-Received: by 2002:aca:ead4:: with SMTP id i203mr14925680oih.74.1622919420331;
        Sat, 05 Jun 2021 11:57:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id z25sm1255808oic.30.2021.06.05.11.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 11:56:59 -0700 (PDT)
Subject: Re: VRF/IPv4/ARP: unregister_netdevice waiting for dev to become free
 -> Who's responsible for releasing dst_entry created by ip_route_input_noref?
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
References: <20cd265b-d52d-fd1f-c47e-bfa7ea15518f@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <373ad07f-71c9-a10d-d870-5e9a2c8a8502@gmail.com>
Date:   Sat, 5 Jun 2021 12:56:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20cd265b-d52d-fd1f-c47e-bfa7ea15518f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/5/21 11:16 AM, Oliver Herms wrote:
> Hi everyone,
> 
> I'm observing an device unregistration issue when I try to delete a VRF interface after using the VRF.
> The issue is reproducible on 5.12.9, 5.10.24, 5.11.0-18 (debian).
> 
> Here are the steps to reproduce the issue:
> 
> ip addr add 10.0.0.1/32 dev lo
> ip netns add test-ns
> ip link add veth-outside type veth peer name veth-inside
> ip link add vrf-100 type vrf table 1100
> ip link set veth-outside master vrf-100
> ip link set veth-inside netns test-ns
> ip link set veth-outside up
> ip link set vrf-100 up
> ip route add 10.1.1.1/32 dev veth-outside table 1100
> ip netns exec test-ns ip link set veth-inside up
> ip netns exec test-ns ip addr add 10.1.1.1/32 dev veth-inside
> ip netns exec test-ns ip route add 10.0.0.1/32 dev veth-inside
> ip netns exec test-ns ip route add default via 10.0.0.1
> ip netns exec test-ns ping 10.0.0.1 -c 1 -i 1
> sleep 10
> ip link set veth-outside nomaster
> ip link set vrf-100 down
> ip link delete vrf-100 <= Never returns
> 

thanks for the quick reproducer; I will take a look.

