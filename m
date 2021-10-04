Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60C4213A1
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 18:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhJDQIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 12:08:36 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:34819 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235064AbhJDQIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 12:08:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id DCB33580A24;
        Mon,  4 Oct 2021 12:06:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 Oct 2021 12:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=UUDC4YPuEtCCTitozLyUXSQK64PbAa0gIhVIGJmIS
        k8=; b=gM59//UsggGrtqThRY9sJqyp8D+9kxjC+UvC7jenhj+AROpr2V0dfX/fq
        h6ehvCOLyj1zbY13J0RFv4HpMy6SMAEX5K/uwt2bcfpRtPSpV3rFp+/j5p5rgavJ
        NUyyosal30d0QXln5Q8fjxIIkwHXSAzv8sdGRmRetfikyw/8NylOSLiIaeHcXLZs
        YnaQzu/hGWx1xjutunU4A8MqMaIbIvUXaFJWF+sjfSBezb9G0uo907QDhO7iF4aw
        7fC70puO9Bw3YWecSEMZGNFm8zpFdi6oYbLiFHdf0ITrk8yAsZ2S/bYEurSItMlo
        SOkfWQhrsVpq5DpSXCXcRtiveKNYA==
X-ME-Sender: <xms:kiZbYZK76wrajKm36pl4y5bzwireSQ2PWq2QzmRyqpJBHcInWhTmoQ>
    <xme:kiZbYVIlcj87gCVjNNPK5QPTqd8t1YcvnICIJfanlnR6x2MMVbKa5jV0o1rEMslHs
    2KNk7EnlWn1VY0>
X-ME-Received: <xmr:kiZbYRvoGQyS69DlOaXpRPdTlLNyTDyV8yIB-2TQIn8Qxic2MNEvxz1D6gmBj2QJR9O2mzQBZIJXGdgSNGBPLYHwahPH7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kiZbYaaBVxWoLW4HGq7VH3nQiN1XEhlUkUC98apwzk7l6Fx4FErx0w>
    <xmx:kiZbYQYcCWruVgLFP-TF0YGUHpZOeSxmY5m5m6oa68X5U2Ddai6Mag>
    <xmx:kiZbYeDufN_iwdYLwtcWcpJme_iAsTm2JZudp2486KUXMZDUiY1Kzw>
    <xmx:lSZbYbv6xGNDhED2lZiFwGSYztonTM5evW1J9XCSbgxJbNzywj8tBQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 12:06:41 -0400 (EDT)
Date:   Mon, 4 Oct 2021 19:06:38 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v6 07/11] PCI: Replace pci_dev::driver usage that gets
 the driver name
Message-ID: <YVsmjpUYk8P1X6Fr@shredder>
References: <20211004125935.2300113-1-u.kleine-koenig@pengutronix.de>
 <20211004125935.2300113-8-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211004125935.2300113-8-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 02:59:31PM +0200, Uwe Kleine-König wrote:
> struct pci_dev::driver holds (apart from a constant offset) the same
> data as struct pci_dev::dev->driver. With the goal to remove struct
> pci_dev::driver to get rid of data duplication replace getting the
> driver name by dev_driver_string() which implicitly makes use of struct
> pci_dev::dev->driver.
> 
> Acked-by: Simon Horman <simon.horman@corigine.com> (for NFP)
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

For mlxsw:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Tested with the kexec flow that I mentioned last time. Works fine now.

Thanks
