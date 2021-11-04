Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D9445950
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhKDSLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhKDSLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 14:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9208B611C3;
        Thu,  4 Nov 2021 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636049336;
        bh=xnNcXcazwQwUlo5RPHBcBCT74SiT22kEneLRSZIj/FQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tba14w+sKLD/aZF8PYdg0l92q+C+lx5K1JeX0grlk3OxVCjy6x6x7mJRtWA94BiMm
         vJen6WSh/YoC/2VRRSXlDRIzivYTN0/AVJCHUBOb1x60r6W+mZ3avmSizsuionzgva
         2LI+YVnx+FaoLOarVK3iFJAVSAEzgVBWDz+M7ZKQdoLoEr4jW/8kF7R6vXjecFtxlc
         4GwE507rYzZZ9CzXe3UzWYDVOfPA5NkZgvFb0Yt31vCpwVh/hEV+wAuUi/qyQXNgF+
         XpKYtJGP5IBBpoJhMjlD/J5FMLO1JFA82knblenO2WNNFTubNCSf4tGjubWSIjW8rM
         zVAtHaXBLWUNg==
Date:   Thu, 4 Nov 2021 11:08:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Message-ID: <20211104110855.3ead1642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211104081231.1982753-7-maciej.machnikowski@intel.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
        <20211104081231.1982753-7-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 09:12:31 +0100 Maciej Machnikowski wrote:
> +Synchronous Ethernet networks use a physical layer clock to syntonize
> +the frequency across different network elements.
> +
> +Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> +Equipment Clock (EEC) and can recover synchronization
> +from the synchronization inputs - either traffic interfaces or external
> +frequency sources.
> +The EEC can synchronize its frequency (syntonize) to any of those sources.
> +It is also able to select a synchronization source through priority tables
> +and synchronization status messaging. It also provides necessary
> +filtering and holdover capabilities.
> +
> +The following interface can be applicable to diffferent packet network types
> +following ITU-T G.8261/G.8262 recommendations.

Can we get a diagram in here in terms of how the port feeds its
recovered Rx freq into EEC and that feeds freq of Tx on other ports?

I'm still struggling to understand your reasoning around not making 
EEC its own object. "We can do this later" seems like trading
relatively little effort now for extra work for driver and application
developers for ever.

Also patch 3 still has a kdoc warning.
