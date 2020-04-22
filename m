Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4241B3B29
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVJYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:24:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:42986 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgDVJYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 05:24:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E7EEA201AA;
        Wed, 22 Apr 2020 11:24:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nipilgQiCoqD; Wed, 22 Apr 2020 11:24:36 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8507120512;
        Wed, 22 Apr 2020 11:24:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Apr 2020 11:24:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Apr
 2020 11:24:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D8DCE3180096; Wed, 22 Apr 2020 11:24:35 +0200 (CEST)
Date:   Wed, 22 Apr 2020 11:24:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCHv2 ipsec] esp6: support ipv6 nexthdrs process for beet gso
 segment
Message-ID: <20200422092435.GV13121@gauss3.secunet.de>
References: <494257e3fab248db52f8dc6e2d0c5924a4c0c4dc.1587283800.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <494257e3fab248db52f8dc6e2d0c5924a4c0c4dc.1587283800.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 04:10:00PM +0800, Xin Long wrote:
> For beet mode, when it's ipv6 inner address with nexthdrs set,
> the packet format might be:
> 
>     ----------------------------------------------------
>     | outer  |     | dest |     |      |  ESP    | ESP |
>     | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> Before doing gso segment in xfrm6_beet_gso_segment(), it should
> skip all nexthdrs and get the real transport proto, and set
> transport_header properly.
> 
> This patch is to fix it by simply calling ipv6_skip_exthdr()
> in xfrm6_beet_gso_segment().
> 
> v1->v2:
>   - remove skb_transport_offset(), as it will always return 0
>     in xfrm6_beet_gso_segment(), thank Sabrina's check.
> 
> Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks a lot!
