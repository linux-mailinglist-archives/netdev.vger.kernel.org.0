Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AED3EEDBD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbhHQNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233288AbhHQNv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8671760F35;
        Tue, 17 Aug 2021 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207545;
        bh=2BNje+PP31tmUpIGZqD0jAs9iIRc8+S0ks+rtVdopxc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R4HJPZX5snVbcwoIYEK0usstZOCCK2Ep5nJYVwb53BXFKPQ+2yLn/ANFidoHMO57r
         FlfsVm/Eyq06l5McqN5AW7GPmsp/uPfoHzviKpMv4FB1omO5guXYYbBXoAPSd/gjIm
         eXb6XfJ2NAVsEGnJeRXo53zILfUYimz0RyNeiV9o5MRjw4OWMrBd+FHSWkVlhgtp0z
         mOxGEi0VH5udAslzPiKeoMIgPD+csn25l8fPsuk/n54SW3a45cYkP69iUx7scTQ7G3
         AQG5sWYPLH4Ac5WDB7eM8mAGzcpVthql/haswrr8YSSla4y8xOQvKP2DLFrUOxNy/z
         ZA/yWga36uZeQ==
Date:   Tue, 17 Aug 2021 06:39:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
Message-ID: <20210817063903.6b62801c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
        <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 10:36:05 +0800 Yufeng Mo wrote:
> In order to support more coalesce parameters through netlink,
> add an new structure kernel_ethtool_coalesce, and keep
> struct ethtool_coalesce as the base(legacy) part, then the
> new parameter can be added into struct kernel_ethtool_coalesce.
>=20
> Also add new extack parameter for .set_coalesce and .get_coalesce
> then some extra info can return to user with the netlink API.
>=20
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

This and the following patches don't build, please make sure
allmodconfig builds correctly. Here's an example failure, but
IDK if there isn't more:

drivers/net/ethernet/ti/davinci_emac.c: In function =E2=80=98emac_dev_open=
=E2=80=99:
drivers/net/ethernet/ti/davinci_emac.c:1469:3: error: too few arguments to =
function =E2=80=98emac_set_coalesce=E2=80=99
 1469 |   emac_set_coalesce(ndev, &coal);
      |   ^~~~~~~~~~~~~~~~~
