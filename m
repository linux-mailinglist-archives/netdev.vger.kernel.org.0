Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BEC4DC1B7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiCQIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiCQIrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:47:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AEB21C404A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647506763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OJl0OqzFyx1IFYWW/jK4Qb7pxtgaM7g83EsrlNNbdCA=;
        b=fGd3TdXYQ43+fB8qHF4tr0icvBQx1vpt7P/livOfxDSSfz82pVhnY/ZQIN1Xi7PpehAqrf
        RHA0ZwUZPLmgDI3Bj02NeT7mc95XFqrhAJXs191OwvGBLCyLjyH29Mwe8P6TSSZpWmwrJt
        CBs+Y97K8L1fVdvWC4vKIzBweHEHSOw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-ziQYNZgFMDqlhEuLtt5kZg-1; Thu, 17 Mar 2022 04:46:00 -0400
X-MC-Unique: ziQYNZgFMDqlhEuLtt5kZg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D69261C03389;
        Thu, 17 Mar 2022 08:45:57 +0000 (UTC)
Received: from localhost (unknown [10.39.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643CC43E8FA;
        Thu, 17 Mar 2022 08:45:56 +0000 (UTC)
Date:   Thu, 17 Mar 2022 08:45:55 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 1/9] virtio_blk: eliminate anonymous module_init &
 module_exit
Message-ID: <YjL1Qz58ET7gS0bs@stefanha-x1.localdomain>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-2-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fc5ZE+6HWCBqJ9uq"
Content-Disposition: inline
In-Reply-To: <20220316192010.19001-2-rdunlap@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fc5ZE+6HWCBqJ9uq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 16, 2022 at 12:20:02PM -0700, Randy Dunlap wrote:
> Eliminate anonymous module_init() and module_exit(), which can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
>=20
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
>=20
> Example 1: (System.map)
>  ffffffff832fc78c t init
>  ffffffff832fc79e t init
>  ffffffff832fc8f8 t init
>=20
> Example 2: (initcall_debug log)
>  calling  init+0x0/0x12 @ 1
>  initcall init+0x0/0x12 returned 0 after 15 usecs
>  calling  init+0x0/0x60 @ 1
>  initcall init+0x0/0x60 returned 0 after 2 usecs
>  calling  init+0x0/0x9a @ 1
>  initcall init+0x0/0x9a returned 0 after 74 usecs
>=20
> Fixes: e467cde23818 ("Block driver using virtio.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org
> ---
>  drivers/block/virtio_blk.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> --- lnx-517-rc8.orig/drivers/block/virtio_blk.c
> +++ lnx-517-rc8/drivers/block/virtio_blk.c
> @@ -1058,7 +1058,7 @@ static struct virtio_driver virtio_blk =3D
>  #endif
>  };
> =20
> -static int __init init(void)
> +static int __init virtio_blk_init(void)
>  {
>  	int error;
> =20
> @@ -1084,14 +1084,14 @@ out_destroy_workqueue:
>  	return error;
>  }
> =20
> -static void __exit fini(void)
> +static void __exit virtio_blk_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_blk);
>  	unregister_blkdev(major, "virtblk");
>  	destroy_workqueue(virtblk_wq);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_blk_init);
> +module_exit(virtio_blk_fini);
> =20
>  MODULE_DEVICE_TABLE(virtio, id_table);
>  MODULE_DESCRIPTION("Virtio block driver");
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--fc5ZE+6HWCBqJ9uq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIy9UIACgkQnKSrs4Gr
c8iZgwgAu+noR+ltVAJ7OwDFJ+cU1+Jt+y9ekxCE7nVf1ewvSPnRQk4uHedTFnbj
Gj0heR6sfjVttvETL+7czSeKRHX9EXeoVppr4CUa8V5WFqvF9x1znxWKUdhLvBTQ
EkP9LIuTQcDIAhhBnDkey+nm+HGSCskhzdL2dv+tCrmQpNL+A452YdhLdRDE9rc0
hZhcHBGwWMaLCwkBgoOjtbV8XhAben6e8pSm/y4fhYox3Vdp+uhpyNq0VgecqQxo
oAIHze/jJOOtt40S/VkCBFk59HmIIVfiP1HZYLTZ1rSxlozav/tpfevVO+SE1J4I
AOGS9d5FzkEqt+zUnNrH4FIwokLOJQ==
=xh+M
-----END PGP SIGNATURE-----

--fc5ZE+6HWCBqJ9uq--

