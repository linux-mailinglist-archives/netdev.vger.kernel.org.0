Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E080D69078C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjBILgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjBILgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:36:19 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FEE7714D
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:26:07 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id f23-20020a05600c491700b003dff4480a17so3767324wmp.1
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 03:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=arzmlPFRCEC3ktmUkczOnfmY5OM0wVJDFgD9efWlpnY=;
        b=ZPIUeiK+T40h8azkoKzedqz/45kxXPVT2WtenEokHcatb8kB2WgRnnYwA7r08HDLLo
         p0yWVuuBuSWoTP6W+qMzvrvQVvcsmcX0oekDEW+2NGb5Vx1yDa4GvTB79mQYBx/jNaCh
         61Ylbt3wubw9k4awwZ/UPYmrdMZOwVnWVitKnnDuJ3R5mFnZDMwp9iDAXrrvv+oPpDP4
         7sm7W4yFQ3wAw92BH5IM35QNNWIsHlgdBxGSzBpQsWzVmcLqCii+2MVELFsyQJj+8oia
         uVY8/B5DAOE1HfjwW54tBkW1P3m+aUd/vPE3meesVbW/QUgqJJdQV+pg0PyuycfSJQUg
         LiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arzmlPFRCEC3ktmUkczOnfmY5OM0wVJDFgD9efWlpnY=;
        b=3y9Xa8CUoWcrty3no3UmZ8Pd5oSvye/W5r0T4IZlFiX/83ioek9raZxqWxwCNUKeOe
         EZisRD8Lm6KuAaJLwOpn5CQCt5bYdbZ4dCqK1u6KwtflNmeDQbDqIhsTidWogX5j4Owp
         +d6tasw+zwYb1DwBr9ufye1cagG1/kKxSA4CHK3s7J8BLOMUmYxXS5zGxkLj0kMewUGp
         +5DPUkFDdn0MUaz3Uq/spbFGfCwXDjptpkxHQO4vC/sKokQQmT47XSXvb/5aucUSAHVU
         +lHdDXzJZKtTSVfeOZW7tVH6HWYf0Cc1rULeac/ug52noIvylYlbS8aWZH5plPOBNLRP
         MWJg==
X-Gm-Message-State: AO0yUKVj9/iP2biG01WJ5Pj541T1l1coQtXfxvuWHR5fF5TS1qsD/ieR
        C7tJOPZzKriHP61FmIpGQIuL8kbDfzxk/hL1KfivgKyTXlOxpvPF
X-Google-Smtp-Source: AK7set+1gV66F7LWlM6uQ5y5yTX6OOeA6ZU/x9PhrSRlYIgM4B+84GfZLsbCXIaTICgzrat5FDtWJhksH992zjapv0I=
X-Received: by 2002:a1c:7501:0:b0:3da:ed8:43ba with SMTP id
 o1-20020a1c7501000000b003da0ed843bamr582607wmc.145.1675941914172; Thu, 09 Feb
 2023 03:25:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 12:25:02 +0100
Message-ID: <CANn89iKqosk8Dyji7PT-K0ciohQwQSK0ZMwenJx8sxDbfb+m5Q@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 0/4] net: introduce rps_default_mask
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
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

On Tue, Feb 7, 2023 at 7:46 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Real-time setups try hard to ensure proper isolation between time
> critical applications and e.g. network processing performed by the
> network stack in softirq and RPS is used to move the softirq
> activity away from the isolated core.
>
> If the network configuration is dynamic, with netns and devices
> routinely created at run-time, enforcing the correct RPS setting
> on each newly created device allowing to transient bad configuration
> became complex.
>
> Additionally, when multi-queue devices are involved, configuring rps
> in user-space on each queue easily becomes very expensive, e.g.
> some setups use veths with per cpu queues.
>
> These series try to address the above, introducing a new
> sysctl knob: rps_default_mask. The new sysctl entry allows
> configuring a netns-wide RPS mask, to be enforced since receive
> queue creation time without any fourther per device configuration
> required.

Reviewed-by: Eric Dumazet <edumazet@google.com>
