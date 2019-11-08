Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CAFF4570
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHLKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:10:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27506 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730614AbfKHLKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 06:10:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573211439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3nYT87qwUirFN/Bs+GrE3cX/9b5VoxR9UXPdSVM6IKE=;
        b=e8hfq0MN5zF2EllYDX5y8Lxw6aO5e0YQ5uHPQjNwGkuTwjjcQzo6YdLETK7mHaHIvUx1Ys
        5iXfFVoG9feL5a/KZIFA6e/7fhRYf5Zj3ko1J1i0OawUEvpYNP3E4s9X+zx/5nQun1cs74
        66cCBvYS1Qg2pdEeCLLrMDOg+UjF1tE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-eir2viv0OcmvHDnBioCDyQ-1; Fri, 08 Nov 2019 06:10:37 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CED11800D7B;
        Fri,  8 Nov 2019 11:10:35 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEF625DA7F;
        Fri,  8 Nov 2019 11:10:32 +0000 (UTC)
Date:   Fri, 8 Nov 2019 12:10:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev
 alias
Message-ID: <20191108121030.5466dd3e.cohuck@redhat.com>
In-Reply-To: <20191107160834.21087-7-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-7-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: eir2viv0OcmvHDnBioCDyQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 10:08:22 -0600
Parav Pandit <parav@mellanox.com> wrote:

> Some vendor drivers want an identifier for an mdev device that is
> shorter than the UUID, due to length restrictions in the consumers of
> that identifier.
>=20
> Add a callback that allows a vendor driver to request an alias of a
> specified length to be generated for an mdev device. If generated,
> that alias is checked for collisions.
>=20
> It is an optional attribute.
> mdev alias is generated using sha1 from the mdev name.
>=20
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 123 ++++++++++++++++++++++++++++++-
>  drivers/vfio/mdev/mdev_private.h |   5 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
>  include/linux/mdev.h             |   4 +
>  4 files changed, 135 insertions(+), 10 deletions(-)

Is this (or any of the other mdev alias patches) different from what I
reviewed in the past?

