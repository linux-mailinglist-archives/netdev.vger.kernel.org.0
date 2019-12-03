Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D72112062
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfLCXnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 18:43:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfLCXnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 18:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OPqV2nFrcb2kveUIO3yew2jRvZwyS9xTFWvVWcs/spM=; b=iq0/EIA9iexEmIjjiLPdaYHs4
        7BdmVMdoj3wljvzDO3pkZVaF1Wr0nxYgJgLm3fzx5EA5oSg+H3hMxQ302BVueNhBS+2AkjSGdRog8
        TVyD5WtJiUIXVsHeLGp5wibrlD0aHaf0qlEmkm0MOUJNN+hBEovPsNViw+t59+Sowqng5rt+oip9D
        gjUNPEFXB2RUoagAaA9p1uUBh/Js94QdDNn3/JbSK5TETsO90oTHighhyYgl2DRnGXc9E8kBZhCMz
        P2zTagF5/f6w1g2Mz8pGi03vG6/Yt1MAjE1RXhCeNHF+7sI6h9EFzrmcyHal8J27DPH9WdJ+Ej+FH
        zBpFDIvOQ==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1icHp1-0003aR-6R; Tue, 03 Dec 2019 23:43:11 +0000
Subject: Re: linux-next: Tree for Dec 3 (switchdev & TI_CPSW_SWITCHDEV)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-omap@vger.kernel.org
References: <20191203155405.31404722@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <58aebf62-54f8-9084-147b-801ea65327bb@infradead.org>
Date:   Tue, 3 Dec 2019 15:43:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203155405.31404722@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/19 8:54 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any material for v5.6 to your linux-next included
> trees until after v5.5-rc1 has been released.
> 
> Changes since 20191202:

I am seeing this (happens to be on i386; I doubt that it matters):
CONFIG_COMPILE_TEST=y


WARNING: unmet direct dependencies detected for NET_SWITCHDEV
  Depends on [n]: NET [=y] && INET [=n]
  Selected by [y]:
  - TI_CPSW_SWITCHDEV [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && (ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST [=y])

because TI_CPSW_SWITCHDEV blindly selects NET_SWITCHDEV even though
INET is not set/enabled, while NET_SWITCHDEV depends on INET.

However, the build succeeds, including net/switchdev/*.

So why does NET_SWITCHDEV depend on INET?

It looks like TI_CPSW_SWITCHDEV should depend on INET (based on the
Kconfig rules), but in practice it doesn't seem to matter to the build.

thanks.
-- 
~Randy

