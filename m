Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C379A2D1EF0
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgLHA2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:28:24 -0500
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:11685
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728627AbgLHA2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:28:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oxh9wm5No78c7RuZUVwd7hhYN7Fn2Wa4ihhqlgJPC+ra1HNKoPTGsFdS+2tiNmGsYgSvOr5MVZnzJyuFqjiN7AIFIfnj3vojLSvZY/qnCEBBALmyBuDsSLceMc6bjgqjjsHuaAOFS42BwTaQIy2Lm4PD/SpER+DAbiLh327rN2Zo0Xmbbi0HrszAJbZ2kUlclFAXqX0NxB8Lxsv5K8exgYyLUQYisLwY9xen0W8tt1s7xFDm+1AFp/x3bZG2WAOoTl0G9JiINbPn+Gb5G1eoPYnm0rwJOmh1HSRi4cScJUfc67tqUHI7z0nn3VDM65IAHBuWqYad4BJagwvdCdwRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpWmwUTB/lH6QSBElsG2s1nS+88E6msN+SikdfIcZhA=;
 b=KAKBZwVmIegDWdPG+6RBfLPp0Qgy+FAMhurmm0dWlxIEOrZ2VwUROqVwbp04SRulcnPoUssDGMuqOA+SGHaCwjISX88bSqWtTlSpkqJW5sf0D1OLD3OuC4ZcikVtyJnEUCsrPIZvaro8WpECR1a2ok1BikRQ36N5AmRo4cEAwW0u/Tadc8Z1xcKpnJO9IZxi2/25OMHM4VHwo9pJkdnpP+V/d0Gbucx1zKNVYRrlsxBLjQ1jxifgbE8ukOwbBdvHR500WPXNMoReGDSdcoVlkSVxHQqbjC5YWXAn7qoL9feAxtCszMnqiYEiLHW2mqdP3lQ3tscIY/CqLEoAPyOFBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpWmwUTB/lH6QSBElsG2s1nS+88E6msN+SikdfIcZhA=;
 b=kUG/H7q4t9v8CfZkJbL5pQ+Zt8l3SDGjDOQcyoqWg9Q1fpt8a+yS/z/LBmwJ7W1n/PxQorUXTnq7wbujMaMZe66SEaozjCuf3NwkfVV4TsllV5gxYeRSzRPoEB1qMfB0ydTxyp/1k5XGX74uVVZy4z+UZgttICXfhNjEh+sYnMI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5341.eurprd04.prod.outlook.com (2603:10a6:803:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 00:27:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 00:27:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Thread-Topic: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Thread-Index: AQHWyGckctV2w2nTZkq+ydRFCzPhBanoy3WAgANvpgCAABN0AIAAEX4AgAAA+AA=
Date:   Tue, 8 Dec 2020 00:27:31 +0000
Message-ID: <20201208002730.kftox7xvr7d475rp@skbuf>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201202045325.3254757-2-vinicius.gomes@intel.com>
 <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87eek11d23.fsf@intel.com>
 <20201207152126.6f3d1808@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87blf5ywkd.fsf@intel.com>
In-Reply-To: <87blf5ywkd.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04f9688b-d38e-4a1d-8e88-08d89b100d49
x-ms-traffictypediagnostic: VI1PR04MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB534141E7F3D6F7143DEBA608E0CD0@VI1PR04MB5341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AYB5u3X9LmJUhDxYAR1iRBkFYhY5Px5r5eP5gvB6jefgarTJ6u+w5N4f1NOFROZ93NPCdr38jnhGRIBjfyWa6lE0uVjCm5kF96skr6UmKYlfOI/RGuMbjpe1w2L7tBmSK0Nhuf/5NLGNIvo8tn00I1tqOcByUhQQ+ohG7I1++WxvQGlaJ2kGG/4rXBxOYdpLYs7PmUL2ku1DvQ5cdRBOc51KQdU5AiDlWtzNdnM6FuhYy4U0XcM3HsU4HFpNERZX6XUhPBHckrRGy5Q+bgRu1NnRQT9m+oj8ZIHec05UEV2n3Vslfgvn4/Ev36k5C9j4IN7zO2TLy2KrvbruTucq+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(376002)(366004)(8676002)(5660300002)(71200400001)(186003)(66556008)(6486002)(7416002)(64756008)(76116006)(91956017)(4326008)(66476007)(8936002)(66946007)(6512007)(6916009)(9686003)(44832011)(2906002)(83380400001)(508600001)(33716001)(1076003)(86362001)(54906003)(66446008)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?P+K+HAyoWzP+cxqiOTN7leVzZ6P+6tHj6mIIhGdEoa9wAveePtgeexlCBFGP?=
 =?us-ascii?Q?Z+GNISbyiUGtYZrPBq+ctaTjjOpIqs0Z87Ts+v9RHil44Shg8ZxFRykJ7SIi?=
 =?us-ascii?Q?zwLloemnBFyCmcb8oNlubMts6psGuziLoX0rJh817zyjoe0xv4GI8STy0JjE?=
 =?us-ascii?Q?pRx0Uz8b3lXRCua/dXrrQM1CYJxRJV5XyZGuXZW0/BDBwqcae2BSgGj4wX9F?=
 =?us-ascii?Q?BtI6UEntv82q/T6G+VwddAOsc1/MToMPWT30Me5xQj1Ld9/AZ8eE/eroTdpp?=
 =?us-ascii?Q?oDgGJTBFto+TsCwGQYnVTPgpBIRPGS55QiB1bs6Zg+J52JjOPDvMVqk/B1dZ?=
 =?us-ascii?Q?9Mcb7p9ocd6jUwjk/+iYqRWLC22JzWW89Bfh5+MFjmXpPuWVYW8LVGw5nt/h?=
 =?us-ascii?Q?h4INbWP+oeG80YrtProfuTobERMw6HLyw1y0Zz024a+x8uii+qZTY1vBuVEu?=
 =?us-ascii?Q?HUsxIjj3Ut3DGq6XamEc03kj9jIsM0lkQDuNecI8ixnRv7Xr/Zx45KqLkSKB?=
 =?us-ascii?Q?nuwW4DeektsdkE8feesv1s8zTE7ACTcmmBU/kGJfcZlb1h6hOfpWCWvMLV4W?=
 =?us-ascii?Q?KovjFlf40NK3Uq2uReshGgtvGePQPC0iHgclNL8SRn2BwSdFtEbcdwxZ/uKU?=
 =?us-ascii?Q?2scIfi+yMnit3GeLXt2obaCLoQSrLyHbjzudEDjDxZU74slDLvTFqgsbXYSm?=
 =?us-ascii?Q?TlIl4vCYfaZ5AY39u4iIR5gPWx5+e6fjYJSSvmuibjG+Ny2UFeBLXdjKtVW3?=
 =?us-ascii?Q?uyoPy9fBDciA9PON+bMyPjVO0eI6m5ebFr8+Ro+wIQnOcGL0lXF26TD93x4Q?=
 =?us-ascii?Q?YUxRWCBda+Q9i6tksTULz5nfCuDSu8zHCNMOQbMpMpyCl7ccaEPb7dNsGVDK?=
 =?us-ascii?Q?2bQwZSEni/6wtghpMZGsCjJPzK/pWSbyMzbTRFJWU1KBvH2JWhiqZWu35H1d?=
 =?us-ascii?Q?SN3LIYic80a8ctgeXTUDytJZjGr+yArRC5D1nE82OVUYz9qT+SWxidXPlT/u?=
 =?us-ascii?Q?OWU/?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB831BD3F14BC24EB15ADF2AD7F7C0AE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f9688b-d38e-4a1d-8e88-08d89b100d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 00:27:31.6142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4i5Q3g0uz3XcYTRZZtQaOPn6nywfLRBIwImLcq7oRz8OPes1QCkObOyajtlUidxKtG1UJLoNtw9kzGgKzykHxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 04:24:02PM -0800, Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Mon, 07 Dec 2020 14:11:48 -0800 Vinicius Costa Gomes wrote:
> >> Jakub Kicinski <kuba@kernel.org> writes:
> >> >> + * @min_frag_size_mult: Minimum size for all non-final fragment si=
ze,
> >> >> + * expressed in terms of X in '(1 + X)*64 + 4'
> >> >
> >> > Is this way of expressing the min frag size from the standard?
> >> >
> >>
> >> The standard has this: "A 2-bit integer value indicating, in units of =
64
> >> octets, the minimum number of octets over 64 octets required in
> >> non-final fragments by the receiver" from IEEE 802.3br-2016, Table
> >> 79-7a.
> >
> > Thanks! Let's drop the _mult suffix and add a mention of this
> > controlling the addFragSize variable from the standard. Perhaps
> > it should in fact be called add_frag_size (with an explanation
> > that the "additional" means "above the 64B" which are required in
> > Ethernet, and which are accounted for by the "1" in the 1 + X
> > formula)?
>
> Sounds good :-) Will add a comment with the standard reference and
> change the name to 'add_frag_size'.

I think you should be making references to the IEEE 802.3-2018, that
will age better, and a lot more people have that handy.
I believe the go-to definition for the additional fragment size can be
found in clause 30.12.2.1.37 aLldpXdot3LocAddFragSize.=
