Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7B3B7DA1
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 08:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhF3Gxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 02:53:39 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:39710 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhF3Gxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 02:53:38 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id B63B7800051;
        Wed, 30 Jun 2021 08:51:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 08:51:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 08:51:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0182E318040F; Wed, 30 Jun 2021 08:51:07 +0200 (CEST)
Date:   Wed, 30 Jun 2021 08:51:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <0x7f454c46@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net: xfrm: fix memory leak in xfrm_user_rcv_msg
Message-ID: <20210630065107.GT40979@gauss3.secunet.de>
References: <20210625102354.18266-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210625102354.18266-1-paskripkin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 01:23:54PM +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in xfrm_user_rcv_msg(). The
> problem was is non-freed skb's frag_list.
> 
> In skb_release_all() skb_release_data() will be called only
> in case of skb->head != NULL, but netlink_skb_destructor()
> sets head to NULL. So, allocated frag_list skb should be
> freed manualy, since consume_skb() won't take care of it
> 
> Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
> Reported-and-tested-by: syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Applied, thanks a lot!
