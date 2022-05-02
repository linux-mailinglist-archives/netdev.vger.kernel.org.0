Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BA85170F1
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiEBNyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiEBNym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:54:42 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B267613D7E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 06:51:13 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id c1so11345042qkf.13
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpRcT6cBGgIvjuJLXqOi7apbkA4TwDLee4dbnnhi+Lw=;
        b=iiCr2I3mzbQkTlEzbMW7FMHgQ2/6hJFOJQYNKtxMO+IoevNCgUjYvsLEx/1qg22qns
         QQJfqSmvZmnqSf81/Uj+ppSm7FuK08f0mMyyzt+aZSYi5jupy44YN/OmwXM7/+ml5Rwq
         kopxww1J3bAEO9lxb45b3GPXIWpFWe02pzv2YBcyu9OhcF+6Cy7VsgTFmPNYlGAuZoOP
         GO3aQdpDvHWhKPvxtM/zKosRnOMKteeTrVgKjAtxy22/LHzn5GDH/ghjGu19bPMjRPX8
         S4lui8wVo5zI8apUffqr6B6aZwle7q0zDFX/ShQmanjG1uEri+C+f6Eo52y4oseQt1Au
         Rajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpRcT6cBGgIvjuJLXqOi7apbkA4TwDLee4dbnnhi+Lw=;
        b=6e0sfId9z0pbrytAhAP6kkVsYah9mR40ma5v8NsDSw+9E7YUbPgidh1B5bjf/DUGa8
         oG1lzasPQslmbBNh3srLlfgDNJWR1UfozfwkwQQ+kH0PcvuErF0UmZMc8lxuvMjenAtn
         4cFgc4hYGyAqFeNi4gGsw5syRN+0VPjsRHVwzW0WiF4Ciq57LPzT9RaKTXctDlR1jfgg
         yub7vsmtDsAx5AWvMnyYuCWKoeSlbxK1JK8lDxG4F22njzj7U1zMuA9ylUWCdkCRIUvg
         FhCrO1j/FXKmVY1QKVvWSEqs/cJzV1qQaKyWboSBeN61faLztLi+s7lrN4R/qTqnYzWx
         P3sQ==
X-Gm-Message-State: AOAM531AN+PlmNh2EU9O9vNVzsxcb4cFOYN6HcOwtePiHTEuDeIs/BYa
        KZFhk8x1DsVJRNhfrZBItS64diDVXUU=
X-Google-Smtp-Source: ABdhPJzHrTBeQplghUV6evDxIlJEgf6ByHwfDU9eOelZNcuNbmbApiRXk26MCDxAAoNuR5/Cs+q5/g==
X-Received: by 2002:a05:620a:666:b0:69f:bbd4:b9af with SMTP id a6-20020a05620a066600b0069fbbd4b9afmr8538633qkh.11.1651499472788;
        Mon, 02 May 2022 06:51:12 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id t11-20020a05620a004b00b0069fc13ce231sm4242505qkt.98.2022.05.02.06.51.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 06:51:12 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2ec42eae76bso148147917b3.10
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:51:12 -0700 (PDT)
X-Received: by 2002:a81:a047:0:b0:2f7:cdda:3d63 with SMTP id
 x68-20020a81a047000000b002f7cdda3d63mr11375387ywg.348.1651499470811; Mon, 02
 May 2022 06:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220502094638.1921702-1-mkl@pengutronix.de> <20220502094638.1921702-3-mkl@pengutronix.de>
In-Reply-To: <20220502094638.1921702-3-mkl@pengutronix.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 2 May 2022 09:50:34 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf_sKapbYcB1xPXSerRKXJLCybRtc9iw5pFHYfn8gcjsw@mail.gmail.com>
Message-ID: <CA+FuTSf_sKapbYcB1xPXSerRKXJLCybRtc9iw5pFHYfn8gcjsw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] selftests/net: so_txtime: usage(): fix
 documentation of default clock
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
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

On Mon, May 2, 2022 at 5:46 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> The program uses CLOCK_TAI as default clock since it was added to the
> Linux repo. In commit:
> | 040806343bb4 ("selftests/net: so_txtime multi-host support")
> a help text stating the wrong default clock was added.
>
> This patch fixes the help text.
>
> Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Acked-by: Willem de Bruijn <willemb@google.com>
