Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F450A658
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiDUQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390522AbiDUQ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:57:55 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858D22738
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:55:05 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a14so2018364uan.9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2feid4PrG147T6WY9Gvx9U/HJbVi9jT1QER9Uve8Tmk=;
        b=KCYAfW/4qvbVC11m71tRGW/IlzlEqcdA0q3gy8VwUlXNzC4cblmh7AvyUxftDxb2dJ
         6fAOyk1PelQIpSXoO+0H/GLr4q4SS0geYWvTyt6S7f4NFyoitQ/r6FAd/ZzCx5vuS4Ed
         qKT6EFVfru3nrekFZPBzHL9c/0FXN+uA/eKfKCR+vE2wujbdh/hKzyPmkCdcx5/yvHGK
         y9TxpxZ+/ajMxNqC4+F0dOHqv85ia39eLdq2XRJSIWjZll6zW2TMaui1uKSPs9E500tj
         166DnkNoVrhjDV0u1A2+T+wlYZHhYrBOD/YdEFxUgh9LDamXxtbllPt3hKXpiuyCUpL6
         /rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2feid4PrG147T6WY9Gvx9U/HJbVi9jT1QER9Uve8Tmk=;
        b=r3Ib0gc7GKbK4jqRprzM2YmWUpGw6CXf6z1fE9k+4LPhvXOBKv2sgYuZizZSfMs2RS
         UCHxq+xBg+S+OoXaycYvtEHFHRKv9kixJbrBx+qelF5OKXFWPA/VCTZeXFa3voe+WruB
         e0bsgX/DKPUgVs2B9kN/VxEzl5y8gCAmwbohPouhALuziOeuL639G5UDgytUCkLt7MSD
         u2IElLxgEZISsoy5HNyS3yk80RG58Ii+FFFDku284odvIu/GZx3x2RpkJj9IDwfYt8dk
         nIyYjk4dYiwiUTm06xM2MirWefPcQLxyjodcPy/av03eA4Y2k89tvnYucgFvS5E+m6U8
         vbDw==
X-Gm-Message-State: AOAM533Ic2dnlHCdG5bqB590PjYFOS8EAXoDL+hZRxzfFRgbtZ38DSbW
        RUkiBrpnyhXOvNWZxnyU0StIXu2kYn/09zp+RUw=
X-Google-Smtp-Source: ABdhPJziQoCmQhTN1qqADnfUQEl3FgPRcMFKWoIeeY/t9YsWyvp6chtXv/ABFKF5YuC8vTdihJPw7VIJiYoOcrlepQ0=
X-Received: by 2002:ab0:407:0:b0:35f:ef75:81e8 with SMTP id
 7-20020ab00407000000b0035fef7581e8mr236576uav.91.1650560104554; Thu, 21 Apr
 2022 09:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp> <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
In-Reply-To: <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 21 Apr 2022 19:54:53 +0300
Message-ID: <CAHNKnsTkBiS8EKHXiF1MxoRfmGrv_Zrtgc2gaciCmZQREQULMQ@mail.gmail.com>
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Loic,

On Wed, Apr 20, 2022 at 12:53 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Wed, 20 Apr 2022 at 04:22, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> Flushing system-wide workqueues is dangerous and will be forbidden.
>> Replace system_wq with local wwan_wq.
>>
>> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> Could you add a 'Fixes' tag?

From what I understand, an inaccurate flushing of the system work
queue can potentially cause a system freeze. That is why
flush_scheduled_work() is planned to be removed. The hwsim module is
just a random function user without any known issues. So, a 'fixes'
tag is not required here, and there is no need to bother the stable
team with a change backport.

Anyway, Tetsuo, you missed a target tree in the subject. If this is
not a fix, then you probably should target your changes to the
'net-next' tree.

-- 
Sergey
