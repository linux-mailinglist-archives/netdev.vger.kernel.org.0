Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC7D2C4991
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgKYVI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbgKYVI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:08:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F10E206F9;
        Wed, 25 Nov 2020 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606338536;
        bh=Qnl/GZSXG3Q/uSLd95lx8IpC32MuLIMDcM9abz+pXr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JvkXv2M690IH9Fj99ASnrn+Iup65/JrUlsGqAke5dCUi4JkTKrS5/tU94qM7ZDQiP
         c8h3MKtO7TygySLp+NvjWKdP7a5WlsJ5HkKzWF/sgGm8trX/Odn8fO6YLYunRzMDAK
         Vqi3s2/eYCUgEkGdbSQGD6vsa3GJWMrqkycZRD3o=
Date:   Wed, 25 Nov 2020 13:08:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: Re: [PATCH net-next v2] ibmvnic: process HMC disable command
Message-ID: <20201125130855.7eb08d0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123235841.6515-1-drt@linux.ibm.com>
References: <20201123235841.6515-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 18:58:41 -0500 Dany Madden wrote:
> Currently ibmvnic does not support the "Disable vNIC" command from
> the Hardware Management Console. The HMC uses this command to disconnect
> the adapter from the network if the adapter is misbehaving or sending
> malicious traffic. The effect of this command is equivalent to setting
> the link to the "down" state on the linux client.
> 
> Enable support in ibmvnic driver for the Disable vNIC command.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

It seems that (a) user looking at the system where NIC was disabled has
no idea why netdev is not working even tho it's UP, and (b) AFAICT
nothing prevents the user from bringing the device down and back up
again.

You said this is to disable misbehaving and/or sending malicious vnic,
obviously the guest can ignore the command so it's not very dependable,
anyway.

Would it not be sufficient to mark the carrier state as down to cut the
vnic off?
