Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B324046E6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhIIITX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:19:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:59902 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhIIITW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 04:19:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="281735795"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="281735795"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 01:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="430999647"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 09 Sep 2021 01:18:12 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 9 Sep 2021 01:18:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 9 Sep 2021 01:18:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 9 Sep 2021 01:18:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUD701QnoywN84tDQyHaq9s6hPxRUSArYOgDZ5mL0py0ER7oQHcvW35vjvQHTWqTGPus0qj6B2q+LuzmfgTs+DXyKnUsai4Q9XQWZfpt+hblIn3bBPj2LOiKqr7xyHPs/EpU0NJWgIDqJcBrTbr3tLoa2/hd9mXAW6x0YoRKtU55EIZrKNPwRNgqHFRupqjBFZcf7kg09cvPdo4x50brDzFK9OvYMNws541wacyGOks1IGhkBvmTgTdzInWC3JIRlIwx3uMLJZzZnfYXvFeFUJVYap/tpa+qOF/T1KkV4rH1YeqdgWvSeyGCULpXDAJPqzaLhv28LiUpnNcCKGglAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ut1UF74dcsdXYADWaYeUKpJUMijIEG3UcS27wobyZ0=;
 b=hN1cu3JHu8PKFEh3b71e8iafLVsPytnGsDpGhjHbSBgWn3Ls5uSkfk+jtEEGEdWRvVLioUlD9PRHL3ks/xbjFxTMl3ZxKH7kWkj8AZZFQ3XmM1bQW5ex5VAt1KaY7YipElPaOoJSagPgmoVloptaUXitdMmlHfknPCG0D2saeMnxDMRqskAbKzTmArsE8mVcpS5DQUK39g9HtMDtw8+oqadhDHLzmH17ekray8oF7XkDaAH0H1zj4j3lFOa5+MuljqS2CEhDD91GFVvFHxny7EeLVEC9W1Lw/A2XoIKfwtt+lkrKO7nkfMudnNjVadjlSuzhUhZYBN7Dv3ZDAiJBbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ut1UF74dcsdXYADWaYeUKpJUMijIEG3UcS27wobyZ0=;
 b=tXEq+6wdDqdXCiziHuDeLAi6nvhHVSWSW9fLxciyVUcMgau/DN35UFVub3lLUSGBmY2Tp9/KHTmm+KSRNdbhRhEGdYAK8iwDDbfLlcjjJrXFMymapTA+vMGcTSTWH1PluXvK+Gpp6WGVtwuWXwBa4KPVNKbZLvvDvEyuzFAdJZs=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Thu, 9 Sep
 2021 08:18:10 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Thu, 9 Sep 2021
 08:18:10 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Saeed Mahameed" <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQgACTXICAAAjlIIAALSGAgAAuVoCAAArlgIAANQiAgABlvKA=
Date:   Thu, 9 Sep 2021 08:18:10 +0000
Message-ID: <PH0PR11MB49515C4ACE9BAD7BD9172825EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YTkQTQM6Is4Hqmxh@lunn.ch>
 <20210908152027.313d7168@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YTlAT+1wkazy3Uge@lunn.ch> <20210909020915.GA30747@hoboy.vegasvil.org>
In-Reply-To: <20210909020915.GA30747@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5244f71f-38b1-4ac0-9e28-08d9736a5cc0
x-ms-traffictypediagnostic: PH0PR11MB4951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4951419D89001CCBA4BE9CA0EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWSl4nIDe4PNNmK04WjyXHAp3UtlEB6VCEEsjyTMgIdlZpLOqalvKGulsO/B3CbZ5Vr0roiLd/wGVqlRpQkl9giC45O81FPzEAH4UNPqerybHMD9xjcUd85wW1nQodgOBmJ0LKdOtHo1Lx26i2mlABA7eyPBklo4mYhUMbU6nIyouBhwCP+Hpoewx1cFd/WAcSYqR08CnOmn4ha36nLi8AUYGmtmgn8LMGslQ4jTAIa6BOyWRHTA8S6DG/MbonAgZ9EO2CAxk7Qrgq1er6SZ6pXB8hgsfBhA1LtvPRsKmbRPfwCpq1djHRpUQCrEooS7JIuAYeLsz0Y3DoOBnAvdMlo99I1AVYCCMNEz6uGrZCibd2dqHNEkwVcZ9phoe81zksDNbLxT6aAmqMxUa7SrsQQFSZ119PRvKNPRvOKkhsl6/xo9hJKP1yjSERNQhsPf3OgfhVXdeMTR5Rit8xgHwXuC+6ErDCfiUW2FXRULVmxiGwuDziTW9jITHietLJDmWsprri0TzKsTlx2tqI2lMH4dvGJnP3no/GHtOGgIbxmYPtl2S0xnLMwJ64FWvax1fusXpDLoo/rkEEgQIdLKPiJpmeuq++w61x9bJTtzo1q3hsJTxNFhddEEHmoEHXSvw/xLwqq3XpQ80cim9YPGzFqgWJyVLAfjbQltlDt1wRUNdMCejl046/BEvVvzIDAT46gFd7yimxx/JoQTWCuYIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(2906002)(76116006)(83380400001)(54906003)(86362001)(478600001)(110136005)(9686003)(33656002)(71200400001)(4326008)(316002)(52536014)(7416002)(5660300002)(186003)(7696005)(8676002)(122000001)(8936002)(26005)(6506007)(64756008)(66446008)(66476007)(66946007)(38100700002)(53546011)(66556008)(38070700005)(55016002)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hB1CDBuUM/jmQVDNnIyi2h3jIZ4/65qRT667Rj9bOXI1U3JvznfMKhCGfaPA?=
 =?us-ascii?Q?18CQ4pPKehEPyv705jxr7x9zE77UCdfeROcvaRouxdVmy3klIcfbt23SUgSP?=
 =?us-ascii?Q?2aClBM4QVKunCWeZLcKp6HOr9Zi/R/6n57hZhmk1JO0NqsmCuHw8m7Wwdw9I?=
 =?us-ascii?Q?Emdaw/GUU3OYBnmzuI5Y1anLhZS9B9+uY1zzrfqurxTm7mVDkgnzREzuzyZR?=
 =?us-ascii?Q?f8UCg1pCjvlwBE3IJAxIsbIjrIjz+j+QOD1uSx/FSiqUehx1NUdJhbWAzgRg?=
 =?us-ascii?Q?C8P3bMb/alRZzO8cJBsSVWIgp446BkvRzW7E1INONcFKzDzAm2LTe2eB9ko0?=
 =?us-ascii?Q?rG6cO1jHpmP1gEN2dh4aXidFZWv73KYbeKYremLGKaJC//wdy9/Dp+Tjndkd?=
 =?us-ascii?Q?6iJxjhKQqCEyut4z1GYkX63/wp0dpXFgTv4ApXolQWI9gARC4yI96A6OBGgx?=
 =?us-ascii?Q?0bPdBAdJuA8lc1S6SmghhAC0kTZAqWJQf6HgpLCsHwoIYREqrfIBj3PNdSDV?=
 =?us-ascii?Q?d8s2Ec2gAAfWESocOEP0WbJUnIHlXtRm4KP5igY/1PB+wGFqProC/egXCaX9?=
 =?us-ascii?Q?4olmvplPj6V6XyoVzQpBheZ9Um3H7Nq4xcknsa6poPnLcC/1iTRJh3E+BqzB?=
 =?us-ascii?Q?WmThbkXRvZiabsO67RX3EfpQ4t1Z9dI8hVl2nhuC7NijZ2jgV5UZG2JJVA/S?=
 =?us-ascii?Q?EpN57GPu4/tdqTt0Ju7u5/VsbUrlQrRywuYBVJER1zkO8zhxeIC5jCDr04PD?=
 =?us-ascii?Q?rtavi4xlOP51stnTX5ye2N4Xg2QYf7kBMDNK/d3foLL17ePkiJmoALr94+sd?=
 =?us-ascii?Q?2zHS5HuwknWWkttRzPIJzhV4GKJQ/etTdtn2y4kg4hAi6f0kv1x0bOemfXgG?=
 =?us-ascii?Q?tipU/dh82GT6ZTr5jhgn/qYJ0CanDnPlaNtEK/agcwsPWcaQWxc6klHLFiUv?=
 =?us-ascii?Q?jqgeoMaQAUiWPJgZhFoQT1Or++VYF/bAESfQHO967qyGhIFWQNLv+YVwQgRy?=
 =?us-ascii?Q?p9iVZhO0AnnZnxs1jUygmDxs7r8ySZ1CflbZA5aFclHY1EcQLPkKQOuG6BuB?=
 =?us-ascii?Q?mvKHrNpFBkl91TKWIcVodwPTVwkDA9oSuT1Im76RjyLgPU7O1FkQBdazLeh0?=
 =?us-ascii?Q?RmUstXqCn4ksQ36n5c1fi8zC2CuaRyKH544A6xyvLMGEKDWOSYGNejC6jbZR?=
 =?us-ascii?Q?Xe6YkgYRlTMqtNfAgr2x+2Om2l2HyD8MeGyB3gO/Jnu+LcWBqGeNeTO2/UF9?=
 =?us-ascii?Q?34avLUE3uBsSnm+W3RLMVF9/kv3eOerp6PgCFGAK/R5x2QTp4aOYPdbuRFvv?=
 =?us-ascii?Q?+EQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5244f71f-38b1-4ac0-9e28-08d9736a5cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 08:18:10.7847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xf5YmUEsWfDKv8iC21YsX4A2LFpvUBpoekEQS5SqrnmmL4qLcKFCAEiU5kRn3lanUINgKkMdh4hMjPU09Uxmb+89XmJeH53sfLp1MY6HPPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, September 9, 2021 4:09 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Thu, Sep 09, 2021 at 12:59:27AM +0200, Andrew Lunn wrote:
> > On Wed, Sep 08, 2021 at 03:20:27PM -0700, Jakub Kicinski wrote:
> > > On Wed, 8 Sep 2021 21:34:37 +0200 Andrew Lunn wrote:
> > > > Since we are talking about clocks and dividers, and multiplexors,
> > > > should all this be using the common clock framework, which already
> > > > supports most of this? Do we actually need something new?
> > >
> > > Does the common clock framework expose any user space API?
> >
> > Ah, good point. No, i don't think it does, apart from debugfs, which
> > is not really a user space API, and it contains read only descriptions
> > of the clock tree, current status, mux settings, dividers etc.
>=20
> Wouldn't it make sense to develop some kind of user land API to
> manipulate the common clock framework at run time?
>=20
> Just dreaming...
>=20
> Richard

That may be dangerous. In SyncE world we control clocks that are only
references to the EEC block. The worst that can happen is that the DPLL
will ignore incoming clock as it has invalid frequency, or it will drift of=
f to=20
the edge of allowed range.
Controlling the clock that actually drives any components (PHY/MAC) in
runtime can be a good way to brick the part. I feel that, while the reuse=20
of structures may be a good idea, the userspace API for clocks is not.=20
They are usually set up once at the board init level and stay like that "fo=
rever".

The outputs we need to control are only a subset of all of them and they
rather fall in the PTP pins level of details, rather than clock ones.
