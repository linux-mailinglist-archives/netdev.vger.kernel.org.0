Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF1624DAF
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKJWj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKJWjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:39:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843D849B4B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:39:52 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v1so4225444wrt.11
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V4iLy86XnflkontGUNe+PUdzrqube7RjtOxMoOG1Mdo=;
        b=IOouANnj75KXbngN4Gq1m41HD0T46AWNAgd5dyEeQrmLCGHGe9/vvrn4zrLNcudhmg
         OsNrSnCuHqbfPiXi9nI8si3nl0CJihjCQb8cSaT6z5BeCcVzIyz+n9570bLIPx+u0U+A
         804QPzn2TyeTWhOjg07oeUWztZMobgkiITCfrUU84JfY8WWbS2ERJWJpapYZzVThsyas
         fpa63Xii8r9qUVPr5WEsC68wlaahpmOJGIOJFlmgf9imek6dlMflAOWmsbqpGJLQofhf
         OdgiS9qwRKK2tgU2llEqgK0RuwPHRGpuGG69ZwN9W9i1GA+MZ8X8V2RL1WsIqpCawZDu
         naFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4iLy86XnflkontGUNe+PUdzrqube7RjtOxMoOG1Mdo=;
        b=C9iZB0ArfTwfB8bfk7qA2tpUKW1d7DIMdkPoPFRtkn2dQgk9l26SbRqwLAyLAU5nI0
         iGiCqPl+Emf6oxHpbjHovQzkLXzdMn4dH4A5XDJxKp//XA/sEhfL+INJf1cQMe1H97SD
         18j8B/Ls9HSmI0c6WWk+9Hhgi0CHuC8Vp99gxcvFoFXTttQu2Wcr97j8IUGUBBmkrBRs
         9PsnlvBRz2d6iykprH8BWlPUOoQO0Ahkr3wiDIwCrD3ynwyy8urEyTjSpbXPi3ERu0Fo
         LXAjxOWClTmrzGY6+kB2UNU/pRf8cgKkWnIphLwrLyetXCstI86678z6lboXD7swBbFj
         0XjA==
X-Gm-Message-State: ACrzQf02o3DntrkNhAW+PUHKFx/tS2+/Tubg1WFxrG6QAtEyE2L4RUrp
        KW02IoWlu+5LE58klfr7E3T51muBtl4FMyqhnYe/wFZsFyw=
X-Google-Smtp-Source: AMsMyM4Xf4391QDFc8qq049ThSijzyacsKtGYzy9HfjUfDMDCRjjrep1dmezJC/O7RPmv1cHhquv0pmwhJBs6Ikyg8U=
X-Received: by 2002:a05:6000:1c2:b0:236:6e69:db3d with SMTP id
 t2-20020a05600001c200b002366e69db3dmr42018745wrx.144.1668119990556; Thu, 10
 Nov 2022 14:39:50 -0800 (PST)
MIME-Version: 1.0
References: <20221110172800.1228118-1-jeroendb@google.com>
In-Reply-To: <20221110172800.1228118-1-jeroendb@google.com>
From:   Jeroen de Borst <jeroendb@google.com>
Date:   Thu, 10 Nov 2022 14:39:39 -0800
Message-ID: <CAErkTsT8mXJqLGKc8M2Aoz9h6+h=5Zw2L9UGb4KS2Ynp22cqBA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Handle alternate miss-completions
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
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

I should have prefixed these with 'gve:'. Let me know if I should resend them.

Apologies,
Jeroen


On Thu, Nov 10, 2022 at 9:28 AM Jeroen de Borst <jeroendb@google.com> wrote:
>
> Some versions of the virtual NIC present miss-completions in
> an alternative way. This patch-set lets the diver handle these
> alternate completions and announce this capability to the device.
>
> Jeroen de Borst (2):
>   Adding a new AdminQ command to verify driver
>   Handle alternate miss completions
>
>  drivers/net/ethernet/google/gve/gve.h         |  1 +
>  drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
>  drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
>  .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
>  drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
>  6 files changed, 140 insertions(+), 6 deletions(-)
>
> --
> 2.38.1.431.g37b22c650d-goog
>
