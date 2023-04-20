Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986556E87DF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjDTCPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDTCPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:15:00 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA774492
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:14:59 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-544f2c5730aso200089eaf.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681956898; x=1684548898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6uFK0OCqFOWirj1P654nbEeN1jK0+zZrRBX4osD4m1U=;
        b=tIH6v9gPbzBPzRnguKLxBDl7NYGFZ8MyHA6ZDGTLOnqeHtWELSIWjuDiI3A3R5r5vR
         tudMhO8zf8VWHHwxjmEKcTeruDI//+AEM/aWr8eWxl2d3r4AqnvR/bI71Z9WOofScl9a
         8V4kq1xlFLOYZtFbJZYPEcOaUPaXydPFZc9d9wAyy2WUCpD8dQJKHu4GRd9iryUZSI9u
         hn1Z0PUrtvClCQaqW9IbBDsKXXAD852NavetakZky49T0Z1HojgGTD6JVtKkyKKo3TYW
         nCM9c5UO09SX407oRRAnnXWGLiDPVnRRBbLYWtoHhrQaW69duJY7KWquUUiJT0/PIYg2
         Z9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956898; x=1684548898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6uFK0OCqFOWirj1P654nbEeN1jK0+zZrRBX4osD4m1U=;
        b=B9U8Fr39JyOr5+0zCnqrSiUXgp9D5gyxM7XTRzMfJtdSLPPpkb/50WCBGzlWEA+ix6
         tkF+L2T3bjO8tg21V92gBxac3DRpib7S1vZOd2RjuAPpzgdM902tOClA+EDJeLpyv7u9
         g7BXKktqPgq8Svnf7ycqKDuaZXYvXDkt6lLkhuHW41XCa6lnk2AY/MHRs8QteHzzwlsQ
         6Xlo+xvynsGv5D5uKnExTosursKT2h7RYL3Nmirk3f3gTP2kVQEugaZbU1jYWAe3YvQJ
         kP9WAGPMyUEy8l8AP8+px40Rn1lzqgRr0xRz/qgeRi8AJFbETyRtiinWxCT8o77kJh5Z
         k5VA==
X-Gm-Message-State: AAQBX9ceG1zzGaTLHqe6be8Mn5fQPG+Tbae1u9iTqTvR6CKQGK7SBe6W
        rW1sMDdqAAoRRIaQv1Fu/pbiDg==
X-Google-Smtp-Source: AKy350YTLqapwoZdVAcOZuyemDEzhSxkP73+hY89dHGrrV88kX0+731AkZEJffZgw1ECuddjziP9OA==
X-Received: by 2002:a05:6870:3456:b0:183:f844:5e0a with SMTP id i22-20020a056870345600b00183f8445e0amr39789oah.38.1681956898677;
        Wed, 19 Apr 2023 19:14:58 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:9ee5:4c39:6d56:5391? ([2804:14d:5c5e:44fb:9ee5:4c39:6d56:5391])
        by smtp.gmail.com with ESMTPSA id ea37-20020a056870072500b00177be9585desm306597oab.1.2023.04.19.19.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 19:14:58 -0700 (PDT)
Message-ID: <d45983a3-6884-d8e9-499e-c9e71c4685d5@mojatatu.com>
Date:   Wed, 19 Apr 2023 23:14:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 1/4] net/sched: sch_htb: use extack on errors
 messages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
References: <20230417171218.333567-1-pctammela@mojatatu.com>
 <20230417171218.333567-2-pctammela@mojatatu.com>
 <20230419180832.3f0b7729@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230419180832.3f0b7729@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 22:08, Jakub Kicinski wrote:
> On Mon, 17 Apr 2023 14:12:15 -0300 Pedro Tammela wrote:
>> @@ -1917,8 +1917,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>   			};
>>   			err = htb_offload(dev, &offload_opt);
>>   			if (err) {
>> -				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
>> -				       err);
>> +				NL_SET_ERR_MSG(extack,
>> +					       "Failed to offload leaf alloc queue");
>>   				goto err_kill_estimator;
>>   			}
>>   			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
>> @@ -1937,8 +1937,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>   			};
>>   			err = htb_offload(dev, &offload_opt);
>>   			if (err) {
>> -				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
>> -				       err);
>> +				NL_SET_ERR_MSG(extack,
>> +					       "Failed to offload leaf to inner");
> 
> I missed the message changes on v1, but since the patches are already
> Changes Requested in patchwork...
> 
> IDK what TC_HTB_LEAF_TO_INNER is exactly, neither do I understand
> "Failed to offload leaf to inner". The first one should be "Failed to
> alloc offload leaf queue" if anything.
> 
> Let's just stick to the existing messages?

The existing messages omit that the offload operation failed, which I 
think it would be important to say in these two cases.
But taking a second look, the driver gets the extack so it should be up 
to the driver to provide the appropriate context when the offload fails. 
What do you think about demoting these messages to WEAK and change them 
to something like:
"Failed to offload %attribute"
