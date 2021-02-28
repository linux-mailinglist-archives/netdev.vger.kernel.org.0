Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1443273B7
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhB1Ry4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 12:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhB1Ryy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 12:54:54 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF98FC06174A;
        Sun, 28 Feb 2021 09:54:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id a23so200791pga.8;
        Sun, 28 Feb 2021 09:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0KoH4BIRHrZnQv6fHrG8+mnofwMyjzrrxakEBRTgsLc=;
        b=kPr1XgmxI4BpLFOhEnzsg6CE8HuVUVSNnbFhPDQXbY3ZHybwJysAC4vDUt37RoPf7x
         qn4kn646da0/epMowC97GhtKmFHECXiiaisjkSVmmX+L39Ix2TWGoSDqQS2JC5A2paow
         sMcKJVxWb1Z1NzFQnycrsg+/4YnHPgECc3Q3lZPgAQKoafxp1hXS+I5Kv2gpM/kGdbv3
         iAXPO4IGArAS4Qt7EvlEwTQpDjFDDEq2tQQws2cPFL6iZ17RPlqVbk14XxH0yvLfj4MX
         y3ZJl2+ibd2UE8Cgya4sJyCEiA+ah8ABuWnQ1g/cjLWt00qUX4+opjNrF+dHpQyHDL35
         IaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0KoH4BIRHrZnQv6fHrG8+mnofwMyjzrrxakEBRTgsLc=;
        b=EDGvPFHwxXDie3utNC/ycrxA4Gc8SZ4xy3Aw8DxbTl8sWpmamQEjeyV2+k8ejEPMCs
         quqQjbLuWpM0YIeXbeeWbZF3BNtgPd0qO3rzjX+pF2rHK8A/5oncIUYTFG2BMW6yQdA+
         Tmzs81EdGJUzWCjNfEmUFlAsNpgMvxE1B8MIBldQzX174I2kKkU2mXwPl6Z7CO95n9Cz
         RYF2fMhZpvvnb4bU0bMv04N1TwxaacwMp4CDsoS2AYxDfhcuBD+zeYVpcj8C9f1DMKrr
         lE+0GOKVxcKI3sAu5iBDQ6EjqvWgETwxNBqSo4ZwqLNOPGAMZqNkp6xch7oVr6uCIrzV
         IoGg==
X-Gm-Message-State: AOAM53184LBb9FEko4LZRfNo4C+3NAwOK1VxaJYvyRozYwvEDJ54tMSX
        mxbSToC9jkNl1nAVbEl5kGQ=
X-Google-Smtp-Source: ABdhPJz4NdvE2RgQaiimh2LzC/6ArXQpkSZlmSRVh+zBCj/M0cArHNJjo8+grPdrK+wvOVWJFTbd6w==
X-Received: by 2002:a62:2c85:0:b029:1ed:39f4:ca0f with SMTP id s127-20020a622c850000b02901ed39f4ca0fmr12020452pfs.11.1614534853174;
        Sun, 28 Feb 2021 09:54:13 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n11sm13879027pgm.30.2021.02.28.09.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 09:54:12 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: fix egress tags
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>
References: <20210228170823.1488-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b5c863a0-b29a-80a7-a7af-f523346616a2@gmail.com>
Date:   Sun, 28 Feb 2021 09:54:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210228170823.1488-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/28/2021 9:08 AM, DENG Qingfang wrote:
> Commit 86dd9868b878 has several issues, but was accepted too soon
> before anyone could take a look.
> 
> - Double free. dsa_slave_xmit() will free the skb if the xmit function
>   returns NULL, but the skb is already freed by eth_skb_pad(). Use
>   __skb_put_padto() to avoid that.
> - Unnecessary allocation. It has been done by DSA core since commit
>   a3b0b6479700.
> - A u16 pointer points to skb data. It should be __be16 for network
>   byte order.
> - Typo in comments. "numer" -> "number".
> 
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
