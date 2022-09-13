Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77255B64B1
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 02:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIMA4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 20:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiIMA4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 20:56:46 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609A2CE02;
        Mon, 12 Sep 2022 17:56:46 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v128so8370381ioe.12;
        Mon, 12 Sep 2022 17:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=139dsmbsaAd8MZiK3fSYiaJDkYkfmCamFM0JQ/i2eFU=;
        b=cLHxg5Gi5bsrTRwpBekrWl2BN8GhA/+EAQqn9bmiMpoMrKCmaE4enQIuIr/4ZzaqLT
         /nhe4/8cQZOr86K23uXGuIHN8fYFuPfRgfJGMjggCke1fPnWsRmCP+0tXzU6Q2iIoF7I
         pQLtqIcUXPBJCwRBvAITTiLM6BHwXS+RFbYXSvZ1vgPNCvzXLL6LqJiFPuZVyTS24/wg
         7WOtOnNv0E1K8+LMeMpMVwuv2lIfYml4N6lyFmVuKiwfvF2UMR5t14VLxwdl2+wpjI1S
         dq2Hy3ePWCVKVcOtXonYMeNn9k5PVJw4ix9kor+tPdkFWC8dhgt46oldlZqlGlYzF6rc
         0kSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=139dsmbsaAd8MZiK3fSYiaJDkYkfmCamFM0JQ/i2eFU=;
        b=Q5JnW3rwmPB17CTMandcBpNGLWRdC5YU+hQVOUA5gbe6vXr2RHYpw9BY70v/gm9dXm
         E50HJ+gTrAH5hsHds7tVZJiJ0G4CrhOaQGj0PwI6uoej9j5j3hfZj4kV3Ibh0mTE8ICy
         aPzqd85f006ZkjdWfTdfVgSc93dhhtqfzEurXMiEq0rlST8+Fmd20Ha1QYAbepBnw0Cp
         Hu8LUBAIsYnwupBbBWskZ7ZiljIuuQnFoPBcdLbso3aevOhPmuToJFROv0hESAv6AbH+
         r1DGiPa6g7fSCA2AYkhHxRTIVx2+rWUQyYToLc/zi/TxgjOVfiMsUE4BtVZvKQ2A5Nr/
         civg==
X-Gm-Message-State: ACgBeo1WXw5+HvDJTiC77gDn/WJrydRHZufNEr55TYu1eA1FHA8xVkyU
        kZF56Vn9W4gj4XjkFwCB+6b9BlNIBPXJFmfLV+U=
X-Google-Smtp-Source: AA6agR6E6N6UNnoe9DxzrJyWBdSoaS90BbaZ6XOn5MwMsTfUdg5oZYv/dYaycKs4WAY5hqDW3Gi55KONm1OWZ5/k+G0=
X-Received: by 2002:a05:6638:1a12:b0:358:4c15:69a0 with SMTP id
 cd18-20020a0566381a1200b003584c1569a0mr10661537jab.15.1663030605494; Mon, 12
 Sep 2022 17:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220912214455.929028-1-nhuck@google.com>
In-Reply-To: <20220912214455.929028-1-nhuck@google.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 13 Sep 2022 03:56:37 +0300
Message-ID: <CAHNKnsR8jBbJ32mia_XaP3SLWfHNJsFknbrMa9MxZMQbnJ1-pQ@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: Fix return type of ipc_wwan_link_transmit
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Sep 13, 2022 at 12:45 AM Nathan Huckleberry <nhuck@google.com> wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
>
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>
> The return type of ipc_wwan_link_transmit should be changed from int to
> netdev_tx_t.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
