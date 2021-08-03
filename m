Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E5E3DF135
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhHCPQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:16:09 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57534
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhHCPQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:16:07 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 284AB3F070;
        Tue,  3 Aug 2021 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628003755;
        bh=XxRTNfvCsCZZOY4PoI1ruoqNXeZxwETY+pJxOCsiVdE=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=tKNn5vwUayiaXsVY7ahH5QBOP1I45/1oCvVk8cdN2Fag/79mvzkadQq/hn/0DImRl
         2C87kQYINlNym8rZyA9g2uu5KwWxzAkmKRqb3mAJ2YU4xd+Xr7miPJWwgvNCR/c34+
         IY6zLQspic/zDuEjgXVmWw982c2AQRwwybP9AOeMJvVhAzdZcAue2itOngfu57ienQ
         ywRQYHmz0yjOD4R3n1kzu8JC+yuQ9kHiWalymA5Ppdsyy/Mvz4wC6WWNXUbi6OzGOD
         wcIWBYfM+hNnMmRcgit0NuSa7oL8OYEigFOVJ3vu9BxtF1CQy4FRJtJjs83PCYMACx
         vyRM/kQRktbwg==
Subject: Re: [PATCH 2/3][V2] rtlwifi: rtl8192de: make arrays static const,
 makes object smaller
To:     Joe Perches <joe@perches.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210803144949.79433-1-colin.king@canonical.com>
 <20210803144949.79433-2-colin.king@canonical.com>
 <e07dfde8aa6616887c74817bed1166510b5583dd.camel@perches.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <4e1d8a60-0af8-97d5-b95c-7d91502825e5@canonical.com>
Date:   Tue, 3 Aug 2021 16:15:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e07dfde8aa6616887c74817bed1166510b5583dd.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/08/2021 16:09, Joe Perches wrote:
> On Tue, 2021-08-03 at 15:49 +0100, Colin King wrote:
>> Don't populate arrays the stack but instead make them static const. Replace
>> array channel_info with channel_all since it contains the same data as
>> channel_all. Makes object code smaller by 961 bytes.
> []
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> []
>> @@ -160,6 +160,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
>>  	25711, 25658, 25606, 25554, 25502, 25451, 25328
>>  };
>>
>> +static const u8 channel_all[59] = {
> 
> I don't believe there is a significant value in sizing the array
> as 59 instead of letting the compiler count the elements.

I was reluctant to remove this as I supposed the original had it in for
a purpose, e.g. to ensure that the array was not populated with more
data than intended. Does it make much of a difference?

> 
>> +	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
>> +	36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
>> +	60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
>> +	114, 116, 118, 120, 122, 124, 126, 128,	130,
>> +	132, 134, 136, 138, 140, 149, 151, 153, 155,
>> +	157, 159, 161, 163, 165
>> +};
> 
> 

