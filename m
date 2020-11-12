Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C12B0AC8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgKLQzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgKLQzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:55:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D891206FA;
        Thu, 12 Nov 2020 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605200134;
        bh=k+3SviLSqOkowHpjjuhnCv26uuu/tn/sd6MtqFR5CEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mQU24Sq+0+Kpr68Fy7lO2kn86V4nrgZ57Wp2EELH1UAO2jMrNNGPg4XyKYMj/oTFU
         xruSXhFndDl0SaFThxpTZ09v/i5yaDZyyD0OMcNtvf5R9jnEGIoAXNzPXteYP4R4bL
         BK1E0lLb1+42rd7elzGK+5MjFbCjjCE9O0CdrRM4=
Date:   Thu, 12 Nov 2020 08:55:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-11-10
Message-ID: <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 16:19:51 -0800 Tony Nguyen wrote:
> This series contains updates to i40e and igc drivers and the MAINTAINERS
> file.
> 
> Slawomir fixes updating VF MAC addresses to fix various issues related
> to reporting and setting of these addresses for i40e.
> 
> Dan Carpenter fixes a possible used before being initialized issue for
> i40e.
> 
> Vinicius fixes reporting of netdev stats for igc.
> 
> Tony updates repositories for Intel Ethernet Drivers.

Pulled, thanks!

Please double check the use of the spin lock in patch 3. Stats are
updated in an atomic context when read from /proc, you probably need 
to convert that spin lock to _bh.
