Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6468D607541
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJUKnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJUKnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:43:15 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3BB2608D4;
        Fri, 21 Oct 2022 03:43:09 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so4695762wme.5;
        Fri, 21 Oct 2022 03:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K900jaFVQB4K0wGNMX2hVD9xV9wtPx941ilke2G2ejc=;
        b=kk6F187v7S/2DaSwkVn7AYwGNeT/SUdk1QGRlZ7a2mPbKa/9w3y+E81TQqYfTeK7Vk
         WH1M5XPBjhxBVfDy0NxVSEJJczcjlxuaYAwvMDm1xjYYRcM0BgW4ZdFGpFS1O/M83Eux
         DgBhf+mHGwt8/8EzDhIrzfqYdHpgqFC5VeqJuqBNjc1YaJ1uKx5S4uISwMyF7bjJA66M
         p6w/oebKX5Twho8YFYogBjYWjQZ3dMvh68us5zMBcowZeJSw3A6QsAIRuPhyxuaevtAI
         uoFu/mf9+z/74mEZCMTFlo+UdxAYN6pTHAB1rgqTB6hJnBt9NnGfM9ZqW4/MG06TdaJy
         QLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K900jaFVQB4K0wGNMX2hVD9xV9wtPx941ilke2G2ejc=;
        b=6Eh9QD6D4nKKPS2GIzyTFLAIb490VT/WKeJRPmtRLxSqLyO6YjTMoJAHxv7gA0r7Vx
         YqU5o0CFyFzyvB5JU3nWaA3KYmiv2l0hdrw2qZUKzSyQabuFfA+9Ri+tVq7Vf1DwkCXe
         09gPL5Leqnw/qHXeFyEq9Y8aSlKron9+ONiyRS9XNCgY+vpTpJF0zaDmc53K/8X5XCCn
         17dHUQiTJIP+HKFP8GHKuo76vPOoFVoznHqQlDCYcXnWgImCbizNaOFgzzM9RMU6kPj4
         VABGb/DQdI/8ddcN4iBj0ASAGt4gvKfoHey3Ijg9uCFXDo0tkBc+guS1605hAz8vpsxa
         +1qQ==
X-Gm-Message-State: ACrzQf0NGJrfNdNV/as3GUItkFMP5EPCI56qESYncMFSdGfzNocche/J
        koPElaTuhNQ618drKnmFEqg=
X-Google-Smtp-Source: AMsMyM59jxEr89fUEQfETrvjtA3uNs6Awj6UASKKz2gE7TWy+nAKmZA/S9Q3OyI2FCiDtJ4cTHXeQw==
X-Received: by 2002:a05:600c:468f:b0:3c6:f85c:25a1 with SMTP id p15-20020a05600c468f00b003c6f85c25a1mr12190600wmo.60.1666348988161;
        Fri, 21 Oct 2022 03:43:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id c5-20020a05600c0a4500b003bdd2add8fcsm2493181wmq.24.2022.10.21.03.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 03:43:07 -0700 (PDT)
Message-ID: <114a0ef7-325d-61c7-dc47-3ecd575fd2bf@gmail.com>
Date:   Fri, 21 Oct 2022 11:42:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 0/3] fail io_uring zc with sockets not supporting
 it
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
 <d4d6f627-46cc-8176-6d52-c93219db8c2f@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d4d6f627-46cc-8176-6d52-c93219db8c2f@samba.org>
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

On 10/21/22 11:27, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> Some sockets don't care about msghdr::ubuf_info and would execute the
>> request by copying data. Such fallback behaviour was always a pain in
>> my experience, so we'd rather want to fail such requests and have a more
>> robust api in the future.
>>
>> Mark struct socket that support it with a new SOCK_SUPPORT_ZC flag.
>> I'm not entirely sure it's the best place for the flag but at least
>> we don't have to do a bunch of extra dereferences in the hot path.
> 
> I'd give the flag another name that indicates msg_ubuf and

Could be renamed, e.g. SOCK_SUPPORT_MSGHDR_UBUF or maybe
SOCK_SUPPORT_EXTERNAL_UBUF

> have a 2nd flag that can indicate support for SO_ZEROCOPY in sk_setsockopt()

There is absolutely no reason to introduce a second flag here, it has
nothing to do with SO_ZEROCOPY.

> The SO_ZEROCOPY version is also provided by AF_RDS.

-- 
Pavel Begunkov
