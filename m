Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D1217B01
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgGGWaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgGGWaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 18:30:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E172075B;
        Tue,  7 Jul 2020 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594161006;
        bh=oPzY0gG9T1bPi6zV7COGHN22WmoxEJHF5fqvgiZhvfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Scsx36pmt7Y1n8Sf4TCjePFz578gOyGNiTozAIgK+1DGIJl6CPRAWg4lQa5SnHdH3
         xOAMqi9NOr3kJGgsCaNwE0l2aRsQw9nRQ5qhABUwtlk8QJUkKYwzID2/KM5dYP0vTd
         QXe3rir5O81Twxigkhb5oQMl5BuMGhtf5aivymdo=
Date:   Tue, 7 Jul 2020 15:30:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net] ionic: centralize queue reset code
Message-ID: <20200707153004.06f36127@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200707211326.11291-1-snelson@pensando.io>
References: <20200707211326.11291-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jul 2020 14:13:26 -0700 Shannon Nelson wrote:
> The queue reset pattern is used in a couple different places,
> only slightly different from each other, and could cause
> issues if one gets changed and the other didn't.  This puts
> them together so that only one version is needed, yet each
> can have slighty different effects by passing in a pointer
> to a work function to do whatever configuration twiddling is
> needed in the middle of the reset.
> 
> This specifically addresses issues seen where under loops
> of changing ring size or queue count parameters we could
> occasionally bump into the netdev watchdog.
> 
> v2: added more commit message commentary
> 
> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Acked-by: Jakub Kicinski <kuba@kernel.org>
