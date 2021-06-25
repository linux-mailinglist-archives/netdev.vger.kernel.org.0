Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEF23B471A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhFYQBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:01:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:56052 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhFYQBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 12:01:24 -0400
IronPort-SDR: 8O0rm2mMnUcgOiUoTEmKHVIpEMgFKwSP0+NZuynJqmk78a5ALORAcUiOiGX9A47ppjxcehERLi
 3BYxikoOc1LQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="194989788"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="194989788"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 08:58:21 -0700
IronPort-SDR: we/+YVfX6jEoKyEbiTtdpQ/Sskj4AjvNF5dfqVAw5oLBvsEeDOfjEGrvqHCqtaPH31zlu+E686
 dihq8zWxoxnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="640154377"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jun 2021 08:58:20 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 08:58:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 25 Jun 2021 08:58:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 25 Jun 2021 08:58:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJsk7ukU7C9hHLvKpWII6/SrbRCwQj0uLMgYhNmlDWi5Pp3MoOzNAmDThhf3PLP788Q8A4/6j0f4LQ3reVcGNUfRNAyC8QQP+Z6KdHwvGOaiLxmnWPaBgWawsu284zFU+f3JVzvKTpnnqcP01uYr6WDpc9jK0AtbDqoTPAv9F+g3ltDu48l6zfeyACPDzeVw2Mi9bJeHa2bSi5qt+bcL4L3cXRU4wwkiV9syM47DUlJtCpXkXcVKrjagL2kahEEJ82JcnswINsmQ0nsbhCKujLRh/fWq+wPo3CFzFAoxuebk22vWXsE9vG7/VszaHCXRKA5OEdJQfxcAlbiYjM9wGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4JQDvkJsAY8XeKNZugXw1WP7iBq3vHQmMhkK7To72c=;
 b=hIXAidj38IJNgaPDMMQc18XNOLF3Q7eah211vIqgbsckksoeoe2tiw6+TBFbR9XFDbljjSEM6vbkmMcMApGJQTVlNQEIEN5bN7dD24sSFSaZxQHTVlykGK6vdYHvepYj4k5ETcRk6Ge5RNhM1V9ABToYI8DLk2DxmjbwxwVmwJ/aYksb89SiTStB2ZXCDOEJsW8pXfFYIK5TPAmRXCDe5+wTg71f/SY0cuSuZhulYX5riVRzxjje61UElEzNELcEMBeqlDnfDAw7biaZbWTykzgHxdw3LYtnOdagOAei0iPH6OplO4jbJ9CUUo3P5mX8fHwi2cxg6mbyIRkI05llJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4JQDvkJsAY8XeKNZugXw1WP7iBq3vHQmMhkK7To72c=;
 b=hTBCFQXoyED2kNoqqYWTISRtLw1wR738gbGvSGb6ewoJ+/cfc8RkmNkm6DLaGcV39ynSzwc4D5QrJSi6TD41nxJniKM70O8StsZ7Oz5hxd/U3itSo6gh5Zs3TXiu95ILOc8s7IFJXJvL4ny5K7XHwknE2APQno9WeanOnzmVJO0=
Received: from CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5)
 by CH2PR11MB4344.namprd11.prod.outlook.com (2603:10b6:610:3a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Fri, 25 Jun
 2021 15:58:18 +0000
Received: from CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd]) by CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd%4]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 15:58:18 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Topic: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Index: AQHXZoJFBtZ0uXgSn0S7qboFjm+Joqseb0UAgALh+bCAAK/dgIAA5rbAgABIGwCAAagL0A==
Date:   Fri, 25 Jun 2021 15:58:17 +0000
Message-ID: <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com> <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
 <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNSLQpNsNhLkK8an@lunn.ch>
In-Reply-To: <YNSLQpNsNhLkK8an@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.208.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce1edfd9-d7df-49de-3164-08d937f20c84
x-ms-traffictypediagnostic: CH2PR11MB4344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR11MB4344768627C51586938AB48788069@CH2PR11MB4344.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ojA+ja7aViic1Gq6xB9ddGEBKKdbjUoEsb5e8A8o6oJx4VJGkue/e0TLH/mh914t2YW+VirSApA6GUd8XtutJB6u6T3f3LyTQdguC3GCGU08UhEK0ZagMaB+eoIehk/GKtSIvX4lYzuR4V22/5diMZfMZPVg9r+NcVd4mUHKnSr5K0EB7Dytw8gwsJoTlKomavfytdKT+97oBTieNC8c3TYFtTdXWsdvOw5aLzC/7mbKP73K2H6gWV4FXqEG/Q735bxmOsQposgF2/MsGDCtxu7tF6fx2eGeXHwH1cO6tlnIGMyuUKh+E8WBV9AV04/8gWqRmIO9pH2BUpWEQf9I5CRN0xAvuvOEx59qdAyWrn29kk5hQjYVmRBXJI0mopZel8qNFYXePwsDpMSf3KSdbFE5AezUF5l/OEPxyXtOJ2sYnSPLXmOO6djHgYl+MTjnLi7Ryi71IcLY7QGGeSrqRzTOOCIy04PasThWTkKeVVUFkrmZPIstjWYcm1Vv07YykWMYhrvSmpGK/DC0UxyThgRByhZnNN68jlU5vu29BweDR26S/An7IKe6+3JWWGkKBQbrjBKW1feqAfv0iMI6KkHoAtVJEjuYfa6oeygwVDc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5380.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(6506007)(8676002)(71200400001)(83380400001)(86362001)(66446008)(64756008)(66556008)(66476007)(186003)(5660300002)(26005)(122000001)(7696005)(316002)(76116006)(54906003)(66946007)(8936002)(6916009)(9686003)(7416002)(38100700002)(4326008)(478600001)(55016002)(33656002)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jA5S6FSfvKIQU1RslB12DYfYW/whWfkQ/IWq5Z8CobEDPohlODVRGlCjp/Mm?=
 =?us-ascii?Q?sVokx6COn/dn0dCJAG5G2s1c/tfATFAj5v6RkOE/xGo3GA9VIktfRGLmb+ss?=
 =?us-ascii?Q?+z9s4vdG9UdCSZwaIRmENmCZ0EWShqxnrI2S9ffiik/gLsW9Z1/wGXrB0h52?=
 =?us-ascii?Q?8Gw9oazZbkO9NV9a11KL0gqjilRClTSrqV2eAnKw2LlE11AY2cX84FzJLLEv?=
 =?us-ascii?Q?suOGfW3QlLqYKNWybB6BYBn6Uvxqa+KYXOepK+QxbXU0oFFZIOF/+pldLVrH?=
 =?us-ascii?Q?GYPz+zNKe3FHusRObm9inBSjs8j14lDKY2VwzhwHoZ2L0sO8gPEUnHCBxtHT?=
 =?us-ascii?Q?g6gXC2jVH2Wa+6gpTmXPwA7hSiAnaMjhjrCFWsYGsOZ4RmkuY5zwnHKbNwhp?=
 =?us-ascii?Q?UIVXOFzIA3nafcKKXa8jojqf0Wr1AaF2rDgxUWvM63+bItREQkH/V54JQu4N?=
 =?us-ascii?Q?eN78kPv0F+/vj3NIVMyoZH6PDOiOfYt2eg3rLFC5PA94HuSFqhEWmQQ45md+?=
 =?us-ascii?Q?wFlBighh3ASNA6DCHpc0tItqxxItkxP3CKK+puKImogteO1gkyQrg93tUGVh?=
 =?us-ascii?Q?v3rLHzbHMnUFad9zBy0j0XJTetnUv193g2g5fdPBE120EZ1UY+riEXyYy2qw?=
 =?us-ascii?Q?naZXVtD4R1qLLx1baIDgfDMRiLVP0DrAG5EySGhcqFSDCcrzvAaH33hpJHuW?=
 =?us-ascii?Q?1d9CCgUg6Tw3Y5b1hfbGI6M5PnDa3ZGXOmd33/q8cpwILTx63q9HU6tUUq8c?=
 =?us-ascii?Q?bMpM2+BoiOMOV76If3h3ClKt+dMENVC6u/0uf85sKmmsJW+Fx4Vb8PmQiB/S?=
 =?us-ascii?Q?Trmn5+XT2Kp+fjnzITDKMDCxX++3+NOAICVPqDIwM3kTBIFGpF/DlObkJXIy?=
 =?us-ascii?Q?w/H80TOMDicEtrQySsTHxMg45hPT/5ew55huFTxKRBKEhbaBpm9p9YkybH/F?=
 =?us-ascii?Q?rI8LYm6MyyCgotgx5D6gCRO5udB2iwuMVBJ1okGOrxd+VUlGVdrtTLxJv9Hz?=
 =?us-ascii?Q?iyZmlQV4LYN4vcS5+ICiytUFrXanUYbYxo/mn24uxND8nTCtBDksQkk5ZJmJ?=
 =?us-ascii?Q?mBZFMUGCHAhGEor04hCNmzfRrf7AMXn27UHPLiYyewA4O+NACgLRGK7evsic?=
 =?us-ascii?Q?qgn8hN+0aZJpsv9KPkOiANqC6+dVO2bkgQ//i9Sdq0ZNxTsdANPWgLPHhWFq?=
 =?us-ascii?Q?LiLi6cQZK/nSvvK9ZZRzcz21illFdJlAzr2HMpwj+q9Ithk0pVbhtoEWXEfk?=
 =?us-ascii?Q?6XtJUokoNC/xCxeOZfKr8+8sY+xR6R6NB9TrAvuV8C/+EHhjuvq1YZBdAbRt?=
 =?us-ascii?Q?08uGORubmPmYiK3Ps8hPMJ6V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5380.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1edfd9-d7df-49de-3164-08d937f20c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 15:58:18.0014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B2YIvP3/ni2WsArmBttox10vQvuhE4rkzj7Zh/6TE1Sc7dLEbwB1DUrfKVgaSiHG81CX/+AZNJpVv1udKxOyQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4344
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > No, the interrupt will not be discarded. If the PHY is in interrupt
> > mode, the interrupt handler will triggers and ISR will clear the WOL
> status bit.
> > The condition here is when the PHY is in polling mode, the PHY driver
> > does not have any other mechanism to clear the WOL interrupt status bit=
.
> > Hence, we need to go through the PHY set_wol() again.
>=20
> I would say you have a broken setup. If you are explicitly using the
> interrupt as a wakeup source, you need to be servicing the interrupt. You
> cannot use polled mode.
=20
Sorry for the confusion. But I would like to clarify the I should use the
term of "WOL event status" rather than "WOL interrupt status".=20
For interrupt mode, clearing the "WOL interrupt status" register will auto
clear the "WOL event status".
For polling mode, the phy driver can manually clear the "WOL event status" =
by
setting 1 to "Clear WOL Status" bit. =20


I would like to rephase the commit message to make things clear:

After PHY received a magic packet, the PHY WOL event will be
triggered. At the same time, the "Magic Packet Match Detected" bit
is set. In order for the PHY WOL event to be triggered again, the=20
WOL event status of "Magic Packet Match Detected" bit needs to be=20
cleared. When the PHY is in polling mode, the WOL event status needs
to be manually cleared.

Ethtool settings will remain with WOL enabled after a S3/S4
suspend resume cycle as expected. Hence, the driver should
reconfigure the PHY settings to reenable/disable WOL
depending on the ethtool WOL settings in the MAC resume flow.
The PHY set_wol flow would clear the WOL event status.

Weifeng



