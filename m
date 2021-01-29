Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05CA309089
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhA2XVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:21:19 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:65282
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231156AbhA2XVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 18:21:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDLlpALswt6FLRcSeWOuJgXcX3PVgP9Ygy+dAyyX5vXePfWrpdFo1H2+hTv/uAhUZ/EN3jtFa6pZ9x9TzffLk0JDJwywfqRcWHP725ZZa48ZUm9TaNaBtL+xAl4MHAk5FUTn+q5IvTP30Uw3d/l7Sv4xRdYbTcAqOaMhQMgx+I33Hn+LUeZVgpcOqILnPXbfFCtDP1SVISVZ+svi1/JWdkSMOb/KUtdRphOpDUZrxn9+ZiiVx02UPshyM7PGbzDxhb53BOduNNz1Lm4R1n4p/qGweSVIsyEnJrDMCfiRc3R6m+93c+e7/vjG+t03rH/C9GVWH4NTTy8bTznT4IppBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRcrUBBHzRc1kNS8jQXlM0/9Bm1/BimeMcsGae34/Lk=;
 b=Cw7n5SBRadyWroH4XKwqJuhp+aNjrPuXrUMy6Nefy9UwZLGbHYhHgFqa3nVcr+UXRgOoioTDP37f1HLe921JtHqXpCer5jnuh/2QKLf0+svOnOYQ2vNWHsGePGfvRSlzQUL/05r8Q/V5MMIQhXiubblu+225gLvNeOSIIYavWGnmTWOgO5YERu1T17mvnFu0nI1v59BAZOV2+VgoA3Pt6BTv0cgu7d5RWZDQ18J+qfC8NKqk6PZF57j99SWQ/mG3aKAMjq0MN+Z8z+BG9lotPBws3dZY+P8VhhSSKWhPq3fkVe7b4wEfMVO/nQtVVvqra+i1KG8W5aRIhEWlwVdaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRcrUBBHzRc1kNS8jQXlM0/9Bm1/BimeMcsGae34/Lk=;
 b=IImMM2Dw5eXtWGmYBaLzJg8UxoU7GcLNZcNWI+d5dCdHBhz/Wh0W0J1bkaTkD2XPqc56wg0TNIm5oKAGiIF671u7322ZHHfh0mESk3RxthlmCR9E3qznqrkBq5U/XGAWCAi/NqrY+NEx6SY4tb5xEwVXhhIE+Lwf4KhGlQVnWsU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5293.eurprd04.prod.outlook.com (2603:10a6:803:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 29 Jan
 2021 23:20:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 23:20:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame preemption
 offload
Thread-Topic: [PATCH net-next v3 2/8] taprio: Add support for frame preemption
 offload
Thread-Index: AQHW8RBJQDX+89PKk0KRFCgmtnZ2gKo5DOAAgAYYJwCAACNxgA==
Date:   Fri, 29 Jan 2021 23:20:16 +0000
Message-ID: <20210129232015.atl4336zqy4ev3bi@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-3-vinicius.gomes@intel.com>
 <20210126000924.jjkjruzmh5lgrkry@skbuf>
 <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
In-Reply-To: <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad71839c-1885-4ef1-5858-08d8c4ac6fd7
x-ms-traffictypediagnostic: VI1PR04MB5293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5293AF44F73376EAC74475D5E0B99@VI1PR04MB5293.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ahqas22u2emcXYABSC4TSGyvHQ8B2gW1+jWKZfQFqlwVtMT6VrsC1f176gJiakxR1w4Fdj37OeNT4F0fxzQKpF1UvDD5wiFbfppd4FA0c8VpYxh3QBW1FSvva7LoDzhq0NkG9cEK/fsNaGi+/OAf0rYOXVOmvVCnJHX0XQxwea1QBWowM7v9/2JvEYd9exs0lFaie+1NfxmSbS/ulaXBGMKeynOV8MpICRkEBXa7Tk1OIow/2usu+J4A7Z93BM2/sjhsm+spHPYhLK2QGE+hGjeYq/bDMQ7J0Q9vhNOZq6iYj0dYk2H3B1EwPenIDC4J4uYkcOV6Nx4ExssaKDm0wf02DRXYRL5xpc697nxvX85eDWWzzh2GOqVpNLgqtR1iJhX/ya3cj/Qa7lH2Pz0Yw6KlHblZFRMoX29Mdy6/Gq5RktlQQjc39GIQT7AY8lMPiWX4C+gXHmMS4SuupmHTs0m1sXbDncbg2FsFzmUoXZzWFWacbLyXFyV6S03s4Ioe/lBVaGOg1tuHzgA/D1e0nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(39850400004)(376002)(136003)(346002)(396003)(66556008)(6916009)(76116006)(1076003)(7416002)(9686003)(66946007)(478600001)(66476007)(26005)(4326008)(6512007)(71200400001)(83380400001)(64756008)(66446008)(4744005)(6486002)(2906002)(186003)(8676002)(54906003)(316002)(6506007)(44832011)(86362001)(5660300002)(33716001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lbxY0qY+fTP1V5bzSHVQWvzdTk8BCWP3H0LEQRfo4VZxlP5+UL3+pcbLUDvC?=
 =?us-ascii?Q?NhUoytHY2uyvjee6MffUEJaGUBO66QHEYYOLwArn4Dmfdfpj5/BcZQWQ5k5k?=
 =?us-ascii?Q?N3X5ACvio1yWtyfVHQJS+9ESNBtRGOXCcdoxKM2D2y3yEQoVPqCgcbrZLjxx?=
 =?us-ascii?Q?ioriG/eBaMlHmCEICvJfbyYgwXGPWejvB5TQpYHSsjZcnXQLkvDD+j88WPIh?=
 =?us-ascii?Q?RwiKwzeo5MPqdm8qF/YcnB8J2vGLc/6k7oNDjWyc9OGr9jpmWLmUu/cqeyO6?=
 =?us-ascii?Q?j5cm+ly660Nr5p28AULwTQAaUCiEo5uEBM6C7uJAQPGDgmZFiBYWoy6Mv96b?=
 =?us-ascii?Q?uIlTE0b1YYFFjOQdouAErUa2rccz2Y+x8WVXFvRdd57sJYOA9Edc5vfyqw94?=
 =?us-ascii?Q?l+XrKLa44jf8YIXcE1cq766OktY0ew6FrplsUHfJZW4kMXsfF3y91A37gCiQ?=
 =?us-ascii?Q?eXPFhfUFG1HY2K9HLWQQkIvJGhmzpHUvvZ0A2cFjW7zHAOYAryT/agI/ycTW?=
 =?us-ascii?Q?drapZC7SoMhAfG74P55ByYS7kIMqorBFxML43mxDSt0e2MdjM80/+yCZj2jO?=
 =?us-ascii?Q?TVLCJZ9Y8Po5sj26/wrXRN1aCq94rREfCtYVPp43/ZwfWziSrcuxHojJmnL9?=
 =?us-ascii?Q?RGPTLgvMuPqFU6tVQorYoE9/G2kik2aEWKWbQGTvPkkAxpraAMSXKjcjsi6K?=
 =?us-ascii?Q?YX5XibenHJWZXU5N3M0E1bTnTsvaXN2iujdDU0I3u6YQ+S6nBLMDkfoz43DO?=
 =?us-ascii?Q?tAw+qUizIrutnYAWSxTtEBpTOSQzi25x4UTZ756Vg7+huJVPbFvrvgGFAL+N?=
 =?us-ascii?Q?AW8lvu4k1DPRxYpEP+A2xEgt6PHnK25XyDqFHLbdO3Gjgt0JG1xoeg8pQIPI?=
 =?us-ascii?Q?pI+5H/PHh1GDC3Qa7B8aFEVveoYOgXOMcaJklXnoCTSJ5fi6i9tqm2hM5mIZ?=
 =?us-ascii?Q?XIztPxfYPtNsqomBm24Izwch7xu4XiwwbG68rHMVPDwaJSnJzaAC37FDl93Y?=
 =?us-ascii?Q?EFqVeMaPZebxzo8CswhMICaPUC5uBKwD0uTgSjPZEUObv/TXtksqkPcJayTN?=
 =?us-ascii?Q?eYD9Argw?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B7D906427B60A43900B2FCAF0E6725B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad71839c-1885-4ef1-5858-08d8c4ac6fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 23:20:16.1448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMFJe7lechnR1wDstpT0vw5r8Ko/0UJLSQy7p0oh4BMB58RmTWBcrr8Lj2g312Ti+ahyC1uYPm1JvLgu/p/ZTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 01:13:24PM -0800, Vinicius Costa Gomes wrote:
> > Secondly, why should at least one queue be preemptible? What's wrong
> > with frame preemption being triggered by a tc-taprio window smaller tha=
n
> > the packet size? This can happen regardless of traffic class.
>
> It's the opposite, at least one queue needs to be marked
> express/non-preemptible.

I meant to ask why should at least one queue be express. The second part
of the question remains valid.

> But as I said above, perhaps this should be handled in a per-driver
> way. I will remove this from taprio.
>
> I think removing this check/limitation from taprio should solve the
> second part of your question, right?

Nope. Can you point me to either 802.1Q or 802.3 saying that at least
one priority should go to the express MAC?=
