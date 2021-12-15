Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4124758A2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbhLOMOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:14:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:17470 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhLOMOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 07:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639570482; x=1671106482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xeUsDb1e5lmsRgjr8Fk0jFvfYSO2whaJ1P3xs4huwlQ=;
  b=SD8oRGZYEb+Vv7wwQNNc17m5IkHWm5X2EpN3KEUxl8y5lFXES7+5hZaI
   MatQDROJxjy+s+TfKcPOk6whG8/tKCD8Fu6YK0THyRyquVMi0kTUYy3rF
   Nyw4t5XzrCfDh2aWXWjV5UvAyvPhqRbiGlahZxPRlCecKuRQ4KlUOO2q4
   6uwwwyl22RwMI8XUWAraCO5wJNI4IacEXUYYW72nucQwjuX61YZx1PJsd
   +6CzfKXR73TWbn/IWQ9oG9z2h7G8Zm/4FtOYlj7kAmD/IMt/WYw9RNdGb
   HJjmnHTPKdKG/NSVFQj/Qfp9AVdixOTY7lgBqs7+2GyWrF9tP+5mT3b7U
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="239433347"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239433347"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 04:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="482369264"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2021 04:14:41 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 04:14:41 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 04:14:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 04:14:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFTma1nY0WhqfiRHfwtzlgxOqES5DD+s59CIcwB9PklcZq04K5EUCXcRXSc0yXD2TQTZnmMi9XZa8wKzxT26POgfPQs4qm+x70M6a8idVA4gFNX11Ooy6iAW7ofXFLp9zBirWW+/owNd9G8ixhOb5mjs0QFOdlUSwNBRtRTqfhD3jNpqlJqOwyCl8aGYEV5aNlr/KecvkEuR6WC0HesDjmWE2AmVIBGJO62gXoRLR3N4S+BJooJUnFTHalqtXMPUA8xIQVJislQA6mcnLi5+3WK2FVMmprbQlKpCS5rsGS1s6exzPKW0AU2Vo4hN/KifpvOr+5cq5Z2EjwcnIEuI0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xeUsDb1e5lmsRgjr8Fk0jFvfYSO2whaJ1P3xs4huwlQ=;
 b=FnximsfK2CPeIjA44OoUUrrey0Iygb7MOjhnRCQ+IAUh79xjgas9FZSBdc1gxFEQU0NUmrWyL/PkQCTvQ5phAQ1I9GAIdvsSArXOkeHLOMg9yVEC2hdlQAoZ41DDMOB7gmfVbsaIXVyxI1LECXNCZZHnbRqMUTPf0HHCvUm3a7exyp93NjU3uPGmsNeEg9uG4VorT+poXdESP8bUvDq3oWcvqaO8yN2CvM886zEidjXlRtMjp70m6B0mAMN/UHlYi3i4scByaCYNhdMWEAzyaR3wqimyaJ8x6FA82qF3PhHsy5q866yHCPEYpuLeGVIXr6Qh+mHxa8aVZ486Sqj5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB3945.namprd11.prod.outlook.com (2603:10b6:5:192::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Wed, 15 Dec 2021 12:14:39 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::8029:d3f4:4d28:6730]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::8029:d3f4:4d28:6730%9]) with mapi id 15.20.4778.017; Wed, 15 Dec 2021
 12:14:39 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Topic: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Index: AQHX7c5gkbjtdDkUvk2JrP1IlaGkc6wr5xQAgAQ7IwCAA0az4A==
Date:   Wed, 15 Dec 2021 12:14:39 +0000
Message-ID: <DM6PR11MB4657CE134223B65B5F2EF5F29B769@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <20211210081654.233a41b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <MW5PR11MB58126A8F6466A8EAD1293D5EEA749@MW5PR11MB5812.namprd11.prod.outlook.com>
In-Reply-To: <MW5PR11MB58126A8F6466A8EAD1293D5EEA749@MW5PR11MB5812.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03c9c06d-6426-44d9-7a1a-08d9bfc477d3
x-ms-traffictypediagnostic: DM6PR11MB3945:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB39453F93533AE4FA8BDD74209B769@DM6PR11MB3945.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sy2oLv/v6mG2W1xFpETNPT4LfhNhzhN1FTTh7bmeb37c1jEwNzsplq2KPVwb9JlbWAiq1yxWaBgvPZmBlFxI3NKtpHpgnD2wER6g2Wv+Q+C9jdMqOWkDyjGoij3PQWNFcROiijcAac23oLryy1ufewrZWZotJbhT4Z07L9D83V7uO38DgBM/70gP9VknFdnqrgZHnVb199CQSTOMq+WJQIOFaB65qtawutlNvNdbC014mYLqyQZIlCRdODbQC1ywLObSURV84cum9tVO8sFTityNyb8nDs7LiMnqHzXbP8wwIrwB19XYITZLohXoSQ4DcwFYFb531ze5IHoWuOYl6T/3ViJBq9zsVE3kckYlYgcwE2G34FMUAREcgxP9VhP4NCAc3cKPwvVQn06hdKGmQX2LHB2ulb8FQNxPKMn52z4ZmoViOsFrgxgPTZE5ZALl/CjLCR7vPRbikdAiZLk3RpogTCn0R3RiAKJWh1PDyI3f93fPAZX4LmUfdhEQ1tKinxo0Rkr+4bhI9U6zPOxSVfAbJMtVOV+kbeioCMC7aO5odtzgBEB5Yyfldj2cIAIi2cYyt2toHPdudh1vHbQPY8YqbCystWoYsIaCiPbJqAdEu/PsgEOO7ZPfxPBN1BcoytMilT1ZRH0Y9gAOn7MY3m02YtNl3i0h4Ez7wzJRIu2mB6uYHeTdX9RhdMMmWlx2XfOX2cG9p+4zrtYDaYZsXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(316002)(64756008)(55016003)(66946007)(83380400001)(38100700002)(76116006)(26005)(4326008)(7416002)(508600001)(86362001)(66556008)(8676002)(9686003)(82960400001)(33656002)(66476007)(110136005)(53546011)(66446008)(8936002)(186003)(38070700005)(6506007)(54906003)(122000001)(7696005)(52536014)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?cDgkA6mHOq19JboaqUKxpwSnD8ATOadP8BbPpABBVJ1B/j7t6xJRopdI9o?=
 =?iso-8859-2?Q?NRbDrs9kXbmN/Cy2NHoDjRICsU+seCKhbbQZrfE+HhkDSvmFL7xuNEDYqa?=
 =?iso-8859-2?Q?Tloi7yFCQBsc6Zxnm7dKhBkVEM8If9ES8Zl7WCSoa7fBLkoLZ5auczpnjw?=
 =?iso-8859-2?Q?3plP4qN9ft0kISJQ4N/5bXUmyJyJsmAX5jAMc1F9m4cZlTbc4SQpJy/w0c?=
 =?iso-8859-2?Q?xucIRXJznR3r2beQh6ZpixwUPjS/o14b2eulXTIv+btPLHmnxv6ZQ16iYl?=
 =?iso-8859-2?Q?wKdN70ohEPAWXAia5zKwvKxMeX2hk2zGwOSGrMxnMYnYjthbso5bp/Gq5D?=
 =?iso-8859-2?Q?Qffbczmn/gyjUnqmW6KPpgUMeb4eDYpQ4xQUCzTTgOgbfEYN7Yjdeg0C1P?=
 =?iso-8859-2?Q?K651wAenWFqL9VXNElOPHbEbMi182qYLr3lN9a9aN1bJLrJC3IqsrmfdPA?=
 =?iso-8859-2?Q?ctJM9Lga2CeDWQJZrLleyX84zL2OJzpodoUZ0YcC+vXMyy1e6cXvWE3ExT?=
 =?iso-8859-2?Q?1DU5HwdaBnbsYZLF12ZtlgdWZ5ZECGbSe04I+/9Fp4k8jkRg5U/RSBDNUG?=
 =?iso-8859-2?Q?gfIiSJYGlkMe8rt9cpx2YKBBPE+IsZyIpmypWsRWoZd/tmSClphYDCgnOC?=
 =?iso-8859-2?Q?SihVpWJtBwOHbNZsY2k71fnBuBcqhOwxYBOLloH4bntZuQ6/QuS012zEYm?=
 =?iso-8859-2?Q?3WUz2evLMhrteYKlGOmCpEWQ/buj/C8nN2HZBIaNUnFCxxI2UdjgPti5zf?=
 =?iso-8859-2?Q?xf34ffQ+H5nwC78GPfbxzANQexVqlQj6Hy4NKo8qXVedl9urYGDx68ZeTO?=
 =?iso-8859-2?Q?m8yDxotgyrbnAlun2krWOYLyQTD9ytXWXBFBNYO5fcOUgpdIw1C3Ry+tRj?=
 =?iso-8859-2?Q?UVr/ptsZwabS+sjpL+EZ4aDCVQFkUEU2SbdiS7e1f06Y5usJaO3yUumob6?=
 =?iso-8859-2?Q?SMN1lOeuwlM6qc98nq8ucdDiTfZf9RTZfsWUlHZxRfs5CZ0SrcFeZI6KK+?=
 =?iso-8859-2?Q?R6NgALMC70meZaSXRCNWjS7VJFcb0DV0O9E1+KpdKsfMv+IwmlX9ACjQvg?=
 =?iso-8859-2?Q?1/ZxwzT+l7vYmF+8z4SVPztyv2J9RwMqD9nTRZ+0Ierovu8o4Cdr6punwC?=
 =?iso-8859-2?Q?ZYkYzo3TFkMPDukLBR9EtNzKczpo5Zm3EefAQ+ZHTMzQSfjhjGIqBITImn?=
 =?iso-8859-2?Q?ZpiIxVb/0UkRA0x+dmKtpgJDcwYs3vkE/1xdnQSDh7FE5K62lWqlh1p1sp?=
 =?iso-8859-2?Q?gNeh4BVDK1QxtS3DWPtgyNdk09jEJYoEeP2Tt8y+yhocXvLBJDJRa5yI4B?=
 =?iso-8859-2?Q?tKkb4lSdn271F9c/7CyC4ksK/fGnCu6E6t3muzeIa44bph+SEFJV7LXXa7?=
 =?iso-8859-2?Q?TXMRYBTZw8hu82mvndvFQb7afjgH3XGdlKXkCprmpxy9YbxfAIz6eVYaUT?=
 =?iso-8859-2?Q?2RSewOvOCq1z/3hFJ+IU/jX+a14VGDrSKem8elqrf4IUi94TzxaWJlXqKh?=
 =?iso-8859-2?Q?rb52dcUUpZSOdV0Hohg9zvnOak7IK29DnajTIwOoRMP2wOdPxARSvhDN/1?=
 =?iso-8859-2?Q?fSbPIoHp+3QBMHbI5WKAxSCxzsGMmMYUrFxNZF0lF7xud/x6WLPzJAxneQ?=
 =?iso-8859-2?Q?CxlSxOGXKEWZIzPfGsn8nDHHK1dXNQjFM+ByfdgtHVdsS2rtpZq0oWd9UG?=
 =?iso-8859-2?Q?Hza6ViCkYEGkod158D5w1qzinHyRHdpK+8k8SfetG8Mtb1dvhyUQ9XXyqG?=
 =?iso-8859-2?Q?7K+g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c9c06d-6426-44d9-7a1a-08d9bfc477d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 12:14:39.3433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxgWzCZdFLnovAJAGekugd34VeniTiPhMtjnjzDywmVb0+o69zCeFksrMg9XQ3bghYRWerYPOQlffRMBpWpw8DVzOEZ1yOybQT7wM60qdBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3945
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Machnikowski, Maciej <maciej.machnikowski@intel.com>=20
> Sent: poniedzia=B3ek, 13 grudnia 2021 09:54
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kubalewski,=
 Arkadiusz <arkadiusz.kubalewski@intel.com>; richardcochran@gmail.com; Byag=
owi, Ahmad <abyagowi@fb.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com=
>; davem@davemloft.net; linux-kselftest@vger.kernel.org; idosch@idosch.org;=
 mkubecek@suse.cz; saeed@kernel.org; michael.chan@broadcom.com; petrm@nvidi=
a.com; Vadim Fedorenko <vfedorenko@novek.ru>
> Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, December 10, 2021 5:17 PM
> > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;=20
> > Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>;=20
> > richardcochran@gmail.com; Byagowi, Ahmad <abyagowi@fb.com>; Nguyen,=20
> > Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; linux-=20
> > kselftest@vger.kernel.org; idosch@idosch.org; mkubecek@suse.cz;=20
> > saeed@kernel.org; michael.chan@broadcom.com; petrm@nvidia.com; Vadim=20
> > Fedorenko <vfedorenko@novek.ru>
> > Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
> >=20
> > On Fri, 10 Dec 2021 14:45:46 +0100 Maciej Machnikowski wrote:
> > > Synchronous Ethernet networks use a physical layer clock to=20
> > > syntonize the frequency across different network elements.
> > >
> > > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet=20
> > > Equipment Clock (EEC) and have the ability to synchronize to=20
> > > reference frequency sources.
> > >
> > > This patch series is a prerequisite for EEC object and adds ability=20
> > > to enable recovered clocks in the physical layer of the netdev object=
.
> > > Recovered clocks can be used as one of the reference signal by the EE=
C.
> > >
> > > Further work is required to add the DPLL subsystem, link it to the=20
> > > netdev object and create API to read the EEC DPLL state.
> >=20
> > You missed CCing Vadim. I guess Ccing the right people may be right up=
=20
> > there with naming things as the hardest things in SW development..
> >=20
> > Anyway, Vadim - do you have an ETA on the first chunk of the PLL work?
>=20
> Sounds about right :) thanks for adding Vadim!
>=20

Good day Vadim,

Can we help on the new PLL interfaces?
I can start some works related to that, although would need a guidance
from the expert.=20
Where to place it?
What in-kernel interfaces to use?
Any other high level tips that could be useful?
Or if you already started some work, could you please share some
information?
