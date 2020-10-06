Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD70284FC9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgJFQZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:25:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:13919 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFQZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:25:28 -0400
IronPort-SDR: QmoIXOONyAxbn6ayge53qZbh60eGOOzKN0HBVCSSzh4DA527OmOMlUzhFoelKEXFXVGpTyxKym
 xeZiERP4beQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151488557"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="151488557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 09:14:05 -0700
IronPort-SDR: VV3KErqPC2P6XpYcVhVKgyEltAE1uI6KjYIHb1l/cVgWwkdSd18HHjH04R79fwsC0ZBrZZufpx
 1Vi9vYCCvgJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="517293622"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 06 Oct 2020 09:14:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 09:14:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 6 Oct 2020 09:14:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 6 Oct 2020 09:13:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3gz5XY5j44zqap3T9A2PsfnjN/u3bx4wtxaXeb+YeKA7XoSrOfVMttFJ9mGTZ2hnI54NWqWmzTyFHwY1pFc901MJhEcpMtkG39uHySGwtTypR3m76q6QrBgudAtwsYtTE9+51UoRxs4I3Blv++L17167zN9YUIYm+wiFJlbR7qwlBnNfSqMv7tnmUR8lheLZtNKOe+UDFfWCLmEVR7BzNjpE9Ij+sT/jNhE+SigPOI0aClAMpQx3iEART6pVd2wdcuuxpecLXqV3HGY9v5tV8hG57umA92VHxwt+ZDwTs69NJn3oz2zyOzrL2zPCGy076dkpCUGRrmOp5pmD9Je8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cGbrv7fgk9tGuMKZK6FKpyFbb9dXTl2gV/rMr3eTaw=;
 b=VmCzzVumOMcxGRd7gQSU2VK8Oo4AaHFQCY5odiLCnIqLam4D3o3k0rntRhRUv7J+jsIZmuCUUiZ5bp+s7OIpkRo5Trq5sgemdxy4oybIe72sVYo3rtvyUVWcQA/wkTGL4vG6guvQah4x0x9hQ7Zr0M29OA/jTPNOP1wWtfSSP27omwUsZxlxyxu52CH8OdivgnJMKbe7EJKQO2+FVaaybvtRD0+x7wSg2rNkSNE0f5MAIFv7Lrf0qVX+vUIhrEPW7/eTabA+rehonoXr9bmQt1NC08WTiezW4BMJSzsL+OvUVdJKNjPuAz7CDcCk9hzVYcTC6MtgCRTTV3aSnZaHYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cGbrv7fgk9tGuMKZK6FKpyFbb9dXTl2gV/rMr3eTaw=;
 b=t9k1gmrj3SvkdyrRfPm1oGyM7HWd0gcbN/Dved83ecMm7pHZCF+pB3umdu46Digm3B/OKs53KjKqxKwlTsFJaadWenCwlai+nj2trMxgfim+OF0xva4ToBPguoO4gdxjiMvuxbAnpwa989G8KgGL/KK7xNKvtBy4oGZ+nGMMNWA=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SN6PR11MB2800.namprd11.prod.outlook.com (2603:10b6:805:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 6 Oct
 2020 16:13:57 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::a5be:6abd:8ad0:37db]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::a5be:6abd:8ad0:37db%6]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 16:13:57 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Seow, Chen Yong" <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW auto switch
Thread-Topic: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW auto switch
Thread-Index: AQHWm/qz8k/sMQzh+0SK7iSUq201camKvnIA
Date:   Tue, 6 Oct 2020 16:13:57 +0000
Message-ID: <SN6PR11MB3136EB80851DE53CD3811DD0880D0@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20201006160633.23470-1-weifeng.voon@intel.com>
In-Reply-To: <20201006160633.23470-1-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.255.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9255f6dc-72ef-45cd-acb2-08d86a12d475
x-ms-traffictypediagnostic: SN6PR11MB2800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2800AC5B3CC4A8004EBB382E880D0@SN6PR11MB2800.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I9tSB23KeRwxTEVp4e4wkDONqR7T4OjqZOM99anAlpF4Y1tTmx77uaZb10NPR8oWSGi3JGAQ0r4T9ehbHkA/xPnqWK/9Z7V+WimdmiuT3wU3tbY4qRjkn9IRaf2ag6RzD1bjAaJUjeLW2dpsabkZYG0L/uBtfVhlvz28RnNgCdiz5dGdn3j8W9v7mO0FL4kv/aLrTCbS2gJF4sCBKFIcLvgaVT8Vwb/W8FAHO+fdFm5+VY1b8dCtsinIu+NSOECy0SD2PDqouSk785RuTEeVYH76WqCse39WMR7vuua6twSRn81IQqfhSN8jtt6SCHas
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(26005)(478600001)(4744005)(4326008)(110136005)(6506007)(86362001)(316002)(7696005)(33656002)(8676002)(5660300002)(54906003)(66556008)(66476007)(64756008)(66446008)(76116006)(186003)(66946007)(52536014)(55016002)(9686003)(2906002)(71200400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pfjruPJrfmelRbOHu5NUzVlY2rQMw+ofaxJw+FMjACEfPH8o+YkduRYskwtOSWfl4KLEShfvdfWYwpdMUbwwetDG2byl9KOE0VZaTTanelhpNwM9HL6sGAxFtaGt0T4AfG4irBDYY5sunAC5sWN3Ni15lreaaoyQeajatAOT1poaTqU6kF3nIouFr+oD5mUpfNZrbOPTRPB4wWfpRD5vdZfMt31io2lRfvy5jPAlY4IzRZbBuJaiChwd3A2FlzW60wpbunXgtxyUEC348/toLlo0RjlDF11t4ScsmaQxOJ5ia4I5mcUbzIY3KXROe1ckXoa+MhDV1H/u4s7RoP3J+W/3gLhSkzZakZI2hpOnbMgLf3oR9fMCm/q5kK/XkGTIwkJlWwstVH8mtb/OQK0ig2lPjD5rOS+EcjagVjWNq7Gu4ovqJvjB7YbUpb8/+39hwumh1gL7sg4MxQCohQ9Kp86F8JFjrOGuXZth93CrcqPDponqApoPg9REHrjrrZp2mSCDeEqQ9EDIXXJTSy5uAkq7A+Peixoq6EdPxR1rFWUdsCMfp2oQe1g82dRGAx7QU43INlAzuVKzpw1dpqa1Jq0MdiBlTMCCnq8HcBKTnPlh+V3h0icU9MIuVkq6GJh3BjxCNW1QeTL5mFbAF2xOLw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9255f6dc-72ef-45cd-acb2-08d86a12d475
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 16:13:57.8283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXLIcBZdFRdHfejCB69vB9/4FaVtHGZPVaWOY5AQlo/E+hzVRslBUKH7s3lRC6EuWZ8ULQWCLQPh5pJX/eP7qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2800
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
>=20
> This patch enables the HW LPI Timer which controls the automatic entry an=
d
> exit of the LPI state.
> The EEE LPI timer value is configured through ethtool. The driver will au=
to
> select the LPI HW timer if the value in the HW timer supported range.
> Else, the driver will fallback to SW timer.
>=20
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.co=
m>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> ---

Please drop this patch. Sorry for accidentally sending out this patch.
