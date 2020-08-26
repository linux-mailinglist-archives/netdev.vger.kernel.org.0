Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BA7252589
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 04:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHZCpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 22:45:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:32842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgHZCpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 22:45:50 -0400
IronPort-SDR: ZdJZLL6L2xSxhWBkFEO4pMegYdVV48m9Xk3CFMP8ypf+vObcoBZujybSwFXvMq8nS4cdX25AqG
 OOZDwBCOi9Zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="143889538"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="143889538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 19:45:47 -0700
IronPort-SDR: B1G6VTklFBrsoMA9/iPjAt3vfxcd5hMzNGB3cpNLHNago9siT45VuZGXQVarBRlXFrgTyl+lll
 j6VO9nkKmJfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="339008643"
Received: from orsmsx602-2.jf.intel.com (HELO ORSMSX602.amr.corp.intel.com) ([10.22.229.82])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2020 19:45:47 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Aug 2020 19:45:47 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Aug 2020 19:45:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX161.amr.corp.intel.com (10.22.240.84) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Aug 2020 19:45:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 25 Aug 2020 19:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMeK51KAaMBcua1Kc9uTXfFJfQTARkh4Ctnwn74LgfBJTh+Z8Mlt/6H6L33HCVZrhkwHYJFay7d0C42c3y7lpNVXeDVBHoczYh4xwiQXRJxRGK1/dpEj839eh73ffSX0nQDRGzizrSdU8aVMpmaJin/bJ4vHD8C1n48ag6eAg0EQbLCDdRpC+ZlpmEi/NgEwE/WHvx98y9BuvnTKeL3hswqYRtbYBVS+Z5ECV4ivtp9bixLejBQ/XX3TFfVhsUCbzk4qO2NCx6TUyasOqa6n2bXartW/2DN81vR3FO5u9qSiOhe3PoR6x5N0KD1wapRYkrgt8HNQI4mSOjd8lwDGdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uG6KUDlFczJQyfyg7Okp5TwhK3o33hke/oDclYSoqZ0=;
 b=YUkAbavLRAo7lov20GPqxQ6WQE3bNx0Jj0XWxBA8k++8mFQpT7ZsV+kl+f7AhiwyJyKQfneuuLg2aqC2YLW+d4Wvu9jZX8fX2lE7OzXdTgL9xrr1/ZfA2QKA6H+j4offMNXHg+KcwPfE4dcxB3LFx+fOPfgjbIQrLVEi/jnZuzpulhJOWI4W2dlqST7rvzsVdX4Kd8pXHQwlyS0I0t5XQsnt9AssyEy5kg1DXWG6S2h5lAZzTYBNXXjCVkf7tK76TJHKxc+jMilCSwtWmGUJiSrACfeG51ouaFoJ6k6v8TsgPlgNwCVtJyuCANpRz9DT0mVU/qMPUUXvjSllllVw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uG6KUDlFczJQyfyg7Okp5TwhK3o33hke/oDclYSoqZ0=;
 b=cfCAckHCcUwAsB0LZoCu0vqq+9t/GgvBu0OncqeXfyqzofMzUhfw95kt6pkCZC7b9+OLkd7Kmm/fAy6VKoUm3XkEfHf1e7Pa5pKHL9/JTRXAyWuWnuhrsCKto20KWGFIANzPGV3HcVoqBLIaOMGDUP7V5DA3zBQXb9wt4Y4UzYw=
Received: from BYAPR11MB2552.namprd11.prod.outlook.com (2603:10b6:a02:c7::22)
 by BY5PR11MB4022.namprd11.prod.outlook.com (2603:10b6:a03:18a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 02:45:44 +0000
Received: from BYAPR11MB2552.namprd11.prod.outlook.com
 ([fe80::ed3b:2b32:68e7:a9c0]) by BYAPR11MB2552.namprd11.prod.outlook.com
 ([fe80::ed3b:2b32:68e7:a9c0%5]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 02:45:44 +0000
From:   "Liang, Cunming" <cunming.liang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Wang, Haiyue" <haiyue.wang@intel.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sarangam, Parthasarathy" <parthasarathy.sarangam@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "shm@cumulusnetworks.com" <shm@cumulusnetworks.com>,
        Tom Herbert <tom@herbertland.com>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Parikh, Neerav" <neerav.parikh@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpwgAEdaICAC25lgIAACEWAgAQpEoCAA5A6AIAKLx7ggACqkgCAAdqXwIAhFtPw
Date:   Wed, 26 Aug 2020 02:45:44 +0000
Message-ID: <BYAPR11MB25522AE36EFCCB409B2DE9FCF9540@BYAPR11MB2552.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
        <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
        <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795FA12407090A2D95F97C6F74D0@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200803134550.7ec625ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR11MB37951AC65BFBDF0E9BFBF86FF74B0@BN8PR11MB3795.namprd11.prod.outlook.com>
In-Reply-To: <BN8PR11MB37951AC65BFBDF0E9BFBF86FF74B0@BN8PR11MB3795.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ee7d909-aec8-40fe-ef56-08d8496a214e
x-ms-traffictypediagnostic: BY5PR11MB4022:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB40222B819B2B0BC6618BCFD0F9540@BY5PR11MB4022.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IbsIlm6ETlx1EP+3UC5Q6LI0KAem0AyuPgYEi7/4V4x5dcrLUTHGyEt841pz/Qfss4MpibNtiPxSlmxYDCSjR4VQRij8JouK6UAG2dUvhKE8FixNDpilM8y2rVvhu+3BzMZvEqageYUR0J1HMVqj2zk6l2CdiZ+uwQmwnCTY7K+A9Dd3OLlWbcBd7h57aikzLkdqpkuPegwfppq80loXpVFBJBLYunEAVoKnnhmvumv7xiHAkFK5JiOTsPSF7TSMvlCjlI0l0utw1tL8EJ7LQClrd1QPESpZwH9QQh0HdDsLRQO9nNLQ6IKmXxFOSQ+ic582PwyE4v2uQVGZXJ+t57uyj8JQ03buLc2tO6xg+onZ3jhGes8U/KqEmbrHC799iPjmRRDRt+G3zY87BiV8nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2552.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(71200400001)(66946007)(66556008)(66446008)(76116006)(8936002)(33656002)(52536014)(53546011)(186003)(54906003)(66476007)(107886003)(4326008)(5660300002)(64756008)(26005)(2906002)(316002)(8676002)(7696005)(966005)(478600001)(9686003)(55016002)(86362001)(6506007)(6916009)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BhZtdlJmrh8icwmEkHUCo4djvynDCylrYRojNTG2r77EqGuG9QPif2urrKw3DlyCR5oykc9kGKYIXqyeX3wWe0f9jPtdnlg0z/qdH00zHHg2qUXgtUQNRekGNDZOBTCfHsxtQwXohKjGMSVlyJlhbe1ecvGwXvQGkmphIBQL/eQ86d7BbfCe76D1iDcU2Ag2bbFkV+JZRFICTsKM08L7hh87oqhHe/r3ys17knr+30TQ5pX2SnozzyHjpzTxQFE1y3m8zYLLdBvSNCauVRVKBjv5lmH7Je9dkPLqat0jMcdnHklnWd0qyENxpzGnqBJChZBirTjHtueNKYWMCwHvKd3FS1YLlfBoXqvLuoItO+gYVPJUZeNs74kw/+SLUd7SLZfYD/T/ld/IBYqfWPuY38r1yELDZa6sKiJGd4CbhDWJ90+TNrj5H0+Qz8X7wvSX+D8E3qxQM4IJsGDUupaFdR+MiuY5oR89Cp7+iA5VAwhcBccFXvNJLzK8wPKpiRm4H5osLr4DVwqnv7djMowEWcl/WNYXPG4K6ZyJQwnU+kw4Pz8HTGXPVCz+qlbLheA+9wNDdNjaUnZWG0hsnpevgeglIONocMlElB9RunZ8OTeRTdRlCobYwddF0Qci7ljmnVyxOCk867SrJxBOTJN6Uw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2552.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee7d909-aec8-40fe-ef56-08d8496a214e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 02:45:44.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aov0XXjea1vl+kxZSnJNRIN5+Jii/zq6TmwMzAtYkcz3QXiRC1HXdUGpJG7h/KLmFJHY5WjcBjbxGVlYrrLWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4022
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wang, Haiyue <haiyue.wang@intel.com>
> Sent: Wednesday, August 5, 2020 9:06 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Tom Herbert <tom@herbertland.com>; Venkataramanan, Anirudh
> <anirudh.venkataramanan@intel.com>; davem@davemloft.net;
> nhorman@redhat.com; sassmann@redhat.com; Bowers, AndrewX
> <andrewx.bowers@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.c=
om>;
> netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; L=
u,
> Nannan <nannan.lu@intel.com>; Liang, Cunming <cunming.liang@intel.com>
> Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, August 4, 2020 04:46
> > To: Wang, Haiyue <haiyue.wang@intel.com>
> > Cc: Tom Herbert <tom@herbertland.com>; Venkataramanan, Anirudh
> > <anirudh.venkataramanan@intel.com>;
> > davem@davemloft.net; nhorman@redhat.com; sassmann@redhat.com;
> Bowers,
> > AndrewX <andrewx.bowers@intel.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; Nguyen, Anthony
> > L <anthony.l.nguyen@intel.com>; Lu, Nannan <nannan.lu@intel.com>;
> > Liang, Cunming <cunming.liang@intel.com>
> > Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ
> > command
> >
> > On Mon, 3 Aug 2020 10:39:52 +0000 Wang, Haiyue wrote:
> > > > In this case, I'm guessing, Intel can reuse RTE flow -> AQ code
> > > > written to run on PFs on the special VF.
> > > >
> > > > This community has selected switchdev + flower for programming flow=
s.
> > > > I believe implementing flower offloads would solve your use case,
> > > > and at the same time be most beneficial to the netdev community.

Jacob, thanks for the feedback. We proposed the previous solution in our ea=
gerness to satisfy customers who were using mature, and validated (for thei=
r data centers) host kernels and still enable rapid adaption to new network=
 control planes.

When revisiting the real problems we were facing, basically we're looking f=
or a rapid self-iteration control plane independent of a mature deployed ho=
st kernel. Definitely kernel is the most suitable path for a control plane =
and we need to enhance the kernel to add the missing piece required for thi=
s solution. Best way to achieve this is allow such use cases is to deploy c=
ontrol plane on latest kernel running as virtual machine. We shared some th=
oughts on netdev 0x14 workshop, attached link as https://github.com/seaturn=
/switchdev-trust-vf/blob/master/netconf-workshop.pdf .

As a follow-up, we'll continue work on tc-generic proposal and look for pro=
gramming rate improvement. As an independent effort of enhancing tc-generic=
/switchdev on trusted VF, delegating device specific capabilities (e.g. esw=
itch) to an assignable trusted VF brings all the benefit of a separated ker=
nel to upgrade up-to-date features in the pace of applications, and always =
prevent host stack from any connectivity (e.g. stable access) issues.

Will be happy to answer any queries...and thank you for guiding us in the r=
ight path.

> > >
> > > Jakub,
> > >
> > > Thanks, I deep into the switchdev, it is kernel software bridge for
> > > hardware offload, and each port is registered with register_netdev.
> > > So this solution is not suitable for current case: VF can be assigned=
 to VMs.
> >
> > You may be missing the concept of a representor.
> >
>=20
> I found the concept, thanks, missed it!
