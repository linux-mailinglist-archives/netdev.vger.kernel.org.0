Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7052B630
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiERJHZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 May 2022 05:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiERJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:07:22 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC30E15C0;
        Wed, 18 May 2022 02:07:21 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id 126so1000349qkm.4;
        Wed, 18 May 2022 02:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OPdrAjKOyQOcWm67dROL4azSD7nDXBVBpZGGGZKL78E=;
        b=hc8oIs7ZyO4XjHkBTDGVbQzPHanenkTdGJUfqI4BTIaRvM327ffexnDSBbMTHNuMFz
         X5QW31F2xiS9aNNH+JERnjqVzs08OxIjWoYIqQyHiS3VuPVlWSqYXcPYKT0izg+lCANM
         7JAuD7tSP8HSqhWIN8e0La6lOwaZgIW55vfzbbTEGokLmxTsFY4ItXhrNDBy4uQK3IrL
         VE/TuOSvParetHD6r/yTq2khJUEZ2SR8PQB1aTfdShTCfiJSmw++F8u0UNEMW7C41aac
         PdM+mCzBScII+jEYCvNSr4DHSFIXBJaywJcFxYVoqkH2O6OwNp5wKOC8dGbY94ubaatE
         WI/A==
X-Gm-Message-State: AOAM532QRjgPrgJjMei5Jkc2pyLd6ZgWFPzKLRBLYON2vPwW4S2K19Nv
        egu/kQDC9XTIiDzIjvZm1gZ7qGY1gKb9OQ==
X-Google-Smtp-Source: ABdhPJwOxaIdhXrkfIK0RJfFWGAOJ/OzQlp4CncqNBYYOjYKJqVCx6BuNuNCFIMH7fGI/cpTPASMdw==
X-Received: by 2002:a37:6549:0:b0:69f:a625:fe2b with SMTP id z70-20020a376549000000b0069fa625fe2bmr19052577qkb.132.1652864840806;
        Wed, 18 May 2022 02:07:20 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id d21-20020ac800d5000000b002f39b99f697sm864460qtg.49.2022.05.18.02.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 02:07:20 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2f83983782fso17146067b3.6;
        Wed, 18 May 2022 02:07:20 -0700 (PDT)
X-Received: by 2002:a81:2143:0:b0:2fb:1274:247e with SMTP id
 h64-20020a812143000000b002fb1274247emr29579131ywh.384.1652864840147; Wed, 18
 May 2022 02:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220516115627.66363-1-guozhengkui@vivo.com>
In-Reply-To: <20220516115627.66363-1-guozhengkui@vivo.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 May 2022 11:07:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWH1rdP22VnhR_h601tm+DDo7+sGdXR-6NQx0B-jGoZ1A@mail.gmail.com>
Message-ID: <CAMuHMdWH1rdP22VnhR_h601tm+DDo7+sGdXR-6NQx0B-jGoZ1A@mail.gmail.com>
Subject: Re: [PATCH linux-next] net: smc911x: replace ternary operator with min()
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Ian King <colin.king@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        zhengkui_guo@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guo,

On Mon, May 16, 2022 at 10:36 PM Guo Zhengkui <guozhengkui@vivo.com> wrote:
> Fix the following coccicheck warning:
>
> drivers/net/ethernet/smsc/smc911x.c:483:20-22: WARNING opportunity for min()
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>

Thanks for your patch, which is now commit 5ff0348b7f755aac ("net:
smc911x: replace ternary operator with min()") in net-next/master.

> --- a/drivers/net/ethernet/smsc/smc911x.c
> +++ b/drivers/net/ethernet/smsc/smc911x.c
> @@ -480,7 +480,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
>         SMC_SET_TX_FIFO(lp, cmdB);
>
>         DBG(SMC_DEBUG_PKTS, dev, "Transmitted packet\n");
> -       PRINT_PKT(buf, len <= 64 ? len : 64);
> +       PRINT_PKT(buf, min(len, 64));

Unfortunately you forgot to test-compile this with
ENABLE_SMC_DEBUG_PKTS=1, which triggers:

        drivers/net/ethernet/smsc/smc911x.c: In function
‘smc911x_hardware_send_pkt’:
        include/linux/minmax.h:20:28: error: comparison of distinct
pointer types lacks a cast [-Werror]
           20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
              |                            ^~
        drivers/net/ethernet/smsc/smc911x.c:483:17: note: in expansion
of macro ‘min’
          483 |  PRINT_PKT(buf, min(len, 64));

"len" is "unsigned int", while "64" is "(signed) int".

I have sent a fix
https://lore.kernel.org/r/ca032d4122fc70d3a56a524e5944a8eff9a329e8.1652864652.git.geert+renesas@glider.be/

>
>         /* Send pkt via PIO or DMA */
>  #ifdef SMC_USE_DMA

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
