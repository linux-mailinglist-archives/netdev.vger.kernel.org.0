Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6185230E7D2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhBCXso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhBCXsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C8464F60;
        Wed,  3 Feb 2021 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612396081;
        bh=+6Wgzo0UAUksPUWapSep533wADw9r5wsvfB8fRBzU/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UIpgYckud7N2g2qsN2quewUJHN1CUfhAF2xZ2mhebPxmAgTlZ1pFi2i1CsFDlmmtt
         FV5l4wXK+VlOFUX90qIWpCk/8kGxGxOFbh6e6aTEsMvpxeb5KHUCf3IfB6QWsRf3s3
         Z4fdA6Q+ICKsQwqSTsnIK7vM3TofwoJjvDpC4SIolrap2mJPZo204ZtyPnB0BblQJv
         ni/AeyRm9iqFminn9qBX3VTMmeWnuus99o8CnpBVWde/lCR7gwnJ3kSJLcueqXCA2r
         xeleXlmjwqoauwANKqm8SuyqbtTQPU6bqIPnCupc8Wlz/i2dl3h6diFgdDF6SgymXf
         DC9/FjRrODCtg==
Date:   Wed, 3 Feb 2021 15:48:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Druzhinin <igor.druzhinin@citrix.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
Message-ID: <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202070938.7863-1-jgross@suse.com>
References: <20210202070938.7863-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 08:09:38 +0100 Juergen Gross wrote:
> Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> xenvif_rx_ring_slots_available() is no longer called only from the rx
> queue kernel thread, so it needs to access the rx queue with the
> associated queue held.
> 
> Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
> Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Should we route this change via networking trees? I see the bug did not
go through networking :)
