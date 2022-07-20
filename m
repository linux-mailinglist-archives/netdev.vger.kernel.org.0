Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3263A57B22C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiGTH5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGTH52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:57:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1161B23
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:57:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso3188751pjz.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YIz3lR6pTNFCuE9qNtsf8LzrYcbHIZ8vrShikNuR60=;
        b=JljGW8sTA+UeKxOLIb+QbktBv690NkTIiujWpx38P+KRRUOW6+77Z1YkgE5+yEAGGJ
         UDKiP+FmzNKSthlfYL3RV2C3Y41uVVPdZY1NQP2ob78pD9qhu8oVOO8JHTY4167iE8s3
         iWNei/rMH3qpZpygkkgrQuJKarLv7wSaPPEttRSzA1AfzwrhZjlsF6EZaCS8rOqip7j7
         fULBObT+qqye1S/XjlNKHwi+/q4OX+O9TyKVuBbTwO7f6wdmG4FkF87CuPmlL7CcPQy6
         fF6t3RovYSiKEEMPSEzeZy4aG7suHMFQ1o9uOSXORPhxB9LjjZDYLPUYEz8cc45ocqDm
         dkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YIz3lR6pTNFCuE9qNtsf8LzrYcbHIZ8vrShikNuR60=;
        b=P/+8opv5LUsXPQErU83Efoxk5U40WSLyP8AqmRw1jvdHK6HP6DnlMn1G3JsqHpaLR4
         sy4Zlabbxr7CaMbfZgaRpqOymDNQ0UogR9UIEKsnDMbwRfXBcZfrevP9JikedK5bT4kE
         cn6TyXGICHh2twqyJIWfHplRKp1UINjR3uD2AaPnjFFYSFi5cwXCUg1XBRd6tj39tNnZ
         XP4yzLpbf0YJSA5pnB9ygQbpARViZT01/KfG1yCG51V+x4qQTt2m1C/D57Yp75Sm0hID
         /ZUoGMwTunExBlDdXj+YR9O88YyMzMMM1MVWMQ8YzsLgG5zTbzRoZrPyoJimKP5udxFO
         JUow==
X-Gm-Message-State: AJIora8x+dFXYdQtVGbhQ1HQS7wKPbrwoShhqLjnkEcRZjbxSft2bfi/
        1VgjMMiaQKtlNNR+lMht8F1aduyMZ8ckFyt1sp4dzA==
X-Google-Smtp-Source: AGRyM1srl0Aywl+XWht4nUfoV16vn/ZkoZwNRP9bifyjxKQe2XAHk/oPpbwOgt+jd4E4mO50yb+jB29W6ERJ1lN8z4w=
X-Received: by 2002:a17:902:ea0b:b0:16c:3f3a:cb32 with SMTP id
 s11-20020a170902ea0b00b0016c3f3acb32mr36746060plg.150.1658303846772; Wed, 20
 Jul 2022 00:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org> <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
 <20220720031436-mutt-send-email-mst@kernel.org> <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
 <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com>
In-Reply-To: <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Wed, 20 Jul 2022 10:56:51 +0300
Message-ID: <CAJs=3_BtM2CTRLaA28R7_yjfFcq+wexQudfXBM0jWX02ZkacyQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And we need an upper limit for those values, this helps for e.g
> migration compatibility.

Why not let the device decide the upper limit, making it device specific?
As written in the spec., a device can answer to the coalescing command
with VIRTIO_NET_ERR,
If it was not able to set the requested settings.

If a physical device uses virtio datapath, and can for example
coalesce notifications up to 500us, why should we limit it with a
lower number?
