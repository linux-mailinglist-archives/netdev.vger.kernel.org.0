Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A615B319B6F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBLIo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhBLIos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:44:48 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC62C061756;
        Fri, 12 Feb 2021 00:44:06 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAU3X-001mBP-0T; Fri, 12 Feb 2021 09:44:03 +0100
Message-ID: <9e24638bdadeb4f08bcc8a130d8e0fa416d0e595.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Date:   Fri, 12 Feb 2021 09:44:02 +0100
In-Reply-To: <991c55472dd1f2be79438fbc11f2aa6d96ce5075.camel@sipsolutions.net>
References: <20201215172352.5311-1-youghand@codeaurora.org>
         <991c55472dd1f2be79438fbc11f2aa6d96ce5075.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-12 at 09:42 +0100, Johannes Berg wrote:
> On Tue, 2020-12-15 at 22:53 +0530, Youghandhar Chintala wrote:
> > The right fix would be to pull the entire data path into the host
> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -748,6 +748,8 @@ struct ieee80211_if_mesh {
> >   *	back to wireless media and to the local net stack.
> >   * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
> >   * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
> > + * @IEEE80211_SDATA_DISCONNECT_HW_RESTART: Disconnect after hardware restart
> > + *	recovery
> 
> How did you model this on IEEE80211_SDATA_DISCONNECT_RESUME, but than
> didn't check how that's actually used?
> 
> Please change it so that the two models are the same. You really don't
> need the wiphy flag.

In fact, you could even simply
generalize IEEE80211_SDATA_DISCONNECT_RESUME
and ieee80211_resume_disconnect() to _reconfig_ instead of _resume_, and
call it from the driver just before requesting HW restart.

johannes

