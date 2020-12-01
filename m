Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031A72CAA8E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgLASMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:12:48 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15776 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgLASMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:12:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc687770000>; Tue, 01 Dec 2020 10:12:07 -0800
Received: from [10.26.72.142] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 18:11:59 +0000
Subject: Re: [PATCH net-next 4/6] net: ipa: add support to code for IPA v4.5
To:     Alex Elder <elder@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <evgreen@chromium.org>, <subashab@codeaurora.org>,
        <cpratapa@codeaurora.org>, <bjorn.andersson@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20201125204522.5884-1-elder@linaro.org>
 <20201125204522.5884-5-elder@linaro.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com>
Date:   Tue, 1 Dec 2020 18:11:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201125204522.5884-5-elder@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606846327; bh=/D27y9r+pShq7ay9aYZhLt2r9FM2Jf0ooHB+jAavkBM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=Pv2b7mFpB9VseLXJGAz/zIg5f00sqtHxchoQ86LxP3FddDa9FsQwi/Wfze+IEzAQ+
         KXkbjYRy57Gav896beABqu/EaH8OwamsJWLAUj87pC/PjQzRfBzVX7ytOKaYgAUAki
         wYApKu1tpMoXA1IH2s9r29A/B7vafueHxWK4TdUcY+osVdqsQYAUU6OAFSB54FWqOD
         IzIT04q+0Q2feW1bUE6sinMsn489L7R0gs6g0KIxVy6GYymzldno9ucqoZfBsJ1jpD
         etpCYQ6RHR1OPR+qnSokGQmdxX/r7nuAYJ6GdQR471bvcHTSyfF1WHht/AgXe7mjcl
         5LigkIA13UqQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/11/2020 20:45, Alex Elder wrote:
> Update the IPA code to make use of the updated IPA v4.5 register
> definitions.  Generally what this patch does is, if IPA v4.5
> hardware is in use:
>   - Ensure new registers or fields in IPA v4.5 are updated where
>     required
>   - Ensure registers or fields not supported in IPA v4.5 are not
>     examined when read, or are set to 0 when written
> It does this while preserving the existing functionality for IPA
> versions lower than v4.5.
>=20
> The values to program for QSB_MAX_READS and QSB_MAX_WRITES and the
> source and destination resource counts are updated to be correct for
> all versions through v4.5 as well.
>=20
> Note that IPA_RESOURCE_GROUP_SRC_MAX and IPA_RESOURCE_GROUP_DST_MAX
> already reflect that 5 is an acceptable number of resources (which
> IPA v4.5 implements).
>=20
> Signed-off-by: Alex Elder <elder@linaro.org>


This change is generating the following build error on ARM64 ...

In file included from drivers/net/ipa/ipa_main.c:9:0:
In function =E2=80=98u32_encode_bits=E2=80=99,
    inlined from =E2=80=98ipa_hardware_config_qsb.isra.7=E2=80=99 at driver=
s/net/ipa/ipa_main.c:286:6,
    inlined from =E2=80=98ipa_hardware_config=E2=80=99 at drivers/net/ipa/i=
pa_main.c:363:2,
    inlined from =E2=80=98ipa_config.isra.12=E2=80=99 at drivers/net/ipa/ip=
a_main.c:555:2,
    inlined from =E2=80=98ipa_probe=E2=80=99 at drivers/net/ipa/ipa_main.c:=
835:6:
./include/linux/bitfield.h:131:3: error: call to =E2=80=98__field_overflow=
=E2=80=99 declared with attribute error: value doesn't fit into mask
   __field_overflow();     \
   ^~~~~~~~~~~~~~~~~~
./include/linux/bitfield.h:151:2: note: in expansion of macro =E2=80=98____=
MAKE_OP=E2=80=99
  ____MAKE_OP(u##size,u##size,,)
  ^~~~~~~~~~~
./include/linux/bitfield.h:154:1: note: in expansion of macro =E2=80=98__MA=
KE_OP=E2=80=99
 __MAKE_OP(32)
 ^~~~~~~~~

Cheers
Jon

--=20
nvpublic
