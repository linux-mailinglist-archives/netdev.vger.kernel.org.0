Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD391FEF3E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFRKEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:04:11 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:41682
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728361AbgFRKEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 06:04:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZIFW1QFvyT3aqrrx7Qktzde6E9OhxFd04qL4LFX+B8rCZJXj8iMwmx/lZw/hYZnV50nj1uoqghsk31GpPKtgLDGXe/Uj9+6jU5oP5AlpPdjsfkpr34Mq99kczU9ZCLLDxUMq9mI8149m++Nds4Gl6PGDCjsNIcVRz8/qYxb9iM3FJ3lwQdMGvZ5ecOXeNZ8kwUfG5WsXAg+1bX5c9KSzwlwtFSFpQJ9tVV9un/XnXNVuWSuAj566cij3JrtGKf/Q930QWuLp+vlIlhcj8vI+Y9esbUBhbQiCw95AfKtJ2mnPMgV2hlzxxsBYktwpn3Rndm/Sec3Z59wYXS7eOlfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISdBk5NehdJqXzzakqohnN7YMDtwJt3j+om3TphjJjg=;
 b=Sf1KV7N/swAHXAzVE9ehUBPmv1K4zKylSvI4REE5nPWA7oM48aTelH49Q9hq241NNpSFGhI0TlcVEn2CnCkLoE+sprqKX2vztNbCbNQPzuARf2a0gX7Cy63sWE0ALGtxBmd6Apng9dtTO+T4ytdd074Cybn7uYHgIfO987UBl4CKEA/l7ruXHDnyoBYUeHZ9oSZi/4f9z41WwpcVYAYV6Df7oZ8zlun6GU24saHeyaPWUKb9W8u2vjTsEHry036TYs/A4Wev2mpjj9aMouxDhdZ9sFvFH7t2c8MtGNyCcZPKswo7T7q6O6gm1P2CzxQr0D2ryBVSZaaDbFHY7SmCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISdBk5NehdJqXzzakqohnN7YMDtwJt3j+om3TphjJjg=;
 b=S2jdLKn3Gf1el9Ze67DqZnPLvxvwhg7ebkxkoVyIkhHwGbFJJlfqUsdlclBpDRmmkb/KMyeq2yXYwXSNP/KaXrSZ0eIY6Sjfpz/lgURPncywA08RFsiMexgL3O8jlTDHUnQJ8mFJnh01E8WpNMX9L7sx7EkP7Sd1m/S+MBL3log=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4481.eurprd04.prod.outlook.com (2603:10a6:208:70::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Thu, 18 Jun
 2020 10:04:04 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::cd55:fe92:2c43:63eb]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::cd55:fe92:2c43:63eb%6]) with mapi id 15.20.3088.029; Thu, 18 Jun 2020
 10:04:04 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: RE: [PATCH][next] enetc: Use struct_size() helper in kzalloc()
Thread-Topic: [PATCH][next] enetc: Use struct_size() helper in kzalloc()
Thread-Index: AQHWRNfSjLh15xR7Hku9D+4C2bLGL6jeJWxw
Date:   Thu, 18 Jun 2020 10:04:04 +0000
Message-ID: <AM0PR04MB6754FC0BE106F42DA7DDBF78969B0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20200617185317.GA623@embeddedor>
In-Reply-To: <20200617185317.GA623@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80607d0a-099c-41c2-a16a-08d8136eeebe
x-ms-traffictypediagnostic: AM0PR04MB4481:
x-microsoft-antispam-prvs: <AM0PR04MB448135CE5F8E048A03C40414969B0@AM0PR04MB4481.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gDM6OJEEZiseLQjd8id3iD59vmbNa4opdKEZnSQSQE5GHK2qcju8GjC/4VDrqQ03sfjCrpS/CH+ucG6opwmDRaqC0SMD0VGqHXLtmDZ+GIZHlBwEuGdGOYfj8iLzSYZTKSeKXOVHkcIDS1gVYya7Cq6oBkk+r5JnN3K26grlNiR6W5i1zjZpNnyIe55aG2TGBLu/67wfFFPSpc3avi/HUGW6YKPRDCY2n5SYj56qz9pYao6FIzyX31+W8npM6x3nWE8EksN9AauahR5CTjdzTrnS7X+KIMGjsY4dnjF1uDEGi8jVMQfBVzj6E3NMfZRKv6AK5dIoURXq68M48HJ4LQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(52536014)(71200400001)(76116006)(5660300002)(83380400001)(86362001)(7696005)(478600001)(8936002)(64756008)(4744005)(66476007)(54906003)(66556008)(66446008)(6506007)(316002)(110136005)(66946007)(33656002)(186003)(9686003)(26005)(2906002)(4326008)(8676002)(44832011)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ypXVCGly7PzkhwhU+jv5vsZo0A27GyVsH2Kf/oMEJSL7Bk2RAfPMUQzoBRL7IhasiWRX3WKUh7vlDcNRuggkuLgC2q2UL6rsQufNZsLbom6UyCoTkAB0Wkfnh8ylRKZGICuV/H7zI2ft6fAayLWlf5VB/t9us+AkEOlyR59XWhUbesF/AK90gQb8QdgUaCc1i6eCiiYOxZ4pupph+yTEMJas3jv0B2yc7RySE9/cjsEH1nipxpRBCNPCIVeqRoJDSmLH8hNN6FFAYeITdBvIrClSgjawpNTcnHKNVt9zNI6UKdNwo8diUPJPWjOE+NuEJP9gGtUJ/pef1IwqK5xu3/jsR/nLBUEh1c69jKVTwORmbDSZTsoakc2CVQTbNGsr8PYoAqnNTKeEb6DYHuZ3AVlF8s72f2bdpSpFAsNtppSPgnasCrb5loqXowBjPYIGlapWX5p4WddIaibIU4JN++YoGmUqvT9pIR5ymHzyLmQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80607d0a-099c-41c2-a16a-08d8136eeebe
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 10:04:04.4556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vI8YqMTQRRKPKbzZ90TPfPzlNROM9wVu3x+DNOa30V8zqfB1BqHiYNA0ldkDg7riBsOmjI4JK5qExJ4M0G2EoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4481
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Gustavo A. R. Silva <gustavoars@kernel.org>
>Sent: Wednesday, June 17, 2020 9:53 PM
[...]
>Subject: [PATCH][next] enetc: Use struct_size() helper in kzalloc()
>
>Make use of the struct_size() helper instead of an open-coded version
>in order to avoid any potential type mistakes.
>
>This code was detected with the help of Coccinelle and, audited and
>fixed manually.
>
>Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
