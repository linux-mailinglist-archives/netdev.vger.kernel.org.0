Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946904C63C0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiB1HW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiB1HW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:22:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A769B66233
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646032938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7j1GkmOvqBxBNz3WaJ25FJ/DXQBZpB6xZ+GFPKNtI4=;
        b=E1vwMCIRPX8evnD08lnnPYF15HIo7fXK6wOkoKPlhhX37liyiyFSHzMbW4y4pmFmtQAafE
        4WqAkoGy3Vnfn8aJjknbZD6KB78e6ilNbhNZTn1kbxUpsKiGqj60rAQcomYAp9b/q6Qf7S
        wUzj7dBdtKdtBYVAIfREis6peCNhKxw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-adQaGs_XN7mQrs-zMPQ4VQ-1; Mon, 28 Feb 2022 02:22:16 -0500
X-MC-Unique: adQaGs_XN7mQrs-zMPQ4VQ-1
Received: by mail-ej1-f70.google.com with SMTP id oy15-20020a170907104f00b006d6a18ab439so806636ejb.12
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=J7j1GkmOvqBxBNz3WaJ25FJ/DXQBZpB6xZ+GFPKNtI4=;
        b=LhmZ3OT/CWh+fM7/Gsa8Snu/ECsogaK3SyQ0OM/khC3F9F4lQqh2f5P0sfKbZ1QVbC
         ksmLl9YckzXPXUCgCVnmkv/Dl1z7himfTKg2ld0+Mx0Ts9PTutq+WfdFR5RMqjcMxVEL
         AmdTyjuVXed1lRAVRYvCZPByueWWz39Gjd1+9Ryey2/Cq5hoJLblM8TpZkmGr/je8krg
         pLh21KRZS37dsI6VS9g244Q5AOzPTR7L761TrWDD16I2sv+8W9y/UIrvgToFx69icNIz
         0ywTDOLwxm0MqNhY9in9W0rVMkTUxoqlJkC44dHq4N1ylSUk20pf59gmkX14jGHhTmHr
         EM+Q==
X-Gm-Message-State: AOAM533yImw9p9QDVpZp3wnSYw+y8WGVJH68HdRoPyhmgCjUxyavdE+0
        XHB43lpfPEIBP6cL7rHZ8KJtUIRZrEoCVObN41fEPqTwt22wJZO47lgGRqOwYKab41EMDfKxCXd
        faLErSLs5MEnHvZvP
X-Received: by 2002:a17:906:1e13:b0:6ce:e50c:2a9c with SMTP id g19-20020a1709061e1300b006cee50c2a9cmr14076009ejj.546.1646032935290;
        Sun, 27 Feb 2022 23:22:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRG2KbPkcp6Nn6d0YABo+529pmRxE8dnV4k24vljbhHYXU44ImG6XzmAWYXKqTn/YLQNSvUw==
X-Received: by 2002:a17:906:1e13:b0:6ce:e50c:2a9c with SMTP id g19-20020a1709061e1300b006cee50c2a9cmr14075995ejj.546.1646032935153;
        Sun, 27 Feb 2022 23:22:15 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id ga12-20020a170906b84c00b006bd3d11bf8csm4023063ejb.181.2022.02.27.23.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 23:22:14 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d36cf804-66a5-0010-2d3c-57dae1e4028d@redhat.com>
Date:   Mon, 28 Feb 2022 08:22:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v7 3/4] page_pool: Add function to batch and return
 stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-4-git-send-email-jdamato@fastly.com>
In-Reply-To: <1645810914-35485-4-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/02/2022 18.41, Joe Damato wrote:
> Adds a function page_pool_get_stats which can be used by drivers to obtain
> stats for a specified page_pool.
> 
> Signed-off-by: Joe Damato<jdamato@fastly.com>
> ---
>   include/net/page_pool.h | 17 +++++++++++++++++
>   net/core/page_pool.c    | 25 +++++++++++++++++++++++++
>   2 files changed, 42 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

