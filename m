Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16551A64
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbfFXSVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfFXSVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 14:21:08 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EF7930833AF;
        Mon, 24 Jun 2019 18:21:08 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C312C5C231;
        Mon, 24 Jun 2019 18:21:02 +0000 (UTC)
Date:   Mon, 24 Jun 2019 20:20:58 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] iproute: Pass RTM_F_CLONED on dump to fetch
 cached routes to be flushed
Message-ID: <20190624202058.47caf759@redhat.com>
In-Reply-To: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
References: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 24 Jun 2019 18:21:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen,

On Sat, 15 Jun 2019 03:33:50 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> With a current (5.1) kernel version, IPv6 exception routes can't be listed
> (ip -6 route list cache) or flushed (ip -6 route flush cache). I'm
> re-introducing kernel support for this, but, to allow the kernel to filter
> routes based on the RTM_F_CLONED flag, we need to make sure this flag is
> always passed when we want cached routes to be dumped.

Support for listing IPv6 route exceptions is now back on net-next,
relevant commits:

564c91f7e563 fib_frontend, ip6_fib: Select routes or exceptions dump from RTM_F_CLONED
ef11209d4219 Revert "net/ipv6: Bail early if user only wants cloned entries"
3401bfb1638e ipv6/route: Don't match on fc_nh_id if not set in ip6_route_del()
bf9a8a061ddc ipv6/route: Change return code of rt6_dump_route() for partial node dumps
1e47b4837f3b ipv6: Dump route exceptions if requested
40cb35d5dc04 ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()

and this iproute2 patch works together with that as it is. Do I need to
re-submit? Thanks.

-- 
Stefano
