Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AED254BF2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH0RUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:20:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:20125 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgH0RUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:20:11 -0400
IronPort-SDR: 4P42dU+vtTTYQ/N6laWTjruy4WkmRkMm8u5c1cVeCa7x7+SGuZ8GO5jOBilkROPR92aH9nlU1X
 McB+ffsKjc4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="154085684"
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="154085684"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 10:20:09 -0700
IronPort-SDR: 4BfubxniO0fJI6oLrDP9nqrYJKVfucCwHPKleJS6PQM88B47Si/88DVRyzQnZvNITqckvU7w/t
 LySHtBczE1zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="295808650"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2020 10:20:09 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:20:00 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Aug 2020 10:20:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX112.amr.corp.intel.com (10.22.240.13) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Aug 2020 10:18:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 27 Aug 2020 10:18:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPNE2QfhhQuvNF33Xo3q13xlKr6hwcO4T0as9re1ehgrNn+bNBs/xwjNdo1ymd+FROptJ+46gh32xBvPFWO7KXTAJPHAGs8f4MkDZZkjjf/yUYu7tMsk0IeYArSJa/UFBIujUiPqTqppQLj9KSt3eQgq+Kk+C5jVxC4Zd2uKKR4cOcNzz4sArMNSooMHf2hvY6Ze3Y2VndM7Hajml+O1NzwfujahYmtI8ONgRJRFGrldJ4QoL5O+ytefgYqNk06C+FvAOkVzI3xcb+9ZtWsMdzIYIxAcqKl4p9CeyEfUzijo2quA3Ty2AUQF+FwbSgbqbWHRsqrM1LHOMi+UC1e4Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmRT1hQiMKLlLHrZUo+UES9iU7oUKOwbnSBMZc8kdlA=;
 b=Gp1WyFoa6I1rfeHq2r8+u4VNr14y1ikPU8rrAhWMkSlVgot/0AQm9xrCtUPT7pYUKR5myCs/YwUMTjeXtx+hO+tGRXTTZy9qMTB+vqwZ4WpMs2ASDswSzt/9nkfZubjuQ5vKfCmhKbS30PSZIfdqXAWQ1mRfTm1BrdI5S7G3KsnyA3cua5bcmY71bRAfjvUZ6hjlSu5HGN9rh5bOSN6o34ebWNsZJS9q1+l1TPrLnUW9nPX7qS9yHtOKTI84S1EJKKgHki7QCU7ONcgmiF4D+VThf8HhDgWR4H3/BSgLzDxFrEGvl1/PjiMJb2WXrEAtsMF3MRJD3WZwPhz7UxjgTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmRT1hQiMKLlLHrZUo+UES9iU7oUKOwbnSBMZc8kdlA=;
 b=LJbY8NObwKQi9ydOKKbtgfNUKuov2YLwkSdWDpMjl7IVsVB8ti+fCyiIbRGy+CaN+fA/Nda0K6vNUBAvEujF/262j06Hvf2dwZSEoQBZNGhq75umEfYBrcMKeZYLOTyHHy3/f/DAuYIXHC732zit349XdO5n5lF/TZPuu3tAh60=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1727.namprd11.prod.outlook.com (2603:10b6:300:1f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 17:18:25 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 17:18:25 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 04/15] iecm: Common module introduction and function
 stubs
Thread-Topic: [net-next v5 04/15] iecm: Common module introduction and
 function stubs
Thread-Index: AQHWejy1tOSD76N110WqZPtCXyg6lalHuUyAgAR+B+A=
Date:   Thu, 27 Aug 2020 17:18:25 +0000
Message-ID: <MW3PR11MB4522ADD532ACCF8C7AAF89BD8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-5-anthony.l.nguyen@intel.com>
 <20200824134105.1010fd2f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824134105.1010fd2f@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68d5ae2e-cee2-4217-471e-08d84aad3519
x-ms-traffictypediagnostic: MWHPR11MB1727:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1727FF5AC2A8E8B84FD244398F550@MWHPR11MB1727.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A3Vmbk9gAEGEurmogkFQ6N/YaESVCCK0FxHBjnXwDqjhIIxbv0fleWXRyeHs/lpz7WJtq/2Bph3q7uFzddykT6U6SESCVuNtiTLJdWm4S+U7lGoCQ5nuCci7DVW8R3u6gRYGzXFbsRO60md88FuP9lV5GLPUHKi/EWCu00pN2pPsVLZTomtUEkR8SaO8E7iJNePCIBtETFe3Ip34TCMNU8507pjElKYrqiVGUfHFMuD0AomSXkUWjlmXJPJ2dbNj/cmicscR3HwHSShl1RrZPW45NzB4tVP90kpX2EopnTGNt4Nd24C/XrxXCiqDfY71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(316002)(6636002)(83380400001)(26005)(8936002)(7696005)(2906002)(110136005)(6506007)(54906003)(52536014)(5660300002)(86362001)(33656002)(53546011)(186003)(4744005)(71200400001)(55016002)(9686003)(66556008)(64756008)(66476007)(66446008)(66946007)(76116006)(478600001)(4326008)(107886003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CSA0f7EmtMK1YokWKJzQv3mU/2cPUh1xQ7pnftpHJXtozB+NLVME8i5DzJeAt4o2SuoXprF6xqKlChvFKyf7XDJSphEM4oWUUUjGgVFDlVt5m/1K6PK0iOXxSkgZtsIQ0tCSxT/kkvia70NVh8RJYq1eRys8fulIQHgHoulQyh/QDEws7erJkjjnr0xQpzo3PkYjCl7+sZMhCBlJMrPPTnjS5nNo4OQb3zEeK210DCYVDtdS+iGBdJzuepvHh44m2tAYpI90OtOgOwyJP1nwN25l72dNo3IX57saNa9yi/rw3JsMVUyVIIbEgKx4PMgClSwlmCwYutaTv/lzR1F5O1fHiKTYS5AbDHAN6Rw4Gxj5l25IMlzveGr2hODdMAcIZydfKK6+4tsBYj8+H1hVXGcyst8d/BsCIIcRlbt3NijgYJN6VlEuGF9gvSOiKqEhUC0y7hUXQ4BnJ7BWxJqg/bdZYoUb9vA8lzxAh7svJUYBbW6p772n7txYSiPo2MeQNF0peZNgU1l7uXXJ6UCR7Gmw/0ywwSTVVB+sXIP7H02Zktr7InvzNl3Po/YCHJpbnFc+ye1rqgnKnGbCTWlIFCX69kZCOp6VOpcO9+eCXkiYbH6nGG2WCJ0Zfo2DIIBiPFxB3Gp83aG6KzxqWPEErg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d5ae2e-cee2-4217-471e-08d84aad3519
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 17:18:25.0495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sqzdF9V5dji96kaJiYmI0PRIP012NPyD/UWMSlYx/V7XCCE3qs27eN257TcejEKZh8waPEMB1JK1E0JUYw64wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1727
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, August 24, 2020 1:41 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v5 04/15] iecm: Common module introduction and
> function stubs
>=20
> On Mon, 24 Aug 2020 10:32:55 -0700 Tony Nguyen wrote:
> > +static inline bool
> > +iecm_tx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget) {
> > +	/* stub */
> > +}
>=20
> Still a lot of static inlines throughout. Are they making any difference?=
 The
> compiler will inline static functions, anyway.

We haven't profiled the inlines to verify they're doing anything, perhaps j=
ust some misguided preemptive performance attempt.  We can remove them.  Wi=
ll fix.

-alan
