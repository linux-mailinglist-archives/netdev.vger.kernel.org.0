Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61B0597EBE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbiHRGl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiHRGlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:41:25 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6A4AEDAC
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:41:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id h5so655123lfk.3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kjPTotdKjvEDDAHNy6fKqwSVnrlA5hvU4qORmBZM7/M=;
        b=NixcghVgXXFL+gHEMQkFJ8FdBomoNLONh7drv5JhIbUfcVoiqnKvVspH5NBtlZfzeL
         p0Z18hgEwbx9W/qaBFxFYmnsXObdHegimcGoCAj2Th4S/riM1mzB9MjtpTTbZNXttrBH
         /aMbfMSA8qUGQGuCXhzKHamnftQSFqLhuu6xOpeiR4SnWhtFwuBLUvCehmiK/Im6+o8U
         vArmeqa20gHo/ROKc/AWL4V4YQA9xTwbO+9fCVnf+vQ6ktx3a8K4MAM/LhW1HJxbx+Fw
         0XsU3qFTLrMdatcP4hm8LUZnoqU90mXY0Do48oAJcj3/K6vY10sJHdQO+7YGUb+zrzp1
         L/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kjPTotdKjvEDDAHNy6fKqwSVnrlA5hvU4qORmBZM7/M=;
        b=uDKVZLTZ3iWcNhwuwj125t18IFdhFwf1ggJMu1ae8Ocw9YU0EDwklhxjeZ2+5VALEU
         a78Ns8HO2Z8smvU3fT9BZREm6p0Ko6VmxRX2iZSWnwOL36NbuGHS8Ak6kG4OQkgZB7Ff
         r++KYS+5YbPzawjPM8IYhL1eKxoqbd87jevHZeIZxNUdyi0rZU2rkp/GUgNSmzTYnnRU
         AxChbWVkfS9t0ti3jij4Ul+KtDY6Hv2ITiYjex/2dZmzWzgCuLys0CXs6T6qIX06I8Ca
         4/RzeeBNgWaKcyb0SNpdEm+LqJ7Hzxs/fe6zehiNj51VMev84sLxFp80Usj/BggF50wz
         2ZDw==
X-Gm-Message-State: ACgBeo2NgM85tsOgl2YQNS14xR9biqbDbpyQHkY1mExPNfRxO/U4eYUZ
        JlNFcJX2wZVEk23ik48hZfYeyzrVm/NXnx5Bu/AoZ9yG1bQIJA==
X-Google-Smtp-Source: AA6agR5/XvyeJiZt0dqbaxscqbS2XOsF8aYUMnZI1ZkN8wr4S3Blnre0OtIFc32aCUlHAQWxVVlRXUBrGD4GJk/PrfE=
X-Received: by 2002:a05:6512:3d8e:b0:48a:eff4:6b03 with SMTP id
 k14-20020a0565123d8e00b0048aeff46b03mr481285lfv.49.1660804883384; Wed, 17 Aug
 2022 23:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660720671.git.chenfeiyang@loongson.cn> <5bf66e7d30d909cdaad46557d800d33118404e4d.1660720671.git.chenfeiyang@loongson.cn>
 <20220817200549.392b5891@kernel.org>
In-Reply-To: <20220817200549.392b5891@kernel.org>
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
Date:   Thu, 18 Aug 2022 14:41:11 +0800
Message-ID: <CACWXhKkJGO5PV8kBurR5Urf7XAiDKgX3b6epn0SPMkZdBH6iUA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] stmmac: Expose module parameters
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Feiyang Chen <chenfeiyang@loongson.cn>,
        zhangqing@loongson.cn, Huacai Chen <chenhuacai@loongson.cn>,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 at 11:05, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 17 Aug 2022 15:29:18 +0800 chris.chenfeiyang@gmail.com wrote:
> > Expose module parameters so that we can use them in specific device
> > configurations. Add the 'stmmac_' prefix for them to avoid conflicts.
> >
> > Meanwhile, there was a 'buf_sz' local variable in stmmac_rx() with the
> > same name as the global variable, and now we can distinguish them.
>
> Can you provide more information on the 'why'?

Hi, Jakub,

We would like to be able to change these properties when configuring
the device data. For example, Loongson GMAC does not support Flow
Control feature, and exposing these parameters allows us to ensure
that flow control is off in the Loongson GMAC device.

Thanks,
Feiyang
