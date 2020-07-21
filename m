Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0295F228928
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgGUTbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgGUTbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:31:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E0320720;
        Tue, 21 Jul 2020 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359870;
        bh=zY1MVr3AFcxn8sXK9bMC5SSSTK1lzsYuvuRwLRgynbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iz1PAWCBypW41bNBHSRoikSSYUBsO3lIDM0q0OuUGD3SzKdchoPfmUp7EDhR7BuQE
         L4O4Xn39qI7VhgaD4cdlLdTTC1oFMSnAmirxR1asKI0tn+iiOMhNaIC7OuAZG9QZVw
         ra26CWfs893/VXWs4pHoLpYXqSZnyhTj+lCHkLps=
Date:   Tue, 21 Jul 2020 12:31:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dpaa2-eth: add support for TBF offload
Message-ID: <20200721123108.25da923a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721163825.9462-4-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
        <20200721163825.9462-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 19:38:25 +0300 Ioana Ciornei wrote:
> React to TC_SETUP_QDISC_TBF and configure the egress shaper as
> appropriate with the maximum rate and burst size requested by the user.
> TBF can only be offloaded on DPAA2 when it's the root qdisc, ie it's a
> per port shaper.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Problems that Jesper run into make me wonder if we should always return
-EOPNOTSUPP as an error from drivers from the root Qdisc. Maybe that's
a larger problem, we already have drivers returning other errors.
