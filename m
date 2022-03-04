Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3A54CD7D1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbiCDPbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 10:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbiCDPbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 10:31:55 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC781C57FA
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 07:31:02 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id i1so6777921ilu.6
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 07:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uzhwGur91P5yesG29UCmB2WlYMRkzgA8jcRThwt2ek4=;
        b=o7wy5sMsd0ZQ8yU01ATPTLKkoJFBHes9Lwic/GWlizs5LBotKxOjC9xMu6UblbkUfq
         Zqtzvon23Pd1/9EqiFPdc8T2Xjm+QY22lxcsEd+cjjV6QOjOxYLlJlIeWGfagLEIrH8n
         BWdfIWF+7pAMYbNm2uZXphfoNsVZ8YOBgsKeNAAvujbLJC6Xu5+H22JFGzkFi2DN9/V0
         eulUH2H2i+FnRvkqphIqSoZW8rMLoSd6KZVjrlpKKMptghK0tztgeBtO8pIN2G7bMRzJ
         Jj2Lwguomu3D6jGdlc8CfLcpADq5MbOmXSgp4s+JAIs/IvfyxgTefwmefWMQTDKWnzbl
         6pUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uzhwGur91P5yesG29UCmB2WlYMRkzgA8jcRThwt2ek4=;
        b=gA953i3BByWNa8TpKOL4pl14PYSrb7bPDh8aqY8Q5+zSISm5fHBL68+rV9oPdHwwi7
         l81kYapyD9t5Or74vOK9nC2evdRuTlgT1jC5YBMDMO80HxQsn296ooWp+9rtLHA1pDrc
         dh1PvAadVEiDVMWMk1ZH3L70QSvWm3hOalvfogfu3bY6pb7lYqeMOsIUQjpSgejbvOKd
         l8UeiVWhsivwwZiPchvV4Px+w36ltY9L7QYEU9VXInC7ZiIUoMwZeb45SY4ckSguNPsT
         2MsrIinWtKSe2I3yZrExlnnseGbJus54VPDpWYqvwltcq1XFDgvCJ4tOwLLraNgTv8VN
         8igw==
X-Gm-Message-State: AOAM531DbbZV2+CL2da+dY76Yr7htmYaA6yqIo+bhyuxtO3G9uN2wNAq
        uIdtMlVtDS2am+MHCWGz+jSRogoI/sU=
X-Google-Smtp-Source: ABdhPJwMWONMURu3MVZ4ordiNNxixPZOmkfObIVrX966aWpMu4XUNLSuZim8K9r25jjc5M7biSKcPw==
X-Received: by 2002:a05:6e02:1543:b0:2be:d7b4:49b3 with SMTP id j3-20020a056e02154300b002bed7b449b3mr38390050ilu.97.1646407861839;
        Fri, 04 Mar 2022 07:31:01 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.59])
        by smtp.googlemail.com with ESMTPSA id f5-20020a5d8785000000b00604cdf69dc8sm5216411ion.13.2022.03.04.07.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:31:01 -0800 (PST)
Message-ID: <c9f81dc8-d32c-4ce1-5963-a45bc72fcd31@gmail.com>
Date:   Fri, 4 Mar 2022 08:31:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>
References: <20220304045353.1534702-1-kuba@kernel.org>
 <20220303212236.5193923d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CANn89iJ_06Tz8qA26JsgG14XdHCcDbK91MCYqneygSuTRdzsDg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89iJ_06Tz8qA26JsgG14XdHCcDbK91MCYqneygSuTRdzsDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 3/3/22 11:37 PM, Eric Dumazet wrote:
> On Thu, Mar 3, 2022 at 9:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu,  3 Mar 2022 20:53:53 -0800 Jakub Kicinski wrote:
>>> -     return false;
>>> +     return __SKB_OKAY;
>>
>> s/__//
>>
>> I'll send a v2 if I get acks / positive feedback.
> 
> 
> I am not a big fan of SKB_OKAY ?
> 
> Maybe SKB_NOT_DROPPED_YET, or SKB_VALID_SO_FAR.
> 
> Oh well, I am not good at names.

SKB_DROP_EXPECTED or SKB_DROP_NORMAL? That said I thought consume_skb is
for normal, release path and then kfree_skb is when an skb is dropped
for unexpected reasons.
