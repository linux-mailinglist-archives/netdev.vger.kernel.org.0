Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFC34CAE71
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244976AbiCBTRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbiCBTRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:17:01 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30062.outbound.protection.outlook.com [40.107.3.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFAE527C7
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:16:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNNgga0hSoWLfeu+oW20/QzU5wKzx6TfhxZAILd9AGBF/paC7JBo7OZwWBAwP3DlaE7S7TSyCWLTgnmDuDCIjJD+piIi4T9YSSfLtWi1VSNL3sJ6SLCQWjrtj70Kjm8jMU7Tm1oI0k5B07D8cQynHcmOXVtMeamZ8TlT4I5hhMmH836uXJWpdPpDfJH4z4r9mEgJHH3M/GPz83xqpaxqNfoW4mcVyadNpoustOfANiuuVeChgUNyblhT9kALOLvrCSXtsHTdQmKmiWhmu9Phy6hvzGRaFCFeFbPZy3gpJ5eRjeaQo2oGzxxxuJB/cYDg3OTOYDQmdHgmdGMVY3urQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qFvjirHPJN617PWHaJYCYr9DpheCXGmnsBsxiO1cfw=;
 b=DChtfI/cXCKscWBHBeVmUHF5z26jqayFoJJRlgUaV6/vL375rTRzWEV/ILDFu+NNIeZ9Nsr/yZTPYh1V6MuaE1MG0Bwlu6vFKXAo/MAAKybu7G6ZPz8G++TUbwTBLPjmmJr5yReoWHFPa9pOeRd+zktvjEiPisX8dJ2Ge711PZHZKmS/21RjFJzihseU6n6XtCQKbViMqXlkT1M0faVy5rzCz43b472UtgAYRVbwJpED5ybGJ7hLdFTGYuEWxtjMSygp8tCgKAUaZngDobOGJvJ6spe+ytSqsjIHmx9mXxH0PQ1jqbR0vQZmBPEr3SL4CIKXAXcpaa0ZjG5ybwNQPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qFvjirHPJN617PWHaJYCYr9DpheCXGmnsBsxiO1cfw=;
 b=mnHykz8AXMZ29gLXxEL+55CoL3ea0i0VBXGX4H8gJfMhVuxigguVci7kUKydXUu9Mj65QMwzsRSvHf61mVgUL+cCLdsBcxYBQid2V4YV5JNfvR/eEQDLJmqwAOf6sYj1HIfaGaFtgpkFaboG2hSfDLBpufbw4uBet/qjrMRWVwg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6558.eurprd04.prod.outlook.com (2603:10a6:803:11b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 19:16:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:16:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Thread-Topic: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
Thread-Index: AQHYKZfghaCn9gSIwkaajp+2UkkGvayqvh8AgAADtQCAAYAxAIAAPsAA
Date:   Wed, 2 Mar 2022 19:16:13 +0000
Message-ID: <20220302191612.oylrlrm2yduwzlh2@skbuf>
References: <20220224160154.160783-1-vladimir.oltean@nxp.com>
 <Yh5IdEGC9ggxQ/oy@shredder> <20220301163632.pcag3zgluewlwnh3@skbuf>
 <Yh+N2OCM+Mv3GWoO@shredder>
In-Reply-To: <Yh+N2OCM+Mv3GWoO@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e3f8ce2-4f93-4fdb-d673-08d9fc811e35
x-ms-traffictypediagnostic: VE1PR04MB6558:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6558E366D591C6D288A02A5DE0039@VE1PR04MB6558.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uvsiiWlmYqoZOt0aF/KLeZLvS5mNAon0++nMELe3yq1FEWJbeVdbaznxra1pZxPS/AI0IbHR9vuFfHt/AK+1TvjrqLILcvsfzMQAsbgmqsjb9439Adp5/WvKNHsT8Qxd51pOlzHHHPeHKSvP/OTXCESbzCi0cFnWLJ5uP81jRwCxdelLiMj0cO1MKncze7x4A91Gc12rmy2saiq784Gkb0zOtvX9dEYdvMuRtC7+vc9FM4wyet/oE85snfIO601mAxpK8EXFpxdykzJv3hKUADoo0SoUgo82Dcg2NPTeZltv5HXH0mEGc/M5Cq2kWeNjYLrOkE6yS3b0tps4WCguXhDUqyzWlp0tM+UN0Gq5k9xOhomXRiwu3R9LlINNXPGW6iCY/RaKgCA3w4zGzsANtSjBNxgWIAHg9SDfPKvtVC+miPArYeFK+H+NPKZb7T8lfbf5Me06SVVNq0AMdQlEL417ahvC5s8x5YxSi4fAh0R3ZqX12TPmsdGdP+UDdguAbMsO+Wna1WPF5xAFqD5bBSPipHw0UWj8xQMxT6V3zxbUcFDeTb79iBWrCIcq8uYBkf3RYRFMzPpNtLH8IDPacdxAjG/gOMgqh/boXftJ1k6p3UX7/LidIoxdcRm10UE1ma/bgDXLCCqcuVtvRakvoKp/gZBV8QdCnmS/HmbPDkJCVrMN3l5xAOxrS0LEK6P5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(186003)(38070700005)(44832011)(6512007)(8936002)(316002)(1076003)(9686003)(76116006)(6506007)(66556008)(122000001)(66946007)(91956017)(2906002)(5660300002)(8676002)(66476007)(64756008)(66446008)(4326008)(33716001)(71200400001)(508600001)(38100700002)(86362001)(6486002)(54906003)(6916009)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fnW+g/rsoawF4mgpExTQv3EqALusTl1brwbqrB/J4N7l72TM6rh2HMhTYW1x?=
 =?us-ascii?Q?1j+kFrMHXlIi1Q0TdMZen0KCR0p44VXXnVsAhrAAgz9g6e4oG6efmdChqBmi?=
 =?us-ascii?Q?Z8n+C0AQoOnzX+bw699r6+vSWvNCeMI910/GgbnmUjAMqt6/iE3iRcC0lq5f?=
 =?us-ascii?Q?Nd9AEfOqWPy8AfMFB6tTi+VOhJANTYalDK/UgYc6pdfqQZuDRuXEu0EmSPOC?=
 =?us-ascii?Q?0MzYv9kt7jkN1ama7e11uiYPxxFElhxIwfwKqj7I1FKM74x21qGmUMSuQrlc?=
 =?us-ascii?Q?CYMfdKvkD+yJH2RlnnZg+XuHh15+34iq9QeW3Hdhe9HyxFxTwx+4MV9DQWd+?=
 =?us-ascii?Q?0WEmtl5xC2m6wUpYS9HlIWp6d7L3f/I3gsrnQyPaB+Ri7sR79ymEMU4BIe+M?=
 =?us-ascii?Q?iwcLIluEh10lmtwXi2LkHBUKMTRg9bGdGkfRQdh6bndSmDU3cq1Jme6vLvBw?=
 =?us-ascii?Q?0erGXwJuY1Q0Px4L5GW7dwHRjXRt9ZlAizVj+w0jDFHm1wgim+yqfKKAN2k0?=
 =?us-ascii?Q?9YT1YXpRmlp5xxS2A0SrXLrUm8hzPJjDrrQbaXYNIAXLbPvAHC6GPK68/iBM?=
 =?us-ascii?Q?6RCNLSD6sj73JXEyVIPpODnueWsNtfxlN+Gxzkcm4aKAPFQVUqyA5Q3y3j93?=
 =?us-ascii?Q?War9rJGCFMo2AqKS8B2d0filH9F1lXLRKxsnhiEOurBJSYms4UidjIQWgDv4?=
 =?us-ascii?Q?489T7VVX3Q4xU4xcAHnFSKUKf+xcBeeEAiLGw9ZLWRjh0WumDKAotzbnohvs?=
 =?us-ascii?Q?MC4HgwGecHnQikB8ZoiDbjsCC5e0FeGCLNOq5Wv81Gch0jp+EiEOMxJZLYJS?=
 =?us-ascii?Q?lZm91rvHOdBJl13s3NgOhQOw4QCXun1ZlTJT56RkF+LlK7ShxVWOv56Zn/QQ?=
 =?us-ascii?Q?nIQO1oy3dqoRB9Jj1Y1nnowAzz6ciJ2GpKrS2xy+KSTKHUbSf4RLQCMqtTBL?=
 =?us-ascii?Q?Y7OHSVw3OgTX4V1B5+F87ygkD0BOjJ7kL/y51/W3rUT3ExA5AxOdYslbrdIt?=
 =?us-ascii?Q?0o8UudXZfi3SKijeupZc6Cyg/ySpMC2U0yQtvOOtw1FBjw6tCHIS3K8Yo0PX?=
 =?us-ascii?Q?cgcpkK4yiLEFuu2zfPNPBVdKwNwEzy3f15Nv8YIx6TGBHcCdsjFfAnsH5lHW?=
 =?us-ascii?Q?8r1eHFGqdds0gXre3iJiX1D3rgTTIWyGjZHNMeDS/GiKfEs8KpGkyie1rxbT?=
 =?us-ascii?Q?i6Jr5rJRK2CCi/kHjWxw8sik0351imAoPy12zYDlUjwly1HauiY6JYh4D86n?=
 =?us-ascii?Q?MwOMXAac3zBc540M2VP44iKCEf5V1ApEwSdHwdFFzGe9zz5T+v1DSOMR61LH?=
 =?us-ascii?Q?e5fA2m3IWbAihbYrwGs4DYjl+TSD1TMPsw77LdMnRf8aO++FNktRbaUa8TY4?=
 =?us-ascii?Q?ZwQH+QfHSMs6BNJaESAVYHAa4tKTMbTsm64nC33FpE1vuz54drIvj5PaL1t1?=
 =?us-ascii?Q?l20/zbhb/JRPcKepZOhxfLJ6LVezPxDtsNpm2A9KgP+bsSoIZSVd4FbunCFL?=
 =?us-ascii?Q?hPHrTzZr4FpZQVbaQpPWDjT0WCEiIpoU6n3FTIvEhoN0rm5eFdTw3vFRWP97?=
 =?us-ascii?Q?NcvsnPC3ub7uGeVy4nQcK5tmNr5EW5GIpSKEjh1SxaMz+cxX+nwHNIv1gr6d?=
 =?us-ascii?Q?eyD40zjJxDRYWxRjiajX9T0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A34D262C599D6E449E5C73BA62E820F2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3f8ce2-4f93-4fdb-d673-08d9fc811e35
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 19:16:13.6055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hhiRS0Ferr92dxQCrRvTU9SqL9RErsg1ZVlVKtJh6RdaiFZ6FY4pwi1T14AE91mJ71ZY+of9NXKkGV7H4mRTsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 05:31:36PM +0200, Ido Schimmel wrote:
> On Tue, Mar 01, 2022 at 04:36:32PM +0000, Vladimir Oltean wrote:
> > On Tue, Mar 01, 2022 at 06:23:16PM +0200, Ido Schimmel wrote:
> > > On Thu, Feb 24, 2022 at 06:01:54PM +0200, Vladimir Oltean wrote:
> > > > +static void dcbnl_flush_dev(struct net_device *dev)
> > > > +{
> > > > +	struct dcb_app_type *itr, *tmp;
> > > > +
> > > > +	spin_lock(&dcb_lock);
> > >=20
> > > Should this be spin_lock_bh()? According to commit 52cff74eef5d ("dcb=
nl
> > > : Disable software interrupts before taking dcb_lock") this lock can =
be
> > > acquired from softIRQ.
> >=20
> > Could be. I didn't notice the explanation and I was even wondering in
> > which circumstance would it be needed to disable softirqs...
> > Now that I see the explanation I think the dcb_rpl -> cxgb4_dcb_handle_=
fw_update
> > -> dcb_ieee_setapp call path is problematic, when a different
> > DCB-enabled interface unregisters concurrently with a firmware event.
>=20
> Yep. Can you please send a fix so that it gets into Jakub's PR tomorrow?

Sure, let me send a patch right now.=
