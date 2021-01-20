Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766CD2FD98D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391913AbhATTZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:25:42 -0500
Received: from mail-bn7nam10on2118.outbound.protection.outlook.com ([40.107.92.118]:4576
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392274AbhATTYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 14:24:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRcUeHPr2rY1zVtY3P9LGc/JU5X+r3Ta4sL2fIRLh1u+Nkujw4WOsRS/5pAxuNY3Gbh71SLSIwQWSxE2YvRyEFY380NKMJ0VuYZ6mKATslvUThwccP/h8K29YlXEbtxv4U2R4OExyA7cwrotOEB78yW0A7tImOzQs7Y7ATrodfTUSf18ILJK87BSVhQSdjR24lvp2lhOSKpSprOhG/Pj7MOhP/uoNapNV7VU/2ujqgb3LYKYWVZwoxxBOkSm0oWtt7AS4G/K5Jswcb4z0KW8CfSf0LQ8FFZMfEKm6lNMmEo26P5WXKSWDBnihyM824IR9NKM/X07olRBOVJ+ivLdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIJ+m9acMegeT3QJyTY+je/GqebK0FgsUbpi2tQAhEs=;
 b=F6ZayVDwWrTewSRSspcWp8Jnt7en+kVGMnyR+4yPpgRTyt413K+hpvr0yYuPnoSpVTRxecqFIVhx9vaGEYdopQ4ka9j/mEHo+HzKLrtu3sFkl0gdMc+RheyCFTlKr4lM8/RlIlt2WW1NKsvgiIl3zgBdz8dFGbyQpdlQhDMjxq15Q/keD993NaaK5ypbrxLgW/k4V4w4MN/BbvAWojmnlma8h5yP4CWPtVD3n+jgPOwj5pTtY2gLiXgSVsIet474XIf5jlDQp/ERxwaafmsTXfmrn8l/4SHzHdSaRgFMDXah6U/Tzwe+mxcvQavbWd1uO1rRsrwH1d1KH651pnZhww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIJ+m9acMegeT3QJyTY+je/GqebK0FgsUbpi2tQAhEs=;
 b=Ks3phbH/F2iXJ/GbEfYYmlju+uPb/5pz2+7BVibYFke+PQh/rCQAajOVuBvNiAq4tisO1YDKJZqaxtyoy1BGztfktEpaFdfkeCLnv5+TdfmiXxthOc46SBCtaNas7CCMuBZ3jDGm+ufEB0gela07CiJwaKW8L79Sj7Jv6b1clUM=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB0996.namprd21.prod.outlook.com (2603:10b6:207:36::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.3; Wed, 20 Jan
 2021 19:24:06 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::5148:e9c:f912:a799]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::5148:e9c:f912:a799%3]) with mapi id 15.20.3805.006; Wed, 20 Jan 2021
 19:24:06 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated guests
Thread-Topic: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Index: AQHW7ozTJyADPmDtnEe0lsr5e3G6Fqow4pmA
Date:   Wed, 20 Jan 2021 19:24:05 +0000
Message-ID: <BL0PR2101MB0930CF4297121B1BB904AA7DCAA29@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
 <20210119175841.22248-5-parri.andrea@gmail.com>
In-Reply-To: <20210119175841.22248-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a8ba24f5-71e5-413a-9802-17ef7eba6aec;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-20T19:10:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31d9bcab-c038-4c74-46a4-08d8bd78f476
x-ms-traffictypediagnostic: BL0PR2101MB0996:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB09962361713AD6FDA722AD27CAA29@BL0PR2101MB0996.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xe3WoKrcMTaecW367rKd9YD6kG3p8+bUv9jYDpFUiD0BAWZqu/rbhH+lJ1mO5BCaZDvB5RZ8ySjPJsyIVA3mSK9p3OVaFxmQOak2dr9qnkJqgfEdRSXVAv9Z4iUyOMt2sclJ6tuCJoOCawa5OqTK8eRQkLXMZiHWYEnTwsLcR8XrHv5F1X2N4wN1SDWqInbLDynsY6G+K/oNR9LMCf0L7Pp+Jyr2zN2ArUW7cdjmKm2FvoZzi/Zo8jidDXPbNXRgh7O/Sr3Ip0UqkbbFJkjUZ5jrGzF3BF1eP0khmFZ+30Zg+r0sZhJP3LRv+WW2yn4H/52tI6zXhFCGDH+NKfbFTZGjb8OldENLiDOsIR0WFDhBPcPQAqz01j8AIWqwSixIrZt3TuEvzeWAKlmqWWP64aiCc7m7SKY0SUXa/DWv2eH7Egmw7StIst5ukfakzTD9n8P9sRUvhZNTYpsDN5p4X5WGvbEVU/nb3q7/eNQWipC7HsULf9PgzBUMD7o+xcSssduAAXlYKU1xhlIWNFZIrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(9686003)(66446008)(64756008)(66476007)(86362001)(66556008)(71200400001)(8990500004)(76116006)(66946007)(55016002)(2906002)(8676002)(83380400001)(6506007)(53546011)(82960400001)(82950400001)(186003)(4326008)(52536014)(26005)(8936002)(478600001)(7696005)(110136005)(54906003)(316002)(5660300002)(33656002)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kKa1GBGyX+bDqr6Bwu/dlLV9+6CEEGP7wKTydw5Mm6UTZGVe0Yq6EQcZuW/8?=
 =?us-ascii?Q?S7ZtXm6f7BbKtF4/2a3uuA/NY2kHdC2L1fHI5SOowLGsgyf19iyZElaOiWHo?=
 =?us-ascii?Q?ZNpjeRoPhjOtxfCuodehjhXIb4+JFv5bDB328ADATzFy4kS8q+8ohRYFDGNA?=
 =?us-ascii?Q?6Fd0P/QMESOdWjcEjnC7AKPqfNkx6N8l9ddd1JFg/JDqt6LtXDkOISOj7QhI?=
 =?us-ascii?Q?CH40DGXTLKjVdbesSsvoLRLVERjJjrKQ9a4Ewe+jOOVf4v0X5TrFeJyqrrMC?=
 =?us-ascii?Q?6TgcqKVoIqyzyh0osLJkfLpgda9FWbQHCzTgU7RsnT2tkWtbD8pKWsb97Qt9?=
 =?us-ascii?Q?vwAW2yXBmIG4X+dEESX4SeY8u113pbkkXPPlwjuv3PRvnBDQ4MyUpzCGWKRE?=
 =?us-ascii?Q?xEgfv5dQ2k/Rs/Og9MlOxfYgdIShG0iEZASbpv1RAdHD/r+XgQQpZchqUOQO?=
 =?us-ascii?Q?k9dNPlzYK97ycuKvdZY9Fg7A6R/9rHfxSjsQtndsIZwqzaj/U5FcPtcFzYom?=
 =?us-ascii?Q?/U3eWvkkCYrnZgubMm5r8bZxVJfBvcBQp75UN4MhR9puMAviSVldUjhyT4Bj?=
 =?us-ascii?Q?dyWXAC3841tc+ul7cdCylSsndDNKi1IdY5z6EiTOf+nu4UZtW+I6vn4mRowq?=
 =?us-ascii?Q?7qEsFNP2uf3KCMnMx44PTcoEJs/B73dqag7cPD9LVZufibcOZReeCGBfGDWG?=
 =?us-ascii?Q?C+b3iWkYtdtPjJbypnSRg2kG+1+1XnZgavlAjx1jfmbHtZgm+7nISMclJJZw?=
 =?us-ascii?Q?JpeQrLaWb3Iveio3eDY1FtZEagvZkklwjK+4h/zixjFhWpoBcOZXwQfkH7dG?=
 =?us-ascii?Q?uIEuwSY5V2N1ejtFXKzdgseOZ1s/Jw4cYc+Qq4OKMh3ZaoWeY5Gf5/8GNXLo?=
 =?us-ascii?Q?enuW1g52bYQez71ROPpwg1bm/21PzWvzmol5YKU1BOSWY19jItF0gqmnOAEL?=
 =?us-ascii?Q?OaDKIGzJQ5r28FeTHUnFb39sOs5uyfabY5D93Oq8wMD/PIdZB0tOmAspJ+Mn?=
 =?us-ascii?Q?tOZmot7l3otmdnrx01GheYjqYM5jhIcm/NZNWhBc2bdVYgttv3DU+Zfl2810?=
 =?us-ascii?Q?r7vsiCrm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d9bcab-c038-4c74-46a4-08d8bd78f476
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 19:24:06.5234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NlaLDsoXX6gR21gtbYKYIbEkhA0Hizb3TZCVzPvuAY52j3gVV7CebSMTmDpw2Z55/r1G+XuBgAOqivJ/ypAljQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0996
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Sent: Tuesday, January 19, 2021 12:59 PM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Michael Kelley
> <mikelley@microsoft.com>; Tianyu Lan <Tianyu.Lan@microsoft.com>;
> Saruhan Karademir <skarade@microsoft.com>; Juan Vazquez
> <juvazq@microsoft.com>; linux-hyperv@vger.kernel.org; Andrea Parri
> (Microsoft) <parri.andrea@gmail.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org
> Subject: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated guest=
s
>=20
> Restrict the NVSP protocol version(s) that will be negotiated with the
> host to be NVSP_PROTOCOL_VERSION_61 or greater if the guest is running
> isolated.  Moreover, do not advertise the SR-IOV capability and ignore
> NVSP_MSG_4_TYPE_SEND_VF_ASSOCIATION messages in isolated guests,
> which
> are not supposed to support SR-IOV.  This reduces the footprint of the
> code that will be exercised by Confidential VMs and hence the exposure
> to bugs and vulnerabilities.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/hyperv/netvsc.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 1510a236aa341..8027d553cb67d 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -22,6 +22,7 @@
>  #include <linux/prefetch.h>
>=20
>  #include <asm/sync_bitops.h>
> +#include <asm/mshyperv.h>
>=20
>  #include "hyperv_net.h"
>  #include "netvsc_trace.h"
> @@ -544,7 +545,8 @@ static int negotiate_nvsp_ver(struct hv_device
> *device,
>  	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q =3D 1;
>=20
>  	if (nvsp_ver >=3D NVSP_PROTOCOL_VERSION_5) {
> -		init_packet->msg.v2_msg.send_ndis_config.capability.sriov =3D
> 1;
> +		if (!hv_is_isolation_supported())
> +			init_packet-
> >msg.v2_msg.send_ndis_config.capability.sriov =3D 1;

Please also add a log there stating we don't support sriov in this case. Ot=
herwise,
customers will ask why vf not showing up.

>=20
>  		/* Teaming bit is needed to receive link speed updates */
>  		init_packet-
> >msg.v2_msg.send_ndis_config.capability.teaming =3D 1;
> @@ -563,6 +565,13 @@ static int negotiate_nvsp_ver(struct hv_device
> *device,
>  	return ret;
>  }
>=20
> +static bool nvsp_is_valid_version(u32 version)
> +{
> +       if (hv_is_isolation_supported())
> +               return version >=3D NVSP_PROTOCOL_VERSION_61;
> +       return true;
Hosts support isolation should run nvsp 6.1+. This error is not expected.
Instead of fail silently, we should log an error to explain why it's failed=
, and the current version and expected version.


> +}
> +
>  static int netvsc_connect_vsp(struct hv_device *device,
>  			      struct netvsc_device *net_device,
>  			      const struct netvsc_device_info *device_info)
> @@ -579,12 +588,17 @@ static int netvsc_connect_vsp(struct hv_device
> *device,
>  	init_packet =3D &net_device->channel_init_pkt;
>=20
>  	/* Negotiate the latest NVSP protocol supported */
> -	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--)
> +	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--) {
> +		if (!nvsp_is_valid_version(ver_list[i])) {
> +			ret =3D -EPROTO;
> +			goto cleanup;
> +		}

This code can catch the invalid, but cannot get the current host nvsp versi=
on.
I'd suggest move this check after version negotiation is done. So we can lo=
g what's
the current host nvsp version, and why we fail it (the expected nvsp ver).

>  		if (negotiate_nvsp_ver(device, net_device, init_packet,
>  				       ver_list[i])  =3D=3D 0) {
>  			net_device->nvsp_version =3D ver_list[i];
>  			break;
>  		}
> +	}
>=20
>  	if (i < 0) {
>  		ret =3D -EPROTO;
> @@ -1357,7 +1371,8 @@ static void netvsc_receive_inband(struct
> net_device *ndev,
>  		break;
>=20
>  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> -		netvsc_send_vf(ndev, nvmsg, msglen);
> +		if (!hv_is_isolation_supported())
> +			netvsc_send_vf(ndev, nvmsg, msglen);

When the driver doesn't advertise SRIOV, this message is not expected.
Instead of ignore silently, we should log an error.

Thanks,
- Haiyang

