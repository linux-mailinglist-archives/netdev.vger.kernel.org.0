Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1E6D3882
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjDBOlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBOlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:41:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECA85B9E
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:41:43 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j24so26874917wrd.0
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 07:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680446502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEt4l1scuvVJz61CdEo1J/wJGcCf7qx7gZaNe6q49Tk=;
        b=AM6IaoRgryD3mDHhYKjzWlGbOI4PjjiEREetuHxrbI8nRCASKBbID1ipXfMppUGefn
         SbRKbLaAy9LbJ3V3mYVh1d7MfKEOcTMaYCQgoi2kIqrA8WieblRhcgfY1lBJy2l7AUzC
         EplF4yW5IeKj4Msbo4Qhegh3MyPtngcY4GgSehJsaeWXcZlkh0ImoFsC1vlwoaBqzZMx
         4vAu5vD81iViSQ0u+6NM9bNpQVITK0e1iinU0lKKuoX3lh/VtVQ8biplLPpVXwfrl8cH
         H+K6jZscXL1FWh8GR95ZawTqsOkOrQbpoOAEwWn6qEyY+R1pr8ctvfOnNibyvJMAgT7h
         KTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680446502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEt4l1scuvVJz61CdEo1J/wJGcCf7qx7gZaNe6q49Tk=;
        b=1jidpdw4ISFPWVyXxVMOjcdmUR1f3bImn/MfFbvpIDcy71dfyB2kq1FqBVNvY10PM/
         y1+WsK080OTasCZG84ndQrh/2hIzIMlmbmGW308b5xlPyeD08xs1psYYWVRm0cPMpM0u
         gbJN7PCNYroso+8gYn5ysbuJjNMjuzFsWzAM+7tkEowvj9nVtizWhYdyZ/q3ckDwqnpi
         D/rG4KNOdVyXZfqMT/lrjlJpNYv29ipzJI9jiOjNE4VWCRM8RHLP3tsEZ12UerhxGoaZ
         igwdPcWrXUDh6yBhkN6dzURroJV4HtdWj4iot3uXtmADgTWpb+y5zCVhcOKFRh+BD6hQ
         RpRA==
X-Gm-Message-State: AAQBX9c0S8Pa+OqpiB3jLfqxuwP9KyOUSQtjY1tviZahW4D4bspKt2IE
        YH2iVNTkVEwkWFZ05kPNKC8=
X-Google-Smtp-Source: AKy350Yn72Cp3g4kqSIGRXETjmEUB7dsTtjqD1MDsR7d5+bikqDEJ859bvNTN8XhIC4ugyFr+biBQQ==
X-Received: by 2002:a5d:58e7:0:b0:2ce:aed6:3f2e with SMTP id f7-20020a5d58e7000000b002ceaed63f2emr23235081wrd.46.1680446502253;
        Sun, 02 Apr 2023 07:41:42 -0700 (PDT)
Received: from jernej-laptop.localnet ([209.198.137.155])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d4d06000000b002e6d4ac31a3sm5053895wrt.72.2023.04.02.07.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 07:41:41 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com, kernel@pengutronix.de
Subject: Re: [PATCH net-next 10/11] net: stmmac: dwmac-sun8i: Convert to platform
 remove callback returning void
Date:   Sun, 02 Apr 2023 16:41:40 +0200
Message-ID: <5660915.DvuYhMxLoT@jernej-laptop>
In-Reply-To: <20230402143025.2524443-11-u.kleine-koenig@pengutronix.de>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-11-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne nedelja, 02. april 2023 ob 16:30:24 CEST je Uwe Kleine-K=F6nig napisal(=
a):
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

=46or sunxi:
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej


