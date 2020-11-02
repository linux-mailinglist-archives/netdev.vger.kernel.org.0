Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE22A324F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgKBRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgKBRxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:53:44 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670EB2222B;
        Mon,  2 Nov 2020 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604339623;
        bh=pdsobQXNdzfnVTTs+hipelJh7dplYfmBt2Sy9fdVVJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FcrsVLmmz3cHivIctq2dqfSfm3WeHKGi7koMkAkAodRG+oFLkb14lxIV2T40X1OBK
         2NHwB/2ETBHlJ/bQkhu2+lgdlsTpDS+kb5pPKsaAuIj2CaDI2+Z9ieA5poMmh4VZs5
         31sHEPH9Bvw3fppeKmQBFWHie9TiAwOqNh/N8blU=
Date:   Mon, 2 Nov 2020 09:53:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: Re: [PATCH net-next 03/13] octeontx2-af: Generate key field bit
 mask from KEX profile
Message-ID: <20201102095342.38c5d5c1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102061122.8915-4-naveenm@marvell.com>
References: <20201102061122.8915-1-naveenm@marvell.com>
        <20201102061122.8915-4-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 11:41:12 +0530 Naveen Mamindlapalli wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>=20
> Key Extraction(KEX) profile decides how the packet metadata such as
> layer information and selected packet data bytes at each layer are
> placed in MCAM search key. This patch reads the configured KEX profile
> parameters to find out the bit position and bit mask for each field.
> The information is used when programming the MCAM match data by SW
> to match a packet flow and take appropriate action on the flow. This
> patch also verifies the mandatory fields such as channel and DMAC
> are not overwritten by the KEX configuration of other fields.
>=20
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

Lots of new warnings like this here:

drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:351:38: warning: imp=
licit conversion from =E2=80=98enum header_fields=E2=80=99 to =E2=80=98enum=
 key_fields=E2=80=99 [-Wenum-conversion]
  351 |  if (npc_check_overlap(rvu, blkaddr, NPC_ETYPE, start_lid, intf))
      |                                      ^~~~~~~~~
