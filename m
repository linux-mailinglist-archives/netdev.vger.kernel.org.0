Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BF0250A2C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHXUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:40:57 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959B3205CB;
        Mon, 24 Aug 2020 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598301657;
        bh=o3rDkse2O5JZ0f2ny7SC1uSR1bFUJCe9dL1qo9ET1nk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFHLaquZBly5mbT+nCm7/xwtnjVaiGa0opMXfaLyRJkmq4e8VcSlnAI34xMpOF4tK
         zj6loyCqZAJbIms+/2XPJ9ype5Eij/t72c4xr/31S6Cus/BHpwZP/8wI+suQKrnC9S
         DWghZ1hgera43LKnxbILfYRpYNHjM/2Ko6+NXOXY=
Date:   Mon, 24 Aug 2020 13:40:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 11/15] iecm: Add splitq TX/RX
Message-ID: <20200824134054.4dd467bc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824173306.3178343-12-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-12-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 10:33:02 -0700 Tony Nguyen wrote:
>  void iecm_get_stats64(struct net_device *netdev,
>  		      struct rtnl_link_stats64 *stats)
>  {
> -	/* stub */
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +
> +	iecm_send_get_stats_msg(vport);

Doesn't this call sleep? This .ndo callback can't sleep.
