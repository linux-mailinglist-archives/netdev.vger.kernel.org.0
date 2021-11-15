Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76844FF50
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 08:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhKOHnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhKOHnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 02:43:22 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3027C061746;
        Sun, 14 Nov 2021 23:40:25 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id l22so41131103lfg.7;
        Sun, 14 Nov 2021 23:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hD+y9+QPBxPIEHLp2C5nAr71aH7yvAgfpLbqsq9aZ20=;
        b=aHa5zLbymxJfKWMSKuuwCIgwPfTWfAFmUOyDgzniMmSzRrIDS0rjcrnDo5E7FO/6hG
         9OcfykS8DzQo4JtVBnLU2azMeMQmgjeJnH4F6xpq54i8akSRJZe6Q9hbFqaObu72xAMI
         RmsRReglCA2C4w6SKQsb8+CfFG1wFlG7+CV/ZxauYzdIDceiUsy621RP5rw5mAGB3ObQ
         ylI99/FN3BuDSDDl36lwMBN09peOteR5zpil2LEE04OP7uyStv9qngvRbsbF5+ByvN/c
         Utfnny6kjs5HEihZlKA48ZoLxiOiFzyyK/slIdCW002pnLksHNIpHW3wuKroM9IeRtYJ
         jgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hD+y9+QPBxPIEHLp2C5nAr71aH7yvAgfpLbqsq9aZ20=;
        b=oaFoojGDqyQDSQGnqhIYswAo+Rd5RkcPD9KM64z/4Lh1Z6vOAzvxQDaGoyj709JDWB
         9FJn8k5u6Z96DUCHw0vZ5RoZy/m4YEFS2JjDknGmK1f3+U1rRcCmFaYA2aSCgWligEGw
         dWNhwyYjRaF6FnzjA+GHP+2NoG+LSYpUmqQG1W82GbR4groD9bKaOhnBqiS6YClOYzcu
         euIfykquak1AT50Fokx1B/jOwMTOrpt3cqLodz5YnPVu1daC0P0MGZy8+ifcQctIryg7
         kkM5QAdigTjm187onrTnBIxjfRMgc0+nu/oELUQ89N6drRDMyo8LORBXkQ2IiVCJh6TQ
         IcBw==
X-Gm-Message-State: AOAM532gb4tt9wnq18QkfFrba7TQtqowsFP348IpFvR5eby55XMJ0YkM
        CtoXCqj17WQ1f7qfRkYGKRW1Hs14o2A=
X-Google-Smtp-Source: ABdhPJz/1l54205h8je5+/DlGM4h3RRIPAHFZqLGoWjlpkXdR7oZotRHyGHQxVCVy6i9CYcQKMF70g==
X-Received: by 2002:a05:6512:220e:: with SMTP id h14mr34728927lfu.310.1636962023930;
        Sun, 14 Nov 2021 23:40:23 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id c15sm1332667lft.244.2021.11.14.23.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 23:40:23 -0800 (PST)
Message-ID: <9a811cfb-1e9c-763f-0c8f-577f21d8f3cc@gmail.com>
Date:   Mon, 15 Nov 2021 10:40:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] can: etas_es58x: fix error handling
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211114205839.15316-1-paskripkin@gmail.com>
 <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 08:27, Vincent MAILHOL wrote:
> Hi Pavel,
> 
> Thanks for the patch!
> 
> On Mon. 15 Nov 2021 at 05:58, Pavel Skripkin <paskripkin@gmail.com> wrote:
>> When register_candev() fails there are 2 possible device states:
>> NETREG_UNINITIALIZED and NETREG_UNREGISTERED. None of them are suitable
>> for calling unregister_candev(), because of following checks in
>> unregister_netdevice_many():
>>
>>         if (dev->reg_state == NETREG_UNINITIALIZED)
>>                 WARN_ON(1);
>> ...
>>         BUG_ON(dev->reg_state != NETREG_REGISTERED);
>>
>> To avoid possible BUG_ON or WARN_ON let's free current netdev before
>> returning from es58x_init_netdev() and leave others (registered)
>> net devices for es58x_free_netdevs().
>>
>> Fixes: 004653f0abf2 ("can: etas_es58x: add es58x_free_netdevs() to factorize code")
> 

Hi, Vincent!

> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X
> CAN USB interfaces")
> 
> The bug existed from the initial commit.  Prior to the
> introduction of es58x_free_netdevs(), unregister_candev() was
> called in the error handling of es58x_probe():
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/can/usb/etas_es58x/es58x_core.c?id=8537257874e949a59c834cecfd5a063e11b64b0b#n2234
> 

I see, will fix in v2

>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>  drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
>> index 96a13c770e4a..41c721f2fbbe 100644
>> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
>> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
>> @@ -2098,8 +2098,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
>>         netdev->flags |= IFF_ECHO;      /* We support local echo */
>>
>>         ret = register_candev(netdev);
>> -       if (ret)
>> +       if (ret) {
>> +               free_candev(netdev);
>> +               es58x_dev->netdev[channel_idx] = NULL;
> 
> A nitpick, but if you don’t mind, I would prefer to set
> es58x_dev->netdev[channel_idx] after register_candev() succeeds
> so that we do not have to reset it to NULL in the error handling.
> 
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c
> b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index ce2b9e1ce3af..fb0daad9b9c8 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -2091,18 +2091,20 @@ static int es58x_init_netdev(struct
> es58x_device *es58x_dev, int channel_idx)
>                  return -ENOMEM;
>          }
>          SET_NETDEV_DEV(netdev, dev);
> -       es58x_dev->netdev[channel_idx] = netdev;
>          es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
> 
>          netdev->netdev_ops = &es58x_netdev_ops;
>          netdev->flags |= IFF_ECHO;      /* We support local echo */
> 
>          ret = register_candev(netdev);
> -       if (ret)
> +       if (ret) {
> +               free_candev(netdev);
>                  return ret;
> +       }
> 
>          netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
>                                         es58x_dev->param->dql_min_limit);
> +       es58x_dev->netdev[channel_idx] = netdev;
> 
>          return ret;
>   }
> 

Also will do in v2. Thank you for your review :)





With regards,
Pavel Skripkin
