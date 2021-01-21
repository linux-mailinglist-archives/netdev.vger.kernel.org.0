Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE42FE169
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbhAUFQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbhAUFGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:06:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CD5238D7;
        Thu, 21 Jan 2021 05:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205555;
        bh=IqdTpuPyQpVOz99F9S5B33fV5ykceVp/OmS7a6OWS+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QhV7nkVr4Yr+jM00Iy+KKIRHTkuIUoCv673wta2rJ7BrevFEDbxaEpciEzH2rIbDa
         MXuhF0sBF5eqi5G/aV3xESfn0mZ9OTG756mtWgyHd1vNOFwK4aohMXszitgCFyDeMh
         d5FMh9SCGK6Kd+l+D6AvLo2kkbDONa973FtDYsnMaAgZV5GpaNdZCLLetgoSPso1aV
         l4cQ3DPLQEvK2Yzp1APJKkTaBQ9dGWam1KQpB7SjTuQoabHaxqwIiKLc9qgziXpaym
         h0zTLqOyX6SjeH5yWZw4MfGC8GOvujqSXw+AxItOXpb4P9GWmFbc2VYZbHDBi5jPzB
         jbQPDzxvcqU5g==
Date:   Wed, 20 Jan 2021 21:05:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/4] net: inline rollback_registered()
 functions
Message-ID: <20210120210553.3c7584c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKOOJTwJMT-hP8vHbWPoLP5z_Tycy7AXc6X4UXB2ffUvivz=Mg@mail.gmail.com>
References: <20210119202521.3108236-1-kuba@kernel.org>
        <CAKOOJTwJMT-hP8vHbWPoLP5z_Tycy7AXc6X4UXB2ffUvivz=Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 15:18:46 -0800 Edwin Peer wrote:
> On Tue, Jan 19, 2021 at 12:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > After recent changes to the error path of register_netdevice()
> > we no longer need a version of unregister_netdevice_many() which
> > does not set net_todo. We can inline the rollback_registered()
> > functions into respective unregister_netdevice() calls.
> >
> > v2: - add missing list_del() in the last patch
> >
> > Jakub Kicinski (4):
> >   net: move net_set_todo inside rollback_registered()
> >   net: inline rollback_registered()
> >   net: move rollback_registered_many()
> >   net: inline rollback_registered_many()
> >
> >  net/core/dev.c | 210 +++++++++++++++++++++++--------------------------
> >  1 file changed, 98 insertions(+), 112 deletions(-)  
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Applied, thanks!
