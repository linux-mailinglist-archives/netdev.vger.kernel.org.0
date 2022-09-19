Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD395BC27A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 07:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiISFSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 01:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiISFSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 01:18:31 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B4B1A075
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 22:18:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i26so45127983lfp.11
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 22:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=nvDETwO+D5Y2NBD6uRk39J5iQEEocd32pfaDUVkrGO8=;
        b=bCJH+Y+GzHh6K+L+bHrXZZOaLtdzwpWwFyK+xJBbc9NE8/mDS5g1rnUXj+nAre6Kvo
         csDLr2DW4tJB3eJJTHUykOrQ6qxschbxlYwKFp0ow1e49xa2//5TGoRQwLwThBY3x2Yb
         cOGEwSKiZ+FoXBdzfvh6HY09QRhdtwmJI0KYTgQ1xl163NICuBL+jqV1dBaHaoMdAzot
         FRgaYvTQGfgEec1fUXtOoPsuGovTRC9OcA77a8v6Xm5EZBW286UzhUFbVgZOdgcG+Aaw
         GQOyJjAcSMpeeT/rBwVneYDaSgJ2u4nvj3VzT8BM1t7dT7srvD5IcCQJpKDb6TcqBHHr
         ZCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nvDETwO+D5Y2NBD6uRk39J5iQEEocd32pfaDUVkrGO8=;
        b=M3QLQhmtAn5ZLzCq9Vb/HYQZEH/KGQEXyysJPIDNLG3DPN+VMDULqNrdL6iD47pgj2
         1fv36bEn/NhIpjV5JGFXVVpCnz4PmY3lXMDP5jN0RflyWV8tEpTpbQxRBRW/ViIg7eSF
         yoASRBm9Vzi7NQ3TlGrrNCadNgR/UcUFBeTJc6grQHoZQn1oKsWXnUvGHclm+J/V3tmp
         m8qaHGX2ZW6oEwvW2rRULuBqERs0UzccZmd5YPxC2r/Or3UffBTKhIeNBlILukAHlzzO
         9Tq4buBspfNqY5tDArRPl05wM+tFsz34uTB+hCbnggeQKeRlwiM6RKARIq1YSfAafz9m
         kjWg==
X-Gm-Message-State: ACrzQf2eKQunl8VEnsH24S+HrZfqOHpd+jazre43t9/2dExcKRC1OypY
        W1GYp8Uf5+9fO1kVDSF602s=
X-Google-Smtp-Source: AMsMyM7DOs6+HtK8BcuQ2UvZYLgvcTeQjBzDQR2JR/slhuDOUbxbxBNxNO3Zx4OwN514meyMnO+39g==
X-Received: by 2002:a05:6512:3b9d:b0:498:fc06:320b with SMTP id g29-20020a0565123b9d00b00498fc06320bmr5352963lfv.21.1663564705690;
        Sun, 18 Sep 2022 22:18:25 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id cf11-20020a056512280b00b00499b232875dsm4919631lfb.171.2022.09.18.22.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 22:18:25 -0700 (PDT)
Message-ID: <12edaefc-89a2-f231-156e-5dbe198ae6f6@gmail.com>
Date:   Mon, 19 Sep 2022 07:18:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v13 6/6] net: dsa: qca8k: Use new convenience
 functions
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-7-mattias.forsblad@gmail.com>
 <63247c75.5d0a0220.e6823.b58e@mx.google.com>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <63247c75.5d0a0220.e6823.b58e@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-16 08:09, Christian Marangi wrote:
>> @@ -606,17 +587,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
>>  		kfree_skb(read_skb);
>>  	}
>>  exit:
>> -	reinit_completion(&mgmt_eth_data->rw_done);
>> -
>>  	/* Increment seq_num and set it in the clear pkt */
>>  	mgmt_eth_data->seq++;
>>  	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
>>  	mgmt_eth_data->ack = false;
>>  
>> -	dev_queue_xmit(clear_skb);
>> -
>> -	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
>> -				    QCA8K_ETHERNET_TIMEOUT);
>> +	ret = dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> 
> This cause the breakage of qca8k!
> 
> The clear_skb is used to clean a state but is optional and we should not
> check exit value.
> 
> On top of that this overwrites the mdio return value from the read
> condition.
> 
> ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
> 
> This should be changed to just
> 
> dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> 
> Also considering the majority of the driver is alligned to 80 column can
> you wrap these new function to that? (personal taste)
>

Thanks for the testing, I'll fix the issue you've found and do a respin.

/Mattias

 
>>  
>>  	mutex_unlock(&mgmt_eth_data->mutex);
>>  
>> @@ -1528,7 +1504,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
>>  exit:
>>  	/* Complete on receiving all the mib packet */
>>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
>> -		complete(&mib_eth_data->rw_done);
>> +		dsa_switch_inband_complete(ds, &mib_eth_data->rw_done);
>>  }
>>  
>>  static int
>> @@ -1543,8 +1519,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>>  
>>  	mutex_lock(&mib_eth_data->mutex);
>>  
>> -	reinit_completion(&mib_eth_data->rw_done);
>> -
>>  	mib_eth_data->req_port = dp->index;
>>  	mib_eth_data->data = data;
>>  	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
>> @@ -1562,8 +1536,7 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
>>  	if (ret)
>>  		goto exit;
>>  
>> -	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>> -
>> +	ret = dsa_switch_inband_tx(ds, NULL, &mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
>>  exit:
>>  	mutex_unlock(&mib_eth_data->mutex);
>>  
>> -- 
>> 2.25.1
>>
> 

