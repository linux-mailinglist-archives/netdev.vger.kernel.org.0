Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADD47F4B6
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbfHBKIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 06:08:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbfHBKIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 06:08:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EFA426079C; Fri,  2 Aug 2019 10:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564740491;
        bh=xz9w0+aLOrKW8e4WbfqeN6YPcjyXc3C+PdLcAJ/KxeA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EsT4dukRw4sikWspz/rvp2DfOqglRWlAQ63oc5eEzT9LuD6B+MWy7PTeRf1uFcHDm
         9AENIQzscv83SHdZGN7mR7bU1MQRpLNHJ2fHgFLwzPZin4qEE1zufrqFIpLhlpEsoi
         pSFfJe/uCmgUOyny7xRXle6dMJsAJNv6KpHka/mo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 835F46055D;
        Fri,  2 Aug 2019 10:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564740489;
        bh=xz9w0+aLOrKW8e4WbfqeN6YPcjyXc3C+PdLcAJ/KxeA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=la29ZdGcyC0KI0VVTOIu6v6lVSBzfZ27VvHODNQVelTnj1pzwuS/BPMPjvW9setie
         tmjHW8n6dTJMm3ViQcZrvXKFQqKTFB2Q1XBbF5a1CCUWtvW5MFg77wPeR9VCc1tKvd
         JUee3GiaBJcfz0XiX5aL+8yJya2ofGisYIzzfhYc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 835F46055D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Remove pointless cond_resched() wrapper
References: <alpine.DEB.2.21.1907262157500.1791@nanos.tec.linutronix.de>
Date:   Fri, 02 Aug 2019 13:08:05 +0300
In-Reply-To: <alpine.DEB.2.21.1907262157500.1791@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Fri, 26 Jul 2019 22:00:23 +0200
        (CEST)")
Message-ID: <877e7vkhh6.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Thomas Gleixner <tglx@linutronix.de> writes:

> cond_resched() can be used unconditionally. If CONFIG_PREEMPT is set, it
> becomes a NOP scheduler wise.
>
> Also the B43_BUG_ON() in that wrapper is a homebrewn variant of
> __might_sleep() which is part of cond_resched() already.
>
> Remove the wrapper and invoke cond_resched() directly.
>
> Found while looking for CONFIG_PREEMPT dependent code treewide.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>

I use patchwork and this doesn't show there as our patchwork follows
only linux-wireless linux. Can you resend and Cc also
linux-wireless@vger.kernel.org, please?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
