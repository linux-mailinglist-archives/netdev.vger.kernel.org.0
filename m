Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D642355B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhJFBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237056AbhJFBNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F7360FE3;
        Wed,  6 Oct 2021 01:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633482709;
        bh=HPD4WkhCesL/KcxKyc2keg+CxLmso3IcO32eweXSHqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oPvy0Kh3Qk2g+jfqlQmplss3EZUetsEwK1QuIHJj1CU2eDUAGJRN2EfTf3cyESnEe
         cxP9dUoY29Sg47OwzxgWaEPkqul/XMwEMmccR5VwnTbnUBJHgLp20donzpO520dPOp
         JjqoB91POgXnehUqezzidjXb0ZH3suDsKzVU+Uf7us39DgVggF22ydM1z2J/TWPkJl
         L9Ra8OxbSl8cpFTYOnUTb0BU1W2pTGRIQkO35wpBPKx77QjLsiU/doX17LAef7sX/y
         Y1G8ZbGSrKaxRTmpLH5HV9nImjH0EtAtz2G/aiEb9Dpmdm55pucZLNPWGerIMX1o2Y
         rPKojfasDQq1w==
Date:   Tue, 5 Oct 2021 18:11:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>
Subject: Re: [net-next PATCH 1/3] octeontx2-pf: Simplify the receive buffer
 size calculation
Message-ID: <20211005181147.3481f702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1633454136-14679-2-git-send-email-sbhatta@marvell.com>
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
        <1633454136-14679-2-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 22:45:34 +0530 Subbaraya Sundeep wrote:
> This patch separates the logic of configuring hardware
> maximum transmit frame size and receive frame size.
> This simplifies the logic to calculate receive buffer
> size and using cqe descriptor of different size.
> Also additional size of skb_shared_info structure is
> allocated for each receive buffer pointer given to
> hardware which is not necessary. Hence change the
> size calculation to remove the size of
> skb_shared_info. Add a check for array out of
> bounds while adding fragments to the network stack.

drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c:91:54: error: =E2=80=98s=
truct otx2_nic=E2=80=99 has no member named =E2=80=98max_frs=E2=80=99
   91 |  aq->sq.smq_rr_weight =3D mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
      |                                                      ^~
