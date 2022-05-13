Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94AA525980
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376384AbiEMBqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiEMBqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:46:50 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2133.outbound.protection.outlook.com [40.107.215.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6383B3EB;
        Thu, 12 May 2022 18:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQI1z7SeKbvIga68oH9co76c87wE6VYV3k2xsxFowON5mBGPhUwsmReg/7uWiUyrO9iN/anxTu5qCxBlPqz5QQpFN03w4Y5dp3WJPcRvKcBKo4UBlqfQxtX+Q4hFCjWm6vXscKU6mZk/k6Fs9vLFGxvxhZ4PuVekFM8cm7BOkX1CXWLqC0IZtUDUilTUi/ppswnzfeNJY91VUmETpBSeEGRSPt6ObDK+xoMm3og3Tq1g39Ud9UTAuKTLx6KzpoF58xZ3MXwbViXRKTHqiOJXbRcAj4F1aFs45z9GQpBfVysskBxCeer3dqxb5/i47fh/ahP5tRY4J0qdYESQ/WQV5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcKbdraWt6Bbfw8nWmeH6b4QEsGNZp0tfxQsiFC5PQA=;
 b=Ys9T+ivLc/x/bR9YbLb3Uqq1lqMp5WSAl+BtEmCElkdRJsJDeO6zz2CQ2vOjkYkuOTDfG9yGlF0CYfTWUIVi5KTnT4hdnV05XRm5bneefKz5yEu+mgM+g7ycjWJWPZDwCh52E2XzNOyYnC4bTW6PatvtLNTRa0nN1eX+svLb59jEggjxkHNUP2NirHFHBRaZe7VNpfd0TogOGT+2TuODoXQAFseHQb9zSFiO2Ju70Wy70jZDStHA+SrvlqhnT1qSgGoenG1P14uHaPzUVh3cBQIkrg4J8WaOS9UCzBI+KCQ071SvbfkAV1J1XIB8zHln7+Kf0Hrb9UcudGMx420epw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcKbdraWt6Bbfw8nWmeH6b4QEsGNZp0tfxQsiFC5PQA=;
 b=EZ5hh1mkcBTc9tyVRoF8uENmzwOxvykUvee6eqANzvrnx4OqFkzqboqLwpMEdxUpbSgdKtdjE0AUg5bGfSsX8sRILe7eml4mDFIKVjkwG4YIpXI5mn7x8jbETpwIIodwRFh3PpudkR6CsZ9d5uMwZZYFyVKWeNJTnrJuW3d6QrBcGMOlq0wWweO4anFH9TUycW5SpEO49QQA3LwbQZECGxSx2/rNBgryGki8fZx46RITrNQXowwW0zeTZWYmwB6jBi8lPJEa1NXEissii7uAdKI188npwfMwMXC1u9F9X/+83AhfJpzYnC5zqlN0w6+ApdPtCDJC6wRdcCHywQgaaA==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by SG2PR06MB2585.apcprd06.prod.outlook.com (2603:1096:4:60::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 01:46:39 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd%4]) with mapi id 15.20.5227.023; Fri, 13 May 2022
 01:46:38 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Wilder <dwilder@us.ibm.com>
CC:     "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>
Subject: RE: [PATCH net v2] net: ftgmac100: Disable hardware checksum on
 AST2600
Thread-Topic: [PATCH net v2] net: ftgmac100: Disable hardware checksum on
 AST2600
Thread-Index: AQHYZlbKaZPttnO0Y0uPh06RLKT9Ya0cCbKw
Date:   Fri, 13 May 2022 01:46:38 +0000
Message-ID: <HK0PR06MB28341F811AD74F52ACA5D19B9CCA9@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220512231938.228651-1-joel@jms.id.au>
In-Reply-To: <20220512231938.228651-1-joel@jms.id.au>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdd04b01-8686-4fd8-d742-08da34826bec
x-ms-traffictypediagnostic: SG2PR06MB2585:EE_
x-microsoft-antispam-prvs: <SG2PR06MB25855B18893D205613C491A69CCA9@SG2PR06MB2585.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DV3S3QSIB4hfn6WvBQcYCkjAgYxc+U+Bu309KFEt0X8roBQLvYfiyjdZpSQeW0vHI2oE9NwzseSw2IuDHCIGK59JePiAs1btEqXOLEQDrO0pC03L8BpPDBGfqYRWdaHo4PuucIRj67sPoVbOgmgNIsAwit0BXZUc7XA1XpmeYUAyOD3wGoxXwogTWy5IZCCfG9i4A1rkH5nG86KcDQAe3WW0vZO2SBHqYhPaTX3Huz1IeKI1GB74hnF4RCvvR53NZ4vaSvUoRpZm104km0SDcjTQeOq/SU24hIwQy0MPTL0gQbMT4BrXCTHIeOGiZlLsDRAErJwYIX/PgkJgJNDO4TdN3r2LrOAmHc/e+8j1LSHTX6XtLFysaxLBjzeWbZExajpt/JUdjXnQeJwBdqOJGlRn4RyinN26JCk7ole+w/rXj3+XfEzsiJn0Pl0fuGLjfwIyYcbZgixLWWBxUqHAiNviYqu5igys0aXDbgazS1KQjEGrDXcEcZ5ZQ69+hg9BiqfNRvMBe8B2CUz2kiicPtfCp4irI3NBut64f+aTpdoZkvFGkF/R3jkBiBGUXiyC/barVsSQYTJSM+Ma/VtvsrNy53tq7PqgUGcR1nPERm4PF4LMZDvgK3lpu1AMrvDnEf9lU8ADLAun1J/6qct3mOSgw/FJohOm7im8d69IYhwmTEkVAWqVhUnNsFvDI41ZDGJvPfHEXeMW4OBsTjpcbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(396003)(376002)(39830400003)(508600001)(110136005)(54906003)(122000001)(71200400001)(2906002)(316002)(38100700002)(52536014)(4326008)(38070700005)(9686003)(26005)(7696005)(186003)(6506007)(53546011)(86362001)(55016003)(76116006)(5660300002)(7416002)(66556008)(66946007)(33656002)(8676002)(8936002)(64756008)(66476007)(66446008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MGcZnDKKrRHln1omsf2ViKOsiGpF8QibWQ3mun1iwmspxOYCDgyJL9EYfVex?=
 =?us-ascii?Q?/UqGBZxxtisx1Xx/3SopI0d/6IOOnk5tJPStd2dgiIVgmvaFjUbrEW0KYMfD?=
 =?us-ascii?Q?vU9ay/HTYahppdFclYQnrWtijO8isRj5jy2UawXTANa7jnWxmTat6qvQ0PMv?=
 =?us-ascii?Q?jh3g1qIzT++VGQjq3kyYuIqyudWurCMe53NyHv9NQW5KFIsK0P4PAv/x403B?=
 =?us-ascii?Q?/+e1aPJmf04kn/8lrXisQsccEEyeyovRt/jf9jTaWRCauu7D4wRRL0ZgxUif?=
 =?us-ascii?Q?uRLVf26DxSi6fCPT6e2FgyEsxqBZZNpgIUIshXjZGrmKtdUlbt3XGMkEGkBk?=
 =?us-ascii?Q?PpyIYK1kyl5+lUl+hsdtiGq4QEwHFGqeQ+xaTiMg7Q47abG41ycMKeTJHlEb?=
 =?us-ascii?Q?b3BqHlkZDBeN991YWidQ0s5EdNoybpYKZ2unqCFh22PQDvoc4VAzAFVvmRY+?=
 =?us-ascii?Q?oDGlJAKL0TYnnoOD457AZAWXRdgsgRFGyhJP7PoQjrC8iot31Xb+a1skQyC0?=
 =?us-ascii?Q?kAIjVlhqyYY31rQaRaTKU2urfc94udm0zeatHxhwFWvkq4amHwqak0+smOE8?=
 =?us-ascii?Q?andbRwLyRtcN8P4Lc/Us1Fkg/Doas+v7qotg7TOgn9CmO1nPgHkBBs3A4sNQ?=
 =?us-ascii?Q?N0oetbccKSxkuqoUB2XJZQB8ZLjzDbKgL3BFKD7a3aPGJtTEkbGiA7vTeJxv?=
 =?us-ascii?Q?HJwUm9+0Q6kf7JARsoCPnP4YiDTm8nfJiVW0JSkEj/8ofpBmLYJeM7/0vmQx?=
 =?us-ascii?Q?Tlnsx9lPR6IjbooNRJ5J/oEKnfTZ1RNngSmXZdAXfdgSZIuqYrQ80+tExfWH?=
 =?us-ascii?Q?MP2pv/N+XW2m8h1Pw33wEUgZqxqSo3CH+FqwRMaixCIeer7kyUZT+38U1oRW?=
 =?us-ascii?Q?BB+6tiOKQ0Hw3NbW/6N6Kima7OrWoDg2KiVxskLmzkLYGZJjddirJqFpoeyY?=
 =?us-ascii?Q?gefuV47DBCxVHO7LekyLzGAuo/OvblnZQN9NGv7gqli0v+77rOFDR5F0bFFz?=
 =?us-ascii?Q?/53i78nMe8HD7sPM449Irg01yi/dbzepDg2RwVEQ/ChQ66H6jim3koPDfaaz?=
 =?us-ascii?Q?n66WuFNUalE22fps1nGiWNEsysi1NXT1wuAUL9j5LsdvTeHRugqya7fBZvcn?=
 =?us-ascii?Q?bKZjKViaP909GyU9SA+9xqSPm+QXmgmEy6spj6kixR9ODySZC8jWiiL+iMlC?=
 =?us-ascii?Q?dHHln6C7upO3muixJEFUYTT8Zo9oSoCU8f3DzpPY29GROkDUJWt6UUVomSqg?=
 =?us-ascii?Q?a1YnoiQX6xci49i1x3bo5du4tsQOdKGmKzr2ajvBxMWaeMgFA3UZUpY+6miw?=
 =?us-ascii?Q?LetCwca2Yidowpp2qfBGK4Qs8t7k/tdMaf3wPX3moyN7+3W0Cg3SEW2NHMAD?=
 =?us-ascii?Q?80WaF6CIA0tIg1rMEJqfZVVrCVclIKb1BWLGiu0lwWR14Yy8SknlcewrxptY?=
 =?us-ascii?Q?n104hQ1Kidh0IpNLYOPFfBxkcdjOUdeBJFfJO0ODFdNcm0iFNAWDTdJy0RM9?=
 =?us-ascii?Q?d8fhg6HhdNDe/Sn2gM7x4us8DPFK9+F+KQMB1xkBdTZjkNFVc+i6EmOP9dXP?=
 =?us-ascii?Q?15inPQ1b0Uu+jW/OtILfVJP6dUVWtfxO57r4VaHIB06ohXrnxbZt8Sb4lxik?=
 =?us-ascii?Q?jk6sS9ptwpflGMI0jrLdmBPhE0BYmv+evJZs8JTOGo6Ij3Je+7Vx6sRN73oW?=
 =?us-ascii?Q?aoyWrCwF57aLEylfgMPZYKpRk7P8D47J5WvgQxcjnaHpUabNyH7ifpJ+9MgJ?=
 =?us-ascii?Q?L0pemnuHs6lI0YwvoUuU24I9OFZTgUU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd04b01-8686-4fd8-d742-08da34826bec
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 01:46:38.6798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0DSHc4pmePT8wspfzkce7C/0RoXHQOPshwK8bbVDOaY/Vl66XbHqoUiuFbQSI51ekMQAZ/PeJbvmYKINHnH6GAilafZ9MSI9kI7aMuDmi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2585
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: joel.stan@gmail.com [mailto:joel.stan@gmail.com] On Behalf Of Joel
> Stanley
> Sent: Friday, May 13, 2022 7:20 AM
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Benjamin
> Herrenschmidt <benh@kernel.crashing.org>; Dylan Hung
> <dylan_hung@aspeedtech.com>; David Wilder <dwilder@us.ibm.com>
> Cc: openbmc@lists.ozlabs.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; David Wilder <wilder@us.ibm.com>
> Subject: [PATCH net v2] net: ftgmac100: Disable hardware checksum on
> AST2600
>=20
> The AST2600 when using the i210 NIC over NC-SI has been observed to
> produce incorrect checksum results with specific MTU values. This was fir=
st
> observed when sending data across a long distance set of networks.
>=20
> On a local network, the following test was performed using a 1MB file of
> random data.
>=20
> On the receiver run this script:
>=20
>  #!/bin/bash
>  while [ 1 ]; do
>         # Zero the stats
>         nstat -r  > /dev/null
>         nc -l 9899 > test-file
>         # Check for checksum errors
>         TcpInCsumErrors=3D$(nstat | grep TcpInCsumErrors)
>         if [ -z "$TcpInCsumErrors" ]; then
>                 echo No TcpInCsumErrors
>         else
>                 echo TcpInCsumErrors =3D $TcpInCsumErrors
>         fi
>  done
>=20
> On an AST2600 system:
>=20
>  # nc <IP of  receiver host> 9899 < test-file
>=20
> The test was repeated with various MTU values:
>=20
>  # ip link set mtu 1410 dev eth0
>=20
> The observed results:
>=20
>  1500 - good
>  1434 - bad
>  1400 - good
>  1410 - bad
>  1420 - good
>=20
> The test was repeated after disabling tx checksumming:
>=20
>  # ethtool -K eth0 tx-checksumming off
>=20
> And all MTU values tested resulted in transfers without error.
>=20
> An issue with the driver cannot be ruled out, however there has been no b=
ug
> discovered so far.
>=20
> David has done the work to take the original bug report of slow data tran=
sfer
> between long distance connections and triaged it down to this test case.
>=20
> The vendor suspects this this is a hardware issue when using NC-SI. The f=
ixes
> line refers to the patch that introduced AST2600 support.
>=20
> Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle
> property")
> Reported-by: David Wilder <wilder@us.ibm.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2 updates the commit message with confirmation form the vendor that this=
 is
> a hardware issue, and clarifes why the commit used in the fixes tag was
> chosen.
>=20
>  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index caf48023f8ea..5231818943c6 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1928,6 +1928,11 @@ static int ftgmac100_probe(struct platform_device
> *pdev)
>  	/* AST2400  doesn't have working HW checksum generation */
>  	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
>  		netdev->hw_features &=3D ~NETIF_F_HW_CSUM;
> +
> +	/* AST2600 tx checksum with NC-SI is broken */
> +	if (priv->use_ncsi && of_device_is_compatible(np,
> "aspeed,ast2600-mac"))
> +		netdev->hw_features &=3D ~NETIF_F_HW_CSUM;
> +
>  	if (np && of_get_property(np, "no-hw-checksum", NULL))
>  		netdev->hw_features &=3D ~(NETIF_F_HW_CSUM |
> NETIF_F_RXCSUM);
>  	netdev->features |=3D netdev->hw_features;
> --
> 2.35.1
Reviewed-by: Dylan Hung <dylan_hung@aspeedtech.com>
