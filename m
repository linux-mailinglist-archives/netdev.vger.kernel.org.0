Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55B86489CB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLIVBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 16:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLIVBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 16:01:41 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A054AF4D8;
        Fri,  9 Dec 2022 13:01:40 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3bf4ade3364so67992327b3.3;
        Fri, 09 Dec 2022 13:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ww4C2VTWkj7IF5qdJ8e0SkSDNmvW1h7I6Mx/ZRJOkY4=;
        b=CcLzblNC/vCuqWcNu/T1zxvY984E8N59flQNaw/n/g5x0n+aYgl0xNESOn4S1/DJ5b
         ux3Joq5cdU6PAjxl/nie1m2IMlVZX4FwjTL6QfClbAoMp8IqS3DYME+zMzcoNEK8fjvG
         MHAte/riloJ2DuSr3WMalHN57EEBAOHWwgZ6NlMZwqMrfsIM0SYpE+bEgAyGd2XFoq4e
         bxrACRV+A/LRsVDnH2qa2fT7V7AmQL09D60kgizbLyEd/3tPw4f3Ax28KtZeYyuWp+Yn
         UK2t4IXo+HvPZJJxHVzwwMGJ7/h06NK26/xHZDBuRReG+PY4gXgMfSUvfSJcVx8lEGc/
         YWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ww4C2VTWkj7IF5qdJ8e0SkSDNmvW1h7I6Mx/ZRJOkY4=;
        b=NhQQekJ1DIwKkcmYDEBVV2PKsr+U9rWN1vv1/CXiQDPzaI7AB0StGFYkUuhJxVsDkY
         xeVUaDFygKtVF57CBZDtu9mkgtg95kcGSphAsqtLBhcLgjsJrFEWyAq+snerDCp/4Quk
         rmAIsLdKq9GPHfOZOWf+bqZ+b6lSYDD2JgH2IZC8pNveNHYEi1lnwNTBMOK5IDipCfCG
         OGjA88DHor8oRIrRzd267vCrK2BBVrSCdnWPHW8l/KU90wCNz+BLigOWqbli3SH2xhoG
         G7dwxmhqqLKvUlA1xxpIhldvuFlB5DADTuOKURxEkilo4fQ9JBGl7v/mvC6c2XnpLt81
         IuwQ==
X-Gm-Message-State: ANoB5pnYHWENNINRmMyg0+nNG9hoqlTmZVo2t9BtYCkFegnkuqM0L1RR
        bzkK+2MQzUSN7dXzphZYAtt3C48MrKBgQFcDSwjCNJQkUpwnHOFl
X-Google-Smtp-Source: AA0mqf4VbI0wwWPkzyLDKowh06WVfO4OvtoC/p1+6arSDvL9Fj+S/Ya2VtpIx8Ak5p+6JXXdHErmno80LSp9vpyPTmo=
X-Received: by 2002:a81:8807:0:b0:370:4456:5cb5 with SMTP id
 y7-20020a818807000000b0037044565cb5mr6181857ywf.284.1670619699326; Fri, 09
 Dec 2022 13:01:39 -0800 (PST)
MIME-Version: 1.0
References: <Y5B3sAcS6qKSt+lS@kili> <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
 <20221209143024.ad4cckonv4c3yhxd@skbuf>
In-Reply-To: <20221209143024.ad4cckonv4c3yhxd@skbuf>
From:   Uladzislau Koshchanka <koshchanka@gmail.com>
Date:   Sat, 10 Dec 2022 00:01:28 +0300
Message-ID: <CAHktU2A2MQ4hW0WYcLDXuCuMsN84OmfrnrhTiOKqvHB_oFaVwg@mail.gmail.com>
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> The problem I see with bitrev8 is that the byte_rev_table[] can
> seemingly be built as a module (the BITREVERSE Kconfig knob is tristate,
> and btw your patch doesn't make PACKING select BITREVERSE). But PACKING
> is bool. IIRC, I got comments during review that it's not worth making
> packing a module, but I may remember wrong.

Do you really think it's a problem? I personally would just select
BITREVERSE with/without making PACKING tristate. BITREVERSE is already
selected by CRC32 which defaults to y, so just adding a select isn't a
change in the default. Can't think of a practical point in avoiding
linking against 256 bytes here.

In any case, it just doesn't look right to have multiple bit-reverse
implementations only because of Kconfig relations.
