Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F353B4AA3
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 00:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFYWoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:44:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:33591 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhFYWoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 18:44:01 -0400
IronPort-SDR: UatXbjzsiggWLVRl0cZX6y6g18AfnntGkGVkIk6EtmyRiulHK+Z9OKHTlEDu+teuBkARmkv5O5
 F/V2no1Y+jGA==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="268882299"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="268882299"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 15:41:40 -0700
IronPort-SDR: lZWiNXoRaTXbo1IrFeKsn+kZy1/XXzprUqyvRZEDMSECl7P/ZOV3kBsfUEaZVWcyNR427iVwb1
 NnLQvcoOsDKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="481985097"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jun 2021 15:41:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 15:41:39 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 15:41:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 25 Jun 2021 15:41:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 25 Jun 2021 15:41:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTufKGll+kzQg6DWV3xlGe6b2/IOzWZN3Tple3TEuKchQRMg3QxPgzLkqWA1CrBwxyCdTmOJf6e7x6tzluPABYkX8S5BmZj/V9fApErKvQOo0QBEbZLJeyOme9Vf39NdS5GC+c98SujuqKhqW2EMo+nzgYV1Haptk6d0HznlPK7stIfvkIjg9ZfOxQ/BiWBC/6ihYfbgQ2bA9hAf3cr8UdDQCLXUZANQmf66Y4SufruiXmCVuo+Kn9U8RiCfPvbkXtQcGQ/JJPV6KeaAi5sj8ibq9DjeHWIF19a9QqjoFxJWFId44X90+vhidSz0HxS4JyZjan6KyoK2xuVqfQvxpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgFD13lQ0zetoEnNiAOmPwOYTRh6IW03RZVwvDXgpEE=;
 b=f1q1W7uFhkuHXW0vx3BMtkEoZqBqKRVsXYPj2IusEFN1BwJQfp4YowmuXUw7vwWuy9PYeMyAGDp4PC1+cDwXb4z4mB/0rEFVqrIizzb+7p0NArQudIbfYyCqGKnKn6VbGW3asDiHB6EiXCvwuLitm82kD7MhwN+l5IZArFC+NzYZqT5NzdPJFYhj2nlXvH4nmL2Bmb7DcgQozY9r/mDE/gnef1HOzCPtLqXqgMQy0onC/kRXbogrpMUX9VkjhdLi+hwTBZwa8i0EMyWSr7y8G9pNStJGW5Xx4sMRe/yLJEm/WUz42SdKG6gT4B+CRZZZBwq6ueZbgCl1TKgbFJmUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgFD13lQ0zetoEnNiAOmPwOYTRh6IW03RZVwvDXgpEE=;
 b=QhBoW8tr9SRO5iPus+5Ej1SY913FFAQ1eZ7lUTU0igbyTKMQLdCyC3KvYDqu8vc4QOs42hKcA9gNu4Zr4SWmgyTgfrU0pDrh/51tqWVa3hHkpLHYXzFfLwHgcHZPbAV5Pf2vSzwOCXS68GzDiL5W11mq61RBmbBmUl/vMDutwp0=
Received: from SJ0PR11MB5662.namprd11.prod.outlook.com (2603:10b6:a03:3af::7)
 by SJ0PR11MB5597.namprd11.prod.outlook.com (2603:10b6:a03:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 22:41:37 +0000
Received: from SJ0PR11MB5662.namprd11.prod.outlook.com
 ([fe80::58ac:cdd:41f6:93c2]) by SJ0PR11MB5662.namprd11.prod.outlook.com
 ([fe80::58ac:cdd:41f6:93c2%7]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 22:41:37 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] igb: Avoid memcpy() over-reading of
 ETH_SS_STATS
Thread-Topic: [Intel-wired-lan] [PATCH] igb: Avoid memcpy() over-reading of
 ETH_SS_STATS
Thread-Index: AQHXYulUYEBKBRvrOUOwmiDlPfn9naslYJZQ
Date:   Fri, 25 Jun 2021 22:41:37 +0000
Message-ID: <SJ0PR11MB5662F0A8BAFBC724EA8347E6FA069@SJ0PR11MB5662.namprd11.prod.outlook.com>
References: <20210616195319.1231564-1-keescook@chromium.org>
In-Reply-To: <20210616195319.1231564-1-keescook@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f4a728e-03a3-4f99-8ceb-08d9382a649c
x-ms-traffictypediagnostic: SJ0PR11MB5597:
x-microsoft-antispam-prvs: <SJ0PR11MB5597152198E373A893725D5DFA069@SJ0PR11MB5597.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jM1ajXEsCHpASmEgkjeYN85Cd1+zz9RCu5sETANNutElZhPXKoTeo9/7iNIx/pwt/PKsuYbRqmtUBV3aJgo+zFuhEiCp03x15iotH9s4d3qlNUL0n0M1jIHJabUSVMmMT1GO24zHmaoiVx8b21AhigVAvUCpKVnV46EMuzVMSo7xcj9aVGzPuAY2+Wkq1LYKsc6EU8M5QS7rFx+F3zyIiEhMruoi/TyXuu5Fz0tEf4shoUiC/Ldb5mW/hKPLISPR4+yg/MuAmaVEhJcM7TYxmy2/60X8NE/MWu1FqJdUTOa1zncB+c4Oo8XQLwb0Lx9zxZiLMGFtagfkIwiRYabVtyIxwJHF/P51+GZKUNkoCYYuchdgKG6RTObC7dIBr1bqsu/xJAWloiGX2/KwOcOsI7ytZxpdm2oaSRIPHrCkQ5O9CIubeBjEeod47WPYVwpTLww8S13Sk3C4X+JsOOpHda/9d79hHqGvtOl+fWBZUiHdBPkEvwpFdUQYszq4pAh/gH0ShB/At2WIOqeGiLcUfHL037gUuKqMqt7NphEeh+5mU8+gz2i9G6yw4kWGZhBm5OmWJqOWOHz0NYSY8rqLzO3TkLDhW/Q+WWrjGzhlFYA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(66446008)(64756008)(66946007)(66476007)(66556008)(4744005)(2906002)(8676002)(71200400001)(8936002)(110136005)(54906003)(86362001)(76116006)(316002)(5660300002)(52536014)(55016002)(33656002)(38100700002)(122000001)(83380400001)(26005)(6506007)(7696005)(53546011)(4326008)(9686003)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+H76tJRN/2LSabiRUcfCjdAfesDkRvtnkZg0TQuTRGiz6hOaIbdUoZhhE6jB?=
 =?us-ascii?Q?9+zJn5l08l01pUNjSQ+TbaMyvCdhNXp6mQWVMghjBosSUvKx+jxoSq+JPCOx?=
 =?us-ascii?Q?Nt/uTp0ulJArh1eagaSV2lmHJwnh9nh+bZ13XaTXKUmGHB/1Ouyn47Onc1mc?=
 =?us-ascii?Q?vZ5khZ/3yY1yUn8of0pZt6cZPgoLd8YB9CKJGti3urBEXZvKNCiva+AaxmcK?=
 =?us-ascii?Q?B14YdfAUKZYUw03c8zXqwmMHeRwGdPCdXEfwKUj9s0TNU28C1mV8U1qcNssu?=
 =?us-ascii?Q?8dDjVK7Tg521QyGBd8NBlrpG2QekSz+JsnRlBdMsv3oDaPe6zRxNxTzSLacw?=
 =?us-ascii?Q?p+ff86KipiypvDLujXZSpaKDRd0udkfRaZL48xjiYbKHbCJmenXIGvnVJuff?=
 =?us-ascii?Q?FK46gEQ6p9IgDKL1tNL8gY0jSMw9/jvfhvu54KvnI4TAXrcTDvqD4TrNp2fP?=
 =?us-ascii?Q?1l6IdzHwA5dqrDExd3nQ/RpLfKsrfOWuuccax6QbhG5zwzVU9DaLncnSeECN?=
 =?us-ascii?Q?0LEWjNDRQD0NfMpntj2k7jez5KKusCFSrQ7QuXZwWtaetr63VN4o6pI38YpO?=
 =?us-ascii?Q?PPSVmWm6vgwaaaxiFYJqjXrpPuK/Az+l8cq848wOZQsfmR9ZR4u4Uff+vvk0?=
 =?us-ascii?Q?bB+pHgeOfBL3/t7jRpP5GiF2dyioeXgj8064kzFxt2bYCg51JY35LyxFM44z?=
 =?us-ascii?Q?0loihlYSq4mOiV20oVcuPKg0A0TSaPMCs//njJIP6WIlko4wbqBuoN6Ss49r?=
 =?us-ascii?Q?RDsUIj5EOzyJizR9pDV8jgttileRvbRSs7gnZ33Z3j2J0PG+r338JVmsCrzv?=
 =?us-ascii?Q?FpQ7p13Bgh2N4RwasUU35bxqRxtTzph1wNolEm6qTer8EZaB90nXNskerrzB?=
 =?us-ascii?Q?euE+Bgzu0SLNCrFk3xT0yCg/+Txrfky+ZrvpscZxyK+i2j3xzTtLijfOR2N6?=
 =?us-ascii?Q?vX0dMVd7wV1BFAi5gJqe0p0/jRt5LYNKwaGWSeqBKaTRVGcKIPuJpfnEYIyU?=
 =?us-ascii?Q?mw39ObNe0ZR8BsjAlscZO/DTIf1Y/hszPxe04tFL14BcUe2qABndTHXsJBYj?=
 =?us-ascii?Q?Gu1BflsFXlbhpS8nXwIJ1XvmrwfS4L9+7iSBxA1kzB45CYKynQtstdG6x94n?=
 =?us-ascii?Q?Q2iYmNE+uVjTXFwq3pObwfVZ7MyVHSmxll7NTdVRcNbnZNxfjYdWKY6hm8Ac?=
 =?us-ascii?Q?8lb1GVeCJLtKLMJD9kzvpAShQioki8Aj3t/d4NQ+qPLCbURbv70AXElZPU8r?=
 =?us-ascii?Q?jg0NwkxNFHhK3i20cV9iynJezKohdFCRVO0YJ7uwy72C/qsm2gZxWpBgBz/I?=
 =?us-ascii?Q?jzVR4C1KrkL0Am1q7Wmh0Pda?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4a728e-03a3-4f99-8ceb-08d9382a649c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 22:41:37.6035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6BqvZdM3f7fSyzgD67+cAjE4CPZX54PpuI/bZtZ/GVckT+OVoJ5EcUN0tZQvwnSviMHx0adu5FZyTyM6y6qMG2Fjuix0zlRKWqpAg2t/mxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5597
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Kees Cook
> Sent: Wednesday, June 16, 2021 12:53 PM
> To: netdev@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>; linux-kernel@vger.kernel.org;
> linux-hardening@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; intel-
> wired-lan@lists.osuosl.org; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] igb: Avoid memcpy() over-reading of
> ETH_SS_STATS
>=20
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
>=20
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> (A Contingent Worker =
at Intel)


