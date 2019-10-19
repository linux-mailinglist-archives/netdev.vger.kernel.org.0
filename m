Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6EFDD5AD
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfJSALB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 20:11:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35618 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbfJSALB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 20:11:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so4812011pfw.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 17:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=C4QIMI4guzd7x3IuAQwfn5G5+8wN2B8Pny7JIPX4E9s=;
        b=XmR6aBYtQuq6647pzZRAK2Zs2MVwEzyn9LG5QNDy5Swi2Le9wO3jfn6VNeCVFi7Ebz
         EDa9FwrKkvjwKcyEkNRNRtgnClXeW6p3I6CayCZ2Zys9V1hxe5sOBd+VhADNSDEB/3kr
         QNGHzITDgyde8BefSI9dpsOu+xwOeCICOldmqEhOmLLoTcSZzYaQQnh8nLCAE3Dvcg5e
         qH1069xJ5UbTYu2ZoemvlLt0n/zkjLxgr762gw5GW0Lwc85YVs5jwr6H/f65rNlNiZlp
         5cTLT7wkoFd2p8TaHTT/CyfTXtGw/B5IL9zU+gG/TetmWJOgbFQ+sqMZgFBsY4qpYt3n
         C7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=C4QIMI4guzd7x3IuAQwfn5G5+8wN2B8Pny7JIPX4E9s=;
        b=Yr1+k2JPiYoxjA0rwlyK6XBGUMgckQJ5Lu2++bSCMWyVQmwCWpp8++6ybOy0vcKypU
         qJsZYbX60e4gp+B032GTBhoCx2InFyEsjuqPPyovPxVzyiBr8NkXhjwC2J/mvSRUve7P
         uU8h40UudKaVDNfNfeNKxpoqtcq0DEoE3zpkSn+Ks/1tKT/VvRhbtyiLS3zGxSG7GwrI
         nBOGZ7Nxl8pGU+kpeXewWzjTCj8YIOXwPtEeafofZaxn/mKzIztoYvD/zvlgT29bjaVO
         e5VBgCr49rNeDMzCTwEWABelC6ek4ulziVt073Go8KjU3IC5G12QZ1nXzTd6ntITNEFq
         KXpg==
X-Gm-Message-State: APjAAAU0APPtKDNXfGbCxrHzjpGTwAznt2LqqZvcu6scVehJubuWIljE
        aHrDVhMN9sesP+bp7l2ns/M=
X-Google-Smtp-Source: APXvYqwI6NNYtGAB2Js8a9Sb22eJSVqslYKBr3dL0RC8qBABMoQezewv0sFIVkTrM8YOXVLlvQrbvw==
X-Received: by 2002:a17:90a:3acb:: with SMTP id b69mr14378245pjc.75.1571443860520;
        Fri, 18 Oct 2019 17:11:00 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id o42sm6511697pjo.32.2019.10.18.17.10.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 17:10:59 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     ilias.apalodimas@linaro.org, "Tariq Toukan" <tariqt@mellanox.com>,
        brouer@redhat.com, Netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>
Subject: Re: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Date:   Fri, 18 Oct 2019 17:10:58 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <7C9F38DB-6164-4ACB-A717-1699ACC9DCB0@gmail.com>
In-Reply-To: <7852500cd0008893985094fa20e2790436391e49.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-2-jonathan.lemon@gmail.com>
 <7852500cd0008893985094fa20e2790436391e49.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was running the updated patches on machines with various workloads, and
have a bunch of different results.

For the following numbers,
  Effective = hit / (hit + empty + stall) * 100

In other words, show the hit rate for for every trip to the cache,
and the cache full stat is ignored.

On a webserver:

[web] # ./eff
('rx_pool_cache_hit:', '360127643')
('rx_pool_cache_full:', '0')
('rx_pool_cache_empty:', '6455735977')
('rx_pool_ring_produce:', '474958')
('rx_pool_ring_consume:', '0')
('rx_pool_ring_return:', '474958')
('rx_pool_flush:', '144')
('rx_pool_node_change:', '0')
cache effectiveness:  5.28

On a proxygen:
# ethtool -S eth0 | grep rx_pool
     rx_pool_cache_hit: 1646798
     rx_pool_cache_full: 0
     rx_pool_cache_empty: 15723566
     rx_pool_ring_produce: 474958
     rx_pool_ring_consume: 0
     rx_pool_ring_return: 474958
     rx_pool_flush: 144
     rx_pool_node_change: 0
cache effectiveness:  9.48

On both of these, only pages with refcount = 1 are being kept.


I changed things around in the page pool so:

1) the cache behaves like a ring instead of a stack, this
   sacrifices temporal locality.

2) it caches all pages returned regardless of refcount, but
   only returns pages with refcount=1.

This is the same behavior as the mlx5 cache.  Some gains
would come about if the sojourn time though the cache is
greater than the lifetime of the page usage by the networking
stack, as it provides a fixed working set of mapped pages.

On the web server, this is a net loss:
[web] # ./eff
('rx_pool_cache_hit:', '6052662')
('rx_pool_cache_full:', '156355415')
('rx_pool_cache_empty:', '409600')
('rx_pool_cache_stall:', '302787473')
('rx_pool_ring_produce:', '156633847')
('rx_pool_ring_consume:', '9925520')
('rx_pool_ring_return:', '278788')
('rx_pool_flush:', '96')
('rx_pool_node_change:', '0')
cache effectiveness:  1.95720846778

For proxygen on the other hand, it's a win:
[proxy] # ./eff
('rx_pool_cache_hit:', '69235177')
('rx_pool_cache_full:', '35404387')
('rx_pool_cache_empty:', '460800')
('rx_pool_cache_stall:', '42932530')
('rx_pool_ring_produce:', '35717618')
('rx_pool_ring_consume:', '27879469')
('rx_pool_ring_return:', '404800')
('rx_pool_flush:', '108')
('rx_pool_node_change:', '0')
cache effectiveness:  61.4721608624

So the correct behavior isn't quite clear cut here - caching a
working set of mapped pages is beneficial in spite of the HOL
blocking stalls for some workloads, but I'm sure that it wouldn't
be too difficult to exceed the WS size.

Thoughts?
-- 
Jonathan

