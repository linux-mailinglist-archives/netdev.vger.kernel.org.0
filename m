Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922381B3B3D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgDVJZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:25:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43026 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgDVJZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 05:25:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 077B920512;
        Wed, 22 Apr 2020 11:25:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ba3uRmyZSFxo; Wed, 22 Apr 2020 11:25:15 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9A61C201AA;
        Wed, 22 Apr 2020 11:25:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 22 Apr 2020 11:25:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Apr
 2020 11:25:15 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D4EFE3180096;
 Wed, 22 Apr 2020 11:25:14 +0200 (CEST)
Date:   Wed, 22 Apr 2020 11:25:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCHv2 ipsec] esp4: support ipv6 nexthdrs process for beet gso
 segment
Message-ID: <20200422092514.GW13121@gauss3.secunet.de>
References: <234f0732bd3bff63ea88febcd4107a32ac4d9f95.1587283862.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <234f0732bd3bff63ea88febcd4107a32ac4d9f95.1587283862.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 04:11:02PM +0800, Xin Long wrote:
> For beet mode, when it's ipv6 inner address with nexthdrs set,
> the packet format might be:
> 
>     ----------------------------------------------------
>     | outer  |     | dest |     |      |  ESP    | ESP |
>     | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> Before doing gso segment in xfrm4_beet_gso_segment(), the same
> thing is needed as it does in xfrm6_beet_gso_segment() in last
> patch 'esp6: support ipv6 nexthdrs process for beet gso segment'.
> 
> v1->v2:
>   - remove skb_transport_offset(), as it will always return 0
>     in xfrm6_beet_gso_segment(), thank Sabrina's check.
> 
> Fixes: 384a46ea7bdc ("esp4: add gso_segment for esp4 beet mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thanks!
