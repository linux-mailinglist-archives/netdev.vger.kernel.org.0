Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9455E424CF1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhJGF77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:59:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37766 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhJGF7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:59:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 25CCD2056D;
        Thu,  7 Oct 2021 07:57:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qf5Dxb8xJ5-f; Thu,  7 Oct 2021 07:57:54 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5DC3720538;
        Thu,  7 Oct 2021 07:57:54 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 57BC480004A;
        Thu,  7 Oct 2021 07:57:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:57:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:57:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8B0243183BED; Thu,  7 Oct 2021 07:57:53 +0200 (CEST)
Date:   Thu, 7 Oct 2021 07:57:53 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
CC:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        Eugene Syromyatnikov <evgsyr@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: strace build error static assertion failed: "XFRM_MSG_MAPPING !=
 0x26"
Message-ID: <20211007055753.GR36125@gauss3.secunet.de>
References: <1eb25b8f-09c0-8f5e-3227-f0f318785995@alliedtelesis.co.nz>
 <20211006214816.GA11000@altlinux.org>
 <20211006215124.GB11000@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211006215124.GB11000@altlinux.org>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:51:24AM +0300, Dmitry V. Levin wrote:
> On Thu, Oct 07, 2021 at 12:48:16AM +0300, Dmitry V. Levin wrote:
> > On Wed, Oct 06, 2021 at 09:43:11PM +0000, Chris Packham wrote:
> > > Hi,
> > > 
> > > When compiling strace-5.14 (although it looks like the same problem 
> > > would exist with bleeding edge strace) with headers from the tip of 
> > > Linus's tree (5.15.0-rc4) I get the following error
> > > 
> > > strace: In file included from static_assert.h:11,
> > > strace:                  from print_fields.h:12,
> > > strace:                  from defs.h:1901,
> > > strace:                  from netlink.c:10:
> > > strace: xlat/nl_xfrm_types.h:162:1: error: static assertion failed: 
> > > "XFRM_MSG_MAPPING != 0x26"
> > > strace:  static_assert((XFRM_MSG_MAPPING) == (0x26), "XFRM_MSG_MAPPING 
> > > != 0x26");
> > > strace:  ^~~~~~~~~~~~~
> > > 
> > > It looks like commit 2d151d39073a ("xfrm: Add possibility to set the 
> > > default to block if we have no policy") added some XFRM messages and the 
> > > numbers shifted. Is this considered an ABI breakage?
> > > 
> > > I'm not sure if this is a strace problem or a linux problem so I'm 
> > > reporting it in both places.
> > 
> > Yes, this is already covered by 
> > https://lore.kernel.org/lkml/20210912122234.GA22469@asgard.redhat.com/T/#u
> > 
> > Thanks,
> 
> I wonder, why the fix hasn't been merged yet, though.

That was due to a delay on my side. I've just sent a pull request
with the fix included.
