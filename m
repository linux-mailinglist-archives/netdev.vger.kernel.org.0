Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A29B3002ED
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbhAVM2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbhAVM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:27:47 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A0FC06174A;
        Fri, 22 Jan 2021 04:27:07 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l2vWq-00A8qY-EG; Fri, 22 Jan 2021 13:27:04 +0100
Message-ID: <4ae7a27c32cbf85b4ddb05cc2a16e52918663633.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Date:   Fri, 22 Jan 2021 13:27:03 +0100
In-Reply-To: <6569c83a-11b0-7f13-4b4c-c0318780895c@samsung.com>
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
         <CGME20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458@eucas1p2.samsung.com>
         <6569c83a-11b0-7f13-4b4c-c0318780895c@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> This patch landed in today's (20210122) linux-next as commit 
> 791daf8fc49a ("cfg80211: avoid holding the RTNL when calling the 
> driver"). Sadly, it causes deadlock with mwifiex driver. I think that 
> lockdep report describes it enough:

Yeah, umm, sorry about that. Evidently, I somehow managed to put
"wiphy_lock()" into that part of the code, rather than "wiphy_unlock()"!

I'll fix, thanks!

johannes

