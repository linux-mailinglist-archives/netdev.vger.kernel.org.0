Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000EF69781A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjBOI0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjBOI0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:26:12 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4520F367ED
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:26:07 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-530b85f118cso24676317b3.9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 00:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a3ZgM6EtQZl6EzU76OPyMxd1ygIyUswbcQx0Z4OFYnA=;
        b=ZZNGWzUCGDkDEnh3U1hB4PFK1yPD8o1APMZPbCFy0/cCqSuHvWKdbu7hihda9uJBr9
         eFuhenMge8fbzY18JH0rQsB3suRFucWoJJvN/49uURX2TnU2zhCFvsH+okq1zNyxonxT
         gFOsJ8BWC5IguLlpiayTuENRb8WHTYtuL+WH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3ZgM6EtQZl6EzU76OPyMxd1ygIyUswbcQx0Z4OFYnA=;
        b=oKOEDdVBBRV/j/wSUIUfBZ4IUz5q4f3ppQh0OV0mokO+W6FhMbnihV1EuYpvliVcPp
         gLnxfiwTcItu4Or+8dI7Z38NYnGBWJ84IRFRfhPZJ8DE7wGJc326lZX4Un6vvm4/6aNQ
         IB0pAhqDd30NoqcQfJjMpGBdL+uGjKEbDGVlGEaUp7ExiahbhJEvP4FraoegdlZIIXFr
         bgDc2ZtNfeEbVvEFMO8hWymtYE7WmneGCpeQ5UFro6Nc8d0M47NTusbZGhZeVUMjOi5i
         q41ULIGM7FCC+P+i/PbqVmnstxD45yIAzP4yS/+f8Slk8jGzoZpfUjCXiq75GXXG+jRS
         Do/Q==
X-Gm-Message-State: AO0yUKUAyvZZU+EwwJUbSqsA+KGvZuRaFohefstWs+fOfPue8Caz5p8x
        yQ4v9LWm4kN7URQSAa2XcuG5guI53na9g4fV7IUqJQ==
X-Google-Smtp-Source: AK7set8DhJGWq7AJaA+uULI6MQNW8fbj1RwjFmqrpIh4xTVZulcMB71kFvWCwj4F6HCfhOiyadXd/xmprdSemf5n42o=
X-Received: by 2002:a25:9d88:0:b0:881:39d0:46ee with SMTP id
 v8-20020a259d88000000b0088139d046eemr124617ybp.522.1676449566528; Wed, 15 Feb
 2023 00:26:06 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
 <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com> <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
 <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com> <CANn89iJvoqq=X=9Kr7GYf=YtBFBOrOkGboKsd7FLdMqYV0PE=A@mail.gmail.com>
In-Reply-To: <CANn89iJvoqq=X=9Kr7GYf=YtBFBOrOkGboKsd7FLdMqYV0PE=A@mail.gmail.com>
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Wed, 15 Feb 2023 08:25:55 +0000
Message-ID: <CABEBQi=UQn11f7SzeXFSgorQCvj=CU43eNQX_UKcXR4HF-eM-w@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Tue, Feb 14, 2023 at 7:59 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 14, 2023 at 6:14 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> >
> > Hi Eric,
> >
[ ... ]
> Thanks for the report.
>
> I think the following patch should help, please let me know if any
> more issues are detected.
[ ... ]

We'll give this a shot and let you know if we see anything else.
Thank you!

FrankH.
