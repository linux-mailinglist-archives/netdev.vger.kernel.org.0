Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976163FF0C2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346091AbhIBQJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346072AbhIBQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630598932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GSpEDr48SFMamWq8zs4iNuq1IKQ5SNS2nRQshqJ9RkY=;
        b=eAXU+vjrHD8bDUXYslFabS9qVTfKAUnaBjwYX88SMp+RM+6MqX++DYHR5M+5DBYnpQsd7J
        4m7Kaekrl4L3iElym/VTN4zUmlM4HtUccbnjxtjgVNh+Jw3CjkGrRBZbXr56yY6+2B6rFn
        SuD6XlCwnXpfA+oOM0I5a2piuIN828s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-p8V3IUfjMrCKAJvZJcwcTw-1; Thu, 02 Sep 2021 12:08:49 -0400
X-MC-Unique: p8V3IUfjMrCKAJvZJcwcTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76666195D563;
        Thu,  2 Sep 2021 16:08:47 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8976419C46;
        Thu,  2 Sep 2021 16:08:43 +0000 (UTC)
Date:   Thu, 2 Sep 2021 18:08:40 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        strace development discussions <strace-devel@lists.strace.io>,
        linux-api@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ldv@strace.io
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header
 files
Message-ID: <20210902160840.GA2220@asgard.redhat.com>
References: <20210813120803.101-1-caihuoqing@baidu.com>
 <20210901160244.GA5957@asgard.redhat.com>
 <20210901165202.GA4518@asgard.redhat.com>
 <1797920.tdWV9SEqCh@x2>
 <20210902133529.GA32500@LAPTOP-UKSR4ENP.internal.baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902133529.GA32500@LAPTOP-UKSR4ENP.internal.baidu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 09:35:29PM +0800, Cai Huoqing wrote:
> On 01 Sep 21 13:36:54, Steve Grubb wrote:
> > Hello,
> > 
> > Thanks for the heads up.
> > 
> > On Wednesday, September 1, 2021 12:52:02 PM EDT Eugene Syromiatnikov wrote:
> > > Adding linux-audit, strace-devel, and linux-api to CC:.
> > > 
> > > On Wed, Sep 01, 2021 at 06:02:44PM +0200, Eugene Syromiatnikov wrote:
> > > > On Fri, Aug 13, 2021 at 08:08:02PM +0800, Cai Huoqing wrote:
> > > > > commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> > > > > indicated the ipx network layer as obsolete in Jan 2018,
> > > > > updated in the MAINTAINERS file
> > > > > 
> > > > > now, after being exposed for 3 years to refactoring, so to
> > > > > delete uapi/linux/ipx.h and net/ipx.h header files for good.
> > > > > additionally, there is no module that depends on ipx.h except
> > > > > a broken staging driver(r8188eu)
> > > > > 
> > > > > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> > > > 
> > > > This removal breaks audit[1] and potentially breaks strace[2][3], at
> > > > least.
> > 
> > I wouldn't say breaks so much as needs coordination with. :-)   If ipx is 
> > being dropped in its entirety, I can just make that part of the code 
> > conditional to the header existing.
> > 
> > -Steve
> IPX is marked obsolete for serveral years. so remove it and the
> dependency in linux tree.
> I'm sorry to not thinking about linux-audit and strace.
> Might you remove the dependency or make the part of the code.
> Many thanks.

Unfortunately, that is not how UAPI works.  That change breaks building
of the existing code;  one cannot change already released versions
of either audit, strace, or any other userspace program that happens
to unconditionally include <linux/ipx.h> without any fallback (like
<netipx/ipx.h> provided by glibc).

> 
> -Cai
> > 
> > > > [1]
> > > > https://github.com/linux-audit/audit-userspace/blob/ce58837d44b7d9fcb4e1
> > > > 40c23f68e0c94d95ab6e/auparse/interpret.c#L48 [2]
> > > > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > > > d7106d6b/src/net.c#L34 [3]
> > > > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > > > d7106d6b/src/sockaddr.c#L30
> > 
> > 
> > 
> > 
> 

