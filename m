Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECD2CA340
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 13:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbgLAM5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 07:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727712AbgLAM5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 07:57:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7C9C061A04;
        Tue,  1 Dec 2020 04:56:20 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kk5CZ-000W9o-07; Tue, 01 Dec 2020 13:56:15 +0100
Message-ID: <2007533d7d6466fc5e6b588df148238046e25b4c.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: cfg: enforce sanity checks for key_index
 in ieee80211_del_key()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Date:   Tue, 01 Dec 2020 13:56:13 +0100
In-Reply-To: <a122ca3c-6b1b-3d03-08e3-ac1906ab7389@gmail.com> (sfid-20201201_134519_457943_AF72D8E2)
References: <20201201095639.63936-1-anant.thazhemadam@gmail.com>
         <3025db173074d4dfbc323e91d3586f0e36426cf0.camel@sipsolutions.net>
         <1e5e4471-5cf4-6d23-6186-97f764f4d25f@gmail.com>
         <a6eb69000eb33ca8f59cbaff2afee205e0877eb8.camel@sipsolutions.net>
         <a122ca3c-6b1b-3d03-08e3-ac1906ab7389@gmail.com>
         (sfid-20201201_134519_457943_AF72D8E2)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-01 at 18:15 +0530, Anant Thazhemadam wrote:
> 
> cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher) returned
> false, and thus it worked for the syzbot reproducer.
> Would it be a safer idea to enforce the conditions that I initially put (in
> ieee80211_del_key()) directly in cfg80211_validate_key_settings() itself - by
> updating max_key_index, and checking accordingly?

Yes, I think so. But similarly to cfg80211_validate_key_settings() it
should look at the device capabilities (beacon protection, etc.)

Thanks!
johannes

