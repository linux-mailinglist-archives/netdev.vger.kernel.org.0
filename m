Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E2C101B65
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 09:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKSILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 03:11:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59959 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbfKSILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 03:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574151077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYpGRqlZ79gShGcxr9nZMiDNSw56rOuWXuGDiw1tjtA=;
        b=MW+FuUDAkidytsnqTwC1B8OGOpzmTdlb2F2f3ytxeM3DtQUCrmrSJv7uxnublrTFOtheP3
        e1ZWAyRBHJMbn0jEY2Y3oUMwj2oflr7BOFdTdTlsyVSoXCFu3jXgjkxpL966hkxvMkaORV
        ghJcf5FQf1G+6eFNBZUodzA02tMCqo8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-9s8HsaOzOK-g8G__hlit7Q-1; Tue, 19 Nov 2019 03:11:15 -0500
Received: by mail-wr1-f72.google.com with SMTP id m17so17729708wrb.20
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 00:11:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TbCjg00ROYqbcfn2fYTagiY6x5F8HKQPvmZOtUZA9LU=;
        b=nQCJalT92CI4VQ4y47LQIAZmO6rqnwUM5OLexuC9r/w+W0BqKuLocSBer8zf1N68fc
         8sQh+jJo1b/o7JsY7pMAo+5BxUATTNe1eAp6BQaOiAxH1eMirkTjrHN0kGo690BVDWNV
         6kOW02KBDTvah4cdowPjgRnK4SLmUtGAo4ZPRZS1xGytJG20WV0OcgSa2W20sApAMFTi
         33t/agVYclY4ZQdd8gZCnZxDc7NBb29Ih+/lBxE65l0EsItAkilqdKPTbN2LbGG14x1G
         dk6CF84e0sAeTT+v7iZ5ZUor+oN3xgz2dgYVjpnS+JwPkAtzq9oywS0GlqbvdkQ02CDe
         lWhg==
X-Gm-Message-State: APjAAAVyYz1xk7zs9nZb2yDQjyx3ws64NfLymdDCPTUzAGfxXTH9carg
        262lbvKDOjf7kIGDR8FqNnKH1JpGn//+RuQvG8dqrxQIDs3ZMt51ULR0NBof2e9qrw+gBWoueos
        QB/f9jdYGBJPN+YHS
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr18635228wrv.6.1574151074702;
        Tue, 19 Nov 2019 00:11:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1WdmEcZgq8Ru42cFxmubo9c0srM3mEX5+ycGUtl1ZXlAfcMSdDjHH7HPd2t/AWy6rw2SZ+w==
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr18635200wrv.6.1574151074490;
        Tue, 19 Nov 2019 00:11:14 -0800 (PST)
Received: from steredhat.homenet.telecomitalia.it (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id y2sm2318028wmy.2.2019.11.19.00.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 00:11:13 -0800 (PST)
Date:   Tue, 19 Nov 2019 09:11:11 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mao Wenan <maowenan@huawei.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        kstewart@linuxfoundation.org, alexios.zavras@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] vsock/vmci: make vmci_vsock_cb_host_called static
Message-ID: <20191119081111.gz2adojvsdcukvwk@steredhat.homenet.telecomitalia.it>
References: <20191119032534.52090-1-maowenan@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20191119032534.52090-1-maowenan@huawei.com>
X-MC-Unique: 9s8HsaOzOK-g8G__hlit7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 11:25:34AM +0800, Mao Wenan wrote:
> When using make C=3D2 drivers/misc/vmw_vmci/vmci_driver.o
> to compile, below warning can be seen:
> drivers/misc/vmw_vmci/vmci_driver.c:33:6: warning:
> symbol 'vmci_vsock_cb_host_called' was not declared. Should it be static?
>=20
> This patch make symbol vmci_vsock_cb_host_called static.
>=20
> Fixes: b1bba80a4376 ("vsock/vmci: register vmci_transport only when VMCI =
guest/host are active")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/misc/vmw_vmci/vmci_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/=
vmci_driver.c
> index 95fed46..cbb706d 100644
> --- a/drivers/misc/vmw_vmci/vmci_driver.c
> +++ b/drivers/misc/vmw_vmci/vmci_driver.c
> @@ -30,7 +30,7 @@ static bool vmci_host_personality_initialized;
> =20
>  static DEFINE_MUTEX(vmci_vsock_mutex); /* protects vmci_vsock_transport_=
cb */
>  static vmci_vsock_cb vmci_vsock_transport_cb;
> -bool vmci_vsock_cb_host_called;
> +static bool vmci_vsock_cb_host_called;
> =20
>  /*
>   * vmci_get_context_id() - Gets the current context ID.
> --=20
> 2.7.4
>=20

Same patch already sent by "kbuild test robot" <lkp@intel.com>
https://lkml.org/lkml/2019/11/18/609

If we want to merge this, maybe we can also add:
Reported-by: kbuild test robot <lkp@intel.com>

Anyway, it is my fault:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

