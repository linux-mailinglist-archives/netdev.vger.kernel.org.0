Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0430494F
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbhAZFd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731933AbhAZBdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:33:42 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C92C0698CA
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:20:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQmktDMLRdqgNvnPnlcNkFHj8+lii0+JEJcgewduk19YDtVil5N7aQ9sSB3iBvy//YoF1/0ccSVYVYq5/TXeEMC1HaFON7CmOn1wRWQ3N9wjOGUhgKNuOMD52ud+05bNiXU98FmdIGSdy/ipMOkqq3FqaZ6G2IxBDnKiRV1XXdVxpbv4lIffzTMMsowOtvyvPDm59/5cRwTLp0oOtTOcpoktbqeSt1W1g8B+akt4QHhiyZD6lgK8hTgy04rfZvBo0HDgZ7//trPPXMTB/2D5EhToeOgVry/Pv3msg6wh+mzoabJWcFABUn4EbTylOcxr3TX8VMlPZyn8YTd+yBbu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKoWuGnyQYkgIDlOnX6Yfrphna/H9FLkvulXMNmhYw4=;
 b=nU3afB0vBrGCVN2LhiV4IKMA8OIrtLjJikytZekUfEEaJnG6IMa/VM7GOSjxPZPuY2h4OV27wKFEpNLSffH4yDHYyyQU2N865Qg0bkK5zifL3ppAvdQoY/vQ1dmdjlAgKTEaZxJ+7VcRDZqB8FxAWSw5GkrD8t0Fpjury0Ozm/7IXrdybjpzq5TZBlyWUsKjfcc1hmvfuSj+925uIcrcQKW12W9PK07xrOj1xkFIev04/x/C9d+U+4veaEejeqfwdgAeFFE17wi+gqnhdvF2KfQ8ZT1CB69ak2y4lEpxiyXvMPeDR/MAjLyeeT0L9/QSnTi9pmzgkIO6aAJCMk8Auw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKoWuGnyQYkgIDlOnX6Yfrphna/H9FLkvulXMNmhYw4=;
 b=NWOoiwsk/XsK85zZtuJsfmz8afLuCaA7xGzRjEhn3SfYzjLjfrIyMu05XixLvOXqaAXnCXmBG04N4aVdyVnEe0heRqxf+sJuhGEvRNUE4/v/ggqm+EC1sxAz2dQEHu5RirR//R1lQtFuPVwvryikV2+ZlbiHhin4Hxilu6cqwbw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 00:32:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Tue, 26 Jan 2021
 00:32:44 +0000
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
Subject: Re: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
Thread-Topic: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
Thread-Index: AQHW8RBJWWRwM35MG0uYfKaT0XnEyqo5E2SA
Date:   Tue, 26 Jan 2021 00:32:44 +0000
Message-ID: <20210126003243.x3c44pmxmieqsa6e@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-7-vinicius.gomes@intel.com>
In-Reply-To: <20210122224453.4161729-7-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0aa56d87-19f1-4343-1720-08d8c191e5f3
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3616DBF8522E04827B1E4DADE0BC0@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rfjeYcTw+a8ch2upcID0vbq8HN9XUmfVKcSNibUpK1AlTwkijrDe8jSr4Nd9DeCwbVWMQwGKp7Cxq18cE02a1JIJhqlNArvYZdMWaedn6R36nKzr+pq1wCUQDgxZSBLlCIWe5rngf7jjPoeNRUwe3jM2M+CoEcG3klp5ykA7ekJWAU+up+4D03RDq72cWpGWBNOyJE/tGzGMrt8/sHTbvqCo1bS7u3GPNK8auatPwq/ftK4qSyAWmkscM9vcriZyCHPTmJkLe8RVePv2JHF2aouPMfBJ5R3zATOPWZ0OYxUInLP/H3Pa2B/3DpSUR2OUbWgDdPCZrEsSrDECwV4f8iZ2TVaYnl7gfLK2dV1fA1IB2f51exSd9bgWvcxdbX4f5XP8sEsh8aTgEqOG+Sd1VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(366004)(396003)(136003)(346002)(39860400002)(4326008)(6916009)(91956017)(33716001)(6486002)(7416002)(76116006)(71200400001)(1076003)(66946007)(6512007)(8936002)(9686003)(66446008)(66476007)(86362001)(83380400001)(316002)(5660300002)(8676002)(66556008)(186003)(478600001)(54906003)(64756008)(6506007)(2906002)(44832011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AoQePBH3dUXe1cB8WO56hxxCCX4kpKXr8OejMylKHPJ70+l6r6Dy38Ws4CTG?=
 =?us-ascii?Q?/VNtC/IV/AuhhKjstVrA5qEcOY2sgJPffkmCcq4cmQTer5AwoZL2aAV7wvju?=
 =?us-ascii?Q?FWNvAijVadr490uj1cjET07chGFARZfYOMYskU/mlrppZ+WbwcVIv2D11Blc?=
 =?us-ascii?Q?EdMnJ/nrlmdtEz4oVYjVw7mHFOy2bqzTdPHixBf9BQCVFWZX8pFcG3Or7MZi?=
 =?us-ascii?Q?n7eTWX9cMswdqkJwTWtXy3ei60KpPUGa3sI8uO6B4OCIHIfNg5ATE497pI5r?=
 =?us-ascii?Q?zTLFBHTl8QD8+7msEYQ6eqyNI+9vZgVJDWGcD4Rtw6G1HVJIQADKpt/p7kRn?=
 =?us-ascii?Q?tsisCS0qHCeV7Zo7NwJZ3nQICtZ6J2ez8irVBtjCoeJ+75rlQZZqzXkUTtcM?=
 =?us-ascii?Q?vpAllCrmfckPp6jQZQhILymVrTVuJiN4cqep2ODwmIkmOEz0Rppod5kSrkbS?=
 =?us-ascii?Q?67XCwBofP6PzglnexzrSX3bJ7YYMjWdtlNof0d5o6/GDRmLVu+lyOXpqqj5g?=
 =?us-ascii?Q?73H7wFSdxz5MMiVHSg6OnLEvFjNhyte7kegdVoZnMTE/5UK0TqFkdEIxz5d4?=
 =?us-ascii?Q?IlOC7VbWTfX0cxWMGtBD9Fqm5kYsr9D4LlGhTG+tECWL4HGR4DopcHnajcdP?=
 =?us-ascii?Q?2whbFACZnAL9bPaMQZByrOuJsgyNv4k7/qkba7imWQWJ25VBNlGSXIMBYxF2?=
 =?us-ascii?Q?ENJnxRTHyp4+z+n8G3igtgWhl+nDdF3MTh6CAMcNCVf2fmb/K9by5YupoIz5?=
 =?us-ascii?Q?aPUeH35ewoa4QR0WwCMADSvoxIJFI9S3olze2DbWeTLRnsnWGSSYpjeceolS?=
 =?us-ascii?Q?9nOkHEzE9xQEml/PQMS0t7blr6MoQkjIHnJLG/DkZoCeU6QyWVZwkaxaEhlK?=
 =?us-ascii?Q?GTIMVE5FfQuA7TTjJwfiGIGkS3N1DzwaD5pED3Z8YjfDpVRZ4q3WHtRVpy8X?=
 =?us-ascii?Q?OgI1nn5zFNbQ1T+gZ4gbSzCXXYLzP951Jt6JCnqYTe15bZo0zGgxmYqsLkgi?=
 =?us-ascii?Q?TaXdldlsFZX/E6NqgTe1nBiwHm2KcUaYPX+pmGAgmcq1GTW8BNr9Gw5HtdA2?=
 =?us-ascii?Q?CWhSrd6Q?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <049A3FC0022CD94EB1606346C797E095@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa56d87-19f1-4343-1720-08d8c191e5f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 00:32:44.3908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pA696OFStsoOtkpQp+zo3jV5udRiyl/YlLTvT4SGdfXOGieBkfu79s3ahLGa3nR8oyqLy5UezjLaiNLE7PwRKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:44:51PM -0800, Vinicius Costa Gomes wrote:
> The tc subsystem sets which queues are marked as preemptible, it's the
> role of ethtool to control more hardware specific parameters. These
> parameters include:
>=20
>  - enabling the frame preemption hardware: As enabling frame
>  preemption may have other requirements before it can be enabled, it's
>  exposed via the ethtool API;
>=20
>  - mininum fragment size multiplier: expressed in usually in the form
>  of (1 + N)*64, this number indicates what's the size of the minimum
>  fragment that can be preempted.

And not one word has been said about the patch...

>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h         | 12 +++++
>  drivers/net/ethernet/intel/igc/igc_defines.h |  4 ++
>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 53 ++++++++++++++++++++
>  drivers/net/ethernet/intel/igc/igc_tsn.c     | 25 +++++++--
>  4 files changed, 91 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/=
intel/igc/igc.h
> index 35baae900c1f..1067c46e0bc2 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -87,6 +87,7 @@ struct igc_ring {
>  	u8 queue_index;                 /* logical index of the ring*/
>  	u8 reg_idx;                     /* physical index of the ring */
>  	bool launchtime_enable;         /* true if LaunchTime is enabled */
> +	bool preemptible;		/* true if not express */

Mixing tabs and spaces?

> +static int igc_ethtool_set_preempt(struct net_device *netdev,
> +				   struct ethtool_fp *fpcmd,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct igc_adapter *adapter =3D netdev_priv(netdev);
> +	int i;
> +
> +	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
> +		return -EINVAL;
> +	}

This check should belong in ethtool, since there's nothing unusual about
this supported range.

Also, I believe that Jakub requested the min-frag-size to be passed as
0, 1, 2, 3 as the standard specifies it, and not its multiplied version?

> +
> +	adapter->frame_preemption_active =3D fpcmd->enabled;
> +	adapter->add_frag_size =3D fpcmd->add_frag_size;
> +
> +	if (!adapter->frame_preemption_active)
> +		goto done;
> +
> +	/* Enabling frame preemption requires TSN mode to be enabled,
> +	 * which requires a schedule to be active. So, if there isn't
> +	 * a schedule already configured, configure a simple one, with
> +	 * all queues open, with 1ms cycle time.
> +	 */
> +	if (adapter->base_time)
> +		goto done;

Unless I'm missing something, you are interpreting an adapter->base_time
value of zero as "no Qbv schedule on port", as if it was invalid to have
a base-time of zero, which it isn't.

> @@ -115,6 +130,9 @@ static int igc_tsn_enable_offload(struct igc_adapter =
*adapter)
>  		if (ring->launchtime_enable)
>  			txqctl |=3D IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
> =20
> +		if (ring->preemptible)
> +			txqctl |=3D IGC_TXQCTL_PREEMPTABLE;

I think this is the only place in the series where you use PREEMPTABLE
instead of PREEMPTIBLE.

> +
>  		wr32(IGC_TXQCTL(i), txqctl);
>  	}

Out of curiosity, where is the ring to traffic class mapping configured
in the igc driver? I suppose that you have more rings than traffic classes.=
