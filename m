Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BF231607C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhBJICX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233319AbhBJICU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 03:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9483F64E3B;
        Wed, 10 Feb 2021 08:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612944100;
        bh=9XKUNx1ycYxYGqnZEdu26NuayXq4cganuhdS3OcomCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrR6xcHD43vkNTEQmtEDs642ryqvhigsAMmG9YqxKZR+pCqKpgcBvS7wsqPYSyEVc
         uyr62j51S4bla9DTQPFteVrg6SWIAGODuFpGi5VUMvuOL+NgqUF2v3P9f8XOQPYezU
         Lu6Exn2ysdQ/hL+N3gzq14sX6R656EoRfW/d321I/QWbNz3dMKW+Uhi589TZArdQly
         w9Kn1aKz1+uzN2OwAVih+WzGevWmkq9NKcEeUG3sDV4XHD4Z4WynAfJOihGQWliq1L
         14TBDBlDt8g+706N83x6G5B7kujyTFeZRSdviV5cfzu5v9TgvmlnJ/piBCGDVM3cLJ
         8CywGHTvpAjWg==
Date:   Wed, 10 Feb 2021 10:01:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add new timestamp mode bits
Message-ID: <20210210080136.GF139298@unreal>
References: <20210209131107.698833-1-leon@kernel.org>
 <20210209131107.698833-2-leon@kernel.org>
 <20210209102825.6ede1bd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210209191424.GE139298@unreal>
 <20210209115254.283fbb71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209115254.283fbb71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:52:54AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Feb 2021 21:14:24 +0200 Leon Romanovsky wrote:
> > On Tue, Feb 09, 2021 at 10:28:25AM -0800, Jakub Kicinski wrote:
> > > On Tue,  9 Feb 2021 15:11:06 +0200 Leon Romanovsky wrote:
> > > You also need to CC Richard.
> >
> > We are not talking about PTP, but about specific to RDMA timestamp mechanism
> > which is added to the CQE (completion queue entry) per-user request when
> > he/she creates CQ (completion queue). User has an option to choose the format
> > of it for every QP/RQ/SQ.
>
> I see. Perhaps Richard won't be interested then but best to give him
> a chance.
>
> Not directly related to series at hand but how is the clock synchronized
> between system and device for the real time option?

When device works in real time mode, driver can skip cycles to ns translation
it does today in order to provide recv/sent SKB NS TS to the stack. Real time
mode does not require any changes above driver level and the synchronization
to system clock will remain as is today. The mlx5e soon to support this mode.

This series is needed to keep RDMA compatibility and fail QP creation for wrong mode.

Thanks
