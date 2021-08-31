Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560A23FC58C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 12:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240964AbhHaKVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:21:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:31731 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240953AbhHaKVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 06:21:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="205663317"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="205663317"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 03:20:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="460038959"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 31 Aug 2021 03:20:21 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 31 Aug 2021 03:20:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 31 Aug 2021 03:20:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 03:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWAc/iLcmWOsMeDY7/103QYuO/xbJd3x04tUswsIrM8+5yu/zAsYyATX27EQ48Ow9SCFUmAIoL0jjX1tnTexSR6R2quIG4rmhYj/II9UKZbQjelQbPjMr31NVi6/zAPHxwubqX6LyvA0oikCCgGDRtqMgvUzDMcMiqz/eUN6MyBFm2kzvog+uD2JtqoPeaDQQYl4jPoAiTs9IxFwIpQKdbmzDDOYQpiYNZrK6HvmQuDLaOOrYkGHXr/9gGpVYGGcVR4ZNp8CyXrSWS69jBWtoZv6zmJr0g9avHOAjfFRP/B8WjhUNjh+dY/Q5nQyeh5pzleLST2raLb8DlWqXSEMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0JRJMSOEuUJiUyTS4KB0KvOzXg7HnNM52OR90xnvuE=;
 b=mmaIQoUBS/5aNokcdEjKdWhDTEshbd9/cAeYUVvAmvEhG7fjVdJS3M6AUVV1iNSXjfwMsELG9CNLk4lhAhVDV1lYufO31VppeGXS0XMwJD7FzozqrIi+yZi7YIWPrCJbPvZa6WL50hmmp/GIHYc/ynMADLGS0ow4umhM9Y+49zRaioNZ3dpzlgJl6AxcFij5vossbclsXkg6M2xZ/0sq9luCTuxZBNnrtbEGRti/h+C2mmlijFZGdFh0QdyPcc8RFGORovRByTZ/uQtS74MpXBNYqP7LXCnagNu6GqIhb2kbW/vNk29LKUhq+nARjZkyWUTmKxamxv2IFN+77ujrUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0JRJMSOEuUJiUyTS4KB0KvOzXg7HnNM52OR90xnvuE=;
 b=nIT7tbQkTnHpAGRVs0G9TrwKWNUtDmNq1/o9vwINYxbQKccVlRRzLzjAW6DVcfK2JVzSMnYb/Sw3pKl7wPjOUGmA3MFSoPmCY1OAGPBnSM3t9W+FjALjpeR1fWu29tfqI+vrE+wNTs9HK1umeK/m+seUfXbvaU11XJUtgxY6w/w=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BY5PR11MB4118.namprd11.prod.outlook.com (2603:10b6:a03:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 10:20:19 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 10:20:18 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "bsd@fb.com" <bsd@fb.com>
Subject: RE: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Topic: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Index: AQHXnK7K1rkxJTKXbUG0z9L1S2fbo6uKlpWAgAANa/CAAeYOAIAAKj6AgAC0GNA=
Date:   Tue, 31 Aug 2021 10:20:18 +0000
Message-ID: <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
 <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a076ed7-852f-4d19-46e9-08d96c68eedf
x-ms-traffictypediagnostic: BY5PR11MB4118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB411848DC97DF06607B84180BEACC9@BY5PR11MB4118.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MG5VAaeEyh4za/h6Cd66NFKG/Qh+MjG29tb8Jm/+UQdZylAN89aPL0E40rWBZu//ZrtL83kwp/9W8f55oCj4OkJklSoxIEFmgsMzOgSvUbhHpvjJ5o/SY9IRJLJVC9Udb7L6OehbjvnvV4enlCf2/xzi+n2YTLbUb26JIVwL4iVS/iP6WQZ0w1Zdw/SW2FxjblzYCQMFcNw4ZiJO/it1FOvUQEmC6h2do2vzcfW6q95/ku598TPoVLZCbZiOWC4eLCSrF2CR3bl5flvfZcTHKTbZbtgkHs84zDbkPTr3f33qCs9cXoeTkNWw/UaV2WBv0A8dEVEnV6WZMFW1v1zve2YMmIa7PUzJ9eZ0YqeJvFBO0Zc2Ffqdp5Zr3JnWY8+l2DIPXi5/tsERA6fJ4t9NusvjX4jHLUV4kmm9GY16KwimOKVhFk/TwPy5jOsifp/98ryRi/EWO0W3XcCeSrCxXTgO1J/Fe/Y65/+wDMcUwXEXimERnvRQlC03etD2Mq1neUzUJWDcJ/GhYwUQfwfaet99kTeepi+wT/Gq/d74OouWDSawk8TcuhIluY7FkdxxEP5g60cf2hFEAFbQM/dIwpGX94ewt+WRO7Ah8MsO3onc3gdoMpaYTnM4qJ5DPUMetwrH5jtBZFjFLGac+fiZQbw+zwDz100nCb14mdF+uIdoHEP9vShy6jLp+2b5nwnP4+UV05uHEx5g5AezC2m9fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(478600001)(15650500001)(38100700002)(110136005)(122000001)(76116006)(83380400001)(55016002)(7696005)(316002)(52536014)(9686003)(53546011)(66946007)(38070700005)(66446008)(186003)(26005)(86362001)(66556008)(54906003)(2906002)(8676002)(5660300002)(6506007)(71200400001)(66476007)(8936002)(64756008)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tqaC5cfJC8jCIfPiIvhk2CFTciYxSZaBU3fL+zNU51/sTrE1Ucci7XdmcOVl?=
 =?us-ascii?Q?5HV5oB1azXibFqLOioRSOQb16z7w4dulvuKE7+FpXoJEW5tpo/pLslOOQngR?=
 =?us-ascii?Q?K45JD3u5nMqL0j1E/iz7tDhvbp8ODU5pG58HHCNFIMvqLvs3merEH40AC1He?=
 =?us-ascii?Q?Zzl3rvxnZMD5s3l3VAlT48u2hbJ4tiXR9DTSmMr2VFmUFoYkzHGIwwwd89i+?=
 =?us-ascii?Q?qxXdkT+Gu3869BWefPe5RBGHbdE2iNibJuBBevS3PU5Cx4gB9Lg+E+R72Voa?=
 =?us-ascii?Q?aFmXfdeItlIUgUWzmGTwzt1vEEGi9Qh+z0F7arKQZJ07SwYH+FMOakHR7Ky8?=
 =?us-ascii?Q?3EHZpCtFGidcOq7cEquH5J57ucuR0N2F35+KQMdf8K2jNmrhkiPKI/0wbviT?=
 =?us-ascii?Q?dQIcKcviFw0L52MKBSpAdLcd0JNO0Ot8QiPhMvsNj4wepUakMMs/Oj87Hvv7?=
 =?us-ascii?Q?wEu+zT1nJhKpb+xHoEukj6FHHnN7n4sK6XDUjBNB0uzJc78MS2LUrDM/jY5l?=
 =?us-ascii?Q?tsQUmeA3Qzqw8HP1cOWkB099kw6Ws9L8jQzpfaWy4M9ijtzHapchVi1mQk8l?=
 =?us-ascii?Q?9kBgd7TpNlAy8YYY9o5DrckLSaqrw/xwZRfDP5+D9J1h61BqoK9O4kWvwevy?=
 =?us-ascii?Q?Buqq+gJoMU79h31ceaz4+wpFTp2KWUlfdqguSZaxmsFSC56HfCm/c/gYf6io?=
 =?us-ascii?Q?L5NnU0uksTREoOkbzpzrWblhvpP44Zu0gvw5Wh5kmcKu4wQ9sXpgj2EGdj6u?=
 =?us-ascii?Q?AoQ8Cyv0cZU3vTxwzi5fmdhOrxwnZyAEEr83nZ2Rr/czSTTGbuiWkcn463Fc?=
 =?us-ascii?Q?g2KZhS/G9mkOgzimXiUg8giB1h49MyttmxaOB4ULKlcVKNI18VGqUNJ0SdAn?=
 =?us-ascii?Q?SX6MHU60IYNILKrQr+wmr/QF8pWmFyqn8aasE6u2ghnwPOPmLsEDgLpMWgtF?=
 =?us-ascii?Q?z2YmwuuvBtPDsy7qfwSihLrB6CJiilm75/FKtZ+FadIL+WgrOc51/tXcbSdV?=
 =?us-ascii?Q?sTrXPnrGYUClnxT4hmIGKhB5XIsz08AkvAnf6dhK2vIIc4eD4i8sGTd86OhO?=
 =?us-ascii?Q?hflpDdckmy6ky797PKzFS9YlaVlftibmaAAXsM+Mv2hN47r5GgThfXjwxmXs?=
 =?us-ascii?Q?RKDQYpKhPZK4gy2ROccFIc6lpPhvIlQzTcNGJusZ8BxEr1q1rvZxaAR8YnfJ?=
 =?us-ascii?Q?URWDCo68pl+NgX2CBMcUOIuS+XWwYxul1jyEEpJEyE8hXJU2PGEMcKGjEk8h?=
 =?us-ascii?Q?OWYQCovtoTxR1cqbVSRsmzyrEr/co8oNHWxn7fIgxvPfvYvC0dU+O+uHUmot?=
 =?us-ascii?Q?PMY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a076ed7-852f-4d19-46e9-08d96c68eedf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 10:20:18.7991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3qqAKjOWZOUU2PDq24FHayS32KXD2diezP1KdvKKrpEkc1LDJlhWiKAy8qGFDOO/qwr/DN+XPv0+s1SLfOOqTDV33WCd8MVbP82M/TMOYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4118
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 31, 2021 1:29 AM
> To: Richard Cochran <richardcochran@gmail.com>
> Cc: Machnikowski, Maciej <maciej.machnikowski@intel.com>;
> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> abyagowi@fb.com; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; linux-kselftest@vger.kernel.org; bsd@fb.com
> Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Mon, 30 Aug 2021 13:57:58 -0700 Richard Cochran wrote:
> > > Please take a look at the 10.2 Operation modes of the G.8264 and at t=
he
> Figure A.1
> > > which depicts the EEC. This interface is to report the status of the =
EEC.
> >
> > Well, I read it, and it is still fairly high level with no mention at
> > all of "DPLL".  I hope that the new RTNL states will cover other
> > possible EEC implementations, too.
> >
> > The "Reference source selection mechanism" is also quite vague.  Your
> > patch is more specific:
> >
> > +enum if_eec_src {
> > +       IF_EEC_SRC_INVALID =3D 0,
> > +       IF_EEC_SRC_UNKNOWN,
> > +       IF_EEC_SRC_SYNCE,
> > +       IF_EEC_SRC_GNSS,
>=20
> Hmm, IDK if this really belongs in RTNL. The OCP time card that
> Jonathan works on also wants to report signal lock, and it locks
> to GNSS. It doesn't have any networking functionality whatsoever.
>=20
> Can we add a genetlink family for clock info/configuration? From
> what I understood discussing this with Jonathan it sounded like most
> clocks today have a vendor-specific character device for configuration
> and reading status.
>=20
> I'm happy to write the plumbing if this seems like an okay idea
> but too much work for anyone to commit.
>=20

I agree that this also is useful for Time card, yet it's also useful here.
PTP subsystem should implement a similar logic to this one for
DPLL-driven timers which can lock its frequency to external sources.

The reasoning behind putting it here is to enable returning the lock
to the GNSS receiver embedded on the NIC as a source for the
SyncE frequency. It helps distinguishing the embedded GNSS
from the external sources. As a result - the upper layer can report
GNSS lock based only on this message without the need to put the
embedded  GNSS receiver in the config file. On the other hand - if
sync to External source is reported such SW would need to read
the source of external sync from the config file.

And the list is expandable - if we need to define more embedded
sync source types we can always add more to it.

Regards
Maciek
