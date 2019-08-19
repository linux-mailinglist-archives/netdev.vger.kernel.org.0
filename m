Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35389210F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 12:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfHSKM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 06:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20171 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfHSKM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 06:12:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 173DD10B78;
        Mon, 19 Aug 2019 10:12:59 +0000 (UTC)
Received: from localhost (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D94C19C58;
        Mon, 19 Aug 2019 10:12:56 +0000 (UTC)
Date:   Mon, 19 Aug 2019 12:12:52 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     gnault@redhat.com, haliu@redhat.com, edumazet@google.com,
        linus.luessing@c0d3.blue, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Fix return value of ipv6_mc_may_pull() for
 malformed packets
Message-ID: <20190819121252.5fccbef2@redhat.com>
In-Reply-To: <20190814.125858.37782529545578263.davem@davemloft.net>
References: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
        <20190814.125858.37782529545578263.davem@davemloft.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 19 Aug 2019 10:12:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 14 Aug 2019 12:58:58 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Stefano Brivio <sbrivio@redhat.com>
> Date: Tue, 13 Aug 2019 00:46:01 +0200
> 
> > Commit ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and
> > ipv6_mc_check_mld() calls") replaces direct calls to pskb_may_pull()
> > in br_ipv6_multicast_mld2_report() with calls to ipv6_mc_may_pull(),
> > that returns -EINVAL on buffers too short to be valid IPv6 packets,
> > while maintaining the previous handling of the return code.
> > 
> > This leads to the direct opposite of the intended effect: if the
> > packet is malformed, -EINVAL evaluates as true, and we'll happily
> > proceed with the processing.
> > 
> > Return 0 if the packet is too short, in the same way as this was
> > fixed for IPv4 by commit 083b78a9ed64 ("ip: fix ip_mc_may_pull()
> > return value").
> > 
> > I don't have a reproducer for this, unlike the one referred to by
> > the IPv4 commit, but this is clearly broken.
> > 
> > Fixes: ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and ipv6_mc_check_mld() calls")
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>  
> 
> Applied and queued up for -stable.

I don't see this on net.git, but it's in your stable bundle on
Patchwork. Should I resend? Thanks.

-- 
Stefano
