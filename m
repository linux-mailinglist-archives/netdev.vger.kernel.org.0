Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB72141E288
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347753AbhI3UJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:09:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:39105 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhI3UJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 16:09:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="225318270"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="225318270"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 13:07:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="564424050"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2021 13:07:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 13:07:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 13:07:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 13:07:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYisw/ToDT9wNmm2QoG70+UElasDXeRKQIHV9Y9cf6JBOsddbBpOLlHlOiazksLyJXHRQI9uhSTcipJlIVlAlfKHoUoZqAMvEhdoAe5H6QmYTVLBAlAcjLc1k00u+N3VJ+4IL/jPBsFf8C3zm/hOYjGPXvsux+uTiHuj6SYzH+JdKdLcfERZTRjhMEr5GSAIp+DzZKPSGbT4Ec0QOLN3yv487ciDiaJqkikOwpFyA2fdcYz2T/9wS84pJ+HS21H8CiZWiEP5v7z0iyYDlVsXpt7XfJKxaLP5tD749HgK1J3A2a8I31uj0IgDyqy5+PgTzf6h9SJim4ZGO+TPK/Wrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yh+lSeggrGKzZSJvZJps84aSYOTCnxaiGSnCPdhUko4=;
 b=XEp9dgApRAfUKdFDq2kX0cY8bKe8+Q79vESFbmuiUf6Qh6zFrU6Po5iTQN16uOGljWoVL7tajanbFkqb/PZSE/50p5LHFNWZDSVUBtdQw1gxbXdFfHP3w4LH7eHxC59J4f98an5AGXzOf1Ggi986kfIKmLFREhOL7ZbepK0T+e8m7namA3RCx/I2Y6F9NlDm8n1zemXLSQGmtAJNntP0uV6H7yQLEdNH73dbtid07QmGX042m5HYoU6akAkCY9dwyRJDRFLfD2YeRHJRlit+1lLTnrrgL5AVkBfkZaVVXlCswJQqxIu50MaY/uiXwPQsCpnuUHgQ2huxUp1h+e/Mbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh+lSeggrGKzZSJvZJps84aSYOTCnxaiGSnCPdhUko4=;
 b=aHcpxyIP7XYqQIaQDWzSk3mxsKlMxa8l8FuQinqZO3CY3Fxvmeiw2HUP4mCq3SXAAsTpRkR1G1niF9Zly+/43Yxt36gJwWloEapka8dMU4lEHEA3FA0Rw0YOLZjZvGIcmOelizTe2NYzOtZM+H1oDXvyv1lzHUKX+ChKyFQaWIA=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by MWHPR11MB1504.namprd11.prod.outlook.com (2603:10b6:301:c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 20:07:55 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::194c:9213:9b06:8c7f]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::194c:9213:9b06:8c7f%7]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 20:07:55 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Jiri Benc <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under
 rtnl
Thread-Topic: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under
 rtnl
Thread-Index: AQHXqUZWtCPIBhgwP0OaAf5pieGmgqu9GmbA
Date:   Thu, 30 Sep 2021 20:07:54 +0000
Message-ID: <MW3PR11MB47484B86C8BE138AB4BA229FEBAA9@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
In-Reply-To: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60f6242f-da88-4d99-f33c-08d9844dfd92
x-ms-traffictypediagnostic: MWHPR11MB1504:
x-microsoft-antispam-prvs: <MWHPR11MB15044022926E088255BC7809EBAA9@MWHPR11MB1504.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXz81E1bHYuHf+zVlht44QTHXhjvKw8s3TuvC25/1x7n+yw6EJkDPFpH7REYEATKR28za37c71h9PGLoCpe746QOd7nJ3HI/r68A0d04QPm46MrjvONASbuI5owiYf4Dxh6op1XuK0jKIln1v+wC3dO+IDtmfgiZvD0xyX73cuDgUip6nj3oW41svxTxdTk4tFvoSoe1QOhhucFYJQcQj0axNQw+u7YKFnCSRETJsddai7x6K6/ahF701p6HrDSwJ1ilmAHl7PawF98s7K+sPgbiUTCxnArFA3wR25j+BTZVjuwrChS56FLqJjLFhR0+ek9W1Xqw21CsEJsU+whR6DGO1ZUOhH+QfYKJMrXq2NiRqlWg9mbXuWk9IgkeZZAZE/pSspubXmzzDOxLqMj/Q9XZr6+Ks303xY6Q6Fo1j3G4V2d0YiSrllu2enYdY30QuGJ4/hjRuLf3mJ50Vr4M1peoe+N2DUUTvALYSmryTnU7zEOZJ8SLnMbXG4xjriBBxzH3A0yHXdf1Zb0Lr1YuQCv+jpLAQskD9yixlrKhCwbAkL/gj1z2rHAhLOdo5qiVUISq3idlDaHpYGjUHTvANphCcd861zRC6GLfXwQq0tHvu3/J+GlrzvLzqTy0B824hLExm3CJ55KAv9cNJhcDHuGgaS+Zsk8Gs3W6tjiT5hlmbuuB0zN2bXJDQE2j+1r9cS5yd5yMuDVOyi87eiTA6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(55016002)(8936002)(9686003)(83380400001)(26005)(66556008)(64756008)(316002)(66476007)(38100700002)(66946007)(110136005)(8676002)(86362001)(5660300002)(6506007)(66446008)(122000001)(33656002)(2906002)(76116006)(4326008)(52536014)(38070700005)(508600001)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qngXNN41cs4N6RNWXU5r6V8cMB5CllEhAaCORkBbCCh/bljSHsiX9BrgzBtK?=
 =?us-ascii?Q?rcwVcih6myKNXOyWZbR+j5BhsuygjzSR2iRVRpEACQ7L1A0r78MCUd+dbZrs?=
 =?us-ascii?Q?+DZtai8r5s1GUqzLaVugkumhkembusYnxru7L8IDJJb2S4i874ZA8i/kp5Tx?=
 =?us-ascii?Q?VcXIQb5TmIwDdReJ/j7fqiWPHoxhtiK234ItcvilLx0pLogk8QJrv+WTuyov?=
 =?us-ascii?Q?XcAsXagFx7uyiKBhYtDywJLas6Ye51AKXuLeIMOWuFiT0jC5DlM/rvsUkW3/?=
 =?us-ascii?Q?F8nxHSJpSCnRjdreeP7w/gZMYFn7XJHoXHRRGY2ibw1oyZmygPvbFvcy/nla?=
 =?us-ascii?Q?a9jMlJjxUVfOJf0plRmYNT0JYOB7/szAoelNmydCyCaNP6+pj2WM0nswgDIN?=
 =?us-ascii?Q?8J8gcfke1I3cVsx/jvaaWoJqPtjdep6ophTp7Subce7I/WOybvUAWnuhFGUs?=
 =?us-ascii?Q?mtZ5+otaG44w2ztzq0KuXwtTGQo5CJkLnmowcm/11FU+vxPQY1EGMBeq4ZtJ?=
 =?us-ascii?Q?z5B38ktEDf47pK0kc73S/wfAqE5aa4ciDZ8NSwR1tLpZgllKIe9jYHkeAuR3?=
 =?us-ascii?Q?whj1vUBHnUpIsfl3TLXiCNNNU1dOAigWsZtG+UX2f93fOb8RwVq9I/xXEgwG?=
 =?us-ascii?Q?8pY8Thh4KfeCeVlKNguzlrVR5SjCpitDEpwEZTyTf7AOrm+goQ0xnkZqdaN7?=
 =?us-ascii?Q?Wnlvl7M5NV7ZiFw0X3iw6mklWE2ksExvpSyXv4pp3CkyzwKMS2FpMObegsjx?=
 =?us-ascii?Q?Dbe3pUJTfW1btMFRFzounE5V9b4VVyW2xSIPa1ma8KIMb/ZDCwTS8JVkhGdl?=
 =?us-ascii?Q?sc9aH8ET9gkfOJtU6Vrt9z8uJoAqANRHCoKwhMDEy9vqfWztOjMf0fzUP1Sk?=
 =?us-ascii?Q?RkyHjNzCUCmhluR4ezTpAJKd2XfGXxfVOisIfVGifcGfm8x5ky6kEN+2/xrh?=
 =?us-ascii?Q?I8lCKVsFwodT9PdrQ4OGwuUQ4WOJQfr9/JynydL3h7RuXx2jPQHfaykq6Iz3?=
 =?us-ascii?Q?aVQzsblODD+UCrTWu/LRrt6L/SFbLxT098tkihfGvFV/ZVn4LJEBNZ3SHK3X?=
 =?us-ascii?Q?+EcBwX2Cq2TvDHPvXqM+MacBHaKzTPTLzjQZ0Zb6CnuQduYCug5+2vkay9Jr?=
 =?us-ascii?Q?vnBXoqWJ9/1WjegKs4YqlGyB6IGi1vDNaP8fEf3QSKFiRQD+zMJTdfM688PV?=
 =?us-ascii?Q?1qtl+w1v1gPuo9F9gSc3KBTooB+1BKvfJGjAvatB4MgVWk0xFbSc2jzQSAvy?=
 =?us-ascii?Q?PWzyd4XolFIWW/X6SSqWlt4l5DSB08M37gQuiLnrXcZSROwqyQ2QC2aXqnLO?=
 =?us-ascii?Q?FJY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f6242f-da88-4d99-f33c-08d9844dfd92
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 20:07:54.9901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hi4tzPDtbiTJ7TMmDMsowCMk2KLaZx0Ah+2MTvuukpRzmYujRFi9ubm5c/hL3/2qwRgxtUUGlt6oSOxTc0hw9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1504
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Ji=
ri
>Benc
>Sent: Tuesday, September 14, 2021 1:55 AM
>To: netdev@vger.kernel.org
>Cc: intel-wired-lan@lists.osuosl.org
>Subject: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under rtn=
l
>
>The loop in i40e_get_capabilities can never end. The problem is that altho=
ugh
>i40e_aq_discover_capabilities returns with an error if there's a firmware
>problem, the returned error is not checked. There is a check for
>pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
>firmware problems.
>
>When i40e_aq_discover_capabilities encounters a firmware problem, it will
>enocunter the same problem on its next invocation. As the result, the loop
>becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but
>looking at the code, it can happen with a range of other firmware errors.
>
>I don't know what the correct behavior should be: whether the firmware
>should be retried a few times, or whether pf->hw.aq.asq_last_status should
>be always set to the encountered firmware error (but then it would be
>pointless and can be just replaced by the i40e_aq_discover_capabilities re=
turn
>value). However, the current behavior with an endless loop under the rtnl
>mutex(!) is unacceptable and Intel has not submitted a fix, although we
>explained the bug to them 7 months ago.
>
>This may not be the best possible fix but it's better than hanging the who=
le
>system on a firmware bug.
>
>Fixes: 56a62fc86895 ("i40e: init code and hardware support")
>Tested-by: Stefan Assmann <sassmann@redhat.com>
>Signed-off-by: Jiri Benc <jbenc@redhat.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
