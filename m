Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D0052ECC4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiETM6l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 08:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiETM6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:58:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B493169E27
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:58:39 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-91--vTwU6QNPHuZFWFp6B3O9g-1; Fri, 20 May 2022 13:58:36 +0100
X-MC-Unique: -vTwU6QNPHuZFWFp6B3O9g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 20 May 2022 13:58:36 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 20 May 2022 13:58:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] eth: ice: silence the GCC 12 array-bounds
 warning
Thread-Topic: [PATCH net-next] eth: ice: silence the GCC 12 array-bounds
 warning
Thread-Index: AQHYbBAkNdre3chl2Em7A5GyBQPoe60nuPLg
Date:   Fri, 20 May 2022 12:58:35 +0000
Message-ID: <fbde22661c6b4d5f82ca47d5703ab7a8@AcuMS.aculab.com>
References: <20220520060906.2311308-1-kuba@kernel.org>
In-Reply-To: <20220520060906.2311308-1-kuba@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 20 May 2022 07:09
> 
> GCC 12 gets upset because driver allocates partial
> struct ice_aqc_sw_rules_elem buffers. The writes are
> within bounds.
> 
> Silence these warnings for now, our build bot runs GCC 12
> so we won't allow any new instances.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> ---
>  drivers/net/ethernet/intel/ice/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
> index 9183d480b70b..588b6e8c7920 100644
> --- a/drivers/net/ethernet/intel/ice/Makefile
> +++ b/drivers/net/ethernet/intel/ice/Makefile
> @@ -47,3 +47,8 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
>  ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
>  ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
>  ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
> +
> +# FIXME: temporarily silence -Warray-bounds on non W=1 builds
> +ifndef KBUILD_EXTRA_WARN
> +CFLAGS_ice_switch.o += $(call cc-disable-warning, array-bounds)
> +endif
> --
> 2.34.3

Is it possible to just add:

CFLAGS_ice_switch.o += $(disable-Warray-bounds)

and then ensure that disable-Warray-bounds is defined
(and expanded) by the time it is actually expanded?
This might be before or after the makefile is expanded.
But it would mean that the work is only done once.
I've an idea that 'call cc-disable-warning' is non-trivial.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

