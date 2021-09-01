Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261EF3FE138
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344543AbhIARiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344504AbhIARiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630517822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xhdpu5W1fJXLeojM24bKC1MSSzMuWR+Cf49l2mlXcbA=;
        b=JAS88if+Dj9G5e049lqCm8N5LeL24BxdUlyMGgw5I7CluW8m+KETOHPvlgHk148kT7uXWl
        vPGVcNg5hxh2BJPyQAW3dq4VfoyDnN6bnxdU9aK+T+Ns49Li/gBSnhY0J2buVz1U3voQub
        hxhx5xWjbekg6yPphDqxDZYC5ajlq3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-vPtR8mibOjGdW4PL0N-50A-1; Wed, 01 Sep 2021 13:36:59 -0400
X-MC-Unique: vPtR8mibOjGdW4PL0N-50A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2A7C801A92;
        Wed,  1 Sep 2021 17:36:57 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74C9A5C1BB;
        Wed,  1 Sep 2021 17:36:56 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>,
        Eugene Syromiatnikov <esyr@redhat.com>
Cc:     linux-audit@redhat.com,
        strace development discussions <strace-devel@lists.strace.io>,
        linux-api@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ldv@strace.io
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header files
Date:   Wed, 01 Sep 2021 13:36:54 -0400
Message-ID: <1797920.tdWV9SEqCh@x2>
Organization: Red Hat
In-Reply-To: <20210901165202.GA4518@asgard.redhat.com>
References: <20210813120803.101-1-caihuoqing@baidu.com> <20210901160244.GA5957@asgard.redhat.com> <20210901165202.GA4518@asgard.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thanks for the heads up.

On Wednesday, September 1, 2021 12:52:02 PM EDT Eugene Syromiatnikov wrote:
> Adding linux-audit, strace-devel, and linux-api to CC:.
> 
> On Wed, Sep 01, 2021 at 06:02:44PM +0200, Eugene Syromiatnikov wrote:
> > On Fri, Aug 13, 2021 at 08:08:02PM +0800, Cai Huoqing wrote:
> > > commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> > > indicated the ipx network layer as obsolete in Jan 2018,
> > > updated in the MAINTAINERS file
> > > 
> > > now, after being exposed for 3 years to refactoring, so to
> > > delete uapi/linux/ipx.h and net/ipx.h header files for good.
> > > additionally, there is no module that depends on ipx.h except
> > > a broken staging driver(r8188eu)
> > > 
> > > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> > 
> > This removal breaks audit[1] and potentially breaks strace[2][3], at
> > least.

I wouldn't say breaks so much as needs coordination with. :-)   If ipx is 
being dropped in its entirety, I can just make that part of the code 
conditional to the header existing.

-Steve

> > [1]
> > https://github.com/linux-audit/audit-userspace/blob/ce58837d44b7d9fcb4e1
> > 40c23f68e0c94d95ab6e/auparse/interpret.c#L48 [2]
> > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > d7106d6b/src/net.c#L34 [3]
> > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > d7106d6b/src/sockaddr.c#L30




