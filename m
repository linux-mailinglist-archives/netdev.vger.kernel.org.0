Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D801D22789C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGUGIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:08:07 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35262 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGUGIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:08:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B536A2051F;
        Tue, 21 Jul 2020 08:08:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hElOQYLskFX2; Tue, 21 Jul 2020 08:08:05 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4686D2018D;
        Tue, 21 Jul 2020 08:08:05 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 08:08:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Jul
 2020 08:08:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6DB0831801E1; Tue, 21 Jul 2020 08:08:04 +0200 (CEST)
Date:   Tue, 21 Jul 2020 08:08:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec-next] xfrm: interface: use IS_REACHABLE to avoid
 some compile errors
Message-ID: <20200721060804.GI20687@gauss3.secunet.de>
References: <b1bb348efd21f1567164adb33c39d6c3d55b0c65.1594969350.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b1bb348efd21f1567164adb33c39d6c3d55b0c65.1594969350.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 03:02:30PM +0800, Xin Long wrote:
> kernel test robot reported some compile errors:
> 
>   ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_fini':
>   net/xfrm/xfrm_interface.c:900: undefined reference to `xfrm4_tunnel_deregister'
>   ia64-linux-ld: net/xfrm/xfrm_interface.c:901: undefined reference to `xfrm4_tunnel_deregister'
>   ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_init':
>   net/xfrm/xfrm_interface.c:873: undefined reference to `xfrm4_tunnel_register'
>   ia64-linux-ld: net/xfrm/xfrm_interface.c:876: undefined reference to `xfrm4_tunnel_register'
>   ia64-linux-ld: net/xfrm/xfrm_interface.c:885: undefined reference to `xfrm4_tunnel_deregister'
> 
> This happened when set CONFIG_XFRM_INTERFACE=y and CONFIG_INET_TUNNEL=m.
> We don't really want xfrm_interface to depend inet_tunnel completely,
> but only to disable the tunnel code when inet_tunnel is not seen.
> 
> So instead of adding "select INET_TUNNEL" for XFRM_INTERFACE, this patch
> is only to change to IS_REACHABLE to avoid these compile error.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
