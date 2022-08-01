Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9665F5871B1
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiHATsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiHATsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:48:53 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA531DF4
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:48:50 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-31f661b3f89so119869957b3.11
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 12:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=swnmUmkuaQCrDd7BqquDuLnBwSz1agI8pUsIz7DQa+E=;
        b=ZFoJsB3e0Bkn1z6G6cLaDbKtGQvGjRz+G3AC+x1wwTAw9d2Dx0girBIQMZCMWYZVcU
         w72T+Xe4naaBE6a2TVCIKbxUJLeF47x82mDk4GwTsiKViXRqsl03jWeZg5EZ/Am039YF
         Mdj7mZ8yhoTFnf2wjSByQJ25scQBoMRZ5MPY02xm3siv/4yDTrI2xHvYV3WENIfQRLLM
         NlJI/+lQyKW41OJ5jhwZPgHvD8h5m06T1yGE4vXWhPUS8k6WWiPihaeu0j5gom7B4IBx
         VwgEAl42PG3LkZQyfqPeUwTTYE4IKXnd5JLGaMUTwa0LL0q0XTIKng/gsp0s947DmJkM
         ejpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=swnmUmkuaQCrDd7BqquDuLnBwSz1agI8pUsIz7DQa+E=;
        b=1zRqmrB9vE8AtD+DfdIKb8/1Urdf4qHPFObSPty9rbw/kmlVUhUReDok2J9GrRV6O4
         UD4OxUl+7JdkDnlrSA4erxb2q21Ua6xm+XfnJ1nzVwbumM/zIBCp0b+vghH5h3tfrE2l
         4cMNrsmIkUh9dmcS3Aa/RinCKTZtjsCed+JfGpR/tMhzswi/mUydELYGaXCu4TYKv1LW
         poQ1eXyO/UOKgfvArtxOI6Rhyv5UhwHc62B57ODB9pd09W0LAn01gntgoh9ukPGkNHB9
         l3Ng3a23W0nt7XEfTsXBeEtTSSH0eT2U3DNH/CTDEAlmkfFdRMlYRT3kmD7Qv7x8Kn3i
         eGVQ==
X-Gm-Message-State: ACgBeo0FhvwkVep90XaS0J4hhIDEzV6RIpo0Wrw/m7O0mxpht6o91BIe
        6jH5wEejVcL1T/2FnEaVj6GWn+o8TjgRUFUnHaA=
X-Google-Smtp-Source: AA6agR7vggdntTiFmMNl7HFBPW8cK4jkxLmU9j8htB2ABJjfLu0hDFwVEMa5TNvBtvXGGWYjgN9UWVdFk0vZLW1jeOQ=
X-Received: by 2002:a0d:d001:0:b0:31c:75bc:25bd with SMTP id
 s1-20020a0dd001000000b0031c75bc25bdmr14573515ywd.505.1659383329772; Mon, 01
 Aug 2022 12:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf> <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
 <20220729000536.hetgdvufplearurq@skbuf> <CAFBinCBXNnpz0FUCs1PnxAoPk2nTKoj=r2wjSFx_rT=vV+JPtA@mail.gmail.com>
 <c5aee3cc-a97f-523d-2bed-63e1473dcee0@wp.pl>
In-Reply-To: <c5aee3cc-a97f-523d-2bed-63e1473dcee0@wp.pl>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 1 Aug 2022 21:48:38 +0200
Message-ID: <CAFBinCCz5--Sr4a0PmG5kXQfaV9bXAmgAp+t1OZROkHeNRbDcg@mail.gmail.com>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
To:     Aleksander Bajkowski <olek2@wp.pl>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com
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

Hi Aleksander,

On Sun, Jul 31, 2022 at 11:29 PM Aleksander Bajkowski <olek2@wp.pl> wrote:
[...]
> > The GSWIP140 datasheet (page 82) has a "MAC Learning disable and MAC
> > Learning Limitation Description" (table 26).
> > In the xRX200 vendor kernel I cannot find the LNDIS bit in
> > PCE_PCTRL_3, so I suspect it has only been added in newer GSWIP
> > revisions (xRX200 is at least one major IP revision behind GSW140).
> > Maybe Hauke knows?
>
>
> In the GPL sources [1] for the xRX330, the LNDIS bit is marked as added
> in revision 2.2 of the GSWIP IP core. The xRX200 uses revision 2.0 or 2.1.
oh, that's some really useful information - thanks a lot!


Best regards,
Martin
