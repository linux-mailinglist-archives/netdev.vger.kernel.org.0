Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFC604D4D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiJSQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJSQZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:25:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D60EBECF3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:25:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u21so26044064edi.9
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=73ooaDjhsWuKcmTR6uupYzQnjdCkJLwakhqkPvojzTE=;
        b=nc9DaLlL+naAmqBs91NFH0mTAfhu0kciVxW5Mk1lRH1fUMXf9J19T687JJH0yhUHIq
         l+qbmtqUleAtWn5IF+TSvojnj3+3eXhWOMwnSl/0jMXEqdyYlQaggzw0jjCoI9a/Mi3C
         L2Yhq++zp+WELRjHQ0vKJswdcaQotsKiG+Wd/MxtDsYrt+wTfpCjFnSAYTpohgRDA0bT
         9e8aFYvIOMbx5qyFzqqqgauajWzSKlZitlqZpCUJqRNdkmEtG5REd0Uuj5B4pVGl1fTl
         dFKnlGFeK/tCZkrvkkGCxVWEHfnsgUHLJXtqe6wj4OO85jHluXbvaQl4kDAZndqECPNO
         wCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73ooaDjhsWuKcmTR6uupYzQnjdCkJLwakhqkPvojzTE=;
        b=1J/XFcQnHr+zWhXMpc8l5DO/NQ2VgMp7qCcib90/ZmlHyeZyiKcP5IX2x5ssPnQ+ZX
         dRi1Pg4SAmfONjXFXr+XQcFJxkYlTHlvbPtl2evBuKZ30YyKhkWIkzZcg6lSVLOi7e6A
         E1RGS5w2/YReR5MH/aOm59LEJ2XT1AseLQnAvwLFlDlZQruBYaMOEUvJDzohFUjsTZIs
         nxRl0PwviXL3GVQmetk6hS2dwrdGiyIj+F8BBEnrO6972Kmyn2AWFx6VXNXTGVb5qWj7
         Y9ktYPO7aCdU0OH13LqdZz8lplBAdbs4PtOGUz2gGpK/0ijq/kGgqp81j4AHri/elq7T
         2uyA==
X-Gm-Message-State: ACrzQf1fSh4g5bGgIsIOFK8mI9p3NJuWjMpN79C7FpRm8DZZDSj8CFRy
        0TbzO10/rmahYWXSsDF/xrtXUVzuCJheQwxt+RWZS/iFiSzgQg==
X-Google-Smtp-Source: AMsMyM6Vel4HAwvyraTYA5Kd5P/KjHiYQPAxADowTW71bF9f0Z2p0X6hDz7rCcv8m5s32/lK7dvuBSDJG6NSyhcN/Ac=
X-Received: by 2002:aa7:c314:0:b0:458:dc90:467a with SMTP id
 l20-20020aa7c314000000b00458dc90467amr7963832edq.284.1666196730711; Wed, 19
 Oct 2022 09:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221019162058.289712-1-saproj@gmail.com>
In-Reply-To: <20221019162058.289712-1-saproj@gmail.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 19 Oct 2022 19:25:19 +0300
Message-ID: <CABikg9xi4_i-Qn4MqBJTi1HE9pbUKna+xUydu4e2XwofAnxxVA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch,
        Vladimir Oltean <olteanv@gmail.com>
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

On Wed, 19 Oct 2022 at 19:21, Sergei Antonov <saproj@gmail.com> wrote:
>
> The ftmac100 controller considers some packets FTL (frame
> too long) and drops them. An example of a dropped packet:
> 6 bytes - dst MAC
> 6 bytes - src MAC
> 2 bytes - EtherType IPv4 (0800)
> 1504 bytes - IPv4 packet
>
> Do the following to let the driver receive these packets.
> Set FTMAC100_MACCR_RX_FTL when mtu>1500 in the MAC Control Register.
> For received packets marked with FTMAC100_RXDES0_FTL check if packet
> length (with FCS excluded) is within expected limits, that is not
> greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
> an error.
>
> Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Sorry, forgot the changelog:
v4:
* Set FTMAC100_MACCR_RX_FTL depending on the "mtu > 1500" condition.
* DSA tagging seems unrelated to the issue - updated description and a
code comment accordingly.

v3:
* Corrected the explanation of the problem: datasheet is correct.
* Rewrote the code to use the currently set mtu to handle DSA frames.

v2:
* Typos in description fixed.
