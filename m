Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361081B06B6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTKiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:38:25 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33542 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgDTKiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:38:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0FBB92058E;
        Mon, 20 Apr 2020 12:38:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SIB-b-ymJCiN; Mon, 20 Apr 2020 12:38:23 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A449F20536;
        Mon, 20 Apr 2020 12:38:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 20 Apr 2020 12:38:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:38:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E6E1531800B3;
 Mon, 20 Apr 2020 12:38:22 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:38:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] esp6: get the right proto for transport mode in
 esp6_gso_encap
Message-ID: <20200420103822.GG13121@gauss3.secunet.de>
References: <7f50634c051299833413aa8478083d061443cc7c.1586509616.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7f50634c051299833413aa8478083d061443cc7c.1586509616.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:06:56PM +0800, Xin Long wrote:
> For transport mode, when ipv6 nexthdr is set, the packet format might
> be like:
> 
>     ----------------------------------------------------
>     |        | dest |     |     |      |  ESP    | ESP |
>     | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> What it wants to get for x-proto in esp6_gso_encap() is the proto that
> will be set in ESP nexthdr. So it should skip all ipv6 nexthdrs and
> get the real transport protocol. Othersize, the wrong proto number
> will be set into ESP nexthdr.
> 
> This patch is to skip all ipv6 nexthdrs by calling ipv6_skip_exthdr()
> in esp6_gso_encap().
> 
> Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
