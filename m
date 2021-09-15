Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805EF40D019
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOXSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 19:18:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:12749 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 19:18:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10108"; a="209536786"
X-IronPort-AV: E=Sophos;i="5.85,296,1624345200"; 
   d="scan'208";a="209536786"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 16:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,296,1624345200"; 
   d="scan'208";a="529853024"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 15 Sep 2021 16:17:11 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 15 Sep 2021 16:17:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 15 Sep 2021 16:17:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 15 Sep 2021 16:17:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WITkXehzjdQYfFwwPUhZ1bIE7G2n3FjKvfXlRikgzoAtN/Dc6scIh9y6gOUT1vOJmffog6nnBw3qkGiXSTIYBtN4bxYu79RGNL9Ck6JXwHsVrKmhVDeeR1ST79iTQTmTsMf67/soQiaouK+4gRNYgAwZxx79QL6wmakAqZGVty7Nuw+CDYJkuOtCz7nPHM+5Xsj3K/jxKH+1e22JJ/Qvs0sRQnEzUMBYFTr7t5WSNyiUy4Uvz+Svr4RRkBcvVHFEQNMX74cTOl15OoDwYr+4fQCDYjJHArtKwEOAVLyDI881EKua5N3wCyhjcliVR0r9Cyl4x5EefExu3QOUnt5cKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1mSMZAeUX+SYQuRNP/tfvXoziYDhYT8qy7S8ZHdRQvQ=;
 b=St6YowI5JWR6Rq4RJrCtZydvpnwzFAx+mgpo470s6clvRHZU5G3MzlHWONJ2ujAupFe4UVML3dPLJmz6erh2e11M1KvrPoLWbFwji6ffq3J5hez7QPz1NAqb9uDdsbB2ONW6i0qY4rMhT3yCZUHhaxt1P7ZFL6yjiQgbm3FnSFzsEEZ/soLXHM4Lz7nl21Xuv0tSEtt8u9NGhekOGEFcBm2yfKSMP4MPm5DmI01ZjkkyVDWMv2FKZEG7fnsaCXLIjEMtvKWqT9geNOGmIM98x+DbHtPS7F9X1THMWzOAQcAAgrnzibOag5gUFu0gGbHln+1MFcWt4b8weTgW2XtUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mSMZAeUX+SYQuRNP/tfvXoziYDhYT8qy7S8ZHdRQvQ=;
 b=hC23K/LgvfXTR4TMnTB4n9ZOnwJ84bk2hV7XsvB26lqObyWg4uWd696+VU6aw/uHYG2Y0E7eUOrISxXk6AKlI1NzCQ42eQD7sWKZc3LcrjS9wtPh9hDtTyNY9A7ogCPu9DX58cIHsskjOFnSihHJHLkfp8Hd5K6YeAOYkm0dP+M=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB2726.namprd11.prod.outlook.com (2603:10b6:a02:be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 23:17:09 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::8cd:e7f8:57d5:fc8a]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::8cd:e7f8:57d5:fc8a%6]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 23:17:09 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
 coredump collection"
Thread-Topic: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
 coredump collection"
Thread-Index: AQHXqnzZ50olsslNJEu+9mi7g9MJaKulueiA
Date:   Wed, 15 Sep 2021 23:17:09 +0000
Message-ID: <SJ0PR11MB50088886CB7E54A9A9E719C7D7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20210915215823.11584-1-kuba@kernel.org>
In-Reply-To: <20210915215823.11584-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98146086-ed74-4dd0-42ee-08d9789ef15b
x-ms-traffictypediagnostic: BYAPR11MB2726:
x-microsoft-antispam-prvs: <BYAPR11MB2726A57C094DF061417F3BC3D7DB9@BYAPR11MB2726.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/vJbdk51Po6wJpbtmvbVn/Q7emZthmxZsxAfd1hZjKsZ3DQFBj5MuZ1Y+eyF3QqVf1sPjkYPSXGYH9599cRptDmPiOsd4qOawmxTUzp6hWRenSlGjn1FlHS/un1wEaSOEU5wbW2ccnW11L0JFO01r/43x8ojSWqlW96bgbmvVFZpR7WnWGrVNF/MSKjp1uSgYnxh53aA0amXMte1nHquvxspSos2NnSusn3xUtjCh+rvDbh9rKwMHn6Ghh/cDVJnGxsdbwGWaiIU18du7SnOh5mLGJ7XiGeuE928NtXA91utv6q97L6gCi9763OvzqwygZLPbRMFcfE6SZJLri4RRAjRXb6F+ZOvi8ugR7QhoUdBOUucvbMxzZ23ujpmhWm9fop5ZgYhSGmvmNOl6MpZUEA9cg+cOuYm058ABcXHk93fG/y+zqXvkFk1WINl0/YDwqZZuNMwTXyiYt2y/7FUj6z/dVDarqcrLHQFYoGzYmr+68ZGdPNSU0njW23tEL2ZFql4Twb6L1HxTqJ8QXmZ8akwaibJrS1fASZ5H+TXcIGKM0eoJSuP9ydI+dj77DAaTd2TMATfeMS5Wv2FkWrGnXAvlJErw3tXBA8eBJeRxZI6+eM1yO/wyggKiQQtFD6IUIs4vnXUgjkO2YbkoBkCBgQcxwgu9VXY4MZt/OesqZQW79hLUXUPATEOjBqsXgBE6rQZdU5tO5ulf7nxEcEMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(26005)(66476007)(66946007)(66556008)(54906003)(316002)(4744005)(66446008)(7696005)(5660300002)(76116006)(64756008)(110136005)(8676002)(186003)(38100700002)(6506007)(38070700005)(53546011)(4326008)(9686003)(83380400001)(122000001)(71200400001)(478600001)(86362001)(52536014)(2906002)(8936002)(33656002)(55236004)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e3NUx2LgrFPlwBdw2Sw9ADMjgMfCue36cax/mvuUnXzD0kgDOlSMF1kapCtb?=
 =?us-ascii?Q?ByxmFatVSrMYmvaYfmtXjXYbDXqgj2G9EHv2ej0D6zxlpB5GFLbHeYtlV28o?=
 =?us-ascii?Q?ks7qlBloVti0kLktpiLFqSxZdx2xdRvGAUcYjotDsaVJ7vD2x25Inihb6WwG?=
 =?us-ascii?Q?wsXQmtBKBjTfgOpoyB81WbSbY19ErrklJpb30gaXB78LuSbWaAwriFBkwMZg?=
 =?us-ascii?Q?o+LPQFCrR9an38lKq3ml5RSlvfHg3w5TNWLMJG2EPEh1MJVQNJIkbUOJgm8L?=
 =?us-ascii?Q?z78D4OdioMp06l2BrQo8N91L+kCpjpgzD6v/0fC0/sAvbeysiZSFySJiUY6J?=
 =?us-ascii?Q?PJGLyr+4V9ByOcHoc98j8ImmM+tKxWvyMTFfyuQ+90aa7MlYn3/1jFOFPHwl?=
 =?us-ascii?Q?LKsW7y10CV+ShO984GGlOejEeERQ5ORSAekYCqg9XZk2LGA1jOf4WmXfsgrq?=
 =?us-ascii?Q?0gqxmrNDWrcTkSaYaegjMRJd6XduLGkL5Xfav7r+Iifxv8YYCP1MtFNdksrI?=
 =?us-ascii?Q?JFmewp6d06zs12wdQ+u5+BnOau3b4V8zfDl6iIZ2qk+90U9qFBM7qZPvZfPX?=
 =?us-ascii?Q?zCsA8AuyoRlDDWSBSgSrKcGx853TIvB2TFBlDM0NReEmzD/SOS9kySOIFgYB?=
 =?us-ascii?Q?6+8u3lqacAIAvMH6zsx5q7H6liV381HPC0m7uHpw5DgCL8K/070v6D+MSYSB?=
 =?us-ascii?Q?gwpeEWvhcwC6zMWMs4zakE6ULWC3yKGRrNZvZtPgMd26aBK2kjrkvXAvXjJq?=
 =?us-ascii?Q?1hSIUtGRX+aPm2g/mNBDbgf6tHmN5hvwlAUW2Bv4D1Wm8NU6dP7CfC4nsohb?=
 =?us-ascii?Q?2oPipuSC1D9PWscOs3EDYS87CNhx3dv/rF2dOSVDaYAb7NDS3GOO1x/C8/of?=
 =?us-ascii?Q?ku2CBauh3jVXI5hrXBObkeD6QR8LnkMTRAy35hcsTD12oSS7CawO9VuZaCZm?=
 =?us-ascii?Q?MN8QkEaqMcEMMLfKf4AbyKJXoWM94xyKcqaCyeMoNscIZrw+L428MQQaXXpu?=
 =?us-ascii?Q?kAvmhqqZUch8xXpIyC9yhGsDws08ITfpA9eoEgspPRjgz8B8KewqpDAIqjgL?=
 =?us-ascii?Q?fmI8y+LrWODWUW/PmVN5StqIh4I/VJBrMFb6C7yhvuFJ3PDHSx//2lZA1uY+?=
 =?us-ascii?Q?nMlZd+XF0/pN+4DiOCt+s4QIB2NQOBCrfAUT8HafDUJU3q71Y8g6HepdrjLk?=
 =?us-ascii?Q?ITfyqmO9/vox5lWs5QyhTxBcjDN/Gvfd3FAOmOY0jOZzotQXXpdRJgujY9H2?=
 =?us-ascii?Q?/WzEP5Nllv4WQQVhLC3SYzUB4sovBE7Y4XGNqWTrogW74NDxydsssJLLLyxd?=
 =?us-ascii?Q?7as=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98146086-ed74-4dd0-42ee-08d9789ef15b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 23:17:09.8583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T2QxQ1f0guiWViVhrrz6fg0bqRToY4SJvCwkKn2rG/+X9nHon+YsIx+MvIkmtA6FvaVev6spKYWcZKokaPMB7O/XzW9uvd5cG5FPVVuO/mM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2726
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 16, 2021 3:28 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; loic.poulain@linaro.org; ryazanov.s.a@gmail.c=
om;
> Kumar, M Chetan <m.chetan.kumar@intel.com>; Jakub Kicinski
> <kuba@kernel.org>
> Subject: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
> coredump collection"
>=20
> The devlink parameters are not the right mechanism to pass
> extra parameters to device flashing. The params added are
> also undocumented.

Could you please suggest us how should we pass extra parameters ?
Also I was about to submit the patch for documentation!!
