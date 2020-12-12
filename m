Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF42D8A46
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408073AbgLLWTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:19:49 -0500
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:64421
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgLLWTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:19:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PleeuxkapCPyj/HH33Ti8AxjXG9FotKTb1XDJVgnwQNMBYeVth/hM0vLpPuFL0gKdjIfwWOp7S0zxSsbNIz0dxazAleBX03LXFe9TLm8hKxiAO78U6xfI7+fhZzH6ubeF3OazHHIPWUkYEu78KK0GNrqj8tSuu3LeNJxhuhJaFzgOi+tFi2d3xNGmKgu7TTiz0fcGzMzuhmhfxE3qT4nzZ+vAaKJBT6Zu7blYr2pxmxK0VmDeoKe/1iylXWO+ANfD9fPg2qTMwmg4mJ8Tu9gcADwSbn1JtHibKZio1G1flTtBQLQWhUXOEEY0UokM/twE6vxUoEwDOK88o6NjrkPbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk7deAqGe6+XNSpLauhjxgByV7P0pVQ+enhbD5mbZFM=;
 b=TxlZonHeqxrvDtVftLZdGsym+Adn+FddWDaULlnm5zuVQBeOMYG6jVBC70kTlYCQFRWZbjc2vjprydjrSyu0wEXebckqEaQ0vAJbJvMB6yB7CjAhqbrQpAK43RLl2BNNnpVhS/3uML4vQsDoA1hh54VJpLmD87hfeRVkEJI+JKwptb26JJrTH+SlCR3d/lFYH7xtgwqXmVRP9tMGrVMc8jpAeZqdTykdV7GYfw9N189Cme+mGExZLa2x0Z3G8oM5TeTJNCN8BWu1LIUD5u1R3hDjuS8iq4VSBWC40uxULyq9tNJyqKFKjWyZGgd/oLcq5TF0QrADyU2Ll3tshf3OMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk7deAqGe6+XNSpLauhjxgByV7P0pVQ+enhbD5mbZFM=;
 b=Mx+9yD1cTSwjGqCLY7WvUpaeDcxTlGTcNJrT0ykFLKJgBPyJDVoOAdP1kTY3ofNv7T/MYCmqhY0wM8SCPWpw0vbcw6IMoOTSe5Nhc+XxcBsj8cLyQY1MjWl4+ldSGoh7TRXwSs4YTPY/EWctb0KGIOP/odOw08a5JYya9FhK2hE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 12 Dec
 2020 22:18:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sat, 12 Dec 2020
 22:18:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Topic: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Index: AQHW0MbaD+Wb9ZfykEuALlETOMXISKn0BJWAgAADbwA=
Date:   Sat, 12 Dec 2020 22:18:59 +0000
Message-ID: <20201212221858.audzhrku3i3p2nqf@skbuf>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch>
In-Reply-To: <20201212220641.GA2781095@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5cad06f-581a-4188-c270-08d89eebec7d
x-ms-traffictypediagnostic: VI1PR04MB4688:
x-microsoft-antispam-prvs: <VI1PR04MB46884A92E2A4DA3156BA7EDAE0C90@VI1PR04MB4688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J/U+Q6xJ/FU6IJ4ZxCq6ocbR0JOc8e48zkMcgf2tS1LSeIPegemCm1Kb9Hiqe9N/B5PRw8EX32/wYQYjyk7HG5XDV2/jC5l1tnFbfBN+5gqDFlQGBZlaj9ZWlh2f2i9Eh+Nw2QWXwPMrCRjAcE4om8APP06bLDK/skM+ycl9OXuzukuhZxcOuKiaWCSZgl9Cskyytr6ymiBwt8XFDw+h6V1Tdy94PIsJbm5A7OSHM0P7nK9zvcqfaDzrqXrLnV+gAzZx3ByMdt011PYvngMlZfCVyHpeWcXswQtnLV+EqyQau5cb86uUDJhcBtLFIEPirV3KovBWztXYGQuVNjmuUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(39860400002)(396003)(346002)(136003)(66476007)(6506007)(83380400001)(4326008)(1076003)(8676002)(64756008)(6486002)(316002)(66446008)(71200400001)(66556008)(9686003)(6512007)(186003)(33716001)(76116006)(478600001)(86362001)(66946007)(8936002)(5660300002)(26005)(54906003)(44832011)(2906002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VMlBpiuF3ncYxFMxB7AeaxUWW3kv1VzMSb9r3RtBHwIc5BLE5wVNN05uub8P?=
 =?us-ascii?Q?aRFyQuTHxWlWe0DDbKsvnTOeteSovhb5dOY79el4f+L4nUqu6HLDkxsmN8jh?=
 =?us-ascii?Q?xwPTfVbfM7jc448qi+GCLOPX4JHwOsZ2U/GtgtIlBNQcXZ+nG0pq8vBfwt50?=
 =?us-ascii?Q?4SNB41Yxvjy2G4DMUbvMpOa//7WU2Ql+H/mUZsghOH+Dp9lXENDD7gL+hl+m?=
 =?us-ascii?Q?qgu5mnKj3NB7ZeF7tLAK0APnsMOxufrv6E/eCdJjOA6ggAij6it8UoH+p+j9?=
 =?us-ascii?Q?aQmhLY4FKZtpdWVh5qocX8ZhNNqsXoT2JcAo/lhTTvprO5O2IJCKrHJ4ejb4?=
 =?us-ascii?Q?wRSVHtdgLvUkn5zbbvhQn/votjKrWmcv73uDoWyutHNeETd0my9OFMKMciNn?=
 =?us-ascii?Q?9pFxqeEaVblt8S+yes1MdCCG8yaBcnFDzCs6BfciXJvtLmk9k1vi26w7cxrJ?=
 =?us-ascii?Q?PXc/QQBYrtfP5MKt2+VKGmzDSiAsy0lGYLNtKgHvsLM6sR1ubzM6XY5+S4AW?=
 =?us-ascii?Q?X5Q3vU+wrL0YKkrZveKyB29i7EcF6+Zcltxb7ywbXiuCS9RTLG6fU++Okb1N?=
 =?us-ascii?Q?xiv5P+SXmeyf3uv6A8LHcT333qytPbdqsWQwYxpwQ03S1zARm4AaZk1SjWM6?=
 =?us-ascii?Q?t8uehntnN/wqdT2IW+ZtQhgdOKluHP3RhynUYg6Lr2bazzHTa5sUKJBa8ngq?=
 =?us-ascii?Q?bgKB3kiSmfwU5XUCzTWyMkiAw/hb0DGgrFFjkkm0EO+BF7cgKY6HZByHZhbh?=
 =?us-ascii?Q?D42IVRhyUEZWdMA9QcubPTFnwEyxwxcC+TmvLh6CQsGYoTE/8ZhwR5mGDgMC?=
 =?us-ascii?Q?Vj7LTZwv0N7kDQauLc1imZA7sJHEIk6038MQm/mTSPPqZ1/L7fLt375MXBzz?=
 =?us-ascii?Q?e28qPpLJHWtOPUO/y9M7/swUK3dnIsdEu/JuLTk8TX0m0H7MisMwo6qDozva?=
 =?us-ascii?Q?hZUw9zK5IVsyDnmWqgTfHSjexlo9hlpx0wn01txw2Lq4KqDkMMmq9pNqUyA6?=
 =?us-ascii?Q?4bCq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D10E164E5DC7F9408D19E5694859C9D8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cad06f-581a-4188-c270-08d89eebec7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 22:18:59.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uIYsM+5PG+3HPgipAdCvHhPsV4NUL/WBQYrQpkLdx6sbNksI3k8uPwPmEI57hY9ZWM4lqbofSkZFjxhFTejvDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:06:41PM +0100, Andrew Lunn wrote:
> > +	/* Complication created by the fact that addition has two phases, but
> > +	 * deletion only has one phase, and we need reference counting.
> > +	 * The strategy is to do the memory allocation in the prepare phase,
> > +	 * but initialize the refcount in the commit phase.
> > +	 *
> > +	 * Have mdb	| mdb has refcount > 0	| Commit phase	| Resolution
> > +	 * -------------+-----------------------+---------------+------------=
---
> > +	 * no		| -			| no		| Alloc & proceed
>
> This does not look right.
>
> The point of the prepare phase is to allow all the different layers
> involved to allocate whatever they need and to validate they can do
> the requested action. Any layer can say, No, stop, i cannot do
> this. The commit phase will then not happen. But that also means the
> prepare phase should not do any state changes. So you should not be
> proceeding here, just allocating.

Are you commenting based on the code, or just based on the comment?
If just based on the comment, then yeah, sorry. I was limited to 80
characters, and I couldn't specify "proceed to what". It's just "proceed
to call the prepare phase of the driver". Which is... normal and
expected, and does not contradict what you said above.

> And you need some way to cleanup the allocated memory when the commit
> never happens because some other layer has said No!

So this would be a fatal problem with the switchdev transactional model
if I am not misunderstanding it. On one hand there's this nice, bubbly
idea that you should preallocate memory in the prepare phase, so that
there's one reason less to fail at commit time. But on the other hand,
if "the commit phase might never happen" is even a remove possibility,
all of that goes to trash - how are you even supposed to free the
preallocated memory.

Sorry, I don't think that there's any possibility for the commit phase
to not happen as long as everybody is in agreement that the preparation
phase went ok. If you look at the code, I even allocated the memory at
preparation time _before_ calling into the driver, to ensure that we're
not giving the driver the false impression that it gave switchdev the
green light but the commit never came. If our allocation in the DSA core
fails during the prepare phase, the prepare phase of the driver is not
even called.

That being said, please let me know if you spot bugs in the actual code.
I tested it and it appeared to work ok (I also put debugging prints to
make sure that the refcounting works ok and the entries are removed
after all of them expire).=
