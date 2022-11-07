Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0030461E858
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 02:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiKGBik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 20:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiKGBii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 20:38:38 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2134.outbound.protection.outlook.com [40.107.113.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20965A8;
        Sun,  6 Nov 2022 17:38:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcpWPyHRZPynpmLtKQG6hxypcdja2dgdNZB1IMOKX/Y3aqpIZKXWxsn/53KZJmSp/JU9oXHOg4XMfdokQJ0ymu58DR053kxjZjjLFOCsxrx+hcCzeJGdELPry0gIHbjMMrdktqY17uF+aOgBQGco0RG21gwdOTHJDo7QAwH6T8XYQsbl9VLJ0tKxDbU0BhO20fJ6tX56lvagsThedvUApQ/N2kdTn1VRLUsI5Md0jUI+PpdWLlDvZxs7VG44Uq38mWGdk4+OOLohtamaLSOk1F3EJgRjGzUjxuCd9vRGP9tXF3sJlQaGZi80qmGvaoMfmg5W3j5iaXM/SrK27pp0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbLz5NceAtgUl8cpSd9dgBfxtNGSJj2IHnwIkwieY4o=;
 b=G9U/IPXh2eZEPBPWZ7YD5im+Ce6FNSmCokUziaFnRWmMBx5xAPuWhA7eNnu9Y58zuCMyyqDi6If2ydwszHx426Szp+tWVXfL/J3G77pvHlHoRs7SHCNc8hFmsCmCBKk/B0zU9DE9l7Hf4oLkTrKaCTALKEZm7QCAa+MKpr8ToBeZb7XdSTiRSDZzypZhAb22igzIYxnmTSfndFkUmfQ99HYGMJURTdt9GUqnCUxRilzGXvoI5ofVEs9cC4OeMbg0bMmElWSYdbT2RJUI7jwMtXXNTdgHgVD6CZrzG3aWAzIibxAihnPZvWZ4e/3AXjESyTT+ZtKmTCNPrJ2Zqm0zRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbLz5NceAtgUl8cpSd9dgBfxtNGSJj2IHnwIkwieY4o=;
 b=dNyxOBO0Io6GcpKGf9iaGzcLREYPDiIAnX3G1+IAo6wiijax4WXd6Ro+ayZQPk8AtuXdj1RcVkv+MCqfLeSk8nHhbVw2qf9NqU+U4kQIkgj6Y9wh1q8M/f1gHOB9H9wrrtyj6pH2OHKGFnRMDzxYQntSzASEXoLefCjKyhoYl4s=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10018.jpnprd01.prod.outlook.com
 (2603:1096:400:1e2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 01:38:33 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%9]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 01:38:33 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     coverity-bot <keescook@chromium.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: Coverity: rswitch_gwca_queue_alloc_skb(): Control flow issues
Thread-Topic: Coverity: rswitch_gwca_queue_alloc_skb(): Control flow issues
Thread-Index: AQHY8IPHt28QOrskV0CLeS7WksgRGK4ysbyg
Date:   Mon, 7 Nov 2022 01:38:33 +0000
Message-ID: <TYBPR01MB534103DBA4A6AA19EB26E2ABD83C9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <202211041229.F3B37C03@keescook>
In-Reply-To: <202211041229.F3B37C03@keescook>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10018:EE_
x-ms-office365-filtering-correlation-id: d42daf38-3689-4f4b-8764-08dac060c83c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rc4vbEO9Q443A6CRQNltbAO84JZp0cRENoTAMcK073T2PvSJQdsN+qaiJKa8h6NoKeZHsYSj/ja5qgyvlGHvNraXp/2zs5ltOXOx3X5XSBJD1KOeqTPrzbH384RPtrrjQmGRJ2P1L+d173yvCaRkV/cTG/7nZPvbVN4Wjbq2MWUComaGKZszDG8s2eN86mcTRs96jNV6w1AkwT1lbFRGhjN4ii1nikbvmVfFRhmTr1u43UjmS+fpvoIn+OaQ63UJIXr39Xmq9YP15zIOtbWMeNpWbs43NWzcyeV+PUOzfAXOcL5rz0p9zGbp2w0Z64XDci45TDfJUtRH0gb1TurBvvSORi69WljovJST1KsOoFsg+m5ZOvYTMDwenXU23rpeFNmpg+3Mi+ObeWDGHUxN66tL3DIPLxmYd6cjrJr2NBheis8GyobG7wgB+Dj3lO2HEWuWjy3Igw2DIBTknkDg4QeU16lA+jBEFbED5UishC99h+LanZPRxLkN+1gBGVqonX8SbWVxlO9HrLA0kQRGe3NGF42EltuxyMD8zgNto1iiKFWY2yO2PTlFjKfM+j60gxzs5zZkXOEbFjoi5i+3mnij+D3ltuGy/SLbRkLskLuyZgOKbd/MKxr5Fy1VmHor/BYvXsfL5XudX3cBwcheBv6+Jc4YEy9iEW76MITxXag/krcATFcjPlX8GAmmshBGF8fGTD4+MEcWfhjYAN12SUlHY6f9LarfuNsU1DKwL5VC0KWt3mgpBo+hNO9CoLzGGb6FlzSEzcXiBmZ95VbHPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199015)(2906002)(66446008)(66556008)(66476007)(66946007)(76116006)(64756008)(8676002)(4326008)(83380400001)(7696005)(6506007)(55016003)(478600001)(71200400001)(86362001)(38070700005)(186003)(316002)(33656002)(6916009)(54906003)(5660300002)(8936002)(7416002)(38100700002)(122000001)(9686003)(52536014)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YH8xzzutmuQ1XxMy5DxhuP95GLT2QDksfvrp+AduhQtciYgHh5K6OFveEt5a?=
 =?us-ascii?Q?8f146nimHsCtGmdi8tbCeNvagcdFgfHc3bCVWqXcCZ4ZapI44bkvgbjC+3xE?=
 =?us-ascii?Q?OqVzV5wIncwoB5K/4KmqeZgG/GUgavgA1ZyxADcg3Ujb6JrufWzquvcQ/R4t?=
 =?us-ascii?Q?Th58I2+YQy4LQneGurhJ3teXLBvVsXYheSBrRkQKntXuZw8Pjfnm/xjskNAR?=
 =?us-ascii?Q?YN3n99ggIi+dffL7g92toRUB2cf/0ukScnNfEErgbe5juS2jvQHjZnyr5HAW?=
 =?us-ascii?Q?MiJA+iyfLLLBKTvXK6dJ6H9BhTDt9OwRrad/EASS4ph+5bDPuPZPirnuktEM?=
 =?us-ascii?Q?u0V8d0U9e2NulVblLBwynF06F/vn7xhQnBsIa8fnM8KdEZk8MHL0+ADkBqOb?=
 =?us-ascii?Q?BBR5tTepmgNwxoRE+GFOkizkFBLvrpN4tLP7nbJFQwnB2DfQvevJjw/izR5b?=
 =?us-ascii?Q?szL8/aPvmYsXlyt+oph4WMg2N4JIUkBAONT5PInxk6djwVaLHjVJnBsSYuw5?=
 =?us-ascii?Q?ksgFV9yTrI4UiAzthsx0UWuvY8GlQwTsGbQE3M/1i/xDAmNbfR/ON436lmwQ?=
 =?us-ascii?Q?f1DZvBokQlHAhUw+p8QnN0Dwnqi12Tc+1JRUJI74CbsT4iuSYzWodGd1MLVK?=
 =?us-ascii?Q?QzhUVMtdztARBSdRW7asCqlEapWAJk1l2g2oIm5tKWRq4y3clGyHliy934YK?=
 =?us-ascii?Q?rAbTuHTYkihJANpBaE34dhYm/a0JzNT/63kfyRgO54Hg0+mXnPr5oeDhpFLl?=
 =?us-ascii?Q?j0rCtQon4c5RtBybfPnWL07am56z4i+gXdP+5lWcWTFYVvLc8RcMpa7SnubW?=
 =?us-ascii?Q?y7tPlcIURvgasyfbbhsQ7lintaTXc5yjWZLMp06yj3AxwCPDmGxlmValCp4m?=
 =?us-ascii?Q?dJizs65gSMn3Ew1SYg2sr+1VAkG9HuhZBbbVLDHstQ60DoWQbU8BAI79pADv?=
 =?us-ascii?Q?oDWnSX+MF0PP3BiO1pM74SfNGKEttsWrHf5Gl0W4IodJm14em4ztUtdMU3qd?=
 =?us-ascii?Q?RgvkTz4YUaXvfowXp7YycAzQaZ04+xU4T0Zliob1Wv5jb0ek0PiHTQ3zI7Rs?=
 =?us-ascii?Q?uSFhT0mPQBJ+47qrDwf8Ts+AR1Fnnj75SOZBJ5847Lp4RKwvnNCwg/r2KJhJ?=
 =?us-ascii?Q?W/R8WlDItIdlxANyd0vE/zYhljlMZoOz9DfVPMcjJT9ntsFKVA+epmIJSIUO?=
 =?us-ascii?Q?/ArOSqHvXE/kdTKewsOCwH3rdfHBZQ2QLsDlRRNi7uKenL5/zBHsusyncodv?=
 =?us-ascii?Q?yYhf9ihNuEFXF2iQsUz63tjHwgdBIV7a8rPCesgNRo6r1QUVIx0hR2Eu8Uin?=
 =?us-ascii?Q?6GeWNGXccsMSdRmwiPrwAJI15oyfL1kTsaqAsMnvESsyX1s4BX7oAy/NfnCO?=
 =?us-ascii?Q?5ObGqOQxdSv285xbDAAOcgLvgXqa/L9HEuAPo9B4blR0Zo6FqhRxqnOL4aqz?=
 =?us-ascii?Q?7T8MWGSdH99wiGOwcspVSorMdUuLVpY2SMq9J9acrSM/1t9KKXestR9g1nJj?=
 =?us-ascii?Q?28/5XhJNkQHUx7luDtatLcUvGlTs3EMBUvuACDui3iCJ7FTnDyFWVXzTGd9u?=
 =?us-ascii?Q?QO9F3z9pADitqpPkNp8QC5/pkoK7InYGNCbFYa/sh8Ylc3SWgTjHKov+D3mH?=
 =?us-ascii?Q?KRusu/sAZbq4E5GulgFNgonDrJm44ki7AVavfzHB3JbyMj5VHmP6APXICJFX?=
 =?us-ascii?Q?J/9NPQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d42daf38-3689-4f4b-8764-08dac060c83c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 01:38:33.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qh7uEm5KKgbFnNlipHMH9T/xKBx12Cc2PVXW/jVXZZUB4GIHThXbbNhl1dvZSoi11u+OvxjUvNNMWWeDiza028V2BjDaR6QobGJlN1RQXBmmgdYTZLYk6WfeMU8yRXvD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10018
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

> From: coverity-bot, Sent: Saturday, November 5, 2022 4:30 AM
>=20
> Hello!
>=20
> This is an experimental semi-automated report about issues detected by
> Coverity from a scan of next-20221104 as part of the linux-next scan proj=
ect:
<snip>
>=20
> You're getting this email because you were associated with the identified
> lines of code (noted below) that were touched by commits:
>=20
>   Wed Nov 2 12:38:53 2022 +0000
>     3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Swit=
ch"")
>=20
> Coverity reported the following:
>=20
> *** CID 1527147:  Control flow issues  (NO_EFFECT)
> drivers/net/ethernet/renesas/rswitch.c:270 in rswitch_gwca_queue_alloc_sk=
b()
> 264     			goto err;
> 265     	}
> 266
> 267     	return 0;
> 268
> 269     err:
> vvv     CID 1527147:  Control flow issues  (NO_EFFECT)
> vvv     This greater-than-or-equal-to-zero comparison of an unsigned valu=
e is always true. "i >=3D 0U".
> 270     	for (i--; i >=3D 0; i--) {
> 271     		index =3D (i + start_index) % gq->ring_size;
> 272     		dev_kfree_skb(gq->skbs[index]);
> 273     		gq->skbs[index] =3D NULL;
> 274     	}
> 275
>=20
> If this is a false positive, please let us know so we can mark it as
> such, or teach the Coverity rules to be smarter. If not, please make
> sure fixes get into linux-next. :) For patches fixing this, please
> include these lines (but double-check the "Fixes" first):

Thank you for the report! I should fix the driver.=20
I also realized that rswitch_gwca_queue_ts_fill() has the same issue.

Best regards,
Yoshihiro Shimoda

> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1527147 ("Control flow issues")
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet S=
witch"")
>=20
> Thanks for your attention!
>=20
> --
> Coverity-bot
