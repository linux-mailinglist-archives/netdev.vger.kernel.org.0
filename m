Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA231A4C2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhBLSu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhBLSuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:50:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFA164E9A;
        Fri, 12 Feb 2021 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613155814;
        bh=ca8NmUoXUMn3p9qX2HDf8b5wDt/sG8WeAWOl8PNCSNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K4VklQHDUj8mWEb4wGE+IuW8XY3tfX4XirqHLdhm8NL4rRGvgVWiVNrEvoxd6asMG
         acVSKvNhW3JF1eqQ5NwuH3d0FjbRoA9Jy0OSLAoJCv0fSfOHkjRzrm29M5qVl2vPtU
         Wwznm6jAIELdvqqJlKO+oYn/+SZ6+FLVHvzxuDFfOwRxA3SUS0T6Er7pqO45IgwblN
         03l+2BdTTavhsowiNsAod+LFVICJE53KYG2i8h1lZDGdWFMS3WixWKhAjcqtiLzfzF
         mQ9qo4LiufgHRs4PO1EgIdrAd6LjE/87ihsC5G+Ive0cmdYr8YCkpDV17IasBPBSHL
         DQmXm/TC6oHXA==
Date:   Fri, 12 Feb 2021 10:50:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Cc:     elder@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        davem@davemloft.net, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] net: ipa: Add support for IPA on MSM8998
Message-ID: <20210212105012.2f425230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210211175015.200772-6-angelogioacchino.delregno@somainline.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
        <20210211175015.200772-6-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 18:50:13 +0100 AngeloGioacchino Del Regno wrote:
> MSM8998 features IPA v3.1 (GSI v1.0): add the required configuration
> data for it.
>=20
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@soma=
inline.org>

This one does not build:

drivers/net/ipa/ipa_data-msm8998.c:382:3: error: =E2=80=98struct ipa_clock_=
data=E2=80=99 has no member named =E2=80=98interconnect=E2=80=99; did you m=
ean =E2=80=98interconnect_data=E2=80=99?
  382 |  .interconnect =3D {
      |   ^~~~~~~~~~~~
      |   interconnect_data
drivers/net/ipa/ipa_data-msm8998.c:382:2: warning: braces around scalar ini=
tializer
  382 |  .interconnect =3D {
      |  ^
drivers/net/ipa/ipa_data-msm8998.c:382:2: note: (near initialization for =
=E2=80=98ipa_clock_data.interconnect_count=E2=80=99)
drivers/net/ipa/ipa_data-msm8998.c:383:4: error: =E2=80=98IPA_INTERCONNECT_=
MEMORY=E2=80=99 undeclared here (not in a function)
  383 |   [IPA_INTERCONNECT_MEMORY] =3D {
      |    ^~~~~~~~~~~~~~~~~~~~~~~


Each commit must build cleanly and not add any transient W=3D1 C=3D1
warnings.
