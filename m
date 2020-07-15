Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54B221421
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGOSS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:18:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:21813 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgGOSS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:18:56 -0400
IronPort-SDR: 5ZJNm3w2NHxyUwkOhsJsjVAkj/MB9ZeV02NDtEs9LODU0Xqslm2IhtwA7/z7EovZ/DAovib8i5
 dAJ/LpyrTk5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210774988"
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="210774988"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 11:18:56 -0700
IronPort-SDR: LGoAKCxRMgXkQKQBLdYQprapMrkzZp1FKl9iDARSxPR5bmI+vpFDKhyGDNXIywqjkgnThrMqF3
 4unkRsEMaQZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="300003951"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 15 Jul 2020 11:18:55 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 15 Jul 2020 11:18:55 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX155.amr.corp.intel.com (10.22.240.21) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 15 Jul 2020 11:18:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 15 Jul 2020 11:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzQfV63XGQVRKIeIHT4x3UJVVeJboCMSk5LZIDYRMg3uFRhddNjAwUoBvv5jxWOHBZcS6P1eH4zRX52kb/A8v2nYDxj0dycDKBv3LhTr6n2G6M90XKXrLDYLYVD7Aaod90tvduPGu5UQjUEI4cKs9oWNk9DmIMRsrV1/hCAQ7DS37VnBuW4bahXgWdWA+fAAG3hyzMJFcdNkfiqBru8T4qQnevmGeCyzCZCmkLMrdzmbCGZtFxnaCAgsvxugS23ltzLLnvnRdNXiNohterQmMvK4oft9dUOdac/d3sBNoC8Qh8xQguPEjfk9HDkEZgZA+PswEYuKMSgtyw59r47xpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vewmljBVc8sIL5RYs+AdxxPCx+V+3SinCO9ku/q5rEs=;
 b=FaDsSeEYNYGkN320v8KVNzGHQKeXrpThIPErpT5mgl4Gxv8G+1QFqErjKaQ0pBm846CQf8YIDCPwzKhw+v7zsYSB+yYMAtxURywfay8Z12dXWNji4SxzonJZEHhorEWIw/HhD4qO1/HMrZvVq4yrk8hZlyb2Y3L71d/horzMafQfqge34iBqMDKeBHctGA/h5iraSIqFt+z+wxXG7iaqPJVWK3FB333LKZtDcoJRaeTUkoPvsVPi6NqZ5Fdi2Cep8yEB6x2DVFFQe8Hz9h3/8xC0Z2VWXa9EZ2N2523aBU194AL1IqN5H/ehi1TC63luo5HCAvjw0xCa3dNfsLFIfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vewmljBVc8sIL5RYs+AdxxPCx+V+3SinCO9ku/q5rEs=;
 b=zRcNci3skiLrH2zvgK2V+svwIfPKz6eqA0VFULa2lJW4bMgctBhcLHZdQyNyZ8MrGeCCTYYVdk01a/kE/lF4Y9+CJmLowjQiSF6Vw0FysU1bMvT/X+E4JRpr8CEiSK3/+GmqmJs8TTk3GXLs3TU83jGaNabj4q+3DspLXtH9RHE=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN6PR11MB3923.namprd11.prod.outlook.com (2603:10b6:405:78::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Wed, 15 Jul
 2020 18:18:53 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde%5]) with mapi id 15.20.3174.025; Wed, 15 Jul 2020
 18:18:53 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Liang, Cunming" <cunming.liang@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpwgAEdaICAAACNEA==
Date:   Wed, 15 Jul 2020 18:18:53 +0000
Message-ID: <BN8PR11MB37958678A4BE7EF5F9E58AA6F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
 <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc8c088c-1d28-463c-ca68-08d828eb880d
x-ms-traffictypediagnostic: BN6PR11MB3923:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB39232FE76E5292E10B7FF958F77E0@BN6PR11MB3923.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xbfKPVaam2i/6jeouD+L1Upr8LHogcDjzi2FUXNMwufZbjZ51VtfxK2aYkhvWdJfSo2UTzwUyaAzURtjTr/TqnyXGnClRmy6DcfVVVcOz3n9DF2uzO6Np831pi2V91yisyapdD4FcATqvNtIudj0/IR2xu8P87qw2HetHyiXpP0GoSQBs8k+qp3bFTL37cs7+9Or0qY1vv4REIkkJMzPtH1VBomGT/P1duVZoVIGQLKpG7XNoPSuAnPjrlg7SSKmpUohzyxMTZYfWuzRyICi8kORq3jFD7MMWqh+H3P5Gc+LD8Kuyd/Oci+nU05j5SaT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(76116006)(66476007)(53546011)(2906002)(186003)(66946007)(26005)(54906003)(66446008)(66556008)(6506007)(6916009)(478600001)(7696005)(64756008)(8676002)(86362001)(33656002)(8936002)(316002)(52536014)(9686003)(55016002)(5660300002)(4326008)(107886003)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Mqrc31IDV4W6Gp7Uz5nwK+TLc/vTP/ZDJ+819naiJbCKSOJ35K1AHYFiBLipYTvhNindrJX1WeMpv9E30vBDg5LQQABk5hOyTdZ2M4307Kxg1p+ZMqb1nO6uxCzlVk9RNaxUF53nAaidLcvGuk5UXllofg0KZc/fdpdulrjsagQ4oTjgLeC/iM6UxR6wdTReY5+hfg7VKbmXh3LxtMbIbdw/HABCbPbwfLXvojjMkJrGPuZUBWXJlCctnIUa2z3ewADLrh6o/KfgmsXNgWyygffXEZv2/Wkj6/e338yCG2zZedIeiVPaIya5BpgFFMpj/cbpYMWLUTtK0zxURic9JQKTjA7a6849azSFq1SRP1ZQV6KPQyRoJbv3aoBdXb8mDBbI2M6BCP4zmnUWmEmdHDmYjowPyT5OGEMJtBN5QRyHHH7kjBzHrtqrl3zmV0pIIti1BOJg7gV+6FZ9HdTy/Ia0ksk9I/uetGJHyQfY68BAZXSzm2TC+SYQ8jhnJDhc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8c088c-1d28-463c-ca68-08d828eb880d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 18:18:53.5517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WIZGFrMzIsCeBxiUF22IdTcJO4oaGgUTdDqwD5+M8793xjlsePOLmmnIxUPVcKFMSDOPBH+YLfjvgzOwaZHbcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3923
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On Beha=
lf Of Jakub Kicinski
> Sent: Thursday, July 16, 2020 02:04
> To: Wang, Haiyue <haiyue.wang@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; =
netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kirsher, Jeffrey T <jeffrey.t.ki=
rsher@intel.com>; Lu, Nannan
> <nannan.lu@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> On Wed, 15 Jul 2020 01:17:26 +0000 Wang, Haiyue wrote:
> > > Could you say a little more about the application and motivation for
> > > this?
> >
> > Sure, I will try to describe the whole story.
> >
> > > We are talking about a single control domain here, correct?
> >
> > Correct.
>=20
> We have a long standing policy of not supporting or helping bifurcated
> drivers.

I searched the concept about 'Bifurcated', not sure the below is the corret=
:
 "Queue Splitting (Bifurcated Driver) is a design that allows for directing
  some traffic to user space, while keeping the remaining traffic in the
  traditional Linux networking stack."

What we did is some path finding about how to partition the hardware functi=
on
in real world to meet customer's requirement flexibly.

>=20
> I'm tossing this from patchwork.

Thanks for your time, I understand your concern from another point. We fix =
the
real world issue by our limited wisdom, and it is nice to open source our d=
esign
to get the feedback of the net community.

Problems
-	User app expects to take advantage of a few SR-IOV PF capabilities (e.g.
      binary/ternary classify) in raw manner
-	It doesn't expect to take control of entire SR-IOV PF device from user
      space
=20
Motivation
-	Single control domain is always managed by kernel SR-IOV PF driver
-	It allows app to issue access intent for raw capabilities via named
      trust virtchnl
