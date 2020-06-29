Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BCC20E451
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388780AbgF2VXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:23:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:30747 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgF2SvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:51:06 -0400
IronPort-SDR: ILkEWKRebT8AC7p1L49Z3guuXKp7bulrLCdGdFcNXsDbL0/IBwXlQw01r7hMHgqMScvVgruo3+
 kU2wkDE6q0MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="133470000"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="133470000"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:51:05 -0700
IronPort-SDR: 3WwjY/2IawcN/61p6gNoIZvS8brVMLl5VFdWYNyxBY7BiJ6GnJKn+AVEEYJd1kdaBI7aHVNtkG
 GCwVEC8rwlXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="355540386"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga001.jf.intel.com with ESMTP; 29 Jun 2020 11:51:05 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:51:05 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:51:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wg1cafeOXb4fpY8fqqikDYdsjnpXL/Fw5j+ZHnArKt1M13U3spT9UJkUJ6c/w1rMnlwNyOo68n+Gpt3AEarMw46xOpKyLBlxuhEx4sKCiE05Mxvh6kgYb8mYbTf2FuYssffBJdR4yfRrlAF6Rkc6PCNNRBgu5BwvVEmBlV6zAVxvtTY/qi4SPvJ8NtG6MuIp//gpFP2Iou8wb5mO9MtEJX8FNI03UDmnkL3rmHpejt4zSSVv9Bp8keMN5/uXwrAs3Rpg4519/5mNqjFu8ZVe9kyzYv1Bq8CBUtCnYvkrfUSvL69x12Zwrn8h+F9xp25imyWPhk2IPM/y2BpWYXrsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYh+IdSVjhbPtmPP/87kab5VUDA8+Ye/y0znjDn3JcQ=;
 b=f0GOlR856n3xlxAuO3UvfNgWuXBHUznal5D48VynMqfzP/QJN0SsN3nWmpqr+oYlohkIHYX4ZqSqYCnn2rPIj18JSY9nZzE8qvWidrSzLsMyN61nkQdVUxg7+S2dqQLZFKSna0T4O7dn9hJb4raGRYEZUNG4H/MguLYDSWF6jLyTiDJxvN1cneqU7wbK4RpxtS/8ONMniQ8vCHJCkS/Q6EmFiyrsmStJjHqWbYfso4fpfMEBWGnZOYYnj13qtMA/4uIa3RcTCGazDtUKEFwRy3REdYwiaA4DwgwrQVASeiAW3LWIj1KbC6zrYkzqdNqHQSDoB04gsxJY1hqYbgwhyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYh+IdSVjhbPtmPP/87kab5VUDA8+Ye/y0znjDn3JcQ=;
 b=Sy64acN6KbsjVZKlMxv4B5PdKCS2QXWwFoF2Zr+dPyDf6rOmofBpo8S4PCDt1gsqBXW8Yr1BfMU0LJ0CLIh3AjMiDlHYhn7NGRk8Wq/boUlwKw9X3qyTCVUVqdFsk9NDe5Pcv+CPbpQd5YRKDLpmGHzwrvLQ/GeOZrYYP0jxmBU=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:51:03 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:51:03 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 06/15] iecm: Implement mailbox functionality
Thread-Topic: [net-next v3 06/15] iecm: Implement mailbox functionality
Thread-Index: AQHWS16YcAHH7x0WuE6wSPFuTv8zN6jrRA4AgASxIGA=
Date:   Mon, 29 Jun 2020 18:51:03 +0000
Message-ID: <MW3PR11MB4522C35BC95BCF16E3901F4A8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
 <20200626121004.506bfa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626121004.506bfa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 571e0827-2477-46cb-16ae-08d81c5d5fa5
x-ms-traffictypediagnostic: MWHPR11MB1808:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18086D98511EEBFBB7F9C4DD8F6E0@MWHPR11MB1808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tkQSNO2UJIYE3dk23Rh6e+zB3guzvKYZIOmn6oS8vHZ7fkVJwMrAs2v+vmrPVB++tfifkKcxNC42AQWNM6TnPxgwQ3DSTuPylcU2vVjOv2xn+cPs7RLQ3k/xzUS9zo9UXZUkErgIeQic0a5j27UsRZhg0aXmZoGUkKPlMe1iUlk8gq/NpGmScfP/ivAYpm/mOD5d+jDTTie8TfrLNcFivE+u0RlSCvGFfSF05L4a4zRumJLRhDchc0cgZRYLnrEcsv6IRpN9wTp4xNg50nVHdac9Jl6jYR3IS8jK6mNezUdGpJ8BWnLaDoCoLeOt3Xx5GFcerBSA9raMidzka/f9kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(6506007)(53546011)(33656002)(186003)(26005)(7696005)(9686003)(52536014)(86362001)(66946007)(6636002)(66556008)(66476007)(66446008)(64756008)(76116006)(55016002)(15650500001)(71200400001)(110136005)(54906003)(2906002)(8676002)(4326008)(83380400001)(107886003)(5660300002)(478600001)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OU9/Ix+1Fyq52hJwaonegCfqNPej1OJT3WUgH+rU3iGacFQ/2iw8xtMtvxcq2SOLYFPLy6M5JCryMfrXifAAlkLaY8QjQdUf8n7ZTdQzmwCjAvx6y3XWHXwIG7tuUiks32IpimWDzue7uPP282X4ApM6fxAXme77D99GsN8kJ0QhdrajewvjPYkeX+UalIcQgCwUTKOTOl5kWc07Y+l13QAlk87Ofk+kS080TTLbRZdxq8oM5yuUj5kXwEXPdMhEex6wt5NmvdNWbf0Gx0mUGki9BHMVjUgT2jcmGr05+9V9BEsIMwPj7OoAIAwRe5uF1RLsje3vZ6wRAeuN/Qs5iogh09ur/RHDn0R91cqdEOcOhqDGPVBhPeyBYacvIMt36FuVfkTSntI73kPs9b12LSI/Fg+0gOIFaCxa1tI0x+6CHM2kKyMMUIDm0TR3ICCZMiQi3R/lIzJvsVmNCwBUyDZv9WZ5ffzP3HSFyPBgfecSKoZby01AQzzilpAwRIhy
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571e0827-2477-46cb-16ae-08d81c5d5fa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:51:03.3931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DJWT2YbaciYeR8Y+3471cBREzniJ8RcVFk8o/MvH6EbBZzsQ3sfv+4/7gGDk5YLE/HxCY2tAcDbX5ZuRKNAOuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:10 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 06/15] iecm: Implement mailbox functionality
>=20
> On Thu, 25 Jun 2020 19:07:28 -0700 Jeff Kirsher wrote:
> > +	err =3D register_netdev(netdev);
> > +	if (err)
> > +		return err;
>=20
> So the unregister_netdevice() call is in the previous patch, but register=
ing it is
> apparetnly in the "implement mbox" patch...

Apologies we tried our best to make the patches readable but this slipped. =
 We can swap things around if you'd prefer, but that may create more thrash=
 at this point.

>=20
> > +	/* carrier off on init to avoid Tx hangs */
> > +	netif_carrier_off(netdev);
> > +
> > +	/* make sure transmit queues start off as stopped */
> > +	netif_tx_stop_all_queues(netdev);
>=20
> Seems like a bad idea to turn the carrier off and stop queues _after_ the=
 netdev
> is registered. That's a very basic thing to pass 6 authors and 3 reviewer=
s. What
> am I missing?

Agreed this should be swapped, thanks.

Alan
