Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA77561570
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiF3Iv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiF3IvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:51:24 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CAB427E0;
        Thu, 30 Jun 2022 01:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GP56aIWok+qikXSQ4ZmpIzaIcNfCkCoKArNGRKOqJCt26puiGfbnp99VHQiGJXJ6PZuqRkeVH70gpxHyFyIeEPtHwdrJ61XXWz8tyfwdmqLfJCxsO291XeXIr5DKGy1PnQVNK/10xbyUNm82VpE/O653LVsFAkhlTQBBANj4eO3H6GXwgF42Qr/5d2zvUTR+qJ6AC2mrjS2PLfsHyfS4e7dWrHP9Vgd0T6tTQJL6JcafrvocJeAR0N52685MMlmSgMS63fYUoOjQWaapvMFZSFvfdnM5wKVdNWtcEe7eSqCdSlRGbvCUAI31YkeqlGQTW0030At76Ikgi2lyJ4h3RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxz0INGYBJVydrEwHfbUDxlz2QMVh1fMHD5g4X8UZXQ=;
 b=BeL+xhfSvJdA4lgruZ7Dsu6hMf5OKDmdUCm6mi9g/nM8j01Z9j2FkigxDrlT1KR/yHpY+Y8z1VvQz+6MAURINmf4OiVm7GXSq9ohTWLtxR3JY1PJNdR3tlX6Fd3gZzodq5wzIMV5f4JqbCJGxAFplUl/8TfjSQlu+Y1JGKzprI7nHEuCvIs1KUw/ewf9YrCtg+Nvybc4ng5RfcewCwOIpTqbhE527Z72F4GIOBTpZP7N7IayZDHK+/+tGEix7I4F/E6arktjfIsy5RIAoiqxh08ayzbjTTtiw0zWJTOKfNrsB9D1wC8Um7knPVeRHVjnuw3FvuCgb+MkKfbzEwZy6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxz0INGYBJVydrEwHfbUDxlz2QMVh1fMHD5g4X8UZXQ=;
 b=Hax5OdgIzaLCK7lqqXCotvJbiNh/YxDfd8uFPhhZNIMMP25PnJFDTVaI4FE3Xdj92kNzhWl//zbIq+2b7ecX3bc1qmf8xVzzqax3oJ9ITBL8fw8CfmDyuCensQm/gd+8Kd3Ac599baNShDRsga6WcUEHNMNy/akRl6YpIVRKJWo=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by VI1PR0802MB2319.eurprd08.prod.outlook.com (2603:10a6:800:a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:51:18 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::5479:2737:f137:bea1]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::5479:2737:f137:bea1%6]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:51:18 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernandez <carlos.escuin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mayflowerera@gmail.com" <mayflowerera@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Topic: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Index: AQHYb2NB5v+kUYU0g0uDR0Vv9E1K5K1k4jKAgALya4CAAAlIlA==
Date:   Thu, 30 Jun 2022 08:51:18 +0000
Message-ID: <AM9PR08MB67887876922C0E9842EAE88ADBBA9@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
         <20220628111617.28001-1-carlos.fernandez@technica-engineering.de>
 <e6114817650d7c27f4c1e75eaa63058846d71418.camel@redhat.com>
In-Reply-To: <e6114817650d7c27f4c1e75eaa63058846d71418.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 08fe1fb1-5066-9214-c16b-3cf57fb23d3f
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1375c98f-ba55-4989-9972-08da5a75b300
x-ms-traffictypediagnostic: VI1PR0802MB2319:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nBFoJOnHZNJCu2lbmEoLdK/J8mJVJc3mfWsvKN8zBOLcwqmWmyONYViMtWRpaKyrJnNRHMG8IC3IQGBLY/ONMqn0RZLkrMZflb2YgbAp1irqcluYJ/KnM9ffVr/a9cUxk+ryPqY7g/hc7pZDG+4U309fGCZnQCA5Z/bD0bG0EQIpLd0dPOHWdTCPZNZUAO6Z2iBMOLYKak7opMf6SDBdh1IXWoGc+msyNnXpdlsCrJw78/7XGi2wdno+9rgrQrH17eB5nKmZ8veDywg7/Wgw6QkUHr1+/O8u48YoQ1D/tHZEL9PSVm7WKuPnNW/c1ZZTj/EimOVPsS2tKcvvmOqeKcmGtsCambs9+97yZ+0/Vh0WDlw0xl0hwKCEdogQK1Qf58OwJ42Tg1ioh/nk6hRiP9brXUv7RGMHf6vwXCnxGYIsuVd6GD0q+oa+gro6NK3/1jOkqDFp7bokvfnrs3nxTo+Bp6P9NbdiEgEFoxwMatOdl7+POJbwU3WOgEZClSpqLVGlG5uotgyuBp9S256zvMLkJdL41WIOtiNyO0jf6KTs5HOOzoZKKwtJmIdNSmuqKcpDlDDZsZq7Z7H4yQs/4hGpi6DWvX3wtEZ26eiMSG9waDH3QnUYaCtkOh6JIn5ViKiHECqm6QVJ9eR3Qn4kkbsug0TgMr0rITnokVcGA5U8yJEITX0BAlIrfWkQN4eyRuatBj/GOLcjNr5gaGMRvYu9t/GiyCYV+XQ5A83e0iWs098yw2qDRdlqY7Q9IP3/9WhDmlbXPqNjU3ncNB5c99fHvUJO9L2t8yWsPwL0EOw/YuXuXylR3NwpbfZPvie8lQZTO9HZ3VP64OO2MKNOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(396003)(39840400004)(346002)(64756008)(76116006)(66556008)(66476007)(66946007)(8676002)(83380400001)(38070700005)(55016003)(66446008)(7696005)(8936002)(71200400001)(6506007)(186003)(33656002)(26005)(966005)(91956017)(478600001)(5660300002)(316002)(44832011)(9686003)(52536014)(53546011)(41300700001)(38100700002)(110136005)(122000001)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bmWQl07Ls+iPEm1c1lmV5/MLlLIXjLrEVr6m2MDxrk86HJbFvgfsYPAfIt?=
 =?iso-8859-1?Q?jRDFrDizeuPeyB++fQ+0pFGLG9bW9WQnmCPrplL7V9XRxvCgVaeUTkpKvK?=
 =?iso-8859-1?Q?OQ6pTG0tokLQmk7soHUvacCLFNR2iZNdtfgd+PQETkQI3Dlfv5Kj+D26Af?=
 =?iso-8859-1?Q?UDpV5j0WShWIQEArSNdrBA6xMbJz/nZmUKsaKwtP6wOWxc3F30dJDGPLrj?=
 =?iso-8859-1?Q?ZntqlPHxjLGYntEUmnySKxCY6Mvv+iYKLhzBc7w/Je/STZZHIUX/ivksWp?=
 =?iso-8859-1?Q?rIJOxDFDqSYMvJYf3ALA2Jl7+6qEaQT/ert1Jc0R9E1Io3jE2xXHyTP9ur?=
 =?iso-8859-1?Q?LWMVia0lGsvtrJJ3JucQY3/kRiwHU62N0PGAOKfUEYWGfj8KA2Y2fM2YZV?=
 =?iso-8859-1?Q?6XQDt2upBAHlA+I9OIc6vhyrIWCAynvph+Lgd/TtsLCA1yOTUAq22NUAVM?=
 =?iso-8859-1?Q?1qcOqAJBi05z9twPls4XYHkPigkjMB1LDko2oq3hwY6WYeDZVSW6rRFUyd?=
 =?iso-8859-1?Q?ixzXzRgZ+R+E1oGKzkTjK4hMkAMZK7pypse8/uWjs91hhHKErQmZhUtNKL?=
 =?iso-8859-1?Q?wRfkrqNCkD0bqD4TEzMtay4Tj1kAMKm6unLJl1Urg9XMdS9YXSKu1Zuoc4?=
 =?iso-8859-1?Q?9yeXbKML3ExdupUVqju4cUq33RBgEMfJsNjDhqJvvVNxjWQDry++O7nlCi?=
 =?iso-8859-1?Q?+dpCBfcdOF9xIWe4XuBKDrDZpDr0cChnOIuAvSqE65WFCyydrqs5vtHy1H?=
 =?iso-8859-1?Q?00+PH1oQStjtPfSNWbhAFQuZzIMxodvQchqikQCHt2BlTAkNYYx4Lwg5BI?=
 =?iso-8859-1?Q?J0PgSSHhg4R5JPe8IbJ8OA9RFQa0rarQp5Mx8FbZr/npyPnA8ak12Ak3iz?=
 =?iso-8859-1?Q?OC+07WK6RKfBluSdoqJ0nG7uzuurmMmOjIfn3N1QBJvwitHUdJoX7ni1JC?=
 =?iso-8859-1?Q?ebx1sxhGohcOtuf2wp7Z8u/1mUoEQG+tsYPSDqgSLBUjjRVS+Xrcw5skf7?=
 =?iso-8859-1?Q?637LBkkKBqcZMIeHet8cjTPtJeY1yJvoq5WuDU9Qy4I6+AEe/8M8KIrQud?=
 =?iso-8859-1?Q?buYw2+AZ7zR53k4MAEIT1Vqg60WHEezLULcsQN/6azq+kO1fDbTRDR+qeo?=
 =?iso-8859-1?Q?p2c5Xfkq1T3FEjiCUMwLUoVcGGNA2HgVNkygMQ6otzUkjq/jskOYeaM8ev?=
 =?iso-8859-1?Q?oBOVuHIh6iNCfnlyhvAt5/l82yql8OS3w4mnnf3RvR2tK9aCs7LUu7FB0a?=
 =?iso-8859-1?Q?UPmUzSCydU5trkiqm/qxfMGHKpJJG+jvWTCvqhR2G0RE53o08MAOWsrW+L?=
 =?iso-8859-1?Q?CE26T276s5ta2BXlBsJNMZ6oCjWBP7unqlD5Se+IuF3KUTC+uV7LUglRa9?=
 =?iso-8859-1?Q?sepp6ku6srVIMJt8clwmlmK0XCPyZriFf9ekMiCt3KrVgJdHBvp4detpCt?=
 =?iso-8859-1?Q?JA7yK/a9e/oIUA9maa0sAvd58+XVUyo+g6zDUgmw+vAF8RsRL4fGZQ35iX?=
 =?iso-8859-1?Q?+tTLwNmGODLenePY8nkQeb1xsGvr31zEObvjhtj9gNylxE1M3bwkwOSbQu?=
 =?iso-8859-1?Q?Kcy3+Jycq4HBm8JIVS3XAkgIHkRB3uzwDrv9/ezunuC5uhNxB0Br6xQ5z1?=
 =?iso-8859-1?Q?XV4NwlmMoLshQF/DsztgZigLtNZq2j84EphKhwmIn/6pfNuS+XGMwBJwB9?=
 =?iso-8859-1?Q?z951HbY3t/CSKUotac8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1375c98f-ba55-4989-9972-08da5a75b300
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 08:51:18.6868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFMpJmbsmLXEg8NZpwUCxGb+dQOq/kbRwNvqf5JZ6h2auMRZAPr9DC66hnaiTfBpYUJfCnslS7qovoDRlSA5C2Jkg/xaj7YQd//LIQEYMk1jOLOnLJ8DjsFtLuMsSBS0GYkkHtUZwUrg67rBRigOng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2319
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo, =0A=
=0A=
Sorry about that, I was pretty sure I added it in the first line of the pat=
ch and then I used git send-email. =0A=
Is there any way that I can be sure everything is ok before sending it? I'l=
l try again.=0A=
=0A=
Thanks,=0A=
=0A=
________________________________________=0A=
From: Paolo Abeni <pabeni@redhat.com>=0A=
Sent: Thursday, June 30, 2022 10:16 AM=0A=
To: Carlos Fernandez; davem@davemloft.net; edumazet@google.com; kuba@kernel=
.org; mayflowerera@gmail.com; netdev@vger.kernel.org; linux-kernel@vger.ker=
nel.org=0A=
Cc: Carlos Fernandez=0A=
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before=
 offloading=0A=
=0A=
CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.=0A=
=0A=
Hello,=0A=
=0A=
On Tue, 2022-06-28 at 13:16 +0200, Carlos Fernandez wrote:=0A=
> When MACsec offloading is used with XPN, before mdo_add_rxsa=0A=
> and mdo_add_txsa functions are called, the key salt is not=0A=
> copied to the macsec context struct. Offloaded phys will need=0A=
> this data when performing offloading.=0A=
>=0A=
> Fix by copying salt and id to context struct before calling the=0A=
> offloading functions.=0A=
>=0A=
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")=0A=
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>=0A=
=0A=
This does not pass the checkpatch validation:=0A=
=0A=
https://patchwork.kernel.org/project/netdevbpf/patch/20220628111617.28001-1=
-carlos.fernandez@technica-engineering.de/=0A=
=0A=
The required 'From: ' tag is still missing.=0A=
=0A=
Please really add it and re-post. Please additionally check your patch=0A=
status after the submission via the patchwork UI:=0A=
=0A=
https://patchwork.kernel.org/user/todo/netdevbpf/=0A=
=0A=
so you can detect this kind of issues earlier.=0A=
=0A=
Thanks!=0A=
=0A=
Paolo=0A=
> ---=0A=
>  drivers/net/macsec.c | 30 ++++++++++++++++--------------=0A=
>  1 file changed, 16 insertions(+), 14 deletions(-)=0A=
>=0A=
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c=0A=
> index 832f09ac075e..4f2bd3d722c3 100644=0A=
> --- a/drivers/net/macsec.c=0A=
> +++ b/drivers/net/macsec.c=0A=
> @@ -1804,6 +1804,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, st=
ruct genl_info *info)=0A=
>=0A=
>       rx_sa->sc =3D rx_sc;=0A=
>=0A=
> +     if (secy->xpn) {=0A=
> +             rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
> +             nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
> +                        MACSEC_SALT_LEN);=0A=
> +     }=0A=
> +=0A=
> +     nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
> +=0A=
>       /* If h/w offloading is available, propagate to the device */=0A=
>       if (macsec_is_offloaded(netdev_priv(dev))) {=0A=
>               const struct macsec_ops *ops;=0A=
> @@ -1826,13 +1834,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, st=
ruct genl_info *info)=0A=
>                       goto cleanup;=0A=
>       }=0A=
>=0A=
> -     if (secy->xpn) {=0A=
> -             rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
> -             nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
> -                        MACSEC_SALT_LEN);=0A=
> -     }=0A=
> -=0A=
> -     nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
>       rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);=0A=
>=0A=
>       rtnl_unlock();=0A=
> @@ -2046,6 +2047,14 @@ static int macsec_add_txsa(struct sk_buff *skb, st=
ruct genl_info *info)=0A=
>       if (assoc_num =3D=3D tx_sc->encoding_sa && tx_sa->active)=0A=
>               secy->operational =3D true;=0A=
>=0A=
> +     if (secy->xpn) {=0A=
> +             tx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
> +             nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
> +                        MACSEC_SALT_LEN);=0A=
> +     }=0A=
> +=0A=
> +     nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
> +=0A=
>       /* If h/w offloading is available, propagate to the device */=0A=
>       if (macsec_is_offloaded(netdev_priv(dev))) {=0A=
>               const struct macsec_ops *ops;=0A=
> @@ -2068,13 +2077,6 @@ static int macsec_add_txsa(struct sk_buff *skb, st=
ruct genl_info *info)=0A=
>                       goto cleanup;=0A=
>       }=0A=
>=0A=
> -     if (secy->xpn) {=0A=
> -             tx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
> -             nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
> -                        MACSEC_SALT_LEN);=0A=
> -     }=0A=
> -=0A=
> -     nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
>       rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);=0A=
>=0A=
>       rtnl_unlock();=0A=
>=0A=
=0A=
