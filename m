Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9A6D41E4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjDCKXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjDCKXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:23:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E73212C;
        Mon,  3 Apr 2023 03:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680517392; x=1712053392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UWRsVWrwRtw7Uwl9yzyN5vlsMalF+EArBz9f6skr2Xc=;
  b=KWWpzUmLfI9NWgt21Y2ZA5GNapargOvIEaMoRGHHIpHgvhfw/s6Hq2we
   4Tz9xcrncmF4qUH6kB4Lj088hwNGMu939E84NmQobu+pt5tqfL6MtZ7w/
   yVIOfc184sLdUA+Qr2VRlEhY+unp1G24fRmOQe+27Gkp4TQy3MoBGxhkO
   44+ohfsQRvGyiax6VddKdy+qccrlFNuX9Ey21jgbVMVc9frqDurhiBxKw
   YT+m86e7mte0lEYw8MX7izBFQt3Hf2Z5IrDGr3N6vfPAKK9ZSzCdwAZp7
   Zs8swnvuiwx8OHlWNY8shd3fyCKXOv/9XFNxbzGUyyPYJk/OuY3DWoMTM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="344412099"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="344412099"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 03:23:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="685912684"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="685912684"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2023 03:23:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 03:23:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 03:23:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 03:23:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 03:23:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWkVvDSktjHFT0TZ8yXCogkn9YvM+wIi/mWIIeyi20mCd8X302s7YBiLFghfKHdvVhDXMEj4hN67HaoNwRKcb9qQRDb9dyLrSQRbL/VO+bTOE4g44l7dinlSSiDGBPFDwFvSxPxcGdVr67EgffBH6gWP2IGN/8GVf+hpuOj+ZBoyFdZB25XTVxXBxPdQh0DC/NoxS9o3hCrCCCGZmspj/GvnZCoL4Xr3e4JBWryIHH7JHXw29yz4OoLB/m06goPifSYLMbsRamH+QXC+41mjv0gvKztJPlKdhYYTSuxwpDv6XkwPCZVYO0LBrHUzdCiRrmD3HgVElLQN0Fu0xTpRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yluRbXfIuFZDSA988KJi3HKVXpCuh52G1QrPNxJydGM=;
 b=UGdPgfeuxD0oKKtZC6p12ErgUpFeZs4a6PvBH/HSBGJJ/oMg8f78kb7cH+rcGhiDC8tvhmoCOZPrIxEhJ3jMR8wAnu6Fszen0sSfsJXKUKDpix/E310TugFCU+PcPOOLihtfP9IWHO9nWpnHFIV6FcxZcZDHa1UwGV/Xei/usCHl2FYJwxzuckeQV/55kLUveoa520eXUE8KtrZqMOjwFYiLRZgQkch5plqoTPC7bB94ZpxJWi65MDCKMXazspVy/rGlUZLeGUI/cvfkUUL2gqNeyZCg9scKdGIKSnZlYUZGHRbZZiyKrJ/iUj8pKsu1oD04WRoPXXm4OE9or6jakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7963.namprd11.prod.outlook.com (2603:10b6:510:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:23:08 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 10:23:02 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZVIpnHLcQhYk8TUaWsBJuqa19SK79clSAgBwQrCA=
Date:   Mon, 3 Apr 2023 10:23:02 +0000
Message-ID: <DM6PR11MB465703F6902C601B186B74C59B929@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-4-vadfed@meta.com> <ZBMdszEWZNN2VFz1@nanopsycho>
In-Reply-To: <ZBMdszEWZNN2VFz1@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7963:EE_
x-ms-office365-filtering-correlation-id: 219fcff1-b0e7-4a14-a37e-08db342d67eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ioAeD6eUETMERiLHdVoQLz73RJs8pkqZtiRXeTvfyWHwr8otlpsyk6WmonMZM9zQjnNnpAUC74xBxa8R6xlo0sIg+SQnWP9eGpeapscmep3YZHIpEOEXoKHKg4Tsj7e9Mc7v6t+wjTyfD6Ovqr5u4wZQ9Vxg/85VidiKrVtTYf5CH1C9xsYLqVQ1yczwdzjy5bcJihgLDNeQHDR4RM461F/JGHN5kZxXa/J3r60NbEJDIhPY4I7vaLPGTmh2GzRGxFnI9wwnIloqB86QPGyd/A4r6zHlJGTkStxSpR390LeiHtNDZJkRyFfS4rwct6Qfc//3y2e3BMXcoxdz1s4NmEEoGDxezMwEed+fea8/zaxsx5swBVWrXTEKiEBWS2yXcdiXZ9AN7E5fliHTWV9Dsi+QUJeCIsaII9jrVLSMt7A69oEq+ne3FOHBclv0H06MXS+wVLneBLg3UyhNyfbudMFqbvqGHcdgsM+15yCtVvm/PxPSrMtBVud0Smq/uh4vJqATXrALdhO95CS+7l946LjjceetRiJrqZ/xIEhUN3vKWAc50ggBqy4igiaPp+Ig9n2JExAW9J1jagPQKBGKrGaWryNouqmOZ2miRCTJ+dU9vje5m1tzUP7yatM7I+mC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(55016003)(4326008)(76116006)(8676002)(66946007)(66476007)(66446008)(64756008)(66556008)(478600001)(41300700001)(110136005)(316002)(54906003)(8936002)(4744005)(7416002)(5660300002)(122000001)(82960400001)(38100700002)(52536014)(186003)(7696005)(71200400001)(9686003)(6506007)(26005)(86362001)(33656002)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f8B4h0U4aTEhgQbqKTrFfPgpch8ylfbnPLqUluoWcbQkswozyYCPf1CHLA0T?=
 =?us-ascii?Q?4pemVmTuOOGQAybTWBGVnzAihfNALLW3m4fOKIKuF80nFjb2LNoPRlDrO6U1?=
 =?us-ascii?Q?lM4I0fU/21V9ymUyMLplMJzvy4mUY0hFJZSPlZ6b0MRKhIEvrh4K/WOrS4o3?=
 =?us-ascii?Q?hKTnrM0cctpElC2hnvFy/XACEs4yqmM02w4sHlHrXQsPQbsB57QqU9KTkoHm?=
 =?us-ascii?Q?dcR+KxPqmVuh6L0KY43oV7p26HfvlXslrmR1FZX0Mv58m8dsGg+LcE6/lHJD?=
 =?us-ascii?Q?2N3qX84rNVMcKYrvPuJdF+e3XdPRf9XwyveKpeTh9Jj01TKoMh0tz3bp4X4x?=
 =?us-ascii?Q?EeqDFlfg7XRAnYT4FbIEnIcY2hIxXHVZfVJiKlEprfiAdtF6bzPH/c2CLu9u?=
 =?us-ascii?Q?tHig4dYuDNEL9dnyA0F1aqRfgHQAJyp0chfKDLy2l0s/uuT0BMUQp26yr9a7?=
 =?us-ascii?Q?6QoVn0TYoiL6Owwfyi6J9LEeoznrpIbSm6R6yOM3guLfHiVXeoENitXDwIPh?=
 =?us-ascii?Q?/9wipGd1oUE9oEbKBZXIKVIFtcJtjBTxrxYnLdLuzvsIcTOtMTAzjIbv3YNI?=
 =?us-ascii?Q?jnZidp+bl9HvXw7uAMfk/iCNQoEjwhnWtVyre32iAIozULI/XzAVjTpO/Gcb?=
 =?us-ascii?Q?fbX6FG0OcBXTzBsGM0mKvTgI/u/VCm/9c0T+xB9YZ1rpXb2oFHfDVXF9Lpvi?=
 =?us-ascii?Q?3WJvvpc7We0TWiyOGvDfqmcpqvDCSl8Ya/03doTfRq1UbA1l6ioJStk+Wlgr?=
 =?us-ascii?Q?80p6SyKFDsTdLkOMfARyBGhCXLdH+aCF3uBT8CF5PY7QlWNtbM46H6oseS71?=
 =?us-ascii?Q?ugxCsCh5dR6Ae+iZNRNf83gQTTJ89pFCjRJ35QFizwBIxiRh1gdQ6d9rJxaw?=
 =?us-ascii?Q?IlPkGmgm9gRCeXoYNOB8AAHNRy5LIh3s7F3TuLzn5EuDlplEU/VD+9hVuq86?=
 =?us-ascii?Q?Po1JVyV8OwOOivkWbqfHTYNwbpRgEe0yrEtKGi74fZlutkFxtBHIQdGlUo9V?=
 =?us-ascii?Q?MVRn3BYKf2jlqHfoTKlH9cpMBIbV01SfNILqsIVl2i79+Iwo0vguUV+t1BSZ?=
 =?us-ascii?Q?mt05JSrV2bpqAAHgUp7/7GGAbdwEQYSvDntvcx4DWIvFplkbWdgqedRQxfD1?=
 =?us-ascii?Q?Kn2jPlM5Ek5BM3ALtlKAxqTx3kkDRzYTdIdOIWRrMdaJndhKNzNEkoOKrbyj?=
 =?us-ascii?Q?PjygbAMNrp3QsLNesDNGBZMgZjiEvOo1KhJ9OEgOIdxdGbqDpd8QwPeud1m5?=
 =?us-ascii?Q?KSvTwrvuWOviVPWTq01hk1kfp53NFdlPVSa66V3sSvK2/2i8DlK1WTCP6Fgk?=
 =?us-ascii?Q?DcFP8pJu16FN1u2SSv3AM19jc9x3ctTG1xv0xVvC6a8NnvbxSyq1DBvSBoSx?=
 =?us-ascii?Q?ELWuWwcp6BMFc7T1pOvMLH+zEMB33eJ2h0Jwwk+zl5SIm1zd9J0/YRuNLf1D?=
 =?us-ascii?Q?FdcVA37/VQpNhKRyvkqBBl++1Eul5R0NvTgfqvJoeKRJefAi20GQuSl2pOi4?=
 =?us-ascii?Q?hYM7rkMidvun5ppVyB/vvE+IKrwW4th/PPgbF15cPZ2TIvUl0UAMtTmpTxcM?=
 =?us-ascii?Q?4mIVYgq26cadbcX7Cj58lrDrRGQ+1AuzHo1f/gG4LlFICeQaI5mUunbbkZsq?=
 =?us-ascii?Q?uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219fcff1-b0e7-4a14-a37e-08db342d67eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 10:23:02.4173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wG0OFSuxJsCm3l+4GJdfknMVfSS/IxGU1R4TnUBmQr7zemVEX7BUQzo/5uIk3wP2oKgYpqFXi7+HK+L4JCqEGHGJsHEY45HTSTRrpS3SgVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, March 16, 2023 2:46 PM
>
>Sun, Mar 12, 2023 at 03:28:04AM CET, vadfed@meta.com wrote:
>
>[...]
>
>
>> Documentation/networking/dpll.rst  | 347 +++++++++++++++++++++++++++++
>
>Why this is under networking? It is not networking. Please move, probably
>directly under "Documentation"
>
>[...]

Fixed, now in Documentation/dpll.rst

Thank you,
Arkadiusz
