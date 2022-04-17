Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4682D5049B7
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiDQWcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 18:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiDQWct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 18:32:49 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0065C55B4
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:30:12 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f19fdba41fso203737b3.3
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYsLAcs+Cdr2DI93W7KQbZdUoLBWhPGFIGg6PQXepFQ=;
        b=XyU5t2OQEsZMaQx6vHZ+ZTBI/awktCVlSLtJF50A7FMl2ckR/0pwayVsPssiRa8fUv
         vyovJLg6Iy9ZxPq/JUyzT83zExS73bxk7QjJOGRw5me/NGTlcI6q85HTJIrbgrlOXxXu
         SO7gLb1SEfyjeidMYdVx2KfLE1InZ5fP0+idGzPLU1Xu1Sf92tK9DLMuJNuj9Kp/+VHp
         Z0ATW0msTwTe/AJx2LGbnz7RkWlC9ZBOnGB0nZzbx+Kxe2EahfTmWrIJns3kMcjw7FjI
         TxofvYoDTxi3lwSt6avWlw8110skZlunIgXTHd0O5cHgg8ekRApLoYXOSf8lk3DqHqNa
         maGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYsLAcs+Cdr2DI93W7KQbZdUoLBWhPGFIGg6PQXepFQ=;
        b=Xi1buMmGaytbVdlBG160gU+11JgirsIg28I5KKRYwTyb7V/fEcUerPq7pxo+4KnTA/
         nZa5/ibLC34Ocmpfx+3RdfjVt/QkDToStKTPd4s8MQzK1OAzw3vz6GnrUKP6oEc1/q3T
         lIH2oTjDS/JgqFajjo0z5MFLVJIm4HK0/vsdFQDIHclOJCQ3GEjyjqFLPqnq4ZPWg2Vi
         cDJ55/GCkV+dBymlFZzx0fpy39ZW1Nn8lbhrgRX3Yf1kqZFCq1L8BXi5aKSL9zhM2oPb
         bIaQXHkemmEpSrOcB+rgxWZ35mCz7yRKqtn+Fedl9/zDyYF74pC981Jw+ysGEPhkuboY
         o9/w==
X-Gm-Message-State: AOAM533LoRMnn2tB9t13srub+3YRcv6wOcTWUg244tDJa/rW91txLOO1
        UroDuHlXQVmV8sSvwQdrQOEyAYP/lv36ebQPCTe7BaRfRgQ=
X-Google-Smtp-Source: ABdhPJwPm7wERRi+KZKUIwDtanlQw113ZOji8RINj0OPfZeUKYKorgVxcdXL69B4PLk+ysSQBGN/QKNCx3tlMxebq5o=
X-Received: by 2002:a81:23d8:0:b0:2ec:611:ab74 with SMTP id
 j207-20020a8123d8000000b002ec0611ab74mr8045339ywj.154.1650234612188; Sun, 17
 Apr 2022 15:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220414011004.2378350-1-eric.dumazet@gmail.com>
In-Reply-To: <20220414011004.2378350-1-eric.dumazet@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 Apr 2022 15:30:01 -0700
Message-ID: <CAM_iQpXb=-hdGbdbpTbDBGJKyYPhn3SxXUUowHg5gTy20W=iiQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net_sched: make qdisc_reset() smaller
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
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

On Wed, Apr 13, 2022 at 6:11 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> For some unknown reason qdisc_reset() is using
> a convoluted way of freeing two lists of skbs.
>
> Use __skb_queue_purge() instead.
[...]
>
> -       skb_queue_walk_safe(&qdisc->gso_skb, skb, tmp) {
> -               __skb_unlink(skb, &qdisc->gso_skb);
> -               kfree_skb_list(skb);

Isn't it precisely because of this kfree_skb_list()?

Thanks.
