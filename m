Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9945F9F41
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJJNQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJJNQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:16:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C8672681
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:16:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bu30so16981530wrb.8
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vJokQeJ2T7X0zgJR/pLPYL/dpchq3XvDfZT0AuTIiXk=;
        b=cyN7jPcFlS00GJO/AGtx5boiMAoBYGreF8Lt2ycEgBp40z1ALmVXAYCFaRJ23K68qK
         uu++/3K+KUYZuKDhXsmiJE1yZauW1dqHHpUMaZvxuY9oXPRrEa0SFsp5ibltk7hRkKLn
         oMOklxXO2EMGC1FOfrZd6HvkRwAay6gUZ6l5L/2fKsjIOF8CJN7dxpUiSQTOjFF2iCaU
         qkAY/8Gr4SCLovJy71IpkYBjfaylOWT+3RR/dYas3AGONwxSgjzYrwOlwhsbDBfL97WU
         jNtysQ7EipNoL62h0f08CANc1xkejHRwhPLX62ORtBmCOBEEUkFWpynSqEVvORV2PJCD
         xjFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJokQeJ2T7X0zgJR/pLPYL/dpchq3XvDfZT0AuTIiXk=;
        b=6fhhRLLaHpWrd5p4s27I/zUO93ONCSWt68i68iVgOtX1eMd5mg37UEm4uY8JI5ZZ48
         Tuu3Mn7J4PAcwek7VzdcQCU/1s1sebEZim9CAPkNA5/htgmM4b0pKveJFWbOc6o8lvI7
         GeTw9iQ5qBaqJLGZB70fuViQgPSMpVJmLUvUSSY2KsAaNbmCy7TvmWHlCeIoxz3t+Mtl
         sTKcWMaZQR7Kv9vq25HnF0MMTdq+GwyHwHt0xiOiooh462fwA03U9C1lhjgzp/E+5+9p
         w/QZP2VTZYvGWS2RyRduhGuOfjbkXB8Vn12uAfyUBFrkH/eRyW/OaxKbdJyeYs7HQ0qc
         KMkQ==
X-Gm-Message-State: ACrzQf1pMoLtnqjzTtzgldw81UDf+soSHxr9BY0yorAfAPgE1O4VXnHa
        HcWpiJ0tCkMKUgUK0ZqSD9eSbA==
X-Google-Smtp-Source: AMsMyM7NlUCU/Q21rInNTPbNCSPvMQt+eZc1UWAWgUFay+GAW5zlCnW7Ibam/0eVQQVfTSSYLKCRKw==
X-Received: by 2002:a5d:6d82:0:b0:22b:b9f:d7fb with SMTP id l2-20020a5d6d82000000b0022b0b9fd7fbmr11255531wrs.580.1665407759682;
        Mon, 10 Oct 2022 06:15:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d4:a7f7:8743:2a68? ([2a01:e0a:b41:c160:5d4:a7f7:8743:2a68])
        by smtp.gmail.com with ESMTPSA id q22-20020a7bce96000000b003c21ba7d7d6sm10939130wmj.44.2022.10.10.06.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 06:15:59 -0700 (PDT)
Message-ID: <51f7d346-2250-1d22-483a-69198b4f020c@6wind.com>
Date:   Mon, 10 Oct 2022 15:15:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        monil191989@gmail.com, stephen@networkplumber.org
References: <20221009191643.297623-1-eyal.birger@gmail.com>
 <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com>
 <CAHsH6GthqV7nUmeujhX_=3425HTsV0sc6O7YxWg22qbwbP=KJg@mail.gmail.com>
 <0e3f881d-b469-566f-7cdf-317fb88c305a@6wind.com>
 <CAHsH6GsBo59jm+fYLmPwf3FDa8+8Dc29BV1huj20YgjRdLeevQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAHsH6GsBo59jm+fYLmPwf3FDa8+8Dc29BV1huj20YgjRdLeevQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/10/2022 à 14:52, Eyal Birger a écrit :
[snip]
>> Thanks. Is it possible to write a selftest with this scenario?
> 
> I can add one targeting ipsec-next.
> 
> Do you perhaps know which is the current preferred flavor for such selftests
> for ipsec - C or bash?
I would say bash.
There are a lot of examples here:
https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git/tree/tools/testing/selftests/net


Regards,
Nicolas
