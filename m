Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C452B31416B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhBHVN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236274AbhBHVNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:13:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434C564E8C;
        Mon,  8 Feb 2021 21:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612818743;
        bh=hNvBcJy5ixIUtLWXqcGSgVgsgzzWO/TTRh9sBdAcSqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LnuIhFnQgC786aRReL1/LWXXdp9IZ9xyxBYxx95f1L4a2PlU5wO9b4x7H9zvtr3kV
         rX4dZ3+PXlcJsCgHdEtMgPGI8S5owC+h0OYz7K4MqmAGvXYmoyWFfJmJS5bVdfLFAe
         Hhh50YCyBBtt8kTqLDAVvtjO895dxM6gV5JJLsM7IBh1UjFGWIDEQt0ymjRcix+2vH
         9wj9WvF40CM84xFTjgDE1N+EEFFIVM6EBQokbTAq4CoCVGXtfbjpQP9gciIvuK9l//
         HhnC5Skn0HofAUvVYMTYXam9/RQZhvsQl/ry1f2N+T19r7o1QDCRJy7qgGMneE8RtK
         WKkYpVUfhqMGQ==
Date:   Mon, 8 Feb 2021 13:12:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com
Subject: Re: [PATCH net-next v4 5/5] net: mhi: Add mbim proto
Message-ID: <20210208131213.7a2bb081@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612771237-3782-6-git-send-email-loic.poulain@linaro.org>
References: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
        <1612771237-3782-6-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 09:00:37 +0100 Loic Poulain wrote:
> MBIM has initially been specified by USB-IF for transporting data (IP)
> between a modem and a host over USB. However some modern modems also
> support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
> allows to aggregate IP packets and to perform context multiplexing.
> 
> This change adds minimal MBIM data transport support to MHI, allowing
> to support MBIM only modems. MBIM being based on USB NCM, it reuses
> and copy some helpers/functions from the USB stack (cdc-ncm, cdc-mbim).
> 
> Note that is a subset of the CDC-MBIM specification, supporting only
> transport of network data (IP), there is no support for DSS. Moreover
> the multi-session (for multi-pdn) is not supported in this initial
> version, but will be added latter, and aligned with the cdc-mbim
> solution (VLAN tags).
> 
> This code has been inspired from the mhi_mbim downstream implementation
> (Carl Yin <carl.yin@quectel.com>).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Sparse says:

drivers/net/mhi/proto_mbim.c:159:41: warning: restricted __le32 degrades to integer
