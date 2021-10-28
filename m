Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E399C43DB31
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhJ1GhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:38036 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhJ1Gg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 02:36:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="293794929"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="293794929"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 23:34:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="580128676"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2021 23:34:31 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 23:34:31 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 23:34:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 23:34:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 23:34:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfa5qxImVRRxySvZx9RLxaewjOkP9VOuKMUF0ctENh1t1ZMEI/EoutbsnrBsRAYrmQ30N4MQq6gj/NdBrj2yDRPwKrKFS9E/Kd/4LkqH7A8l0hwpRjriW21E95+l5oHf7GgCw2tS5V2nMfSRtwtjRsJLhf4nfE6P1IqWuy/26O9WX8kS04DYhOzirrqrlQXlOK9mGO9SVgR91WbIMuPQwGoVEGR37NoB7lwUvKEoeIH2/M315IP8CcWlLh3KXJAKjiO82f/yZzObrlCADwXpImM0w7Lt14oXN/jXq5BMW7MwwpMNZQAiDy+DoAAGJzSr9Ys+gShvslJpjgMoMz6Mug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqJOxU2kH6ES3D7JOIl8Jt4cF/7J5ISq+DRUygFmL60=;
 b=Fg6lDe0R2u3UoEm4WS3zkqJsJf3J4AbCHO9qW9vsksaPhOlPNn1cOYazUnIxlKO5DBgqwWH9ZBJTg+I+ai6rRjGfN7En+gX9TPd4TJ61yRLyJXeSbQuk9hWSSJS1+Ba/J5qQOQrSLmWle/XrJpADwu82ILCTGioTxV8Y/QnsCZ+HgpfrjsEWqsjXLI7opjQ0ilRZYzBbXj0ocTS+IPqkwDUeV+wA52HYIpp+hNOrjc77YwuhlSSax0WGt0J0/U1r8rK6/ZQMFpxpVZU5lnqUDcVz8Wc80I+MptqZT4a37EHhCUapx61TPvmv/LXynE8Uqp9T/09gnD8ng7T4UzvMuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqJOxU2kH6ES3D7JOIl8Jt4cF/7J5ISq+DRUygFmL60=;
 b=MKEBQ9GEQ8EV4Bjzq4Cny7KUZHnDcOZUTWHrhNm8Gsifwv++3FcrqcEkYAoIKR6AdKXeSSfLLFjzDb8bvZ5OKE3frA4DhMugQa5s9WhVQMwIXnbms8PkMw1YsnnBr3ltx+fNLhD9B/BwMpBJeLUoq7hQTtWxGfMSYc7XNNq6f6o=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by CO1PR11MB5059.namprd11.prod.outlook.com (2603:10b6:303:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 06:34:29 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.014; Thu, 28 Oct 2021
 06:34:29 +0000
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
Thread-Index: AQHXypF5GnToGZDTek+S9Zl+hE1bD6vmbkEAgABltYCAACCJAIABAYPQ
Date:   Thu, 28 Oct 2021 06:34:26 +0000
Message-ID: <MW5PR11MB581227D73C9FD010A50759AEEA869@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <20211026173146.1031412-3-maciej.machnikowski@intel.com>
 <YXj7WkEb0PagWfSw@shredder>
 <PH0PR11MB495191854BF5470E9BF223F5EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YXlr9jEZ6jrywpe9@shredder>
In-Reply-To: <YXlr9jEZ6jrywpe9@shredder>
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
x-ms-office365-filtering-correlation-id: bfab7bdd-30d2-44cf-a058-08d999dcfed6
x-ms-traffictypediagnostic: CO1PR11MB5059:
x-microsoft-antispam-prvs: <CO1PR11MB5059AB4D2382BF047F7A8C48EA869@CO1PR11MB5059.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DNmodV6c0RoQTxqILJN5w861zgdmSmzmOAFY4tTJfvv5mRqVJ1xpWwxSH0Rof8CQF94CqHH7Vaks9FuKDIIp6BszKaRz8m7uVNdbLkiHwYOiqyj3Ayup2M5EI5d1mU6eu5Xy6G/QP7Dst/P1WEzSG/uEOncp6n5QaqtVqWuHi+D2/rtNh6minf+VXsIG+mppwIwHAdvOw8EBF9Ji2IsBBp9KCX3NmbY7t0mwwFlrrcGu0kHXvF1SqmUq11hTkGioJFQzlwJSaRgNDxUZ13Gl88ioL32XB8q3NZqaP0WwIlE7fR6prXfMgPtN7kAxCANYTHshBt7bgMSX+my0atkxvnulmcz9BAu8bHPxQKYQrRPagY3pDwgpYcM6k96IpKSHf7WJdXaxXQR1aJ1q3O91qd9JycOjh8ojGJNIUynunk8PaDTvtWTNbgg2/WPFn8nS0z4rTqzvx9+f5b9oLU94VmKj3G3bjBSKKCyn0sVS2oHSfucnQd9b1HT2sdqpBHc7Wq0e5USfRmqc6ave/d2Qxub2aE+HRzNbQgiCQAomNMJlw4aDXjat9gdj+iGLoYu5lW5LHTrm00k1Q6xBxFTrNi8YAkV/WrfaKMFAlMwZyR5+ixsfPj8Es+VRySBeQts9THJq5CfA3pRLRW7YPZC62NdN59zrgLBkFk95uPGNBo9/IoWVcPSRdE8/uFyWo9R/K52w2+XARQHYwwv+hsHjnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(86362001)(71200400001)(66446008)(66946007)(38100700002)(122000001)(66556008)(76116006)(33656002)(8676002)(66476007)(64756008)(6666004)(26005)(55016002)(7696005)(53546011)(508600001)(2906002)(5660300002)(52536014)(6916009)(4326008)(38070700005)(186003)(7416002)(54906003)(9686003)(8936002)(6506007)(316002)(15650500001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u6BlIoX/96IKKnU5a66n42Q52QLqwn3iScYEmvr/Iz0WnDPrhr9ljSivHX+7?=
 =?us-ascii?Q?pQrD7k9OOGZDVDU2ia4mubTRQu/Eq51wUCHnjPFAym3zqlU+UqxV+fG1xI/O?=
 =?us-ascii?Q?Sejb8J2dXRQLtGG1em/pO3xffvRc8xEXL07UTpzMz3ZeFUzowD3ujpukpmZ5?=
 =?us-ascii?Q?dPCx6PpOd8GGMCTYNh2p0YRfqydZiPQssMuCz0VYsw7Wxd9INj3jzov3ptNZ?=
 =?us-ascii?Q?ZURELIVA8tTnfSGtUgsguhb45lsWao7/3sIyLwii2cnhvNtF0Smgld+FYyRz?=
 =?us-ascii?Q?xN/Ik7eeJJGFgiLle7c7clRZoL7jPMUzcgQbRJkdJZKJ0R55RE1O+zgwa1uM?=
 =?us-ascii?Q?sscXPAbG2Nn9iby4UdVvMZKBnVECgZ7bm+P2BI+E+CJ5/ix5yPpDUmG5P0pw?=
 =?us-ascii?Q?Vrh+psPvur4kQojb27JzwpdTd5IKq2w55j8IHAtYE6BA5XamWWSiXqZ4/qPp?=
 =?us-ascii?Q?f5aXB2WRxlCfxTy/sTpNxHLpd4Yy3uRJGoXOi6+9CF4uYf1/8PcKsFUz5aRI?=
 =?us-ascii?Q?C5AfUbjuc7w/SXklhviK/dLDQCr3fAoxgf6Z/SRlwFWV+gPFTmp+nCm4CyQt?=
 =?us-ascii?Q?RJ+c70G3ikQjCTYYHtjrMAUCr9waJZroJopvdsZzTA3D66sBusFUk+LLzvDi?=
 =?us-ascii?Q?Kr+rS6dzt8oks09ZOag2jtIiMBa4XgYQ1O2cjXidL6afCf8hfSe0RS6LGQRM?=
 =?us-ascii?Q?9t4Dlx95A8wGprRxShitOZ4EExmr9qdctRRVQAaRWEKU3nyIcMkiuOqVHnID?=
 =?us-ascii?Q?L0YAmHpcYnrUJ7hBY6INalSozif2xFdO3pH3wj0iQT8RRhIOzuxp0vnB5mqA?=
 =?us-ascii?Q?wUOpSuMJArMpFUdsG0pxh8mQAdxhhTYJBhnkBybIWPk0PQ5SeOT1T/+SrPGJ?=
 =?us-ascii?Q?85OyEwFeq6j0K7vmit56dg2ZWudoUym4fw+PfLIc/RvzfTCQhLp5irLGerqT?=
 =?us-ascii?Q?tCJMp4iLxgDcOM8iDSXrUdO2RXCd5meoSOi6CKqeoPqE0Y6v79mDgjso2j3d?=
 =?us-ascii?Q?6LDpIB3r55K1HwSEd7f/D+pdP6+kKeVKuB+tKtgquAC8ovgbxHNde3mwjwAn?=
 =?us-ascii?Q?gfCpkE4/ml+M5KY20ycgezxtgMp381cM9BCw9ppDkaHW4wCfmuxliKNT2rQO?=
 =?us-ascii?Q?jQXEkrmHuKECCcvWaEvIXKvwKA6+x+t/Dtq8QALlgHG9UJjS56FCSyDB15va?=
 =?us-ascii?Q?YrCZTJ1tCuya01fCMG54w92eetDSkFqY7G7/Nq6cevqJAHcXh42P5lw+Gosm?=
 =?us-ascii?Q?9ggGmsQlU6E81dwaNCiHaXJQ/dlYB9D482d4dRaa7NszPXAtUKVXDoqKPSYz?=
 =?us-ascii?Q?ysqUhclMZLIE4dt53Jd3+S6koChtrsOeA5JjvEWKzHtaAKrcO4ZNeLj9TyZV?=
 =?us-ascii?Q?bXc4kw3K6cjZk9nlmp43cib0I1eQS1y3mEG0AooWVZvpgzXKlm4/GxL7izQi?=
 =?us-ascii?Q?Y7QgpKbwb0dRYjyaW6UZ/Whbr6CeLQAFZCMEPoBxplW1cXVHZ4CxfUEllUje?=
 =?us-ascii?Q?NWxbCFhXhK3Y73mr2z/8GdcAzG3Bc2ocw9vtOo2yVWczItRHd8zsfIN7PJ9u?=
 =?us-ascii?Q?M6FYdaQ9s5XcqBHABG+RRg1kbMmX41MbrZcKevt19WBwKAiM9gWx8IrCl3R+?=
 =?us-ascii?Q?pc/h4idztiJ/tmPW0dXaMoUl4zHLIl7o6wJLBJGqI8uGCh+r6oUiOnavaTZv?=
 =?us-ascii?Q?8GPt/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfab7bdd-30d2-44cf-a058-08d999dcfed6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 06:34:26.2709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8aZMbt3x7G8TsEeq63ntE/DhhwsptfhWUW8HKz4OzE1JO3HVb1dW0R2U4JwtfPYTfn2W9zqY92aMVfNIs6x0hv9sawC3hQl9Oe7DsnhP0u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5059
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Wednesday, October 27, 2021 5:11 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> linux-kselftest@vger.kernel.org; mkubecek@suse.cz; saeed@kernel.org;
> michael.chan@broadcom.com
> Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Wed, Oct 27, 2021 at 01:16:22PM +0000, Machnikowski, Maciej wrote:
> >
> >
> > > -----Original Message-----
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Sent: Wednesday, October 27, 2021 9:10 AM
> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > > Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE
> > > message to get SyncE status
> > >
> > > On Tue, Oct 26, 2021 at 07:31:43PM +0200, Maciej Machnikowski wrote:
> > > > +/* SyncE section */
> > > > +
> > > > +enum if_eec_state {
> > > > +	IF_EEC_STATE_INVALID =3D 0,
> > > > +	IF_EEC_STATE_FREERUN,
> > > > +	IF_EEC_STATE_LOCKED,
> > > > +	IF_EEC_STATE_LOCKED_HO_ACQ,
> > >
> > > Is this referring to "Locked mode, acquiring holdover: This is a
> > > temporary mode, when coming from free-run, to acquire holdover
> > > memory."
> > > ?
> >
> > Locked HO ACQ means locked and holdover acquired. It's the state that
> > allows transferring to the holdover state. Locked means that we locked
> > our frequency and started acquiring the holdover memory.
>=20
> So that's a transient state, right? FWIW, I find it weird to call such a
> state "LOCKED".
>=20
> >
> > > It seems ice isn't using it, so maybe drop it? Can be added later in
> > > case we have a driver that can report it
> >
> > I'll update the driver in the next revision
>=20
> You mean update it to use "IF_EEC_STATE_LOCKED_HO_ACQ" instead of
> "IF_EEC_STATE_LOCKED"?

Rather report them separately - as there's a value in having info about bot=
h=20
of them. LOCKED_HO_ACQ can be forced into forced holdover, while the=20
LOCKED will revert to freerun.

> Regardless, would be good to document these values.

Noted! :)

> >
> > > There is also "Locked mode, holdover acquired: This is a steady state
> > > mode, entered when holdover memory is acquired." But I assume that's
> > > "IF_EEC_STATE_LOCKED"
> > >
> > > > +	IF_EEC_STATE_HOLDOVER,
> > > > +};
