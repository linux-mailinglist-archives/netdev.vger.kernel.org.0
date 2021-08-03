Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C213DEF9D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhHCODc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:03:32 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52508
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236195AbhHCODb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:03:31 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id D59013F079;
        Tue,  3 Aug 2021 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627999399;
        bh=bOi9tqA3zB1OAVNkRWRD6erwRTSHLcX4UwSrN5PadMQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=bOkft6cWnSZJwBLrtE0pVxKk/36KmGhn3StueXmGRbCzm3MsIMRskS/5LMbn4vhO/
         NmwWa92b97cZ8uoz3991eUaZLNyS25dQ+aANc/a1PjigiG8STBy1TqnLqkIh+AblaF
         RWBA+MKMECJDt/bJIz68QmPX5LHGElDFbm/lD/A2AHnPcwNSmPbFW/CMMiWPv+CHQ2
         cqBYaOAWcsXCUp4yug0K3Q7oNaeKWKFjLyf2/4xBr+LSLhBjCA7clgtOb94b/S3SG2
         ttUDem7wM0U1+HoUmsclboE6laSzS2+JyFJYd18Fvlf4saC2j4x9q8l+tJj65r9jkM
         QTBlhpXXk4c6A==
Subject: Re: [PATCH 2/2] rtlwifi: rtl8192de: make arrays static const, makes
 object smaller
To:     Joe Perches <joe@perches.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210731124044.101927-1-colin.king@canonical.com>
 <20210731124044.101927-2-colin.king@canonical.com>
 <e96786f5772f8ed01ab3153e0d5d66820b2e920a.camel@perches.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <7b203ff8-a19a-4fb7-d003-558adaa08407@canonical.com>
Date:   Tue, 3 Aug 2021 15:03:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e96786f5772f8ed01ab3153e0d5d66820b2e920a.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2021 09:35, Joe Perches wrote:
> On Sat, 2021-07-31 at 13:40 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Don't populate arrays the stack but instead make them static const
>> Makes the object code smaller by 852 bytes.
> []
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> []
>> @@ -1354,7 +1354,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
>>  
>>
>>  u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>>  {
>> -	u8 channel_all[59] = {
>> +	static const u8 channel_all[59] = {
>>  		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
>>  		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
>>  		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
>> @@ -3220,7 +3220,7 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
>>  u8 rtl92d_get_chnlgroup_fromarray(u8 chnl)
>>  {
>>  	u8 group;
>> -	u8 channel_info[59] = {
>> +	static const u8 channel_info[59] = {
>>  		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
>>  		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56,
>>  		58, 60, 62, 64, 100, 102, 104, 106, 108,
> 
> These two arrays (channel_info and channel_all) are identical but
> laid out differently and could be combined and use a single name.
> 
Good spot, will send a V2.
> 

