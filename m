Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FA36E7510
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDSI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDSI2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:28:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A2C5FFB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:28:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id c9so40694072ejz.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681892920; x=1684484920;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Vjqb/rd6lVFn3DRe0+O/IpF73Y7laVu4D6aYnGz7ts=;
        b=qpk9ANAaIbhoQIPf/LMA+iuZFVPkunfdRSu33erHc3XTLJHM06eh14bNC3Ugm9oZAF
         m1WOj3RYr7bfJOvxEC5Vdxq5581QdL9cOjMe5TKob/V37nVSDi2t2QKhskp5WAaaY5zl
         thjxuFgXyjf83/gWLsOsrsY2X4nmXaqmSxu0WP75qCFQSBwvJRwM7orViHMswF3YIE3v
         /r98/e4rdBH0KyfW4xo87y2tsMOsPeYLcGEKOexh4mncOK7Xzs9wzvsySwZgopJrKm1i
         EriYyEkY6WTA6UGgo1GUY12mNYx7cwiU+et/IR0fB2rzDheM1Zsh99EPwbCCD7Wc+sJv
         3ItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681892920; x=1684484920;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Vjqb/rd6lVFn3DRe0+O/IpF73Y7laVu4D6aYnGz7ts=;
        b=JY+/tHVMsK6owl13DVtSVMGpDiDmKVptgAsTUOtsn4asSk35vp8PB+POa9mjWNMWwz
         xiOmra1pdk2waytZYGeXOpY/ffjnCIYwZDj+YiN00TwMggG7Ougp2sMUwzopVUMlYAlQ
         hiR75bmbJcgkKw4UhAdkgs/527fhoLmWckRm8wqt4+EZnPP9mfbwiR9xDmNg2A+TPKcS
         UWMLyYcu724dRQZAb1n8lM6ySt71IqHkG23GivLWs/PkdcS6GBH7QRc59MNIW/7yecLX
         y4x5UWHDaMO55RLngHOtRV/9U7KdwaidTZlXT7fCy3w+G7+Dewle/Ebdruano6qkMuz7
         lMsA==
X-Gm-Message-State: AAQBX9dnsarJ9T4Y8RgsKIMU7Rpj25dvLtup9LXZNxCxnwsCAD7euaB2
        daVc/87IT92K4vlsfj8RR5n7FQ==
X-Google-Smtp-Source: AKy350bVuX3PSTH80vxKtyZdHC5T3iOQ7ds02ATBSxRQYlMlXip24RPv3+qNoMkmmvo4gj9jO9oQTg==
X-Received: by 2002:a17:907:271c:b0:94f:6852:549b with SMTP id w28-20020a170907271c00b0094f6852549bmr9737681ejk.9.1681892919746;
        Wed, 19 Apr 2023 01:28:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:62f5:eb43:f726:5fee? ([2a02:810d:15c0:828:62f5:eb43:f726:5fee])
        by smtp.gmail.com with ESMTPSA id v25-20020a170906381900b0094f3f222d34sm5166964ejc.56.2023.04.19.01.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:28:39 -0700 (PDT)
Message-ID: <76d5df65-c0c9-9702-8037-4c1d3b2255f3@linaro.org>
Date:   Wed, 19 Apr 2023 10:28:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] net: nfc: nci: fix for UBSAN: shift-out-of-bounds in
 nci_activate_target
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Anup Sharma <anupnewsmail@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linma@zju.edu.cn, dvyukov@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZD9A5Krm+ZoFEFWZ@yoga>
 <3aeac99f-aef3-ee22-f307-3871b141dc7b@linaro.org>
In-Reply-To: <3aeac99f-aef3-ee22-f307-3871b141dc7b@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 10:26, Krzysztof Kozlowski wrote:
> On 19/04/2023 03:16, Anup Sharma wrote:
>> syzbot found  UBSAN: shift-out-of-bounds in nci_activate_target [1],
>> when nci_target->supported_protocols is bigger than UNIT_MAX,
> 
> UINT_MAX?
> 
>> where supported_protocols is unsigned 32-bit interger type.
> 
> integer?
> 
>>
>> 32 is the maximum allowed for supported_protocols. Added a check
>> for it. 
>>
>> [1] UBSAN: shift-out-of-bounds in net/nfc/nci/core.c:912:45
>> shift exponent 4294967071 is too large for 32-bit type 'int'
>> Call Trace:
>>  <TASK>
>>  __dump_stack lib/dump_stack.c:88 [inline]
>>  dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
>>  ubsan_epilogue lib/ubsan.c:217 [inline]
>>  __ubsan_handle_shift_out_of_bounds+0x221/0x5a0 lib/ubsan.c:387
>>  nci_activate_target.cold+0x1a/0x1f net/nfc/nci/core.c:912
>>  nfc_activate_target+0x1f8/0x4c0 net/nfc/core.c:420
>>  nfc_genl_activate_target+0x1f3/0x290 net/nfc/netlink.c:900
>>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>>
>> Reported-by: syzbot+0839b78e119aae1fec78@syzkaller.appspotmail.com
>> Link: https://syzkaller.appspot.com/bug?id=19cf2724120ef8c51c8d2566df0cc34617188433
>>
>> Signed-off-by: anupsharma <anupnewsmail@gmail.com>
>> ---
>>  net/nfc/nci/core.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
>> index fff755dde30d..e9d968bd1cd9 100644
>> --- a/net/nfc/nci/core.c
>> +++ b/net/nfc/nci/core.c
>> @@ -908,6 +908,11 @@ static int nci_activate_target(struct nfc_dev *nfc_dev,
>>  		pr_err("unable to find the selected target\n");
>>  		return -EINVAL;
>>  	}
>> +	
>> +	if (nci_target->supported_protocols >= 32) {
> 
> I don't think it makes any sense. How do you protect from UBSAN reported
> shift? Why supported_protocols cannot be 33? You are not shifting the
> supported_protocols...
> 
>> +		pr_err("Too many supported protocol by the device\n");
>> +		return -EINVAL;
> 
> I am pretty sure that you broke now NFC. Test the patches first and
> share your test scenario.

BTW, ISO15693 is here protocol 128, so definitely more than 32.

Best regards,
Krzysztof

