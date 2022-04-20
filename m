Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0291D509360
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383088AbiDTXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiDTXMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:12:17 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175241FCE1;
        Wed, 20 Apr 2022 16:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXIDxNIdcyAnzxLW+CgAbLUNC7tH8Yeeu/whAD22WR7x1h+GGFl8zd4t/Um1u0T8hnmv1u6ZfkawxJx89QQh5/IWIWnw6KjqoBUtF7kfSvhrsylI/782AYCjvfaYJFTUmfZyixGG14fRrhPTgvOi28gl9iTd3C7bkUi7Zxej+waW5JrjYzyyVfK9NNylH9B19lM39npK8I+xeiCJLQO7kAEskxk9CnuYL5fjPp9GfFzbzooK7qUU5ZGiL9M2PKsyA34C4887tSPR0R2shqnmOjIbU4YgmdiIJm/M//cijrRDjq2XIW+/MoCs4vxlDxItzX4Ts88tn64f/qe+kvUbXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4v2TdiApwB1hyifzQAvrPvdHwdd5naO3NoiVL8pZXU=;
 b=cEG+Ucv2WwwrU1zykFFaC5vvCj3rA/JDOyMB5nWc4Lp2FPGB4m2ltKsaC5oOzLFa/RNNYWRCCMQuFIAAyOs7mmCJajnhGJNsEfCpNHpDZ3fhhg9PknJnJQA+kTSrpb+sb8fd/9mZJWjnA+3T9sC+dQodprnsDtKvEl9b4mTGq5RhYjJONK1+Mlv1JKQjDRt59kzfHnfOV9iIZAZhtDsM0O3sJFqPUYhara78KGPtBkKCVtGhgdVwfGIRoMdIXvMkiUgnVeLKSdw7uumjBS8gyl/nJ6UVofQaAGnDL7LlNpRdPWeuYJZgFGCq3ZpYenhdruxy73xYe57VJK2tRRgsSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4v2TdiApwB1hyifzQAvrPvdHwdd5naO3NoiVL8pZXU=;
 b=cQWHDniLReIpkMbVIMbm/e3JQMkxDeCEr5pRV/HlLTdOrtGVlvgcJhXMn+AKlVjMMyl6R1pu8D0gLhjox1Cd0FVQj62DOt0jDuWcfVZtJhG/HnIA08r0fazArR2/0gs8XtHcaXkRaVhIu4tHAh+4cZbigVGM6xhars1i7LG5Ob0=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by DM5PR21MB0634.namprd21.prod.outlook.com (2603:10b6:3:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Wed, 20 Apr
 2022 23:09:27 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5206.006; Wed, 20 Apr 2022
 23:09:27 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
Thread-Topic: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
Thread-Index: AQHYVPJPraBNnfobSEGP8CGGfmBD9Kz5bTSA
Date:   Wed, 20 Apr 2022 23:09:27 +0000
Message-ID: <PH0PR21MB30258B8132A596D377386AABD7F59@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-4-parri.andrea@gmail.com>
In-Reply-To: <20220420200720.434717-4-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2b6408c4-eb2b-4e52-8898-8a4270c11f56;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-20T23:08:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b536582d-1fca-4c93-f566-08da2322d171
x-ms-traffictypediagnostic: DM5PR21MB0634:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR21MB0634A772EFCF453916855AA6D7F59@DM5PR21MB0634.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r6F3xlAjZFX68JmIbEAeGTpkrofXTK0GHVj8A7dQbW5k5dxtK1uWqtrsL4+rMrvEHKEySfsFIU0+kv59TNWg7/2Rk81qYC1nT6u+xxt+xseYqhx34nSmqVFDkUta4EsDFK8Iceim0heyqbbNqIAXfG4yfFX8nWI1q/hXQ3t36QjwhlccC7JJX27XvHvFMejUQDDdExU3BOpCxdoPBOyC/TgmC/iDUiMvbdBUs2v07NKc4i3TDGH6dqCnLSZObwixJsUihheei5TWUknb6ndVSNCcHa5hMuWZ7leivy2ZLOurTIbVzeteAQ0OiTEPnaF6GwgXJudIrSnhWAGUXAM2XteAC6cm/zeBvX20rtLpwTwPCgSDHjr5nA/FOivP4krsnd3Z3UusaFSD9M0CyUnUGsmX5/Z8rupqih53X1zw/Q4GGhEIApVgxCWJqz3rxyBlTjMVWfkBFNcBaDZ8IrFMvU1Feyycah+RJeJD1k0WLhX+x+Vq+KXrLjS1al7JKTJblefqfEv7SRc8Fcda77MTSqAUGpuanrdKXPKTebtZex+XPu7D+BbOc9Vz35rL7fjfx2gCh5kPLVcxbn5CRHufleKTLNClaCkpxggWyuR8HXm1eijs1hbAkbNhL9M4qBs7mwKpFbWmPWiO2vBjeqmpcrlHEQPB7AV1lJIHzEI7D3Onbbh08mQd30rfXKUKINJHbb0dFT8D00+l5M53AKZ0ra1U3/omFZGKVeILxVBN/5KHusxhwHIIBjeOtp/5J0p34XT6wj5BoH1mp9upzhdSHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(8990500004)(6506007)(86362001)(2906002)(9686003)(186003)(110136005)(66946007)(7696005)(4326008)(54906003)(316002)(8676002)(64756008)(66446008)(76116006)(10290500003)(66476007)(66556008)(38100700002)(83380400001)(38070700005)(122000001)(55016003)(508600001)(5660300002)(7416002)(71200400001)(82950400001)(8936002)(52536014)(33656002)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZT/463DnIg8CWrEN1Jij9D+SHLel3uGYpWPBHlcOb9adjYxJbVMwpVAdWAbc?=
 =?us-ascii?Q?gBBVvFO1Kf3qgHvFMW3wnbjn0WgQhQuuMUXDWv7EonhH1SaMgIXULmY6AcPJ?=
 =?us-ascii?Q?REsz1U5wwvv8CYKXw0QUcSH5RGR5KAdpoxgfq/6FoHkkjHiM70KUpVGCtraj?=
 =?us-ascii?Q?WxfOgz4zNC4OxLD5NhsWC2OV0pxF7CIocQI7UtNZ/nrnY7l4rVZyxzHwVIeL?=
 =?us-ascii?Q?fq6ON+EpjgGl1XJaD3M5okTYB6KVf+x6OlrWjuBYIbg9usdhclucz6kUvjZn?=
 =?us-ascii?Q?8iLIQpQ/PuvmVrbnEdS4T4ArtrJFzW9saJkXBFFYx9oz5woTnbLoBPPkm0tA?=
 =?us-ascii?Q?taW6af+PjH7iUpYVz6kzLrMzNFNuvW2ipD0acNsVxfGTmmJROch5MadKFVRn?=
 =?us-ascii?Q?o/vZl6hq9QAKFjVFN/yemEwAggtFDH2WOCbfBmT1DGLyq9riEyAZt1B5U22y?=
 =?us-ascii?Q?H54U5iv/i5sC7jbXjtIz/69luXiDpBbWb9Lne5FOHsnn3eBA0cwhaIJaztDh?=
 =?us-ascii?Q?gd8hyVNlr9ZMHvfgubsjfgBreqJacipE4ObE/uV6OESj2X5VdV812/RyF0+b?=
 =?us-ascii?Q?CaRi6O4U0zWmuetBiphEKXRuVUmO9Ab+uZDIHEh7AeRp4WfQUC9jJhrbXIQc?=
 =?us-ascii?Q?uwRc9bvISPBGqXmDk47Wxq2Uqr3fzXlVCRVK0VZmEsgn4bImcvfvUY/KqQlX?=
 =?us-ascii?Q?71cbBqUHSA5pzN5nC/KoIyj/6/uDrwV/A5ReTjRG9s1vM8RmBXj2OVbscOg6?=
 =?us-ascii?Q?htBuZhXqd/shxkQ8DyKA/ZIcaC7lO/cnd5cT6n+gb5U/rzQdpiM5tENFBgtQ?=
 =?us-ascii?Q?lJyDh8DcqcH4sLVj3iI1lmwn6KwA+wSPovduGURNJp2f5oUp/Ze64vbWGRB8?=
 =?us-ascii?Q?2L3tlDJE7XtGLPLgR88rjhMuAkoBfZUlwIG8JzWjGLatw6v1spLmYFPRHWaG?=
 =?us-ascii?Q?gwIhnL0snHGFQYkXwJR0Wx8pCHBVMyf5Ar5CaZiDpEC+cppBVbaYbWhR9vfd?=
 =?us-ascii?Q?XN+ncqoo46Y4syUGnWEoLy4rdk/g0w2Oem7/WmoMgtmQ9EpCNKL0lrbm/PLs?=
 =?us-ascii?Q?mfI4uUQ5weers1JDe6g1vDejAokkiqiu/2tTG4Jl8wmXGmPJQGuO7eRE52ey?=
 =?us-ascii?Q?7rtHL4BeMYNxKiG7cK/jinjT0Lmh0xKpyZUIj8ZUHDBZCzKLVjgQqXx9HDci?=
 =?us-ascii?Q?nJdrCRGvzinT8okUxOYRAWtruESZWRF1RjCZccn6EBvy/s/mJZtJI2E/bPTb?=
 =?us-ascii?Q?+BXVSr05vOQ9nu7puhHil8Qyvxb8m4Fww/QMxnWSoU4uYWxqbCtP6hyrMPB1?=
 =?us-ascii?Q?x7CCHG/0BnKRNy0OykoUM+mywfWRem+9pV7WIBuajPmuCsMyVEDZa3crYKQP?=
 =?us-ascii?Q?bIWxzIpoBq9mPn77rNalQK4Zb1jGOyCtQlYDzG3XCsLSLE3Pw0Iwowfx69/6?=
 =?us-ascii?Q?pFfHKXTDEQyKu6aDhQzoPUuuJ74YObJYlfSA2h+/Uuvyq0RFWvFIRS+mVK9m?=
 =?us-ascii?Q?H6cJtRZUMH5fLgf0w1T12swncNT68zgSSAAmQcOddFPZpC1DbZ2aRhIIdJ8d?=
 =?us-ascii?Q?W9XRT2f9LFIRH/VXBYnNpnLvW7t440xstWvnzB/nDgYPbzhmsMpFUy5nncfw?=
 =?us-ascii?Q?FEWFFUbHsAH/t8IfRvj2V4YoyL0gu8j25qHVySxYETdxwHYNBwElwus94VqO?=
 =?us-ascii?Q?QqjF9ox0LrB4I3zdYVWqttJxdjd/BLWwdHo/4DlmxVua+eIZl4I9s1dM5wkS?=
 =?us-ascii?Q?ybUq8O5LPoJx9H9PyZIKxYHpsNQTVC0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b536582d-1fca-4c93-f566-08da2322d171
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:09:27.5963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gzuN25VsUJJkCQdwARD1UCiLpwvBhddPadz3mL4DtI/RQcnRlXsqIEvYALAgcO7H/Lcc6P2jKdFWd57Y6cD9jqwNvC2oFMTPt0SkYeujDSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0634
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 20, 2022 1:07 PM
>=20
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest in the host-to-guest ring buffer.  Ensure that
> invalid values cannot cause data being copied out of the bounds of the
> source buffer in hvs_stream_dequeue().
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  include/linux/hyperv.h           |  5 +++++
>  net/vmw_vsock/hyperv_transport.c | 11 +++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index fe2e0179ed51e..55478a6810b60 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1663,6 +1663,11 @@ static inline u32 hv_pkt_datalen(const struct
> vmpacket_descriptor *desc)
>  	return (desc->len8 << 3) - (desc->offset8 << 3);
>  }
>=20
> +/* Get packet length associated with descriptor */
> +static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
> +{
> +	return desc->len8 << 3;
> +}
>=20
>  struct vmpacket_descriptor *
>  hv_pkt_iter_first_raw(struct vmbus_channel *channel);
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index 8c37d07017fc4..092cadc2c866d 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -577,12 +577,19 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
>  static int hvs_update_recv_data(struct hvsock *hvs)
>  {
>  	struct hvs_recv_buf *recv_buf;
> -	u32 payload_len;
> +	u32 pkt_len, payload_len;
> +
> +	pkt_len =3D hv_pkt_len(hvs->recv_desc);
> +
> +	/* Ensure the packet is big enough to read its header */
> +	if (pkt_len < HVS_HEADER_LEN)
> +		return -EIO;
>=20
>  	recv_buf =3D (struct hvs_recv_buf *)(hvs->recv_desc + 1);
>  	payload_len =3D recv_buf->hdr.data_size;
>=20
> -	if (payload_len > HVS_MTU_SIZE)
> +	/* Ensure the packet is big enough to read its payload */
> +	if (payload_len > pkt_len - HVS_HEADER_LEN || payload_len > HVS_MTU_SIZ=
E)
>  		return -EIO;
>=20
>  	if (payload_len =3D=3D 0)
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

