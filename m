Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B74B2F0FB8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbhAKKJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:09:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37648 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbhAKKJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:09:50 -0500
Date:   Mon, 11 Jan 2021 11:09:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610359748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OStc6tYhGtUgpIIfKJXOMyhkrYNa5qWoDdt0j5xoqgc=;
        b=DuyBy4hxTBJdMtP7AFTvG0WW5VrU3Hr1MEIUtKn24cvaFonRhrC3tRjj6D0Km18kqD6pCo
        FDZcXQ43WHf0GMyuPB3gS9qI5u/Oni/PeG5lBnum+WW3uLgjQb1JWi4cqy13HzocRD/+72
        IzOK+IZBIhuxLCNac4PH/8ETGtLFCunxeBeq4qkPliUc8DZ2V4ykvXR6zV0PHnAzqfcINS
        mL255dTxi33nvncmRsFYMtH92U36Kfsq8ca9IKU7D9IgVDnPpK8XsEDd7nvQzlTWKxOTpl
        x5hldRATtKAvwS74z4tIgbcAXsIAMPjzn1RzYdm7tRwr3FfRcymBtt2OgezAaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610359748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OStc6tYhGtUgpIIfKJXOMyhkrYNa5qWoDdt0j5xoqgc=;
        b=d99FN6Gez6PbK0zyvrWL39yaAz+q6o52ruTW8Di/LTRqkRxSbjEjjIXMD4F62RlQX/iB8a
        aVYrrZ25VfzCPACA==
From:   "Sebastian A. Siewior" <bigeasy@linutronix.de>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/1] net: arcnet: Fix RESET sequence
Message-ID: <20210111100907.tacvfj6ghtwkpyy6@linutronix.de>
References: <20201222090338.186503-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201222090338.186503-1-a.darwish@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-22 10:03:37 [+0100], Ahmed S. Darwish wrote:
>   2) arcnet_close() contains a del_timer_sync(). If the irq handler
>      interrupts the to-be-deleted timer then call del_timer_sync(), it
>      will just loop forever.

del_timer_sync() will trigger a warning if invoked from interrupt
handler.

Sebastian
