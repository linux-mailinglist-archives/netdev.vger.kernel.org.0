Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663524C60BC
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 03:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiB1CFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 21:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiB1CFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 21:05:51 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC6659394;
        Sun, 27 Feb 2022 18:05:13 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so10012694pja.1;
        Sun, 27 Feb 2022 18:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AMsxO2P3weaQAvlcqcwWLnN/LSWoD+a1H1M9VEhhr+w=;
        b=j5TxDo4q28a7EkdINe9hZaFOYrbEIeY0GW4nGZYiUQGsx3beX0nzXOMizDIng+TyOK
         JG7IQiZ5cnvYTOrT1SHSXTc3pBt9W3yF20HJwxD7DOOeS+xgT3m/wNIdiQW90Y2EEr70
         Qw4eQbrYRbHTT407/zye0HiQOcHA0Rt873EXaGuYzPHSTuWmE7aoW+oZKECPZkxTwh0K
         mhbYvdTnZBz6xbf5llOmEagVYu4dkhpwIv0O0Dz0eGjf9Ztlw/SVah37NXAveh7F5WZV
         0dkpQukXd++9/nsNQTZCMUToqu/UCwCk/YgvH0zs/OkKfwNE3KlmJpRWqzA8D6Msbv6J
         XVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AMsxO2P3weaQAvlcqcwWLnN/LSWoD+a1H1M9VEhhr+w=;
        b=U8yt1RCHjKBUQ/Ybx1jrqTaX1TWK/SmLFhIIBtUgNHqJOqB8lSGi1HoBVOLw7SK7IU
         4lO2giyq0mSzOxianKDHR9j6sPk4kvk2ZveDmjNFdjzlqCbli4OQKxRr5YibUBzXrBIQ
         tpZfHmn5dW1xBHgo7QkGjCAXw1cQd6C4Sjw2AvmLhfD/9qKsa1YOXrwODbiR+te/FxiO
         4q1vX8pIvKI6CpfvZhQVTFy0wjYBbTl4LdPRw9cv7r1g/eWpU42NKGfXVWDyVTfZJo4n
         5fpqEmnNsBTOJeYLAxVYaPx+NN9xNPlsgmHaNRX/YVvevFhpqCM5A4I7Xb+iHff4BDfh
         ni5Q==
X-Gm-Message-State: AOAM533Nds+9WCj0Z0JET+f2gc+QGbaKC6pZJ1gjfgJ/5yb/iFY+Jx+c
        vuZ48jDxlOyRhSxKCxqF4QRb0b4t+p2fjYI3
X-Google-Smtp-Source: ABdhPJwgsHZDrr3WcZ2QSJ03lyGKdCVA1+Af/7uT9ugUWz2zbbuDjNAzETd/XhFa7GQK7AYk444qsA==
X-Received: by 2002:a17:902:f344:b0:151:533b:b6c5 with SMTP id q4-20020a170902f34400b00151533bb6c5mr7453783ple.58.1646013913235;
        Sun, 27 Feb 2022 18:05:13 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm10969747pfu.56.2022.02.27.18.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 18:05:12 -0800 (PST)
Message-ID: <69b0dd44-93ac-fa33-f9c1-6f787185ab47@gmail.com>
Date:   Mon, 28 Feb 2022 10:05:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb: fix a possible memory leak in
 esd_usb2_start_xmit
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, thunder.leizhen@huawei.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220225060019.21220-1-hbh25y@gmail.com>
 <20220225155621.7zmfukra63qcxjo5@pengutronix.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220225155621.7zmfukra63qcxjo5@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I get it. But this means ems_usb_start_xmit have a redundant 
dev_kfree_skb beacause can_put_echo_skb delete original skb and 
can_free_echo_skb delete the cloned skb. While this code is harmless do 
you think we need to delete it ?

Thanks.

On 2022/2/25 23:56, Marc Kleine-Budde wrote:
> On 25.02.2022 14:00:19, Hangyu Hua wrote:
>> As in case of ems_usb_start_xmit, dev_kfree_skb needs to be called when
>> usb_submit_urb fails to avoid possible refcount leaks.
> 
> Thanks for your patch. Have you tested that there is actually a mem
> leak? Please have a look at the can_free_echo_skb() function that is
> called a few lines earlier.
> 
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   drivers/net/can/usb/esd_usb2.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
>> index 286daaaea0b8..7b5e6c250d00 100644
>> --- a/drivers/net/can/usb/esd_usb2.c
>> +++ b/drivers/net/can/usb/esd_usb2.c
>> @@ -810,7 +810,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
>>   		usb_unanchor_urb(urb);
>>   
>>   		stats->tx_dropped++;
>> -
>> +		dev_kfree_skb(skb);
>>   		if (err == -ENODEV)
>>   			netif_device_detach(netdev);
>>   		else
> 
> regards,
> Marc
> 
