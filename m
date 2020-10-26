Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC48299A58
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404546AbgJZXWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404241AbgJZXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:22:30 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A995B20715;
        Mon, 26 Oct 2020 23:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603754549;
        bh=t/6ry6r9TRhPIvmyqAN3lGK2MIUZVfhoMorMvGFcAD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p3nUSijL1pkTMvo3npSfI2Sa5oscMaY3FI9qVRywR57kMJ7I3SUWsqoJld4K0vC5i
         dIRbyK41LYAoXUo0jwrbEsax8CVM57G4UvBa7Yu/ziJFKxQBnK6eV+993uxmjb2VRJ
         i9TIIdGy2OEFvYZHHSMMPmHcCuP3KjEV2X03655U=
Date:   Mon, 26 Oct 2020 16:22:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Morris <jmorris@namei.org>
Cc:     Jeff Vander Stoep <jeffv@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-security-module@vger.kernel.org,
        Roman Kiryanov <rkir@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: use ns_capable_noaudit() on socket create
Message-ID: <20201026162228.7f2d16a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <alpine.LRH.2.21.2010270737290.9603@namei.org>
References: <20201023143757.377574-1-jeffv@google.com>
        <alpine.LRH.2.21.2010270737290.9603@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 07:37:37 +1100 (AEDT) James Morris wrote:
> On Fri, 23 Oct 2020, Jeff Vander Stoep wrote:
> 
> > During __vsock_create() CAP_NET_ADMIN is used to determine if the
> > vsock_sock->trusted should be set to true. This value is used later
> > for determing if a remote connection should be allowed to connect
> > to a restricted VM. Unfortunately, if the caller doesn't have
> > CAP_NET_ADMIN, an audit message such as an selinux denial is
> > generated even if the caller does not want a trusted socket.
> > 
> > Logging errors on success is confusing. To avoid this, switch the
> > capable(CAP_NET_ADMIN) check to the noaudit version.
> > 
> > Reported-by: Roman Kiryanov <rkir@google.com>
> > https://android-review.googlesource.com/c/device/generic/goldfish/+/1468545/
> > Signed-off-by: Jeff Vander Stoep <jeffv@google.com>  
> 
> Reviewed-by: James Morris <jamorris@linux.microsoft.com>

Applied to net, thanks!
