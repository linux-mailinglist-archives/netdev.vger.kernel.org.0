Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04395F1137
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiI3Rzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiI3Rzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:55:50 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F9FFCA7B;
        Fri, 30 Sep 2022 10:55:48 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id de14so3133877qvb.5;
        Fri, 30 Sep 2022 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TStWu5xhTWjf+DQY5C/HvZc7/tJjWZr93okZ6oz8m9I=;
        b=o3KMuM+TyMXuE8VucIlqx29Ar3YQUnGIS/HKNaBUw507MSqTdt6+9eDAb7PcycXrfW
         lTPhPGOuZpuQsSrOtuxbj15j8fOeti6ossPyq+XhHZg9npOhOqzQ4Spo6EyLSaV4NkXN
         gKd4Vf6/R+MqVnfuQOpioUA6ooT7rW7bvQ/xHjFhAgbrh8ISsqvQ/iCWhOmbFsvqQWry
         VgMWnn5GWBTKty1vVXNOhHtXqnnLx4Q+ZaCAGIqeAPALdrSwAp7dv9PRvSVUimjSaR+I
         4NzFLakBA7e8G0GOx5W4QwHD3NdD5PoMw+mEWTu5lzmECKSYCyiNq2qj07ztye8BPKJW
         XGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TStWu5xhTWjf+DQY5C/HvZc7/tJjWZr93okZ6oz8m9I=;
        b=shI0901JRVpm+N9dnEMh54j8Y+5BQKoRl5j9IYBdacGVxO/NrgGKiXQCoKpGk5iVRg
         yuDaL1O5+ACORoRxq/mykOiR5WbJGzxGdmBtwkZStNzWPGmIm85YsZtuPkg8k62pjaN7
         grbuXYTKq8Pmrske2MDrU6KdgT3kRBrqj4ba7jbqiJsJPk5Ikba4XmjBlGB02uX7Ub1t
         wXvlWZM944yRqzmFR2RI1k/qr00GGT1nERQ6EEcb3Chq01YE2nmHzyaPAwqrVqLsoYNo
         fokR6ZHgRQ40zZ3oPRYv2BcsFrRBeAlz7NikltwrCRlK4KSVIgu7A3mrwH6IoCiQkC/E
         Vi9w==
X-Gm-Message-State: ACrzQf2Ta69cOMHKzLI8fJ+YZicDVut0k6wCbMMGuRRBvBYeaYm1923P
        mcV+AhINB7fxbFelg0VqxaWaAANZO7uu4xMfs62U0ExWPLgOWA==
X-Google-Smtp-Source: AMsMyM4ogXT+Xm+sdqReDqZEd/VyZnFYCNEBrHfjOxjungzM8Q8PKknCDrUWeHJ2iK1WjAOl6h9VkR2dh6QjfHjvflE=
X-Received: by 2002:a05:6214:3005:b0:4ad:8042:128a with SMTP id
 ke5-20020a056214300500b004ad8042128amr8003856qvb.66.1664560547733; Fri, 30
 Sep 2022 10:55:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220930040310.2221344-1-zyytlz.wz@163.com> <20220930084847.2d0b4f4a@kernel.org>
 <CAJedcCx5F1tFV0h75kQyQ+Gce-ZC4WagycCSbrjMtsYNM85bZg@mail.gmail.com> <20220930102533.03e21808@kernel.org>
In-Reply-To: <20220930102533.03e21808@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 1 Oct 2022 01:55:36 +0800
Message-ID: <CAJedcCwMobzY8eLcqJ9cjacGOuo3n827V4Q2UfJ0vsX1uAUdRQ@mail.gmail.com>
Subject: Re: [PATCH] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, netdev@vger.kernel.org,
        wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        security@kernel.org, edumazet@google.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please repost without the Reported-by tag, then.
> It's implied that you found the problem yourself
> if there is no Reported-by tag.
>
> Please remove the empty line between the Fixes
> tag and you Signed-off-by tag.

Hi Jakub,

I'll fix that and resend the patch right away. Thanks for your advice :)

Regards,
Zheng Wang
