Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3337F61D95E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 11:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiKEKWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 06:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKEKWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 06:22:08 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1922409C;
        Sat,  5 Nov 2022 03:22:07 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id l190so6527832vsc.10;
        Sat, 05 Nov 2022 03:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+co3CUeubjm2uYW9bEqZCEC9kC2xNrdHsDwtCcoY3e0=;
        b=Id5hN3RGMJ92Ms/ucPuEqcqww1GVpIXOabK+LPLU1asWBRE4I2V9zV7jVVVFdw/xPx
         y6jPbwmeEGMpDyf8BvWzbD5aa5xzDUn9eM1lhHpJQhj9fBq1tkXtneh9B8iMQoDG4cnV
         6Cccj9E6WH/Zihg1et7QhZSr1UjZlQDfXVG7sZNEgYcxRKFIewfrmVXvUJ3GPC4wcpfj
         oibpRj3t1k18r5eKfzlCzDjXbhGjFEB2p40xrL8vXGB+k39W4B7uIaeyB58JP3Mw9Wo4
         sAlblGSou0nFOs7KwdyrN3HPPswNBlOkFn7jZ5EZygISi/LwnWEfObwxdmvR7E4sCsMB
         9Hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+co3CUeubjm2uYW9bEqZCEC9kC2xNrdHsDwtCcoY3e0=;
        b=qYo6mIrGm/L9M859JtS4zgsgwAe8wcVtEtPH2fP/epra3851pTesZIBEfskxBRo59h
         gXqCzCNrxB4wVzPZiT+xvlXNN1imn/DQVDjf1Xdu1++fBjptyWL+5WnaJWXrcYZGxqmG
         1HfotrLbcgqL4ipSt4IhS09vjjDJRUss4xbxzRkK8iDGFcl7ECgU5aaujMZGAieMGKSW
         qPfOEkNveoW2LMjyjjte+2ieGesnEz7QHTvV+SpomgTfx9Agzm1X1BpZsU9uugCUU/IK
         ErDuQ2yA8XvthJHUz548ibAGPqQroZ5Owjna/pp4mZ+pmBIBtt/NyW70e9ASYVKYvIbS
         jXQw==
X-Gm-Message-State: ACrzQf3yU4VMAVvZ9dLgqu1h4IgQmsAX1ZOiNMsYu/xnPwMPe8Y0F8Vq
        5e/TxXA6Rg+Gxh9oomVvCi1qUvlZihgsVnqskhk=
X-Google-Smtp-Source: AMsMyM5FGzjIQby+gSSGSeKnTrBcOGqg+2Clco3irlIsB+mHcq6j8F0kpdyqxECn7nMjYywt6FTeIo+CgFV6OKGyjsQ=
X-Received: by 2002:a05:6102:118:b0:3ad:2777:742 with SMTP id
 z24-20020a056102011800b003ad27770742mr12196034vsq.57.1667643726111; Sat, 05
 Nov 2022 03:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221105101755.79848-1-tegongkang@gmail.com>
In-Reply-To: <20221105101755.79848-1-tegongkang@gmail.com>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Sat, 5 Nov 2022 19:21:55 +0900
Message-ID: <CA+uqrQA7phtFFs-=eYroademz2F-5+1yCPMZVcErxnpKxEfi_g@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Fix unsigned expression compared with zero
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=EB=85=84 11=EC=9B=94 5=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 7:18, K=
ang Minchul <tegongkang@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Variable ret is compared with zero even though it have set as u32.
> So u32 to int conversion is needed.
>
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/sel=
ftests/bpf/xskxceiver.c
> index 681a5db80dae..162d3a516f2c 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1006,7 +1006,8 @@ static int __send_pkts(struct ifobject *ifobject, u=
32 *pkt_nb, struct pollfd *fd
>  {
>         struct xsk_socket_info *xsk =3D ifobject->xsk;
>         bool use_poll =3D ifobject->use_poll;
> -       u32 i, idx =3D 0, ret, valid_pkts =3D 0;
> +       u32 i, idx =3D 0, valid_pkts =3D 0;
> +       int ret;
>
>         while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH=
_SIZE) {
>                 if (use_poll) {
> --
> 2.34.1
>

I just found a grammatical error in the commit message.
I'll resend this with the correct message.
Sorry for the inconvenience.

Regards,

Kang Minchul
