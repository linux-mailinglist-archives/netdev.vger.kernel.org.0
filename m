Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBC24A78C7
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346913AbiBBTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:34:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:48049 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242712AbiBBTeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 14:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643830476; x=1675366476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nzxyXDDz9qgVuuDzP7aKXtLeZab23R+D3sjfpgvcl9Q=;
  b=bGdgRj6vZPvl8ng+CCCiIC6DMTHC16VCauNh73/W7x3NhmZFoBebMHud
   L0gpoYkqkiMoqJw1uPVfrlZGDYEmfAuUIIP/uI/DXerSOdfMy2FadRhHE
   AuswYZHmswq+gghUMrpnTrbHemJqb/ppYz1c1k22kPZPYHk+1RSN0Yg+i
   81r1bvLX3WAmiAe+FgEZHeENHQWyCL5rCyzxONQ/OFaxFGyFjtaNjmVk0
   /6NRQTnCv4GG7+y/09ll5sUNmW0X8+k3Boi68Y1IiuVdQQ3jwmn1SgQgd
   6pBWzB0a1UhYF4UoS4hySRgt+F3XfUqC4gb9nxHYt8nbCkrtjbbhX4obU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="308734038"
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="308734038"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:34:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="771548458"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2022 11:34:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 2 Feb 2022 11:34:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 2 Feb 2022 11:34:35 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 2 Feb 2022 11:34:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIwZoZrxhiriBaII16Nhymdso9dL1qE+7+237hIhVgR2801C9HB4MaIZknUbGgM+5DG41ypwqP0T9S2qc4O6TxZ+JefDQBMDtahFVf/cNveiMVpbmK1x0+cTbKMUwELIX6EdvErTEDdFZNYsPN2SyOvpxCaos77iNKdDbX7wqFp9hoEpwNDNj8LMr+G26JZNZpaoQJRnHo8cCbUDpRGEx5C0lADSqx/Sk+TzJSsGEXsLxd9fc6TREjoZrmtANjJQXwt+qbzw79R9QHnJ8jXcDIXcXOnc6bUIMgKC2J+xXlcRgHg+QyktAv4wETwktHKcW/l/R597aSPjufJPyalxZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4v+akhOXy2hrQIgAW1tKkHaFeqHFs+MOuaoGIBbl4m4=;
 b=Y9OWrI5k0GxTLMdtDXIJ7Ptw7GVbWiwxyAf6GgXgNEEdwj7b6sLCHc53XO5fO8sU3JxFKjBf6XcnBOV7Uc+m8zU+np5y/M6ZlXofAVYSFbaSc0BstfYgRVNFGkAaTlNagnDz58skMO4+OU+Xnlr9mZ+pvTvHb9kZt2dgsL5aE8bHo+PGZcQbs/MGAQDwdS540Dk2LjGYrUkiVCWWjRU94/e4/7gXg2UHRfuHDjKX/lblK4LcpxruVcdYxkC12tL0oH+9CcE3JvmMj8oJxhy5aN6rdmlfDyU5hKZAs44U3DQWy7OZpYxVQkyhlQds4TuduBO3VvOIBd3GH35oDwTN3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM6PR11MB4009.namprd11.prod.outlook.com (2603:10b6:5:193::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 2 Feb 2022 19:34:33 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9%7]) with mapi id 15.20.4930.022; Wed, 2 Feb 2022
 19:34:33 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ixgbevf: Require large buffers for build_skb on
 82599VF
Thread-Topic: [PATCH net] ixgbevf: Require large buffers for build_skb on
 82599VF
Thread-Index: AQHYCAzJTdC6rocnTUaIwyNO+ZIFB6yAx5hA
Date:   Wed, 2 Feb 2022 19:34:33 +0000
Message-ID: <DM8PR11MB56216C0BF94DFA7D96DF1C98AB279@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220112233231.317259-1-samjonas@amazon.com>
In-Reply-To: <20220112233231.317259-1-samjonas@amazon.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6aa1d980-51e0-4e8e-70cf-08d9e6830a47
x-ms-traffictypediagnostic: DM6PR11MB4009:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4009AA6D5B793EC9338801C9AB279@DM6PR11MB4009.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MeUiva25c+7IHm77hxu0CsBN1/1vZ3wb/PtyBa1TdUHREMkwqjfhhkzy8PCt+CzqAu7rxC2iWUL0iN0SAYkLeVzpgMJZwiuGtOFEhvPFG8LX7Z3+5ntkqAvyUbx115fjrBrJ/xPXBCBPW1JXtX2eEI1PAIsfG6swat0kFBdPalDIybxKx0VB8xr+H4sI8st/pKASDyDziIqSNtsb9pIbScaFtFHmsa6Hm4iND2X076LzqEmTkxWzELFF6aryWdDl3W115OxZRwGbRAmfzgTS3TLKvEEpwBER/Lfs3tCji/HmXbKfSxjH79BIbMbPEy3QmvOWUWntm+8BW8YuSkpragP6/hp/7vt2wD2XxzlkhPGPnExzOUD4bUSixRr0MyQHtriWFMG77Ipl5u5l3dxoS0X3pJASuYskvl8n3qRWUCNO21tfVbHgxDzZiQr5fRHVWkaI2AJnbRrdPvSTepZevr9MMwVbx+Ll7SrubLjgB3vTl+Ff8iYPnUVmKv5HLPASmU0Caj4ceGCA6+Ofryj0Ez2kKx0mUcW2QnBl4BnC3/C11Z6xqyIXRjBtXOUiRZ4BqaN9mSzBh3ZafDLl6bO+3gorqkURaSwvgbK8hc8wEMZm4i/el6+Eok5mzs/Y7ic7hpbXZzP6JcSGcGSWpgIiLxaPa1kaqK4XI2vjDiCjqhjubiGT+VKnw3zzyiohja4gmyprGNDFYr+hM4EVQwBARQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(316002)(66476007)(66446008)(64756008)(5660300002)(82960400001)(122000001)(110136005)(66556008)(54906003)(4326008)(38070700005)(8676002)(8936002)(52536014)(66946007)(76116006)(38100700002)(53546011)(2906002)(186003)(26005)(83380400001)(508600001)(7696005)(55016003)(6506007)(9686003)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N2jXqJPGfPd992gjH1bEmYyUt+d/okpbysP+PUCYiP6izws9ppVpqFjIVhCL?=
 =?us-ascii?Q?EG811r5BIPxkW9sVE+VkDJcUTRsP3Inw5XkebOw9U7Kcic6MyQA8o/BVYXMX?=
 =?us-ascii?Q?DEW3S8IoLjaj57F9bAMcn+Ca+74DZQ5xjon8auiMvVioC71gEO60Bv7gOPoi?=
 =?us-ascii?Q?O4GgcM2rPYRJM/bgHLrsnOBl1RvJflNo8vThDoYHMPQzfWyllO0MSKYybB0f?=
 =?us-ascii?Q?l7uwCt4lD2P52ooMNLbvHERmjuNpu0Ww8mRVe0t9T/1jibCRb16p+TSv1eX3?=
 =?us-ascii?Q?sL/qTm1+Sj9hZ18PVoh7no3DyIJlghUCVHuiygNEig9tJQMoDlh3HzPmiodk?=
 =?us-ascii?Q?9mkCHZGSMXb2gIn5+QFh6U3LNfpXpx0u75zhByKqw+LoRaJHzTKuSWALxJeh?=
 =?us-ascii?Q?kMLIUT/7rwXBTnZAGfDhxgFMcWllTZmGfdg40Nw7rQhI+Fq0BHyfd3FDtyN4?=
 =?us-ascii?Q?1SCdF/PhjMQa7TBNUvJJBMywpJbHGDv0UYjcBCsLHg5IUXbhd1nnHPD2YaOw?=
 =?us-ascii?Q?i8l6TieBwAlAdRzKsKOwWG1bYuEKwoEMBHdCYNQH2Kcfh4dw0I9CAmlHR78p?=
 =?us-ascii?Q?/du/PngzleddPcB6k4b7xyxJ3z+pB+ndy6Hvi9EOwllJu94omZAH11L7wzYN?=
 =?us-ascii?Q?iQt4xQmDzhSUyVVmMyfSNBCFb47HCSjq+At0WYMPNlAsYtZmQ9T6sr6QI8YM?=
 =?us-ascii?Q?I4Bqcsva9sbaPmqIYEQ6w5jS5xWeO7YLPwUpD6DqZ1v9tN2vLoVxnkHJYnuY?=
 =?us-ascii?Q?F1ScEsa+/DPAzGXS1nYWDkzfvFtNfZhkzbNp0ful7GoWReAI4JXoOP8Pyohi?=
 =?us-ascii?Q?0+Y+ITno4XZRHh7AqNrtG0wWu5EYPto0V221uOgIz4smSWFsyFGDtVj1vnIg?=
 =?us-ascii?Q?QkCqYAUBLjt1G/sKWjtpR009xiebuaNQ/CkBJGGulyRXTG7aBlkpH+OFPdFz?=
 =?us-ascii?Q?21dYS/FrgSm1o/DtI9M1EqkvxUAgmsMd2W0ZZ2yNj+tb45PbUml6cioggmcE?=
 =?us-ascii?Q?mCGBAXHTU+AjUDMorZS/TRuZ7kEutdX/IhBzanNSscsc5NcM1prz3BUn4l5C?=
 =?us-ascii?Q?GgLheZ0E/HYBImDO5bsf9LME+H3Rn9cU4nLBpd4CH6e/k+dPx4f9SCJRD5lp?=
 =?us-ascii?Q?l7lPtsCLGNgLlv8gG7FtRnnShEcl8ZsbkQ4dtzvDpXmHSrPxB4wopkmqylr4?=
 =?us-ascii?Q?iZ/1VbhqsMM6LiBSog9U9LmMDqOarlS/0eavAx/KyHuygX0Frc90ijlE8d/j?=
 =?us-ascii?Q?JtNrR/dJhbt2kk3k8ZX6BAv0epgb84woudt/z3IAPH5J/QOVMhZWwLHMiYdg?=
 =?us-ascii?Q?jFSFj0X8t9loQf38JbICiMqmZCvZ1Y/QNkk7STS4Et2O1B0jTUau/kkFvxIl?=
 =?us-ascii?Q?lzmZxxi70xU1grrUyiIJLpre0Q0hOTNHxpBnmJngQ0V2UhoSkSa7UKCUQ4lV?=
 =?us-ascii?Q?D0Dx73xGDJfWKu1P0KT+7gQt/A0ey/eEbPLv6FxW2oZLD1pslTdGGRzoaySH?=
 =?us-ascii?Q?D0X6rFKePVDexQc6L96brjYpJteXsd3eoN4968MWg/3tMArxwVIaKyjubztz?=
 =?us-ascii?Q?ZyeaPBvr2xDKRjReD0GN9l77azEpOai9serXEU072GmBZ0ZWp+EJqZx1rd6z?=
 =?us-ascii?Q?XYUR6Gmf1gFwZE1ZETgyI2gBCkadwXSUH9AqTL1vIG/t3jz9koXyewsWp2Qm?=
 =?us-ascii?Q?K8OR0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa1d980-51e0-4e8e-70cf-08d9e6830a47
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 19:34:33.5944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GowbB0hzmdNscO6oq9pPjOodrTTQT7way0wUcIEEgHEV5EkxJb/l5ANNmAtE+WYMPVTRRO5sD7LFrJOUn7jt2M+hbHmL0vBlPa0gNcKSDzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4009
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Sent: Thursday, January 13, 2022 12:33 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Cc: Samuel Mendoza-Jonas <samjonas@amazon.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; David S . Miller <davem@davemloft.net>;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Jakub Kicinski
> <kuba@kernel.org>; linux-kernel@vger.kernel.org
> Subject: [PATCH net] ixgbevf: Require large buffers for build_skb on 8259=
9VF
>=20
> From 4.17 onwards the ixgbevf driver uses build_skb() to build an skb aro=
und
> new data in the page buffer shared with the ixgbe PF.
> This uses either a 2K or 3K buffer, and offsets the DMA mapping by
> NET_SKB_PAD + NET_IP_ALIGN. When using a smaller buffer RXDCTL is set
> to ensure the PF does not write a full 2K bytes into the buffer, which is
> actually 2K minus the offset.
>=20
> However on the 82599 virtual function, the RXDCTL mechanism is not
> available. The driver attempts to work around this by using the SET_LPE
> mailbox method to lower the maximm frame size, but the ixgbe PF driver
> ignores this in order to keep the PF and all VFs in sync[0].
>=20
> This means the PF will write up to the full 2K set in SRRCTL, causing it =
to write
> NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the buffer.
> With 4K pages split into two buffers, this means it either writes
> NET_SKB_PAD + NET_IP_ALIGN bytes past the first buffer (and into the
> second), or NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the DMA
> mapping.
>=20
> Avoid this by only enabling build_skb when using "large" buffers (3K).
> These are placed in each half of an order-1 page, preventing the PF from
> writing past the end of the mapping.
>=20
> [0]: Technically it only ever raises the max frame size, see
> ixgbe_set_vf_lpe() in ixgbe_sriov.c
>=20
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> ---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 0015fcf1df2b..0f293acd17e8 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
