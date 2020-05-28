Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D81E5234
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgE1AZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:25:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:16326 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgE1AZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:25:15 -0400
IronPort-SDR: XHou4KGgGSruVfQsgyekgjTFI6s6Fu7a0+X/l9lGL7/X/o2xVZv2L+P+X6NHgZRlJiArBJg59X
 mSAgrS5VMOQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 17:25:15 -0700
IronPort-SDR: qMYLWdck6zFxjlL7so1xP4eMN0QS382K4Imu/Smfl9Iu8+Ywz8tSwVTsjzDYEmsdk4EQpKPXY4
 qdm488kvPRjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="291800937"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2020 17:25:14 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 May 2020 17:25:14 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 May 2020 17:25:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 27 May 2020 17:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4gjIO+Qv5c3Y6P1iUu7flhIJ1f/+2idBVAyLjKQIgOYrVdeV+jGboqrf4S13ne30emeiVYO/XjjEHotUzODNbR5zthjci27iVONyylzhyHEWsjrOwkzTcWYxHmVxySvsf8Cml450EQpF9cj9SnpJqi2EallLvAGlTPjRtcnMJ8peHoyBb7dTK6HXGNX8wHqTlZQ1qEZtVNWhxNF19JCI6UeEU8z66fRlUgHq5lXf05n0KZqcGC231/1LKghbTX6HNMsEdc6DZ21NT6/F28PyBb30jgzlZcrqauIyj6O/HGRl2SdaAnKdmg/sxo2xyVYhHp5ffzWLiM8YHYNRxCoDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOH6w6M0k2+QV6GsU1q8QAiOAyUGJnpik3dj5HPF50M=;
 b=jdAarlefAKmCWvIuppzHamUH2+3uH8XWzjgQ7kyPK30sNs1xg4ZA90ERYD0DrK9BmmdQk2VfndWujzjBQ9PRlCZw6vHYsQjuGtAmcOe2s+FdXmTYht8YJ+Li87uiDBqNrZcHJK8b/sTcUFD4gqtd7co/tjDZDL5zJ+7FVT+pORo7LQYar6LPdZsvn7k3XjLFgaT6NdAskJ7QYimri5o4Nh0JtaoC4PRLa43hMiUDniksqDXhvEPYryiDFh5XfXEovdjHUvKV2VrbZlg3slYIhACmaMErQG9nD4v1WoVxtzw3S7E2NBRWT/78UdxEFJSO+P40POUhBaY41rwW68/CWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOH6w6M0k2+QV6GsU1q8QAiOAyUGJnpik3dj5HPF50M=;
 b=Z28T5x10+QC/svQdt9UwH94GbbvzWZ8LynpVeUhnrbcXuSLSwh8xEQ9mAA44cknEUZSIaCVUEO6HOvlfBuxJpvhdvFrpAylb7hzrzm1XXuyLneDtwOl2hvx5sSCTzSOJN69NeRtwfrhglXa2a0JGIfn2nPx6DLXE/Bvczyz599g=
Received: from BYAPR11MB3845.namprd11.prod.outlook.com (20.178.206.161) by
 BYAPR11MB2550.namprd11.prod.outlook.com (52.135.230.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.24; Thu, 28 May 2020 00:25:12 +0000
Received: from BYAPR11MB3845.namprd11.prod.outlook.com
 ([fe80::6c9a:4a6a:13ad:49f9]) by BYAPR11MB3845.namprd11.prod.outlook.com
 ([fe80::6c9a:4a6a:13ad:49f9%6]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 00:25:12 +0000
From:   "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Brady, Alan" <alan.brady@intel.com>,
        "Michael, Alice" <alice.michael@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Thread-Topic: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Thread-Index: AQHWM99qPqE7VmXdPkmQAFF1oTkHpai88tEA//+SXgCAAB74MA==
Date:   Thu, 28 May 2020 00:25:12 +0000
Message-ID: <BYAPR11MB38458D4EC9D75DE299FCCF35A08E0@BYAPR11MB3845.namprd11.prod.outlook.com>
References: <20200527042921.3951830-1-jeffrey.t.kirsher@intel.com>
 <20200527150310.362b99e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <61CC2BC414934749BD9F5BF3D5D94044986DBDEF@ORSMSX112.amr.corp.intel.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986DBDEF@ORSMSX112.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 052800d3-fa76-4b07-a660-08d8029d9621
x-ms-traffictypediagnostic: BYAPR11MB2550:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB25504B67735D457B13D29E76A08E0@BYAPR11MB2550.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OT5JtTJiMEXY+qlXnbSJgkzWuFaQMvMdk3uLEn6+5FCRI7T/HJtkUzFS78Pjc3IvjHzwb1JxDLZE7Z2mP5hfdSewQQEBVZeNRqP6LNa9xSnTC5lFuPpsI02NlC+PAXOx8Nv38dxVSDwzdazUxPeEAS1ARhAq+PWAqLIybabbH5HdX9q7ZuvKJtrMbIxzY1WwxZ8FRaOHA4ANtepeyR0OZtuNyoe6L2FT9f/3S2qhQyfm6URHXtkV3XvJYS5NOUTKiYCJtz3vjic0ZqpIuqvq/fWxQr+8xjO6XNptm3dRVlHKyxChxhHrxYurGsl2011G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3845.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(8676002)(8936002)(478600001)(2906002)(86362001)(4326008)(6636002)(110136005)(186003)(316002)(26005)(54906003)(6506007)(53546011)(7696005)(33656002)(52536014)(66446008)(66946007)(76116006)(64756008)(66556008)(66476007)(5660300002)(71200400001)(9686003)(55016002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: smjlXB1YxSxJlRWcxpZ/5GazLlz+kdBNsxA0m8zZp+UyVOcfXCx1PJZq886wZfvvw27uchGGaogocsJXFB6ksYVs9OWgs34Koq5jjgLImBfhUkFk4BA25foX/08+Om3paQMaBB5HSX6Ia7fNhSGW8hBq5h2NW1BLstDpwH0p1uDVnVeDY7O0OGXkTliOL/hp2IqNkO+2VFhOzx2fun7alISJYpnf3I0tSsxGRSV6yGsc2zU5p9QyyiUDJSj+UJGvx2nr6jqJyBiJlvLCwIZ2S5z9lQxE0QjROFvEH+vC1YAKnCdGtY5vZG5adgBdiG+qD1yMmVshWjShbNhliPLpc3K48kH05yzRAkvdxy8o+TEJmhqBs0PHmU9stshW1WTd490MPNSE7dn5F+2eIW8PXH2xxpZ02LYdfyhUlG9JWY44qORKVBE2wyl17NZu91hOVinlzyUr5e8LKSRWjpcZqTMXJQOSSHfzQliZyhzksn5x0LJdBO5o99ueLiq16cA0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 052800d3-fa76-4b07-a660-08d8029d9621
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 00:25:12.3184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8KoncAKgmxVnZ0mXAfpLC63iZ35teB3y2/N5jEMbqMJLt3Yl50sK0J10DYiq1PL2rX/CI0zdznoLKU2NLjFoZFMdOvD1WV39EnA9zHN5+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2550
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Sent: Wednesday, May 27, 2020 3:33 PM
> To: Jakub Kicinski <kuba@kernel.org>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Burra, Phani R
> <phani.r.burra@intel.com>; Brady, Alan <alan.brady@intel.com>; Michael,
> Alice <alice.michael@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com
> Subject: RE: [net-next RFC 00/15] Intel Ethernet Common Module and Data
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, May 27, 2020 15:03
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org;
> nhorman@redhat.com;
> > sassmann@redhat.com
> > Subject: Re: [net-next RFC 00/15] Intel Ethernet Common Module and
> > Data
> >
> > On Tue, 26 May 2020 21:29:06 -0700 Jeff Kirsher wrote:
> > > This series introduces both the Intel Ethernet Common Module and the
> > > Intel Data Plane Function.  The patches also incorporate extended
> > > features and functionality added in the virtchnl.h file.
> >
> > Is this a driver for your SmartNIC? Or a common layer for ice, iavf,
> > or whatnot to use? Could you clarify the relationship with existing
> drivers?
> [Kirsher, Jeffrey T]
>=20
> Adding the developers to this thread to help explain.
[Skidmore, Donald C]=20

Currently this is a common layer only for the idpf driver (PF driver for Sm=
artNIC).
The plan is to switch our iavf driver to use this common module in the next=
 few months.

