Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496575159FF
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 05:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbiD3DLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbiD3DLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 23:11:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1F0193F6
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 20:08:16 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bg9so7796475pgb.9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 20:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rkeES2OIvdNI+++7vcCsjkOqdIA5OgpHye4Y5dnS0TQ=;
        b=U37Ij73DZbkmlfohZzCjCF79OJofs9nwNu8IEe07ZSR9z6x0b69r0JfmvAmP6hR0UB
         0ShV1JzH8B6jRePfRi+0utmY4R6C4qCX6ioToU5cLjY5dUTVcx1oXUad54t5/EotdLgj
         HNbG+JsMM4rD9qjXvmlWioXRKRolYpYqXaAGpA46dv9dWbmkHASwVVn/0E1NyxSJMdcH
         hiLV3UBR+lMWx7lrljO6+YA2AQ46y+i/6pqWj4QYnbPlICPb+tME+bjvQjOETTDxqQiU
         OQ6uTPQzgQmyHKlNYLjyPqRmS9zhZRvGZA9Fd66vjKMda0Yz6y3imQaRGXcOaLx4Uxr5
         bYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rkeES2OIvdNI+++7vcCsjkOqdIA5OgpHye4Y5dnS0TQ=;
        b=Lgyk/F+dvAc7rKh27rdGqY8UOWKe359FFhvALjGUBecOIXzjDr7fxAH5I/bVSmU5Nx
         j5ncroqHE84QDBwzdL1NT931oVpmpfnO6ZlNVUBIr+gVH1+cBx00GPH/MOw8lztxLnSn
         LjphyKFGSJSYQB/7RqccnAElUjcFGCKjFnpay5HAo0azgFj3f7Vit6w2Ovm/YU+Oq+ym
         pvYb4UqDnEqj3T0DJIBHPoVPXe9pec1kl+fY7t8blN1kF/0cI/n4I54H2wfWxAZx5BqB
         TpPfa4fs58DyhqlMIsHQ2kTNBcj7sKtTzmtdyqJ74fg3gsvBD3BvWj7T4JDGrQeXJP7u
         WVQw==
X-Gm-Message-State: AOAM530V52JT8mops+URzNaMhjd/Wyp8R3ryvUPjivSHFuxOvj8ZCRxY
        q3cnD6iIgTIBPL/cfBn2UsTxRg==
X-Google-Smtp-Source: ABdhPJwBF3D+FxRKosYiOQnIqkuXlbkmf3kDwkQSdgiyAIX9wO3jWUde0JZKiBB6sEz7BP1z9EaOjg==
X-Received: by 2002:a05:6a00:140b:b0:4e1:2cbd:30ba with SMTP id l11-20020a056a00140b00b004e12cbd30bamr2078477pfu.46.1651288095956;
        Fri, 29 Apr 2022 20:08:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090a3fc700b001d0ec9c93fesm11420143pjm.12.2022.04.29.20.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 20:08:15 -0700 (PDT)
Message-ID: <38ae32bb-59e5-3e5e-6d22-245e757e428a@kernel.dk>
Date:   Fri, 29 Apr 2022 21:08:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] tcp: pass back data left in socket after receive
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
References: <650c22ca-cffc-0255-9a05-2413a1e20826@kernel.dk>
 <20220429191538.713da873@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220429191538.713da873@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/22 8:15 PM, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 18:45:06 -0600 Jens Axboe wrote:
>> This is currently done for CMSG_INQ, add an ability to do so via struct
>> msghdr as well and have CMSG_INQ use that too. If the caller sets
>> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
>>
>> Rearrange struct msghdr a bit so we can add this member while shrinking
>> it at the same time. On a 64-bit build, it was 96 bytes before this
>> change and 88 bytes afterwards.
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Commit f94fd25cb0aa ("tcp: pass back data left in socket after
> receive") in net-next now, thanks!

Great, thanks Jakub! I'll base on this for the io_uring change.

-- 
Jens Axboe

