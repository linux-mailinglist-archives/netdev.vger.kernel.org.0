Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4403DD217
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhHBIft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:35:49 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:43942 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232799AbhHBIfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:35:48 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 1695C180A8859;
        Mon,  2 Aug 2021 08:35:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 7C09F2EBFBF;
        Mon,  2 Aug 2021 08:35:36 +0000 (UTC)
Message-ID: <3f55848b4612d1b17d95a4c36bec1dee2b1814f1.camel@perches.com>
Subject: Re: [PATCH 1/2] rtlwifi: rtl8192de: Remove redundant variable
 initializations
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 02 Aug 2021 01:35:35 -0700
In-Reply-To: <20210731124044.101927-1-colin.king@canonical.com>
References: <20210731124044.101927-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.10
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 7C09F2EBFBF
X-Stat-Signature: u1zu3eenyuecqkjwuh9k94wtp4dehu7u
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/Jsvet2KmRc4qR68KoJmWVobQU8MF3js4=
X-HE-Tag: 1627893336-409696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 13:40 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variables rtstatus and place are being initialized with a values that
> are never read, the initializations are redundant and can be removed.

trivia:

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
[]
> @@ -1362,7 +1362,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>  		132, 134, 136, 138, 140, 149, 151, 153, 155,
>  		157, 159, 161, 163, 165
>  	};
> -	u8 place = chnl;
> +	u8 place;
>  
> 
>  	if (chnl > 14) {
>  		for (place = 14; place < sizeof(channel_all); place++) {

This line should probably be

		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {

