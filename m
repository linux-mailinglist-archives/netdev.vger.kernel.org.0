Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535EA29F456
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgJ2S50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ2S5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 14:57:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E22A20756;
        Thu, 29 Oct 2020 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603997307;
        bh=nmDELoqCoVDB2Fekho1RKuq6npIMn0ALJLva/swIWO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hWlgd7GXpm4MmqWkrZgjDM4VaDOadXVsvmd9mgwhdnCP/QH40/ZIPu2hpWfUx7LXA
         9M+gQTrbCj06zWsraThAEDbTzhlW3wbsC1G5yK3YAOhKenjCR/xXiYM3vBI7wnR6Ix
         7VdCMaMOyd/F8qiEV8RXGS8keZYn5GK1rhhJRLsU=
Date:   Thu, 29 Oct 2020 11:48:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix issue with forced threading in
 combination with shared interrupts
Message-ID: <20201029114826.76567cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87wnz9b6v4.fsf@depni.sinp.msu.ru>
References: <b5b53bfe-35ac-3768-85bf-74d1290cf394@gmail.com>
        <87wnz9b6v4.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 14:37:35 +0300 Serge Belyshev wrote:
> > As reported by Serge flag IRQF_NO_THREAD causes an error if the
> > interrupt is actually shared and the other driver(s) don't have this
> > flag set. This situation can occur if a PCI(e) legacy interrupt is
> > used in combination with forced threading.
> > There's no good way to deal with this properly, therefore we have to
> > remove flag IRQF_NO_THREAD. For fixing the original forced threading
> > issue switch to napi_schedule().
> >
> > Fixes: 424a646e072a ("r8169: fix operation under forced interrupt threading")
> > Link: https://www.spinics.net/lists/netdev/msg694960.html
> > Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Tested-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>

Applied, thanks!
