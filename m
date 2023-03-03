Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2EA6A9CC7
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjCCRIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCCRIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:08:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856E0EFBA;
        Fri,  3 Mar 2023 09:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677863329; x=1709399329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5qpgEcmtFtXm8BaLCl9zUN6D9lhYvYLjbX4h3Suafb8=;
  b=QFtvdvUpGlnSSCOWJdpNvpL1+Pe6neqLpHrWArkTufwtka4UK9t1Vt75
   clFFKSo5HPH3WabgSLiQnyVau4qh4ZZ1WP6fphJxdBzK80VrtibWICIoJ
   mJTQ/+4JESsUDRuIqlqj4Oen4ToPEgng5o+oyFQNWBBpvUJwgZ2vr2Ouh
   J8IJwOLxjkp84Ycgnz9rccfpHsHTyPkYv+zHS5lxx5eP8VEA1YyGT+RP3
   kg7N+uOAsxF26A1Rc6QXu16sKhTREAv+lEn+pSLZHh0IocE81eYmnf72d
   4kZcIUmlA0sB4NIpMyT44/xSPxLG7TMzsz/iXPsqDsfoRLyzh0AadNPAL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="314752204"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="314752204"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:08:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="1004638895"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="1004638895"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 03 Mar 2023 09:08:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:08:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 09:08:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 09:08:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cumDtXVak2opQYG3T2WsPMkLUU5+3adUOUFfe3qezvlxp6m2lCs65tbGxv7Ue8ALNzooHzR2EPixt7n3bx7B74iIFE4XeTypFeJ+MNTkd1hk5VLEfRMvPI6h0BbajkTKiEVdSS+I6vn7lFpXtrwrX+UEqjeBpxqrP9PB7XaQb/kpohxNkGnDxyhV0/jrBJYiweuiv/4Q7PXb8LMRkwNVUPlg5ZGkRcF+ZvHenMWus8K8iXvZJ2+0+wcQrZN/tvu6VVGBHpXVqf6JH0HwQKLY4fFocN7WtzS6zQxE+Z19iGQtdubeqGK0nnvrR3umiribSL4Yl5PHL0lb8VLXaEwX6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/L1wnE6CXy264Wa07/Aw8gvMUwh7gMTqHTbD73AxDs=;
 b=aaOQjz7VQiu3NpNrTyOuoClqdBPfgVzGFvIcMc0VNfFftLd3MP4GpFxty2bpKU8B0+xuz1IRSKLk2Av4ZACPfwVpXJmJ2w7rUqEO2S64KySKi7ryv3ECp2/GopGg6tsslZlFFe0nRU7p59qUMa4e5PJCfh/Ya/HzU3g/a8uu+1WG4bO2DwG4erWMuzSn8tKRHR6ZElrfHW7eJ/VWNhKoXRkCz2Fx4vB/9UUWi+F2CwVyTABBX96MSDlOUfxFBQLkitV0BOcY0gu6+GStRXRet3YYQBrX+z3KZvX+xLAREFQkuXcZTjvfQjQDilIJJiRMyF7tSrfsGQlyWAjrX5G4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by SA0PR11MB7158.namprd11.prod.outlook.com (2603:10b6:806:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 17:08:46 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:08:46 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 7/8] i40e: add xdp_buff to
 i40e_ring struct
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 7/8] i40e: add xdp_buff
 to i40e_ring struct
Thread-Index: AQHZQwn0CWS9crRYjUasLgH5ANaJP67pXdrA
Date:   Fri, 3 Mar 2023 17:08:46 +0000
Message-ID: <MN2PR11MB4045771DF76F2D5A36067559EAB39@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-8-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-8-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|SA0PR11MB7158:EE_
x-ms-office365-filtering-correlation-id: 42de24f0-c196-4d8e-c2c6-08db1c09f330
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PnOZxYiCBHGGak8JUtESPzTr4RfDBcC9Kz641CG+dd4zTX4a4ldVUCa3FABqU4udattbtrUKfjG8/DkIvRQws+BiIkhoQy8uFozzBFmFs35A4hvSpcERwIvwGm6u/yQ9GI6laupy/facLikCNisQgBtkfNAhvcH+zKQBiGcKaBpiOYt67kIR+BWUqTevgjmYg5ABYWrIcCttG0o7PAdVBpiDuclSeVybfV+mZ8yHor6thAx18bTwHCYtcADUqAn4BAeuLUL0C6q2BpSaZcBHD2BYacCgQW5PRE8DLCk22aONQQUk4qpMzY1l+tpXtkvgYuB+g4qyri3dHTuQZQCWw7Tx9U0Vz6I+gcLW27TIWjS9aa/yaoXNqdIRlrymhmeleCl0NHLWyCm+013tPMf9UjqPoj4ZNVhmz8dghO+wvoLrbxiWohu3yx3nMrtV3rTiQpN5Q8UMKD5pMd+BGhE7+8KtmdtAW3AJkNaK8HIEqM9rFJKkt+nErF7M294vvc+hE2yYYANX12qca+yKQckdecHWYKYcQT+rKGGAzNJk4GbcA0MR5psgFNa1A8M1T/i9QUMzA16qG2K8d6vI/zPbaGIRRU/PPb0Ap/37vDHbXJ6lrgGnGHpsnkKhEjMX7SsWNWuAh7O4qgKjW91atHNgRMOI7RIU2dkW63pgQC/NuBDQm2aj4dnGptL1UTpmkCeXJehlo31TDExoasKlQk8tBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199018)(76116006)(66946007)(4326008)(66476007)(66556008)(83380400001)(66446008)(64756008)(8676002)(54906003)(9686003)(86362001)(55016003)(38100700002)(38070700005)(82960400001)(122000001)(186003)(110136005)(316002)(107886003)(55236004)(33656002)(26005)(478600001)(71200400001)(6506007)(7696005)(5660300002)(2906002)(41300700001)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NkhowJeQ3PKiwI1R8ePllMAbiz37ctonWpLjmAeHY3Lc/rkcfNAmjYVHz7kM?=
 =?us-ascii?Q?hyMzjhWc1Hy/H7OAonqjiajWjHff3+gjdBPAuLlreVTVJq4EHjwtj1sDBlnG?=
 =?us-ascii?Q?pNWOWxqtAcQM8kDeZLZHnBZwUrfX7Rzf7+4OchU6xb15E/f2uUKbVHblDKnp?=
 =?us-ascii?Q?2hBHjd+Fjz6MuqVhJFNOvQry0a0x512ZalkiwFAuRu3gVskPAWDP0nc9ro2y?=
 =?us-ascii?Q?LzH/TLs0LupU57hecklH5EdttoEVyJbZSNi4o3Gz6sflxCNjBsoXUDcb+4qm?=
 =?us-ascii?Q?D4To8z1EjJ+Vd5FLzoOrjbk6veG7Bwq/qVRAGkva8bw/bYN/wcBnlpKJ+yf/?=
 =?us-ascii?Q?GGgSCq5iR/ARZ0InwG6sQLN34/LKEeLWxrgCLgoUZif8DpvzR89IB00ZmD5A?=
 =?us-ascii?Q?hkRNx4Cq4i8irbChoGZTNP+19Ds3Sed8gFkV9hxWYmZ/Qy628DFOK1Zqg2uP?=
 =?us-ascii?Q?3RUxtqBw2uNnUQbUzJIp9OPB6XS9yRTVm2PqaPQ/AkQox5PdO1F4N9OSuchP?=
 =?us-ascii?Q?hrOo/h2EikTk/iywf8WKpCqVEE1DzX8TJ4F7G5RPDCREb2Tc3qKlM14VeHMx?=
 =?us-ascii?Q?HJCiupJqEJWTMbldz7E0BGfyExfmuxChCqyfL/VFq6B4JxXdPEuYSXuv947J?=
 =?us-ascii?Q?QsezkB7XfzL1zmmOOr6tY75vltl6aihPFKuVDddQw786YfD270picj88RmXS?=
 =?us-ascii?Q?jADj2g4mOKN646PEhP7k+luYoNipsIRMfcOaRjMmkfrdF6T4dCv4XuK83G63?=
 =?us-ascii?Q?+4ZtuuOb8ZXrDj98oTeoWiDhY8f09CjMGNJk3ThtI130jSjYb75fcy4+IakU?=
 =?us-ascii?Q?40P/yROO6Of0OmUYKSw8+W4vN9XgXCGedaWhYuNCK7EAwxFtpC7wKL7Z1Itt?=
 =?us-ascii?Q?qetKkEoK+hMkjRmyhdaT01HNB7u4NivVxsX92OYGbrQlO5qAuFC+RJKh5hzn?=
 =?us-ascii?Q?7naw4hTl9LEBZLeVjZrZwG00DFRov1TkUqJ2E0W4Ub9hCS4FeffOqe7/NHI5?=
 =?us-ascii?Q?zPSrXtRiwEg9a6ySiEevBeUnXONzagInprSMWHN/dXrm+tF1L7+PqsLMe6Cy?=
 =?us-ascii?Q?Wa5sH3Zytg39s8CpDyZxnNGLg3K+nPl+RcjhXp+uCUZ9gWYw24tflnOmlfPe?=
 =?us-ascii?Q?WzPrX9ctvly/L4Yh/hnehH6MfJie1GqLnHOaTlsb3ErODR1frj4D/qqrjTPj?=
 =?us-ascii?Q?PTk1Oeli4V5Kr7enqHuhsXdJtvZwGI8BmmbI3a5p/ZGqhTnZN15QM8zN8Q63?=
 =?us-ascii?Q?TpATNk/ATGw5MGipeExtoUTyz7NX0zEbkOkUGdGJfffXWzzmn9TV2+xj6pC+?=
 =?us-ascii?Q?ThJdYRlb9FlXEGVj9VE4ZzJGadiidKvRXIvCux6eGgFMlxHlWwZwqEgZlNKc?=
 =?us-ascii?Q?UoosxadHh4MK9KXG+SnfZtPt4pGVKVyamd5tLtci9CUkoBCalTtZ1e+dxfB6?=
 =?us-ascii?Q?cc+kfVLyrJmQEPk7MtCoLHkrh0abFm9t9M1SM4yYC4QhvD+K72oF0En7hznW?=
 =?us-ascii?Q?RyvPVV9u0x7IF+IvmC6JTh/4vpAA3iMr7L0esx4QTmYee1EGrLQceTKAAvB6?=
 =?us-ascii?Q?YMpk/iebKmr0pIwilpwdDgkTbXI4qKSDVTuzUewL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42de24f0-c196-4d8e-c2c6-08db1c09f330
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 17:08:46.2774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8DyjlPwy13QAqjZYIrqI62CLHl7NPGezRQVGynMIcM+h+7E5XRRyCK6aAxqk6K94mIuDk+8E0l9RSn7mAKsb9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7158
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
>Subject: [Intel-wired-lan] [PATCH intel-next v6 7/8] i40e: add xdp_buff to
>i40e_ring struct
>
>Store xdp_buff on Rx ring struct in preparation for XDP multi-buffer suppo=
rt.
>This will allow us to combine fragmented frames across separate NAPI cycle=
s
>in the same way as currently skb fragments are handled. This means that sk=
b
>pointer on Rx ring will become redundant and will be removed in a later pa=
tch.
>As a consequence i40e_trace() now uses xdp instead of skb pointer.
>
>Truesize only needs to be calculated for page sizes bigger than 4k as it i=
s
>always half-page for 4k pages. With xdp_buff on ring, frame size can now b=
e
>set during xdp_init_buff() and need not be repopulated in each NAPI call f=
or
>4k pages. As a consequence i40e_rx_frame_truesize() is now used only for
>bigger pages.
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c  |  2 ++
>drivers/net/ethernet/intel/i40e/i40e_trace.h | 20 ++++++------
>drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 33 ++++++++------------
>drivers/net/ethernet/intel/i40e/i40e_txrx.h  |  7 +++++
> 4 files changed, 32 insertions(+), 30 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
