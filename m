Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FBE1B548D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDWGHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:07:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51320 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWGHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:07:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EF99E20523;
        Thu, 23 Apr 2020 08:07:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GN6tqjKHOmi8; Thu, 23 Apr 2020 08:07:36 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8C9BD201E4;
        Thu, 23 Apr 2020 08:07:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 23 Apr 2020 08:07:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 23 Apr
 2020 08:07:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F2BE431800BD;
 Thu, 23 Apr 2020 08:07:35 +0200 (CEST)
Date:   Thu, 23 Apr 2020 08:07:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] ip_vti: receive ipip packet by calling
 ip_tunnel_rcv
Message-ID: <20200423060735.GC13121@gauss3.secunet.de>
References: <ce41ba7497a377260905d75349aeb8f6cc803e20.1587473171.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce41ba7497a377260905d75349aeb8f6cc803e20.1587473171.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 08:46:11PM +0800, Xin Long wrote:
> In Commit dd9ee3444014 ("vti4: Fix a ipip packet processing bug in
> 'IPCOMP' virtual tunnel"), it tries to receive IPIP packets in vti
> by calling xfrm_input(). This case happens when a small packet or
> frag sent by peer is too small to get compressed.
> 
> However, xfrm_input() will still get to the IPCOMP path where skb
> sec_path is set, but never dropped while it should have been done
> in vti_ipcomp4_protocol.cb_handler(vti_rcv_cb), as it's not an
> ipcomp4 packet. This will cause that the packet can never pass
> xfrm4_policy_check() in the upper protocol rcv functions.
> 
> So this patch is to call ip_tunnel_rcv() to process IPIP packets
> instead.
> 
> Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
