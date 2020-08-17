Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91012475D8
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbgHQT31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730315AbgHQPcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC03B207FF;
        Mon, 17 Aug 2020 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678339;
        bh=2c4Yh95xvolsVljCfBjOgUgBnpWZevsxHtYN4hwUUuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqJ4AUhNCRXS/VC9OkD2uAmeo4aNAyZFhtAwYnKIWQMQg4HzuxJiPNeQAvPUunzxL
         vszsyooQh67yVwKcN2epBRLBbjuWuZCRBZX1do/00btQNQEi18MWMihYss83LaZXfH
         JZrLi1BvTDV+8rUaibFK/+EgCNKN/gzQ0u1Bd7vo=
Date:   Mon, 17 Aug 2020 08:32:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     jes@trained-monkey.org, davem@davemloft.net, kda@linux-powerpc.org,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, borisp@mellanox.com, keescook@chromium.org,
        linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH 06/20] ethernet: chelsio: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20200817083216.5367f56a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200817082434.21176-8-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
        <20200817082434.21176-8-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 13:54:20 +0530 Allen Pais wrote:
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

You need to adjust kdoc when you change functions:

drivers/net/ethernet/chelsio/cxgb4/sge.c:2664: warning: Function parameter or member 't' not described in 'restart_ctrlq'
drivers/net/ethernet/chelsio/cxgb4/sge.c:2664: warning: Excess function parameter 'data' description in 'restart_ctrlq'
drivers/net/ethernet/chelsio/cxgb4/sge.c:2965: warning: Function parameter or member 't' not described in 'restart_ofldq'
drivers/net/ethernet/chelsio/cxgb4/sge.c:2965: warning: Excess function parameter 'data' description in 'restart_ofldq'
