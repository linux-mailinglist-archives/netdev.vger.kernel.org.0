Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3545E76D3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiIWJYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiIWJYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:24:09 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E6CE1082
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:24:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so26672460ejc.1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sdhEqqcLQ9mPBvHp0xzH8RN91FNsaGFp1sqEEbf0Klg=;
        b=8KEj5RkoExqB7QUn1pVTDUOrzMbG1hNThr7BgxpbklpvEXMeqF3jO5MPncDCFjXE5i
         q4y7h6MF1HLf5sVkFR5zLUyHReyhib6fkML8mtDrmZEqruuHSAjbTlGzxQbu+l+a31bC
         xTFZgJpUljY8tjpCP/8i/V5n2QIEXXTgwfDtpNXs40EvtmOZUJob7KVi9NHEmDrnHdRE
         nakPv+SbbaCEzZ4iKMyBoH2yHkMcTo7wzWMKYOHAMHcYt/kHjOByV8w8N6OZ+rpRVpef
         u3qtaqItwqMGX/i5kuAIpb6C7TOKt4ty69TMnU1Pr7JccOjfKTjm7JebH7zBzS9Ui9zs
         /Udw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sdhEqqcLQ9mPBvHp0xzH8RN91FNsaGFp1sqEEbf0Klg=;
        b=ON6KnOxx5HXV98P0wByIJFky3vaI91PqT03cJVU590PuGdDl8h9JsjPHWQdvuFTlyJ
         CA2Dg0Tnruxa7luj88X12LlFbo4kBNxibp0/Vn1WNXRloBfIbTx0AKJC0KWIy9Iwj2Jm
         2fjaqNZcoLbD5c6nKHRxVgNRdZm6PJcr1a4i+6U7u8eUoPjwjDphWyrMkV4acCtkcUh+
         bO5YPcyy3iAvlyw2b9xazic6AcMbNp3cBoNiYbC86N06wp4DS9B0jjrXCQq6cuGgAOLG
         iGS95Dsl6zsuTnBzMnCJDiJbCQOTZxsWexV87Uj/Fz22qLSALJ3waR5SXOJq1AM4Yl/w
         L7NQ==
X-Gm-Message-State: ACrzQf2yafsZEDEAYhuV+NJ4FQkPyyL/j2V+APY2+JjmbRcY44ygDUNe
        gwYqFXOvs0Qj0KrJkO64VueCHA==
X-Google-Smtp-Source: AMsMyM6YZ/wN8xFwdDm3pQTdYhSKMRqDUQ4TSVSOKmqOMRFu564QuPXlK8k6ORG6biif7eZE2kTHFA==
X-Received: by 2002:a17:906:7945:b0:73b:e605:f31 with SMTP id l5-20020a170906794500b0073be6050f31mr6114135ejo.129.1663925045890;
        Fri, 23 Sep 2022 02:24:05 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:5e2b:69ae:ba71:ae54? ([2a02:578:8593:1200:5e2b:69ae:ba71:ae54])
        by smtp.gmail.com with ESMTPSA id 13-20020a170906318d00b00738467f743dsm3764902ejy.5.2022.09.23.02.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 02:24:04 -0700 (PDT)
Message-ID: <beb00a53-fa2a-4208-7650-e299157a8617@tessares.net>
Date:   Fri, 23 Sep 2022 11:24:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net 2/3] can: gs_usb: gs_can_open(): fix race
 dev->can.state condition
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220921083609.419768-1-mkl@pengutronix.de>
 <20220921083609.419768-3-mkl@pengutronix.de>
 <84f45a7d-92b6-4dc5-d7a1-072152fab6ff@tessares.net>
 <20220922082338.a6mbf2bbtznr3lvz@pengutronix.de>
 <20220922130525.6b1a1104@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220922130525.6b1a1104@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 22/09/2022 22:05, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 10:23:38 +0200 Marc Kleine-Budde wrote:
>> On 22.09.2022 10:04:55, Matthieu Baerts wrote:
>>> FYI, we got a small conflict when merging -net in net-next in the MPTCP
>>> tree due to this patch applied in -net:
>>>
>>>   5440428b3da6 ("can: gs_usb: gs_can_open(): fix race dev->can.state
>>> condition")
>>>
>>> and this one from net-next:
>>>
>>>   45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")
>>>
>>> The conflict has been resolved on our side[1] and the resolution we
>>> suggest is attached to this email.  
> 
> Thanks for the resolution! If you happen to remember perhaps throw
> "manual merge" into the subject. That's what I search my inbox for
> when merging, it will allow us to be even more lazy :)

I thought you were going to ask me to impersonate "Stephen Rothwell" :-P

Good to know, I can sure do that! (Or at least try to remember that next
time)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
