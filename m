Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6E663CDD
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjAJJaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbjAJJ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:29:39 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78DEA44D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:29:32 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 194so8925657ybf.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxMVb6+fkslwFRfFIc3jz4kt9BLmOFSWtIO9OneUyMM=;
        b=DsnZKuoI2mF4gr/chUmgRBszKtb1xCzEkvOaFw83R6CgCgcjBxYBCJ85GkVSVo3pMW
         zssMTQtFTZmzUR2TeUlTLKsnAyLwqReqLCHFW+DrOfqCNkIC6Ib/l868mkLdLqTDVyM9
         iy9CGfKjtBaRgJNGziHMD/+8eMWtvB1sKg3pqgrcluGmpF9pwx0ixgSdml6LOOxeIQBC
         NVG/5XguK+j0n5y5JfuynqBj9orsHQTIHYjJcYRXdj1wzfKHJZJ2PDJUglZzxM+NwjOm
         mmnELdex34f6a8WlyW/PnmvNIr2l0w5+HtrQv/HTWpEBYEan1blZnyjGpTOv5UfmtM+Y
         S6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxMVb6+fkslwFRfFIc3jz4kt9BLmOFSWtIO9OneUyMM=;
        b=jAbQb/r80p9Q/hfc/JePEEIsJYpq1oHXB66Ynb6fZ++ipJEzBdLf2yF2Ps3b5x992n
         OR1UgU73elbFcztc85yWFpyuloJXoQ1RgLqZRM9PuaTIa6+sC2wN84PD/scK2IxY5t9p
         dIHA2EphliHTjPkbIn7CIF44Dh8NZ3H2iagx0jAMNAUBoWluEzFFpA8cH4TPlfW6AFcy
         WgMgUMDLBCulN4/mHV/HSVd9TsBuizqPob0HVnRI6G5e8QDbHx757RKo1Tbsa7++J/EK
         OfmXQXXRP4gDR2EyEpRi4KBj9mvZT1B4Ecl8K+WzDDez6pLGapPSqKIpIoIhxcsxIq5a
         Jz9g==
X-Gm-Message-State: AFqh2kqNwzn6uYXFLrfpgWDnnB3FUUGDCh+Lt8jn47xerSs0axzsOwfD
        tsRoB7ZkVEKmr091UWHFE4EDTcdEQQ1K8ThgzfbwjQ==
X-Google-Smtp-Source: AMrXdXvOyGXV47Ajx3feNBOuyggwcRBTTArd3N4S7J+LfML/U162pOUMXjLZ5j8eHB7vUo0V3pqpDOStT71S+N10Ihs=
X-Received: by 2002:a25:b78b:0:b0:703:657f:9c91 with SMTP id
 n11-20020a25b78b000000b00703657f9c91mr5471246ybh.387.1673342971790; Tue, 10
 Jan 2023 01:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20230110091409.2962-1-sensor1010@163.com>
In-Reply-To: <20230110091409.2962-1-sensor1010@163.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Jan 2023 10:29:20 +0100
Message-ID: <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
To:     =?UTF-8?B?5p2O5ZOy?= <sensor1010@163.com>,
        Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Jan 10, 2023 at 10:15 AM =E6=9D=8E=E5=93=B2 <sensor1010@163.com> wr=
ote:
>
> the task status has been set to TASK_RUNNING in shcedule(),
> no need to set again here

Changelog is rather confusing, this does not match the patch, which
removes one set_current_state(TASK_INTERRUPTIBLE);

TASK_INTERRUPTIBLE !=3D TASK_RUNNING

Patch itself looks okay (but has nothing to do with thread state after
schedule()),
you should have CC Wei Wang because she
authored commit cb038357937e net: fix race between napi kthread mode
and busy poll

>
> Signed-off-by: =E6=9D=8E=E5=93=B2 <sensor1010@163.com>
> ---
>  net/core/dev.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b76fb37b381e..4bd2d4b954c9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6580,7 +6580,6 @@ static int napi_thread_wait(struct napi_struct *nap=
i)
>                 schedule();
>                 /* woken being true indicates this thread owns this napi.=
 */
>                 woken =3D true;
> -               set_current_state(TASK_INTERRUPTIBLE);
>         }
>         __set_current_state(TASK_RUNNING);
>
> --
> 2.17.1
>
