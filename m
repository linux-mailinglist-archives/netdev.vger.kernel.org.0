Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF915A7E15
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiHaM4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiHaM4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:56:08 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E7C979E2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:56:06 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id d1so10989620qvs.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BO8O6Y3MFh/MYUSNiSGbWSukd83AAqr/q1qEVq4rhtU=;
        b=PFRP3I4V6hDF6ClWskC7YyRPVgroEU86EzD5I2OAZtbykAZoBN+MntDDGcY67zEBIO
         JMwr8s6OyGw/JXpzcp5YxO29Rt6cq2Z0jvvuqSeRFVEl69gz2pJ9scmGyc2Yt3D+SdZi
         rW7daxFH/5ydPYaPUoH02MH7lWheOnUh8db3g1+xPddlOFiX3HufzKSmQn8S6efdNUGv
         7BUqfrcmS/9qV+vh6oaUzhI6cnApWDtKdB5LDjyaTHTZ/N4jd2q3LnF5JOgcYOsH60M4
         Pii6oyUrljzR89bZtaR4cTGVE4yIzybmWLsohOsvlm3niF4lqWuB5ILZJgb4kVTZVith
         jYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BO8O6Y3MFh/MYUSNiSGbWSukd83AAqr/q1qEVq4rhtU=;
        b=u4KjWtGa1uZXzEguQzThq6HeC1IpUeUqUKFwmTcQ5kylO6IIYKHNAwElTC0uXzzZrS
         mntq817Wx+mkZQZF2aWMKzrY2K5idEYP6GW/pLdWcaFiQk6t+feE8ne9fucEZW6BVUwt
         n99h1K3qRes7UPNcCdfL98zsm6RW5NyRpkb6b5zwSZMSEmMoa2jBcQu1tGZQj0xrNkaf
         cW26tykKHCflH4gSBLPoMA6InLYnEeCMCrpmogKvyPziCX7Kq8F0Sh4HOqQ1J7R/f8Or
         /ahf8gsYES+YuHwtw8X30N4wD0/T5tUANlJfJRfs/dneaa6P4f20I6/WDGF8xcVdvy4P
         Y+9A==
X-Gm-Message-State: ACgBeo3ShqnJatSpTr9JabTUwJMMwd7ZC/DACWLgfDgBYP/IoczAQmRn
        fjX5SVv1jzuSN+2XKOkHCt5xna5UZTwCK/98Yr2r9A==
X-Google-Smtp-Source: AA6agR5pyAZY/OstASlymkYiOH8tvKdnar8p0RXdAbNLqHMM73vhM8UL/aqPyfwJpYQeP6Q+wqKh6ugITdeTl8OvsuI=
X-Received: by 2002:a05:6214:2489:b0:499:1a3d:42ef with SMTP id
 gi9-20020a056214248900b004991a3d42efmr3789289qvb.62.1661950565523; Wed, 31
 Aug 2022 05:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220830185656.268523-1-eric.dumazet@gmail.com> <20220830185656.268523-2-eric.dumazet@gmail.com>
In-Reply-To: <20220830185656.268523-2-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 31 Aug 2022 08:55:49 -0400
Message-ID: <CADVnQyn8Mr6FjZjaxPE=9H0GcnThfZX_DHWoM+TwMczPNKpjCg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] tcp: annotate data-race around challenge_timestamp
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

On Tue, Aug 30, 2022 at 2:57 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> challenge_timestamp can be read an written by concurrent threads.
>
> This was expected, but we need to annotate the race to avoid potential issues.
>
> Following patch moves challenge_timestamp and challenge_count
> to per-netns storage to provide better isolation.
>
> Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal
