Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C42B4C0A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbgKPRCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731681AbgKPRCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:02:32 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE0220789;
        Mon, 16 Nov 2020 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605546152;
        bh=ykvawW0olLJgE6wckd62t+BySXzfbRrSNq5I3/RVv9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sspM8WWp+4qLobSpyveJ7LHhlImy86icjXndo3etDQoOE3tYh9ETP1+XwJBLZO76k
         2q5s2ixmsdYktLYyWoInr0wVeU4pPA4iyHnGfWlUaFkJXgsjuInCGcirvMQ8Fhxhnz
         uCmMKV7HoCxy52liCzJBB/YSnE2r7uYNpf1lpnPI=
Date:   Mon, 16 Nov 2020 09:02:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
Message-ID: <20201116090231.423afc8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f3db229-940c-c8ed-257b-0b4b3dd2afbb@samsung.com>
References: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
        <CGME20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56@eucas1p2.samsung.com>
        <1394712342-15778-393-Taiwan-albertk@realtek.com>
        <5f3db229-940c-c8ed-257b-0b4b3dd2afbb@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 10:18:13 +0100 Marek Szyprowski wrote:
> On 16.11.2020 07:52, Hayes Wang wrote:
> > Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
> > as modules. Otherwise, the r8153_ecm would be used, even though the
> > device is supported by r8152 driver.
> >
> > Fixes: c1aedf015ebd ("net/usb/r8153_ecm: support ECM mode for RTL8153")
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>  
> 
> Yes, this fixes this issue, although I would prefer a separate Kconfig 
> entry for r8153_ecm with proper dependencies instead of this ifdefs in 
> Makefile.

Agreed, this is what dependency resolution is for.

Let's just make this a separate Kconfig entry.
