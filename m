Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5D6A152E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBXDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBXDIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:08:04 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DBC1422D;
        Thu, 23 Feb 2023 19:08:03 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id y12so12664495qvt.8;
        Thu, 23 Feb 2023 19:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677208082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrZOBgrLfanVHU8gvu8PaQc3hE0+RhVJQiShU2zGgBU=;
        b=fCoewdt5wLUzD+6NJMY/p4tubiW1XCBMZ6uuqtfm2SIMFSBovxOXB2GZFogz348WkZ
         o4BFJHmKiO6+IMvRR6o39cXl1EoNX8WFXbIih2sGcD4O3Zbw2/cEdareC6HbulKIo3l6
         M1CyIx8W6OfKWoB5vSIiNN/6IQfE379JsoN+haV0dKMeHTQUO/H0+E+wKOD86RjEVazl
         Ytmw5/JwpUO1kSKzyLDJ7w33YGzarT88CFJXRDJtBvAXw2iBzbyO6oSaHKjL/JfSdLse
         pvxJV7R95EleV4suYLqzUQbw6bx90ny/PGBoqD5ytYelJvgofFhOZ5pTNQ09ZItvJ2uZ
         FtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677208082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrZOBgrLfanVHU8gvu8PaQc3hE0+RhVJQiShU2zGgBU=;
        b=Itf3wMcfeCZWArF68kafHs3BajA17JyZ0RbvI/NxY/xJCeiLSqVlUm9WRID02Bo7Rn
         tAukK7OT1aecMSZkD6MhwKt22cdBXlFNCXjggskM0i1XGpieZ7SZK8HaauWr9uEyUDoV
         /BU0i9MOIFthuEmycr3vE2IDMgaWd2BcPRyI5B57y2IuiQd7I+SUJVCxW/zmoulAzCIW
         yqA45DCC/LNW3tAqM4+NyNDWZcOYTgVL9kdTR0z1WHBODcXwsW9vtLlLXx+Wd4KGJRKk
         upyVvIzyVUIKmp9WPv6Py2onCzWzVIIHrJYJhsMU2LkIF452iqvUcn2saYjSQRKv/qoQ
         GvRA==
X-Gm-Message-State: AO0yUKWav3RboUyJAUew4rPKKdVpZJsDpa8GKH3CWs48FDqxU1wtM5yy
        ZbCYFb8rEK3Yxp36fN+Hwho=
X-Google-Smtp-Source: AK7set80XqGL8tpwQapQOq5jTup96zyKCKKut8ZL9cRg3OS2a0Hm9cbVze7QmfZD6QfL8GcBezDa2w==
X-Received: by 2002:a0c:f310:0:b0:56e:f89c:b0d9 with SMTP id j16-20020a0cf310000000b0056ef89cb0d9mr23195366qvl.4.1677208082461;
        Thu, 23 Feb 2023 19:08:02 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id r196-20020a3744cd000000b00706bc44fda8sm5335955qka.79.2023.02.23.19.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 19:08:01 -0800 (PST)
Message-ID: <310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com>
Date:   Fri, 24 Feb 2023 11:07:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230223090508.443157-1-hbh25y@gmail.com> <Y/dK6OoNpYswIqrD@hog>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <Y/dK6OoNpYswIqrD@hog>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/2/2023 19:15, Sabrina Dubroca wrote:
> 2023-02-23, 17:05:08 +0800, Hangyu Hua wrote:
>> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
>> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
>> before kmalloc cctx->iv. This may cause info leak when we call
>> do_tls_getsockopt_conf().
> 
> Is there really an issue here?
> 
> If both tls_set_device_offload and tls_set_sw_offload fail,
> do_tls_setsockopt_conf will clear crypto_{send,recv} from the context.
> Then the TLS_CRYPTO_INFO_READY in do_tls_getsockopt_conf will fail, so
> we won't try to access iv or rec_seq.
> 

My bad. I forget memzero_explicit. Then this is harmless. But I still 
think it is better to set them to NULL like tls_set_sw_offload's error 
path because we don't know there are another way to do this(I will 
change the commit log). What do you think?
