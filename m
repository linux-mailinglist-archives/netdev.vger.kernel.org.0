Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818732A885F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbgKEUwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:52:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:23149 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEUwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:52:19 -0500
IronPort-SDR: Gs4UEiplqQTpigG3bPiqEHKCM/ySrAImEu40Q5ap6+ofFJIAhH/QrG6uabM1zwq3SK67Ap8Qa7
 KcSL6VcueTPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="187370599"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="187370599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 12:52:18 -0800
IronPort-SDR: 5craox6rAKb9swdbfOh5gX7xCNiz6zeUUtjBp3PPR3aTHSBvyc3Cf3AeqK3TWOqzcL6F73bK5Z
 qhTpm5YEJ6fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471803650"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 12:52:18 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 12:52:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Nov 2020 12:52:17 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 5 Nov 2020 12:52:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgcbGA1gIJEQGhwaZUgk5HFWopgM8SMjYg01j2l6RJs+/Wgsf4ZvtwGXMutmlatmayApsXtuFJi1IgqpGbIfg9g1s46Aizl9IfQ3nSV0GEVokaYckoZoQ1JY8aebEPvqPOzAIOIVss+QC2AgIzQEPAxO7E8k7H7iMHKPbXw6RZj0BNp3LEVjyEbr+oFS92UpBxVQQw7I1+lsOauutyXSy1jgDSA7Q0anlI+lIKaW3kplLvrz3NJmKreLHcD5k1BUmSq38wZ6/z+cTlp1qIWG0+f8bSelwDF1KDBHbZODbAxPgQKmeBzs0z3BqZg70dgOTofFMvx2edwRHwRTNbqRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwMgkecA+AoS9RlEsts9+uuv4vo9O+aoPYfE3lqoVw0=;
 b=LRuux+DBZkLAmWHjW7urinHVsIJIEqGMj3IifeSAjnhiUYfQg/X+O5OcDjtaIChz5wt9meqn4P2BQofipuK7O43w6j/ksXN7KOYAit1uV+QAyj5lzdPPgqWRIKFaZGxYPYF1KKAbVByjUXq6M75VtnpuU8IwvoF3W+7Ci+QHeCy8JV1p07lTaVUhFHPwUSdiOo41sNyJUdrHH1wFCOcECbmmkp5lb4VKXEyki9JAqLSnwPnYMfE0D/k8vVXo47/N8cyw+VTxCM1MEru02bRGbgZLVfXGWAmFK7a7orbufbMvYDZAcFo9NxOkbgp0iCsc3ptsb1FB7RRkR+w2tvhwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwMgkecA+AoS9RlEsts9+uuv4vo9O+aoPYfE3lqoVw0=;
 b=A4JJrfQtrOzSyVvApLAiLS+vsMSwVy84JjbZ4E0EzgMuvwCBYluAAcDcTW74Rwa4yiOkhEXj20a+8yviUg4T2KdkWTT0kA/TjLq3c6Y4YKpQDUQdywSrQDRygSzvanVWJo59vODLq6AH6gUURrtslppNzKVzkqAAxF4s+x2LUYw=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR1101MB2284.namprd11.prod.outlook.com (2603:10b6:4:58::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.29; Thu, 5 Nov 2020 20:52:13 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3541.021; Thu, 5 Nov 2020
 20:52:13 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leonro@nvidia.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 01/10] Add auxiliary bus support
Thread-Topic: [PATCH v3 01/10] Add auxiliary bus support
Thread-Index: AQHWqNRxbABQ//8l1UOfD+CnDPwsEKm5V8WAgACIGmCAACQFgIAAB9xQ
Date:   Thu, 5 Nov 2020 20:52:13 +0000
Message-ID: <DM6PR11MB2841C04DA30B0EA299554704DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201105193511.GB5475@unreal>
In-Reply-To: <20201105193511.GB5475@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7df671d-e207-40ca-e29f-08d881ccac20
x-ms-traffictypediagnostic: DM5PR1101MB2284:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB2284772B6740229B1CB300C9DDEE0@DM5PR1101MB2284.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCCZhd8Mn7WAn2gUMdZN8z0UUiQfhleFAAwXMOejlKL5pty1bEQRx0xcKMYDWgxyTwMMLkknDJ3BlfZFsG7wbrQsC0s6tVG3l3/epnekyv4XMCJPL/AL1rCsl+xSackW0Je0zYSIi2B/Gk1zO7arYL0onlN2nZM4R3RjGgzPAdDxOXI9Zqqvm02UWrBo91uGBgfnQceIZGFuKvDgRTo1xzYlANPkBMGV03oBvWB+ctyAGm1xx7heRP3ue9cFE4IB1/PCqnMImq2aTdrPB/mhbSHRj9s0LDZU4gxGUP2HU5SQ1vtTkwo9RBme0wLD37Y1Fco4HiVJg7h0QWiyjtRW5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(66556008)(76116006)(66446008)(64756008)(53546011)(33656002)(71200400001)(478600001)(186003)(6506007)(52536014)(66946007)(5660300002)(9686003)(7416002)(8676002)(83380400001)(26005)(54906003)(55016002)(4326008)(7696005)(86362001)(316002)(8936002)(2906002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qC2YGckFwNg5boxji38cJHhzXulase2Ngkxci5DLI/PQwhzFmjFbRPH/yw4MtfCH9bi9xQcmRyaXd1SZ2WgQ81805hBi3T88FN0/0h68thVUw2kAW4cCKPoCesmfAWDq3mEoUi8lUxSlVJYiFpRfxsJnSWavBQ1oxA+IWYmiwOTEbGrqiu8Fn7aQ/VPsZ9lB/3GE8kvMf9ZMZApVi5s9eemgqu63sjTElv/m18vDy+G3FBWCNQPtwki+RiSO1FAL9xqcN7yKYC4a/8hwBUxHVjXRfoT4wmzSlsWTPdjfySNamHbDu0mLs/QQZ7jjai6W7H5mNhm+Aio7UMfDPhewAXwM/QdNmloyYZbiyJLM9cH73YZjFokMrU9rlMSvoPU6F7gj14i7PBTbV304UDk00BGCHkyN+E2Hj+HhdvGwa0Yxja5TJmVgYp7ui/CLopVcsSZFqFWT9xFQG1g3cmhMzTUl6M0qVz4ea/+Ht3XaHqaCbShFwP8HjKJn2qalLAdiHjaeFMYy3Ss084zfzqnpkc0FoiU8uq5mLmrAbWhBlBGAIzP9CIcruwt4GyCnDC3WYljmAJBYCKDzxo2QW6h8HS8h0xM9GAmX/9rN9w7J5fDcInBzlIE8g0SvylfOAWkCNgxCGteoZdv93ZhcWTMJ9g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7df671d-e207-40ca-e29f-08d881ccac20
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 20:52:13.2723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uX3z692HQ3evUZUZkdWtJxopVe5R1ql7wBFS3/Z86bOmew+e8x33S23ALsuoKaMUtHF1/gTT+9PQi5HnkgWd4YhlazVPUgczk9JZfxTvcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2284
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leonro@nvidia.com>
> Sent: Thursday, November 5, 2020 11:35 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: Williams, Dan J <dan.j.williams@intel.com>; alsa-devel@alsa-project.o=
rg;
> Takashi Iwai <tiwai@suse.de>; Mark Brown <broonie@kernel.org>; linux-
> rdma <linux-rdma@vger.kernel.org>; Jason Gunthorpe <jgg@nvidia.com>;
> Doug Ledford <dledford@redhat.com>; Netdev <netdev@vger.kernel.org>;
> David Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> Greg KH <gregkh@linuxfoundation.org>; Ranjani Sridharan
> <ranjani.sridharan@linux.intel.com>; Pierre-Louis Bossart <pierre-
> louis.bossart@linux.intel.com>; Fred Oh <fred.oh@linux.intel.com>; Parav
> Pandit <parav@mellanox.com>; Saleem, Shiraz <shiraz.saleem@intel.com>;
> Patil, Kiran <kiran.patil@intel.com>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>
> Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
>=20
> On Thu, Nov 05, 2020 at 07:27:56PM +0000, Ertman, David M wrote:
> > > -----Original Message-----
> > > From: Dan Williams <dan.j.williams@intel.com>
> > > Sent: Thursday, November 5, 2020 1:19 AM
> > > To: Ertman, David M <david.m.ertman@intel.com>
> > > Cc: alsa-devel@alsa-project.org; Takashi Iwai <tiwai@suse.de>; Mark
> Brown
> > > <broonie@kernel.org>; linux-rdma <linux-rdma@vger.kernel.org>; Jason
> > > Gunthorpe <jgg@nvidia.com>; Doug Ledford <dledford@redhat.com>;
> > > Netdev <netdev@vger.kernel.org>; David Miller
> <davem@davemloft.net>;
> > > Jakub Kicinski <kuba@kernel.org>; Greg KH
> <gregkh@linuxfoundation.org>;
> > > Ranjani Sridharan <ranjani.sridharan@linux.intel.com>; Pierre-Louis
> Bossart
> > > <pierre-louis.bossart@linux.intel.com>; Fred Oh
> <fred.oh@linux.intel.com>;
> > > Parav Pandit <parav@mellanox.com>; Saleem, Shiraz
> > > <shiraz.saleem@intel.com>; Patil, Kiran <kiran.patil@intel.com>; Linu=
x
> > > Kernel Mailing List <linux-kernel@vger.kernel.org>; Leon Romanovsky
> > > <leonro@nvidia.com>
> > > Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
> > >
> > > Some doc fixups, and minor code feedback. Otherwise looks good to me.
> > >
> > > On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman
> <david.m.ertman@intel.com>
> > > wrote:
>=20
> <...>
>=20
> >
> > Again, thanks for the review Dan.  Changes will be in next release (v4)=
 once
> I give
> > stake-holders a little time to respond.
>=20
> Everything here can go as a Fixes, the review comments are valuable and
> need
> to be fixed, but they don't change anything dramatically that prevent fro=
m
> merging v3.
>=20

This works for me - I have the changes saved into an add-on patch that I ha=
ven't
squashed into the main patch yet.

> Thanks
>=20
> >
> > -DaveE
