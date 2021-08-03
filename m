Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6523DF11B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhHCPJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:09:46 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:55456 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236614AbhHCPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:09:45 -0400
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id B31AA182CF66C;
        Tue,  3 Aug 2021 15:09:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 40962D1517;
        Tue,  3 Aug 2021 15:09:31 +0000 (UTC)
Message-ID: <e07dfde8aa6616887c74817bed1166510b5583dd.camel@perches.com>
Subject: Re: [PATCH 2/3][V2] rtlwifi: rtl8192de: make arrays static const,
 makes object smaller
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 03 Aug 2021 08:09:29 -0700
In-Reply-To: <20210803144949.79433-2-colin.king@canonical.com>
References: <20210803144949.79433-1-colin.king@canonical.com>
         <20210803144949.79433-2-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 40962D1517
X-Spam-Status: No, score=0.10
X-Stat-Signature: qfyjgjxee9wo91ryrqsmtk1g8nbwy61c
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/hQZTuO5PJBJ65UX12wm27sQMXQRdEsUQ=
X-HE-Tag: 1628003371-423443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-03 at 15:49 +0100, Colin King wrote:
> Don't populate arrays the stack but instead make them static const. Replace
> array channel_info with channel_all since it contains the same data as
> channel_all. Makes object code smaller by 961 bytes.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
[]
> @@ -160,6 +160,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
>  	25711, 25658, 25606, 25554, 25502, 25451, 25328
>  };
> 
> +static const u8 channel_all[59] = {

I don't believe there is a significant value in sizing the array
as 59 instead of letting the compiler count the elements.

> +	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
> +	36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
> +	60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
> +	114, 116, 118, 120, 122, 124, 126, 128,	130,
> +	132, 134, 136, 138, 140, 149, 151, 153, 155,
> +	157, 159, 161, 163, 165
> +};


