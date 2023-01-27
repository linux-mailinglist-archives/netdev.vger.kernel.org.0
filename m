Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A46967ED16
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbjA0SNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjA0SNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:13:07 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7424F193C6;
        Fri, 27 Jan 2023 10:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674843171; x=1706379171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hgLfUSm6i0OFq5M65pWHlwpwz9SNEqnwWwDynlRueas=;
  b=RrABqC509gmD5kws/dnFWxiar5tbmVZbA2VHEZQnrC6MDVanImkkMR4E
   59PVLYe4/LO7Xih1bPgwk3iwFwFivoISuVuNHIAkWDWD4rDoi5+IPTBSt
   PAqZ0Va/GBUKO1oxgVgw/UdBqHHnOM/so0GbdtzI4kZw0PvKFubH0V6aY
   AhKkVQiZkyNOdv+mT64zWXLcTPbJuAhMJqHYH0i6XgnYC1o6FOKlKobqn
   iMCCV9Bsehcu57Z12yhgISEAGzpIIL7nIU81LAkPu82U6BDr4oK6PcAKB
   rY21Jc29WpjoV26WtZGM53qRfN/xujO9WSfdk/lgB0qhTqCI/ukPZY8OL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="306800238"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="306800238"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 10:12:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="908756539"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="908756539"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2023 10:12:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 10:12:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 10:12:49 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 10:12:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGyVG2VNLcthv5YR04eHqNjTFKK4+c4G3qRlX3fbKCjk0vrl4M90Awm3yq5/W4tN8CRYPrS9cDMSKQkj5oGxjaMwaPx5BqRElAPYGXImh1FaInqCJn5+NAufkRZq96rOdPRETg2adq7jqoHgVTmh3tavy3EXMzR9+QCsl27y0p3Koq07kmV0h7QG9QZWiB2kjs3t+fc/EiPZuWq7+TcbCQQ4i/jXyE7XV/b9aCyTWfAcUesKTfnxm63DF3fqMFHhIWCYFwk0hPxQ3DtiCuTQjvxpZClf9qKwoZFJmqqA3KX3tDKHznJrNZA7OwSTm3fBE+Utp6BP4Q0QxgoPMuHW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmNZJPpzTBmbncUBWw7Egc/6nH6QIpPF6Iabh540j2Y=;
 b=RP7SoLoDsVCJAjfFchGbvy5Gi8EkUnNmH/ecXyT6wNQwJL7GtWgEkOvFYURM6U1Q5J8RAoYtD9/wTCtm2vGndzfLqcsYJZsS1W7Hb5jAZMSx02opM8HXCI4EB/3l6f6ZDtBDaWmvnwFG5+jFqtAxnz+qBo1I+8GC2TIetPJf0oO+cx9O+WBMh+Zv3p2Rn5v2xsrhAuoYFCTGiltJshtwxeWawqwXp1grlZOCIxfNyU8YEv1pTg9yqiTXIJJ1f+vNkjK5/afUDN6dDPwBct4KSmxToV5QxOx0lr6qTb0v2REHYOiAK3c3WxhjJ5LuNbz08M0tlmf8WvaCTDvC8u3omQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:12:42 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::9c46:2880:3985:6f89]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::9c46:2880:3985:6f89%4]) with mapi id 15.20.6043.025; Fri, 27 Jan 2023
 18:12:42 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZKp4K9cfIHTE4HkioJShQwVs1zK6l/jqAgAyiMiA=
Date:   Fri, 27 Jan 2023 18:12:41 +0000
Message-ID: <DM6PR11MB46575F782A66620E1A2D04229BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com> <Y8l63RF8DQz3i0LY@nanopsycho>
In-Reply-To: <Y8l63RF8DQz3i0LY@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MN0PR11MB5986:EE_
x-ms-office365-filtering-correlation-id: 7941f525-8257-4a7d-fe71-08db00921501
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6Do5M4MHwQiQ87RFHJenRruI/aHE9ZpYgFxLCEHZRKTLHYuqYdy8RjYLs1fWQgcfUEX5d6fHCowhjK9Xdje45S6lvy8tLY9pvYSThd6SP0PHJ7oQcNJqa13JY2asLXH4b0EwfmbeB8x+zf8jXhqPeoU8ctCayjPhhNRyUhdO4JrdzwTH7LcLj+ny6pG9PDdW/+e4orTHQig83iI4p+EqSKEzFHtYzO0DRVrXeC/eEUHD7XrI+23+HZ4EnBdcQjtVikiDOaNmHU2OCKSYqClKymIXSRO/lMpX9lt6e1V9ediaVEB4QbabPw819gZC0I5zYqv0uNWTJiwKcmapw5ZcKn76kWNT1qCz8+WmgHlTKJ/rTW2uK/rwvGSa/nq7Z4gBVYJWJbSu5D/i1KbUePxFLTSwEQ5EZi48nHj3QhAhM64q4TGW8KyFBr2r2P6EcV7Gp2/AHEosAF7J31A+jSaG6kNxJooJV81g7FPY7bQUh9x24nGm6kDsL2akjDsGqqF9ngq2h2/RkKSqrC86yhEV56lL1bcqZ7lX4cLuAYDhFQMXXu0ektl20nQBnxr4IE0xsrEOdSH/Gl9t83XSH8tMJ5/HZLIvTaOafJTsicvEWBHyoRtBKTpRCWnVBMIXvgs/qdGQPuoo8B3ZzHFnrCZJQZxNtVqge3iRP4H6YH71KJigQazHBLkAPUIPsZ0k1K5TUQG4WxmnMfV9hWm9hmzBkXgW9/XsDdFiXbHwH7VUmc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199018)(45080400002)(8676002)(71200400001)(33656002)(7696005)(54906003)(966005)(55016003)(38100700002)(122000001)(9686003)(38070700005)(110136005)(26005)(83380400001)(86362001)(186003)(30864003)(478600001)(107886003)(6506007)(82960400001)(316002)(52536014)(64756008)(8936002)(66446008)(66476007)(66556008)(5660300002)(4326008)(2906002)(76116006)(66946007)(41300700001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r1Sjn73TeCpiMK79pa4ErSdJD3sNbS+wvK+kZN8E1P/6FV3RzwFeQnMpxahF?=
 =?us-ascii?Q?ahY9wDj3uPZghCEkBGwSESY8LNWJFt67OM+zqjwg5SmpKQyC6YHJ4XIlK2XY?=
 =?us-ascii?Q?frKZFb5ivE630Gx7NiwJW040XSuFvqEubVsZqHF99tb6g824sSn/IeSuxoG1?=
 =?us-ascii?Q?IXOgXefhTD+TUfUrMuaZaOOVxsCHZ9OVHbo0LCcEeFyeKgyqciva2IJIPWrO?=
 =?us-ascii?Q?Bv6et8qKbRRbzup0JCKEKBZTa8SQ7OvAJmaM7L9ew1Z0yBBcJoai/pfePFBk?=
 =?us-ascii?Q?vXlP5GyAW9vCusuG2eg2dBhiLkReKkw2PVxKRLbtuS8y7qZrIczW92Q0qgmG?=
 =?us-ascii?Q?KnL2DXB6zkIFNKd0i9DAqRvOdTssKa7YohryfF+6JeBt9RWfCOSpOxJeHaI5?=
 =?us-ascii?Q?ijArB0gDSPMZ1GVST2e5p2PGHLffEu6VWgooUKGUHNdTMq19Tcc2Hvo/A42X?=
 =?us-ascii?Q?Mg0arUYz1EzgjMmDS4ZdgtSqA+5ks4JCkmebNpO7wN4YYRY0cSC6ORGI2RWk?=
 =?us-ascii?Q?vAQqxRxN1QSWX0qvjvEzOddkZsigpRhyLKdcLu2e/OjaEMC9t9jZinYIWHwi?=
 =?us-ascii?Q?Wd8Kgz/haYXOgfH5FpNzCv85YDhRj78JwBrQIQ/TWkxJ4WjURNPV1Eg1V4HE?=
 =?us-ascii?Q?7BufRXEOMjJwIOX3Ss4L4Kdn5O4yEh4uv82A/dUcEUwSbnfJ0AI5j02n/Ezh?=
 =?us-ascii?Q?50U9JrtCEyhfHQjWzxABjKKRw8YBK9Jo8XbUzlxGruB15Pn8QOO8bCDVq3wG?=
 =?us-ascii?Q?ac0LG8F0Gv00Wf74RKLJY5Uavq3IJkzWrWOocjvb6dLRkbUSC9Awdiu7m5o8?=
 =?us-ascii?Q?VFBS3Tgrl9IkEcPOzYDrB6JWQ77ez3KhzvZVQ60lArby0sVVMP9Odb19VPwv?=
 =?us-ascii?Q?4GEf1K2qA1zic9T8y7PmgVgivfw4pNci6adSWvJNYbTNLIeBN3I0dzc5L7gr?=
 =?us-ascii?Q?/Cyv32baFgHKZV6vWOAj4uPlFQhH49TSPSMA1sIlzlCHkqIelHWt+jsUatC8?=
 =?us-ascii?Q?PjaQurGGT3Oq7i8SGsr+ofYds/MpVUU6lTdAMblYI6eXOVMcHjdDv8ESez3i?=
 =?us-ascii?Q?pyNEJaUtFn1hJc+MGoapKWKDT9yD5xaOPUOdVS475IE3liSXJyDH9GvFgwHU?=
 =?us-ascii?Q?2b6gvxaz85BiKkLcyjmd3r+7D59MmO6aUk/GQ2NVDci2QHUckFsRUIYQ+wsz?=
 =?us-ascii?Q?Z4xwvxGnKjO6gucVMACZdLZCF+VoGr+w3qx5ekyzoD1CGDcLza1AtLNW8PJC?=
 =?us-ascii?Q?bim2vj0lsBpXYSjgE40Qz1PeXVUbGnwCFyfRekGgDASPTfkvuwViNH/nsU47?=
 =?us-ascii?Q?7WnB8/SglIG2NsiRszQZci2Ofu3vAvmulb2wmPbTV+tDA/auShm42M7Qtq8I?=
 =?us-ascii?Q?HD+hCLnZNUCWW0c2PRTmgQmaqbTkjhSMrZr2aNzXYiZxOVu2YT6KgDYo5wuP?=
 =?us-ascii?Q?KFMwY8iYYXnO+EsTylxxHgRABjbkmFvMgqNZ8ornOrI3vIv27BnCofVUCh/d?=
 =?us-ascii?Q?joy81gW6k4MKori5obdKPMSrXuoMTrKd7vfJ91jPvQwVVPRo88g8J7SRWg07?=
 =?us-ascii?Q?THWTUEqdOl6G5mgtpZ3YKRo5Jmal2INK6Bjl+VXYvIyDCamTVOKOLhkEA4gf?=
 =?us-ascii?Q?5Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7941f525-8257-4a7d-fe71-08db00921501
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2023 18:12:42.0578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VLN2KTrh4QDHlTFDska/rZxhHNvvA0INdSWTX8wX+YlrZEGXHa2ccCezVZkwMsnG/NsQZgrRWZmzxmGfV1P8AohhH0cDvqfHMlyLbqhe+9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, January 19, 2023 6:16 PM
>
>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:
>>DPLL framework is used to represent and configure DPLL devices
>>in systems. Each device that has DPLL and can configure sources
>>and outputs can use this framework. Netlink interface is used to
>>provide configuration data and to receive notification messages
>>about changes in the configuration or status of DPLL device.
>>Inputs and outputs of the DPLL device are represented as special
>>objects which could be dynamically added to and removed from DPLL
>>device.
>>
>>Co-developed-by: Milena Olech <milena.olech@intel.com>
>>Signed-off-by: Milena Olech <milena.olech@intel.com>
>>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>>---
>> MAINTAINERS                 |    8 +
>> drivers/Kconfig             |    2 +
>> drivers/Makefile            |    1 +
>> drivers/dpll/Kconfig        |    7 +
>> drivers/dpll/Makefile       |    9 +
>> drivers/dpll/dpll_core.c    | 1010 +++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_core.h    |  105 ++++
>> drivers/dpll/dpll_netlink.c |  883 ++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h |   24 +
>> include/linux/dpll.h        |  282 ++++++++++
>> include/uapi/linux/dpll.h   |  294 ++++++++++
>> 11 files changed, 2625 insertions(+)
>> create mode 100644 drivers/dpll/Kconfig
>> create mode 100644 drivers/dpll/Makefile
>> create mode 100644 drivers/dpll/dpll_core.c
>> create mode 100644 drivers/dpll/dpll_core.h
>> create mode 100644 drivers/dpll/dpll_netlink.c
>> create mode 100644 drivers/dpll/dpll_netlink.h
>> create mode 100644 include/linux/dpll.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>>diff --git a/MAINTAINERS b/MAINTAINERS
>>index f82dd8d43c2b..de8a10b21ce8 100644
>>--- a/MAINTAINERS
>>+++ b/MAINTAINERS
>>@@ -6411,6 +6411,14 @@ F:
>>	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/swit
>>ch-drive
>> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>>
>>+DPLL CLOCK SUBSYSTEM
>>+M:	Vadim Fedorenko <vadfed@fb.com>
>>+L:	netdev@vger.kernel.org
>>+S:	Maintained
>>+F:	drivers/dpll/*
>>+F:	include/net/dpll.h
>>+F:	include/uapi/linux/dpll.h
>>+
>> DRBD DRIVER
>> M:	Philipp Reisner <philipp.reisner@linbit.com>
>> M:	Lars Ellenberg <lars.ellenberg@linbit.com>
>>diff --git a/drivers/Kconfig b/drivers/Kconfig
>>index 968bd0a6fd78..453df9e1210d 100644
>>--- a/drivers/Kconfig
>>+++ b/drivers/Kconfig
>>@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
>>
>> source "drivers/hte/Kconfig"
>>
>>+source "drivers/dpll/Kconfig"
>>+
>> endmenu
>>diff --git a/drivers/Makefile b/drivers/Makefile
>>index bdf1c66141c9..7cbee58bc692 100644
>>--- a/drivers/Makefile
>>+++ b/drivers/Makefile
>>@@ -189,3 +189,4 @@ obj-$(CONFIG_COUNTER)		+=3D counter/
>> obj-$(CONFIG_MOST)		+=3D most/
>> obj-$(CONFIG_PECI)		+=3D peci/
>> obj-$(CONFIG_HTE)		+=3D hte/
>>+obj-$(CONFIG_DPLL)		+=3D dpll/
>>diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
>>new file mode 100644
>>index 000000000000..a4cae73f20d3
>>--- /dev/null
>>+++ b/drivers/dpll/Kconfig
>>@@ -0,0 +1,7 @@
>>+# SPDX-License-Identifier: GPL-2.0-only
>>+#
>>+# Generic DPLL drivers configuration
>>+#
>>+
>>+config DPLL
>>+  bool
>>diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>>new file mode 100644
>>index 000000000000..b18cf848a010
>>--- /dev/null
>>+++ b/drivers/dpll/Makefile
>>@@ -0,0 +1,9 @@
>>+# SPDX-License-Identifier: GPL-2.0
>>+#
>>+# Makefile for DPLL drivers.
>>+#
>>+
>>+obj-$(CONFIG_DPLL)          +=3D dpll_sys.o
>>+dpll_sys-y                  +=3D dpll_core.o
>>+dpll_sys-y                  +=3D dpll_netlink.o
>>+
>>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>new file mode 100644
>>index 000000000000..fec534f17827
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.c
>>@@ -0,0 +1,1010 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ *  dpll_core.c - Generic DPLL Management class support.
>>+ *
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>+
>>+#include <linux/device.h>
>>+#include <linux/err.h>
>>+#include <linux/slab.h>
>>+#include <linux/string.h>
>>+
>>+#include "dpll_core.h"
>>+
>>+/**
>>+ * struct dpll_pin - structure for a dpll pin
>>+ * @idx:		unique id number for each pin
>>+ * @parent_pin:		parent pin
>>+ * @type:		type of the pin
>>+ * @ops:		operations this &dpll_pin supports
>>+ * @priv:		pointer to private information of owner
>>+ * @ref_dplls:		array of registered dplls
>>+ * @description:	name to distinguish the pin
>>+ */
>>+struct dpll_pin {
>>+	u32 idx;
>>+	struct dpll_pin *parent_pin;
>>+	enum dpll_pin_type type;
>>+	struct dpll_pin_ops *ops;
>>+	void *priv;
>>+	struct xarray ref_dplls;
>>+	char description[DPLL_PIN_DESC_LEN];
>>+};
>>+static DEFINE_MUTEX(dpll_device_xa_lock);
>>+
>>+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>>+#define DPLL_REGISTERED		XA_MARK_1
>>+#define PIN_REGISTERED		XA_MARK_1
>
>DPLL_PIN_REGISTERED
>

Agree, will fix that.

>
>>+
>>+#define ASSERT_DPLL_REGISTERED(d)
>>\
>>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+#define ASSERT_DPLL_NOT_REGISTERED(d)
>>\
>>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>>+
>>+struct dpll_pin_ref {
>>+	struct dpll_device *dpll;
>>+	struct dpll_pin_ops *ops;
>>+	void *priv;
>>+};
>>+
>>+/**
>>+ * dpll_device_get_by_id - find dpll device by it's id
>>+ * @id: id of searched dpll
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_device_get_by_id(int id)
>>+{
>>+	struct dpll_device *dpll =3D NULL;
>>+
>>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>>+		dpll =3D xa_load(&dpll_device_xa, id);
>>+
>>+	return dpll;
>>+}
>>+
>>+/**
>>+ * dpll_device_get_by_name - find dpll device by it's id
>>+ * @name: name of searched dpll
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_device_get_by_name(const char *name)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>+		if (!strcmp(dev_name(&dpll->dev), name)) {
>>+			ret =3D dpll;
>>+			break;
>>+		}
>>+	}
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+
>>+	return ret;
>>+}
>>+
>>+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
>
>Hmm, don't you want to put an owner module as an arg here as well? I
>don't see how could 2 modules sanely work with the same dpll instance.
>

Sorry, I don't get it.
How the driver that needs to find a dpll would know the owner module?
The idea of this is to let another driver instance to find a dpll device
already registered in OS.
The driver that is searching dpll device is not the same as the one that ha=
s
created the device, otherwise it wouldn't make any sense?

>
>>+						enum dpll_type type, u8 idx)
>>+{
>>+	struct dpll_device *dpll, *ret =3D NULL;
>>+	unsigned long index;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>+		if (dpll->clock_id =3D=3D clock_id) {
>>+			if (dpll->type =3D=3D type) {
>>+				if (dpll->dev_driver_idx =3D=3D idx) {
>>+					ret =3D dpll;
>>+					break;
>>+				}
>>+			}
>>+		}
>>+	}
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_get_by_clock_id);
>>+
>>+static void dpll_device_release(struct device *dev)
>>+{
>>+	struct dpll_device *dpll;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	dpll =3D to_dpll_device(dev);
>>+	dpll_device_unregister(dpll);
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+	dpll_device_free(dpll);
>>+}
>>+
>>+static struct class dpll_class =3D {
>>+	.name =3D "dpll",
>>+	.dev_release =3D dpll_device_release,
>
>Why do you want to do this? Why the driver cannot do
>dpll_device_unregister/free() manually. I think it makes things easier
>to read then to rely on dev garbage collector.
>

This was in the first version submitted by Vadim.
I think we can remove it, unless someone has different view?

>
>>+};
>>+
>>+struct dpll_device
>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>+		   const u64 clock_id, enum dpll_clock_class clock_class,
>>+		   u8 dev_driver_idx, void *priv, struct device *parent)
>>+{
>>+	struct dpll_device *dpll;
>>+	int ret;
>>+
>>+	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
>>+	if (!dpll)
>>+		return ERR_PTR(-ENOMEM);
>>+
>>+	mutex_init(&dpll->lock);
>>+	dpll->ops =3D ops;
>>+	dpll->dev.class =3D &dpll_class;
>>+	dpll->parent =3D parent;
>>+	dpll->type =3D type;
>>+	dpll->dev_driver_idx =3D dev_driver_idx;
>>+	dpll->clock_id =3D clock_id;
>>+	dpll->clock_class =3D clock_class;
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll,
>>+		       xa_limit_16b, GFP_KERNEL);
>>+	if (ret)
>>+		goto error;
>>+	dev_set_name(&dpll->dev, "dpll_%s_%d_%d", dev_name(parent), type,
>>+		     dev_driver_idx);
>>+	dpll->priv =3D priv;
>>+	xa_init_flags(&dpll->pins, XA_FLAGS_ALLOC);
>>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>
>What is exactly the point of using this mark?
>

I think this can be also removed now, as there is no separated alloc/regist=
er
for newly created dpll device.

>
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+	dpll_notify_device_create(dpll);
>>+
>>+	return dpll;
>>+
>>+error:
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+	kfree(dpll);
>>+	return ERR_PTR(ret);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_alloc);
>>+
>>+void dpll_device_free(struct dpll_device *dpll)
>>+{
>>+	WARN_ON_ONCE(!dpll);
>>+	WARN_ON_ONCE(!xa_empty(&dpll->pins));
>>+	xa_destroy(&dpll->pins);
>>+	mutex_destroy(&dpll->lock);
>>+	kfree(dpll);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_free);
>>+
>>+/**
>>+ * dpll_device_unregister - unregister dpll device
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Note: It does not free the memory
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll)
>>+{
>>+	ASSERT_DPLL_REGISTERED(dpll);
>>+
>>+	mutex_lock(&dpll_device_xa_lock);
>>+	xa_erase(&dpll_device_xa, dpll->id);
>>+	dpll_notify_device_delete(dpll);
>
>Why do you need to hold the lock for notify?
>

Good catch, will move it out of critical section.

>
>>+	mutex_unlock(&dpll_device_xa_lock);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>>+
>>+/**
>>+ * dpll_id - return dpll id
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: dpll id.
>>+ */
>>+u32 dpll_id(struct dpll_device *dpll)
>>+{
>>+	return dpll->id;
>>+}
>>+
>>+/**
>>+ * dpll_pin_idx - return index of a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: index of a pin or PIN_IDX_INVALID if not found.
>>+ */
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each_marked(&dpll->pins, index, pos, PIN_REGISTERED) {
>>+		if (pos =3D=3D pin)
>
>What is the purpose of the lookup for the pin struct you pass as an arg?
>

Seems like no longer needed, will try to remove it.

>
>>+			return pin->idx;
>>+	}
>>+
>>+	return PIN_IDX_INVALID;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_idx);
>>+
>>+const char *dpll_dev_name(struct dpll_device *dpll)
>>+{
>>+	return dev_name(&dpll->dev);
>>+}
>>+
>>+struct dpll_pin *dpll_pin_alloc(const char *description,
>>+				const enum dpll_pin_type pin_type)
>
>s/pin_type/type/
>

Sure, will do.

>
>>+{
>>+	struct dpll_pin *pin =3D kzalloc(sizeof(struct dpll_pin), GFP_KERNEL);
>>+
>>+	if (!pin)
>>+		return ERR_PTR(-ENOMEM);
>>+	if (pin_type <=3D DPLL_PIN_TYPE_UNSPEC ||
>>+	    pin_type > DPLL_PIN_TYPE_MAX)
>>+		return ERR_PTR(-EINVAL);
>
>I think this check is not needed here. If driver is passing something
>else, it is buggy. Idk. If you decide to leave this, put it in WARN_ON
>

Sure, will do.

>
>>+
>>+	strncpy(pin->description, description, DPLL_PIN_DESC_LEN);
>
>kstrdup. Please treat the rest of the strings like that. No need to
>limit the string names.

Ok, will follow.

>
>
>>+	pin->description[DPLL_PIN_DESC_LEN - 1] =3D '\0';
>>+	xa_init_flags(&pin->ref_dplls, XA_FLAGS_ALLOC);
>>+	pin->type =3D pin_type;
>>+
>>+	return pin;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_alloc);
>>+
>>+static int dpll_alloc_pin_on_xa(struct xarray *pins, struct dpll_pin
>>*pin)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each(pins, index, pos) {
>>+		if (pos =3D=3D pin ||
>>+		    !strncmp(pos->description, pin->description,
>>+			     DPLL_PIN_DESC_LEN))
>
>WARN_ON. The driver is buggy if it does something like this.

Sure, will do.

>
>
>>+			return -EEXIST;
>>+	}
>>+
>>+	ret =3D xa_alloc(pins, &pin->idx, pin, xa_limit_16b, GFP_KERNEL);
>>+	if (!ret)
>>+		xa_set_mark(pins, pin->idx, PIN_REGISTERED);
>
>What is exactly the point of having this mark?
>

Think this could be now removed, we got rid of separated alloc/register for
dpll device.

>
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_pin_ref_add(struct dpll_pin *pin, struct dpll_device
>>*dpll,
>>+			    struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin_ref *ref, *pos;
>>+	unsigned long index;
>>+	u32 idx;
>>+
>>+	ref =3D kzalloc(sizeof(struct dpll_pin_ref), GFP_KERNEL);
>>+	if (!ref)
>>+		return -ENOMEM;
>>+	ref->dpll =3D dpll;
>>+	ref->ops =3D ops;
>>+	ref->priv =3D priv;
>>+	if (!xa_empty(&pin->ref_dplls)) {
>
>Pointless check. Just do iterate.
>

Sure, will do.

>
>>+		xa_for_each(&pin->ref_dplls, index, pos) {
>>+			if (pos->dpll =3D=3D ref->dpll)
>>+				return -EEXIST;
>>+		}
>>+	}
>>+
>>+	return xa_alloc(&pin->ref_dplls, &idx, ref, xa_limit_16b,
>>GFP_KERNEL);
>>+}
>>+
>>+static void dpll_pin_ref_del(struct dpll_pin *pin, struct dpll_device
>>*dpll)
>>+{
>>+	struct dpll_pin_ref *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each(&pin->ref_dplls, index, pos) {
>>+		if (pos->dpll =3D=3D dpll) {
>>+			WARN_ON_ONCE(pos !=3D xa_erase(&pin->ref_dplls, index));
>>+			break;
>>+		}
>>+	}
>>+}
>>+
>>+static int pin_deregister_from_xa(struct xarray *xa_pins, struct dpll_pi=
n
>>*pin)
>
>1) dpll_ prefix

Sure, will do.

>2) "deregister" is odd name

Rodger that, will fix.

>3) why don't you have it next to dpll_alloc_pin_on_xa() as it is a
>   symmetric function?

Will do.

>4) Why exactly just xa_erase() would not do?

Might do, but need to rethink this :)

>
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each(xa_pins, index, pos) {
>>+		if (pos =3D=3D pin) {
>>+			WARN_ON_ONCE(pos !=3D xa_erase(xa_pins, index));
>
>You have an odd pattern of functions getting pin as an arg then
>doing lookup for the same pin. I have to be missing to see some
>black magic here :O
>

The black magic was done to target correct pin in case pin index differs
between dplls it was registered with. It would depend on the way shared pin=
s
are going to be allocated.
If mixed pins approach is allowed (shared + non-shared pins) on any dpll, w=
e
would end up in situation where pin index for the same physical pin on mult=
iple
devices may be different, depending on registering pins order.

As desribed in below comments, I can see here one simple solution: allow ke=
rnel
module (which registers a pin with dpll) to control/assign pin index.
The kernel module would only need take care of them being unique, when
registers with first dpll - which seems not a problem. This way we would al=
so
be albe to get rid of searching pin function (as indexes would be known for=
 all
driver instances), different driver instances would use that index to share=
 a
pin.
Also all the blackmagic like you described wouldn't be needed, thus simplif=
ing
a dpll subsystem.

>
>>+			return 0;
>>+		}
>>+	}
>>+
>>+	return -ENXIO;
>>+}
>>+
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	int ret;
>>+
>>+	if (!pin || !ops)
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	ret =3D dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>+	if (!ret) {
>>+		ret =3D dpll_pin_ref_add(pin, dpll, ops, priv);
>>+		if (ret)
>>+			pin_deregister_from_xa(&dpll->pins, pin);
>>+	}
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>>+
>>+struct dpll_pin *dpll_pin_get_by_idx_from_xa(struct xarray *xa_pins, int
>>idx)
>>+{
>>+	struct dpll_pin *pos;
>>+	unsigned long index;
>>+
>>+	xa_for_each_marked(xa_pins, index, pos, PIN_REGISTERED) {
>>+		if (pos->idx =3D=3D idx)
>>+			return pos;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * dpll_pin_get_by_idx - find a pin by its index
>>+ * @dpll: dpll device pointer
>>+ * @idx: index of pin
>>+ *
>>+ * Allows multiple driver instances using one physical DPLL to find
>>+ * and share pin already registered with existing dpll device.
>>+ *
>>+ * Return: pointer if pin was found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx)
>>+{
>>+	return dpll_pin_get_by_idx_from_xa(&dpll->pins, idx);
>>+}
>>+
>>+	struct dpll_pin
>>+*dpll_pin_get_by_description(struct dpll_device *dpll, const char
>>*description)
>>+{
>>+	struct dpll_pin *pos, *pin =3D NULL;
>>+	unsigned long index;
>>+
>>+	xa_for_each(&dpll->pins, index, pos) {
>>+		if (!strncmp(pos->description, description,
>>+			     DPLL_PIN_DESC_LEN)) {
>>+			pin =3D pos;
>>+			break;
>>+		}
>>+	}
>>+
>>+	return pin;
>>+}
>>+
>>+int
>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>+			 struct dpll_device *dpll,
>>+			 const char *shared_pin_description,
>
>I don't follow why you need to pass the string. You have struct dpll_pin
>* in the driver. Pass that instead, avoid string to refer to kernel
>object. But this is something I wrote multiple times.
>

I wrote this so many times :) Separated driver instances doesn't have the p=
in
object pointer by default (unless they share it through some unwanted stati=
c/
global contatiners). They need to somehow target a pin, right now only uniq=
ue
attributes on dpll/pin pair are a description and index.
Desription is a constant, index depends on the order of initialization and =
is
internal for a dpll device.
Previously there were a function to obtain a pin index by its description, =
then
register with obtained index, now this is merged into one function.

Altough I agree this is still not best aproach.
I will fix by: fallback to targeting a pin to be shared by its index, with =
one
slight design change, the pin index would have to be given by the driver
instance which registers it with the first dpll.
All the other separated driver instances which are using that pin will have=
 to
know the index assigned to the pin that is going to be shared, which seems
like a best approach to fix this issue.

>
>>+			 struct dpll_pin_ops *ops, void *priv)
>>+{
>>+	struct dpll_pin *pin;
>>+	int ret;
>>+
>>+	mutex_lock(&dpll_pin_owner->lock);
>>+	pin =3D dpll_pin_get_by_description(dpll_pin_owner,
>>+					  shared_pin_description);
>>+	if (!pin) {
>>+		ret =3D -EINVAL;
>>+		goto unlock;
>>+	}
>>+	ret =3D dpll_pin_register(dpll, pin, ops, priv);
>>+unlock:
>>+	mutex_unlock(&dpll_pin_owner->lock);
>>+
>>+	return ret;
>
>I don't understand why there should be a separate function to register
>the shared pin. As I see it, there is a pin object that could be
>registered with 2 or more dpll devices. What about having:
>
>pin =3D dpll_pin_alloc(desc, type, ops, priv)
>dpll_pin_register(dpll_1, pin);
>dpll_pin_register(dpll_2, pin);
>dpll_pin_register(dpll_3, pin);
>

IMHO your example works already, but it would possible only if the same dri=
ver
instance initializes all dplls.
dpll_shared_pin_register is designed for driver instances without the pin
object.
=20
>Then one pin will we in 3 xa_arrays for 3 dplls.
>

As we can see dpll_shared_pin_register is a fancy wrapper for
dpll_pin_register. So yeah, that's the point :) Just separated driver insta=
nces
sharing a pin are a issue, will fix with the approach described above (pin
index given by the registering driver instance).

>
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_shared_pin_register);
>>+
>>+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin)
>
>s/deregister/unregister. Be consistent in naming the functions.
>

Sure, will fix.

>
>>+{
>>+	int ret =3D 0;
>>+
>>+	if (xa_empty(&dpll->pins))
>>+		return -ENOENT;
>
>Remove this check
>

Sure, can do.

>>+
>>+	mutex_lock(&dpll->lock);
>>+	ret =3D pin_deregister_from_xa(&dpll->pins, pin);
>>+	if (!ret)
>>+		dpll_pin_ref_del(pin, dpll);
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_DEL);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_deregister);
>>+
>>+void dpll_pin_free(struct dpll_pin *pin)
>>+{
>>+	if (!xa_empty(&pin->ref_dplls))
>>+		return;
>>+
>>+	xa_destroy(&pin->ref_dplls);
>>+	kfree(pin);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_free);
>>+
>>+int dpll_muxed_pin_register(struct dpll_device *dpll,
>>+			    const char *parent_pin_description,
>
>Again, pass struct dpll_pin *parent, not a string.
>
>
>>+			    struct dpll_pin *pin,
>>+			    struct dpll_pin_ops *ops, void *priv)
>

Again, separated driver instances are the issue. Will fix with a parent pin
index given by registering driver, approach described above.

>Why this is a separate function? Why can't we have one function
>say __dpll_pin_register()
>which is called from
>dpll_pin_register() - parent =3D=3D null
>or
>dpll_muxed_pin_register() - parent =3D=3D valid parent pointer
>?
>

Sure, can try that. Altough as described above, a pin index instead of pare=
nt
pointer.

>
>
>>+{
>>+	struct dpll_pin *parent_pin;
>>+	int ret;
>>+
>>+	if (!parent_pin_description || !pin)
>>+		return -EINVAL;
>>+
>>+	mutex_lock(&dpll->lock);
>>+	parent_pin =3D dpll_pin_get_by_description(dpll,
>>parent_pin_description);
>>+	if (!parent_pin)
>>+		return -EINVAL;
>>+	if (parent_pin->type !=3D DPLL_PIN_TYPE_MUX)
>>+		return -EPERM;
>>+	ret =3D dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>+	if (!ret)
>>+		ret =3D dpll_pin_ref_add(pin, dpll, ops, priv);
>>+	if (!ret)
>>+		pin->parent_pin =3D parent_pin;
>>+	mutex_unlock(&dpll->lock);
>>+	if (!ret)
>>+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
>>+
>>+	return ret;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_muxed_pin_register);
>>+
>>+/**
>>+ * dpll_pin_first - get first registered pin
>>+ * @dpll: registered dpll pointer
>>+ * @index: found pin index (out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long
>>*index)
>>+{
>>+	*index =3D 0;
>>+
>>+	return xa_find(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
>>+}
>>+
>>+/**
>>+ * dpll_pin_next - get next registered pin to the relative pin
>>+ * @dpll: registered dpll pointer
>>+ * @index: relative pin index (in and out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long
>>*index)
>>+{
>>+	return xa_find_after(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
>>+}
>>+
>>+/**
>>+ * dpll_first - get first registered dpll device
>>+ * @index: found dpll index (out)
>>+ *
>>+ * Return: dpll_device struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_first(unsigned long *index)
>>+{
>>+	*index =3D 0;
>>+
>>+	return xa_find(&dpll_device_xa, index, LONG_MAX, DPLL_REGISTERED);
>>+}
>>+
>>+/**
>>+ * dpll_pin_next - get next registered dpll device to the relative pin
>>+ * @index: relative dpll index (in and out)
>>+ *
>>+ * Return: dpll_pin struct if found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_next(unsigned long *index)
>>+{
>>+	return xa_find_after(&dpll_device_xa, index, LONG_MAX,
>>DPLL_REGISTERED);
>>+}
>>+
>>+static struct dpll_pin_ref
>>+*dpll_pin_find_ref(const struct dpll_device *dpll, const struct dpll_pin
>>*pin)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long index;
>>+
>>+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
>>+		if (ref->dpll !=3D dpll)
>>+			continue;
>>+		else
>>+			return ref;
>>+	}
>>+
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * dpll_pin_type_get - get type of a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @type: on success - configured pin type
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got pin's type
>>+ * * negative - failed to get pin's type
>>+ */
>>+int dpll_pin_type_get(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin,
>>+		      enum dpll_pin_type *type)
>>+{
>>+	if (!pin)
>>+		return -ENODEV;
>>+	*type =3D pin->type;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_pin_signal_type_get - get signal type of a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @type: on success - configured signal type
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got signal type
>>+ * * negative - failed to obtain signal type
>>+ */
>>+int dpll_pin_signal_type_get(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     enum dpll_pin_signal_type *type)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->signal_type_get)
>>+		return -EOPNOTSUPP;
>>+	ret =3D ref->ops->signal_type_get(ref->dpll, pin, type);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_signal_type_set - set signal type of a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @type: type to be set
>>+ *
>>+ * Return:
>>+ * * 0 - signal type set
>>+ * * negative - failed to set signal type
>>+ */
>>+int dpll_pin_signal_type_set(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     const enum dpll_pin_signal_type type)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
>>+		if (!ref->dpll)
>>+			return -EFAULT;
>>+		if (!ref || !ref->ops || !ref->ops->signal_type_set)
>>+			return -EOPNOTSUPP;
>>+		if (ref->dpll !=3D dpll)
>>+			mutex_lock(&ref->dpll->lock);
>>+		ret =3D ref->ops->signal_type_set(ref->dpll, pin, type);
>>+		if (ref->dpll !=3D dpll)
>>+			mutex_unlock(&ref->dpll->lock);
>>+		if (ret)
>>+			return ret;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_signal_type_supported - check if signal type is supported on
>>a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @type: type being checked
>>+ * @supported: on success - if given signal type is supported
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got supported signal type
>>+ * * negative - failed to obtain supported signal type
>>+ */
>>+int dpll_pin_signal_type_supported(const struct dpll_device *dpll,
>>+				   const struct dpll_pin *pin,
>>+				   const enum dpll_pin_signal_type type,
>>+				   bool *supported)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->signal_type_supported)
>>+		return -EOPNOTSUPP;
>>+	*supported =3D ref->ops->signal_type_supported(ref->dpll, pin, type);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_pin_mode_active - check if given mode is active on a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @mode: mode being checked
>>+ * @active: on success - if mode is active
>>+ *
>>+ * Return:
>>+ * * 0 - successfully checked if mode is active
>>+ * * negative - failed to check for active mode
>>+ */
>>+int dpll_pin_mode_active(const struct dpll_device *dpll,
>>+			  const struct dpll_pin *pin,
>>+			  const enum dpll_pin_mode mode,
>>+			  bool *active)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->mode_active)
>>+		return -EOPNOTSUPP;
>>+	*active =3D ref->ops->mode_active(ref->dpll, pin, mode);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_pin_mode_supported - check if given mode is supported on a pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @mode: mode being checked
>>+ * @supported: on success - if mode is supported
>>+ *
>>+ * Return:
>>+ * * 0 - successfully checked if mode is supported
>>+ * * negative - failed to check for supported mode
>>+ */
>>+int dpll_pin_mode_supported(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     const enum dpll_pin_mode mode,
>>+			     bool *supported)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->mode_supported)
>>+		return -EOPNOTSUPP;
>>+	*supported =3D ref->ops->mode_supported(ref->dpll, pin, mode);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * dpll_pin_mode_set - set pin's mode
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @mode: mode being set
>>+ *
>>+ * Return:
>>+ * * 0 - successfully set the mode
>>+ * * negative - failed to set the mode
>>+ */
>>+int dpll_pin_mode_set(const struct dpll_device *dpll,
>>+		       const struct dpll_pin *pin,
>>+		       const enum dpll_pin_mode mode)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
>
>I don't understand why you need to call ops->mode_enable for all the
>dplls. The pin is shared, it's the single entity. One call should be
>enough? Why not? Same for other attrs, with exception of PRIO.
>

Single pin can connect multiple dplls. Most probably one call would be enou=
gh
if all dplls are controlled by one driver instance. But as example draw fro=
m:

https://lore.kernel.org/netdev/DM6PR11MB4657DC9A41A69B71A42DD22F9BFC9@DM6PR=
11MB4657.namprd11.prod.outlook.com/=20

This is not always the case. So we want to call this on all dplls and let
their drivers decide if there is need to take an action or not.

When registering a pin, kernel module can pass ops=3DNULL for a dpll that d=
on't
require to be notified with callbacks about pin changes.

>
>>+		if (!ref)
>>+			return -ENODEV;
>>+		if (!ref->ops || !ref->ops->mode_enable)
>>+			return -EOPNOTSUPP;
>>+		if (ref->dpll !=3D dpll)
>>+			mutex_lock(&ref->dpll->lock);
>>+		ret =3D ref->ops->mode_enable(ref->dpll, pin, mode);
>>+		if (ref->dpll !=3D dpll)
>>+			mutex_unlock(&ref->dpll->lock);
>>+		if (ret)
>>+			return ret;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_custom_freq_get - get pin's custom frequency
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @freq: on success - custom frequency of a pin
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got custom frequency
>>+ * * negative - failed to obtain custom frequency
>>+ */
>>+int dpll_pin_custom_freq_get(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin, u32 *freq)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>
>How this can happen?
>

Something would be seriously bugged. Think we can remove it.

>
>>+	if (!ref->ops || !ref->ops->custom_freq_get)
>>+		return -EOPNOTSUPP;
>>+	ret =3D ref->ops->custom_freq_get(ref->dpll, pin, freq);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_custom_freq_set - set pin's custom frequency
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @freq: custom frequency to be set
>>+ *
>>+ * Return:
>>+ * * 0 - successfully set custom frequency
>>+ * * negative - failed to set custom frequency
>>+ */
>>+int dpll_pin_custom_freq_set(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin, const u32 freq)
>>+{
>>+	enum dpll_pin_signal_type type;
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long index;
>>+	int ret;
>>+
>>+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
>>+		if (!ref)
>>+			return -ENODEV;
>>+		if (!ref->ops || !ref->ops->custom_freq_set ||
>>+		    !ref->ops->signal_type_get)
>>+			return -EOPNOTSUPP;
>>+		if (dpll !=3D ref->dpll)
>>+			mutex_lock(&ref->dpll->lock);
>>+		ret =3D ref->ops->signal_type_get(dpll, pin, &type);
>>+		if (!ret && type =3D=3D DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ)
>>+			ret =3D ref->ops->custom_freq_set(ref->dpll, pin, freq);
>>+		if (dpll !=3D ref->dpll)
>>+			mutex_unlock(&ref->dpll->lock);
>>+		if (ret)
>>+			return ret;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_prio_get - get pin's prio on dpll
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @prio: on success - priority of a pin on a dpll
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got priority
>>+ * * negative - failed to obtain priority
>>+ */
>>+int dpll_pin_prio_get(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin, u32 *prio)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->prio_get)
>>+		return -EOPNOTSUPP;
>>+	ret =3D ref->ops->prio_get(ref->dpll, pin, prio);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_prio_set - set pin's prio on dpll
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @prio: priority of a pin to be set on a dpll
>>+ *
>>+ * Return:
>>+ * * 0 - successfully set priority
>>+ * * negative - failed to set the priority
>>+ */
>>+int dpll_pin_prio_set(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin, const u32 prio)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->prio_set)
>>+		return -EOPNOTSUPP;
>>+	ret =3D ref->ops->prio_set(ref->dpll, pin, prio);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_netifindex_get - get pin's netdev iterface index
>>+ * @dpll: registered dpll pointer
>>+ * @pin: registered pin pointer
>>+ * @netifindex: on success - index of a netdevice associated with pin
>>+ *
>>+ * Return:
>>+ * * 0 - successfully got netdev interface index
>>+ * * negative - failed to obtain netdev interface index
>>+ */
>>+int dpll_pin_netifindex_get(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin,
>>+			    int *netifindex)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+	int ret;
>>+
>>+	if (!ref)
>>+		return -ENODEV;
>>+	if (!ref->ops || !ref->ops->net_if_idx_get)
>>+		return -EOPNOTSUPP;
>>+	ret =3D ref->ops->net_if_idx_get(ref->dpll, pin, netifindex);
>
>return right away.
>

Sure, can do.

>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_pin_description - provide pin's description string
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: pointer to a description string.
>>+ */
>>+const char *dpll_pin_description(struct dpll_pin *pin)
>>+{
>>+	return pin->description;
>>+}
>>+
>>+/**
>>+ * dpll_pin_parent - provide pin's parent pin if available
>>+ * @pin: registered pin pointer
>>+ *
>>+ * Return: pointer to aparent if found, NULL otherwise.
>>+ */
>>+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin)
>
>What exactly is the reason of having one line helpers to access struct
>fields for a struct which is known to the caller? Unneccesary
>boilerplate code. Please remove these. For pin and for dpll_device as
>well.
>

Actually dpll_pin is defined in dpll_core.c, so it is not known to the call=
er
yet. About dpll_device, yes it is known. And we need common approach here, =
thus
we need a fix. I know this is kernel code, full of hacks and performance re=
lated
bad-design stuff, so will fix as suggested.

>
>
>>+{
>>+	return pin->parent_pin;
>>+}
>>+
>>+/**
>>+ * dpll_mode_set - handler for dpll mode set
>>+ * @dpll: registered dpll pointer
>>+ * @mode: mode to be set
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_mode_set(struct dpll_device *dpll, const enum dpll_mode mode)
>>+{
>>+	int ret;
>>+
>>+	if (!dpll->ops || !dpll->ops)
>>+		return -EOPNOTSUPP;
>>+
>>+	ret =3D dpll->ops->mode_set(dpll, mode);
>
>return right away. You have this pattern on multiple places, please fix.
>

Sure, will fix.

>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_source_idx_set - handler for selecting a dpll's source
>>+ * @dpll: registered dpll pointer
>>+ * @source_pin_idx: index of a source pin to e selected
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_source_idx_set(struct dpll_device *dpll, const u32
>>source_pin_idx)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	struct dpll_pin *pin;
>>+	int ret;
>>+
>>+	pin =3D dpll_pin_get_by_idx_from_xa(&dpll->pins, source_pin_idx);
>>+	if (!pin)
>>+		return -ENXIO;
>>+	ref =3D dpll_pin_find_ref(dpll, pin);
>>+	if (!ref || !ref->ops)
>>+		return -EFAULT;
>>+	if (!ref->ops->select)
>>+		return -ENODEV;
>
>ENODEV definitelly does not look like the correct value here.
>

Sure, will fix.

>
>>+	ret =3D ref->ops->select(ref->dpll, pin);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * dpll_lock - locks the dpll using internal mutex
>>+ * @dpll: registered dpll pointer
>>+ */
>>+void dpll_lock(struct dpll_device *dpll)
>>+{
>>+	mutex_lock(&dpll->lock);
>>+}
>>+
>>+/**
>>+ * dpll_unlock - unlocks the dpll using internal mutex
>>+ * @dpll: registered dpll pointer
>>+ */
>>+void dpll_unlock(struct dpll_device *dpll)
>>+{
>>+	mutex_unlock(&dpll->lock);
>>+}
>>+
>>+enum dpll_pin_type dpll_pin_type(const struct dpll_pin *pin)
>>+{
>>+	return pin->type;
>>+}
>>+
>>+void *dpll_priv(const struct dpll_device *dpll)
>>+{
>>+	return dpll->priv;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_priv);
>>+
>>+void *dpll_pin_priv(const struct dpll_device *dpll, const struct dpll_pi=
n
>>*pin)
>>+{
>>+	struct dpll_pin_ref *ref =3D dpll_pin_find_ref(dpll, pin);
>>+
>>+	if (!ref)
>>+		return NULL;
>>+
>>+	return ref->priv;
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_priv);
>>+
>>+static int __init dpll_init(void)
>>+{
>>+	int ret;
>>+
>>+	ret =3D dpll_netlink_init();
>>+	if (ret)
>>+		goto error;
>>+
>>+	ret =3D class_register(&dpll_class);
>>+	if (ret)
>>+		goto unregister_netlink;
>>+
>>+	return 0;
>>+
>>+unregister_netlink:
>>+	dpll_netlink_finish();
>>+error:
>>+	mutex_destroy(&dpll_device_xa_lock);
>>+	return ret;
>>+}
>>+subsys_initcall(dpll_init);
>>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>>new file mode 100644
>>index 000000000000..b933d63b60c1
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.h
>>@@ -0,0 +1,105 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_CORE_H__
>>+#define __DPLL_CORE_H__
>>+
>>+#include <linux/dpll.h>
>>+
>>+#include "dpll_netlink.h"
>>+
>>+#define to_dpll_device(_dev) \
>>+	container_of(_dev, struct dpll_device, dev)
>>+
>>+/**
>>+ * struct dpll_device - structure for a DPLL device
>>+ * @id:		unique id number for each device
>>+ * @dev:	struct device for this dpll device
>>+ * @parent:	parent device
>>+ * @ops:	operations this &dpll_device supports
>>+ * @lock:	mutex to serialize operations
>>+ * @type:	type of a dpll
>>+ * @priv:	pointer to private information of owner
>>+ * @pins:	list of pointers to pins registered with this dpll
>>+ * @clock_id:	unique identifier (clock_id) of a dpll
>>+ * @clock_class	quality class of a DPLL clock
>>+ * @dev_driver_idx: provided by driver for
>>+ */
>>+struct dpll_device {
>>+	u32 id;
>>+	struct device dev;
>>+	struct device *parent;
>>+	struct dpll_device_ops *ops;
>>+	struct mutex lock;
>>+	enum dpll_type type;
>>+	void *priv;
>>+	struct xarray pins;
>>+	u64 clock_id;
>>+	enum dpll_clock_class clock_class;
>>+	u8 dev_driver_idx;
>>+};
>>+
>>+#define for_each_pin_on_dpll(dpll, pin, i)			\
>>+	for (pin =3D dpll_pin_first(dpll, &i); pin !=3D NULL;	\
>>+	     pin =3D dpll_pin_next(dpll, &i))
>
>What is the purpose for this macro and dpll_pin_first/next() helper?
>Why is this not equivalent to:
>xa_for_each_marked(&dpll->pins, index, pos, PIN_REGISTERED)
>

At some point of implementation, struct dpll_device was private for dpll_co=
re.c
now we can probably have it simplified, will fix it.

>
>>+
>>+#define for_each_dpll(dpll, i)                         \
>>+	for (dpll =3D dpll_first(&i); dpll !=3D NULL; dpll =3D dpll_next(&i))
>
>Same here, why this macro and helpers are needed?
>

The XA of DPLLs is private to dpll_core.c

>
>>+
>>+struct dpll_device *dpll_device_get_by_id(int id);
>>+
>>+struct dpll_device *dpll_device_get_by_name(const char *name);
>>+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long
>*index);
>>+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long
>*index);
>>+struct dpll_device *dpll_first(unsigned long *index);
>>+struct dpll_device *dpll_next(unsigned long *index);
>>+void dpll_device_unregister(struct dpll_device *dpll);
>>+u32 dpll_id(struct dpll_device *dpll);
>>+const char *dpll_dev_name(struct dpll_device *dpll);
>>+void dpll_lock(struct dpll_device *dpll);
>>+void dpll_unlock(struct dpll_device *dpll);
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
>>+int dpll_pin_type_get(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin,
>>+		      enum dpll_pin_type *type);
>>+int dpll_pin_signal_type_get(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     enum dpll_pin_signal_type *type);
>>+int dpll_pin_signal_type_set(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     const enum dpll_pin_signal_type type);
>>+int dpll_pin_signal_type_supported(const struct dpll_device *dpll,
>>+				   const struct dpll_pin *pin,
>>+				   const enum dpll_pin_signal_type type,
>>+				   bool *supported);
>>+int dpll_pin_mode_active(const struct dpll_device *dpll,
>>+			 const struct dpll_pin *pin,
>>+			 const enum dpll_pin_mode mode,
>>+			 bool *active);
>>+int dpll_pin_mode_supported(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin,
>>+			    const enum dpll_pin_mode mode,
>>+			    bool *supported);
>>+int dpll_pin_mode_set(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin,
>>+		      const enum dpll_pin_mode mode);
>>+int dpll_pin_custom_freq_get(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin, u32 *freq);
>>+int dpll_pin_custom_freq_set(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin, const u32 freq);
>>+int dpll_pin_prio_get(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin, u32 *prio);
>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx);
>>+int dpll_pin_prio_set(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin, const u32 prio);
>>+int dpll_pin_netifindex_get(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin,
>>+			    int *netifindex);
>>+const char *dpll_pin_description(struct dpll_pin *pin);
>>+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin);
>>+int dpll_mode_set(struct dpll_device *dpll, const enum dpll_mode mode);
>>+int dpll_source_idx_set(struct dpll_device *dpll, const u32
>>source_pin_idx);
>>+
>>+#endif
>>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>>new file mode 100644
>>index 000000000000..91a1e5025ab2
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.c
>>@@ -0,0 +1,883 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ * Generic netlink for DPLL management framework
>>+ *
>>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ *
>>+ */
>>+#include <linux/module.h>
>>+#include <linux/kernel.h>
>>+#include <net/genetlink.h>
>>+#include "dpll_core.h"
>>+
>>+#include <uapi/linux/dpll.h>
>>+
>>+static const struct genl_multicast_group dpll_mcgrps[] =3D {
>>+	{ .name =3D DPLL_MONITOR_GROUP_NAME,  },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_device_get_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_FILTER]		=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_device_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_MODE]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_SOURCE_PIN_IDX]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_pin_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_IDX]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_SIGNAL_TYPE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_CUSTOM_FREQ] =3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_MODE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_PRIO]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+struct dpll_dump_ctx {
>>+	int dump_filter;
>>+};
>>+
>>+static struct genl_family dpll_gnl_family;
>>+
>>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback
>*cb)
>>+{
>>+	return (struct dpll_dump_ctx *)cb->ctx;
>>+}
>>+
>>+static int dpll_msg_add_id(struct sk_buff *msg, u32 id)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_ID, id))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_name(struct sk_buff *msg, const char *name)
>>+{
>>+	if (nla_put_string(msg, DPLLA_NAME, name))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_mode(struct sk_buff *msg, enum dplla msg_type,
>>+			       enum dpll_mode mode)
>>+{
>>+	if (nla_put_s32(msg, msg_type, mode))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_device *dpll)
>>+{
>>+	enum dpll_mode m;
>>+	int ret;
>>+
>>+	if (!dpll->ops->mode_get)
>>+		return 0;
>>+	ret =3D dpll->ops->mode_get(dpll, &m);
>>+	if (ret)
>>+		return ret;
>>+
>>+	return __dpll_msg_add_mode(msg, DPLLA_MODE, m);
>>+}
>>+
>>+static int
>>+dpll_msg_add_modes_supported(struct sk_buff *msg,
>>+			     const struct dpll_device *dpll)
>>+{
>>+	enum dpll_mode i;
>>+	int ret =3D 0;
>>+
>>+	if (!dpll->ops->mode_supported)
>>+		return ret;
>>+
>>+	for (i =3D DPLL_MODE_UNSPEC + 1; i <=3D DPLL_MODE_MAX; i++) {
>>+		if (dpll->ops->mode_supported(dpll, i)) {
>>+			ret =3D __dpll_msg_add_mode(msg, DPLLA_MODE_SUPPORTED, i);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_msg_add_clock_id(struct sk_buff *msg,
>>+				 const struct dpll_device *dpll)
>>+{
>>+	if (nla_put_64bit(msg, DPLLA_CLOCK_ID, sizeof(dpll->clock_id),
>>+			  &dpll->clock_id, 0))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_clock_class(struct sk_buff *msg,
>>+				    const struct dpll_device *dpll)
>>+{
>>+	if (nla_put_s32(msg, DPLLA_CLOCK_CLASS, dpll->clock_class))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_source_pin(struct sk_buff *msg, struct dpll_device *dpll)
>>+{
>>+	u32 source_idx;
>>+	int ret;
>>+
>>+	if (!dpll->ops->source_pin_idx_get)
>>+		return 0;
>>+	ret =3D dpll->ops->source_pin_idx_get(dpll, &source_idx);
>>+	if (ret)
>>+		return ret;
>>+	if (nla_put_u32(msg, DPLLA_SOURCE_PIN_IDX, source_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_lock_status(struct sk_buff *msg, struct
>>dpll_device *dpll)
>>+{
>>+	enum dpll_lock_status s;
>>+	int ret;
>>+
>>+	if (!dpll->ops->lock_status_get)
>>+		return 0;
>>+	ret =3D dpll->ops->lock_status_get(dpll, &s);
>>+	if (ret)
>>+		return ret;
>>+	if (nla_put_s32(msg, DPLLA_LOCK_STATUS, s))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device
>*dpll)
>>+{
>>+	s32 temp;
>>+	int ret;
>>+
>>+	if (!dpll->ops->temp_get)
>>+		return 0;
>>+	ret =3D dpll->ops->temp_get(dpll, &temp);
>>+	if (ret)
>>+		return ret;
>>+	if (nla_put_u32(msg, DPLLA_TEMP, temp))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_idx(struct sk_buff *msg, u32 pin_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_IDX, pin_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_description(struct sk_buff *msg,
>>+					const char *description)
>>+{
>>+	if (nla_put_string(msg, DPLLA_PIN_DESCRIPTION, description))
>
>I don't understand the reason to have these helpers. I said that before,
>just call nla_put_* directly and avoid these unnecessary boilerplate
>unctions.
>

Sure, previously there were some parts reused, rest was for consistency,
I think we can remove all of them in next version.

>
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_parent_idx(struct sk_buff *msg, u32
>>parent_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_PARENT_IDX, parent_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_type(struct sk_buff *msg, const struct dpll_device
>>*dpll,
>>+		      const struct dpll_pin *pin)
>>+{
>>+	enum dpll_pin_type t;
>>+
>>+	if (dpll_pin_type_get(dpll, pin, &t))
>>+		return 0;
>>+
>>+	if (nla_put_s32(msg, DPLLA_PIN_TYPE, t))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					  enum dplla attr,
>>+					  enum dpll_pin_signal_type type)
>>+{
>>+	if (nla_put_s32(msg, attr, type))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					const struct dpll_device *dpll,
>>+					const struct dpll_pin *pin)
>>+{
>>+	enum dpll_pin_signal_type t;
>
>s/t/type/
>

Sure, gonna fix.

>
>>+	int ret;
>>+
>>+	if (dpll_pin_signal_type_get(dpll, pin, &t))
>
>Why don't you propagate the error value?
>

The driver which have not implemented the callback might do it on purpose,
I will fix it by narrowing return 0 here only for missing callback.

>
>>+		return 0;
>>+	ret =3D __dpll_msg_add_pin_signal_type(msg, DPLLA_PIN_SIGNAL_TYPE, t);
>>+	if (ret)
>>+		return ret;
>>+
>>+	if (t =3D=3D DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) {
>>+		u32 freq;
>>+
>>+		if (dpll_pin_custom_freq_get(dpll, pin, &freq))
>>+			return 0;
>>+		if (nla_put_u32(msg, DPLLA_PIN_CUSTOM_FREQ, freq))
>>+			return -EMSGSIZE;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_signal_types_supported(struct sk_buff *msg,
>>+					const struct dpll_device *dpll,
>>+					const struct dpll_pin *pin)
>>+{
>>+	const enum dplla da =3D DPLLA_PIN_SIGNAL_TYPE_SUPPORTED;
>>+	enum dpll_pin_signal_type i;
>>+	bool supported;
>>+
>>+	for (i =3D DPLL_PIN_SIGNAL_TYPE_UNSPEC + 1;
>>+	     i <=3D DPLL_PIN_SIGNAL_TYPE_MAX; i++) {
>>+		if (dpll_pin_signal_type_supported(dpll, pin, i, &supported))
>>+			continue;
>>+		if (supported) {
>>+			int ret =3D __dpll_msg_add_pin_signal_type(msg, da, i);
>>+
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_modes(struct sk_buff *msg,
>>+				   const struct dpll_device *dpll,
>>+				   const struct dpll_pin *pin)
>>+{
>>+	enum dpll_pin_mode i;
>>+	bool active;
>>+
>>+	for (i =3D DPLL_PIN_MODE_UNSPEC + 1; i <=3D DPLL_PIN_MODE_MAX; i++) {
>>+		if (dpll_pin_mode_active(dpll, pin, i, &active))
>>+			return 0;
>>+		if (active)
>>+			if (nla_put_s32(msg, DPLLA_PIN_MODE, i))
>
>Why this is signed?
>

Because enums are signed.

>
>>+				return -EMSGSIZE;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_modes_supported(struct sk_buff *msg,
>>+					     const struct dpll_device *dpll,
>>+					     const struct dpll_pin *pin)
>>+{
>>+	enum dpll_pin_mode i;
>>+	bool supported;
>>+
>>+	for (i =3D DPLL_PIN_MODE_UNSPEC + 1; i <=3D DPLL_PIN_MODE_MAX; i++) {
>>+		if (dpll_pin_mode_supported(dpll, pin, i, &supported))
>>+			return 0;
>>+		if (supported)
>>+			if (nla_put_s32(msg, DPLLA_PIN_MODE_SUPPORTED, i))
>
>Here too. Please check the rest, you should not need to put signed
>values.
>

Enums are signed, don't understand why you want to mix types?

>
>>+				return -EMSGSIZE;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_device
>*dpll,
>>+		      const struct dpll_pin *pin)
>>+{
>>+	u32 prio;
>>+
>>+	if (dpll_pin_prio_get(dpll, pin, &prio))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_PRIO, prio))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct dpll_devic=
e
>>*dpll,
>>+			    const struct dpll_pin *pin)
>>+{
>>+	int netifindex;
>>+
>>+	if (dpll_pin_netifindex_get(dpll, pin, &netifindex))
>>+		return 0;
>>+	if (nla_put_s32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+__dpll_cmd_device_dump_one(struct sk_buff *msg, struct dpll_device *dpll=
)
>>+{
>>+	int ret =3D dpll_msg_add_id(msg, dpll_id(dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(msg, dpll_dev_name(dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_device *dpll,
>>+			struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin *parent =3D NULL;
>>+	int ret;
>>+
>>+	ret =3D dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_description(msg, dpll_pin_description(pin));
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_type(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	parent =3D dpll_pin_parent(pin);
>>+	if (parent) {
>>+		ret =3D dpll_msg_add_pin_parent_idx(msg, dpll_pin_idx(dpll,
>>+								    parent));
>>+		if (ret)
>>+			return ret;
>>+	}
>>+	ret =3D dpll_msg_add_pin_signal_type(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_signal_types_supported(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_modes(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_modes_supported(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_prio(msg, dpll, pin);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_netifindex(msg, dpll, pin);
>>+
>>+	return ret;
>>+}
>>+
>>+static int __dpll_cmd_dump_pins(struct sk_buff *msg, struct dpll_device
>>*dpll)
>>+{
>>+	struct dpll_pin *pin;
>>+	struct nlattr *attr;
>>+	unsigned long i;
>>+	int ret =3D 0;
>>+
>>+	for_each_pin_on_dpll(dpll, pin, i) {
>>+		attr =3D nla_nest_start(msg, DPLLA_PIN);
>>+		if (!attr) {
>>+			ret =3D -EMSGSIZE;
>>+			goto nest_cancel;
>>+		}
>>+		ret =3D __dpll_cmd_pin_dump_one(msg, dpll, pin);
>>+		if (ret)
>>+			goto nest_cancel;
>>+		nla_nest_end(msg, attr);
>>+	}
>>+
>>+	return ret;
>>+
>>+nest_cancel:
>>+	nla_nest_cancel(msg, attr);
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_dump_status(struct sk_buff *msg, struct dpll_device *dpll)
>>+{
>>+	int ret =3D dpll_msg_add_source_pin(msg, dpll);
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_temp(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_lock_status(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_mode(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_modes_supported(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_clock_id(msg, dpll);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_clock_class(msg, dpll);
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>>+		     int dump_filter)
>>+{
>>+	int ret;
>>+
>>+	dpll_lock(dpll);
>>+	ret =3D __dpll_cmd_device_dump_one(msg, dpll);
>>+	if (ret)
>>+		goto out_unlock;
>>+
>>+	if (dump_filter & DPLL_FILTER_STATUS) {
>>+		ret =3D __dpll_cmd_dump_status(msg, dpll);
>>+		if (ret) {
>>+			if (ret !=3D -EMSGSIZE)
>>+				ret =3D -EAGAIN;
>>+			goto out_unlock;
>>+		}
>>+	}
>>+	if (dump_filter & DPLL_FILTER_PINS)
>>+		ret =3D __dpll_cmd_dump_pins(msg, dpll);
>>+	dpll_unlock(dpll);
>>+
>>+	return ret;
>>+out_unlock:
>>+	dpll_unlock(dpll);
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_pin_set_from_nlattr(struct dpll_device *dpll,
>>+			 struct dpll_pin *pin, struct genl_info *info)
>>+{
>>+	enum dpll_pin_signal_type st;
>>+	enum dpll_pin_mode mode;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 prio, freq;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_PIN_SIGNAL_TYPE:
>>+			st =3D nla_get_s32(a);
>>+			ret =3D dpll_pin_signal_type_set(dpll, pin, st);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_CUSTOM_FREQ:
>>+			freq =3D nla_get_u32(a);
>>+			ret =3D dpll_pin_custom_freq_set(dpll, pin, freq);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_MODE:
>>+			mode =3D nla_get_s32(a);
>>+			ret =3D dpll_pin_mode_set(dpll, pin, mode);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_PRIO:
>>+			prio =3D nla_get_u32(a);
>>+			ret =3D dpll_pin_prio_set(dpll, pin, prio);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_pin_set(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct dpll_pin *pin;
>>+	int pin_id;
>>+
>>+	if (!attrs[DPLLA_PIN_IDX])
>>+		return -EINVAL;
>>+	pin_id =3D nla_get_u32(attrs[DPLLA_PIN_IDX]);
>>+	dpll_lock(dpll);
>>+	pin =3D dpll_pin_get_by_idx(dpll, pin_id);
>>+	dpll_unlock(dpll);
>>+	if (!pin)
>>+		return -ENODEV;
>>+	return dpll_pin_set_from_nlattr(dpll, pin, info);
>>+}
>>+
>>+enum dpll_mode dpll_msg_read_mode(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+u32 dpll_msg_read_source_pin_id(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static int
>>+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
>>+{
>>+	enum dpll_mode m;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 source_pin;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_MODE:
>>+			m =3D dpll_msg_read_mode(a);
>>+
>>+			ret =3D dpll_mode_set(dpll, m);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_SOURCE_PIN_IDX:
>>+			source_pin =3D dpll_msg_read_source_pin_id(a);
>>+
>>+			ret =3D dpll_source_idx_set(dpll, source_pin);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_set(struct sk_buff *skb, struct genl_info
>>*info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+
>>+	return dpll_set_from_nlattr(dpll, info);
>>+}
>>+
>>+static int
>>+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>+{
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct dpll_device *dpll;
>>+	struct nlattr *hdr;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh-
>>nlmsg_seq,
>>+			  &dpll_gnl_family, 0, DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	for_each_dpll(dpll, i) {
>>+		ret =3D dpll_device_dump_one(dpll, skb, ctx->dump_filter);
>>+		if (ret)
>>+			break;
>>+	}
>>+
>>+	if (ret)
>>+		genlmsg_cancel(skb, hdr);
>>+	else
>>+		genlmsg_end(skb, hdr);
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_get(struct sk_buff *skb, struct genl_info
>>*info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct sk_buff *msg;
>>+	int dump_filter =3D 0;
>>+	struct nlattr *hdr;
>>+	int ret;
>>+
>>+	if (attrs[DPLLA_FILTER])
>>+		dump_filter =3D nla_get_s32(attrs[DPLLA_FILTER]);
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_gnl_family, 0,
>>+				DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	ret =3D dpll_device_dump_one(dpll, msg, dump_filter);
>>+	if (ret)
>>+		goto out_free_msg;
>>+	genlmsg_end(msg, hdr);
>>+
>>+	return genlmsg_reply(msg, info);
>>+
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+	return ret;
>>+
>>+}
>>+
>>+static int dpll_cmd_device_get_start(struct netlink_callback *cb)
>>+{
>>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct nlattr *attr =3D info->attrs[DPLLA_FILTER];
>>+
>>+	if (attr)
>>+		ctx->dump_filter =3D nla_get_s32(attr);
>>+	else
>>+		ctx->dump_filter =3D 0;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buf=
f
>*skb,
>>+			 struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll_id =3D NULL, *dpll_name =3D NULL;
>>+
>>+	if (!info->attrs[DPLLA_ID] &&
>>+	    !info->attrs[DPLLA_NAME])
>>+		return -EINVAL;
>>+
>>+	if (info->attrs[DPLLA_ID]) {
>>+		u32 id =3D nla_get_u32(info->attrs[DPLLA_ID]);
>>+
>>+		dpll_id =3D dpll_device_get_by_id(id);
>>+		if (!dpll_id)
>>+			return -ENODEV;
>>+		info->user_ptr[0] =3D dpll_id;
>>+	}
>>+	if (info->attrs[DPLLA_NAME]) {
>>+		const char *name =3D nla_data(info->attrs[DPLLA_NAME]);
>>+
>>+		dpll_name =3D dpll_device_get_by_name(name);
>>+		if (!dpll_name)
>>+			return -ENODEV;
>>+
>>+		if (dpll_id && dpll_name !=3D dpll_id)
>>+			return -EINVAL;
>>+		info->user_ptr[0] =3D dpll_name;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static const struct genl_ops dpll_ops[] =3D {
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>>+		.flags  =3D GENL_UNS_ADMIN_PERM,
>>+		.start	=3D dpll_cmd_device_get_start,
>>+		.dumpit	=3D dpll_cmd_device_dump,
>>+		.doit	=3D dpll_cmd_device_get,
>>+		.policy	=3D dpll_cmd_device_get_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_get_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_device_set,
>>+		.policy	=3D dpll_cmd_device_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_set_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_PIN_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_pin_set,
>>+		.policy	=3D dpll_cmd_pin_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_pin_set_policy) - 1,
>>+	},
>>+};
>>+
>>+static struct genl_family dpll_family __ro_after_init =3D {
>>+	.hdrsize	=3D 0,
>
>No need for static.
>

Sorry, don't get it, why it shall be non-static?

>
>>+	.name		=3D DPLL_FAMILY_NAME,
>>+	.version	=3D DPLL_VERSION,
>>+	.ops		=3D dpll_ops,
>>+	.n_ops		=3D ARRAY_SIZE(dpll_ops),
>>+	.mcgrps		=3D dpll_mcgrps,
>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_mcgrps),
>>+	.pre_doit	=3D dpll_pre_doit,
>>+	.parallel_ops   =3D true,
>>+};
>>+
>>+static int dpll_event_device_id(struct sk_buff *msg, struct dpll_device
>>*dpll)
>>+{
>>+	int ret =3D dpll_msg_add_id(msg, dpll_id(dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(msg, dpll_dev_name(dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_event_device_change(struct sk_buff *msg,
>>+				    struct dpll_device *dpll,
>>+				    struct dpll_pin *pin,
>>+				    enum dpll_event_change event)
>>+{
>>+	int ret =3D dpll_msg_add_id(msg, dpll_id(dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D nla_put_s32(msg, DPLLA_CHANGE_TYPE, event);
>>+	if (ret)
>>+		return ret;
>>+	switch (event)	{
>>+	case DPLL_CHANGE_PIN_ADD:
>>+	case DPLL_CHANGE_PIN_SIGNAL_TYPE:
>>+	case DPLL_CHANGE_PIN_MODE:
>>+	case DPLL_CHANGE_PIN_PRIO:
>>+		ret =3D dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/*
>>+ * Generic netlink DPLL event encoding
>>+ */
>>+static int dpll_send_event_create(enum dpll_event event,
>>+				  struct dpll_device *dpll)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_family, 0, event);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D dpll_event_device_id(msg, dpll);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+	genlmsg_end(msg, hdr);
>>+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
>>+
>>+	return 0;
>>+
>>+out_cancel_msg:
>>+	genlmsg_cancel(msg, hdr);
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+
>>+	return ret;
>>+}
>>+
>>+/*
>>+ * Generic netlink DPLL event encoding
>>+ */
>>+static int dpll_send_event_change(struct dpll_device *dpll,
>>+				  struct dpll_pin *pin,
>>+				  enum dpll_event_change event)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_family, 0,
>>DPLL_EVENT_DEVICE_CHANGE);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D dpll_event_device_change(msg, dpll, pin, event);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+	genlmsg_end(msg, hdr);
>>+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
>>+
>>+	return 0;
>>+
>>+out_cancel_msg:
>>+	genlmsg_cancel(msg, hdr);
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_notify_device_create(struct dpll_device *dpll)
>>+{
>>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_CREATE, dpll);
>>+}
>>+
>>+int dpll_notify_device_delete(struct dpll_device *dpll)
>>+{
>>+	return dpll_send_event_create(DPLL_EVENT_DEVICE_DELETE, dpll);
>>+}
>>+
>>+int dpll_device_notify(struct dpll_device *dpll, enum dpll_event_change
>>event)
>>+{
>>+	return dpll_send_event_change(dpll, NULL, event);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_device_notify);
>>+
>>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		    enum dpll_event_change event)
>>+{
>>+	return dpll_send_event_change(dpll, pin, event);
>>+}
>>+EXPORT_SYMBOL_GPL(dpll_pin_notify);
>>+
>>+int __init dpll_netlink_init(void)
>>+{
>>+	return genl_register_family(&dpll_family);
>>+}
>>+
>>+void dpll_netlink_finish(void)
>>+{
>>+	genl_unregister_family(&dpll_family);
>>+}
>>+
>>+void __exit dpll_netlink_fini(void)
>>+{
>>+	dpll_netlink_finish();
>>+}
>>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>>new file mode 100644
>>index 000000000000..8e50b2493027
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_netlink.h
>>@@ -0,0 +1,24 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+/**
>>+ * dpll_notify_device_create - notify that the device has been created
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_notify_device_create(struct dpll_device *dpll);
>>+
>>+
>>+/**
>>+ * dpll_notify_device_delete - notify that the device has been deleted
>>+ * @dpll: registered dpll pointer
>>+ *
>>+ * Return: 0 if succeeds, error code otherwise.
>>+ */
>>+int dpll_notify_device_delete(struct dpll_device *dpll);
>>+
>>+int __init dpll_netlink_init(void);
>>+void dpll_netlink_finish(void);
>>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>>new file mode 100644
>>index 000000000000..fcba46ea1b7b
>>--- /dev/null
>>+++ b/include/linux/dpll.h
>>@@ -0,0 +1,282 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/*
>>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>+ */
>>+
>>+#ifndef __DPLL_H__
>>+#define __DPLL_H__
>>+
>>+#include <uapi/linux/dpll.h>
>>+#include <linux/device.h>
>>+
>>+struct dpll_device;
>>+struct dpll_pin;
>>+
>>+#define PIN_IDX_INVALID		((u32)ULONG_MAX)
>>+
>>+struct dpll_device_ops {
>>+	int (*mode_get)(const struct dpll_device *dpll, enum dpll_mode
>>*mode);
>>+	int (*mode_set)(const struct dpll_device *dpll,
>>+			const enum dpll_mode mode);
>>+	bool (*mode_supported)(const struct dpll_device *dpll,
>>+			       const enum dpll_mode mode);
>>+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
>>+				  u32 *pin_idx);
>>+	int (*lock_status_get)(const struct dpll_device *dpll,
>>+			       enum dpll_lock_status *status);
>>+	int (*temp_get)(const struct dpll_device *dpll, s32 *temp);
>>+};
>>+
>>+struct dpll_pin_ops {
>>+	int (*signal_type_get)(const struct dpll_device *dpll,
>>+			       const struct dpll_pin *pin,
>>+			       enum dpll_pin_signal_type *type);
>>+	int (*signal_type_set)(const struct dpll_device *dpll,
>>+			       const struct dpll_pin *pin,
>>+			       const enum dpll_pin_signal_type type);
>>+	bool (*signal_type_supported)(const struct dpll_device *dpll,
>>+				      const struct dpll_pin *pin,
>>+				      const enum dpll_pin_signal_type type);
>>+	int (*custom_freq_set)(const struct dpll_device *dpll,
>>+			       const struct dpll_pin *pin,
>>+			       const u32 custom_freq);
>>+	int (*custom_freq_get)(const struct dpll_device *dpll,
>>+			       const struct dpll_pin *pin,
>>+			       u32 *custom_freq);
>>+	bool (*mode_active)(const struct dpll_device *dpll,
>>+			     const struct dpll_pin *pin,
>>+			     const enum dpll_pin_mode mode);
>>+	int (*mode_enable)(const struct dpll_device *dpll,
>>+			    const struct dpll_pin *pin,
>>+			    const enum dpll_pin_mode mode);
>>+	bool (*mode_supported)(const struct dpll_device *dpll,
>>+				const struct dpll_pin *pin,
>>+				const enum dpll_pin_mode mode);
>>+	int (*prio_get)(const struct dpll_device *dpll,
>>+			const struct dpll_pin *pin,
>>+			u32 *prio);
>>+	int (*prio_set)(const struct dpll_device *dpll,
>>+			const struct dpll_pin *pin,
>>+			const u32 prio);
>>+	int (*net_if_idx_get)(const struct dpll_device *dpll,
>>+			      const struct dpll_pin *pin,
>>+			      int *net_if_idx);
>>+	int (*select)(const struct dpll_device *dpll,
>>+		      const struct dpll_pin *pin);
>
>Could you please pass extack to all of the ops? I think it is important
>to give the user the meaningfull error message from the start.
>

Sure, will add that.

>
>>+};
>>+
>>+/**
>>+ * dpll_device_alloc - allocate memory for a new dpll_device object
>>+ * @ops: pointer to dpll operations structure
>>+ * @type: type of a dpll being allocated
>>+ * @clock_id: a system unique number for a device
>>+ * @clock_class: quality class of a DPLL clock
>>+ * @dev_driver_idx: index of dpll device on parent device
>>+ * @priv: private data of a registerer
>>+ * @parent: device structure of a module registering dpll device
>>+ *
>>+ * Allocate memory for a new dpll and initialize it with its type, name,
>>+ * callbacks and private data pointer.
>>+ *
>>+ * Name is generated based on: parent driver, type and dev_driver_idx.
>>+ * Finding allocated and registered dpll device is also possible with
>>+ * the: clock_id, type and dev_driver_idx. This way dpll device can be
>>+ * shared by multiple instances of a device driver.
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized dpll - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_device
>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>+		   const u64 clock_id, enum dpll_clock_class clock_class,
>>+		   u8 dev_driver_idx, void *priv, struct device *parent);
>>+
>>+/**
>>+ * dpll_device_unregister - unregister registered dpll
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Unregister the dpll from the subsystem, make it unavailable for
>>netlink
>>+ * API users.
>>+ */
>>+void dpll_device_unregister(struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_device_free - free dpll memory
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Free memory allocated with ``dpll_device_alloc(..)``
>>+ */
>>+void dpll_device_free(struct dpll_device *dpll);
>
>
>Could you please sort the functions? I mean, dpll_device_unregister() in
>currently in the middle of dpll_device_alloc() and dpll_device_free()
>
>Also, there is no dpll_device_register(), that is odd.
>

Sure, will fix it.

>
>>+
>>+/**
>>+ * dpll_priv - get private data
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Obtain private data pointer passed to dpll subsystem when allocating
>>+ * device with ``dpll_device_alloc(..)``
>>+ */
>>+void *dpll_priv(const struct dpll_device *dpll);
>>+
>>+/**
>>+ * dpll_pin_priv - get private data
>>+ * @dpll: pointer to dpll
>>+ *
>>+ * Obtain private pin data pointer passed to dpll subsystem when pin
>>+ * was registered with dpll.
>>+ */
>>+void *dpll_pin_priv(const struct dpll_device *dpll, const struct dpll_pi=
n
>>*pin);
>>+
>>+/**
>>+ * dpll_pin_idx - get pin idx
>>+ * @dpll: pointer to dpll
>>+ * @pin: pointer to a pin
>>+ *
>>+ * Obtain pin index of given pin on given dpll.
>>+ *
>>+ * Return: PIN_IDX_INVALID - if failed to find pin, otherwise pin index
>>+ */
>>+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
>
>You don't use this in driver (and I don't see any need for that). Remove
>from the public header.
>

Sure, will do.

>
>>+
>>+/**
>>+ * dpll_shared_pin_register - share a pin between dpll devices
>>+ * @dpll_pin_owner: a dpll already registered with a pin
>>+ * @dpll: a dpll being registered with a pin
>>+ * @shared_pin_description: identifies pin registered with dpll device
>>+ *	(@dpll_pin_owner) which is now being registered with new dpll (@dpll)
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ *
>>+ * Register a pin already registered with different dpll device.
>>+ * Allow to share a single pin within multiple dpll instances.
>>+ *
>>+ * Returns:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+int
>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>+			 struct dpll_device *dpll,
>>+			 const char *shared_pin_description,
>>+			 struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_alloc - allocate memory for a new dpll_pin object
>>+ * @description: pointer to string description of a pin with max length
>>+ * equal to PIN_DESC_LEN
>>+ * @type: type of allocated pin
>>+ *
>>+ * Allocate memory for a new pin and initialize its resources.
>>+ *
>>+ * Returns:
>>+ * * pointer to initialized pin - success
>>+ * * NULL - memory allocation fail
>>+ */
>>+struct dpll_pin *dpll_pin_alloc(const char *description,
>>+				const enum dpll_pin_type type);
>>+
>>+/**
>>+ * dpll_pin_register - register pin with a dpll device
>>+ * @dpll: pointer to dpll object to register pin with
>>+ * @pin: pointer to allocated pin object being registered with dpll
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops
>>+ *
>>+ * Register previously allocated pin object with a dpll device.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this dpll,
>>+ * * -EBUSY - couldn't allocate id for a pin.
>>+ */
>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		      struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_pin_deregister - deregister pin from a dpll device
>>+ * @dpll: pointer to dpll object to deregister pin from
>>+ * @pin: pointer to allocated pin object being deregistered from dpll
>>+ *
>>+ * Deregister previously registered pin object from a dpll device.
>>+ *
>>+ * Return:
>>+ * * 0 - pin was successfully deregistered from this dpll device,
>>+ * * -ENXIO - given pin was not registered with this dpll device,
>>+ * * -EINVAL - pin pointer is not valid.
>>+ */
>>+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_pin_free - free memory allocated for a pin
>>+ * @pin: pointer to allocated pin object being freed
>>+ *
>>+ * Shared pins must be deregistered from all dpll devices before freeing
>>them,
>>+ * otherwise the memory won't be freed.
>>+ */
>>+void dpll_pin_free(struct dpll_pin *pin);
>>+
>>+/**
>>+ * dpll_muxed_pin_register - register a pin to a muxed-type pin
>>+ * @parent_pin_description: parent pin description as given on it's
>allocation
>>+ * @pin: pointer to allocated pin object being registered with a parent
>>pin
>>+ * @ops: struct with pin ops callbacks
>>+ * @priv: private data pointer passed when calling callback ops*
>>+ *
>>+ * In case of multiplexed pins, allows registring them under a single
>>+ * parent pin.
>>+ *
>>+ * Return:
>>+ * * 0 - if pin was registered with a parent pin,
>>+ * * -ENOMEM - failed to allocate memory,
>>+ * * -EEXIST - pin already registered with this parent pin,
>>+ * * -EBUSY - couldn't assign id for a pin.
>>+ */
>>+int dpll_muxed_pin_register(struct dpll_device *dpll,
>>+			    const char *parent_pin_description,
>>+			    struct dpll_pin *pin,
>>+			    struct dpll_pin_ops *ops, void *priv);
>>+
>>+/**
>>+ * dpll_device_get_by_clock_id - find a dpll by its clock_id, type and
>>index
>>+ * @clock_id: clock_id of dpll, as given by driver on
>>``dpll_device_alloc``
>>+ * @type: type of dpll, as given by driver on ``dpll_device_alloc``
>>+ * @idx: index of dpll, as given by driver on ``dpll_device_alloc``
>>+ *
>>+ * Allows multiple driver instances using one physical DPLL to find
>>+ * and share already registered DPLL device.
>>+ *
>>+ * Return: pointer if device was found, NULL otherwise.
>>+ */
>>+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
>>+						enum dpll_type type, u8 idx);
>>+
>>+/**
>>+ * dpll_device_notify - notify on dpll device change
>>+ * @dpll: dpll device pointer
>>+ * @event: type of change
>>+ *
>>+ * Broadcast event to the netlink multicast registered listeners.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error
>>+ */
>>+int dpll_device_notify(struct dpll_device *dpll, enum dpll_event_change
>>event);
>>+
>>+/**
>>+ * dpll_pin_notify - notify on dpll pin change
>>+ * @dpll: dpll device pointer
>>+ * @pin: dpll pin pointer
>>+ * @event: type of change
>>+ *
>>+ * Broadcast event to the netlink multicast registered listeners.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error
>>+ */
>>+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
>>+		    enum dpll_event_change event);
>
>You don't use this from driver, remove it from the public header.
>

Sure, makes sense.

>
>>+
>>+#endif
>>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>new file mode 100644
>>index 000000000000..b7dbdd814b5c
>>--- /dev/null
>>+++ b/include/uapi/linux/dpll.h
>>@@ -0,0 +1,294 @@
>>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>+#ifndef _UAPI_LINUX_DPLL_H
>>+#define _UAPI_LINUX_DPLL_H
>>+
>>+#define DPLL_NAME_LEN		32
>>+#define DPLL_DESC_LEN		20
>>+#define DPLL_PIN_DESC_LEN	20
>
>I don't see why to limit this. Those strings are read only. See
>DEVLINK_ATTR_BUS_NAME for example.
>

Sure, I think Vadim wanted to take care of it.

>
>>+
>>+/* Adding event notification support elements */
>>+#define DPLL_FAMILY_NAME	"dpll"
>>+#define DPLL_VERSION		0x01
>>+#define DPLL_MONITOR_GROUP_NAME	"monitor"
>>+
>>+#define DPLL_FILTER_PINS	1
>>+#define DPLL_FILTER_STATUS	2
>
>Why again do we need any filtering here?
>

A way to reduce output generated by dump/get requests. Assume the userspace
want to have specific information instead of everything in one packet.
They might be not needed after we introduce separated "get pin" command.

>
>>+
>>+/* dplla - Attributes of dpll generic netlink family
>>+ *
>>+ * @DPLLA_UNSPEC - invalid attribute
>>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH
>size)
>>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum
>dpll_mode)
>>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>
>IDX
>

Sure, will fix.

>
>>+ *	(unsigned int)
>>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>
>Hmm, wouldn't it be better to have it as 1/10 of Celsius degree for
>example?
>

As we are not using it, I don't have any strong opinon on this, but seems
resonable to me, will add a divider into uAPI like:

#define DPLL_TEMP_DIVIDER	10

>
>>+ * @DPLLA_CLOCK_ID - Unique Clock Identifier of dpll (u64)
>>+ * @DPLLA_CLOCK_CLASS - clock quality class of dpll (enum
>dpll_clock_class)
>>+ * @DPLLA_FILTER - filter bitmask for filtering get and dump requests
>>(int,
>>+ *	sum of DPLL_DUMP_FILTER_* defines)
>>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by
>>driver
>>+ *	(char array of PIN_DESC_LEN size)
>>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for
>>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>>+ *	(unsigned int)
>>+ * @DPLLA_PIN_MODE - state of pin's capabilities (enum dpll_pin_mode)
>>+ * @DPLLA_PIN_MODE_SUPPORTED - available pin's capabilities
>>+ *	(enum dpll_pin_mode)
>>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>>+ * @DPLLA_CHANGE_TYPE - type of device change event
>>+ *	(enum dpll_change_type)
>>+ **/
>>+enum dplla {
>>+	DPLLA_UNSPEC,
>>+	DPLLA_ID,
>>+	DPLLA_NAME,
>>+	DPLLA_MODE,
>>+	DPLLA_MODE_SUPPORTED,
>>+	DPLLA_SOURCE_PIN_IDX,
>>+	DPLLA_LOCK_STATUS,
>>+	DPLLA_TEMP,
>>+	DPLLA_CLOCK_ID,
>>+	DPLLA_CLOCK_CLASS,
>>+	DPLLA_FILTER,
>>+	DPLLA_PIN,
>>+	DPLLA_PIN_IDX,
>>+	DPLLA_PIN_DESCRIPTION,
>>+	DPLLA_PIN_TYPE,
>>+	DPLLA_PIN_SIGNAL_TYPE,
>>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>>+	DPLLA_PIN_CUSTOM_FREQ,
>>+	DPLLA_PIN_MODE,
>>+	DPLLA_PIN_MODE_SUPPORTED,
>>+	DPLLA_PIN_PRIO,
>>+	DPLLA_PIN_PARENT_IDX,
>>+	DPLLA_PIN_NETIFINDEX,
>
>I believe we cannot have this right now. The problem is, ifindexes may
>overlay between namespaces. So ifindex without namespace means nothing.
>I don't see how this can work from the dpll side.
>

I am a bit confused, as it seemed we already had an agreement on v4 discuss=
ion
on this. And now again you highligheted it with the same reasoning as
previously. Has anything changed on that matter?

>Lets assign dpll_pin pointer to netdev and expose it over RT netlink in
>a similar way devlink_port is exposed. That should be enough for the
>user to find a dpll instance for given netdev.
>
>It does not have to be part of this set strictly, but I would like to
>have it here, so the full picture could be seen.
>

A "full picture" is getting broken if we would go with another place to kee=
p
the reference between pin and device that produces its signal.

Why don't we add an 'struct device *' argument for dpll_pin_alloc, create
new attribute with dev_name macro similary to the current name of dpll devi=
ce
name, something like: DPLLA_PIN_RCLK_DEVICE (string).
This way any device (not only netdev) would be able to add a pin and point =
to
a device which produces its signal.

>
>
>>+	DPLLA_CHANGE_TYPE,
>>+	__DPLLA_MAX,
>>+};
>>+
>>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>>+
>>+/* dpll_lock_status - DPLL status provides information of device status
>>+ *
>>+ * @DPLL_LOCK_STATUS_UNSPEC - unspecified value
>>+ * @DPLL_LOCK_STATUS_UNLOCKED - dpll was not yet locked to any valid (or
>is in
>>+ *	DPLL_MODE_FREERUN/DPLL_MODE_NCO modes)
>>+ * @DPLL_LOCK_STATUS_CALIBRATING - dpll is trying to lock to a valid
>signal
>>+ * @DPLL_LOCK_STATUS_LOCKED - dpll is locked
>>+ * @DPLL_LOCK_STATUS_HOLDOVER - dpll is in holdover state - lost a valid
>lock
>>+ *	or was forced by DPLL_MODE_HOLDOVER mode)
>>+ **/
>>+enum dpll_lock_status {
>>+	DPLL_LOCK_STATUS_UNSPEC,
>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>+	DPLL_LOCK_STATUS_LOCKED,
>>+	DPLL_LOCK_STATUS_HOLDOVER,
>>+
>>+	__DPLL_LOCK_STATUS_MAX,
>>+};
>>+
>>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>>+
>>+/* dpll_pin_type - signal types
>>+ *
>>+ * @DPLL_PIN_TYPE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_TYPE_MUX - mux type pin, aggregates selectable pins
>>+ * @DPLL_PIN_TYPE_EXT - external source
>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT - ethernet port PHY's recovered clock
>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR - device internal oscillator
>>+ * @DPLL_PIN_TYPE_GNSS - GNSS recovered clock
>>+ **/
>>+enum dpll_pin_type {
>>+	DPLL_PIN_TYPE_UNSPEC,
>>+	DPLL_PIN_TYPE_MUX,
>>+	DPLL_PIN_TYPE_EXT,
>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>+	DPLL_PIN_TYPE_GNSS,
>>+
>>+	__DPLL_PIN_TYPE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_TYPE_MAX (__DPLL_PIN_TYPE_MAX - 1)
>>+
>>+/* dpll_pin_signal_type - signal types
>>+ *
>>+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
>>+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
>
>Why we need to have 1HZ and 10MHZ hardcoded as enums? Why can't we work
>with HZ value directly? For example, supported freq:
>1, 10000000
>or:
>1, 1000
>
>freq set 10000000
>freq set 1
>
>Simple and easy.
>

AFAIR, we wanted to have most commonly used frequencies as enums + custom_f=
req
for some exotic ones (please note that there is also possible 2PPS, which i=
s
0.5 Hz).
This was design decision we already agreed on.
The userspace shall get definite list of comonly used frequencies that can =
be
used with given HW, it clearly enums are good for this.

>
>>+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal, value
>defined
>>+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
>>+ **/
>>+enum dpll_pin_signal_type {
>>+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
>>+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
>>+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
>>+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
>>+
>>+	__DPLL_PIN_SIGNAL_TYPE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
>>+
>>+/* dpll_pin_mode - available pin states
>>+ *
>>+ * @DPLL_PIN_MODE_UNSPEC - unspecified value
>>+ * @DPLL_PIN_MODE_CONNECTED - pin connected
>>+ * @DPLL_PIN_MODE_DISCONNECTED - pin disconnected
>>+ * @DPLL_PIN_MODE_SOURCE - pin used as an input pin
>>+ * @DPLL_PIN_MODE_OUTPUT - pin used as an output pin
>>+ **/
>>+enum dpll_pin_mode {
>>+	DPLL_PIN_MODE_UNSPEC,
>>+	DPLL_PIN_MODE_CONNECTED,
>>+	DPLL_PIN_MODE_DISCONNECTED,
>>+	DPLL_PIN_MODE_SOURCE,
>>+	DPLL_PIN_MODE_OUTPUT,
>
>I don't follow. I see 2 enums:
>CONNECTED/DISCONNECTED
>SOURCE/OUTPUT
>why this is mangled together? How is it supposed to be working. Like a
>bitarray?
>

The userspace shouldn't worry about bits, it recieves a list of attributes.
For current/active mode: DPLLA_PIN_MODE, and for supported modes:
DPLLA_PIN_MODE_SUPPORTED. I.e.

	DPLLA_PIN_IDX			0
	DPLLA_PIN_MODE			1,3
	DPLLA_PIN_MODE_SUPPORTED	1,2,3,4

The reason for existance of both DPLL_PIN_MODE_CONNECTED and
DPLL_PIN_MODE_DISCONNECTED, is that the user must request it somehow,
and bitmask is not a way to go for userspace.


>
>>+
>>+	__DPLL_PIN_MODE_MAX,
>>+};
>>+
>>+#define DPLL_PIN_MODE_MAX (__DPLL_PIN_MODE_MAX - 1)
>>+
>>+/**
>>+ * dpll_event - Events of dpll generic netlink family
>>+ *
>>+ * @DPLL_EVENT_UNSPEC - invalid event type
>>+ * @DPLL_EVENT_DEVICE_CREATE - dpll device created
>>+ * @DPLL_EVENT_DEVICE_DELETE - dpll device deleted
>>+ * @DPLL_EVENT_DEVICE_CHANGE - attribute of dpll device or pin changed
>>+ **/
>>+enum dpll_event {
>>+	DPLL_EVENT_UNSPEC,
>>+	DPLL_EVENT_DEVICE_CREATE,
>>+	DPLL_EVENT_DEVICE_DELETE,
>>+	DPLL_EVENT_DEVICE_CHANGE,
>>+
>>+	__DPLL_EVENT_MAX,
>>+};
>>+
>>+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
>>+
>>+/**
>>+ * dpll_change_type - values of events in case of device change event
>>+ * (DPLL_EVENT_DEVICE_CHANGE)
>>+ *
>>+ * @DPLL_CHANGE_UNSPEC - invalid event type
>>+ * @DPLL_CHANGE_MODE - mode changed
>>+ * @DPLL_CHANGE_LOCK_STATUS - lock status changed
>>+ * @DPLL_CHANGE_SOURCE_PIN - source pin changed,
>
>Why comma at the end? Same to couple of others
>

It's not needed here, will remove it.

>
>>+ * @DPLL_CHANGE_TEMP - temperature changed
>>+ * @DPLL_CHANGE_PIN_ADD - source pin added,
>>+ * @DPLL_CHANGE_PIN_DEL - source pin deleted,
>>+ * @DPLL_CHANGE_PIN_SIGNAL_TYPE pin signal type changed
>>+ * @DPLL_CHANGE_PIN_CUSTOM_FREQ custom frequency changed
>>+ * @DPLL_CHANGE_PIN_MODE - pin state changed
>>+ * @DPLL_CHANGE_PIN_PRIO - pin prio changed
>>+ **/
>>+enum dpll_event_change {
>>+	DPLL_CHANGE_UNSPEC,
>>+	DPLL_CHANGE_MODE,
>>+	DPLL_CHANGE_LOCK_STATUS,
>>+	DPLL_CHANGE_SOURCE_PIN,
>>+	DPLL_CHANGE_TEMP,
>>+	DPLL_CHANGE_PIN_ADD,
>>+	DPLL_CHANGE_PIN_DEL,
>>+	DPLL_CHANGE_PIN_SIGNAL_TYPE,
>>+	DPLL_CHANGE_PIN_CUSTOM_FREQ,
>>+	DPLL_CHANGE_PIN_MODE,
>>+	DPLL_CHANGE_PIN_PRIO,
>>+
>>+	__DPLL_CHANGE_MAX,
>>+};
>>+
>>+#define DPLL_CHANGE_MAX (__DPLL_CHANGE_MAX - 1)
>>+
>>+/**
>>+ * dpll_cmd - Commands supported by the dpll generic netlink family
>>+ *
>>+ * @DPLL_CMD_UNSPEC - invalid message type
>>+ * @DPLL_CMD_DEVICE_GET - Get list of dpll devices (dump) or attributes
>of
>>+ *	single dpll device and it's pins
>>+ * @DPLL_CMD_DEVICE_SET - Set attributes for a dpll
>>+ * @DPLL_CMD_PIN_SET - Set attributes for a pin
>>+ **/
>>+enum dpll_cmd {
>>+	DPLL_CMD_UNSPEC,
>>+	DPLL_CMD_DEVICE_GET,
>>+	DPLL_CMD_DEVICE_SET,
>>+	DPLL_CMD_PIN_SET,
>
>Have pin get to get list of pins, then you can have 1:1 mapping to
>events and loose the enum dpll_event_change. This is the usual way to do
>stuff. Events have the same cmd and message format as get.
>

Sure, will do.

>
>>+
>>+	__DPLL_CMD_MAX,
>>+};
>>+
>>+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>>+
>>+/**
>>+ * dpll_mode - Working-modes a dpll can support. Modes differentiate how
>>+ * dpll selects one of its sources to syntonize with a source.
>>+ *
>>+ * @DPLL_MODE_UNSPEC - invalid
>>+ * @DPLL_MODE_MANUAL - source can be only selected by sending a request
>to dpll
>>+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto selected by
>dpll
>>+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
>>+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover available
>>+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled Oscillator
>
>Why does the user care which oscilator is run internally. It's freerun,
>isn't it? If you want to expose oscilator type, you should do it
>elsewhere.
>

In NCO user might change frequency of an output, in freerun cannot.

>
>>+ **/
>>+enum dpll_mode {
>>+	DPLL_MODE_UNSPEC,
>>+	DPLL_MODE_MANUAL,
>>+	DPLL_MODE_AUTOMATIC,
>>+	DPLL_MODE_HOLDOVER,
>>+	DPLL_MODE_FREERUN,
>>+	DPLL_MODE_NCO,
>>+
>>+	__DPLL_MODE_MAX,
>>+};
>>+
>>+#define DPLL_MODE_MAX (__DPLL_MODE_MAX - 1)
>>+
>>+/**
>>+ * dpll_clock_class - enumerate quality class of a DPLL clock as
>specified in
>>+ * Recommendation ITU-T G.8273.2/Y.1368.2.
>>+ */
>>+enum dpll_clock_class {
>>+	DPLL_CLOCK_CLASS_UNSPEC,
>>+	DPLL_CLOCK_CLASS_A,
>>+	DPLL_CLOCK_CLASS_B,
>>+	DPLL_CLOCK_CLASS_C,
>>+
>>+	__DPLL_CLOCK_CLASS_MAX,
>>+};
>>+
>>+#define DPLL_CLOCK_CLASS_MAX (__DPLL_CLOCK_CLASS_MAX - 1)
>>+
>>+/**
>>+ * enum dpll_type - type of dpll, integer value of enum is embedded into
>>+ * name of DPLL device (DPLLA_NAME)
>
>Yeah, I really cannot understand why you think for a second that
>embedding an enum value into a name makes sense in this world :O
>

Probably was to lazy to add new attribute instead :)
Will add new attribute for it.


Thanks,
Arkadiusz

>
>>+ *
>>+ * @DPLL_TYPE_UNSPEC - unspecified
>>+ * @DPLL_TYPE_PPS - dpll produces Pulse-Per-Second signal
>>+ * @DPLL_TYPE_EEC - dpll drives the Ethernet Equipment Clock
>>+ */
>>+enum dpll_type {
>>+	DPLL_TYPE_UNSPEC,
>>+	DPLL_TYPE_PPS,
>>+	DPLL_TYPE_EEC,
>>+
>>+	__DPLL_TYPE_MAX
>>+};
>>+#define DPLL_TYPE_MAX	(__DPLL_TYPE_MAX - 1)
>>+
>>+#endif /* _UAPI_LINUX_DPLL_H */
>>--
>>2.30.2
>>
