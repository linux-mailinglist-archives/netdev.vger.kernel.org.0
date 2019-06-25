Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC3F54CC1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732142AbfFYKvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:51:45 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36080 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfFYKvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:51:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so12316479lfc.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 03:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QYR0/BYwnzwCl+rKULiTMDwFesUkqjrw3t7FlbQxB08=;
        b=yfu8bNMV5M/M7hGf8bi48wMrTqPQ2ptTJ2bXJ41rOTfD7rmdXz09MFQLz1Lfx/LeYl
         OpOr3nQARG5SsJl5vXwuwAH6Mzf+nuDp8PwSV7UPn2GB8fIKzcPAALmeF0SikSsIiGD9
         jVEkP6EBLp5r0UYSnHk8kaIIrkwyIz4H8QPrrZjyhetij564U2H5WT1Rz3s7YtxT1VDt
         /mzSxSgU5JrZJFKju+1XmsplmX6v1IR2fTZyuzDKx72SPrPHBwaxGlSN2JjJBGVNYgxY
         MwyCQGGIFvZNWqvPkIWmm3DtI6/xyKp76RBCEU645MMyPtgNBqeFKJ1F0xCikU7RTqn2
         t0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYR0/BYwnzwCl+rKULiTMDwFesUkqjrw3t7FlbQxB08=;
        b=WQbGmnI/qVrt9nbGvkqKbR/JqA5jAEHbHvySMqO5WvoO8JFmANuUuJ8mdFO+on4OxB
         Tc9bahc3jziJDLXKLAsOJtig9j14fK5kjqkqSumY1Wyc3a1l9gMvktjaaK8Skrv3gy//
         5WG6VhSPj3WNqQBkNRD9eBpGRBG5lAULuiCZInH2AcxW3aEmyLYzvPdkfdkL3v7jzPcR
         TL3I2D75gbl5OIScK1/RLAarrLmF9ZAk1AvCR4b48o4g2aJ+W5tFyK+n05PDTdaMzLfT
         jKD28pt2ZbUwTKqrZKc2Nq41J+QdzqwGKYX8AJHt3C7oEYArr98KAJF+OUzz9gEqV3cF
         STjw==
X-Gm-Message-State: APjAAAUXeUAJg4oOxFY0cczW1HKnK93RoRJCdcnfkQpVFK83UqGmVg+Q
        Z7d6s/MFHmFeu6ZZ2wJ9JEJ4cg==
X-Google-Smtp-Source: APXvYqzZ09wkjVNPOiocxOa4T9N2dk+LWvcKvQjj68NhxhSUE1cmPSz5jwP2yyCvKMWoN/WTUgKZvg==
X-Received: by 2002:ac2:569c:: with SMTP id 28mr19131895lfr.147.1561459900452;
        Tue, 25 Jun 2019 03:51:40 -0700 (PDT)
Received: from [192.168.1.100] ([213.87.147.32])
        by smtp.gmail.com with ESMTPSA id k82sm2185877lje.30.2019.06.25.03.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 03:51:39 -0700 (PDT)
Subject: Re: [PATCH net-next] net: stmmac: Fix the case when PHY handle is not
 present
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
References: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
 <895a67c1-3b83-d7be-b64e-61cff86d057d@cogentembedded.com>
Message-ID: <6a0db024-312b-746c-4ecc-ab6166c6e409@cogentembedded.com>
Date:   Tue, 25 Jun 2019 13:51:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <895a67c1-3b83-d7be-b64e-61cff86d057d@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.2019 13:29, Sergei Shtylyov wrote:

>> Some DT bindings do not have the PHY handle. Let's fallback to manually
>> discovery in case phylink_of_phy_connect() fails.
>>
>> Reported-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
>> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Joao Pinto <jpinto@synopsys.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Cc: Alexandre Torgue <alexandre.torgue@st.com>
>> ---
>> Hello Katsuhiro,
>>
>> Can you please test this patch ?
>> ---
>>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c 
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index a48751989fa6..f4593d2d9d20 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -950,9 +950,12 @@ static int stmmac_init_phy(struct net_device *dev)
>>       node = priv->plat->phylink_node;
>> -    if (node) {
>> +    if (node)
>>           ret = phylink_of_phy_connect(priv->phylink, node, 0);
>> -    } else {
>> +
>> +    /* Some DT bindings do not set-up the PHY handle. Let's try to
>> +     * manually parse it */
> 
>     The multi-line comments inb the networking code should be formatted like 
> below:
> 
>      /*
>       * bla

    Oops, that was the general comment format, networking code starts without 
the leading empty line:\

	/* bla
>        * bla
>        */
[...]

MBR, Sergei

