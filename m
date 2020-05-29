Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E31E89B9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 23:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgE2VNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 17:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgE2VNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 17:13:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB58206A4;
        Fri, 29 May 2020 21:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590786792;
        bh=UiFicGKzPKJ240MR38LFO3j8D26TPzO27wvqkqUyy5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1EAHoT9gtrnSyeMr+HmfzyuVj0YmiAxbB5geAbOD8PQIUAyL3X0zclzTBYL+oMVQi
         1jS4sAC3RZUaoe3iyNtyiupS6ClZ0nUDXDE4n1nQfbC2g+wVBEJ9fBDAnDhsuzMP7R
         wLJSFq9TyqWVbdOjp1AfDF+vObcIHOrbn2OyZ614=
Date:   Fri, 29 May 2020 14:13:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Message-ID: <20200529141310.55facd7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529174345.27537-3-ioana.ciornei@nxp.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
        <20200529174345.27537-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 20:43:40 +0300 Ioana Ciornei wrote:
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> 
> Configure static ingress classification based on VLAN PCP field.
> If the DPNI doesn't have enough traffic classes to accommodate all
> priority levels, the lowest ones end up on TC 0 (default on miss).
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v3:
>  - revert to explicitly cast mask to u16 * to not get into
>    sparse warnings

Doesn't seem to have worked:

../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    expected unsigned short [usertype]
../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    got restricted __be16 [usertype]
../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    expected unsigned short [usertype]
../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    got restricted __be16 [usertype]
