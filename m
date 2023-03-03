Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01356A9CEF
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCCRO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCCRO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:14:27 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A4514EB6;
        Fri,  3 Mar 2023 09:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677863666; x=1709399666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VR/h3vjsfaf6v1+ckmiCB/GRmboAExD8IxK9/vNU5yQ=;
  b=c99VUzBFy0yOJODFZ/Y8wyppe3FysyxQzEd45avKOBMGvOleIgM5d4d5
   kBMs2pA1ZZKD2u2Ehg0c5fKgGR3xAQL5vp+dQCrop3gOdEUA/DeNsHTAy
   KNYMq8J8ZRJAUkUn6ZzInQTVzF5DLE3CXv7RAjqTZhArjWBkdEn/fTQ47
   fJ3h2ZuJ2ZvZikpEs2sburZtXG2Gut/CQOHDb/jJwD7H3LvytVCNBiTFT
   hKsYtwgwE92xL5juiN2i23KW8wSgCDpDsF402vXqdsJfP53CeadLkYR5Y
   VTUEnTZ4fe7vvx14Q5LPLRQpC33TZqLrIi9SOMD6vvBwGbAsg45TZtZin
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="337412852"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="337412852"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:14:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="818540560"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="818540560"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 03 Mar 2023 09:14:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:14:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 09:14:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 09:14:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXXfmeMkeNtP8OkCZcxYtWtcTWPqzDd/yy3UOy1rgDdDm0HIfB2O6+b8oDSabX9L8B/Fp94q2dboR9wgn9cL2s8Jms3FsbOvufoSGVOYrP5Yb7hz8FBcbiuiwn3QvhiFU/LSkNgQ8fN6kJ3aG3ix08NRFXilMXAskoQnbPh0WCFFaIi6DZ9SDH14RacsQYX76oARsBReeB39OreqJfBZEiUhBiiOzyzQfespxzPl/r1Jr3Cn4wNBXAIY/u+K8S2xHj8dL7uVS5ouMlNsY0gAp3ujR/oinxhhI5Kars7Ql2ROjjVWIU6IboNtNNyhV59pgN6dZhEmGQzVjuv8YBUgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j21YVPFpb2Ux8rJNs+LnRYyHovs54RsAGrmI9WGdoZw=;
 b=ibN6JA0r+TXNq2zogwofMZn7i8AO9Kz1jL/z95vSbFrfV72tpfFF5cdQ+vAu4Rskq6Ry/MdZsV6Mv9cvyYy7fDjSYcbOS5qPigFUm18G8Fz5qlB9pnpxKlsT4PDY/+S/9zGzqZ6IZ1gZAXb5D/OdHLtGrkmJsNdQW+ryKG12aRBrsNoJlC6/p/6aKilQgkRXPQ2EGGQsc8VMAoIlSXEUhhZfnvHUF6V9ae3jFLbm4nRQDon2DXURK/M951H6ePl/Gg8Y++KvZNAjKaBJQWDayDrIR9DOxXjc1gRHupo49CJuDINE7tldBuJDh8xNcGfcZIZ3hwc6gLF/t11Pvxt+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by CH0PR11MB8086.namprd11.prod.outlook.com (2603:10b6:610:190::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 17:14:17 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:14:17 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 8/8] i40e: add support for
 XDP multi-buffer Rx
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 8/8] i40e: add support
 for XDP multi-buffer Rx
Thread-Index: AQHZQwoHdZvQdoq5xEKyxGAb5lYX7a7pX+5w
Date:   Fri, 3 Mar 2023 17:14:16 +0000
Message-ID: <MN2PR11MB40452D36C68C6F20D9925AA6EAB39@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-9-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-9-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|CH0PR11MB8086:EE_
x-ms-office365-filtering-correlation-id: 2a3f499b-a0de-4d82-7a14-08db1c0ab833
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYp/PhOf/FZodm9UPRkxFcV+liA/nVsXv7IhOLULYneO14HZoIDN22rLAIdSFCZvLBgieHravhvQEUJTFYfw1LxeETJSCQzYvc9qQBiFCvj/mBBJK8dSMg8wWIgfSHm3aJ5JuJnxU/JJavLQCBgX1hdUjQCiuwdBDdzHD/yv5xZVBDs8hDaVtJg0KNgEvDLoBUcjEu+IdgJk283MVetMq13z3K77apBiCG3kLF0qfmIFY3XbyWfr9AM0/ZDo3j2fsvAdAUPMg7QvroURrwaOzGm54CZX8mPt0MtMrTUEXIGD1VFRY8Jh3TPZEuBRBlZh04vlXr7SsqQnOBl5CGwHuC4JQoQaW6/EKh+1OgOkUAXYKUONCgnOFv1EZM2zt3t9jV3E5y89fdXNDV3LRHUCds0x8dtwbt+kShkKfInRb404/5P2sp8weGJOz+4Im/K9mmq/8uyLgZINV4D2xJdLLZsm+CTUp5eiQMRUSSfCXYBEEvsFpCF8ngpGxVmkSxOz67a5xkOd931CX8tmCikaHPxYPVSuHaK76NbkvxoYZIBQg3Uz6a9HP9P82tm9vsLXZ7dK049JeNH+eIrQRkWbFdslJ4EVkRbELB5ZV1Zfzm6Q1yLXSmz7fjffDdByhbadoVsjfZdKaikucHYYzgPoi/n/4nnEfrjFC58UEmCuEKxd1t5yYX8QIvf9JRCWrrykwY2csKQfJ5thRF3NzFtdNUR9yy6cwtuTl5761jhsoiw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199018)(52536014)(8936002)(7696005)(71200400001)(6506007)(107886003)(26005)(9686003)(55236004)(186003)(478600001)(54906003)(83380400001)(110136005)(41300700001)(316002)(66446008)(4326008)(64756008)(38070700005)(33656002)(8676002)(55016003)(66556008)(66476007)(76116006)(66946007)(38100700002)(122000001)(86362001)(82960400001)(5660300002)(2906002)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1JLqL00nSyeOY908Ta3fkeGQL9Kp6s3WPtSyu8SnvGZ5yd9tX5QMuEdvGPVl?=
 =?us-ascii?Q?IgDEJ+Ri2Ps0DJC5z4/ZU7GE47PhIMjyWoAyVz1WFKu6SdVooGBPY7pSwdSX?=
 =?us-ascii?Q?WOfa9NDLMM+HMS6eAFlMkU+FlabAnWHTT4ybkFEQdlRt2TszJhliaq2RGoVa?=
 =?us-ascii?Q?SZIRsHceMvkRZ9RycscM2rQwL0PtOU1LtGV+aOXogBJMjwxQKaSH7k3e3OGk?=
 =?us-ascii?Q?mF6UTdk7L7GRHoPrPay7LT1XIp7NtAFKcFqjZmqTndadUDei2uZJsOBOQnhx?=
 =?us-ascii?Q?+cghXWCdJ8QpjZkps3Vm82PWqZomW+DIHUCsLzLZy5BrzQG+AJsE77UveyLQ?=
 =?us-ascii?Q?cPb4594OFufCHNQnaKR6XFlK6TnsGM35g7glYKEM1/j1JOllyXN1YG7Nh/Rm?=
 =?us-ascii?Q?YkI8nmj/QRQQzBNhJ48x57MCSHDwijIeRaR0Eexxf5J2+DC4Yz+I2wbn4mNX?=
 =?us-ascii?Q?SC9DS6fWdnOl70Z4o+xe1I2x0FGqALS+Biok4Ce2HrN3BOt93wwJRBaLNGaU?=
 =?us-ascii?Q?0rert+KozC/BfOQKvNAb1BkzPQ5FrAp87eu0KOvYJ6sS6OhlogSmypFgLqRn?=
 =?us-ascii?Q?EMDhDIt2jULytsmtllKN7nCKMNpb6JJEtpaRFy3b4xLRCAWv0R95kirOrKka?=
 =?us-ascii?Q?UIkq3H5jREOxh3+OkjTe3XfNeQVSBBPkK2kV35lK3n6slQMksc0EalbVm/cD?=
 =?us-ascii?Q?aGnRasDllfpsV01H5dD7hKNzWQZoL91Q+mZXWOAdO2JEqaMEoABndjpPLIbA?=
 =?us-ascii?Q?kvjwKTE6Hjs7OPp9ds1/4nKP/8MOyqCQ+vChfTqkbQB0UiLA617Oo+gPytfo?=
 =?us-ascii?Q?qaJONquaLplFfZY8iddjO720oRNb/sHgPbz19Kz64+lrFp/vvxXDxq9OwuVA?=
 =?us-ascii?Q?hBYS3IZ7AFaEt1x9sFz7sE03n/I/DgX4jcZedrnFFjLiZn6GKEtKolgwAvQ/?=
 =?us-ascii?Q?3EAUOYgV9E8bGHd1/1k2ucMKEDA0g5Kr9RZXKRvzbWT9EOMR7AT7mKpCEp3G?=
 =?us-ascii?Q?DAD+4cSMhfdXTjT02XKfb7iLwjbdOET9KA0OD0bW44c+tpqqYsDjyOQ5ZZS/?=
 =?us-ascii?Q?lKX36ekXqyW1i/18rc42d3g3MldV6ppuiLKFK9lBDxfOs6wZSTvHzZ3Jr64t?=
 =?us-ascii?Q?LZMQZttkk9cZ8YrCYZzi2TYnyXAN/FbWWEm/nRbgnwDFXuLehaD9k2hGB+Xs?=
 =?us-ascii?Q?EEda7BcYZgpeXT5EhvUy1rFBzuIc2jLJLOkVjvfKf/LJFGJ5rdqg81TXn61n?=
 =?us-ascii?Q?tKbEz2ZiQtfUVXX7/BF08YFhMofmhpWamdNbF3acHHwf0AXjHjyHiRThhzPt?=
 =?us-ascii?Q?OWkuEwG4ecmpBp8ocV1D+AGhKLDvKuB4wt9N4HF/7I+DVPCjeKi817sHCfLL?=
 =?us-ascii?Q?M2mLp4T4UQ8lHIITZp/OMa/x7RbiAvUxE5ufijxYdoDEE0SCqjkYQw0QamlX?=
 =?us-ascii?Q?av2oRK/KpKY6K78kCSkBxMhGBkjhXD/SMFLdQadR+AAjUdjdmQq9w49xbnBB?=
 =?us-ascii?Q?7Towg0ArN3txyNgAjSX1XbogtLOldDvggXn3hKk+a+xvLV0ZmWmxcU3PysjS?=
 =?us-ascii?Q?Ix0iZKDxAYQ9HKH8idMjwetVroZPmk9Rn+u8xV1H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3f499b-a0de-4d82-7a14-08db1c0ab833
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 17:14:16.8376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QuMrIkM5EnqXeL2TT9XLUUDjKCTaToMTTh5ZbjLTA25YAiLMNrZxLq8DdhmxrrdEcDaaboKYI3tB2125SoQzjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Sarkar, Tirthendu
>Sent: 18 February 2023 00:45
>To: intel-wired-lan@lists.osuosl.org
>Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; netdev@vger.kernel.org=
;
>Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; bpf@vger.kernel.org; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-next v6 8/8] i40e: add support for=
 XDP
>multi-buffer Rx
>
>This patch adds multi-buffer support for the i40e_driver.
>
>i40e_clean_rx_irq() is modified to collate all the buffers of a packet bef=
ore
>calling the XDP program. xdp_buff is built for the first frag of the packe=
t and
>subsequent frags are added to it. 'next_to_process' is incremented for all
>non-EOP frags while 'next_to_clean' stays at the first descriptor of the p=
acket.
>XDP program is called only on receiving EOP frag.
>
>New functions are added for adding frags to xdp_buff and for post processi=
ng
>of the buffers once the xdp prog has run. For XDP_PASS this results in a s=
kb
>with multiple fragments.
>
>i40e_build_skb() builds the skb around xdp buffer that already contains fr=
ags
>data. So i40e_add_rx_frag() helper function is now removed. Since fields
>before 'dataref' in skb_shared_info are cleared during napi_skb_build(),
>xdp_update_skb_shared_info() is called to set those.
>
>For i40e_construct_skb(), all the frags data needs to be copied from
>xdp_buffer's shared_skb_info to newly constructed skb's shared_skb_info.
>
>This also means 'skb' does not need to be preserved across i40e_napi_poll(=
)
>calls and hence is removed from i40e_ring structure.
>
>Previously i40e_alloc_rx_buffers() was called for every 32 cleaned buffers=
. For
>multi-buffers this may not be optimal as there may be more cleaned buffers
>in each i40e_clean_rx_irq() call. So this is now called when at least half=
 of the
>ring size has been cleaned.
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c |   7 +-
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 316 +++++++++++++-------
> drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
> 3 files changed, 212 insertions(+), 119 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
