Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C89B22789D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGUGIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:08:44 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35278 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgGUGIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:08:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2DA3A2051F;
        Tue, 21 Jul 2020 08:08:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ixEdlJUFUvfi; Tue, 21 Jul 2020 08:08:40 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B49DE2018D;
        Tue, 21 Jul 2020 08:08:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 08:08:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Jul
 2020 08:08:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C7ACB31801E1; Tue, 21 Jul 2020 08:08:39 +0200 (CEST)
Date:   Tue, 21 Jul 2020 08:08:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>
Subject: Re: [PATCH ipsec-next] ip6_vti: use IS_REACHABLE to avoid some
 compile errors
Message-ID: <20200721060839.GJ20687@gauss3.secunet.de>
References: <2aabdcbf7f02d036995701b0ce48cceee4e261ee.1594969394.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2aabdcbf7f02d036995701b0ce48cceee4e261ee.1594969394.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 03:03:14PM +0800, Xin Long wrote:
> Naresh reported some compile errors:
> 
>   arm build failed due this error on linux-next 20200713 and  20200713
>   net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
>   ip6_vti.c:(.text+0x1d20): undefined reference to `xfrm6_tunnel_spi_lookup'
> 
> This happened when set CONFIG_IPV6_VTI=y and CONFIG_INET6_TUNNEL=m.
> We don't really want ip6_vti to depend inet6_tunnel completely, but
> only to disable the tunnel code when inet6_tunnel is not seen.
> 
> So instead of adding "select INET6_TUNNEL" for IPV6_VTI, this patch
> is only to change to IS_REACHABLE to avoid these compile error.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Fixes: 08622869ed3f ("ip6_vti: support IP6IP6 tunnel processing with .cb_handler")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thanks a lot!
