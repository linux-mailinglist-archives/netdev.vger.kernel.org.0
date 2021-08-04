Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A453E09A4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbhHDUxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:53:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:7769 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235488AbhHDUxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 16:53:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="214040634"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="214040634"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 13:52:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="480321318"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 04 Aug 2021 13:52:51 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 13:52:50 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 13:52:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 4 Aug 2021 13:52:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 13:52:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGg/6wCfPZoewkCCdiBT8eluzrbzafjZokuwh6AL/XiCnqhRSVHVH9IxLx4Q+U9jFu++PBJi2aMAsTiCaWWipPdu0h4/7fCYd1u0ynWKm5kgCuGrbFHGISYRM0zpEWq/Yg1uZZGqn9IbWKUL6YDd7n+NFl4aUAxM7lR2eLsi0aBrCvO8N1fWI13CTX2cGAb0r3pMSEi3mC+oNocxhexa8+CZRRi2JsLyjifTt71CtJLQzOzQT7dwy6Az/pBQ9EZQnHG/tS/NkcQJmGoeP8hH5hd42cXnFs5qeHCpsp4nWJY12t0L33DiYUEwLcL1FReCm+G2eaUhtrkd7mKZeBbLsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmKsTeDHRztTv7yB+qI3ZclbJn+sgY6xlTS8D9b6Z6M=;
 b=dV8Zi5wHK9hluPZ9LvXC4oJ1bi/F2EuOP9tHeGW0rIIYeifdPMhpvMDwN0y2XsSIyxNY862DcgPb1s/D+OptALP6WnsrcAdEjxFI7oBsrxVnlzLhuiIrMiMzh3Tp9WGhdrqIIRec3AMoD27rCoxo4rcltoBCZKjxBBpj/ZEnyCbJnovPm+Jw1dSc8QRENdZwA6I6Ul1aIDMCoMLRnt0aXucNxGj6GB6iUgcofXfzd2Q9IJs9Du4lhs9wFt9q9vvMfyaNKFedYRg6jOs5cZsPiWK6ds0krWkWIcZmI2Nv1TjzJjBEV4LwOF7czVU/GlcsAAOmngv+ul219lT58A8ccQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmKsTeDHRztTv7yB+qI3ZclbJn+sgY6xlTS8D9b6Z6M=;
 b=LP3pO3+3TyrQjAgYLDXyE/PTMhzTD7z4Wq0GlQXL7+MrBSoMKX99tif6vrWtPE7ZGnpC0lJ5IOtHv9CTbl7iRUuFnikjA1p3qwGHeFnpT5jw3XquuVoO2hNyhIWqV6hYCWm5nmgOU4z7rsf4KHA4RiwDfgCfEYQC+jTwj+ludwc=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB2063.namprd11.prod.outlook.com (2603:10b6:300:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Wed, 4 Aug
 2021 20:52:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 20:52:48 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "Sergei Shtylyov" <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Simon Horman <simon.horman@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
Thread-Topic: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
Thread-Index: AQHXiSosUCoOA3E2bUW3hSCJKNRp/Ktj0jJQ
Date:   Wed, 4 Aug 2021 20:52:48 +0000
Message-ID: <CO1PR11MB5089A77D5388203C4AA2F9E4D6F19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210804121318.337276-1-arnd@kernel.org>
In-Reply-To: <20210804121318.337276-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5e00065-32ae-4ded-81c7-08d95789d168
x-ms-traffictypediagnostic: MWHPR11MB2063:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2063DDCBCBBD05F0665E7211D6F19@MWHPR11MB2063.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wx3AhMaMBKcWDBtdp3fAgXv+yWmnJ3mwglCzmJRlSc1P/0uzUmyXL79bTBXgkvgDDMEbMimv6vO9qJdPs5+vmRNYWQeTSAzPVjxx4y49Q7r/fVx3lbIdXgBnLiSmkdS35kMIZEUsaaEW1cxiSikARFBei9aNksCXHDHPYTwPFHIZJqUhEQGyfoo0hVUl6kOiQ1ke9BLV/lzRryx0R34lBPTrqDFKRZsXMlYwQrBE9blEZcDohZhZaqXTpAdlIf/wIXwmW9fsxfL/le9TXqqaKlYY6Fnx/M4zGbSURNc6Nupt3LcCGhSB37/gnBLb5cZiFOVY1Z9g88AmSh7l8F2eRXKMbqN2Frtx44eBoTJb7q9o0jION9fOoc9/uG1wWt2jB5o1qRvsO5+eXDMol7t7RCD39k2GQGUYp8niPM9uP2hgiHxGsfFf/+CNNdEUdBrYHyyF4lkPFiml8KLzpZEGnsxt0csvw3WxhaP45hVtM6zxXyz77+lS2/lryd3z936kiwvmY9xFGvfzmxfxVwgrA3TDwTZ9gBn6SvPht5HBTuNbPZcKBGm/3t0tm28bbZ9XqC92cQLuVyF3zwUFr3uOkW7oXSUy13k+qLpGE6qgj/4njYKYmIcQuDfZMNhP6WndxuovwWqeEK2fxyvXjRjUa1ZKFQAsITp8+jGYhZa1BHyO1Dd2eMuJvlZ24g608INhjE57C/zHafQjuZuMwG0bm4T76clnq+Xv3+soFCyhmiYu022oyhVssk05SHpVTERbArd5lx8VcrGLEeeDtFBi5qJxMb0PvIjuCSMx5g8qKcnTr8jq+qdsl6IYrOatiVkr3O0ngFVWu//5QSMXdVrUEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(186003)(66946007)(53546011)(6506007)(26005)(8936002)(83380400001)(76116006)(66446008)(478600001)(38100700002)(38070700005)(64756008)(66476007)(122000001)(33656002)(2906002)(8676002)(66556008)(7406005)(54906003)(71200400001)(4326008)(7416002)(5660300002)(52536014)(86362001)(316002)(7696005)(966005)(9686003)(55016002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b2Fp4RhH2E5/MsaPcQhLiIB4WjHgCda3zS1emeJ/RLybYuOVE8QPiYW8Xy8n?=
 =?us-ascii?Q?wHsKZWvrcimcM6iPgQD0KMuI5YtGzNOtj0PaGv3zqRN8aHIKOjgh95rON8A4?=
 =?us-ascii?Q?WTl1roHfs1hqET0h1sootHASIn0QnMhFE80W7AW+/zV3AcyHM+TgcMTZovvB?=
 =?us-ascii?Q?9eazvlcFVMZgcoz5jIPolShBz4nsGMc9y/K3KxCz5jyl3Dua10FAFBYwAJOe?=
 =?us-ascii?Q?XRdAp7c8qL0KvkvWeglzXi2IhN1h4Z5xbqY1PyDIzPteM5yHkuSopEDVpM8u?=
 =?us-ascii?Q?RuorVFx4NHtMGa866ix9hpYKNWdo3zysa74He42DJsn7TVmcWwF4fUwjd36a?=
 =?us-ascii?Q?9SsPAWV94+hEmjyJEz0pDLgOuUZxbq+x0xrZhOyoByROSNuFFA4k5WTFZ9T7?=
 =?us-ascii?Q?vnOi1dmGSKtFooriOeczYtT+Vbk/9vVe4Z2HtH/jCthxLD6KOOlr3BR3aadl?=
 =?us-ascii?Q?eR5DJucNxgWouV+NBQftPAO/94SDIa9150l8IYTCC/U60YStmH1Mhf06GKi9?=
 =?us-ascii?Q?lz/Bmsu3jpy9HSt8DAgdCfGCTvSx+UnA4DS7Wv+oqum0jdeab/rhnDaojxr4?=
 =?us-ascii?Q?zgqctLeHyV2wDN4iZFe3F+3VGDl6bw0o6oXSaPl5wpzU5T7QIRW9LzD8+J0a?=
 =?us-ascii?Q?t0tToX22dcmqfWjb/5FyhVvmmrfFOCZqBakvjPMKkApJAPqXiCZM6ndFD8vd?=
 =?us-ascii?Q?0uxS81j07oQnq7kVwg7nB+gwuqXznSzsx5Ju+K/dehmVo0+//4ToSg857APM?=
 =?us-ascii?Q?GqSmETx4u+Hxhzyv4TtQMowHgU0EACmZZ8ynOveoqeO5ZQizcEehu3/sKFQl?=
 =?us-ascii?Q?b1Pqwf7pgZpDlPkJnu6U78aPCMfqhx6s2QsqBOmk68T/+uBLmxA8UkYZkc0v?=
 =?us-ascii?Q?QQED8oa8vudvtR9oDJQ+91fPxn6stm+qddw9ln2sDbLQxwfNgdG1OGv1n3rp?=
 =?us-ascii?Q?AJAyo3cVG+d9R/4Iy+R/kh1Rw/6D+nj/+ipoltq3awRyBo9oG4OcIywsNf+Q?=
 =?us-ascii?Q?WZttcuI72pFr70XvB+augBzrhD/r06SIMOLPBaAVCT6VObIIW/0u48V+Lb/n?=
 =?us-ascii?Q?0bfGXGlpOvoOuA9Gp50mfUt3442H6bNyMlY7e4bLJOVF29PZrnt6nG+Slh5j?=
 =?us-ascii?Q?8pqs4btJ4rafFDU/+BO5h86NmsEerw4ITv0sC3BOn5Xezv0cAoJIAioubFLK?=
 =?us-ascii?Q?qU5ARc7sTnC9Qpy7uLNEyW2AeZckmsfMYRDfp5nEMcHs4F783zJYjuNNhryd?=
 =?us-ascii?Q?EO4CMt0omAat+dYyJckMP0HpWjOrBbdg3X3WIA71TLabARRN4XQKtWG/JS9Q?=
 =?us-ascii?Q?+5g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e00065-32ae-4ded-81c7-08d95789d168
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 20:52:48.2858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJAGPptXH6CQfzp32Mjy5pbrbNmhB8InvDpl+jfs1RYCiMfV+G603Uf8DLRa7uwJ78Ya4LAvLCdv+9U17hqUz8oBln+D5/Q+b4nqLwisMAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2063
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann <arnd@kernel.org>
> Sent: Wednesday, August 04, 2021 4:57 AM
> To: David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.or=
g>;
> Richard Cochran <richardcochran@gmail.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; Andrew Lunn <andrew@lunn.ch>; Vivien
> Didelot <vivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.co=
m>;
> Vladimir Oltean <olteanv@gmail.com>; Claudiu Manoil
> <claudiu.manoil@nxp.com>; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; UNGLinuxDriver@microchip.com; Nicolas
> Ferre <nicolas.ferre@microchip.com>; Claudiu Beznea
> <claudiu.beznea@microchip.com>; Yisen Zhuang <yisen.zhuang@huawei.com>;
> Salil Mehta <salil.mehta@huawei.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Tariq Toukan <tariqt@nvidia.com>; Saeed
> Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>; Jiri
> Pirko <jiri@nvidia.com>; Ido Schimmel <idosch@nvidia.com>; Shannon Nelson
> <snelson@pensando.io>; drivers@pensando.io; Sergei Shtylyov
> <sergei.shtylyov@gmail.com>; Edward Cree <ecree.xilinx@gmail.com>; Martin
> Habets <habetsm.xilinx@gmail.com>; Giuseppe Cavallaro
> <peppe.cavallaro@st.com>; Alexandre Torgue <alexandre.torgue@foss.st.com>=
;
> Jose Abreu <joabreu@synopsys.com>; Heiner Kallweit <hkallweit1@gmail.com>=
;
> Russell King <linux@armlinux.org.uk>; Yangbo Lu <yangbo.lu@nxp.com>; Rand=
y
> Dunlap <rdunlap@infradead.org>; Simon Horman
> <simon.horman@netronome.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent
> it from being disabled manually or built as a loadable module when the
> user is built-in. In the ICE driver, the latter now causes a link failure=
:
>=20
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_eth_ioctl':
> ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
> ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_get_ts_config'
> aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to
> `ice_ptp_set_ts_config'
> ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_set_ts_config'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_prepare_for_reset':
> ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
> ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26 =
against
> undefined symbol `ice_ptp_release'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_rebuild':
>=20
> This is a recurring problem in many drivers, and we have discussed
> it several times befores, without reaching a consensus. I'm providing
> a link to the previous email thread for reference, which discusses
> some related problems.
>=20
> To solve the dependency issue better than the 'imply' keyword, introduce =
a
> separate Kconfig symbol "CONFIG_PTP_1588_CLOCK_OPTIONAL" that any driver
> can depend on if it is able to use PTP support when available, but works
> fine without it. Whenever CONFIG_PTP_1588_CLOCK=3Dm, those drivers are
> then prevented from being built-in, the same way as with a 'depends on
> PTP_1588_CLOCK || !PTP_1588_CLOCK' dependency that does the same trick,
> but that can be rather confusing when you first see it.
>=20
> Since this should cover the dependencies correctly, the IS_REACHABLE()
> hack in the header is no longer needed now, and can be turned back
> into a normal IS_ENABLED() check. Any driver that gets the dependency
> wrong will now cause a link time failure rather than being unable to use
> PTP support when that is in a loadable module.
>=20
> However, the two recently added ptp_get_vclocks_index() and
> ptp_convert_timestamp() interfaces are only called from builtin code with
> ethtool and socket timestamps, so keep the current behavior by stubbing
> those out completely when PTP is in a loadable module. This should be
> addressed properly in a follow-up.
>=20
> As Richard suggested, we may want to actually turn PTP support into a
> 'bool' option later on, preventing it from being a loadable module
> altogether, which would be one way to solve the problem with the ethtool
> interface.
>=20
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810=
 devices")
> Link:
> https://lore.kernel.org/netdev/CAK8P3a06enZOf=3DXyZ+zcAwBczv41UuCTz+=3D0F=
Mf
> 2gBz1_cOnZQ@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/CAK8P3a3=3DeOxE-K25754+fB_-
> i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/20210726084540.3282344-1-
> arnd@kernel.org/
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks for the "_OPTIONAL" symbol, I definitely find that more readable tha=
n the "depends on A || !A".

> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> index af84f72bf08e..4e18b64dceb9 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> @@ -6,6 +6,7 @@
>  config PCH_GBE
>  	tristate "OKI SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
>  	depends on PCI && (X86_32 || COMPILE_TEST)
> +	depends on PTP_1588_CLOCK
>  	select MII
>  	select PTP_1588_CLOCK_PCH
>  	select NET_PTP_CLASSIFY

I did notice this one driver which now directly depends on PTP_1558_CLOCK, =
but I suspect that's because it actually doesn't work if you disable PTP?
