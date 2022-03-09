Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72244D2F09
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiCIM2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiCIM2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:28:04 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980C17584F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 04:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646828824; x=1678364824;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Jh5RRD1/W77f6CSqSzMZXYyJEruyAPDBc7XuzG/t09Y=;
  b=LsSTcr0yiX5Gq0Wibznnc3mGDmvhJZvxjuK+aPr4Yn3Mc8JXJ+GNhBYe
   bGa6R+cG8sXN5t99/QRortvDArDmxK5NiP1ZbmN832zuzKgo6e03QoUmf
   uxE/+pEClKqY5IdshbBbrEBH/vSKYvCza7ozyUHhMWZzB9dW6zj7ZIJ/Z
   7f0tSKLLgIX5FaDbqYs57+3BI3hN1kQmRlIEASFqZ9lQRedWAttv2KUu7
   tMd3MICQntwsrjYLUzeBPwVl1fHaGDBK3GG1B6taXm56kkTzSUTLb9ezz
   /CUWzh6RkaRp1f6j+UucB40BhmcRv6B4yFGU8SsOYAIqijwcYlwIeNvD9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="235570149"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="235570149"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 04:27:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="711927283"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 09 Mar 2022 04:27:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:27:03 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 04:27:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 04:27:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 04:27:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mweLvVdt7uHvNRFY8qbZ7uK9TPIHjHPsoAlXlNEa0tzZKP9Jf8aEEHvYcffne645lEKHDyKBPJNiajuZkTpjR9pJ1VOUz8SPNMZ00hbdFYi0KJemQuUwd+qizfE8E8aJvKBiqVLDdO9ZKrps6hQv2sLbu67ZbqzGwTSKrfRvL0pFvtgyYAOhOmpQWh3JUWEa2VDIZmUF7pFeXZr6pwRfnW1m8pICKQCP/N7IV1iJnJJHiZCBAmlnm60tREJ4SzdF9CRgPzjsmyBYjrlii8j//HAC4PlhZaWZTiOSqpmfnFQnYftPeVVqclQNzDj5Bz0ciRM6BT7VET9xZGHvjl5lDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jh5RRD1/W77f6CSqSzMZXYyJEruyAPDBc7XuzG/t09Y=;
 b=cq5UzDAt7is5/qnFNWL+BJ+OhDSNfpGaHzitfjs4N2CUxnvqWD545Pi675Y3FWw4L8lEZvvqJmgGgJmzRFkI+PHjWCaXtdFzhbuFzXu2dWFH9hiyo5ro0nMR46YffgU5TpuKILX1NRRUUD7+oNFrhUcakDidhqKj3wiVVZhoNrbKwAQv4DeLvAfYnGZ+Hx9LZTZlG//bCuyMqtCi3ot7hBYvEB4tnY9fpmFfjY4xsswnLgEmJQwZXzdyDV45N0FnzBplFPTnr4WeW/vvG9M/SaUzBWS8iWv14MFvU8HOWZBmzkuuzrcV+mTHqy/A3cpjmgAPBWyKw9/t/FGzkPLvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY4PR11MB1973.namprd11.prod.outlook.com (2603:10b6:903:123::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 12:27:01 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%6]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 12:27:01 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@gnumonks.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: PFCP support in kernel
Thread-Topic: PFCP support in kernel
Thread-Index: Adgzonf8LBvYss0DRt2kM5s+Tem75A==
Date:   Wed, 9 Mar 2022 12:27:01 +0000
Message-ID: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c606d76a-327f-4643-3083-08da01c81c9a
x-ms-traffictypediagnostic: CY4PR11MB1973:EE_
x-microsoft-antispam-prvs: <CY4PR11MB19730F149C060A6F52892DD9FD0A9@CY4PR11MB1973.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: auHPNkruc7kL1ja4DaNDdgIzpn2sElsZrGWuj4f0yEHqQG2bQhqfm1RWgBsGgHPchKuLWKjcP2o+r1T1a4t7asZXWF2orv1h3By2CRigSYYMz3cEb+NI5DVGFPdZsQdo28fzacF2mOfGWWOgUzgMbLbaYjdbwoXjkcHLw4IErbHA3BR/D6lniR9GzPp9GfgJ1UU/gGQlROcGN4strfi1JHWdmUMeyPCX0v2zDJVFD988p7AHNFa97HVXOKlSx9Aui03aXB9HaPf4fBxgAcbtjL73eHtzOwg8DOc82YyHK2/eop8P0skdjL2EbsK023/RPYbJITaHtnpgV0V9+fdJHczjmCgR/72A2yv8M8/sdk7ofo2qCfPLObfZ/uL9R13hq8O7OcmC/Gb0efZI3Da2o1ihzYekpgXPCRnHc7hy5YJafxtBH2nIMJIufREkZARTpAlvAWE5QyLe5ueRHXIb+QdjxZPgRfO6CvQOaTot9pnycThj/n1lY6DLrHeLaqkXeUVoSuY38CLixaf/ZKYTwr5+GwEe9YOfbJ2EVqRkw5XQCbdILGa1v6pwL28g5WCPWxTCC9/gvSRRChmsONTDQ69xF2VtX66aqp56geH2DTFvB1IePFWNVt+4Hkr5Dp7WyqdkHtWz89MVuiPax+QLfgyTK2Vey0i0B4n9mN+M38Y9tTZFME2OXNkfUO/HlvAFqaU303H/i9z9InpbvNNNuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(38070700005)(86362001)(2906002)(55016003)(71200400001)(33656002)(6506007)(76116006)(7696005)(83380400001)(3480700007)(82960400001)(52536014)(8676002)(66946007)(66556008)(64756008)(66476007)(66446008)(4326008)(122000001)(38100700002)(26005)(186003)(316002)(6916009)(54906003)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qJ9Cc4qsTwW88NRrNJEA4P9ap1J/Wtvkv1drEtJim1W6vYXiJuXZyWS9TMWd?=
 =?us-ascii?Q?/0iipnT/3DzyGFDOAIin+6CEOfOFbfbTIN8Cnwj22p4iSkb+euequNGR6CHa?=
 =?us-ascii?Q?wU3ICktPqVP/Ku+Mu5TZq/eBUbfxyre9j0b5XzeMcFR0U6B95Cn8CbA1OGqI?=
 =?us-ascii?Q?/29G/O6nfRxYa54TmZwwGphmAkSDB9Ys16CbE5Fu3Gob2Im+yKyq2YRcGhfb?=
 =?us-ascii?Q?QxN2H2azYGiaXeXrqad/g55BnE580H62lTzYokokCbfySKeYIiduOQt19jKu?=
 =?us-ascii?Q?646pndXlkyRfqdUXQsFYB9f40tCZDovxZrWTEH9D+SjCGwJl5A8vwI0q3ANS?=
 =?us-ascii?Q?4811HlWbkNoqNr8fkz51Q27efBrzeaQNjxVVlwftummCifJSUadav5/njiBF?=
 =?us-ascii?Q?lQsmoevwbtuiomskyPX2OqnRggxwDGX+Rh0nvW/SXkDAMYkkPZ4/ZgFumDLI?=
 =?us-ascii?Q?FdV3FqXfx8kkGtgV17xymXOe+5kBRxgF3GAOsN4VMzgsUNwLKNuoWNfQwCia?=
 =?us-ascii?Q?RKRQQXl4kJDhXVvCpBWhgcVMgcfpDuFtL1CJl6exWcMWVFn4Ihq/LQdElShp?=
 =?us-ascii?Q?lplNJM9l8GTw6aeHBCC9SFsfhWwA2dnLV75bWTwvA/QBnAmsO8YpBZ9nHoAB?=
 =?us-ascii?Q?wZ2/lBrNSJr95uAuI2AOZD046Tjw+mncWzndJ43TmCZ1Wye65F2OzXQ1Ep++?=
 =?us-ascii?Q?Tmql3Pw35cQ+vyeXOomOCxg8E+6d9Q1xCRoMd70j9xCZiihm0Q9ZNVCWjOMZ?=
 =?us-ascii?Q?JDEC1ls2WZLqf0LaQxnSI90xJEiodh14aJ26SEF0tMMMNVWu35t7kSDvVayn?=
 =?us-ascii?Q?wn6E6U5brjz8lD7npeJWmRlPc3wNhfDkqBroOaWowgTgrU7rU5UuDfcd96kz?=
 =?us-ascii?Q?AIypnal3NOUqBCIVcAChLkM8YQony6kxitA1Weoclt7n1i9Y37hhKxxCkjOg?=
 =?us-ascii?Q?n6+aIQUKf3HXEROohRFOXqXhxjo9ShatJaeVDNsdFofJIEipakqvTcluyCY2?=
 =?us-ascii?Q?NwX3tewr6HjCKNLjHItwUHhZX+lwjt8eEiJG5fvq+LXDyFrYUxq4k/535guL?=
 =?us-ascii?Q?3UpmMhmojuoXpiwCb2j9Dnys7WcdRSLoc7p2t6WWqdvDkrE+WyLycTY38umo?=
 =?us-ascii?Q?1i4IxCPhUwwF2s1I60b3vvoalCK6ZbBaU6P8yNEkewsUpvNDGpZXleLoown+?=
 =?us-ascii?Q?3jKu5Ayv4xG268kKN7ams2Vu/m+0vpa35X+k305q5mzitq8eOdcxXz6ooRyp?=
 =?us-ascii?Q?8rr9qe3IfQs+4CFk48J1krohRlOj3UiuDMmlQ+fkODJ6XNsUvHzljE4KSoku?=
 =?us-ascii?Q?J3I465fVv70KRadmQuL8wg5cG0e2Z50ZuEby0OS2AY0+lHukGaX3qu6E75gp?=
 =?us-ascii?Q?3wVxr0FI/DsvwWHV/aovAxIB+GJuuN45MqXTgM0EczTdtHZAZBSIkBfNq4wv?=
 =?us-ascii?Q?x6/G6FzSzRyHbpVutgLYXoUwuHfG4q/aO3Lc+eAGXcI4LgecQvzz3ia5EOzp?=
 =?us-ascii?Q?zzbOnYFpj/YAt1PlmA0UeauSlsxFNSpzV6CBO8MMiqTudtq6Nk8KflJKqiQP?=
 =?us-ascii?Q?QWUHkHmCYdC6D+K+b/OKsbJWWVKwF1n6efbxMCeoz8AnTfI26rfnL9uDES2J?=
 =?us-ascii?Q?NJzoHaKo+mYyQ3RA72ZtFoPxsXZIohH0uQJRy21bF9EdQBXZY/uDCSBoRq+w?=
 =?us-ascii?Q?YyawZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c606d76a-327f-4643-3083-08da01c81c9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 12:27:01.0519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1cHIMu25d/GlbOzi/wvzl9ZEC96t6SDwf4WJfnnbiKoPfF9/aMg3JNfi6iO1XQGfwCIQ7tDTQQOhHUr5tTc/RWUEbCnR3OTUc9/7Q23EEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

First of all I want to thank you for your revision of our GTP changes, we'v=
e learned a lot from your
comments.

So, as you may know our changes were focused around implementing offload of=
 GTP traffic.
We wanted to introduce a consistent solution so we followed the approach us=
ed for geneve/vxlan.
In general this approach looks like that:
- create tunnel device (geneve/vxlan/GTP)
- use that device in tc filter command
- based on the type of the device used in tc filter, our driver knows what =
traffic should be offloaded
Going to the point, now we want to do the same with PFCP.=20
The question is: does it even make sense to create PFCP device and parse PF=
CP messages in kernel space?
My understanding is that PFCP is some kind of equivalent of GTP-C and since=
 GTP-C was purposely not
implemented in the kernel I feel like PFCP wouldn't fit there either.
Maybe there is something that PFCP module could implement and it would be u=
seful.

Lastly, if you are wrong person to ask such question then I'm sorry.
Maybe you know someone else who could help us?

Regards,
Wojtek


