Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE62D4B36
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388089AbgLIUFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388085AbgLIUFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 15:05:14 -0500
Date:   Wed, 9 Dec 2020 12:04:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607544273;
        bh=AYuF3zfMHlMRG7rqQ/XhTpbeydCAtLhXUZNwC6Y4Dls=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=usqqVeA6HplSf1vklVlq65i2RCRYcEymek+ZyFE8GqQw52zjdav6CketDbyUUTe4M
         5eBC9PJ5om9qquS4biFLlhaMb5m47nlsnHdWAxfrKR1ny7nLqohDltIZUZvP3R/Eci
         PUXig5zm/A0CP54u0fCsmuU9x/NfHzXYy9iSmH6xqBbV2nU+1/HrAH+69iT45hkreB
         hNUFSxEyqXseYdpbdV7codIpSzmx6PpsFXvfpX3yC/Zmnvu6VkK9NHBIKkhA8i9zIt
         Ju2eF+7RkZolrLg1aVllIT9ja4sCQCDNMRm3l7piyCNh8CYTHDCn+DtZl0c6jDoA8/
         a+0l3cbD67YLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] vrf: handle CONFIG_IPV6 not set for
 vrf_add_mac_header_if_unset()
Message-ID: <20201209120432.08ad638b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <30116173-cc7f-f492-f290-faa24db28864@gmail.com>
References: <20201208175210.8906-1-andrea.mayer@uniroma2.it>
        <30116173-cc7f-f492-f290-faa24db28864@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 12:51:55 -0700 David Ahern wrote:
> On 12/8/20 10:52 AM, Andrea Mayer wrote:
> > The vrf_add_mac_header_if_unset() is defined within a conditional
> > compilation block which depends on the CONFIG_IPV6 macro.
> > However, the vrf_add_mac_header_if_unset() needs to be called also by IPv4
> > related code and when the CONFIG_IPV6 is not set, this function is missing.
> > As a consequence, the build process stops reporting the error:
> > 
> >  ERROR: implicit declaration of function 'vrf_add_mac_header_if_unset'
> > 
> > The problem is solved by *only* moving functions
> > vrf_add_mac_header_if_unset() and vrf_prepare_mac_header() out of the
> > conditional block.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Fixes: 0489390882202 ("vrf: add mac header for tunneled packets when sniffer is attached")
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
>
> I should have caught that in my review.
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thank you!
