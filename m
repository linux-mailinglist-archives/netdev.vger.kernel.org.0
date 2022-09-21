Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5515BFA3E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiIUJIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiIUJIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:08:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42E88C007;
        Wed, 21 Sep 2022 02:08:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l65so5276307pfl.8;
        Wed, 21 Sep 2022 02:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=svFiUUeuYFlMrWiqj/jt3gEFxH31/pi8v8YQVoLmJro=;
        b=FwSkcF3BOlSiZ7nMRlmFpLIZJy+hqmvpWkSXa+Dnn9qgT0ieruxCsZMUu6lg0a/yGa
         a66OwfXr2+K0PS7NsMY1+fMcLv9PQ/UIPvkhiCJXHS+D9jXGHZKWM/EYu9tZkVnnQfrM
         W4tE3p96PwNUyLmtNz53eU6qn5h8w/0Sljr8Xl/M1rvGcV1cx/07bfIokeUIjo8nA/70
         /9+ziuFtjeAK8zEq5A85i2vZedu9l3SZTWh1VbTGyIeOv6TfDWI0e1kg/pHDr29pQ9Hg
         NvLtjZqk00+31Vs1viwH9ItWj92fNJ7CEmJ/LbGGwiCbrWfAGTVanxGre9x63VGjbXK0
         TlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=svFiUUeuYFlMrWiqj/jt3gEFxH31/pi8v8YQVoLmJro=;
        b=iCaWo9BWR6AycJZ9pvG+j5fC4gV1JfPd943HRJw7khr8APorVJ9F/YzxAQm1oKzdS/
         KPyFw7eEkkvSLcfYp0Z8oVQSZNcNl53ceGOhLl5/nckO7enrRdYSqeu8S1casIOjg4ly
         TWSDaOs9xP5bFWhuq6Vp81tZTyrbfoxv78Hnsz7D2OiCy8yLPcm1Xvl+T0N16PBKW+5h
         uSFAW4efSEqnIEkGz+YOsQs/7uq3RiyQCSaFb/skm3ASJWQoqnyxcWawjK3ecVC589D9
         Gveu9xMsIQnPGqOGA34OUKDO3bMedwZZ4JHhJpdKBoC3AEl0tMSnn5UwzPh9cOD8o15p
         ktiQ==
X-Gm-Message-State: ACrzQf2JAtBb3F1d+Irf7xABalbSnESg2QYcRHRWWEl9uQJWsjdMdld0
        8WOwzl5QPMH0OO/gz9XgbTc=
X-Google-Smtp-Source: AMsMyM6DppFjbMEpgewsvQoIa8b6R/n/SMTwIK/5BGP3ZGJJAMYwAZZjVq6jaPKKy9xUBuP7qkBOeA==
X-Received: by 2002:a05:6a00:14ce:b0:544:1ec7:2567 with SMTP id w14-20020a056a0014ce00b005441ec72567mr27129210pfu.24.1663751329480;
        Wed, 21 Sep 2022 02:08:49 -0700 (PDT)
Received: from [192.168.50.247] ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id w68-20020a623047000000b0054124008c14sm1562147pfw.154.2022.09.21.02.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 02:08:49 -0700 (PDT)
Message-ID: <7272ff00-fa24-8f05-2a5e-bd6fcb8acc45@gmail.com>
Date:   Wed, 21 Sep 2022 17:08:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: sched: fix possible refcount leak in
 tc_new_tfilter()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220915085804.20894-1-hbh25y@gmail.com>
 <20220920085006.32c743be@kernel.org>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220920085006.32c743be@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 20/9/2022 23:50, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 16:58:04 +0800 Hangyu Hua wrote:
>> tfilter_put need to be called to put the refount got by tp->ops->get to
> 
> s/refount/refcount/
> 
>> avoid possible refcount leak when chain->tmplt_ops == NULL or
>> chain->tmplt_ops != tp->ops.
> 
> This should say:
> 
>    when cain->tmplt_ops != NULL and ...
> 
> otherwise the commit message does not match the code.
> 

My bad. I will submit a v2.

Thanks,
Hangyu

>> Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/sched/cls_api.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 790d6809be81..51d175f3fbcb 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -2137,6 +2137,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>   	}
>>   
>>   	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
>> +		tfilter_put(tp, fh);
>>   		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
>>   		err = -EINVAL;
>>   		goto errout;
> 
