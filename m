Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A746466D82F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbjAQI3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbjAQI26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:28:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902361F4B1
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673944091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+6BYudluJLerY8xv5pVK4MG77+MbXReDqsF/tlVARI=;
        b=PGcf67eGB92ldcLVBTuPiIMsJYcSD/NMJ4PbIn+GEpD5MLu5KPirDCMv0vSlOdQbGWjF3r
        o2P1IMIuKZ9lLVK8WlerztDKN7d/TiwVtYYXqsickzSU/g4gbCQjMWQFC6l0yculZuP250
        PDoBKprl5iHR4pWI8OOjyXEJKffFrDo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-yfs0OFlRMNOjkugCn6L8Vg-1; Tue, 17 Jan 2023 03:28:03 -0500
X-MC-Unique: yfs0OFlRMNOjkugCn6L8Vg-1
Received: by mail-qk1-f197.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so22317075qkn.0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m+6BYudluJLerY8xv5pVK4MG77+MbXReDqsF/tlVARI=;
        b=24Z4rhJthX6DYnxoEhxvkvLwnlwfauBtur+Tt6UlzWbDFa4KXfdgnJRp0YP3eMHCws
         tEs9gjIyVVfvqyY8Nb+ol2EGD7vfQkXh/qrqAARI2OMpxLzpF7S36Xfx3swZEP+76CXz
         +2BYl6GzHocFtwizS4DPxsqyGoHLB7uO+WvVAMNYTK+Bc7PvdlCnsbgRufkvk2Mr5HNu
         QTiBc7uYErNq/C88SmuDmL7nIo0L+q82VGSGjm3ECDgebn2jyDy16YjYNtWQzDMbKr73
         m9qrivFoiwO7soUP6kPVF39SbM+z2Nh4KPdWPE4E1QeEx0SnJXMKvzjHl8/6UG6psVKK
         Ghqg==
X-Gm-Message-State: AFqh2kphjdznaqWUhXlNtK2YzdA0FuD0vi6Lgcrv9Pdsn7PckU4pGfbU
        k7TAWfIvQsDhvWT18gn/I1XcyH9mHJdyKRQHItROXvW0KJWS+00oYJ5AXnut3lNH5qyoxBSMJg/
        K19290BMownOMV/R7
X-Received: by 2002:ac8:718f:0:b0:3b6:35a2:bb04 with SMTP id w15-20020ac8718f000000b003b635a2bb04mr2857501qto.7.1673944082569;
        Tue, 17 Jan 2023 00:28:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu/E4Cr9udbp9axgo1/YZ5h66bfn9nqv1hysCj476Ft8Z+EGz88GliVUvugE+ln2/ljJlMqIA==
X-Received: by 2002:ac8:718f:0:b0:3b6:35a2:bb04 with SMTP id w15-20020ac8718f000000b003b635a2bb04mr2857480qto.7.1673944082284;
        Tue, 17 Jan 2023 00:28:02 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id bj30-20020a05620a191e00b006bb82221013sm19709741qkb.0.2023.01.17.00.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 00:28:01 -0800 (PST)
Message-ID: <6ee1798af93cc5b8c46611ecca941ee57481358e.camel@redhat.com>
Subject: Re: [PATCH V2 0/7] Add eqos and fec support for imx93
From:   Paolo Abeni <pabeni@redhat.com>
To:     Clark Wang <xiaoning.wang@nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Date:   Tue, 17 Jan 2023 09:27:56 +0100
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2023-01-13 at 11:33 +0800, Clark Wang wrote:
> This patchset add imx93 support for dwmac-imx glue driver.
> There are some changes of GPR implement.
> And add fec and eqos nodes for imx93 dts.
>=20
> Clark Wang (7):
>   net: stmmac: add imx93 platform support
>   dt-bindings: add mx93 description
>   dt-bindings: net: fec: add mx93 description
>   arm64: dts: imx93: add eqos support
>   arm64: dts: imx93: add FEC support
>   arm64: dts: imx93-11x11-evk: enable eqos
>   arm64: dts: imx93-11x11-evk: enable fec function
>=20
>  .../devicetree/bindings/net/fsl,fec.yaml      |  1 +
>  .../bindings/net/nxp,dwmac-imx.yaml           |  4 +-
>  .../boot/dts/freescale/imx93-11x11-evk.dts    | 78 +++++++++++++++++++
>  arch/arm64/boot/dts/freescale/imx93.dtsi      | 48 ++++++++++++
>  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 55 +++++++++++--
>  5 files changed, 180 insertions(+), 6 deletions(-)

It's not clear to me if the whole series should go via netdev. I
think/fear such option could cause later conflicts for Linus. Does it
make sense to split this in 2 chunks, and have only the first 3 patches
merged via netdev?

Thanks!

Paolo

