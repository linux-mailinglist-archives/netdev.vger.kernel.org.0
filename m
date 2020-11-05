Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696CF2A865E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgKESrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:47:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKESrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 13:47:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4B6206C1;
        Thu,  5 Nov 2020 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604602019;
        bh=mxKY0SN2aNios4WCHdV+qmpayVW9pGEpbXnDznhlPXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P0P4qiikJtr9Pj7gx4+FPhY1ps35jSMqhSf+q4tYJRHHzHb6rqZdjnxx1lWARGlyU
         2w6u1UlH9DflOT77BfY2wQiu7E1k3nAxa8ZQ1jDuoawVd1Yvd5eIo1usGk8ynPIpFT
         /77Bl/HqvBUj5+uuZx5lq2Yh2FHyBUxZVu3D+ZuQ=
Date:   Thu, 5 Nov 2020 10:46:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Message-ID: <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
        <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
        <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 23:55:15 +0530 Vinay Kumar Yadav wrote:
> >>> We should prevent from the socket getting into LISTEN state in the
> >>> first place. Can we make a copy of proto_ops (like tls_sw_proto_ops)
> >>> and set listen to sock_no_listen?  
> >>
> >> Once tls-toe (TLS_HW_RECORD) is configured on a socket, listen() call
> >> from user on same socket will create hash at two places.  
> > 
> > What I'm saying is - disallow listen calls on sockets with tls-toe
> > installed on them. Is that not possible?
> >  
> You mean socket with tls-toe installed shouldn't be listening at other
> than adapter? basically avoid ctx->sk_proto->hash(sk) call.

No, replace the listen callback, like I said. Why are you talking about
hash???
