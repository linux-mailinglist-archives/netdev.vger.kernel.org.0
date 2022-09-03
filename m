Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBB75ABC88
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 05:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiICDQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 23:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiICDQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 23:16:25 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840DC8E455
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 20:16:23 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3376851fe13so31538967b3.6
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 20:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9019xUUgha0XU8iWEos1ixEPqahW6+6xYwiKM3vzWtA=;
        b=GIJ2in1wXbL5qeo3IGnYPgvqIfaYrU2hGgMPfjtLmxa/zZ3dpHCp03jVdt4wXjT1TT
         c4/2fLKdtaLS8eKhN6FKawXmO1fcnVTM2X0uFtQCg+yJSi2LQi/5FQcbE3xb8USvNI1A
         goUEGQGvoksMG8ElHrLwdy1TNSHK+oMstKswPcl0j72NC485sP5rNTKunF5eo6CwHd5n
         iBYKuwkZLhbn4N1W5DPax09+YC8sbP0obJ3vgfEK+suoGkB3jmIjoTfncdvGxc3PIJSB
         GW+7m6L+savFfbXRwoET36Vk8ao2g1bzosbq5MpS8Ioc/peHuEW8FIjceF3xeNE+HRr/
         z5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9019xUUgha0XU8iWEos1ixEPqahW6+6xYwiKM3vzWtA=;
        b=1jQmzCWFZlezr4Bj3u1ltKSChGWFpWk3RW8n4hkslBMh/mfUlZRA4OEHGzfpKO0Skf
         6PxAfIov2Fvd5HrVck/1juFYIG5SuNYIpxuExeCrYF/uwBmjVfzlUbmQIfpNmaXklmOl
         W9vfNBUG8v3cF3Z1Fd3DBnAZepoyJWiDwHxJs5P1iXqHd0n06Npe/2CPGO+EHehN+390
         18tegzsw4lYI4Nq0iU2f/+HK+2Cme/ER2D4HzSSUx9HgNECz15TvX0oFO/CcoTV59DI+
         y+UJRdy7yc1ueUChERnFTMt8Px4pa39ocVlXRodUmTvqDHEuoSoq11AESA2KdTJE5AaO
         7ejw==
X-Gm-Message-State: ACgBeo1APLY56vlJlOWhRQNzISzfEbnrZnK1fXyxrTa34S3nhsqX6Ncg
        3lFBy66LdjG5CHwdLKomvtKNgcsNLegCkuOFeFhHVw==
X-Google-Smtp-Source: AA6agR5BEVKjhe2KmlcAA7v8lq/f9Q1zQJ3NPZyXvR21/afqnrlPUd51pyVoHo67M8PXodmhmBcUGjJij4ei8yvYgCM=
X-Received: by 2002:a0d:e083:0:b0:343:2928:867f with SMTP id
 j125-20020a0de083000000b003432928867fmr13113424ywe.467.1662174982612; Fri, 02
 Sep 2022 20:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLHKRZU_+vdQAf-RYn5gDxRN4-9_k4wn5N7xAzadGH=EA@mail.gmail.com>
 <20220903025034.98192-1-kuniyu@amazon.com>
In-Reply-To: <20220903025034.98192-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 20:16:11 -0700
Message-ID: <CANn89iJajB9Jp_fJO5jd8_sF1sL6g=NFTw-jgiBRcFT18P0d-w@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
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

On Fri, Sep 2, 2022 at 7:50 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:

> Ah, exactly.
> Then I will add ____cacheline_aligned_in_smp to tw_refcount, instead of
> keeping the original order, to avoid invalidation by sysctl_max_tw_buckets
> change, which wouldn't be so frequently done though.
>
>  struct inet_timewait_death_row {
> -       refcount_t              tw_refcount;
> -
> -       struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
> +       struct inet_hashinfo    *hashinfo;
> +       refcount_t              tw_refcount ____cacheline_aligned_in_smp;
>         int                     sysctl_max_tw_buckets;

This would move sysctl_max_tw_buckets in a separate/dedicated cache line :/

-->

{
   refcount_t              tw_refcount;
   /* Padding to avoid false sharing, tw_refcount can be often written */
    struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
   int                     sysctl_max_tw_buckets;

  .. other read only fields could fit here.

>  };

Explicit alignment of the structure or first field is not needed,
they will already be cache line aligned.
