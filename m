Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7692A3FC3FC
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 10:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhHaHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 03:55:53 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:5122
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240018AbhHaHzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 03:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YH5BvH9U4reQbU0L8DYsOBGgpSeyP20XMSR6Vfn7GEfaBIOoa+P8cCHASel8rHrDRB1yK3DjfROGfTOVKNNwbygcIUzooEb892MCLPC9VUGe3/dzoEm6rg8XX5lZGAgV+z4MOr//F3RiunCFtpB5+FnhwlkLIzzb5UgPPapGFvrTp0gEoI8fyXNeRlz3wobconyZsd6Eiit+4drx36KllaPFKN9gv+g3cmI2XKzwEqRehSYd13VElopAbiotZDGG5npG40kUPdJC+uAVkIf5PydephAqEzsh/t3IEsaLpOW3mQkPSn0LAR5RhUNEY8ACUYiFrw2IYQIMUIPDtKQtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8BrNJ7/bZx4z+IUBnsecWOvrJ4eBtngMgXWvCzwejs=;
 b=mhS9MFwqFyI/Aoqs7nBK/W89rBuO4M6+ChSmssQKGTpToyz3hXoOaMYJrKSVXiORUNZvuPU1L1o/Twg1A8I0jUVGXtUk/ovD/qjdD+AhZNGEn13AftYkDgPNR77Ykh4vaVHAQqww+jEpK5o/7poMbdcQA0TZBrcu+sKzGZYfSH2gN0+FnYGwxqtJ2g+OV3OaXHJLZKcd/m5EZsjJR/1A4MpUkxJv4RJt6vyabdooMkhK38HXdGlpVViWVW3bzd1GXF1+dIkrcZM8mXdDi9HWeW9AEJL4l5eKWkuNhvQLr6EiWRJ9R3TcX4miPNw1sEz2VCwtRtWPjNS/BiZYZ3d6Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8BrNJ7/bZx4z+IUBnsecWOvrJ4eBtngMgXWvCzwejs=;
 b=UlIWO1Hjes6PmTd85sGLcodMufiaMClF4JOMzWSTZe4W5C8yvrJiJ3/2jWtoPengxyMq5uIrhD1PJd+gfUimjopKvw/C0njQslH7GYpucMUomxhQWPcLFnEp0FhuWJV9+VEv6DfS4lv1wON99esqUPBiAO2hkwytN2ufCmrZKLw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 07:54:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 07:54:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAA
Date:   Tue, 31 Aug 2021 07:54:51 +0000
Message-ID: <20210831075450.u7smg5bibz3vvw4q@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dbfe742-0f30-4f61-1943-08d96c549d3b
x-ms-traffictypediagnostic: VE1PR04MB7328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB73288324E3A71FE16A862CB7E0CC9@VE1PR04MB7328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bA3lzDugyxLHosXgF+GU5saFraAYPC2BxF9l8qdjdS8Mbx/+jz7GlJ08Q6cf1aC1jZqmUiVRlcs7LPwkWCi/Wo+Zqxu47lOL60wT+p9yOyYXlv17NVLnrrNquJLmyKxEM0ypacwpFTHh0UfKdGOfidxXzzuVgABhYLFCAb/FHc7haZ0c0S8Tx14aXb4UdSNYbiikFxzKHGqSIt4xC/Yt9aBEZOA1QA2aqKjzYLmZFu0uBGqDdzSN1KbaEr2jF2A/B0VkG+baeO5EUSx3omjh6TkiCdl2OWykBc8K5AQ0gCz4RVHVy+IDiTUSENM/SG86M1F8bk+5le2iiddOOt7vxeTTL4+Jp/bsBX1Qm4E5q6BZnPE2/48ERt4b9G1A+fKO+lbX5HqKx/feVMNpWNoe749Na+K9JlmgJC7N5S5JmdZCPFbC1DVhf1ebAPAgophGtqkVfWk2YI1LoqNBbCItGDEvUFuqR2rlhr4otgLqUbNu8mQUQv90B23ZKh+JjgibWfXvfF8wM5KlxKG+Fej9SxsGsEiLgTxCI1C1m0aXStFsiUHNMtbzgJs+LpyTy84agM7xoHVmkn8q/grpyeMUld4h91pJM4ucXn4H2tpLDq2pvPChEdy4CUMx5zxY3YrXj4EqmkFw/ILlTNpdTow+w+3aUx9YAuxGlzEjMCe+stMIwvelSh7Eytqjr3xpuZ4XQNN0WC1wbA2DuZhRZ4dkRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(316002)(6862004)(1076003)(2906002)(38070700005)(86362001)(6506007)(54906003)(7416002)(122000001)(38100700002)(71200400001)(4326008)(33716001)(66556008)(64756008)(76116006)(66946007)(91956017)(26005)(5660300002)(478600001)(6636002)(44832011)(66446008)(6486002)(9686003)(966005)(8936002)(6512007)(66476007)(186003)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bij1mlhv791IAakkJeKm7ujkVILg9u4LKQ7v4pXN8pHEOsYGd3/N8X4Jbvf8?=
 =?us-ascii?Q?zWi027enX5sXfEnccpdx6uFNc5z5bjpzjVlQZndIRrR4WpSOvvTtHbZzv0Xn?=
 =?us-ascii?Q?Hse/isQ7OSZfzo/5ekD0fLwVPwkrm+nGiFY95U339kDTXK06urlQ960x3wKr?=
 =?us-ascii?Q?aPXwJsHr9pV/a1hi3hOqKq0v8gImwglybOSsprWSEv8aePs7/SaT/+2r7aNT?=
 =?us-ascii?Q?B5zMwJ/i5Q9bIgRrWCITZmyEPkewoJGHHt6iN23ecZsFs/6gsEBf3+9vmHVt?=
 =?us-ascii?Q?2eQL5t5TdUMrT6zNY9xtjzXBI7FrgkDq7p8SsJ5VtQnni929rnPRv6mTzDdT?=
 =?us-ascii?Q?OEeT18T+dm/MAhEousQMzdyhcQAnqrbk9e0blieR9S3iZebJYLeJ868TNHnk?=
 =?us-ascii?Q?fd80puU4/1yAsO7asujlt0s6iyJnkkAQ7Vy2OHG0zH+LddQfw/6WHv1G9sNN?=
 =?us-ascii?Q?Az7MoY01bGXHgVfPjxr2IcXJu+TtRsplmDcg5Uhi6bGThgbD4qXsgrYc+UMG?=
 =?us-ascii?Q?++fKDSruHKk6PC1xadfaoxBc53Jq1/U4K/IBJZWU5Njo95WSGhzaujr368qh?=
 =?us-ascii?Q?lU1iSz0YxWTteq5JMePuFe2vQlIWH8yY4U5uV2G2SD19GqqwBZFAevZU1lmq?=
 =?us-ascii?Q?3QBBA1imSlJj8OjvzufAflExDuvmdDVwUDlUS5iRt3XA2Ns6heu4NiB+H58e?=
 =?us-ascii?Q?2ktQmKwPi5gwbfKB6Xes6WIbuolT1KII2JL4VL2OGQfbg7XBxgwy9fuv5T7y?=
 =?us-ascii?Q?fZej6Z6FZRJMXCSlFG39g0d/NCTgXoM96cKGJKVWsCf6oeBY0fUe+M+1kNv7?=
 =?us-ascii?Q?HPEA5DWqR/eH5oNIQJhghuE9VGWnI+hDYtOf7p0vIcpnIXMKvPGOsjePG/uP?=
 =?us-ascii?Q?TiOmCp2+AJm/k/1YbXvOnN2PNgutneMh11tlJkn3vkhKDTvLVfhVgiLY1J+L?=
 =?us-ascii?Q?Wkhe4I4uoj9Qv1Zmg/GTnxwuD91nWEEWPWR3KG3bviM/HWm+KnoyvwC89Dci?=
 =?us-ascii?Q?4QQm20hAaAXChE05jPcgukK9o7B9lxkkg3GeyhHW+xuzowAXbEp5PV3N50BX?=
 =?us-ascii?Q?yxQ2nOdWrTFUbQAYtmR/KoVczyyBQWT7+KPaS1/+PGK1DkGpJMfMAV1GyPLH?=
 =?us-ascii?Q?xwzTKSHmaAZuNs1Uz0vRokr9NlDp9cZzpQNy8p9mpAfCSzS3FC1qEuMsA6r/?=
 =?us-ascii?Q?/Xdbz7mrOJRP8LVEfvA4NyCfyxEmhmg9OYZwGsMyMxBC170lEivRJym08QD7?=
 =?us-ascii?Q?5JxEt5LT/XYo5bIY3Ngsl08ol9d6ZFyy1MVFIYDsxc7J5bN//dYbt1T8LmBs?=
 =?us-ascii?Q?6koCnW/QqiAl32f+WQZiFWGf?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A66B6898F7BAE4B8C7951D5E8DD182F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbfe742-0f30-4f61-1943-08d96c549d3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 07:54:51.9385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQevIWCM0+36itEM7j395USa2yB88r09W8KkxFjyDdu4w51TjRPLnXYmVp5DVirFNHHggwcGL8rhJTknQnfLBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 11:45:33AM +0800, Xiaoliang Yang wrote:
> +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> +				   struct felix_stream *stream,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct ocelot_mact_entry entry;
> +	u32 row, col, reg, dst_idx;
> +	int ret;
> +
> +	/* Stream identification desn't support to add a stream with non
> +	 * existent MAC (The MAC entry has not been learned in MAC table).
> +	 */

Who will add the MAC entry to the MAC table in this design? The user?

> +	ret =3D ocelot_mact_lookup(ocelot, stream->dmac, stream->vid, &row, &co=
l);
> +	if (ret) {
> +		if (extack)
> +			NL_SET_ERR_MSG_MOD(extack, "Stream is not learned in MAC table");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ocelot_rmw(ocelot,
> +		   (stream->sfid_valid ? ANA_TABLES_STREAMDATA_SFID_VALID : 0) |
> +		   ANA_TABLES_STREAMDATA_SFID(stream->sfid),
> +		   ANA_TABLES_STREAMDATA_SFID_VALID |
> +		   ANA_TABLES_STREAMDATA_SFID_M,
> +		   ANA_TABLES_STREAMDATA);
> +
> +	reg =3D ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
> +	reg &=3D (ANA_TABLES_STREAMDATA_SFID_VALID | ANA_TABLES_STREAMDATA_SSID=
_VALID);
> +	entry.type =3D (reg ? ENTRYTYPE_LOCKED : ENTRYTYPE_NORMAL);

So if the STREAMDATA entry for this SFID was valid, you mark the MAC
table entry as static, otherwise you mark it as ageable? Why?

> +	ether_addr_copy(entry.mac, stream->dmac);
> +	entry.vid =3D stream->vid;
> +
> +	reg =3D ocelot_read(ocelot, ANA_TABLES_MACACCESS);
> +	dst_idx =3D (reg & ANA_TABLES_MACACCESS_DEST_IDX_M) >> 3;
> +
> +	ocelot_mact_write(ocelot, dst_idx, &entry, row, col);
> +
> +	return 0;
> +}
> +
> +static int vsc9959_stream_table_add(struct ocelot *ocelot,
> +				    struct list_head *stream_list,
> +				    struct felix_stream *stream,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct felix_stream *stream_entry;
> +	int ret;
> +
> +	stream_entry =3D kzalloc(sizeof(*stream_entry), GFP_KERNEL);
> +	if (!stream_entry)
> +		return -ENOMEM;
> +
> +	memcpy(stream_entry, stream, sizeof(*stream_entry));
> +
> +	ret =3D vsc9959_mact_stream_set(ocelot, stream, extack);
> +	if (ret) {
> +		kfree(stream_entry);
> +		return ret;
> +	}
> +
> +	list_add_tail(&stream_entry->list, stream_list);
> +
> +	return 0;
> +}
> +
> +static bool vsc9959_stream_table_lookup(struct list_head *stream_list,
> +					struct felix_stream *stream)
> +{
> +	struct felix_stream *tmp;
> +
> +	list_for_each_entry(tmp, stream_list, list)
> +		if (ether_addr_equal(tmp->dmac, stream->dmac) &&
> +		    tmp->vid =3D=3D stream->vid)
> +			return true;
> +
> +	return false;
> +}
> +
> +static struct felix_stream *
> +vsc9959_stream_table_get(struct list_head *stream_list, unsigned long id=
)
> +{
> +	struct felix_stream *tmp;
> +
> +	list_for_each_entry(tmp, stream_list, list)
> +		if (tmp->id =3D=3D id)
> +			return tmp;
> +
> +	return NULL;
> +}
> +
> +static void vsc9959_stream_table_del(struct ocelot *ocelot,
> +				     struct felix_stream *stream)
> +{
> +	vsc9959_mact_stream_set(ocelot, stream, NULL);
> +
> +	list_del(&stream->list);
> +	kfree(stream);
> +}
> +
> +static u32 vsc9959_sfi_access_status(struct ocelot *ocelot)
> +{
> +	return ocelot_read(ocelot, ANA_TABLES_SFIDACCESS);
> +}
> +
> +static int vsc9959_psfp_sfi_set(struct ocelot *ocelot,
> +				struct felix_stream_filter *sfi)
> +{
> +	u32 val;
> +
> +	if (sfi->index > VSC9959_PSFP_SFID_MAX)
> +		return -EINVAL;
> +
> +	if (!sfi->enable) {
> +		ocelot_write(ocelot, ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
> +			     ANA_TABLES_SFIDTIDX);
> +
> +		val =3D ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE);
> +		ocelot_write(ocelot, val, ANA_TABLES_SFIDACCESS);
> +
> +		return readx_poll_timeout(vsc9959_sfi_access_status, ocelot, val,
> +					  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
> +					  10, 100000);
> +	}
> +
> +	if (sfi->sgid > VSC9959_PSFP_GATE_ID_MAX ||
> +	    sfi->fmid > VSC9959_PSFP_POLICER_MAX)
> +		return -EINVAL;
> +
> +	ocelot_write(ocelot,
> +		     (sfi->sg_valid ? ANA_TABLES_SFIDTIDX_SGID_VALID : 0) |
> +		     ANA_TABLES_SFIDTIDX_SGID(sfi->sgid) |
> +		     (sfi->fm_valid ? ANA_TABLES_SFIDTIDX_POL_ENA : 0) |
> +		     ANA_TABLES_SFIDTIDX_POL_IDX(sfi->fmid) |
> +		     ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
> +		     ANA_TABLES_SFIDTIDX);
> +
> +	ocelot_write(ocelot,
> +		     (sfi->prio_valid ? ANA_TABLES_SFIDACCESS_IGR_PRIO_MATCH_ENA : 0) =
|
> +		     ANA_TABLES_SFIDACCESS_IGR_PRIO(sfi->prio) |
> +		     ANA_TABLES_SFIDACCESS_MAX_SDU_LEN(sfi->maxsdu) |
> +		     ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE),
> +		     ANA_TABLES_SFIDACCESS);
> +
> +	return readx_poll_timeout(vsc9959_sfi_access_status, ocelot, val,
> +				  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
> +				  10, 100000);
> +}
> +
> +static int vsc9959_psfp_sfi_table_add(struct ocelot *ocelot,
> +				      struct felix_stream_filter *sfi)
> +{
> +	struct felix_stream_filter *sfi_entry, *tmp;
> +	struct list_head *pos, *q, *last;
> +	struct ocelot_psfp_list *psfp;
> +	u32 insert =3D 0;
> +	int ret;
> +
> +	psfp =3D &ocelot->psfp;
> +	last =3D &psfp->sfi_list;
> +
> +	list_for_each_safe(pos, q, &psfp->sfi_list) {
> +		tmp =3D list_entry(pos, struct felix_stream_filter, list);
> +		if (sfi->sg_valid =3D=3D tmp->sg_valid &&
> +		    sfi->fm_valid =3D=3D tmp->fm_valid &&
> +		    tmp->sgid =3D=3D sfi->sgid &&
> +		    tmp->fmid =3D=3D sfi->fmid) {
> +			sfi->index =3D tmp->index;
> +			refcount_inc(&tmp->refcount);
> +			return 0;
> +		}
> +		/* Make sure that the index is increasing in order. */
> +		if (tmp->index =3D=3D insert) {
> +			last =3D pos;
> +			insert++;
> +		}
> +	}
> +	sfi->index =3D insert;
> +
> +	sfi_entry =3D kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
> +	if (!sfi_entry)
> +		return -ENOMEM;
> +
> +	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
> +	refcount_set(&sfi_entry->refcount, 1);
> +
> +	ret =3D vsc9959_psfp_sfi_set(ocelot, sfi_entry);
> +	if (ret) {
> +		kfree(sfi_entry);
> +		return ret;
> +	}
> +
> +	list_add(&sfi_entry->list, last);
> +
> +	return 0;
> +}
> +
> +static struct felix_stream_filter *
> +vsc9959_psfp_sfi_table_get(struct list_head *sfi_list, u32 index)

This function needs to be introduced in the patch where it is used,
otherwise:
https://patchwork.hopto.org/static/nipa/539543/12466413/build_32bit/stderr

> +{
> +	struct felix_stream_filter *tmp;
> +
> +	list_for_each_entry(tmp, sfi_list, list)
> +		if (tmp->index =3D=3D index)
> +			return tmp;
> +
> +	return NULL;
> +}=
