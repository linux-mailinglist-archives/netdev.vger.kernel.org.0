Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F137F69
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfFFVSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbfFFVSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:18:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BA3730C0DC6;
        Thu,  6 Jun 2019 21:18:42 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E5A07E66B;
        Thu,  6 Jun 2019 21:18:38 +0000 (UTC)
Date:   Thu, 6 Jun 2019 23:18:34 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190606231834.72182c33@redhat.com>
In-Reply-To: <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 06 Jun 2019 21:18:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 14:57:33 -0600
David Ahern <dsahern@gmail.com> wrote:

> > This will cause a non-trivial conflict with commit cc5c073a693f
> > ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> > an equivalent patch against net-next, if it helps.
> >   
> 
> Thanks for doing this. It is on my to-do list.
> 
> Can you do the same for IPv4?

You mean this same fix? On IPv4, for flushing, iproute2
uses /proc/sys/net/ipv4/route/flush in iproute_flush_cache(), and that
works.

Listing doesn't work instead, for some different reason I haven't
looked into yet. That doesn't look as critical as the situation on IPv6
where one can't even flush the cache: exceptions can also be fetched
with 'ip route get', and that works.

Still, it's bad, I can look into it within a few days.

-- 
Stefano
