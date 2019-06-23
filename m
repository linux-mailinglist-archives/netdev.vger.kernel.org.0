Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5284FA54
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 07:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFWFN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 01:13:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22744 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfFWFN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 01:13:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5N5BqCc014275;
        Sat, 22 Jun 2019 22:13:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=JzQn7Zw63SN90S/kzLlW41C6OrzHaH237adHT8mJjVo=;
 b=aCbgzxTJfHdzW1EwDNvTYOQyXn31VLGz6OG2BVoXjYA0dEo67UbKJX9Irwb8aH+IiHEP
 GCJ2prAvhAR7dPmje+vRTRUOcSwvHa5JqkLC8k9AoN3E0r9xPLE8/d0hgUSr7QNrmKxD
 VWD3ukas7rdEY3L1FYor6r3v0LMGnhCHO5cnSTmLjijMc1YUDL2Z1KGkNUaTQgtyZe4A
 n9OX17k60wZSBVMLToZESN5H3ZcDQMQz2qY2CnPWc2wpBrbEZmP06I9B9LZe6sQm490T
 1vr5m+IDsf9UeJ6U6RHTc8elwp/Ji9oKnRIun4VLI89K7PfcGelyNWQngGNqGaSztNdp 1w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t9kuja8x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 22 Jun 2019 22:13:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 22 Jun
 2019 22:13:23 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 22 Jun 2019 22:13:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzQn7Zw63SN90S/kzLlW41C6OrzHaH237adHT8mJjVo=;
 b=a256c6BnqPoog11Pk421z7WGrcX5wH+DHjVRXypzetYqOjJvtz8z1BV2Xf5I59At1Uf0gLP5F1KwWzJIoZgf4Z/Dw0h5j/R6hmLVRFRoDtoHbLQ46OHLOvSsp+zb8wyBsKSUVC+V5jJZk3dONlLMVT3KHijtb+jKZAZOOadtjoY=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2414.namprd18.prod.outlook.com (20.179.81.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sun, 23 Jun 2019 05:13:21 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.014; Sun, 23 Jun 2019
 05:13:20 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Subject: RE: [EXT] [PATCH] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Topic: [EXT] [PATCH] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Index: AQHVKHgF+Y8g5SZqikCOpgE9QV1RL6aoq0zA
Date:   Sun, 23 Jun 2019 05:13:20 +0000
Message-ID: <MN2PR18MB2528C51C0A23D9FA7744D883D3E10@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190621212634.25441-1-gpiccoli@canonical.com>
In-Reply-To: <20190621212634.25441-1-gpiccoli@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:50a:5206:537:cc1e:ecd:f48b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0320f839-faba-4742-9ac3-08d6f799826b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2414;
x-ms-traffictypediagnostic: MN2PR18MB2414:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR18MB2414ECE6A1745175B8FDEDD2D3E10@MN2PR18MB2414.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(136003)(39850400004)(199004)(189003)(13464003)(186003)(53936002)(256004)(14444005)(71200400001)(6506007)(52536014)(99286004)(5660300002)(102836004)(76176011)(53546011)(66946007)(6436002)(55016002)(25786009)(66446008)(2501003)(86362001)(66476007)(66556008)(64756008)(73956011)(76116006)(8676002)(9686003)(6306002)(966005)(6246003)(6116002)(478600001)(33656002)(316002)(8936002)(81166006)(7696005)(4326008)(229853002)(14454004)(81156014)(11346002)(446003)(476003)(486006)(305945005)(54906003)(110136005)(68736007)(2906002)(71190400001)(46003)(74316002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2414;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EOnPj6FKoG9AyB3U96uSeGOjZFguaC4ED+Xum2NWG2isMvqjqf1N00h0mYNHazJWl+SkXIVr41CyqYv1McD1gHWIEZvAkYbuyMu7/X3pD06GN3S7lDeSHyWhYFjhPh6EaTZ8AvMYfok/tuZrO6wd6qoqANtkhEDk8KJAoILyiQ0eYiDy5Ap6fg/KmkdQ6Z/JT09+1Kos8Bowp4GReIAEC5bt2Yd0zflyk1Xt1uSVJTTdDrXVOQ5KNpiqKoR8pBtwbLYHvz5UYXiDt7EZtF5oBRguJEq2Is3sBRavTl+69AqU6+SSgS/tfWrNI+lIveCFrzKSU/xw+3SU17/xcNa/aLnuYvRwTzxrYubBAsTARUkctBKXb/bwajolmizsp+miRMY9SlsUPsTWxpxkmaBBf4kQ+jQucIVl3o5hVrhxLec=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0320f839-faba-4742-9ac3-08d6f799826b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 05:13:20.7692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2414
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-23_03:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Sent: Saturday, June 22, 2019 2:57 AM
> To: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>;
> netdev@vger.kernel.org
> Cc: Ariel Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru
> <skalluru@marvell.com>; gpiccoli@canonical.com;
> jay.vosburgh@canonical.com
> Subject: [EXT] [PATCH] bnx2x: Prevent ptp_task to be rescheduled indefini=
tely
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
> zeroed; this isn't reproducible for example with linuxptp since this tool
> request a supported RX filter. It seems the NIC HW timestamp mechanism
> cannot work well with RX_FILTER_NONE - in driver's PTP filter initializat=
ion
> routine, when there's not a supported filter request the function does no=
t
> perform a specific register write to the adapter.
>=20
> This patch addresses the problem of the everlasting reschedule of the ptp
> worker by limiting that to 3 attempts (the first one plus two reschedules=
), in
> order to prevent the unbound resource consumption from the driver. It's n=
ot
> correct behavior for a driver to not take into account potential problems=
 in a
> routine reading a device register, be it an invalid RX filter (leading to=
 a non-
> functional HW clock) or even a potential device FW issue causing the regi=
ster
> value to be wrong, hence we believe the fix is relevant to ensure proper
> driver behavior.
>=20
> This has no functional change in the succeeding path of the HW
> timestamping code in the driver, only portion of code it changes is the e=
rror
> path for TX timestamping. It was tested using both linuxptp and chrony.
>=20
> Reported-and-tested-by: Przemyslaw Hausman
> <przemyslaw.hausman@canonical.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h    |  1 +
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  1 +
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 18 +++++++++++++-----
>  3 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> index 6026b53137aa..349965135227 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> @@ -1838,6 +1838,7 @@ struct bnx2x {
>  	bool timecounter_init_done;
>  	struct sk_buff *ptp_tx_skb;
>  	unsigned long ptp_tx_start;
> +	u8 ptp_retry_count;
>  	bool hwtstamp_ioctl_called;
>  	u16 tx_type;
>  	u16 rx_filter;
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 008ad0ca89ba..990ec049f357 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -3865,6 +3865,7 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb,
> struct net_device *dev)
>  			/* schedule check for Tx timestamp */
>  			bp->ptp_tx_skb =3D skb_get(skb);
>  			bp->ptp_tx_start =3D jiffies;
> +			bp->ptp_retry_count =3D 0;
>  			schedule_work(&bp->ptp_task);
>  		}
>  	}
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 03ac10b1cd1e..872ae672faaa 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -15233,16 +15233,24 @@ static void bnx2x_ptp_task(struct work_struct
> *work)
>  		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
>  		shhwtstamps.hwtstamp =3D ns_to_ktime(ns);
>  		skb_tstamp_tx(bp->ptp_tx_skb, &shhwtstamps);
> -		dev_kfree_skb_any(bp->ptp_tx_skb);
> -		bp->ptp_tx_skb =3D NULL;
> -
>  		DP(BNX2X_MSG_PTP, "Tx timestamp, timestamp cycles =3D
> %llu, ns =3D %llu\n",
>  		   timestamp, ns);
> +		goto clear;
>  	} else {
>  		DP(BNX2X_MSG_PTP, "There is no valid Tx timestamp
> yet\n");
> -		/* Reschedule to keep checking for a valid timestamp value
> */
> -		schedule_work(&bp->ptp_task);
> +		/* Reschedule twice to check again for a valid timestamp */
> +		if (++bp->ptp_retry_count < 3) {
> +			schedule_work(&bp->ptp_task);
> +			return;
> +		}
> +		DP(BNX2X_MSG_PTP, "Gave up Tx timestamp, register read
> %u\n", val_seq);
> +		netdev_warn_once(bp->dev,
> +				 "Gave up Tx timestamp, register read %u\n",
> val_seq);
>  	}
> +clear:
> +	dev_kfree_skb_any(bp->ptp_tx_skb);
> +	bp->ptp_tx_skb =3D NULL;
> +	bp->ptp_retry_count =3D 0;
>  }
>=20
>  void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb)
> --
> 2.21.0

Thanks for uncovering this issue, and the fix.
With the proposed fix, if HW latches the timestamp after 3 iterations then =
it would lead to erroneous PTP functionality. When driver receives the next=
 PTP packet, driver sees that timestamp is available in the register and wo=
uld assign this value (which corresponds to last/skipped ptp packet) to the=
 PTP packet. In general, FW takes around 1ms to 100ms to perform the timest=
amp and may take more. Hence the promising solution for this issue would be=
 to wait for timestamp for particular period of time. If Tx timestamp is no=
t available for a pre-determined max period, then declare it as an error sc=
enario and terminate the thread.

Just for the reference, similar fix was added for Marvell qede driver recen=
tly. Patch details are,
9adebac37e7d: (qede: Handle infinite driver spinning for Tx timestamp.)
https://www.spinics.net/lists/netdev/msg572838.html

