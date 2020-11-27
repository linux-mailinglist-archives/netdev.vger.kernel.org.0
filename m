Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172E62C6BE4
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgK0TNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbgK0THf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:07:35 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9335221F1;
        Fri, 27 Nov 2020 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504010;
        bh=7xY4djymxfomn0HHhU92HPV9KSkWe3TieW6ZrbQn0pQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dSPI845BtyaEkXx1kXFo+g8wRcjy3/NIrh52VVBc1w730cf2ZGNUoRbF0zS0mfNk3
         Lz0kP+eXlPPTi3TAiA4TWvb7x4EbffBh8JzE50N2hzP+QWu0WMxXP8ecvziq0yoYSr
         V9JZUiS2soE/WXfgg6zYjmvcg9VSKIiXXDSzPScQ=
Date:   Fri, 27 Nov 2020 11:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix NULL ptr dereference on bad MPJ
Message-ID: <20201127110649.62563a6c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <2c3eecf9-c3b9-861a-cb8c-2f103496abfc@tessares.net>
References: <03b2cfa3ac80d8fc18272edc6442a9ddf0b1e34e.1606400227.git.pabeni@redhat.com>
        <2c3eecf9-c3b9-861a-cb8c-2f103496abfc@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 16:23:08 +0100 Matthieu Baerts wrote:
> On 26/11/2020 15:17, Paolo Abeni wrote:
> > If an msk listener receives an MPJ carrying an invalid token, it
> > will zero the request socket msk entry. That should later
> > cause fallback and subflow reset - as per RFC - at
> > subflow_syn_recv_sock() time due to failing hmac validation.
> > 
> > Since commit 4cf8b7e48a09 ("subflow: introduce and use
> > mptcp_can_accept_new_subflow()"), we unconditionally dereference
> > - in mptcp_can_accept_new_subflow - the subflow request msk
> > before performing hmac validation. In the above scenario we
> > hit a NULL ptr dereference.
> > 
> > Address the issue doing the hmac validation earlier.
> > 
> > Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
> > Tested-by: Davide Caratti <dcaratti@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>  
> 
> Good catch! Thank you for the patch!
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks!
