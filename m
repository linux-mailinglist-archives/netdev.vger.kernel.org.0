Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530D43FBCD3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhH3TWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:22:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:21381 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhH3TWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 15:22:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="215210152"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="215210152"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 12:21:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="475427188"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2021 12:21:07 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 30 Aug 2021 12:21:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 30 Aug 2021 12:21:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 30 Aug 2021 12:21:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnrOLzTgStTZyEE/SprpzolhcL/BO9lD6fljpe9sj0d+BrTtCFlWaSi1ipeOxw0EQP2+OX+jh5dwdcMRySh31zuIw9CPvHj3TBRwBCaeeg40ewYxdh3jGPntC5TeBYIUWJwOdRYs6tmG2nAy/gGXaCaxAKhs7AzNEuZ6ilUZrE4O+Qpn67ddZtFUN08CFmISRuqLk8MAbxFq1xlvZWwGK5IejGRmXG3u8lx8lhanPvPXlpubsv11CXtimD5cAUQ6AYiF8nZCBjLtNv8duRbKLpdnsZjdtdvlEaVEDh0FZQDvNJ1lSgetdaTjMVbE4T/KOZAOy+6eGwiCioJ9ZiYqNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7g9iEhgjnvFwzolrIWh8YwSbbXhy6M0pnUEl0ywtFjk=;
 b=ayux2rx95jJs+LkJkDDn2kcOpEaIzidv1t0xi5VJkNYFi9ntcNk05jWj2QjBUGNyhLbar2JtcVaknDy5OfL8PT1qu4QPxDZaSSk5Q5mK3iLIliJaz2eL/xONRw34cPMTmBEbiSXZoiunbFe+T6gSTx6+wse5IdeVr7LtpDv4B1KjfUpeIKuFaWr+IhQEHWszNWn6wUzHdWe2QFV9cbu0Bb4TikyY5YqOFP9ihPKXlsMNvlB8B9spqfLPVETKOl1NweJXsXDbyJk4ceVDUvSoKF3C9/dNe001iCWwBGekarvpI6mCEnAR/Blf+oPVlyBqPP82PoJ4FaJJ7pRpdIYCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7g9iEhgjnvFwzolrIWh8YwSbbXhy6M0pnUEl0ywtFjk=;
 b=KQfiMMm2K+LZc9ysps+n0hUpe5pnbeGdOisGmhXgFsoMWUJwcuNwRELYO15mBFYEaPLzmhZmpjtI8AHTUGBXmg/OHaXjfFpkxn725BzKCCjSTCOP9l8LeIR+X+SXUS+BK8HkkLhDA7gcqXDRJNuvydKjQX643r/tcjSLfNf4/zQ=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR1101MB2302.namprd11.prod.outlook.com (2603:10b6:301:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Mon, 30 Aug
 2021 19:21:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f580:fdf:ea8d:669c]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f580:fdf:ea8d:669c%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 19:21:05 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 2/5] ice: remove dead code for allocating pin_config
Thread-Topic: [PATCH net 2/5] ice: remove dead code for allocating pin_config
Thread-Index: AQHXm4PF463jtvzHXUisL/isShLcWquIFHSAgARclYA=
Date:   Mon, 30 Aug 2021 19:21:05 +0000
Message-ID: <CO1PR11MB508999531C05589D7E380C3AD6CB9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
        <20210827204358.792803-3-anthony.l.nguyen@intel.com>
 <20210827174339.5db00f54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210827174339.5db00f54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3f9e7d5-34b8-4c24-71f8-08d96beb5019
x-ms-traffictypediagnostic: MWHPR1101MB2302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2302002B9A5692A546C312B0D6CB9@MWHPR1101MB2302.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDKvSmM1QgbyGDzbxjQceGHunujIgwSUM8Qs0c5sXw92iSCU22V3H1d7RQoPxa+rgM1MV7N/MiPu3lJJARmhBvxpGBF1huAHTI5E/n6HKVdcoEzQoZHLioHbtOReT0whxxbDGbqamEjv7JI3CdcEKhS+x5jDYGzZsW4zq57Gdpm5YeMB3l7Pl/iea+iaTNVJt+vd9S9oDsaSlnhZPWKZ0u0Wcc5cyfznwW/fnowbxJ7KetO6YOrlTJWty8gQ36GaSGA5keQ0eP+KgUeXPM1RmhbWEaNUVmru2rBskrlYby9G241+9BhASZyRHrvj9yMf/RdqCPLf/AmomEcWQFyzeLFWNHZc+XRKBBGRv623OGqZMEU1W8u+t24mLej8XsgWqBsimTugBP7PKJsyhiEogiTojQ4hhyU/0qAljVfboBONCj97BYmieC8wU3OnvofqIL9cuQMC0gAOVnphPae7EMd5XI3Mhz4i6dKMTV6wFtBFm/XLfYZoK9zSggPXF/4u8hEnn4afP9UqkBDy6umgxYytHOBJS7dxCr7KSrOJayjMHDS99EBWdijJpLOdeAzu8xx0lQvEzZPysvMqvqQnPikEER32fW3e4M5UpWa9a8DOgTLCIIKksgnZh+ROHERSZSGn9P7eAYtJw+Zv8yvN8WsfWLsum6EpEMSuJxVacwmqQspIlZcLDHPb/wQsa+R757+5/BEC6lzafBJrIRPWvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66446008)(186003)(38100700002)(66946007)(6636002)(5660300002)(64756008)(76116006)(66476007)(38070700005)(71200400001)(66556008)(55016002)(86362001)(83380400001)(122000001)(26005)(107886003)(4326008)(33656002)(53546011)(6506007)(7696005)(9686003)(110136005)(8676002)(478600001)(54906003)(316002)(2906002)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fg+E45LVPD1oFRc+1iFHum/quniGq3w9Stbhzfo4C9+gRAISoUh0DXGDacQd?=
 =?us-ascii?Q?gUhS3ovZ3PEQHji3QTVttJ5oNcUuMr5G978fPx+NIzFYgj6qlTAfMkK0zia0?=
 =?us-ascii?Q?+HVaxWFvX9VasyTU3VHY6K+JgA/kTTxqZZlIWvh/+fH12/dLxYWxfDDG5ubg?=
 =?us-ascii?Q?1U5p1wE0IshZr8uAGoXbPZi+9LIDAlnMqgaFs7a6J9VCihMgKHwtgYHHvQ4S?=
 =?us-ascii?Q?vmKEDhYpK4jJp7ds24y2GMPT4h6T0QCWI+v+dpmLVAfisZQLg+wL0TJRMuny?=
 =?us-ascii?Q?uRn+yBMXir9Fw+ZC7r3pOXUkLSJwYy7ac2WC7dCsQO+R7voG8+5bfPUXUReo?=
 =?us-ascii?Q?t3MU9DCcM/pahw5h1Vsqv7M8nGraCBVDPMvCe5acUkdAbGdVo0D2XlIG/tyT?=
 =?us-ascii?Q?WaLWw/85/45yEpEeuiVdXTsUD18AAV+UTwnM/ViP+OQ6ZXgO70sFJYzyMZYd?=
 =?us-ascii?Q?VIeI9wjlvEmC0+JLoinWAHvrsjsTPgepfwGtC/n+AlM6RBNTAQQqTdmrGQoG?=
 =?us-ascii?Q?zHn5JQ/BXmwerQUQ1GIQs5TAmI7aO7fVWMaqaMX2avNVlX7GepskTc5C6khM?=
 =?us-ascii?Q?A/36SjCWMSq96pYEF5Ua7f68pLVswjvGJjbCZF62KUP4R7ApyMxu76kt/95a?=
 =?us-ascii?Q?TONqk3WvPttDuagxIh/L06sJQCa2nHjX6kKSvkzvdHt+5Qfe/SAagyJ9alqq?=
 =?us-ascii?Q?fn7LtcPqXuPCLdHyVf7d9OUGQmafu++7aUSr/9RK76cKJTfHqsIZ6lmGDnHn?=
 =?us-ascii?Q?4767E/3yGenlzT+12Kp9meORHDur+OTmSetW+gt4BoNuwCOB1QRHtnKDnHdL?=
 =?us-ascii?Q?x8jSD3shuRnUm2bcnFZbGc59uvwFLxwOkFRfbOcqMxcL3IgHL//isIvWFbWu?=
 =?us-ascii?Q?ZTqb52hwqj4hoiaj5vT5P6uP7meO/x4x2unEPFUiw63ehWFAVfeiXjWeGZQw?=
 =?us-ascii?Q?o+O3RJBYWn06Ls76BW6FDRI/fGX2TPvvbF8b8HKi2X+zw+y7V5K08JQ7rAFo?=
 =?us-ascii?Q?XefiPzH+69VKGAkq46CzhQTD4imYwMc0bCFwq7JVFlb4t+10Gn0ZT5Uhnbpk?=
 =?us-ascii?Q?z4H7z9/YQ9bqukaNs5WKd0hI+LdsRAIisx0s3/VBqRsDgnC2GbCBWqrp6ov2?=
 =?us-ascii?Q?h5P6psjUp/LDre8DrrKxZNTPI/Du4aNEyjDpAMlZUkREUwc6pkic4fXvTSgW?=
 =?us-ascii?Q?jJbIUukh2u8YnMqske0x6s4lfT7BBuWzRCDboxJig1mp9BPJMFmytZrHXW2Q?=
 =?us-ascii?Q?d5N1a1gtullx69ZUg0FgiUysQj25iQS/Fcxhj9ZlNxfZ91AooCQAWoaU31TV?=
 =?us-ascii?Q?Q2o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f9e7d5-34b8-4c24-71f8-08d96beb5019
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 19:21:05.3951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +NEvFKERFp3dJyitaLOVgxljssAWmG6EFz5xyGkjJAyL8xAPig3fq+aZNB/mgdfObRFsGtdpddNyQGj2M5wYuBoP4KncpuBt19FnYjib4dw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2302
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 27, 2021 5:44 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; richardcochran@gmail.com; Machnikowski, Maciej
> <maciej.machnikowski@intel.com>; G, GurucharanX <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net 2/5] ice: remove dead code for allocating pin_con=
fig
>=20
> On Fri, 27 Aug 2021 13:43:55 -0700 Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > We have code in the ice driver which allocates the pin_config structure
> > if n_pins is > 0, but we never set n_pins to be greater than zero.
> > There's no reason to keep this code until we actually have pin_config
> > support. Remove this. We can re-add it properly when we implement
> > support for pin_config for E810-T devices.
> >
> > Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins"=
)
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Tested-by: Gurucharan G <gurucharanx.g@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>=20
> Removing dead code is not really a fix. Let's see if Linus cuts 5.14
> this weekend, in which case it won't matter.

It's a fix in my mind because the code was included in the original due to =
a mishandled rebase when working on series of patches. But yea, from outsid=
e that context its not really a fix since it doesn't change things from an =
external perspective.

Thanks,
Jake
