Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0132A36E8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKBXFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgKBXFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:05:30 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A863F22280;
        Mon,  2 Nov 2020 23:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604358330;
        bh=x+q6Bm5flcZvll36ZgtzcGehsn+wDBCSLDHxqKZxz3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Go3NZD3gR76smYAvSHk8Od63rMsSUQ8nQuWTfYp0AcYIhi8yFeTXruNyRqjGJRAT2
         TeHnqR7CiHeMaO8zAF7fnPbuMFWxTcR0+J6f/mxsgE3177NvjV2ezB7S0++/Syal9f
         s6rJP3tmUHx2epSp/Rh9UPXRSE5DO8aDfrE2VMi8=
Date:   Mon, 2 Nov 2020 15:05:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Petr Malat <oss@malat.biz>, linux-sctp@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on
 big-endian platforms
Message-ID: <20201102150528.59f13386@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102132717.GI11030@localhost.localdomain>
References: <20201030132633.7045-1-oss@malat.biz>
        <20201102132717.GI11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 10:27:17 -0300 Marcelo Ricardo Leitner wrote:
> On Fri, Oct 30, 2020 at 02:26:33PM +0100, Petr Malat wrote:
> > Commit 978aa0474115 ("sctp: fix some type cast warnings introduced since
> > very beginning")' broke err reading from sctp_arg, because it reads the
> > value as 32-bit integer, although the value is stored as 16-bit integer.
> > Later this value is passed to the userspace in 16-bit variable, thus the
> > user always gets 0 on big-endian platforms. Fix it by reading the __u16
> > field of sctp_arg union, as reading err field would produce a sparse
> > warning.  
> 
> Makes sense.
> 
> > 
> > Signed-off-by: Petr Malat <oss@malat.biz>  
> 
> Then, it also needs:
> Fixes: 978aa0474115 ("sctp: fix some type cast warnings introduced since very beginning")'
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> (If the maintainers can't add the Fixes tag above, please keep the ack
> on the v2)

Applied, thanks!
