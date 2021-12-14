Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF559474671
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhLNPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:31:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52538 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhLNPbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 10:31:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC85ECE1903;
        Tue, 14 Dec 2021 15:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB5BC34601;
        Tue, 14 Dec 2021 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639495873;
        bh=nIm7IP3pOSVJnjnVXQ9Ds8xTD2Whp9+vyIKmyYPKwgE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YQQKXqAkpyiAUzSd8+pmM5QYb+q0hRrZUMjB1UhJH+/c9O6wofnbfe+cEipEBUH2B
         HRqK6ThMBH26KhPpuFY6tmlVDNbFeL76CaFKCeE25/LrzXTiO6rujD3mBUZuNwwG6x
         tyEvELkXhrfW6I1+9TDI+M1WLQdkl/SZkIyQDCyf+GIRU5LxZZ6Sc69jIMqXwBagGi
         omI0S5WXSS1nhBoB8ETL1rFrXR/XFfJt5L33mbkZRxPoXXQamv1a4QEhbLw4Dfsmbx
         rM+iR2OR3fVdJmpytXcuNAWeZcv1fHSiUJM0bssJom12t6jq8a2XxcOoygyL+FaPjo
         OUPoggmB7D2HQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath11k: Fix a NULL pointer dereference in
 ath11k_mac_op_hw_scan()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211202155348.71315-1-zhou1615@umn.edu>
References: <20211202155348.71315-1-zhou1615@umn.edu>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     zhou1615@umn.edu, kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        kbuild test robot <lkp@intel.com>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163949586478.10444.18327229880355423779.kvalo@kernel.org>
Date:   Tue, 14 Dec 2021 15:31:09 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhou Qingyang <zhou1615@umn.edu> wrote:

> In ath11k_mac_op_hw_scan(), the return value of kzalloc() is directly
> used in memcpy(), which may lead to a NULL pointer dereference on
> failure of kzalloc().
> 
> Fix this bug by adding a check of arg.extraie.ptr.
> 
> This bug was found by a static analyzer. The analysis employs
> differential checking to identify inconsistent security operations
> (e.g., checks or kfrees) between two code paths and confirms that the
> inconsistent operations are not recovered in the current function or
> the callers, so they constitute bugs.
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.
> 
> Builds with CONFIG_ATH11K=m show no new warnings, and our static
> analyzer no longer warns about this code.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

eccd25136386 ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211202155348.71315-1-zhou1615@umn.edu/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

