Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925285670BB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiGEOPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiGEOP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:15:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D9B21A3;
        Tue,  5 Jul 2022 07:09:57 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z21so20689480lfb.12;
        Tue, 05 Jul 2022 07:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mkpYMkRu/76pOOu+MHLe2oZToj5Yt5Dx7rgEtnCdrPQ=;
        b=IKQoY/My2mvs2KygiBq4kvXiSv0KM+0Qeikhdsnx5XPID6cmubAFjIW0/HaD7POAY5
         SsmKNSvgWfWg6VjKuWxZuE+KQS8WhIoy/i6vIWMrshxduSxnHjtRKOr5UkQttb5McMea
         ki4r58st9mM8U7P/rRgKEw9QYn4mbhKQQ4DNcb8hL9HfvZEmVGjs+i8XWY1eE2jGOfOW
         iYofhYXGteHTKOOSQNUopEfeMGP/9VR9FFZdu47Z6nPqeMtuVt1aTtAAPSij6x+IPXlA
         ObmXDPU7XjGGtZQDYl501/GRpe00ttnaam5qB2wVso11bT+Pnp4Mw23E+f6j+1qWpXNj
         /juA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mkpYMkRu/76pOOu+MHLe2oZToj5Yt5Dx7rgEtnCdrPQ=;
        b=v58n3HVTQKtJbJsT0sBd/4cmBZ845aIbtkWWeuN7zrTCeVgEgNiiQDgMaCIaFRtlVI
         96QyxPY9ihYaYMXpyFuTx4dcGNC9ORe2D2LQQDsmFL87+GAMXj9zj0h/9et/LRdS0TZE
         8fdmXtUPl6IWbPvz2ksl/nK+WwEKZWHQAj6sP5n1kgnuORtgiKGaGyzrIWLQwmQhlHnc
         Ay4T+9lB/fK+ndNCr13+/f8JTP6+RYBHXMXy62pJG3Ppdm2y4QWzh6Kb4eNLU0aQTSl0
         dzrd+OOKh6qZsMIHuUogVyxIOMvBkWcPUvHS6D2/4+hXQahu8yo/7MhtZyngZZ1x6nBR
         W78w==
X-Gm-Message-State: AJIora/eq8FjRXGmH/Lhd+qriVPogirKZZXXWET5bM9rKJkc3hUNtzyv
        mFc4O6PpTz8HDnutesco4K5BT5ESNF/PfDx0pWw=
X-Google-Smtp-Source: AGRyM1tSIs7PI67WcqIU/JRHnYrMgswH/xmh7JqI+2SJSmBmNqBBi68lT4gRWIzylYRqVXC5Pn0RPBLpngzyVN3P5uw=
X-Received: by 2002:a05:6512:b14:b0:482:a9b1:ea3 with SMTP id
 w20-20020a0565120b1400b00482a9b10ea3mr9893588lfu.353.1657030195926; Tue, 05
 Jul 2022 07:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220614181706.26513-1-max.oss.09@gmail.com> <1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl>
In-Reply-To: <1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl>
From:   Max Krummenacher <max.oss.09@gmail.com>
Date:   Tue, 5 Jul 2022 16:09:44 +0200
Message-ID: <CAEHkU3VEg=LU6U-rB6HWGy59=jZJkUe_qW5faLi+Xx4Ka+i5qg@mail.gmail.com>
Subject: Re: [PATCH v1] Revert "Bluetooth: core: Fix missing power_on work
 cancel on HCI close"
To:     =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     Max Krummenacher <max.krummenacher@toradex.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 9:57 PM Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wro=
te:
>
> W dniu 14.06.2022 o 20:17, Max Krummenacher pisze:
> > From: Max Krummenacher <max.krummenacher@toradex.com>
> >
> > This reverts commit ff7f2926114d3a50f5ffe461a9bce8d761748da5.
> >
> > The commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work
> > cancel on HCI close") introduced between v5.18 and v5.19-rc1 makes
> > going to suspend freeze. v5.19-rc2 is equally affected.

The following follow up commit fixes the issue for me without the revert.
https://lore.kernel.org/all/20220705125931.3601-1-vasyl.vavrychuk@opensyner=
gy.com/

Thanks
Max
