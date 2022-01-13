Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6509948D6F1
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 12:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiAMLxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 06:53:11 -0500
Received: from mail-dm3nam07on2060.outbound.protection.outlook.com ([40.107.95.60]:33824
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231868AbiAMLxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 06:53:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5xyR7dvDMYZDZWkJcqJlDCUpnIiiTnFKjCrznENY+brrd/79hXdYNMXHhJ9eHc6VwXAGZNfdWzZRbNKqs2CJ+GDvvlVXHLKBUk8jjgGsrKrEAoShTx57we6WoYeKeVOJsJ2A+jPxqnu09+m32t2KaPxpqDnBYtLcPdr35cAfbcFvZk91S787lJHkvjZBKuyCGvVTa7xonxzM2NvufSxTRcrbJ3H2Fax3khQx+UsOXiwZ8J0BUbPo2cjs+nBO5qDJZajXY2izk4ZeWeTI5Ms2qK/7mEVgB8COPDndm51GKiAHY3N+4CuT/V8UQ2jN50wfdlzDKNEzh8qcF8E4t/F0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lElpldeFHIuGcl3qrOa4HBPMzVl3DtMO/gvc10kpI0=;
 b=j3FqMDOiqPOwrOP5a55La1UlFGPw92tU8HNTh+kmOXuxvmI/2em+CZihlY2c66qiCmGZVBHTXmb/Rad5cRGyhffdWCbIKP9S8/gMtrwCq6I+RJgYB6eiz/dvGKzU4PH1npep8zBlUuRHj7ELK0S0ybLoWanYOunKUPkVglc6/qs2LqmglkbEIf1ZHNNgpaXWarRdBqWFb1PvxhDFsyyupCMRH5i65ERfh+SDoaXfWgA2Wr/ZiJJhOTGJtHtOUUCOIBxZzm+fTi5/6DnyXCf/SBanKXr4HHWmdN2T/OtRJkCxgM+rGBNzjhMelwEMJAuBbiO/EA/PM75i7RyhYjuwDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lElpldeFHIuGcl3qrOa4HBPMzVl3DtMO/gvc10kpI0=;
 b=iBRfEeI2/lu+soJCUh8MQYj1ziII7F91VFhrRM3qBqBXAlij3dS088JT9vHKxqVYFYzAGlCsEULKZX+vSA+HZaD+k00/K1JKXNDszPes1L5v7WcEGeybn2xOsAwMyVpMT/iyj/Vq0IdNAX5mF70HUPCtjr2ay0NtTINuCZ8/g/Q=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BYAPR02MB4919.namprd02.prod.outlook.com (2603:10b6:a03:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 13 Jan
 2022 11:53:06 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 11:53:06 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michals@xilinx.com>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Topic: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Thread-Index: AQHYB9s2rj4tGsjvk0qQz4QEeERkwKxg0wQg
Date:   Thu, 13 Jan 2022 11:53:06 +0000
Message-ID: <SA1PR02MB8560F3EF51828D9065763968C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-3-robert.hancock@calian.com>
In-Reply-To: <20220112173700.873002-3-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9505ad4-77c1-49c2-88c7-08d9d68b4333
x-ms-traffictypediagnostic: BYAPR02MB4919:EE_
x-microsoft-antispam-prvs: <BYAPR02MB4919966888E95C58358BED9CC7539@BYAPR02MB4919.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RxtpBObIgWCae8e+diZokcIoHyJrd2O8BX7Q+xw6s6mKmoz8yI1nStP+oAQEqeDYtU9jmeUJq11JesROwKaGGMwHBQsWlk69IJRdAX+WTzXzhAofB3mE5TNw6JKeANdPi1yNj6twnzZDfst2V33NDgRBElqTGztFYoiiLLmLPjWw6rdukhSHNzrS3qdnn9AZkLVHMqbXfd1ej4IjFr1qSJj0Cbsk+yCDdIY0oCERj3xY+fZUIV5mfldh9mTNXnINEAcC8Sy9+dC1cUnQOanZ7bh0fTMTPw+XrI99y5a2clRElioNfwtUq/i24l6pwY7UBu3tHDhDKwJEi7L7dz+cEvuacj4lRFM647DOffZ/navJYicqbqyJLFzju+xkU/hklpH73mv2HaTboSkIr3AL+pz0mJS5g0Ym75umTeL4bBubA+ppNue3a9JwgySVUwr98rQ6udUcPhfM0+YquhxmUAQetuWXpD2GNzOi8hbnBw3W0LmWEc6TpE3HGJV7lvb7njPL+DfBR4enkZhhiJZyK4Z2utdFp9QEO2U6DO21cKCcdwEcPDHMlQr7nOXtmeE6/yt62LM/vEYaTJGfgFnwZ7lxwqDghu8ZsKlabCXmdTH8rsbpjy9ggUFHnJjJxT2D8GnEBtzWtW19/gnU/V8rN8Wcasqktyxss6bsevrU9M0qLeSaGh9f1K8yoGMZKZc5xf+/6BJcox8Pr0SVjSJUaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(54906003)(76116006)(66446008)(66556008)(64756008)(83380400001)(8936002)(5660300002)(33656002)(110136005)(508600001)(2906002)(316002)(8676002)(26005)(186003)(6506007)(52536014)(4326008)(38070700005)(71200400001)(107886003)(86362001)(122000001)(55016003)(38100700002)(9686003)(7696005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rKW4cqDSyIKxxW71s1zDs3n7g7eKXVCdE19ZXa9xgKm56IIcObFQPWIUPmm0?=
 =?us-ascii?Q?8kGp6Z3hNhDX0nxBnIOgt0RhfReKDRk04xuFVdh0RTpwwh1s5N3zNkvwyN8c?=
 =?us-ascii?Q?uT44XnDFSKuzG6DQr0D7MMZ0lUCG+f99eTrgBjUH5NRrN2glxbkU6C9gCJG5?=
 =?us-ascii?Q?/hlpsSuL2guh9ghmsC0SigA1IHR539F26RX2jvkydYip0WSsxuhdpFxIcIts?=
 =?us-ascii?Q?SN8eQbSYwWktGXja2csjHlFL1eBIC+Km21NtFCmL/LwBKkno780CUjU6iffk?=
 =?us-ascii?Q?vot+0e27oLOEPiWhFuRPHvvWkw8+n8094V+OwCQ5xjInO4Ds4PAPv5w0Ms5h?=
 =?us-ascii?Q?lLl+QbytTUFAV0SgbhUdvZfhlLDI7H45MycJIfxOAhgkmCiUYOoVXonCQJ1r?=
 =?us-ascii?Q?pRQaAwVu/yhd1INSM/Elc9W7GDdVeFk2I+5loFly71d7dtOxCIyMPyiKJKNl?=
 =?us-ascii?Q?iDu4HdsQxILcVSYSfaRG/5YhQ9Ip3M+jq9D4lWxMJaoN/ypSy9x0qHUAHza8?=
 =?us-ascii?Q?eoowcDPBuTIdrs6WR5YOScbSvsjI+1+R7/GUZ+f9xkOgakUy0lIy5hL3l7H6?=
 =?us-ascii?Q?dM1n/aUDFeUfOSBunNxnUfVansPlpDIetLgprnZzCuS+qSg2b6gxw1H8t4Ct?=
 =?us-ascii?Q?9jFtX95ovSfX9giLAi6vKZmcsA5vcNTvERq8N2y/Oo+l1kU6NDYM7FP/mhOH?=
 =?us-ascii?Q?dxTiADPD76Argmmh8e318tom2QRtIfvzP8JRKdPg6YidKPZBf+5hvytmxv0Z?=
 =?us-ascii?Q?ZwOkcIt4bLDxwQilh+1FBkAeIK6R6dke+HULhxwWZcnHyeQC0EB4dhxtclq6?=
 =?us-ascii?Q?e59E1WZcsxdhgGs9IICeiaLKedwMCTStshRTGXsAclPfqOCWA1FmvwBJV3iF?=
 =?us-ascii?Q?8ybtP7MA0IKhxbOJEo7uywWPmM5gGCGOdS/uKV5xNUbq+ytJ587ulRbE95nX?=
 =?us-ascii?Q?ANZOzzubDWYeGkDo4svNTuYUuz58O+1OjloaAb2uYUhSx2mhHkmGuqnyPVGU?=
 =?us-ascii?Q?gRmAmVdkpV4wWrDmEz3LdtjM/HOgsc5yu9tse5PTS4gtxU1/vHk0xi5pvNw2?=
 =?us-ascii?Q?bGx0fh4LoD3N4ZG1Oufw8KnwoxvA7mMO1uVt9jeaRj/wWNYqR9QKCIUkr9Qn?=
 =?us-ascii?Q?63aVjHIiqQQKKlYGvgumgMoi6ed5nyKwiPQgO69MAnG1zUJtfsgB8vXl4lYh?=
 =?us-ascii?Q?lZLm7dUexWULUw0aCF9CrNMAufIOdEMnU5B8SXtDb+NXjRC83aoejoHvRK/q?=
 =?us-ascii?Q?y39v72mQPkuuVvOq3bThEl0p3gssGnQGpQxki1sKgNXj6I+QerpYbk1ARQEI?=
 =?us-ascii?Q?BBaavT9eGY+dTS40gJh1eAxEhnmIrx1pWlFjRP9Lr4Bu8xNsLvTLPe62vFFj?=
 =?us-ascii?Q?muh3IiSuyEu/lmuKBL/IUlvIFwmThy/Ms4ojAvjT/dTuOqtnOLLgT2nX7HB1?=
 =?us-ascii?Q?bzgaqbjoVrQ8/7t4n5kTdkSRmrwjn0DUVctOisM7gEVBFnIICE9sBGJYcIGx?=
 =?us-ascii?Q?PJ/TBdzb3QuQd0Ewxj+m4oAgzBgj0Dzutn+2yrQ53V1GuPmGxbptZf4WM6cl?=
 =?us-ascii?Q?28+1w/yjscXDV/f/gRTc0oRHJPvDmuZer+WRNrO9upTVlEYUj4UTEdoiyQCO?=
 =?us-ascii?Q?Y062h6VB6oA1qHlBB/vGlGU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9505ad4-77c1-49c2-88c7-08d9d68b4333
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:53:06.4791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OV3j/H/4W7e6VNJZqt1BiGIf0u8d/36q4Wm8nU4LHRbEMmHcU03V8fMaj4Tf094nLw+8FzUG/Jl1Pj98+DFQFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4919
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Wednesday, January 12, 2022 11:07 PM
> To: netdev@vger.kernel.org
> Cc: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org; linux-arm-kernel@lists.infradead.org; Michal Simek
> <michals@xilinx.com>; ariane.keller@tik.ee.ethz.ch; daniel@iogearbox.net;
> Robert Hancock <robert.hancock@calian.com>
> Subject: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core=
 reset
>=20
> When resetting the device, wait for the PhyRstCmplt bit to be set
> in the interrupt status register before continuing initialization, to
> ensure that the core is actually ready. The MgtRdy bit could also be
> waited for, but unfortunately when using 7-series devices, the bit does

Just to understand - can you share 7- series design details.
Based on documentation - This MgtRdy bit indicates if the TEMAC core is
out of reset and ready for use. In systems that use an serial transceiver,=
=20
this bit goes to 1 when the serial transceiver is ready to use.

Also if we don't wait for phy reset - what is the issue we are seeing?

> not appear to work as documented (it seems to behave as some sort of
> link state indication and not just an indication the transceiver is
> ready) so it can't really be relied on.
>=20
> Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethe=
rnet
> driver")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index f950342f6467..f425a8404a9b 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -516,6 +516,16 @@ static int __axienet_device_reset(struct axienet_loc=
al
> *lp)
>  		return ret;
>  	}
>=20
> +	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has
> finished */
> +	ret =3D read_poll_timeout(axienet_ior, value,
> +				value & XAE_INT_PHYRSTCMPLT_MASK,
> +				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
> +				XAE_IS_OFFSET);
> +	if (ret) {
> +		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n",
> __func__);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>=20
> --
> 2.31.1

