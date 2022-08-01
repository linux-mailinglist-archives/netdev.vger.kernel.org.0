Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D953D586611
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiHAIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiHAINZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:13:25 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BD62B601
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:13:22 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id k3so10429239vsr.9
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3Zv79Cs51isXrSdJsVm0i4Wa9LD12edge7RWxx7y3o=;
        b=dmqEzlOZ1X3YsuP2nwYbn+cD+s24NBSeT7TsDEkS1uorO87puy7L9Cvgoucf7L8WDs
         bUX1UYXP2+fi/dldoeY95oUgSmqErFNBTb6vEhO5V0ei9Q/0qH+hqJVVF+YPqYv8cOaV
         hcay9seG+ZC5DCr1aULZGcovFoskHIrBbmRgcyyfi1+V3xyVAvRmiKactcnylrDNGpYS
         nf1b3JLqGTWcLwQMQVsUJw6DC2Zg2PMKYXFhjcLzIA9RBq4sV5UsGn3z3KyVC2GOAzfX
         dINFBcBK65WaQkJ+5CoHy+H2eJkCrPpS8jGhhoJM4CRMdtgp4wQPxpUs1JPqnFo2ZqxU
         CjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3Zv79Cs51isXrSdJsVm0i4Wa9LD12edge7RWxx7y3o=;
        b=dRWsoqQyL8ZEBPJggLoyczhQIv9a/G2SI0dTyQArMno13JGRVL8DdsKHwF9lhS1MZ5
         uXsldwUoykjaUKNsdnWXu/X5hbsMGeDTtV3/yF8hxWs3aHu8qXKdmgZJ3p6R124an1tp
         pt3wP+op3kCYK2batOmKYuAifyMsHZibcSz2ZKK0zv3f1WD9dLuJtWKWPie/514zZUVY
         Tb4mMGnZVSYZTD2q00B5V+iu7e95UHs8xrXhpMPFlLLpKnMuPNJbjPPHES8xpRMfo92B
         wQ8sqYKvEItl9rNBskPQ5r/LP4yKKnxFwiSNA7JZtv+L+PzmCpZl49xeW/5SETCmjR0c
         KBSg==
X-Gm-Message-State: ACgBeo1ekhTrAI98M3KeGl3JpxwIKsjAo8O/vG4fRW2bkWWlBcok+FTa
        k16vbpcdcF1MjCH+2Rp0VRobKl8ue2S+kZceIrC1ig==
X-Google-Smtp-Source: AA6agR52sPn0O7rKsqSW4B1dL7cPYFngDmDT5Bc/jLGziLt9uaz9T4vam1lKXUObeAjdqtnFcMZwzzuzl4e9YsN68zI=
X-Received: by 2002:a67:c19c:0:b0:386:3a4b:dd5 with SMTP id
 h28-20020a67c19c000000b003863a4b0dd5mr632376vsj.53.1659341601797; Mon, 01 Aug
 2022 01:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220801042918.292541-1-shraash@google.com>
In-Reply-To: <20220801042918.292541-1-shraash@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Mon, 1 Aug 2022 01:13:09 -0700
Message-ID: <CABXOdTfCxZ=r+iH0bwN3Rb6x-RgXHvCMeieeyQv_bwEAFF=tbQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Replace IS_ERR_OR_NULL with IS_ERR
To:     Aashish Sharma <shraash@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@chromium.org>,
        Martin Faltesek <mfaltesek@google.com>,
        Linux Bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Sun, Jul 31, 2022 at 9:29 PM Aashish Sharma <shraash@google.com> wrote:
>
> Since bt_skb_sendmsg never returns NULL, replace IS_ERR_OR_NULL
> with IS_ERR.
>
> Signed-off-by: Aashish Sharma <shraash@google.com>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  include/net/bluetooth/bluetooth.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index 6b48d9e2aab9..a8b52175af05 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -494,7 +494,7 @@ static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
>         struct sk_buff *skb, **frag;
>
>         skb = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
> -       if (IS_ERR_OR_NULL(skb))
> +       if (IS_ERR(skb))
>                 return skb;
>
>         len -= skb->len;
> --
> 2.37.1.455.g008518b4e5-goog
>
