Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE2D2B0EA6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgKLUBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgKLUBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:01:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F85720791;
        Thu, 12 Nov 2020 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605211268;
        bh=BN8+3Ezm8lmuq0VOX+lKf7l+fguUDSawLXOtKGykzSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0F3dpJPnR2ALJrLe2gSGJGXGJgbjksvIuHX/Y3IyKKfXjb+YAEwzG7k7na/MX0m5
         P9rYcXjhDsCJKaRqT4I4Z+t0B9LzbN0epIUdP6b0Zw9i+GKP/+WGLyiSBxhdvhx9iD
         1WSyjFszlXMv53IJqVEEMi/TYiTDXYmZu9U/NOtE=
Date:   Thu, 12 Nov 2020 12:01:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-11-10
Message-ID: <20201112120107.4d43108b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87blg28i4z.fsf@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
        <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87blg28i4z.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:55:24 -0800 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >
> > Pulled, thanks!
> >
> > Please double check the use of the spin lock in patch 3. Stats are
> > updated in an atomic context when read from /proc, you probably need 
> > to convert that spin lock to _bh.  
> 
> I just did some tests with lockdep enabled, reading from /proc/net/dev
> in a loop, and everything seems fine. Am I missing something?

Indeed /proc only takes the RCU lock so you should be fine, thanks
for checking.
