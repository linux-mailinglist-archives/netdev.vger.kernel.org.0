Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92554DB4F7
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbiCPPey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbiCPPey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:34:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4462B1AB
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:33:39 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h1so3195014edj.1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C/X8AdauJ2UfLh8yYLCKT804J2aRhpi3Fx20xJZ8Trw=;
        b=Wp7qMEFohGETv34KH2wHXo8CgaKaGEC6FzQurZTh4ucnCL/CpJUEq5XnIr2GzkSyuj
         TwIix8awLcTGaX9ldu30cHdDfm3NIdEYWaD0ETWxG85B7+TNS0UU1c8MJpvm+GTyoJ9O
         Jj3bvNjyAgsvJAvrrxhdDO9i+CoYUfQOC6hhfSPJ+tCt8q3SVo0qpWDFJv1pz4+uhCUY
         VmYXLx4AqwZ6vfbfdvjujJcsqGadwuxPskkBjm6SRXHC26dOehqqM5C0k8jm53grR3Q7
         woQJ47h0Y/3cEK1YfwMHBXxellsp1Z6WF/RcWx9P02MTQnCFx24a2snK4ZRLpiUaGpFg
         xAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C/X8AdauJ2UfLh8yYLCKT804J2aRhpi3Fx20xJZ8Trw=;
        b=wTcuYhqjP0xd5TGHWtshpJJfqFw2rc/O6X46t2+MPp9C3giz9IQMR8SPpe35HqSlC5
         +XA925NF5I0YirX7rbehcSO0dIVku52ec1bVwdmEKLsbfc4ajFR0QNGuMltC8qoOaX/6
         zn2qf2o45lRQgEB312wd6Hk3tPwPdIoryLg/nn7qFdJpRyL8MyiUwQIl6waWgt2gevmT
         jqTnNfPsyj5qDSPrrt3QiuFsCIVr3+Me4iKTtQvNbY985ZJh9vRZIGyFhTgPBQdkJWCl
         /dPhGjHAbcKVt3IsxHL9uY8VNg9P3bmSzpFdtgJfQrFyJTNIWNXELAwglvOTPRtfEG63
         rjug==
X-Gm-Message-State: AOAM533OB6xXTvfClP1YaskACjhLitggfQgI6UIhVel2iDo6kYxapFZK
        Wj7h/8AEq0vRqHiJ2+1KY4E=
X-Google-Smtp-Source: ABdhPJwMmyXaLqKpi0pvGUj907JqiIgsQNsbzFdt7W9Xk/ejS+f1qGbr1AqfQ8+68aJ760DVBymA0Q==
X-Received: by 2002:a05:6402:5304:b0:413:8a0c:c54a with SMTP id eo4-20020a056402530400b004138a0cc54amr80010edb.172.1647444817817;
        Wed, 16 Mar 2022 08:33:37 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id w2-20020a50d982000000b00410dc0889b9sm1169455edj.63.2022.03.16.08.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 08:33:37 -0700 (PDT)
Message-ID: <41425230-eed8-0da6-616e-48e52b09e906@gmail.com>
Date:   Wed, 16 Mar 2022 16:33:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] Bluetooth: call hci_le_conn_failed with hdev lock in
 hci_le_conn_failed
Content-Language: en-US
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     netdev@vger.kernel.org, Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
References: <20220316152027.9988-1-dossche.niels@gmail.com>
 <03B539EF-D2F4-4345-A6F9-F2F77CAA41C5@holtmann.org>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <03B539EF-D2F4-4345-A6F9-F2F77CAA41C5@holtmann.org>
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

On 16/03/2022 16:32, Marcel Holtmann wrote:
> Hi Niels,
> 
>> hci_le_conn_failed function's documentation says that the caller must
>> hold hdev->lock. The only callsite that does not hold that lock is
>> hci_le_conn_failed. The other 3 callsites hold the hdev->lock very
>> locally. The solution is to hold the lock during the call to
>> hci_le_conn_failed.
>>
>> Fixes: 3c857757ef6e ("Bluetooth: Add directed advertising support through connect()")
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>> ---
>> net/bluetooth/hci_conn.c | 2 ++
>> 1 file changed, 2 insertions(+)
> 
> please send net/bluetooth/ to linux-bluetooth mailing list.
> 
> Regards
> 
> Marcel
> 

Hi Marcel
My bad, I'll resend it to there, I have copied the wrong mail address.
Regards
Niels
