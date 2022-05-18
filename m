Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4643852B717
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiERJjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiERJjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:39:32 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFCA12B003
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:39:30 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t25so2599360lfg.7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xt6cx7jfdtIzxFo8xURtsGgmnzna5Y1WbrzL+0I9i88=;
        b=WdPPOTLZEmP6fLpXhxUCY+FLR0re9MImuXhfUpZuwAp6zbSPxLr9o/TgQAipysxVbr
         erLdjvEzsUZ2JUNRQl7E2cFyxpMdNeKAlMNN/NckLhBlbhuDZUb4SIhoCEAYu74RBLNB
         M7S6+ykzn5Zru4xrCcZEv60+FqmjKlBKlvA93LKNGsTXJs5KFUvlnW+Z5Tgt4xY+gpIw
         xbH8qUlPxCLx852Z//f6lt6CsxAfmJ/3eunpiX+H7KOOKs3kKwG6EfdVuu9ErPAxOiEQ
         8tnnjBpyyZRTj2LWqjVtUn3WdNqn1gDa/JDI/OtKR4DfFT0mHaclzxv8gO31H+v9m0Iv
         ICYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xt6cx7jfdtIzxFo8xURtsGgmnzna5Y1WbrzL+0I9i88=;
        b=H2wFDi3pBxmacAxW6sLNH4Z06WtaKhQWZN47mLG6Rt2NhrlRU7FbXRGDKVUBxz2bub
         V3UxAxSQRYFqo8XGJSLrwR7XmafqUAtLV3X0uVknnSogrj+XyNO+o2F4lYvhTMU0sjUI
         NMDI2WDvF2newQO911VnISDacbiQoCqd8wyJZ2KRWT58i++RnsqUY0GNP40zPjPlMpUv
         LKWhrXyFp4Pls+sw9XpTuqlKXrRBX5HVgavVnvp9l6/P++8qgrQ6kJtgNF2GiuYrSqAM
         DZuF79iqIgCRxMPQIW1cla4qyfC+N7RHTT7ekgi3uHsiR99Xw/E4Nr3uANYed7iV4rli
         xLhw==
X-Gm-Message-State: AOAM530W6ROf/IItlYaStG69yAio6fSMx2xc+kZzEQuP/5USIOk/m5G3
        luDA6cPWNu37GHOF2azhUIFSIQ==
X-Google-Smtp-Source: ABdhPJwqm4lmlIPHLTfO667Gwmm+iuswyu2QPgkfJ+MIsx6YbSKKBtyBjeDJy2jgXwhjUL9H3h/uyQ==
X-Received: by 2002:a05:6512:3a86:b0:472:6287:6994 with SMTP id q6-20020a0565123a8600b0047262876994mr19830525lfu.16.1652866768962;
        Wed, 18 May 2022 02:39:28 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id s9-20020a056512214900b0047255d21163sm153402lfr.146.2022.05.18.02.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 02:39:28 -0700 (PDT)
Message-ID: <bb566eb7-c571-9a51-af51-78e36412fbfc@linaro.org>
Date:   Wed, 18 May 2022 11:39:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
References: <20220517105526.114421-1-duoming@zju.edu.cn>
 <2ce7a871-3e55-ae50-955c-bf04a443aba3@linaro.org>
 <71c24f38.1a1f4.180d29ff1fd.Coremail.duoming@zju.edu.cn>
 <68ccef70-ef30-8f53-6ec5-17ce5815089c@linaro.org>
 <454a29ba.1b9b1.180d576985b.Coremail.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <454a29ba.1b9b1.180d576985b.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2022 06:39, duoming@zju.edu.cn wrote:
>> There is.
>>
>> nfc_hci_failure -> spin lock -> nfc_driver_failure -> nfc_targets_found
>> -> device_lock
>>
>> I found it just by a very quick look, so I suspect there are several
>> other places, not really checked.
> 
> I agree with you, the spin_lock is not a good solution to this problem. There is another solution:
> 
> We could put the nfc_hci_send_event() of st21nfca_se_wt_timeout() in a work item, then, using
> schedule_work() in st21nfca_se_wt_timeout() to execute the work item. The schedule_work() will
> wake up another kernel thread which is in process context to execute the bottom half of the interrupt, 
> so it allows sleep.
> 
> The following is the details.

Yes, this seems good solution. You might also need to add
cancel_work_sync to all places removing the timer.


Best regards,
Krzysztof
