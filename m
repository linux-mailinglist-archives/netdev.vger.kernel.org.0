Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CC56B376E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCJHeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjCJHdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:33:50 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2303E41B61;
        Thu,  9 Mar 2023 23:33:49 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j11so5418817lfg.13;
        Thu, 09 Mar 2023 23:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678433627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJoJsZm0fPLQWz7IZmUxRuApQGalUJu4dW7JDfWoa4o=;
        b=RHHm6DUnAQCa+s0mSaRtu2OezhYS4oDWb2F8frhHf59KAqOZYG7zK7o6rrCnqlFqBT
         xwBAEwG15HzPeeBrhXNjNjoMdgh8KumhdLwb/7HHSFhE0C6IJ9YeowLJnEjoJXotrfRP
         bnYOdcdCfM1rpsTTWHZ8HRVT4Jx/8xOsro223I6tAv9t5+4AlfGBIuYqeLYTiAmnL8io
         13izbwuE8Ywq67lVz/B54wnYdM5S5nKwdfQK+vqZEEctD6zm0Vk8q7lXvt3ERgQbVwd3
         ftEgqWVqbDbbiwVhGr6Y/idUYaoKj/Ub23tV3VS3LvfdMvKsIW8X+qGO0ui5e1w37KWb
         EvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678433627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJoJsZm0fPLQWz7IZmUxRuApQGalUJu4dW7JDfWoa4o=;
        b=uIPgUrzUgNai5Vml8d+1MF/nWCEEAVvTHLhFRjV2Mgh0uA6b4xE9E4kYs8pDx/0rz0
         SGpQ4onb6pDNPX5wTD7Y+7RIbqS+YgMMG+r7KgkVuMeuesOnGN1aG/kTrlj1wxIR4vtL
         SSiVrPPuf01glKiqcdJgGnXbpK6GsQ131yawD30p0rFeJzCZ+ba0gMqSbpfaZe08koOH
         vONLxTXd/wvtH2yEMmSzXzScmU8SwPse0UFfTWQlidlbcu42Q0vgcBuz0F4LIUIMEC8U
         4GCSHp4JuFr9IK0y6b4dVtRfkRQVOPQHIhgeImJVdHHqz0rFqKbUldrcE+gv5I11CaMX
         lpMw==
X-Gm-Message-State: AO0yUKUP1DoUON6aux3R4J8inN+Wqg0Al4WGUX2X7gO1zBw+EkPpCu3N
        KAyIRZVAnWKoR4I+0z2hWC/bTuTw1HmtpIFdvLSghg==
X-Google-Smtp-Source: AK7set83+nm8Nr4hhVncbwXK+iak2RBf8wJd9tgD+cJc2Kow9bcwYwL+CkdbJj9/yuA1Q7ez5xiZMw==
X-Received: by 2002:ac2:532b:0:b0:4dd:af74:fe1a with SMTP id f11-20020ac2532b000000b004ddaf74fe1amr6778332lfh.48.1678433627309;
        Thu, 09 Mar 2023 23:33:47 -0800 (PST)
Received: from [172.25.56.57] ([212.22.67.162])
        by smtp.gmail.com with ESMTPSA id o3-20020ac24943000000b004db3aa3c542sm160083lfi.47.2023.03.09.23.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 23:33:47 -0800 (PST)
Message-ID: <9b367837-4bf0-1802-e753-6eca37e105b9@gmail.com>
Date:   Fri, 10 Mar 2023 10:33:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] bnx2: remove deadcode in bnx2_init_cpus()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20230309174231.3135-1-korotkov.maxim.s@gmail.com>
 <20230309225710.78cd606c@kernel.org>
Content-Language: en-US
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
In-Reply-To: <20230309225710.78cd606c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2023 09:57, Jakub Kicinski wrote:
> On Thu,  9 Mar 2023 20:42:31 +0300 Maxim Korotkov wrote:
>> The load_cpu_fw function has no error return code
>> and always returns zero. Checking the value returned by
>> this function does not make sense.
>> As a result, bnx2_init_cpus() will also return only zero
>> Therefore, it will be safe to change the type of functions
>> to void and remove checking
> 
> True, but you need to tell the reader why you're making the change.
> One of the impossible-to-hit error handling paths is missing unwind
> or some such?
  Path with error handling was deleted in 57579f7629a3 ("bnx2: Use 
request_firmware()"). This patch is needed to improving readability.
Now checking the value of the return value is misleading when reading 
the code.
Do I need to add this argument to the patch description?
I also forgot to add mark Reviewed-by: Leon Romanovsky 
<leonro@nvidia.com> from the previous iteration
