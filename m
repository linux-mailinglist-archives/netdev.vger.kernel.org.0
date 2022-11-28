Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72F63A473
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiK1JNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiK1JNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:13:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2111.outbound.protection.outlook.com [40.107.7.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1687676;
        Mon, 28 Nov 2022 01:13:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Q8ruBZBCf19MvyQJwsThozH+OAVb9mIizl4MhxE+rEz28pLjssjms3w1jXUy4SCgzvdQuZC/YfLEcKtuvADj4AV7ddkgV9B91ePcDBDFFHeoF1NuHAfCKMkDxQvlqhgqkufw8N19bfS6ylVPZSrOwwdu5UDTMa5dW44//ETA543fnIezHGvHVZp2fF9Fl90vi8YloTE3zSJ1gYG1rFPZNadzyQqKU5m2+nXYoxp4eFBRK7omavZ8Np7PZxF/HQpmYpU/CjN3bKr8WREDCTz3coxXFHcRBHxDMV/RoL3QbEeXv+9NwSyU6BJOQUi7CgrKce8aYsApKEAYgn6KmxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyC1ISNGFyLlFVnxojfWUPdHMhs27VQm0KGMMcs2f6A=;
 b=gXPCz989wNB0xFtCgbgxebMMKLDfZFOyGBtNBVW8ODayhcLY4hNByf2c3eIM7fAM0nORmqZtA5krrvhdrtW56OWjZsgZkLGzzf8oxBW9m2ys+Bon8FoHbyUMqm3xXkpRRq1CsZV6oTwQGJMP4frrnXqCGiiEDBIwQG6bfpgW6zRsIoBFnv8woDihIdfkU405IMBvuy8Q8g9H9SJroojkpT0HYJkpLItqcyFPW7DB08Gth9pxITqsPJRR0Mw4Oj8GgMZ/ksGwBU/rtnnG2FaaDj7i4HFxMHVGikgfbNnOrz8y9wqz2bQTgLFcMTwg7ss4h7lR1+l7UK2QRR6l0SLR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyC1ISNGFyLlFVnxojfWUPdHMhs27VQm0KGMMcs2f6A=;
 b=xHZEvuCiMNflN5HLmci12YkKkspoRNnKNblnb0A+IYs2Zn8e32Oeg7FMU/in/7A08eKEpT6hj90XbHB3sec8gGjhIgwiBqgvppC+YPv31bDez2n+AK0e2Yt6OsuzwC1R5qhVJox3MUDaTnkuUECspYLHIWeQohGGTt/hFGIwcW8=
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::26)
 by DU0P190MB1953.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:3bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 09:13:32 +0000
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a]) by VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a%3]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 09:13:31 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [PATCH] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHZAwigVh8f3ft6pEOKlYsmtLGFeq5UDSTX
Date:   Mon, 28 Nov 2022 09:13:31 +0000
Message-ID: <VI1P190MB031750C809B1682A5605DDCA95139@VI1P190MB0317.EURP190.PROD.OUTLOOK.COM>
References: <20221128090542.1628896-1-vadym.kochan@plvision.eu>
In-Reply-To: <20221128090542.1628896-1-vadym.kochan@plvision.eu>
Accept-Language: uk-UA, en-US
Content-Language: uk-UA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1P190MB0317:EE_|DU0P190MB1953:EE_
x-ms-office365-filtering-correlation-id: 84ad82be-9b5a-4f2b-5d30-08dad120d1ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tjK1xcu8ZGvdVpM5dOqeEpE3bqVwPx5jvIRY3qh5kuGKv3v0Ph+G08MrvIZf5NGVsm/8uKiDdMe0v5xsJ88Q7oHEEv2s6m1yYSYO3ls7JhTfnNRyDrwElinjWnKRS8o5uoXcsDbVnATAEkVmr8BgnUd1VMNCIiyMriu4nf8qvA+/E75BQoPi5AxIWL6hs4N/NKEG16GygmD12WvnTuYbeCWDH0WTSr0mj9eJwctVJEdClpcHS2o1uU0F/h6DDpUsjNQiKwnlcl+knV6OYMYdzpVCX1TvK6kd8IazQ/lkh3tBpv+FzlVEntnq9SwK1inVRpZ/NK7JrT7aNPT0oQ7soti8OIH6ixAZZzRqkkRgVxYKh9H5Dfp6+xy+a2RrEID+d1xop5GrOlD3HlgcY5dALiK8P53VRHghypPuuh3K87wsILWCRUkINd+ER2Rqk6wOZF1fUaq9xKC/hwqHsY9DBlu7rUbX3lgm2CbfSnH8GtxlaHgDM+LjDP+wUh19QPDha/5ODwtZBsWKvc2Ox3gDbvDLcmDcLqaGt7hbnEijxVaKUgAZEjXBGI+lrOqOfGfSDJlypKUdZUJzGpQ28a6RGmxsYbGrr8/ntICVxLRfi+wgQj7VuaWYiwT5zGr2OCB+SIs1o4ohtPbfUcJL9Cn6uxn8a4SViGf7OLyedmrCBYagOq6P8qjDv9ZaXmc8T57UNsFzDsxDcNXrL7VQ3iY3Zqro6us4dGhAmc1ESbyaWgQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0317.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(346002)(376002)(396003)(366004)(451199015)(71200400001)(7696005)(6506007)(966005)(478600001)(66946007)(66476007)(66556008)(4326008)(186003)(91956017)(41300700001)(52536014)(64756008)(76116006)(8676002)(66446008)(26005)(9686003)(316002)(54906003)(110136005)(5660300002)(2906002)(38070700005)(83380400001)(15650500001)(86362001)(55016003)(33656002)(44832011)(122000001)(8936002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?koi8-u?Q?NxstYiAIpCkrrCTiNEvw2xHj5Exr5SDo7SicbHj4ePNcxLKAqk+B1s41Rz+51g?=
 =?koi8-u?Q?nh1OlS1TRtacTw8uG1xFpbjAQRc9pwwn4+Zfj+7csOWeWiumhzfZe08UiBU8aN?=
 =?koi8-u?Q?+JlotFl5MdByyuImjQmj8psfxPN0SYTKBTotajDTPTvsRiD7nmDMC6uznF0mON?=
 =?koi8-u?Q?CgVYdauytpbL+mqRjTSsRc+trdjkGqvtU0V89/JEaLf4uV5ODNA+cNtpb62SMa?=
 =?koi8-u?Q?o1YQkQwJQZCtQM8z574PfR9vQmf+lPMhUEkyc4UiHyeUgmFQo09vLCaXM4RK7c?=
 =?koi8-u?Q?ck1RTKukIeccldHCCyUcVmol727IYchwtbAVQmXDsZfpYvOiLwu43J5quKxo13?=
 =?koi8-u?Q?SlmuXUfeIdW4nCzyHlMYdY+fBbvjg0EoiCrVtoLtVhIzQc0dTqmIb0SNtAAyXZ?=
 =?koi8-u?Q?+9ARS0Z13dAaKcmWJrC0vasiBuMYkxb4DWW1K0uZroL9Q7OSWWYkVEmYNNROnR?=
 =?koi8-u?Q?oNVK1jI/kGptom9sRsX3FDE3/F/P8dwPDD0QFugCRh2gOEWaSHXFHx0MaWvUoJ?=
 =?koi8-u?Q?1lUqZr0zULnZWaXUx7tdl61jNyJCvAQh9K3mi1xYx5qXeiQX6ugG6tsCh5gh35?=
 =?koi8-u?Q?hs48FR0oz9ggrxvLILQ03OsfamG9h25aXiRLHZ7pUGWMnlFvzigi+vxjIg9ITq?=
 =?koi8-u?Q?9ISTrwDo9i+Ki7KyQWVw4ctxP/LcoJGkbd4jPMuClhEs9d/fMZb4kS3reJkvAq?=
 =?koi8-u?Q?iBWpF/8idYxUyukBgMoEs1Jgx/wPL8I4b8z8WqyNJDpuKGx2H2QMN53oNoXlf7?=
 =?koi8-u?Q?LlL6DKdVuBcscvwzDBsOcQ6ImW6rqJW2NLfgb+AoEsoWvISadk7ZDRJMyDdtUV?=
 =?koi8-u?Q?cOUN/w+l1UOGVaR5iIZRYU+j20/OLB433SZIzNSVtUhjr++wQSxWyBP5MHfP4g?=
 =?koi8-u?Q?z8Ji9s9iMrIQnbiQz3Q1YFr8xdHSUga5HeYnpMb2ChofuAyeJWk9EEqRY+mhk9?=
 =?koi8-u?Q?Kwzes7Z/DkMt5ccycJ7OA3LUH5STgNgRzNBYIWuA6qtfem45Oql0FM5UsUUPT/?=
 =?koi8-u?Q?w8HQrh3yRz406colnraYV2437XFuGPLB1dYMSmxECpjFDjjnA4ihSXlmUMLr2p?=
 =?koi8-u?Q?0tRhOzD0NRf3hXclF2F/f+HZ5ug302TDhS4XCHrvR1dKdPOxP8f4TdP1Yk+xdb?=
 =?koi8-u?Q?ntyjQ9/1TvtJkwnTGGNbuEHXpQyJQhHRh3eWAM45I/uwsZJUKEuGoCFqIaY3d2?=
 =?koi8-u?Q?fj9QZEVsfAJ7pivOCWrnfcDy5p69CRQhTUtFt+whu+0sTUVIrFf7JJH9W7MpQk?=
 =?koi8-u?Q?sZaA5UIM7FGxPkFQYl+XNi7S/9cOTt7x2PjaFbJXjr+/fdWV7B1VOC/TtNAizD?=
 =?koi8-u?Q?bX7tvyIItxtKBCxugM7yWtZZlPuNAwyOiN+IFqcIW2pme2oaoODIcQ5PFjLhEh?=
 =?koi8-u?Q?fUJmTfoZs+CCO9Ej3NwpwqaYdHgfeg20bYyeKKAfyfj4pyX/marn2ULYpI4lYy?=
 =?koi8-u?Q?t9CWWCqJ8ERKKT8/o738FRYfe9orLnk3oO2yfHDzjiqBS7qvBwnCMe/tPs6dj9?=
 =?koi8-u?Q?2oEx3S/Q6GFuAN49oor4NhAgfrrptzN5m6Sso1rJ27AxwL+8pH?=
Content-Type: text/plain; charset="koi8-u"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ad82be-9b5a-4f2b-5d30-08dad120d1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:13:31.8366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXQsIu48Nh2xEEwBnEFvJoh1FZBvqCj+AJMbWSWE4FtFNy6cRPXOId0jltsTrGriFwigQnYVzOYt9M7hKv2rvlyPEjKGrs/rDR17Y4l+kyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P190MB1953
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
Sorry will re-send v2 with preserved Taras but with new mail.=0A=
=0A=
________________________________________=0A=
=F7=A6=C4: Vadym Kochan <vadym.kochan@plvision.eu>=0A=
=EE=C1=C4=A6=D3=CC=C1=CE=CF: 28 =CC=C9=D3=D4=CF=D0=C1=C4=C1 2022 =D2. 11:05=
=0A=
=EB=CF=CD=D5: David S. Miller; Jakub Kicinski; Paolo Abeni; netdev@vger.ker=
nel.org=0A=
=EB=CF=D0=A6=D1: Elad Nachman; Mickey Rachamim; Taras Chornyi; linux-kernel=
@vger.kernel.org; Taras Chornyi; Vadym Kochan=0A=
=F4=C5=CD=C1: [PATCH] MAINTAINERS: Update maintainer for Marvell Prestera E=
thernet Switch driver=0A=
=0A=
From: Taras Chornyi <tchornyi@marvell.com>=0A=
=0A=
Put Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.=
=0A=
=0A=
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>=0A=
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>=0A=
---=0A=
 MAINTAINERS | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/MAINTAINERS b/MAINTAINERS=0A=
index 61fe86968111..3da743bb5072 100644=0A=
--- a/MAINTAINERS=0A=
+++ b/MAINTAINERS=0A=
@@ -12366,7 +12366,7 @@ F:      Documentation/networking/device_drivers/eth=
ernet/marvell/octeontx2.rst=0A=
 F:     drivers/net/ethernet/marvell/octeontx2/af/=0A=
=0A=
 MARVELL PRESTERA ETHERNET SWITCH DRIVER=0A=
-M:     Taras Chornyi <tchornyi@marvell.com>=0A=
+M:     Elad Nachman <enachman@marvell.com>=0A=
 S:     Supported=0A=
 W:     https://github.com/Marvell-switching/switchdev-prestera=0A=
 F:     drivers/net/ethernet/marvell/prestera/=0A=
--=0A=
2.25.1=0A=
=0A=
