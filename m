Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1161E5E57F5
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiIVBUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiIVBUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:20:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2127.outbound.protection.outlook.com [40.107.113.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D4D98A4A;
        Wed, 21 Sep 2022 18:20:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1ZsKYuS/iAQueydoxfikP/L+NUzAfq2MxLOY4D2vtiph2RQYGbMme25fFg5hScUyljv9D4tEBbynZWSWdlI9w0JEubk1KaFc27Q7E3wu1J1Xhc7IH/OLZO11IoxQN+kSL/77JyMfFha0CJz2Y+mDKPBri4Ti1QOa1SHVr9nVftdQ4sPzyZA6KM5St3BQARP+1a0RE69EJsvQNw7B5TRmTr6H7DPVgoONZ6WPxDLc40KLF/CIzEb74YUN9DXAqeACGnISCrGGmSj0IXkLKpS9g4pHg7VwAZWCw9fQiZsrlY2+fqrFE8xxyAkOry9r8ChzpOPSutYZ3VZgBrEhDhvWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YluqJe7ReNRKoU2rxwujI3aoIMYvvGpFjm7CItkntx0=;
 b=hLiYBn0PcNeVXPlAf+UACwORf1XbwYuU4ga3uSLOPC7j8o8d25zbJD5sJL4qSe+XhkqHNL5nvVyJablBgjxagL4fO/rfRmOho2kxNNiTQ6jnekYPWHJYemL3OyRw/qJZcE/JEvfQHXuBaQt6mxiTqkvYoTZzdEWPqMNFdBmr+Q2iwT5/tBbS3xLmLOCxywsAIO2olqy20Is43EqOMculTcO2doeokpM/FUzURsr8Tbh4BJXnIXBa0C4Sm2mImu08/5bEG6O+NXKCcQiMM2qxAHpZyduX32w0PIWCDmOu22grn59ML1WbEc069D//cVXTJ/ZJfAQjK+ZRE6E/8Lfl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YluqJe7ReNRKoU2rxwujI3aoIMYvvGpFjm7CItkntx0=;
 b=Vo6q5R9BLKrmaSHxyhVS32hx0uHwaIG8JDKbQHOB7w0SQQcNcBzmO93brsj7SIRWwwWOvLXW5uQMChGGCYnF4SkeiT2aL2oZVzgjXZzZMxBE/e/NngBtLLABa/QcZBCsMjtAPLemWY1yfy/0mHrmugiDqC5OjLIrG7+p9mxs5Z0=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OSZPR01MB7937.jpnprd01.prod.outlook.com
 (2603:1096:604:1b9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 01:20:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 01:20:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Topic: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Index: AQHYzZbyqTwrMjeNqkC6dNbQ2PLk4a3p9OQAgACfZDCAAA+uAIAAAxYg
Date:   Thu, 22 Sep 2022 01:20:25 +0000
Message-ID: <TYBPR01MB534149567C3CF601FC335702D84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
        <20220921074004.43a933fe@kernel.org>
        <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <20220921180640.696efb1a@kernel.org>
In-Reply-To: <20220921180640.696efb1a@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OSZPR01MB7937:EE_
x-ms-office365-filtering-correlation-id: 72ec3385-3dd9-4e01-afca-08da9c38a0d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /k01EtwbCn5aCBaaaIouSpTPTTIKctYkgwpbUfVMJuDdOleIor/nnJPz0YJ1mHwWjXl7GRf6HGlZEbco9wiw7CnoIDd8jAtA8sNB/MeCG+HgYyjII/WsXHl4iMiTDt9miHXveD+D31NdVcdRVRBljvl2zHFBzV4A3hM2RnyDpBZWFBSZR0Hy0nRtdWPzlcEMRl1GHcL2+2q6guMyIPhQaCxosCJn8IQ6uBz5EWctnp/PdHPfwJTDCmO3CVcJPqh9wIOqZ190sqFUeXCrKUstM+L/4Lu1C19/fQQXdGdoo1kcSf/AP+ubpWvlaUzfB9CITyGKr/LPneAV595a2yPI6lIUNNapR723cBi3mbEzvoZzry9S6oc12aGqwPD8lZ0LTGatkDiLaFGXbwbztyNxbzKLtmx32V4ixbARMQgxF+0qfS0ijX3Xr/XwJtU4EQVQNO7WN17aEhdRizzuYorb5DzZq7JL7G2VpNQDw1ooPnecky2TGixUByc00TRmMzjuVh4GZozYdnn6I0Af59SGC+TjaBAfJDVd1rbj6yjFBL9eszjPTVlwP1Ou4d9H3nXSeBWCLWQrzjORmrFW2CQmYbDbLsVXjPZ185+VGAdCdeKCU0L/v03IsdULVKmc9/zNVQ/i7JWjVAkPt+VEREyihCmSv7x9cu2w0KCK3GSOFyUTLLa15rq4SxqnNiuKL7WxWgCrmOQQulIp8RW3P4lRJUTmilAtUGUPPjZmEOX//Pez5CSv991DUadu6PN3ypG7pCOcpWfLQeoQN5hc7cPwFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199015)(55016003)(66476007)(38100700002)(122000001)(64756008)(66946007)(66446008)(54906003)(86362001)(41300700001)(4326008)(8676002)(76116006)(6916009)(66556008)(33656002)(316002)(2906002)(5660300002)(8936002)(52536014)(7416002)(4744005)(186003)(478600001)(71200400001)(7696005)(9686003)(6506007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7trHyodlg/FRZGAtTm5eyHBsOJ5gU5A3VsC478BtDFwQF1toVkRU6n45L8Lt?=
 =?us-ascii?Q?w0HiQyBoULrudLx0EDgOTH7QuQAXxunG3ZaG3fjtSmT3BCzzrHagIxDwO1kF?=
 =?us-ascii?Q?uHVvXjk0EZchnlhBEnLvweXRxEVhn1Y8acXvLjynxy1Guk3VJrFhfS5Q0hEA?=
 =?us-ascii?Q?iVu5iA7apTRaF2stcbkE2csm2r/c88UbaPFsm0eYOSSCuIFjG4BF+wa2+GAG?=
 =?us-ascii?Q?u2aztXt7+y7RnJM9NUvifOytNPZV4r0idgSwkyCfIm12bRZbEaCXSItGEkcv?=
 =?us-ascii?Q?8Zfd9gZs3IdtA80AGwjNGlCpUm+8rt24IJM0+8eXoeMeVBs0amELnzN60xE3?=
 =?us-ascii?Q?oT7PWGL3d8AazopoNIE9hDuRWSWjgSysBAdfr9uqD4mRipwZjD/3ECyjA1Os?=
 =?us-ascii?Q?ql/Vjzh6w4onQkd3rS+VMIJmBWiVMpgAXUm8e9UThdKVExPCL4aqijEF88ZU?=
 =?us-ascii?Q?ZXxFDW2nYHyd6Ic6Quy1c/6lMa1vZoOevaurVtafNm8JWrC1tZTVT+zU4cnF?=
 =?us-ascii?Q?Od2Efig+ev3RWxVkAsKXx25N+5jA9FDiw/o7lOFdj1ZTwpWcptOFVha29Zyb?=
 =?us-ascii?Q?ZpHMFqX81wRLtuj6joJ73M0T/eP86bZs1xckxnpmb0O3NF6gd87GcR3U90EX?=
 =?us-ascii?Q?fJd0jxm+YkaHBBdIcypeBgyfvcuhl2dvLATAuC1pkffA3xqUrQcOl78diOLg?=
 =?us-ascii?Q?LP0FTAwAQdSXWOsEYtfWBM4tcC+fql74jjfd6ervp42QcWNVqBMzaR7+rqSx?=
 =?us-ascii?Q?FKBzkkpzXvABDkhwG3v1a4xU6m0OqFaoGjEBkO7xicHqaQWjA4qCZ2CSoJSf?=
 =?us-ascii?Q?T1B8OhATie0uqLifuD0+dLB6p3PLdQzdKqExuh+PecxQMdiTdRabaISn3l8t?=
 =?us-ascii?Q?7O8DsOrE0qv+65qOMt69SteSkS3QN6VyIFDN0B+1m3IME+xLylk3NfLTMSEi?=
 =?us-ascii?Q?fpfxKsZLR9Ti1476ERdjv7yjlVNzRkcqV4/6pqQxwNWFkjaEfek0awDIIlh8?=
 =?us-ascii?Q?7boJNDQHBki797wWzjeN6dYhqksxVOaWum0tFBC4MXkgTfNJSjFwl9uCO5Kl?=
 =?us-ascii?Q?viWJkirH/X7YXi3Zlt8ZbCKFCZNbWGdRptG6rkihpKYhbHjpy/BydIKISI1i?=
 =?us-ascii?Q?sUN9RVFC5Hbf6FrXquXs4S4t4sN2KF36kRY4j7/ur3QsFZSG8xwxibJZVjV1?=
 =?us-ascii?Q?03p6cXkvLSj7nQorJ5x53U2EmvQxiAN8zB8Gf+zRLLSo7wo0pMRmwtx/tqaz?=
 =?us-ascii?Q?20yCmqQm1seE7RwogfEi9PO1hsHZCUD2HeBEyTIDVj1Cpl53HgIofWGjcXK0?=
 =?us-ascii?Q?QCaHqa/EFiQ/KJ36XOxjAl567/xlHAfn8ILWJB7zCAH0VvlEE0fQp4ZeA/EQ?=
 =?us-ascii?Q?r9qRKE0OTwGIKtyp8PDX2ldWETXHO1V5joT+T5hbc/RRnP5V88FYBj/f7TCL?=
 =?us-ascii?Q?DoG2Srn2LINGTKB6Uvw5CDlD7uv2KIq3VYS5sdxwwH5PO5JLtYuEUIHUIE3m?=
 =?us-ascii?Q?xuVAvqjUgAMsbz4t8h7uabTSGxlkR5WzaBmS1qSBDMUfzNqb2AfILW2LyI0x?=
 =?us-ascii?Q?Sdh3gn7hIKFqw0XS5LxylCf3iBrBH+yJah80F5SMcwR9j4vXfIpQPZUg3Q/Z?=
 =?us-ascii?Q?m/L9BiGhFKJz9bcpsIf0n0tAS/9v/aHMnaX/o1pI56QdLvWfTikMghmiY37Q?=
 =?us-ascii?Q?l3y0Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ec3385-3dd9-4e01-afca-08da9c38a0d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 01:20:25.5985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDPt1FT+eGNIMmw21Bv2W7C4V7vdRYC34bZClxqX7g8kASsQYmMHExfsOjWnHMJEYeYlPRn5qRWtLXuM4AvYuVRfx/5V2ShD3C3eBa7Fkz4Ahu/QDiITmqInawdsZXud
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7937
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for your reply!

> From: Jakub Kicinski, Sent: Thursday, September 22, 2022 10:07 AM
>=20
> On Thu, 22 Sep 2022 00:46:34 +0000 Yoshihiro Shimoda wrote:
> > I thought we have 2 types about the use of the treewide:
> > 1) Completely depends on multiple subsystems and/or
> >    change multiple subsystems in a patch.
> > 2) Convenient for review.
> >
> > This patch series type is the 2) above. However, should I use
> > treewide for the 1) only?
>=20
> I thought "treewide" means you're changing something across the tree.
> If you want to get a new platform reviewed I'd just post the patches
> as RFC without any prefix in the subject. But I could be wrong.

Using RFC is reasonable, I think. I'll use this at next time. Thanks!

> My main point (which I did a pretty poor job of actually making)
> was that for the networking driver to be merged it needs to get
> posted separately.

I'll separate patches for the networking driver on v3 patch.

Best regards,
Yoshihiro Shimoda

