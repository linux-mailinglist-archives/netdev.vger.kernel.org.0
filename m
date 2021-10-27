Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD2C43CE2F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbhJ0QDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhJ0QD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB0460720;
        Wed, 27 Oct 2021 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635350464;
        bh=YT8751DQ/g/rL9z8Pb2gfJnxUep22WxJVClsHY6PgiI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LoQ67/edgQ//AsKgqY+zDIh1BBtxvwvlP6WP9jlLiHTMgBbXosbA02zJsznOY9lOX
         yHUkWJB6pW40Oq2EDCSADyzfSJGx0p3yVbCnTkUzXKmhl5A5tFFJVcubMySk+PCleq
         wW7bm9DD314QUC/+beyzOTjEIL5TBEmmyrJ53f8Ki0ivReh6piZNOkVNQr+B+393W9
         GwLmDtuDXTOPtwbOZbPjnyI0bCZJ6GyUPTWKFGhKIcxsZOd2PKuqxPNd7RM8try1Jc
         1NZYoPOozEPiMmthiD40uqejRhaasQqYZoO6Xc6ujEwt4QoZhPkWzObRW+9T2PtFZK
         waKXbwdu1YG2Q==
Date:   Wed, 27 Oct 2021 09:01:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Caleb Sander <csander@purestorage.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Joern Engel <joern@purestorage.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 1/4] i40e: avoid spin loop in
 i40e_asq_send_command()
Message-ID: <20211027090103.33e06b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
        <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 10:55:05 -0700 Tony Nguyen wrote:
> +			cond_resched();
>  			udelay(50);

Why not switch to usleep_range() if we can sleep here?
