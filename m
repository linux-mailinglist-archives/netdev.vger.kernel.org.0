Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2984A6A532B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 07:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjB1Gxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 01:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1Gxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 01:53:44 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062.outbound.protection.outlook.com [40.107.105.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74FE11673
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 22:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3U9x7MRhIbi8wDGa+WenscuarRIGHMQTtNMI23qBp5ChQbDz9c+LR9QiJWxuW0eY4Ms5fK3tOYom8w3B4luf0PwqULKMuTmV4vTbErM9WdqIik3H35mNBxlW457rvn+O98d6+URT3QW6PAJCfCTf94e//MNQ29IgT7oWFXB+n55LDT7O3Q6f3SpVgJF75dUjmLFM9svvVAam4lTWi5dpUZzCpATHmvvwWnWKoWH3L1Nl8SP5VVJOpcX/tsXuxfPU9NU0MOkQK+NlhNiSSQxP61z6DDbQhBJ0NXmcWuH+mRxdfmd+IOX5zJ75LSEkkNKD/Bx2Dw7tnowBcwhevTOBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2U0IVDukanBG0f4rHHC71hEOz8gzl9XE0ACfE1TbaRI=;
 b=d8ZIFysM669mj2tpyL0Zai8ApywNar4dsjFGN338ySHyjt13Wf4kcd1MMtgaDqU1AfylZDBOnIZ/j2AoRMiZ2OhtOycsqTqwYS91zGFvNPYmdjYubbeOU8Jjq4MXqgfCkHGIvKnlM1+NwySxfooiOc0+2qJzQaRFTO/Hhxt/Bo6GuZwuiw4zI5dSbcvhywP6VSJUzwqQZqHdadXYu6/1w+FDcNozqfwQXVcwn2Jm4FRFRPGrFC/Qu/LJSHDOAcOcMDVXLnruXgLgyOhC9hesYi/z4Es9REoHEQAf99G3+G4xzvzcmFUL14kcc8DiAV3L1vJRnCPwOpG9ilu4Yj/oHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U0IVDukanBG0f4rHHC71hEOz8gzl9XE0ACfE1TbaRI=;
 b=htvXe819v1XLqU0y/sap/nuJlKp3dnksnboV320vcSV08y0Em2AReh6vNkh8wwrqLxzBj2LTT8OZhGdLZ9L3dXh3gNOl9HNwqMOVFnB3rndpTOJyS541fojNDsIDOXlqWHsbrNfpgJoKOCVowUMisWI4IISQ6WFBZs9YTXFIZD8=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AS8PR04MB7542.eurprd04.prod.outlook.com (2603:10a6:20b:299::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 06:53:40 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::c2c7:5798:7033:5f87]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::c2c7:5798:7033:5f87%7]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 06:53:40 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
Subject: RE: [EXT] [PATCH net] tls: rx: fix return value for async crypto
Thread-Topic: [EXT] [PATCH net] tls: rx: fix return value for async crypto
Thread-Index: AQHZStcEChKupRegbUCxW7I1Qyf3G67j7QCQ
Date:   Tue, 28 Feb 2023 06:53:40 +0000
Message-ID: <AM0PR04MB60046AE4671F4D2B293FAB38E7AC9@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <20230227181201.1793772-1-kuba@kernel.org>
In-Reply-To: <20230227181201.1793772-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AS8PR04MB7542:EE_
x-ms-office365-filtering-correlation-id: bdc901c5-897b-4902-f565-08db1958865b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoZpFiB9t2NzaeT8sZA2xWsVa46G/FrlNrJAdSN6Ht7Rcd//cz0S4uH3RCMO9VXtxpbz5tvpIIf3Q2hgVxMz6QlaZ21BzOIYjRJ7DJExHFM2G0JX7RWt30QM17HAnQzvTclFk2tmYc756gtHUjnuptJ+asOgcH3XApnCz2gntviV9oDoZndx/U8l9dbcp1qdgci2PYLFtbx/DJ7CiIomynaeTaWrGV3u4jB85l0gmTEtcE6UnyH7up0Nx/zfVfc6Ydn0V9UE5DN/Ky2JKEjdEQWey5B7+LyNb5wSknt8QPHM5aGM7L2pv6NxxvWzQQGSQz1CwVScmplDDMpOuMYmBhwG51wkt/ZG++uHJlbkDy8+h77i7MA0lInAJmDb7Ts4xdvm67cy36ceQlJn++YyW/Gj8YMiklMOz66MhHyDYUw8T++/ncsnoDkVQNewhioVyrNfCYtnT4eVYXAf+79d8bxTZWnivP/zKCI8NMzNYvF997aE48dTzFWSfY45Fqs9wZvmp1bi/blfiYoNQutLiADt4sf/dOyPhJI7WFRRZFIkOUu0QKk9NivBBLFvpiaAvSqiDvyCH7ktPT2/a2Co+/S29h3PHaC8VR/9AJ7MD5OC/McizKf6lvMa3iarIXEEzg6QAKGGIdIwQxDUvkFJOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(4326008)(86362001)(33656002)(55016003)(66556008)(66476007)(66946007)(66446008)(64756008)(5660300002)(41300700001)(8936002)(2906002)(44832011)(8676002)(38100700002)(38070700005)(122000001)(7696005)(71200400001)(966005)(52536014)(45080400002)(478600001)(54906003)(316002)(76116006)(83380400001)(110136005)(26005)(9686003)(186003)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VHLT5gVz1zdN/aIYXcYS5OtGR12GdFcdj4eSZ9oCCE+39P7uOhgMcTLkrrYt?=
 =?us-ascii?Q?EG1x24J03nhQH7/9xF1mxl80hg8B7fKwPSa0Gp51pEfDCFNNXa4w3Ri/L2wj?=
 =?us-ascii?Q?gH0sZxl9nIas0olTkJb/9EZ+MexUKjlJtNE5xCMBEppAWVgbdfEgsFEQd47q?=
 =?us-ascii?Q?Qg++QmRjPzJ9J+dZppxPrgHpMiO0E75jFRXR7uvQ6ZjWRaLUJ+Tsc0/5yEAz?=
 =?us-ascii?Q?aLztsd/YQnw1phWhBcO3CXc0TElLlm8WRyGEK1mRnfFbn42I6p0/KyzMAYRV?=
 =?us-ascii?Q?n9FzHRKlRiaayohYkTSLi12LL+JRoINtA4TF2ObE3DdL+EJYbgeCxD9aEGr4?=
 =?us-ascii?Q?JKQRxCiMdQo/+11eOa0NX23T8hE2rVhEjGCTPq/oTtUB2GC3GtSiea+zyjyH?=
 =?us-ascii?Q?f2BHX6ZT7KliCjnwai17hy5WGWDAiESlRI67X9fC4MpTpJl6BY45dLCjlBlE?=
 =?us-ascii?Q?K0ktK7jph1tEskh9+WyjZ4Eby/XBWoOvrpUlGVyd4GG6F9OhJgi/gb2M+nvC?=
 =?us-ascii?Q?zcDdH54iSakLQ8kwTy9amEA2R3GsofJbVqfO1jR+3/CLXrPE9gABIQrqCNzZ?=
 =?us-ascii?Q?OER1fmMnfWfG1vmkABN9/q6DH1T5Dd86NeQWRQ+IcLhhbu7Ccip3zeB0xa+t?=
 =?us-ascii?Q?k34I1OQNN97J1UmpgLAKFNdppWU30+NQIw66FKPZSiV7wLKINzU6isK2MGB9?=
 =?us-ascii?Q?mf64iwxREFHbZdRe3jiRiPYWOY40zgu7gMXdB4rHe20UWrWxmk5cRsqWcvke?=
 =?us-ascii?Q?oqSxNtOxpk60vdQCa5yR4icgawgs+YqQCE0ufHomjkSn/k5PACNNdiCcBkdE?=
 =?us-ascii?Q?53IMXPw4sbnld7YAAcYRz8BJq/Imsasn3FLL2WXlpSjPslQ5ERv6D6yMRAu9?=
 =?us-ascii?Q?lwWAHcXwzgqDsbGgcsATQG/5S17AGXcJTFPIHaUILLTK/iyJHcqGhvGvVuJY?=
 =?us-ascii?Q?8Khd0o/lkeZRdo44WluaaLoCeWTXaBbeAQ4Atq0jjOkPppIvZm6d0IyIDG7M?=
 =?us-ascii?Q?XKC4DRBcfkXaKPtsvUVot05QT7MSkRZaOQ7RkR5bJ9u6/Q3GYjEq72iqXZ6y?=
 =?us-ascii?Q?4zMe+2DsNxN1ptv2eO8RlDzyZdq63RKDmnPZI1t8UEjBMdam7hKjLoEFnMZw?=
 =?us-ascii?Q?oZL4zYGpzalcEvFUjPYhSKK9j9PZ0jWPBwxKnGkXSIo3XWmjVLNalQhf9G/F?=
 =?us-ascii?Q?gzRANipKbrwKViTs8b4ExGUeiOZWIlMBJzehLw7eFN+KExMkxdhI90uoRiHs?=
 =?us-ascii?Q?2TD84xjs+QxXIUuQ6DcThsh50ttZI+5Bw1Ruvio2NTV27CBUwWmUMEj6nBfv?=
 =?us-ascii?Q?9Un1VT+5XuM5EM9eo5mi+Ek29REEV18QWHlUZXvriWdl5s90+DxKvoNVfKcn?=
 =?us-ascii?Q?hyuRArxM/rXCxQJ1HVJGBfid5a6MSYgqwQ0cbuK1SU0cYusBbfcGi7pkgvrG?=
 =?us-ascii?Q?PL8sPVnWuloKrjX4CANvDeAGWkkml42lU/NOdjiwLgdzZvsBxDpjMpwsLIdq?=
 =?us-ascii?Q?5FBUAc4vMjHBF7tcyoX8RPDAw40Lo3Sk1Qx0eY5umLa3Mp09doGDyjeZvP6Q?=
 =?us-ascii?Q?nu6mwXqHg8342jXoy0tqNACO1Ha2c9LWVNIHaXE8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc901c5-897b-4902-f565-08db1958865b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 06:53:40.4422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /F697Sr2WbFdSTkWlBAMT9zy4DbuDlVHYgGcPIC/s1aPyTo5akfuT1VcrOgUEOiRYfFZiELFuo3PlmfxwaC1Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, February 27, 2023 11:42 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Gaurav Jain <gaurav.jain@nxp.com>; Jakub Kicinski <kuba@kernel.org>;
> borisp@nvidia.com; john.fastabend@gmail.com
> Subject: [EXT] [PATCH net] tls: rx: fix return value for async crypto
>=20
> Caution: EXT Email
>=20
> Gaurav reports that TLS Rx is broken with async crypto accelerators. The =
commit
> under fixes missed updating the retval byte counting logic when updating =
how
> records are stored. Even tho both before and after the change 'decrypted'=
 was
> updated inside the main loop, it was completely overwritten when processi=
ng
> the async completions. Now that the rx_list only holds non-zero-copy reco=
rds
> we need to add, not overwrite.
>=20
> Reported-and-bisected-by: Gaurav Jain <gaurav.jain@nxp.com>
> Fixes: cbbdee9918a2 ("tls: rx: async: don't put async zc on the list")
> Link:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugzi=
lla.k
> ernel.org%2Fshow_bug.cgi%3Fid%3D217064&data=3D05%7C01%7Cgaurav.jain%4
> 0nxp.com%7C77f145ef30784d369bca08db18ee26ab%7C686ea1d3bc2b4c6fa92
> cd99c5c301635%7C0%7C0%7C638131183344515410%7CUnknown%7CTWFpbG
> Zsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn
> 0%3D%7C3000%7C%7C%7C&sdata=3DPQE9yFQ85lN8RvbgLwLIZmRbCzZOVcF8VB
> MEWTgi%2B4Q%3D&reserved=3D0
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> ---
>  net/tls/tls_sw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c index
> 782d3701b86f..021d760f9133 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2127,7 +2127,7 @@ int tls_sw_recvmsg(struct sock *sk,
>                 else
>                         err =3D process_rx_list(ctx, msg, &control, 0,
>                                               async_copy_bytes, is_peek);
> -               decrypted =3D max(err, 0);
> +               decrypted +=3D max(err, 0);
>         }
>=20
>         copied +=3D decrypted;
> --
> 2.39.2

