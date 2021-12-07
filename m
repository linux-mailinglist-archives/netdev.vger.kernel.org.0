Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FC446B8A1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhLGKTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhLGKTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:19:49 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF6EC061574;
        Tue,  7 Dec 2021 02:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=IcqXxtNVsaj3hjwuuMq/DQ1XtggkrgP1L9GHFlTa330=;
        t=1638872179; x=1640081779; b=npWwC2njL4318rEmntMaZX+oOVSBPFDMKSF/FQcuRtnF5CY
        VI8E5SWZg+8ugLdZwA2Sojn2DcihFM+zfaBx+LlI0PlLsUTCYjA3Nyfr3FKhntme24nNviZzG0xue
        8yqEN3Zps8mjNkxd6eBTs4hz0Y+uFFHpi+6WaFD6VNA648EHogKg4cSEanzldibN/h17B52HrN8z0
        BP/OZmqNL9ZQPR3OfwwG57aDAlK8XZixkfAN5X6qyfedHEOWSMpbn2WODzPGt/FqvXSr4YUgUKlIP
        MHH+tDtxzNwjmR2mGswsPxclB9YyRWJdc0K753T7VUPlORZrNMFOfs82mTgKdujw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1muXW4-0088sO-KB;
        Tue, 07 Dec 2021 11:16:08 +0100
Message-ID: <fd1f5c0f0a9a6b3f59ed0d03e963f87bf745705f.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] iwlwifi: fix LED dependencies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 11:16:07 +0100
In-Reply-To: <c9acebcef9504ac6889de25d528c3ea0c590b1c1.camel@sipsolutions.net>
References: <20211204173848.873293-1-arnd@kernel.org>
         <c9acebcef9504ac6889de25d528c3ea0c590b1c1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 11:14 +0100, Johannes Berg wrote:
> On Sat, 2021-12-04 at 18:38 +0100, Arnd Bergmann wrote:
> >  
> >  config IWLWIFI_LEDS
> >  	bool
> > -	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
> > +	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> > 
> 
> Hm. Can we really not have this if LEDS_CLASS=n?
> 

Well, umm. That wouldn't make sense for IWLWIFI_LEDS, sorry.

Might be simpler to express this as "depends on MAC80211_LEDS" which has
the same condition, and it feels like that makes more sense than
referencing MAC80211 here?

johannes
