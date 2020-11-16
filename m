Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF152B4A24
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgKPP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730473AbgKPP6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:58:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E9D20A8B;
        Mon, 16 Nov 2020 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605542284;
        bh=5/W5YHREqFFasn1uY6bRpOswAoCpvHqJsGYAbOijz14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QPNj0RJBqE4bNWKSYXCVp3++nattwyn4mWK0DEt1g9a1SnarWw7t4bhCfBMcTXp77
         IH0OraBVdp/0MTyRamS1qGfANOo7PtsYZ0MKDjE1yCvt2HX4euQEnFkEA6Oc9Arqbd
         KV6L0NKJ2WsPGuSr3B6EwP4K5Hi16n9opMBIvAS8=
Date:   Mon, 16 Nov 2020 07:58:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: improve rtl8169_start_xmit
Message-ID: <20201116075803.0a75fd3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <80085451-3eaf-507a-c7c0-08d607c46fbc@gmail.com>
References: <80085451-3eaf-507a-c7c0-08d607c46fbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 21:49:53 +0100 Heiner Kallweit wrote:
> Improve the following in rtl8169_start_xmit:
> - tp->cur_tx can be accessed in parallel by rtl_tx(), therefore
>   annotate the race by using WRITE_ONCE
> - avoid checking stop_queue a second time by moving the doorbell check
> - netif_stop_queue() uses atomic operation set_bit() that includes a
>   full memory barrier on some platforms, therefore use
>   smp_mb__after_atomic to avoid overhead
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
