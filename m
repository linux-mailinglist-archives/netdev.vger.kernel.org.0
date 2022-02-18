Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95324BB13A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiBRFT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:19:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiBRFT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:19:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EA3D485;
        Thu, 17 Feb 2022 21:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645161551; x=1676697551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y/uK8Rn0wS4Kr5ZteyX4X5rmC0p5FSbtg6gz1LIQJso=;
  b=INRmtqIUG9eagqSh1UZrOoj8NUa5OsNYmK89KsOZ4vLv44Q482jwfWlN
   A6ObG5VjK2M17zFdEYA04NiaP9FnvWZS9P9HhV8Jx760MqYlo7750EX9C
   b6Ag3B9GrzTefAcla85jgmgeIjMRMDWtADQGB0bMIWzhtXNA/nIeRnJv0
   FjnQbbVQXq+zRatkrGytFw4j4Q5RI1qeoQ5x265XvygDxPm7x4aSD0Cys
   S4JscWLG4JjEbxMNCRlv7bMIHYdss20AkQvXPSyfZjE4G9MyLP635wlA3
   y3vt05BT5EZ8Bkda1RZxm2mwznWNH3QTbjRVCINBOPYWkE/4MZSffJZo3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="337498866"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="337498866"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 21:19:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="572169181"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 17 Feb 2022 21:19:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 21:19:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 17 Feb 2022 21:19:10 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 17 Feb 2022 21:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2xwvSaUZmrPU/xlIn73FrGgmm3+OiALBnoohHOiYB+jggacyU3usexVSUQ4LJYI+vX8VhuFuZ3SbB7m8/1P10WOkxr4TQQ0iNHF7rxQmqs+nKQOHguCyygrwChD9eJbRIQ1PdMP2vs9mSmk8ihUkTvA/n/hCPKi+u3b247KAD0ykmYrCIjdUiiLYrEIvVEUP6Yo+rF1TWVPzM/I4Dwt636Uy37IZEBZhuprrL+AM9lrtLrJIZDrSSGE/NV3dyeK2mxb0a6n4c/aqvKjGrsSrsMOAXp3Xtoji4dkm2Bx2YINu6rNlSUDw8ZR4GqCagmg+4m9Zvk2DwSs18lrqJCytQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/uK8Rn0wS4Kr5ZteyX4X5rmC0p5FSbtg6gz1LIQJso=;
 b=JrJ8gs415Mt5Lh8dpVnMaHGJLIrC7syK9ASCILimA42vIC5z6pXOlYv3+FCKEIs5MVuWWU2SNWWoFZnGd8U4AQm7iAMSPkyMLwA+qqAfGrkzNRqLjXlO+k0Aqobb99M8DWrtdrkPGikR3pAweYJx8PAJBbdE0IoU/ry/ajk/hG6Dcuq+LXUS4OwqKRU2DCxj/xg3C7SinECUSadjQ6DUt/B2pmqJHRbvAXVcXcTcSUREgs+3vePkyieK/rxBgS6K4InyjiDy6ZU+z/lm5iXthqQbSS202v6Kpzb9XhVwtUeibddaqC5M0GjYtbgB0Xq7EzQWKqvFSSXx36MYVwHiRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MN2PR11MB3568.namprd11.prod.outlook.com (2603:10b6:208:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 05:19:08 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a%4]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 05:19:08 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2 net-next 2/4] ice: switch:
 unobscurify bitops loop in ice_fill_adv_dummy_packet()
Thread-Topic: [Intel-wired-lan] [PATCH v2 net-next 2/4] ice: switch:
 unobscurify bitops loop in ice_fill_adv_dummy_packet()
Thread-Index: AQHYE5SczxRW6mP4JkCEedhrQbetuqyY5uAg
Date:   Fri, 18 Feb 2022 05:19:08 +0000
Message-ID: <MW3PR11MB45547FA58FB4D79792D6598F9C379@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
 <20220127154009.623304-3-alexandr.lobakin@intel.com>
In-Reply-To: <20220127154009.623304-3-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb408df7-6784-4999-b3f2-08d9f29e30ea
x-ms-traffictypediagnostic: MN2PR11MB3568:EE_
x-microsoft-antispam-prvs: <MN2PR11MB3568AC91A231669EA6EDBBAE9C379@MN2PR11MB3568.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q5adiH+ryW8pMVH8cNeCIesYWs8FWaxIEyYcFrdUIM9HqQG/i/9joL6Wqoc+h9nywqvX1YAItWGPYVygAgvrVtDq+AS0L0tEDlTEFJeZ7WyRXiKI+LzzyyjI4Wtm7wO8WpRoMBKY7eJ/dpNdIj1rFz62qJEE0Gxt6pXTLFaz3gpW51uzpy43zKX4RaUav5mdIcVS1PO4nz2lUoPO6LTmRfNMu2S6jAMTZtraiEGbSTEtOeNOKMujmhuoOgxRhwCEhTRWIN5KPKxvL+aVHoo8mgSGo/n+rGhx/Rou6IVU/MfG1XxfVzMgoDvfqDJ2GzOCmD1V9tODSk/QNHKGSOl7kUJjuJzTlUmYaoXztVAR6waYC8aelMbySFmAXL9DI063If+t4R18uyMgUE4mfVxtfoOnu/FmzYBX07L4VoMSKJuWDR3Op6SA80SjRUk4PopTV2rZm32WbWo2il84qsO2QVKNzzkm9wp6f46nOvo70gdrG+yf08bq+ioe7hD+5OPrFxFu05yfq1Zp2StGQd2tIw3MAwn3VWcbC0R1T8IgbcLCseHXd3Si6HC8q+M/z9vHsMJ/LBxllvFMO35ymSdSJND5+5sZ6XL3aAsY1VHjV6KObDy+4X0BTx/sPrWcE29bL1GuGmaDG1iWC61lNOKqof2UxhijZ08aa5W8ir3mrnnKudC8BOO0tuhH8v3tP6qOSMZ5PKgFB+6B0AFXL+Ppsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(4744005)(66946007)(4326008)(8676002)(52536014)(38100700002)(76116006)(66556008)(6506007)(7696005)(64756008)(2906002)(8936002)(55016003)(71200400001)(66446008)(26005)(186003)(86362001)(38070700005)(316002)(122000001)(83380400001)(82960400001)(508600001)(9686003)(33656002)(110136005)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jwFkhc5HKDGBBu+A84d9y8ROcwJFstnKcFMfdUZidkTSt6ws8BsTWJzPqJDl?=
 =?us-ascii?Q?Hrfi379GIhxn3svx2HXgN1CDWtSIRN9GQZu/RrsX59QUDP3jOnXj7eo1oiG3?=
 =?us-ascii?Q?YqFLBSy5vA/HVj7fdx+ottYUknj9yYUMjJ1nGePUzu05DSQphDfSAy7/HtM8?=
 =?us-ascii?Q?H5mGuhjzb3CeSn6PZBuNH0Ndkl3IXTFRBz9uprc9ZAZIF6Kgd3evCX1pJxtn?=
 =?us-ascii?Q?x1GiCPi+XaR8p9mUX25topIB7hvQ0np05WF2c+sJVfxQtrLhJ7PhlNlBxeRY?=
 =?us-ascii?Q?tBPYPHZwUw6TdlZY76g6nAxP6m8w6DeCq4V9GCVMtYeheZpPkUv1vEPJ9RjK?=
 =?us-ascii?Q?As8CUMOfG818slP5Y5miDiXSp2DFkwwfLMknmbXzHh7ZG4fRpA+e0TNVLsFh?=
 =?us-ascii?Q?1yiOciXD/IZWzqXn25U81aodnEoJFChx5nnFJcmuhD0FcmBPLJux5X7laDI9?=
 =?us-ascii?Q?/ZHFoSN2xYgBgLvXmayiayP45WBiKXSPiDoIq8qBOOJCQdijiwByTsY8ZcvU?=
 =?us-ascii?Q?z7wP05hO8d5zNaI1jiAu9CsOng4n6So6xJucsA0OnTZsu3QqWNtiSbBjPSFL?=
 =?us-ascii?Q?0ShUKGV3OwFxaVZvaxiiT7Af15DhgdPLk/NdT8TbVmJYQjwobd8FP69Fuwyw?=
 =?us-ascii?Q?egmH2G7TlCsohWs/h0V56emgco3c+YsCN1y/UvlC5Eb1dhiermbD5icXsLQj?=
 =?us-ascii?Q?VduwQrKhSs0Z0KBh1P3/UUFPYw37kUMkBIkDMDEu40s4N5Ru6sKQHWaM60QH?=
 =?us-ascii?Q?U+2a/QRv35pUhQl0mBjs+UrftJ4q3shLdNJ4W/+jgOP1IOI9IlTnJJ2XKgC6?=
 =?us-ascii?Q?OG6WXqXcNPyvui+ZTqpjRDMNjXagK4KHZMFc6E0Gv8udAQ7vLlNXF3w5p0uK?=
 =?us-ascii?Q?VbdpuDezwwoYXtYj0LDJ+4QIJFsqJhxX9iLi+eFMaeE6qXxyq9KOuLTUzNEI?=
 =?us-ascii?Q?GxufdIIarcldqHmTSo/l6PAnFU0OjzWxfllC15R4NuZ0O4r81KVHewhDZwOD?=
 =?us-ascii?Q?bhZcJtWriu4Jg4Yk2mndEzSEZfzV5ekyJ45B8iSR2AwSZBo9+EWwtky/6R4/?=
 =?us-ascii?Q?xSLg6FIfBU8VeRg6Tv8BDXC54YCoN/Bw6+LfXQbJlBQceD1WKgGv7otrWrwu?=
 =?us-ascii?Q?Utrh5tr686yIVTWKhqNanbw3fHzi89UejDmcSrIl97YSL/5i7Rqo/F0Zu1hx?=
 =?us-ascii?Q?pV8w7NwLfrhLPeTU7B/7aTpCz6yY4m9iM7wA01lFNrXfsDhFXq04QDLCJnkT?=
 =?us-ascii?Q?X2sOceFW0eCZXKOiDvIpd0QQgoj0Mhb3zS5XkpHol/PdAWuzCMlYDzuMWX44?=
 =?us-ascii?Q?AZJn1/AdotXtrtQNkO2JRKxlR8lrjIPrPx8/HMm8X0pJfWOsZMdhYvNnTGzA?=
 =?us-ascii?Q?/XQ+7Dce9lELyPx/LZKMjgSu5PLfexQ8ax5iGB/5GqgQH5YN2XX/6P43UqZn?=
 =?us-ascii?Q?9HafKCxwmHENPZMWWEOqVZV/crb2N7G/fBKr8c/21WlUQj3gLd6h9J4/1ZNS?=
 =?us-ascii?Q?lkwOqKfnY57mipnGIEbraOLG0Rc4lyVbcW1jTqr+50fotxDYPZ6LO/hwmb0v?=
 =?us-ascii?Q?NxaswdXH0XMMGdy2KUT7axi9lobxNPzKT6C6We1VMnOOC2n8ju+3cIi7bIeY?=
 =?us-ascii?Q?nCXb9FTe4ow6VmV7wSJiiaLrZh//GlwKTKu8hvtfD/iMlNpvgnc+TeRXKGwy?=
 =?us-ascii?Q?W0UJgA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb408df7-6784-4999-b3f2-08d9f29e30ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 05:19:08.8140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yJ7mEtWZ0AOGaClofk/hPLSt3WzbJcYlTj2uHYWlZ3Rl73fyci8gAwpuo2Lh/lrBLVG9vvj6RW1V0tJLNtfrvp7j2B0CC4Pv7/628EVoKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
>Sent: Thursday, January 27, 2022 9:10 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; David S. Miller <davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v2 net-next 2/4] ice: switch: unobscurif=
y
>bitops loop in ice_fill_adv_dummy_packet()
>
>A loop performing header modification according to the provided mask in
>ice_fill_adv_dummy_packet() is very cryptic (and error-prone).
>Replace two identical cast-deferences with a variable. Replace three struc=
t-
>member-array-accesses with a variable. Invert the condition, reduce the
>indentation by one -> eliminate line wraps.
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 16 +++++++++-------
> 1 file changed, 9 insertions(+), 7 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
