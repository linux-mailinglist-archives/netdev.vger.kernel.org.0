Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106BD2955B6
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442509AbgJVAjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408364AbgJVAjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 20:39:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 427F1223BF;
        Thu, 22 Oct 2020 00:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603327163;
        bh=9JpYhh8eO1UEmHacpzeompGiSzSnTf6oUVFrnm3kEGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v/CzBztnpekuz+kw5zgB+14qyW68txvx18Qqq20YALMGIfdmbCEfoXJVYOzBR4DC9
         pjRAqPVa3ls051zCP9NMCS0RBe5PKZUMv4A8MBNTH/f0C+1SxnfPeBDCBZegE8Uy/X
         V57lx/y86Xe7CCITxCqDDf+VDtAAyTcNqseQE4Jc=
Date:   Wed, 21 Oct 2020 17:39:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net v2] net: hdlc: In hdlc_rcv, check to make sure dev
 is an HDLC device
Message-ID: <20201021173921.776d6250@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020013152.89259-1-xie.he.0141@gmail.com>
References: <20201020013152.89259-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 18:31:52 -0700 Xie He wrote:
> The hdlc_rcv function is used as hdlc_packet_type.func to process any
> skb received in the kernel with skb->protocol == htons(ETH_P_HDLC).
> The purpose of this function is to provide second-stage processing for
> skbs not assigned a "real" L3 skb->protocol value in the first stage.
> 
> This function assumes the device from which the skb is received is an
> HDLC device (a device created by this module). It assumes that
> netdev_priv(dev) returns a pointer to "struct hdlc_device".
> 
> However, it is possible that some driver in the kernel (not necessarily
> in our control) submits a received skb with skb->protocol ==
> htons(ETH_P_HDLC), from a non-HDLC device. In this case, the skb would
> still be received by hdlc_rcv. This will cause problems.
> 
> hdlc_rcv should be able to recognize and drop invalid skbs. It should
> first make sure "dev" is actually an HDLC device, before starting its
> processing. This patch adds this check to hdlc_rcv.
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you!
