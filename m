Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2359B59074C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 22:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbiHKUVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 16:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiHKUVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 16:21:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4639D753A4;
        Thu, 11 Aug 2022 13:21:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb36so35355590ejc.10;
        Thu, 11 Aug 2022 13:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2iEcy+RgZiOD/1fkSOT4cXVP1R14wGMgGLfQW0hnJac=;
        b=NLQbE4ehol47zdMYLS9lgGX3R8VmarLHibGrY4bqrACBfqHrYkAPY+Oh0u2ksSCuHQ
         UhgtEeC6F/pA58PhjkQTPHKlss0B2IN4eNS6yenJ/rbRZrYYWB4PJa27RzgWJSx2uPrt
         dnv40OjTFDTT3Lf/JeiSB/r2EcO/WiLk4Zvd1ZkrrKHDBFY+cA4xYo9DfwZuGMEXjGqQ
         oHIUaNtSmshudEAGD52MTcbmdCCey5PKlwSWYBuO9odEfpGXHzTGvNUS9pAOGDBM+zVa
         HR9eBS5mw8nwVsIl81qQaMF5Kjmx8TR6nmoL67rko45Nl0kY2bvwpzBpbgFSrD6T9qLJ
         Xngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2iEcy+RgZiOD/1fkSOT4cXVP1R14wGMgGLfQW0hnJac=;
        b=7sVQNXTv6A7RypuPLxBwAeCako18CSIITLgFQVTG1jtZN8eDtmyDKEKulhUByKxIPi
         +b/sdMnOKWXjMw8XzQlvohqmkQaaHTjmY4rXmcdCJEB3kK49wG6hVcE/FwodBUSvrco4
         sCvLhPkWDrKw5JKH6Cw9aF4a3BKTk2ZJNYeBuIrO71NeMNrWayhNO0iFtjZTi+p9RwRm
         StTmRQzD5XbPZ5PAE7FKMUs56rjXcqYJ+nW1tQGe+C1mmPVWM6xGqePO1dqF1sOzvrf/
         j32rBecJiu7WsG+QO+VMIHIrvXscbFnNAZwYcSJCKI3gEZKOvmCqpS2OBs/wuv/XgXsJ
         1JNQ==
X-Gm-Message-State: ACgBeo2GA+d87beNXy0bu4dKQMDK2zl2TTR1CGdOiq6bpDEudIKJFshy
        7cd+WaA9eO4iNKyHaFx1OU90HzFgWsfejQ4NeDk=
X-Google-Smtp-Source: AA6agR68RJZpGJtMUDX5fXOKniTkKN6MH28UQJ0Gmp7auThiQywPbs0HnPnL7U33duN8QrNeS6/VwiJ46Nw40uxozfE=
X-Received: by 2002:a17:907:28ca:b0:730:aabe:2e28 with SMTP id
 en10-20020a17090728ca00b00730aabe2e28mr522193ejc.72.1660249263804; Thu, 11
 Aug 2022 13:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <YvVQEDs75pxSgxjM@debian> <20220811124637.4cdb84f1@kernel.org>
In-Reply-To: <20220811124637.4cdb84f1@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 11 Aug 2022 13:20:52 -0700
Message-ID: <CABBYNZKxM5Z2CUah1EB2uUDs=gEgDbrK0B9gbxeoyvtL6g=4+w@mail.gmail.com>
Subject: Re: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-next@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
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

Hi Jakub,

On Thu, Aug 11, 2022 at 12:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 19:53:04 +0100 Sudip Mukherjee (Codethink) wrote:
> > Not sure if it has been reported, builds of csky and mips allmodconfig
> > failed to build next-20220811 with gcc-12.
>
> I can't repro with the cross compiler from kernel.org.
> Can you test something like this?
>
> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> index e72f3b247b5e..82bf8e01f7af 100644
> --- a/include/net/bluetooth/bluetooth.h
> +++ b/include/net/bluetooth/bluetooth.h
> @@ -341,6 +341,11 @@ static inline bool bdaddr_type_is_le(u8 type)
>  #define BDADDR_ANY  (&(bdaddr_t) {{0, 0, 0, 0, 0, 0}})
>  #define BDADDR_NONE (&(bdaddr_t) {{0xff, 0xff, 0xff, 0xff, 0xff, 0xff}})
>
> +static inline int ba_is_any(const bdaddr_t *ba)
> +{
> +       return memchr_inv(ba, sizeof(*ba), 0);
> +}

So we can't use something like BDADDR_ANY to compare? Anyway afaik
these were already present before the patch so I do wonder what had
trigger it show now or perhaps it was being suppressed before and
since we change it now start showing again?

>  /* Copy, swap, convert BD Address */
>  static inline int bacmp(const bdaddr_t *ba1, const bdaddr_t *ba2)
>  {
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 77c0aac14539..a08ec272be4a 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -2001,8 +2001,8 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
>                         }
>
>                         /* Closest match */
> -                       src_any = !bacmp(&c->src, BDADDR_ANY);
> -                       dst_any = !bacmp(&c->dst, BDADDR_ANY);
> +                       src_any = !ba_is_any(&c->src);
> +                       dst_any = !ba_is_any(&c->dst);
>                         if ((src_match && dst_any) || (src_any && dst_match) ||
>                             (src_any && dst_any))
>                                 c1 = c;



-- 
Luiz Augusto von Dentz
