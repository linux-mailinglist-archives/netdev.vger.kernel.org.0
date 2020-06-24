Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49634206923
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbgFXArj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgFXArj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:47:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992CC2078E;
        Wed, 24 Jun 2020 00:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592959658;
        bh=l5mG4HDXdmGZW5S5dZ5I1aZpP53Y6yIihQZc8wvFoEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUhUg3Fr9gqg3unK70fLleEnilPYbJHeT6j8x+PYMa+d2IKVDqSvpYzX/8pvuB+RM
         Lj+uwO+uwef91e892cvjg3Bd+WF47xWkEVAmIHKxDgeKIMVdF48ztROs+CIiLAHhmg
         wKrHQfYDw4DQMyvWRD/Mors0OWtlh9DsxOtMnqws=
Date:   Tue, 23 Jun 2020 17:47:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 3/4] bnxt_en: Fix statistics counters issue during
 ifdown with older firmware.
Message-ID: <20200623174736.0785ebcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1592953298-20858-4-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
        <1592953298-20858-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 19:01:37 -0400 Michael Chan wrote:
> On older firmware, the hardware statistics are not cleared when the
> driver frees the hardware stats contexts during ifdown.  The driver
> expects these stats to be cleared and saves a copy before freeing
> the stats contexts.  During the next ifup, the driver will likely
> allocate the same hardware stats contexts and this will cause a big
> increase in the counters as the old counters are added back to the
> saved counters.
> 
> We fix it by making an additional firmware call to clear the counters
> before freeing the hw stats contexts when the firmware is the older
> 20.x firmware.
> 
> Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
> Reported-by: Jakub Kicinski <kicinski@fb.com>
> Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Tested-by: Jakub Kicinski <kicinski@fb.com>

Thanks Michael!
