Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1932B30E4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 22:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKNVD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 16:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKNVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 16:03:27 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22093C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 13:03:27 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t21so3306093pgl.3
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 13:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l9/fTIz5b16XFaNYEEOJbZdu0zbEpAGXD2YJ4VfVjYk=;
        b=J88KdlpIpFDPRYkf/ijlptRfCcd2dVhbEoQzG725oGuQG44pNOxGnWFrEzrJgq/9k/
         6qX53G6aqa2WJ8Uk9/U3VcqvNKtfHNP0wS157hrg97ApbKb3OX0/2UoKxy13mfPyyLBL
         tQ7nJnOO2CB+UP0v9ukDipIBqoAIK90FOMq6gcqdgdOaRaVmoXiSWclRX2vcSnpWAcY+
         tebkVLEnVEY8WU/hKVrSIvjPivsxjOY5+5pvMEPOPMAfPbLsFsZNhlvlKy0lx8ctog/l
         lwJKI2IjG+90E6kmLzzQat3xLaJkQGwFnzuAho43+QG81wviTb6gK/ZkoLvVDQbHPaHD
         sdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l9/fTIz5b16XFaNYEEOJbZdu0zbEpAGXD2YJ4VfVjYk=;
        b=ZuHPJRF9WoPs8DVW3XR4y9t0lcqFW7Jy6Ni4sdhvl8AUgT0kgyGSB14zWbttxksCWf
         nVptmLwzPPdxs5HfVTJ3hp2gjfoG1uS0bW3qG/cZucdMs78khEkEFVxVLtqqOgmQZCKr
         l48MOTbMovmR60FPP4pDmptbQJlpHFE8DERdH16NQisR1hmoFmWSZ3QQdZfY+eafKL53
         MUJrvhtGmLS8Olc6klsPp5sQhQekXnAwmWN/lQquTJ5BCrEH89fkIzisicCi64Auel8C
         e3oWCn/Ddd7x9HaZWVyWc5UwClqty+c+RrRBFQ2fcuabqPlbIghhTp0xKVwSEptzZwEq
         outg==
X-Gm-Message-State: AOAM533vefNuTgUA3WB+RkFU8ikGEO8N8OO7LYE2/2sb3gUUVHxetDdZ
        uZGd+JC+E6lim1S9n/jWDvo=
X-Google-Smtp-Source: ABdhPJydDcIUBzziPnbQ9f/9w5mNVfkcxkG73/QX69NZE0R5b45ijymefUZDL5MuypzV0ahePcLj8Q==
X-Received: by 2002:a63:1f50:: with SMTP id q16mr1741010pgm.214.1605387806670;
        Sat, 14 Nov 2020 13:03:26 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v196sm13665034pfc.34.2020.11.14.13.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 13:03:26 -0800 (PST)
Subject: Re: [PATCH net-next] lib8390: Use eth_skb_pad()
To:     Armin Wolf <W_Armin@gmx.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, joe@perches.com
References: <20201112163134.11880-1-W_Armin@gmx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <044e6281-5f1e-9b4b-e283-0f37583a16ff@gmail.com>
Date:   Sat, 14 Nov 2020 13:03:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112163134.11880-1-W_Armin@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/2020 8:31 AM, Armin Wolf wrote:
> Use eth_skb_pad() instead of a custom padding solution
> and replace associated variables with skb->* expressions.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---

[snip]

> @@ -407,8 +404,8 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb,
>  	spin_unlock(&ei_local->page_lock);
>  	enable_irq_lockdep_irqrestore(dev->irq, &flags);
>  	skb_tx_timestamp(skb);
> +	dev->stats.tx_bytes += skb->len;
>  	dev_consume_skb_any(skb);
> -	dev->stats.tx_bytes += send_length;

There is nothing wrong here with the existing code and you could avoid
an use-after-free if not careful, I would personally keep the existing
code which appears to be just fine.
-- 
Florian
