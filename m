Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A819557819
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiFWKr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiFWKr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:47:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335A34B1EB;
        Thu, 23 Jun 2022 03:47:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso3430855pjz.0;
        Thu, 23 Jun 2022 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FyEUu15vvzH95LcwuWkWyhW3ebF5SK1T267BEuaWV3g=;
        b=KESis4YxduSsCemtNPXlOa0SV4p4nwujQpil/zxARLDUiXNMcSc44QiCNu6hvEmVNh
         aTlLI+uQBCqDhWoDUiDkp0HZLnH9SWcpJiPo9I8zpHdFm0lf8u79kuBUjOx8y0Snq5/V
         KUJcbdhlMlEgpKyYjqyfoaPOND5flIPf60vEDIgMGwTWUh5IRqLOYornvqVtpjvCBWZb
         uPYKbN8WLbyR2HaPM1JZ0WxMeKt7mloeOXYusMdKSBT3xmwBcCImkDEW2jKMKFPFjzOh
         g94xvEt67d1H+Md6uUyW8PPBma9s1A8yDlugoVZSbxVWRvmQVsPJmqUhenL1kGTOL20C
         Np9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FyEUu15vvzH95LcwuWkWyhW3ebF5SK1T267BEuaWV3g=;
        b=WkdG1MEuSk4FURDxfVElVd0ueEhsZUqCGbT9xOVFPEMO8S/UQ17voaL82mJEgrd37U
         AqUb7lBCU5D5wx6/rbPKHBMZcL21t8Ru5mrkf9O7/OkG7vDDgLIEYyh9v1xbeN6pAcvx
         qM5P8eCMFWzzR84JqxhpHwIQ9/3FD5I7aDBC0st/yWPSngCDX7fmiTYuPJipbrgmvdMP
         CGM4ODHprmZlqsr2/kUY8O6w1VDRf0Yqz/oy/9BgdjKG8t57kYyPB6RM4gUS+3Sw+fWF
         COA93sCoJ7+QBleFUuEE8mA+cqrjyhpqlYL1OB+LK+CM/y8ea+FneALF8MLyFqRJWNyl
         jhew==
X-Gm-Message-State: AJIora8sGRapu9ICZbrGZmI3+dtKxtQDKnfgbOBiOyUJ8eq8RFBOCeFm
        UZzN6ar56Bice75KMRH1was=
X-Google-Smtp-Source: AGRyM1s4qcoH9Z6XWD2ITvm7Hnwb7mNlMppHGiV2QsaEIPLGPPJ+TN3hRoaWL7F/we0gctdiA/NZMg==
X-Received: by 2002:a17:902:ea4b:b0:168:d5e9:68ec with SMTP id r11-20020a170902ea4b00b00168d5e968ecmr38343340plg.146.1655981243389;
        Thu, 23 Jun 2022 03:47:23 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id f25-20020a637559000000b0040cf934a1a0sm5384193pgn.28.2022.06.23.03.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 03:47:23 -0700 (PDT)
Message-ID: <31fa8ce4-a132-03c6-3272-6f8448270830@gmail.com>
Date:   Thu, 23 Jun 2022 18:47:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] nfc: st21nfca: fix possible double free in
 st21nfca_im_recv_dep_res_cb()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, krzysztof.kozlowski@linaro.org,
        sameo@linux.intel.com, christophe.ricard@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220622065117.23210-1-hbh25y@gmail.com>
 <39279ba0ced207f484b664fe5364fa4ee6271cfb.camel@redhat.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <39279ba0ced207f484b664fe5364fa4ee6271cfb.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 2022/6/23 17:42, Paolo Abeni wrote:
> On Wed, 2022-06-22 at 14:51 +0800, Hangyu Hua wrote:
>> nfc_tm_data_received will free skb internally when it fails. There is no
>> need to free skb in st21nfca_im_recv_dep_res_cb again.
>>
>> Fix this by setting skb to NULL when nfc_tm_data_received fails.
>>
>> Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   drivers/nfc/st21nfca/dep.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
>> index 1ec651e31064..07ac5688011c 100644
>> --- a/drivers/nfc/st21nfca/dep.c
>> +++ b/drivers/nfc/st21nfca/dep.c
>> @@ -594,7 +594,8 @@ static void st21nfca_im_recv_dep_res_cb(void *context, struct sk_buff *skb,
>>   			    ST21NFCA_NFC_DEP_PFB_PNI(dep_res->pfb + 1);
>>   			size++;
>>   			skb_pull(skb, size);
>> -			nfc_tm_data_received(info->hdev->ndev, skb);
>> +			if (nfc_tm_data_received(info->hdev->ndev, skb))
>> +				skb = NULL;
> 
> Note that 'skb' not used (nor freed) by this function after this point:
> the next 'break' statement refears to the inner switch, and land to the
> execution flow to the 'return' statement a few lines below.
> kfree_skb(skb) is never reached.
> 
> Paolo
> 

My fault. I messed up two switch statements. I will be more careful next 
time.

hangyu


