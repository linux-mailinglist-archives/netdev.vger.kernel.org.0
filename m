Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E647330AE63
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhBARtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:49:52 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:36769
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231748AbhBARtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 12:49:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXbMbWoa0A2qSwKYPQjfmLo6TTOPubt4JDTFI0p3hYW9kzkMjR3yzu7Anx5lCmsSFqehUsy5x2iri2pA8MJOYEiMTiflBstq42qsyHOJXUp0MksAw8qjvtDoGQhfay7lbNApw/5XqvaeKoS2s38t1KvZwTUmZE83QZMMMDpL6S1moDEbWA632q8dmGGdIVv+UOWeR9u6cQcuzXtfVxAVeI/gB1hnod8Rh57krri5oGsjjiPVA+N1Da92O1nC+PyAtQ8X1QrIUK0LubUNL7aKqy3s9E5JuXwocjL+92zJbgDaZKNSU232hfM1UklmEcKDHPJVJgrRissKusr2S5W9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1ihNwhU1mVplqkT7LqYDFQltcUxTXjNEYklI6cxAr4=;
 b=PaoRCkFPWFk71OfxXJVDlDlBzhSZkGc3AotF/TxwXKnFVNzXyGBpOmDoJRixEPpxoVzew9c0L8yvVeL+RWqNjorYqWk55vZBul34C88DRwqIs8xMCht5aioBjA7zDphRuyWKX0SeYWn8nGIIxI89C0lJrXB8AnLiExIYicWZYMnYmnNvOX8jAeSfYkSgeduQBVmALdqBSnNL2p5sUmfcK9pLqn2DeVErddNgPp9l8BEcOrx0+QSYJnuexrWG1pCP2L9xsfnCc6PzRN482XgcRMpP26a7Zc9vEFxs4oQhLDNykxFebPiXIV+l87JFqh2llK4Z7jhwT+ycCWYmfBD/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1ihNwhU1mVplqkT7LqYDFQltcUxTXjNEYklI6cxAr4=;
 b=jOlLM0iGHwkqUHErTeUPxqunB5ACJlnPkxhZ6LSPcHU/cnDmHSZgTdeO603da8Lp5W5VKuDbTqL+Ov/T3Um8SPhqfI/ctiSJfCxfztaE4BGXzOl+PzA2uWBmYKAxqwYzpmlZiOXLMAaeUSb4g4VtQUlL/p9OLoP0Qy63cqvUaJE=
Received: from (2603:10b6:301:7c::11) by
 MW4PR21MB1875.namprd21.prod.outlook.com (2603:10b6:303:72::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.4; Mon, 1 Feb 2021 17:48:56 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2%9]) with mapi id 15.20.3846.006; Mon, 1 Feb 2021
 17:48:56 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 hyperv-next 4/4] hv_netvsc: Restrict configurations on
 isolated guests
Thread-Topic: [PATCH v3 hyperv-next 4/4] hv_netvsc: Restrict configurations on
 isolated guests
Thread-Index: AQHW+KlZXxAZS+dgn0icQWwQcKCw76pDk1kA
Date:   Mon, 1 Feb 2021 17:48:55 +0000
Message-ID: <MWHPR21MB1593CB2AA09DA302FA2EC5D0D7B69@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210201144814.2701-1-parri.andrea@gmail.com>
 <20210201144814.2701-5-parri.andrea@gmail.com>
In-Reply-To: <20210201144814.2701-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-02-01T17:48:54Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b06888ef-5aa3-4c4a-8bba-1da9c3e96182;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a182c6d-45ea-45b0-71fb-08d8c6d9a599
x-ms-traffictypediagnostic: MW4PR21MB1875:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB18759ACA09FCDAA5B2FE4D45D7B69@MW4PR21MB1875.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O/38UHcJE25VnrJLhpq1P3Tcr3zw5jWffuzVFtWwvStuN8yPF7MlquVhQw+CutIWQupkSGwb4WlZvxgO5Jt7pZCvB5D110Ksp67XwuB7CNudL/YbKqik+nWpQztZ4e594IhLwyYx72USxfr3T8aQJygtChEc5rx242a9sWae0ewexGffcuezc+FBOcW6CIn1afh+3mNEhMsfTpYM/cY+1emqmJTRuuMisD5J1SmxOW570/lKq8Wg/JP1IJ3wZ3RUnsM2oCGso3qe3EMvUZIks7Z2NcdIHsMw+X3HlssaYW9H4vAVigs50N1kiITWleDL3c3hhxiKhLevAfcmu31HYRUG6+jcoxOT4GW81EpTo1PEDPx9KYncnrVtEzc+353+lX70JPNqxXNsVZIZ7HtuEKinGoOnEnWiV0oQWiiG1sc6mNQG/7yHd9EcG0iCl16ntIxRKzeGGAHIvEpst/fSvPHNepxBAHPKug0KbQRYjRcGZYJU3Q1LgQCS6tkh5/7NmOEQBn3FC8homNQhFOHhsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(66476007)(66446008)(66556008)(110136005)(64756008)(54906003)(66946007)(8936002)(316002)(8676002)(8990500004)(52536014)(2906002)(83380400001)(9686003)(55016002)(86362001)(76116006)(82950400001)(82960400001)(33656002)(26005)(186003)(10290500003)(5660300002)(4326008)(71200400001)(478600001)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Q9YM08V1rfyW6l7VDbYXJ49Jg/nOl/7/eHQKQqloMrn54ZsSf8/QiNbRnWtL?=
 =?us-ascii?Q?KUCFEvqQ8ocrjxJ1VB5A0kIO4kIO+1wx8rNs1RG5QdXIvYWWBtuoF9z38tJZ?=
 =?us-ascii?Q?3H5U07qz66AFMTkNpVy23dTLu/iR9oXdGoDOBlviFdk9D4wgutaUGEBv2dk+?=
 =?us-ascii?Q?njIgIOeiWMcA3yLdhkhZMiCnq9u8r1349J0JfxaC1Tk1JXdWYN3w1KMLKBmA?=
 =?us-ascii?Q?HYSjlfES6r9vwrPKVkw4tlyJ+qtJs2JjKaI+PdmXXrQYicXpGXvlVC+jjBVd?=
 =?us-ascii?Q?l/b+t/DNPtDXzMrghSxuSmLrd4JOVAuY/svgUfoaMWmqnPS8CDRXVmBPFqJJ?=
 =?us-ascii?Q?bG4ms9s0xHQuctaL5QSyhm9ptVMIbRQznG7BxdpsIw1it9AUu9CkqW4rRyA1?=
 =?us-ascii?Q?pP0qISWJ6rWZ7p0/rz0Egzolz/xdekUK/P3+SYHKcRXZGgP7emOWacT8ij9+?=
 =?us-ascii?Q?CbwolWRfR5krNKlKlFvRsKUDHzQ5rvyvcmZaHQFIskbSCJqxeNy24twass3a?=
 =?us-ascii?Q?1gpJpyqRQF3BHPVUxEbm0wXxKf1NwgbqOprPvYji0jncUNMS9aq57bHojuV4?=
 =?us-ascii?Q?tYbFwD/YDyCyUb2r9UAI470lWpi6/EX/KtUeyAdlkBYpLkHLyvgSMAqic0lo?=
 =?us-ascii?Q?yTzW0sQzAdry+RaUdPfrTX3oB7yhpBCuNh25Tn7uIk4nwy8b3+wIfKgaxN0s?=
 =?us-ascii?Q?OMB/bYAM8hXHvQmTqNlOfN+RpfcWIeDcU+dCaW7RO1PYJUa5n/h9ZsI3B/z5?=
 =?us-ascii?Q?0DUPXMw/g5lHzWIGRdPkiG7+5uo28h6Ot/tEiB8v97U3kvl4StQ0uKpFjp++?=
 =?us-ascii?Q?WdpBuoQeDRkahPFtoIfWzDy1j18yGXEKpmtTuJpJTW+IFw8eaxLWvvRs64K7?=
 =?us-ascii?Q?fS8rxEdu7UISkpCPKqgVU1C5Dkn3yLRMCeZD5gMKJVch3hEdWkRF5UHFsMBs?=
 =?us-ascii?Q?0Cmv6oHXnpzlOAiG/jE96yPGXpWswh0v8fdiFhldyy3Ua4b9pIxk8+NJcZq6?=
 =?us-ascii?Q?pm7XjcmXR7cyeT9j7wbZlqKQS7GfY1py3eAiUcOHShYZkqC0oZjnSgif0g6A?=
 =?us-ascii?Q?it90yjfBYGNT9zdrFHoi6Vs6KjWwqvC6U7c2ifMigbr/9PBHNijbPUg0qqdn?=
 =?us-ascii?Q?YD+fQDWR7EsqXBuCYrNwujQgB+Bj2k4N82C8OvjUWnTWdGM6p17YCFeADxKI?=
 =?us-ascii?Q?QZYPBwHlUHouFBh4jrGia/bQeh1CDZUBufXaX0Ldkvz6zftcZXlUDFNPBOI+?=
 =?us-ascii?Q?Htc9iVSIL8LKbfIFBqnQdxgpTHu4JWQQrF3sLpRguz90TqlALBp6ql3a/NbR?=
 =?us-ascii?Q?newjkUJhaog4wosm9S52h2L7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a182c6d-45ea-45b0-71fb-08d8c6d9a599
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 17:48:55.9336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hZVglyw3Aa7d/0/3LlpsGnXBJBiNLnorAKDNApvcrNfryMvM+4T/Nd4VNWO0zZs2hl6QEItseSWzNoWiaW19A0skmOxnoSu3fpDH/H+L76E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1875
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Monday, Febru=
ary 1, 2021 6:48 AM
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
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 1510a236aa341..51005f2d4a821 100644
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
> +		if (hv_is_isolation_supported())
> +			netdev_info(ndev, "SR-IOV not advertised by guests on the host suppor=
ting isolation\n");
> +		else
> +			init_packet->msg.v2_msg.send_ndis_config.capability.sriov =3D 1;
>=20
>  		/* Teaming bit is needed to receive link speed updates */
>  		init_packet->msg.v2_msg.send_ndis_config.capability.teaming =3D 1;
> @@ -591,6 +595,13 @@ static int netvsc_connect_vsp(struct hv_device *devi=
ce,
>  		goto cleanup;
>  	}
>=20
> +	if (hv_is_isolation_supported() && net_device->nvsp_version < NVSP_PROT=
OCOL_VERSION_61) {
> +		netdev_err(ndev, "Invalid NVSP version 0x%x (expected >=3D 0x%x) from =
the host supporting isolation\n",
> +			   net_device->nvsp_version, NVSP_PROTOCOL_VERSION_61);
> +		ret =3D -EPROTO;
> +		goto cleanup;
> +	}
> +
>  	pr_debug("Negotiated NVSP version:%x\n", net_device->nvsp_version);
>=20
>  	/* Send the ndis version */
> @@ -1357,7 +1368,10 @@ static void netvsc_receive_inband(struct net_devic=
e *ndev,
>  		break;
>=20
>  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> -		netvsc_send_vf(ndev, nvmsg, msglen);
> +		if (hv_is_isolation_supported())
> +			netdev_err(ndev, "Ignore VF_ASSOCIATION msg from the host supporting =
isolation\n");
> +		else
> +			netvsc_send_vf(ndev, nvmsg, msglen);
>  		break;
>  	}
>  }
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

