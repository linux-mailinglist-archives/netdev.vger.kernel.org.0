Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472AC6867C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfGOJlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:41:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOJlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:41:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F2A9961112; Mon, 15 Jul 2019 09:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183663;
        bh=ct7GW0Ok2mMfuRL4Gmv0L86fX5Qb6y+3jIfZFn5anmo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kL4AAtZ0r8F6fRv2EDdEnQKRcPdpf7MYj/bpbbD2nM9PwSI3PGCm636Vqz/yGNkub
         It1ZKpf96XPugn92NuEx1/75YTUKGdh16ejDgVXQi92I8FuAbG1SNjJgU8Kn7jEpMG
         gKZTninbXm17NJ+R5U6tNlSiZw1stYo9Za2UBAZk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCF8660E3F;
        Mon, 15 Jul 2019 09:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183662;
        bh=ct7GW0Ok2mMfuRL4Gmv0L86fX5Qb6y+3jIfZFn5anmo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R4YBFv4DQa25OT3GB/6w5GR6GKkwS7JUXpuRxxptKvyX3XDkivKZkNI1lEubP1JS1
         q0OROiXlk7NRaEar58+Z9ghlIJJGxbre0UzQ6IpIbpi+yaoTXjMML1ADRYQsbpU4DH
         s+YbDZO9W7iEnuvO7kBVhmfDp8JDVdzb/boN32ro=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCF8660E3F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wl3501_cs: remove redundant variable ret
References: <20190705103732.30568-1-colin.king@canonical.com>
Date:   Mon, 15 Jul 2019 12:40:58 +0300
In-Reply-To: <20190705103732.30568-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 5 Jul 2019 11:37:32 +0100")
Message-ID: <87zhlfprdh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The variable ret is being initialized with a value that is never
> read and it is being updated later with a new value that is returned.
> The variable is redundant and can be replaced with a return 0 as
> there are no other return points in this function.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/wl3501_cs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
> index a25b17932edb..007bf6803293 100644
> --- a/drivers/net/wireless/wl3501_cs.c
> +++ b/drivers/net/wireless/wl3501_cs.c
> @@ -1226,7 +1226,6 @@ static int wl3501_init_firmware(struct wl3501_card *this)
>  static int wl3501_close(struct net_device *dev)
>  {
>  	struct wl3501_card *this = netdev_priv(dev);
> -	int rc = -ENODEV;

I'll manually fix the commit log with:

s/variable ret/variable rc/

-- 
Kalle Valo
