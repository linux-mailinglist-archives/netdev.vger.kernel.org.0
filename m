Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87BC2CDC96
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgLCRln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgLCRln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 12:41:43 -0500
Date:   Thu, 3 Dec 2020 09:41:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607017262;
        bh=aIkWrXx0JDsapSDY/q9+inHrf0Z/KsQRChX1vIRkqJM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=EntDGUAqhSKz0+oOEK4jNFbOQS/yxrVKVqXACUHY6UIAyKNeFEmlfjaWi4OAOHtGO
         xXCe81Di+uqUjEpfEJ1LRMfVTh0y3bD1Lax1wPvpsK1UbIyhW7XNrVKTuFUbSo2KjO
         bErrBooCXnFLRFRFfneMsf56veVUgMzpm5gUQiQrnUmiynDAhtHx3MaHQ9j4D3GrWr
         j+hSM7b5wITwdzaPknlaoSLTTC8ENEdaYGkc5RR8kzUGSqMhA63ogrMYt6ch0zrx7s
         wJAYo8pzDdtVoQqaJLqiVbDTSxqcB6/VUj99OxsLo/GZZJD8vjob5LNBTbYEjXTIIu
         GFv7dZ3atdXGw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Pawlak, Jakub" <jakub.pawlak@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] iavf: fix double-release of rtnl_lock
Message-ID: <20201203094100.516612a1@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1867f98e7951f8d044a7dbf16fcf6a93996914f7.camel@intel.com>
References: <20201203021806.692194-1-kuba@kernel.org>
        <1867f98e7951f8d044a7dbf16fcf6a93996914f7.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 17:04:14 +0000 Nguyen, Anthony L wrote:
> On Wed, 2020-12-02 at 18:18 -0800, Jakub Kicinski wrote:
> > This code does not jump to exit on an error in iavf_lan_add_device(),
> > so the rtnl_unlock() from the normal path will follow.
> > 
> > Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)  
> 
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Did you want to apply this or did you want me to take it?

Please take it, I'm currently running with the assumption that you'll
take all Intel patches (minus some corner cases, maybe, like patches
which are part of some cross-tree series with dependencies).

Thanks!
