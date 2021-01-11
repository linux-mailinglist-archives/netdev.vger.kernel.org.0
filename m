Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83BC2F22B2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbhAKWZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbhAKWZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 17:25:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3F222D03;
        Mon, 11 Jan 2021 22:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610403866;
        bh=BsWKe4iJRvrnIvqhsWumSjczollUV73NMAGhYxNPl1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6P38OdZlvGOJQLWRFoDPt1I1wTIEC/iZzsZXjcndgvSZ2hCGcVgHs/n9G+DAh/WQ
         lgoK50lz6XfOFykdsgbVz+rEUncEOFlxSLiSbBftyoALIzkECz9uoEUAhCOfxjlb7H
         nM4YI3DRYh3ttD60i+smmZnPhhQIL61TDSk/75XsUVPVSHQ1XdK6PBDogONRKjtqlq
         NixCGvxJcFJVCcilNMucIG5GwNznj5ssz4LAqFnZIvGRv4raF5DN4I/+K+hHcd+jJV
         aHsyckJMYlnpiBpjq24/jBdnk744cbpbsxDnFsgYPk3JllgLqWHpxG7PogN0uumcvZ
         qX/03WtOC54Xg==
Date:   Mon, 11 Jan 2021 14:24:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH 5/6] ethernet: stmmac: fix wrongly set buffer2 valid
 when sph unsupport
Message-ID: <20210111142425.1cec69ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111113538.12077-6-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
        <20210111113538.12077-6-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:35:37 +0800 Joakim Zhang wrote:
> In current driver, buffer2 available only when hardware supports split
> header. Wrongly set buffer2 valid in stmmac_rx_refill when refill buffer
> address. You can see that desc3 is 0x81000000 after initialization, but
> turn out to be 0x83000000 after refill.
> 
> Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Please make sure there are no new sparse warnings (build flags: W=1 C=1):

drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:509:25: warning: invalid assignment: |=
drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:509:25:    left side has type restricted __le32
drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:509:25:    right side has type unsigned long
drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:511:25: warning: invalid assignment: &=
drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:511:25:    left side has type restricted __le32
drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c:511:25:    right side has type unsigned long
