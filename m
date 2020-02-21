Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764D116865B
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgBUSVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:21:34 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:62675 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgBUSVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:21:34 -0500
X-Originating-IP: 92.184.108.100
Received: from localhost (unknown [92.184.108.100])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id E555640003;
        Fri, 21 Feb 2020 18:21:31 +0000 (UTC)
Date:   Fri, 21 Feb 2020 19:21:30 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [RFC 12/18] net: atlantic: MACSec offload skeleton
Message-ID: <20200221182130.GF3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200214150258.390-13-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-13-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Feb 14, 2020 at 06:02:52PM +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> --- a/drivers/net/ethernet/aquantia/atlantic/Makefile
> +++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
> @@ -8,6 +8,8 @@
>  
>  obj-$(CONFIG_AQTION) += atlantic.o
>  
> +ccflags-y += -I$(src)
> +
>  atlantic-objs := aq_main.o \
>  	aq_nic.o \
>  	aq_pci_func.o \
> @@ -18,6 +20,7 @@ atlantic-objs := aq_main.o \
>  	aq_drvinfo.o \
>  	aq_filters.o \
>  	aq_phy.o \
> +	aq_macsec.o \

You can exclude this file from the build when MACsec isn't enabled and
remove the #if in the corresponding C file. If MACsec is set to be built
as a module, your driver cannot work as the pn wrap callback won't be
callable.

You would also need to define a dependency on 'MACSEC || MACSEC=n' for
the pn wrap callback to work.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
