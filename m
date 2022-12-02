Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A8264093F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLBPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiLBPXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:23:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD09A1C2B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669994580; x=1701530580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQw8bkiHfNxZ+1IT1d7j3nQfglDtEUghTFrVrjwjTyc=;
  b=IYqcwh6C4fh6RMxuEwDYJ3ZCLYSXfwuHQZ0qof0S0byONHzPvsmwSCfS
   AJpNpkVl1HASlF3yzc4i+Bf+ozxA1yI3hJ1vAt25HYh+TkyGCo6FTgvZK
   TDLS/YRwN7NVnPcDXU/dNswwsU360LBKGN7Xpn3Gx60zbuBcy0VQnB33r
   qgZimagUuGuRAySs0yc5QTDWQ1qUifzSE1LStr29sAU9wmLK+y8gqTGe+
   ksGmhgrNDGOna7vYFhj3DCmciC3rLIsVviuH75Ya6W4D5O7xtrvdNruaZ
   9QoOUZhEE14VVYvfdG8eB/IXbcrGgc0q7+OFXwki9RsUKuTCyIr5PyZgt
   g==;
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="186272413"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 08:22:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 08:22:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 08:22:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FME3JFvlULv6ab+ny+/xxp3IU124QKJrBt7MB5WYfY78dzwh4fWyE6CWE1QD+T/0ZWmq4acFpITFIhsuI9BlwGC7D3fPJCaDcIfoWWPISRvGjg9kxYUvEo688MYrAr3zgoBr8pctzF7m59qibFllFZe7Gkp0RlUPFzf/p0eOWYn+ywFUpbfVyD3szdyS5v0B56Ww53bwIDU8rygteL/KXD2ytb3WhqIJeQzU3Q7HtkEFDurFYHON7Q77dD8M6AtJ3xFS8IwnQwYsgMMJlG/FsGVOZMUYDIcZSUx9lYkL4WqLRebAObr2qhe739cdiz7s9quHQk3D9t/Y37m3VdeYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93sNKhgmyniaKTgN/nAYBE0MfZs8812zUf05cS2EVOk=;
 b=N4oeyG/xN3JHsXxEllNqpA/n0RXRzHSCQmIXuX8klHhMuoaX/w/Dbc8nuPfjKh6h6nLfiosjhs4AbUngJ7eSBhMdPjbDKL++Gza3I7gYOVe6GPyzzDytuXVOalATeMBvPFzgnKHs7knf5nFz+P4jiE7stpHJdbuhVA4Z2cYkY/+3vTIrF4UQD6Rx4JdEK99oG4qde5NWT/ImMeWPecfRmJluMze9B2/ylcCvLB+Z4VOjQy3agmbkBAbLA3Z1yCpvqqTsvddE4NVsq+DbyLs3yBc5PeQxhbtTSGO6VTMb5RFtqYTBeXI94cZGWKqrD+Rz6ZLS2FGM+k+/lANWgMlNIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93sNKhgmyniaKTgN/nAYBE0MfZs8812zUf05cS2EVOk=;
 b=cFRmPN99emavefmyxVfBB4vB7/4NfwHzLY61B3m1H6YjDFKZzt3y4hyr51VVTKQ6Rh5Kyn1f3TpYK8UQwAcMyOGTYi3XQX64UexIQ7vO1f6H5AfsEkxem0f3MPB1+TJGPn69z00lHdW/XB7moVgVJsbCY2xE2yI8aL506dpG+dE=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SA3PR11MB7525.namprd11.prod.outlook.com (2603:10b6:806:31a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 15:22:55 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 15:22:55 +0000
From:   <Jerry.Ray@microchip.com>
To:     <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZBPd7JcFTQQToA0qvxVT5rs7YJ65X8puAgAFEzcCAAAdwgIABes2w
Date:   Fri, 2 Dec 2022 15:22:55 +0000
Message-ID: <MWHPR11MB169342D6B1CC71B8805A741AEF179@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
        <20221130205651.4kgh7dpqp72ywbuq@skbuf>
        <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221201084559.5ac2f1e6@kernel.org>
In-Reply-To: <20221201084559.5ac2f1e6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SA3PR11MB7525:EE_
x-ms-office365-filtering-correlation-id: 99c50995-cf1e-42b3-10fb-08dad4791660
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0gmEj/5ZWxVqwvTc4/xv0C13O3Mo4bN1xaoILppkXp+/7zG/FFL+TfGuHd3EVWA3cUBws+y9gFBShM9Aa9f5JKo3OOoYjoW3aPCnT1NQWvcAijMZS45aP/3iGywfTfVwNk93E605Uf5UeMgjQ03d14mHJbUIZ27Ix6GGv6fLHsPzGBpSobh3Vy7IGmPT7QxJlKHatR4a+OnEL9cl+nWREUHsjb+KJcQ8WrX5ErABreEA7tlB5MVQjmeaeUat9wf0iLYNm1cnk0SvW+keTLw89KPcpZqQE6LlXX2bu4kq2ZMsCFPIbccFnWwEMugjCxbcrZNBAZNUqSSu2OExooCreosv8wxc9EQYPvjl+qunMChC4RPdeqt8UyDdtAbVjBz2SoPHr7N+CS1P8sQ5lng/vsOJrKP7Z/vG94v079QhMdJ/DN8oMf3uDxYlGt4fr2gTu0FPbR6kG7e6z/ICxGEM9M02iy6tn5wpMqlqxAYXu6yiWYbgyhFTvtD4FUtMEUTNH8jfvTFfDPM0QTZ8adHDB1ZVprzhTawq26EzT7sB0jh307RSTbUTlVygkhP6J31tBOTdYSJg0gJWjGT+PiJvueYXoSoDGfHnGTAOXrKO7qrhP4dy7yMm3o99dPP5YBW7fSY2VXILXCJzQyUbU/xQDl5sgxmvtUqge+6GvFtRQoHas1V+VJzcO0fjzc2WyIGkWw0cHEusDDVrH2iWcHx2Dg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199015)(55016003)(54906003)(6916009)(122000001)(316002)(66556008)(8936002)(52536014)(2906002)(4744005)(5660300002)(41300700001)(4326008)(76116006)(8676002)(186003)(33656002)(66476007)(66446008)(66946007)(64756008)(38100700002)(83380400001)(38070700005)(478600001)(86362001)(7696005)(26005)(71200400001)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/JK/JI1lqFJdjjdhIHsxplmbxhTcmr4us+coiQ1oYftWVF7kUXcfL77yYIZ4?=
 =?us-ascii?Q?EmSzA44akfyAq8BLAy2qS6MO3nbu4a+mQDkV2UQJhNoL1YaFIUQp9/3/Bgr9?=
 =?us-ascii?Q?tzHfGJy/twsSGCpzNDKf7oY9sWamfah3ybI+DFsUPGTK+ri6Lw+6/MLIhkBI?=
 =?us-ascii?Q?oOnnl2HyG+flOk7ggLtD8QrCKe2zVNFwzf/YF2bhdM/Q3HEY4W1xwv9iZ0FE?=
 =?us-ascii?Q?TgDsdMPWdN+nEfFutlFoSdJYfMB11/fbNQb4qrn7XHEAGMbwMkkTc7c8vewp?=
 =?us-ascii?Q?qzPPZS+h5idpKwQJnuTgKt+0K952JmV9uIZpStENlD5RuTVs7BWP1S0S84UA?=
 =?us-ascii?Q?4gNnFNHFW2VSVBRuOoNMVI8W7Upc02BC/8DP83OxrRwfdsNpXeRR8/Q3DbHF?=
 =?us-ascii?Q?c8O8YCBcNHHwOjEvW8+iNHFjrdsVdCj25v/f3z4ufETGI5PW6lpUXS13lPGF?=
 =?us-ascii?Q?e+R9Puc570gBR1FTlP+xVD0+5Fl5e2sIr7+4o48X5+H4HaQuL4vJhOyagWnd?=
 =?us-ascii?Q?O3FBt4oNyOGwXLTrOR0bxp7Oa3GLEGUBIp44z84Zy0szb2FxuqlrAwDojAlw?=
 =?us-ascii?Q?paiM1UW+UoXtsWihHl2+R+KIJs5H6kn3Wug/f0qeOlIkd4L7JcPKqbfYQRTQ?=
 =?us-ascii?Q?/BWG4Kc1LdpBBwwmTAF9wYBdefxIQOdo0fyM884d5WiipA5KNI785tIwdl4/?=
 =?us-ascii?Q?I+HBw9DJUF3akl2V3lcWsDq/GoaABNTDw/2mlietm2KpnKta4UqkCBqpiAbe?=
 =?us-ascii?Q?VzF/D4sn6iwp2jijhcwXtbHA4Kx2PJ+BwbM+4gcxy28gcPFbtF3DIR+aMnEd?=
 =?us-ascii?Q?LDtDrKg2yrEFoxjX92PsMCmT50A3M7deTv9wX+k9Cr5EaA1BbppfrxQdurHB?=
 =?us-ascii?Q?xpuIUX2H9i6V5F77g3R68b1qZ9VAUagtlrqIKPoUXSQPKl1Hvo57+UjAGeIo?=
 =?us-ascii?Q?kZd+QLZV3uEpQX6/mTVcAt2P4xvwbndUcyauotK1qnSLh8xM/pstt5W+KN4/?=
 =?us-ascii?Q?HtiIZfRkzKZwzfgIdAXe3E2Oqnn4OvepyGvxqCUvPv6ysG6et84t7OsNpNij?=
 =?us-ascii?Q?guY9iB1JgUaiXTaUvxElOOEOBh52lORyRIuXydzzhSczpK/lo2O5pjFU3zso?=
 =?us-ascii?Q?2Mac2ls+TgAXgwvX2non3Ne5yPvrldw66Wlna0RMyTWTfC/l32UYXKaYwXFe?=
 =?us-ascii?Q?DsUgqNP3xByP3VNwVV0tZK3LBIHk4MYp3+MfZ6/hmkiwiaMyCd3fDvaJxvSI?=
 =?us-ascii?Q?rcffZQg7l48QZO+A9ZzJJz4zFTAu5rBhbb2MdOZU0y8yn9r1K4iZqEizug5d?=
 =?us-ascii?Q?nI+WmgwcyxXSSMaH0rXJqZ5tmDDQZ+MaIvKYY2bHPZjTx9iHRbzBoAopk6+O?=
 =?us-ascii?Q?kXaGpBgip8kGE+Ee8HiAkz/bwKDJB1pEJpYlrVZ3/Z6rpqqK1enWuXFDVh2S?=
 =?us-ascii?Q?R2i1/iRLfK0ig0Bfr0Q1FRuMwv148w2GQlGlPlukbvNSekGnN0tHJ2Jk6wyF?=
 =?us-ascii?Q?ImthRhOv0EKy7a//ULjTdHRyDYYLvVoYy79iwN9vr6zOX1S2yPCARGKmMVUj?=
 =?us-ascii?Q?58dbEqXLbRhpzYOOkAJYvjGi8F2mi0aIXVWHVOKr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c50995-cf1e-42b3-10fb-08dad4791660
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 15:22:55.7716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nsL6VIHFPUOHceAGj7uRdixYNxoT+AwSk9Orb9d6u8/rQGSXo1vO/QcgkCUTJ4yESCMghmfL12Auy9PNt+KTmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7525
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>> get_stats64 will require PHYLINK.
>
>Huh? I'm guessing you're referring to some patches you have queued
>already and don't want to rebase across? Or some project planning?
>Otherwise I don't see a connection :S
>

In looking around at other implementations, I see where the link_up
and link_down are used to start or clean up the periodic workqueue
used to retrieve and accumulate the mib stats into the driver.  Can't tell
if that's a requirement or only needed when the device interface is
considered too slow.  The device interface is not atomic.

J.
