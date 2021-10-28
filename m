Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA6C43DB1F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhJ1Gew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:34:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:17169 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229762AbhJ1Gew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 02:34:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="230601702"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="230601702"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 23:32:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="665280778"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 27 Oct 2021 23:32:22 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 23:32:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 23:32:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 23:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yb7nJqp+tGzcQOtUHtCjzfhmgBV/LPsmsn9+JoMPQply5kgw0QLD/4x1cEvFNV1h+hLjiZ8hq9PzSvS/c7WSMLm0MS+xYnT3w9PkETnGrKY7zbT0E9DV0J59ydSYpU4YExTWp1jwNEeQ14uqMGrwvV2V+h4TjsaCAM95ptXfDd74gHUzRb0o96p6fYwsNCoC7bF6LeN9BzsuNs9+PDkHOkdCOzQSI9X+toygCH4FE69mP06htt1XkveIt5G1knDmm+DVEkhvhZpEYtCUmy1mEhCtkc/YFjER+2mQ15PmSHCsnNlsJEB2w8s0W5XbDeFjH5qzn4OHSWvohby1oAUmiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaHsyktGZBng1e9w0gp6X7um6y1/2emliy6Rwd3VLV0=;
 b=ddnC8PNvFXpJOTMSguWeww+4AhsAo+5NJR2vkv8nU2i6e+bdKdgAvbJKXVU2ZOvMLXTehWunZ0prUsQBsx4NYPAuT/TcUUMBhZhm0A++/Dj7wfnh9ucei7YZ7B9O0dUHzLW5Q+neUsVEqYqS32rZ7VLbmVtpIG0ZQcf3XiRXQW0LQUWWWqM/KElFUZ7Pvahdir+PxQ8RJYjcbXX8pNilg4xEShZ9ezCPamWPSO+B1Gpt9Og3XR/KVadfqc0LYKWPJpGrMInC07EBTowQGEmxnEiobwBVl0hCUax99k/0sTv4ENC5Y4MZsZlkSMKbozygY5HhocEbpnTzlhsGMyGBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaHsyktGZBng1e9w0gp6X7um6y1/2emliy6Rwd3VLV0=;
 b=X6RaVlSzXass6u7YprFCd9fbwqblZU8vCcsC7ayozyjcdKag4vzrZ5qmzIvqvx5Pptt5bQhTI4hxXsmwqYe0Ut9LXcWheTJdu9VvB0BSDmq/5uv0Av51yPxTrY4YLum9BWUqwHqBoBkhgHI3GaqZy22d6GDZOsF0QwrAm0WWy5E=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4619.namprd11.prod.outlook.com (2603:10b6:303:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 06:32:20 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.014; Thu, 28 Oct 2021
 06:32:20 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Thread-Topic: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Thread-Index: AQHXypF0qbvmrrSvGE6wNeD0sLdJiqvmaJ8AgABr7yCAAB5WgIAA//bA
Date:   Thu, 28 Oct 2021 06:32:20 +0000
Message-ID: <MW5PR11MB58128494AB0A5296AE638731EA869@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <YXj2oKjjobd0ZgBi@shredder>
 <PH0PR11MB4951A17040D860D8AC6975C1EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YXlqnXRw2iL7bGrh@shredder>
In-Reply-To: <YXlqnXRw2iL7bGrh@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad2be502-9d6c-4f1a-6794-08d999dcb1e6
x-ms-traffictypediagnostic: MW3PR11MB4619:
x-microsoft-antispam-prvs: <MW3PR11MB4619926018F5E6B73BBEA8F2EA869@MW3PR11MB4619.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R87zig9reToBP+NptRKNnbo0reKzxdhJEt+YaY/1Jf7/hBRIGqpixOv4fgQUBaSzT31GWi69YrjRXhyQJGc86YnkzLDCCnxkhQ6hswahMtves/bLd2fwWj8WNKNhO9t7N7Gd7A+WVPl0GuevfIZ3h7+/a/B+3/LkHaZ54XEHedhGfaWXvVMSzzJnRYEuTJL1+sLApEKJIms1NG1PyqDYHluOe+73+QhaN7HkIuSfVyzKwAkU13a+01NiSc1mteXqEur8Rw96hg+gpl4obv0AT+afAstxIa2LOOQdMBVFaOZR6Yvz8gyqXF3mGR4BrDdgiFbABBucJjvfLFaTU4+R1AdIuJA2tK/M6rNB2DzE2sDitkvB+kSmQPdk34FlIiiowPUMdNP9sm1XcnfC56PPRB5CotaXYb+xedPV6ceaOIfPeSs0uShSptrjRDo9fpATSzj0X4J0+sUwFywgT4I0e+sCIkEn/0vxjorRvZJyEmkCtiHd611sTdQpUkvJEiH1ZkQ+NogeS1P9vTeR9dhJGUgYINHcmon/9BMRKBeMyh5PM/FvWVBwivtv1SA0cg1rBlTHY8xPsgvPuP73O02BT8fOiMzKHfPj11CEkoJKVsXRpOF+R485iO8rcHmNd7DyQD98bQwhXZ2ZLKOg2AsezUAszC9aPxNrto6EYglEvzwURfNetZgq+M0wUxsMO/GqPsWdU9g9KrwXislbGnwFSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(2906002)(66446008)(7416002)(4326008)(122000001)(86362001)(38070700005)(66476007)(66556008)(64756008)(66946007)(76116006)(5660300002)(508600001)(38100700002)(82960400001)(9686003)(55016002)(186003)(26005)(83380400001)(71200400001)(33656002)(53546011)(7696005)(6506007)(54906003)(316002)(8676002)(8936002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jxJQGQwBFYHgudmPQr7sOdUY2IsO7EvbdKcmL4EdzQbvstsK2hjZms6OwNHj?=
 =?us-ascii?Q?1RjCaHzBmSjf8RZRJKdYpSzBNJZFeKbVavEWuxyagadIqPEmIyEdSlvFXAeY?=
 =?us-ascii?Q?AUYVLJmsxKYuPIa6xkeE/Z2TT1eDEbn8+nEl/o6lktBTS10rACQG+BUtTOGA?=
 =?us-ascii?Q?Q4+NE+gSwj8rOGsuzV3H4oWsdlJoqhiKg/OdOiUMBXFIW90s6VtCzhLE2Zbt?=
 =?us-ascii?Q?nanywCDso9W7AOJgmAGQwcdEOdc+gEWKVHjmohBhcbQAunV0riURAUzamLWP?=
 =?us-ascii?Q?+T+B5UbyGpdHUWXpoEs4Z8JqYB8ZGpV2zyxXWPIoM8ac7Yqh3y0AAoEwFyZB?=
 =?us-ascii?Q?FykQ/kbba2AGHdw9S333C12pSU0yw9G0r4p3Y04HEjCj2IFkIOwUa8DMkYG2?=
 =?us-ascii?Q?GHU7otBDEVMJA0T3gPTpuIJOZoPiEhoAgrFZ4YOHOKHPW1qmoj+gmDDx5Cl7?=
 =?us-ascii?Q?81nWsJiw2MGTRH31BnJgzb1e7B/4y7F7JOjbnidldTmipZf4H7ogZDjGsAsV?=
 =?us-ascii?Q?1GbILgz/HVhk2SxAClf4Uwrcj094BYMApp/YPi8z+/a0HGFGw9LH3xwnMbym?=
 =?us-ascii?Q?1E013+J2hi/q1VyKsWhCiywDU58CsoLR0gEWK35PfeAR07iqhdErb/K3pVVf?=
 =?us-ascii?Q?mXf0S8FMzeNluBEw+hN5mF/uwY0kUaJvqiWa0tmmU2tkcuKeBe0oylho7KP0?=
 =?us-ascii?Q?dL30QX7iCnd3DOvU+N6wNd7uJOUf1b/VdL1wJkZUeio39ry4DDfkYR9JIxdY?=
 =?us-ascii?Q?pWAVdFdRdV5fEMmBB5XZWSH/zIlQ6RNTagAMkKk2LaMpX3ALQLUYvxG4xhqM?=
 =?us-ascii?Q?CuO6OyVQ+CYdDYniqEyhiv2t2Fg2FHq57rpoeI0rnplJkMycUnszxb5iVDbH?=
 =?us-ascii?Q?ULmp+TGlaFddmWYf/c7bK6v/4AW32rgPertsBxex7OBnRrmkHXqC4sQOXDSC?=
 =?us-ascii?Q?1QTjFt/cOeb5OeOdTG/hX1OV7iHdyEF9WU4fhiYxevC/vSB2cUoDZL5tKmrn?=
 =?us-ascii?Q?xX4mFA0SOTlITXC/9CMVQEvcKHgKmiQtbo0rkHVrtOzkKQ80AgP3UfpUHHu3?=
 =?us-ascii?Q?V2XxpprVeIS3Uat+uzFNKIPKPqF9FOIT9t1xdrJAkJCBpAv+jZhzfi0N1tVU?=
 =?us-ascii?Q?uxS9YMpkrcxoRspjFWMm/qsRMu3fVB213qtYmCfzGSgYhwK4UHnclSEujSRz?=
 =?us-ascii?Q?qW+/y7E+ofzGq7SDBe1HFuCdrpYdo+JWqhJrUWtyiltACGav66Rb+2Njyr0s?=
 =?us-ascii?Q?tEQYnBH81tqm21kIXHKVqUtAGKp8fs7KKKFprKNCCNF4O5pG/TKzRVAOACSM?=
 =?us-ascii?Q?IiIP1+GDN0w/YT56ruQ9CkI4p+VbivKhb0MQU36/nbaM8aL1MR87hCy/pSgM?=
 =?us-ascii?Q?OtwWWTe7oaddkv8l8OZ9VbY+58ZPrCXsnEp3eXFH3Y/JhMYa2Pb8bwqDmf59?=
 =?us-ascii?Q?KqAgr8r7fEA7JD0dR+4PDtiZGYH8I1oEXOSUuIPjX4KV5hjUMI5P5fN5zFf1?=
 =?us-ascii?Q?FH3gXayfCk+rIpkrN7gB96dMTySxMuC+ID8cAFTsDcCMKfI+Dw4eOVDeQORq?=
 =?us-ascii?Q?GLjXiRdFq0KvI3w1cCFSLuyDefAugaQxvWa8FSw+txDPnsktRkDaPVTxvYdL?=
 =?us-ascii?Q?+M3pLlNJeO6NYUXQ9sx2n0zT3R49LigopoW2ov8EfRrHp3wcdqFT8pgvTOPk?=
 =?us-ascii?Q?b78DJg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2be502-9d6c-4f1a-6794-08d999dcb1e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 06:32:20.4943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KpOkky/b35JiRY6UpVhD/nLQt5HbcAXBhz9mxyX84Q/VAuaH2gQwUYTK0993LSA0GHaN64JLHILm1oHLGBCquoth2YwZv8jlWVcp6m1iQ2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4619
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Wednesday, October 27, 2021 5:05 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
>=20
> On Wed, Oct 27, 2021 at 01:21:58PM +0000, Machnikowski, Maciej wrote:
> >
> >
> > > -----Original Message-----
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Sent: Wednesday, October 27, 2021 8:50 AM
> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > > Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> > > richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> > > <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> kuba@kernel.org;
> > > linux-kselftest@vger.kernel.org; mkubecek@suse.cz; saeed@kernel.org;
> > > michael.chan@broadcom.com
> > > Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
> > >
> > > On Tue, Oct 26, 2021 at 07:31:41PM +0200, Maciej Machnikowski wrote:
> > > > Synchronous Ethernet networks use a physical layer clock to syntoni=
ze
> > > > the frequency across different network elements.
> > > >
> > > > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > > > Equipment Clock (EEC) and have the ability to recover synchronizati=
on
> > > > from the synchronization inputs - either traffic interfaces or exte=
rnal
> > > > frequency sources.
> > > > The EEC can synchronize its frequency (syntonize) to any of those
> sources.
> > > > It is also able to select synchronization source through priority t=
ables
> > > > and synchronization status messaging. It also provides neccessary
> > > > filtering and holdover capabilities
> > > >
> > > > This patch series introduces basic interface for reading the Ethern=
et
> > > > Equipment Clock (EEC) state on a SyncE capable device. This state g=
ives
> > > > information about the source of the syntonization signal (ether my
> port,
> > > > or any external one) and the state of EEC. This interface is requir=
ed\
> > > > to implement Synchronization Status Messaging on upper layers.
> > > >
> > > > v2:
> > > > - removed whitespace changes
> > > > - fix issues reported by test robot
> > > > v3:
> > > > - Changed naming from SyncE to EEC
> > > > - Clarify cover letter and commit message for patch 1
> > > > v4:
> > > > - Removed sync_source and pin_idx info
> > > > - Changed one structure to attributes
> > > > - Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
> > > >   to the recovered clock of a port that returns the state
> > > > v5:
> > > > - add EEC source as an optiona attribute
> > > > - implement support for recovered clocks
> > > > - align states returned by EEC to ITU-T G.781
> > >
> > > Hi,
> > >
> > > Thanks for continuing to work on this.
> > >
> > > I was under the impression (might be wrong) that the consensus last t=
ime
> > > was to add a new ethtool message to query the mapping between the
> port
> > > and the EEC clock (similar to TSINFO_GET) and then use a new generic
> > > netlink family to perform operations on the clock itself.
> >
> > Hi!
> >
> > I believe we finally agreed to continue with this implementations (for =
a
> > simplified devices) and when the DPLL subsystem is ready, plug it into =
this
> > API as well using the discovery mechanism. As there may be some
> simplified
> > solutions that would not use the controllable DPLL and only provide the
> > status (i.e. using physical signals)
>=20
> By "simplified solutions" you are referring to simple NEs that only
> synchronize their frequency according to what they extract from the
> physical layer as opposed to an external source such as in the PRC case?
>=20
> >
> > > At least in the case of RTM_GETEECSTATE and a multi-port adapter, you
> > > would actually query the same state via each netdev, but without
> > > realizing it's the same clock.
> >
> > True, yet for a given port we need info whether we are locked or not,
> > so the interdependency wouldn't break anything.
>=20
> But if two ports are using the same EEC, then it's not possible for them
> to report a different EEC state, right? The only difference is that one
> port can be the source and the other isn't, but this is also an
> attribute of the EEC.
>=20
> Basically, I'm saying that it seems that we report attributes of a
> single object (the EEC) via multiple objects using it (the netdevs)
> without making the relation clear to user space.
>=20
> I'm not strictly against it, but rather wondering why.

Agreed. The reason to start with this approach is that it will be applicabl=
e
to some  devices in the future and we can easily fix that mapping later by=
=20
adding EEC/DPLL ID to the attributes.

> >
> > > I think another reason to move to ethtool was that this stuff is
> > > completely specific to Ethernet and not applicable to all logical
> > > netdevs.
> >
> > That was an open in previous discussion. Wanted to first show the
> > full API to discuss where it fits. I believe all other networks (like S=
ONET)
> > may also benefit from having it in the netdev, but am open for discussi=
on.
>=20
> OK, didn't think about SONET. There is include/uapi/linux/sonet.h with a
> few SONET specific ioctls and a couple of drivers implementing them. The
> whole thing looks quite dead...
>=20
> ethtool still seems like a better option for something that has
> "Ethernet" in its name :)

For now we add it for SyncE, which indeed has the Ethernet in its name,
but I think the concept of recovering clock from the data stream is
common and applicable to other transport layers. I believe the same
API can be used in infiniband, fiber channel, xPON if they implement
PHYs supporting this capability. Hence if it's not a strong NO for putting
it in netdevs I'd rather keep it there to avoid challenges we found with
timing cards where we had to stretch the concept of Ethernet device
to use the APIs defined in the ethtool :)
Also the ITU-T recommendations G8261 and G.8262 are more generic
than just SyncE and they are applicable to any packet network.

Regards
Maciek

