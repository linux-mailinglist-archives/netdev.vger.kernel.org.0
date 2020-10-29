Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4447529F41F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgJ2Sea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJ2Se2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 14:34:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B5B020825;
        Thu, 29 Oct 2020 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603996467;
        bh=fP/uVPZi0LUVGYE8DUr8VQFIQGDfZ+vs9v5SkNM7zyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f423O2UjQiVVT1+aNggoY+j2ueF1SO8Qk1qFAcb/noo80X1LuTa+wCO79X8Pexd8E
         5zLbNBHwayA0uwtCCW8ITySjZCxpI9WFzXrvKeKM/A+akqW72zA+7Dh3ejTgGsHrCQ
         odbHT8BQ6z2WBgl4X9DUJPAyOGDcJ7sFYvGDOgBM=
Date:   Thu, 29 Oct 2020 11:34:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v3] ibmvnic: fix ibmvnic_set_mac
Message-ID: <20201029113426.09ff67ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027220456.71450-1-ljp@linux.ibm.com>
References: <20201027220456.71450-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 17:04:56 -0500 Lijun Pan wrote:
> Jakub Kicinski brought up a concern in ibmvnic_set_mac().
> ibmvnic_set_mac() does this:
> 
> 	ether_addr_copy(adapter->mac_addr, addr->sa_data);
> 	if (adapter->state != VNIC_PROBED)
> 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
> 
> So if state == VNIC_PROBED, the user can assign an invalid address to
> adapter->mac_addr, and ibmvnic_set_mac() will still return 0.
> 
> The fix is to validate ethernet address at the beginning of
> ibmvnic_set_mac(), and move the ether_addr_copy to
> the case of "adapter->state != VNIC_PROBED".
> 
> Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Applied, thanks.
