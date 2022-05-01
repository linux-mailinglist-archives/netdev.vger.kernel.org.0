Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E184A516379
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 11:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345366AbiEAJkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 05:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344857AbiEAJkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 05:40:32 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376A3E5E3;
        Sun,  1 May 2022 02:37:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gh6so23025704ejb.0;
        Sun, 01 May 2022 02:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5ViapVJF1DFMpUvvMCDM92Zu3wHEo/8IwGcBaU15+L4=;
        b=fc0OUI4hcrKZ13LClof+9OLUFGhxUGRJKfwAwwBNc2Z6hzXAKMV6I0E0vJmplmp89n
         IMwXMxkqX4UDDAUlhXecEDwJ+ufyY/xJBsCnUE06OR4IctHsgr/aO/E1PNQqn5SG4TKb
         ODFE3dBWgj6YyR69KdrDwO9IzCXLeZLrWzPS3e7iEGJZZIDCrjt4VvHJ1wfIn6OCkskO
         /gN9g3ub0skYAqHBiQDKR4Bi1lgr2F99cnwbCnI5ynTldlR4HBjpgcx4oWODs0bGfnYO
         zUVDeCfKZ3lQ/QvDN3vX4LZG2LoNzDqGs5RVaG6IaF6pa2cUIjHFeDPtiPTH0EsB0ojS
         ndIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5ViapVJF1DFMpUvvMCDM92Zu3wHEo/8IwGcBaU15+L4=;
        b=EriJEfJU7XCRn+is8f3MvOnltKuy8TBQsT5YcOpIlFQCHmSlkN+vnOJj+vZbcL8dcE
         3Zx7bojAf0JmmMZQW2JWzLs4F416ToixSyiy6TuOuk2A8Z2iSOqwvIKYGqVhe6cZVnhg
         4czxvbKvtweDmTfgybP1mGTjWfhMsI3P6lRtjLpADOjU+pt0F03erpvY30Q9HI0W8MVK
         LtkNI1Nomzd8yDSlCibwPNHMlyYaGpDFqGRjN5tkNr6UHtibnV0zcEptS4yaa3vyTMPY
         k6hV7jPAAcE3Itz5PJxLpFZ6ezM2jnu4+5oQ06pEubV4shXO6qFn5iO/84yui7wvJE+D
         Lp9Q==
X-Gm-Message-State: AOAM530LYu0yPqmddDe+C+gO+dtFj/XQJW0TOj3lcgB97cICf0wMvyI5
        AQltFRMG/jfvZE5VY0ZtBGg=
X-Google-Smtp-Source: ABdhPJwvLGZJe26G5CI3UDLVL7/1xA5JOXqq5rVPEoAbydvnyktC8O++HUoBW8w7GFe0/Cm0NgTXEA==
X-Received: by 2002:a17:907:eab:b0:6dd:e8fe:3dc with SMTP id ho43-20020a1709070eab00b006dde8fe03dcmr6775847ejc.165.1651397825377;
        Sun, 01 May 2022 02:37:05 -0700 (PDT)
Received: from debian64.daheim (p5b0d70a2.dip0.t-ipconnect.de. [91.13.112.162])
        by smtp.gmail.com with ESMTPSA id ia12-20020a170907a06c00b006f3ef214da8sm2444863ejc.14.2022.05.01.02.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 02:37:04 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nl60X-0002IO-0L;
        Sun, 01 May 2022 11:37:03 +0200
Message-ID: <21e8a296-d756-78c7-8dc9-80fc416302c7@gmail.com>
Date:   Sun, 1 May 2022 11:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] carl9170: tx: fix an incorrect use of list iterator
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220328122820.1004-1-xiam0nd.tong@gmail.com>
 <164914623778.12306.14074908465775082444.kvalo@kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <164914623778.12306.14074908465775082444.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2022 10:10, Kalle Valo wrote:
> Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> 
>> If the previous list_for_each_entry_continue_rcu() don't exit early
>> (no goto hit inside the loop), the iterator 'cvif' after the loop
>> will be a bogus pointer to an invalid structure object containing
>> the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
>> will lead to a invalid memory access (i.e., 'cvif->id': the invalid
>> pointer dereference when return back to/after the callsite in the
>> carl9170_update_beacon()).
>>
>> The original intention should have been to return the valid 'cvif'
>> when found in list, NULL otherwise. So just return NULL when no
>> entry found, to fix this bug.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
>> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
>> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> 
> Christian, is this ok to take?
> 
First things first:

Acked-by: Christian Lamparter <chunkeey@gmail.com>

patch is OK as is.

In theory, the "return NULL;" could be moved one line down
(i.e.:after the closing bracket). This would make it so it would
cover the surrounding if (ar->vifs > 0 && cvif) { ... } check too.
But I can't tell you whenever this move actually overs extra
protection (the function isn't called if there isn't already a
virtual interface present).

As for the BUG that this patch addresses.  It is possible to trigger
it: the device needs to have a primary AP/Ad-hoc or Mesh-Interface
and the firmware needs to send a rogue PRETBTT-Event before any
beaconing is setup.

In my test case (changed the firmware to send out PRETBTT
events every 100 ms as soon as it starts running). It didn't crash
outright after setting up the AP interface. But I managed to see
the corruptions, once I reloaded the module:

[  958.763802] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  958.764560] #PF: supervisor read access in kernel mode
[  958.765246] #PF: error_code(0x0000) - not-present page
[  958.765550] carl9170 3-2:1.0 wlx001f33fcd15b: renamed from wlan0
[  958.765841] PGD 0 P4D 0
[  958.766985] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  958.767063] CPU: 3 PID: 716 Comm: kworker/3:2 Tainted: G           OE     5.18.0-rc4-wt #50
[  958.767063] Workqueue: events request_firmware_work_func
[  958.767063] RIP: 0010:strcmp+0xc/0x20
[  958.767063] Code: 75 f7 31 d2 44 0f b6 04 16 44 88 04 11 48 83 c2 01 45 84 c0 75 ee c3 cc 66 0f 1f 44 00 00 31 c0 eb 08 48 83 c0 01 84 d2 74 >
systemd-udevd[5870]: regulatory.0: Process '/lib/crda/crda' failed with exit code 255.
[  958.767063] RSP: 0018:ffffa720026b7d90 EFLAGS: 00010246
[  958.767063] RAX: 0000000000000000 RBX: ffff980c2e96fd98 RCX: 0000000000000001
[  958.767063] RDX: 0000000000000074 RSI: ffff980c0fd73e10 RDI: 0000000000000000
[  958.767063] RBP: ffff980c0fd73d98 R08: ffffa720026b7d50 R09: ffff980c17a0f640
[  958.767063] R10: ffffffffffffffff R11: ffff980c982e82b7 R12: ffff980c0fd73e10
[  958.767063] R13: ffff980c128de0a8 R14: ffff980c0fd73788 R15: ffff980c0fd720c0
[  958.767063] FS:  0000000000000000(0000) GS:ffff980eff8c0000(0000) knlGS:0000000000000000
[  958.767063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  958.767063] CR2: 0000000000000000 CR3: 000000012e924000 CR4: 0000000000350ee0
[  958.767063] Call Trace:
[  958.767063]  <TASK>
[  958.767063]  hwrng_register+0x5c/0x1a0
[  958.767063]  devm_hwrng_register+0x3e/0x80
[  958.767063]  carl9170_register+0x3ea/0x560 [carl9170]
[  958.767063]  carl9170_usb_firmware_step2+0xaf/0xf0 [carl9170]
[  958.767063]  request_firmware_work_func+0x48/0x90
[  958.767063]  process_one_work+0x1bd/0x310
[  958.767063]  ? rescuer_thread+0x390/0x390
[  958.767063]  worker_thread+0x4b/0x390
[  958.767063]  ? rescuer_thread+0x390/0x390
...

with the "return NULL;" in place, no crashes happened anymore
when reloading the module in the same setup.

Cheers,
Christian
