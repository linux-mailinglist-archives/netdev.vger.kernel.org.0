Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C140694D
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 11:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhIJJwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 05:52:04 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54830 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhIJJwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 05:52:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 236A62058E;
        Fri, 10 Sep 2021 11:50:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SecrLvBUU0ec; Fri, 10 Sep 2021 11:50:49 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3439D20422;
        Fri, 10 Sep 2021 11:50:49 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 2B50A80004A;
        Fri, 10 Sep 2021 11:50:49 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 10 Sep 2021 11:50:48 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Fri, 10 Sep
 2021 11:50:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 668453183C70; Fri, 10 Sep 2021 11:50:48 +0200 (CEST)
Date:   Fri, 10 Sep 2021 11:50:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net: xfrm: fix shift-out-of-bounds in xfrm_get_default
Message-ID: <20210910095048.GL2319818@gauss3.secunet.de>
References: <20210902190400.5257-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210902190400.5257-1-paskripkin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:04:00PM +0300, Pavel Skripkin wrote:
> Syzbot hit shift-out-of-bounds in xfrm_get_default. The problem was in
> missing validation check for user data.
> 
> up->dirmask comes from user-space, so we need to check if this value
> is less than XFRM_USERPOLICY_DIRMASK_MAX to avoid shift-out-of-bounds bugs.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Reported-and-tested-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Applied, thanks Pavel!
