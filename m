Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BCD4B3D3B
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 21:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiBMUDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 15:03:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiBMUDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 15:03:06 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30044.outbound.protection.outlook.com [40.107.3.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9E14A912
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:02:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNSmcg3wLToXlcVSVlnoGgwbFzp/3GLAxjjQHGQlvjmOlRQmwwEiVdD1q5K5zlZCj2m8e12JvcAs/rpsHqeha+vLbzPAXjOm2a3ETwBsifdIef+Jdj2WmHt2ff2Gk5M0Qwd8gm1LauePldOFAXVxCeq4BOkR1kTaqwr4KRGuoG5+fIMpu1nthXWsopFnGKcWHoT+3svmk1tw18rXQh8fcDFAKpFRQK6G5yrYn0qrIwp2MQJSYu4/tSk/5UCL3UuEMuqIkjYht4q+xBOICU5emAx/HoxAJ/dfkdFh3hybLZjxO8PYR2qMw6CxVuctTjXgYk5G/URJcv4IGGADf/D2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ua0XrtdOcuBp9FuBBD3pg0+eldvra4QEl5wfjWpG2f4=;
 b=Xjk1Bhy+UKoem4ndAP8T0VOxqXnPy0ePxay1JwajG2PFmb/0qJHGbtdiEK7Y2rfvFnFy2aLgJx0jQcAoJSWveEk5JlcTVKDj3bCDA1iwq7uRKMfJ8SnoghsY3VxCK0uyqNsMdvCvQzNI0YE6rYmp+FlMD6hn+N30S6UvlgPImKmBekgclANtuf3KpRJzKxBDT2+DLZ2ru49q1Q5bSNvvmwv0TzRYe+yPr13TBg/fG7opjED0UTbS7s3NKNyFnKrS8bd6Zek3EOHVmbkXRBmsU+/eRMJE4DfJMOtWYSglwGgj+LmSQzG+8KStvdJ17X1WP81EZALxHrMPte79PqRXRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ua0XrtdOcuBp9FuBBD3pg0+eldvra4QEl5wfjWpG2f4=;
 b=UC/NIFb8NkaxWeP2/xMUg9yvFQIlGjc+rDkx0pyU/pVANBkBazc/PSjiiA1L/vpjaw+zU7VAHVMYmTvEjz5h4Yx34aGdTlY5ZnBwTGek3rU8YhEhb0Eds3vvXIpzUhc4wXaMj2G0meUl4uQBVZQdVW+pILCFMvWwyov9WJ6ds9Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6056.eurprd04.prod.outlook.com (2603:10a6:20b:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Sun, 13 Feb
 2022 20:02:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Sun, 13 Feb 2022
 20:02:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Topic: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Index: AQHYHfxXQePXs1M3lEOTgYyrlnmZbayR2mIAgAATBoA=
Date:   Sun, 13 Feb 2022 20:02:55 +0000
Message-ID: <20220213200255.3iplletgf4daey54@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
In-Reply-To: <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5ec5768-4756-457a-9c94-08d9ef2bd369
x-ms-traffictypediagnostic: AM6PR04MB6056:EE_
x-microsoft-antispam-prvs: <AM6PR04MB60560804FD0EC754EFCA489DE0329@AM6PR04MB6056.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j7ZDV2RwQyzGh3+8u0u6W/fFsU1x7ZoccLuD3DqygfYpZPQUHZUCtNKM/I2m8No3gHeIN1tUUBl8soYPN4VI9hkV4ZEAhzBEXtzZ3t92YP3KMpXWhFGiWH997Xn9wrpyxyNNWT/7MkbOsG/p2+++5p8dq15HDdzN91+RhJSrxCUkb/2Ocbb4fEAu+YNktiaa6vHFnpN6p46sYyjWOFomZia/NxsjqWct1N/OHTPYYJQToXsw9tx5dISAFEf7YjiKUwSLZP79StNwwk2G6POW1raQ7be4+u81KBdGgyQ7yGGOyBDYnGQInwjYwXIjRc0mXQambyXuJlBfZrPzmLqxI5ULqpjz/jaXZTryx1vSe59un8NimUo2zC4kRtLvUx8L+KISSnxoaVh2p/Q5UHgXA8JOXPj5ZktLG6KO92i0UDuE0jy6RtEBZdYXWC1mvyfDsjWdm96uyGIJL/JIRCgyt2/5q4XDKLNalLWAFB2PLIoozBBMKAcrpVfnhArFLKMPNe0SMXC7oCJBAnAFxgo8TMNJJiBYYh3ds4NmziBEkDrTjXtm0vX2PeAK9N61aSNegHl4hrJaPGIMMN7qxOMkWBm7ylhwvmFyCG39B0rbdTJgxB8UmksB78ePtbEnq3nA/ocYrWMMx3pZKVYaTy98t+Dbzg0geOdQuJv6PWKgM01//XGfZF8pI4hi1pxdJCbgcd0mNuG+yyVf/l7DmXia8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(54906003)(6916009)(316002)(6486002)(8676002)(64756008)(66446008)(38070700005)(4326008)(66946007)(66556008)(508600001)(76116006)(7416002)(38100700002)(5660300002)(71200400001)(122000001)(66476007)(8936002)(186003)(26005)(83380400001)(33716001)(9686003)(6506007)(6512007)(44832011)(2906002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iaiJiYVzPEv3kZAUIp7zLzc1/cO5i66tKILlBTDsX9hCzO2MIQTdw8+XvR/6?=
 =?us-ascii?Q?lhpedFU7F6ZpkaTFUxmE/UwbiqqtGdkuJRQ8ryLklM6APQDxjlr6ZEmodUx7?=
 =?us-ascii?Q?GQwEi/N1fGIv8g4vUZI//2H89+NApC07k0SkJJXfaEk/IGsbOdv4jfnR3hAu?=
 =?us-ascii?Q?SJpJLjLwiMr5Nyr/f9e4efAbGCi3GPsn0FPdI78vVgEFyus4glVHRWwtp3Yc?=
 =?us-ascii?Q?H8s4jcHSOu4puvo0pvv/9NAZSA3NEljyzQB+vTklsudXUKkgrl7DA8+y39TY?=
 =?us-ascii?Q?bYu9vN6tPjMgej8+My14S9+Dgs/LBSDuhwyjmrhIC8WlAfQw1AzW8ebTSBGb?=
 =?us-ascii?Q?yFwYTqK/5al6hPPteBwONHGDU+JumpofqH0cAlucN1T3uFb34bkyzh+dDy/N?=
 =?us-ascii?Q?WG8WpzqU2qKOtwoemZ080Ouf0wsBOaEt/jWsRqyixle8ElilyylBbLayhTk5?=
 =?us-ascii?Q?vQq7dj052wmbVdFpZ8k0Xk8ZIO3Kj6ZGqwzlFwIA5K3Wlzz16wwBHCQp38qU?=
 =?us-ascii?Q?ei5rpcpjFzUPLLPlUk/sqgm9bPvnQ9sotigkZPiS9wb9Z1kDVwF2971khc4O?=
 =?us-ascii?Q?RFExXoPhzWAFKiq1kLlA8pYu9VT4If9hy1eHqzrtHV1Fv2OJIhtTu5ruHZrF?=
 =?us-ascii?Q?2rLNqUc+j9pMQIMKKyuQZwUEka1kNDoufiZW6EbT0q3HcPYT+jdcZJzH/7iY?=
 =?us-ascii?Q?Ih6HbwrpyZqcPSdlEaDrHv/DceijiVGJskvoCrZp75l7UYATiuFL8OaVmCZK?=
 =?us-ascii?Q?nxSEwVuOGg/ooq2QBGVVx6iddvggLJDfNAs0dxL1Mr+aUUKg8x3KSiLyowGV?=
 =?us-ascii?Q?XNzbVWK3b+zmgE+ZIxcriqW3PKO3w3x/M9fmB/jTHTaFoeLQH/hl7EqVRrAg?=
 =?us-ascii?Q?5TR+02pew8WJgwK8w3iMyySWME6FyFyRZDr0dZ5lcc3hF9AJvSaZLYHy+ers?=
 =?us-ascii?Q?sfXQn0gPjSjplS05dnwN23dWpiw6yUV4sz3Ow/GkvNe9KmEQS55DUd+iM5Eo?=
 =?us-ascii?Q?+3x2jPKE5ctJFNqW5bTgCz+2SYkQwmVnQi4gGEyCgjmOr+u4x90tEqMwrzQD?=
 =?us-ascii?Q?eYhAfu9FAqUorMb2mK87CGpKnDuc2Plif+6kbVf32oQRSqy5FCAjIEyEvAj6?=
 =?us-ascii?Q?uy9SiYMtWucOsoPDXZ5g7UVLgHCeU9f04fi19qETAdXboul2Is3bL6clTP3V?=
 =?us-ascii?Q?Zc67va+OGUY4RKEXg9r2my5E0LnCvBVSuBD4JVXWypTQCsZXUtgeSOoADqLa?=
 =?us-ascii?Q?h9XwdsMFMPucwyCkUt+LXJ5xWA7KC1nd0kAVurKwHeXv+D2d2uGPmx/DXpUD?=
 =?us-ascii?Q?Pczw8k6PxRW3n0ANmjWe1uY4n1JZr3cdl1MT5japeVxEaEgCaKPyc+kIc8ni?=
 =?us-ascii?Q?mQ3/A72O9caCMERcUJC6X+aZEkOfxDItoi33rmjm5FT/RJSFh13jp7gYvBGL?=
 =?us-ascii?Q?bhxXhn07cWjVMz9Dc/479TpgJpd4v0hzQG0cPnrfe7FIUl20JnGKg4BY4wsu?=
 =?us-ascii?Q?WJfiNm3UW66qjkn13xF+HzgEvd5Dsr5oWgn4Hr6Msqq3Yz4Tqgi1o2AOmd6Q?=
 =?us-ascii?Q?PO2Q1eIEjSkLED55aoOQ09HVtMhpHVfIEau+IIBE7wT6eKTydKFdJwPcwNqO?=
 =?us-ascii?Q?wonl0aBAp7AiiiVaHJ/PLm8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D458A0C60286B4BBE1B21E5A2B5CA27@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ec5768-4756-457a-9c94-08d9ef2bd369
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 20:02:55.8088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBWeXVe/3U6zLJugd1d9Gg9W8japCUqoP7me5Vc6e8k8Ix2TSGT2eFgmjHy1WFU+oAI37Gl9EBtxb82GHgTe1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6056
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Sun, Feb 13, 2022 at 08:54:50PM +0200, Nikolay Aleksandrov wrote:
> Hi,
> I don't like the VLAN delete on simple flags change to workaround some de=
vices'
> broken behaviour, in general I'd like to avoid adding driver workarounds =
in the bridge.
> Either those drivers should be fixed (best approach IMO), or the workarou=
nd should only
> affect them, and not everyone. The point is that a vlan has much more sta=
te than a simple
> fdb, and deleting it could result in a lot more unnecessary churn which c=
an be avoided
> if these flags can be changed properly.

Agree, but the broken drivers was just an added bonus I thought I'd mention=
,
since the subtle implications of the API struck me as odd the first time
I realized them.

The point is that it's impossible for a switchdev driver to do correct
refcounting for this example (taken from Tobias):

   br0
   / \
swp0 tap0
 ^     ^
DSA   foreign interface

(1) ip link add br0 type bridge
(2) ip link set swp0 master br0
(3) ip link set tap0 master br0
(4) bridge vlan add dev tap0 vid 100
(5) bridge vlan add dev br0 vid 100 self
(6) bridge vlan add dev br0 vid 100 pvid self
(7) bridge vlan add dev br0 vid 100 pvid untagged self
(8) bridge vlan del dev br0 vid 100 self
(8) bridge vlan del dev tap0 vid 100

basically, if DSA were to keep track of the host-facing users of VID 100
in order to keep the CPU port programmed in that VID, it needs a way to
detect the fact that commands (6) and (7) operate on the same VID as (5),
and on a different VID than (8). So practically, it needs to keep a
shadow copy of each bridge VLAN so that it can figure out whether a
switchdev notification is for an existing VLAN or for a new one.

This is really undesirable in my mind as well, and I see two middle grounds
(both untested):

(a) call br_vlan_get_info() from the DSA switchdev notification handler
    to figure out whether the VLAN is new or not. As far as I can see in
    __vlan_add(), br_switchdev_port_vlan_add() is called before the
    insertion of the VLAN into &vg->vlan_hash, so the absence from there
    could be used as an indicator that the VLAN is new, and that the
    refcount needs to be bumped, regardless of knowing exactly which
    bridge or bridge port the VLAN came from. The important part is that
    it isn't just a flag change, for which we don't want to bump the
    refcount, and that we can rely on the bridge database and not keep a
    separate one. The disadvantage seems to be that the solution is a
    bit fragile and puts a bit too much pressure on the bridge code
    structure, if it even works (need to try).

(b) extend struct switchdev_obj_port_vlan with a "bool existing" flag
    which is set to true by the "_add_existing" bridge code paths.
    This flag can be ignored by non-interested parties, and used by DSA
    and others as a hint whether to bump a refcount on the VID or not.

(c) (just a variation of b) I feel there should have been a
    SWITCHDEV_PORT_OBJ_CHANGE instead of just SWITCHDEV_PORT_OBJ_ADD,
    but it's probably too late for that.

So what do you think about option (b)?=
