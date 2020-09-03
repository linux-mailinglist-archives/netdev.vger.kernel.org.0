Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661FD25C947
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgICTSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgICTSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 15:18:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544D22083B;
        Thu,  3 Sep 2020 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599160685;
        bh=jA9CJjgvkNQcDNJXVA/ZoKkZjnuffGg1MniFd0r7O6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t4sHcoeRTqM0VzAvcNUV1W3jAYT+WiVpN6PB1/IyzkqxB2NmJziQfhYptpxXbLVk4
         DdTSGwfweXnwsmZRrcwJBYU+rideUJHx0WnfvGBTmUgUmN8u0FHA+srhiW/5L3iGze
         huPxk/qg3h8yAaIcy/ZnY+0x3DJW+l/JXw1Ha8IE=
Date:   Thu, 3 Sep 2020 12:18:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
Message-ID: <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> This patchset adds tracepoints support for mailbox.
> In Octeontx2, PFs and VFs need to communicate with AF
> for allocating and freeing resources. Once all the
> configuration is done by AF for a PF/VF then packet I/O
> can happen on PF/VF queues. When an interface
> is brought up many mailbox messages are sent
> to AF for initializing queues. Say a VF is brought up
> then each message is sent to PF and PF forwards to
> AF and response also traverses from AF to PF and then VF.
> To aid debugging, tracepoints are added at places where
> messages are allocated, sent and message interrupts.
> Below is the trace of one of the messages from VF to AF
> and AF response back to VF:

Could you use the devlink tracepoint? trace_devlink_hwmsg() ?
