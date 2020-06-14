Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074FF1F8AB1
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 22:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgFNUfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 16:35:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726648AbgFNUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 16:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592166912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eDQwvsx6hMB13gWyocZFDvXcBFPxQurPVUXmSPgoBxM=;
        b=ei7sgRem+QHUItt1Wvs5/q8qhTj/gne6JM8nGzXN8l59TovhZDIOXofHz1ckQ0j8JKvepH
        juQNSYkPDqfY/n+IrTsLFVa8YHfT8qPWi3eeY5SXJBlWbFGJw2I2MAgJZjZyYvmGijEQFG
        5c4y+T82GrMAB25ZPj5a/Eo0YOBrqw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-WM2ql_62MzWi8YGLPlhzeA-1; Sun, 14 Jun 2020 16:35:10 -0400
X-MC-Unique: WM2ql_62MzWi8YGLPlhzeA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 381151005512;
        Sun, 14 Jun 2020 20:35:07 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 352495D9C9;
        Sun, 14 Jun 2020 20:35:00 +0000 (UTC)
Date:   Sun, 14 Jun 2020 22:34:56 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Good idea to rename files in include/uapi/ ?
Message-ID: <20200614223456.13807a00@redhat.com>
In-Reply-To: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Jun 2020 21:41:17 +0200
"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Hello there!
>=20
> At the moment one can't checkout a clean working directory w/o any=20
> changed files on a case-insensitive FS as the following file names have=20
> lower-case duplicates:

They are not duplicates: matching extensions are lowercase, target
extensions are uppercase. DSCP is the extension to set DSCP bits, dscp
is the extension to match on those packet bits.

> =E2=9E=9C  linux git:(96144c58abe7) git ls-files |sort -f |uniq -id
> include/uapi/linux/netfilter/xt_CONNMARK.h
> include/uapi/linux/netfilter/xt_DSCP.h
> include/uapi/linux/netfilter/xt_MARK.h
> include/uapi/linux/netfilter/xt_RATEEST.h
> include/uapi/linux/netfilter/xt_TCPMSS.h
> include/uapi/linux/netfilter_ipv4/ipt_ECN.h
> include/uapi/linux/netfilter_ipv4/ipt_TTL.h
> include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> net/netfilter/xt_DSCP.c
> net/netfilter/xt_HL.c
> net/netfilter/xt_RATEEST.c
> net/netfilter/xt_TCPMSS.c
> tools/memory-model/litmus-tests/Z6.0+pooncelock+poonceLock+pombonce.litmus
> =E2=9E=9C  linux git:(96144c58abe7)
>=20
> Also even on a case-sensitive one VIm seems to have trouble with editing=
=20
> both case-insensitively equal files at the same time.

...what trouble exactly?

> I was going to make a patch renaming the respective duplicates, but I'm=20
> not sure:
>=20
> *Is it a good idea to rename files in include/uapi/ ?*

I'm not sure it's a good idea to even use git on a case-insensitive
filesystem. I'm curious, what is your use case?

--=20
Stefano

