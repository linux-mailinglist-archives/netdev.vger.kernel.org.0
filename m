Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359C22AD155
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgKJIdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJIdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 03:33:09 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92704C0613CF;
        Tue, 10 Nov 2020 00:33:09 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kcP5A-004ok0-0t; Tue, 10 Nov 2020 09:32:52 +0100
Message-ID: <29adbaa7a7f200589e56566069270c857fcba015.camel@sipsolutions.net>
Subject: Re: [PATCH net v2 00/21] net: avoid to remove module when its
 debugfs is being used
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David.Laight@aculab.com, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Date:   Tue, 10 Nov 2020 09:32:49 +0100
In-Reply-To: <20201107110522.2a796f1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201107172152.828-1-ap420073@gmail.com>
         <20201107110522.2a796f1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-07 at 11:05 -0800, Jakub Kicinski wrote:
> On Sat,  7 Nov 2020 17:21:31 +0000 Taehee Yoo wrote:
> > When debugfs file is opened, its module should not be removed until
> > it's closed.
> > Because debugfs internally uses the module's data.
> > So, it could access freed memory.
> > 
> > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > So that all modules will be held when its debugfs file is opened.
> 
> Hm, looks like some of the patches need to be revised because
> .owner is already set in the ops, and a warning gets generated.
> 
> Also it'd be good to mention why Johannes's approach was abandoned.

Well, I had two.

One was awful, and worked in all cases.

The other was less awful, and didn't work in all cases.

I think both gave Al Viro hives ;-)

> Patch 1 needs to be split in two. Patches 2 and 3 would go via Johannes.

FWIW, I'm happy for you to take patches 2 and 3 as well, but I guess if
patch 1 needs to be split there's a resend coming anyway, so then I'll
be happy to take the patches 2/3 from a separate set.

johannes


