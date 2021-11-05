Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2845446302
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 12:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhKELyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 07:54:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:58252 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231852AbhKELyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 07:54:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="230609529"
X-IronPort-AV: E=Sophos;i="5.87,211,1631602800"; 
   d="scan'208";a="230609529"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 04:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,211,1631602800"; 
   d="scan'208";a="532568639"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 Nov 2021 04:51:51 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 5 Nov 2021 04:51:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 5 Nov 2021 04:51:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 5 Nov 2021 04:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDn0BrF64sP0X1OrV3dJInschxMLBAutDpEr1dfJ1VwS6BePNkrPNKUDZ7xWopgrXMIC2m1YSyqCrACT5MhMpYPQELU2LDwDhgbUUTp2YZQ80VFABi4BMtvEF7J7zw4naxBYBjtfmZ9+LjV7PMpM4aZaGRKrEbrQeNv+3525Yr0T55vN7sFml0HmCHgox4viU0CM/8mkkj5PldpCuFqTD4YIFfdFlaUXOkf1h+daiFqcQM72qWRkv6WNDjSAX2U+d3LNEHyEo6Ti5+2OP32GGsHSgU7adaiQLqF9alzHG9WgWBzDvQPsK5CRpSlZwRFZz6coYmnNDVvETq9f8iLYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va+/yiHKipX66RRfogb2N5SyODMdj8E4+UqTpMy1JOc=;
 b=DZljAweDpMZBiBQiFJJjQNssrCnDH9ikH2bBlWfOkv18qd3Ja//WTspL0ednhJZhGZ6/vVCmtx+JRSDFGweec/wmcG5Mk7zI98vxd1pRMHu6NuIVLlixhmjx3UYvJ7EsNYmUlmAqDmD9fjB9fufKV/JZrCHVPM0L3VaDxCX48tHt/tLEd+VPK8DVyjBbLdlbOhTmkRuFXXvCJxnjTpqscYsWxo5QmGRJtbcoDyF8HKAN7d30YRmUGEbUz6BEiNklSQS+R/NvvRsPVBr8EJWf+UVIFpo2QX60ZpemsNZFf09crwIqqanpAYOWljHe6/X6wBi+CAiFRtb8LH1B1ltqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=va+/yiHKipX66RRfogb2N5SyODMdj8E4+UqTpMy1JOc=;
 b=VeGJmV3pEYEDHPTBR+KnEhg5zJ6HQ+CG7RTiIRu2A+kbrVeaQx0hqyJPxpsR7QRZBHYEEVzARagmORzMVpssz4nbt5KjnkLswv8xBJLMGUrUkbmG/ugmh8fZ2flB0RMMZkL2wwX7+ZB5P38UzGD7eW5v6WrtnHvjsna3jXS5bNI=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 11:51:48 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Fri, 5 Nov 2021
 11:51:48 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0VXcGtUZm/2t30+on8cXw89n7Kvzq2OAgAEBMxA=
Date:   Fri, 5 Nov 2021 11:51:48 +0000
Message-ID: <MW5PR11MB5812FA6647FF189D368C75A5EA8E9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
        <20211104081231.1982753-7-maciej.machnikowski@intel.com>
 <20211104110855.3ead1642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211104110855.3ead1642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6325d2c6-1fee-4662-1a83-08d9a052a5f7
x-ms-traffictypediagnostic: MWHPR11MB2046:
x-microsoft-antispam-prvs: <MWHPR11MB2046B40419B579B13A76F8FDEA8E9@MWHPR11MB2046.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JZEKACAjrOt1AV7KHPZ0duMCWYO46otGB+8vG8ZhLGVH41SwsnNtsxvfCA4pCrflZWuT/pshjbs5I0xu3dqEioK5vP7AECRKVPd9EIYLmMmogh+BdCuHffLoaJx4M1SzHPwZKHwbtmNZRXn2I9oXrE0BeDA1C+qVqho8x4VBFAwFvt9mBKdt608urg/deOkUzeBojTfh9OtphwtJobgKo2fyxn8lWCbfmglB3TwYsc5PyFgcLSgrvbuZGDC34CQORZ7apJV1UMjzGaZx2ZQsMJfCQN5cTyjr1uHtM1OTSgLtdGgaMUDSpd2KIjKrDlhy6UQLWlaLfkiiWoaHur7rAibMXD2MIADLYY7ojiqZybNSRYJTsRoTUFDCNFavCotEIlKpGVB3y8ojwwL7SzmUfrVspr91oEYTR6ayyOYhfsjKjoJtWY41z/mEAciEHE1fXcgp5hkjGu1TIh5l5D0sZ49IKVBEuLWS+IacMFtoLmhZ9A0oHZHoIpZTjpz7znbsx5JoY+hWUqfQnI0XCesR/BNyXFD0ZTnN2sqLbgeVzh9JWu1guOIWOfp/laLV4xSq8tJSKUckm0l3KnE0eGTRwEPP2sTfnk32B3c34WZJm59+IIlzuvMkmPV/l7xcaLdk0ZO0OqACjGuHdfNM/PtZG6Yb8aR5ugHv8K1r0uQWQ3EkR5jv5wfvuHCVIKkZmqmtf7Z8rCa0Ln9D1EvywNQpjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(66946007)(8676002)(4326008)(9686003)(2906002)(5660300002)(55016002)(83380400001)(54906003)(6506007)(53546011)(26005)(71200400001)(7416002)(186003)(6916009)(38070700005)(7696005)(82960400001)(122000001)(52536014)(76116006)(38100700002)(66446008)(8936002)(33656002)(66476007)(64756008)(66556008)(86362001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oTfM0aSMZ1FBA54fHTVgW6lnoVw7iOmyujTU5ks5kmnIxD7e0c3qzbN8hezM?=
 =?us-ascii?Q?IzymKhjIySfYf9b4mCiMAbPZE38IKAIeDiI+mSmNlpvALnyzuf1KF5r11E5S?=
 =?us-ascii?Q?GkpIrL5vkUOLnjG+1mfMgi54v9CcvWGkBosB0S9kmgi+FuvquyppsAF0nK4P?=
 =?us-ascii?Q?8vnpsR70Hp0oEzCrsbpe8xve+V4ZqNVt4T/TR7/3VLei5UeZuOE9ns+wR3nH?=
 =?us-ascii?Q?ArONTdaDBlcvwl+1ueHXChsxpmmYX6WNS2ALtUVTduKl1ZPOIhGFkNRa4fz3?=
 =?us-ascii?Q?jGCdwIHXbz/eeAt7JC0vMEMQtzbWM0uG1b18i6zS0OY7mbHzlmcVHUGSVRRB?=
 =?us-ascii?Q?YLVdW+o/ULVIbi0S0kTtKrOlO0Or77L3J5Pv3/mDke9jn/yzTNm9u+EtUoXj?=
 =?us-ascii?Q?1q5uvjDai1JKnd2qpWl+qwDJFt4g7OA/9QcP927+YhzTnEeWTLhhLXuKhBv2?=
 =?us-ascii?Q?MUm6r0magpmQ+p2WKlNtqTrdnjdLN06ckv/jlg+xZbAJEnv60aBogIeLwAiy?=
 =?us-ascii?Q?CSPQNJkV5XoJkMK5Rfe820ZeXxtpXPStKssjKj+KmFA9f8D5aUXMIE0uo8f2?=
 =?us-ascii?Q?1dX8odzHLVj+YX3YK+c+gvAhA6nWP4nggSpZolkmD1CmaLByRZVfHRlmIOEO?=
 =?us-ascii?Q?s2u5Elu36DWJSU0dLJWIulVLs/5tZBAziDrOccpr2AevW6B37EsynvqydZYy?=
 =?us-ascii?Q?deFCii79cMJI/+TuNg/pMYvJPKtPa4xrzPRaaHMft3z23d8NCyfWhcIwzo1O?=
 =?us-ascii?Q?lb6QUcSnUhKAMtjyGu5nL/VraxY6rbnIYtb/sufvr55ozxz4d+ufEkS694pC?=
 =?us-ascii?Q?ZTwicEC02n0T9bXM6TGVRmJK0VyD9eD2TakPMin2LRNg+3SRdqjA1fNwl6VK?=
 =?us-ascii?Q?xG2QcmeLuVLHQepGiHBjoYwdCYUxMV/UNU+/8+GOTUJO5B7XIr79f29m1wQs?=
 =?us-ascii?Q?zJAheQrjqXn/FY/kD9yjH6B+Ni2Q4KJdg9zB7T1+PUf9PIwq3go/5VMyBYWH?=
 =?us-ascii?Q?NdZv7uc0X6WD+CuBDLlVKaTOFBfyWkDXb7TD0P9Gvjy3wzbrpGV9Toi2ytTc?=
 =?us-ascii?Q?EgcIdvkLmgEm23DlBbgH/ynWdtukkY4Dez6bwHs9Q2qDn5PJ+btwFq+QZTUA?=
 =?us-ascii?Q?R22GYHGz/I0g5XWn+rpdivT46Xe0Jl7HctRMGlRLiuzfzEGUyEMMTew6Lc1H?=
 =?us-ascii?Q?6ZsCWyfJ9H7pfVQHwbzKDTNO1CbCky+br60mxEJqr7AcGKHT8F0hDRgcJeqX?=
 =?us-ascii?Q?/SqfqHbgb8NUx8ujsaXe2o+U/2ogB9bqd/aEpW3OhJTeHHNWv7gi8+YDpoN+?=
 =?us-ascii?Q?a4xpukWJ8HTR8hk7FjDUkHuw+xiGlhC9QfauGEOCHjmjBbyaCN58xmjGwIRZ?=
 =?us-ascii?Q?hJbsQ6N4fb334FMiry+9EcWEOxXAAo9ShxVh2FeIEFy6zN3EXOdVf3COZ5gi?=
 =?us-ascii?Q?p8DxqyegM6DNz5DCJTvA7JAFhQFiTUyMZaOWklRmUMNPOfMas7BN+vK9U6jp?=
 =?us-ascii?Q?sU/2VDV/uyAV62x5U4FCvZ1MQ3ziooBgZCAqEB/a4lIbroPMWlcxIxr5SMRo?=
 =?us-ascii?Q?I9hGYJqZt0Oj4rYY5bdSe2nnL4Lyz+B7YtEtczH6PXJR011NoiWsdiXnD+XS?=
 =?us-ascii?Q?SMXVp+D+4rL1ADlAn7RnxVA9UXnyYuzZNo6SOSeYL0JaTWm46tShIUa6AoKy?=
 =?us-ascii?Q?wlUvZg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6325d2c6-1fee-4662-1a83-08d9a052a5f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 11:51:48.0976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wbs7SmZSCcSi65qfRGFz2Dzz2iYIlqXdsNQrBdzO41OtFPI8yNc8aGWz51J3C+qh94IMlMiswTwdzv89wH8HWWX5Tkwnmb9YIiipz1WXJCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, November 4, 2021 7:09 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
> On Thu,  4 Nov 2021 09:12:31 +0100 Maciej Machnikowski wrote:
> > +Synchronous Ethernet networks use a physical layer clock to syntonize
> > +the frequency across different network elements.
> > +
> > +Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > +Equipment Clock (EEC) and can recover synchronization
> > +from the synchronization inputs - either traffic interfaces or externa=
l
> > +frequency sources.
> > +The EEC can synchronize its frequency (syntonize) to any of those
> sources.
> > +It is also able to select a synchronization source through priority ta=
bles
> > +and synchronization status messaging. It also provides necessary
> > +filtering and holdover capabilities.
> > +
> > +The following interface can be applicable to diffferent packet network
> types
> > +following ITU-T G.8261/G.8262 recommendations.
>=20
> Can we get a diagram in here in terms of how the port feeds its
> recovered Rx freq into EEC and that feeds freq of Tx on other ports?

Will try - yet my ASCII art skills are not very well developed :)

> I'm still struggling to understand your reasoning around not making
> EEC its own object. "We can do this later" seems like trading
> relatively little effort now for extra work for driver and application
> developers for ever.

That's not the case. We need EEC and the other subsystem we wanted
to make is the DPLL subsystem. While EEC can be a DPLL - it doesn't have
to, and it's also the other way round - the DPLL can have numerous differen=
t
usages.
When we add the DPLL subsystem support the future work will be as simple=20
as routing the EEC state read function to the DPLL subsystem. But if someon=
e
decides to use a different HW implementation he will still be able to
implement his own version of API to handle it without a bigger DPLL block

> Also patch 3 still has a kdoc warning.
Will fix.
