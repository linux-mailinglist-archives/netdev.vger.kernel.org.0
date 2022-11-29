Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA463C2D9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbiK2OlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiK2OlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:41:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9224E40A;
        Tue, 29 Nov 2022 06:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669732865; x=1701268865;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Czjti7ZRgm4dDMJ2KAISr+athsk4Ebdq4ZcUByffXLg=;
  b=HxSPkh9iGNaFTLOWqS+vLMxJiEO0zKoZQ0LW3cOVtkCHi2KAbZMUe8tS
   CnoxNzFNdk+m+VrFXQpNXWlBTFIGOPmWFijw2GIPWJHeabfJ7gIVcdJzV
   28JMvmHZGgvpejoVPMW4+wK5GwMKy6yG83ujGQ1D3Tbf+TPrBx5+xp35I
   bFks+gzyg5jMRbLY8Qp5TTZWsdloWkGhc21U4apVCcvsUX27cvJ4yzdTK
   BHdsgEo+dHL9pUnq+DRFnpdQVUW4ZnvGo0NlW8kkVjbMqgJOlpIUbiQxm
   tKYFI7RPK7JBk8iuYvu+RbfKvhOaZFnb1ZZCW+xqOgxOlBUDcz4n5oFks
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="294815910"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="294815910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 06:41:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="674640886"
X-IronPort-AV: E=Sophos;i="5.96,203,1665471600"; 
   d="scan'208";a="674640886"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 29 Nov 2022 06:41:04 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 06:41:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 06:41:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 06:41:04 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 06:41:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g64pbgsveBKrg3orMOHiMrBf9669VNabJ06EE8xIwQoJ36DdLtwbez4SV6J5VPcQEIynRojRU0zW+QB21kc9TD5RNwMaSFpMydweXaE21Stg4UekIDuKLg8uvHyYyxOAB6Phjv7loZIRKu1zJqEG9zLPH724kszLNy0AQNHNkRQX/iwfFNfKwqYbiqPRMgHcBFnNfdvXP9cpnQK2hD2//wQ18QxDx5Sqp3wdexgKQFGlmk0vY68Vu/xvce73C1znR/eZzigEyUvMGuaqXRM8mnO0P94PZRkc4FUUq4MyKDCvdICt8CB3+2Roz1e/WA0o5P3XDqkm/WjWYMktfw8CxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlEbECNwsTnRomQ+Ftq0Szhpr/yJNBjIjLMc+etdXDw=;
 b=Ch5DRvEXkvRfQrz+u7zb1Haut4FQcaLF3Is1Zm6CX2+xnqONRCUyjWVMAwsC5ic/YCdrL7punpmSYnSgAwcRV8mk3Ap3pP/Td+YaZxMNubjo0vq+MC3L1POBPidc94gFBlbJBDrHX7VyUDDcvk6PJP4BAZ/FMP+ebgfAa1AqFSnvLxzV2JUO33r2cX36l+zfOjiKuUfb6Pw13tKschLAIKCIKLQgZmVGDi7vvSShKEcs6jwOJ87SmN2jxxP0NhKw90quAtUynqHLBXVlwoNzHO7Jfoqufqz8eBasqbBxcLAQD5oowo/JE2aevWYZt+Em/N8it0Onawtvzq5vUB65Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 29 Nov
 2022 14:41:02 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%5]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:41:02 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuri Benditovich" <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v4] igb: Allocate MSI-X vector when
 testing
Thread-Topic: [Intel-wired-lan] [PATCH net v4] igb: Allocate MSI-X vector when
 testing
Thread-Index: AQHZANI65tHc8YIWGUO076whpgIGrK5V/1Nw
Date:   Tue, 29 Nov 2022 14:41:02 +0000
Message-ID: <BYAPR11MB336772D78CBD1F38C8054636FC129@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20221125133031.46845-1-akihiko.odaki@daynix.com>
In-Reply-To: <20221125133031.46845-1-akihiko.odaki@daynix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|CY5PR11MB6115:EE_
x-ms-office365-filtering-correlation-id: 30e2224e-c6c0-42c9-e3ed-08dad217bd15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOjZiefESzbhuxq+QTKnidxV8f895+SOn5gDtZG5DAjLXVQFU6LykD+PMBSDTKHL0fEfCiI6T01QacjgfaR8S3G0EgzkCYH1mRDpTqQGllck73HyT6uiDL1sYYER2w0Z7Z7O+VEA35/53n9a8tRyXZnX0RXEHXsv2yraAHJXumDR1d9KvvsuxO7T8gEojHFqPGVRQBooClKDY3DrQWcXtTjFQSUaddofWhKAvJiti9bjHlBA7x0k4dUXHC065vODR76wXvM4tEwX6hhEJmAsW2WQw88knuxdSUKj6Ptu7GAfHPkXLGbI2g2tY6hW2eU/hZSvlBA+wKqT1En7E82VOTNob5dUMuv/voV7jJSoDIGpLwDixSvosuwsudpNPQR66g+ODSYDxHcwt5YwnP4FRbVS8fkvL496+64nE2o9bZHENA1OzCEzeu6a1ElPey4k719gHYny4Tsu1YbyWBmZuI70Y+frJopUqmPjdnGViSU+8ATKGa3E9MbWa44E9jGgYXA8mRXWuyGikpU8A6CLVDGO6y7vGMhGWTpdQtBvM8Qbt7hwT0nDnPtAvZiuezxtXgn2qKh0P+ZAJeWTk7xA8fEwvYPh4WHe3ZYJtD6hMDv3D/+AWtaagCqPVQCy1MhCL8XRLMuBnTPF2WtrIaU+MNN4dkxM2F3BRTGd+I8YyuHZ5Na4U4VnU8a0MrxrCtYliUsua6YtXhya3yJJKNKLGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199015)(54906003)(83380400001)(186003)(2906002)(26005)(7696005)(6916009)(316002)(6506007)(9686003)(33656002)(478600001)(86362001)(55016003)(71200400001)(7416002)(64756008)(66556008)(8676002)(66476007)(5660300002)(66446008)(41300700001)(4326008)(52536014)(8936002)(76116006)(122000001)(82960400001)(38070700005)(66946007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LWttWkPrTwKoCpzoOydKaBURjzlzCAbFWe6sFp7thQgN4PWcGhEP3YoctK6P?=
 =?us-ascii?Q?xebrn3yOADgKWl0D169N9d6HMAHGZaPUqUcJGcJRhhPM7+uS7Wx4GoGy+9V4?=
 =?us-ascii?Q?CxJbszBlRWql1diBLbfdKUyGM/zE8LKhhZmrGCm3r5UIN1F3GyRKL/KHFFlF?=
 =?us-ascii?Q?8BL49KFqpReCS8OFW323iEzogCm92awx+Gh38xqaXclEknuz3JB1qN+kjCkC?=
 =?us-ascii?Q?BEt3kfgbvuxjW+lqZoKoW+S/rvvkrTRA/ZfSyZq/441OOTuTOs/g5UjggiR6?=
 =?us-ascii?Q?zv1PeXkDCGAKte9h6viUKV9rrlqRWocW4fyVMpjxOshgCDxTqBwiupnAx71Z?=
 =?us-ascii?Q?pV+ozurn5Xsxyw2aZgxzozwzFCuLxRduL6hu+XoxxT80QJECKu0WFger9iNL?=
 =?us-ascii?Q?p1wadBpPbmQMamNCA8Sh0FBUNyiWtaO5nVbexPhZHt5HdruUKBJHSJhnZYP/?=
 =?us-ascii?Q?i+VFre9Qg38XodzO11ONSN4V6gbiQjxESFWrXkGGrWFrdhHXafImUbINjWSg?=
 =?us-ascii?Q?g7QvK0lcDYSn83e1zALN/07NgA0Qbi0NZrZFwac3Ly11/tpUL6qgbOvcs30R?=
 =?us-ascii?Q?94paaNOBK8mxjwS73pp2X8txjp2ZPyIZ0UCKQFUmT3zNiu4Df2DzJep3WuKy?=
 =?us-ascii?Q?fbr4GGJdWForGVRRnBHRqWYQerQlo5vudCQgvExRTCiWUh2jDZGRGiRcahKQ?=
 =?us-ascii?Q?NX4iOouRrBn+Pn/NS7kmPUr4uzc6qqyDQq9lGwrzRAQDsLtOSIV5NiA0gqya?=
 =?us-ascii?Q?WPCFHIdMGuvXxTLnhMlfWW/osnA5AvY6gi692Diroiil+h3KxLLUG9VQmKQX?=
 =?us-ascii?Q?qlWSKJG5nQC/knnYx7S6hU6Qwiq5sV3o8EwB7QM8vPuvOOF3MyCoiI8HM/eN?=
 =?us-ascii?Q?HocAoYMtdb2KhuhUOz0u1VAn705DVFLC/UATt95fVtgu1KNhbAoYzpWXPqXa?=
 =?us-ascii?Q?QgqVJApvJrPCxBNdQaVZH9q1lMLiLmryumb+GvDkM9j0MLAkx1LzXg+DQCy+?=
 =?us-ascii?Q?5VfS6CR31WHzDtDziyWwF2D+NdS8HrKtb8at4FK9SHdc0fz5MlXBGS7pu+Rk?=
 =?us-ascii?Q?h5Ec7pN6WL06PZ+9IuSp+qILBWxKi6BkcKxWLBzeJz3CNrMgs260wEB3W/mk?=
 =?us-ascii?Q?IkSmPGQIFzyxGOpo7X0JRWTKN+8gau7t9MHf5jSwKEsL4YG43KlLGdSvIjTI?=
 =?us-ascii?Q?rM8C+oHUJi+5bOQ69S72dIwtBpyyvwtRnZADeQaapu8HXcXjFhzfCfh+7MrB?=
 =?us-ascii?Q?IkEBHceiZ2st4FABbYqMRHvKetD6tT/6Rz1rGE0ENmRIUn4ql6He0sfteWrC?=
 =?us-ascii?Q?srpayMMuqJpO5k7NV+Te5xr7Ogalbzq3Ouyw72ffMIZquDroxGkc0eMWu6ii?=
 =?us-ascii?Q?DphXJlEuhuM98Wg1tRsjxSbpPA9LKeoX4kiqF0ZA97hORatbJJsuvP7ySDMF?=
 =?us-ascii?Q?/z0esHMIy+zokUCzpq9X88m3RWDRxGUQ77FwL0Su6s4ToGFz99AIYfZyvi+m?=
 =?us-ascii?Q?G94NMCAQaVjjFAwih62utUCauPD9uqJZNKwm9VFO3TSrht5LOzbMmTWGpCjm?=
 =?us-ascii?Q?DS4cFckTG+zpJdixCZ/X7ZqwqnMbpr3fqzBjrl6K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e2224e-c6c0-42c9-e3ed-08dad217bd15
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 14:41:02.4599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a5vXraSo2u0vqMTc9qvGdJk+X86J7wym8E6vite7ZNmMxZaNp4NhjMKF14Etp3eyW9CGBt+BBrMQDnWAKpSjhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Akihiko Odaki
> Sent: Friday, November 25, 2022 7:01 PM
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yuri Benditovic=
h
> <yuri.benditovich@daynix.com>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Yan Vugenfirer <yan@daynix.com>; intel-
> wired-lan@lists.osuosl.org; Paolo Abeni <pabeni@redhat.com>; David S.
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net v4] igb: Allocate MSI-X vector when
> testing
>=20
> Without this change, the interrupt test fail with MSI-X environment:
>=20
> $ sudo ethtool -t enp0s2 offline
> [   43.921783] igb 0000:00:02.0: offline testing starting
> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 M=
bps
> Full Duplex, Flow Control: RX/TX
> [   51.272202] igb 0000:00:02.0: testing shared interrupt
> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 M=
bps
> Full Duplex, Flow Control: RX/TX
> The test result is FAIL
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 4
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
>=20
> Here, "4" means an expected interrupt was not delivered.
>=20
> To fix this, route IRQs correctly to the first MSI-X vector by setting
> IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be masked.=
 The
> interrupt test now runs properly with this change:
>=20
> $ sudo ethtool -t enp0s2 offline
> [   42.762985] igb 0000:00:02.0: offline testing starting
> [   50.141967] igb 0000:00:02.0: testing shared interrupt
> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 M=
bps
> Full Duplex, Flow Control: RX/TX
> The test result is PASS
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 0
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
>=20
> Fixes: 4eefa8f01314 ("igb: add single vector msi-x testing to interrupt t=
est")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> V3 -> V4: Added Fixes: tag
>=20
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
