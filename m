Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0E265CC2D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjADDfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 22:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbjADDf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 22:35:29 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00400167E2
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 19:35:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso25557092wmp.3
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 19:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsvk33R4DYQucuzlILv604rElypjCvBYNtIeYzz0ItU=;
        b=3oPy7+/jBszDhLigAlcyWJ6kZj7wuKNL8KKHikey1QL2RrHkm82yqN0HrLoHfyD/Np
         hvADAUjv04m5PtaKw+YETVRcGYgSUcZQdM3QEBMIYe6u/N58dvcESEvokUVObcQosnTb
         PZZC27Ng0YvD/2QcKhqwXrwm+i4vqLP7ofMRRlX2xMgGY+PdM8j/v2oFtuD13+Tnq/8g
         6lFuZCOcWtfaNQztCOmwqHRTmhvjaKPd+M+/tProuJU1f9ByAZKYmMYwPeLTzqWqfHr/
         W66+LngGprgSggAPkGil5/MvRA7CP6EtYiA+eEAfNaWTSqqQcKNEtmMAEyIA64wmpCT5
         Z+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsvk33R4DYQucuzlILv604rElypjCvBYNtIeYzz0ItU=;
        b=wz6yIW6jbdVMfep/ALGKwg0xwMTxQBmzc+zfC0MCHqOzG0qQ7vGCQN6ApCcgK29elx
         vA23LQegsRUj5wfo8B5dCRXeps6vzh7r757E/5l3dpxISY7irZoFmacyBafxe+uPiWlN
         7fomHm2ZzTxCJz8LQrOJ9q1XY+uwo9qN31hGWiyW0Q4+iD3FBTzijcf/OU4aXODYC+A2
         EFxN680h3fdAjls2HbvYCGf7wrmzhRudeYL9xQSL2KInfATWh5qsJ1frIqpRkqkFCWGC
         gupqTU9SdqC29aYGSju61eN41rkJhtD7fWOcZpBrsHdioZmKKJQqCPB5EysFiPKy2wqF
         y+Vg==
X-Gm-Message-State: AFqh2kp0EXxUgOoVDN52vBA/GTj8T//oF1z36lCveIcB1OTWHVmlMKga
        kUeqN5rmnnDj6p8THuskicwuCLTGF/W7WoZqe40IhQ==
X-Google-Smtp-Source: AMrXdXv/rEpUOV6MhzNpIfs3SJsrAZanT6qfePBKVHNyTtojiOwaTIsZIFySFaHBQhw+w4GqtmEzKe/FnRXjQ605btg=
X-Received: by 2002:a05:600c:3503:b0:3cf:8952:2fd2 with SMTP id
 h3-20020a05600c350300b003cf89522fd2mr2897959wmq.9.1672803304583; Tue, 03 Jan
 2023 19:35:04 -0800 (PST)
MIME-Version: 1.0
References: <20221229080207.1029-1-cuiyunhui@bytedance.com> <Y7HaeTkNtfb3oIP4@pop-os.localdomain>
In-Reply-To: <Y7HaeTkNtfb3oIP4@pop-os.localdomain>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Wed, 4 Jan 2023 11:34:53 +0800
Message-ID: <CAEEQ3wmc_hPwUc9zeFJ7c0xvmyip7CGHvCHQN2U4c8wyfM1KLA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] tcp/udp: add tracepoint for send recv length
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     edumazet@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, duanxiongchun@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> =E4=BA=8E2023=E5=B9=B41=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=B8=80 03:10=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Dec 29, 2022 at 04:02:07PM +0800, Yunhui Cui wrote:
> > From: Xiongchun Duan <duanxiongchun@bytedance.com>
> >
> > Add a tracepoint for capturing TCP segments with
> > a send or receive length. This makes it easy to obtain
> > the packet sending and receiving information of each process
> > in the user mode, such as the netatop tool.
>
> You can obtain the same information with kretprobe:
> https://www.gcardone.net/2020-07-31-per-process-bandwidth-monitoring-on-L=
inux-with-bpftrace/

As we know, kprobe gets the result by trapping in an exception, which
loses performance compared to tracepoint.

We did a test for performance comparison. The results are as follows.

Time per request
sock_sendmsg(k,kr):  12.382ms=EF=BC=8C tcp_send_length(tracepoint): 11.887m=
s=EF=BC=8C
without hook=EF=BC=9A11.222ms

It can be seen that the performance loss of tracepoint is only half of
that of kprobe.
