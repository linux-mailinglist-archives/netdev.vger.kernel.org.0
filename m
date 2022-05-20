Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD152ED8F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348243AbiETNxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 09:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348706AbiETNxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 09:53:08 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9076D60BB8
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:53:05 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j6so6919574qkp.9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGR+whjNeV5lQ5mL6l6NHxm6IVCDzbcrLX3tF9OMg2c=;
        b=EFAnWlMX37CEmbheKts/opui51h5JGB/7WRVQhN8F4ijCxcNhN3QRk2Gfp+dxEgRrl
         4ywhthyY+2++sRfgeFpUZFHz5Pv6JNExpFNSFNGnc0VmKF988VcBk7Cy14k/4f0Wne6e
         V7Ysg5bGno23v9mWaLmD6dwGpQS6mRTrCeXJxhGagrFGhT2ywdv94PA6XtXZs9poeqNd
         jSe8/9fsM7X05zsiS5PzQqO8fY+0cG5H4ouFWqtqroPHpMJR9kURigUyU1eFG3ZItQxH
         OF0f/OCaTEPPdFDFndIODFPtTnvhl45mQgcZyg8YmdSQVl78Mdscso1KBiCHPjaWodhi
         1BqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGR+whjNeV5lQ5mL6l6NHxm6IVCDzbcrLX3tF9OMg2c=;
        b=iTRLCNCGqD8AKvVU0xB6WVl74zWWoTRv8ftmHKJ4hfa52e6n7FnlO4KIPFtCFr9FmZ
         nqNzAfzogAZHRlwNoJjC1OSmPPo90N8YLS/HTCgWNKeJey9x1PQHEfWhj2STE7soaRwv
         h86bdc6RZscrw7KkkDmr/5Do6yJ7RE7tePJXCD+Xi6fvVgjNGtPoUYM5Qjd0mkANlK/7
         GfwmgNWRXm+cJLfladiO6mGZaLW0RzFXAXcfLQaoiocliz+RjPloTeplxAhioncZa+TC
         vtL5H0OPWF3RVKZx+JFfwZh9xSJP7MBlO/7GlfNZsU7KOQov+ZyfOsaZT7czOxNsBSXO
         l2WA==
X-Gm-Message-State: AOAM533PKUyRlZwkch30lMmBoRkbJsy5eq5GDmmbRjMaja+WB+SPeDR8
        TM1SlovMMqpPg6gxw4M9QKCdJ46uiRs=
X-Google-Smtp-Source: ABdhPJx9YIQ2zkSad/YWBQnZa6tCUeQpp3lYuqI2SH+0VCRUKFMaKIWeJhWJdn78rOcUFUw2NH16yA==
X-Received: by 2002:ae9:ef46:0:b0:6a3:5c24:2b4 with SMTP id d67-20020ae9ef46000000b006a35c2402b4mr470913qkg.305.1653054784607;
        Fri, 20 May 2022 06:53:04 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id u124-20020ae9d882000000b0069fc13ce226sm3015696qkf.87.2022.05.20.06.53.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 06:53:04 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id v71so14304650ybi.4
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:53:04 -0700 (PDT)
X-Received: by 2002:a25:e012:0:b0:64f:7141:abac with SMTP id
 x18-20020a25e012000000b0064f7141abacmr1449347ybg.378.1653054783771; Fri, 20
 May 2022 06:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220520063835.866445-1-luyun_611@163.com>
In-Reply-To: <20220520063835.866445-1-luyun_611@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 20 May 2022 09:52:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
Message-ID: <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
Subject: Re: [PATCH] selftests/net: enable lo.accept_local in psock_snd test
To:     Yun Lu <luyun_611@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 2:40 AM Yun Lu <luyun_611@163.com> wrote:
>
> From: luyun <luyun@kylinos.cn>
>
> The psock_snd test sends and recievs packets over loopback, but the
> parameter lo.accept_local is disabled by default, this test will
> fail with Resource temporarily unavailable:
> sudo ./psock_snd.sh
> dgram
> tx: 128
> rx: 142
> ./psock_snd: recv: Resource temporarily unavailable

I cannot reproduce this failure.

Passes on a machine with accept_local 0.

accept_local is defined as

"
accept_local - BOOLEAN
    Accept packets with local source addresses. In combination
    with suitable routing, this can be used to direct packets
    between two local interfaces over the wire and have them
    accepted properly.
"
