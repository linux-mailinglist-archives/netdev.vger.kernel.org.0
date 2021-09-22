Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B05414EFD
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhIVR1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236716AbhIVR1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=25lGIVYtKt3kH1kWTNrr/qFisdmByWs8m8B7PEwB7yQ=;
        b=abXgpKfHs2mXBli1SkJJRtQ4tSNB6ogaz7n/PGMMJx0gDUBzxhaGo9E7j89AmFokTi0ClL
        mQWqxeE9ahZ0GfvrKJKDO0OjdzijYsdoNEfPEUgVKYM9KyAey9bBSWGnbizV2CO8zS2onq
        Lj5jHFpi4ChOOKlJ/EhCR4fnF0hNZ0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-QM5rgveEOg-MnWOc20chRg-1; Wed, 22 Sep 2021 13:26:02 -0400
X-MC-Unique: QM5rgveEOg-MnWOc20chRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E6DD814707;
        Wed, 22 Sep 2021 17:26:00 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.9.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 169841972D;
        Wed, 22 Sep 2021 17:25:31 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>
Cc:     Cai Huoqing <caihuoqing@baidu.com>, linux-audit@redhat.com,
        strace development discussions <strace-devel@lists.strace.io>,
        linux-api@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ldv@strace.io
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header files
Date:   Wed, 22 Sep 2021 13:25:29 -0400
Message-ID: <1710508.VLH7GnMWUR@x2>
Organization: Red Hat
In-Reply-To: <AZHUZQ.4E5G2GAEGJ0U@crapouillou.net>
References: <20210813120803.101-1-caihuoqing@baidu.com> <20210902160840.GA2220@asgard.redhat.com> <AZHUZQ.4E5G2GAEGJ0U@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, September 22, 2021 1:01:58 PM EDT Paul Cercueil wrote:
> >> IPX is marked obsolete for serveral years. so remove it and the
> >> dependency in linux tree.
> >> I'm sorry to not thinking about linux-audit and strace.
> >> Might you remove the dependency or make the part of the code.
> >> Many thanks.
> > 
> > Unfortunately, that is not how UAPI works.  That change breaks
> > building
> > of the existing code;  one cannot change already released versions
> > of either audit, strace, or any other userspace program that happens
> > to unconditionally include <linux/ipx.h> without any fallback (like
> > <netipx/ipx.h> provided by glibc).
> 
> Also, the <netipx/ipx.h> fallback is only provided by glibc (and maybe
> uclibc?). With this patch, it is now impossible to compile even the
> very latest version of "strace" with a musl toolchain.

I've made support for ipx optional in audit user space a couple weeks back. 
It's no longer a problem for us.

-Steve


