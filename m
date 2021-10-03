Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C83420400
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 23:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhJCVFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 17:05:46 -0400
Received: from mail-eopbgr50064.outbound.protection.outlook.com ([40.107.5.64]:49807
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231389AbhJCVFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 17:05:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2ATjnG5EVADRoSH/gATlBt68Zq4vn93+fLAi2WXU6mxXflensXVzHSfvq/cigSmzmGCi5o6b7GADKsgAudv5dwqSkaGm3R8tewa0bvpXyz4kTwrOB83qnu6UTB+Y/ZsoxZX0FtEZGBbtRgNXcILViFDIu+/uQ+PFKdvBgxBZXpi1IM3RzWEL/KU9KsqAISyXIrj7xc76OtkI2oQpCjgQe2t2VYk0o5Jml/BiX2dn8N7Xy4Yc3ARd1b+lwLwfqrsGeiX0LPeshwX0DvdCk0vmieFDC6gHTUP6MSf1Rep0CSscP8bwKSFmpiEyx83N/a7kItaUH6i2k2FM6YqjOycEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94GqvwfcgXcVvXwvbf3PK7CU8MKNJnYjWJBCUp09E4s=;
 b=NRTXDzGfi2lVD89CY5EFaxEOmpkzCjae9sWHcFlc2k1dAMR8wQ/fXNVgCtn1wziwMhGGzSBdDTj5cBo61UEXPpqW0lQoXayOBhDZPrKar95RaKKIlRkBp6Lt/pxNoE0jT6Ylya8NVJj2dKNCiDpTCcsStyhxlaP2PmdEdCjek32DPcDI5AcnSaZIAyIqof7rkIAzbDyPqjZdoE90+RQO/uhstXJW2FdyXcp+u0wv5bI3W0c9RsqZe58XudsewPEU5SxSEjOP/bmy+bWVAreKZnm2w1dKuD1dGgpqQvffJBSuyteYuRPaE2mSMkyG6rolowsDCyBpzwcRfQ1keKqBLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94GqvwfcgXcVvXwvbf3PK7CU8MKNJnYjWJBCUp09E4s=;
 b=Q8w5SbLRK7i48pLppvzu8uqVh9XfJWV+cUjmWpVucR1V0uh38mtb9gHfp2tijyLgvmSp5dcyXyylJYATsFleCuRP1inIwUljk7353oXBrl8QSWRxr/zgQZY5xYA5WmBCDlmnUXWWNCbI4NDpQ/Zh8DmcSTPvHBHc8Uyq4O5wqFI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Sun, 3 Oct
 2021 21:03:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 21:03:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING
 case
Thread-Topic: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING
 case
Thread-Index: AQHXuG6ULWzW46PLSEq2SyN1aUYH6KvBw3sA
Date:   Sun, 3 Oct 2021 21:03:55 +0000
Message-ID: <20211003210354.tiyaqsdje6ju7arz@skbuf>
References: <20211003155141.2241314-1-andrew@lunn.ch>
In-Reply-To: <20211003155141.2241314-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc2fe9a0-8863-4718-851a-08d986b14fe0
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB48160F3364320DC6BF44CD7DE0AD9@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vb4MvQPTSA54Xs9TDji0UtuzZZX1yBebgBqciPTz7YzIDFLPKaKjjVkTlYtBqT1zGqkQLQA0VrPnsxe7DgpZ2XyLJGDjNhpNm57HA/xrn2bTdrc9vyA+amh381dPlNiEiBmWq5vbyN0lkOpjgndOHL9IymSM3/295Vi4VwuRgxSepywiv/PYcWkBEcMq/NrZR3Ys5HHEEzCfeMpPzhssMDJBK0mUNrE92smq1KeNT3moK6XF5EeKPj2devB0T5R0h4QFC1wXenJ/46wgbxpezCYTnioN1JcHsTI5p+9CnfpvJwJDXnY6tClVt47tjfNnlK5jsTlnQb53HdxmA0/ofx0j1jT9w9IOm854Nh8bOX4CKAxNqxSnC37PvIB/AljehPyrULgKVAWGEuSr6mr/+HDUp4yRnuvvkzGBJtK9FkchAJaQNeGTcmkScfTRFE2F0ejkyTCDHTDynUG9HzEHMh/NR793+nfDG/Ufv7aG9tjl7q0DU7Ue7Wg7Gxe8rH2Ko3WHAHC4LUWrZBvgJ3BaovWOpJqY1Eu6FNR0LYaakrMC7/tudWa5MOIxq4ocdERF9yv/6mvOUJxclKaE7fylLIesU4GA2LsalP1FMXXRiY24cJLyaLU/RObpvyc4gFO2r8DyibV35N9Y71JCIW/gyx2gAGoqNG/2fmu2Uq6ByJc4MSabnneTGRini0VTufBrGhbobVqr+ZrWtfKwWM0z7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(38070700005)(4326008)(54906003)(83380400001)(5660300002)(8676002)(186003)(6486002)(71200400001)(8936002)(2906002)(6916009)(86362001)(33716001)(1076003)(508600001)(38100700002)(44832011)(6512007)(66446008)(122000001)(66556008)(64756008)(6506007)(9686003)(91956017)(66946007)(76116006)(66476007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3AdFMmmFysd10eS5PFYMKrfrYQiZKPSRQZXzTgOj2RfuDGr1jQPKnp6EA3bk?=
 =?us-ascii?Q?iWnaiSD05RsWo7rNjH7tVrlnus5Z2QNEZQhHyndBj5Em3Vjwwj43RA2PBCf0?=
 =?us-ascii?Q?tGIaw7rwUNKS+h5PyaHYj4NsYZj9HfJgKdauQj4G9BKHPTdyfHoXBd7jGFQO?=
 =?us-ascii?Q?N2JyppTPU4Prdhq0ujgrDugfL3MuEys1Ert4Wr4Al3H7XxoIHlDYhjciIOHL?=
 =?us-ascii?Q?hj/xIsi06Uy8sO5sHeaMWCelzykUA5W+ZB4ksyXLwRSJ94FZM8X3u8CMXg40?=
 =?us-ascii?Q?gkaQgMjPAJMmydiWVKc1zk55YGb4BOzJWfmUaE48GbsKpdlkGyTmb2FIS2d6?=
 =?us-ascii?Q?KqxdU/benVd/rpUxlcEHgQiaG77FXv9na9YNdPg9Wv/KZbYdf8V/alplkgZU?=
 =?us-ascii?Q?HmNYm9yEeB/IdXRBRvgg1bps/VaGhkBmqifm0JVPNZETS0JCsdiFWgZ9Z7kI?=
 =?us-ascii?Q?0pZzT8ssIWiKKS0DJxPB4HQBIo0T6y6HPcboyzW7FVopNFiiAFC7pZ0rjHmp?=
 =?us-ascii?Q?Qmjw+/+hbN8zKy+cG5fWNjjLzz1JUAkBN8JNQ+ZjnkM0hTaDhDlePtwU4dCo?=
 =?us-ascii?Q?yk830inomhoTSOUfbvoWqDFLo4TP7T/5Bl55tY+q1H2Kfu5tpKN+OXOX1h7D?=
 =?us-ascii?Q?zh9l/+F9CcfGUF/6PBjiZaUmA23mRBBotkKe7pDy/TOc6UAugzQ0pyns61IY?=
 =?us-ascii?Q?/rvQQ5bfxS4WE0dcNooexTlMtPCA0okjXVXKxHXDnSGPKgT+mBvHxiRumryt?=
 =?us-ascii?Q?QDjD0uIqErRrj4SqNPsb94M5xaR2wwwrnWpbKP67PLtudMnrI7WlLoDl9XEE?=
 =?us-ascii?Q?xz2i4R2+6IXjVMdrvjAt01wv6uDB+Tio0r443Y8bnoYfGuG8QMNg3hvecSt/?=
 =?us-ascii?Q?hx2FskOYSs6oGmKX9pH+587h+mh1MdmM4Th0T1WQF3g/bo/48E/s5gnna09r?=
 =?us-ascii?Q?V6f9MCojHm8iTymxLGLLiHM9wv1w6zsihEgNoX0zInVunCRuVyR/jIThF7mu?=
 =?us-ascii?Q?c7dtMxEoSyldNGTD8eytuqN37mp6lDm12saj1ysDRWSIZwfL+OrponZ+2GYH?=
 =?us-ascii?Q?TrORw7p+39rpVZYgM9Ja5Zhz1gOfnepNUemmzCPjJMzHKH+/gVmfHEZRPGgp?=
 =?us-ascii?Q?f2jIk+V6jIcjeIMjS/cj5OhKZdjsjM7tAa4FwD8tOkGBgiCvS+KUS81tlhF6?=
 =?us-ascii?Q?YxSVEs722umdpo203Tz6qzOiuSS/OwHL2j1fHg3l+3nGOzOoQi2WWdxQ5JhW?=
 =?us-ascii?Q?Wp4ivEHd6FgrbW2LVX5Wdmq5PeP6l9vsBb06ChHdq0FK3tTOftfRhKxjdo0k?=
 =?us-ascii?Q?WjU015p+Kq1oRYjVGYWo60Nl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDB13A574FEC0F4FBDA4686350A6BE99@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2fe9a0-8863-4718-851a-08d986b14fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 21:03:55.5844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVB2X13L9XVgmnNqHDh8gkXLZCUfqXiKw7YG0/qfP4P5oVL+547xDywtB4ckIaQwVJkPwiOax90s/3KqHJHxjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 03, 2021 at 05:51:41PM +0200, Andrew Lunn wrote:
> If CONFIG_BRIDGE_VLAN_FILTERING is disabled, br_vlan_enabled() is
> replaced with a stub which returns -EINVAL.

br_vlan_enabled() returns bool, so it cannot hold -EINVAL. The stub for
that returns false. We negate that false, make it true, and then call
br_vlan_get_pvid_rcu() which returns -EINVAL because of _its_ stub
implementation.

> As a result the tagger
> drops the frame. Rather than drop the frame, use a pvid of 0.
>=20
> Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding pr=
ocess")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/dsa/tag_dsa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index e5127b7d1c6a..8daa8b7787c0 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -149,7 +149,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *sk=
b, struct net_device *dev,
>  		 * inject packets to hardware using the bridge's pvid, since
>  		 * that's where the packets ingressed from.
>  		 */
> -		if (!br_vlan_enabled(br)) {
> +		if (IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING) &&
> +		    !br_vlan_enabled(br)) {
>  			/* Safe because __dev_queue_xmit() runs under
>  			 * rcu_read_lock_bh()
>  			 */
> --=20
> 2.33.0
>=20

So this got me thinking. We shouldn't behave differently when VLAN
filtering is disabled vs when it is disabled and compiled out.

In fact it is actually wrong to inject into the switch using the
bridge's pvid, if VLAN awareness is turned off. We should be able to
send and receive packets in that mode regardless of whether a pvid
exists for the bridge device or not. That is also what we document in
Documentation/networking/switchdev.rst.

So if VLAN 0 does that trick, perfect, we should just delete the entire
"if (!br_vlan_enabled(br))" block.=
