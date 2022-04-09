Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA204FAAD9
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbiDIUsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiDIUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 16:48:11 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFA860F0
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 13:46:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2P8sLkHE0YOH43XPDu+/4rKONRLE+YUj4pAXIFh/0TSUFg1RwFIv6Dd+sbZJqEZN3wvvy59qPKEy1xKspmnulkUqYRFPZcM1bXM98+/IHBpe4JMD9nvtFo4YPTzzQ6hcgDuLQDH2WHm18ENHH4N1rUWWlimZc5LM0dO7Tq+/y4s27KfUrsf4vT/dxW14tgnFpfGhQxdV+atlronGUr08EgOdJZ+noE2FDjixqg348ckSMD3ZfAsbP58B9uMB+r5/BmnuFyn6iHoEeKfQsLZk3XBTDpuuxZQW/YXAANoAa2dwzzbSeN4VZZp4ssYeC/6ObNM4fy4K/vyUh8eT6Hr/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUGF390KLlonsZ/QFDsBel6wnAbG10srVPcNeOCSG3Y=;
 b=Df0yPJVST3wa3l2p5eyULMPlpToKMN1aEl7CcujUUIJQFAXOInjIJaxhOIGotw937R3+nkE/Lvexj3xAexSFGCZ4EMmDXkeRLWmbmwK5WHbqRb5V6wGFJblsv7s9FFKBRLCNoHTpBfeNv9xgeVmOxjO/QYmtgu3CFLLMunWyD9DBwBYdeaLyAVc93znr7bX0Qkdn5azSF99Y0/9FOR3cvEQO1SBp2312NsIgvu98NkNpEZCi/6CHDep+iDFWk8ivtlPopwuyRo1RRuVw+dh3kNiYFXJEWvOdcApcJqt6c5/mSHW/1N6oXwSdq3gOL97SD5nESdvmXiHuhBjEtjdDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUGF390KLlonsZ/QFDsBel6wnAbG10srVPcNeOCSG3Y=;
 b=LKB81HJvgsldkNN0ZxR4oAfDMUFhKkDuBueKNYu1NNodwKUwF9g0TeyIOMjiEn1MbK8NI3rSfO7Okr89iVti7a+1tMYtm7lLY0Hjx/oPyGVepOkSmv9Otzf2xzx6jbDgfK5fuWyzs+/z73PZbIgeCU6bZ3p1fZqRP9vy0g+fiFg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3904.eurprd04.prod.outlook.com (2603:10a6:803:17::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Sat, 9 Apr
 2022 20:45:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Sat, 9 Apr 2022
 20:45:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Topic: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Index: AQHYS4PpJFoPHwGopUSskoKVo9n1g6zn/hgAgAAQgIA=
Date:   Sat, 9 Apr 2022 20:45:57 +0000
Message-ID: <20220409204557.4ul4ohf3tjtb37dx@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com>
In-Reply-To: <877d7yhwep.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bc69260-1bb9-4573-1a9b-08da1a69f31f
x-ms-traffictypediagnostic: VI1PR0402MB3904:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB390464ED9F01E587F96F7852E0E89@VI1PR0402MB3904.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tFZIKVMhnDEJ/Q+3Ah/+zo1NwYCMgBFEy1+61ybF0XqQ3X2KjGRuPJB1It1la6IocMxJWVJrOiHdCIj2q79oqMrWA4T9KLSt+9AR3uN/PHnjgtWkoYz1YXk7c/52b8scFpwlmD2NSo37x6QWUgT+tZKti3bIMWwWxLueQga9EeSUeNQoQ/QxtuFrqozmCjsXfyAzIuESDSR/4Syy53cA4nxl4JCkscw72CZAWajcY3/FbP/PBcL8UKGDBOTJFJlkwdtAR+2uOKSJzwEWhTTUnCJrYPVgZppzZPsx5tbLvYmNbXoWRtYCXeLRcpUyZ9xiW0+fDM95klPl8xiizR4OHJjhlqamwojR6nntmgHOviA/+tFzCr3JRFqYFSMmIJ0gSeBK5uGyrOpq6C7e7BeEUOz7fTaGyCW3KPhpkAkZG+R3THWGppiBX+tq0SXdfhtg+gzHl6ivoZ7OWfeBLnYFL0AlKawtWPBgMPnYwHt62EF5p2bOeV23NeJ7+/3zKVEC+xDlnbRAI10Ud6w81X4TYlYCee/DnB3/FkHiP94sWgHsFtCtZgKJAMpQ56Dyxrnaaey5QeOdoXINmTntjzXpHhQv580QOy9/6lY2uiHDH0ga7QhGhtIf2Bol8ZTCCb9MEUBmQmeVfDLgaae2JiONoGI37kkV11vwB0OvUFmfsH0xTzdsJik5JhVf5WJTCLbSTh6EPsruDkdeObcy60HmmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(2906002)(44832011)(122000001)(8936002)(508600001)(316002)(38070700005)(66446008)(38100700002)(64756008)(8676002)(4326008)(7416002)(5660300002)(66946007)(66556008)(66476007)(76116006)(6512007)(6486002)(6506007)(9686003)(54906003)(6916009)(71200400001)(33716001)(186003)(86362001)(53546011)(1076003)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aYXixE8U95iqNxJ3g5G/K1viw3AOvjxYq19oWh8KQrYFWUvN/WC/rITi3xj0?=
 =?us-ascii?Q?mQbfuB4baYlU1Omi5ElKPsigsb+cTDezTxzYDu07OW+HWIqO8O4d+zund9wD?=
 =?us-ascii?Q?Njq03k//LWNLBfss9bbcCV/KItoHIWCtTu34REqWcO7y6x9sLHCICSUEygfL?=
 =?us-ascii?Q?Dj2fyMviUlAxd0FBIELl8rdRBgGTKOohZMqGGoKY+mO1DACtoVNXMODXq2PQ?=
 =?us-ascii?Q?tgTWVDoMKjnwdx9RphAKXBsUhNFDk3XBESAqr7AKv33/KanDBzmhMI7CABRg?=
 =?us-ascii?Q?5m5qiQi8Aq/GR+xHVvocd8HwFEi1/vXShUj+w8UmfgNkAYSd3vU8rqYjBiut?=
 =?us-ascii?Q?mFNAZvST/JXFxWwZmBg1m1SuwX8zU0rkYbTXA4CFpbQ8st7CxEcfUnI7Srou?=
 =?us-ascii?Q?D6vRzAjcoNQZdgIObaTG1UU89ueBmus4tSBRhqNfzWPErGId8be1x7K+cKCf?=
 =?us-ascii?Q?oV7O/LffzpkyKWOYHJFgaQka2dC7dOHSEiTaHYo8XhbJAhMVTY6GUmYLGPpn?=
 =?us-ascii?Q?sxdeOEbqB0PTmDJbZw3GVP1a1kXSto0rgtYxPieKiP+0VJcQKfbqxXZelCV6?=
 =?us-ascii?Q?e63KulUOHR4ytz1iS2ENqCev4vw/MVt3UQreRgEi/O93c7K8bdzj/Nj+Zhl+?=
 =?us-ascii?Q?0DBRE51ZFUGh5XimWwENhjqz1w9tlJRS+mKNasnXRc2dBgNwQmijo2jqKpMp?=
 =?us-ascii?Q?uR9FvRrD7a+x+6ZChTyeFQWwH/VldgAENDkalF/+KoIFb51TWPea8RK5s3B8?=
 =?us-ascii?Q?H++j2aBuRYtKnnqmzJzk4Rf0Ca8gcHq0Kzp1CjlHguC82WfsjYm+XB9BPN2U?=
 =?us-ascii?Q?V9mpoGqjq90aJWMWL4rIxWBRu8kr7oC6c0+UQz+MVGVdjtGozwKnK88RvU9w?=
 =?us-ascii?Q?e+k+9QyBMxnaNTD3WSF9ZmpH838s652aZb67nYpcU3gDDTx0kRbWkm+yn6C5?=
 =?us-ascii?Q?Ot11HT6bZwQA/Q84RVCW3n9pGCiEum6b3ctokxMSEEGJ1d+G09rqxdfQ4z6j?=
 =?us-ascii?Q?Oc3MYea4zU9XGHdUIuv9oa/LO3ISQIbChcU3SRtSHiRqvXBHMLU+QHH64bh0?=
 =?us-ascii?Q?yTksmDY4BW//gAEKKFixJt5Rx8LrX64fbHkCzuP2pk3+6mpPsmd1CO0O+y3J?=
 =?us-ascii?Q?WcWEIh1itbEFcbld+/Tm4lmRjAVvjnS9I4HA/6EhiVpMrsFd9zJe/cm6nU52?=
 =?us-ascii?Q?kYwQMm43UmFWK0DEcSPSVCoKnnQDuX+BIqJT70G21Bf8na59WXNLShC1ztQZ?=
 =?us-ascii?Q?NuRphvkZ5JyjopGJInhAedScB6k10UT2LJNdAgxtj0hQjVO+UUgsgWwaPug/?=
 =?us-ascii?Q?Fh4zZ8zcPeqtDiOoshOonkn2YKWt56Jh1QjiulYVkYg8LB0QEuD9VdEu6Pcr?=
 =?us-ascii?Q?p2ZhfBF4IN73A00Ouse24Q2DMHR6WiUaNNdERoUFRQFmSBkd7eaNiXxsNF7d?=
 =?us-ascii?Q?kTHZ26YrfmIYUg/UEBBUGZ64x22XpMXx5V7Ig2rtY+oWatb1Hvc6bC++PH/h?=
 =?us-ascii?Q?GL9bMB0N/fSrCUSQW1xBznREsSCgjf+E9Pq2l2dqsxTRpcFP7YQUocMjUGzh?=
 =?us-ascii?Q?oPFRzGKoFt/hRhhs95l32hMg0HxyqzZAG4viu4V0taQOWNsft+N2Qy/R1O1F?=
 =?us-ascii?Q?5gytwH6vj9yxqkMLGhEVdZvWj+HQkyriI6NOpUk+XVGPv1lq9MDythAIomgB?=
 =?us-ascii?Q?tXEKbo8gZT7C6UuMbGrEk6Erq3A06m404qZjaAVnx6W858xqpH4j1D0NTKPD?=
 =?us-ascii?Q?pzVXswtb+y0TWtI2ZZnFmcm8LB8CD2U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61F296CC361CF6469196549718921ED6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc69260-1bb9-4573-1a9b-08da1a69f31f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2022 20:45:57.7886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qCdiTTckOh+eZ98PDvH04zMz+N7s4h+CHtD1N2ZP/hpO0xgNA5bCZIQIw2mgh0aWG9ljpxrcL1s70z7TVw4AWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3904
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > For this patch series to make more sense, it should be reviewed from th=
e
> > last patch to the first. Changes were made in the order that they were
> > just to preserve patch-with-patch functionality.
> >
> > A little while ago, some DSA switch drivers gained support for
> > IFF_UNICAST_FLT, a mechanism through which they are notified of the
> > MAC addresses required for local standalone termination.
> > A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
> > bridge FDB entries, which are the MAC addresses required for local
> > termination when under a bridge.
> >
> > So we have come one step closer to removing the CPU from the list of
> > destinations for packets with unknown MAC DA.What remains is to check
> > whether any software L2 forwarding is enabled, and that is accomplished
> > by monitoring the neighbor bridge ports that DSA switches have.
> >
> > With these changes, DSA drivers that fulfill the requirements for
> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering=
()
> > will keep flooding towards the CPU disabled for as long as no port is
> > promiscuous. The bridge won't attempt to make its ports promiscuous
> > anymore either if said ports are offloaded by switchdev (this series
> > changes that behavior). Instead, DSA will fall back by its own will to
> > promiscuous mode on bridge ports when the bridge itself becomes
> > promiscuous, or a foreign interface is detected under the same bridge.
>=20
> Hi Vladimir,
>=20
> Great stuff! I've added Joachim to Cc. He has been working on a series
> to add support for configuring the equivalent of BR_FLOOD,
> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allowing
> the user to specify how local_rcv is managed in br_handle_frame_finish.
>=20
> For switchdev drivers, being able to query whether a bridge will ingress
> unknown unicast to the host or not seems like the missing piece that
> makes this bullet proof. I.e. if you have...
>=20
> - No foreign interfaces
> - No promisc
> _and_
> - No BR_FLOOD on the bridge itself
>=20
> ..._then_ you can safely disable unicast flooding towards the CPU
> port. The same would hold for multicast and BR_MCAST_FLOOD of course.
>=20
> Not sure how close Joachim is to publishing his work. But I just thought
> you two should know about the other one's work :)

I haven't seen Joachim's work and I sure hope he can clarify. It seems
like there is some overlap that I don't currently know what to make of.
The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress settings,
so I'm not sure how to interpret them when applied to the bridge device
itself. On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
bridge device as the knob that decides whether the software bridge wants
to ingress unknown MAC DA packets seems the more appropriate thing to do.=
