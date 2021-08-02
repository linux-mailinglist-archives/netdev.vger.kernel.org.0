Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86163DD21B
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhHBIgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:36:01 -0400
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:43994 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232799AbhHBIf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:35:59 -0400
Received: from omf12.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 67A71180A7FE9;
        Mon,  2 Aug 2021 08:35:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id F04A024023B;
        Mon,  2 Aug 2021 08:35:47 +0000 (UTC)
Message-ID: <e96786f5772f8ed01ab3153e0d5d66820b2e920a.camel@perches.com>
Subject: Re: [PATCH 2/2] rtlwifi: rtl8192de:  make arrays static const,
 makes object smaller
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 02 Aug 2021 01:35:46 -0700
In-Reply-To: <20210731124044.101927-2-colin.king@canonical.com>
References: <20210731124044.101927-1-colin.king@canonical.com>
         <20210731124044.101927-2-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.84
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: F04A024023B
X-Stat-Signature: phr4y8pb9rudtjkroxy4dhqhgh7x1pp5
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18CUAd1kqMqv9Dylht6+9ZozDbNCxg9Scw=
X-HE-Tag: 1627893347-499552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 13:40 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate arrays the stack but instead make them static const
> Makes the object code smaller by 852 bytes.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
[]
> @@ -1354,7 +1354,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
>  
> 
>  u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>  {
> -	u8 channel_all[59] = {
> +	static const u8 channel_all[59] = {
>  		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
>  		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
>  		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
> @@ -3220,7 +3220,7 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
>  u8 rtl92d_get_chnlgroup_fromarray(u8 chnl)
>  {
>  	u8 group;
> -	u8 channel_info[59] = {
> +	static const u8 channel_info[59] = {
>  		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
>  		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56,
>  		58, 60, 62, 64, 100, 102, 104, 106, 108,

These two arrays (channel_info and channel_all) are identical but
laid out differently and could be combined and use a single name.


