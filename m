Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009863E0997
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhHDUpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:45:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:61887 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhHDUpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 16:45:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="201179336"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="201179336"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 13:45:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="637112944"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 04 Aug 2021 13:45:30 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 13:45:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 4 Aug 2021 13:45:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 13:45:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7i5tarLiy7zpVXppMWvFuZf2oayz18a4mpYSqRyRBSTQKZUzQINgqHGF3bEgv++IFjBw9ZPc3RuQz0OVTD7VxVK6Xpen/9rT39LPUjD01maCOG8dCDQTCw80aazI/hDFVYas1xon1ShMVHWx9UA9/CQLAEv2tm9ctl1KtD0XcctoLvgh1UpoAfvp3WAcsnKDfXppwBHCEhQaCuthSctxmjr4beBiZIMHlQGJtcZ0/Yzc7D/63b5ONp367To0cj+ypZPyRSA/6ygKi7GhljXQzzHvAJhnJ/CmcW6wxI/A/ybz0+pNJSeuMvDQ+AiQwNGsG0W9no9GTepCSP6SZPh5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI+PlVjw9hThbkoMmcp6LYrdFGiyInzLXv1ODvvsurI=;
 b=FudOf+kM/2yAjGtLIDvocSN/35fqtDbOtalXCW486N1Pdh9ESAvE5pRdlZFpmfUZ52kwxGX+Xbz91TcFrnGJ27U5I/VLdnGTfA4bDV1aboQ/ilmXPhTlHMNPjz9bL9zvlvdSkNHRJz8/CKfFiQSGI2E3eVpC7FTvNnR6C5gGYi6sthhjhTmi7hHU39PDSjccVs7GHveBw0l8BzDWTPZyrnw86+rD0jI4VKkEJkOLcMqrLtfC7WrJkMfWjxVgGm0H00N94/XcU5/vp9rmcl5/7vQbbUfxWnWsVbkQIobI2ODq0Cpa97+IAhoTUc4NC8hguRp7/naYi86lpvTwWnmsCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI+PlVjw9hThbkoMmcp6LYrdFGiyInzLXv1ODvvsurI=;
 b=l/9KloEPGsiyIcP+jvrnUe2B21nygAZ07htgrd0FVsxnUXmc5qBrafhSWfKyMyObJaXB1OqLUF+befdtrcgZpIoiRk62kq2Wy2SiGbIuOHcLBCKmWweWfmvKMUQrvlwvn46Wdsz+1bkk4/ScxmX26N0EKWd4wpFKdwvt9GIksGQ=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 20:45:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 20:45:28 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        "Salil Mehta" <salil.mehta@huawei.com>,
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
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
Thread-Topic: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
Thread-Index: AQHXiSosUCoOA3E2bUW3hSCJKNRp/KtjZ5YAgAAOxICAAFp7MA==
Date:   Wed, 4 Aug 2021 20:45:28 +0000
Message-ID: <CO1PR11MB50895017B516FB92DB9CD165D6F19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210804121318.337276-1-arnd@kernel.org>
 <20210804142814.GB1645@hoboy.vegasvil.org>
 <CAK8P3a1EBwd+DvqnQSHL03zqaoRz_bhxj6TGw2ivpWLDT7jorw@mail.gmail.com>
In-Reply-To: <CAK8P3a1EBwd+DvqnQSHL03zqaoRz_bhxj6TGw2ivpWLDT7jorw@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 584fb085-7ddf-4747-81fe-08d95788cb62
x-ms-traffictypediagnostic: MW3PR11MB4761:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47617559E4BA2C2E2529C182D6F19@MW3PR11MB4761.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e6PUHyjEeimaUUYDmiu1IqpQZCAlMgYOxxk7UApQ1Zvx/sj0wp0uCBfCGz3RtoleajqeqP13TPqWFd2FyK21C5+rx92tJtHhYrErjGopADS9w+YGycIO9EVk+qhIYbT8v0ndSJhxOUsc6pDeem27EtEu9kxZv9SVrByvV2q7+pPGqzs4oW+46YU1CFO6NHrJu9yYfNILIwzK43iR0Esbyiq2AoUWNo6sjB79Zs3SWkf3qF92vMUG8fz42QQUVIZhfEBShkOOaVfdKuicYYBXbYkh9+5sMRao7NZJu+qnebZIkcQaMHyNryM2MF9bmnVff7tYykGdm7gfBK4zBw3L+ILEK6sCqGAZ+Mkozdn6698t3okCCsbh7Sao1J1Q5a/W4uS6ZzpqPpRi2KBwQOm9wr/yWNv2vH3BudB+mjetET9fdwjBCfChgAmidF7jR/SvZnrj4rGlLXrxIQwaeqddefbZJu/fOM2E/U90f5iwQL8s9mMroN4IZpxmlOBKKUSaCOuo7ZNuf+QjNlbxnrrp7nc8/hrGXdUyJCHlX/beiKfBKT3eHfue/+diju3Ls8oXFEF4dfrTYxjhyUicjTEuP+qUFRV9cYil6u3d3mFzI6/Dq35RMqLHaHsmeHEoWknzRb1QurMK5c5RmI3rFrV7sumDgdNx/bgLWhqEfBkkubBuK2S/Nz21GOyBkCC1tA6/qN+c3t7LRkP+mK11aJWLXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(66556008)(53546011)(64756008)(52536014)(6506007)(110136005)(8936002)(38070700005)(66446008)(7416002)(7406005)(76116006)(71200400001)(33656002)(4326008)(7696005)(55016002)(66476007)(5660300002)(2906002)(316002)(478600001)(9686003)(38100700002)(122000001)(83380400001)(186003)(54906003)(66946007)(26005)(8676002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTF0eGdZbnhuLzhqTnlGYXl5UXFXRVpYS2xTaDRiU1FFNlZkZnpkdXZXZ0Ny?=
 =?utf-8?B?bmlpS1lJL0FIOElZMStTbWxZZ09obEs3alc2aFBJYWIrWGh0NEFvcUVtaE1t?=
 =?utf-8?B?MzA2TVJFaUF0Qk5YbTVQc09PdW5VTEJlZStCalFCTnRVU2NrcnpaV093ZGxk?=
 =?utf-8?B?UWwwT1hPTjZGVXE5TGM2eVd4OEh2cWJDVFN1dXMveDJrUmZaYUtNREhsSmNq?=
 =?utf-8?B?MWFuWVJnRTdsNDJjZGs5bWZMbHBZdUpMUU5iUlB0TmcxQ0IwS2pZUjU5WWZt?=
 =?utf-8?B?ZVRKYkcrNTlNK0p0UFFrbC9zQjJ0elRmM2xBY3hWUmJpMGdzU1NBT2hrNFZ4?=
 =?utf-8?B?clZCb0UvWUlDb3VsVWh2VmVUTzZtVE9wQnk1TFl3Wkp5SlBYNFhLSFd3TDFp?=
 =?utf-8?B?K2FLQTRuSDRpMjhVUUUvME1QMzdtNzFWdlNYcWpBeVFRazVzZTVlOUJaZkkv?=
 =?utf-8?B?L1Jsa3NkcFJDQitrU0Jqb2x6eXJKT3owbTA0ZTZYdTZTc0tEeXRRRmJndm94?=
 =?utf-8?B?bkFwM3YwZUwxQ2xZUXpPSFlrb2hxRkl5c1R3N1U3RmdtTXN4ZDBtMnBlQ0F3?=
 =?utf-8?B?Wmt3NFVIMnpkTXc2Mm55U2Q4cmtnTjNmaEorRFhQSDZ6ZVRSOGh0eDRKYU1N?=
 =?utf-8?B?dmV0U3pSR3BUcnVSZWxFM2V5aDBqWU5COUNnWTNJMzNoVitZWC9UZ0dnbkZv?=
 =?utf-8?B?b0dSV0Qrc2h3RFRiZDR3cjhINVFxd0sxSDRFMlVTTlNFRmxtVzlqYXFBTU5i?=
 =?utf-8?B?RHArOGRmVjZxdDUzN1RxTWJRMFRGM0crWTRFdTdyNlRKQTUwM0FtakcwNkdC?=
 =?utf-8?B?SVRjdmlCZDE5Znk4aU1GZTBFb08yZWlqQ0hmTS9FUDNWRjZ0TFZXMlp1ODNI?=
 =?utf-8?B?VDhhU2lKTWFTZGdsejlHb3hNZnRTVW9XenNTaDRrVzJ3U3R1NlpQazVnNWF0?=
 =?utf-8?B?UHk0bTU1VVZEbHNHTDhQNm9xeWtGTTdFbGpVZDFOa2piOUZCMXlOOTdZdEFN?=
 =?utf-8?B?a1BKTlIvMUJyN0lRL1oyS3RhdDNrTS8xUC84Q2w0UUdoR2ozdm40V0ZxNnN0?=
 =?utf-8?B?VjVpaDdhYmpQSDQ0OXUyTTIvalJYbktxVm84NWJuc1M2NGtoSjJEU0xiajhW?=
 =?utf-8?B?T2NGV01IK3E1eTdIR2RZZlM2dTFzRURIdVNla1FxZWplcEEzL2pKY0Nib1NE?=
 =?utf-8?B?V2FTSjAwMS9MS0drWGtheWNyV2VoYnJlOXlzVmdVYnRBcXArZ2hNTmlUamNY?=
 =?utf-8?B?b3ZXMXFDTktCWHNOTUV1VTlBYzR1UzZPQm10S0NCN0N6empzS3N4QSt5bnQ1?=
 =?utf-8?B?SXBEQkJhanZhSTQwK0NlVnZ0R2NucDFCTTd5WUJMU2tRNzhwdWY2aC9VWWMr?=
 =?utf-8?B?ZW9WeUprNkxVbkFXZks5KzhLb1VlWUl5REpSQkZTN0s3Y2hmNkFkdXMzUjlk?=
 =?utf-8?B?SU95VUk3eUJEcnU0aGw2VzJ6UUkrS3pmSDEwRWgzdlFiem5ieEFkMFRZekkr?=
 =?utf-8?B?YUN2K1hocS8weUdRUjlMTDE5V3ltcjN1bmllRk5JNUJsV0Z3cXE4bDVUY1Fx?=
 =?utf-8?B?NEQ5alhZZ3dRU2RYRTJUZW44b2pqMnpTYUJPV1BLTE1ZM21zZ3FpVkFuOUJW?=
 =?utf-8?B?YVg1UTYzWG1GQWRQb3VFSm9WaDh6eG9kdFJ4OEtUaS9CSzdqZ0FYaFR2TkhE?=
 =?utf-8?B?K0NPVjN6ZEwrbis4dlEvY0RJeVY0TGlDV1pNZnhNZ2tlYlNJdUVNR3FjeXlJ?=
 =?utf-8?Q?Y9185Q8YTN1sAShn6Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584fb085-7ddf-4747-81fe-08d95788cb62
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 20:45:28.6944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SIRyD7n6K5SssdywNz3Nc4OTXCI0wn533emOKJP56N8z8UfR6DjRim+E3zwLKZmeRmCxp1hJR+0kJS59ovhCnq88UMKShXPlc3NPJsp2Jb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXVndXN0IDA0LCAyMDIxIDg6MjEgQU0N
Cj4gVG86IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBDYzog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47DQo+IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwu
Y29tPjsgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT47DQo+IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD47IFZpdmllbiBEaWRlbG90IDx2aXZpZW4uZGlkZWxvdEBnbWFpbC5jb20+Ow0K
PiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47IFZsYWRpbWlyIE9sdGVh
biA8b2x0ZWFudkBnbWFpbC5jb20+Ow0KPiBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxA
bnhwLmNvbT47IEFsZXhhbmRyZSBCZWxsb25pDQo+IDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGlu
LmNvbT47IE1pY3JvY2hpcCBMaW51eCBEcml2ZXIgU3VwcG9ydA0KPiA8VU5HTGludXhEcml2ZXJA
bWljcm9jaGlwLmNvbT47IE5pY29sYXMgRmVycmUNCj4gPG5pY29sYXMuZmVycmVAbWljcm9jaGlw
LmNvbT47IENsYXVkaXUgQmV6bmVhDQo+IDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPjsg
WWlzZW4gWmh1YW5nIDx5aXNlbi56aHVhbmdAaHVhd2VpLmNvbT47DQo+IFNhbGlsIE1laHRhIDxz
YWxpbC5tZWh0YUBodWF3ZWkuY29tPjsgQnJhbmRlYnVyZywgSmVzc2UNCj4gPGplc3NlLmJyYW5k
ZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhvbnkubC5uZ3V5ZW5A
aW50ZWwuY29tPjsgVGFyaXEgVG91a2FuIDx0YXJpcXRAbnZpZGlhLmNvbT47IFNhZWVkDQo+IE1h
aGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT47IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwu
b3JnPjsgSmlyaQ0KPiBQaXJrbyA8amlyaUBudmlkaWEuY29tPjsgSWRvIFNjaGltbWVsIDxpZG9z
Y2hAbnZpZGlhLmNvbT47IFNoYW5ub24gTmVsc29uDQo+IDxzbmVsc29uQHBlbnNhbmRvLmlvPjsg
ZHJpdmVyc0BwZW5zYW5kby5pbzsgU2VyZ2VpIFNodHlseW92DQo+IDxzZXJnZWkuc2h0eWx5b3ZA
Z21haWwuY29tPjsgRWR3YXJkIENyZWUgPGVjcmVlLnhpbGlueEBnbWFpbC5jb20+OyBNYXJ0aW4N
Cj4gSGFiZXRzIDxoYWJldHNtLnhpbGlueEBnbWFpbC5jb20+OyBHaXVzZXBwZSBDYXZhbGxhcm8N
Cj4gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+OyBBbGV4YW5kcmUgVG9yZ3VlIDxhbGV4YW5kcmUu
dG9yZ3VlQGZvc3Muc3QuY29tPjsNCj4gSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+
OyBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsNCj4gUnVzc2VsbCBLaW5n
IDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBZYW5nYm8gTHUgPHlhbmdiby5sdUBueHAuY29tPjsg
UmFuZHkNCj4gRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+OyBTaW1vbiBIb3JtYW4NCj4g
PHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tPjsgTmV0d29ya2luZyA8bmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZz47DQo+IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc+OyBJbnRlbCBXaXJlZCBMQU4gPGludGVsLQ0KPiB3aXJlZC1sYW5AbGlzdHMu
b3N1b3NsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2M10gZXRoZXJuZXQ6
IGZpeCBQVFBfMTU4OF9DTE9DSyBkZXBlbmRlbmNpZXMNCj4gDQo+IE9uIFdlZCwgQXVnIDQsIDIw
MjEgYXQgNDoyOCBQTSBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4N
Cj4gd3JvdGU6DQo+ID4gPiBAQCAtODcsOCArODcsOCBAQCBjb25maWcgRTEwMDBFX0hXVFMNCj4g
PiA+ICBjb25maWcgSUdCDQo+ID4gPiAgICAgICB0cmlzdGF0ZSAiSW50ZWwoUikgODI1NzUvODI1
NzYgUENJLUV4cHJlc3MgR2lnYWJpdCBFdGhlcm5ldCBzdXBwb3J0Ig0KPiA+ID4gICAgICAgZGVw
ZW5kcyBvbiBQQ0kNCj4gPiA+IC0gICAgIGltcGx5IFBUUF8xNTg4X0NMT0NLDQo+ID4gPiAtICAg
ICBzZWxlY3QgSTJDDQo+ID4gPiArICAgICBkZXBlbmRzIG9uIFBUUF8xNTg4X0NMT0NLX09QVElP
TkFMDQo+ID4gPiArICAgICBkZXBlbmRzIG9uIEkyQw0KPiA+DQo+ID4gVGhpcyBsaXR0bGUgaTJj
IGJpdCBzbmVha3MgaW4sIGJ1dCBJIGd1ZXNzIHlvdSBjb25zaWRlcmVkIGFueSBwb3NzaWJsZQ0K
PiA+IHRyb3VibGUgd2l0aCBpdD8NCj4gDQo+IEdvb2QgY2F0Y2ghDQo+IA0KPiBJIGRpZCBuZWVk
IHRoaXMgd2l0aCB2MiwgYXMgaXQgd2FzIGNhdXNpbmcgYSBjaXJjdWxhciBkZXBlbmRlbmN5IGFn
YWluc3QNCj4gKElJUkMpIENPTkZJR19NTFhTV19JMkMsIGJ1dCBJJ20gZmFpcmx5IHN1cmUgaXQn
cyBub3QgbmVlZGVkIGFueQ0KPiBtb3JlIGFmdGVyIGV2ZXJ5dGhpbmcgZWxzZSB1c2VzICdkZXBl
bmRzIG9uJyBub3cuDQo+IA0KPiBJJ20gaGFwcHkgdG8gcmVzZW5kIGEgdjQgd2l0aG91dCB0aGF0
IGNoYW5nZSwgYXMgaXQgZG9lc24ndCBiZWxvbmcgaW4gaGVyZSwNCj4gb3Igd2UganVzdCBsZWF2
ZSBpdCBiZWNhdXNlIGl0IGlzIGNvcnJlY3QgYWZ0ZXIgYWxsLCBkZXBlbmRpbmcgb24gd2hhdCB0
aGUgSW50ZWwNCj4gZXRoZXJuZXQgcGVvcGxlIHByZWZlci4NCj4gDQoNCkknbSBmaW5lIHdpdGgg
a2VlcGluZyBpdCBpbi4NCg0KPiA+IEFja2VkLWJ5OiBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRj
b2NocmFuQGdtYWlsLmNvbT4NCj4gDQo+IFRoYW5rcywNCj4gDQo+ICAgICAgIEFybmQNCg==
