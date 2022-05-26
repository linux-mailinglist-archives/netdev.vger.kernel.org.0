Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18B534769
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244202AbiEZAR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241492AbiEZARy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:17:54 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B52466ACD
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 17:17:53 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2ec42eae76bso232627b3.10
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 17:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQpMgdDVQBlOS7Uyf8RCVf203NdQ67RxWtAyVdVPCCs=;
        b=izRZ8wniZfRM3zYOmlJvnoVIDezjLkP2O23TBOD9uEflwt9rjGMF9cgvcIKpuOnnYh
         5GUVfg4DTwXVl8JjGx7yHc6FxUOYSWVISrlEfUeMNtjhgD1WZ3GC0Br+Hm4hSgJnVsBx
         VUIoJGtdMI0olnZPtf6gGZviqZ5brfyeHwSZ3Ha4j0xUmkY0fnKj0xbQU85w50B+2flr
         UFcCd/SaY7FjW/7ukF+dLhUCBsGnuz5WujxOf0WU8KRb85ePZN0J+l4CBknUmwptcRQW
         h3eipsaQMITddqvh8nM55NnY5caxpDqv4dCi9M5BPfzqhHZcUyfX4GJ3HDOPBC8Q+xlp
         chwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQpMgdDVQBlOS7Uyf8RCVf203NdQ67RxWtAyVdVPCCs=;
        b=TSJwVYvqKJqxXkbDuGOkOo8/K2mi1V/Ee2wQW+yXncBp2R3srtwuRJzH+0UynzE/OQ
         S4HP4bnBEDSzpN5ApM6LAzEhaeDKerhHG3jUh1zLAKiP4HMpzgFAGK8b8ByitDqfXKIU
         70O0RQBiaQ0TPSWK6NCs+iDHjkGDOnBnA8a/+M7jG8j0sGv/ZXVrtlGoQo7kn1ZaFd5g
         wlrhOkc3QhGTE0kRS8/hFL5sqt6hghaKw7bXaMJ7oC384IwU/WoGbnk+dGDcgTMZQuJI
         tyT61fWnMJXYkBu1bmksbaKTuVPm43CEiW3PcvGJRtWGW99FMToFUdJC5Qa70iJcu8Ir
         gcBQ==
X-Gm-Message-State: AOAM532BOJokjeQfYKHMAJwUy6r3gNT6EDpGkb1rBoT+3ZFLOFILj9VX
        X5e6Jxc+zpaYZSStS6+DtR8h0yiY8iV0QEROYrFRdQ==
X-Google-Smtp-Source: ABdhPJxT05BB4TYZzG9FPo1rI0EVNkKMgVxyA5U9KHy7UZZ936Vf+PrV0UlGIm6qNN/z9jx2lVd1/LyBh02fVN1f+xE=
X-Received: by 2002:a81:7c45:0:b0:300:2f8c:7cf2 with SMTP id
 x66-20020a817c45000000b003002f8c7cf2mr9798611ywc.255.1653524272322; Wed, 25
 May 2022 17:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com> <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
 <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com> <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
 <1010638538.15358411.1653500629126.JavaMail.zimbra@kalray.eu> <151424689.15358643.1653500890228.JavaMail.zimbra@kalray.eu>
In-Reply-To: <151424689.15358643.1653500890228.JavaMail.zimbra@kalray.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 May 2022 17:17:41 -0700
Message-ID: <CANn89iKTv9nGqnUerWKm-GZvCQGoTrDA_HNZda3REwo0pLwXrg@mail.gmail.com>
Subject: Re: packet stuck in qdisc : patch proposal
To:     Vincent Ray <vray@kalrayinc.com>
Cc:     Guoju Fang <gjfang@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linyunsheng <linyunsheng@huawei.com>,
        davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        pabeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 10:48 AM Vincent Ray <vray@kalrayinc.com> wrote:
>

> >
> > Guoju : shouldn't you also include the same Fixes tag suggested by YunSheng ?
> >
> > Here's mine, attached. Hope it's well formatted this time. Tell me.
> > I don't feel quite confident with the submission process to produce the series
> > myself, so I'll let Eric handle it if it's ok.
>
> NB : from what I've understood reading some doc, as this is a fix, it's supposed to go
> in the "net" tree, so I tagged it accordingly in the Subject. Hope it's Ok

Patch was not delivered to patchwork this time.

I will resend it.

Next time, please take the time to read
Documentation/process/submitting-patches.rst, thanks.

(line 276: No MIME, no links, no compression, no attachments.  Just plain text)

Thanks.
