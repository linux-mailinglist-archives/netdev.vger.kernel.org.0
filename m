Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC34E7126
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355863AbiCYK1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244196AbiCYK1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:27:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1518ABF50;
        Fri, 25 Mar 2022 03:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648203959; x=1679739959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ftNgwce06bCgExQ7J8aIQbb0r2AwR7J9jvOS3NXDUJE=;
  b=mY4CgDhaCn1AWzNUacqyHUedGiCGH4vmb9zmV8MB5LkbS53LGfdEsJD9
   GVl9Riu6gMkOMAd7jPP7vGG+QWvMAusmh+KV3H7zwYvhVAU5BzuwZuoxU
   PE2Y3Q+YWflSpN7Dhf5sHhmPMYCvxcwV89FUWIwk+iahR6jC9yqR/O70d
   ecjSBAND8fUrVKCwQa4t6B8qdMSxwa0SDgPdg5t2k3RCFm0fXdlofqW6I
   XIThmhUkSJ7vB/ZpeQx+bks674oqLt7aWuMJSUrQBN3WDOToRe8TiHbYF
   X95LrpBSfcniMt0gaVcMd0Id/0HGYAkjGEggFRzNt5XtXUitxTJUG2llk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="256172574"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="256172574"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 03:25:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="520158636"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 25 Mar 2022 03:25:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:25:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:25:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 25 Mar 2022 03:25:44 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 25 Mar 2022 03:25:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ9279+Jw+d5mY9SXsHUF2rkk+zoViMP94T/KIBDOeNf8YKP4nTCbboNIZpCJhnuE3+5tcPqu5DTwXYkRk//9RQhY4y/XEpxpz/d1G2pTjWYgHDV53gdff/FUyhX/6DNIzihwI6zr620cXUxZpRehIfmkG93dRde0JDJnvyUTJHD04eCsC1NVkop8rZLsLrcdxRc5fN3larvluKmbTavV01WzH2JyhKMWyik2nXY+lbL6emkz1OCI3gv3rE8+fJnWRIpr9gfWJj0YE2LsZpAIT765ULb4nhXpjhWsVsLJ27vVndatgCV8d+2jFoAM5ewhbHOL+lgaQVI794o1pi7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftNgwce06bCgExQ7J8aIQbb0r2AwR7J9jvOS3NXDUJE=;
 b=afxDX8m8SegleUYWPq+7H/NSWaJTFzKFixSOQbpo1/iz17jde99vYR7SMr1mRm2RhR07yzXoNr7AQFxXOP1aTZJgKMr/xsKzrZ5o8zIF5WbvTqJ+ycC3V4tLIHypji/DxSNPVCXA/rbQAn2v+9eAZROrJbS7yUhMNsa2wOVlUH1zbNvx97kEGn/YCprZhBoW5yAvYlntPjo6QPJFpDj1TlJlMVxb7Pi/RCz9pMLPLAfvcF1fLOwfUvkz5J5dU+nCpawy4yc6c2Io03JtqaVekv4ZjJ8IHmq1IMfAS4Vk26WpjML0ME1iJ2gX3H87H4Uu5ZHebx/EoAcUiSl+PVXfVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CY4PR11MB1624.namprd11.prod.outlook.com (2603:10b6:910:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Fri, 25 Mar
 2022 10:25:42 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df%7]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 10:25:42 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 4/5] ice: switch: use
 convenience macros to declare dummy pkt templates
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 4/5] ice: switch: use
 convenience macros to declare dummy pkt templates
Thread-Index: AQHYPRMU4F734eosGEGSRoqQ2hJHOazP6xsQ
Date:   Fri, 25 Mar 2022 10:25:42 +0000
Message-ID: <MW3PR11MB455443055341CB2F91E3E34D9C1A9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
 <20220321105954.843154-5-alexandr.lobakin@intel.com>
In-Reply-To: <20220321105954.843154-5-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0714a79-8712-4974-cf52-08da0e49d0b5
x-ms-traffictypediagnostic: CY4PR11MB1624:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1624DD205B90A0B8FAAA72EC9C1A9@CY4PR11MB1624.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P6uqFUTCskLfBW9Q6chD5Td9qhgCQKWD3l+EuasdLY4XD2YxVS+MrM5FCtKGGnT2Ek3qMC6HaU0rp0QJvzbEx1h8ImMItKfQyVYHRUjsywMfDOoqdQgcvhDSra1b7iszZIfrk/B/LMR7CfLaWNRibA/KdtxPIbL+SdHDJXXfrK4WN6WMqQNszFqNF+toQLJOsLAOsmYkx4xV4DuFlZOpz6UBmr4GXLkTq10mALi2dpjDQSL1SsRIAy25GjlFuB35kPPAjO6/+E87/C1nesl2m5QX5M+sY9cRJvGFGU9fF28uBTq2CLw+Mis8AKomoDRs9UqUkLnYu9z17SePRotCtuJ6bHVbylaoE9Gocf9KiOFVf5MRBFxQbaHFVxhRe/zH+ZwVLVvUwV5x28VTmFcxRdSjyeoKcXAXc29q1eMHhoJwQiJloq0zkpsGawMy+PGonItDmUMoF3+KqjkL49eHhhcK4sQj4rin3qKXtRiYn4GIueQ6HlK4v3fy2KZ9l0OrQ0gbrPGZRzcxhbNJJkJqYpm6bZ81nOkQqS9IehcAerN5d0xgV1sHFYf5yU2mffKUdjGCQy6dirZpmEyb123oApmRmHd/apSoCunep39GYaWzehC7Ne+DrY0rixzjLrIMp10+EatM8ELb2cYQ6EXbRxkOSZe4leladFJpf/vEioUMQQm61ahwdKcbBdrIUXen6JPkPLONZlr2CdSK0li/bA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(66946007)(83380400001)(66556008)(38070700005)(71200400001)(64756008)(4326008)(8676002)(66476007)(86362001)(66446008)(110136005)(33656002)(55016003)(54906003)(316002)(52536014)(508600001)(5660300002)(8936002)(38100700002)(4744005)(82960400001)(122000001)(2906002)(26005)(186003)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vE5MtgM7s0wvJx+8wJORx8rrrF34o2Ndlk4zSqs2/HDjv3FsETexH9AVNKSF?=
 =?us-ascii?Q?ciaBPzca84iTbAfPM3p8Y369t0AkiRIHNDH4FQIHI5pWc7yQgasEJDS/NUva?=
 =?us-ascii?Q?YrVMrIZUFwYD0A+fR0aRSA2ikBZWff68hPWsEq1n1+uvp7P4KN/rvjYLIxJs?=
 =?us-ascii?Q?yhRkLvyBoQsGKeuayY4bF1MDKcvI1p76FsL8V1JSqapKIJcJab4p39l8qLui?=
 =?us-ascii?Q?sOdlsTvRY2LlDuP5nOC36jE090xsYZWWj/LmSfxmHKzJKmPS0x9F9A+n21SY?=
 =?us-ascii?Q?2t73l3AxjM/bsPkjNFLA2okcXwQFsm6DQcFt4rNEe7L6RBt2TD7VxiSzh+KF?=
 =?us-ascii?Q?wVAEPBdmE5GzImzrJngcHpZUwB6C5QmhpbXLD3zj950mEXASKndU/ssBZQ3z?=
 =?us-ascii?Q?o4R0/5IJkAsvYKVrm7Gop7ENjRMoHe0B5fhSc6GczvayzbE0PcTIH19qRfad?=
 =?us-ascii?Q?/j2a3R55XfArXOjOe2+MPlLxKQKfl6WbGeSc/p72RYE5H2KuTYq8lSugsKvi?=
 =?us-ascii?Q?Krd6LDpl9V2SpgNZgdp6pQinpv2nMHIQ1v6tYoPqx7VGTeGCtIHMBgeXfBgV?=
 =?us-ascii?Q?qvuOCy5w6vsazIwuWUl64ELuJUegbaOFjDd2gVzb6xja5IZ8BpV0DSJEDnSo?=
 =?us-ascii?Q?slAOjuYoCW4Ap4VDgr321FWIOJuHxva8eVuPeNghH3aLTX7beA85HohPIlFx?=
 =?us-ascii?Q?4aT3/tPqpYTdrf1rWmHSq0uBTis+BWguPmZEZyidNPWacdBqJqgBd03RK7BA?=
 =?us-ascii?Q?Y6ltpcC943LMd4M0aJT8nWmqIwS3YvVDforpUQAG+rIeDMy5w6IjFwVscUB7?=
 =?us-ascii?Q?KMDOqgeCLsN00IXkEaDJa+zPmqDmPLLM6QJ3sFaTg/+Dck6FafeNy66356IY?=
 =?us-ascii?Q?tVvooeWDgZb6wyX3nkHFWz4dnSt3bbezYWgO/Wzx7fwbsX/XRKnmah68creV?=
 =?us-ascii?Q?IkR8SWu4e+S91KE5MTrb8S3N+TRaSzdB2OAG0SJgDgUSurRD6tlbHUhXH0F0?=
 =?us-ascii?Q?ixtmhu8pupzI8kKsUhr1bsYtzvYkxw27UvwpGtQwjuXJigLOfejR4EzXxsKR?=
 =?us-ascii?Q?09qeGx7b7bnqKf5awRfx+ofKt1gXCwln3V8oXz9kRhahAk9sDPSSOo14exSI?=
 =?us-ascii?Q?Tu5XeK4VYkZaAjGgr2DVhu4vqhptbO+N17p01jTvZ99K712sl/nS+Q830+A6?=
 =?us-ascii?Q?o2cRgebhC3sNS+ZBDrrvjgHYhMEUyX4mMZKmiFgDatP398eNRBMxxdSNJBxV?=
 =?us-ascii?Q?QVhDz4fWUZlJbWdP+AhATWk6uOio/eS9scqpW0fGFAzg4JAEo6dirL33GVLF?=
 =?us-ascii?Q?IfxsrNJWgegHJMf2IktAqH8zSwKN/Tp+FsWo/C9ZT4DwGGtnVN02JWDteEUN?=
 =?us-ascii?Q?OxDOqly5CanDj4YRFtmTfBbnjdMlqxPpZZThPGSwS/BHHNYGFTCND4TLdvWs?=
 =?us-ascii?Q?Pf52BygR4VkBDAQomkkb0464DM4BlqZl232UU4BtuHzSVjVUhwzuGi16TS8A?=
 =?us-ascii?Q?3hJm1PfxS8ugQu0SLyCjkgQDn3KcTj8RZ142lh3D9rj4fqsTw4w/uAqBzQ3/?=
 =?us-ascii?Q?TH0IUzpNRGAaNbxAvSD/mduAHTuInRr44J4BRLSoRo5IwYPkV9Ku4X5xQYQg?=
 =?us-ascii?Q?ySO9wr1XX5MNI+lMBtbOMfTZnGpIH0Hp4mFIu87EiXFvpGqaJZfM/4PPsHdZ?=
 =?us-ascii?Q?iH/N5A5Ypf3HWtCSAIuww1tVRzUYEurn4WeRecpDjFZ4gwkCqJFQA8pEq7kL?=
 =?us-ascii?Q?XkxcPRTh4OspQMy7nMiFtsajbI9y9dM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0714a79-8712-4974-cf52-08da0e49d0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 10:25:42.2386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TRALrLsgZPUrkLy1lQxkUmZ5EjhGmAj4UsTW07/dEAl4Am+ya7aAYDjbj5fF2EQ4cqZiReHaYsDG1UIBXHmtM4Ea+D7t24ioaXZboiluVq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Monday, March 21, 2022 4:30 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
><davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v4 net-next 4/5] ice: switch: use conven=
ience
>macros to declare dummy pkt templates
>
>Declarations of dummy/template packet headers and offsets can be minified
>to improve readability and simplify adding new templates.
>Move all the repetitive constructions into two macros and let them do the
>name and type expansions.
>Linewrap removal is yet another positive side effect.
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 133 +++++++++-----------
> 1 file changed, 62 insertions(+), 71 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
