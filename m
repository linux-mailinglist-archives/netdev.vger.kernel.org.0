Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D691485916
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiAETXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:23:03 -0500
Received: from mail-eopbgr00068.outbound.protection.outlook.com ([40.107.0.68]:61623
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243475AbiAETXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 14:23:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8cbFOvsCUMHjZUCRKAd0/UNGtV7bAyUK8KHSJJco466QF/63k25VlNT59tbf8zS90A2OHFs92NIlF+R7IozFiqclCddY30rBqV9NSUIwyhcWw0xJBCW15k/Ay9cO+cbSHaWK0hR/2+IGR9YtZStstYpNITqT/4u2M2iMYWA5+tL0C4OWmK0ixdd2ZDFZzdRDT+6qfz/Tvfr301yh8iDrlIhxTRK43HeEEKRvmu72KXxuGrbMVcZxI2cqMEa6/iSWTpvGvFEnVZag8ldgjT68pVoy14sbx3n5GsiYGp/qx3AAYBAKUMVoI7vJj5xgx/dwuUsh39gx2pPD2X2LRQRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+0MDg4cEa1/MyXTfHusR/49e6I4j1neb6rvvponpOg=;
 b=RrfPKYlMWcKKDJLMgu+5hkd15h386Sc5lkhQE2isGtJzYMCH3lnRL7H8SgP+rhikG+/n8Jp3Zpq/iWY1D17UglRPHkQAF3z+v4LuoVl2cRBIcTWbpRDvRouluzrzNAR+UCP9Eb+pXPRms+f3G8PPc0hIW/DF+hMcytMKXF79kHRjo+wZFxhcwGhqQmwzYHeyact/PXOvPaPcWafTUjOJonRUQuU6klmjBd+5qZwwluVdsOS6WvAmbBqv4nWgQDDXW96jQ5kv1vn5ADso4CSzGBb7IMusEccUCGAIQThtDgf6XJnZjGpqvYaYBhauZFr1sovTl/PcIijZF4xTBFmqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+0MDg4cEa1/MyXTfHusR/49e6I4j1neb6rvvponpOg=;
 b=Jci8kDFmsxSB/W8u4Koy0DORl7z8g8HW652NmrCbZlegyxlKDbJRBB+J05KoGoYblnJaRlPVJsxWr9dc9RoWGoHfgjTuA9oH8NSYvwVp+rawbQh7A6zvj5AJOmxkS5xOjBSVqhC+haic/USNhXB8Mzpy2nyCfKmefKm31qaXtvk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3071.eurprd04.prod.outlook.com (2603:10a6:802:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 19:22:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 19:22:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Topic: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Index: AQHYAjcz7PA8h1MVMEuDn2+fyJJZ2qxUwpgAgAAFk4CAAAGBAIAABS+A
Date:   Wed, 5 Jan 2022 19:22:58 +0000
Message-ID: <20220105192257.cjnha6eyzcqp34bw@skbuf>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <f6d50994-6022-be0f-4df2-1dc3c8199c09@gmail.com>
 <20220105185901.hprorcjw6api4bwc@skbuf>
 <cadbfac7-0f20-baaf-d559-d9fe62f08856@gmail.com>
In-Reply-To: <cadbfac7-0f20-baaf-d559-d9fe62f08856@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50f1f650-2245-4bda-86bb-08d9d080c83e
x-ms-traffictypediagnostic: VI1PR04MB3071:EE_
x-microsoft-antispam-prvs: <VI1PR04MB3071FBA3250F9805C90EAE11E04B9@VI1PR04MB3071.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gBdpzxy9aTtoH3nzWE3ViRVGdDC2hULigJaBBGP9qiaBybiMDV0w8hJLrUkIOFO5ayhobpaXVEBfkphTQriDP8ojGJ0/zv2fFKLhetAFx9xDj3TkzDbZtrTHlmtKCxzbxuLNR42V2hsuyqlgm2YIHHcbB8whKparuv9tzyIzxRBgVZ/cTfry3l8v34njIJ0XmryUXA9GlOa66FQG6vJi8cCGjhQSDZSLCPMABbQCqaJnEvFnGOZg9DonhdwV2w3NzaZVCvtp14DreLn/ocwBXcwLqqnw1bEo7ZipifGsuvU4XWCT1phikD2mJKv68wBMTEMua5DC1Zd6yV0xGEOkXlwSjCUwia6hJ0tOwvVCD4x5/+kStN/21mtUtvC3sSd9ZQG76z4nSUa0E4fzhl5SgeW7cHyHw+2AOxcWfE7NOc8nFCpcaZMyxv3vJopm/hHlZ1y/Gz4hu5byKUTIxOOceBpOyBVrZDeEdePowtxTw+9F4fFudnU9auQc4yHiPseJVUnn7hVdJEr6DTnDSE838g8qWtuHR24JJLdYgOHpSHWz0pHYzW9HJK8xSiSRu2R64WQ0ZuzOzU6f0JOjTjDpX5oTce7Xvk06nKTCJVDZOQJLYTqnatiufaa9qglCJjLH2XZ4pa5tI1fiyZFfLoGlCKmeFmkbXcIEgI0c/bzoEM/WTtsilbo6gkk9e41p6gLOhM8vhO13tvJQcMIam5qGCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(83380400001)(122000001)(38100700002)(5660300002)(8676002)(86362001)(8936002)(38070700005)(71200400001)(9686003)(4326008)(53546011)(76116006)(6506007)(1076003)(54906003)(186003)(508600001)(6916009)(26005)(33716001)(66476007)(66446008)(64756008)(6512007)(66946007)(316002)(66556008)(44832011)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tG1EhqGfDSbrm1Q9rKRmJ0mK2ow+m4rOJZ/tW11xMsTyTlguZvcKFgeZNXG/?=
 =?us-ascii?Q?zZbQNZSAQXzjDswxyBMOBNptj6/NGooQCsktAIKiLKBEXUDUjHQruFfasjT7?=
 =?us-ascii?Q?V0tFwPigbLWxOv46PydIUpU7J4pXzOuoM4T6595T/0PXrs+4TLJ31HE8vltt?=
 =?us-ascii?Q?7m5FA+1dTX1cmvv3nlrPYIKI0KPWmWZ67mj3L/nKmelZ5SGvuELCLtNiUK32?=
 =?us-ascii?Q?G35ZnzrLDP9r6Nfk8HjMmFx+tAZfQbEG7bNllRHnZnkeo5HwWLv8fGOXhRCq?=
 =?us-ascii?Q?K3gMiUdXYUChFpml5zn9V1jJoNnkXcomz15mXn1JodUiAn5wCKg129x588SG?=
 =?us-ascii?Q?gwMRXlBhmdufCzEPWsPmajuboCRitfOOIQiKiZQBHbRruvoWKw/fa4hKty0k?=
 =?us-ascii?Q?CCz9GKKLV3yxKC1/l7OzRnAbh7oFz5BKyl6p58rmDn4LhWCVe9u3bRIDjqMz?=
 =?us-ascii?Q?Vpfkn3QYdQXYwwjoLNPApBhVpmp6hngjfKF0W16GhMFdMcl5h1cJSouj3yLT?=
 =?us-ascii?Q?KbWZNfO2k/fh6zZbkJ9qS2fMKVOzq1suyCYO0O5J6RZyjC+VMW78Dvtnk/l8?=
 =?us-ascii?Q?BWjER0z27RuIEIMWEV6rd76n5m9l+1nzETsnXgXwdY/FuvN128hwTH4gEq0i?=
 =?us-ascii?Q?sAcvwdciw/rQp9EAzhyShsc+EWDoa61yG3/nJMh9oJ9/RQVyqmK6drSj9U+7?=
 =?us-ascii?Q?VNVCytQm6nseiKg1Zvm+lomF2i3cjk/5e2rGsc4Lf5ntvfWnWESGrYdoD3Cz?=
 =?us-ascii?Q?vAh0UNlpg/rDdjcGHvXc5mXu0VOTazreiLB4K1icdHo8yzGQHiUjZQ+20Y8T?=
 =?us-ascii?Q?r6pj7PEzqU+WoHB9Eq/EJftuyH2Bt7QPadDiqErUb6YDDwshQLZgg8wBPpRB?=
 =?us-ascii?Q?gUtoncQThDepPS2qe7Xe30rjfenaV6lVakMt3r87Bta9zUqc/Z68VSghvUqK?=
 =?us-ascii?Q?0Jr3wFa6NGRFkvM109V5tAWgKVu6nwtXKACP7R8rOy8lYLJ5O24LMwoJABJ7?=
 =?us-ascii?Q?d94fru4waNFBD6SXmc0oAm9UZLCnGid+xi0a9Fc28MEyBwFJR9mSNx6uUI0B?=
 =?us-ascii?Q?+9x35Cje8/L9Kwp/PK2AdBepuLXFiPcx4kdk0aBLz0HRmYFh047uo/pSZWBD?=
 =?us-ascii?Q?8BmspYN77fUmQPPsiaIUOtzOZRvs6mTYTkzfozzlbaLovp6knPfeBTITS0jT?=
 =?us-ascii?Q?jEwgs7adAiCLaph+6PNO8/95r4Lnq1dTPCykQ/JJHHdwf8yJTN8Ktii6yysg?=
 =?us-ascii?Q?K+cd4AHZjA5N9wv06Las6KAiq6p5sPCfl2QRAN9ZIiuCI9tXtUWV2piBd9kR?=
 =?us-ascii?Q?88xNGycMP9r27DF9gODclznZnfzntQ4TdKeKTocsLIB8LERv2aMSxCBDPVeK?=
 =?us-ascii?Q?FIyxJlWGjG8T9ajyfILPsXFd8jswhwbBkNNn2xu6N4IJC6WzemfvnqkA/nd7?=
 =?us-ascii?Q?u9hfwPjAgRPtjr7C4FXpundaxF4xLizmUZiPTD6QnwxnCB+nADwovi02ZefZ?=
 =?us-ascii?Q?PR1uA0QyhMG/q8X/EmC342m5+3kedwhszi3UmJwqdurgegOojnuqT+VNYaBb?=
 =?us-ascii?Q?b0lLJmEjcJwOJg8WJVUiRlYrKVWH9IxNZsfEIXPY4KXVVzeIPUbF9jgotc1N?=
 =?us-ascii?Q?KiwN5qPdw99/ZiOjEyIVt2A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7A77226D5666B4985980BEA6F1BC126@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f1f650-2245-4bda-86bb-08d9d080c83e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 19:22:58.2474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NlPJ8QhkNa1c6UY/uoF544uOzfrBPWP9CTB1k2uYa+FsjIuVSTwuZMQDmYWHYkui4TcTNObGzyXQd2KEQOyfsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:04:24AM -0800, Florian Fainelli wrote:
> On 1/5/22 10:59 AM, Vladimir Oltean wrote:
> > On Wed, Jan 05, 2022 at 10:39:04AM -0800, Florian Fainelli wrote:
> >> On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> >>> This series contains changes that do the following:
> >>>
> >>> - struct dsa_port reduced from 576 to 544 bytes, and first cache line=
 a
> >>>   bit better organized
> >>> - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
> >>>   better organized
> >>> - struct dsa_switch_tree from 112 to 104 bytes, and first cache line =
a
> >>>   bit better organized
> >>>
> >>> No changes compared to v1, just split into a separate patch set.
> >>
> >> This is all looking good to me. I suppose we could possibly swap the
> >> 'nh' and 'tag_ops' member since dst->tag_ops is used in
> >> dsa_tag_generic_flow_dissect() which is a fast path, what do you think=
?
> >=20
> > pahole is telling me that dst->tag_ops is in the first cache line on
> > both arm64 and arm32. Are you saying that it's better for it to take
> > dst->nh's place?
>=20
> Sorry it stuck in my head somehow based upon patch 7's pahole output
> that tag_ops was still in the second cache line when the after clearly
> shows that it moved to the first cache line. No need to add additional
> changes then, thanks!

Yes, that output is a bit verbose and small details are easy to miss
(adding --expand_types makes it even worse). Happened to me quite a few
times during the session...

I'll prepare a v3 once we figure out what would suffice in terms of
warning other developers about the lack of bit field atomicity.=
