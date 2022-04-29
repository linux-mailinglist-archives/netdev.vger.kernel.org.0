Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9D513FA2
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352679AbiD2Anl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352630AbiD2Anj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:43:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C483819F
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:40:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b12so5789773plg.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S0hvh8N9CuA1tfH0+0CD0HhCXFZ5HF8ZqUYO4X33sq4=;
        b=fEVNX55bz27Z+zdohEMGtKwDcgDRIpFJkXQjt/MvbU+MDO4YtsEO4beumipf+aaoZy
         +jr/7BqtIDUXBsP5pPPBH636dU9CmKFb+u4rw7i1Sf5iiumicrhyifG6z6zaN/unfAKF
         tBY+4I11wSMRDQTgxmt/yZfP9kxKTY/KhlsHr9qThXI915AYrv0bbZUlQkqstQVS7fTC
         hgCRyjC9WRSAzUUx1jDs2NopvgU3mhFaYOv+6+OloBngFTb6VuLquHN34GbBzxfn1vxa
         8d3GQXodSGPV0sojGm+ndxPrvVQC/qdvw/ClKPhwTey/n2Xl023n5TvHSDzPyPnP62tw
         u6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S0hvh8N9CuA1tfH0+0CD0HhCXFZ5HF8ZqUYO4X33sq4=;
        b=4X2wwEAIaDPJplSwGUBs346xiqHSE2h1dFi/9mHGunVzlya+Ye+mUxqYcHQLcL/4WQ
         JVTObMYyhVs9F/iFFILtTGLcFmkPvJjmTaXM8hzbPpynPEmG8qEGOjMCRH9MBBwe/Q/S
         +NVHN5Y8oisa2aPvjBy4lf3KlGjnwaRPqcciHItCtdtktqUXAxsm7HeDNuP0IdR6IJ09
         NEGdu3LKqe20baPu1cuIWC4JQuP81E6Jv2DmhohVZH+KI6r3XPPQPCgbjHxIp0n2hW6q
         EMb94PNAI8UP+vWERbo1Be+rojlA3PIhjdaixscRuNUdSRrbGB7s7rhf9ZXxdFMl1U+z
         EPdQ==
X-Gm-Message-State: AOAM531imcQ8i/BR5rcOattLVE1mUyVCT7nEhEwnbhMHxYG8ydU7GfpP
        AqGzjtKCBtHEE2LpAyI8nxZSIQ==
X-Google-Smtp-Source: ABdhPJw7e6Zq8bAIhZgWC7InizNqQo0NVW+hxP+zXTHh8ZSJSNk4inyuq9WQG6gCDYi4p9FXvDwpVw==
X-Received: by 2002:a17:903:94:b0:15c:f928:a373 with SMTP id o20-20020a170903009400b0015cf928a373mr27342605pld.26.1651192822585;
        Thu, 28 Apr 2022 17:40:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m67-20020a632646000000b003c14af505f1sm4162862pgm.9.2022.04.28.17.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 17:40:22 -0700 (PDT)
Message-ID: <3d6f12c3-48d0-d7ff-6228-c2f4d04e8c7b@kernel.dk>
Date:   Thu, 28 Apr 2022 18:40:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] tcp: pass back data left in socket after receive
Content-Language: en-US
To:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk>
 <CANn89i+RPsrGb1Xgs5GnpAwxgdjnZEASPW0BimTD7GxnFU2sVw@mail.gmail.com>
 <CADVnQymVud=+D7WCZXJCQvhWnzXYhGSxePvEH+SCuuDDK6VoWg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADVnQymVud=+D7WCZXJCQvhWnzXYhGSxePvEH+SCuuDDK6VoWg@mail.gmail.com>
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

On 4/28/22 5:41 PM, Neal Cardwell wrote:
> On Thu, Apr 28, 2022 at 7:23 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Thu, Apr 28, 2022 at 4:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> This is currently done for CMSG_INQ, add an ability to do so via struct
>>> msghdr as well and have CMSG_INQ use that too. If the caller sets
>>> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
>>>
>>> Rearrange struct msghdr a bit so we can add this member while shrinking
>>> it at the same time. On a 64-bit build, it was 96 bytes before this
>>> change and 88 bytes afterwards.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>
>>
>> SGTM, thanks.
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> The patch seems to add an extra branch or two to the recvmsg() fast
> path even for the common application use case that does not use any of
> these INQ features.
> 
> To avoid imposing one of these new extra branches for the common case
> where the INQ features are not used, what do folks think about
> structuring it something like the following:
> 
>                if (msg->msg_get_inq) {
>                        msg->msg_inq = tcp_inq_hint(sk);
>                        if (cmsg_flags & TCP_CMSG_INQ)
>                                put_cmsg(msg, SOL_TCP, TCP_CM_INQ,
>                                         sizeof(msg->msg_inq),
>                                         &msg->msg_inq);
>                 }

I'm fine with that, doesn't really matter to me. You're under that
cmsg_flags branch anyway.

-- 
Jens Axboe

