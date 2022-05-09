Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77DC51FF91
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiEIO2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiEIO2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:28:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56181E3EF7
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652106286; x=1683642286;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/2l2g/MrFx55moNfRCcBXkIbFoxABtx4FIskkfWAky8=;
  b=DwuFkDoiSGDyh7W4SZs8QUmxYSdmovGu/pcLL8yyOdjrEu2EP7HEMmO8
   Z0pb5//FINFin2qOqMZfJ/32vi+eV2hpXfToHzOMJuUOGTuZIKEgr/Y52
   Cvy73zsc7SBL4LzPx1pbH/HUDNXlIZSJsaA1Eca/hFsq+MxmKPdHowlbH
   iSYKTO85PBytGrw5sOEKktBl/757ia2wZR5wxT4o73tVRmZ2kNo5Sg28I
   lt9U27ZvUtrR4230yx3dGcKW6wY2HSh9VbtfMZ8sCtdufi+2n53iCT7jV
   wNcfqViSty/o0K8ehHpdp7W7okIPzpgZpcf/G5yoyR2NAOY2aCvaJSCL5
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="172517874"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 07:24:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 9 May 2022 07:24:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 9 May 2022 07:24:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl9BD++2L6OWV4oRwRWRxJwpzl8mL45r0Xxx2hKAuCuhzxD/qGW/vWoneTvKLlwUxRt57BS7qR65Hzi8pWWt18pe9J2rNuwElKXvIl9Cm0eqjr1mjzo+aIs9kmpaPK2ONtCA02z3QbAJosY11EekIBB4V1gpRMI3y/TkMRGOtIbVpampQVTWp7cahSJ76IRFe2kGtCln9QTwED8oBgBTdfMmbdp7fJu/LVuOiRma8p1hcv5xiN9lJ5Auc9m1RgrD8axPjrkEWm5XNrXihys8UZBpceqcSY1eilkHk2Z8x/svhzTlMW5dMIAssrZ2/DRKmIzATBRB3TVSWhxjDOZTbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X+J8JkvkX/ooM0YUdoahPbXyNtgPPYCWOCIkxQkGls=;
 b=FdI8sgUfInOjarzb0L3bFOMo2iPcWw5OMRx2C3S5rAflwTI8dGUkafEs/8WWJB9wTr2dTMiPXnPwH8j3vHunI3vc/YuWuWvwLidgNfyK092DpPh4MtSgllryFIexZpklFUB7pYdHYovqxZhPrGGyvwZ6PWUBPxK1vsL2II6BGm3TKu8+4t9q0+qLueh5I/limVAu33SkR8cPx5VwTimMqhIcg4BOme1qBA/Fox/E+9aspuRsfOUexMCyL+0lNIdCnyh+jGzyjL1cqWI0/QkeisuTPUf38dvkV9nOMdf1BnrvMd50o5DKuNPv4ZlGL/kjRPDmXKvWl70jZvcfQicxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X+J8JkvkX/ooM0YUdoahPbXyNtgPPYCWOCIkxQkGls=;
 b=vR3gmUroPIYTim8JUTC52Yj+NyH5JiW4gKeHEXLhjOLaGWcCS+TPtOlWenEmXROLaFmRpDVnuaeqQra3THkPa2dxf+DwpenKk/F9YRn402RpWY1ZOAlOiawkt4cQ/u2VyeUuPrns5aUBx5SRmQ2WkejUOKAH3/+ud8S/rmcJRhk=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by SN6PR11MB3533.namprd11.prod.outlook.com (2603:10b6:805:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 14:24:44 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 14:24:44 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <kuba@kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Ravi.Hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Topic: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Index: AQHYYKvOScev42KTZkuZEw3AktpFnK0Qq3WAgAHJGICAAPxuAIADI7TwgAABeICAAAgmYA==
Date:   Mon, 9 May 2022 14:24:44 +0000
Message-ID: <CH0PR11MB55611C73D1A6472911151BB98EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
 <20220505181252.32196-3-yuiko.oshino@microchip.com>
 <YnQlicxRi3XXGhCG@lunn.ch> <20220506154513.48f16e24@kernel.org>
 <YnZ4uqB688uAeamL@lunn.ch>
 <CH0PR11MB5561FF8274E9D5771D472C0F8EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
 <YnkcJ73mhI2aoo2h@lunn.ch>
In-Reply-To: <YnkcJ73mhI2aoo2h@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12170916-da62-46ed-e058-08da31c7a9db
x-ms-traffictypediagnostic: SN6PR11MB3533:EE_
x-microsoft-antispam-prvs: <SN6PR11MB35331F83CA93D1EBBC1865DA8EC69@SN6PR11MB3533.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o6cRogokM0tvlwx6pSj3RcZEfOBN2/ePh0vLUoPCjrFru2K0R3MQmj4/SVsZ4napLHB56maSCjZZs9fY4jUI/X9FzyIh5SxHbvSiyBk//JyeQq/AcW9xOnW7elOxK+RU0rmsFXlwWpBtvA5pWMJtKMvJlvJz9y3cD5PuEbj5hfUJkM9RNKM0W3R38EwoskhIS9PUVUUpq95f1Q4uXAhjjuO3e/jTaiy4By6URBPBuiQg72bJ4LtTCxPXRq8N385CO3pla+VyZI6DXEC/nzplHqoJki1BHwNnxJu1gCgrrV9uDqrti4i7q5SNkFDK2N2nLRpdwwwmn1+TRXOAo0ER4bpY+fbx8YADu7YuQVgATBtRK5U+McHQ6lHtFp/DIAPk2AHQ9SfJGxpQ9/BES49N6Jpa9d0gbkC0/VvymrAJY05SuovFOVWfIXASCQCWMOMD3VsewQHasjlKDmsEX+KPJLKIbnPsd2xVJNetOAHc3jgszqbhRkwYdSyiFl46hqXFY387dooybm8Zq9sbGxf5VuoNU1zXoFwFbsftzDbUdbldZaKbhc2L7z9JrLS17WGWMxytVrn8sucYaFqjlORAYchjEZoTjoqc9CFDOfEwUpdGqmKj8WCpApyiNOtVXOW13fCgB2i2XqFyvkaOSE1y8NSPwfACPyi0J7U/20hnILHQjO8c6v5YGLnbVVw2VDhfyFbOXxohvEktnrZAdc3K7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(38100700002)(122000001)(26005)(86362001)(5660300002)(52536014)(83380400001)(8936002)(38070700005)(6506007)(107886003)(66476007)(64756008)(9686003)(508600001)(4744005)(66446008)(66556008)(55016003)(66946007)(316002)(76116006)(4326008)(54906003)(8676002)(71200400001)(6916009)(7696005)(186003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ykaIY+P+2MUfc3TXWflC/KfH8L0xM043vUGJEKGFEYxeoWCbO8Yksp9Z337V?=
 =?us-ascii?Q?np8tbJJAzN7/Tkxu5ysj4vX1eAa5Zew7M55/kBi93/+Ixa9kRsXKl0kGhwGC?=
 =?us-ascii?Q?mTtcYesjDBsBXBOuJeU5X3bn0/B/UWWefRramj1BiFj0hsO9xbPhB3MUkzom?=
 =?us-ascii?Q?awJ9doNZbp2N9bx56PPXQc0mA/PwZ/FIw2vmdOLuSAfE9cQWo3RA5H0BdOlD?=
 =?us-ascii?Q?nPdc+ZU05Qr4aO/csgNiFzKM3ly/LsjW8H11b1CFKMWU0tcyY4dUMH4uSSTG?=
 =?us-ascii?Q?9aqA3lFD/ONFbm/IRLT9JdMtNZExLwMLXu3ZUzhVFZf8XBhelrRSMcQDWgxL?=
 =?us-ascii?Q?Xym8mtuKZo3RHivP4e5xaML+kVRs1xHmSIFNOm1F5ZzyUSOji4jw4DcDELwW?=
 =?us-ascii?Q?hMSnelWnfKQLnT2Oba2J7P9Usy36iwrEx72wSXy1oZ3qPWAo/b9A4wNLh32i?=
 =?us-ascii?Q?KSxRHYbYCL+5phufOae6bP5SkzbAMwBh1QdqVPjsbdVNPb6wvjXMWLc3vcTI?=
 =?us-ascii?Q?JPpwoxkkijYU9Wzc5YFHp+QkES18hMEpEDIJ3Utt9I2WLMxQhb0TVnf8GZaA?=
 =?us-ascii?Q?DYItr+MkP63Mypun+saNlMTuG6v9OzNx0iZTtOUTXcf0VUvz6f8hHw5SaGeI?=
 =?us-ascii?Q?16mD/7ZA1R8DjGf9Q7qcA481UgxTIzNAHk2Nem230vtzWYPEJMMcSKIAOpH2?=
 =?us-ascii?Q?tptM7RxJOZp7Vzud2pYpT/lOH/z5JUoE77RMqEA5kl0HzKvvRX65zOLc/plD?=
 =?us-ascii?Q?0sdtaZI7uv4KPB5nbOt7LQy1eK94R0fNd8nSt+biu4PJlf3QR7pxpqWKTCDR?=
 =?us-ascii?Q?QkBLkxry8/pK6P995Q2xF14186kM9+PDIK4hTYe+XbKz4h9yWj8QnAigSseQ?=
 =?us-ascii?Q?wNxLVk+vgfPfkJEv2R2BkwN1fkFDgeiXBbxrBzZBgqXxMHTg9xNcDHjLOmGN?=
 =?us-ascii?Q?3SodZnB5MXEoFsx3HjmlIC4SBlws7UCJcKEP4XYs5zwprJOqwAX+6CjwLvlj?=
 =?us-ascii?Q?qRPPGxuF60dst+4Ypfji06ejCrs0y1CQ8UyLesWVpaMhc2Ox4BEbcJzP6rDr?=
 =?us-ascii?Q?w8WttkZC20VGhaj8yhgHl1QAnZ8gtfL9fw/SAtzaNN/CwfbpqjvqSM3LGpRX?=
 =?us-ascii?Q?ZMD5cVG6ujqK7yvSZLNvs4+O+sjkjwdFbXE9npvZMakipLn2rz9vIOsXpsOX?=
 =?us-ascii?Q?WCyck/hzO+UN9RPqqNmYD4+fV3hS5nYvozCNGyRFjFI6mYgU5MuNoe7r+BBn?=
 =?us-ascii?Q?nNp0gOc5XKPT1+wi2nUtITcj0rDiUBjcvs3YRZN0fH5qEUcZr/mbXKof6okl?=
 =?us-ascii?Q?c7axbLir8vvWikxJR54kX2rbSVFjDV7jH8HT4UDIMT4km5mULxmEhu1cvP7j?=
 =?us-ascii?Q?ly3DStJRr9fZ83ObP7amZ1DjN/zVrpvcm1Tu+yegKFZR3H9lOIB2oODqKe2v?=
 =?us-ascii?Q?yPBHGI4AoZbjqMoyhF5aqbID6/TNbRT6v9JRw0vvVnjTywy7VKHsveGLNOgj?=
 =?us-ascii?Q?5TRkPkdyIwX3Js7c7lb4ToWzfdSeIs3pyh39WQoWVgPy9A0PAShIZl2WmK4r?=
 =?us-ascii?Q?Vs04zgF/TgKDWuUrTZ+XJpj2FEyB5uRRPi3ZvU7yuVl388V1A3J78c5GCYLh?=
 =?us-ascii?Q?3GuPHL9KzcCx99Kbfngdlp5SO1w/kgrQf2YKa34XIhthmkayJdC8+WgYnps9?=
 =?us-ascii?Q?u1yBTvdilcW7MjXPwG3zoYSlE65c7yIljDB280fN2mqoATUrTfrx6zNy5thc?=
 =?us-ascii?Q?bR6l9spTlbRYAdyZrIMw3emxw5SqqO8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12170916-da62-46ed-e058-08da31c7a9db
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 14:24:44.3890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElkRdK6UlV5mn3y2ix+IWq/v4RyD2gTrr4j50nub2AFEOw6RDZkVO45DXkEvqX1OPjTLmtb5Afm0qyRFptmOhy8F/fg0krOQjwrKUdf+xpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3533
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Monday, May 9, 2022 9:51 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: kuba@kernel.org; Woojung Huh - C21699 <Woojung.Huh@microchip.com>;
>davem@davemloft.net; netdev@vger.kernel.org; Ravi Hegde - C21689
><Ravi.Hegde@microchip.com>; UNGLinuxDriver <UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy suppo=
rt.
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the=
 content is
>safe
>
>> So should I create a new series with the missing comments only rather
>> than doing v5?
>
>Yes please.
>
>    Andrew

May I also fix this missing one tab after the phy_id in smsc.c in the same =
patch?

+	.phy_id	=3D 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	.phy_id_mask	=3D 0xfffffff2,
+
