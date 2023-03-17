Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85AE6BDDD1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCQAyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQAyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:54:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761E1EFDF;
        Thu, 16 Mar 2023 17:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679014481; x=1710550481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XgEnml38Eb43AGkIkua/x16Na0K0UuHdsZKzXp0Y0EY=;
  b=EuvmcA1zwoa0uIuf/KqSKryciqJk84wGplX+hz93hlPYqIXJvU79Vot9
   lI5coycvvDpjTs/EixxaT4v2HdLDI8RiWQN9xOM4wnpR8VINlRhOhdKbY
   5ickVAFy/uM5GXhF3nUCKAvHFaOGm+38YX7USY54JPPvE6WCoflpvjjmH
   L4GDZOQeIIURa0QzyLaKWu58wmhWCs+siPmRaEDGR0iAfAi6bi+rJ5wuZ
   OFxSr7AuLrS4fL3YBi4DtnZjW5oyr3Vb3ueyviseGBGTNd4siPR2IrMYG
   fw7A8BWobZhkDbOeIV1R1qOmCbBd3FZobbxWMRlQMDlaKIDHVZfaOfvZn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317805056"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="317805056"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 17:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="1009454218"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="1009454218"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 17:53:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 17:53:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 17:53:52 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 17:53:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGIwUlSy9bjZUxLJty1XMaztHlhNjYEYWQxu9YcZtYwL/GirBKueV/hc6X801zurgopins9xcg1Npt8937taCpOwnIfVbB032A7tQjKV0f0kK5FmdU5ll4GvlBTnJaNtWRbr9br9PXmFE7rJdQikrQ+KtTmg+lf+jXpEKsybW2ZKQsEQ+tKNHHBmDbx7eOgWnFJ+aIsyotJHrBwOI9V5MY4LXjMQ4VwLJIu2f0x9WfOrwKHtx/gnP7ruV5cS/VMknojMMmwp0QUocPXIjgCuiCZQ2pbU9tGw/St19RK5+lNziWtDb8nP9ehBsaJTQqJ1IZ7iM5bXdX/HAn96A9lWig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1EnpsM8mzV+orNEDbWxjAfwNvPnvw190wSrfWwwgaY8=;
 b=XZ0hm2Id6aW210MEDDvFehinB2Tt7wJBz0Tut5R4bqC8nKZ0YvGb7gVCr/TAxEBiEjlSwSHxo9qLBXX6bbmWj5gLk1IpMVdC8CPgZbBFBVARmQF+USS2NBmk+W7w0/unSBAWMk3wVnJDA6YUoyUuT1CQfOKyGTEwmLo3V/TSPv1k33zAMcIISveexzTu88yt4bcb4TSPGsT+Id7xDN4Je/MioLcmoReb2ZCikIHThiXJkoDkpkK9iVO23PN80qqSvlhRwfCfmGghnLE9BenEMHrwDNL3/Y53zTnwjg0DlROGsZD9ZlqnDAkc2I7LMkXdsqOuzzXjmfOZEIexJmThLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SJ1PR11MB6107.namprd11.prod.outlook.com (2603:10b6:a03:48a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 00:53:49 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Fri, 17 Mar 2023
 00:53:49 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK76Xc8AgAML3PCAAAhNAIAAGnUAgACgJGA=
Date:   Fri, 17 Mar 2023 00:53:49 +0000
Message-ID: <DM6PR11MB4657BD050F326085A21817C99BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho> <ZBMzmHnW707gIvAU@nanopsycho>
In-Reply-To: <ZBMzmHnW707gIvAU@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SJ1PR11MB6107:EE_
x-ms-office365-filtering-correlation-id: 2efdeb4c-42ec-42d2-d0b9-08db268211e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RGfeureaDUyLTld3N9lE0wYBESvg2onLbeKVHNBsYRxzNpYm00WlXXa19/m19AMEUl+pNwdygL5mA2VISF28Wf8H16Gi6Z4p4XFvwdAeFJm4G57GgBiPGHDVDqWKMUlEmjEWf7Mo5H/lZygRV7HHnHaqZB02ILZYTu3V+i6hdvd1rFY9mSuhPBlhX4aC6KjNk9dJ5MROHO/A+n2i8+/y8QcIUcGQmQmfo6d9TC+39k7BAdY7P96tZJA1p8fv7SX9V0+Xr6cTfFAdkuVe/QyPqzzFCzqBqB5ZG3/jhf3w/rZch5aCln30Lz3KlciBnyNyMs9pBDGHZ+E3l7BAQ7ThSv1EWkadVAMSNeDlRjxVU9ONFHci5ZILtw9Stvek/r8hQP61Jb0bs9r/h6wV+cN2hwdq8JtkLGj8iRrLAl3mEfhPTUeBf/2YCInlZaD6YgPmMyoMgS26BTJdDpo1dDfVE38oLeYFg92ZfKqFtd64BzpdJEgoSoCSJS0hZkDO/u6oVeSAJNoth+gl5KCsJWQX+PtjgVkdZboeUbCtsT7VtuLGK+vuE1vptA0JG0KjmKGTeQHLOG/f5jy6qmSm98dZL4qh9gOpMZ0VUzEuK2unr5a11c7Zx8+tJTbF7FrSwggHlqUuvuttl/+lfxFLcb1yPhotfngp9FTcF6M3q6fLK/nWWKZESR76fo7Kvz+bEvIyr5C+akeULqYupaotXcqo5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199018)(82960400001)(55016003)(54906003)(9686003)(186003)(83380400001)(86362001)(71200400001)(6506007)(107886003)(478600001)(26005)(33656002)(7696005)(4326008)(316002)(38070700005)(38100700002)(122000001)(7416002)(5660300002)(8936002)(2906002)(76116006)(52536014)(64756008)(41300700001)(66556008)(6916009)(8676002)(66476007)(66946007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WcYf44P7Q3J2bCxmwZiv5doye1adtKZ5CSB6zuSbzkm/LTZ2BocNQN91uv3g?=
 =?us-ascii?Q?GooYoxcnPDeQKtTJYrC6ZIk2Xq+MTYmWi1i6b4VqMLkHRtPzmXnZNsuzV8Y6?=
 =?us-ascii?Q?lYh5WsP+QkShtdHF57/74sCI1+cuqToCursm6xMQr4dGXDbxcYoB8GHnJcX4?=
 =?us-ascii?Q?YyKueva9y6m/37W7oljzYFGat2keyOQrtn1hKpO2pS+T5M3qDhO6lfD43ru5?=
 =?us-ascii?Q?xqDT9KL7BusFDkhz3UWpxlV67/TZNkleMQhhyC8QsFOZXPALLgF07twATM/k?=
 =?us-ascii?Q?64aIzQJamRHh0MrHDmFrz6I9FremmgIKrguhoTzALMOS9d6wiA7/FLm13bz2?=
 =?us-ascii?Q?0DjArUeOyaLpRgJf6h/pSWdDKmbgjHlM5rN/mxQ3GVYbWPdDsarx9h8diM9P?=
 =?us-ascii?Q?g5DvujnmLSICO61kTFFzQTQkZ4XkFBxstan+l/CtXuyd91qQMZ/Ljn9BSriC?=
 =?us-ascii?Q?bnezSoTd/D5za0SitgjPoL0I64DjpU8xj1HjgUhPaGF3fpvc7q+O3XvSGyhZ?=
 =?us-ascii?Q?TJIKVpNQ9DPxdy42mGRoPeYM2jB3jhrgoGr5Ct9dOy/i/L0eXcugvGCsqFGP?=
 =?us-ascii?Q?BP04KlZiYZcE1o++xQGzIIj0Qkl6n/o3G6B5Y01uZxhX9+XvLppX9I8MXoTQ?=
 =?us-ascii?Q?bwTupUyO9fZ44FjyECNnZraYaYhCMCels3aSLoj+3amlSbYwYtBTrY5SvWGX?=
 =?us-ascii?Q?u2HL4LI2yBcconxWEnxnDT0ZJ6VtrAvd8N0MGkjJf37x2uCr7Xt9kTDtYbgU?=
 =?us-ascii?Q?FSxsB7ImvhcwKWepkqJCGFj2+Ty5O2dv+i+G2Z5eCf0UyeyPc5ApSTs8P1lU?=
 =?us-ascii?Q?kw8+z/iIiPSDtnflag+gBNQYnMfKfsF5eKSUm64q7ct9gPfL8Fb2WZ3IAQ6b?=
 =?us-ascii?Q?lezVEE6h0jxzUTmGYbzgyJc21iGFc4rUOw9Sba8l0FocGskmAAp1Mc9gCYoZ?=
 =?us-ascii?Q?SmZG9Ql4hoKIjtc/2/DejWa+3vZrjuj+CFaVMYdnyfkzGRESJcnU4n4d3S3x?=
 =?us-ascii?Q?JUfQljgX073w33KJuZXdVUh/13MugNTpO7veXD7FVQk8+2uzTbVukKLFIqvg?=
 =?us-ascii?Q?fxk22PauS6mHdC8I+wbpHOQQ6ufxfkaW6K9IE5oOv1YbXGqjfL9402ti+GCH?=
 =?us-ascii?Q?BDSGN1t9lGyaraPhBOpW6XtDkrHu0q6BzS4hvbPfEmuD3JFoFj2xpn77GEWY?=
 =?us-ascii?Q?cO+KEGsKqH0wiPCH1fNbGWLgudio9hTDXZTbPcdsycbGKNDpTRkjC1uIqKma?=
 =?us-ascii?Q?IwaALpcqq9eTug/jNQrRrkKfpjBeCujmaNiN0ABb65YXaerdC3lafbmYvXIC?=
 =?us-ascii?Q?uyESyjcWfhnP6txM05wViocos0RsGGDB+bWMFNCfPkcVYaGUMRahM1bjYVkW?=
 =?us-ascii?Q?eJrNPN1hEz5+rcGDeRifDVWcvRzU8Q+/wNWrS/XWz6JzxoZcIdHPy+Mh8eDF?=
 =?us-ascii?Q?IbD1kQqLIPLateYb+vArdax0SdjguBNZHlT4GMz4SRWWdqmUJmcvmJGfuEDd?=
 =?us-ascii?Q?y+rz1c+aP0uGg/bRnAN5vIhcM+vyWflXyZ7Oy7lW3xNyfqlByTlDDSVojM+N?=
 =?us-ascii?Q?3cNvkeAN/8gin4kkTdEohgweb2zEMJE4PEg2VLGTZPyHJ5HcMx7aX9dtqZSU?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2efdeb4c-42ec-42d2-d0b9-08db268211e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 00:53:49.0572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B2IzPaIUpaBoQv+tgXFcOzv5Fc1Zy0QGB5guqTXiIXAX9AhUFtfkzHatUe6cnYsLNW7rJ48OiYTChl7QhtOw7VzNoL2QLFaMZJJB1RYZZ90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6107
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, March 16, 2023 4:20 PM
>
>Thu, Mar 16, 2023 at 02:45:10PM CET, jiri@resnulli.us wrote:
>>Thu, Mar 16, 2023 at 02:15:59PM CET, arkadiusz.kubalewski@intel.com wrote=
:
>
>[...]
>
>
>>>>>+      flags: [ admin-perm ]
>>>>>+
>>>>>+      do:
>>>>>+        pre: dpll-pre-doit
>>>>>+        post: dpll-post-doit
>>>>>+        request:
>>>>>+          attributes:
>>>>>+            - id
>>>>>+            - bus-name
>>>>>+            - dev-name
>>>>>+            - mode
>>>>
>>>>Hmm, shouldn't source-pin-index be here as well?
>>>
>>>No, there is no set for this.
>>>For manual mode user selects the pin by setting enabled state on the one
>>>he needs to recover signal from.
>>>
>>>source-pin-index is read only, returns active source.
>>
>>Okay, got it. Then why do we have this assymetric approach? Just have
>>the enabled state to serve the user to see which one is selected, no?
>>This would help to avoid confusion (like mine) and allow not to create
>>inconsistencies (like no pin enabled yet driver to return some source
>>pin index)
>
>Actually, for mlx5 implementation, would be non-trivial to implement
>this, as each of the pin/port is instantiated and controlled by separate
>pci backend.
>
>Could you please remove, it is not needed and has potential and real
>issues.
>
>[...]

Sorry I cannot, for priority based automatic selection mode multiple source=
s
are enabled at any time - selection is done automatically by the chip.
Thus for that case, this attribute is only way of getting an active source.
Although, maybe we could allow driver to not implement it, would this help
for your case? As it seems only required for automatic mode selection.

Thank you,
Arkadiusz
