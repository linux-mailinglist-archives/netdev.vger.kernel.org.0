Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E11B06B2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDTKgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:36:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33372 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgDTKgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:36:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 278AA205A4;
        Mon, 20 Apr 2020 12:36:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0N7dIQNGemrY; Mon, 20 Apr 2020 12:36:07 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BB7C620536;
        Mon, 20 Apr 2020 12:36:07 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Apr 2020 12:36:07 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:36:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D15CA31800B3; Mon, 20 Apr 2020 12:36:06 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:36:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] xfrm: allow to accept packets with ipv6
 NEXTHDR_HOP in xfrm_input
Message-ID: <20200420103606.GE13121@gauss3.secunet.de>
References: <ba8d9777f2da2906e744cace0836dc579190ccd7.1586509561.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ba8d9777f2da2906e744cace0836dc579190ccd7.1586509561.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:06:01PM +0800, Xin Long wrote:
> For beet mode, when it's ipv6 inner address with nexthdrs set,
> the packet format might be:
> 
>     ----------------------------------------------------
>     | outer  |     | dest |     |      |  ESP    | ESP |
>     | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> The nexthdr from ESP could be NEXTHDR_HOP(0), so it should
> continue processing the packet when nexthdr returns 0 in
> xfrm_input(). Otherwise, when ipv6 nexthdr is set, the
> packet will be dropped.
> 
> I don't see any error cases that nexthdr may return 0. So
> fix it by removing the check for nexthdr == 0.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
