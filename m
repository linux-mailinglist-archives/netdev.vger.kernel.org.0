Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844C53F469E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 10:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhHWIaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 04:30:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:4417 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235607AbhHWI36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 04:29:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10084"; a="213929956"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="213929956"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 01:29:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="492617635"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 23 Aug 2021 01:29:16 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 23 Aug 2021 01:29:16 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 23 Aug 2021 01:29:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 23 Aug 2021 01:29:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 23 Aug 2021 01:29:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLesO4mpFjiutlkEMbKi9f4y4UpkJ9FCWfTpJm2/jNxCs0Laa1jPwKcUA1qCVQjQhnFLAMyxZ7DvmXindWgm9MuezhCjDyfbqIaNJnLQS7vNDAWQfHEGpIugy2wuSXN7Nlj+rh+Opd1kzQ7H4Nwrrsvg/LAcColL2ILakF1UUfxNsELnfVJWDIOvGyW32yC/j79L0QjTSkNLn5uB3PDhMMVL7tF+HvinxDANj+ygo0DheUbP7YVrzarNXLHQrocTfyVc9bXXx5eaXkj+oLOPoWfhZEU15v9aLm8xkbJjS/RVF1ypqSJPL3PhkpY7I5pN3D2l2jt4wbgiU31buDYWIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lj59PPqhANlYkYGFOANKIrAxEZUOAfmhEEzftqWDdI=;
 b=KWT0fieY1vPjrlybWk6L3LSAwrjHdWYi6wfisw3c7mTR3auAmQ3lJfcx9ccQs6iW/LkR5UF10tPwerGbODbyjYA/PUqFk05eCScgRbcAQYcHnEEKJ3B6S04CbiS6I4uyoRdFY8NwZLS/8vEwTLj/b5efgTTF7QoGjpauR3TtKtkffI6mKpVbBjSyX2RQZWCAUuisMwtNjd2c6O2MZ21Cj0DFoReyTjjybfi2TxSBVxQjfk3AYq1o91UR+8/TGbPHT9VbZ6LUEmyzbzfioKprUbvn5GVGRhyffFN6/aD6rjb4JyxWzhXQHPYpm8BwTj9ZmsjywDVVyBzIlmuws3ro2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lj59PPqhANlYkYGFOANKIrAxEZUOAfmhEEzftqWDdI=;
 b=Sw1OSjpPdE6p5Jm9RWfooMZf+ROL90sDjsIo2CrJmhSTHj+DzBEyZ/9iRRRxGuceKRcczOYJUKJHSKTZgpKfr580gf6MpAwmBxPl0zwjzrlhSxqDQibLyi1Fd311vmggbkGxlgJxKLssLeYdvu9GCQGMs3fFDxLTTmtbn3zAYRQ=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 23 Aug
 2021 08:29:14 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.019; Mon, 23 Aug 2021
 08:29:14 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: RE: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Topic: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Index: AQHXkrpDE4/97678+kqD5jc+QEB2qKt2zoSAgACcQzCAAhWPgIAAVWdwgAEkIgCAAAB9kIABl9IAgAAdxFCAAiYTgIAB8I3g
Date:   Mon, 23 Aug 2021 08:29:14 +0000
Message-ID: <PH0PR11MB4951C8C972C5123E7FC5DAFEEAC49@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210820155538.GB9604@hoboy.vegasvil.org>
 <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210822023057.GA6481@hoboy.vegasvil.org>
In-Reply-To: <20210822023057.GA6481@hoboy.vegasvil.org>
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
x-ms-office365-filtering-correlation-id: bdcbb92a-730c-4d2f-5b5c-08d966101715
x-ms-traffictypediagnostic: PH0PR11MB4950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4950078AE2897456DC37F649EAC49@PH0PR11MB4950.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K00jnlCYO4JtuzYsIFnCqwxucSNDUbCyk/BBE+yAGSPtrXcGoSVCbHCpNRMGqknkokPe0t1HjUfnhfP9k9eDeobOnGb5chm4ZQiF8ko+DeIDqD+NsAVO07tbj9afPfVMFuwL4l6SbA9UY7QNnX/sS6R8j73wYNx7SM9kG9NbKv4HNGUk0p2N1fAOY2Tb+dk6AHdfGV8L00YHVeT/lzX9f4EWiBNmnuDksVjSuQXTwQuRRrh7+KyPk+Xpn6xtX9CPgePsZWIbHyPRifYoaLM5N3CUCNgX4ZpyKbP0c3xo4UYG9tc4KpgDbN13o847B9QG68133u+SJyIGuQp22T9/XvquzVTwvQ2m2q3odMQKcu4fGBuUtV6vO1QlTee4O2ttBOwU6MnZCmCr6pVjFQVmW3ZGj9PydPc5bk7FdNETWLR71wJj26ZKMOzX+evyfH9ujkHfRTSjzttZIcw5B7XQq1fNnnZHxOsZiardfz54okZjXccXVqKq27bEM3qIBN3LwBi+I2awmx05Jcc8tsv60imXaRPftoYf8f0zpBOWe/HpraPo+Kv7WVFd6abqAfSNzqkXXDodxBy8edrurLDRXKi1Ya618EMQE0V5arIRA1BZB8pn4Xd9LTebskhXp1P/uQrgqX+NxfXxWZyyXzgPbFg7hkBf2RNyQBiIKyWg6fbpqRafzMZkbsg21uIqJLcMWLGe1dptyXGC5KH9iBefCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66946007)(4326008)(8676002)(26005)(66556008)(316002)(38100700002)(186003)(66476007)(5660300002)(55016002)(7696005)(7416002)(122000001)(71200400001)(64756008)(33656002)(52536014)(8936002)(6506007)(2906002)(66446008)(86362001)(83380400001)(38070700005)(54906003)(53546011)(9686003)(76116006)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hxCXeIFks2VnjPioWWqQ7KL7buZiraETtWYa2d8DzUTgiv0RdPcfGvRfdnH1?=
 =?us-ascii?Q?I3HSdvKiJTSTHmIVWb9POR3lghRfuUdVJqvx/62uFumW9VuFAk7cA76IlZjA?=
 =?us-ascii?Q?la0x7wfA7Yj1djcrVlS680mvA6n5bFazgYEKlXGSswpZkzZXLRFt8zbwtJrN?=
 =?us-ascii?Q?Aj9enS1m72HP52FEFvekNVFGBcy7HN+0/HddlLZeAkiCUWWqtoF3295LqwTu?=
 =?us-ascii?Q?cY3h2cNmCwkgr/zm2eDMYu6MCJF1cxzaSDmMo2T/dDHwvv1uxuUgIwfkpsuZ?=
 =?us-ascii?Q?GC5+oYz9cg//uk5J/IA+gi8EPa2wF+QQGKR9PvKImEjp1fLDDY4t8YxX6Ld+?=
 =?us-ascii?Q?9R0jHfpTz/1BRYS3YusmI0fsdEri/4TdzZM/yWiPf7oBUVyJaWcp5iv11yyi?=
 =?us-ascii?Q?O4tsGyYOSQdZBDcTfdWGk3Q584diWCVwo6MhIM4GoDaMARh5MIl4suMh0otJ?=
 =?us-ascii?Q?OxKy+x9onBgbu1phcAKeS4JD73QrEJcPxp4ks+X/8RwHCFsfjvaxRLiMNAJv?=
 =?us-ascii?Q?QpUUfH6qYRB2QzxzyQFZiQqfx23Z2ha/HmfVCoyjZlw0dKaVCCBGMjK4K1y7?=
 =?us-ascii?Q?AqORYxGkMrBecwWGv8+7Uvs/shmwnVZZHFgP8QTx3AXMBeCKFHnnQHCpMUNz?=
 =?us-ascii?Q?MX6vVSiboOmNNAkcaPhfHTdFzk6N9w1pCSF7iO73fbX2ogpr0miYlKgER+AS?=
 =?us-ascii?Q?R1tUFfPQNGtsLyS51shgLKTPMgdwzfRBir15DbTmXIsOIupXZ2Z6bsmxtec+?=
 =?us-ascii?Q?rucsPXX8Twc9qds5o5J6Iv/BVW1ECZn7iU7AYORFN+Hq4tl3kbDWkACH2ZvQ?=
 =?us-ascii?Q?eoT36WR0B+RgZrrZXSqBnS1yCxYfTSzsNO3+K9w0boEbK1IT3M6z/GQMldEi?=
 =?us-ascii?Q?uaF8Do1a1eYw8dPmOy+42BSVNEpLW/EJxFmMtWtB06ZH9ND9Cs7Uf9ozUGFC?=
 =?us-ascii?Q?Yz+HNvjY2Ygw1Fu1wclr1UU3N/UX3QGw7OAZMnd5h3sPDklmGolKfLctit6y?=
 =?us-ascii?Q?Uc80TgOjuKnscWyhXJ1BZ8t/z63lYmfBZamaYkIxMhk5ZuVj+X1BBq2IAS2m?=
 =?us-ascii?Q?XNBzk1j8Pu7rcNxtFPUPwhYGWijDnDavU4RxIC3sdDyJS7EvadcOgWr3QvDv?=
 =?us-ascii?Q?r10a1+2tjjrBZhzKiA6mduHEyJ6dSWkf7tS4x3zaZn1glwokfADjNGHGgmIb?=
 =?us-ascii?Q?4YlHPjHY7HlbOQJZcKSyLtx7J/Fai2F16yosKBXWHdMUUBnmuav44whgSbBJ?=
 =?us-ascii?Q?DlyPJXZCDmW8uCX8ZVPKa38VSVi1HFkBIpehz45eoEo+6jn+ScqyKFLgg91p?=
 =?us-ascii?Q?ViY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdcbb92a-730c-4d2f-5b5c-08d966101715
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 08:29:14.0778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmsu8Vy+OpX6so8oFaRnW20RDZhapJLs9/AlsyoA70UwubByuW/pyyfqmI/hY6ln2MPCQgJAgTgkwtCrYmZx2L72POFm9FuvnSGyiNJR+8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Sunday, August 22, 2021 4:31 AM
> Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL sta=
te
>=20
> On Fri, Aug 20, 2021 at 06:30:02PM +0000, Machnikowski, Maciej wrote:
>=20
> > Since the 40.5.2 is not applicable to higher-speed ethernet which
> > don't use auto-negotiation, but rather the link training sequence
> > where the RX side always syncs its clock to the TX side.
>=20
> By "the RX side always syncs its clock to the TX side" do you mean the RX
> channel synchronizes to the link partner's TX channel?
>=20
> Wow, that brings back the 100 megabit scheme I guess.  That's cool, becau=
se
> the same basic idea applies to the PHYTER then.
>=20

Yes! Sounds very similar! :)

> Still we are doing to need a way for user space to query the HW topology =
to
> discover whether a given ports may be syntonized from a second port.  I
> don't think your pin selection thing works unless user space can tell wha=
t the
> pins are connected to.
>=20
> Thanks,
> Richard

And a good catch! I'll update the RFC to add the query functionality and mo=
ve the SyncE logic/pins to the netdev subsystem.

Thanks=20
