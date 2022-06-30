Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBAB561D92
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiF3OPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbiF3OO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:14:27 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0AB53D07
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 07:00:00 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-317710edb9dso180401147b3.0
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T+ea1w8QRkUddSdVnFCFkg9e+PUNpgdO8wtU8eLtl2c=;
        b=bm5xbqUhoFqxsUzsolFkWpWmVa3yxNJ/oI3RgKxw7J5R71k2WEYGS5kZDr4PS9cLjF
         C0IBLt/IfQbIkso14ODe2bFQUuv2rNwuxnmVHLRDNSpZXgymttSCff/Nv6v9xzjKonuL
         6Mhbgbv0tvyETNZ77A2JWvba5VrGuTfm1R/S2qZYRlkZaQdn4t7mth0oLsxxwgfwJGgM
         31XSsdLp5Ss46yxewm2/qz9p0alUjrfCW0q5V9mwEx1ppoECg7dU5BTZDunWpVe6yRWl
         AkhZhqwTF4UQy5fn3C57peUR+X4T3zJdreQJ58VfoRQhd8TStPruf2KnU1zBJ2n1ZoTl
         8BTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T+ea1w8QRkUddSdVnFCFkg9e+PUNpgdO8wtU8eLtl2c=;
        b=LR6NJ1z9rDAaX8x8zzU2OM2EAG2NnrzaVMrrjb+35uDiDyW78m7yD/YtfAAF4G4Eda
         6RtOCDMz6YJ7/xox+M3VWS7e4jhmkIkrjuPJ2oCKcw3PV17Z8IVpDaWNtsoxIO4RACxq
         GFT1fRoMKyUDTtAZ1jp42yuT/b6yCrBc5gFMXABYNBz5fqTUDbuxM3H9irGlNhQVUacu
         lr/oUzMOW2jiCsQ0JWOZnl6qhkRFZq0Ipe+rVDqmEagqmvVLV4kWA7fM7tRWHVhu6AjV
         WiixiiUoAzaNxxbjrB7nf3x7nnH/M9p2BR1SLgJlXwiYvvVes5iXV1i32rP+ghd4F+KW
         grRQ==
X-Gm-Message-State: AJIora9WliSDKMlSouxw978qvUE40ni17BfyyJcJ0Jt4QGpeqmbToC/x
        GmDiYp0KJWMlpP21p+xmv6y4DXKKmjaqA1RYeQOcVQ==
X-Google-Smtp-Source: AGRyM1thKLDhXRDe9ieaVjZQXmKEPL9hxWESyEef3JZPDrCUIjmNqZlOreFKFwaQodOti/6xuSbB01HkQRmpW1HnlZc=
X-Received: by 2002:a81:5c9:0:b0:317:b1a5:bf8b with SMTP id
 192-20020a8105c9000000b00317b1a5bf8bmr10445328ywf.489.1656597599582; Thu, 30
 Jun 2022 06:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
 <CANn89iLpW4zFf2ABADbMNERPFr=OrAXEMm6ZgCxYA5VpcDpYTw@mail.gmail.com> <8b012bbd-a175-5699-1f26-108dd52fc5b7@linux.alibaba.com>
In-Reply-To: <8b012bbd-a175-5699-1f26-108dd52fc5b7@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jun 2022 15:59:48 +0200
Message-ID: <CANn89iJ-2BTR1SfFBbNG3jSgHK-TuRE_J-Khbbednu=pWnFtmw@mail.gmail.com>
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
To:     maqiao <mqaio@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, gustavoars@kernel.org,
        cai.huoqing@linux.dev, Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        zhaochen6@huawei.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 3:57 PM maqiao <mqaio@linux.alibaba.com> wrote:
>
>
>
> =E5=9C=A8 2022/6/30 =E4=B8=8B=E5=8D=886:23, Eric Dumazet =E5=86=99=E9=81=
=93:

> > Note: The following is racy, because multiple threads can call
> > hinic_get_stats64() at the same time.
> > It needs a loop, see include/linux/u64_stats_sync.h for detail.
> Thanks for reminding, and I noticed that nic_tx_stats/nic_rx_stats has
> been protected by u64_stats_sync in update_t/rx_stats(), it seems that
> it's unnecessary to use spinlock in update_nic_stats().

It is necessary to use the spinlock to protect writers among themselves.


>
> I will send v2 as soon as possible, thanks.
