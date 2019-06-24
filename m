Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCE451969
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfFXRUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:20:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfFXRUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:20:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D65E615063AD3;
        Mon, 24 Jun 2019 10:20:29 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:20:29 -0700 (PDT)
Message-Id: <20190624.102029.1787909800092048267.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     dsahern@gmail.com, jishi@redhat.com, weiwan@google.com,
        kafai@fb.com, edumazet@google.com,
        matti.vaittinen@fi.rohmeurope.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v7 00/11] Fix listing (IPv4, IPv6) and
 flushing (IPv6) of cached route exceptions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 10:20:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Fri, 21 Jun 2019 17:45:19 +0200

> For IPv6 cached routes, the commands 'ip -6 route list cache' and
> 'ip -6 route flush cache' don't work at all after route exceptions have
> been moved to a separate hash table in commit 2b760fcf5cfb ("ipv6: hook
> up exception table to store dst cache").
> 
> For IPv4 cached routes, the command 'ip route list cache' has also
> stopped working in kernel 3.5 after commit 4895c771c7f0 ("ipv4: Add FIB
> nexthop exceptions.") introduced storage for route exceptions as a
> separate entity.
> 
> Fix this by allowing userspace to clearly request cached routes with
> the RTM_F_CLONED flag used as a filter (in conjuction with strict
> checking) and by retrieving and dumping cached routes if requested.
> 
> If strict checking is not requested (iproute2 < 5.0.0), we don't have a
> way to consistently filter results on other selectors (e.g. on tables),
> so skip filtering entirely and dump both regular routes and exceptions.
> 
> For IPv4, cache flushing uses a completely different mechanism, so it
> wasn't affected. Listing of exception routes (modified routes pre-3.5) was
> tested against these versions of kernel and iproute2:
 ...

Series applied, thanks.
