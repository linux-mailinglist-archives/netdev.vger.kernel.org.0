Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDC6B99EB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCNPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjCNPi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:38:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5033A8E9B;
        Tue, 14 Mar 2023 08:37:39 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so32546076edb.6;
        Tue, 14 Mar 2023 08:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fH2THU53sotkebWz3onCTMHoVnM+8nCWx/+krcQxvjk=;
        b=RsnpsCoFMPh1YTPijCu44lvveoc9nA1YR6pmXmE8hg8nPWksyfJ81uEIUyCB5sR7/n
         KVsnqTNeDUz9t4MQZyGJ1YrtjN8RzqcYZFT3mVgQmvbiPEi78fIcJPbwiWnlNXN2kRS4
         C8miA9SvGWcOWywf2Q3SKJeoMkq1TWZ+X5YzhvSfsgFdmsGpAPWo09vDOjED04DpOboy
         AMwN6tRLgH0YNsvBstWejD90waW0PByraJSegCZpRBC2k6Qx1Tdaf39gou36Bgenljx3
         Bd1y0vfiZXcTbzoj1SJepVRbB88+oAHemivdm+VkcOYhBmQ5/QlQFHyiz7jPyHGONLiz
         8O2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fH2THU53sotkebWz3onCTMHoVnM+8nCWx/+krcQxvjk=;
        b=2QLaMo4gwavvN8el72XDwwtw2AxTod7J56AnlOPm/TS0mUPahF4ATSHtHzfZS3p5T+
         bnW643t7dkRiGI/t+BQtyBJvB/pHUvOk19J2+x9rj233LG92kLtn2qwbA4Ec4nFxx//C
         4hjFfB2kbEWayuuwyO2gSyubbRlLK2euA7NJ4pc+DkiU3wJyEjWjvZo+oYI+IqU8p9E5
         XR9abj7tUaNF6Xa5uIievXqqly/gClQIDmGRbrKIQnZTC4q/CdjgAQTCdmlsB7CN1ehB
         NwyutAfovTRNJvoNVSf6wCQF2vo2gdRztR3yCYGNO7/MiylOV8l+GxmFtB92kJZckJBn
         xeqw==
X-Gm-Message-State: AO0yUKV58EilhR9TfDWBme25IHLXLYFbk6FX23R5L9SndbFBlX6DpvkE
        2LZf1LFk563Urusosl40lOY=
X-Google-Smtp-Source: AK7set8aeRn7CY+Pcz5X+2L8BiG05KWwa0mB1GI59XeSgqhgmxdNw9sXiLGj4qhNYOziVigGbUeEDA==
X-Received: by 2002:a17:906:73c9:b0:8f0:ba09:4abe with SMTP id n9-20020a17090673c900b008f0ba094abemr14851280ejl.2.1678808223705;
        Tue, 14 Mar 2023 08:37:03 -0700 (PDT)
Received: from [192.168.10.15] ([37.252.81.68])
        by smtp.gmail.com with ESMTPSA id ss10-20020a170907038a00b008e36f9b2308sm1328145ejb.43.2023.03.14.08.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:37:03 -0700 (PDT)
Message-ID: <ff0a4ed4-9fde-7a9f-da39-d799dfb946f1@gmail.com>
Date:   Tue, 14 Mar 2023 19:37:00 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
Content-Language: en-US
To:     Oliver Hartkopp <socketcan@hartkopp.net>, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
 <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
From:   Ivan Orlov <ivan.orlov0322@gmail.com>
In-Reply-To: <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 18:38, Oliver Hartkopp wrote:
> Hello Ivan,
> 
> besides the fact that we would read some uninitialized value the outcome 
> of the original implementation would have been an error and a 
> termination of the copy process too. Maybe throwing a different error 
> number.
> 
> But it is really interesting to see what KMSAN is able to detect these 
> days! Many thanks for the finding and your effort to contribute this fix!
> 
> Best regards,
> Oliver
> 
> 
> On 14.03.23 13:04, Ivan Orlov wrote:
>> Syzkaller reported the following issue:
> 
> (..)
> 
>>
>> Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
>> Link: 
>> https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
>> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> 
>> ---
>>   net/can/bcm.c | 16 ++++++++++------
>>   1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/can/bcm.c b/net/can/bcm.c
>> index 27706f6ace34..a962ec2b8ba5 100644
>> --- a/net/can/bcm.c
>> +++ b/net/can/bcm.c
>> @@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head 
>> *msg_head, struct msghdr *msg,
>>               cf = op->frames + op->cfsiz * i;
>>               err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
>> +            if (err < 0)
>> +                goto free_op;
>>               if (op->flags & CAN_FD_FRAME) {
>>                   if (cf->len > 64)
>> @@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head 
>> *msg_head, struct msghdr *msg,
>>                       err = -EINVAL;
>>               }
>> -            if (err < 0) {
>> -                if (op->frames != &op->sframe)
>> -                    kfree(op->frames);
>> -                kfree(op);
>> -                return err;
>> -            }
>> +            if (err < 0)
>> +                goto free_op;
>>               if (msg_head->flags & TX_CP_CAN_ID) {
>>                   /* copy can_id into frame */
>> @@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct bcm_msg_head 
>> *msg_head, struct msghdr *msg,
>>           bcm_tx_start_timer(op);
>>       return msg_head->nframes * op->cfsiz + MHSIZ;
>> +
>> +free_op:
>> +    if (op->frames != &op->sframe)
>> +        kfree(op->frames);
>> +    kfree(op);
>> +    return err;
>>   }
>>   /*

Thank you for the quick answer! I totally agree that this patch will not 
change the behavior a lot. However, I think a little bit more error 
processing will not be bad (considering this will not bring any 
performance overhead). If someone in the future tries to use the "cf" 
object right after "memcpy_from_msg" call without proper error 
processing it will lead to a bug (which will be hard to trigger). Maybe 
fixing it now to avoid possible future mistakes in the future makes sense?
