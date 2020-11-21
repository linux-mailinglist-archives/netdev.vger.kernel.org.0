Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1D2BBC36
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgKUCWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKUCWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 21:22:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE85223FD;
        Sat, 21 Nov 2020 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605925340;
        bh=blEzB9181ZdOh4kOcpju433zu2gnv8R4ne5lcjvGRMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyM6kwOCxF04/DKj31P5DFOqUm9A5kEQ1obXZLfbfpuRCFPDkXHijp+81Zsm1Ktwa
         576jAuS4vft6/xWy+RgAH7NHNOzTlvbEVnjLY6F6eG7+DCVCDBGODGF7uimwYc3zev
         LQHV6oVAqnKT3710lvIG4Q0UIj7FAOh6P0+0qX7Q=
Date:   Fri, 20 Nov 2020 18:22:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, kernel-team@fb.com, edumazet@google.com,
        brakmo@fb.com, alexanderduyck@fb.com, weiwan@google.com
Subject: Re: [net PATCH 0/2] tcp: Address issues with ECT0 not being set in
 DCTCP packets
Message-ID: <20201120182219.4f83557a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
References: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 13:23:43 -0800 Alexander Duyck wrote:
> This patch set is meant to address issues seen with SYN/ACK packets not
> containing the ECT0 bit when DCTCP is configured as the congestion control
> algorithm for a TCP socket.
> 
> A simple test using "tcpdump" and "test_progs -t bpf_tcp_ca" makes the
> issue obvious. Looking at the packets will result in the SYN/ACK packet
> with an ECT0 bit that does not match the other packets for the flow when
> the congestion control agorithm is switch from the default. So for example
> going from non-DCTCP to a DCTCP congestion control algorithm we will see
> the SYN/ACK IPV6 header will not have ECT0 set while the other packets in
> the flow will. Likewise if we switch from a default of DCTCP to cubic we
> will see the ECT0 bit set in the SYN/ACK while the other packets in the
> flow will not.

Applied, thanks!
