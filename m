Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5B198A01
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgCaCgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:36:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46423 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727614AbgCaCgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585622171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nhe1R9fcd9sn8sBUTkjUECHmGPeTRwWPtrkYv9HeUA4=;
        b=cptWrn+cGBELuAIkrgUXdDX/JkSnhvMTYzJQQOgWfXxEQDDTn6D0Gcdni1KDcGZnhe1gPQ
        am9UnVqxE9i9Oj+x8mb108AyaSrJIKlDgHwyZ/x3PPZpYQmEUgq1dr9D7ywft8/fQu1SGj
        W0s0UzsHcuGhquRm7UIEQTFpOicNahM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-htrLS0PsNj2cJicau63YfA-1; Mon, 30 Mar 2020 22:36:09 -0400
X-MC-Unique: htrLS0PsNj2cJicau63YfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E29BA800D5B;
        Tue, 31 Mar 2020 02:36:07 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F3F5C1C5;
        Tue, 31 Mar 2020 02:35:58 +0000 (UTC)
Subject: Re: [PATCH] vhost: vdpa: remove unnecessary null check
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200330235040.GA9997@embeddedor>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <32ae2f4c-de7c-050b-85a2-489b6813fd5f@redhat.com>
Date:   Tue, 31 Mar 2020 10:35:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200330235040.GA9997@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/31 =E4=B8=8A=E5=8D=887:50, Gustavo A. R. Silva wrote:
> container_of is never null, so this null check is
> unnecessary.
>
> Addresses-Coverity-ID: 1492006 ("Logically dead code")
> Fixes: 20453a45fb06 ("vhost: introduce vDPA-based backend")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/vhost/vdpa.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 421f02a8530a..3d2cb811757a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -678,8 +678,6 @@ static int vhost_vdpa_open(struct inode *inode, str=
uct file *filep)
>   	int nvqs, i, r, opened;
>  =20
>   	v =3D container_of(inode->i_cdev, struct vhost_vdpa, cdev);
> -	if (!v)
> -		return -ENODEV;
>  =20
>   	opened =3D atomic_cmpxchg(&v->opened, 0, 1);
>   	if (opened)


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

