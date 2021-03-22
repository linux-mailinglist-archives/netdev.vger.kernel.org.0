Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1603442E2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhCVMqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:46:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:36971 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhCVMoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:04 -0400
IronPort-SDR: BKa1f7/qcct0G2Ec2cIWaWl63ahojrt4jaBGe+dnkRbDbVWaqYzj/NlqLoAS0Jq02O9MuW2fsm
 RuPDqKusPG1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9930"; a="177833867"
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="177833867"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 05:40:00 -0700
IronPort-SDR: TZsFns+lZr16E1HmUjnO00vjGrvVaCdmAT4lgGyhQfxxIVgGVQL8Ow9qY3UfpwQuOhxvD0PpRX
 cGFPoabWue7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="413026851"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 22 Mar 2021 05:40:00 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Mar 2021 05:40:00 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Mar 2021 05:39:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 22 Mar 2021 05:39:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 22 Mar 2021 05:39:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mf9eqvNuZ6t4jVPYxvsEjrI47JGFnS5HDAj4fEG6+8kFVBGxBoCi28soL6RerkKhrpG6X1T2ik328k2phe8bHE/01fVwyq4VDBPoBsoSREzUUUEWuppdMs+COs1CS/WBf479MesrApZlWBc1SzHFM/fuqAavdr7y6reb9QEUkf1xRIb8VVJmrMWqOzhd5EV1gnLYX8Nt+ZlNxJ+gGB3ESdCZIyA2Z2zKyI23wrus1jDoWebvZ4ZFeaqLcmIfi7MQVOT7zzZ5288KhWMiE3b/D88RSWY0BZe8e37gsxOV1YC8e4ABp5d7YF1ClZqKlusM39JJ5Eb9uk1gzhTgJPauQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Podkf5lsBJu4Rdh6LLsFBFGCVvtY7OdigWktCrFs2Zk=;
 b=hqJla/knndA04ZeNjjhRHy47HA67hcq68BXaBBcDCjyxCj/paMkFgY3PERqSXMpIJCUaQr9n+8Vvo4R+tM8eduiu/w4+ngkbmgS6t9FoAUzryTr16VJi5G6Q23gd3zelof824vjztZVzs/wkCsLdvus1tC7F1s8kkc8j+1cWLNtBDYbCQ3Wp5bA7me/Hi3FDYuUp3IiSoUuGNtJS1s22lzOAskBP+Mc+K2IhdSdEefw/F3N9PdiUtbJ2tsefKSI6NAbnt715pKuzFFkgGP0L+w33WgZtRpIdVVPCK5A3WPnqM+bev5r5A2HSOeoECAAKNtumnAv8atHJU4feUlFJQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Podkf5lsBJu4Rdh6LLsFBFGCVvtY7OdigWktCrFs2Zk=;
 b=iWLb+5Qeuhbtph8m3iGRl1DMnMeIDTnaSg7mAlFhpg9RyVvtFSGgTjgiUCCPmPbD/DV/AGwANUgpUyiqVwHxWeUmaghU3lYhI6LKg3i5hPly0aPm+QVuv3fsTjkDG6lBJiQNH8rL3imqJaj9onLeAWwXHnScSQ9pcU+Ggf+LPJE=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by SJ0PR11MB5149.namprd11.prod.outlook.com (2603:10b6:a03:2d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:39:58 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 12:39:58 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Thread-Topic: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Thread-Index: AQHXHJMri61PaJNIo0y3q5cHdUTUA6qLAlgAgATmr0A=
Date:   Mon, 22 Mar 2021 12:39:58 +0000
Message-ID: <BYAPR11MB28702033C50FCB9EAE5686A0AB659@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <3f7f68d0-6bbd-baa0-5de8-1e8a0a50a04d@gmail.com>
 <20210319085628.GT1463@shell.armlinux.org.uk>
In-Reply-To: <20210319085628.GT1463@shell.armlinux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-originating-ip: [210.195.26.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48f609f1-73a0-4c91-6b57-08d8ed2f9a9c
x-ms-traffictypediagnostic: SJ0PR11MB5149:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB514979E96D4B349CAFF5463DAB659@SJ0PR11MB5149.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JoWNbAv1EqyD7M04OpMTFg31yczuUkQnOFxrKFaYdCR7lXV7DkxfkEunX50mX8SqothnFmrhEdT+dQJAqXJCLjIU9EWCos4v86ekNtg4AnIbjVYg7OIU34kZAz37iAo/EQtT1mo9D0UrQFwoCViHNqu0xHlkzJJHDTBlBJqqdA4K1UsBtpaoCZxeNvMVvpH1/c6rBjqgR38AvDmMvqe8WJ75IsxtCW4tiuuQBs8zNg50GJSCGE8j3Hk7Q3+bzIr9W6eia74H0LMZKRA3LLXbyHFx4XTMCpoO4HZAf66K7SGUl3JEc1zFUukgmwSjCk8nellrFrcEWnK86A66Df5lISBK/1x3Xaqhlf06A8tbi2gz1aR6VZjKS8/zOvtqT2gKfxYUoHNf8SI2gJ0QKfq7fvb7ECpdreWiGrsb31siPuqc/e9yEZWSZqJSREG9Vute2t1bQRjzt91T9kYSF+kkOKKs21Ft8KFUJ8rxakX4DZS6VNHo1RGJXYFGVuHby2piooXveSwqBwDowXUiTChsA1qmeJIdtCKD99jwToRoo/6LPYG+vOJTL/EVt6I7rIGqOcSRHhAFa+D6/7y5yd4QHPxQhiyoMqOs8sxHS5bpynXw+qYXObmJUAhwqo2P8BPxxD+Nsh37+wLXE6ysJSOtXk76v244R9B13kIk9HPGKKemtet71RVniu2jEMFDvRPHDoguu4nNd8LmoOgXT70hoD8LI9XK1gjDzg5bSMV5Ryg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(66946007)(66446008)(76116006)(110136005)(8676002)(64756008)(316002)(4744005)(83380400001)(8936002)(54906003)(66476007)(33656002)(86362001)(2906002)(4326008)(26005)(478600001)(5660300002)(71200400001)(6506007)(966005)(55236004)(186003)(9686003)(55016002)(7416002)(38100700001)(107886003)(7696005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qiLiBEpycyaYgVaWA2ibPJXaVJi/dO3XK09RWXEW9Rlx1deKrXDucSW1xLTi?=
 =?us-ascii?Q?cHOgvjmU/9Ww7F50Jw1wMbFRjsSmxertbIZsvVBQ7G50dr0FkBEwM7AZDRjy?=
 =?us-ascii?Q?rjWZzjDtLFIsqiNNK0cGML+xBSdcJ4/XjihR5dRocxIsk8ISDrIA/ffBb7w7?=
 =?us-ascii?Q?4XU5WXm9t8ElgwpAEx6z89z3sJyapkvgqjHtjtnMJspd0rGrwVLqM0l3RGNo?=
 =?us-ascii?Q?WPjXjuxh/2+uDNtRbj9y0vGLLg8ZdR3dQghA/7vDOytZH0BIKxNhsmdy6ck4?=
 =?us-ascii?Q?sP/qpEHFUGXsUBnk5HNIMxZU8T2pXXZdpyyiehVJujz4+fX6K4/iOtv1aO7i?=
 =?us-ascii?Q?3+pIcC5jhAZ8ncCFGN2SwwPTFI0un4KIsmg/GjgWXAD/YsKaasJ/dlMiM8O1?=
 =?us-ascii?Q?z4UdvEOP3XODmQJ7JnKXLpMVZEnhDHJ2BRSqK493u3POvRydm3+mjiyJAUaq?=
 =?us-ascii?Q?Cyf2vJly6R1r1G2hLLFV+z1hDniAEBRXennlkEkifDItLpagNIQVjWGz0f7m?=
 =?us-ascii?Q?02+NBn+rvGis5KW3bkFurB2aUt8vtmwEZa4I/N/8A7a/CfmFzjQ1WHH7OX/H?=
 =?us-ascii?Q?SAZcWqlqJdWdZHI5GftGEg6cJJ4EK26hSCoh1KZCfD29NM4Gjej0tN0SvO1Z?=
 =?us-ascii?Q?2eKnjlkjc6ulIuBNVPXqa0NAp0ESeyfkmWN5U/sdZgP5KCGup99mxfv2LaJO?=
 =?us-ascii?Q?pPVMcf08fIqjLq58D24Xa8geO5skeIQuEvs3giX9cS7l3jzhdS/fFbcza1MP?=
 =?us-ascii?Q?RlPIvzLdGDhm6bwIOuabBJ6hRcdh82c7mMt+u7ypvhY1SUOngqbC+5QFQL7l?=
 =?us-ascii?Q?ii84tzUvJZ2TOrnu+oKwmSAPy364tLn+F/2RpbkTPPvuiUksVNtftNhfXMFG?=
 =?us-ascii?Q?UYQ/gGp6n8jsvAWexp1O9p4EuRGDSYD6RxueYnORSDYzyVQUBX1cc5vxZAtS?=
 =?us-ascii?Q?kbtfrKhhiQBywzMC9IddGb1xkwryCroi5qeFQ+chDxOOE69gGFxCCA8cKrNV?=
 =?us-ascii?Q?8ceVwsiP+2O4l+ck+4EjlDSkfK9a8lenQorqU0xHISvTYnFjLvf7+VNILk3p?=
 =?us-ascii?Q?Uu0V+wdaMnFz2V5ay6jff6PSCIGBwvaIn8okjn5c6kr/Z5J8Xu0GcWFFBxP2?=
 =?us-ascii?Q?a4itm1EbwGJOUkQTtaVKveIax8xomN28FcYWvebEqioY6W4lhuPPbWe8RmJS?=
 =?us-ascii?Q?tsKQwC0g8fgLH04QOZbFbvKEcvAxk7HG++xuQp/mcJ7/wNl0CVNIFJL61FQF?=
 =?us-ascii?Q?qTkMHqCg9bulliRILHEeA6oG6tOggZScEaQ2oqN4xrFgEER76BtTYaNO6AMm?=
 =?us-ascii?Q?169Ld5EBX2H0QC/8WjGqEFY0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f609f1-73a0-4c91-6b57-08d8ed2f9a9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 12:39:58.4994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2akSXwn3qN/t4gNzt+xW4DyHlh9zX00OzRoaOTfSPwJSTX8A/In/paMmcPGwWjc0Zu5PYD7E1RBrw7BygBNhiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5149
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 04:56PM +0800, Russell King - ARM Linux admin wrote=
:
> On Fri, Mar 19, 2021 at 08:40:45AM +0100, Heiner Kallweit wrote:
>> Is there a specific reason why c22 is probed first? Reversing the order
>> would solve the issue we speak about here.
>> c45-probing of c22-only PHY's shouldn't return false positives
>> (at least at a first glance).
>=20
> That would likely cause problems for the I2f MDIO driver, since a
> C45 read is indistinguishable from a C22 write on the I2C bus.
>=20

Hi Russell,

STMMAC is capable of supporting external PHYs that accessible using=20
C22 or C45.=20

Accordng to patch [1] send earlier, it should solve the problem.

As for any other drivers, if it is not using MDIOBUS_C45_C22,=20
It should still work as it is by using MDIOBUS_C22.

[1] https://lkml.org/lkml/2020/11/9/443

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
