Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359F750C5F5
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 03:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiDWBQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 21:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 21:16:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121EF2A25E;
        Fri, 22 Apr 2022 18:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650676423; x=1682212423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o1y0redGm/5XmqoCNr+jrrFD/h+JQamdXcy0XQ71teU=;
  b=FsZ1bHNXT4qKTvBKwlYPh2/B/jST86+vGrzMaOhUIbQvm21x6StCX5NF
   MCPL4lw4NyBYp9BVgEb7e9SKdATiFHap+aN5o/O8fUmjC79CGmDkr9Mb6
   IPawMJ6HBMZB8hoIJaEdOXcuBkIkv/FqpWpXJMbDWOYBoBDHxNXZ6tgnV
   ro6He+10RNpH1f1IKIpbr+pjA/EABg5Xw48wzYn8MOGRlzK0IPxGZ3jmD
   5gl5UxX8MtxroxxR5DOhwaetPKFThKgMkmqh6ZhhlNKDCEepW1LRsffc5
   Bf5V8iMQ/N0xfQ+JnX/e2QrwxpCwwjw4H/0cmtJyEv5qEmUMC/iuZnD3J
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="327740240"
X-IronPort-AV: E=Sophos;i="5.90,283,1643702400"; 
   d="scan'208";a="327740240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 18:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,283,1643702400"; 
   d="scan'208";a="806229660"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 22 Apr 2022 18:13:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 18:13:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 22 Apr 2022 18:13:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Apr 2022 18:13:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT2vi4fPKk+v8qejqkTTCUadepMAd/G6uFWi6H2nXypPU3757RQeXcQVxCQ1ZeGEEyohBPiB2R9ZZICVzT+vOKiL0vjfQYzHa0pm6UwKnA1z8K12uFIQ0MHg8x7hiKHF//Nw1EPwW7116KIO/8xt94Lv85V9NYFFOWcg6DH0AGQVGUR0miU3prgAxZt0VdO+atyqwBTjlmXWswk2EMHpDsqSKUu4KTiV5W2Q/iX8BfileVaiE4XiMxnUYXAQE1P+4N/w4lhhdaphq51uWbFlXPWi4ibKfGAU+5gQOsPMj1TdPKvEmdUEy2hdCkbv7RLrM5F0nuv477YJ9cPJ136lrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1y0redGm/5XmqoCNr+jrrFD/h+JQamdXcy0XQ71teU=;
 b=LiqXxpPorXI3l/q4mZOJfJNySbHb7WuMtAUVAskGwBL4Ed1fwjmlVvmyYb4aWyOkaqsh6xd4S1ujy3EInHwKWBO1/7AM1GTb+vTCp4Ybkdoz9nDOCKFuMCUzBVBHDyCbMwa3rnNfWWOPXAFmwTKoW9VgvTvJRUkxQViFRlZnKZgftyu3yiIRnW0YyWu/Ly8uUsD66qEZ4Ksela66ry5wlwp3lAgbSV6ZnXMMmNkm7l5wP2j9xCkkXBu1G4k2nJv1iuCVjvVwP0DtkWL3z+2lO2X1bJjwgdwPo99bl7zpCdGSx1lt/3OIQKUR3Dd1a/oNDan4GRxaVMUA+wys5vCA4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2770.namprd11.prod.outlook.com (2603:10b6:406:b4::20)
 by DM8PR11MB5573.namprd11.prod.outlook.com (2603:10b6:8:3b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sat, 23 Apr 2022 01:13:35 +0000
Received: from BN7PR11MB2770.namprd11.prod.outlook.com
 ([fe80::34e4:2137:9a9a:4be2]) by BN7PR11MB2770.namprd11.prod.outlook.com
 ([fe80::34e4:2137:9a9a:4be2%6]) with mapi id 15.20.5186.014; Sat, 23 Apr 2022
 01:13:35 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/4] net: stmmac: introduce PHY-less setup
 support
Thread-Topic: [PATCH net-next 2/4] net: stmmac: introduce PHY-less setup
 support
Thread-Index: AQHYVhwiepIIS+eH50C/N1IPmhYl06z75TKAgADNEtA=
Date:   Sat, 23 Apr 2022 01:13:34 +0000
Message-ID: <BN7PR11MB2770FF900AB58368ADCFC4A9CAF69@BN7PR11MB2770.namprd11.prod.outlook.com>
References: <20220422073505.810084-1-boon.leong.ong@intel.com>
 <20220422073505.810084-3-boon.leong.ong@intel.com> <YmKmifSfqRdjOXSd@lunn.ch>
In-Reply-To: <YmKmifSfqRdjOXSd@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 972dc25b-85e4-4ce9-d687-08da24c67d44
x-ms-traffictypediagnostic: DM8PR11MB5573:EE_
x-microsoft-antispam-prvs: <DM8PR11MB5573281639B2B719802ACE3CCAF69@DM8PR11MB5573.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHjJwmI8fyVIVzi+DBmHTcPdlObR9BBmXEj54+7RGC3NvAx0+o7Gj1ZmP1udE5Xq+ZAQ26iiG8VhzUdaD+dC7W0uc9nDc4xux9/JV8Xb39788+rzBZp1LBVECkq3mjwJvEy15PfZZkfapQ/4J54zIPnx0WetBKpjvFWwOmZO96z5Ku1Zsns1Y/ZuP6MT+WCNLWnYQk14R9PJvX6wqncOgtngbP24FBEj4UDWG4lD8WPXDM2Im2zSh2YZCtWXNHBN8YI5k+rI6CQBRs1QfTA4zei11lSnuAl9nIeHDOUdh+6k+vVlIy7UEuC2VnlnmwP6ANT7QzsWjaKggnP60aSYJJfriKmEHj3+0n9myzZ2dZ2DZwIDaaPYv6M79X0PEvzAZ6rrG26+9VGyJ7ANvObeCASW0Z2htFATrT86SAEQ5wZ/wP5AK9McsBlQP4ivkQ64DojqzyIj+w7WxJNzm5dKCzIVYzpQiWaRCuVdqr/m93ucSHyEY2im76OXN52mcOruw22zUsPJNZgpY10d1CmirRk4e4gYBakAtW/hnGoTQNp/XFmwfqn3gO+10MCPjKy7bNkpxPfMca6gtVIqD6PN+1/qCHh0k7PYO83DzC1G+/QZtvbuNRGperXvvF1Tk5xPgyMq9enQ2TcF36ONegR53O0fw+h1ivgs3Mh7XWKX/CXqWSMXWS5bKKdLIOPUNc6oVUmtF+bx/CV+R/7xvASZ7rVtLoXR30ftU17Lx2WNzFK5mfO43LWyImbvUTgUHusG5euv4013nfKTDohJuhfnMaMChfqdSrjEi6L/V/2T3/Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2770.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(71200400001)(6506007)(66556008)(66476007)(9686003)(186003)(5660300002)(26005)(8676002)(2906002)(54906003)(82960400001)(4326008)(38070700005)(38100700002)(508600001)(7696005)(66446008)(558084003)(66946007)(52536014)(33656002)(6916009)(76116006)(86362001)(64756008)(316002)(122000001)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LDuS9NIWxUPH007Rp5HJ3A6OgVw8MT+nfM2Eb4Y05Uo7ValZ3fzFLESkCU3r?=
 =?us-ascii?Q?yYajooKpAMLqBnUZ8Dafg3ykZQYS1j1JuYmGIdfuy/NSw0XjaGncN5cc14aH?=
 =?us-ascii?Q?kbIoCQqFx3htyF+mmjlpej7dgx8eLABQ85+/Ia7g1HKwl0+GVuIgMrM6Gc/b?=
 =?us-ascii?Q?ZJlCPrY5eGIatTjV/WKOu6j+T/MCI2ICtcVpbhFYMyTw4Y3sLShkG5SGoINc?=
 =?us-ascii?Q?vXnE/djqkRgfIY4GY043oyY6cQhc1IH2vuVNORsoRkN3qD3JhQD1/LyZkTHB?=
 =?us-ascii?Q?stz2ULhXVk5QCi58vG+sZUmwU3NbHQIj7gN4Zg9gS+v8GVmXqE/Fz3dYIUbD?=
 =?us-ascii?Q?JrjJDHAf/L1z/ub7kWF94XFSSFd1+0Vzn9qmkO0pv2XsxXpefYwoKhtX+37H?=
 =?us-ascii?Q?vPQgl0gu38RK/8AH86dMs8yaVWt+BbjUHfhtZIUF1WZ2uMkHi1Pm1fdcTTMG?=
 =?us-ascii?Q?ePECMXdrMsbGx8YdD4zjPRsrHXnLwy08Pl7YM5nyzsxP3Pd9U2DPYx3H5aB9?=
 =?us-ascii?Q?zAYdnT5JtPGjLUU0Bfi6thWQuss6tDcX26x5a41TauhAbV080tddfbDr/AQ4?=
 =?us-ascii?Q?n9h1duJR7w/SPeFqBZ1wMdrOz30k9UYRQXHOsIVS3ZH4znZGHT3DE8oiw7b9?=
 =?us-ascii?Q?Twk6KhIECTqrtI7Xn61ex9bVhzG8Fb/4VdemfCCu+7UJTtVZjUtFyWCQEop5?=
 =?us-ascii?Q?ck1RjCunvpoQCy4NwqZhZqix/8wtzhLcyOYmiMdD2OTB+LxYljgHvdLtLOg1?=
 =?us-ascii?Q?xED/bg4KkLYr++fhfhzo0viFGlKw6EY9KdEv4GQcDEx9rzUcfTjBFv/KUdZ3?=
 =?us-ascii?Q?yH5PO7Ma1ZNrIBjbpEnz15Beddtml2cxRKCrdwTM71/2lOflS58Xkix93QvF?=
 =?us-ascii?Q?3bdTkhrb9HAMryUIYHfxMJ8tXcs0aT6xF9KW3FNuAiN4SvQCAP/4187NKuDp?=
 =?us-ascii?Q?C1fpadf4nx/aS1BxVyHHXbfXZHHXcV58Mll1oNzfrxlOlAqMIpJuCjY01JiX?=
 =?us-ascii?Q?tvVAdtpRncIHOCShe029mrCsG+8I4hUA0Mgdxal1B1uXO2sBOXuwdTPWKBmj?=
 =?us-ascii?Q?bYuhe74y/zyxGs+XuLK8WWwZIxicEnWdk3rIbUFP78tPA/HPyX50YDVq9+yd?=
 =?us-ascii?Q?qpUWa6iGEE3q0QOGp4ZqEAHdQYm+AANamHvc3eSvvf8kPbknyIN6M+3XLOOq?=
 =?us-ascii?Q?Oc5xiY7ohkLbLZ/4+M+sXLeI2A6TvdO6aEL/GuFMOHrWalGOP/+18XL5Ra+f?=
 =?us-ascii?Q?Mrrw6aFI7jwHydHek9gIA87+NmlHQZgI7NFM/pdoTQ/RiZ717FHc3WOt24ig?=
 =?us-ascii?Q?Pwv/N2qmihWBlllJmiAZU1cHfAwjLIgsMgEOv0cZiYCswr5FnEKmJ5cjYDFR?=
 =?us-ascii?Q?BPyGRMfU91723QlPLYSXL7O+ZFqUL82eHAfNlVdDXi4mu2PUtpIfKQ+Vydvn?=
 =?us-ascii?Q?dhSHGWgGfyjcqhqVsSP1TGCZPmHfzmxys4//Ph9D0VVCE8Xtk5oKtCzBjgRY?=
 =?us-ascii?Q?orPF9Tn7SclvFT9rPJDYNud8U7GMYOYPaPbA9IVfSV71knlmFdZmATSqWgfl?=
 =?us-ascii?Q?72UMD1fBWfcKQaQpesADnB+nM+Ox+UY7hF962Bub1VMn1+cFh5SCZg99tF80?=
 =?us-ascii?Q?X54pow8ncWZ1HyG30VJwS+4XPGDR/fti+sBNhqXNyHreOrsvUav9V8V3tqub?=
 =?us-ascii?Q?IUzO5MBFkVc+tk3gL87CdivZ9enCQfAAf3zSu9wbkpcfur/04B5d6GuImKyT?=
 =?us-ascii?Q?dEdCtuVRcHVjKgysOWsPHInJSuThw/A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2770.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 972dc25b-85e4-4ce9-d687-08da24c67d44
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2022 01:13:34.9821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DrNaM8Y4RmMJAjOKYcszV3IgNYQeJNh3a7q9b2xlDzMr3J7dhUG7Kng4stge7JwBpZ7YljdtmcYcXmipka+W8Blwq9wQLl3lf1+zAT1omHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>What you need to do is extend your DSD to list the fixed-link. See
>
>https://www.kernel.org/doc/html/latest/firmware-
>guide/acpi/dsd/phy.html#mac-node-example-with-a-fixed-link-subnode
>
Thanks for the feedback. I will explore with the BIOS supplier to the proje=
ct
on this.
