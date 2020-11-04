Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5122A5C07
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgKDBh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:37:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCEC223C7;
        Wed,  4 Nov 2020 01:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453877;
        bh=C1hxwgsRNteQbnQrr6jQpvui5WhBjDZGbOrP0Y9oqdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=we4JAzN44kzWwjyMg5wHhLJ2vGMD0Ay4MZH+Wf339CCbo/UcQWmMBOUEMD33X1sIM
         zlle9bWssGRdkHjAUpMGazlcPLt45Nfge9Ei9IY5DHfACCOzZFrZMRAWhkJWpMI/Zl
         Ek9O+L6+H7/SH+LjnlF0hT6h0Tld9V1pvSutSiCE=
Date:   Tue, 3 Nov 2020 17:37:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
Message-ID: <20201103173756.5f495c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Nov 2020 23:30:44 +0100 Heiner Kallweit wrote:
> We had to remove flag IRQF_NO_THREAD because it conflicts with shared
> interrupts in case legacy interrupts are used. Following up on the
> linked discussion set IRQF_NO_THREAD if MSI or MSI-X is used, because
> both guarantee that interrupt won't be shared.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Link: https://www.spinics.net/lists/netdev/msg695341.html

Applied, based on my understanding on RT. But I do agree with Vladimir
that it'd be good to see actual performance numbers for these sort of
optimizations.
