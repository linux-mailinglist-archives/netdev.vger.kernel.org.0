Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4416801CF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394419AbfHBUf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:35:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394395AbfHBUf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 16:35:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38FF25AFE3;
        Fri,  2 Aug 2019 20:35:58 +0000 (UTC)
Received: from elisabeth (ovpn-200-58.brq.redhat.com [10.40.200.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9977B60C4C;
        Fri,  2 Aug 2019 20:35:55 +0000 (UTC)
Date:   Fri, 2 Aug 2019 22:35:49 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
Message-ID: <20190802223549.3f4f387f@elisabeth>
In-Reply-To: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
References: <20190801082900.27216-1-liuhangbin@gmail.com>
        <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 02 Aug 2019 20:35:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

On Thu, 1 Aug 2019 13:51:25 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 8/1/19 2:29 AM, Hangbin Liu wrote:
> > Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
> > if src_addr is not an address on local system.
> > 
> > \# ip route get 1.1.1.1 from 2.2.2.2
> > RTNETLINK answers: Invalid argument  
> 
> so this is a forwarding lookup in which case iif should be set.

On actual forwarding, yes, it will be set.

But if we are just doing a lookup for a route (iif is
LOOPBACK_IFINDEX), I think this should still give us the matching route,
which is what IPv6 already does and what this patch fixes for IPv4.

Otherwise, we have no way to fetch that route, no matter if source
routing is configured. So I think this patch is correct and to some
extent necessary.

-- 
Stefano
