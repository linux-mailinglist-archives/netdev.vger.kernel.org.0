Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616A95B3AC4
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiIIOgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiIIOgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:36:33 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60057.outbound.protection.outlook.com [40.107.6.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ACB1251A4;
        Fri,  9 Sep 2022 07:36:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgzM0egIsO/A/HfzOwujLn3Nxbnd1zRliduem21Ci27yqKyygOzcKAd+pd5DH3c07VIIdV0RcpA1kDO0n4uvBJpuES2o065YNLonN7htLzk4mLoJb9RFF3VjWzqcZK8TSyeorkaZ3rBu0SxWIbbz1MTSpJFvFUPDcF9+US/SRAFoHRyux8jsaaLiD4RC74iJKcoA3FaHdmkqGkQbBEZJAxb4gJAmSUGyITFSoJoFbg0848dFadlRNh64Fc7aC08faqGez7eAZVzRcJmjFlmTZgbAULBFXa5126i9ah2ia7JJI0kSck5hhan2q0lAgG7HWm5Rgu69Ywc/k7HyWpCQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SurR9hJ3kJIyBL3EaOoCGo0PEoQWYZ21p5P0bfj+aI=;
 b=Rx/gvUDG0p7+0PZhjY3ESNIFru2dGRLyKFttoMmYyQhUdagfF24q/PjaZ7brfrPT1bHjbga6daLAbnc1F138o/zE0H8/F8c7GN2XyeaTJ/0UI0OneMd7lxkUttpUtn70bNFxUn3j4XLiro8msGPMKZyYdhBZYdQ9STtEe1BD3JQ3nNUQxOGdc55EEP4a/tl6xUzoZXuCuYAd7Lnsqx7AWRzMaeVuFz6ls6Hb4PGJla/Mkj+qguGzkbVI1do8+WS78RNMhb5qYKuxVLkQVcS3vwOqQanqtegEJpqocA6G8jowbdqc8tO1BXBJYzPrFyfldjbOq+7WLVtGYc2pwF8VOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SurR9hJ3kJIyBL3EaOoCGo0PEoQWYZ21p5P0bfj+aI=;
 b=FGinTr36Lf/xm4C9Yi+GlDwngayn22VM81amOW44uT5q4SP4/6UF0f7YPCv+u7VW3nXOKpD+T84WQ0Od1eYufX1f5915ReeCKXxP4EWOrv3Swr4W1MhxQRtI5sIegbe/lr8R2jg/dlRCQBSzdgR8nMxEQDAAdynsUsL8PFjHS+o=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DBBPR04MB7802.eurprd04.prod.outlook.com (2603:10a6:10:1f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 14:36:29 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::950d:bfe8:d27f:8981]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::950d:bfe8:d27f:8981%6]) with mapi id 15.20.5612.020; Fri, 9 Sep 2022
 14:36:29 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: enetc: parameterize port MAC stats to
 also cover the pMAC
Thread-Topic: [PATCH net-next 1/2] net: enetc: parameterize port MAC stats to
 also cover the pMAC
Thread-Index: AQHYxECkOQBIxj21/0+AmUL4y9CbhK3XKdhQ
Date:   Fri, 9 Sep 2022 14:36:29 +0000
Message-ID: <AM9PR04MB8397D889F519A57587FD56CD96439@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220909113800.55225-1-vladimir.oltean@nxp.com>
 <20220909113800.55225-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220909113800.55225-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|DBBPR04MB7802:EE_
x-ms-office365-filtering-correlation-id: 5765437c-09f0-40a9-169a-08da9270aef8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZPUO7xvFad2WHvEt9vMbqC0f9C1M3jb59I9JtW3Zv7U2+szD7XO8Q55YFrlemlY5WClGX4bWmsuLlLP3H4T4zB3Mlagp93SWEYpqAseY+Mz0r4sUv/GwZCUO4WJgPqLdan5zF7w5IgZZe2VG/+2yYn7zv3QG41FQ5QZ02Y4HrED0zlyZX73D31nPICPxq+bVLvvkxVpxNqJEXIaqLh0xQvZcxmk/Te3ug9Mnr9XIK8X8g721U9CLHfnGrFGFvYMWzTDhYM37ba5y6gaV6rD8Uw/iPl82RhTDm2/HJuKEkKKqhVFYVFfciwMp6y2p44zqqSlIx7iTiB0zmkzRz9rOjlyQB9B45mAlfD7FW2ZR4SHQoDarDiKFI2gd0k9nSRciXTWXf4qvIJWv84V93rlqY0rcHYacBsSb4h7cT/eiixY1vygWUwxmaXsMrDH7/WwyTyMnUNV2b0t0fz9r1sPd+MGhNtSOAM8Cl6NHLbSGaMqm4SOkm4nky3KuTt9Vbs6j32+to5s7jgV7n47z7qhxe2CdHaNouOJhwmFpCPYaFCYvFrVbZRSbiEBB0o6YvxF3uTvGlGNR6TfQLv3JAbaA8thu9DOb0bEqgxq7ITWQV3HyTLLxVr/OIaFE2tA/HxqIqcf6DCTnNTFyWRzRp7KjZy4wzYyZAWCsGUlSX3QMG+6FfqA9HDL/whZViGYRruBRScZXdCPkd6cvpaiTyRCVJBiWR5XgocaiiIpIShHqZ9SMqDV+Moy/6T9bArK532g6upj6dich3W7/PIpXsshP0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(66556008)(64756008)(66446008)(66476007)(52536014)(38100700002)(122000001)(5660300002)(86362001)(38070700005)(83380400001)(186003)(53546011)(6506007)(9686003)(7696005)(41300700001)(26005)(71200400001)(478600001)(316002)(8936002)(66946007)(33656002)(76116006)(55016003)(8676002)(4326008)(54906003)(110136005)(4744005)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MaFtk4/NupJoHxy07F3+QpLZvR4/2x1+2VDS0MIcBIgF1UVmkqHmjVGRA4zC?=
 =?us-ascii?Q?SsLWuUyu86QfUgx0LuDCByo0BHHYtt7QEh2qT+fO7+6R8lILoFQdjmjkPfwZ?=
 =?us-ascii?Q?pzzarTDIyUBwkh3AxdrOTfpUrqko/XBRcmC/Gw06biJj6qtcbQrxnWmbWYYw?=
 =?us-ascii?Q?8K0mVGsLAm607s7fVf38ujQmgwdRz56EBydUTlAwcYTvhXTHOckH4cCpao6L?=
 =?us-ascii?Q?qOEYthFbAJCRPE3NRxkc6F9tYO5NN8/isjGrO1rtay6PFf34rgbzvSqKf1Ys?=
 =?us-ascii?Q?UPVUJdpZvmgrGv6GvfY+PomcxoMpZtAc1TZA+5DRv5P8hPzMAT576PX9k8if?=
 =?us-ascii?Q?uzhzh7YAgiO5DeXFRNoLG893gAL80Z9cuIt2Vfv/73jOkyq+C4AAKTazXX3h?=
 =?us-ascii?Q?789tEQDOECziSjZPLnqiTUO5eMODkiFyuMSTTIbXawsD9k5fRrH92mvXtPOz?=
 =?us-ascii?Q?hw1ahCrS9rDqVsv8shUyqRsly/r7iAQWnKWrcY9YgZR4+jLD3Ra09R8005ds?=
 =?us-ascii?Q?c7zN4ecoh+n3CwIbfSO4ot4oDP0KyEuDTPxlVpoEM3IpwBEXWJLaKPOpd3pW?=
 =?us-ascii?Q?bIoQgaaFRHMS57bFUWLHBsZ9jqX/BWBgM+oPZPYosnhJXnYAHQYpyq8cEve6?=
 =?us-ascii?Q?jhlNSUfbYD6bqAHRt06FynkjXIlodTGKLMnoEjZDVlaTXyGb6UP2t8RJ0en4?=
 =?us-ascii?Q?B1Ko/7zr0D0YNynVd3eBJs2Yrcs/s2sFxrz9gNuwCKMKEWUzwzfvRAXEijBi?=
 =?us-ascii?Q?cafOM9CN05TuOKalOYqwfgcsEkR1hVR16vhTVnh+q2lFfW2QLuDDFv3wLsBN?=
 =?us-ascii?Q?jH2LUqGqK/USE0DJY0PHh+DLVwexWx2sgSiArt17nQpc/uG3dSaN1mO6u0xe?=
 =?us-ascii?Q?YLv2c0RXMvZR3Ksad07yyycmOvAAaakaEN8p9YIO69Qnd1BtsjuZTKh3/18V?=
 =?us-ascii?Q?0tw1lNi2RQeEN7JOTqA49TlrrPNfwd5cr0uDjv2txMz0YOIBt/I1bVtBG78M?=
 =?us-ascii?Q?qzthROk5iecQJ7iglPYEpxVmsHQLCaV6m5g8BGic/RPK20s2q5mXkIdmX2jF?=
 =?us-ascii?Q?6nXb1R7Z10YWZL6aBclc9kmsLmLOUiY+QXarqq7KB3Ayn6iwLNmtinVGTlw2?=
 =?us-ascii?Q?GWPS3iwxnhp69Jd4g+exRYyzAcCFpCoNhDNFkirhlY3d3etX03UApRniJUwu?=
 =?us-ascii?Q?N+4Rvj8eaj3Xih/i+oCJ2X7cNMerZg3UfJhWs+Ad4Cj9B0EpC9hCAx9xmkDN?=
 =?us-ascii?Q?oKojLOL7y2bQU5mLknQyqR8CL9cPTRPaP7eFzlPTj+WMw8m+2XbjkYQDbTaH?=
 =?us-ascii?Q?xCj4HfFJUQlJ3B2FyQ6JsjnVehqXKQuXMeU1fLxhmUZJNivh1bPrAtEQ4+mg?=
 =?us-ascii?Q?O7sp2Fec9fqSvvZyRbXexaq9t0U6YfwUu/HQKtq/kWwtS08JwKdI92M4/FV8?=
 =?us-ascii?Q?xgJ53zAc5p+JF8998tXUHRcvSGp9P30ZmT+74gI13i2zQsOSK84sJf+rMUUp?=
 =?us-ascii?Q?opv1w2SyIyqavC1HBJLbPxrJfZEQ/L4S+YQ1BH8qywZZZyhYutAxDWDO/vf/?=
 =?us-ascii?Q?JW7oAva19nZAkgJK3KFPRHm46GX7Z5DRBHoe4vfo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5765437c-09f0-40a9-169a-08da9270aef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 14:36:29.5677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQqEM77rZRodUrzZJplFKQZyVzkf4o2ccYiq0xnsiVyfteUTU9HKud8d9rzQYw+XhsJ5sKWu/E2SybLo3oAzvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Friday, September 9, 2022 2:38 PM
[...]
> Subject: [PATCH net-next 1/2] net: enetc: parameterize port MAC stats to =
also
> cover the pMAC
>=20
> The ENETC has counters for the eMAC and for the pMAC exactly 0x1000
> apart from each other. The driver only contains definitions for PM0,
> the eMAC.
>=20
> Rather than duplicating everything for PM1, modify the register
> definitions such that they take the MAC as argument.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
