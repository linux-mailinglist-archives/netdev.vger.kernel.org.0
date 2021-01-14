Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF962F5E31
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbhANJ6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:58:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:34421 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbhANJ6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 04:58:13 -0500
IronPort-SDR: DA8CAndxJo6Pan9MVEtPCUM62IOjSCjULTMYknLFJMxQcYhffPiMtQSMNsaLDKwSKFbyaAjB8B
 E8CdVZb3b+uQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="178491117"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="178491117"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 01:57:32 -0800
IronPort-SDR: U5o3kiy/mu4PI8d+1HffNn9rEeOlrcJ+gX+zmEoYwjKOJPr6d/iPEkw/ojv/AFW7fiqMb4oebF
 n5Fo65Jp6vYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="424897648"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 14 Jan 2021 01:57:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Jan 2021 01:57:31 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Jan 2021 01:57:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Jan 2021 01:57:29 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 14 Jan 2021 01:57:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhfMLo2QlrIs9sOaoY4SQ54num8TDpu8wVNWR2yOWRz8Feja0NKnVOpGDU1kvFDCaLNeZ8P552bsjo92u485i3WVwANNSaHHywtC2zbL66/w9ResosB3QDyIA5Cj1WtVRl+Gu5wlu9ncOz3x2eNi3HtYcc6OrY8ghfpi5byBZTJDv3csqVuGuF+B3kfhkg6Ndx6DQnBK8V4S4tMvSfdRolyWWWR/lidqgWBfkj6N1dFTooZRLlKZC0YeBxfns5xCYlyFWHflBc0dYUOppqd6Kxqv4lb1bAB3MnTuYaGvypWRnLWkcSGqZPuGWk4mgZtjLxTNO6BAEpKW71fYgpfpbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRrb4L2DDR4q2wsL2TS5NGrCxbS0+rTcTlPb6R9L0eo=;
 b=GXTuSoWlBfmHFgJ0YL1plWfCr0H1BqfizE3Lte12sK7j8lTs/DAsGA3Qc1AA/KDnxosBgXjJKzVytLT72mcimnPGGGGwbjp1OfL9hqciiqcg3+4lFBjGHvnPVvD91RsYrzJpxx3FHdPCvS8N1lIq4pChKONFGlm0Kc0NdLe/rby9rYoCyy/T4gX5rHk50jwr+Jph39KTXwPd4qPVoCBAcbExkcT75srH+PglHmenF3gqHpGdi+ujuxCpIwQ0dDhxgqXeIkhFME9czsLBgIHHUPUU5soybrUSdD1zvAmuOpD7EnwW0oKkZVSfkxh+oCN8rT59BdtGMV0/DXCqnrsVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRrb4L2DDR4q2wsL2TS5NGrCxbS0+rTcTlPb6R9L0eo=;
 b=aRAP4ktf37ETXJvPqAsRh5+K6JYMBjCqMbo2Yu81WlDygpwPFT8w1cLPoDY9igt628xECtqX+lFnTQ9w7nW+wQltISTCERaWCeWNsA5XDKZ8yzlXgJ9SlaNDHcJHBlyZg6chpkvwx6yNyiT+tVU4UamMbdUETMHVOhTxV8ocOoU=
Received: from CY4PR11MB1576.namprd11.prod.outlook.com (2603:10b6:910:d::15)
 by CY4PR1101MB2088.namprd11.prod.outlook.com (2603:10b6:910:17::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 09:57:28 +0000
Received: from CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::e832:8392:8dea:28d7]) by CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::e832:8392:8dea:28d7%7]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 09:57:28 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Wei Xu <xuwei5@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "jinying@hisilicon.com" <jinying@hisilicon.com>,
        "tangkunshan@huawei.com" <tangkunshan@huawei.com>,
        "huangdaode@hisilicon.com" <huangdaode@hisilicon.com>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "zhangyi.ac@huawei.com" <zhangyi.ac@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "liguozhu@hisilicon.com" <liguozhu@hisilicon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shiju.jose@huawei.com" <shiju.jose@huawei.com>
Subject: RE: [Intel-wired-lan] [net-next] net: iavf: Use the ARRAY_SIZE macro
 for aq_to_posix
Thread-Topic: [Intel-wired-lan] [net-next] net: iavf: Use the ARRAY_SIZE macro
 for aq_to_posix
Thread-Index: AQHWhrJTlOhH9ZnF0Ui9Tr4Lsx8uZqonqdWA
Date:   Thu, 14 Jan 2021 09:57:28 +0000
Message-ID: <CY4PR11MB15769D5697074F230C8742CAABA80@CY4PR11MB1576.namprd11.prod.outlook.com>
References: <1599641471-204919-1-git-send-email-xuwei5@hisilicon.com>
In-Reply-To: <1599641471-204919-1-git-send-email-xuwei5@hisilicon.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [188.147.103.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab8be4de-97ed-4be6-9c38-08d8b872cd76
x-ms-traffictypediagnostic: CY4PR1101MB2088:
x-microsoft-antispam-prvs: <CY4PR1101MB208871F60BCE25105BCABDE6ABA80@CY4PR1101MB2088.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MZkMXQAY9LexzqwXCVjOfld/ryEbt67e7Jlt6rTNCCwZcySUeAUvnn+Na6HJLpL2XoKZ6WMBwMKiqFYBAaMa2ZTKTp/Zqf1fONvWqxZZvop7p6V5Kox1eK+rFL5NbdHMMg7op/HXYpmxvnnDdVE2EGbOxaSX/mwin2Eeb01ON938yK6X17VvuuT+jPWOfZrkoKHEE/PWSr66811OoUKtScRdeGhCsM3g6nqiK2iXaas2PECLoFvzEKdVMK0WBff7waYE/21xsjkTnssXxEbGJ0cyJLWj8JS79N+nLNBm8JqTUuNsFiuyAG3JEngxFmjKzfEqfESR3vgoEqU00mpNpvpWJstaUQv0jghApr3UoDpI4eX0IxMuHauqNgSflw25uz6UPwAOc7noIUxXJa/m/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1576.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(76116006)(52536014)(4326008)(7696005)(8936002)(186003)(9686003)(7416002)(110136005)(66556008)(66476007)(66446008)(64756008)(54906003)(66946007)(478600001)(316002)(8676002)(6506007)(86362001)(83380400001)(33656002)(2906002)(53546011)(26005)(66574015)(71200400001)(55016002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-2?Q?ohT1bNiwqH97qfQ6B5fRVWDfRA3Uu5fHk1LcPn/sCWCZWx3Cdr5ZY5tLxu?=
 =?iso-8859-2?Q?qC3OmjYVCKy9MxM3OiO6I2bKGW751VpIv3RvzCSYur0dFfa4lycmkhNCo8?=
 =?iso-8859-2?Q?OPmTmc1fjvO8otZCmFrq5JURkDwihg3do2kEljh0OcoUYBgiS5TDt+lnyc?=
 =?iso-8859-2?Q?tUbmDpazJu3VMaQLU7m0TcNv2ASshXLr95SiESF1CSZTDMizvg1FZ8BGyY?=
 =?iso-8859-2?Q?/LO6RJKHnxdEZVDcdEFBji5n8YQAhweeQEToR/qH1DuYUppoqK8yxT1l6s?=
 =?iso-8859-2?Q?qbIWHAYLXNJOSDgkZyg2n+Ow/wkBM18uDF6wIsV9eCszE29bfdRFevroPo?=
 =?iso-8859-2?Q?O8rrfC9x96kxn4cGyI+l5AX7Sl+cB7VwHIFT6pEUcWk5rCuxq9nF6KK3A6?=
 =?iso-8859-2?Q?54PI2u/NkEiLFEkKcRbLCNoGzKMpyY1569uOAqIixFP7owJU8LjE0if7zO?=
 =?iso-8859-2?Q?hc6Y9+PsvQPfHaDqMh5do/ZpbICv/heexztQF1V1hBWMv7cH4PWd2+7hBy?=
 =?iso-8859-2?Q?pzEfw8TDTk+/xbl4gBRSqM1nBCi6iYSPYM40rPJSmz5PnVz7yFpZFd7mCq?=
 =?iso-8859-2?Q?F4N9jduEgXC//bFzvJfxoXK5wQGpJrv+s/A9RerrahW6tIi3jd4sUkvnfl?=
 =?iso-8859-2?Q?Dyj00HXrHFEpK22tgXT6sS599pslbenozN84ZL65cdl4KlB95JqA7qn9+5?=
 =?iso-8859-2?Q?Ot4APu230+Sbdog2F5DbwDqlX1/zY4pkTltnq/YlbMDPe7Z1jBy5WtI7Cy?=
 =?iso-8859-2?Q?i+8Gbp3XmIZtBITM01j0RAIMq3vAZf0n1alC8/dm9JPx4+HOFJYE2NAswL?=
 =?iso-8859-2?Q?3GUxXxRu2HNqcus0lHITWhJ9uf93hSEnK+L5YffcpwvedCj0FfjymqItQM?=
 =?iso-8859-2?Q?buATWmjD5AgSKzo8IJmZ5C0+pmezpO/+9IYIZeGVlFxEJ5w7y0EQCqkrpz?=
 =?iso-8859-2?Q?F4N9HgoUrvSYLmZTu7vUnZKvHQMqTlCPrJIa6uSLbvuX+vr6X1g1LF8QYP?=
 =?iso-8859-2?Q?O7qiADW0P6+NOzX5E=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1576.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8be4de-97ed-4be6-9c38-08d8b872cd76
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 09:57:28.4610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+pn2lHDB5R51vKImnNVZiFZCiC7eUDR/uHbsaIOvkiKGGpjuO4J6Tb3UsP1Ikic8lG+mdBV3CFQHNfTcEgSrNOM9IyM3JMkFjmFJ47p+ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2088
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wei Xu
> Sent: =B6roda, 9 wrze=B6nia 2020 10:51
> To: netdev@vger.kernel.org
> Cc: salil.mehta@huawei.com; jinying@hisilicon.com;
> tangkunshan@huawei.com; huangdaode@hisilicon.com;
> john.garry@huawei.com; linux-kernel@vger.kernel.org;
> linuxarm@huawei.com; shameerali.kolothum.thodi@huawei.com;
> zhangyi.ac@huawei.com; intel-wired-lan@lists.osuosl.org;
> xuwei5@hisilicon.com; jonathan.cameron@huawei.com; Jakub Kicinski
> <kuba@kernel.org>; liguozhu@hisilicon.com; davem@davemloft.net;
> shiju.jose@huawei.com
> Subject: [Intel-wired-lan] [net-next] net: iavf: Use the ARRAY_SIZE macro=
 for
> aq_to_posix
> =

> Use the ARRAY_SIZE macro to calculate the size of an array.
> This code was detected with the help of Coccinelle.
> =

> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_adminq.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> =

> diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
> b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
> index baf2fe2..eead12c 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
> @@ -120,7 +120,7 @@ static inline int iavf_aq_rc_to_posix(int aq_ret, int
> aq_rc)
>  	if (aq_ret =3D=3D IAVF_ERR_ADMIN_QUEUE_TIMEOUT)
>  		return -EAGAIN;
> =

> -	if (!((u32)aq_rc < (sizeof(aq_to_posix) / sizeof((aq_to_posix)[0]))))
> +	if (!((u32)aq_rc < ARRAY_SIZE(aq_to_posix)))
>  		return -ERANGE;
> =

>  	return aq_to_posix[aq_rc];

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gos=
podarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapi=
ta zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i mo=
e zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci=
, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek prz=
egldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). If you are not the intended recipient=
, please contact the sender and delete all copies; any review or distributi=
on by others is strictly prohibited.
=20

