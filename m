Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379AB2C6BD4
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgK0TJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730256AbgK0TIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:08:02 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AFA0221F7;
        Fri, 27 Nov 2020 19:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504055;
        bh=IjHjkXLKwIydwmcVuM3MZu0EnkC0zoXUojviaYTn1q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2H8FWTaRd8ar4mwAEodyqN5I6TbMUX744wud7zmIsYIv0IsDfzWTdRyw6qzVFhDo0
         8bQFwMDp024eOB+ECkbb9hJ0fKYSx40XS8waqZkcCQdZ1ZpztAINYqoB5b6TV60Vt/
         qF3R/1JhQKIZagkY02pgYin3rzgUI+qbptLEZ/9k=
Date:   Fri, 27 Nov 2020 11:07:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Ayush Ranjan <ayushranjan@google.com>
Subject: Re: [PATCH net] sock: set sk_err to ee_errno on dequeue from errq
Message-ID: <20201127110734.64598288@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CACSApvaWuwMK+PUDsxJ85FMqcoX2yoQOKP3HeBofPPu5qRyg_g@mail.gmail.com>
References: <20201126151220.2819322-1-willemdebruijn.kernel@gmail.com>
        <CACSApvaWuwMK+PUDsxJ85FMqcoX2yoQOKP3HeBofPPu5qRyg_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 12:28:36 -0500 Soheil Hassas Yeganeh wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > When setting sk_err, set it to ee_errno, not ee_origin.
> >
> > Commit f5f99309fa74 ("sock: do not set sk_err in
> > sock_dequeue_err_skb") disabled updating sk_err on errq dequeue,
> > which is correct for most error types (origins):
> >
> >   -       sk->sk_err = err;
> >
> > Commit 38b257938ac6 ("sock: reset sk_err when the error queue is
> > empty") reenabled the behavior for IMCP origins, which do require it:
> >
> >   +       if (icmp_next)
> >   +               sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;
> >
> > But read from ee_errno.
> >
> > Fixes: 38b257938ac6 ("sock: reset sk_err when the error queue is empty")
> > Reported-by: Ayush Ranjan <ayushranjan@google.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>  
> 
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied, thanks!
