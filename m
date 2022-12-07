Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787F5645DC5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiLGPli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLGPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:41:37 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D1760E80
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:41:36 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3c090251d59so190377687b3.4
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=136w+/CKs8CAOt1UtFKmxeVbEFnT+kfKx76fyUq1Kv4=;
        b=AgADPMpUD6xEQru7wyaMpatuQW64ewNuH926F3OmxGdANcsDYoeTqPMjgL3l5/vEuQ
         w8/sQsLDQ1YBC4484rbm02Qy3VrZjemayVj5xSjScsCj1b2ohPXZe5Nwr2S00jRqysBS
         aRJCUNBYDKfU3xmxuQFhjA8vp0HPld8wuyXuHLc/c1XdooHNwI5d8XxymdfOi6jffHsb
         dVV21QL3uKg5fQmHlaXUT3RbYbaZib9SIUStxOkOaWD8Ddjky2aROS1QMs0Gzp3smWLI
         7lqRfrF/7CK4FCHVbFHScynjT9L2Sq7rCcSp6PjXPS9+Vs0M2rtMv7v6sXxlwU8hLHjU
         Oz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=136w+/CKs8CAOt1UtFKmxeVbEFnT+kfKx76fyUq1Kv4=;
        b=zQ+tOdL51Z/+d3s6dFp1VrY5KIutrFOc6MTzOVTV+ohMZzeYiogDJ8eqiAv0rEGX1k
         VOLV08lZm4gKLXAePucIQnXrrjy7TTz33hg0R39EB38OuHUaQKD4Mynu8/WwEmhoQ7b9
         DFqAhUg4mRcXwV93/djsbWf5c4GbKuJacqNcqJFuSuRzzoPWcLt/KF3nSzYxUrG+5Y7Q
         u9rrzAvAaKQNshAG763DzyNx+yoJ2jmyMKr6Iktux+Y2mBW0xni56jCNvkF75MF26CbH
         ruNeRyMPp3gWWyYy4R8HWsjO56v30HBSDM8IiaKGzHrzsFMrv2Io30JslrHm8f9fcjp5
         YexQ==
X-Gm-Message-State: ANoB5pnDj+vP8n5Qza/VnaVmoRGz0A9jss+1yFEnFTpfKkzP3KIm/9s4
        jC/GLrbx8smhCIsovwdqJlj/s4HlJlHrLMWzOLYdfQIRwcZRjoQy
X-Google-Smtp-Source: AA0mqf5eqr4pnyvAO/pZYS+AW4Gz7CXXLc4T/eMoMTA5WFi9UKUPaoahqcBK2bP381sI/qIgA7YsVhqTHzIrhruPbFY=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr21561017ywe.278.1670427695877; Wed, 07
 Dec 2022 07:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com> <20221206055059.1877471-3-edumazet@google.com>
 <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com> <CANn89iKUYMb_4vJ5GAE0-BUmM7JNuHo_p8oHbfJfatYKBX8ouw@mail.gmail.com>
 <CANn89iKpGwej5X_noxU+N7Y4o30dpfEFX_Ao6qZeahScvM7qGQ@mail.gmail.com> <eb076121-479b-ca4a-c13d-8adbdfdbc893@gmail.com>
In-Reply-To: <eb076121-479b-ca4a-c13d-8adbdfdbc893@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 16:41:24 +0100
Message-ID: <CANn89iLTGFkZaZJHP08DPL7QCeAq11WCMfPwpvMAti6aEruJ2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends
 on MAX_SKB_FRAGS
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 4:14 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>

> So what you're saying is, if all the elements of
> MLX4_TX_BOUNCE_BUFFER_SIZE co-exist together for a TX descriptor, then
> the actual "headers" part can go only up to 208 (similar to today), not
> the whole 256 (as the new define documentation says).
>
> This keeps the current behavior, but makes the code a bit more confusing.
>
> IMO it is cleaner to have MLX4_TX_BOUNCE_BUFFER_SIZE explicitly defined
> as a multiple of TXBB_SIZE in the first place. This way, both the
> allocation size and the desc size limit will be in perfect sync, without
> having assumptions on the amount X lost in the division.
>
> How about the below, to keep today's values for the defines?
>
> #define MLX4_TX_BOUNCE_BUFFER_SIZE \
>         ALIGN(208 + CTRL_SIZE + DS_SIZE + \
>               MAX_SKB_FRAGS * DS_SIZE, TXBB_SIZE)

I already sent a v2, with:

+#define MLX4_TX_BOUNCE_BUFFER_SIZE \
+       ALIGN(256 + CTRL_SIZE + DS_SIZE + MAX_SKB_FRAGS * DS_SIZE, TXBB_SIZE)
+

Please take a look, thanks.
