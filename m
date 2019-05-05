Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8814199
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfEERno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:43:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41111 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:43:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id z3so1561803pgp.8
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R/dcNNnT920ZoXxSnvm0Vz8TqJ26z0S4LxIoiog6aLY=;
        b=Q/sq8ohkC4FAFKK/RTYlOc0Z0fVUR6Z/DlmhXIW8yWw0Crtcgxw0hsuTvP08R/CDco
         UwImcaZuy3HYDNdLsGieMFX2j3yp7lDyAAuFHxZfxez8yP0QkWd7icmGkEQXLN0dmrYT
         lkRdGsfZog1Xyl9xEVUY79PX0aevjSd9Rq6ZETuR9NJPUtveropXZdvzwXI7cHAUAjKB
         ZBS97T7apDjoXDsf59iiY0S04L4wbF9867gQ/rp3XPJ7bF8sj9z+hsa0w46zrShmFsEE
         UVtQoDPKb+q0RR0mejh4+4dLMf0lVY8r/Hxd9KqH4rvJ+ZoIN87rAgsvEz4XUuXHR9XC
         EsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R/dcNNnT920ZoXxSnvm0Vz8TqJ26z0S4LxIoiog6aLY=;
        b=JQjZb/vPBO7FXsuVu3keJQ8eYxsALySdY6kgG8j1KiZoHmX06kOK27ZVzxyf96f9ge
         4ugyyc3WspgUnOLK1E52j4pAJm4z4isvl0go6kcjcUgbj0PFHsk6NpPv9SBKDu2WGTBt
         qu34W6XeVf0fbuxIGLgLP9tFwbsGqk73UVzssa7Dn1t+kp3QK3aLH59aZ38mu5ClA1yx
         Qbi8eKjyI4v5qRQHkQqxfORiUJxI+tLbIgdq8520CBpR13DcO2v9N9JGTtEWnA6YyA5n
         r1MuP2qd0IeXn2p2ZM6hV6BFTA41PGllb8jZuEuFXWOJj1hk529PU08txP5RH3CC1xJ3
         CvoA==
X-Gm-Message-State: APjAAAXOUHJ4B7HFWm/22rdkVxnhmrtCHp7w9HEqiqXkdgLiqoIEGb0g
        vNGc0aG6Z5F1oD+Zo8+0ENc=
X-Google-Smtp-Source: APXvYqxkg7H5hQK/4kpVmE6J1KMRQD3OLKQA3tNq0k981+YC+73Oz1+Gs4eYXqUw3J8xgNS9+Y+T0g==
X-Received: by 2002:a65:5c44:: with SMTP id v4mr25390314pgr.32.1557078223529;
        Sun, 05 May 2019 10:43:43 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5976:65bd:e145:32dc? ([2601:282:800:fd80:5976:65bd:e145:32dc])
        by smtp.googlemail.com with ESMTPSA id u66sm10794373pfb.76.2019.05.05.10.43.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:43:42 -0700 (PDT)
Subject: Re: [PATCH v2 net] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, alan.maguire@oracle.com,
        jwestfall@surrealistic.net
References: <20190503155501.28182-1-dsahern@kernel.org>
 <20190505.104248.1454328009154159060.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <77633c9c-7f44-fc0f-47e2-7f7f9df6872b@gmail.com>
Date:   Sun, 5 May 2019 11:43:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190505.104248.1454328009154159060.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/19 11:42 AM, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Fri,  3 May 2019 08:55:01 -0700
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
>> INADDR_ANY, but neigh_xmit which is used for MPLS encapsulations was not
>> updated to use the altered key. The result is that every packet Tx does
>> a lookup on the gateway address which does not find an entry, a new one
>> is created only to find the existing one in the table right before the
>> insert since arp_constructor was updated to reset the primary key. This
>> is seen in the allocs and destroys counters:
>>     ip -s -4 ntable show | head -10 | grep alloc
>>
>> which increase for each packet showing the unnecessary overhread.
>>
>> Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.
>> Define __ipv4_neigh_lookup_noref in case CONFIG_INET is not set.
>>
>> v2
>> - define __ipv4_neigh_lookup_noref in case CONFIG_INET is not set as
>>   reported by kbuild test robot
>>
>> Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
>> Reported-by: Alan Maguire <alan.maguire@oracle.com>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
> 
> Double signoff and this patch doesn't apply to the net tree.
> 

oops on the double signoff; you actually took v1 so I need to send a delta.
