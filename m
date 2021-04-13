Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3B35D811
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 08:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhDMGaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 02:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhDMGaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 02:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD1D6103D;
        Tue, 13 Apr 2021 06:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618295384;
        bh=sPxJl1FBKHo9wvJk+aIWpc4405aN7VFdL2pRj5QVE14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rN6whHDsadLaWVJvPMV6+udmq/X6jqoxmR/vzyfXcnG6zNO343BmMJIP3EZZgq5Rl
         sHXKP5N6ca24t6FCVkuMMoj2aNdTHuTf5y+AMz41V07Zti2B2YVeUGPFErW5HEuaNI
         AOn3s+QaH/t2dOsTLT1v1UKY0/Sbr779NJh83V1nY+6C27d6EyXwdw94P6QuyB+R2O
         jWPCnolyzrUsf1ykYtoY6bK2Fw+vpuWijUU4oZqahT7iIQfMkRY3VLp2vaV/2ir0fM
         Vv1wKjKnJBsq5jK+Mwvvnfc7Sga7x56wGPyyEGrgvNWLKnd0/cXfdjXnCVOHT7/bgR
         HO0r+RSbod0Ww==
Date:   Tue, 13 Apr 2021 09:29:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <YHU6VXP6kZABXIYA@unreal>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <20210412225847.GA1189461@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412225847.GA1189461@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 07:58:47PM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 31, 2021 at 08:43:12PM +0200, Håkon Bugge wrote:
> > ib_modify_qp() is an expensive operation on some HCAs running
> > virtualized. This series removes two ib_modify_qp() calls from RDS.
> > 
> > I am sending this as a v3, even though it is the first sent to
> > net. This because the IB Core commit has reach v3.
> > 
> > Håkon Bugge (2):
> >   IB/cma: Introduce rdma_set_min_rnr_timer()
> >   rds: ib: Remove two ib_modify_qp() calls
> 
> Applied to rdma for-next, thanks

Jason,

It should be 
+	WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT);

and not
+	if (WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT))
+		return -EINVAL;

Thanks

> 
> Jason
