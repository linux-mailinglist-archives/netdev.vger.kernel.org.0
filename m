Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBB01EF3DC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 11:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgFEJRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 05:17:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:45250 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgFEJRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 05:17:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 470602052E;
        Fri,  5 Jun 2020 11:17:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G759m0awl_Pp; Fri,  5 Jun 2020 11:17:13 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 137AD2051F;
        Fri,  5 Jun 2020 11:17:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 5 Jun 2020 11:17:12 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 5 Jun 2020
 11:17:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3EB9D31801FA; Fri,  5 Jun 2020 11:17:12 +0200 (CEST)
Date:   Fri, 5 Jun 2020 11:17:12 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Huy Nguyen <huyn@mellanox.com>
CC:     <davem@davemloft.net>, <saeedm@mellanox.com>,
        <borisp@mellanox.com>, <raeds@mellanox.com>,
        <netdev@vger.kernel.org>, <huyn@nvidia.com>
Subject: Re: [PATCH] xfrm: Fix double ESP trailer insertion in IPsec crypto
 offload.
Message-ID: <20200605091712.GC19286@gauss3.secunet.de>
References: <6d0d27dceb774236d79d16e44a3b9406ac8a767b.camel@mellanox.com>
 <1591047577-18113-1-git-send-email-huyn@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1591047577-18113-1-git-send-email-huyn@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 04:39:37PM -0500, Huy Nguyen wrote:
> During IPsec performance testing, we see bad ICMP checksum. The error packet
> has duplicated ESP trailer due to double validate_xmit_xfrm calls. The first call
> is from ip_output, but the packet cannot be sent because
> netif_xmit_frozen_or_stopped is true and the packet gets dev_requeue_skb. The second
> call is from NET_TX softirq. However after the first call, the packet already
> has the ESP trailer.
> 
> Fix by marking the skb with XFRM_XMIT bit after the packet is handled by
> validate_xmit_xfrm to avoid duplicate ESP trailer insertion.
> 
> Fixes: f6e27114a60a ("net: Add a xfrm validate function to validate_xmit_skb")
> Signed-off-by: Huy Nguyen <huyn@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Applied, thanks a lot!
