Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7A5A1F82
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbiHZDrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241183AbiHZDrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:47:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A19CCD73;
        Thu, 25 Aug 2022 20:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661485622; x=1693021622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XFNARSRgoYrK5OPxFH/GnXbc+3JK3Wdq2uxYkbCYOLY=;
  b=V9AWG1jwOlJ8megwFbmiIrtbfoW7zPOdkfxw5dNWIZJWiZacQ4WHekJt
   kDo0DWuCMwnEm9UPAbPVaX9QPYed5FlMmoiAb8kwgucQEH+Xja6X9eYFV
   NnfMoq3zfZPd3GlXSrCta1Tx2gl2JaolpE9D8QAi9m3/d5sjcSr5jHYMn
   RxBaAkG0tK8UrA0Th5L5UeueUkZlLFex7rF3zeEUH8ar9F2stT2InP6kq
   AigS2+wHKunCoaHFKeHVU5zwBF9jyAdnXNpr+ct7T10wmUTtGPB6HWrqS
   DvAOoJmp9EvPH+CmLJa3pK53bgq779n4eDDOlb56qFv///Yvc1iExG9TX
   w==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="171046394"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2022 20:47:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 25 Aug 2022 20:46:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 25 Aug 2022 20:46:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBXHF/cl0l9GvdhfxZ5McA9SGhfuPeV1XTNIZj6VZ8isTOTDKGN53HkDO3zmrIb4zdQGLsTvldsROVlmqdUDk1pTQqznpoOQva0QJMo8vfPqBydOToi4oHKFs1e0Nca/icfXtWBoUc9Semb36z6+Ai5O5FoLdS0MTiUgBW2mf+M/3yFdtaIShEwfxGGpokXjOWU2Wmcp77U3sBQy2CT/wAsYpENlQG6deGUApEuemTxoOjZ9Jvmdg58yIZTNFB9KfatGOyELkGKaWGD+BKWbj7Lkc1NUHoH6LTcfP3W+8gl/BYGXfcvGMtm8mBpRtPctg5LT9xEqd/rBC14V8MIhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jISP6wu27z/z3vDcFnOTy3nywhJxYu/hqLS0gUB/L4c=;
 b=VyLxKjLH8BkB5mcwuWzkw+F5dfYuBILqa9ZbaVAfq8jYcVU/DyRKzArhy8u7AHPklh4uIsPOh1FugPw7moL5GrpDYZpZQNHvZqk4qIf4abby+qdIPTSSiwaz4LoaXbyXfh4QCQ2Dz8cyt84G230zQ0R2a9fSYxmpNB8h85fG95uQzYVg5m+qnkJ63ifhzmupG6K0+TlCYdZhOg9ULFCvcJlxPftWByzjij0K3gLgSJeDHB90wbIqDXQVaTI0l/A1KGTlug01RwTH1C2WhURCa80/kEdXetcwu12MY72l4U3/EYqc6E57H6WvDwd1wyf4l2e9GR4ri/rXeLPFzXuL6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jISP6wu27z/z3vDcFnOTy3nywhJxYu/hqLS0gUB/L4c=;
 b=u/uojE1QfC6gnbOy9j0ZM21e6LxBPbOEWJRP7faDO/OdjMkzUi0msCbLB3AhpVNyUHnXVwuhlYtQauRLfvLZ93kvaDYveVbaj2MvBg7I7DknO52ZzY2YLXA8gtSmrjV21k60b2aOwxoRvWeVlC9MyZuRInVxrsB5kELYbUcf5gY=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BYAPR11MB3733.namprd11.prod.outlook.com (2603:10b6:a03:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 03:46:56 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc%9]) with mapi id 15.20.5546.024; Fri, 26 Aug 2022
 03:46:56 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
Thread-Topic: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYuFmMgzj2knw/J0+AGHw88JSECa2/mf0AgADxdXA=
Date:   Fri, 26 Aug 2022 03:46:55 +0000
Message-ID: <CO1PR11MB477177D2A2B78178B7B71DF5E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <Ywd28j0TJjW/ZWUU@lunn.ch>
In-Reply-To: <Ywd28j0TJjW/ZWUU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aea50b25-f168-4433-5d54-08da87159f25
x-ms-traffictypediagnostic: BYAPR11MB3733:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +GLSDmkvWCyJnXaipLroCFsDnLoh/aNAncYTJWJUskJAJJMGFd7y5D2Q48qujF/FtpE/bqFxt9D4Fdc8TxKAETnkSiRWdC4XXd7gwksuRrq0XwD5Z8XxnZw4OLfb4xYYjUvF0dAvPdBGgfin4zKJ2UKk4JFziIm4St+XrhM+w8ev4D+q5tJjUymObVKJvlp89J9rD759eRYqA8yBNCI0erJtA4+d2H6c8R2Lqkz15CBV0OQlSl/1xN9VE63/TdsaDIGdwQJVvgST4CEjkoEDeqTPrTNd+mV5utOC73+Njc65IhqtnkSYDwopS5/5/oRhvHfFpGKV6NFFE6tbXJ/G2CCbjH71Ovro15vf7ujc4WIuNOCDXAuRbTNUt7EwNlCEDiuMlDEPmMzqx6+3k2wuCdgzk3Q3ifCU9CRsJQ1bL7nzXrzoSMnMQshOxt4m9CWL4gZHZsnlZsgJwECxqWftaAYVh6dBYvEmY3qUl2yYeUZHt14E/CAMdUeDrVynmlZGL9tED4HA2yD1W8V9kX4VgwAJ/aXPX4oWr7AviXMbQiMh5NQDOf3MsrhQ2ghOojLH24QKzVe1N9nOO2udWWr7+UIiwVNpHWaNtp8zjYicrfnQiKpbmfQIUKhWA1zSevPx8xncq4xY+gjAt+Wvr7sFDBg1tbGn0qOByszDrHbUG6dlNp1vmLkj/UMrx/cqiSowxGeOjElNSj1C431nrWwcWDQM4GSXkhP+qd1v9hhQNT/5Q/NQ5+xsUE6B4wF6u7+sY/md0A5aINwO1rcNwajJTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(376002)(39860400002)(86362001)(38070700005)(122000001)(38100700002)(316002)(54906003)(6916009)(52536014)(8936002)(2906002)(5660300002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(83380400001)(186003)(478600001)(55016003)(71200400001)(53546011)(26005)(7696005)(9686003)(6506007)(107886003)(41300700001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?laRAFNRVESNd0xlwoBsSggzsFOxWxRouscJr7/UiHHtctRr4/mJpdRTSlbGx?=
 =?us-ascii?Q?PdakMZftP2mkm7cRsBiSszN79QiKZcJXnEP4m8d0T+IGYzxbet8xXdUbmaeh?=
 =?us-ascii?Q?JZGvGxLPnSCAf7+bZRnlwS+RB5FZ/IrB/wXhQ/XYvCb9Dcrc5ACueOhHIVJk?=
 =?us-ascii?Q?5/wYMAklwqrCymD/osalBpJCjz9/p0VvP09bCiV3I0S9DbP4GGIjp//7OyYT?=
 =?us-ascii?Q?HLiNqjlNgXgiIlQPAgUDl1GWApoibLNmqJ3x4pfWwNBn+35hJNdAzetKbaZR?=
 =?us-ascii?Q?a2rUbdOHI50ygA1XfztQNx+Bs6mShlUgme1RD5ihZ86HuUtJapLceb2MY2dq?=
 =?us-ascii?Q?V7u79bCCH0knok/aRusxIi6OgngdCutEw5dSRMvOhW+oT15AqkdKTuea1ztE?=
 =?us-ascii?Q?w1ZOZN36fCsenIqT1ef+IEyiL79ui2i8Jeq8eB3lg9k/2sMfmhalN759qzEi?=
 =?us-ascii?Q?6es4TvSQEGdfweqkzuShfQTpOxIssBhG745GaJ1W0eIA/1M4iXPSpUvHlExG?=
 =?us-ascii?Q?rG3wFNhUog4kjTgm+oYeUyhQiQUlRkg/uxN+cksWP8KFOPPTFrdaC+IMUfW7?=
 =?us-ascii?Q?9aHHjQtg6a4e9+qysXFn3X3pumZrUQHb4Q7fafFSsqOUGnfHmU8m27BzFjft?=
 =?us-ascii?Q?TgH0Mm0ZLAxQ85O+Z2XNrOvBvPpiHcOQQcDXptOz42/3qrtBccamOsgSx6KH?=
 =?us-ascii?Q?a+VRF0UlYabZiGhW8VXr7bTVAaWHty7zXs5mk58GW8efB632t6Ng7xbyi1wx?=
 =?us-ascii?Q?DcFL7Eu/GqESC9ZAH9MZhPrJp5En19dbdgIORUlegMw/ho884fGbKJJeH3px?=
 =?us-ascii?Q?uuPkAhEHbiBJYJMymQgRM2wHFDpNw3ChaJgnzi2TqcuYj2ubwwVv5dIkVfYv?=
 =?us-ascii?Q?f46IPJtgpgK8gVzYRRDO+jFgSW5dohU0u+ykzr1wQySd3TdVx3tPTQBHuLX+?=
 =?us-ascii?Q?xMbOkfPNYsJzmUS0fVTE5sQgCmYIXCHrP9HfhGI9FPJAV32xcn4tEyIg4S31?=
 =?us-ascii?Q?66KK8S67dtvQlV/c+npCNdvRWgjrgpZNYa+si+2i6izoP8cRtw3f1RcimnoZ?=
 =?us-ascii?Q?VAC13DRiIi/xEclPRJw9Ru60WBiuNuB49QUWNJoMzg/NlO+RalrBdNWPgSAU?=
 =?us-ascii?Q?JU8A6TPtjXQVrgdabMJZEmUtwuMczgblyTIDvzB7lriauT016wAeuOGBwd6H?=
 =?us-ascii?Q?gUDV8pyFYb8/8HGSAwwtjG2ibvCECvgT7wowEMlzMLIk4i1FEYx8nRcyk9Dd?=
 =?us-ascii?Q?gZw7dY1x6lJT24kA+jWSAAmSc6AZbzWZYty9R1gaQHPKoAZ7s2Sg6JFF+lIA?=
 =?us-ascii?Q?+7oUdeLeapNkB+kVOIjAnCi1jwAsChFB5n42aI3cwJCYWo4wc+5UDrEtSGAx?=
 =?us-ascii?Q?rOBtR03FyC1hIaqVfFuCrwLwgG3qgg2nH8erZHLXoASzNr4OhtBRa7/akEDh?=
 =?us-ascii?Q?PLD9BwzDl8HZJR3Hk1wDTG8d2o6ycHNPJvNg2wauPV6YiqVT3jkQ7FJ1Ziua?=
 =?us-ascii?Q?0QnKEidH+jfdcxAJkTHYt8TOtk0Vuf3XiS6zJ3bTcv1eWsEkI4Ke9pSIdjPZ?=
 =?us-ascii?Q?0eL1p+eDU+wDO4KCkSn61jupkZoCQOtVL1Y7G8QyZlSaV22HGw1+gj1WtS5Q?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea50b25-f168-4433-5d54-08da87159f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 03:46:56.0123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pItXiZSZ8HYLDEm8/k/R2FnUForaaTmYv5O6EDpEmrkSceQ8TUR+B7zwBjGAV3sC/9JxCDNk+4QrnlBRsQPj/mI85z4ida00KkTD6vyNsJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3733
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, August 25, 2022 6:50 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Thu, Aug 25, 2022 at 01:35:49PM +0530, Divya Koppera wrote:
> > Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
> > index of 0-7 values and this indicator can be used for cable integrity
> > diagnostic and investigating other noise sources.
>=20
> This driver supports 16 PHY devices. You only add this to one. Are you su=
re it
> does not work with others?

I don't have other hardware to test or check. I have only lan8814, where I =
have tested.
Also the register access or register address may not be same for other phy'=
s. The one who has ownership
May provide support for other phy's.

>=20
>      Andrew
