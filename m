Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6AE3FDF4B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343918AbhIAQD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244539AbhIAQDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630512173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xMRtrXe3M1vVJaRkGQ5o+yZQJhadRFN9gcbbCnaAFSQ=;
        b=Jhn3nucxdtKqXDNoS+RCOHkN2VZR/vkwJeKU+N6m6jF7HubaR7sWCX6gpBoBuiTg1vvoxM
        Avvym3A3K7hkIEIYH1PtBCI3/KK1bQ6kqaPU5WnbhdWuVJ3U0cHS00GQweq35w1al7/Hu/
        nFIQg3FrCq8aBe1E4gS28rZjwfLk7TY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-_faMLM-vMfSyd6CWe7D1pA-1; Wed, 01 Sep 2021 12:02:50 -0400
X-MC-Unique: _faMLM-vMfSyd6CWe7D1pA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9978719611A2;
        Wed,  1 Sep 2021 16:02:49 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46EB45E253;
        Wed,  1 Sep 2021 16:02:47 +0000 (UTC)
Date:   Wed, 1 Sep 2021 18:02:44 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv@strace.io
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header
 files
Message-ID: <20210901160244.GA5957@asgard.redhat.com>
References: <20210813120803.101-1-caihuoqing@baidu.com>
 <20210813120803.101-2-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813120803.101-2-caihuoqing@baidu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 08:08:02PM +0800, Cai Huoqing wrote:
> commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> indicated the ipx network layer as obsolete in Jan 2018,
> updated in the MAINTAINERS file
> 
> now, after being exposed for 3 years to refactoring, so to
> delete uapi/linux/ipx.h and net/ipx.h header files for good.
> additionally, there is no module that depends on ipx.h except
> a broken staging driver(r8188eu)
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

This removal breaks audit[1] and potentially breaks strace[2][3], at least.

[1] https://github.com/linux-audit/audit-userspace/blob/ce58837d44b7d9fcb4e140c23f68e0c94d95ab6e/auparse/interpret.c#L48
[2] https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07ed7106d6b/src/net.c#L34
[3] https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07ed7106d6b/src/sockaddr.c#L30

