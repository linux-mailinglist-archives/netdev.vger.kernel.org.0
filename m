Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0DD34FA9B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhCaHnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:43:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:45750 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhCaHmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 03:42:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DD27B20571;
        Wed, 31 Mar 2021 09:42:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AejTVs5M9keI; Wed, 31 Mar 2021 09:42:31 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4728320561;
        Wed, 31 Mar 2021 09:42:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 09:42:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 09:42:30 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9861E31804DE; Wed, 31 Mar 2021 09:42:30 +0200 (CEST)
Date:   Wed, 31 Mar 2021 09:42:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Safonov <dima@arista.com>
CC:     <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        <syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xfrm/compat: Cleanup WARN()s that can be user-triggered
Message-ID: <20210331074230.GE62598@gauss3.secunet.de>
References: <20210329232506.232142-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210329232506.232142-1-dima@arista.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 12:25:06AM +0100, Dmitry Safonov wrote:
> Replace WARN_ONCE() that can be triggered from userspace with
> pr_warn_once(). Those still give user a hint what's the issue.
> 
> I've left WARN()s that are not possible to trigger with current
> code-base and that would mean that the code has issues:
> - relying on current compat_msg_min[type] <= xfrm_msg_min[type]
> - expected 4-byte padding size difference between
>   compat_msg_min[type] and xfrm_msg_min[type]
> - compat_policy[type].len <= xfrma_policy[type].len
> (for every type)
> 
> Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
> Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Safonov <dima@arista.com>

Applied, thanks Dmitry!
