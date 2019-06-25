Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC252174
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfFYEB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:01:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfFYEB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:01:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P3uANV020526;
        Mon, 24 Jun 2019 21:01:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=GfcfDQRRVKhaiR77gujyCNpnMFaovKl6JD3LvQvqAdg=;
 b=vpMx2XEWDU/HS0ps2Wy6TRTuMW2OILVjvsN+g7qM9opVPQlJiDp7cMA0wu55OXOiF7D5
 eLrgWpf5NsF+zeIcGBZWQVuDnHosnnz+NnI++6kYLNFsCnvcWep3z84jdqgdkiBZ0d5g
 vdDoK5F3rEgJM1ANfjdyvh34HO5u0e4kpjA8avTbKOFnKQ3ep5tpwpnMnNynqWya28Rs
 ovNuCbMYqYQ3JS8EyuvxvicpeicdjvFHoYOU1rK5HhwYu8n4WGXhG6W1evruJytiUecD
 /vXnCfsDaJ3C/wk0R1fwON2lb8rRWDEfpGypWOLeIWAXHGVQVnqkJK3wZKXLIfr/Utqs +Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tb2hqj1e6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 21:01:51 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 24 Jun
 2019 21:01:33 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 21:01:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfcfDQRRVKhaiR77gujyCNpnMFaovKl6JD3LvQvqAdg=;
 b=ehwcdYFM0p+40/kNRo4SEJL0xyR4QhbQnpgWReVid7rzQ/45CVyEcAVbb9gHQK/k+TQhZRppNwR0YIybwulau31BxxpmR/dI0d3v9YnSqwlbFZMkieXH3BHcvlpPqC94Ge1DvbyH75RLvrHJYxJFJE81hmhwXyM8KM0CIirfFKk=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2461.namprd18.prod.outlook.com (20.179.81.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 04:01:28 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 04:01:28 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Subject: RE: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Topic: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Index: AQHVKtuKWtZij+tbmkeKy4o7e84z7aarpxRg
Date:   Tue, 25 Jun 2019 04:01:28 +0000
Message-ID: <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190624222356.17037-1-gpiccoli@canonical.com>
In-Reply-To: <20190624222356.17037-1-gpiccoli@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 060b609a-7fcd-4747-4654-08d6f921ccd1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2461;
x-ms-traffictypediagnostic: MN2PR18MB2461:
x-microsoft-antispam-prvs: <MN2PR18MB246189F81C6EC2A35CEC3C36D3E30@MN2PR18MB2461.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(396003)(366004)(136003)(189003)(199004)(13464003)(51914003)(55236004)(3846002)(53936002)(305945005)(33656002)(26005)(2501003)(316002)(81166006)(2906002)(81156014)(71190400001)(54906003)(6246003)(7736002)(66066001)(73956011)(66476007)(66556008)(478600001)(11346002)(66946007)(486006)(74316002)(14454004)(4326008)(64756008)(76116006)(446003)(476003)(52536014)(86362001)(6506007)(66446008)(76176011)(110136005)(229853002)(186003)(9686003)(5660300002)(25786009)(256004)(14444005)(55016002)(8936002)(99286004)(68736007)(6436002)(102836004)(6116002)(7696005)(8676002)(71200400001)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2461;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TslOLHhh2Yh3oIvV1QkUOGGxRO3jOTO3DQN38J5Moa3sK8loNJKEM0KfI5SGSPfcvEbdf9Ut8xB/TeG7UI90v1GmKnlmwh0FVL3Pgij78qQKXb1gPAa5m0FymM7hLuHpwD1lTsETuk7sP2lDuwTkrrplUTNRqEx73UbuMlp/VL4ZXP8W/67YAnlhZOcWnv5f/998zAoIlVOjtOJo1+h1/bVY3I/6PSltGSf2LjS0jec1AT8cr2cmfnxR0OJvSccHEJHfMbgbfTw2HlLnMSmgVbV1nJlrq7U5dAAPBLok/Wa0zzbqpNCXtxq5PHsUVek3xHibvLLuQMMFjtrc44sZt/rh0mWJUIyK2qaeQtGr4/QEjTu5mTqB0F1+EzVTP1TCbbUbjpDzNae8FHH3ElMKVq3ov0ouVvhxvJyb+esO3Dk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 060b609a-7fcd-4747-4654-08d6f921ccd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 04:01:28.3688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2461
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Sent: Tuesday, June 25, 2019 3:54 AM
> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>;
> netdev@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; gpiccoli@canonical.com;
> jay.vosburgh@canonical.com
> Subject: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled
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
> attempts the thread sleeps for an increasing amount of time starting in 5=
0ms
> to give FW some time to perform the timestamping. If it still fails after=
 all
> retries, we bail out in order to prevent an unbound resource consumption
> from bnx2x.

Thanks for your changes and time on this. In general time-latching happens =
in couple or more milliseconds (even in some 100s of usec) under the normal=
 traffic conditions. With this approach, there's a possibility that every p=
acket has to wait for atleast 50ms for the timestamping. This in turn affec=
ts the wait-queue (of packets to be timestamped) at hardware as next TS rec=
ording happens only after the register is freed/read. And also, it incurs s=
ome latency for the ptp applications.

PTP thread is consuming time may be due to the debug messages in this error=
 path, which you are planning address already (thanks!!).
   "Also, I've dropped the PTP "outstanding, etc" messages to debug-level, =
they're quite flooding my log.
Do you see cpu hog even after removing this message? In such case we may ne=
ed to think of other alternatives such as sleep for 1 ms.

Just for the info, the approach continuous-poll-for-timestamp() is used ixg=
be driver (ixgbe_ptp_tx_hwtstamp_work()) as well.

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
> Sudarsana, thanks for the suggestion! I've tried to follow an identical
> approach from [0], but still the ptp thread was consuming a lot of CPU du=
e to
> the good amount of reschedules.
>=20
> I decided then to use the loop approach with small increasing delays, in =
order
> to respect the time FW takes eventually to complete timestamping.
>=20
> Also, I've dropped the PTP "outstanding, etc" messages to debug-level,
> they're quite flooding my log. Cheers!
>=20
> [0] git.kernel.org/pub/scm/linux/kernel/git/davem/net-
> next.git/commit/?id=3D9adebac37e7d
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
> index 03ac10b1cd1e..066b24611890 100644
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
> +	for (i =3D 0; i <=3D 10; i++) {
> +		/* Read Tx timestamp registers */
> +		val_seq =3D REG_RD(bp, port ?
> NIG_REG_P1_TLLH_PTP_BUF_SEQID :
> +				 NIG_REG_P0_TLLH_PTP_BUF_SEQID);
> +		if (val_seq & 0x10000) {
> +			bail =3D false;
> +			break;
> +		}
> +
> +		if (!(i % 5)) /* Avoid log flood */
> +			DP(BNX2X_MSG_PTP, "There's no valid Tx timestamp
> yet\n");
> +		msleep(50 + 25 * i);
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
>  };
>=20
>  struct bnx2x_eth_q_stats {
> --
> 2.22.0

