Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC474742E9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhLNMuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:50:22 -0500
Received: from mga18.intel.com ([134.134.136.126]:17073 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232332AbhLNMuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639486221; x=1671022221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hGyKDzCT7KiCQ5WvuXYEA+u5GRNwBcE2iOTsAvLzNUY=;
  b=OvgvAUoHpsKFj2Y99wDvqAaOQGnC4COnbJlOlPjOFME28WUbrNfArS8H
   bCci0UIzh1B8EfSG4DPDw/oIpcPldUrNTlvWRgIxk+PBQ0VrajYDwKaoF
   qiMLB9Y8Cee1YH4WZZRxz7BBUaB5LGbTDPkwsQVxvz75DCawtYHehMcoW
   /I3FpYC9BA5DuHBJb7+5dbfNISfahW6DeUqf2WaLLHBLqCWDfzy4UNRUB
   FqeRVte7hUvuoC6B2LODPQGl3yPaT0uuVSZ1Bin7CXIk3RH+28RwVNA0C
   qEXJLESkuR6RQAyhK54SZ1o3nCkQNCyWumLqR4s7kvHnNGb6fnFxSOcEg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225829084"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="225829084"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 04:50:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="752970983"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 14 Dec 2021 04:50:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 04:50:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 04:50:20 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 04:50:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEMCpjTar4IoWDkN1tSbIP7cEtBWv4dAO7UzBJPRMUz15clr45HfdOkz7E+51uz928IPqQDRberBCgg0oNHwoPHCDRiE6AW4J6q2PMQCuHKoWoMNQ64Vb9C4Cbd+2wKyi9XMkFXZLgVGxB+8CUoUPa6T+V0zsReb7KJjqdlsbol/MSIWaqxOjcp9NUjjS3aGSF2PQVXCD0IHkgKJzbUuMOmb3Xuw1BChpXjrPFMdNKQl+BuOs2zvi4dqSEvfkfn5A75kju5R4+8tjv0KwaIKCqB8TZOt1z9aRtMeQXIE3beP9iVqAp3sI7WL3zBdjnz+ZLHcrZYYzmNgNx9oQuKUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FN2nedrt25Kc2po0Tk8qoCObNr3PILuaqbYn74d2uHU=;
 b=Dg6ZUu42cgBWLLe+SwyFI5p/JSuVSRjdY/KxQ1FRQm2V4c9pvlnSDvq1/coE6LobKzCznVHELAaGll9A0khjFiDfvPXDcgYWK+ZqfTpbYv4dupMNaEHUetuXlHD3xrcxLxlBO2bOVa0aWjDW22FR68Pu/TZrVqDr2V3XRdYv2UEv/jH3AiCVVIn8I6AIR8e81wzJ0VkbkDkutIEgEtt8crcuK5AYVm8CjXHMN8E8aJJnjjsJTldpkjCqWZ0vs9MmGb4N5rJC2+yCCvEL9p5u/93dmieN6XjN29O7iNmX6OUuqrvT/pKjHjLsJexF/qtsaksLey8isGXx51tS4zyaiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN2nedrt25Kc2po0Tk8qoCObNr3PILuaqbYn74d2uHU=;
 b=R5Zanh5EwvZdsmtK2sjCCj8HhSmyw8pgucDxHZf+0OsDhijL5RY1fKMuFgmcaVsb+3fLX21HIoayJbk/H3vlxJPQSTJJ0tcguItT1XR4S+cyaAujzRFvwUQJ4XK7kH7nJLMX21q4yaZDnZMbPFL8w6S3Ru8EE9JZC3RuwBT7eMc=
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM8PR11MB5590.namprd11.prod.outlook.com (2603:10b6:8:32::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Tue, 14 Dec 2021 12:50:19 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a%4]) with mapi id 15.20.4778.012; Tue, 14 Dec 2021
 12:50:19 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 4/9] iavf: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 4/9] iavf: switch to
 napi_build_skb()
Thread-Index: AQHX4I+ST1cKj72Da0Oqnd79bDcxXKwyENrA
Date:   Tue, 14 Dec 2021 12:50:19 +0000
Message-ID: <DM8PR11MB5621968F34C8FBCE73CD14E7AB759@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-5-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-5-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: 4b9714aa-d002-47a6-fab5-08d9bf0048e1
x-ms-traffictypediagnostic: DM8PR11MB5590:EE_
x-microsoft-antispam-prvs: <DM8PR11MB5590ED5AF242D824857D6579AB759@DM8PR11MB5590.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDYve4/JBNcxmSduUoXYDF+m06G/PUCPCckxRW4F8HbaH+Mqxql3VRIrdZv7C6rfJ9DEaB6BcFOzO1X56ludXl4na7AvptJ2WxUP26dz9Fv6dxiZw11kTx8gqQBTxWz+hIf/NoQ4PyIHsZtlz/oiYeIgjleB6H9hPzQSXQtdUHudCGkeAg7sKw5ZKsaVwCJCJb61xhU14wSyml88V8W1tQ2RQRqr4otearor+aHPF0Y7xUWJrmwcb+5keBM3sm0RxuC3wQFxA2QG6eTCRSp2Nj6FVFqkthlxRj8Nsez+8QPklseBfc0LvdWZyR3+5qMxqZZ9wdjdNKl7Lp3bmEBlNXAK/G1AdZywiaKL6UDJMU0+QHjntRWogTOXEse6IcSwsjRTdy0jNtW8zZolyC89HVL1INC1VUYQHDCtAKs0cjz0y6woXIdPEcpB1hDHqnzGrE5tbliDiNXZK+SqqkF3NF9Hy9PYjgQ05aTu++JKKSPzF4ZQ7e3A8k3RQUP9/j2JCw2souZMdq6IaAha/YhH9nlPL0KhZpxmdibV5zeV5ceRjyiiPQDPxHWDUVIDvF7qyJ2gaZ8i5gZfTZxJxHc3OnAUtpW0dhQLPKysFLzPoFs0Zp6gQBq2esioRiuxDmlu30FiAjuvrwBN2sVdCpC+p1F44FuujZdpuVMSYrUuY1G2jlnqHcAzv5DWKlFfC9Mdy4B2tiHECWx6Bc+e0/VF5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(53546011)(316002)(66476007)(64756008)(83380400001)(5660300002)(66946007)(38100700002)(38070700005)(6506007)(66556008)(82960400001)(186003)(7696005)(508600001)(8676002)(2906002)(9686003)(54906003)(8936002)(66446008)(110136005)(55016003)(71200400001)(4326008)(86362001)(33656002)(52536014)(26005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aZxUPrmwClwlOljPbpPqHPgNIPVN9Whv9g6nZQc6HQnErSnxgl8CSw7CuepC?=
 =?us-ascii?Q?WwwjMgxMVTLMJA8TxDj88oZGyxmuPXRDss9XbwEkcXzBhP2LzsutNRtaDuHX?=
 =?us-ascii?Q?k6kXT0UqElebqRKqeFHlR6vEQH+2Sq35XjFRbPjPAnDF0+jel3/2RXXk+FaD?=
 =?us-ascii?Q?1hUx981xy02oUdlQ8A+hpF5xcL5UzblOiCW5t0ycmMBPqSVEJXaYd1yLUM0O?=
 =?us-ascii?Q?rdtjFtBp8zTFCj/J0EiykoGo86I2bBp2b8N+nMzCwj+m4uzcidi/q6a1WV6y?=
 =?us-ascii?Q?5IVTQZfRlYPF1PnUH4eB+cHxQa4CCUib3Vl4yFp+ofgZzx0JPdfJnhrifkvZ?=
 =?us-ascii?Q?0WEPMmR10ue2m90AweOi06ZW73BaSoAYRGw7eM5kMtV3EWG/001qYEiAgHa2?=
 =?us-ascii?Q?mzfGroUM8iz3EUuCDVlf7o0P5D9iUD2acezgUu9puxOQuC+axOXjd5TTO84b?=
 =?us-ascii?Q?VXOhQhUVoiYeT+MgoTqL1GMR7SRQchSOUr+9S1JVQwqr0xib9Nmqn+lEnKd6?=
 =?us-ascii?Q?0T402q4qkAJ9YZ7ylO12pYQWnwe3Z7Zhf1YluJrNmiFpze1fsfRrC5LxdWuB?=
 =?us-ascii?Q?GdaN9UNYidMgHHGu1k95emj1IIIVxvme6gd78ykmn9iPCUHwLQXWMYr/auS+?=
 =?us-ascii?Q?rhWoyVhaZQUHOVVcE47QlXWqA2YEh1Rx3NJrSUCmzwxeHrBQLQR6T+OomUIE?=
 =?us-ascii?Q?HA596mpVe3vYsP7FuVXLa4dFvYc21lE40yjwssWV0C7sHLQrpQ/z2Q1MJEZt?=
 =?us-ascii?Q?Bibm1kYWykA5GTWqHHOhrdTzXTsLeAANFKJSxuoA53G/UdQ+d0BXRvWUconk?=
 =?us-ascii?Q?bWAvR5udHh7k2P5brFJzvGtXtscMI5RDtAJFRkRTJMMi3ybiwLW0BBgtfFqD?=
 =?us-ascii?Q?qxwTyBusXBYBpyTMGsyb3A8lhvIMQVMNf8iyLD/eS/CpFJNbY0YkdgT1rRS0?=
 =?us-ascii?Q?VFaU9hNNdGd+BYnWaKIqyr4QADSaHNwVx+qeckzK+QRqakE9kBlaoi3GTEBt?=
 =?us-ascii?Q?kbmMKAfcdGx6wIL4fmjJq2gv/yy/3fusM+XRxuogwQ6rv4B/eKkDUowDDbFV?=
 =?us-ascii?Q?00v8hmi8KBbZgz5fNdhPUgXqKHYrwRhW+eGol4Bpm3yiLHACSX+5EXf+AJnR?=
 =?us-ascii?Q?5qRQVCbKdY1y7YTAGUySH3/0eDYJYWbuQGlf5Er/kAQa1aYDMFcIGU4W2AYH?=
 =?us-ascii?Q?dalEfMFa9VgSpdI3C8/4aysP4q6JMssDuxHY7TJArMpt5eRfv5Z0vxo4EkZW?=
 =?us-ascii?Q?O0Stq1gTGgZzKRWNm3CdH06Y/S4qu7NY95QnzdrJVSLNH7ZMqzRgdcEft2go?=
 =?us-ascii?Q?ZnlwuP2GGKarLB3ZZzrepXzfYX1AKWPRbI81BOnZnxt/izz0qpK5JKPPbFBh?=
 =?us-ascii?Q?zwXbjM7yOAKFzFhLcG4wk/JNIsErjy55Ue9xXjk5JnVfF5JY0NIG0V4fyEjO?=
 =?us-ascii?Q?JbZn1VvvSb8RgFQzBy96Q833K3BixCLyrga7YU0+d8+8HaILKDoHf5O/ks5C?=
 =?us-ascii?Q?dc2K9N3GjoM1++TcChZVdnxx/QsTqTwJ5iBhDcqPD8lksFHqJ1Vrx5Ia1l7R?=
 =?us-ascii?Q?IJF9xzVoH8Yt5BqUAXUZxryPeJfhlzSCeU1fMrb/+kDWebbCVsSCFJugIaET?=
 =?us-ascii?Q?gxs9mezR6PYbaY+nQjKDFDEqSQIUiRyTWNeZIRdzVX/AoH8EOKMV3S/piYE1?=
 =?us-ascii?Q?Vz2zaQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9714aa-d002-47a6-fab5-08d9bf0048e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 12:50:19.2583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ljdgVZRlqi/71FNHppW5bM+jDW1o7T99yl5E9x5IV+QlPNxHwWw0W9b2OSZffkfLNKTSWMOKCAAakRts5e97dyplnyh93fkyiJPyxmWM7qU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5590
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: wtorek, 23 listopada 2021 18:19
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 4/9] iavf: switch to
> napi_build_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save
> some cycles on freeing/allocating skbuff_heads on every new Rx or
> completed Tx.
> iavf driver runs Tx completion polling cycle right before the Rx one and =
uses
> napi_consume_skb() to feed the cache with skbuff_heads of completed
> entries, so it's never empty and always warm at that moment. Switch to th=
e
> napi_build_skb() to relax mm pressure on heavy Rx.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> index 3525eab8e9f9..90fdd828e5d8 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> @@ -1363,7 +1363,7 @@ static struct sk_buff *iavf_build_skb(struct

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
