Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A244F997F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiDHPbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiDHPbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:31:38 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49D011984A;
        Fri,  8 Apr 2022 08:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fh//Odr+rb3gnzGT1Bof5yhMDRvaPrg/N/GAFi7XYwyM2N8c92MYzxoIHcsrp0z4Fmv2zqkcuFbxXLKUj/6fD2UlsLHwky6965ibJMe6pP8/4VHBmlT/A4kKCf7pRbNlg27vdAZcb8VN36J0QDxjwSHa6jx4PpwL2ntsW33IBgUHwYm4CRjEtpQICGkK7rXoJ9arw46a9usfUuNk5ncKZsNMGdZukkLi9a+ymFtFNi+7yqoqoGQL8jz1rmf6UJUyQbXWK/h4dMrlqLx+I+MnvasYDka8P3xDLsPNrXRgyqAaeivTYLfnKPuJN2Ic/zWm6tMWQfiWDZaX/EuaNqdHWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzDL0DcPthZuGshAiCRn7DUMJvGyuc1xnDEIaO0MNsI=;
 b=JwrJl3kuwMC+3ykF9V1vi/xNvnyM3jrr1iaT///+EE9tU7KejHdf279lLmUGaHI2HUi2GDZGXkPnlgsN5ZECzvq57imcacnZ2xxuY3yz3/ycefFQ+zo6CW44rS20zA0P6tV/TqqudzUCmNEiu/FV5mj6JHzH27Zf5enYJHq143dmXI9Err3TVBLQmXKIpHFy3nL4OrfLnA2Ae3otp8+zj8aC3MwL9zNcUzFks7yWuwIg7EtCFWpm9pSeNgDkJUKISdQzASe3Cpi0Fi4N/CqRGeVdJq5rGurqkh/HxNTik5sjZHUXD/dwcd47qnjJMFP0wKV7Ua9iFW8APTISQMEybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzDL0DcPthZuGshAiCRn7DUMJvGyuc1xnDEIaO0MNsI=;
 b=YYbtZZIqBOeySV08gWd/tafp/YMIYeShqvhx+YE5tIta1N2uspl1Uf6GeL4PuFaQQbnpH136vrkzbBv/w+Be+ObNQtS/0wZ2M46iQhmvbcZQMDLIphXwYcioKUJ52Vmhqgbkrex7hLNl23/W1p3ey1JaQe53NGKs1SvSWgeK/tY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5367.eurprd04.prod.outlook.com (2603:10a6:20b:2a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 15:29:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 15:29:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Thread-Topic: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Thread-Index: AQHYSey/rjYFxWFs6ECKeXXw010xTqzmJwaA
Date:   Fri, 8 Apr 2022 15:29:30 +0000
Message-ID: <20220408152929.4zd2mclusdpazclv@skbuf>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51697461-af0f-4af5-9c38-08da1974935c
x-ms-traffictypediagnostic: AM6PR04MB5367:EE_
x-microsoft-antispam-prvs: <AM6PR04MB53671D6243E3C707C65909AAE0E99@AM6PR04MB5367.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qAkie90bc5v3HAk8y+U6ghykIXqUU57WprTMu0l9l8saNmAHTr0W3oEo9QU6SK6PnZ4mAgPAPl/mA2zTx2iLSM8jkjdqeVaGHIuQpbuSmXvgjEIzcqXNBe6QptTZAoD8JVZq4pr9SFBHkeJlGz5FKXtb6ZEcLQs1vQL6mBQUBaysfSUEQVOtmuFelDDV4etheJ3Sbham5NCEZwOMtR1J2wI6E11pTxsx/pU3N0Qts8aE1ndSdY13+gkOCj/yOyQVzercDumXX45wXpy/WYls6cyLXMi8R+Bvu6lpXv4bdZYSOschUxTuvrscTweiF5XQIMEp3QXxHC9m70IZ7ZYRsfW9A+8yGr8c5vmfbZbKE0jF3/iwzgaw2Qm4/WqVfajTfGX0mQXSDXXLThASSk77ZIi+Bgd6hR5yYlsEh2f4vIeVY2zLYC8wwBqqYtFBwbkQ84Ke+hd6SnSCwUYvYM/Zts52Of/90u2AlyUd2PiKPdPiFtCNHuy0JR28XKLv2wwnzFxHIHt1+CeuI/HNOtlv0xRWH01tHQGdh+9IvZwSE5JHbzBraZhn26aXy1LbCw6qf59nG0ig+nV19BsJNasok+4iJQxSPMnabU5jU2F2iOooMEnzT22XWx/N9QWsAg1kD9Iu1RxFP63gPht2fmZaEL4jm9HEeTgyjQyRM1iCOBMn7F16MzGCXGp3REnxXSuoK0GEiITYPtq2YArfZB5SlmuCwjfTgTXAvJfApRfM3lL25GISojIPmE7YY/ODVLWAM9ion29ZU8gXUan3fpDlfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(6512007)(9686003)(33716001)(122000001)(38100700002)(71200400001)(38070700005)(83380400001)(26005)(186003)(1076003)(44832011)(5660300002)(54906003)(4744005)(8936002)(91956017)(316002)(4326008)(2906002)(76116006)(8676002)(66556008)(66476007)(64756008)(66946007)(66446008)(6486002)(508600001)(110136005)(86362001)(966005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Il9pFvmxkziB5TFuiG4ZFOzac2J+yiiqawD7AsJFqQE4eNdZ+49QXyolO+F?=
 =?us-ascii?Q?spVhWqk7wiqpefXv2esV+Ih9uX16tJPPvt4EXrMY/CcSqfCIn/wtll0XXgcJ?=
 =?us-ascii?Q?GhrLzWivnj2H0xj2Sys3vv0ofshN+9QLLFse/E5rOEObPEZuQFFNj0ZY2hVY?=
 =?us-ascii?Q?GaxpfS9xHdsdWB7ZoItGa+jwdy5S/obWnNen/s2fdEcv87dzPkwtz9x9CZK+?=
 =?us-ascii?Q?5xDDs3PaqOyvveLZEkw2Fo2HV0JTsQMsQiDEe/x/t36v8HdoG39Bcv0NggpX?=
 =?us-ascii?Q?urAWCnOqay3U/+n5WIqORlfGeost1s2M8ioIi5YDl0kxIWNeUd8rcjIU90nt?=
 =?us-ascii?Q?txMbapfWDVL8mPkbbyR3xrx6bqEJe/Bjhaos/IJraNPdjCPv+eQRw2ls6Hss?=
 =?us-ascii?Q?cuwIO4qXDMaWXIBn7wxviBs2JCAhPbFkBGw9FGtuHKkwTNxS01mNrYgQyJOh?=
 =?us-ascii?Q?KsC6SAKxLyBbWJC+4sEEltXzt5/zoJQ31zJNCpPpXxjF9vk+4698dZZFt185?=
 =?us-ascii?Q?AXGMthQG/eDJ31iMtrAoKVmwhA7uluIA7gPIGuUZ++b/orMr40LP/DB2jXNZ?=
 =?us-ascii?Q?CjeGQMUWOdca9YhrLIRCyzkGlZvd98cATwtDj9u8aBJPk+m3I4FF2aKe7Wj6?=
 =?us-ascii?Q?Lg52Ng6yIxwLfLFCGexTuvHWww/tXtgkDIbS1Bap0SdbE5RDm7i9g+inp/wY?=
 =?us-ascii?Q?R/aCz/7qzPm72zhlG4LqyLixAWFd+VFfUSXEK67Lq+uGYGwQqchJ1vOjCKPO?=
 =?us-ascii?Q?AJuht1I7AWZpp1qiwVpq96vSTh0GsYHR3V6XUddezYlGYaQtJYyJ+7hc6KDV?=
 =?us-ascii?Q?WroFhIRwOElla/bxSb+16X8VYdtnNv7cSOPyv9JnNmWakWX6arVN4HWdHCTn?=
 =?us-ascii?Q?c4krQbrl1I1+btk8PuO1cQwodt85pZXbbioAKoTTaitlLhmAsWhANQTmZ5s0?=
 =?us-ascii?Q?eA7AvPBHYCfT0HlfEjzH3UZYQWLF7U4E2OcdLWG6BZF7j5tl2BA4e449GCtp?=
 =?us-ascii?Q?T2w2rYpEqP26DgNKE5B7wAC+dnbspy7YgeksZ1g/jHGdE1wa545oYlG1b7rJ?=
 =?us-ascii?Q?vuNHYdPH03ckqL/kw4tBbjATFuPQmh8qnsEmlP6a7fxDjZAaetgH5mf3o7Zn?=
 =?us-ascii?Q?RNV6ZqwomyyMthcg05mY8K4xKCw9SPCiTjVtyFiFMgxv/RUNEqLvO5ZEB68Z?=
 =?us-ascii?Q?YCajPvDObzM11yUcQh1Al3CpdynKAQRFDV64Adja+A6drZ4EWFepcRUrFmwB?=
 =?us-ascii?Q?kphPm/8f2ECIYnmGzA+2y4vheRTyHM0WQ/EvAFvu6JsKXmnQT0plZIPdCX7t?=
 =?us-ascii?Q?XmA7K/L0Ka2TDF1peAP5VGHFM6TrHYFTAsX41cZ/rYTntJfiw7D18CWrLtqq?=
 =?us-ascii?Q?uHy5YsRz+DRxay+/26e9k9o6ucB4ptcgfT+ETJ/rkQ28I4Z9T61hRQvI+OSp?=
 =?us-ascii?Q?3ddKmQugfUyoKiouJADq5w9myoRBev8R55rmAVDm7sSjt1aWLRyJ5UkhzQB+?=
 =?us-ascii?Q?YlumrOVfykQDd/TPaYjtsgbacYCKnKQ0/hsaeGhbc0zns0nl+ZWOdCIWl0Io?=
 =?us-ascii?Q?Pe9bX8TDAl+GyueCHqHJ1RaLgJyzz6GiGuuHkqC/ov6barQ9Mxmknvhy8haL?=
 =?us-ascii?Q?X5h7KlXSVgmiJEY95wXEe8WOCeigaGwQF2dRyLL9joxHDAUAOun/LkPtvxam?=
 =?us-ascii?Q?T4qdbOVtizsL5iQN7sykzhOtEhF6V/bhjlIFzeCh/nZetMWvbHCYDBmXtIVM?=
 =?us-ascii?Q?myDPMvoXCktJUqgXDcCvahseFWPS7UE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E57B3305739CB049887F83B360133723@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51697461-af0f-4af5-9c38-08da1974935c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 15:29:30.4317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eRi9DZd1fPSfFphB8ZWxX7FKkgII7oNtFFSuSTuszYavs1MtiOzkBxx/pWxg5dlWNtaYM+7+X7ViPfBfsHLRBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg, Sasha,

On Wed, Apr 06, 2022 at 10:29:53PM +0300, Vladimir Oltean wrote:
> As discussed with Willem here:
> https://lore.kernel.org/netdev/CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rK=
MzGgcPc6A@mail.gmail.com/T/
>=20
> the kernel silently doesn't act upon the SOF_TIMESTAMPING_OPT_ID socket
> option in several cases on older kernels, yet user space has no way to
> find out about this, practically resulting in broken functionality.
>=20
> This patch set backports the support towards linux-4.14.y and linux-4.19.=
y,
> which fixes the issue described above by simply making the kernel act
> upon SOF_TIMESTAMPING_OPT_ID as expected.
>=20
> Testing was done with the most recent (not the vintage-correct one)
> kselftest script at:
> tools/testing/selftests/networking/timestamping/txtimestamp.sh
> with the message "OK. All tests passed".

Could you please pick up these backports for "stable"? Thanks.=
