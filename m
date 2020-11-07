Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F32AA781
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgKGTF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGTFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 14:05:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5303920723;
        Sat,  7 Nov 2020 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604775924;
        bh=8fWLXDQlyjpLjqE8nQkeawiaMwDglWHjOPFr7FpBmKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J7ycqieMurND6gG6r+DjJCYUxS6RGDgWjmwiBk+UjHNF2/ssfJz9v0ZHRNkrC5V/S
         yNvTjsmQCYbJpqYXUAR2kV5LvUKqoG9QESW2vDsjihCls832VMhE5/aqmFuIHKVqyz
         7CDe9s1vqmzIqNChNVAmWgPI73DiBQQ5iCT8U7QY=
Date:   Sat, 7 Nov 2020 11:05:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David.Laight@aculab.com, johannes@sipsolutions.net,
        nstange@suse.de, derosier@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        michael.hennerich@analog.com, linux-wpan@vger.kernel.org,
        stefan@datenfreihafen.org, inaky.perez-gonzalez@intel.com,
        linux-wimax@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, stf_xl@wp.pl, pkshih@realtek.com,
        ath11k@lists.infradead.org, ath10k@lists.infradead.org,
        wcn36xx@lists.infradead.org, merez@codeaurora.org,
        pizza@shaftnet.org, Larry.Finger@lwfinger.net,
        amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: Re: [PATCH net v2 00/21] net: avoid to remove module when its
 debugfs is being used
Message-ID: <20201107110522.2a796f1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 17:21:31 +0000 Taehee Yoo wrote:
> When debugfs file is opened, its module should not be removed until
> it's closed.
> Because debugfs internally uses the module's data.
> So, it could access freed memory.
> 
> In order to avoid panic, it just sets .owner to THIS_MODULE.
> So that all modules will be held when its debugfs file is opened.

Hm, looks like some of the patches need to be revised because
.owner is already set in the ops, and a warning gets generated.

Also it'd be good to mention why Johannes's approach was abandoned.

When you repost please separate out all the patches for
drivers/net/wireless/ and send that to Kalle's wireless drivers tree.
Patch 1 needs to be split in two. Patches 2 and 3 would go via Johannes.
The wimax patch needs to go to staging (wimax code has been moved).
The remaining patches can be posted individually, not as a series.
