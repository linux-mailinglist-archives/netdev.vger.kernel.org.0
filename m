Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4005B1C12
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIHMBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIHMBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:01:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E556FE2291
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 05:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662638477; x=1694174477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j/yX8TpwgjNrkgTk/muTA9Y3BkQHbhwLm1VdA15O9AA=;
  b=agIC2YIls2Urzk4wy5Kv0oqVNge2M55fBIGsYiQcJ/sLRLqm8OhjAwKq
   MayiNeqedJ710y1tOrszqmFZbYgWmoZfJEJSX/JU5YgIzLh7dvuoj4lyH
   KtqP7+BgHF5Qrp81FkVzQ0G9SDJX/W7ktmPive7Wqsbz0+mpnCwlFrh2G
   KYrig3hhk4DyG3lVAwdZRXstBBglubjI1jC5mSGIjc54p6S5JICmFwI5+
   jiHrZLQpKGNn1NWgFo/UtS4hzl92+VArsNqGgRshUzG2BfunfqHqQ2aeR
   zmOdIJeZtY4Y64XSGXFqPz3zMBqAC858NbHHgYYcp/Jm5MHSmfJ6uR2Fb
   w==;
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="172936922"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 05:01:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 05:01:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 8 Sep 2022 05:01:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWJm6d2iwFm/rHNbjwMcduowzS/IP0hrwhFy0qrvCmFLmlm4/ja3BmUpsYBuYMIebQLxlay3udC6ISrsdj9o9759SEWcxGjbaoaWZsj+ggIDg4jwaF2RHHvDTZJ5tQsaCw2AZek9KfUqQoYd80GFKFBuZp56uo+s3ygubxsAG/PbXtGlymJ6QxZCZIjB8yUkLX7GJFUyUTYnxUG6kJMIPYAZV3DuysxIywQyX1//iaHI8JBZzPz31CtQ3n+M/1PKFYDm3lWtMqjHNfXUf0QmlMHAGq9Uibqn5+oJEvCbcFtyv2fGD6q+0em/o+Q5vj7Yi28uMSn08J4VxfKeMJvVIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/yX8TpwgjNrkgTk/muTA9Y3BkQHbhwLm1VdA15O9AA=;
 b=eTLvMnZuAM2L5HWrNz6SpuS0CuqvK+WHT176fEPY5xrYpSqRW1nQ8CMpUW2rH9PKxtJ6ZHx3Mhs8vs5H+zpFksFxPczn6xxvTXE9RL54SNdlV+kJ/eXqDkOvyIW+gi/8mD01UCCssRyFMhfz86tZu6cdTwxfevYZKvETzZjOlImT8FwHm3hRquLgoJd6ySEUeILZ0ksQQ6lPvsmziodzwt978Smm96dk9t7LoPZ6qYcT5UhqksVmguvasQ1e0vMaMThgGh4uiN8sMIvsRf6txMiTIHH0w3kdAuFx87Kujb/5A0J8CPwxy+cz7Qg6RHkjPUCOSEXrKJK7BgYVPhBQcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/yX8TpwgjNrkgTk/muTA9Y3BkQHbhwLm1VdA15O9AA=;
 b=dBvsQryRAo1uL1Nqv05tN6vz8Yz57G5CBVdM0Iw/8M5wB0nNtJXyfKayISyUPligMrUyuulm6OAXjQMiW5niIChVvfF3PGSYCmPMspiB9QD61AU3TFdDJyU01+M+qyPrIipTTAod7fjRt15YsbXX3xbqbLYZo08jAOKQ2XT1Ph8=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 12:01:03 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53%5]) with mapi id 15.20.5612.012; Thu, 8 Sep 2022
 12:01:02 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <vladimir.oltean@nxp.com>, <Allan.Nielsen@microchip.com>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0AgAeuXgCAAG6mgIAALLAAgAD+2ICAAA56AA==
Date:   Thu, 8 Sep 2022 12:01:02 +0000
Message-ID: <Yxnbnp9dIxG5A+XF@DEN-LT-70577>
References: <87pmgpki9v.fsf@nvidia.com> <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com> <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf> <Yxj5smlnHEMn0sq2@DEN-LT-70577>
 <871qsmf6rk.fsf@nvidia.com>
In-Reply-To: <871qsmf6rk.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|BYAPR11MB3303:EE_
x-ms-office365-filtering-correlation-id: b6b1b1bb-cd1d-42f2-9816-08da9191cd5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nf9N0GSVRilPUgeaUnIE2+g9Vw25FRzCXVTKOCnWToUdjNvrktauMcEtFmaRWTW4IyYgF/yYl3ZFYv0GrlvLJ4bDbZqWP4yGkqgBpdoqsryoNzxcCGaUm2r1ZJBjOSH6eyNvL6XT1zW9dMDz3TyaqmgdLk8gLLpw7sFDw1mViCUOv/zCRSbPeV0JyMrNuiaqZ/9i5XW595edNd/wSC6HvUSsltpEHIbLbwgeucd1Mny37l/Oyk0Sdbv2XpgwcZGGN1iHPOLkLbq72S4wKhXEXq9m/2OvNBUYffejAwCaidxI7us6liU4k2TBCfRF/gSulWTLMAz3F8ZwlsJZteAVzd260Qwt8JnfROHez+g4v8vRVwdkgHktRGS7r/ar5LQEFWLeqtbt+q+BuR8NJqlQF2yk3PW8ZOhO2Cl8d8f3MsSdOx6xyNpvVvYbvynaqCVQAffWrEng3rl2DZd3trORmpAJuAQRZci+bXVtvnN6r0ccVHws79PUDNfHaw1jh9wBOxyaAj+sm03rjf+w0M+cmLlIfrqTtGTC+12y+DiraRPvkVF+KWrFWnlYkzhEam7mYWg4EpTCWTJcap7ZiFwoKwmtES4TKK0Awb77pC2vFfNarFje65Yt/VNfmMaUOm9dzBXNh08U8yReoMfBQsQ16K5Vl8zgaaVsxuQ60/y0zLDwWtM2XziPe4KAXGwU7vpMLREiFR4p2MHpn9OxRheeQkDXlR6vy4fM3H7opFdQudo4qKGZkGyRA9j3rNln1TIJb7ai7xNdsbo2e75yegor9ng8L0NzSu6jKV2aHmWVycjcLJYucPsVRrKB0LPTmn+e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39860400002)(366004)(376002)(346002)(136003)(38070700005)(122000001)(38100700002)(66556008)(66476007)(76116006)(8676002)(4326008)(66946007)(91956017)(66446008)(64756008)(558084003)(86362001)(186003)(6512007)(26005)(6506007)(6486002)(41300700001)(478600001)(966005)(71200400001)(9686003)(6916009)(316002)(33716001)(54906003)(2906002)(8936002)(5660300002)(67856001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FOOgIu15bkImMkZAd95Ns9uOXK0ulxaDzk2ury49/uugf1gRjH9gzP0WVqGE?=
 =?us-ascii?Q?pbx1YmRsnd0IHD3r35C7qfDpKGsqRx8UBKQY3IcCD2nKN5jX6a9wSoUc2THw?=
 =?us-ascii?Q?MAh+qjPmwYxNPh+dL8FDZoq64sLS7tCthB+ocmsOm/5/ykXtlduL5KigEOJ0?=
 =?us-ascii?Q?x3xEDEUtPsOSDiR0OgMqnMRBCZiLHgqs2YKuu4oe6U9uvQoh0hrjaFkHxNW7?=
 =?us-ascii?Q?Qjg4CCSnU9Tk/tHlE2clGz7uA9lnTcc+qJb7lAYH/3TVBf78ZRuA0+Vdjdw7?=
 =?us-ascii?Q?4bIIY8DQHx23itkQ5Vo5KaRaFXtCjoh9Fxyl6D/bwCC7rEfxyC4ajxs4zkaH?=
 =?us-ascii?Q?+TY1RGHyjsGKhebryXQa1vAITTCeRTkRWZqGTS+4MZR3TcxSV7sMR1FpuEd4?=
 =?us-ascii?Q?Z/2vsRbq7v5M1B4MfMgC6aY3yrGEFbuw3lhu0/JmhFKIpF7aAZ/jZCWJmmyh?=
 =?us-ascii?Q?YEBnpce/KJKh3HcvX/GGOPCQEbbmq2s74YW1/MM7tyTd+IN/tNtfN+S4uM7H?=
 =?us-ascii?Q?wZfvTdGfMMBbridwVsEbbKmlyTS1okXVrKdbO7vRwEypPKreyBvIcpSNDejL?=
 =?us-ascii?Q?1ugzfahyuZ6T3T6tIFA5Zq4vJTbNofhM6rOyMz35/T3R28if+K9SFry3pJSX?=
 =?us-ascii?Q?tGd7G9Aoga0B5zMBx79H2yMKlHQDM4/Ngy3g1sRaHlAjpAONvkkf9W1u8CWh?=
 =?us-ascii?Q?shFMIZItopSnwtc7rD7qOCSpS6qRSesVqWxBR2TAG25ZR3kEsMOaAyHTHXeL?=
 =?us-ascii?Q?FsJ0MRICJKdJ6p9HefSK9xOupWN7klXJKyHb8nA5mx1f+soeYVBMNxiavuBe?=
 =?us-ascii?Q?beUGf68+s02DON3yKBuHLIEySW9vG7U3MQto4WfDyM02EyrONXhVHH+gN3Mw?=
 =?us-ascii?Q?64h90659IsQqvg917/TSvo1S+FYk8dW4M//di4TBzOJ5+i3SpIuyd4iu8UI2?=
 =?us-ascii?Q?Ana7gaXimsOEjX0Nw0lU6gNQ3HiHCTe+rPQpE9utM5YkeyLMsJUx+T8LzPKY?=
 =?us-ascii?Q?5SOlvVz7sFErz6T6KI5ufJA4LHgvS+ep4Iuq7DhMKmlg3zx0fGuiy3IddBoE?=
 =?us-ascii?Q?2QEXuu0e7hI/EhrpIXdb5XVuGo3iZ7fRRE4Eu/ceGXtfpCMmI2tSCgxx8ryJ?=
 =?us-ascii?Q?nby4Xw7ewjVISh9V2a7N7tJYuMdjzwCNsrzRapMPXzcGP86ZijnIavcP4Ceq?=
 =?us-ascii?Q?X9C/jG6nT+IHO8vdMcpdOmOi3iQcxasR4o+/SDFInD1hnrGr5lVVpG+3lrs/?=
 =?us-ascii?Q?AShPH5csoIjPBxJlUNbrqLotpnORX24Z2nzxpTdRhxCiAhbas2D150/XGDGP?=
 =?us-ascii?Q?t1B+R2TIe/szFupn11B2w9DCoGGi1qfNEFO6jKdww/dNA3NFffCmXYKkn5Em?=
 =?us-ascii?Q?J5uREphXv3YdYqa89EFQp4xwnzf+TD18Ftn0rBy7QCPwDr8QEIr26MYSjGdV?=
 =?us-ascii?Q?WEsu/8q2cvarQC5WdEUXr67iKzn4s3IsoY+19y2xTeC1Ak8RckHKixEmy/Z3?=
 =?us-ascii?Q?C3rNcyX/QTGJZFLkPHe9MeifcqEOHORneSUuJShjq9UFqOrhgyiQJmA3M+Nc?=
 =?us-ascii?Q?oeuhJFhxVwogWenOLUNLUnjOfn+ZOIwoSOcBKBohU01xT5LwOZD1SGTfsxx7?=
 =?us-ascii?Q?Uc0wmar0ZmduoqrUeMOjXgI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C6954BEEA92574D84A811DB6D20518A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b1b1bb-cd1d-42f2-9816-08da9191cd5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 12:01:02.7873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ln8vEz1q5tL6K1oREi0brYmV8PqmcPtJ6qYyEzSOnim3ec7Y8VoU3/RZzUjkPhkAJEimYshnJLyj77UW2inMG8YcEyGWl7aKqAfmc0pMjEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3303
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI:

RFC patch for the kernel dcbnl side has been posted at:

https://lore.kernel.org/netdev/20220908120442.3069771-1-daniel.machon@micro=
chip.com/T/#t=
