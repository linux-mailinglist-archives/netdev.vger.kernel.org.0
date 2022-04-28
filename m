Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC96513ECE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353107AbiD1XAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353087AbiD1XAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:00:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210127E1C1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:57:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id iq10so5591287pjb.0
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eb3yNQVBhkJzfDrQ783D26R+f46gDx6b5TmscQeo+YM=;
        b=jjbjedE6jTNG9bGs6J1Uw+wymgd/a0zy+T7wA92CK+NMSPx3m5Yvna+HNn1WPsAYcc
         MW42BgQsHxO4r4O0FYID7z9jrtExt/IH2y24SNJsRpkkP2KEkPYhv7k/BM4u6IBdpS8G
         Rr8EoVejlRro1pO50kRvv6BpAO6wZMbN75BW5m5yJ5exGtdO3DEM2VaU8tQ4XjnSoHzS
         Nc5+ah39IkhETOaDJwuhJuapK6gZLM0y4KlkIfRRTc8stRiHJ0d6wovdQz69BzIIdgYu
         Ealj43aw2Xz5lxBx8dMmOZ3gGcinq8uV1/l3wsU6rDM9o9GhFd7lcLFy/acxphgnspbB
         Qheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eb3yNQVBhkJzfDrQ783D26R+f46gDx6b5TmscQeo+YM=;
        b=IT99r2efMi3VTRGc3F5Gt+CBXUCyt+MOkray0eEivASxyJGXvhGHByKtfkxrq4X0+k
         0/Rr6veKFkkUJjWC6gjL8GlPN13mpr0ynGt7Pd0QSzTCAT/0sP3J+of5SDSkSvT18mrQ
         V8yXUNpCdptKqxVQv0xNX8Y+6H0Edx9RslZ42TndJGHbMo1ssM+c4fulWxQuTRU20cBQ
         kyUhYtpLNRAeDURvJHvMapTxOc1OCIAD2nwiwiUKjVo+Gu1sevdQ0/FDP66CtyeFW7ub
         HA8z9a0ZzoHKOA27Uj33s8RNpR0hR3vNyOu9zQOSwUofdOgwQk3yWJNCzdB0kc+yQRgM
         mxdw==
X-Gm-Message-State: AOAM533JTZI5Da3EuJemGvhjsxovVQBF4XPiMm07kQZyW3vT7z081cqv
        AJDCodQGdYnRwyi4m6Ko5eUh8g==
X-Google-Smtp-Source: ABdhPJwNwE4r5vcDicYUcwzmvirYmmtlo6fzDEEGVmXcKRDcnnZjTArp5BwAkVe94DAzjpvPyljVTg==
X-Received: by 2002:a17:902:db0f:b0:15d:1e6b:4357 with SMTP id m15-20020a170902db0f00b0015d1e6b4357mr20976249plx.127.1651186647509;
        Thu, 28 Apr 2022 15:57:27 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm839752pfu.202.2022.04.28.15.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 15:57:27 -0700 (PDT)
Message-ID: <11d08d3d-bdf8-68f8-1068-5812b6fff1f5@kernel.dk>
Date:   Thu, 28 Apr 2022 16:57:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: pass back data left in socket after receive
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>
References: <064c8731-e7f9-c415-5d4d-141a559e2017@kernel.dk>
 <20220428151829.675f78b4@kernel.org>
 <CANn89iLQLKc6rUaA8k9rTerXP3yhb0seQS4_K7WGVz1nDGKJ3g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89iLQLKc6rUaA8k9rTerXP3yhb0seQS4_K7WGVz1nDGKJ3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 4:37 PM, Eric Dumazet wrote:
> On Thu, Apr 28, 2022 at 3:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 27 Apr 2022 13:49:34 -0600 Jens Axboe wrote:
>>> This is currently done for CMSG_INQ, add an ability to do so via struct
>>> msghdr as well and have CMSG_INQ use that too. If the caller sets
>>> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
>>>
>>> Rearrange struct msghdr a bit so we can add this member while shrinking
>>> it at the same time. On a 64-bit build, it was 96 bytes before this
>>> change and 88 bytes afterwards.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> LGTM, but I said that once before..  Eric?
> 
> For some reason I have not received this patch to my primary email address.

Huh weird. In general, email is a giant clown town these days,
unfortunately...

> This looks good, but needs to be rebased for net-next, see below ?

Thanks - yes Jakub also mentioned that to me.

> Also, maybe the title should reflect that it is really a TCP patch.

I'll send out a v2 against net-next and update the commit as well.

-- 
Jens Axboe

