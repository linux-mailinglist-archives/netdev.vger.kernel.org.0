Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293933ECD55
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 05:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhHPDwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 23:52:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:11200 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhHPDwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 23:52:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="215819367"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="215819367"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 20:52:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="530164904"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 15 Aug 2021 20:52:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 15 Aug 2021 20:52:07 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 15 Aug 2021 20:52:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 15 Aug 2021 20:52:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 15 Aug 2021 20:52:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neHKry1rhG/iVsHhL6LbK3HP7tF8Pl6S9lR/h93YZw7rdiectEVrR7cNOXhJxakTj+e+rmDM7l8Vwo++XjTMmxTLvahE8PtfUqUiniyVKFw73dKBTxqKcfSZCGa4c3R9/tjvQRLMZG+3YBnJ8lwUVzQQ7rPRPU+ZHXZsAJQjiklPCM0rrdLEx9jsXJead+OZ832yMy2zgqCoIucN8LGCe5u186R3aaHRv5idX1KvXaHrIKaXfZzzI9uio0RWBxDzddnPcCIyaeS3EIEK1LD3A206UgFtvf2o8H2jYIUaF0Md1UXNrV6QhkUdEFrD86Qjsv1S8LC7WjF4qgTOQdikbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J21kcsmdjPSwqW4brFzXqc2coXiH0J4Abk5BIBbMfl4=;
 b=e/Upl9ugidugqGro8LvNUupG+my++vWZZm9hKuC4cE4zMjkHr7vCplxuGA26RA1B7wBJjEUVnBbW9cNzPELW3XeYVOvFWnjLUNBBLlhIzh3/r6RvgZnFTITmOHWdzkBXzLkE8kPcIfj61ESydBlX/NNmC821mJ9iPnXGAcQsUXDMu/DXTsEllVNR5xtBt8iIiLbw4zJRRjMOGuwsnt7Q4LdhoAIri5mim22dFlPOcxjQMc0pLXJ3uClr+ktnQAYp++YICMdkL9Iu3lLoRqiqo/Xlh+sfr/CU4/RpisC+0rS45bO7eHMx1YLTEq92WHcaJSiM3xW4snYnU7yqR8nnZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J21kcsmdjPSwqW4brFzXqc2coXiH0J4Abk5BIBbMfl4=;
 b=Uu3ECP8kajo4bzilv2VbqjtOuBDtpqHJDrDp81q01tgGGn5X2sbhAr2LAU8rFokzNZrb/zSCDFl3dFM1WnZofHABoCfVT3ykJcrgZ6ilA4zKY9uVm6Q7/7nTfKXWOsD+PrKJEy+SfGhguNuwlOoN6gQ8XdWu7CZx7kINLx9qSU8=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 03:52:06 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 03:52:06 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>
CC:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZw
Date:   Mon, 16 Aug 2021 03:52:06 +0000
Message-ID: <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk> <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
In-Reply-To: <20210814194916.GB22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b72c322e-f264-4233-e46b-08d960693744
x-ms-traffictypediagnostic: PH0PR11MB5032:
x-microsoft-antispam-prvs: <PH0PR11MB5032BDEED05E2B0FC90654D2D8FD9@PH0PR11MB5032.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vnet0GrDB6IBp9rV+zOFhyKgNaI9pvWiFxKFvVeFMFTfbo4TbLzc/AALS0Om4isgDM3wpJaCcZutCEqlzjkBG61QNERSOlwg2P9mgxmnYnpmScIsuygOxlt8yK9zJRFJEDgxEsDeNFo638/WlvicUSZ91SymVMmg56RLnRGicn1QVsUyFrA2dew7brF9PyY1sWejkeFSteClIA5u17oUbWqWE4XudwWU4zUZsne1W84hMOB5xlnDeiPE3mbxMaQ24GyD4Yivf6pr50v/1Usl2Z9Y+at8W8plMQO8ACRwzkhKElx3MqpjuDSfVvFSsUnwDDgKPL5pWqii4BehuV98M/n6OCoxqDBgJlvWwphqraXdVlWaiQnS2LPKWnwJwRmkuGln+LrF3znlESCA5VD2CWEhvkrBcWBwKXFuWDSTLQvi4nNBpL3lYjUtAHIA9CmBWxasUKtNeuNIWgg6o4jQyfiLfmDzcyYIpBXmHzEtSsQC75WUKTZj7iutRj2WAxkPbx+KavQD3UUWP7FfnoqNgoKwQiDeTn6DlcvzeQSlWVM6r/W89BVU5nb0EFxDKZ+XABQIGKeZsTc3JskXCeOjmSaL5eJ96vihB8NcTSufe/diY1wYoLHJNEK+gH6E6Sp5QpMfA12csLaaPR+im6cfhPY8Pj7GurVF1KStRLVd8rizCYI3kLzUyoSyAXpVbfv/uSFzcGW7Z3xSQRfUNAZFpwHPI1hLQHIT7k7IIszUCuYHDbZpk2C8AMwOPlaCMhSWV6YnwD9YyyQwY9D1BKJK6IBCuvTMyulbutYeZXOo8KY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(66446008)(186003)(26005)(4326008)(966005)(71200400001)(5660300002)(316002)(66476007)(66946007)(2906002)(55236004)(54906003)(86362001)(110136005)(52536014)(7696005)(8936002)(478600001)(38100700002)(122000001)(66556008)(9686003)(33656002)(64756008)(55016002)(8676002)(38070700005)(6506007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WiFJ/Uyf909o1oOpAeEqagaqS41aygWEVcJ8K0wMpyl0+Xo2BCbOfOecvl?=
 =?iso-8859-1?Q?0Xd6kL5cXzwZzyR3ZGVYXcroEhDU/lx75nI+PSohBjlU4IFsiqQX0CxqCP?=
 =?iso-8859-1?Q?lL19XHmyLiucrKU129rTYeQV51f6oBKprKBoUN50Vxi6Mw6DjMEGgasS9V?=
 =?iso-8859-1?Q?cxD9BnOtFsFvehIfapwgFCFclqFI0m7qMibhYn8Un1rG/Eh7k43aYy4iLK?=
 =?iso-8859-1?Q?DNiyPc7sRX5wPcMUoUIKO+5cWIO5FBdX8WV303toTH4YQsVtqjiH9b2Ev6?=
 =?iso-8859-1?Q?A0XXLd86hT+0q28DDZYUSncveExzv7a44geyECNi1fl2ULzLfiy/+vDak4?=
 =?iso-8859-1?Q?xQHe6pvJHUoYxOvpcXma9qAq1L3N6VYx2VwOryx3SpP4YEZUnjsdJfPbf/?=
 =?iso-8859-1?Q?EHi7GYM+7GaKwk+pYk2iL8+ME6WTCK0cckmq524khGtjhEr/+0b7vEj+Bg?=
 =?iso-8859-1?Q?CDSB6FzkLnbfAUWBxtomY1DvLoie0gA1Z1DfFPETZAhfanc6x5uhr7uDdf?=
 =?iso-8859-1?Q?KmflP1Dx6GCiIg/Y/UG1npAdcT1uvm0BQs8nRrOlsJ7gxWn9eVJGkVYTDX?=
 =?iso-8859-1?Q?TSpX2htrrYrpHVQidxcFMRIosWx+1qj4/fY86UgRq/3wYVMTsjRpZFiB1s?=
 =?iso-8859-1?Q?zJyb5fTMhf48dxI+7e+mdiJ5RcGHz3XBJ4YcCZij1gva9Bhl7tLB5NI8ol?=
 =?iso-8859-1?Q?qyNk0Wy7hC9vU0vYYNK0jQxuSuxtjIHKkp3hD/tDbIZx9wRtQ1aBb4hzMb?=
 =?iso-8859-1?Q?pCmWyEb8G6WSzgk7LRCWDJlF/lqg3McoLYHkGITzWm5HDQ0cnEVAA0hrS4?=
 =?iso-8859-1?Q?APeX/wBIactPFyAAmbtXnlWUXm/DDWbcN9dCvpO1LV7URXnhtvUIQ4SN+q?=
 =?iso-8859-1?Q?h83fckBgg5ps5p1JnNJ0yYxuezIpi/kxn7zAIhxbU1BXGK7GUs+23ayfMh?=
 =?iso-8859-1?Q?6Oh/mqVEvuPk4dnasXgP3GXnAHFNFW6GjoNcriGHS0VTjbhorSmgIKsdfd?=
 =?iso-8859-1?Q?lA/+dLK5DvN8FlYVeXAj03xkuFOeEY5VKt03FkGuSj39Id/pmX4kZjTOGA?=
 =?iso-8859-1?Q?O+9OtBuucfaPTCG0YKbhiqWM9gVLAAnvZxCUQ95EPi9K6tar5EP50dsMwJ?=
 =?iso-8859-1?Q?6ox474PlyKQy3Ea/C3Y0eIoWrD/sN0QZO4qb/AhN5PocpWdsDq+eHDC3Ad?=
 =?iso-8859-1?Q?I9EGbzQ7y096NdfuvchdJcDJ6iws8IipoY2NDsu+fQ2Tqc/FRLa/h9dY7C?=
 =?iso-8859-1?Q?r5vGcDgyHLZbv/E+YEiM9LipiGSPQLvPtDgmqFxg42iIwPjx5zfD8iOYhn?=
 =?iso-8859-1?Q?JSUczAHC/DXFw8Qt4tguBrrmK3/HxxJ7oVzGAtfr7k4OM4zDeb5dLgsVhT?=
 =?iso-8859-1?Q?wmr45VC07C?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72c322e-f264-4233-e46b-08d960693744
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 03:52:06.3356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fnn8bSM1wk6y1ONHXyCvx7GdNsPFSAhAWOuTVZjRfE277gPnVpAD/JYhNdLYC2+hMOVJjxR/Vr7jzDV0v8y+wZpy9SQHUM2g0U40qUC7NYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Agreed. If the interrupt register is being used, i think we need this
> > patchset to add proper interrupt support. Can you recommend a board
> > they can buy off the shelf with the interrupt wired up? Or maybe Intel
> > can find a hardware engineer to add a patch wire to link the interrupt
> > output to a SoC pin that can do interrupts.
>=20
> The only board I'm aware of with the 88x3310 interrupt wired is the
> Macchiatobin double-shot. :)
>=20
> I forget why I didn't implement interrupt support though - I probably nee=
d to
> revisit that. Sure enough, looking at the code I was tinkering with, addi=
ng
> interrupt support would certainly conflict with this patch.

Hi Russell,

For EHL board, both WoL interrupt and link change interrupt are the same pi=
n.
Based on your knowledge, is this common across other platforms?
Can we take set wol function as one of the ways to control the interrupts?

Regards,
Siang

>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
