Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640FD2C9542
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgLACeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbgLACeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:34:46 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D09820809;
        Tue,  1 Dec 2020 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606790045;
        bh=oR1YBZYi5p1n81/1EOD2tYn7V7/76HwcvXB8UHATAQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwvvnmNrWnuxroqHCRTyFJpGHumGJAWIzL5YZDcUuHoCCGaQC8O3WPnBQdIa2u4CJ
         p8eGb9mcddyyLn+MJ7zLUtrRpiEwAtfy4/8ZTGI5aEGWJesuzzDTAghsEURXX1BcwG
         br2GQsXp3efo7mfTkUwsN57H4jVfflf/QZGLoz5k=
Date:   Mon, 30 Nov 2020 18:34:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 0/6] mptcp: avoid workqueue usage for data
Message-ID: <20201130183404.01abe8dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 11:10:21 +0100 Paolo Abeni wrote:
> The current locking schema used to protect the MPTCP data-path
> requires the usage of the MPTCP workqueue to process the incoming
> data, depending on trylock result.
> 
> The above poses scalability limits and introduces random delays
> in MPTCP-level acks.
> 
> With this series we use a single spinlock to protect the MPTCP
> data-path, removing the need for workqueue and delayed ack usage.
> 
> This additionally reduces the number of atomic operations required
> per packet and cleans-up considerably the poll/wake-up code.

Applied, thanks!
