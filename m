Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDACA371B
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfH3Mti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfH3Mti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:49:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B562869EE1;
        Fri, 30 Aug 2019 12:49:37 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C8C76092D;
        Fri, 30 Aug 2019 12:49:29 +0000 (UTC)
Date:   Fri, 30 Aug 2019 14:49:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/6] mdev: Update sysfs documentation
Message-ID: <20190830144927.7961193e.cohuck@redhat.com>
In-Reply-To: <20190829111904.16042-6-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-6-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 30 Aug 2019 12:49:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 06:19:03 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Updated documentation for optional read only sysfs attribute.

I'd probably merge this into the patch introducing the attribute.

> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..0ab03d3f5629 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each mdev Device
>           |--- remove
>           |--- mdev_type {link to its type}
>           |--- vendor-specific-attributes [optional]
> +         |--- alias [optional]

"optional" implies "not always present" to me, not "might return a read
error if not available". Don't know if there's a better way to tag
this? Or make it really optional? :)

>  
>  * remove (write only)
>  
> @@ -281,6 +282,10 @@ Example::
>  
>  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
>  
> +* alias (read only)
> +Whenever a parent requested to generate an alias, each mdev is assigned a unique
> +alias by the mdev core. This file shows the alias of the mdev device.

It's not really the parent, but the vendor driver requesting this,
right? Also, "each mdev" is a bit ambiguous, as this is only true for
the subset of mdevs created via that driver. Lastly, if we stick with
the "returns an error if not implemented" approach, that should also be
mentioned here.

> +
>  Mediated device Hot plug
>  ------------------------
>  

