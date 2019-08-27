Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5CD9DE4B
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 08:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfH0G6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 02:58:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49828 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfH0G6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 02:58:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 884E52057A;
        Tue, 27 Aug 2019 08:58:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nNYcw2TxXR8y; Tue, 27 Aug 2019 08:58:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 246E42054D;
        Tue, 27 Aug 2019 08:58:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 08:58:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CBFA93182772;
 Tue, 27 Aug 2019 08:58:13 +0200 (CEST)
Date:   Tue, 27 Aug 2019 08:58:13 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net] xfrm: add NETDEV_UNREGISTER event process for xfrmi
Message-ID: <20190827065813.GX2879@gauss3.secunet.de>
References: <fce85b872c03cee379cb30ae46100ff42bea8e0d.1566807905.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fce85b872c03cee379cb30ae46100ff42bea8e0d.1566807905.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 04:25:05PM +0800, Xin Long wrote:
> When creating a xfrmi dev, it always holds the phydev. The xfrmi dev should
> be deleted when the phydev is being unregistered, so that the phydev can be
> put on time. Otherwise the phydev's deleting will get stuck:
> 
>   # ip link add dummy10 type dummy
>   # ip link add xfrmi10 type xfrm dev dummy10
>   # ip link del dummy10
> 
> The last command blocks and dmesg shows:
> 
>   unregister_netdevice: waiting for dummy10 to become free. Usage count = 1
> 
> This patch fixes it by adding NETDEV_UNREGISTER event process for xfrmi.

There is already a patch in the ipsec tree that fixes this issue
in a different way. Please base xfrm patches on the ipsec/ipsec-next
tree to avoid double work.

Thanks anyway!
