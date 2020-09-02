Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0925B521
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIBUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBUMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:12:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D220C061244;
        Wed,  2 Sep 2020 13:12:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so249149pfp.11;
        Wed, 02 Sep 2020 13:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uYImFOJu0K//+DZFWON8MWJNUVLoQV7sBihFc3kX8Xo=;
        b=c1JBJ6VTvqs9gxo5fDc8w8Vl0x5F9qV6AD1yaO+4DZ9QWYyxoX/SqdEU4OvAHVCgdC
         MCsrkfRhk5Tuc7fUg8JQ9Bo45NU/I+JdhxB9eHr9eTMnM46EswR2yBwTDK2j7MBsEYz3
         1CqEss1Sjrixd2/j3R4jXfGpP/mXiX2ZOODDpvv3zBDY1vFf6d8gQ5zG3SkrLJHnqoI7
         +vAN1q7bGUZp4ZQAyEOy0JdlmgkvOyLyqf7rvzvr2KpAQpGeEVIbB/OnibxnqS4fn4Pn
         9oi5bRD4AGfouZTl4nD/S3sXgv8F+1HmgBwm5yhnccGZmBPbAHHYmskM/9p7WgyPz2A+
         /pwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uYImFOJu0K//+DZFWON8MWJNUVLoQV7sBihFc3kX8Xo=;
        b=TvjHjpidmoB478UzeZTem3u3kABIJQ9WSIyBqGi9Ty+DcECIeA8Sy+eZLLcz9zHP5C
         H59xHu6/GzGHA7mMFToydhX6C+SPYj6U50jQRtcBoMJOHa9209ytr3LdoimYC5sRm4uv
         VuFV58AAl9QdY10LHY2k+TPeX+haE4JAculmY4najS4V5fNXaEfDCqf48oNWR4ZAaTOk
         QFsK3TvV75LUaBaRJu++wXkbbHA/AY74T0hhILz4CqxY7xTSQMmeVkE+y+Gs+lt3NfNn
         V25wYE/4spm3n5LxXt3C+JBpAa8KrnkHBPoIP+Fojb+EGfdv+o94OMW6pt8ijsKbxm7n
         iGpQ==
X-Gm-Message-State: AOAM533eRGx4gjEtBbEZuBbxepvK2lwIKIPJfKsrxpP0lZ6L47DvoiV9
        Y3qobin8NX3MWk8p7gaVUluoc7CeA5M=
X-Google-Smtp-Source: ABdhPJzk7Hgcfa6oT9Ta03/6Bd/JRgpaRnATLm3cYkkw2w2yvuXgWH6XlwV9+C/K79H5BD4r5ApX0A==
X-Received: by 2002:a17:902:a584:: with SMTP id az4mr113062plb.165.1599077524214;
        Wed, 02 Sep 2020 13:12:04 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x3sm190131pgg.54.2020.09.02.13.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 13:12:03 -0700 (PDT)
Subject: Re: [PATCH net] net: dp83867: Fix WoL SecureOn password
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200902192704.9220-1-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <997e979c-6447-84f3-d433-5c5194abd201@gmail.com>
Date:   Wed, 2 Sep 2020 13:12:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200902192704.9220-1-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 12:27 PM, Dan Murphy wrote:
> Fix the registers being written to as the values were being over written
> when writing the same registers.
> 
> Fixes: caabee5b53f5 ("net: phy: dp83867: support Wake on LAN")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
