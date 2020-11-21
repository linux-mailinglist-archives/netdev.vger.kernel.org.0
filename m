Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2252BC2C5
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgKUXxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgKUXxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:53:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0109B2078E;
        Sat, 21 Nov 2020 23:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606002785;
        bh=WVMgm75HrKo5bu9z9D2CiVDWC2/gmqhMtAxbTigb6FI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uK0KrqBtFqiwlMXBx+04MBULRIeZIEpABxBUfcqfviO4bvt8zoG+Ui/qJ8ILYyRNN
         0OhVcFrw/vL1G0OGtQNRH6+qvvRHqRfRaRH7LO+z4q+BxABsIdnLHU7LG4gBRgTfPh
         /jgtMFRchgDFox0n/6miIg1UzcOtS1DDdNm6XK6g=
Date:   Sat, 21 Nov 2020 15:53:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 4/4] net: ena: return error code from
 ena_xdp_xmit_buff
Message-ID: <20201121155304.1751d0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119202851.28077-5-shayagr@amazon.com>
References: <20201119202851.28077-1-shayagr@amazon.com>
        <20201119202851.28077-5-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 22:28:51 +0200 Shay Agroskin wrote:
> The function mistakenly returns NETDEV_TX_OK regardless of the
> transmission success. This patch fixes this behavior by returning the
> error code from the function.
> 
> Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Doesn't seem like a legitimate bug fix, since the only caller of this
function ignores its return value.
