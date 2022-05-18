Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9326552BF4B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbiERPjM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 May 2022 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiERPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:39:10 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B9C9BAEE;
        Wed, 18 May 2022 08:39:08 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id eq14so1787916qvb.4;
        Wed, 18 May 2022 08:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3x933ygnjXaKQtWyRvufRAEop/BHqYeq9sDh5XL4g5E=;
        b=V9klkk0U6Sw1NhPbNbpAmsiXhUfJSIKrBDMllDPYIW0YNEl2tRUGOkUARyHLYEbnka
         m8+Mo4cS1wrOv6BH0j+uxqKCH0FaYcNIodiMlYF51+LUbuGqK4zoUuSxfONINgTOd/jO
         5obcHPc/GTkXKYZp9/EKss6RzuI5KnWSz2bUO5M7qYnrjwGH8pBl+J4t6DinL0kw5a4Y
         gLllFJYFcG0cRjGsdV8VR7JkxFMNr1Jo0eQATIYBGbmKbsHbjUA3Bc3+PO9+KtCOYElT
         uGnC/YziplO8uXgF379lO5LssmR1eqZXFZ+yMO+A3v7Ju+61C/A6lt5vDDXole+37ZKm
         A1VQ==
X-Gm-Message-State: AOAM532qEyY23yvuoBtRDhFwt2+wWfB3jDOlXtCDtV2DrO4avimkbx0z
        e80qYFERl/JuMGBrySlPCwdyH3Bpw4sqTw==
X-Google-Smtp-Source: ABdhPJw+2IDKkM4sXXUBpnnh73GXpP/pz4u1fF2SzQOKI4JcGYeBDH0nM0xjTTvvQI8TP48ADmXbmg==
X-Received: by 2002:a05:6214:3e1:b0:461:f0b1:6b12 with SMTP id cf1-20020a05621403e100b00461f0b16b12mr326200qvb.122.1652888347444;
        Wed, 18 May 2022 08:39:07 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id h25-20020ac87459000000b002f39b99f6c4sm1383095qtr.94.2022.05.18.08.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 08:39:06 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id o80so4371522ybg.1;
        Wed, 18 May 2022 08:39:06 -0700 (PDT)
X-Received: by 2002:a05:6902:905:b0:64a:2089:f487 with SMTP id
 bu5-20020a056902090500b0064a2089f487mr251266ybb.202.1652888346221; Wed, 18
 May 2022 08:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220516115627.66363-1-guozhengkui@vivo.com> <CAMuHMdWH1rdP22VnhR_h601tm+DDo7+sGdXR-6NQx0B-jGoZ1A@mail.gmail.com>
 <20220518083344.0886bd6f@kernel.org>
In-Reply-To: <20220518083344.0886bd6f@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 May 2022 17:38:54 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU+3DcpgHbytt47MNcGtfVOe+CVXcptM7=WUTWCcHq8vA@mail.gmail.com>
Message-ID: <CAMuHMdU+3DcpgHbytt47MNcGtfVOe+CVXcptM7=WUTWCcHq8vA@mail.gmail.com>
Subject: Re: [PATCH linux-next] net: smc911x: replace ternary operator with min()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guo Zhengkui <guozhengkui@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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

Hi Jakub,

On Wed, May 18, 2022 at 5:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 18 May 2022 11:07:08 +0200 Geert Uytterhoeven wrote:
> > On Mon, May 16, 2022 at 10:36 PM Guo Zhengkui <guozhengkui@vivo.com> wrote:
> > > Fix the following coccicheck warning:
> > >
> > > drivers/net/ethernet/smsc/smc911x.c:483:20-22: WARNING opportunity for min()
> > >
> > > Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> >
> > Thanks for your patch, which is now commit 5ff0348b7f755aac ("net:
> > smc911x: replace ternary operator with min()") in net-next/master.
> >
> > > --- a/drivers/net/ethernet/smsc/smc911x.c
> > > +++ b/drivers/net/ethernet/smsc/smc911x.c
> > > @@ -480,7 +480,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
> > >         SMC_SET_TX_FIFO(lp, cmdB);
> > >
> > >         DBG(SMC_DEBUG_PKTS, dev, "Transmitted packet\n");
> > > -       PRINT_PKT(buf, len <= 64 ? len : 64);
> > > +       PRINT_PKT(buf, min(len, 64));
> >
> > Unfortunately you forgot to test-compile this with
> > ENABLE_SMC_DEBUG_PKTS=1, which triggers:
> >
> >         drivers/net/ethernet/smsc/smc911x.c: In function
> > ‘smc911x_hardware_send_pkt’:
> >         include/linux/minmax.h:20:28: error: comparison of distinct
> > pointer types lacks a cast [-Werror]
> >            20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> >               |                            ^~
> >         drivers/net/ethernet/smsc/smc911x.c:483:17: note: in expansion
> > of macro ‘min’
> >           483 |  PRINT_PKT(buf, min(len, 64));
> >
> > "len" is "unsigned int", while "64" is "(signed) int".
>
> Ah, damn. I did double check that the build test actually compiles
> smc911x.o 'cause this patch looked suspicious. Didn't realize that
> more than allmodconfig is needed to trigger this :/
>
> How do you enable ENABLE_SMC_DEBUG_PKTS? You edit the source?

Yes you do.

To avoid missing stuff like this in the future, my fix also includes
a change to the dummy PRINT_PKT(), so you don't have to enable
ENABLE_SMC_DEBUG_PKTS anymore to trigger the issue.

> > I have sent a fix
> > https://lore.kernel.org/r/ca032d4122fc70d3a56a524e5944a8eff9a329e8.1652864652.git.geert+renesas@glider.be/
>
> Thanks a lot!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
