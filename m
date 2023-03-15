Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E206BAC36
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCOJbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjCOJbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:31:25 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7DE7E798
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:31:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bd34so11308764pfb.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678872678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNpUMs+IhCxx+s9zvnv/ZRka5RkBhP1qXxszwmA8oUM=;
        b=SPV2lki5ka2H1eWFB5HkclWR0XMvkGVgGUeLbX5Z4RypHrqdoTLmkKtbTnLw3mVVxp
         xd65P3ZGeYCL0bWRJdidhQe13cVxVnMWd6ArsafkkFsnwsq3Hj+1J8r1ivtt6OCbMJFD
         tyRWrwrZOqJneYGOxS3COQTD31s4eqmPlYF3xH2mtb3Cj6AP37zTYXLXmKMrRF6huqRk
         agRYAS6q2rdyA9qcUQaqYiRfeC8Xl4KodRhjoBSqU0cYrErs6LPzIiHg4aDGVLNogA6k
         26umvSRPu64ARqdF35FGU2q6QLRQvHehpBEEhZtrP34trNvY5bFrX4+ezxe2OUt/uYAp
         FxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678872678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNpUMs+IhCxx+s9zvnv/ZRka5RkBhP1qXxszwmA8oUM=;
        b=PCA31ac1zuAOInNoM6BjAKvZE8k/aVGHqUYCePa0zDiZtk74pphjKZveA5TlYK5BM3
         G/4Lbi461UiG8v07vGxXjtM1zmm17PMePgavlopwBmxkzJiSxzo7X8WHn+SUBt/19JK7
         B/aOJifNcL4ZhB4XtS1FM7TPQ2eyhjBcfsGSX1euaC1wZX0cypv4wYBrSYdZ/rs2N/Qb
         adPu7+Tw/P6V3jJ5VaQfWn3oYevIH7TjbDC9yVF9LGaS+qisSt1612APVVVTa2fqW9VB
         1++Bu4J0F0l5IXbqNx9/IUvtZDFsRi+A2IKrgQwMejioWjnIiUivA7PZQXiU7imnZfpq
         vBkA==
X-Gm-Message-State: AO0yUKV77reFxoGPWLj6WNeK4YyhjwxHad3ntJsOqJXs+4TFOlAHuj1i
        juWsqInCT8WHtQpHHmh86Xs=
X-Google-Smtp-Source: AK7set++FbN8xwpzZ9r1Emmny4totiFCeO4XufKVq3BvZP3B6ZAsaFEzFPFX0676cvrbOTg06+WP7g==
X-Received: by 2002:aa7:9f96:0:b0:625:5e9e:17d5 with SMTP id z22-20020aa79f96000000b006255e9e17d5mr4151665pfr.9.1678872678122;
        Wed, 15 Mar 2023 02:31:18 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 2-20020aa79142000000b00593e5a45ce7sm3166859pfi.173.2023.03.15.02.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:31:16 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:31:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH iproute2 1/2] Revert "tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG"
Message-ID: <ZBGQXxhHmTL38tz7@Laptop-X1>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314070449.1533298-1-liuhangbin@gmail.com>
 <20230315004645.2420c581@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315004645.2420c581@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:46:45AM -0700, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 15:04:49 +0800 Hangbin Liu wrote:
> > This reverts commit 70b9ebae63ce7e6f9911bdfbcf47a6d18f24159a.
> > 
> > The TCA_EXT_WARN_MSG is not sit within the TCA_ACT_TAB hierarchy. It's
> > belong to the TCA_MAX namespace. I will fix the issue in another patch.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Double check the posting format if it's not just a slip up:
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#co-posting-changes-to-user-space-components

Thanks, I will take care of this in the future.

Hangbin
