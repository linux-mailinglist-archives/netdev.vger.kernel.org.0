Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE929EACD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJ2LiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:38:13 -0400
Received: from depni-mx.sinp.msu.ru ([213.131.7.21]:25 "EHLO
        depni-mx.sinp.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2Lhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:37:43 -0400
Received: from spider (unknown [176.192.246.239])
        by depni-mx.sinp.msu.ru (Postfix) with ESMTPSA id 1DE411BF457;
        Thu, 29 Oct 2020 14:37:40 +0300 (MSK)
From:   Serge Belyshev <belyshev@depni.sinp.msu.ru>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix issue with forced threading in
 combination with shared interrupts
References: <b5b53bfe-35ac-3768-85bf-74d1290cf394@gmail.com>
Date:   Thu, 29 Oct 2020 14:37:35 +0300
In-Reply-To: <b5b53bfe-35ac-3768-85bf-74d1290cf394@gmail.com> (Heiner
        Kallweit's message of "Thu, 29 Oct 2020 10:18:53 +0100")
Message-ID: <87wnz9b6v4.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As reported by Serge flag IRQF_NO_THREAD causes an error if the
> interrupt is actually shared and the other driver(s) don't have this
> flag set. This situation can occur if a PCI(e) legacy interrupt is
> used in combination with forced threading.
> There's no good way to deal with this properly, therefore we have to
> remove flag IRQF_NO_THREAD. For fixing the original forced threading
> issue switch to napi_schedule().
>
> Fixes: 424a646e072a ("r8169: fix operation under forced interrupt threading")
> Link: https://www.spinics.net/lists/netdev/msg694960.html
> Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Thanks, that works for me.

Tested-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
