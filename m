Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02842C1009
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389864AbgKWQSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732538AbgKWQSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 11:18:34 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8374A2080A;
        Mon, 23 Nov 2020 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606148314;
        bh=I+txHobWWnpI+QgOEWYpGqyhR0aiGVbdzJTHZovyGtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cxMsmORVy1XmDzfveDuvihhnw4JihO1Z73vmioQsD5P8Dit95Sr0lDrgOOawSISPL
         gxnQBglvmW8sUOczSdoCAvbY5ZoTlbLWPZi8s20wr2NFFrKI+HbrYwxyzkZ6EWUpJ+
         qrwzkGWRXycUedjeno4kXx4XTj/xrjzPpa+c3PMc=
Date:   Mon, 23 Nov 2020 08:18:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 4/4] net: ena: return error code from
 ena_xdp_xmit_buff
Message-ID: <20201123081831.4502d05a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <pj41zl7dqddfkm.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <20201119202851.28077-1-shayagr@amazon.com>
        <20201119202851.28077-5-shayagr@amazon.com>
        <20201121155304.1751d0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <pj41zl7dqddfkm.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 09:19:05 +0200 Shay Agroskin wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Thu, 19 Nov 2020 22:28:51 +0200 Shay Agroskin wrote:  
> >> The function mistakenly returns NETDEV_TX_OK regardless of the
> >> transmission success. This patch fixes this behavior by 
> >> returning the
> >> error code from the function.
> >> 
> >> Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
> >> Signed-off-by: Shay Agroskin <shayagr@amazon.com>  
> >
> > Doesn't seem like a legitimate bug fix, since the only caller of 
> > this
> > function ignores its return value.  
> 
> Hi,
> I plan to use the return value from this function in future patch 
> (next-net series), do you think we better send this fix with
> this future patch?

Yes, it's fine to include this in a net-next series. It doesn't fix any
bug that could cause trouble to the users. If you had a fix that
depended on it then maybe, but if you only need it in net-next we can
put it there with clear conscience.
