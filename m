Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E30485739
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiAER3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:29:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:34039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242225AbiAER3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 12:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641403744; x=1672939744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=znESV/N4BiItlT6qEi7q8CV7+781jeAE7zeikQTQkY4=;
  b=RosyWZHBbuplUisS9IG/19s7wyW823Lmswcgzkrg0746d/C5lemuhQTs
   WbFExbkq21koe/DVqhS5MkfRjU0I8Dy3UQA+d7zvbrr3Bb/yZoBGHTvYZ
   5YcSnhEcQvrYo476qu9UHikuePeiWCwE8oRVwlZVxu/abKrivbmd+kJyO
   D66VaN5mfY7Y3KqAxvhAsw5sui4rQ3E23rURhCQRW+b1FyQBQTjSYIfIt
   EppPUX16e1ypbx+PZ6K9fNmVZuwwrleBEf3LIAcCO6J/L+6hewz9JflN5
   +pNbBbszLogG8SXSHBL8qYx6K3qaiDEHeQMJcVUlji3R7mlQK5VSrMj/t
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242288693"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="242288693"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 09:28:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="513035604"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 05 Jan 2022 09:28:50 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 09:28:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 09:28:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 5 Jan 2022 09:28:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idmXp/oCO1frsyk85GGl5VppD3bTvwoYQt5jbk4QrIInhgO+0KTNauvuyniOjDKHx2bcUq4CZLBDjnRvbcov2j1+KLEVtBgEDzMQCzZKILwvnMXIG1ksuJD65Br08XV+WWwyfQMPSVhoroncGoDaS8vh2MEGXrsIv2/ih3pvaEdMyhn9cmtfUFzxPuehqzmgpah0Zgyp/hlyBHJxupGy/wwnFKRK6HicCyccQpeBxW8jZwkuaAHkzwOX/5Qr/olsfAtNuCPVO4YodC0HJ0roiJxODkHafdl+C0fBYiEGwtVt2BvxGbU251Z9Wbp0ADhKF1oYwbzyLpqi/n/2+6t1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfJEmxLA5XTrfVfWekZH4GCGsypCR58AS0Xwe+OBIU4=;
 b=XMKE/ehwtSsrRuN2t+orEPQS1iY/pwFSly0Afgibp1744jqGBlWfOSvzQKK0JNIAlZ83BfAd6U6AIYOCASTxl70YqNCxtxfUUlP/N0xP1WKIoE/GXUzwFbGsjx+aGiN146PV88RDwqzX33VHd04blO5d7yluwxBxqocyXUO7NUATSBpIbmGkAqEdGCsGH0pS6iZ7zDjn2SIXwpLNp7oUo5gytAoPVp1zdhZCOV5EUNo883kbaj1fZMYpmDuRBVCks4bqMJYvP5ehQVfego4VcFxbF8b3BmZ0d8/DvGp292yFAbn9J33i+ghUskqYxb3IvwpyyItZqPbLH58FzEPMCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3159.namprd11.prod.outlook.com (2603:10b6:a03:78::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 17:28:48 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 17:28:48 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Optimize a few bitmap operations
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Optimize a few bitmap operations
Thread-Index: AQHX99wLRCQtlTYs+06qA4hRGmJh26xUw4tg
Date:   Wed, 5 Jan 2022 17:28:47 +0000
Message-ID: <BYAPR11MB33679085DC82B376235F8885FC4B9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <b0cf67c12895e40b403a435192d47b0ac1a00def.1640250120.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b0cf67c12895e40b403a435192d47b0ac1a00def.1640250120.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2839bcec-9b4d-43e8-849a-08d9d070d52d
x-ms-traffictypediagnostic: BYAPR11MB3159:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3159E5D01C75769E4551B3BEFC4B9@BYAPR11MB3159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cJ6aEkq4rLGCqM/morLLYHbSWfQjzhZ8bgDsltpQYbfh94MrfF9eEJSRvc9Ybv4Q3/NRCN4ZnCdXgk84fE+5rFDjvzFDC2tPilrZ7GqpCj1WWoYUouBvj3GjeeKwMbLFhFpm4LFBvv1r/sC8w8TNAIgPy7PnqpnTaigtfe/xSvgGEUALGeerh/qZDBflx/AU233G9wrZUHdY/wBgoPtZNcapc2b7kMFdGUOGPFz9A0LBTOb0564ES8Pw4oqe24+dM7kSyO6nuKyRctrgipUCIUnpAbR2CHRsBoENkxteU+MEeV/xLx8aOubRQuti/nn9rgu5AaMJD2BqA+EWdvesbZDp2abLrZle5WX8excBsv2ECQxLpK4U9qO1gP+7D9+LwsVEOplzm0NeAa7FkOSM1UriqEPwPcspEDvjSBYh3GZ/eGFE8R722rzjWV6dTwFP9/PpaGWH6u8S6thc1m0D0gT2KVsRIoBpZKpex9nBg45OkOZnKZW/E9Bw8FtiixksqfnA1I/4XRVGkSC7QkleVYZAbFyzlofdRcDp+CTCejqgXzyDGS+KJV8xXwIRbB8SSInhVw/lHHZvqx0yABZgEVIO0QPEU85HEtYx2SCzQQL+tnTqAREgvhiuATDCmQ/5IcRCRm1TvPMZKOMic96d3Rr+NQWVKP6vAZoclH+IBVGXtNQOEa/AGQqGssy06DUGX7pNzZ7dmrvm0Afwe8XAIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(55016003)(4744005)(6506007)(66946007)(82960400001)(4326008)(9686003)(38070700005)(83380400001)(38100700002)(7696005)(66476007)(86362001)(8936002)(66446008)(66556008)(2906002)(53546011)(64756008)(71200400001)(110136005)(26005)(5660300002)(54906003)(33656002)(122000001)(316002)(508600001)(8676002)(52536014)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0bJ5XldXTWTNC5FF5ut9BasfaFSYNF2ZYoXh8s5QWVR0z44RSniueHwxQ/cL?=
 =?us-ascii?Q?vcFVb8MF5kisqLb/TCjXC7bDRSNIQIeBQzFO3yR7fNzUZJUlA8MIvZm00DSy?=
 =?us-ascii?Q?ARYfD5rWnpxIcHx0U2Dtl6PcIoUZf1lP3AAKb/zaGAdvIijB1x2b5d2G1LQD?=
 =?us-ascii?Q?fYNfNOMNIjrzJXHj3Cst42zJf3hqANh5u3rzrOU0/VkvyIL/abQPB/Yz4YuX?=
 =?us-ascii?Q?UKhymwRvDzyJOzMS4aAB0rbbeFIqlTI+rEBJMszilcUbHNHt+G5vRIsjY9th?=
 =?us-ascii?Q?F9Y2b6BStWXbLGJvpl6BQw9fusB0CTmr1MLBkljzKwYk5wcEx6/Z9NAIEmSm?=
 =?us-ascii?Q?X7+CGeD59/BKB4QRmysQYqWA2HyFqgqIz687xswDcXqqk6o3Yc7G7Lokn5Fu?=
 =?us-ascii?Q?G+AmNm3IgTznUCX7tNOtU4xfoRHdZ41mupvuRHYKTXkl/H2lE+97RPIN+CWZ?=
 =?us-ascii?Q?3y2+6L+YIhUXmMqBVN05V/JGOeASt2c8UbzRV1yHWB5BNdsMUr5R20LKQkMS?=
 =?us-ascii?Q?9klqBLsSpySGhs0Ag0ut61g4NMpBBYYU8e1v6Dc5xK1i49Q8vti28oONKAtk?=
 =?us-ascii?Q?Bs53CZ+b63BTiWmYgknEZbgF4XzMb/QDYkjGoBGBG2jKmmQBriXXSxR53XXl?=
 =?us-ascii?Q?/bJfyC4ZQxKFzLzmjcDCHWO3B4vAIo1X7ypze2oNmvZUnK/nmflhRUYIBuVe?=
 =?us-ascii?Q?vY+iUoVdagra3O9vkzBmVHrt1/UVCT5RLP0VhzkBoDu8Jgj4magh2nuSurGa?=
 =?us-ascii?Q?YQi1noCrMK1+NS0T48NmTk2JD9Cr7bGfm7rzYFUX0l2PjGj9sC22RAlsi5Lc?=
 =?us-ascii?Q?K5/xd1F2HpJzOyVbRZDfTSmyUE8P5iHLRKbYZW3FouK2Fck5CIXfTVvBPahs?=
 =?us-ascii?Q?+stAfrqcuuWPccM/wIuD+beI5PY8lVm97il6o7bjIKWe8pxcDEmuNykNTiT7?=
 =?us-ascii?Q?+ODmEys42hTBUtXd62Fa9JgQB16bIJQKxZWsSrHubl2dvhlwAzMNhIYjVqyo?=
 =?us-ascii?Q?CpgWF7iWuCuwaIscmZDSFsEeO/jnZyW9wA2DWrNzOzROTjaQCZegaxAdflD+?=
 =?us-ascii?Q?HIAArl22E4zupnETfdKduJkleLGBTULIOycrTqfDZvqfzm1JA01XHfvVcJdA?=
 =?us-ascii?Q?3TYyta8ZWY8DH04cfBLGyxAHU9eIFcNKSOdb4ycpDRWSnkIgGR3ArWVNXFfL?=
 =?us-ascii?Q?7Flfz0vhETzBAYkOIDmhVNSap3rZfivIU9kNwMXMMtAvyVpMfCOD8hUUrXJj?=
 =?us-ascii?Q?6+SFA9Vcj3g0vp+3H8L2raQNKdO5JaJBvQK+oOrbR6Hr2vmS2x1MDwX+aYmK?=
 =?us-ascii?Q?1mryf9Kg7jA3fNYfyGiZLGMSzeIEMxDxr6omcWCdsvoD3/buhZHOtct832lJ?=
 =?us-ascii?Q?llQ8J7uC2zcC6zfEprBBaJToH9smujYZpMq4QgblrMQfLhX1YZNjopG56RoC?=
 =?us-ascii?Q?+3enM2XrqGgSj8PPYU5hPv2M3Y7C7R4d3hjNw084tNXt8jOdC1LamWRXSH0b?=
 =?us-ascii?Q?1knkW5uHtXGbSakaJ1hOUBfE6/eMCkfBMwFFHeNjii3mV/H/RUJn+3C+SpFX?=
 =?us-ascii?Q?N9MRTTkVIqAZsRWF4dye/XvDhfsSOadQZ/GhItsA9NUID23VZvkrjQMV9TB4?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2839bcec-9b4d-43e8-849a-08d9d070d52d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 17:28:48.0299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPqoF9mPAdQabDkBXZmeRt9XDPfCOVBBHdfJbLeyRZqcmVyHgBfhjVgJ0HqYcCpRpbxAfNBGKgUf4omTbBAoVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Thursday, December 23, 2021 2:34 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe
> JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org=
;
> linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] ice: Optimize a few bitmap operations
>=20
> When a bitmap is local to a function, it is safe to use the non-atomic
> __[set|clear]_bit(). No concurrent accesses can occur.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
