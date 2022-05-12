Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB6524DFF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354270AbiELNOm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 May 2022 09:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353288AbiELNOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:14:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35931252DD3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:14:09 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-309-NQr6Qan2NXefqjFdfy2npw-1; Thu, 12 May 2022 14:14:06 +0100
X-MC-Unique: NQr6Qan2NXefqjFdfy2npw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 12 May 2022 14:14:05 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 12 May 2022 14:14:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'xiaolinkui' <xiaolinkui@gmail.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: RE: [PATCH] igb: Convert a series of if statements to switch case
Thread-Topic: [PATCH] igb: Convert a series of if statements to switch case
Thread-Index: AQHYZRhZ2eSEIJ3KUEyq6EVycQYB9K0bOTww
Date:   Thu, 12 May 2022 13:14:05 +0000
Message-ID: <3a5a6467b24a46ce8e05fb8a422baa51@AcuMS.aculab.com>
References: <20220511092004.30173-1-xiaolinkui@kylinos.cn>
In-Reply-To: <20220511092004.30173-1-xiaolinkui@kylinos.cn>
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

> From: Linkui Xiao <xiaolinkui@kylinos.cn>
>
> Convert a series of if statements that handle different events to a switch
> case statement to simplify the code.
>
> V2: fix patch description and email format.
>
> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..4ce0718eeff6 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -4588,13 +4588,17 @@ static inline void igb_set_vf_vlan_strip(struct igb_adapter *adapter,
>       struct e1000_hw *hw = &adapter->hw;
>       u32 val, reg;
>
> -     if (hw->mac.type < e1000_82576)
> +     switch (hw->mac.type) {
> +     case e1000_undefined:
> +     case e1000_82575:
>               return;
> -
> -     if (hw->mac.type == e1000_i350)
> +     case e1000_i350:
>               reg = E1000_DVMOLR(vfn);
> -     else
> +             break;
> +     default:
>               reg = E1000_VMOLR(vfn);
> +             break;
> +     }
>
>       val = rd32(reg);
>       if (enable)
> --
> 2.17.1

Are you sure that generates reasonable code?
The compiler could generate something completely different
for the two versions.

It isn't even obvious they are equivalent.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

