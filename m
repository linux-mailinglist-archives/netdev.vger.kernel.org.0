Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356B448C514
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbiALNqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:46:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34028 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbiALNqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 08:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0DAGcFs70pSKScKvPwpeE3r1gxlZdbXwxHIF91PvejY=; b=Y/PftwFpmYnPrHYvzqrrq19RwS
        5rubWXXqSCeAtwcnWrwR+qZFLdZKrG1sGSYLA22eG2OZf01Ms/UdxlX1R3umQ/+iukMrYkLYoiJkM
        pxTilD7Q+dEZLEs0bymseBBZkPKL47NrWK6hxFoVWTSEBrGhtrtqkPL5/hWeFUpVKA00=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7dwz-001CH4-TE; Wed, 12 Jan 2022 14:46:05 +0100
Date:   Wed, 12 Jan 2022 14:46:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, liuyonglong@huawei.com, mbrugger@suse.com,
        netdev@vger.kernel.org, salil.mehta@huawei.com,
        shenyang39@huawei.com, yisen.zhuang@huawei.com
Subject: Re: [PATCH v2] net: hns: Fix missing put_device() call in
 hns_mac_register_phy
Message-ID: <Yd7bnS/jPQgRPD88@lunn.ch>
References: <20220111203333.507ec4f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220112103919.28894-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112103919.28894-1-linmq006@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 10:39:19AM +0000, Miaoqian Lin wrote:
> We need to drop the reference taken by hns_dsaf_find_platform_device
> Missing put_device() may cause refcount leak.

Is the put also missing on driver unload?

As a fix for net, it might be better to rename
dsaf_find_platform_device() to dsaf_get_platform_device() and add a
dsaf_put_platform_device(). Add similar undo functions where ever
needed, and make sure they get called.

	Andrew
