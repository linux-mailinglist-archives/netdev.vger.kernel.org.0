Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5351796854
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 20:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfHTSLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 14:11:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60835 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 14:11:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD21D21443;
        Tue, 20 Aug 2019 14:11:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 20 Aug 2019 14:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wIvSUF
        SxBtKrLx7QW6izXj5arwDQX+RuLbQJMChRUnQ=; b=m0wbJYW+y0sMPQSHCjrZwg
        SQfdBzqc4G9vlAj4sIhdJ8yeReIPGWHJGROL4WecWDVhUdIz//euBTr6BQxvEMSH
        OD/PPC+QMZ3Jcqnzk6kJLDK3/Ti5fle09KBGF1+rgi1ykEkSBiXLF3AC/UOXXFXt
        Bgj7P4smZm0bxUgeHmTD57qSVfEeHDzDqJ3VjtulJdKLAxtEVweEY8S8YMSFxuj/
        EGszuc6EDo+A9+Q+ZVeXZ6h+uqeP1+mmuWJQgj5TW4tgrtLIB45nnxaibjTMgI8g
        EtJ1G4txAeI+Juxa0Qm28DRPbF+aCWl33LYOy0q1ugeEyhEOg8deX8+BZnkld8lQ
        ==
X-ME-Sender: <xms:vjdcXV9c8qRWICIwwh0VqL408lqLf8JOhWfX8mDPNDD7qPnoCiABuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeguddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesth
    dtredttdervdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrg
    hmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushht
    vghrufhiiigvpedt
X-ME-Proxy: <xmx:vjdcXbTrcLZFW3TabmV5FSYQMMS0a8O77UPxp1G4Rwx-pJxXz4Byhg>
    <xmx:vjdcXSSqUsoey59RfOgUgilPQEdJPad7jxkUTPBapiyrtse4C8wKbg>
    <xmx:vjdcXf6aPaYRyXduAh2NYx2NKNW-aFZeqzGI-WY3avpI0e0QMnKXVg>
    <xmx:vzdcXfxxYihdycGB_jQWZXyTLl-MGuJiYvPTV4g2Be58zie7RzTdjw>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3E82380089;
        Tue, 20 Aug 2019 14:11:09 -0400 (EDT)
Date:   Tue, 20 Aug 2019 21:10:55 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, idosch@mellanox.com, jiri@mellanox.com,
        mcroce@redhat.com, jakub.kicinski@netronome.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] netdevsim: Fix build error without
 CONFIG_INET
Message-ID: <20190820181055.GA6054@splinter>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
 <20190820141446.71604-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820141446.71604-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 10:14:46PM +0800, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
> dev.c:(.text+0x67b): undefined reference to `ip_send_check'
> 
> Use ip_fast_csum instead of ip_send_check to avoid
> dependencies on CONFIG_INET.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks for fixing this in my stead!
