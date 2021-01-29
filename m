Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D00F308287
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhA2AjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:39:16 -0500
Received: from mail-dm6nam10on2123.outbound.protection.outlook.com ([40.107.93.123]:46625
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231138AbhA2AiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:38:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyv+bW1GHmMxw7uayyBiQo+ZXg8iWEgu9fw8CStawBk+ISvup/caLQH58kPT7ST3mD69VDrCRzxgok4CQX3/AFu49D70gcywBrvuK2Rjsgw2d5wrR1TPjexqFs0iu8jAcUGwlOVyXljN5tqfpPVvMXamqVN0z+47uaANicIiwLdpkwbkM4gSA+XrklkX6ExfMikLWVrJm4SaB9QvwNk9Gz1AB8pTFoAgaKJqtOlHgvyVN2o1B08TKcGGs9cBKOZW6fbKmtMCF+WxDfotCMJq/brv/H8qswxj3u0xzgT04NlqyCV7/8QUJPGTkVlRQvZR2hWld5XNTew5ERa5z6vZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rJkwjspTLwPqIKxmywy5FSOqpVvAYVhF7QIwGycLOM=;
 b=nh4eG5SkqiUfuwlekk73T6KpBdkqKmiVcRR78mVFljuyAaDNUwuaQmXzWTuT/FukVtVfuw1l/BwJRhZsttDK1DYM8AI3rXG+Ajtzon7nznJcOpjL9JrYC8KSmhKq2GI8124YTYHQfh8CUZpdKN7VjSz8UUeGO9fKLhtNhbf6Vz2yGEDJ+k35ClwgJD0YJOGJJRobUcbH9cz4ezipqSbyHh7L1Rx5rIDYHpgfwQLPBQWthcan4N7CWl0tWE5VBKsUX0cjzEkE9e7GLDSgy0FAo9Zzklti7WWNujQC8HXnue991u/u/gFoe/Az2gehzE3/olM6aAcA2k/ppqpmMUanBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rJkwjspTLwPqIKxmywy5FSOqpVvAYVhF7QIwGycLOM=;
 b=Kjz+sNChVe/m/aC2I9p0ZqDB7vzTFaCao3+BVxIWMWEMO7AoRwVIzXqkdIGkphY8MgDdKwQd3aHnQlDZTARLtqfr7px4LpDQ1mzotLVLTGKiDEinCq9xfzjexEkUEDkVNYktQkMpd3GVSsC4Jakr80t9hoBKAewPu84gdzl73xE=
Received: from (2603:10b6:301:7c::11) by
 MW2PR2101MB1019.namprd21.prod.outlook.com (2603:10b6:302:5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.6; Fri, 29 Jan
 2021 00:36:58 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2%9]) with mapi id 15.20.3825.003; Fri, 29 Jan 2021
 00:36:58 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Topic: [PATCH v2 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Index: AQHW89pqx81SMYL5HkeeGpWVQqM7gao9ve3g
Date:   Fri, 29 Jan 2021 00:36:58 +0000
Message-ID: <MWHPR21MB1593CDCD7D175CA17A2FD25DD7B99@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210126115641.2527-1-parri.andrea@gmail.com>
 <20210126115641.2527-5-parri.andrea@gmail.com>
In-Reply-To: <20210126115641.2527-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-29T00:36:49Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b6992190-5486-41b8-b927-4f58d2b7a05b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [8.46.75.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cf815259-23bd-4827-6c33-08d8c3edfc6c
x-ms-traffictypediagnostic: MW2PR2101MB1019:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB10198C434C1819CBFCA77813D7B99@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: suDWxUS/w0vpr6kua0DR3LUp4gJ/V41pjIFjT8jHt324fGr3nVUmDb1Nfv9wsUCY7o06Q5wzbmG+J8xaUPE+9gKBkGx1JR0c1PIb95lThKqeD5SzVhe151WNjluIjYnOw6+h11dw2OlFuIbVZH0dGxUrTE4fFd3M1CkmjG0CLjRNLTaKzsdl+ycpIbh47qVj8Plhf3UMNBpApKTJG7yVwz3l4JlZDridPAEeipAahxgLBbBXp8MpBRxC4DX7H2nzD5ff6E6YdsldwYgxKCekUP9tdQ0W/IapJ1Iwm8YkQIJAiJtxXN4xqtXtiYLSJhSUS1Nhn3chkak5giUdzoEjVjs4PpZWV6IMgmT+kg/fe/hcGWrJE0fS4yVHDoBrE1OKyiEGDBcD/D5wnYKkBJdKnuZdsE5j8s1w4zdlJVie5NP+n4GOdyeKZizUTWWK6xpG9arR+u6BD7jM+I3ETbHl/Sw5gpWboEepeEm8gx+lxEH6KRiMvgWoxcErU8SqBScs/kc5xFeinr7r+7qY7jjGSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(6506007)(64756008)(66476007)(55016002)(66946007)(7696005)(76116006)(478600001)(110136005)(8676002)(8990500004)(66446008)(83380400001)(33656002)(9686003)(71200400001)(52536014)(316002)(66556008)(5660300002)(82950400001)(10290500003)(82960400001)(86362001)(54906003)(4326008)(186003)(26005)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8Iwb82Ffsf/H+a77DWf3VSTUKhUobGwZQc3FLGnICbycFBWyiDJFcZCBll34?=
 =?us-ascii?Q?ovsPFzRjhTGhfOY6WXMWYsk96NSJmob2sRnJOy8yNMvbsSIlmFTS5ftXUxh3?=
 =?us-ascii?Q?J44dPE/iubuOKY5IZR1ULMJnbkhrfEutprKAmw/Or96dmaVqCeCLFZk/dsmZ?=
 =?us-ascii?Q?5RoB7rUPXXp1UahzNCfVphwSEIwEX0dBTB0W93+3in2OAdajks5fb5ZZNs6T?=
 =?us-ascii?Q?L+A6THd4cw03OseMKHN/Sk6eJNaZ+F+B9tM+nabcJieYdxtowo6hQ1Yo6nLb?=
 =?us-ascii?Q?VhGjmr9C1GdYHAPynu/U2adzKFeltZA+55wfTg/QX2m01DdmkDVqlzzB6Kv1?=
 =?us-ascii?Q?S/5aCVUFeq/W1W5LeYii3wmHmecWFXiKyvSRwUkx1t5dEm3kw6yn0N0KQ+yb?=
 =?us-ascii?Q?7cOdu6d03h3koAz7x59iSlF2PBitqQ1ornv9MluIIgKQP8nSPynsvzZDcTET?=
 =?us-ascii?Q?x3jDk/hfBrhrASv6NWvLrjlq1tI3fdke1SkbLWeFRuiaLDXtQ20tkIUZLzjl?=
 =?us-ascii?Q?dFzxQt10ILsKgfdfzSazLKzbRnJjoFQgVBRYb1csCtm2Cf6iPEtEOhdbtN+D?=
 =?us-ascii?Q?kKUE9UBderTWyn9DOs5BNitUUqT2YSiPhIGeobllMcidkOKhjiPCS3ckfwiZ?=
 =?us-ascii?Q?X3KFEl14XopLSWTuoLe+W8WZ+HH/QrcGTt7yCLwtu+bs5Z49s06fZ1lnm3Zl?=
 =?us-ascii?Q?coxi1xHFWE31ljeMEbRh098gtHN+mUSknEPP4UFMa2ROe9Bf0tUfzh1WxUv+?=
 =?us-ascii?Q?S1rto8yhb11tE901mImMU9hK7H9BNMXRx05AQ/VfbxWZYuSDnE3M8ADOJj+O?=
 =?us-ascii?Q?GHNVZ+x7YEdy+u0MPlbSo6UFrYrAVq3WoACdy4ttbenX9ObcfWzV1Pi5fiKs?=
 =?us-ascii?Q?LH0l87ttm7rtHh5SXihuts9AlqIJbUUZatodwGBMPx9uHnS2iKMst/UgwT7a?=
 =?us-ascii?Q?M/EEtgxA1TAg14os7cJesgkixs6C8+njOVBHrIOid8BQiDS8pT6+AF2T1fOy?=
 =?us-ascii?Q?o0emsm8WT/PvDgBij1CZaPJunEzIEJag3AglhRZbkCGe4NQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf815259-23bd-4827-6c33-08d8c3edfc6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 00:36:58.0585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z7zWbYe9Mhpc6mtKHedZMhZX8dPeQSVq4Dn/0HDCu/ZgVVjz/xusaBg83yoFYDnKITdI3uanu8t18KG503cMT98hSXKTy6ApcRFVtc+wbF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Tuesday, Janu=
ary 26, 2021 3:57 AM
>=20
> Restrict the NVSP protocol version(s) that will be negotiated with the
> host to be NVSP_PROTOCOL_VERSION_61 or greater if the guest is running
> isolated.  Moreover, do not advertise the SR-IOV capability and ignore
> NVSP_MSG_4_TYPE_SEND_VF_ASSOCIATION messages in isolated guests, which
> are not supposed to support SR-IOV.  This reduces the footprint of the
> code that will be exercised by Confidential VMs and hence the exposure
> to bugs and vulnerabilities.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/hyperv/netvsc.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 1510a236aa341..afd92b4aa21fe 100644
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
> @@ -544,7 +545,10 @@ static int negotiate_nvsp_ver(struct hv_device *devi=
ce,
>  	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q =3D 1;
>=20
>  	if (nvsp_ver >=3D NVSP_PROTOCOL_VERSION_5) {
> -		init_packet->msg.v2_msg.send_ndis_config.capability.sriov =3D 1;
> +		if (!hv_is_isolation_supported())
> +			init_packet->msg.v2_msg.send_ndis_config.capability.sriov =3D 1;
> +		else
> +			netdev_info(ndev, "SR-IOV not advertised by guests on the host suppor=
ting isolation\n");

Nit:  Flip the "if" and "else" clauses so that the ! isn't needed in the te=
st.

>=20
>  		/* Teaming bit is needed to receive link speed updates */
>  		init_packet->msg.v2_msg.send_ndis_config.capability.teaming =3D 1;
> @@ -563,6 +567,13 @@ static int negotiate_nvsp_ver(struct hv_device *devi=
ce,
>  	return ret;
>  }
>=20
> +static bool nvsp_is_valid_version(u32 version)
> +{
> +       if (hv_is_isolation_supported())
> +               return version >=3D NVSP_PROTOCOL_VERSION_61;
> +       return true;
> +}
> +
>  static int netvsc_connect_vsp(struct hv_device *device,
>  			      struct netvsc_device *net_device,
>  			      const struct netvsc_device_info *device_info)
> @@ -579,12 +590,19 @@ static int netvsc_connect_vsp(struct hv_device *dev=
ice,
>  	init_packet =3D &net_device->channel_init_pkt;
>=20
>  	/* Negotiate the latest NVSP protocol supported */
> -	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--)
> +	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--) {
>  		if (negotiate_nvsp_ver(device, net_device, init_packet,
>  				       ver_list[i])  =3D=3D 0) {
> +			if (!nvsp_is_valid_version(ver_list[i])) {

Could this test go after the 'for' loop, like the test for i < 0?  That wou=
ld
get the code unindented a lot.  And maybe the helper function logic
(i.e., nvsp_is_valid_version) could just be coded inline.

> +				netdev_err(ndev, "Invalid NVSP version 0x%x (expected >=3D 0x%x) fro=
m the host with isolation supported\n",

Nit: The other two new messages use the phrase "... the host supporting iso=
lation".

> +					   ver_list[i], NVSP_PROTOCOL_VERSION_61);
> +				ret =3D -EPROTO;
> +				goto cleanup;
> +			}
>  			net_device->nvsp_version =3D ver_list[i];
>  			break;
>  		}
> +	}
>=20
>  	if (i < 0) {
>  		ret =3D -EPROTO;
> @@ -1357,7 +1375,10 @@ static void netvsc_receive_inband(struct net_devic=
e *ndev,
>  		break;
>=20
>  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> -		netvsc_send_vf(ndev, nvmsg, msglen);
> +		if (!hv_is_isolation_supported())
> +			netvsc_send_vf(ndev, nvmsg, msglen);
> +		else
> +			netdev_err(ndev, "Ignore VF_ASSOCIATION msg from the host supporting =
isolation\n");

Nit:  Flip the "if" and "else" clauses so that the ! isn't needed in the te=
st.

>  		break;
>  	}
>  }
> --
> 2.25.1

