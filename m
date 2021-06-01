Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D08396C08
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhFAESg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhFAESe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:18:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B5861042;
        Tue,  1 Jun 2021 04:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521014;
        bh=szUq9eHGVnXNab082BDhrDAwpeGw0xGTlDnIHeaC1AI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a/uKoXTkcsx4ezqvxS8vrvLqAnreM3cSR7RXOD+jfipsv7EGeLcPY60HTAjh4Jb/f
         ALSb2e2sgEM6MD6rvBr0aOdtp+a+Iel5kD6wwTtPYu236niDVAbh6aYQmPLNmIzOQV
         Ty7bWJJRGRr0RWrhHo+z36zaGAJblDmwXo2nqQ2SjYB1mjQU88XAI/O8iJCRoBFNEF
         7r46oP3Zp1X+SWnMaGM39Uh6ucYD1uO+rS+LsI7DhcxikL5y+vB1lcFaJtglkCPhoZ
         qbx2HrTJKm2DndiDTH+cevBaDFNjh6hBgtJdYDLX80zRwuWGaofKkmgjTpkJjgoQ4m
         c0QWpCyp50Wwg==
Date:   Mon, 31 May 2021 21:16:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS
 device goes down and up
Message-ID: <20210531211652.11b586fc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <03669e23-0697-7a96-3d49-202e045cbf48@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-3-maximmi@nvidia.com>
        <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <afa246d3-acfd-f3be-445c-3beace105c8f@nvidia.com>
        <20210528124421.12a84cb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <03669e23-0697-7a96-3d49-202e045cbf48@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 14:09:56 +0300 Maxim Mikityanskiy wrote:
> On 2021-05-28 22:44, Jakub Kicinski wrote:
> > In general "someone may miss this in the future" is better served by
> > adding a test case than code duplication. But we don't have infra to
> > fake-offload TLS so I don't feel strongly. You can keep as is if that's
> > your preference.  
> 
> Yeah, I agree that we would benefit from having unit tests for such 
> flows. But as we don't have the needed infrastructure, and you are fine 
> with the current implementation, I'll keep it. The only thing I need to 
> fix when resubmitting is the unneeded EXPORT_SYMBOL_GPL, right?

Yup!
