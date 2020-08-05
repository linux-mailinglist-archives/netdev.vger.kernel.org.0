Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F6B23C2E3
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 03:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHEBGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 21:06:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:60920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgHEBGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 21:06:33 -0400
IronPort-SDR: VSSNC1xwLMkNRnOtNiqr7ZvDDScB2VSKiNAfkrLUgZa92Ld4pFiwt007r+8rtMCuZK53PrP94K
 wWqFCvmdXuFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="237301182"
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="237301182"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 18:06:30 -0700
IronPort-SDR: 0wwP7CGdAgpW5r+K4MNNn3No6ezPrBf0/MCwf831ufWI5lOehTVDxtC5jXdETdyCAw+TO3hejn
 C3egRNboyT5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="315561608"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2020 18:06:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Aug 2020 18:06:29 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Aug 2020 18:06:29 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Aug 2020 18:06:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 4 Aug 2020 18:06:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIXs1sOFXoR6xBxnzKH7t5a8iNHQU+ulqhqPIzbCqhYnj3OrLAgiYVQngJESsX94jHwz1pp8J3QuVHAEnXit9OG337AoBKAmCyYs/5+YB3vByi+7LaqpUBZAQjbq6oYUBCZhJmxzJMFSlZbRUbZIHhJBpp6Tz8jq7hW8D0r4x+uJ+H37IrgD3/+1P5H9Otae3MYCdFbAq8YdweCqpp5CF01XauGqY5b16Vx2UQcP4XvrmbhpwO9ZqdlScml+0N/OIdda8HCZ2pa8mA/qHuVqNIi8LeUKKuWLP4LB4e/jDPVRyBzB6fG6jGcU+pMHxP4dPe2LUF5Ja6jMUx29KQiI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIq74zv+gr4uLEdgtTHLmujgW1798JDIIWmNcdLs6e8=;
 b=ebC12Q39kGIIJCmGkuOCpRCHiQ97QbRQTqGKxAvJKxfyJGe4uE6wXpQNrl3wKGo/wyPMIe4OzGLjb9/vCNkXZ7q/nCr74oFi2o0+r8586xFFsN24CKMtcCtHmWxupsouSNSyXQavWNl/S3NnOcHv98DJMJBz/4Tf/Q5TuatEfQ05IebxYm/UmHDqJqDOFBu/+drhAFjObmnMJgDA2lqV9/hMOi+cKdyw4mPYMyiO8lwhUs9KUlO6QRVPSXiV/lzm7+govOucKTkc51O112F4cLCvNPApI0tc3ADoFfL/j8zxFM9cxUZ3rcVs2B7ZJQH2aohN5tgLsPztlmc9XSzEWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIq74zv+gr4uLEdgtTHLmujgW1798JDIIWmNcdLs6e8=;
 b=nBSOBLWwUQ58kq5dzXjhQgTp4so6OA7eNHM73C1k6BdQf3oAjM11Z+CH6POxVf76v1HVWKvwiILI1KeMnJbKRdzRyxRcLHmRTm10OOIcQQHXSaiWFnF33evhbsUr1bHZAquqeswqmQeYY+3Y4e25TAlZxR8+KeY/5cxj93pqfiY=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN6PR1101MB2260.namprd11.prod.outlook.com (2603:10b6:405:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 01:06:12 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde%5]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 01:06:12 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tom Herbert <tom@herbertland.com>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Liang, Cunming" <cunming.liang@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpwgAEdaICAC25lgIAACEWAgAQpEoCAA5A6AIAKLx7ggACqkgCAAdqXwA==
Date:   Wed, 5 Aug 2020 01:06:12 +0000
Message-ID: <BN8PR11MB37951AC65BFBDF0E9BFBF86FF74B0@BN8PR11MB3795.namprd11.prod.outlook.com>
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
In-Reply-To: <20200803134550.7ec625ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fd7874a-6ed5-4f3e-e32d-08d838dbbef6
x-ms-traffictypediagnostic: BN6PR1101MB2260:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2260D3A0CDA403B8E335A6CBF74B0@BN6PR1101MB2260.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X8eUJ8hYrNsUlMb1y4oZl46mM5MmzyMFfIGUR9idaujEyeB09e/opQJV/qpWCRZKfcwL7AdwhHGcDjuo0172fy9aw3PTCe89Sl5qBMC62Ym3y04D+U17nd9uaSQNCg5ajzR1KAlTirEKuYa1HqlDbh1YkszIivnHj5JY2oa1ZEpOsrROIKzlvSS7iaeTr+Af5ac8N1Diq8RN9rQ8ODaV/23F4O9bDkzjN72jYEJHN9ejv4Of7if4Emm143KZjrDEuccFFhUJNsRyo+7dRBozcbghZfjrxjZLdX027YLGRWcf0Zyq64waK4ZoHj+vuFftL/j0BLP118aQjfaHxJCKqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(52536014)(107886003)(76116006)(478600001)(2906002)(66476007)(8936002)(8676002)(66946007)(53546011)(7696005)(6506007)(83380400001)(66556008)(64756008)(66446008)(26005)(71200400001)(54906003)(33656002)(86362001)(9686003)(186003)(6916009)(4326008)(5660300002)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8pkyLzg/KmZj7U6CT0l1YUm+v9Tk1UU74WNpqyWl6OoyETqOuxOXyrs12ewup1mS3V+7sJaQSeGHm1fnxUX9XlkFH2y3gSZea4qGAHONr344HraIaGnKRfjWrcSuwQBcfVT5hY0s2XWABH/h1M4zsN2+FRQhpHeQvcbh5BzsqZ/hbFhk26WJIWCGkT4+bnP6ipMckbgQ6lZHZtBKtacPfrEJM2f5xbpS8BCvoKNIHLBuDuN6xcSPjLIEv5A5TDAICMclQOAbXL8EDf3NVcJ1E58KuvQG1ZOjv/L0AfStCYXj0YprsCMAUPQEww1hdstHWpAtMCn2otTOhujfaNgbpKjJiUh+7U/ZERzVUE/b2WJBGFb2vUGRhbMGz1dr2ZOOinzoKdbbDLkY7bWvtA9NdSndosSkcWgl4DrN7YMgPffi3By/DPvFLYxuKKyYpo13aSrjoQkOtc4cMjDj99ZRE2Z3EZh7h72ZEVgDOcdVmkd+1mmCJluLMONK/iYxH9VoDlYPhekP8W9KdvP1iyx/vXN0bi0L9ugk++YZZFCj/kvnzmRVc6TlICptezp27CEe406D4ZbHZmY6cFuSV7N4RllcjfuvzdgmevwhvSmxPiAYGxSXK9O55At33n7/k5s4jjTMufHgi8YVEJ8EnO9ZpA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd7874a-6ed5-4f3e-e32d-08d838dbbef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 01:06:12.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDdcFhTVWDIHXB89zWE2gtlP4Ix6Ul1NM2tm0ImS+G8A/gPyEUMJYRva5/cSCUHbARFysdOYyeeF5o5TuvtWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2260
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 4, 2020 04:46
> To: Wang, Haiyue <haiyue.wang@intel.com>
> Cc: Tom Herbert <tom@herbertland.com>; Venkataramanan, Anirudh <anirudh.v=
enkataramanan@intel.com>;
> davem@davemloft.net; nhorman@redhat.com; sassmann@redhat.com; Bowers, And=
rewX
> <andrewx.bowers@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.c=
om>; netdev@vger.kernel.org;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Lu, Nannan <nannan.lu@int=
el.com>; Liang, Cunming
> <cunming.liang@intel.com>
> Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> On Mon, 3 Aug 2020 10:39:52 +0000 Wang, Haiyue wrote:
> > > In this case, I'm guessing, Intel can reuse RTE flow -> AQ code writt=
en
> > > to run on PFs on the special VF.
> > >
> > > This community has selected switchdev + flower for programming flows.
> > > I believe implementing flower offloads would solve your use case, and
> > > at the same time be most beneficial to the netdev community.
> >
> > Jakub,
> >
> > Thanks, I deep into the switchdev, it is kernel software bridge for har=
dware
> > offload, and each port is registered with register_netdev. So this solu=
tion
> > is not suitable for current case: VF can be assigned to VMs.
>=20
> You may be missing the concept of a representor.
>=20

I found the concept, thanks, missed it!
