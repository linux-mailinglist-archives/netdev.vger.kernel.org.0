Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A561A46BB15
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhLGMck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:32:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:22031 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhLGMcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:32:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="298359406"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="298359406"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:29:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="579821279"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 07 Dec 2021 04:29:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 04:29:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 04:29:07 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 04:29:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T700T35YPXsNj6E+zZyuQPo8j9n/LU1sdHvcPpGBpf6P/rphIuweHqyZmvnosoNlXrG3QgF6CGJUZeBYHLhp7ASii4tHOsjtX/W99A53PzgoA/vFzHkN9Y2YBAD2HOLVMZH+/Uii95YsM3Ym2uxSrkCKEFbKI2JVZFAqVXqEsSot/D/6rfvjpUHTvOAn2zv3K0ahbVIYosUYENY75/nxP2rSPvCi9GsqKr+LlBK8DQvbEllZJ6/PJlqPkR+QKW0xfIvs3AL/l+ava/BJownVsQnWrxy65sI3EjsMmQI0JY6pnX6AvwXvHF1hU1dOF8DYNVlGqhcjBatSlx3hQBj/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NI0Aa62X835Yg32mhJ9TDJBdkiROidR/hCSKK8v6B0=;
 b=lSEgs00AuP8ckSV75yBnc8CH0Gz4IfDEefrGmvUyKsZuh0vEH+qS6CO9rjKNuK6haUUqLLvo8f+4h5HRTQQTZWNF7FRnH5oy+wGn9B99gmk7iWmrxPk/KCfPtF50nEyBD0Rg1MUSvwT7/68SKl1Re39e92wR3esRGFV+nLGoECrfyQ2P7jjYFQLCllHuqx5tzrOXnzpf20ivDiM9GC09UZvq4AHws6py1IAGnzTQoznrt5kaNggpmZsXC3qZQnKnJFEz5oM/aTMQHwYRzOuc8z0V6trX1bZPH3NADdz1nYVKw54qFyQi+TK6tOp/sNLw7sCi0xKAYW3EhBV0/Cep1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NI0Aa62X835Yg32mhJ9TDJBdkiROidR/hCSKK8v6B0=;
 b=NfDSQ/iJ9n1Q1FYiFQYN9q49sH/HEIQAuRWcr9VM5M79yNdZ45116Rwsr50ndx9OVkQ42u0HdNIyhP4RWMoM2hWT3Aqn8TV18MJmWskpy0EOHQnAIeda+2CVhe3Y28O0mp5szXeo18C+9Vt2qfDnAt8+fiVEaayeHpSPuT2ySZE=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB3816.namprd11.prod.outlook.com (2603:10b6:a03:f8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 12:29:05 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::9d49:ab80:11ed:29d6]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::9d49:ab80:11ed:29d6%4]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 12:29:05 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: RE: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
Thread-Topic: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
Thread-Index: AQHX60vjEu8KBXjUZUaKCE12aXhyZawm9RDA
Date:   Tue, 7 Dec 2021 12:29:05 +0000
Message-ID: <SJ0PR11MB5008E5648E520EB336C47A2CD76E9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
In-Reply-To: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3c15f34-f472-4e30-308d-08d9b97d28f2
x-ms-traffictypediagnostic: BYAPR11MB3816:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3816AD8D81280E5DAB428F00D76E9@BYAPR11MB3816.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1U0AB4vgz+KdztGz4NoTXLXhMD0cOqvGOUHD6W+9rXsshK+6e74pK/o5YQdfP8bwAGiOP/qTdtX3cfNjopH3DjNkg+/3fgvtuF+AT46R9tbFW0Uy+d8kyLMshdZAPo0N5HDHSWbR18qYZ8fDvK8tzECGOZ9L03DvohEDiK1UE8BsA56cpDZQ4dE7U8l8zbd9dUx1PWFaKX5Moaci+fl+NluHeMM6cv6AhmNtylAeubioCXdWO3HL4Z0aU3WYM0VLh/sktCBcz3SZcwxpW9L/cc8cMtFovEGCAeMv7Iz2asiubv81KM0LZC2poYAY+1exqF5gsjvjTKlBoWL5F/D+r7tR/SvtSjGNwxscDpw++PQ9iA+rj6axwcqTI4a1+JQevtnqiFHee3onWvvpX4IwuExBruh9tGXqUtRUlZ+00Y5Mxb0YqespA6x24E1N1IlQGOOfBRJfQWkOWyGB1OPiDNHhzXuDjHcViGC5TD3XNtv8hC8OMJKLi/ZGIfGtqeyu1yUQCbhWg/7NNuKWUL0u0z9/eQ0NjL1SH07kQMfE+wMHMf+4SXbpyNLXd9OmE96tcXaylHY2Y4z3sbS7scPquwYX/BaOWIBXmc482+qH+g7X92hntHKaLm4oomjQ80/5EUaJcw3pbTBPtbaS8MSWnFil4U5/EsuVlsuIqaIqDmc0jihde/EbLs5hSkdoYd0XK7r4wZNPHScnXbzUaeHZIfSUHubJRBN3Vstztl4Im2pPj+rGw7JWxp2d47lLwAU6HqavVBW25ltdyVYWmJ8t+R1Ll8nA7HGDlhlwsBuqM9SxCmR1IGAncGukqLrToQSBmXEOlfTagWRnq+IaYhFqqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(52536014)(83380400001)(7696005)(966005)(26005)(6506007)(53546011)(38070700005)(110136005)(186003)(4326008)(54906003)(55016003)(316002)(8936002)(8676002)(2906002)(82960400001)(122000001)(38100700002)(86362001)(71200400001)(64756008)(66556008)(66446008)(66476007)(5660300002)(76116006)(33656002)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hx1nt/ZkIwK0DCFLcrbiu18bNvgqtQnbOCxS1AJR4FH8NGeEOCVIgVRtBLHR?=
 =?us-ascii?Q?bRmBcBlR2x3Df4SWhWTyPgvE6COylQMLLWM7kO7LhXwe3mFI7SWBdkd+qTve?=
 =?us-ascii?Q?fcOugpwnqP4XYXSFffS2oTtnAghDbkbJ6WbJE69Zu3aMc7kgCBCUppUuI/zb?=
 =?us-ascii?Q?wchYiTgLTR6sRIhY6fF3D1N+UEnTQa4t3JIKTyDNw1SbDytt04bfGIjyP1du?=
 =?us-ascii?Q?4aGIx8BseQpvf776BbSKBH7LW4OJAIPjeDz/+khwr8mkq+n352X66JDlr4Bq?=
 =?us-ascii?Q?dHTkRTqAyBUGDUp1gj+rzCZHzyUopV6f+K9x4IW23jGccFYuehyIZfZSzW2V?=
 =?us-ascii?Q?8CrIGUwtkHEf/3S8aLiT60QMl2dYfIMKkCAjgCWR1TlPBE8jNkFOmfraDRYI?=
 =?us-ascii?Q?pOv33dVpFgfMGVCfPxnYbeIjaqFfudS8GloH/F1Lc85TCH5sUYrJ8pfR5k4O?=
 =?us-ascii?Q?bA2vdahl00D+F43sM3y/WS77UyT6sMJSp2exlD3ZNwd4F+3XHBmy+xt05xzV?=
 =?us-ascii?Q?V4t60nEkCCT4JTLIAOVbvIVpIsF4MQuW355rOwZWfMZ6MjIFlRgwme4PUAdz?=
 =?us-ascii?Q?9kJ3qHql+Ri4pWFhtDfwKNDOd+qgoYZ4JysBowRcXVR6R0S6XXuCRVHEzcxO?=
 =?us-ascii?Q?YLOFDVbHgZwjC7E6b6SlCOPvZfsWnTAB++nq5TQ/r5nkZpYsY3aFGxA3c8dH?=
 =?us-ascii?Q?ASIjtpd62j8CWFjUMoTFyFjcG7cfv1mfbY5X1wDUri8H+qpAqjhFofMJv/L0?=
 =?us-ascii?Q?Ob3DA5KCKxQPnIKiLlmonEfgt7eaedVvqHiK4a0URVS6mDP6REX8DzuBdlVc?=
 =?us-ascii?Q?TL+HVKDNSFX32GQXJbtCL6zBBk5EWhYJpRSmPswiC6/NIPj7gCuHhpD1YDTB?=
 =?us-ascii?Q?jFrssW9tot6HLE7iEXYfFtsul+YqlsBzZmw1nZDU+tpRC8auLVUYOtvS3rky?=
 =?us-ascii?Q?DlUBcBRqTqy5wnenX6dnzkLDU6bQfmsG7zYRRfkGtpHHG0valL8D3HnJN0KG?=
 =?us-ascii?Q?wG4XVVPg9slH9OA1aOGD5yrIhriFgtozRdNCJQB95EJh9AiqusKl5eAZtTyt?=
 =?us-ascii?Q?VuWNLnqaCHMVv9f8WMlHVwrC0KLjjHgKxARA2hfdXbXKhLMXf6CisB0aA5yS?=
 =?us-ascii?Q?N00Rrz/4Rvkx7W1mzPr7/QsYvzRKqiDLABm1WP+jeH/K2JkNJrxBncPZG9qs?=
 =?us-ascii?Q?ROyt2BkvsS2q+pLrxhfTn+cq4vzrmdfSzWjI99jkbxT6/7oYgk/j3mmaqG8e?=
 =?us-ascii?Q?XnYq6A8eQipA7MXWffNaqN66qeUGH+CvVfp8ApJhW6uQ0aP++WCKGk7LnNRy?=
 =?us-ascii?Q?ZxSH/0EYElzvAr+a9fx+0eJP9EIiAMtf5f28GJZ0KL4Yw2f9ejmhgputvkrg?=
 =?us-ascii?Q?o4uKCWpt9TzLkdkJhjZ/Du+/FN4MMpq/Vgs44UxNcoCPOxQzPy/a73p+KZlq?=
 =?us-ascii?Q?4hwwLiD49o9KrI172dYJm4VpbKct3GCGt3L5VXYy77tvIdMV/lxkwlyMvGIf?=
 =?us-ascii?Q?d74DK9//8Pa+HoeiibgAIjIMr/oSFrh8I3/a/Asmo9jcUN60ilkFqEIEqAUI?=
 =?us-ascii?Q?YxTofVbfp/EhDz1DkiIo/SN+EtbWyIgZUAbujyjcKgDxHxI0eNacJRnSiaC9?=
 =?us-ascii?Q?aX5V1ztT9X86CIZSLsLFz8xa6Hf9urRE71p7KiKnwuxGttQrEizqNQFM0DfJ?=
 =?us-ascii?Q?D1HALA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c15f34-f472-4e30-308d-08d9b97d28f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 12:29:05.7542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h5bqLETgWtudkz0WJiwe5us3Pi1T7wL+9VmBmr6UfADPpgpy90HGO2RAS4byxCeZQsAS65VdsRBq2qFc8v7khw24R6ShdJQ/bJU0nthNkK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3816
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Sent: Tuesday, December 7, 2021 2:52 PM
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; Kumar, M Chetan
> <m.chetan.kumar@intel.com>; linuxwwan <linuxwwan@intel.com>; Loic
> Poulain <loic.poulain@linaro.org>; Johannes Berg
> <johannes@sipsolutions.net>; Leon Romanovsky <leon@kernel.org>
> Subject: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
>=20
> Resent after dependency [2] was merged to the net-next tree. Added Leon's
> reviewed-by tag from the first V2 submission.
>=20
> This is a follow-up series to just applied IOSM (and WWAN) debugfs interf=
ace
> support [1]. The series has two main goals:
> 1. move the driver-specific debugfs knobs to a subdirectory; 2. make the
> debugfs interface optional for both IOSM and for the WWAN
>    core.
>=20
> As for the first part, I must say that it was my mistake. I suggested to =
place
> debugfs entries under a common per WWAN device directory. But I missed
> the driver subdirectory in the example, so it become:
>=20
> /sys/kernel/debugfs/wwan/wwan0/trace
>=20
> Since the traces collection is a driver-specific feature, it is better to=
 keep it
> under the driver-specific subdirectory:
>=20
> /sys/kernel/debugfs/wwan/wwan0/iosm/trace
>=20
> It is desirable to be able to entirely disable the debugfs interface. It =
can be
> disabled for several reasons, including security and consumed storage spa=
ce.
> See detailed rationale with usage example in the 4th patch.
>=20
> The changes themselves are relatively simple, but require a code
> rearrangement. So to make changes clear, I chose to split them into
> preparatory and main changes and properly describe each of them.
>=20
> IOSM part is compile-tested only since I do not have IOSM supported devic=
e,
> so it needs Ack from the driver developers.
>=20
> I would like to thank Johannes Berg and Leon Romanovsky. Their suggestion=
s
> and comments helped a lot to rework the initial over-engineered solution =
to
> something less confusing and much more simple. Thanks!
>=20
> Changes since v1:
> * 1st and 2nd patches were not changed
> * add missed field description in the 3rd patch
> * 4th and 5th patches have been merged into a single one with rework of
>   the configuration options and and a few other fixes (see detailed
>   changelog in the patch)
>=20
> 1. https://lore.kernel.org/netdev/20211120162155.1216081-1-
> m.chetan.kumar@linux.intel.com
> 2.
> https://patchwork.kernel.org/project/netdevbpf/patch/20211204174033.950
> 528-1-arnd@kernel.org/

Acked-by: M Chetan Kumar <m.chetan.kumar@intel.com>
