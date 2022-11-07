Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C761F9A5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiKGQ2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKGQ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5D025C40;
        Mon,  7 Nov 2022 08:25:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3A4611B8;
        Mon,  7 Nov 2022 16:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA9C433D6;
        Mon,  7 Nov 2022 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667838324;
        bh=Yt3AxXZOdVhI/DEePqTeqIYQautqOR/ncxIz0D777Dk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mx92VzePzXibww4J+q2sTiCIOCBCv/BxW56Mvrf5ilDxcGl8KY+JdgV3dtB/Rg9kU
         2Av9B43f9hphEE4UYUAXAipIzMWD2f1a3Eq8uak2E0Xq4U+S3dhwVUvbFQiurbFUVq
         E9N/51PzU6/g09nKIu7ACMjMZNBQ0rYvztAL5e60JaVsZodJdNGcUrAVwEb/FIFBed
         VJQPEU2K+nZv2T/fLLhcLYnZN7vfngYtCv0QdG9fyCYukmVKpz7DnDCqZ472Xt9uSf
         Bh6bZayNenUgtzPkIRbARDGaQFJgsFDXND6AoNsSInu/Cmh+CDF7sCvDda0fP0whFK
         iVYL+RXENjK2g==
Date:   Mon, 7 Nov 2022 08:25:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20221107082522.2e95bebc@kernel.org>
In-Reply-To: <20221107093950.74de3fa1@pc-8.home>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
        <20221104174151.439008-4-maxime.chevallier@bootlin.com>
        <20221104200530.3bbe18c6@kernel.org>
        <20221107093950.74de3fa1@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 09:39:50 +0100 Maxime Chevallier wrote:
> > Also the series doesn't build. =20
>=20
> Can you elaborate more ? I can't reproduce the build failure on my
> side, and I didn't get any reports from the kbuild bot, are you using a
> specific config file ?

../net/core/skbuff.c:4495:49: error: invalid application of =E2=80=98sizeof=
=E2=80=99 to incomplete type =E2=80=98struct dsa_oob_tag_info=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                                                 ^~~~~~
../include/uapi/linux/const.h:32:44: note: in definition of macro =E2=80=98=
__ALIGN_KERNEL_MASK=E2=80=99
   32 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
      |                                            ^
../include/linux/align.h:8:33: note: in expansion of macro =E2=80=98__ALIGN=
_KERNEL=E2=80=99
    8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
      |                                 ^~~~~~~~~~~~~~
../net/core/skbuff.c:4476:34: note: in expansion of macro =E2=80=98ALIGN=E2=
=80=99
 4476 | #define SKB_EXT_CHUNKSIZEOF(x)  (ALIGN((sizeof(x)), SKB_EXT_ALIGN_V=
ALUE) / SKB_EXT_ALIGN_VALUE)
      |                                  ^~~~~
../net/core/skbuff.c:4495:29: note: in expansion of macro =E2=80=98SKB_EXT_=
CHUNKSIZEOF=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                             ^~~~~~~~~~~~~~~~~~~
../net/core/skbuff.c:4495:49: error: invalid application of =E2=80=98sizeof=
=E2=80=99 to incomplete type =E2=80=98struct dsa_oob_tag_info=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                                                 ^~~~~~
../include/uapi/linux/const.h:32:50: note: in definition of macro =E2=80=98=
__ALIGN_KERNEL_MASK=E2=80=99
   32 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
      |                                                  ^~~~
../include/linux/align.h:8:33: note: in expansion of macro =E2=80=98__ALIGN=
_KERNEL=E2=80=99
    8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
      |                                 ^~~~~~~~~~~~~~
../net/core/skbuff.c:4476:34: note: in expansion of macro =E2=80=98ALIGN=E2=
=80=99
 4476 | #define SKB_EXT_CHUNKSIZEOF(x)  (ALIGN((sizeof(x)), SKB_EXT_ALIGN_V=
ALUE) / SKB_EXT_ALIGN_VALUE)
      |                                  ^~~~~
../net/core/skbuff.c:4495:29: note: in expansion of macro =E2=80=98SKB_EXT_=
CHUNKSIZEOF=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                             ^~~~~~~~~~~~~~~~~~~
../net/core/skbuff.c:4495:49: error: invalid application of =E2=80=98sizeof=
=E2=80=99 to incomplete type =E2=80=98struct dsa_oob_tag_info=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                                                 ^~~~~~
../include/uapi/linux/const.h:32:61: note: in definition of macro =E2=80=98=
__ALIGN_KERNEL_MASK=E2=80=99
   32 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
      |                                                             ^~~~
../include/linux/align.h:8:33: note: in expansion of macro =E2=80=98__ALIGN=
_KERNEL=E2=80=99
    8 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
      |                                 ^~~~~~~~~~~~~~
../net/core/skbuff.c:4476:34: note: in expansion of macro =E2=80=98ALIGN=E2=
=80=99
 4476 | #define SKB_EXT_CHUNKSIZEOF(x)  (ALIGN((sizeof(x)), SKB_EXT_ALIGN_V=
ALUE) / SKB_EXT_ALIGN_VALUE)
      |                                  ^~~~~
../net/core/skbuff.c:4495:29: note: in expansion of macro =E2=80=98SKB_EXT_=
CHUNKSIZEOF=E2=80=99
 4495 |         [SKB_EXT_DSA_OOB] =3D SKB_EXT_CHUNKSIZEOF(struct dsa_oob_ta=
g_info),
      |                             ^~~~~~~~~~~~~~~~~~~


Also this:

drivers/net/ethernet/qualcomm/ipqess/ipqess.c:1172:22: warning: cast to sma=
ller integer type 'u32' (aka 'unsigned int') from 'void *' [-Wvoid-pointer-=
to-int-cast]
        netdev->base_addr =3D (u32)ess->hw_addr;
                            ^~~~~~~~~~~~~~~~~
