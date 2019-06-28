Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46EA59359
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1FW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:22:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbfF1FW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:22:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5S5Jbgn009058;
        Thu, 27 Jun 2019 22:22:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=eO0Rkz1FFr+juJIahm25PDtBha6haaPeSrBKDnmkDOg=;
 b=YZjtov6u0gcttgc4STqrPuxoPioSnctGhcUtKBGmvmqm9X0tipEO4lQ9eXbpg4IrtlHs
 ltfFXB0AnDyowwjOIBgHIaG5xTSXo0Qq1gat8BG3k3bvHE8dvCDRzQ/tp8WoXFsZLmh7
 dIoAvUhQvkXhIsvYqxIVKSdSN6H569aNnqBSrCLggEelljejrXP1JLLipUIP7gtCcgSw
 16Ctm8u6TYyjnKzH6ubnbanPgDl2iXTPco2SNSqxwcHCrWUFmlF3TFIXfTYfx19JZyNU
 vuHaE8Gt/TdBclvyldF9olWa8qy0D0nnMPU0bstHrEhTQJzceYbFqDrq77vw7yJicQMR uA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2td6jj1855-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 22:22:53 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 27 Jun
 2019 22:22:52 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.53) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 27 Jun 2019 22:22:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=JAUn341nD8wGlkwYqOe21/AySxArjKJ5xqtOijOlWyTzLSAVOtAhMH23D7T1/d5ChHhgn2khErPJifpK3a9DYdUxGyPCbgtvJ+G13X+jFUKRy1/JYRXj0iE0leL2MCAJJhS/oXrLnr7OcV4y2xLNymZZhUK3upyDgmhnyJcVaeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO0Rkz1FFr+juJIahm25PDtBha6haaPeSrBKDnmkDOg=;
 b=d9tY35Gtb8VBE6M++1GSxyuVY0GuXbKvdw+WHIz3uG8b4wBAtvuIlUMrF7Ch3xmoUh760pZOfO4MCt1fjWYYWhjhlVH8+7a52XXV70vMtIwpDAEUwsOvVY3LFTg9lLV908piDc0Ff1oe8NLaAAcHOTMjgzn1j62oItjo8+HF6y4=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO0Rkz1FFr+juJIahm25PDtBha6haaPeSrBKDnmkDOg=;
 b=Ve2+UAhGmvvpAuM6/oKZkF3h7UdMyQTiMfKEBF8RS+dEC2ON38WBmvmiqsYLKnhFTHeGTAdAmo/R7SacLq7Zsiz0+ni4tWS3bpLFGOOklxLXp1zpLs9Yi7I3t9a+kk5sQ58WM5UJcjEhuZlfHRKzlkl0A3Pxc4brjEWQyrbQ/Qg=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2574.namprd18.prod.outlook.com (20.179.80.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 05:22:47 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.019; Fri, 28 Jun 2019
 05:22:47 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Subject: RE: [EXT] [PATCH V4] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Topic: [EXT] [PATCH V4] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Index: AQHVLQXPAjd+4CkaXE2z8pJMzDSo4qawiACA
Date:   Fri, 28 Jun 2019 05:22:47 +0000
Message-ID: <MN2PR18MB25287DF4D53BCD651E5AC97FD3FC0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190627163133.5990-1-gpiccoli@canonical.com>
In-Reply-To: <20190627163133.5990-1-gpiccoli@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8311e3bf-f630-4fa8-0a75-08d6fb88a847
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2574;
x-ms-traffictypediagnostic: MN2PR18MB2574:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR18MB2574548D4CBC8EED790C5B9BD3FC0@MN2PR18MB2574.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(13464003)(199004)(51914003)(71190400001)(316002)(71200400001)(26005)(2501003)(86362001)(6306002)(33656002)(6246003)(4326008)(966005)(81166006)(55016002)(81156014)(9686003)(2906002)(66066001)(53936002)(102836004)(8936002)(25786009)(99286004)(8676002)(14454004)(68736007)(186003)(7696005)(14444005)(256004)(7736002)(305945005)(5660300002)(6506007)(6436002)(66946007)(73956011)(66446008)(53546011)(110136005)(76116006)(74316002)(66556008)(64756008)(66476007)(11346002)(3846002)(476003)(446003)(6116002)(229853002)(76176011)(54906003)(486006)(52536014)(478600001)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2574;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6uFEnqoMTjvMhUl530o44HpHQbE3OQTeUuFw+Yot7t+HZb4LVIj7AXJu5P5d4oeTl5xpDLjAxq7CA3Wuz+Xc1NaBVIdZMKb2FbxcnjHJNqMH106ZY1BMlASHgcLEm2OZkhxY0PRCU7S/KbuPbGy/TrVMdJnJVgCm59f0jhMjC8+OvEBQ/E8ov9VXxkRSICUegahjagM6x4TLu410CiLIV8bE1mA7oT4h9wzE2lyrwA9T42oaYbhyGpsxF3L5Wcs8pDPZcOqmLBWXjM8QfjFTKarTyDSpqFX/kswY6WaGTRcNNZgJvR0xato6PxGgi72GfnjJCNv/YU7f6xRtGMwAGUf+5lhCqDERRovu+GMCpzU19WStJadUYxxBGk0lmn0BHSIWGXCeb+c+IBe5zghgsDmlc31COl1EiIj3dUkvsJA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8311e3bf-f630-4fa8-0a75-08d6fb88a847
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 05:22:47.5346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2574
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Sent: Thursday, June 27, 2019 10:02 PM
> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>;
> netdev@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; gpiccoli@canonical.com;
> jay.vosburgh@canonical.com
> Subject: [EXT] [PATCH V4] bnx2x: Prevent ptp_task to be rescheduled
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
> Thanks again for your review Sudarsana. I've addressed in this V4 your
> suggestions about removing some debug messages[0].
>=20
> [0] https://marc.info/?l=3Dlinux-netdev&m=3D156165243804760
>=20
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  5 ++-
>  .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  4 ++-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 33 ++++++++++++++----
> -  .../net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  3 ++
>  4 files changed, 34 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 008ad0ca89ba..c12c1bab0fe4 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -3857,9 +3857,12 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff
> *skb, struct net_device *dev)
>=20
>  	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>  		if (!(bp->flags & TX_TIMESTAMPING_EN)) {
> +			bp->eth_stats.ptp_skip_tx_ts++;
>  			BNX2X_ERR("Tx timestamping was not enabled, this
> packet will not be timestamped\n");
>  		} else if (bp->ptp_tx_skb) {
> -			BNX2X_ERR("The device supports only a single
> outstanding packet to timestamp, this packet will not be timestamped\n");
> +			bp->eth_stats.ptp_skip_tx_ts++;
> +			netdev_err_once(bp->dev,
> +					"Device supports only a single
> outstanding packet to timestamp,
> +this packet won't be timestamped\n");
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
> index 03ac10b1cd1e..2cc14db8f0ec 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -15214,11 +15214,24 @@ static void bnx2x_ptp_task(struct work_struct
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
> +		msleep(1 << i);
> +	}
> +
> +	if (!bail) {
>  		/* There is a valid timestamp value */
>  		timestamp =3D REG_RD(bp, port ?
> NIG_REG_P1_TLLH_PTP_BUF_TS_MSB :
>  				   NIG_REG_P0_TLLH_PTP_BUF_TS_MSB);
> @@ -15233,16 +15246,18 @@ static void bnx2x_ptp_task(struct work_struct
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
>  };
>=20
>  struct bnx2x_eth_q_stats {
> --
> 2.22.0

Thanks for the changes.

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
