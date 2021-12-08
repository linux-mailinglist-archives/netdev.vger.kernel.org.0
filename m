Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B146D619
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhLHOyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:54:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50388 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbhLHOyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:54:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CE71B81CF1;
        Wed,  8 Dec 2021 14:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A4AC00446;
        Wed,  8 Dec 2021 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638975026;
        bh=xCd+Ek+0L9WQ4tTA1dWnfyB0nv+bIPj5lTDb8/UQHLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PElFEWn144eCM/ziMqXPbYVOGAZHWOC8+swB4dzmCTx6vwqY0ePpOCCz1VsSlgO8V
         Rg3gZxSknogfu0aMEQEXzACQAl2Of1sTvEpFUK7rx0nvsSwfCa+PbigRv+l9h8GyVz
         HvC5ugHOFXjXfzGQ5LgHO8XM7LtBxJVdRXHHbDizJCAfPhpJ7m3Oss5Z0lZQf9wYvq
         bzBeOwFRsWyLAm3RU940O78nDtz5quHOEIRCIb/DFb0jUZRoJikOzCvHgoRmukQKBL
         eBwbZuZuPxPfEkJfjo7r1+zmiFGhndNKlZ7uQX/mIUcNzEg0xcvPdMj9776wpe4NWR
         PRA/gP8mWv4HA==
Date:   Wed, 8 Dec 2021 06:50:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
Message-ID: <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87tufjfrw0.fsf@codeaurora.org>
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tufjfrw0.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Dec 2021 10:00:15 +0200 Kalle Valo wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Tue,  7 Dec 2021 14:42:11 +0000 (UTC) Kalle Valo wrote:  
> >> here's a pull request to net-next tree, more info below. Please let me know if
> >> there are any problems.  
> >
> > Pulled, thanks! Could you chase the appropriate people so that the new
> > W=1 C=1 warnings get resolved before the merge window's here?
> >
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211207144211.A9949C341C1@smtp.kernel.org/  
> 
> Just so that I understand right, you are referring to this patchwork
> test:
> 
>   Errors and warnings before: 111 this patch: 115
> 
>   https://patchwork.hopto.org/static/nipa/591659/12662005/build_32bit/
> 
> And you want the four new warnings to be fixed? That can be quite time
> consuming, to be honest I would rather revert the commits than using a
> lot of my time trying to get people fix the warnings. Is there an easy
> way to find what are the new warnings?

Yeah, scroll down, there is a diff of the old warnings vs new ones, and
a summary of which files have changed their warning count:

+      2 ../drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+      3 ../drivers/net/wireless/intel/iwlwifi/mei/main.c
-      1 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+      2 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
-      2 ../drivers/net/wireless/microchip/wilc1000/wlan.c

So presumably these are the warnings that were added:

drivers/net/wireless/intel/iwlwifi/mei/main.c:193: warning: cannot understand function prototype: 'struct '
drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function parameter or member 'cldev' not described in 'iwl_mei_probe'
drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function parameter or member 'id' not described in 'iwl_mei_probe'

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28: warning: incorrect type in assignment (different base types)
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:    expected restricted __le32 [assigned] [usertype] period_msec
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:    got restricted __le16 [usertype]
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30: warning: incorrect type in assignment (different base types)
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:    expected unsigned char [assigned] [usertype] keep_alive_id
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:    got restricted __le16 [usertype]

drivers/net/wireless/intel/iwlwifi/mvm/ops.c:684:12: warning: context imbalance in 'iwl_mvm_start_get_nvm' - wrong count at exit

> But in the big picture are you saying the net trees now have a rule that
> no new W=1 and C=1 warnings are allowed? I do test ath10k and ath11k
> drivers for W=1 and C=1 warnings, but all other drivers are on their own
> in this regard. At the moment I have no tooling in place to check all
> wireless drivers.

For the code we merge directly we try to make sure there are no new
warnings. I realize it's quite a bit of work for larger trees unless 
you have the infra so not a hard requirement (for you).

FWIW the build bot we wrote is available on GH:

https://github.com/kuba-moo/nipa

But it currently hard codes tree matching logic for bpf and netdev,
so would probably take a few hours to adopt it.
