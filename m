Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35346902AA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBII6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBII6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:58:41 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EFB6A50;
        Thu,  9 Feb 2023 00:58:40 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so1678384pjb.1;
        Thu, 09 Feb 2023 00:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZPIkHZq4Ruc2ULe8bQVCYe8oa3004dQdp9Bqgi5HwD4=;
        b=i/a1Objb6NOckU3MsGjNNPipxuHko79DlagimdyWw9VMwiHDG0mxSDCuxkGUyybIGJ
         QT/pBR+X2B1IrIO6/3lGe7Ouvc8d9+fFF8Ha2axrq+yoXF3yuQYqt7InwKVqXRK6EMLC
         7PXFfiJE8vv50GyrB6ylrF25738s4eXUkpcZ21cc9H4SLqMje8uS6947NyKZ/HrLxcY5
         wW5RB5fF2Ok3F/4IYTu/j21QTRFLPr7CjLEkYawXyoCme8topKQCtirGO7gHxOEjKXDC
         sEmSByq+ch8alFib+MR5TFI2IcoTxOWx6CnF87Rrqfshbm9mqKvujiDaEliW9kq2V/z2
         3hJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPIkHZq4Ruc2ULe8bQVCYe8oa3004dQdp9Bqgi5HwD4=;
        b=XiThleJP8nyts+sfl4Us79JZqIOTUKPg4pV6SfzQe8XNS1P/jkHHyA5qVPJMXoZTTW
         wHS2ghNP1l5Vd0c1O7o4CvhoBGpltpO230FbFILvGgV8fmHFmCbN3esG4nPzClzzYljV
         JhwkYXW0elSzhLt7s9o+Szltv3KxI7UJMmAXMVkyEktdqTHpmzxoZuh2iDi5X7db1ZbZ
         0uWvbKNWKcwPsbudLVpM2yJJUj9BsgZlv6Hddaq7bHN2bjLtpgS3e5juu0UeTjrI5bxA
         yx+fgaYadfPNgT1AoGzsLHFsb4v0K54C/sgswrMBzqv8OiT3ilDMcmcbjLLNdmAN7Xv0
         ekWw==
X-Gm-Message-State: AO0yUKVMdROqcfbxBJg5nLdFBizQdgHsD9nqu0EsePzkf1vV9Rx3Ejed
        U9qYA07PiJj4Hjm26qyXuIs=
X-Google-Smtp-Source: AK7set+ySuDi7oY1mUr7gU/BkzkvfTkF1TxdYMan1G6SdU+FxdM9J7aKCk+taMLjNUWBY6v53it2Fg==
X-Received: by 2002:a17:90a:e795:b0:231:d07d:7ba6 with SMTP id iz21-20020a17090ae79500b00231d07d7ba6mr1950448pjb.1.1675933119522;
        Thu, 09 Feb 2023 00:58:39 -0800 (PST)
Received: from [192.168.50.247] ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id hg11-20020a17090b300b00b00230b572e90csm822824pjb.35.2023.02.09.00.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:58:38 -0800 (PST)
Message-ID: <eb0df15a-150e-8c7f-4f91-fc1c1442cb76@gmail.com>
Date:   Thu, 9 Feb 2023 16:58:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: openvswitch: fix possible memory leak in
 ovs_meter_cmd_set()
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <20230208071623.13013-1-hbh25y@gmail.com>
 <155E8FC1-746B-4BA4-BA80-60868B076F00@redhat.com>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <155E8FC1-746B-4BA4-BA80-60868B076F00@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2023 16:26, Eelco Chaudron wrote:
> 
> 
> On 8 Feb 2023, at 8:16, Hangyu Hua wrote:
> 
>> old_meter needs to be free after it is detached regardless of whether
>> the new meter is successfully attached.
>>
>> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/openvswitch/meter.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
>> index 6e38f68f88c2..e84082e209e9 100644
>> --- a/net/openvswitch/meter.c
>> +++ b/net/openvswitch/meter.c
>> @@ -448,8 +448,10 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>>   		goto exit_unlock;
>>
>>   	err = attach_meter(meter_tbl, meter);
>> -	if (err)
>> +	if (err) {
>> +		ovs_meter_free(old_meter);
>>   		goto exit_unlock;
> 
> It would be nicer to add another goto label like exit_free_old_meter.
> 
> +	if (err)
> +     	goto exit_free_old_meter:
> 
> exit_free_old_meter:
>      ovs_meter_free(old_meter);
> exit_unlock:
> 	ovs_unlock();
> 	nlmsg_free(reply);
> exit_free_meter:
> 
> 
> Or maybe it would be even nicer to free the old_meter outside of the global lock?
> 
>> +	}
>>
>>   	ovs_unlock();

I get it. I will send a v2.

Thanks,
Hangyu
>>
>> -- 
>> 2.34.1
> 
