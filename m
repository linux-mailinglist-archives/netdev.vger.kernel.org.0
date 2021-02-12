Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACCA319C87
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 11:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhBLKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 05:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhBLKSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 05:18:55 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1FFC061574;
        Fri, 12 Feb 2021 02:18:15 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAVWb-001nzl-Fy; Fri, 12 Feb 2021 11:18:09 +0100
Message-ID: <0a95501d45fd23baa7ce5bab88c033380e2d095b.camel@sipsolutions.net>
Subject: Re: Potential invalid ~ operator in net/mac80211/cfg.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 12 Feb 2021 11:18:08 +0100
In-Reply-To: <86c1e5aa-459d-6d76-69e4-f7bc177214bf@canonical.com>
References: <4bb65f2f-48f9-7d9c-ab2e-15596f15a4d8@canonical.com>
         <15f435a791b0c4b853c8c6b284042c7057d6efaf.camel@sipsolutions.net>
         <1383c6f1-1317-daed-ecc7-e5cc3f309c41@canonical.com>
         <86c1e5aa-459d-6d76-69e4-f7bc177214bf@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-05 at 18:20 +0000, Colin Ian King wrote:
> 
> > > https://lore.kernel.org/linux-wireless/516C0C7F.3000204@openwrt.org/
> > > 
> > > But maybe that isn't actually quite right due to integer promotion?
> > > OTOH, that's a u8, so it should do the ~ in u8 space, and then compare
> > > to 0 also?
> > 
> > rc_rateidx_vht_mcs_mask is a u64, so I think the expression could be
> > expressed as:
> 
> oops, fat fingered that, it is a u16 not a u64

Right, u16, I must've looked at some ancient version or something.

But no, I was obviously wrong with what I said above.

So of course the condition is always true, like you said.

However, what was intended doesn't look like !, but rather == 0xff and
== 0xffff respectively, I'll send a patch.

johannes

