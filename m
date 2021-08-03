Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E503DEFA0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhHCODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:03:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52536
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236412AbhHCODr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:03:47 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 385F23F045;
        Tue,  3 Aug 2021 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627999415;
        bh=2Eega8M+8xNrGY1tf+6f/bUwq+O7naUIVBjSVZIM+lQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=gANBUft+YMWDKu/Em7/tBio1TyPV4dBdccZapxpWh7EctofgoDOcopVqnZZxPI+38
         7OWuGpKVw5Bxh5Avv1bN+czI03GjFesN//JRt9fUkXzw5liEfnqzE0Iu8nJPcDeFWU
         q5JHE+k+OB1hahc1viwkpN9FeTcdHqfM5jQ5KdNBlHDj9K07OgUM0q0OELEP4T/bZy
         Hz3+SVFJIQw8T5mlOiyQM+Gso+QAer2nKuUvsNON1x4fmLNoPQqjBsDlsBs+2aFzOA
         GSGMtsvDSRTfbSnRJDo8Xhts+8bEmZGcHBhEZZMykZB6Srh29FKM+Z0rmCiKVCTfzF
         cGb56iYHeQB6w==
Subject: Re: [PATCH 1/2] rtlwifi: rtl8192de: Remove redundant variable
 initializations
To:     Joe Perches <joe@perches.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210731124044.101927-1-colin.king@canonical.com>
 <3f55848b4612d1b17d95a4c36bec1dee2b1814f1.camel@perches.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <35877a55-3dc3-abb1-5aa4-1d7edaa85602@canonical.com>
Date:   Tue, 3 Aug 2021 15:03:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <3f55848b4612d1b17d95a4c36bec1dee2b1814f1.camel@perches.com>
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
>> The variables rtstatus and place are being initialized with a values that
>> are never read, the initializations are redundant and can be removed.
> 
> trivia:
> 
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> []
>> @@ -1362,7 +1362,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>>  		132, 134, 136, 138, 140, 149, 151, 153, 155,
>>  		157, 159, 161, 163, 165
>>  	};
>> -	u8 place = chnl;
>> +	u8 place;
>>  
>>
>>  	if (chnl > 14) {
>>  		for (place = 14; place < sizeof(channel_all); place++) {
> 
> This line should probably be
> 
> 		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
> 

Nice catch, will send a V2.
