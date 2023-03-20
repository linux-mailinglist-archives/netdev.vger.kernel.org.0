Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368DD6C1E31
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjCTRiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbjCTRhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:37:50 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D024A5E0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:33:49 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id s12so13977868qtq.11
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679333623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXSaEMxO//xDb01VhLRcgIDibiMarrc3dSvt5NdkJdk=;
        b=Kv5O7eIYUIDVR1s/OUCYMPA67AOmbDwCMPW0O4e90AdOPO0+oekkFaxAkBefI5cuEm
         3zyligDdaCZlwPmHNd3akg0tEbJpX7hHrAC7UaHrji+dxnB5u/OyPBJ2wwmSuD5+Cbt8
         M6441juL/ehm7FA/5Bz0D+LE4z6k6o631pVcb4E3UmUfo2ZifeHYCVnqQWOdjajDsoA8
         d/xkeOykvmiBpbU+ZUISmMAlwm6r97b63UqHZT+UkZLbKxcaC5QD8Cxe0fiWJ6vnDVVz
         RWxZFKPeAEk73TZe2P5CGyxQXISGwq2dsuwiUymMElviLHGzMokQBnB2mCLILaAI6oqO
         s0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679333623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXSaEMxO//xDb01VhLRcgIDibiMarrc3dSvt5NdkJdk=;
        b=WcM6zUD1FnGjaxKCGU60HUcR5p9pItROm1obx/dKteCfIXfS9lr4YiD4RmRXO1q6Ux
         edvkQq/EuhOxmNOjYlORWQWPEzmVpVwfTHGoklotC07RvMQjRx7yjtrchn/k9WrjAy1j
         iDCAbVGHTfUP0lk9L/s8EBxW2anoRCfBbPwnjxepdzudbFqBXuihyxB/I2kNlDqqMQ62
         wOjr2oi3QYWn34yCMnHRWd8eoqGchIcs1MuTUeiS6h2HWyKlqtrW73XMP54TE7zg8U+O
         N/w4S3XZ258WfQYwft8JW+caO/tnLyx9Se5IvnGvUDvhgajR8fmtvNMvPdCrPrbOCFFJ
         8nVg==
X-Gm-Message-State: AO0yUKUYPV2L6vqPX4tm6NVStR6ggdKL6JQZrS/rcl6R94BI68SxCTWb
        nR2NMQ+MFg/Vb8MJQFFew6a1nTJt+GGiSor/0Cs=
X-Google-Smtp-Source: AK7set8ybB+yy9E+1k2ql34NPcikwbSTX8j9oUU8GxCOtZAtNaYCnwvNLfHydJ7hbUAxnjgUe9NAOG/viPwP99Jg60E=
X-Received: by 2002:ac8:5612:0:b0:3bf:b844:ffc7 with SMTP id
 18-20020ac85612000000b003bfb844ffc7mr5062924qtr.12.1679333622758; Mon, 20 Mar
 2023 10:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
 <192db694-5bda-513c-31c5-96ec3b2425d9@gmail.com> <CAFXsbZo-pdP+b3iWyQwPe4FA4Pdxr-HO5-4rHB-ZLJApZyJ3DQ@mail.gmail.com>
 <bee01edc-b49a-427a-9ea2-cc194488a0f8@lunn.ch>
In-Reply-To: <bee01edc-b49a-427a-9ea2-cc194488a0f8@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 20 Mar 2023 10:33:31 -0700
Message-ID: <CAFXsbZrkVQOL2ERa3TMTpOLdLJdRfh2kANohtN=oOHcXXMHjZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: smsc: export functions for use by
 meson-gxl PHY driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 5:17=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Mar 19, 2023 at 05:39:51PM -0700, Chris Healy wrote:
> > On a dev board with SMSC LAN8720, this change was tested and confirmed
> > to still operate normally.
> >
> > Signed-off-by: Chris Healy <healych@amazon.com>
>
> Hi Chris
>
> That should be Tested-By:
>
>      Andrew

You are correct.  This was a mistake on my part.  I should have stated
"Tested-by" instead of SOB.
