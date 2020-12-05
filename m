Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D52CF86A
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgLEA4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:56:06 -0500
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:46337
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbgLEA4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:56:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sn5q5FLlWvr/NU2sMldhGyMpcUE3JsEuSMTjN95C/Bz8aGN5PhGYehLiWICwPAqJmDeJTUyOkg+6abCkJdpwqOmRBt0iqm3AaSu6GQ0kvwx93Ll0OY1euF2YMjqTFQUAJd68kCcN5vLhpvK2+/oLnR/9PvU/DXBy0DY0OKkDCyVDxHU4jYmvWi0B4UCmIMJ4tWF3sV/dIf1K25N8nR7zKdZ3vaamGxZruus1fXv4SC1AkNOSluEmFTx32tHKYTWnaYubH80Bw05gNA6IynWgfln66y0TLbOm7O0Wtk2LJD2gbv2tmeLN5u7cci7q890MKzD++eSU+hFytvF+xm2poA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIYe1U7hfVovA4d7gc7a6Tgb4Gw9DsVdV8kFjg2habw=;
 b=oBvvQXSQuZQXrWV2ifSbkpMQU8zWqlF+WW8W3BlAXmNJT/hmvD4MU5RSxvUyQz8gpyk2mGnxdtbfvIQFJ+lcXBlaC/1LVCDw1n3arQo0cS1htXq2Uj5Ky6LU96j8OKOTm/5IWybehHPZDjF3li3OeeZnK1QtI9MD/vdLG0SAgx5chieOD3zV4AA4QtWqBKn9SKmxbJq8uGUPLHQeztwdP0XNrDAZjRSqLDYCcEVD48T2N9oY4oDzpcBOK3yHmz5b/oXIwPitCup8UqlsriWivWTkjcofBhHi/TFZrKF7SVqCYome/FWoTD7K9QlL8x3NsaScerPqbzK/B+3PT7PigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIYe1U7hfVovA4d7gc7a6Tgb4Gw9DsVdV8kFjg2habw=;
 b=Za3sFZ481iLh4O4wZ54qDPZl/iDFR/AooGoLb4ZpOMKcKAjhynq/1UWSLFT8123gmBgPpXsErO+nlueq7RFx2AISAJNkLmkwPatCteZ76c0dY5A/ECIj5nchO5LFXesbkG5oT8L4IuV6Og9llKTOzS/JLW8b0lKTDoJH76wK9NA=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Sat, 5 Dec
 2020 00:55:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 00:55:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Thread-Topic: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Thread-Index: AQHWynu94+QiFXI1yEOwjWnhnoB/26nnfAuAgAAPUwCAACJSAA==
Date:   Sat, 5 Dec 2020 00:55:30 +0000
Message-ID: <20201205005530.lcngtpksxged2ewo@skbuf>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204145240.7c1a5a1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204145240.7c1a5a1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6634faf1-9104-464d-dea4-08d898b876fd
x-ms-traffictypediagnostic: VI1PR0402MB3407:
x-microsoft-antispam-prvs: <VI1PR0402MB3407ABAD00363548E5D3BAB6E0F00@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4JFZQ6eVsZ1N1AhH+oI6VZXMqnH7u0mKe0Pc9iq08D7nIsmKdyb1/iray1e5U/cGDaAbOc1xKunLEFQ/NjLGxqNLlgCngiP7rzZ2WADIgnI+Hhds+2Kgyh1kQe5qya2JvdgDuA1X8aUTqJny59mAiA/aDCMIHtpjDkqfiKtv5yFQPfmB3/oTEO8SXy4f3szbiKtpe5qbokwCIRIpu66+NOPdtti3XGQpZJkiM/jFy+0Akwfi24S/xL5ujXiNQtbXG/2G8pCCX2DhzlDClzEpdEO7SXesGk/msFVJ9lsODVhu5djObdiwJGa5Y+0WPyqe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(54906003)(66476007)(8936002)(66446008)(316002)(1076003)(4326008)(186003)(6512007)(478600001)(9686003)(71200400001)(6486002)(83380400001)(26005)(44832011)(6506007)(66556008)(6916009)(64756008)(86362001)(76116006)(2906002)(33716001)(8676002)(5660300002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mBKZVUexI8G5C+BFL5X8cxWJkqGXHV4Qvb4el8uk07Xyio+8S0IxMOSJjIb8?=
 =?us-ascii?Q?eb3fNHSJ99fZ3ZFG8M0M24RIWuF4F30OCObSBqVaZzQT0+fq86UU0gWgC+l9?=
 =?us-ascii?Q?1sWZPe4Vu9oHY1WXVVQzhZ7W5lxcnoKkPBjUYSseG/6esAVjGH/ddf+IVEip?=
 =?us-ascii?Q?8DelAcYShUsOMmqeFJdaoGC1HfSVm8spQPaSiH+NygITRzxRd4sv9eSPUHmW?=
 =?us-ascii?Q?Ax09NTuE35yltnaVBSxhghtZAZ+kA8D/XISH4ghssvo7aZhbX4LJdo2Gd+d4?=
 =?us-ascii?Q?EhxZ1CRCEWi6KAS87icwlrMgKTnDKKtQoUi6voE2dhg7xKhmNVDoS/22BczH?=
 =?us-ascii?Q?mmwxFk9hE8yJgJfPPVV5hq9ohcRknzsG4XA8bl/x4vKCpsyRhtZFiDYHomIR?=
 =?us-ascii?Q?aYbER7uoxkynTNJciPtgoXSugJKvl/vHjBGvZNDPCeylIlHbVuKDOxra+Ikb?=
 =?us-ascii?Q?t6I790zgOkzctwGXwiBpaL1ZfZJD7v2RkG4bMmgNfCfI0nXRPtsTCRHkGr9K?=
 =?us-ascii?Q?tPllLROf7ST4JSOvVqLOmMtQLcXzR2bigEi4auFl74cetUfpRq7mTAegWvw2?=
 =?us-ascii?Q?1M/EqGB0+6fWxHVv+y4WALftGjx3wS4dRuS/ZigcXfsoCFBnBdlwRcUoXPvT?=
 =?us-ascii?Q?hMIRfw+wMaUQA1nwW2JIPr8J+dX1gn1kmawSkm3h8weoN19M3g61iLX+zCRu?=
 =?us-ascii?Q?kv3/bRGDa+mm40fk1LqHsFVhMzjlFTkKZkqY6d7VBbYHjh/LyE+G/gnfUbhh?=
 =?us-ascii?Q?2RkIDDXHxOZef6nwIB3ghsFHv8nJKmxcfQXrEqfc/JoJ1BMDJ/ixK14MFjP3?=
 =?us-ascii?Q?jZT5iPvam9Ybomzoj6wGs5aZD35H1X2X8oB6rITL/oa7TC9od27Go4nM0i98?=
 =?us-ascii?Q?Mao2b9OqroYKDaHMkesEnZxKcAknZf4mDzCeoGHOjkbCkU1mhcT7cD6/Fjt8?=
 =?us-ascii?Q?Ff8YFpXA0ld+Wpd1RHTyv8hE2XV8SNsgRKw6u5PvFbODDCXoqLsMpvlSRlxl?=
 =?us-ascii?Q?l8+H?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7D0299677AC814A894634FAC1A6AF95@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6634faf1-9104-464d-dea4-08d898b876fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2020 00:55:30.9809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7cUbDA8UEZjeuiCxBl4lG92SPJqL7+gHR93Eok2IBU+97QrXHK8OKDygztOw+NrCTNlDGnFa0V1Z5cgfYceFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Dec 04, 2020 at 02:52:40PM -0800, Jakub Kicinski wrote:
> On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:
> > > Why not use the PTP classification helpers we already have?
> >
> > do you mean ptp_parse_header() or the ebpf prog ?
> > We use skb_flow_dissect() which should be simple enough.
>
> Not sure which exact one TBH, I just know we have helpers for this,
> so if we don't use them it'd be good to at least justify why.
>
> Maybe someone with more practical knowledge here can chime in with
> a recommendation for a helper to find PTP frames on TX?

ptp_classify_raw is optimized to identify PTP event messages (the only
ones that need to be timestamped as far as the protocol is concerned).
PTP general messages (Follow-Up, Delay_Resp, Announce etc) will return
PTP_CLASS_NONE from ptp_classify_raw.

But maybe there is an even better way, since this is on the TX path,
maybe the .ndo_select_queue operation can simply look at
	skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP
when deciding whether to send it to the "good" queue or not. This has
the advantage of being less expensive than any sort of frame classification=
.

Nonetheless, some tests would need to be run. In theory, practice and
theory are the same, whereas in practice they aren't.=
