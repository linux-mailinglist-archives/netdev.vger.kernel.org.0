Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3829322B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbgJSX6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389149AbgJSX6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 19:58:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3C622363;
        Mon, 19 Oct 2020 23:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603151927;
        bh=SW9lfpQpBvNiZ/Z7vLaUdBCSZibxRIIV9LTfP841kaU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G5atLfkoakYYhyT2DoIx530zPDyjbINlkoe21awom9NuvspsC+RaSamxsIZNw1ZTb
         FqV1mx+c/jHDlC2BgpPqUV7LKZ5b6DWBXLoxF9z7hUX1cMLKoDFDHWiCNdJ1an8bpd
         hHoWc+8Fc8+gzFqbrQyhF7hp2J8aUFfEToCARp6g=
Date:   Mon, 19 Oct 2020 16:58:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt
 threading
Message-ID: <20201019165845.61fe6b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 18:38:59 +0200 Heiner Kallweit wrote:
> For several network drivers it was reported that using
> __napi_schedule_irqoff() is unsafe with forced threading. One way to
> fix this is switching back to __napi_schedule, but then we lose the
> benefit of the irqoff version in general. As stated by Eric it doesn't
> make sense to make the minimal hard irq handlers in drivers using NAPI
> a thread. Therefore ensure that the hard irq handler is never
> thread-ified.
> 
> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
> Link: https://lkml.org/lkml/2020/10/18/19
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thank you!
