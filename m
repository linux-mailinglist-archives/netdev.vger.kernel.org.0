Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC56630EE6
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 14:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiKSNFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 08:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKSNFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 08:05:10 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2757A8A162
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:05:09 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z20so9112155edc.13
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=eC70NB1hHtUANIGQp9rmkxpFuS6osrXUdSujdEAtEb4=;
        b=Kpk0FRC8D/V6vZlUUVZ23BoMGlKSqHJwjR/uFfIBT2vQrd0c2lyZjMP0mpjyscK5P4
         xNVJ3K2lseN4JRfu7noKWbQKEmgTmGi0SPWlJNUTCrbuAr6XSZzPAAmu0z0D5MBFhM5/
         cmFPB40dv/T3MhFllSRgdFQkWBZR5thDdiF4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC70NB1hHtUANIGQp9rmkxpFuS6osrXUdSujdEAtEb4=;
        b=Z8PJoSZc3MuDLxL/Pk3tjbyag1hs40JvdJnJ2uEQ9/YI88k1Tmvr19sjrL/KGd+D7u
         vT0Lw+mBj23xm59Df76zdc1V6fDl6yhZUPwX175d6obLjmvlrRAc8vOrp2qJQYRl70EH
         OuRISSUMhVKot3/iCYquWRjwA6qVH9fXHgCmas1Qz2M6ewQzq1WgL3171uWzh3/0Oh07
         Jgczjh0IN05RBgM+kDFw9mqDebpmeaSJhTrEYOvwqd47vCsqvPJkbebsgesL7YG0FuvF
         6QaUuej/y2r5//4MW/lBxzucv6f6b6DHuQEILWC3eg0SRpCqkPAvBIyjMrLv4NRObSj7
         0PHg==
X-Gm-Message-State: ANoB5pk3cAq/A/m7mWrrGpYo5UPWXeVOCIU52qGDqK2QjV001M/ghvAA
        wV//McnmrphjQ3c37cf5/31AUw==
X-Google-Smtp-Source: AA0mqf5e0okWbuM5dXejfdlL3evhOwdYepYpZkEkBj3t3kpQpK1KVw49uQZ91ZwsuU00XwkwrCxTXA==
X-Received: by 2002:aa7:c788:0:b0:458:b9f9:9fba with SMTP id n8-20020aa7c788000000b00458b9f99fbamr9768146eds.305.1668863107649;
        Sat, 19 Nov 2022 05:05:07 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090676d000b0077d37a5d401sm2880978ejn.33.2022.11.19.05.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 05:05:07 -0800 (PST)
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
 <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
 <87wn7t29ac.fsf@cloudflare.com>
 <CANn89i+iRoHnJ=+MFB5N3c36t5AeeDpd7aHqheBdgKjhNH17qA@mail.gmail.com>
 <877czsplx3.fsf@cloudflare.com>
 <CANn89iKZcq1Y81OH=qsVWbgpkW=gKC-jwRo4PC05PBcPpo55fQ@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Sat, 19 Nov 2022 14:04:41 +0100
In-reply-to: <CANn89iKZcq1Y81OH=qsVWbgpkW=gKC-jwRo4PC05PBcPpo55fQ@mail.gmail.com>
Message-ID: <87h6yvumbh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, Nov 18, 2022 at 03:09 AM -08, Eric Dumazet wrote:
> On Fri, Nov 18, 2022 at 3:00 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
>>
>> Sorry, I don't have anything yet. I have reserved time to work on it
>> this afternoon (I'm in the CET timezone).
>>
>> Alternatively, I can send a revert right away and come back with fixed
>> patch once I have that, if you prefer.
>
> No worries, this can wait for a fix, thanks.

Proposed fix now posted:

https://lore.kernel.org/netdev/20221119130317.39158-1-jakub@cloudflare.com/
