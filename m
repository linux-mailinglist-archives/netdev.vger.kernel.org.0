Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08D3576612
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiGORcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGORcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:32:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB77565D49;
        Fri, 15 Jul 2022 10:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657906322; x=1689442322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O0Yg1qtV93xAzVeAukQJCPXp4ZXisQivq3itYnGDA/8=;
  b=FGKj3bBqBKefDrbEuKGZogQo9F5xNcb8piUPcW6fXW6Gf4itZpewGKeK
   01lhCdrS+4rvMAXOj9dLAbiPXg1kE71vVxUb+TsT7ekY0GTHnqrs6EMO1
   ci3yVKAQ8F+MbROIWoBar3cmW05oHx0n44tIIoNwO8O2RMzOqkzVmkpRz
   jSaCIYbM5vElIyRph+bLMiD4VuqI4Uf5vgfb+u1gF8hqbeHWeIEiLLR87
   83oykgXBfQMkRf4sFN1RXtFzn7iXdRmVJHcD2TiLuaSjye8R/p+JLQ9Uv
   JpqjRYtiBUTA4W3XZ206YT5J4NWy0l6d7eqMi+PBuiFVex1rElLUoaLWv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="265643373"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="265643373"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 10:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="629181384"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2022 10:31:38 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:37 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Jul 2022 10:31:37 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwGctD3qZN0USbOdoee0+GD7+eV6MpsXYJwi9Ax0d/9xxdSMaScSfON4BU8UfD+ReUMMBNrbnU7+GRJObvPC3DgEpDmDq4Tev8zhzuKXanI2vRxwzxwpdkOTyUZ0W5Qh70dHhIKxE/7SoOWLnw+egyoA1OGlw0DoX/DdAhaokAQSb45SOfY1S0lY52yJZIxu8vYaMoIxGGysDV5vbjs2RQuGnpMacePEVmWgdVlLo8IdwLP8LEeKh4ZLSqF3vPVSaF3g/ILSbjNy3xcEcFv4W0XHU0JEkyciM0ZccFdnQ+DURx2s1jmMuEWVuTtm3ea3lMbJfsw4R5eawep5CpLf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0Yg1qtV93xAzVeAukQJCPXp4ZXisQivq3itYnGDA/8=;
 b=RI12qMbCM9w+jxDmlGsiu9BQkO8vppgV9Zi7hnpzVJguXrwUvFX3N3agl0sVyIpZK4470PSH0cnz1+1EhpM2qbMlLXiMXaUl851U9G0fjTGEAOWwzeoZQpupwOlSHMfEzim6YLvF9rmXwoVB71SDiojtN8Hj2WcDA6DXtoJ7a/E2TEFyr2PUvssk79i4/RtiiIgSFYS/cedHSPqUw5X6fVXdknpUhB08CNrsAyNtQG3Qi28u6HXY/I7GerfoVHSOdGKktlyHk9mR/08VFP2ubDwOqN1ghlw3HxbVpqmaF8oPGGzuOTEPCUT+3kp6hfjJgQXbEVuW+8MKEGwTdFOZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BN6PR11MB4147.namprd11.prod.outlook.com (2603:10b6:405:80::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Fri, 15 Jul 2022 17:31:30 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%6]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 17:31:30 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Topic: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Index: AQHYiZJ5zeS9OiYOPkW4rEeGr6WnDq149o2AgAWpYQCAAS3QwA==
Date:   Fri, 15 Jul 2022 17:31:30 +0000
Message-ID: <DM6PR11MB465732355816F30254FCFA9E9B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-3-vfedorenko@novek.ru>
 <DM6PR11MB46573FA8D51D40DAD2AC060B9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
 <715d8f47-d246-6b4a-b22d-82672e8f11d8@novek.ru>
In-Reply-To: <715d8f47-d246-6b4a-b22d-82672e8f11d8@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a16c3d6-3e60-43d4-141e-08da6687dab6
x-ms-traffictypediagnostic: BN6PR11MB4147:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7WEPZ7Wjuy94YdhcylxR6tYEQLQCMZ+Q11UKtAueQiQc9l65u+P876SUxHdcSz7ftp+W4dWRFG/db3xAA9O7IMpXsYr15CMVRdofBDvKD10ZKEmVN5fnJ9YSDcOMnFHSAEglTIWTRx86ZVBjLCoUeIGVOm3kvLpeL/Cwq9+tE6h42LAQcE5uGeqxeW2Si0uCp7JhYkx+hI5vLSIysLzXmcpUotyTTtCS75lu8VPiZrxjAaTwgDb8Sut4VcWz0swXnO+nwsh1McvETFCPxtirOcBAW+2cZxRW0fZVFEzmfpo4iLPbXKyUQxY9DbHK6N5/T20SR5Uf8OTvixx6WsEg7rNYxFWg5F1reWqM2wdIfIlT4ESa3W41s3ZnN+XPqJAgMWDe47V8v7H185XGz5wQqx0K7BHJzMB3iRJMCNb9NlMG+r2k5i29rECP2dVt9OlEKzdJPUJTiE+kbNuFfa0xj1lcZ7W0K3N6CyNoE9FEum2VK1RuQzBjPOyTH2a1UN08+yLvL+GjXUq33M8wnMzwX2i+ETnbed4k9lkymGFERCQPMZVYhLZPyGLxw52gVcpgcEqeDfuOt3ACYmBWTigXSQR7WoOP0i+ZyOY9jTY0V7DE+Dc2RzausA3kD5UiP6KzwmuzpN0sYXZXLla2670+lN8UMeCu/hH0DnzMlPttRV/QJMAqwE7/QvUxp31bnUxTfB/SLc/V4kF7TqC8PbAzFceMLAOoPR9a9sRP3diOSzWEMG9HCXE8lyC97lxOIB4+yzCP+1ffJnuMwMRQTNsUKcP7qVamJIk0wGPusnE8vgEVelbmV2pq5sKynuZDXzZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(396003)(376002)(366004)(52536014)(33656002)(86362001)(38070700005)(122000001)(82960400001)(186003)(83380400001)(38100700002)(55016003)(76116006)(71200400001)(7696005)(8676002)(478600001)(26005)(41300700001)(54906003)(316002)(5660300002)(6506007)(4326008)(110136005)(66946007)(64756008)(9686003)(66556008)(66476007)(8936002)(2906002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWVYRXZlUE5TVmk0VjFCUmtnamYveFpNSDlXN3FYdVpXNHowWWhjTGJaRzV0?=
 =?utf-8?B?WVR1UkNsMG12MkF5UmU1U0R6dWVDNElGY2JJbzJkbGpwNzFPTDJwOVVJYTRu?=
 =?utf-8?B?djB4ZzdxdmNTc1k2L1BrNktmdFhoajdjK0dZV0JxUWdIN1dncGNwSHZ6TzZY?=
 =?utf-8?B?WlAxZlRydWJpRC9ESWV1amMyTjJVTXZ4YUJxeGpSZngwTXpCbDcvdUJiak9V?=
 =?utf-8?B?VEllZlZYamhNZW03a3ZOK3FxU1l3dzlQMTJHbHRsVUt3aGtpWHZaQ1plTmVO?=
 =?utf-8?B?TWIxRVFLOUJnZFRWVlVGRE9FeEpqZW9Ma0l1c2dCckhqajcxaERPWnVCb3g5?=
 =?utf-8?B?d3gwUVRURFhHK0w2R3RVU0FaZm9CeG1vMjFjQzFGckdxaTJyOEtERWdyK0hY?=
 =?utf-8?B?Z1lyNnNOcGV4d1QvWXJJZ0c5eTRzWk54TEJpMDRtcU9pMWdvRzBNTUhhZmEr?=
 =?utf-8?B?Q0NHMldxS2VQQmYyTkRrcWdUYkx0Y1d5REJxWXIrT2poTWZ6MDVMZUpSRlpw?=
 =?utf-8?B?aGdFMVAzMEcwOTRvMHdZcVUwSDZ4bnl6TWdDYzdzcXhvaHYrRUgveC9hV2or?=
 =?utf-8?B?eG11ZUZ4a29pMks0a3FGNzFjUDhpSDR5eDFyNGFmM3JrU05mQm1PcVMxYUd0?=
 =?utf-8?B?dXBaY29xMjNxMkMxTkxFaHJVZjJzTERwd0JOYWRnY1JUYS9DRHZoSlRtQzNO?=
 =?utf-8?B?eERSNEFKTHMraVdHSXoyT1RsbWdCODh2MFR1Zko4S3FnMGR1dm9MQzZHVmcw?=
 =?utf-8?B?RTdhYmNDeXpWZFo4VHE0ajg5Y2NxSzljcS9CYVBvNk5ZZ2tHSlhpbGRzcWZa?=
 =?utf-8?B?bUJzTUVTdmYwK1N4SEpDVDk1T2ZZd3RHY1pxd2w3M0gyNGV5MjhNU3JHR3RB?=
 =?utf-8?B?NXJybHBoY0EzQmErRVRTSlYxbEt0c1NCMzFzd241NEROc3pyVWxyMU5McGNt?=
 =?utf-8?B?K3NIYzlkdlkwMndOQnZMdjBWOGUwT2hiWWZRbzZFQ2xoS3ozM3ZRek9MMmY3?=
 =?utf-8?B?N1dJbFg2bW5mQ1MwVTQwOWIwajFna0hYS1NXNGZPNEhtdjBPSUdac1MvNy9Q?=
 =?utf-8?B?aDNYM3Y1OHRSN3A3aTgzM1psRGNIN1MwZWIvWi9idzFUM1cvYUdHWE5KTzY5?=
 =?utf-8?B?K2xrODlSL1JYSHRoQTFMclVDMWZ1UnNFWTQxVHVhVTduRFA5Z1FkZll5OGt1?=
 =?utf-8?B?cUZxMlVqUDh4ZU5vNFdKb2t0U3M2UFJTMks0MWIvT09LTGl1MUdwTVFYOXVU?=
 =?utf-8?B?c3VWdnUyL3U0OEwzMzdnNFhmQ1NpTFozTzI5aTBWNktWVEQ5RVhDZGZoT1dN?=
 =?utf-8?B?Z05WaEZqdFhQc0J4TWt4RHk0a2NmVHc3cXJwNXFWaVJkV2FzeEd4Q1hNMFZ4?=
 =?utf-8?B?WWVmWkVPajlpZ1hydUpEdE92THNHL1Nld2lrNlpFRjBSaEdIdStWSHBTaXM3?=
 =?utf-8?B?STZ2d0lMSXdMbTBxazg4SWtXVmw4ZTM2dU9DNU4xeXVFZGkxeE85OFFCdUNi?=
 =?utf-8?B?TlphdXRqbDVwcTFGWHo4dktKZzA1T21BdTEwRjNia3BidDUyYVdUbVhRazZO?=
 =?utf-8?B?TU5VNXNhS1FGbnFOYlA2OUdqRWd3VndDN2o0LzIyb1IxNXV0OFlabWZmOFBX?=
 =?utf-8?B?TVVZNmx1d1o4aGs3cnJqMnNkYktyQjE5NFhpeHZiYU1VVGwwNUkvV3BEY0Yy?=
 =?utf-8?B?K1p1ZHRYc1J5Q051QUZjMUlSaWVXbGV0SU1Md2xZQlp3M3NKTXdDUFR6dTBT?=
 =?utf-8?B?LzcxeGJndnRlTlA4Rkw5VlA2WlVFSG1QM1I1cU9mVXJRRmw2bkZVeXpJSFlP?=
 =?utf-8?B?UFl0ck5nQ1BXZHJhck43U0twM2p1RzVEekl1anh5bGVxbVBlVEJHNUFYYURH?=
 =?utf-8?B?cXlCZ1JkQVJqZFBxNktKSi9Td1cwbmw2L1BrNmVVY3YyeDVsVW9OcGNZbWRF?=
 =?utf-8?B?VTJFYUQ1c0RvUDk2OXYvRm1ZOWw1OC9IVDYzSk8wdHMrcFU2UEZXZ2FXYWdr?=
 =?utf-8?B?ZEpmWnB4cWx4d3BJb09GTnI3KzZKQkJzVWJiNndzVXMrc3RRVWluQW42bVpy?=
 =?utf-8?B?OFlyRi9vQU5aSkpUSys4OWhFUFZUZCtxTVhOVUszQStoREhYUTRMdHl2ek54?=
 =?utf-8?B?cGVzZ3gxRDNvOUllZUVUVUsvRklaUGRVenMrZXhJZnFvOXZHZXRCOEd2czYw?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a16c3d6-3e60-43d4-141e-08da6687dab6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 17:31:30.1862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4UyZtE/CrINGHGJgq2OxR4oFle7b/H3LKySADGQPOgtr5AH+IqABHE2AfYnunq7CdlvqXDzpB8gnqEYmo9FPa0H3qbLzr7OyZG5AZ1YnyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFZhZGltIEZlZG9yZW5rbyA8dmZlZG9y
ZW5rb0Bub3Zlay5ydT4gDQpTZW50OiBGcmlkYXksIEp1bHkgMTUsIDIwMjIgMToyOSBBTQ0KPg0K
Pk9uIDExLjA3LjIwMjIgMTA6MDIsIEt1YmFsZXdza2ksIEFya2FkaXVzeiB3cm90ZToNCj4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+PiBGcm9tOiBWYWRpbSBGZWRvcmVua28gPHZmZWRv
cmVua29Abm92ZWsucnU+DQo+PiBTZW50OiBTdW5kYXksIEp1bmUgMjYsIDIwMjIgOToyNSBQTQ0K
Pj4+DQo+Pj4gRnJvbTogVmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAZmIuY29tPg0KPj4+DQo+Pj4g
QWRkIG5ldGxpbmsgaW50ZXJmYWNlIHRvIGVuYWJsZSBub3RpZmljYXRpb24gb2YgdXNlcnMgYWJv
dXQNCj4+PiBldmVudHMgaW4gRFBMTCBmcmFtZXdvcmsuIFBhcnQgb2YgdGhpcyBpbnRlcmZhY2Ug
c2hvdWxkIGJlDQo+Pj4gdXNlZCBieSBkcml2ZXJzIGRpcmVjdGx5LCBpLmUuIGxvY2sgc3RhdHVz
IGNoYW5nZXMuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBWYWRpbSBGZWRvcmVua28gPHZhZGZl
ZEBmYi5jb20+DQo+Pj4gLS0tDQo+Pj4gZHJpdmVycy9kcGxsL2RwbGxfY29yZS5jICAgIHwgICAy
ICsNCj4+PiBkcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMgfCAxNDEgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+Pj4gZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oIHwg
ICA3ICsrDQo+Pj4gMyBmaWxlcyBjaGFuZ2VkLCAxNTAgaW5zZXJ0aW9ucygrKQ0KPj4+DQo+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZHBsbC9kcGxsX2NvcmUuYyBiL2RyaXZlcnMvZHBsbC9kcGxs
X2NvcmUuYw0KPj4+IGluZGV4IGRjMDMzMGUzNjg3ZC4uMzg3NjQ0YWE5MTBlIDEwMDY0NA0KPj4+
IC0tLSBhL2RyaXZlcnMvZHBsbC9kcGxsX2NvcmUuYw0KPj4+ICsrKyBiL2RyaXZlcnMvZHBsbC9k
cGxsX2NvcmUuYw0KPj4+IEBAIC05Nyw2ICs5Nyw4IEBAIHN0cnVjdCBkcGxsX2RldmljZSAqZHBs
bF9kZXZpY2VfYWxsb2Moc3RydWN0IGRwbGxfZGV2aWNlX29wcyAqb3BzLCBpbnQgc291cmNlc19j
DQo+Pj4gCW11dGV4X3VubG9jaygmZHBsbF9kZXZpY2VfeGFfbG9jayk7DQo+Pj4gCWRwbGwtPnBy
aXYgPSBwcml2Ow0KPj4+DQo+Pj4gKwlkcGxsX25vdGlmeV9kZXZpY2VfY3JlYXRlKGRwbGwtPmlk
LCBkZXZfbmFtZSgmZHBsbC0+ZGV2KSk7DQo+Pj4gKw0KPj4+IAlyZXR1cm4gZHBsbDsNCj4+Pg0K
Pj4+IGVycm9yOg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMg
Yi9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMNCj4+PiBpbmRleCBlMTUxMDZmMzAzNzcuLjRi
MTY4NGZjZjQxZSAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMN
Cj4+PiArKysgYi9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMNCj4+PiBAQCAtNDgsNiArNDgs
OCBAQCBzdHJ1Y3QgcGFyYW0gew0KPj4+IAlpbnQgZHBsbF9zb3VyY2VfdHlwZTsNCj4+PiAJaW50
IGRwbGxfb3V0cHV0X2lkOw0KPj4+IAlpbnQgZHBsbF9vdXRwdXRfdHlwZTsNCj4+PiArCWludCBk
cGxsX3N0YXR1czsNCj4+PiArCWNvbnN0IGNoYXIgKmRwbGxfbmFtZTsNCj4+PiB9Ow0KPj4+DQo+
Pj4gc3RydWN0IGRwbGxfZHVtcF9jdHggew0KPj4+IEBAIC0yMzksNiArMjQxLDggQEAgc3RhdGlj
IGludCBkcGxsX2dlbmxfY21kX3NldF9zb3VyY2Uoc3RydWN0IHBhcmFtICpwKQ0KPj4+IAlyZXQg
PSBkcGxsLT5vcHMtPnNldF9zb3VyY2VfdHlwZShkcGxsLCBzcmNfaWQsIHR5cGUpOw0KPj4+IAlt
dXRleF91bmxvY2soJmRwbGwtPmxvY2spOw0KPj4+DQo+Pj4gKwlkcGxsX25vdGlmeV9zb3VyY2Vf
Y2hhbmdlKGRwbGwtPmlkLCBzcmNfaWQsIHR5cGUpOw0KPj4+ICsNCj4+PiAJcmV0dXJuIHJldDsN
Cj4+PiB9DQo+Pj4NCj4+PiBAQCAtMjYyLDYgKzI2Niw4IEBAIHN0YXRpYyBpbnQgZHBsbF9nZW5s
X2NtZF9zZXRfb3V0cHV0KHN0cnVjdCBwYXJhbSAqcCkNCj4+PiAJcmV0ID0gZHBsbC0+b3BzLT5z
ZXRfc291cmNlX3R5cGUoZHBsbCwgb3V0X2lkLCB0eXBlKTsNCj4+PiAJbXV0ZXhfdW5sb2NrKCZk
cGxsLT5sb2NrKTsNCj4+Pg0KPj4+ICsJZHBsbF9ub3RpZnlfc291cmNlX2NoYW5nZShkcGxsLT5p
ZCwgb3V0X2lkLCB0eXBlKTsNCj4+PiArDQo+Pj4gCXJldHVybiByZXQ7DQo+Pj4gfQ0KPj4+DQo+
Pj4gQEAgLTQzOCw2ICs0NDQsMTQxIEBAIHN0YXRpYyBzdHJ1Y3QgZ2VubF9mYW1pbHkgZHBsbF9n
bmxfZmFtaWx5IF9fcm9fYWZ0ZXJfaW5pdCA9IHsNCj4+PiAJLnByZV9kb2l0CT0gZHBsbF9wcmVf
ZG9pdCwNCj4+PiB9Ow0KPj4+DQo+Pj4gK3N0YXRpYyBpbnQgZHBsbF9ldmVudF9kZXZpY2VfY3Jl
YXRlKHN0cnVjdCBwYXJhbSAqcCkNCj4+PiArew0KPj4+ICsJaWYgKG5sYV9wdXRfdTMyKHAtPm1z
ZywgRFBMTEFfREVWSUNFX0lELCBwLT5kcGxsX2lkKSB8fA0KPj4+ICsJICAgIG5sYV9wdXRfc3Ry
aW5nKHAtPm1zZywgRFBMTEFfREVWSUNFX05BTUUsIHAtPmRwbGxfbmFtZSkpDQo+Pj4gKwkJcmV0
dXJuIC1FTVNHU0laRTsNCj4+PiArDQo+Pj4gKwlyZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+
PiArc3RhdGljIGludCBkcGxsX2V2ZW50X2RldmljZV9kZWxldGUoc3RydWN0IHBhcmFtICpwKQ0K
Pj4+ICt7DQo+Pj4gKwlpZiAobmxhX3B1dF91MzIocC0+bXNnLCBEUExMQV9ERVZJQ0VfSUQsIHAt
PmRwbGxfaWQpKQ0KPj4+ICsJCXJldHVybiAtRU1TR1NJWkU7DQo+Pj4gKw0KPj4+ICsJcmV0dXJu
IDA7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0YXRpYyBpbnQgZHBsbF9ldmVudF9zdGF0dXMoc3Ry
dWN0IHBhcmFtICpwKQ0KPj4+ICt7DQo+Pj4gKwlpZiAobmxhX3B1dF91MzIocC0+bXNnLCBEUExM
QV9ERVZJQ0VfSUQsIHAtPmRwbGxfaWQpIHx8DQo+Pj4gKwkJbmxhX3B1dF91MzIocC0+bXNnLCBE
UExMQV9MT0NLX1NUQVRVUywgcC0+ZHBsbF9zdGF0dXMpKQ0KPj4+ICsJCXJldHVybiAtRU1TR1NJ
WkU7DQo+Pj4gKw0KPj4+ICsJcmV0dXJuIDA7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0YXRpYyBp
bnQgZHBsbF9ldmVudF9zb3VyY2VfY2hhbmdlKHN0cnVjdCBwYXJhbSAqcCkNCj4+PiArew0KPj4+
ICsJaWYgKG5sYV9wdXRfdTMyKHAtPm1zZywgRFBMTEFfREVWSUNFX0lELCBwLT5kcGxsX2lkKSB8
fA0KPj4+ICsJICAgIG5sYV9wdXRfdTMyKHAtPm1zZywgRFBMTEFfU09VUkNFX0lELCBwLT5kcGxs
X3NvdXJjZV9pZCkgfHwNCj4+PiArCQlubGFfcHV0X3UzMihwLT5tc2csIERQTExBX1NPVVJDRV9U
WVBFLCBwLT5kcGxsX3NvdXJjZV90eXBlKSkNCj4+PiArCQlyZXR1cm4gLUVNU0dTSVpFOw0KPj4+
ICsNCj4+PiArCXJldHVybiAwOw0KPj4+ICt9DQo+Pj4gKw0KPj4+ICtzdGF0aWMgaW50IGRwbGxf
ZXZlbnRfb3V0cHV0X2NoYW5nZShzdHJ1Y3QgcGFyYW0gKnApDQo+Pj4gK3sNCj4+PiArCWlmIChu
bGFfcHV0X3UzMihwLT5tc2csIERQTExBX0RFVklDRV9JRCwgcC0+ZHBsbF9pZCkgfHwNCj4+PiAr
CSAgICBubGFfcHV0X3UzMihwLT5tc2csIERQTExBX09VVFBVVF9JRCwgcC0+ZHBsbF9vdXRwdXRf
aWQpIHx8DQo+Pj4gKwkJbmxhX3B1dF91MzIocC0+bXNnLCBEUExMQV9PVVRQVVRfVFlQRSwgcC0+
ZHBsbF9vdXRwdXRfdHlwZSkpDQo+Pj4gKwkJcmV0dXJuIC1FTVNHU0laRTsNCj4+PiArDQo+Pj4g
KwlyZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+PiArc3RhdGljIGNiX3QgZXZlbnRfY2JbXSA9
IHsNCj4+PiArCVtEUExMX0VWRU5UX0RFVklDRV9DUkVBVEVdCT0gZHBsbF9ldmVudF9kZXZpY2Vf
Y3JlYXRlLA0KPj4+ICsJW0RQTExfRVZFTlRfREVWSUNFX0RFTEVURV0JPSBkcGxsX2V2ZW50X2Rl
dmljZV9kZWxldGUsDQo+Pj4gKwlbRFBMTF9FVkVOVF9TVEFUVVNfTE9DS0VEXQk9IGRwbGxfZXZl
bnRfc3RhdHVzLA0KPj4+ICsJW0RQTExfRVZFTlRfU1RBVFVTX1VOTE9DS0VEXQk9IGRwbGxfZXZl
bnRfc3RhdHVzLA0KPj4+ICsJW0RQTExfRVZFTlRfU09VUkNFX0NIQU5HRV0JPSBkcGxsX2V2ZW50
X3NvdXJjZV9jaGFuZ2UsDQo+Pj4gKwlbRFBMTF9FVkVOVF9PVVRQVVRfQ0hBTkdFXQk9IGRwbGxf
ZXZlbnRfb3V0cHV0X2NoYW5nZSwNCj4+PiArfTsNCj4+PiArLyoNCj4+PiArICogR2VuZXJpYyBu
ZXRsaW5rIERQTEwgZXZlbnQgZW5jb2RpbmcNCj4+PiArICovDQo+Pj4gK3N0YXRpYyBpbnQgZHBs
bF9zZW5kX2V2ZW50KGVudW0gZHBsbF9nZW5sX2V2ZW50IGV2ZW50LA0KPj4+ICsJCQkJICAgc3Ry
dWN0IHBhcmFtICpwKQ0KPj4+ICt7DQo+Pj4gKwlzdHJ1Y3Qgc2tfYnVmZiAqbXNnOw0KPj4+ICsJ
aW50IHJldCA9IC1FTVNHU0laRTsNCj4+PiArCXZvaWQgKmhkcjsNCj4+PiArDQo+Pj4gKwltc2cg
PSBnZW5sbXNnX25ldyhOTE1TR19HT09EU0laRSwgR0ZQX0tFUk5FTCk7DQo+Pj4gKwlpZiAoIW1z
ZykNCj4+PiArCQlyZXR1cm4gLUVOT01FTTsNCj4+PiArCXAtPm1zZyA9IG1zZzsNCj4+PiArDQo+
Pj4gKwloZHIgPSBnZW5sbXNnX3B1dChtc2csIDAsIDAsICZkcGxsX2dubF9mYW1pbHksIDAsIGV2
ZW50KTsNCj4+PiArCWlmICghaGRyKQ0KPj4+ICsJCWdvdG8gb3V0X2ZyZWVfbXNnOw0KPj4+ICsN
Cj4+PiArCXJldCA9IGV2ZW50X2NiW2V2ZW50XShwKTsNCj4+PiArCWlmIChyZXQpDQo+Pj4gKwkJ
Z290byBvdXRfY2FuY2VsX21zZzsNCj4+PiArDQo+Pj4gKwlnZW5sbXNnX2VuZChtc2csIGhkcik7
DQo+Pj4gKw0KPj4+ICsJZ2VubG1zZ19tdWx0aWNhc3QoJmRwbGxfZ25sX2ZhbWlseSwgbXNnLCAw
LCAxLCBHRlBfS0VSTkVMKTsNCj4+IA0KPj4gQWxsIG11bHRpY2FzdHMgYXJlIHNlbmQgb25seSBm
b3IgZ3JvdXAgIjEiIChEUExMX0NPTkZJR19TT1VSQ0VfR1JPVVBfTkFNRSksDQo+PiBidXQgNCBn
cm91cHMgd2VyZSBkZWZpbmVkLg0KPj4NCj4NCj5ZZXMsIHlvdSBhcmUgcmlnaHQhIFdpbGwgdXBk
YXRlIGl0IGluIHRoZSBuZXh0IHJvdW5kLg0KPg0KPj4+ICsNCj4+PiArCXJldHVybiAwOw0KPj4+
ICsNCj4+PiArb3V0X2NhbmNlbF9tc2c6DQo+Pj4gKwlnZW5sbXNnX2NhbmNlbChtc2csIGhkcik7
DQo+Pj4gK291dF9mcmVlX21zZzoNCj4+PiArCW5sbXNnX2ZyZWUobXNnKTsNCj4+PiArDQo+Pj4g
KwlyZXR1cm4gcmV0Ow0KPj4+ICt9DQo+Pj4gKw0KPj4+ICtpbnQgZHBsbF9ub3RpZnlfZGV2aWNl
X2NyZWF0ZShpbnQgZHBsbF9pZCwgY29uc3QgY2hhciAqbmFtZSkNCj4+PiArew0KPj4+ICsJc3Ry
dWN0IHBhcmFtIHAgPSB7IC5kcGxsX2lkID0gZHBsbF9pZCwgLmRwbGxfbmFtZSA9IG5hbWUgfTsN
Cj4+PiArDQo+Pj4gKwlyZXR1cm4gZHBsbF9zZW5kX2V2ZW50KERQTExfRVZFTlRfREVWSUNFX0NS
RUFURSwgJnApOw0KPj4+ICt9DQo+Pj4gKw0KPj4+ICtpbnQgZHBsbF9ub3RpZnlfZGV2aWNlX2Rl
bGV0ZShpbnQgZHBsbF9pZCkNCj4+PiArew0KPj4+ICsJc3RydWN0IHBhcmFtIHAgPSB7IC5kcGxs
X2lkID0gZHBsbF9pZCB9Ow0KPj4+ICsNCj4+PiArCXJldHVybiBkcGxsX3NlbmRfZXZlbnQoRFBM
TF9FVkVOVF9ERVZJQ0VfREVMRVRFLCAmcCk7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK2ludCBkcGxs
X25vdGlmeV9zdGF0dXNfbG9ja2VkKGludCBkcGxsX2lkKQ0KPj4+ICt7DQo+Pj4gKwlzdHJ1Y3Qg
cGFyYW0gcCA9IHsgLmRwbGxfaWQgPSBkcGxsX2lkLCAuZHBsbF9zdGF0dXMgPSAxIH07DQo+Pj4g
Kw0KPj4+ICsJcmV0dXJuIGRwbGxfc2VuZF9ldmVudChEUExMX0VWRU5UX1NUQVRVU19MT0NLRUQs
ICZwKTsNCj4+PiArfQ0KPj4+ICsNCj4+PiAraW50IGRwbGxfbm90aWZ5X3N0YXR1c191bmxvY2tl
ZChpbnQgZHBsbF9pZCkNCj4+PiArew0KPj4+ICsJc3RydWN0IHBhcmFtIHAgPSB7IC5kcGxsX2lk
ID0gZHBsbF9pZCwgLmRwbGxfc3RhdHVzID0gMCB9Ow0KPj4+ICsNCj4+PiArCXJldHVybiBkcGxs
X3NlbmRfZXZlbnQoRFBMTF9FVkVOVF9TVEFUVVNfVU5MT0NLRUQsICZwKTsNCj4+PiArfQ0KPj4+
ICsNCj4+PiAraW50IGRwbGxfbm90aWZ5X3NvdXJjZV9jaGFuZ2UoaW50IGRwbGxfaWQsIGludCBz
b3VyY2VfaWQsIGludCBzb3VyY2VfdHlwZSkNCj4+PiArew0KPj4+ICsJc3RydWN0IHBhcmFtIHAg
PSAgeyAuZHBsbF9pZCA9IGRwbGxfaWQsIC5kcGxsX3NvdXJjZV9pZCA9IHNvdXJjZV9pZCwNCj4+
PiArCQkJCQkJLmRwbGxfc291cmNlX3R5cGUgPSBzb3VyY2VfdHlwZSB9Ow0KPj4+ICsNCj4+PiAr
CXJldHVybiBkcGxsX3NlbmRfZXZlbnQoRFBMTF9FVkVOVF9TT1VSQ0VfQ0hBTkdFLCAmcCk7DQo+
Pj4gK30NCj4+PiArDQo+Pj4gK2ludCBkcGxsX25vdGlmeV9vdXRwdXRfY2hhbmdlKGludCBkcGxs
X2lkLCBpbnQgb3V0cHV0X2lkLCBpbnQgb3V0cHV0X3R5cGUpDQo+Pj4gK3sNCj4+PiArCXN0cnVj
dCBwYXJhbSBwID0gIHsgLmRwbGxfaWQgPSBkcGxsX2lkLCAuZHBsbF9vdXRwdXRfaWQgPSBvdXRw
dXRfaWQsDQo+Pj4gKwkJCQkJCS5kcGxsX291dHB1dF90eXBlID0gb3V0cHV0X3R5cGUgfTsNCj4+
PiArDQo+Pj4gKwlyZXR1cm4gZHBsbF9zZW5kX2V2ZW50KERQTExfRVZFTlRfT1VUUFVUX0NIQU5H
RSwgJnApOw0KPj4+ICt9DQo+Pj4gKw0KPj4+IGludCBfX2luaXQgZHBsbF9uZXRsaW5rX2luaXQo
dm9pZCkNCj4+PiB7DQo+Pj4gCXJldHVybiBnZW5sX3JlZ2lzdGVyX2ZhbWlseSgmZHBsbF9nbmxf
ZmFtaWx5KTsNCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oIGIv
ZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oDQo+Pj4gaW5kZXggZTJkMTAwZjU5ZGQ2Li4wZGM4
MTMyMGY5ODIgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oDQo+
Pj4gKysrIGIvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oDQo+Pj4gQEAgLTMsNSArMywxMiBA
QA0KPj4+ICAgKiAgQ29weXJpZ2h0IChjKSAyMDIxIE1ldGEgUGxhdGZvcm1zLCBJbmMuIGFuZCBh
ZmZpbGlhdGVzDQo+Pj4gICAqLw0KPj4+DQo+Pj4gK2ludCBkcGxsX25vdGlmeV9kZXZpY2VfY3Jl
YXRlKGludCBkcGxsX2lkLCBjb25zdCBjaGFyICpuYW1lKTsNCj4+PiAraW50IGRwbGxfbm90aWZ5
X2RldmljZV9kZWxldGUoaW50IGRwbGxfaWQpOw0KPj4+ICtpbnQgZHBsbF9ub3RpZnlfc3RhdHVz
X2xvY2tlZChpbnQgZHBsbF9pZCk7DQo+Pj4gK2ludCBkcGxsX25vdGlmeV9zdGF0dXNfdW5sb2Nr
ZWQoaW50IGRwbGxfaWQpOw0KPj4+ICtpbnQgZHBsbF9ub3RpZnlfc291cmNlX2NoYW5nZShpbnQg
ZHBsbF9pZCwgaW50IHNvdXJjZV9pZCwgaW50IHNvdXJjZV90eXBlKTsNCj4+PiAraW50IGRwbGxf
bm90aWZ5X291dHB1dF9jaGFuZ2UoaW50IGRwbGxfaWQsIGludCBvdXRwdXRfaWQsIGludCBvdXRw
dXRfdHlwZSk7DQo+PiANCj4+IE9ubHkgZHBsbF9ub3RpZnlfZGV2aWNlX2NyZWF0ZSBpcyBhY3R1
YWxseSB1c2VkLCByZXN0IGlzIG5vdC4NCj4+IEkgYW0gZ2V0dGluZyBjb25mdXNlZCBhIGJpdCwg
d2hvIHNob3VsZCBjYWxsIHRob3NlICJub3RpZnkiIGZ1bmN0aW9ucz8NCj4+IEl0IGlzIHN0cmFp
Z2h0Zm9yd2FyZCBmb3IgY3JlYXRlL2RlbGV0ZSwgZHBsbCBzdWJzeXN0ZW0gc2hhbGwgZG8gaXQs
IGJ1dCB3aGF0DQo+PiBhYm91dCB0aGUgcmVzdD8NCj4+IEkgd291bGQgc2F5IG5vdGlmaWNhdGlv
bnMgYWJvdXQgc3RhdHVzIG9yIHNvdXJjZS9vdXRwdXQgY2hhbmdlIHNoYWxsIG9yaWdpbmF0ZQ0K
Pj4gaW4gdGhlIGRyaXZlciBpbXBsZW1lbnRpbmcgZHBsbCBpbnRlcmZhY2UsIHRodXMgdGhleSBz
aGFsbCBiZSBleHBvcnRlZCBhbmQNCj4+IGRlZmluZWQgaW4gdGhlIGhlYWRlciBpbmNsdWRlZCBi
eSB0aGUgZHJpdmVyLg0KPj4gDQo+DQo+SSB3YXMgdGhpbmtpbmcgYWJvdXQgZHJpdmVyIHRvbywg
YmVjYXVzZSBkZXZpY2UgY2FuIGhhdmUgZGlmZmVyZW50IGludGVyZmFjZXMgdG8gDQo+Y29uZmln
dXJlIHNvdXJjZS9vdXRwdXQsIGFuZCBkaWZmZXJlbnQgbm90aWZpY2F0aW9ucyB0byB1cGRhdGUg
c3RhdHVzLiBJIHdpbGwgDQo+dXBkYXRlIHB0cF9vY3AgZHJpdmVyIHRvIGltcGxlbWVudCB0aGlz
IGxvZ2ljLiBBbmQgaXQgd2lsbCBhbHNvIGNvdmVyIHF1ZXN0aW9uIA0KPm9mIGV4cG9ydGluZyB0
aGVzZSBmdW5jdGlvbnMgYW5kIHRoZWlyIGRlZmluaXRpb25zLg0KPg0KDQpHcmVhdCENCg0KVGhh
bmssDQpBcmthZGl1c3oNCj4+PiArDQo+Pj4gaW50IF9faW5pdCBkcGxsX25ldGxpbmtfaW5pdCh2
b2lkKTsNCj4+PiB2b2lkIGRwbGxfbmV0bGlua19maW5pc2godm9pZCk7DQo+Pj4gLS0gDQo+Pj4g
Mi4yNy4wDQo+Pj4NCj4NCg==
