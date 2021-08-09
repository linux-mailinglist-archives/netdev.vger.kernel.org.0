Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4023E4F92
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhHIW4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233230AbhHIW4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 709716052B;
        Mon,  9 Aug 2021 22:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628549776;
        bh=he0+4XcfmIpvLNkZ3uazscP9HKpWnE5p3omx0Sgbm9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C9vEF6W4jTuzZq13vzXF4jlldLnYLLSceiEjOOeA0kQtjkjsZ3Cuuy88w4pNyY4vR
         64XIjSarTT8aIHLUz0mFbjZVhUJtS4TbffG8OSmv6UYpt+BgmTRloNhJguLcURiKIB
         dK8dduM7ZO7OYo+nw+gbg8/Tn8xGN/Tcszpv2jZsOGmiL/a8CWP5dY7+q0woduISQk
         oaQFQk3ehy2SJmUVzjN5mhrcBLFhk2LWAz4RqYlVrKK2yqM3zyl4448D9YGSV/exOM
         lr/VXp3CRKV6DCihxT0nkVwm3OILhoDHu7sKpsg/DU1WDb2AN+d1YbUuXPkjoeKAy6
         y98gNxrxdn4yg==
Date:   Mon, 9 Aug 2021 15:56:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 1/4] ice: Prevent probing virtual functions
Message-ID: <20210809155615.193bd6c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809171402.17838-2-anthony.l.nguyen@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
        <20210809171402.17838-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Aug 2021 10:13:59 -0700 Tony Nguyen wrote:
> The userspace utility "driverctl" can be used to change/override the
> system's default driver choices. This is useful in some situations
> (buggy driver, old driver missing a device ID, trying a workaround,
> etc.) where the user needs to load a different driver.
> 
> However, this is also prone to user error, where a driver is mapped
> to a device it's not designed to drive. For example, if the ice driver
> is mapped to driver iavf devices, the ice driver crashes.
> 
> Add a check to return an error if the ice driver is being used to
> probe a virtual function.

This seems too selective. Also drivers should not trust the HW is sane
and crash the kernel. Please fix the crashes and fail probe gracefully
in all cases without resorting to duct tape.
