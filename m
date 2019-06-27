Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524F957FF1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfF0KJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:09:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10490 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbfF0KJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:09:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RA9tgf010894;
        Thu, 27 Jun 2019 03:09:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=DBiNtqiYixYNi4S+vgJ1rXn0jsFqemsuJ5pMPh4P0EI=;
 b=SQbv0bbw6Ex4aaOylwhSzhylKOaJjwoAIt/XerGmS1TUFn1coiTLkxgAMDAmk0dVafpV
 g5fOD0XCmkHY3VV8bIpiNFIJy7qvyHHom6+EM+Xj0kvwCHFzGwZ5ZjdIUuT42SpJs0Si
 VbsNebMIdsW0ZExmPFXIdvf4LkQZxrTge9CRPb92HwRdTaGlI8AsK6PD2oE6vZOIj+Oy
 wlQkAhGd70d7nF9o9jl9BLCz3b8qvvnaSuExOVL625zZqPC1vSDt/HmMPe7z9HGEr+EH
 OgNBfyYmmtrS6rcVwOPFG/Z8RnkMrUxr50duj/B04FEhNydEK5DR6wzYVvzcFdkVdglx 3A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tch69afks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 03:09:51 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 27 Jun
 2019 03:09:50 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.55) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 27 Jun 2019 03:09:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBiNtqiYixYNi4S+vgJ1rXn0jsFqemsuJ5pMPh4P0EI=;
 b=bbign7Y3d8GTZDmB2MThqLCuvQ92VDR2WGOkaFUpACthOD+SSbNTsRu1nVkKNLxGMzeZuv59HRoHdZj0b4rZmSB1rglufkXT2JMd4BfkFnUFJktl8JbFNUDyoFNPLmlRofSD4VzgfqW+HssebM1hX2xOVwUHfrLPWgWA1sissVQ=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2542.namprd18.prod.outlook.com (20.179.82.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 10:09:44 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 10:09:44 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Subject: RE: [EXT] [PATCH V3] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Topic: [EXT] [PATCH V3] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Index: AQHVLFxdrdFAE8TBfEilxbyrXunpSKavMjaw
Date:   Thu, 27 Jun 2019 10:09:44 +0000
Message-ID: <MN2PR18MB2528E0CB660FC35C475816E1D3FD0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190626201835.31660-1-gpiccoli@canonical.com>
In-Reply-To: <20190626201835.31660-1-gpiccoli@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 578ff743-0fe2-4f01-6aca-08d6fae793fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2542;
x-ms-traffictypediagnostic: MN2PR18MB2542:
x-microsoft-antispam-prvs: <MN2PR18MB25424703165C455B18B25A7ED3FD0@MN2PR18MB2542.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(346002)(396003)(199004)(189003)(13464003)(64756008)(54906003)(110136005)(71190400001)(71200400001)(66946007)(73956011)(76116006)(256004)(14444005)(316002)(2501003)(6116002)(3846002)(33656002)(66476007)(66556008)(66446008)(52536014)(6436002)(446003)(9686003)(55016002)(11346002)(25786009)(486006)(305945005)(7736002)(74316002)(229853002)(2906002)(5660300002)(476003)(478600001)(66066001)(53936002)(6246003)(102836004)(8676002)(81156014)(81166006)(6506007)(14454004)(55236004)(53546011)(86362001)(26005)(186003)(8936002)(7696005)(4326008)(68736007)(76176011)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2542;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7RALmgiplg95ZJ0IMCGq6G+igSpPYWBC8PQmTOBJL76RbKoGzm8zkdyt+JDvAGefFI/3es88WlYy/yllwcys8IB5/FTWuNOAE+djR4n3HYldXAEqqlGRyBDhbyI/mYn3I2JLX7hIfiiwHT1eO+oA9sfwJI+1p2WweEmwuFWolTUg/nF13RMo2b8nPS7aHtZeowW4kTYJaBuJLpCn5iE8z8lCuiQm5qwps8nD5JpUOpONyGKSqPXSznYSWYKczEXsrmNRatP5M0wWcoxCeEqbBNfTH7cKHeF6a9t5ImgOMN92gwCaD5sKZToDcKFxu3HVUbt3jv3bd6V6AFm9fluVjielts+e/Wf9ivYnS42a6xemPre7O4ioHjGaQ1FXXHAwvYXdMMYdRj1vO69hVU0SKdffStpUJkD8L4dYSLsNpRk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 578ff743-0fe2-4f01-6aca-08d6fae793fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 10:09:44.5448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2542
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Sent: Thursday, June 27, 2019 1:49 AM
> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>;
> netdev@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; gpiccoli@canonical.com;
> jay.vosburgh@canonical.com
> Subject: [EXT] [PATCH V3] bnx2x: Prevent ptp_task to be rescheduled
> indefinitely
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Currently bnx2x ptp worker tries to read a register with timestamp
> information in case of TX packet timestamping and in case it fails, the r=
outine
> reschedules itself indefinitely. This was reported as a kworker always at=
 100%
> of CPU usage, which was narrowed down to be bnx2x ptp_task.
>=20
> By following the ioctl handler, we could narrow down the problem to an NT=
P
> tool (chrony) requesting HW timestamping from bnx2x NIC with RX filter
> zeroed; this isn't reproducible for example with ptp4l (from linuxptp) si=
nce
> this tool requests a supported RX filter.
> It seems NIC FW timestamp mechanism cannot work well with
> RX_FILTER_NONE - driver's PTP filter init routine skips a register write =
to the
> adapter if there's not a supported filter request.
>=20
> This patch addresses the problem of bnx2x ptp thread's everlasting
> reschedule by retrying the register read 10 times; between the read
> attempts the thread sleeps for an increasing amount of time starting in 1=
ms
> to give FW some time to perform the timestamping. If it still fails after=
 all
> retries, we bail out in order to prevent an unbound resource consumption
> from bnx2x.
>=20
> The patch also adds an ethtool statistic for accounting the skipped TX
> timestamp packets and it reduces the priority of timestamping error
> messages to prevent log flooding. The code was tested using both linuxptp
> and chrony.
>=20
> Reported-and-tested-by: Przemyslaw Hausman
> <przemyslaw.hausman@canonical.com>
> Suggested-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>=20
> Sudarsana, thanks again for your feedback. I've reduced the sleep times t=
o
> start in 1ms and goes up to 512ms - the sum of sleep times is 1023ms, but
> due to the inherent overhead in sleeping/waking-up procedure, I've
> measured the total delay in the register read loop (on bnx2x_ptp_task) to=
 be
> ~1.6 seconds.  It is almost the 2s value you first suggested as PTP_TIMEO=
UT.
>=20
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 12 +++++--
>  .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  4 ++-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 36 ++++++++++++++----
> -  .../net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  3 ++
>  4 files changed, 43 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 008ad0ca89ba..6751cd04e8d8 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -3857,9 +3857,17 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff
> *skb, struct net_device *dev)
>=20
>  	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>  		if (!(bp->flags & TX_TIMESTAMPING_EN)) {
> -			BNX2X_ERR("Tx timestamping was not enabled, this
> packet will not be timestamped\n");
> +			bp->eth_stats.ptp_skip_tx_ts++;
> +			netdev_err_once(bp->dev,
> +					"Tx timestamping isn't enabled, this
> packet won't be timestamped\n");
> +			DP(BNX2X_MSG_PTP,
> +			   "Tx timestamping isn't enabled, this packet won't
> be
> +timestamped\n");

Hitting this path is very unlikely and also PTP packets arrive once in a se=
cond in general. Either retain BNX2X_ERR() statement or remove the extra ca=
ll netdev_err_once().

>  		} else if (bp->ptp_tx_skb) {
> -			BNX2X_ERR("The device supports only a single
> outstanding packet to timestamp, this packet will not be timestamped\n");
> +			bp->eth_stats.ptp_skip_tx_ts++;
> +			netdev_err_once(bp->dev,
> +					"Device supports only a single
> outstanding packet to timestamp, this packet won't be timestamped\n");
> +			DP(BNX2X_MSG_PTP,
> +			   "Device supports only a single outstanding packet to
> timestamp,
> +this packet won't be timestamped\n");
Same as above.

>  		} else {
>  			skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
>  			/* schedule check for Tx timestamp */ diff --git
> a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> index 51fc845de31a..4a0ba6801c9e 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> @@ -182,7 +182,9 @@ static const struct {
>  	{ STATS_OFFSET32(driver_filtered_tx_pkt),
>  				4, false, "driver_filtered_tx_pkt" },
>  	{ STATS_OFFSET32(eee_tx_lpi),
> -				4, true, "Tx LPI entry count"}
> +				4, true, "Tx LPI entry count"},
> +	{ STATS_OFFSET32(ptp_skip_tx_ts),
> +				4, false, "ptp_skipped_tx_tstamp" },
>  };
>=20
>  #define BNX2X_NUM_STATS		ARRAY_SIZE(bnx2x_stats_arr)
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 03ac10b1cd1e..af6e7a950a28 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -15214,11 +15214,27 @@ static void bnx2x_ptp_task(struct work_struct
> *work)
>  	u32 val_seq;
>  	u64 timestamp, ns;
>  	struct skb_shared_hwtstamps shhwtstamps;
> +	bool bail =3D true;
> +	int i;
>=20
> -	/* Read Tx timestamp registers */
> -	val_seq =3D REG_RD(bp, port ? NIG_REG_P1_TLLH_PTP_BUF_SEQID :
> -			 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
> -	if (val_seq & 0x10000) {
> +	/* FW may take a while to complete timestamping; try a bit and if it's
> +	 * still not complete, may indicate an error state - bail out then.
> +	 */
> +	for (i =3D 0; i < 10; i++) {
> +		/* Read Tx timestamp registers */
> +		val_seq =3D REG_RD(bp, port ?
> NIG_REG_P1_TLLH_PTP_BUF_SEQID :
> +				 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
> +		if (val_seq & 0x10000) {
> +			bail =3D false;
> +			break;
> +		}
> +
> +		if (!(i % 4)) /* Avoid log flood */
> +			DP(BNX2X_MSG_PTP, "There's no valid Tx timestamp
> yet\n");
This debug statement is not required as we anyway capture it in the error p=
ath below.

> +		msleep(1 << i);
> +	}
> +
> +	if (!bail) {
>  		/* There is a valid timestamp value */
>  		timestamp =3D REG_RD(bp, port ?
> NIG_REG_P1_TLLH_PTP_BUF_TS_MSB :
>  				   NIG_REG_P0_TLLH_PTP_BUF_TS_MSB);
> @@ -15233,16 +15249,18 @@ static void bnx2x_ptp_task(struct work_struct
> *work)
>  		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
>  		shhwtstamps.hwtstamp =3D ns_to_ktime(ns);
>  		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
> -		dev_kfree_skb_any(bp->ptp_tx_skb);
> -		bp->ptp_tx_skb =3D NULL;
>=20
>  		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles =3D
> %llu, ns =3D %llu\n",
>  		   timestamp, ns);
>  	} else {
> -		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp
> yet\n");
> -		/* Reschedule to keep checking for a valid timestamp value
> */
> -		schedule_work(&bp->ptp_task);
> +		DP(BNX2X_MSG_PTP,
> +		   "Tx timestamp is not recorded (register read=3D%u)\n",
> +		   val_seq);
> +		bp->eth_stats.ptp_skip_tx_ts++;
>  	}
> +
> +	dev_kfree_skb_any(bp->ptp_tx_skb);
> +	bp->ptp_tx_skb =3D NULL;
>  }
>=20
>  void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb) diff --git
> a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
> index b2644ed13d06..d55e63692cf3 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h
> @@ -207,6 +207,9 @@ struct bnx2x_eth_stats {
>  	u32 driver_filtered_tx_pkt;
>  	/* src: Clear-on-Read register; Will not survive PMF Migration */
>  	u32 eee_tx_lpi;
> +
> +	/* PTP */
> +	u32 ptp_skip_tx_ts;
The value need to be cleared in the case of internal reload e.g., mtu chang=
e, ifconfig-down/up. If this is not happening, please reset it in the nic l=
oad path.

>  };
>=20
>  struct bnx2x_eth_q_stats {
> --
> 2.22.0

