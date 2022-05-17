Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D292C5295F4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 02:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiEQAS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 20:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbiEQAS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 20:18:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45C54614B
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 17:18:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s14so15954428plk.8
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 17:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZBHx+dXJruSqzd5oNGOTzWZVDIzmgLdg3ddVvPpWcXI=;
        b=T0VyPrUKfmETSqnyrwpBoOEOqwFEfXx05SJdhuo7nG6fb/l6X6c1A+6RbTX14nRBF5
         kqh17w/aBdjIPZSqjcztUTf90xLzjIHsiLLzoBvO4kxMUDdE5tfJFO6o7ZC3zMkffv8i
         5fKd1hm3ScADxTT9WkqLsV/rfzPe7LR+sJDCd+Fcj0FO+Cw0+tUR+lCZ0bm7HCfXnZQ+
         7LPaYbwXO1bnhECC8r6zER+AaBphmvB/tw66IPr4V4gnXxydXaostga/fMGmoFOb8J4O
         w/g3FMy+Waq8SXIjw9zFXbL6iOimvamALzxBipIasKZGquWhWdcKO1JewZSITaTzW+wm
         z9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZBHx+dXJruSqzd5oNGOTzWZVDIzmgLdg3ddVvPpWcXI=;
        b=Vc8e6HQ28L0SmXoDK38h9bOs2+Is5hQeHMgS6KpAfDF/iqky5mAB2oUOKqVSN2BaxN
         FaxV50EIxnFhf5CrLC0w1WG9idAe7Y7eaI6ywRbSJZNvj3KWhKFZew4Y5DMHD+gJ+KiL
         FR5ap7/nXmm4JlsX76J8SKDq4DeAR4KQtF8KcYvo0jinfb7avH2JV2KJZg5rxShaFUzd
         XMAko2fm6G30FLSoGVwcpsD4z1IYUqSMUrkWsOryeAMirT5yAambWYsmHg0ExQ32yJFr
         /WXIC6d5bF+0Eb53IvX8FmJ7G/p+gnHYeULIQ6sFJ03O2WjnpAN5soG6Nr7uUGR9xLaa
         FEFQ==
X-Gm-Message-State: AOAM530G+G+lqvqBCrXJciG6QrTCyt9y8V7c9rb0UhXcPXJSzAqgyp0N
        zsg8a+tber4teKi5+Hs0aiccmAtfO1I=
X-Google-Smtp-Source: ABdhPJwTbzteN+iw0oPDGg4QfcpVJsPewQpX+gnXmVY5gydveH0oLAQNo6wWMO4ycTH503V1IK4rQA==
X-Received: by 2002:a17:903:3112:b0:161:6b71:b465 with SMTP id w18-20020a170903311200b001616b71b465mr9378162plc.80.1652746706054;
        Mon, 16 May 2022 17:18:26 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id kw4-20020a17090b220400b001dc4d22c0a7sm274757pjb.10.2022.05.16.17.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 17:18:25 -0700 (PDT)
Message-ID: <9208ca5a-cdc8-9b73-a024-9b7cba14dfee@gmail.com>
Date:   Tue, 17 May 2022 09:18:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] amt: fix gateway mode stuck
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
References: <20220514131346.17045-1-ap420073@gmail.com>
 <20220516161001.78b3b49b@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220516161001.78b3b49b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/22 08:10, Jakub Kicinski wrote:

Hi Jakub,

Thanks a lot for your review!

> On Sat, 14 May 2022 13:13:46 +0000 Taehee Yoo wrote:
>> -			if (amt_advertisement_handler(amt, skb))
>> +			err = amt_advertisement_handler(amt, skb);
>> +			if (err)
>>   				amt->dev->stats.rx_dropped++;
>> -			goto out;
>> +			break;
> 
> There's another amt->dev->stats.rx_dropped++; before the end of this
> function which now won't be skipped, I think you're counting twice.
This is intended.
It skips a remaining handling of advertisement message.
So, I think a memory leak would occur at this point, so I added.

Thanks!
Taehee Yoo
