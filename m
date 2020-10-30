Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D5B2A00CC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgJ3JJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgJ3JJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:09:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAD2C0613CF;
        Fri, 30 Oct 2020 02:09:03 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kYQOw-00FLjK-8q; Fri, 30 Oct 2020 10:08:50 +0100
Message-ID: <923bdb745be04732ee451b8d1b78b3d915b54b16.camel@sipsolutions.net>
Subject: Re: [PATCH][next] nl80211/cfg80211: fix potential infinite loop
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tova Mussai <tova.mussai@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 30 Oct 2020 10:08:49 +0100
In-Reply-To: <20201029222407.390218-1-colin.king@canonical.com>
References: <20201029222407.390218-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 22:24 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The for-loop iterates with a u8 loop counter and compares this
> with the loop upper limit of request->n_ssids which is an int type.
> There is a potential infinite loop if n_ssids is larger than the
> u8 loop counter, so fix this by making the loop counter an int.

Makes sense, thanks. I'll apply it to next.

For the record, it shouldn't be possible for request->n_ssids to be
larger than what the driver limit was, and that's 20 by default and
doesn't make sense to be really much higher than that, so in practice
this won't happen.

johannes

