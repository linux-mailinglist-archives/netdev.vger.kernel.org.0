Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35734BBE6D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiBRRbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:31:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiBRRbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:31:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C040D2B4D9A
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:30:47 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d187so2820133pfa.10
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w1odBMR+TK7M5azhdCaUBTuy+i+g4F8FRY4aAwIHrV8=;
        b=cP/BKhYR9b8m2zGb5WuzWvT4hSSqfbS/KUkmV4Bff5AmSlfY5kC2pYhkbBRPo3wqye
         FqR4aaQ7lenllmLkqLG3j465/fXwLnQ0NmMTBGoLPw/lXSSwI7ABehK8AYoeX6GRL9PS
         9ZureZNAPgfVu+6aqoElOFrEVptkPQhGqbb2sfR7n8rDdxmnoKulYLng6Etkke3Ukmn3
         PMkZy4FUe3/z8aWyVY74WeUjMl9kB2xQsM39Ff+HtqPEf+62a6ZdvKS6i9CfDpt8Y/Zf
         B3GPiImxUP3nsvSlkRWaTG/uqcxbe/VYZe4B/EFjxHZ14A4obVw/l+8hQR487+CT15Kg
         F8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w1odBMR+TK7M5azhdCaUBTuy+i+g4F8FRY4aAwIHrV8=;
        b=T/iAkPDwtO7BJlxI+9SOz1052wYCw0+IHcJtqZreK/ysyzuc52u67/kzbwS5btUY5k
         ptPOS4VmjUCJdzJ593zQW48ZcQkn9JOq5gwMioN1q4o8jMUl6ITZQZJi+8eOkjptNdao
         83RDuFsReswREy2tSv3/TqlDvG/lycB0wpMeCNO2Ve1dgEXdlwvHtmspl8a4CSWYu798
         JVsdxAXEMLPmLKEAiSYBcplgtSTSdJt1ecbxY7x7ZYxB98z6xlPgDaDPb00W12nNhDJJ
         q3021OatQ0Me1RE2aXlJF78f4VGU37Og9UJ4Xu7XZZeDAezejfwo3eV3Py88z9JvBDZS
         7/zQ==
X-Gm-Message-State: AOAM530+2tFqHrxQADg5/GAVpe/qL1gbm3koepME1YbNDCfV3WU4O0Wh
        KeQoz+pbgC7i92juSnivKUTqNA==
X-Google-Smtp-Source: ABdhPJwHzoNdhkUWwUp3mcgHkNtydUq71s/Z1AhoaZ4GUiSSHgTpIgUQJwZaAFQtDg8NHUq4+lLKow==
X-Received: by 2002:a63:dc08:0:b0:372:be18:dafc with SMTP id s8-20020a63dc08000000b00372be18dafcmr7153306pgg.440.1645205447224;
        Fri, 18 Feb 2022 09:30:47 -0800 (PST)
Received: from [192.168.0.2] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id lp10sm21709pjb.44.2022.02.18.09.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:30:46 -0800 (PST)
Message-ID: <ad4ddff0-2fd8-f172-a674-0e88209efbf6@pensando.io>
Date:   Fri, 18 Feb 2022 09:30:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 1/4] ionic: catch transition back to RUNNING with
 fw_generation 0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io
References: <20220217220252.52293-1-snelson@pensando.io>
 <20220217220252.52293-2-snelson@pensando.io>
 <20220217201213.3e794f82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20220217201213.3e794f82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/22 8:12 PM, Jakub Kicinski wrote:
> On Thu, 17 Feb 2022 14:02:49 -0800 Shannon Nelson wrote:
>> In some graceful updates that get initially triggered by the
>> RESET event, especially with older firmware, the fw_generation
>> bits don't change but the fw_status is seen to go to 0 then back
>> to 1.  However, the driver didn't perform the restart, remained
>> waiting for fw_generation to change, and got left in limbo.
>>
>> This is because the clearing of idev->fw_status_ready to 0
>> didn't happen correctly as it was buried in the transition
>> trigger: since the transition down was triggered not here
>> but in the RESET event handler, the clear to 0 didn't happen,
>> so the transition back to 1 wasn't detected.
>>
>> Fix this particular case by bringing the setting of
>> idev->fw_status_ready back out to where it was before.
>>
>> Fixes: 398d1e37f960 ("ionic: add FW_STOPPING state")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> This looks like a fix, and should go separately to net.
> Is there a reason behind posting together? The other patches
> don't even depend on this one.

I posted it to net-next because the patch it is fixing is still in 
net-next and not in net or stable yet.

sln

