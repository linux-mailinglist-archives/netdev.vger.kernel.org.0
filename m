Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F66467DC2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344069AbhLCTLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:11:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:14457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238521AbhLCTLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:11:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="224289278"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="224289278"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 11:07:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="478428239"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 03 Dec 2021 11:07:18 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:07:18 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 11:07:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 3 Dec 2021 11:07:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 3 Dec 2021 11:07:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ee5U0BqZgO/uQ549BJAvHHCbTLiyo3LlyyRpYo6iEXn6dJkN/Q+kvd32+4HWYjweg+rAR8Vo864JPcj99PMqZYFBubhA2GyAi2Hr8WrUJEWvxTVezE4FbWOqLw+HemYGYO3NFZGLe8PshPlD0EQwhLNwOr2hymhotie+mNKSQuN/95L9QjLNzNrLDqVjdCVBnl+yTfCtZj1q84qa9Fw7on+cLwtgeQ7bgvNlYSS1uHtijOmZrlyg1rorRUXbXTFOqgmEdu2ZsUgZVCgqCNgFmdiqk7Yrtu2Y6o3yQtrAN8tvRinVVa4z3xjCdQYDcADdIoulVSMe4We04zGq3+vtlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkfqEHOcwy+UdgD8bczw2lPUnPnrXhMuyxbc595cl3k=;
 b=VZUkOue3Ps9zeuXn2waucLTtIION5iyqpTupzRyATObI3+AZBFSC3nuqpDqe7yen8/1Et2sqxxUy2GXrgFmtDt3MGMW15kN/Zc+EdTYCI7Np6v51c3Ps6zUy7uAzCVrw5qjVsng2apD6QeXez8IWWxDAJtNcIOe6EZCgKGfXg7z0jXPoCeKFFyYBzsyG3tEtXz5zJ/QGKwE87lkxciQQqr84/GC9NaHNnzLp/HmtOuCRtwCnSy0fIobzrhKyR3DOCZwIx7iHa3TPuMFjG9R0AvXMWMqTVDmJR30PnPWHllF6vX3EZnlwjsro7Sl77/WvdgoclAeMFBgXatrfRaObow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkfqEHOcwy+UdgD8bczw2lPUnPnrXhMuyxbc595cl3k=;
 b=Hbm1ViDH4bEt2dbJub5qUBw4ASVfEzB557OVibv3x/pTvI/vYHwO2hhGCrjpmEVO5VTDzNyrI8ExsSASo7YW2iRMiNFIP7+eHgl0ymbEo8ecdOvWJdl4YBohjlku0FayQs2Sd5J9ydGn0VQHJ4/IwCki90kCpEYnS/ONLVSqpm8=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR1101MB2206.namprd11.prod.outlook.com (2603:10b6:301:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 19:07:15 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%8]) with mapi id 15.20.4755.016; Fri, 3 Dec 2021
 19:07:15 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Topic: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Index: AQHX5t+zHNhA4eAQzEyd+4hcIqumb6wfJraAgAAesICAACIlAIAACV/ggAFk6oCAAARAAIAAHSAAgAADU9CAACN2gIAAA8qw
Date:   Fri, 3 Dec 2021 19:07:15 +0000
Message-ID: <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87lf11odsv.fsf@nvidia.com>
 <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87fsr9o7di.fsf@nvidia.com>
In-Reply-To: <87fsr9o7di.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48403830-8d82-4f98-033d-08d9b6901e9e
x-ms-traffictypediagnostic: MWHPR1101MB2206:
x-microsoft-antispam-prvs: <MWHPR1101MB220654C3C82B683AE4AAB6B9EA6A9@MWHPR1101MB2206.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZJxaLpqgDMHBb2G+ggU0v3kvbPMU8unmdxzBWZOENxSSK7QuSop4QVNapK5vzBgoyn6vV3RHwMUM6iKhixnGRpS2/qxjSHMVr07jL5Wc2jsbom4HS97HOzqQv/MEOPcYuDmKvB3Nljv4Ipgrvg5p9Onzpah+NRS1hKn0vB6HpTMo5o3xImmx0XxU4KlaKTD3kJotDyV3APA2uvQbCjdwsxRENMBkOHfefnmD3kO03zwUX3hoG0PBML5PMgLv4jZVuwGICK6P+YTL/+ucDDTiWxigGIcbKLQLbX7Z0HG1QbjQQdmQNQJAbWHVC3ItOcexIOhPXjZkHeV39ijt9eH8xJnWCWNCgk79LuXjG/8GXvZbkH6wPsl/lEyXkSJVoXY/HU9VUBcmK9QEH+AQh2JQaqqWc0LYga9126wjKGTW4zfLD7Meiu38E/MnAl77wydVqri/Goe4hTycCMfPM2DkjHEOd3jp2zr9mtbfq7NLkZlfVw+WloAS56LyveH92BScAlX7xcpMeIAaHacyNNRRLhlfGcXpZHKrXyvznqKAbXfwyLYEXaoCp/PBQ27887CoLKVbDK77b4WRVmA/DR3vlE9a8ZHSsV3txbDYD0bUtSz5IUoMDsIyEUBfVmNptYRwzRrtNqhbTMY1aXaFNuzXv+0MbnUenGWShp+dAxsveg0F3Pt2PJLwlVkuA5w1lFCvUW9URsrcg94Jy3NXjViAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(7696005)(54906003)(66446008)(53546011)(508600001)(186003)(5660300002)(33656002)(52536014)(4326008)(82960400001)(26005)(66946007)(38100700002)(71200400001)(76116006)(316002)(38070700005)(6506007)(9686003)(7416002)(2906002)(86362001)(66556008)(122000001)(8936002)(55016003)(64756008)(8676002)(66476007)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qAakty4hNOJ8Ps2qjeE0xqjQvpDgmLEILGWKUMPBQ3pVOqwqXqvOWlIgGGY6?=
 =?us-ascii?Q?zp9Dn0yp38Uf73jcRcL5zHv8aVqnxE8Bhv4IA7YYqeoytvsnRtWTZ/3NVvdj?=
 =?us-ascii?Q?c6xTJifTjUOSW3nK4Puzs9pX9I3Oiga1wUzspeIdAyiEOgDpVWn44dFSad4q?=
 =?us-ascii?Q?MEfkYv36LNFExZvo5QQCfQ4fQi6iKnnkE2hTGSpcAYD2/F5NDLcvFwcxPA/f?=
 =?us-ascii?Q?3t+2KIcude/gtEV/4GpZqep+9srz6iA/DPiafKXE644X6FsWTRQSqGATsuCL?=
 =?us-ascii?Q?AmrPTTHUv9J22r40xkb+g+66+Sd8FGhXJChhlfVcCz2d8Tl8yLr0moPsof/g?=
 =?us-ascii?Q?IvoFm5QAv/hmy28h+XMF9ta6Yi/qdRjqHcryJkSPlnKCLRm6Rz4I7HITpbuV?=
 =?us-ascii?Q?US7eKXLsKqJYX3UhqjUI3WhPAWljziTrm+S6QesCuclScK060DQWpu8fqMVW?=
 =?us-ascii?Q?fJBlJKnLByyRjNaLSyAtSCi2jif9w+imBtI6T3guGLF31kymih0oT8hOHN4E?=
 =?us-ascii?Q?Sh8gEswP76htRNtwMg6KJgzgrcFBGApWw9k9KbLDYns4TUzbenGNW7bYDDQ9?=
 =?us-ascii?Q?Tw+HxDeSzqY18AusOEo3PMUUARQ/MD6cyWj0V0+n06Not8NHgzdQqldfmTjA?=
 =?us-ascii?Q?eNH+6OuX1v7kO5SInc0JtymqNHKKcymYa14qGyPXB+LaL9nHNIoKkKbMI5a3?=
 =?us-ascii?Q?hkiTyOyry+8zFBJjzduryqUoB8ZamwNystIwtEmV10tYtMvQYNvgwEwgcZ+h?=
 =?us-ascii?Q?Pw8kriE8+fj5W6pbaWT3QL5X2qK9E7dyyrdmu8EYm9T21rTGzrA3/mK/hHMY?=
 =?us-ascii?Q?FmeGVbGzcrgmOkotD+zohWeD91haRAL98UG5YzSVIrxTsqC0b9POEaVbB3PA?=
 =?us-ascii?Q?LVlRBePdMSqNtbQMxNrsfjSUjudZzZ6xK36VVaIeNbRiCyXsXCkBMWZObHgE?=
 =?us-ascii?Q?kPIs+3ahwsTyC8yvElj00G/FxVaJDrPqxtXgt1bxBZAewzT2plKInNfYTwpb?=
 =?us-ascii?Q?AYNue2F9Bqf4M/0vZY1ex/bZ8OFYhqFw8YUhXsFHUsfKioOqAF7/xFNNhdmr?=
 =?us-ascii?Q?e2vv4GfqmavwbriPr5oqSh96nVJxKs1wwsjISKaGjKTi7sJyBJG+pxYhFi9k?=
 =?us-ascii?Q?dSnpzQzcrP6CEXh8Lt/D+YOiF45GJ8LGTc2p65iHr+R6EA2ZgfnYtzLysTOW?=
 =?us-ascii?Q?Kl2cdG5Uz+/Re9RSsIU8BPDICTSuf/9F8WBguNT9vPxEErU24XP8XgD67zZi?=
 =?us-ascii?Q?wa7o1OxoHrUlaHztqNW5qU/lveZqivn3yNNesAksnFl1qylN5qjpl886MYdC?=
 =?us-ascii?Q?dnAAwBWZ3MJyYEJyxeQmlLo/9tnp+SZhTskwmOY2965H4QD8LVmAFa+McLUX?=
 =?us-ascii?Q?n1KssPgSwwrPboatdRZvhWLc2huSYZ78XhLZEw8bJy7jgPWVPa98gQ+XbeZA?=
 =?us-ascii?Q?DKAhh8aDJ4VaF88NJgy8VVL+q2X++bP5Fzzo4LqZZ3WBvCj6TWM7jbsLat3+?=
 =?us-ascii?Q?ABVyxrO+UpLns/G/DquvtO0utrasD1k1PMWJtY+A2XiIqgbjRjmZKt9iH+H7?=
 =?us-ascii?Q?x6YB+JYYXiJt3Zu+2/2j9xFbJqMgfZetKpr/R8JeRgbVrMB5Zqieye2eSSUI?=
 =?us-ascii?Q?Lxlf8qvBbgX4yhMxaQWuhx3SbP12gGZI3X6fX95ZUY5XYdW8B9V12YyaVKqB?=
 =?us-ascii?Q?3K2sTw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48403830-8d82-4f98-033d-08d9b6901e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 19:07:15.3001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wt0G9KZUIZJoqcqY5rOF/xF2CGVv5qqZvMSDJDdwXB65NWtDlNdDrmwdgw/++pWgs0cLw5JM7Fa4dWEZKjc9GXIxGttfWJVC1d+IhR0uqQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2206
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Friday, December 3, 2021 7:45 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
> recovered clock for SyncE feature
>=20
>=20
> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>=20
> >> -----Original Message-----
> >> From: Petr Machata <petrm@nvidia.com>
> >>
> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
> >>
> >> >> -----Original Message-----
> >> >> From: Petr Machata <petrm@nvidia.com>
> >> >>
> >> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
> >> >>
> >> >> >> -----Original Message-----
> >> >> >> From: Ido Schimmel <idosch@idosch.org>
> >> >> >>
> >> >> >> On Thu, Dec 02, 2021 at 03:17:06PM +0000, Machnikowski, Maciej
> wrote:
> >> >> >> > > -----Original Message-----
> >> >> >> > > From: Ido Schimmel <idosch@idosch.org>
> >> >> >> > >
> >> >> >> > > 4. Why these pins are represented as attributes of a netdev
> >> >> >> > > and not as attributes of the EEC? That is, why are they
> >> >> >> > > represented as output pins of the PHY as opposed to input
> >> >> >> > > pins of the EEC?
> >> >> >> >
> >> >> >> > They are 2 separate beings. Recovered clock outputs are
> >> >> >> > controlled separately from EEC inputs.
> >> >> >>
> >> >> >> Separate how? What does it mean that they are controlled
> >> >> >> separately? In which sense? That redirection of recovered
> >> >> >> frequency to pin is controlled via PHY registers whereas
> >> >> >> priority setting between EEC inputs is controlled via EEC
> >> >> >> registers? If so, this is an implementation detail of a
> >> >> >> specific design. It is not of any importance to user space.
> >> >> >
> >> >> > They belong to different devices. EEC registers are physically
> >> >> > in the DPLL hanging over I2C and recovered clocks are in the
> >> >> > PHY/integrated PHY in the MAC. Depending on system architecture
> >> >> > you may have control over one piece only
> >> >>
> >> >> What does ETHTOOL_MSG_RCLK_SET actually configure, physically?
> Say
> >> >> I have this message:
> >> >>
> >> >> ETHTOOL_MSG_RCLK_SET dev =3D eth0
> >> >> - ETHTOOL_A_RCLK_OUT_PIN_IDX =3D n
> >> >> - ETHTOOL_A_RCLK_PIN_FLAGS |=3D ETHTOOL_RCLK_PIN_FLAGS_ENA
> >> >>
> >> >> Eventually this lands in ops->set_rclk_out(dev, out_idx,
> >> >> new_state). What does the MAC driver do next?
> >> >
> >> > It goes to the PTY layer, enables the clock recovery from a given
> >> > physical lane, optionally configure the clock divider and pin
> >> > output muxes. This will be HW-specific though, but the general
> >> > concept will look like that.
> >>
> >> The reason I am asking is that I suspect that by exposing this
> >> functionality through netdev, you assume that the NIC driver will do
> >> whatever EEC configuration necessary _anyway_. So why couldn't it just
> >> instantiate the EEC object as well?
> >
> > Not necessarily. The EEC can be supported by totally different driver.
> > I.e there are Renesas DPLL drivers available now in the ptp subsystem.
> > The DPLL can be connected anywhere in the system.
> >
> >> >> >> > > 5. What is the problem with the following model?
> >> >> >> > >
> >> >> >> > > - The EEC is a separate object with following attributes:
> >> >> >> > >   * State: Invalid / Freerun / Locked / etc
> >> >> >> > >   * Sources: Netdev / external / etc
> >> >> >> > >   * Potentially more
> >> >> >> > >
> >> >> >> > > - Notifications are emitted to user space when the state of
> >> >> >> > >   the EEC changes. Drivers will either poll the state from
> >> >> >> > >   the device or get interrupts
> >> >> >> > >
> >> >> >> > > - The mapping from netdev to EEC is queried via ethtool
> >> >> >> >
> >> >> >> > Yep - that will be part of the EEC (DPLL) subsystem
> >> >> >>
> >> >> >> This model avoids all the problems I pointed out in the current
> >> >> >> proposal.
> >> >> >
> >> >> > That's the go-to model, but first we need control over the
> >> >> > source as well :)
> >> >>
> >> >> Why is that? Can you illustrate a case that breaks with the above
> >> >> model?
> >> >
> >> > If you have 32 port switch chip with 2 recovered clock outputs how
> >> > will you tell the chip to get the 18th port to pin 0 and from port
> >> > 20 to pin 1? That's the part those patches addresses. The further
> >> > side of "which clock should the EEC use" belongs to the DPLL
> >> > subsystem and I agree with that.
> >>
> >> So the claim is that in some cases the owner of the EEC does not know
> >> about the netdevices?
> >>
> >> If that is the case, how do netdevices know about the EEC, like the
> >> netdev-centric model assumes?
> >>
> >> Anyway, to answer the question, something like the following would
> >> happen:
> >>
> >> - Ask EEC to enumerate all input pins it knows about
> >> - Find the one that references swp18
> >> - Ask EEC to forward that input pin to output pin 0
> >> - Repeat for swp20 and output pin 1
> >>
> >> The switch driver (or multi-port NIC driver) just instantiates all of
> >> netdevices, the EEC object, and pin objects, and therefore can set up
> >> arbitrary linking between the three.
> >
> > This will end up with a model in which pin X of the EEC will link to
> >dozens ports - userspace tool would need to find out the relation
> >between them and EECs somehow.
>=20
> Indeed. If you have EEC connected to a bunch of ports, the EEC object is
> related to a bunch of netdevices. The UAPI needs to have tools to dump
> these objects so that it is possible to discover what is connected
> where.
>=20
> This configuration will also not change during the lifetime of the EEC
> object, so tools can cache it.
>=20
> > It's far more convenient if a given netdev knows where it is connected
> > to and which pin can it drive.
>=20
> Yeah, it is of course possible to add references from the netdevice to
> the EEC object directly, so that the tool just needs to ask a netdevice
> what EEC / RCLK source ID it maps to.
>=20
> This has mostly nothing to do with the model itself.
>=20
> > I.e. send the netdev swp20 ETHTOOL_MSG_RCLK_GET and get the pin
> > indexes of the EEC and send the future message to find which EEC that
> > is (or even return EEC index in RCLK_GET?).
>=20
> Since the pin index on its own is useless, it would make sense to return
> both pieces of information at the same time.
>=20
> > Set the recovered clock on that pin with the ETHTOOL_MSG_RCLK_SET.
>=20
> Nope.
>=20
> > Then go to the given EEC and configure it to use the pin that was
> > returned before as a frequency source and monitor the EEC state.
>=20
> Yep.
>=20
> EEC will invoke a callback to set up the tracking. If something special
> needs to be done to "set the recovered clock on that pin", the handler
> of that callback will do it.
>=20
> > Additionally, the EEC device may be instantiated by a totally
> > different driver, in which case the relation between its pins and
> > netdevs may not even be known.
>=20
> Like an EEC, some PHYs, but the MAC driver does not know about both
> pieces? Who sets up the connection between the two? The box admin
> through some cabling? SoC designer?
>=20
> Also, what does the external EEC actually do with the signal from the
> PHY? Tune to it and forward to the other PHYs in the complex?
Yes - it can also apply HW filters to it.

The EEC model will not work when you have the following system:
SoC with some ethernet ports with driver A
Switch chip with N ports with driver B
EEC/DPLL with driver C
Both SoC and Switch ASIC can recover clock and use the cleaned
clock from the DPLL.

In that case you can't create any relation between EEC and recover
clock pins that would enable the EEC subsystem to control
recovered clocks, because you have 3 independent drivers.

The model you proposed assumes that the MAC/Switch is in
charge of the DPLL, but that's not always true. The model where
recovered clock outputs are controlled independently can support
both models and is more flexible. It can also address the mode where
you want to use the recovered clock as a source for RF part of your
system and don't have any EEC to control from the netdev side.
