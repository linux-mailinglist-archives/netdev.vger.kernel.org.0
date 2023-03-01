Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471896A67BA
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 07:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCAGvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 01:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCAGu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 01:50:59 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078CA21977
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:50:57 -0800 (PST)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 650A23F233
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 06:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677653456;
        bh=dzrOEZ/G+cU1AC5yDnZF1hMrTyBmU7AJE5kFkCkvOQA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=nqpwIM6EKxvJ0jauuTemQltZRnU1Bt0wVZUztEoyozDOQpac/CwOpDBMIAYYyq4qs
         lC+E5QlndHU6jrymua+qhnq8e4Weulyo8BCN5xDmfjIPscoXhwZ3YcHCZVEt+5cXiI
         +sT5W5W/znGW5I/bNoJpCnf+OvcsgLBcQkcbtdKb/Cl9NGcsyqwJUj56c5XX1YNKqG
         liEmNj0/Cyqww9k1eoB8LlFoowLEyhZw8RaYJpGgrC27T2T1KOn0D+YGE1FLSGalgL
         gIw/ATtSMGJAgeDdaAdmvU0fIOZv374KP6T/lFAbG5rLAi7Nlbyk5tNTYxrEklXjH3
         zX3S+IOvCV3Ww==
Received: by mail-pj1-f71.google.com with SMTP id gf1-20020a17090ac7c100b002369bf87b7aso3994674pjb.8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:50:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677653455;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzrOEZ/G+cU1AC5yDnZF1hMrTyBmU7AJE5kFkCkvOQA=;
        b=alAfPlTzLkR7KWJRHwM3l6N8UaQVEbIPqktJZ7p8sFhOoNCqlLytpB0FryvVWEI+Zc
         aQ1JQNrxi9M3MnMOECP36Zyw5JoFTL77FXI15fLfTy6/u8SN6OSsOHKYWKVgRFMdUkUZ
         gHxoVcvBuPypcIOhfciKUpWIJwakHY1UTOw5awyIHd25kJVPnoX0kfsIBoQzoIlq9VoY
         WxkquXufpFMlrMuQtZFRzn0Ek8+d/o9iujCVgZY4OZOHD3x5W64ituDO0RVZBxHJyVh9
         wEMfffc3VkfDvCZklstyjb6WNBJ7ZEtj+qnKJhRHBu+6N/04MIOwZs7VMY8yvx/zpztc
         KqHA==
X-Gm-Message-State: AO0yUKUzSX+C9TUvbSxHLmldth9kSuswuI5+sdjvjbQdufgUdf5Z2DmW
        K6GM/43zTQhVGYGLJjejU+DCQ245bmnivnXS49I8VsPZPLxQeENY1A65GkV2cF+OE0bnKqqzsM7
        OClcWn2YI069lG5CZGYWdoQ2eVSKqR+8kY+I+6gq/wWUCCFGIKA==
X-Received: by 2002:a17:903:2615:b0:19b:b17:6610 with SMTP id jd21-20020a170903261500b0019b0b176610mr1965048plb.4.1677653455097;
        Tue, 28 Feb 2023 22:50:55 -0800 (PST)
X-Google-Smtp-Source: AK7set9O2hozg8W7LXsPplRhCcSEM+wrhXNbZ8y4530KE8NxFOXkoiLxNvfNUDo7tk0a0mEi0RNpwREnZtXUKOA0VYM=
X-Received: by 2002:a17:903:2615:b0:19b:b17:6610 with SMTP id
 jd21-20020a170903261500b0019b0b176610mr1965043plb.4.1677653454819; Tue, 28
 Feb 2023 22:50:54 -0800 (PST)
MIME-Version: 1.0
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
In-Reply-To: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 1 Mar 2023 14:50:43 +0800
Message-ID: <CAAd53p6D7e=pSX0uEZfXiwt9Es9Pd+4s1N5k-8ob+Gb98e01Og@mail.gmail.com>
Subject: Re: [PATCH RFC 0/6] r8169: disable ASPM during NAPI poll
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 26, 2023 at 5:43 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> This is a rework of ideas from Kai-Heng on how to avoid the known
> ASPM issues whilst still allowing for a maximum of ASPM-related power
> savings. As a prerequisite some locking is added first.
>
> This change affects a bigger number of supported chip versions,
> therefore this series comes as RFC first for further testing.

Thanks for the series.

Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

>
> Heiner Kallweit (6):
>   r8169: use spinlock to protect mac ocp register access
>   r8169: use spinlock to protect access to registers Config2 and Config5
>   r8169: enable cfg9346 config register access in atomic context
>   r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
>   r8169: disable ASPM during NAPI poll
>   r8169: remove ASPM restrictions now that ASPM is disabled during NAPI
>     poll
>
>  drivers/net/ethernet/realtek/r8169_main.c | 145 +++++++++++++++-------
>  1 file changed, 100 insertions(+), 45 deletions(-)
>
> --
> 2.39.2
>
