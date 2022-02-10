Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4094B09FA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiBJJuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:50:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbiBJJux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:50:53 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60070.outbound.protection.outlook.com [40.107.6.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE9B1EA;
        Thu, 10 Feb 2022 01:50:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw5z6NgOrUngLpOcNbZ5TzBYjITSz1lZuSGWFS8vOfBW1it/Pk6f3FnDVuVCu41eZxyFUw3Ms4AWvaH4PodPZ1Iek/SrSlRuI2v0lWWCUgAo/X4tPRD0LUITKdJxAYOX7xURZf75U1kYYhFUj0oWIbEhwoqCVhYiUptAF/s7J2WMGScgNJX+DbfawTcPAJ4Vc2NIQiAi0EvueCKNQ7Ejp621Hg1kkhgDphjpmyh10MkAT8O6YWRWoJ/rJpQw8fqpWB74aSEh76UQYiUdOCF4YRUI83Z9HRZG2yJ70pkQA8Xd9x8t+/HYC8WaBMWDJJNge2d19iLrgqQR+hw0JU8GRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SM6s6hvg7rmNOLWqnJnOiFYQNHycnYYz+dZGfjIA5HE=;
 b=cWT2TT+XbTGG18CGoBrgHYXF1ehtrp8oh5a8w2Dgub6f9zjc1tQYYjaKdoSyTy/h0qgiS/TGU7mO03V5xwZ4saQNTPVkk1Zr+8rDTpRYJZAueIcQAhqMD9dgh/Z6VErET7YisPasr1AWGUjurVB8T3j2cbCgIcckYkWjvXk3frSYL/hKVgMEKSxFTuxx5cudkYJcH0apvwGol6vJR1JZSEcLnbnpi6eFfZ0YnFkdrt9O+0emtDCNiZ42bIZ6kBW8aChDgomoCOK0oS1AP4kQL1N1+U7OnvUvwKOBOzk0lxTR/9tqUdzZ8fQ3kBlm557+FrZBTZM7wrqimnN4STSb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM6s6hvg7rmNOLWqnJnOiFYQNHycnYYz+dZGfjIA5HE=;
 b=SWzCSCyvqqs58VKxVdUQouY9HNYSfSdIZ5mnC+IuXz9JjtzUjrkmQd34MVVuwXGsywMeLUkgmAG2s5olEQbtnxBL7oD293hMZrpUiaLbIhlA3CO6do5JSUhOxnn71AyTW8PfYwRslv6Ag/BhM4y/mAE8JpLsmRbqG4wL5Eve8nA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7117.eurprd04.prod.outlook.com (2603:10a6:800:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Thu, 10 Feb
 2022 09:50:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 09:50:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v6 net-next 1/5] net: mscc: ocelot: fix mutex lock error
 during ethtool stats read
Thread-Topic: [PATCH v6 net-next 1/5] net: mscc: ocelot: fix mutex lock error
 during ethtool stats read
Thread-Index: AQHYHjTcMTiSBcyd20+aLf9EJELZxKyMivaA
Date:   Thu, 10 Feb 2022 09:50:52 +0000
Message-ID: <20220210095051.b7rgpy6muvqjnih2@skbuf>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-2-colin.foster@in-advantage.com>
In-Reply-To: <20220210041345.321216-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6e567aa-a813-4823-c92c-08d9ec7ad367
x-ms-traffictypediagnostic: VI1PR04MB7117:EE_
x-microsoft-antispam-prvs: <VI1PR04MB711734C591ABD671DAC2680BE02F9@VI1PR04MB7117.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GMOwl7d9jLp8lAImp0LJkh1IQUh0REbhE6lHjAAJkauObJDXaZNOHWzMa2vxk/W6aFXwi8jYIcapcoQrI54WA9UhvVV1SVnP2wXkyfc+ue2VS6QSk5O9gL7SnfQAi59C8vRos/W2eA0fn7gJcZipWRc1AsFaXg09zcLdWwNEB7YDSKlVWgyTIn2tQe/iBwXuCXwShmUiav0JdIdiKLZURa4LI5QpPpCUOd5aPxwHUShNDiAZ1BU4uYE1tnBaIL7idkysS1MCC9ZRm+Hkl43R60FgLmap0C3OiGMrx7IAFysqUpP00GTivGlZGiCKZJzZ5vQ1wdeTY5t6m3lc/9RvPaU4JCFk0+xMbuaWoMqNLFMPMA/3fY+Rfyj+q3tQYX8ITBFqlbS8rVNuQjUKAyF0zLEvAZPxBYFCjAGVNDLjQDuCOFW5WVj41F8zcfE/dKKBqf0kxuxs6SNqXd72P1pyXNXg1DbtVjjaa160qnxGzm2a3Kcee0ofNIFI+XOyIhUYGyXtO9ozaZcjvVXGNIMLFUTYfYXXoqoKhsU4iuSP/k1oh6bVCxLz/Jv0osvMwUFV0pPsg3547L/lXTFPRcd5GaUdZG6v49XmFpTwMYjaF9Ueu5AQvGFECAoMSaziG/fkjUaU0CVi/t/XBfUCFoyuBGfM4c18T7LmBN37Oiym2xem2iwTiNdv7p/zcz/KJmBub5Uq2TZAjRh5kyq1yHg623W67DNL/s9UgAAzXfFJ+PQz1+JzrtBSttRBi7EV/E7ZFXv+XzEb2/u9fKk9wWFt6o3QfkHx9hijkXDJyRIx3vU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(186003)(54906003)(8676002)(26005)(66946007)(4326008)(66556008)(66476007)(66446008)(64756008)(6486002)(966005)(91956017)(76116006)(508600001)(6916009)(86362001)(38100700002)(316002)(44832011)(8936002)(1076003)(83380400001)(71200400001)(5660300002)(6506007)(38070700005)(6512007)(33716001)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XRgYzNXsDK/UIqpS0czmVJW+cDWeXUEueFI1nQDB5td0VJthLeT4M5YKqZNW?=
 =?us-ascii?Q?OUNNy9Yvi0pHy7O1HCw2xA75eGqoXQEOfytBJl9h1+ht2PZ003zuw52sNYnA?=
 =?us-ascii?Q?qIXU+laeLnyEybRxBmx8FX4LDbi1dgn8SHw0KXjHzMXu5PqD5uHs7osb+0cf?=
 =?us-ascii?Q?ixN1EMvsTxoyDIOBbdJygwZW4gDqvqxCj5STWN9OCSGQbFgwTEN6x36pOkjI?=
 =?us-ascii?Q?tbLzWXk55lWXYxO+HLUKzgZR4hJfMeHNsLabMLxb2gEsDwQqVtFQPRYwpexz?=
 =?us-ascii?Q?en6ud0jyoz9aAgg1TkD4b+qPYwLW0POXIFdLQWqe8G6fVTPO8MNu66VTSf9/?=
 =?us-ascii?Q?Jif8VvXpUH864lDvi7uU7LX9ZA7oX1fJWE3L7twcXiRs8NdWuqyRQfyI7Mdz?=
 =?us-ascii?Q?6mkvF6UUa/ai+n5276hXlv90c0Y6PKAnosmIaRy94/cwXJdfEq+0QYGDaEyp?=
 =?us-ascii?Q?rpfQQ/dQQbiY7oR7zDdPrZT2uObgX1Jn8ekExcQ4Xq4N5U/6Hr/q9YxnB5VW?=
 =?us-ascii?Q?o2ICn+rYzXFPOfGnAjs+VpTYojMdg15Z8qhnsIwa2WeNBqtcpFyrwJD7hmad?=
 =?us-ascii?Q?HsUQQ91xmr3SeqSuh4cd3e6+iKocbrjFfdLDIoI2nBxE59UGeaBsH8Nb0kKr?=
 =?us-ascii?Q?Kp1n7D5lNNTlvVoy+BbZlfrNkMmtH+M1oYXqVt+44/PO89W90/6O43NWBe6O?=
 =?us-ascii?Q?Nu0Vs1g2i0Qh4HOTwpx5WmGUZ4z5BPvx1KvirhK3ErFJiLKbto3pyq9BEe/k?=
 =?us-ascii?Q?f2FfNtp/U7bMFi7/ZWnjy84AwvfyzsABmTc2i4dtHBz3nDyJoSNa3vShXSRR?=
 =?us-ascii?Q?ptnXlC/a/ztEm2Nax6W7bdRU9MDNphHYOFLIT/geC5QRkBxvDJv7SE0eDpDB?=
 =?us-ascii?Q?pbnYTRRu6JWQT6/yGhneOZp5JEetYKEa2PP7Q5vzEQK0N5SzsAil9tiQkjWj?=
 =?us-ascii?Q?f54GSmcKFV+saeK8PgiHRa/0S2sn0dw6YYTF/cKPYOoLcYjggurvtL1FClDB?=
 =?us-ascii?Q?0H7sx9aOv4nUdAtM+PgZDJRKgpAKJqiMXXXwaRQ2qqDQB/RRwvRaPYW7pFCO?=
 =?us-ascii?Q?EBqnjRoZi2D4Zq04y3JpVaz9kvK39lAimuIupQcrjDVnSwXKrakM2ei0rdWI?=
 =?us-ascii?Q?hMtxKkowpwKJvIeAKCLDR7ujL4BUQMw0LCp2gVypfSp9JDmXCJIX8G2YHiS1?=
 =?us-ascii?Q?qL9dWpNzdBjm1EDZUTFB4e6YuDSFtyCG6+74PXn+nJGk0V6H5L05OniEK86J?=
 =?us-ascii?Q?n0cv/DwA68yUDx7iFfcJ8Cx6PIRx/h+9TsxM/ZURju2zZTbDwck8QqqT+hUW?=
 =?us-ascii?Q?p7edByLJJ/zUieyp0pH/tHiibkVj3yxEfkpx1LTgEahPBTMUbiX3BrS9ZuoL?=
 =?us-ascii?Q?DrGiBQlXIKnL5L7FBsrdWVnyKY2iZK41JE1lUIckMKpWcY3ubdjMMwkhUWit?=
 =?us-ascii?Q?roqBHHWCdbh3nGuwvU3MMJZgwaPrtfBJAeI06TxMVmGFoCo/hly9ioFija2K?=
 =?us-ascii?Q?uHvJD0Mv2tAlg+Ib5DTs8BXboxyGOJaRZKDQ5xcrseZ5zw0NVnCvf52ANSml?=
 =?us-ascii?Q?+7Rc8IMa+J+vqkXRTgP2bVMr5Od7sHV2RxbhfpnKN56uLEbHY7QlmNuyInp/?=
 =?us-ascii?Q?sthvIBJd7EINYu9FL2ukTRQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1FE637A7AAACE42A902E1A61091E476@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e567aa-a813-4823-c92c-08d9ec7ad367
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 09:50:52.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clJqmeVVOUbJ31CO+MHNsalOIx0eUUKncnYcFeyC9CVjkobBNeLfqEKMVBCf7osFOlOUQXx4FwR8ZgkMlNDg9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7117
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 08:13:41PM -0800, Colin Foster wrote:
> An ongoing workqueue populates the stats buffer. At the same time, a user
> might query the statistics. While writing to the buffer is mutex-locked,
> reading from the buffer wasn't. This could lead to buggy reads by ethtool=
.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Fixes: a556c76adc052 ("net: mscc: Add initial Ocelot switch support")
> Reported-by: Vladimir Oltean <olteanv@gmail.com>

I reported this using vladimir.oltean@nxp.com btw.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

If you hurry and resend this against the "net" tree, you might catch
this week's pull request, since the last one was on Feb 3->4:
https://patchwork.kernel.org/project/netdevbpf/patch/20220204000428.2889873=
-1-kuba@kernel.org/
Then "net" will be merged into "net-next" probably the next day or so,
and you can resend patches 2-5 towards "net-next".

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 455293aa6343..6933dff1dd37 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1737,12 +1737,11 @@ void ocelot_get_strings(struct ocelot *ocelot, in=
t port, u32 sset, u8 *data)
>  }
>  EXPORT_SYMBOL(ocelot_get_strings);
> =20
> +/* Caller must hold &ocelot->stats_lock */
>  static void ocelot_update_stats(struct ocelot *ocelot)
>  {
>  	int i, j;
> =20
> -	mutex_lock(&ocelot->stats_lock);
> -
>  	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
>  		/* Configure the port to read the stats from */
>  		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> @@ -1761,8 +1760,6 @@ static void ocelot_update_stats(struct ocelot *ocel=
ot)
>  					      ~(u64)U32_MAX) + val;
>  		}
>  	}
> -
> -	mutex_unlock(&ocelot->stats_lock);
>  }
> =20
>  static void ocelot_check_stats_work(struct work_struct *work)
> @@ -1771,7 +1768,9 @@ static void ocelot_check_stats_work(struct work_str=
uct *work)
>  	struct ocelot *ocelot =3D container_of(del_work, struct ocelot,
>  					     stats_work);
> =20
> +	mutex_lock(&ocelot->stats_lock);
>  	ocelot_update_stats(ocelot);
> +	mutex_unlock(&ocelot->stats_lock);
> =20
>  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
>  			   OCELOT_STATS_CHECK_DELAY);
> @@ -1781,12 +1780,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocel=
ot, int port, u64 *data)
>  {
>  	int i;
> =20
> +	mutex_lock(&ocelot->stats_lock);
> +
>  	/* check and update now */
>  	ocelot_update_stats(ocelot);
> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)
>  		*data++ =3D ocelot->stats[port * ocelot->num_stats + i];
> +
> +	mutex_unlock(&ocelot->stats_lock);
>  }
>  EXPORT_SYMBOL(ocelot_get_ethtool_stats);
> =20
> --=20
> 2.25.1
>=
