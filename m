Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E74622EA6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiKIPEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 10:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiKIPEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 10:04:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8071BC8B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 07:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668006228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zqiSLvJxdke/yqrf6iYu6+yVJoRzkJ0McEbSIHch4qc=;
        b=Y2li8mvM8SpG9SmHv5qZtUcOKjSsD0oPPPBcZ93JY/K6szB/8R5pl5dAjslI+nfQ6BI6+q
        /IIIeCKlLFkTeqNtT/En2cGawd9YElIO1LhNvsW1ghSIiWLDtFkOe3WIbw6GcC0uDbHtHD
        ST+aLWVW4NLbUCjzlGfDRccA1S8OJXU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-M9XV-9WON7CtozL5TdDx7Q-1; Wed, 09 Nov 2022 10:03:46 -0500
X-MC-Unique: M9XV-9WON7CtozL5TdDx7Q-1
Received: by mail-qv1-f72.google.com with SMTP id d8-20020a0cfe88000000b004bb65193fdcso11840177qvs.12
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 07:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqiSLvJxdke/yqrf6iYu6+yVJoRzkJ0McEbSIHch4qc=;
        b=tA9BpFkvCqFsWXzrTK2rXC+IzjExrGKRL8srYcxO0ZcQ8xLhswASLuolvdGsWfeROL
         kRgcs8DSiY5VZ+YIyYlwzLI2jay14xmtVYpGMpUW/nQmDQ+7zwpnLh1dUmepMDXZRWh6
         JE4QcDLWpwOdaPqMtJlmHm07J/FKEPDBIEcIf0yMCgTzhWn2vFx4V6KQgssuwxe74EQY
         OvAs4vSDGxym8HPiFPqvp6C65nVQCltY1elS50TDOcmPZEGtpDavQjecSbgmgEkJRk5e
         3g2kbTN6nywwtVhqtI3HXdEcT8hHnBtvTZU8DAzKPeo4umLbzPL5hVIn0uHBnTdzLM3c
         cdXw==
X-Gm-Message-State: ACrzQf0ly1sM5453RxSp1uIQWoZcSrfpCX3X3uK4L9ONUNNJs4z+Z1g3
        8mLhrcQoUpynGFmTXR4CgZar93kFmZVzbDVp9XLxhi5p99erS+glB8E9x2T3e+QM4q/++w61vgq
        /56JFfobbE5QqV4bz
X-Received: by 2002:a05:620a:1476:b0:6fa:4c67:83ec with SMTP id j22-20020a05620a147600b006fa4c6783ecmr31728047qkl.23.1668006225835;
        Wed, 09 Nov 2022 07:03:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5W/7Ofyy9aq2b4znPe4up0GqSbcYRBkArYCCUVmHJGVm6seQcJp68VlQkJ57qQhD7SVx9FuQ==
X-Received: by 2002:a05:620a:1476:b0:6fa:4c67:83ec with SMTP id j22-20020a05620a147600b006fa4c6783ecmr31728001qkl.23.1668006225495;
        Wed, 09 Nov 2022 07:03:45 -0800 (PST)
Received: from localhost ([66.187.232.66])
        by smtp.gmail.com with ESMTPSA id az8-20020a05620a170800b006bb87c4833asm11102303qkb.109.2022.11.09.07.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:03:44 -0800 (PST)
Date:   Wed, 9 Nov 2022 16:03:40 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, kvalo@kernel.org
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Message-ID: <Y2vBTBUw47sshA+E@localhost.localdomain>
References: <cover.1667687249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gRH5EQBfd9X8l7db"
Content-Disposition: inline
In-Reply-To: <cover.1667687249.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gRH5EQBfd9X8l7db
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Similar to TX counterpart available on MT7622 and MT7986, introduce
> RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
> offload traffic received by wlan nic to the wired interfaces (lan/wan).

Hi all,

I noticed today the series state is 'Awaiting Upstream'. I am wondering if
this series is expected to go through a different tree, e.g. wireless one
(adding Kalle in cc). In this particular case the series changes only
the mtk ethernet driver and mt76 is built since we modify a common include =
(but
there are no changes in mt76). My personal opinion is this series is suited=
 to
go through net-next tree but I would be fine even if it goes through Kalle's
one. Any opinions?

Regards,
Lorenzo

>=20
> Changes since v3:
> - remove reset property in ethsys dts node
> - rely on readx_poll_timeout in wo mcu code
> - fix typos
> - move wo-ccif binding in soc folder
> - use reserved-memory for wo-dlm
> - improve wo-ccif binding
>=20
> Changes since v2:
> - rely on of_reserved_mem APIs in mcu code
> - add some dts fixes
> - rename {tx,rx}_wdma in {rx,tx}_wdma
> - update entry in maintainers file
>=20
> Changes since v1:
> - fix sparse warnings
> - rely on memory-region property in mt7622-wed.yaml
> - some more binding fixes
>=20
> Lorenzo Bianconi (7):
>   arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet
>     Dispatch
>   dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
>   net: ethernet: mtk_wed: introduce wed wo support
>   net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
>   net: ethernet: mtk_wed: add configure wed wo support
>   net: ethernet: mtk_wed: add rx mib counters
>   MAINTAINERS: update MEDIATEK ETHERNET entry
>=20
> Sujuan Chen (1):
>   net: ethernet: mtk_wed: introduce wed mcu support
>=20
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     |  52 ++
>  .../soc/mediatek/mediatek,mt7986-wo-ccif.yaml |  51 ++
>  MAINTAINERS                                   |   1 +
>  arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  65 ++
>  drivers/net/ethernet/mediatek/Makefile        |   2 +-
>  drivers/net/ethernet/mediatek/mtk_wed.c       | 619 ++++++++++++++++--
>  drivers/net/ethernet/mediatek/mtk_wed.h       |  21 +
>  .../net/ethernet/mediatek/mtk_wed_debugfs.c   |  87 +++
>  drivers/net/ethernet/mediatek/mtk_wed_mcu.c   | 387 +++++++++++
>  drivers/net/ethernet/mediatek/mtk_wed_regs.h  | 129 +++-
>  drivers/net/ethernet/mediatek/mtk_wed_wo.c    | 508 ++++++++++++++
>  drivers/net/ethernet/mediatek/mtk_wed_wo.h    | 282 ++++++++
>  include/linux/soc/mediatek/mtk_wed.h          | 106 ++-
>  13 files changed, 2256 insertions(+), 54 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediat=
ek,mt7986-wo-ccif.yaml
>  create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
>  create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.c
>  create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h
>=20
> --=20
> 2.38.1
>=20

--gRH5EQBfd9X8l7db
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY2vBSQAKCRA6cBh0uS2t
rPcgAP9PAG0essRbeHBLaiZaGlJXLeM6J4qukctGB9+r/1Ix1QEA8bLkD/GDnBc4
J4EU5i4C57QJ7m+WDzf/nKWJReThFg0=
=jPqc
-----END PGP SIGNATURE-----

--gRH5EQBfd9X8l7db--

