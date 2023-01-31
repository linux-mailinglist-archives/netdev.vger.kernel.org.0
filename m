Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3293682F05
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjAaOSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjAaOSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:18:11 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE6C16AD6;
        Tue, 31 Jan 2023 06:18:07 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id cr11so8612657pfb.1;
        Tue, 31 Jan 2023 06:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/tLUdHiIHb80iO9Lp6bZpLrU9d/zmMciFOjvZujeYU=;
        b=M7BEAZl9XM9H/0i/cZkTiFAj6gsYn05hTXFFLpAf4k7OyA1bg+txR7mkki7YAcPPW3
         oLmFuZ8vC9EolA/0BQLZdhhC94OeHSQMECFcMpY/CykmgCZHc77HHG/seByXRbR904mF
         jIHlzSztlVJRjbrOCMVKJzX4AJvT9NjY5O6+s37lCDOrHfXhfj9qPmyONeuL/Ua502te
         2GsOE5fZuSDI2Qkf8AauNi7QR3TfbgPVEJz2wfsQLq3Pmn5UbX9JD9JRvBYHdcm8YAuA
         4aqMNWgRTmojcWqkyThZtuuVwpGeCV/iUhYjVd4jOOjLarkILE8jbk54NrTZXHAxqbTY
         HFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/tLUdHiIHb80iO9Lp6bZpLrU9d/zmMciFOjvZujeYU=;
        b=DoJNYxLpJSF4jBuqi7slDa6guIGIZhLivh3ZAkLREmngyEqgbj/XljK2ncRNSz1qoc
         p+NamXsUS7/2j3oNVqxVLJXcwXIH7PhaKS45dCA+Kh6JHvk7Y0eVDM6Ul6rcTzJVFmOs
         4/TFLvCIC8WQRkehDvqtOg9z0xG0eQOegySoOEfKcVYr/9xL8QEdGsfm68EllZ4vPMn4
         GegU4XfTB7D1iXZk7Lw+IE4lbtzP/81jW1B6uqrYWuimo1841tNHVEhtS+vO6p5ZKFpx
         L1VxNxERhKQbW5pTQaXcinSvxCEiebzpH92aHaBaGEZJUFM5LlB7uohhKIMcjT0kd04M
         xmeg==
X-Gm-Message-State: AFqh2krg0oDU+LJb40z7IpzbnYY+mcELFow4Gf9ce+gMw7CtMfD5nLi2
        cQ4u2/hKEhNbPOmsjkxyYckEeao5O3iPfL2rWcc=
X-Google-Smtp-Source: AMrXdXs9/A8sqP6U1AUBHsMTAuuw85NEz8wAEfIlns2ZHq3egt0ctehCpLkguo4QE4wz3Iwieal9NkYzu6ISoyDaFl0=
X-Received: by 2002:a62:1989:0:b0:58d:ae61:c14b with SMTP id
 131-20020a621989000000b0058dae61c14bmr6651888pfz.51.1675174686518; Tue, 31
 Jan 2023 06:18:06 -0800 (PST)
MIME-Version: 1.0
References: <20230131112840.14017-1-marcan@marcan.st> <20230131112840.14017-2-marcan@marcan.st>
In-Reply-To: <20230131112840.14017-2-marcan@marcan.st>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Tue, 31 Jan 2023 15:17:55 +0100
Message-ID: <CAOiHx=mYxFx0kr5s=4X_qywZBpPqCbrNjLnTXfigPOnqZSxjag@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] brcmfmac: Drop all the RAW device IDs
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>
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

On Tue, 31 Jan 2023 at 12:36, Hector Martin <marcan@marcan.st> wrote:
>
> These device IDs are only supposed to be visible internally, in devices
> without a proper OTP. They should never be seen in devices in the wild,
> so drop them to avoid confusion.

I think these can still show up in embedded platforms where the
OTP/SPROM is provided on-flash.

E.g. https://forum.archive.openwrt.org/viewtopic.php?id=3D55367&p=3D4
shows this bootlog on an BCM4709A0 router with two BCM43602 wifis:

[    3.237132] pci 0000:01:00.0: [14e4:aa52] type 00 class 0x028000
[    3.237174] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit=
]
[    3.237199] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit=
]
[    3.237302] pci 0000:01:00.0: supports D1 D2
...
[    3.782384] pci 0001:03:00.0: [14e4:aa52] type 00 class 0x028000
[    3.782440] pci 0001:03:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit=
]
[    3.782474] pci 0001:03:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit=
]
[    3.782649] pci 0001:03:00.0: supports D1 D2

0xaa52 =3D=3D 43602 (BRCM_PCIE_43602_RAW_DEVICE_ID)

Rafa=C5=82 can probably provide more info there.

Regards
Jonas
