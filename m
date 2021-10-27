Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCC843CA66
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhJ0NSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:18:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:60552 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhJ0NSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:18:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="210936197"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="210936197"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 06:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="635712833"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Oct 2021 06:16:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 06:16:24 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 06:16:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 06:16:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 06:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qc4ZHj0gVZOcY6C+0AsMcXEExlTvrSug2WecDq26nhGSNPHFEPmOEjbOsL8FPs8A2dOS6RVQIiAB+aWa6tngt37I2fbfFgAAv4ge7XXc+Ig6+sBLuqgP7yFw/j8cuTIOfE+EB/prKAwhn7NKDYKmfo2waQ7Lvg1R+dzxqvt31epSzbfBnAJFiwGXgPn4m9RdrTVgKBCVqmoP8F3OJL9CP+u8KXJ8Til90KrsOu+vhelBI7otTiNdBfGmXBHUmE6UeRwcvLvqz9ReYZdzpAuqLaiX/1XsqEFOXfAlE0eSl/CAW6TfRm43mtOopkJr3tc9lRnEUdf59jK67V5f+20L4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PQgdmIo/bxhhjoqVE4S55MGHmhrn0+NUojKXtmXrkg=;
 b=Q328V6bN3qRjByQVLblQx730SdwnAER/8AiYXGuwlBHjKqbSloEI6ab+rr4/HZcdCRb2WElpLIaU3CPveH8FmBH27VGE5w/seAn4tb0xYhhk+xdFH88S5BeUvOrLtp4VVutdVS+Smozc8+nhO5On7nQ5ZI5mZwON1qp9jMCduWBQI+DbylZA5xj6QSHk/KUeWs2aRF/LrRix0LRFiySe0yfW8K2AwlVif1YoKC3HtTeORM4XKUL7h60AuSMEgnJtf7+ZgSg7xGL7ebWHuflL1ZESyjqt39eQ5xXiqzkZVz+I5hbQjLD7AOcwAv9588ogPaEB6dup24DMLqGibpW/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PQgdmIo/bxhhjoqVE4S55MGHmhrn0+NUojKXtmXrkg=;
 b=pPVAAY6PzRSJT/Kqn4f4bBaGK1SnHBPVTTUwK8mrw9F51384n53Kwg3zb4th2/j+K5JzPiELBFm4e7+h6paqAb+NliemUN8il154sOWc11/WQMXXrmwIG5pi4LKmLpUppYD86FtcyzFEBdH558+5O6UcYL8WIjbaLKcmUxUo2Bs=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 13:16:22 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49%2]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 13:16:22 +0000
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
Subject: RE: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXypF5GnToGZDTek+S9Zl+hE1bD6vmbkEAgABltYA=
Date:   Wed, 27 Oct 2021 13:16:22 +0000
Message-ID: <PH0PR11MB495191854BF5470E9BF223F5EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <20211026173146.1031412-3-maciej.machnikowski@intel.com>
 <YXj7WkEb0PagWfSw@shredder>
In-Reply-To: <YXj7WkEb0PagWfSw@shredder>
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
x-ms-office365-filtering-correlation-id: fc52295f-dfe7-474b-0c85-08d9994bf8bd
x-ms-traffictypediagnostic: PH0PR11MB4999:
x-microsoft-antispam-prvs: <PH0PR11MB4999B2C281F0A93EA064E4F1EA859@PH0PR11MB4999.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lmvp/LxFGroCK4ihYwqUKyWHKIJfiRijfTAC+x3Nr5RgIZ9qdmB1zCnYj72YKiIZSdPE6iar9ceSJlTx8U+tguoYsXug3rt0rrqfA0URkm/5ORqHFJ1M4SnrQflKAEUoKuxzwCGUl5ivdT9hwNBNwg+ta9G/F126Yprrs6cpoJoisurHU8R2+y2GKxRJxr64ShghUSwKOGNNWz5v070M2fgaSVv73ZpzYMRPi/JuAC6SESNc8YiDpCfqvu2kBLFCgFqaEBfNVqhgwU3B/qd8ad2MRXi+5Of3YaMFH+unHobxxUMSjIs92t8E4Y+dVdXlN/rbNwWF7XbxIq20BSUvGeIG0JEQT1JYir9UbBHJqRJctoYZ8rX5vNz1XmJUfDaVZ8/zvuuRQbEu/tSU7eDdzssAHZlrS0lgd4Pl+Jp/2b5JWbnpEhPKX0UHOPiVsVB8gfWub6m1sC8B3liAbP8O0wXFqBEsQBh/bTpNUew8zjXsmEK7ne+QzboBHI1IAbCcgvro62mFQ8348wmeN7POVUET6NZYLopClrmeX7tEWUI2hq3a+B71ef68Pfnh6YbaUHjq6g97k3O1zLEHir2hoYeIeaiXP/JK67WLLyfCNDJTNlpQgm/vpA5Z9NKJTV4lo38HJsejmj7qzCEWvuPmBefAKUGnuBUsVTAEHnk2QEwdMV2ziT4LYmZqAVssNkVACqI1P6pOzrCLtrtenE7Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(53546011)(8676002)(66446008)(64756008)(6916009)(9686003)(52536014)(54906003)(316002)(7696005)(122000001)(38100700002)(2906002)(6506007)(38070700005)(5660300002)(71200400001)(83380400001)(66476007)(508600001)(82960400001)(4326008)(55016002)(66946007)(8936002)(186003)(86362001)(15650500001)(7416002)(33656002)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fxdpei6XOsJ6y/DhuTw/2RwT0Uk2rtyb2rFRUmYIQhj7+PIeKVPm7FEpqeRR?=
 =?us-ascii?Q?78cnf4IDU53/J6S9mREG1KdJJBbpe1N5voIqMGqhmi4Dc6CZ/HwVVO8Jh4DL?=
 =?us-ascii?Q?z0QtkcQVNVQpSjOA02f0RXRV/VE7ry6zcQ8rcK8waHF+sbFPWrDClAP5VwoM?=
 =?us-ascii?Q?vP5gjXa+7ba9uL2Y77OM2J7JIytGCcEOrREK3UlhmlWCee/2+bADUeuQN0xt?=
 =?us-ascii?Q?5EH0fG4XkOLaJ00j0YhdBxaVUO3U/VndR063zxgbN/3XE6y8Y3gDIATKRJ+X?=
 =?us-ascii?Q?n7P3v9snP7lJXERXWDCIpKKT0+aJLXAZNh58HU64OjR8N+jIvbr1sasyNLqu?=
 =?us-ascii?Q?uheNgRfNyRDlqV+VC1Clb0RpOsoOgzsd0DZWF+ETVMe+38KpFO0YjUbKyPHv?=
 =?us-ascii?Q?mEGkrwv7z/YkI7smQ/X5lTd+lYVSTHtkjeMhUMp0ZRVBqLhGJ2bJ8V/u8GkI?=
 =?us-ascii?Q?6lXQMY/dxahstOGVwtJTkTcXLYiC9jFSmbkDI/i1QI4x7wrMifJYmLpr8HPc?=
 =?us-ascii?Q?+DYip+noCODHKHSMWMm5i9fmBLGt4XVVUGFL2UzrYash0lNoV7+KWj8Y48xI?=
 =?us-ascii?Q?HiEUes59pTKq4Sirxd/atObLJAvNND4hY53xbw6m+Hu8MeQDU3ov+oukbNKE?=
 =?us-ascii?Q?NmOw9g+6R/ADWxsds3I8ofo9hPfnvvp9wP+zFIaUsf6Eg84Yk7KavNu7rbPX?=
 =?us-ascii?Q?Y9HJHXfD08YKAqMGTAlWUD8/86zeNUGCV43EWDyZFyZX/XtZZo5qLGJpYUhA?=
 =?us-ascii?Q?1oXVefSSqpkgP1OeKW5WZkg0kKclkkKp+ONweuwOOFb+Bo42+5clN0Q7tJj5?=
 =?us-ascii?Q?d18zu68ZK5wBw61bCfKZgXJKWE8KyQFx8veXq3C44ZRJp7D0FvDSlB3ecYtN?=
 =?us-ascii?Q?mVcbh3CrXuovK6H6PfcDcajZ7VWc8mSVkaCTkdQQdY3U5HT70+dMyUgHEGjh?=
 =?us-ascii?Q?r2vWqcXlKHRkOhcpkGFVBTVKgeMJmSsH5f/tsUtYS1ddULCdtKWiVpUc+bHx?=
 =?us-ascii?Q?DKdTuGQl0HipPnNA9i0TSpUvzz/oJQhLVQh7SOcgMbjXGosHsx9DA0jdqO6U?=
 =?us-ascii?Q?LAmaZJ2yky1RJWNEJ3JYYLC9DRFYDn8iogm40J1ngNN/iTtt36XLOHDvSj+7?=
 =?us-ascii?Q?w06hRlVWh0O2j5RfHbvw+uWCVoDHuUGV7JpLy48K6BAdX4RNhjE9NFJUBXKX?=
 =?us-ascii?Q?GzTEHSEFH+4KjzjlgKmwOzG9OO3nI0Pmq/zcQRVjKR3nIRCrxDhpDyUt/IJw?=
 =?us-ascii?Q?J56FAHvauSrYyrbhUsBK/DNXgpr21S7hLGZ3wfxFCQtvN4HzgJUFe8pO+uxC?=
 =?us-ascii?Q?cl6R4+JmXzGUdonplBw/IGjpGs3jzWTs8PbzhyIBSHYO7ASQckLpyUWomHp7?=
 =?us-ascii?Q?7r7WZRV4p5ftS4ZwnNPBwRxOsrv98yKUpovEIzZ8oqJXLHsMUjMXmwS2UoEq?=
 =?us-ascii?Q?uXFuIwv4G497u7XhDLCDPEaUFSz+X90y4+bPdyjp6NfCZCGKVdv0WUPojPs0?=
 =?us-ascii?Q?DmbJDPTwQ1F4bsSZZQtLxlA4+xBZRPnAu4eoZTTp5McvCqeP3oV5V/LZhjIv?=
 =?us-ascii?Q?L90tiKaLtUZsAF5e5RTR75Yz4sVZMQy38A5sxkL3Jce4ylG8YwPuyFnG30H+?=
 =?us-ascii?Q?yh/ZH3lbX03GrlCByBZWsJ4Hh47zBi5uo8qRJYeSwJyuO+anWVT0AI3zd8eo?=
 =?us-ascii?Q?qhnrzw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc52295f-dfe7-474b-0c85-08d9994bf8bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 13:16:22.2818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HxQ3zLOukaLLxuivfCGWuEUygvt8EEVfTs0BA85H6HTvHEE4F1MtaALXlI7DGYwLfA7x2H0Kfz9AOCG1uH3OcZnQiBXVX6cHU0bfaagIvZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Wednesday, October 27, 2021 9:10 AM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Tue, Oct 26, 2021 at 07:31:43PM +0200, Maciej Machnikowski wrote:
> > +/* SyncE section */
> > +
> > +enum if_eec_state {
> > +	IF_EEC_STATE_INVALID =3D 0,
> > +	IF_EEC_STATE_FREERUN,
> > +	IF_EEC_STATE_LOCKED,
> > +	IF_EEC_STATE_LOCKED_HO_ACQ,
>=20
> Is this referring to "Locked mode, acquiring holdover: This is a
> temporary mode, when coming from free-run, to acquire holdover
> memory."
> ?

Locked HO ACQ means locked and holdover acquired. It's the state that
allows transferring to the holdover state. Locked means that we locked
our frequency and started acquiring the holdover memory.
=20
> It seems ice isn't using it, so maybe drop it? Can be added later in
> case we have a driver that can report it

I'll update the driver in the next revision
=20
> There is also "Locked mode, holdover acquired: This is a steady state
> mode, entered when holdover memory is acquired." But I assume that's
> "IF_EEC_STATE_LOCKED"
>=20
> > +	IF_EEC_STATE_HOLDOVER,
> > +};
