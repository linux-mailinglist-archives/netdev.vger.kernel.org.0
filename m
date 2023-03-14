Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AFC6B9AE6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCNQRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCNQRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:14 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F35C7302F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:16:58 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-53d277c1834so314139917b3.10
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678810617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5J/HDqKu4x54nv7V1xWs/DNuc3ZtDPtjPjGMkyb6YM0=;
        b=A3/xG2qDXNRDu5xVjOGoUxKbZsMgz3AASithsT+fEOd5CCVyU30fI5J7WmOCQxIGes
         JvILmA9THRagiO21Qxegke4/xLrQJqV+0bUhN1gX2YDsJF1ddh/DTkLN0IxjYap13oYX
         /ODFQkN0MFaYM7r8aVsEEOn25+cgzuNyRqxB5HL/LJH4KK43bgnW3a9SR2CX7Q5JecBb
         v57yf0wJ38nR/v0v7H/JAETJwcY1AxzkflZG2xTe8I2Z1q9W9j/SJ+XBcU/Z1xlO1Y9Y
         pGz1f2g5Vn9ARgepbjEBL6GbkcH67Q1PRkszjF0maHXrztRx58MlEN8vWYvvR7FW1e/u
         2kZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5J/HDqKu4x54nv7V1xWs/DNuc3ZtDPtjPjGMkyb6YM0=;
        b=UhvqbGmiRwpbf6aCARVYoopXUnPCoRrsZYGeFTpd1bPlytj3kol/9k2jkmDVl8HZMU
         2ND6Qzh08Bj8dMK6OSjJQ2UdA5+WGWgJBbVMvU0xxpUhbFnfe1p7L/c9owolqBQd7rHi
         HIQnBnv24xn/cWBn0cKGgOgb1RyEfe97LqGSIjXrgKZuRE7l8kbv9YIvxxNZVaPXOJok
         NXJ2/3kBYPkrsz13pdBJc21DCJ7WITRaWtZkxy9tDyI/BCfY2wlEzMQ6wB2LkfCJLTGb
         6jv3P1H5QhCwDTOztFh9MbdZE77qPE0NRJsQLmRsHPdmld+JHktPEWu51P1DiVwBSdKX
         VnmQ==
X-Gm-Message-State: AO0yUKWkkPMFCIepyA+f9MvAWBQy8Ye7ZYXa0mpDPecyrkB9AkPTpjvx
        7LWEvOTOx48OSdhKWTbCihBGWkApA4nKxHYO/71KuquQsrBzrCkj4/oKWw==
X-Google-Smtp-Source: AK7set9WI2x9mfXYk3HVzdAmtZRKqahfF0S6wlzD7IIXlSZvosJpx/noS2+E7xVI99kBJ5eBZzHlMDobdGdKliZHMG4=
X-Received: by 2002:a81:b245:0:b0:544:6828:3c09 with SMTP id
 q66-20020a81b245000000b0054468283c09mr1313187ywh.0.1678810616965; Tue, 14 Mar
 2023 09:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
 <20230310213804.26304-1-kuniyu@amazon.com> <CAL87dS3Brkkbi-j-_W3LYORWJ+VOXockpiBwNZQ84rWk+o8SXw@mail.gmail.com>
 <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com> <CAL87dS1ZCNaX6F+NGNm=RTFNJ0pE7zfceX2YCJc_N-K8cMPefQ@mail.gmail.com>
In-Reply-To: <CAL87dS1ZCNaX6F+NGNm=RTFNJ0pE7zfceX2YCJc_N-K8cMPefQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Mar 2023 09:16:46 -0700
Message-ID: <CANn89iJiBbu_n8t4tweu_56-h0hY8CQHUDPHnsm6q0eUfMs8hw@mail.gmail.com>
Subject: Re: [ISSUE]soft lockup in __inet_lookup_established() function which
 one sock exist in two hash buckets(tcp_hashinfo.ehash)
To:     mingkun bian <bianmingkun@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 9:03=E2=80=AFAM mingkun bian <bianmingkun@gmail.com=
> wrote:
>
> Hi,
>     I find a patch about tw sock, and we encountered a similar
> problem(my problem maybe the same "sock reuse" issue).
>
> https://patchwork.ozlabs.org/project/netdev/patch/20181220232856.1496-1-e=
dumazet@google.com/
>
>     I have some doubts about this patch, why does a freed tw sock(I
> think "sk refcnts is 0" indicate that the tw sock have deleted the
> twsk timer) can fires twsk timer after a minute later?
>
> 1. First something iterating over sockets finds already freed tw socket:
> refcount_t: increment on 0; use-after-free.
> WARNING: CPU: 2 PID: 2738 at lib/refcount.c:153 refcount_inc+0x26/0x30
>
> 2. then a minute later twsk timer fires and hits two bad refcnts
> for this freed socket:
> refcount_t: decrement hit 0; leaking memory.
> WARNING: CPU: 31 PID: 0 at lib/refcount.c:228 refcount_dec+0x2e/0x40
>

I would advise you to contact your vendor.

This list is for upstream/stable kernels only.

We do not want to investigate bugs that were fixed years ago.
