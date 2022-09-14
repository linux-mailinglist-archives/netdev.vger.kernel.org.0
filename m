Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062B85B8E57
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiINRuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiINRuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:50:08 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B211115A25
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:50:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id m3so3592868eda.12
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=kSMenUHCuv4zA9D9anxIKIIVTsykHT4wOT6pMeK7IiM=;
        b=ULYNaSwaTygGtg7eJgpV3MuzC1Pvuv582/v3iaq1BG7zl2WQnKZoKnNOq6WIhv7Imm
         NXbNx3D+1owLmjImTYAUIr76er8AAoNdiK4o92oGAUp3tHvpgFEArXGezAEiRmM1i025
         ZH3ysr2O980zlcDA7z+2RaS7oktOAtDaLJGLKwvGrMjC+nzKEe2Ew9kQ1W9izx3VNUpL
         DOVx8Es9U6/HX9U+7mE918Lkk8jsVCt1gKCQpIa4einXo55U1Z7pJmGVANRGzcSxmLNP
         yrqwGbqPI+1NV2ghapkccBDJECebsPIz1O5Tq1R5V9BVj6pTQ+SbEnWG8KZOZ1tevL/D
         6fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kSMenUHCuv4zA9D9anxIKIIVTsykHT4wOT6pMeK7IiM=;
        b=KURLRAn38GOvC6bDAXBTphwYm+naWhMTeZi7r3uWrfKvx9ccrznAX/dX/+KKxK+7/i
         Bd9C9BJeH/H3sDsZ1O/ZTJFhUZfC7Bq9cPUBH1A4m8V7MKeIfrHTuOfBfem/8NgkJjLj
         GUELhklkKmC218O4m+q/1gewR6LA/ws8JjLCdrEWam4ATbKeO6q0WrUpg8ZI4jpx6nll
         DnUFlZ1QHjymVME+S/pJjDFmg1QEuKm6YwlnWQqJUQxdAOK8FBn5JNvPSeBxAc7HYGR8
         u6gPuiYJyx6o0VA0s9pJAQ1q6/jk/GbEpECt0SydQBcRHfzjOk0s8E7merBagu1lLlDd
         Ie5Q==
X-Gm-Message-State: ACgBeo2HGoAgew3axAorNtVTG7Npfx0zMntPs4jimAEA7P5KTy/3zwmN
        b4V0MTARq2N+cD5AjtW6m2M=
X-Google-Smtp-Source: AA6agR6Zg+oL0Hcg1WkdK+fZGRpO1rw1/mEU6ucZdbMOs09X9XMYlNAKLYw+DgytwSmO45J+RyHJsw==
X-Received: by 2002:a05:6402:34cc:b0:451:62bf:c816 with SMTP id w12-20020a05640234cc00b0045162bfc816mr17802098edc.213.1663177805232;
        Wed, 14 Sep 2022 10:50:05 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d19-20020a50fe93000000b0044e6802623dsm10114771edt.18.2022.09.14.10.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 10:50:04 -0700 (PDT)
Subject: Re: [PATCH net] sfc: fix null pointer dereference in
 efx_hard_start_xmit
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
References: <20220914111135.21038-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <19857eee-cb09-761a-948a-08753b105d1c@gmail.com>
Date:   Wed, 14 Sep 2022 18:50:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220914111135.21038-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2022 12:11, Íñigo Huguet wrote:
> Trying to get the channel from the tx_queue variable here is wrong
> because we can only be here if tx_queue is NULL, so we shouldn't
> dereference it. As the above comment in the code says, this is very
> unlikely to happen, but it's wrong anyway so let's fix it.
> 
> I hit this issue because of a different bug that caused tx_queue to be
> NULL. If that happens, this is the error message that we get here:
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>   [...]
>   RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]
> 
> Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
