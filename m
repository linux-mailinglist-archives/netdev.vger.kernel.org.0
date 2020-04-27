Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64781B95B7
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 06:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD0EOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 00:14:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57507 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbgD0EOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 00:14:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 6E1FD5C0091;
        Mon, 27 Apr 2020 00:14:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 00:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=snpCVV56mFmo9muUIO7ngHFvMfQ
        7y0CccI9e/ddkW0U=; b=q+b03J2UvN30BlUtUGidor66RUfVg3I7fjOkVJJL3VW
        39AhUvi+QNQkhDLUZqmJW4IvIqK7daijDogltdSo4T6Zr2xOXS5z4guhuzUMZtgy
        LcRqOFq8pv2uUkncIo0NonlyVOjlYKmy6hIWZnp9xuFn3pZS5rRvGynmTwB3Euy5
        NAKtdNdz1W6Bsg1Gusq297e6A2fggFIe2nt5zMgC3Hdq8CQZmSE8YxypvoM1p5nd
        bU/kln6UbW4Gx48pKj5czLphnw+FNIpwagcr3RPwrKOdlJQHfPLSujsay6Vb/sdl
        0+1lkOyOSiiSnenLuIO9fZ3fviHRIdZy8twcLwQZERg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=snpCVV
        56mFmo9muUIO7ngHFvMfQ7y0CccI9e/ddkW0U=; b=hpaEQTZiBPxM0Qo083dgn2
        Ts1zTLA7sARPE68PW6ttqv6ZnKudiSuVaKTzJB7oUtd5S0ua6WlZrvN/BqSt9YWa
        eKxRl99X1Sj1D3YYU8Jt8pbeNuQfi7Mie1U9scMW7vJBzxKy67W4Jx99MBRODCu3
        dvdO2EjjL8Y4qC+jmCU6bHuW9XFkjRGuQSnswcfHDG7va0Urk7DsdMv9Nt9zzjDi
        5e900CRzX7elpXpOf80zMcCTFHZDsojxWZelHgFJhgNPdlf/2jVBsUTihonywI44
        MEO5gOtw/DxrHkd4pDy/EmeTKv1YVs5Peja/6qX4Y5X5xzYERkK36m/DULuRZXcQ
        ==
X-ME-Sender: <xms:NFymXr_l9tmdV_Yq1GwPexpbbw4pMKWMLO59YJZyCtZKwqDxPO8r_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrd
    egledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:NFymXn6fxpL4blHwkmRbVBSp9J6s70LlgTh3e2PlPmjpnC-5cl3hhQ>
    <xmx:NFymXnUrdNsb-XMC1uJE-WrCmKEY5pV09nF9glSkQWoYKLk1wEhLQw>
    <xmx:NFymXlPuN3VPn65LG64uChuE-zACUkuvdAkuSwdeSdJ2xJySx31zig>
    <xmx:NFymXueMlwYWYS3-vEzZHAKmQKs0Ahpk-IZp6-78t35a2u_lAAQG8g>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id 077583065E46;
        Mon, 27 Apr 2020 00:14:44 -0400 (EDT)
Date:   Mon, 27 Apr 2020 00:14:44 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 2/3] staging: qlge: Remove print statement for vlgrp field
Message-ID: <51bae37a54d414491779e4a3329508cc864ab900.1587959245.git.mail@rylan.coffee>
References: <cover.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1587959245.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove statement that tries to print the non-existent 'vlgrp' field
in the 'ql_adapter' struct, which causes a compilation failure when
QL_DEV_DUMP is set.

vlgrp seems to have been removed from ql_adapter as a part of
commit 18c49b91777c ("qlge: do vlan cleanup") in 2011.

vlgrp might be replaced by the 'active_vlans' array introduced in the
aforementioned commit. But I'm not sure if printing all 64 values of
that array would help with debugging this driver, so I'm leaving it
out of the debug code in this patch.

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_dbg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index e0dcdc452e2e..bf157baace54 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1570,7 +1570,6 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 	int i;
 
 	DUMP_QDEV_FIELD(qdev, "%lx", flags);
-	DUMP_QDEV_FIELD(qdev, "%p", vlgrp);
 	DUMP_QDEV_FIELD(qdev, "%p", pdev);
 	DUMP_QDEV_FIELD(qdev, "%p", ndev);
 	DUMP_QDEV_FIELD(qdev, "%d", chip_rev_id);
-- 
2.26.2

