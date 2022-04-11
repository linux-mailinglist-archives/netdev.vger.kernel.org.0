Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBE4FC1F9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiDKQN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348119AbiDKQNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:13:47 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A68920BF2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:10:51 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t1so6060771wra.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ce5fu7ycn7dUXlc9MmLst+yQYHhyd+tclVQECLvk1js=;
        b=YSoxKpBQ27pJC/NUYM0t6og3xSn8vpXW+/+d6wALd3rvHLcuIT+n1KEhFkgbRQZV6O
         mawSArsbRGji48AE+AP4hViCE2vNxqT/FcYsLSQFJSHZ8KhC260VUqFtBA5ouNQNUCwA
         xfkDu6VkhuRsIBe/lmqnVtGN0wc5CSpFhj6OmLrskSGrlZB5vQLDPHmJZMqCNOpPBoeU
         8kksghGHey8wzO2YeUdzQ6xxXILIBG7GPdrIF12SmWwicPEqHNXPXvPlZZLHEAzyXV83
         M3b72MTX4pxHyHTSghLecN/6S56DDbGc74rDvZhTz/UrLu4SAUNHhZbyfXjg7wtBTUm4
         KLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=ce5fu7ycn7dUXlc9MmLst+yQYHhyd+tclVQECLvk1js=;
        b=ygAcJXcGhGImscz4kZaYRVjCPAjNw8dSqnro7loa+6J/J9sFHGxp30+QOiQcf8LA60
         TvtN0hEvdhpAGXrWZwnjNw4ZHJ+pK3i4ddec3vArbJqWzBoyvhnd4SpagT6Rl/O7jsVa
         7b9Fvq3OVkuwmcWWye0j+GY00GGOsAnJJUcKU4lsy85eGUkpct9QRHoM9ia/aaU+GXyN
         t/dzc3iHySyTPvB1t5T8DGAqPkQ/WPE4D0B06DgmmxSYln78qUxsvKUgNWCp+LUChTvi
         r1md8EUgTa1M+9P1ZgT5umaUH2LLpaXBi1xHoeax5bH4H2jOLcTzL2a4q1XpZ7YpRQ3e
         HbOg==
X-Gm-Message-State: AOAM532QdW0PLL4klDUaS5MqcdliWEpz0RtNLeOZ7Hts+g/cx+6apFdY
        dKjWIIs66ASQWuNG3vEWYJVTEw==
X-Google-Smtp-Source: ABdhPJxJzT+c7Uqvio4omdC+uK2QKBidQlv52qRyZIzmxQpD85bRX+iO/w3anJTAY/+sqhOdQXEnVw==
X-Received: by 2002:adf:f7cd:0:b0:207:a25c:24c4 with SMTP id a13-20020adff7cd000000b00207a25c24c4mr7820486wrq.528.1649693450469;
        Mon, 11 Apr 2022 09:10:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f? ([2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b0038ceb0b21b4sm21565794wmq.24.2022.04.11.09.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 09:10:49 -0700 (PDT)
Message-ID: <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
Date:   Mon, 11 Apr 2022 18:10:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: What is the purpose of dev->gflags?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org> <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
 <20220411154911.3mjcprftqt6dpqou@skbuf>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220411154911.3mjcprftqt6dpqou@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 11/04/2022 à 17:49, Vladimir Oltean a écrit :
> On Mon, Apr 11, 2022 at 05:43:01PM +0200, Nicolas Dichtel wrote:
>>
>> Le 11/04/2022 à 17:33, Vladimir Oltean a écrit :
>> [snip]
>>> Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
>>> call path is dead code? If it is, is there any problem it should be
>>> addressing which it isn't, or can we just delete it?
>> I probably miss your point, why is it dead code?
> 
> Because __dev_set_allmulti() doesn't update dev->gflags, it means
> dev->gflags == old_gflags. In turn, it means dev->gflags ^ old_gflags,
> passed to "gchanges" of __dev_notify_flags(), is 0.
I didn't take any assumptions on dev->gflags because two functions are called
with dev as parameter (dev_change_rx_flags() and dev_set_rx_mode()).
Even if __dev_notify_flags() is called with 0 for the last arg, it calls
notifiers. Thus, this is not "dead code".
