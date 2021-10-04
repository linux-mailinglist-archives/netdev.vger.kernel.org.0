Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2779420953
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhJDKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 06:32:27 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:6469
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231663AbhJDKcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 06:32:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hd1rXK5asWROzGo3oaYU0z0FHVctofFEasBfN1LlbGqZzG8qjMYRFbpGwLWadPRNgNJvQwLc7WiXNldAqIrIOTbhWd8b9j7QQ1eHm1MoTRZyLRrlT6Sct9N7t8eXrp9PBtCFyrl7hpe/cmS+VpikoMDnb42wTWQsjRhc8Z3kq3NfvStLrbZWREBg0sbGWIV4vI9Chhv/Weai2eY7LizooS7xUrfWh2u60xHDx61V7WkZE9J2Vey+l1SNnJyJq/t7Cs/h/tgwgx+aDUTwJYVRENoldsp3D1/bZcF+O6o31koRAat5sbJa8NRr82gCyupWwLFdQda6KnSHxDE1Uc2LEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ta82m785LFUJjw2ZL7SVe71XAxFPCgqa4fZdCtRPxVI=;
 b=C0/ZJwmXVbliTjOUB2zR8bWaBX4smPorVCG52twAGhd0uR90wbqWgk8Bj5veC2Sm+6caExFkjomt7tJMs0ApiBKcZ5AV8zOlbfl3sH++rNR6FolLtSDn5prYZLXf11S97iXK3QYs2vCS/hyJ5vQoNng+sh0nkr00BhhdchNLWM5Ab2tTjDeghhNw85GIqOfjE+ZVCt6PuTQxsqhBZ40tp6fuj2qmvEcvrTXuH8gQNj3s8PmaaUI0bhLU4m2m+eINrJCcHwYZoHO5tqswVjloQberFFAKfTqFDr/6+EbGvJRu8ug7tiyYmot+peig32JAJlSfqQQwmWX/OuCJoze2PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nordicsemi.no; dmarc=pass action=none
 header.from=nordicsemi.no; dkim=pass header.d=nordicsemi.no; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nordicsemi.onmicrosoft.com; s=selector2-nordicsemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ta82m785LFUJjw2ZL7SVe71XAxFPCgqa4fZdCtRPxVI=;
 b=fDHCZSH7rwhovZd7N3xY5ue+pbCQPFCXLQ5hgObbIaO3tlwznaaQc7xCOJn2NdJRDFC5nsVMGfIbOY+C0R/WpCP9ER0qz3Kc48AAAPZ5NICekjLTRjRyhJgkh7WnaZlrhK2iXLg1Nx2IxqokKAXIj54QzGbHPT0gdUDA0HHHAQw=
Received: from DB9PR05MB7898.eurprd05.prod.outlook.com (2603:10a6:10:263::11)
 by DB6PR05MB4518.eurprd05.prod.outlook.com (2603:10a6:6:54::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 10:30:34 +0000
Received: from DB9PR05MB7898.eurprd05.prod.outlook.com
 ([fe80::18d5:e101:fcc4:8726]) by DB9PR05MB7898.eurprd05.prod.outlook.com
 ([fe80::18d5:e101:fcc4:8726%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 10:30:34 +0000
From:   "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
To:     Florian Weimer <fweimer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: RE: Non-packed structures in IP headers
Thread-Topic: Non-packed structures in IP headers
Thread-Index: Ade11fYpGxA4RFKaTJCxYimSNlf1AQBKmbUlAIFwjVA=
Date:   Mon, 4 Oct 2021 10:30:34 +0000
Message-ID: <DB9PR05MB7898339C06B9317EBAB13437E7AE9@DB9PR05MB7898.eurprd05.prod.outlook.com>
References: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
 <87bl48v74v.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87bl48v74v.fsf@oldenburg.str.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nordicsemi.no;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a97b812b-7a7d-4d0a-dadc-08d987220003
x-ms-traffictypediagnostic: DB6PR05MB4518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR05MB45187702EEA595B35CB2CA0BE7AE9@DB6PR05MB4518.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IyHS4/C8ycDuCk627sAlOMs0EAhwIZFff2y//EOX/ykocUTHbLAvbiwhIjBw1mLb0L5pNHyrIP+bNFaExobKTc+nf7Bvq07wnhb+ihLnTCZRHGQ59RvNzLQ7RPcjT7bcAlJtRTI8RjcFPsuELqDy/Qzc9ut4NS2ChTQ6LJg4FvYn7cmkDTi3ox1N2WIVpYFAtc9ac89W8GlW2Zwb/L4o4PPBBODPkPc01CN6nPja2ONTpQOe3cxidZwa2nKPw7cRB1xC5RBRMtg6k7SUsXQZz2qcAkDFpRdHPiOmX2TlCMSX6dVbTH7obJ77WvTmXC6nbto2DxzF4SMEF0e/i84X+mdx6B82q5zoTLSPaOOtzvb3eIzWRLk0JOv7kup4/Slk7bYJkLHtdNx3NA9nI3fqgYmFyg+VEUia2o+TWq3ViE5YtFDHXvJmaqwqXQqHvyLesLmM3o5C9yZ+R0WhWsPS39x7lYKlka/jkEXA1d0/YC552l2atv0nUoeQLDFIHl+YHrqyYEIhvW3LdstH6t7IraKLvbRIM4TQOJiX2y9cJgpJNBWOajl1xKBRmN/7Mazr+ALTxSYRuvNoL6rBR/fMY9HsUehYxpvfXJ0HOWtQkCZ5ou9sEaOk/swLUSbLWJ1E1yciqUo9zYltr6dWlGQfMmQG9WB6diFUAS/xqCPYMekMx++SNwObImSGZToNu51kcNY+nl5tvHV1nsRJGFr7CsiWrBOn+WhweSYkPYf8xCetFJHQM/7WQmfllNP9ZKBCeYIapQQqpZ9vTs2LUU/QBOfm0J6AxSdfLb0vcejkstw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7898.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(2906002)(6506007)(6916009)(52536014)(38070700005)(8936002)(7696005)(122000001)(966005)(54906003)(8676002)(33656002)(316002)(38100700002)(76116006)(4326008)(66946007)(26005)(66476007)(83380400001)(55016002)(9686003)(508600001)(186003)(71200400001)(64756008)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ejcRTDV8uDYMKo0QGwXQq5w066oFK2okzzIJ8vHCi6KnZn8xrmBdJJqpQ2El?=
 =?us-ascii?Q?ixPKuwVuQzAbmVM7s2toJv23ich62MR8nSrY3fB+vRy5MUOk1L1y/cmLhe3W?=
 =?us-ascii?Q?H2BquHhX1bGR2iEck81DzZWeNIWelIGb386XhBng6v03WLZejFporSAvg97Y?=
 =?us-ascii?Q?Df+/iW1NlfuqRMIeeE8liP5mzehY1ZEE7bD89JD/qSKvmEU0UQgg38tFe2fw?=
 =?us-ascii?Q?1Q6nNYJbcjsqp6VNnrqL1fhVPzc8P3+8444AMTAu06Rvka9GvmnsSDTg0agR?=
 =?us-ascii?Q?psfHchgIbqh7/EYxGWdUF2VwSklH2FZGydsWVGx5xkYv0HlaNbqrGoJnZenH?=
 =?us-ascii?Q?lVmDBrZLxnfi2VhelzcShGuRdUUdVWYoCMf7ayiQvZ25K587l8q67YTy45j3?=
 =?us-ascii?Q?XpaCsJHF8IXhvCvKvRgsZ/opLK6eGAakyZSuT/a1zkqHfAfbrLYGbGcGwKU6?=
 =?us-ascii?Q?1Q5sjbnIaCSq1M3jYnaOUJkAwALU3nwgfLJup4hs+zYEgHdGuyn5gUgW7j7Y?=
 =?us-ascii?Q?oW3mHBgDTrKMxyo/OC2v3GEf0hEhpJbyN0G+FNLwbS7D8ftlhoIfyrNSLM3P?=
 =?us-ascii?Q?VZQkpzz16TR/fNWlBijiEDIjP5TgdngHiw6Gv1jEEpH+8ZdsgSAEGeY1ViFX?=
 =?us-ascii?Q?oxKxuyTgij/YeDGCNeY8wucD9rWMntI5kricW6+I/YBkeoAThgBrQdqmk74W?=
 =?us-ascii?Q?VWIuGRUCkxhFPs2YGCLTeja768qzaOOM01sboT1WeWWmIGqUZ/gP9eCFVngE?=
 =?us-ascii?Q?6FrM2VulPSGIsMh29jG6F8A9hbY9CMACjeVuPxPnVGAgOhIEJRyCKOttwte2?=
 =?us-ascii?Q?2VW/LhAexH0FUl1+G7drgGuhRb/lmefFQ9Tk3sciOo+/tbvzCZbGLCQ312JR?=
 =?us-ascii?Q?uhKfd5ljEk8e8HrzwhRqIP+wbf4EWF8lCQKCBl26tnuLXsTy1nTTTVv1rSyr?=
 =?us-ascii?Q?hOLYC+6zOtGLnCLMxjpFezQHQWWWRQ4djYC3LVr5iPY4WGAUYX2qr97bXz6R?=
 =?us-ascii?Q?VkfwIJfaLOIZxjey5Mf1g2f1wHHunvpdEryTbeKqQF31Yn0chtjLDUrhmeOE?=
 =?us-ascii?Q?qlNhrWE55SSJRMsbVFfZwKDXC+KKKPz66XdRbsjFAZ/6LguaXWYE9L12boQa?=
 =?us-ascii?Q?paJvZPa9a1MXE/pTPNeaM067b43JOEnmop2AkyVjnZagqxxCInwI88CQrCUf?=
 =?us-ascii?Q?2+qWeiDu6+pOBlddNwKtWhm9ipY93i00QYr15HTZcSFHPAUVMvCi0PgGljoP?=
 =?us-ascii?Q?AmxUxeOH9viWKK8EDfjlyNvFsX2DyLfti0dn4mpoDKTVLPy9qEV/n/HmtzPz?=
 =?us-ascii?Q?iVkPA/O2j4wLDyydstBeosYA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nordicsemi.no
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7898.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a97b812b-7a7d-4d0a-dadc-08d987220003
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 10:30:34.7600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28e5afa2-bf6f-419a-8cf6-b31c6e9e5e8d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +4tVPvjAYVYUWBU57JLB6dvXXKuuBopRULmkICsKg5udbmlclUJAEzhKOEyN0gsNIkO++0Sk8qDph3ZKw8KxS5FNU86VESgCQdojluSFry8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thanks for your response.

>=20
> * Carles Cufi:
>=20
> > I was looking through the structures for IPv{4,6} packet headers and
> > noticed that several of those that seem to be used to parse a packet
> > directly from the wire are not declared as packed. This surprised me
> > because, although I did find that provisions are made so that the
> > alignment of the structure, it is still technically possible for the
> > compiler to inject padding bytes inside those structures, since AFAIK
> > the C standard makes no guarantees about padding unless it's
> > instructed to pack the structure.
>=20
> The C standards do not make such guarantees, but the platform ABI
> standards describe struct layout and ensure that there is no padding.
> Linux relies on that not just for networking, but also for the userspace
> ABI, support for separately compiled kernel modules, and in other places.

That makes sense, but aren't ABI standards different for every architecture=
? For example, I checked the Arm AAPCS[1] and it states:

"The size of an aggregate shall be the smallest multiple of its alignment t=
hat is sufficient to hold all of its
members."

Which, unless I am reading this wrong, means that the compiler would indeed=
 insert padding if the size of the IP headers structs was not a multiple of=
 4. In this particular case, the struct sizes for the IP headers are 20 and=
 40 bytes respectively, so there will be no padding inserted. But I only ch=
ecked a single architecture's ABI (or Procedure Call Standard) documentatio=
n, is this true for all archs?=20

> Sometimes there are alignment concerns in the way these structs are used,
> but I believe the kernel generally controls placement of the data that is
> being worked on, so that does not matter, either.

I did see those when browsing the code, thanks for confirming this. It is r=
eally padding that I am concerned about, and not alignment.

> Therefore, I do not believe this is an actual problem.

Would the static assert still make sense in order to check this for all arc=
hitectures?

Thanks,

Carles

[1] https://github.com/ARM-software/abi-aa/blob/2bcab1e3b22d55170c563c3c794=
0134089176746/aapcs64/aapcs64.rst#aggregates

