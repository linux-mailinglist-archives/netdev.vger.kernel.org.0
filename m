Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7FE2AE604
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbgKKBse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgKKBse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:48:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27A87216C4;
        Wed, 11 Nov 2020 01:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059313;
        bh=8ZoXFi19cRFxurUpEO5osza2tLaJVaBLs/a+W0ovF1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q+jPt3Nt8m8DXdJcqcPyssEU7Br3tkPgCzb5XIORN1OLhAFgMJknyUmyBrzhIZdjN
         kcX/8hLGdtUMkj0WJFs99Qe0fAbmTAf7vmho8iFR/BVq6qHO28n9Ez/qgFnwuS6j6k
         MfSackoKWIR0fOla91sG3lNObegpHFomKRKzTEgM=
Date:   Tue, 10 Nov 2020 17:48:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: fix unintended sign extension on a u16
 left shift
Message-ID: <20201110174832.437b4951@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87y2jar76v.fsf@kurt>
References: <20201109124008.2079873-1-colin.king@canonical.com>
        <87y2jar76v.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 14:27:52 +0100 Kurt Kanzenbach wrote:
> On Mon Nov 09 2020, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > The left shift of u16 variable high is promoted to the type int and
> > then sign extended to a 64 bit u64 value.  If the top bit of high is
> > set then the upper 32 bits of the result end up being set by the
> > sign extension. Fix this by explicitly casting the value in high to
> > a u64 before left shifting by 16 places.
> >
> > Also, remove the initialisation of variable value to 0 at the start
> > of each loop iteration as the value is never read and hence the
> > assignment it is redundant.
> >
> > Addresses-Coverity: ("Unintended sign extension")
> > Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>  
> 
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied, thanks!
