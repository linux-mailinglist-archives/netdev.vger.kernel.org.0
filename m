Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30788396CA8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhFAFLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFAFK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55688610FC;
        Tue,  1 Jun 2021 05:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524159;
        bh=n711I0MWA9e0vcWex39A7jnlO48y3pis64NnpnLhV4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KCV6Jcv4k9/18aJv10zA7T7SRzai9TReVO2k1S0WrUmdNXfQdHfFLcEkKy1NvkE86
         7+5TVGoYiDkN+LpYbCV0jccGmnHbMUNzp4KJJiWoqpMSFhpTfIUp887QqVDDjt71l0
         NqcELpUb3FYPhROBJvqrL++Zi3kQEaVBrE60cmU8NtaxKY7qUqEf/k27HZfEq+3Cea
         Po4j2Bu1SFDfJG2YvQX+aqTll8AWBu0kexNFN2m/9ZMBpFJAvubSfT9vuymzVhmvj3
         hqMXVKn146v6wPfuZV6dggKiDBYVd+W0o+p9pAZlvffypYjfup1VqxVYKL4Phwe8dW
         3rYUbBd3IAWgw==
Date:   Mon, 31 May 2021 22:09:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V2 net-next 1/3] ethtool: extend coalesce setting uAPI
 with CQE mode
Message-ID: <20210531220917.3df91899@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <dbdfcac5-f772-1b73-7af8-af2340f21aea@huawei.com>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
        <1622258536-55776-2-git-send-email-tanhuazhong@huawei.com>
        <20210529142355.17fb609d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <dbdfcac5-f772-1b73-7af8-af2340f21aea@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 09:24:01 +0800 Huazhong Tan wrote:
> >> @@ -975,6 +977,8 @@ Request contents:
> >>     ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), h=
igh Tx
> >>     ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, =
high Tx
> >>     ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling=
 interval
> >> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE=
, Tx
> >> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE=
, Rx
> >>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >>  =20
> >>   Request is rejected if it attributes declared as unsupported by driv=
er (i.e. =20
> > Did you provide the theory of operation for CQE vs EQE mode somewhere,
> > as I requested? =20
>=20
>=20
> the definition of enum dim_cq_period_mode in include/linux/dim.h has
>=20
> below comment:
>=20
> /**
>  =C2=A0* enum dim_cq_period_mode - Modes for CQ period count
>  =C2=A0*
>  =C2=A0* @DIM_CQ_PERIOD_MODE_START_FROM_EQE: Start counting from EQE
>  =C2=A0* @DIM_CQ_PERIOD_MODE_START_FROM_CQE: Start counting from CQE (imp=
lies=20
> timer reset)
>  =C2=A0* @DIM_CQ_PERIOD_NUM_MODES: Number of modes
>  =C2=A0*/
>=20
>=20
> is this comment suitable? and add reference in=20
> Documentation/networking/ethtool-netlink.rst to
>=20
> the comment in dim.h.

DIM is kernel internals we need user facing, meaningful documentation.
I'm not 100% clea on what the exact difference is.

If the difference is whether timer is restarted on new packet arrival
or not - why mention CQE at all and not just call the configuration
knob "restart timer on new packet arrival"?
