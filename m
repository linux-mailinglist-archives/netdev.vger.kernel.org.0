Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FAB1CCD40
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgEJTWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgEJTWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:22:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82FF12080C;
        Sun, 10 May 2020 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589138557;
        bh=N46/U9XkZ5fXQ2g06chf+wLR3JOJqjwSBpHx9l8nmqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvL0qI2WHlXpbzaCnsKjEsnfPnzPlxncrnMiRZUYfGoSHSWaLC6sCGA5oXkVfzV9z
         h66zmy8twDemPIXe/2OzqcD/hlFrSgwHBS3+NUliTALJSL1grq55Fhz4ykfKyrjLVH
         JXm0bHMN9ayzwH6eBrWMUrdLni8DwZNg/4s5rURc=
Date:   Sun, 10 May 2020 12:22:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        netdev@vger.kernel.org, benh@debian.org
Subject: Re: [PATCH net-next] checkpatch: warn about uses of ENOTSUPP
Message-ID: <20200510122235.46fb162d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510190432.GB411829@lunn.ch>
References: <20200510185148.2230767-1-kuba@kernel.org>
        <20200510190432.GB411829@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 21:04:32 +0200 Andrew Lunn wrote:
> On Sun, May 10, 2020 at 11:51:48AM -0700, Jakub Kicinski wrote:
> > ENOTSUPP often feels like the right error code to use, but it's
> > in fact not a standard Unix error. E.g.:  
> 
> Hi Jakub
> 
> You said ENOTSUPP is for NFS? Would it make sense to special case
> fs/nfs* files and not warn there? I assume that would reduce the number
> of false positives?

That's what Ben Hutchings once said, but I have no proof of that,
actually. The code pre-dates git.

I believe the real test would be "can this error code leak to user
space?" AFAIU those high error codes are for kernel's internal use.
So any code can use them, if done carefully.
