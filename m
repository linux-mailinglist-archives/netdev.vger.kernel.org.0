Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956EF5583D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfFYT7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:59:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfFYT7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 15:59:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31BED550BB;
        Tue, 25 Jun 2019 19:59:19 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F29A1001B05;
        Tue, 25 Jun 2019 19:59:17 +0000 (UTC)
Date:   Tue, 25 Jun 2019 21:59:12 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     ssuryaextr@gmail.com, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Use return value of inet_iif() for
 __raw_v4_lookup in the while loop
Message-ID: <20190625215912.7f95ac1a@redhat.com>
In-Reply-To: <20190625.124738.1945131933038317898.davem@davemloft.net>
References: <20190625001406.6437-1-ssuryaextr@gmail.com>
        <20190625.124738.1945131933038317898.davem@davemloft.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 25 Jun 2019 19:59:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 12:47:38 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Suryaputra <ssuryaextr@gmail.com>
> Date: Mon, 24 Jun 2019 20:14:06 -0400
> 
> > In commit 19e4e768064a8 ("ipv4: Fix raw socket lookup for local
> > traffic"), the dif argument to __raw_v4_lookup() is coming from the
> > returned value of inet_iif() but the change was done only for the first
> > lookup. Subsequent lookups in the while loop still use skb->dev->ifIndex.
> > 
> > Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>  
> 
> Applied and queued up for -stable.
> 
> I added the appropriate Fixes: tag, please do so next time.

I was about to point that out, but then I noticed that this
doesn't actually fix 19e4e768064a8 ("ipv4: Fix raw socket lookup for
local traffic"), it's just related as it fixes the same issue in
another (very likely) path in the same function.

I think this should have been:
	Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

I *guess* for -stable purposes the effect is the same.

-- 
Stefano
