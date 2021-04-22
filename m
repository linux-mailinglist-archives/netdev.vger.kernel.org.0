Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F855367A84
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhDVHFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:05:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A8C06174A;
        Thu, 22 Apr 2021 00:04:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lZTNs-00F4p1-N9; Thu, 22 Apr 2021 09:04:20 +0200
Message-ID: <317099c78edb9fdde3db3f1e7c9a4f77529b281a.camel@sipsolutions.net>
Subject: Re: [PATCH][next] wireless: wext-spy: Fix out-of-bounds warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 22 Apr 2021 09:04:19 +0200
In-Reply-To: <20210421234337.GA127225@embeddedor>
References: <20210421234337.GA127225@embeddedor>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-21 at 18:43 -0500, Gustavo A. R. Silva wrote:
> 
>  	/* Just do it */
> -	memcpy(&(spydata->spy_thr_low), &(threshold->low),
> -	       2 * sizeof(struct iw_quality));
> +	memcpy(&spydata->spy_thr_low, &threshold->low, sizeof(threshold->low));
> +	memcpy(&spydata->spy_thr_high, &threshold->high, sizeof(threshold->high));
> 

It would've been really simple to stick to 80 columns here (and
everywhere in the patch), please do that.

Also, why not just use struct assigments?

	spydata->spy_thr_low = threshold->low;

etc.

Seems far simpler (and shorter lines).

johannes


