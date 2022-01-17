Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4BD49085D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiAQML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:11:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38528 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiAQML6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:11:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8AE61171;
        Mon, 17 Jan 2022 12:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB9CC36AE3;
        Mon, 17 Jan 2022 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642421517;
        bh=6OapI7HG5+JvXcjhQ4RNwOTwEz8NgDsoFy++fuoJeZM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EF8ZbFnuYHoObTvwKrVGQ0PXhzn1zC43qh+q6J2ApP295CNJngmV6bDfdWsZ64CFG
         YUaqIj4UYEEWtmIrGgE251aqAV6nnu4Y4uDnFAUhr12c+jvivCWyl4QgEf5GpqG//a
         mlK1QEwQqVlWgu2xDeQLMfh5xZVng+1Fh+giyGkFZhGgnorBP1MLMQxnF/ifKrsRg6
         NcpYtqk7dl8hG/h2NOmZCZ6OiZJPAizsXGEVUNxyhDYTEvX68wgz6eBdUeIfYfyiTN
         R5NrComeByw1fw9+dgEHq0twqI+nOISHhDpnTnbLTMGg2ZIOoPV2dFEw8BzuVzZdOK
         E5VHEbGqyhHLA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>
Subject: Re: [PATCH 1/4] rtw88: pci: Change type of rtw_hw_queue_mapping() and ac_to_hwq to enum
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
        <20220114234825.110502-2-martin.blumenstingl@googlemail.com>
Date:   Mon, 17 Jan 2022 14:11:50 +0200
In-Reply-To: <20220114234825.110502-2-martin.blumenstingl@googlemail.com>
        (Martin Blumenstingl's message of "Sat, 15 Jan 2022 00:48:22 +0100")
Message-ID: <87k0eysgs9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
> rtw_tx_queue_type. Change their types to reflect this to make it easier
> to understand this part of the code.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index a0991d3f15c0..13f1f50b2867 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -669,7 +669,7 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
>  	spin_unlock_bh(&rtwpci->irq_lock);
>  }
>  
> -static u8 ac_to_hwq[] = {
> +static enum rtw_tx_queue_type ac_to_hwq[] = {
>  	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
>  	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
>  	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,

Shouldn't ac_to_hwq be static const?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
