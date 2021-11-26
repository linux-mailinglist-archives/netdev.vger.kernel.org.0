Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52C45E663
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358075AbhKZC4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358124AbhKZCyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 393C361106;
        Fri, 26 Nov 2021 02:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637895100;
        bh=xUlZvULXQ6rOq+Z7FE3dDoJ3dhTX0UZTxAaPNoSKV4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lUlwgwytff92HjYig8Cp0RhZf1Geojck1CyhnhTIVO9Da13fzfAwrKtmYPF8nvU1z
         UldZtJ07Dcsi38XGGy4ftKIp5tdNRn1SM+1kzv3XnOJObjEUETDyz2r9vZY/trumA3
         gXWu/l3YgJK7rO7CCfHXRciZiJqg/NILqN3NSNptFTME/pZ2SGXwkUhPkqdwrDrhHu
         RSpYm0JysIelpRH0zO0ABtPO15sgKVMn5NBk93E3GOAyjRszssVEGMDGatwBX2wXBC
         vzyqyhfv9pTSOSymjvfzXuZKD95PURGOTZM0Gje1GWnLSED5gc6SVGVG3baTdAzGwq
         hDNWfduoOCWXQ==
Date:   Thu, 25 Nov 2021 18:51:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>, kgraul@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 10/39] net/smc: Transfer remaining wait
 queue entries during fallback
Message-ID: <20211125185139.0007069f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126023156.441292-10-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
        <20211126023156.441292-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 21:31:27 -0500 Sasha Levin wrote:
> From: Wen Gu <guwen@linux.alibaba.com>
> 
> [ Upstream commit 2153bd1e3d3dbf6a3403572084ef6ed31c53c5f0 ]
> 
> The SMC fallback is incomplete currently. There may be some
> wait queue entries remaining in smc socket->wq, which should
> be removed to clcsocket->wq during the fallback.
> 
> For example, in nginx/wrk benchmark, this issue causes an
> all-zeros test result:

Hold this one, please, there is a fix coming: 7a61432dc813 ("net/smc:
Avoid warning of possible recursive locking").


