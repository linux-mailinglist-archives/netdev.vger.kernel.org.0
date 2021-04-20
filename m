Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8AF3654DA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhDTJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhDTJJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 05:09:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765096101E;
        Tue, 20 Apr 2021 09:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618909750;
        bh=Zx+3BKAojnGAcSOH3f96YdKbuNqEzAUiJZBAF6GT+M8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMrkhbWwZYNe4U/Hn7zbhwwvUlowNTN6ivMFRsUkVS3sExz7m0JS6bv7GtGyUPQXx
         E/8opgt2FVBBBXsFcrMWqZBYodYulxt3Ld/EC2OA3BhEw1Y8iFS6/o9GSKIw/u+t6y
         Sjo5yVfJUv3okjLSUUwp/9Dtf8guE2vs1o7dIAdvzGkrIjaFjHd6j/KwV+/BCWVz4T
         pNxKOiz5TwvcOgF/Oj8xTJTugJg8oFKms91OoMQIJC2xnSmjn3C5Gmp+LQcakDZ3im
         9MXXv/QsYa22Nkq9lvpxp2359JU3uLuN23a07aRAy9v44rdAbSPFXRD0lLoMxipYTy
         naHrldgJlNBlg==
Date:   Tue, 20 Apr 2021 12:09:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YH6aMsbqruMZiWFe@unreal>
References: <20210407000913.2207831-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210407000913.2207831-1-pakki001@umn.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:09:12PM -0500, Aditya Pakki wrote:
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/rds/message.c | 1 +
>  net/rds/send.c    | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Dave, Jakub

Please revert this patch, given responses from Eric and Al together
with this response from Greg here https://lore.kernel.org/lkml/YH5/i7OvsjSm=
qADv@kroah.com

BTW, I looked on the rds code too and agree with Eric, this patch
is a total garbage.

Thanks
