Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4270E31E709
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhBRHmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:42:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:64634 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhBRHjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 02:39:03 -0500
IronPort-SDR: RyBNMJTFoS2RvGzbNDRYdgmKfoZmoqZjNTp17FwxQMTgBN77WZ72QpuWIxAdh9IrqBHOy0jeNz
 yxgQpHsn2stg==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="268276700"
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="268276700"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 23:34:37 -0800
IronPort-SDR: A5V0aS4a4EeqXTZogQ2gfT/flfhNPGRdM4ZwzYlGymy7uSZ5GuDXjsEHQ19tAZ+keIyFGE/APg
 BLhlbVIBUDsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="401570840"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 17 Feb 2021 23:34:37 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Feb 2021 23:34:37 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Feb 2021 23:34:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 17 Feb 2021 23:34:36 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 17 Feb 2021 23:34:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4EhC6LM2IhS5fIhieo2CNoynLNsg6zqCHN70PW170bVRgSMFCMrUSKev9JLPsEuBUkSxMM3w6upF+Qa6BgGHKpk2QX1dGA93wn7MczpSpgYpu2VsfEOa5eyhLpDiIGU36nitOpp/rhe/uAlM+snFDVuZIIHFNT/9iG4gNRpnIsydXp73tBHlXD6bPmgrwu4Ep2r569k4DTI5lRhlr+Fv+llQ2XJCvQNP8Vj8FmRpPig8bQmU79n2763wpC+TbePD3CMUQOWlpo7tDLuGIGZz1tNbsrzhyb8lrHqyahELBvQ2UE6mb5XLX2F6eOEWtP7pPBY85+ZWNnaKTmSaXybHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbxI6BCQ5ZOzl4nMkszqpikAa8Yu2ofy6/tqC+5SGUM=;
 b=kgQyxh53N61iL7Zpomg+ZFgnpxyxQDbuJ7S8Fbr76oIdGSWWjoWGj01YB0WmJiYHd8TIvR84cnZSkoalzDDYrOLZW73YxF9PeHbuonYCIjQWAgUFRgHpNGmEcdWFpY+cEpK9ed1CJbCZ3Xc3GiKZ1ximCVASJ2ZhXKVnrEzvaIUmjDY0EOXuB5psHC8KHIXPmoKYS4QUaOcCHlgc+ZM6Sob6BmOeWEgzcgCb4H4MnVyE94JanjIfZZ9QvR8rzEAdSjYytyryFSGPj9Zy9AR+zsV4adgLBSjB6J4c9MRKr4e/VXx1FXqwq8jaRTQKmrxkDZx6T4mshN5NDNpAEIVhQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbxI6BCQ5ZOzl4nMkszqpikAa8Yu2ofy6/tqC+5SGUM=;
 b=qoaR7WvGeeMyFsBlMeLPatxj7TjQsvJhc+LDoFtwKLFN4Fy9bq9/zx324/DNluwBbaIUhWk2GRKSMAyC+pN25cYhVp6MWsflbRMWWWliXiIAWlbIkVQnU9oBpK0UqZe/YYq51ymiiGI+WUqX89/pkA40yU/3ko9bYkHSdpyZTzQ=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3094.namprd11.prod.outlook.com (2603:10b6:a03:87::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 18 Feb
 2021 07:34:31 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f%6]) with mapi id 15.20.3825.039; Thu, 18 Feb 2021
 07:34:31 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: RE: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Topic: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Index: AQHW/9aKF0BC8ECZBUGvMe9o72Vjw6pdfE/w
Date:   Thu, 18 Feb 2021 07:34:31 +0000
Message-ID: <BYAPR11MB309511566DBD522FE70D971FD9859@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-2-mike.ximing.chen@intel.com>
In-Reply-To: <20210210175423.1873-2-mike.ximing.chen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 631880d3-3994-4e12-136d-08d8d3dfa1a7
x-ms-traffictypediagnostic: BYAPR11MB3094:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3094D9FFC4BBC5704908171DD9859@BYAPR11MB3094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KkQzcVI9zBXaFUC6XGk33wUvlsXnbzQjrlNNUTDL3N8A1NVLtJIvE3vomwt9M0fLA6em+scOkDYPw1IX8GrbRqUgcFPb2fugaT87YFQ9J3+sGZwlr0TFNs4ItzTMohoZ99+ZYRGoaUT14xnLq7BHyWV+P+BiA00AYqb64fncUFNAECZuyWpfXGE85PsJyYozrXxMfWeIXT2WgZIq/vvDo6CNWDW0D82fSLofTbB5koE5wUjrafQ+wPfDeuoG7mpBARHEfOWYgt+X8yhcYc8hOLE26Mdm24+h6ElfSTjM1v71WeeAiPA4QmlvOBBTdDIvvNq1z0hjLn3F4PIEFrIehT9eY8NbD5zJbTaSPMtjaRkM8bBfJGqwU8yVMQojVvWU7ek/yQxStUNGBICY8vstLvqWR7GSYe5avaBgT/TWoB8VizaqaqxL8LoLVjW3biCWMlmD++N9E7ieltv4G6+L36xl57kz5tPBFsKlOavgrlopr467gfd8RDkUs3h9kLCSHSqyxlfyiVat1eZgILQJeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(346002)(396003)(376002)(2906002)(86362001)(7696005)(9686003)(5660300002)(33656002)(4326008)(66946007)(66476007)(316002)(478600001)(110136005)(52536014)(54906003)(26005)(55016002)(64756008)(186003)(76116006)(6506007)(8936002)(53546011)(83380400001)(66446008)(71200400001)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nv6XgJQOpIu6Be6RtuGpYg7PesQSFFmdDvxQrVbd6yXcI9isKsTDKIIcqgka?=
 =?us-ascii?Q?yl3OZX3ad/WiXRYJ6gEKq+Yy1Lz5XtdSWWxtEW/QHLI7mbMF5PKZF80z7fJa?=
 =?us-ascii?Q?0wKsai4MVXgEjO0Qg17feV9LuOsmrkQZbZSUgCQW9NJCzCLmA2Gcxiz7u87a?=
 =?us-ascii?Q?FHhrYr6vcWahXe7G6QtWacJyA7WUkqk+sMC2WQiBKvm30AbH9M2F1STwXJ0s?=
 =?us-ascii?Q?T/CCzCxcgqoMCEIkCILQbgLQHHvOtbL2xL+dOGH8NFVvGdUDtQiipAVhR0fD?=
 =?us-ascii?Q?DuxuCUvNg5D4do9lcv0xDfn452l14GUQ1WEM8DDFAd2PsLT+9Y8czPXukR8/?=
 =?us-ascii?Q?0+dPTrZKI3MstnAk28qitlv1hZxYB5b9DaMwgz9NXPvhm6P4HJO4hORS8LMU?=
 =?us-ascii?Q?OgkafNqjxZIPT+CInAhtpqVDQt95AEMn9TIo9F0LiF9jFWpJTNqtKKJnzNGu?=
 =?us-ascii?Q?k5oa5KgtjvQEvANtL/b5x9VYNPJkBSLaNUXq/FarQwcT6Z31VuEho/BP/TjW?=
 =?us-ascii?Q?wvvrcQTrbZ6+HmsFjkiJUxoD3GX7bQRMnfric/LFvIs664uf8VfhcYvhuSpW?=
 =?us-ascii?Q?YFKkzkCwkgQPCv+tWDKdQhXNlos8upvwyOt1Fxlcw3vWyojCU/4BduGZkLuM?=
 =?us-ascii?Q?hwiBZM9QkP1ppUeUnawnMzQwm5Iv8K1MF70pS76SVGYKamiBHrEf60bvpUd9?=
 =?us-ascii?Q?BEo4cIyezP16rtK9iSyiLT5wVNEPaI5xJcpOqsW/voU8VZk61Sk5tyKtcNiu?=
 =?us-ascii?Q?vX/XFRqSTHPsCoIleMfwKP24PJqOnemMrrvhkQir/02ZJy1nBDqsU2nPDH2y?=
 =?us-ascii?Q?eClbMveQWtqGMwH9J27YeWhBH801PXfgyXHAdi/Nrhb5iMzgBfOMMts+FDjV?=
 =?us-ascii?Q?wU/cfHywr54Pl8mOGBGiJoI6QdfchEEzf6eBHOFA7K/NbloHPB9ly00vfOXt?=
 =?us-ascii?Q?2CsAbAObR9WKVdpQ+0zX3rkAwkfQ5T0PrEwBPJjLAA9oqAFZsTH5/q3Y5x0w?=
 =?us-ascii?Q?/VEkJnDkrxpigDXR8k0EkpTRgJIz7EYNq7s/gSlLAnA2fyzS5y/9q6WaJrkH?=
 =?us-ascii?Q?TshSgSeatT41cvg7iN3EBIeH01yLKVrUidBFsHdSsZTxEVSG8eWVX7zYrWP2?=
 =?us-ascii?Q?1etOjmAQueNywwObTOd6Ni6YbmS4D26mCZZInDx84hieBnrMKrrjFXLGzG4V?=
 =?us-ascii?Q?1IDL72yWseBTROugouQCHxqJX2WqWIwwUtEAaIBKDg/Ulj0bgPV+qv4Pf5hq?=
 =?us-ascii?Q?aHiOzHBRAiIkKniLdnlHM4aplk+WSE9FfDH4/ZHw+jUdmNmow6jFPACCtsMc?=
 =?us-ascii?Q?29VyOex2a3Ei/SIxYPAeuN7I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631880d3-3994-4e12-136d-08d8d3dfa1a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 07:34:31.5354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WyLmgoT5zE1HlpZYE4nbbUyyDLJpuWCCTqHAvKXRt+GAtbXIqLHOXY22jVrEADmar9ZLUZQ8uPPtSFuSi2GGTpPGGIBvRlILvRhvbvQj5mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3094
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Mike Ximing Chen <mike.ximing.chen@intel.com>
> Sent: Wednesday, February 10, 2021 12:54 PM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; arnd@arndb.de;
> gregkh@linuxfoundation.org; Williams, Dan J <dan.j.williams@intel.com>; p=
ierre-
> louis.bossart@linux.intel.com; Gage Eads <gage.eads@intel.com>
> Subject: [PATCH v10 01/20] dlb: add skeleton for DLB driver
>=20
> diff --git a/Documentation/misc-devices/dlb.rst b/Documentation/misc-
> devices/dlb.rst
> new file mode 100644
> index 000000000000..aa79be07ee49
> --- /dev/null
> +++ b/Documentation/misc-devices/dlb.rst
> @@ -0,0 +1,259 @@
> +.. SPDX-License-Identifier: GPL-2.0-only
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Intel(R) Dynamic Load Balancer Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +:Authors: Gage Eads and Mike Ximing Chen
> +
> +Contents
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- Introduction
> +- Scheduling
> +- Queue Entry
> +- Port
> +- Queue
> +- Credits
> +- Scheduling Domain
> +- Interrupts
> +- Power Management
> +- User Interface
> +- Reset
> +
> +Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device that
> +provides load-balanced, prioritized scheduling of core-to-core communica=
tion.
> +
> +Intel DLB is an accelerator for the event-driven programming model of
> +DPDK's Event Device Library[2]. The library is used in packet processing
> +pipelines that arrange for multi-core scalability, dynamic load-balancin=
g, and
> +variety of packet distribution and synchronization schemes.
> +
> +Intel DLB device consists of queues and arbiters that connect producer
> +cores and consumer cores. The device implements load-balanced queueing
> features
> +including:
> +- Lock-free multi-producer/multi-consumer operation.
> +- Multiple priority levels for varying traffic types.
> +- 'Direct' traffic (i.e. multi-producer/single-consumer)
> +- Simple unordered load-balanced distribution.
> +- Atomic lock free load balancing across multiple consumers.
> +- Queue element reordering feature allowing ordered load-balanced distri=
bution.
> +

Hi Jakub/Dave,
This is a device driver for a HW core-to-core communication accelerator. It=
 is submitted=20
to "linux-kernel" for a module under device/misc. Greg suggested (see below=
) that we
also sent it to you for any potential feedback in case there is any interac=
tion with
networking initiatives. The device is used to handle the load balancing amo=
ng CPU cores
after the packets are received and forwarded to CPU. We don't think it inte=
rferes
with networking operations, but would appreciate very much your review/comm=
ent on this.
=20
Thanks for your help.
Mike

> As this is a networking related thing, I would like you to get the
>proper reviews/acks from the networking maintainers before I can take
>this.
>
>Or, if they think it has nothing to do with networking, that's fine too,
>but please do not try to route around them.
>
>thanks,
>
>greg k-h

