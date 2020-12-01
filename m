Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463BD2C9E88
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 11:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403791AbgLAKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 05:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388122AbgLAKBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 05:01:49 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E18C0613CF;
        Tue,  1 Dec 2020 02:01:09 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kk2Sy-000RHc-KT; Tue, 01 Dec 2020 11:01:00 +0100
Message-ID: <3025db173074d4dfbc323e91d3586f0e36426cf0.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: cfg: enforce sanity checks for key_index
 in ieee80211_del_key()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Date:   Tue, 01 Dec 2020 11:00:37 +0100
In-Reply-To: <20201201095639.63936-1-anant.thazhemadam@gmail.com> (sfid-20201201_105711_390361_13D95CBF)
References: <20201201095639.63936-1-anant.thazhemadam@gmail.com>
         (sfid-20201201_105711_390361_13D95CBF)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-01 at 15:26 +0530, Anant Thazhemadam wrote:
> Currently, it is assumed that key_idx values that are passed to
> ieee80211_del_key() are all valid indexes as is, and no sanity checks
> are performed for it.
> However, syzbot was able to trigger an array-index-out-of-bounds bug
> by passing a key_idx value of 5, when the maximum permissible index
> value is (NUM_DEFAULT_KEYS - 1).
> Enforcing sanity checks helps in preventing this bug, or a similar
> instance in the context of ieee80211_del_key() from occurring.

I think we should do this more generally in cfg80211, like in
nl80211_new_key() we do it via cfg80211_validate_key_settings().

I suppose we cannot use the same function, but still, would be good to
address this generally in nl80211 for all drivers.

johannes

