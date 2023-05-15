Return-Path: <netdev+bounces-2808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DDA7040CC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D99A2813E0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731DB19E46;
	Mon, 15 May 2023 22:14:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AC81FBE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:14:51 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454A910E6D;
	Mon, 15 May 2023 15:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684188860; x=1715724860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T+t7QW3r6OlDpwQVxMFBx1aA5hfLLIN4u2rpgH40z7Y=;
  b=Wst/CdYz1m4Q26ar/G0qL+TeODIm9PudW0mAQABXpNhFC9ExbYs/1qyH
   PBGcMJK417/iq0EAIfJGae3brei5c8yVkPQHqIoliqo6RKHeRcK3co4om
   P08bIvlFFjpMZ2Y6W25EN521kc/72BDEbysXmqyBPvVR9TpXvCxhAcymO
   IldVpizVsH1y60ki7qVQRyRP70EcTm0qnurPPnSh881UeSLyJJ8+gWUHT
   51WQTzWR7jwccgyquMcLRCIAXj6zyE99VwgLb/f79xdjITlwovuhwZWYb
   R6Kyt7/g4r5QwYd9Jwh9/Tt0a4KrszV3cwOo86EVKRb7nJL3zlTKjKnr+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="416976533"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="416976533"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 15:08:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="734048487"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="734048487"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 15 May 2023 15:08:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:08:04 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 15:08:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 15:08:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 15:08:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF4loUt9KvZAQqdwDJXkM5qttflP9tlaAkFBavmc/G5XHy2Ej4zXzF/0OhYmwvDJIQNTLSgQCxc994lvS3Ew5rsq5ur86cViAFyx/fCsK93s3lFzvspETIXwWHzaueJqxtUvl9u5qTVsn8lNml6NexPgbc1Lgfo2Z3EwX3Ga5ekTZAOKJjrUt6d38UjUlZyu/REJIiJEcfIVAghZcFezCAVN2aZ2Wy5ihu40D3Aofc9kt9cIms2Vz9MhQ6AG9annsJ5BmFHRdCOdg838X0RGIJpq6hWbbh2atoMiBNmqIXMV53arULRemgkUYBVOFLP1g/Hnu/iOJtd/UwtYNuJaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iib3gE1FOdnYV1HB/6Geq4AtZx91ASgZX1y3qm3cLbU=;
 b=Cpnyn7fNJnukIO4QXW0vgNOzqaLa1hsjsW4c+mSF8LMZrhQ3esRVkQwMfzmhYruMbZqthxoixAYDRcEzGKNX9WSdw/VPkqvHdACZmHe74hBpHZ0b7f0v6hPoe4B8utRue5mj0B3VAyDl+r8puQAFELTFsNdL8IEuhjpw+fi/+EhzVe028A3Y9VkzczqfRJTFyS4BEfRb4K0ydfFxsY5GusbToX9VXrjx4hqK7IJs2618JBXu2L6lht300vV4XyhEjNfCKv5lyliY+Abv116dXgFvzzMj6ckxZt59MEvI7yhE4eOMrcwRy89XnslXdl0p6qsu8lvIBtsl2RCgtP28Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 22:07:57 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 22:07:57 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69If/yAgBOAjAA=
Date: Mon, 15 May 2023 22:07:57 +0000
Message-ID: <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com> <ZFJRIY1HM64gFo3a@nanopsycho>
In-Reply-To: <ZFJRIY1HM64gFo3a@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA0PR11MB4557:EE_
x-ms-office365-filtering-correlation-id: 8a15b3f6-d29d-4446-3379-08db5590d6e7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUpcLAJ6ohDZ0CsrjLmxuKBvkdak1ihKVaIAbA+KnfkU8wB0+gZ7mvV8ynkevP+htti84/HPAISh1QWCOdf4dCtlbJoUxTBq0hR5CMbRzaUX5qO50E+hg3mWDbbxuvA3dp0bF7VTAMfdsmP3g6NRQBraVkvQDQT1r23iD27AEkCIdHZAWIynUy2CBh9yD0Omj4muetjJZKymYiQabcFmOfGuZeY53RUIYpsuIvginvmSFZOOZ/RKasIkT8nFFG1Py148INXsWj3Deoiv2k89xu4VRder7XWuznIQ1Ll/cr+SzjF6lWLvBx2V04FLEWvo+f9/QuNhZT/3oRI89E1V6ztW1o5bTO7G7WG2G7EdnLTXPXGurVPcXNkOK7EKGHNAZ3gZMqB0Uqkwt50IGUjf7dP/GN6KVEg31SXp6smonobR0gO8lTHgLyMydeEu2r4u9AiGjFBlR27FMxlYzft815dcvO9sfgFQ808ZJPuljLx8tnCsnu1ikyrEMgbKglfUWSHIIejWX7YKj921zGJIouK7MnQAqljzlNdyjfHVlwTeLIncCW5Lnylwmm660skQfqBjT0XH5nn/7IO+AZUYhGsVx1ba+y5l2ETAAMIMZ/yW3ogD2GffaXmzGj8fRZxX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199021)(71200400001)(38070700005)(110136005)(478600001)(76116006)(64756008)(66476007)(66556008)(66946007)(7696005)(66446008)(54906003)(316002)(4326008)(86362001)(186003)(122000001)(82960400001)(55016003)(38100700002)(26005)(6506007)(52536014)(5660300002)(41300700001)(2906002)(7416002)(8676002)(8936002)(30864003)(33656002)(83380400001)(9686003)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gCCpI7RARe6TlOnXWRaYTU/6DoOrkh6lLoNvlkJkN0JMzNMzfk4Ixq/oQIu2?=
 =?us-ascii?Q?Zj21OvgmxBTLen11pYzh2RKM3I46o7CYBufyy5EYw0OSpBR7N64OsY1mp0/M?=
 =?us-ascii?Q?TT2HDQVtj3BUWEzRHQ7fH55xUCmq7mAlXt9DIxH/rHW3TMVVRopXc24+fP3n?=
 =?us-ascii?Q?ZuH8/CoaYHqB22Teni1e9VyhBjO9vdSiNpQKkWfo8ACDmSv/6gbhMcsooPg1?=
 =?us-ascii?Q?fyssCBVITRtMcxn/oVY//vxD866XAsExuMrA5dFPHylfVkp38WIw+OZDV4M/?=
 =?us-ascii?Q?bwici9XnNPINI0NY4HrtZQOu2EglvntiOZ2DB4KoBZxeBTezEFnc9EIcp5OS?=
 =?us-ascii?Q?Ey5cH9agu6k4fooS9mCUq8Jy4rvnzPbrDYX6l5yRVOfIuPMTTYjVAF8qMb3m?=
 =?us-ascii?Q?qvdsMLOG0mkfX/l0g149BUxDBkZHbAoX6KrJfuWV3WHfijGsRr3yUOGCnCaz?=
 =?us-ascii?Q?7POXN6X8U1rd890GzCRRpf+gi/0huKu2NPUJOhII2zDQBaD/L/N/rDTbdA9j?=
 =?us-ascii?Q?jxPMsTCbSe8/r4QSvu2mqOW0o8DeWe3Z6qLTQ+rHv2tSXI0na3o2GXaG24Ev?=
 =?us-ascii?Q?ejxp9WgP9MSsEoCoe1OeVpV8NOUP4X57J9SiTAoPNuvJ62aE6g4a2if9IUJv?=
 =?us-ascii?Q?92cnhbT94FtBFB93f0dA1QAV4Nl3MqllE7AmOjeX9Bnlgbd8jlKOrHYeHWt5?=
 =?us-ascii?Q?wfY+gtA1PtRBwieG/g5W6zMJL46/h6OyLXO9XJ9BpFNxPBp9C4e/wJR3PxxX?=
 =?us-ascii?Q?GAWScuwBrNZz493kYZDnrNjPMdfykgLhmUnrK+cORwokPDJi1h3jkkr9/qYI?=
 =?us-ascii?Q?62fAWzlL5opA8H2tHCcqZtBxp/YHVH+NqKbWBFYYfcyY7qCSkQeVahm2j01i?=
 =?us-ascii?Q?3DIDym3q+xvIS01XDJgBMgJWgFHca61jRWcnSkEUkyA4MDuxVeb+lrMkGnju?=
 =?us-ascii?Q?LE8ISnTatmAqbCg+k4fqgckPo4i/T9zqYKNAR7nrjen6qI9DSi/VqfmU6V6/?=
 =?us-ascii?Q?99ZUN62uCs96d5xsorrrv6Gl0hqfBvfIgW5/dspO9r6hFjq11NC/Szc4Wm4D?=
 =?us-ascii?Q?tNstRJRV8oz+yEZApt/miegHhGXKSdS+M4d1AHtFCdgPttKlic3PkYYCGzNi?=
 =?us-ascii?Q?mIBMGW1woR+rAjsQSObSboopA7nvbNmY74Zn8qQGaEpnl0HqkhcIviyiKiCA?=
 =?us-ascii?Q?zfY+0T03CnwDR5FvTw4iZl0KwpZcydvgAZlV/9IGB6gdtp/3CtUBjwVepP0p?=
 =?us-ascii?Q?RGHotYiZEYA5YpB1q6Zm1HLvf8vMq0rn7c4YtnOERXj69EIznPRPna7c44wX?=
 =?us-ascii?Q?xVhBuVFmSm6lzcBWFTQ38WIt3zNFucWWVxH3N4uAIrQL4EmPPb29vzYx8KL8?=
 =?us-ascii?Q?Q1NK1AM709TB3Ca8c4wxARF5ivsHdF+Z+n43r+wlqlNWx1vZMPvcVkJQk54W?=
 =?us-ascii?Q?gOeZDptycYniBb1k8ZBZkZGY3yfRytbsSzu4nL83ytmLmgBTr8wQTnfkSwC5?=
 =?us-ascii?Q?TwtQZTeah6xbkQw905FHltqOOKeLiCWPsnql0FNTekvwsgnMdZd1YPNI4q/I?=
 =?us-ascii?Q?hFwG4ZYsMoCmnKadkxpoJJblCNbKJG8n7KwnlAyA5a+rHSQwoorFIt+A31jm?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a15b3f6-d29d-4446-3379-08db5590d6e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 22:07:57.1648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STXqc0WGPwUaKl4k2/5QwrJh7FozDLEyIZaMgJ16WtxBrM7i3bpbs5jZfwMb2n1Z1URZ5t1j476YBnMnEhA7MPrTg5tvwSDc6aJsAv1nT+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, May 3, 2023 2:19 PM
>
>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>>Control over clock generation unit is required for further development
>>of Synchronous Ethernet feature. Interface provides ability to obtain
>>current state of a dpll, its sources and outputs which are pins, and
>>allows their configuration.
>>
>>Co-developed-by: Milena Olech <milena.olech@intel.com>
>>Signed-off-by: Milena Olech <milena.olech@intel.com>
>>Co-developed-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>---
>> drivers/net/ethernet/intel/Kconfig          |    1 +
>> drivers/net/ethernet/intel/ice/Makefile     |    3 +-
>> drivers/net/ethernet/intel/ice/ice.h        |    4 +
>> drivers/net/ethernet/intel/ice/ice_dpll.c   | 1929 +++++++++++++++++++
>> drivers/net/ethernet/intel/ice/ice_dpll.h   |  101 +
>> drivers/net/ethernet/intel/ice/ice_main.c   |    7 +
>> drivers/net/ethernet/intel/ice/ice_ptp_hw.c |   21 +-
>> drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  148 +-
>> 8 files changed, 2125 insertions(+), 89 deletions(-)  create mode
>>100644 drivers/net/ethernet/intel/ice/ice_dpll.c
>> create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
>>
>>diff --git a/drivers/net/ethernet/intel/Kconfig
>>b/drivers/net/ethernet/intel/Kconfig
>>index 9bc0a9519899..913dcf928d15 100644
>>--- a/drivers/net/ethernet/intel/Kconfig
>>+++ b/drivers/net/ethernet/intel/Kconfig
>>@@ -284,6 +284,7 @@ config ICE
>> 	select DIMLIB
>> 	select NET_DEVLINK
>> 	select PLDMFW
>>+	select DPLL
>> 	help
>> 	  This driver supports Intel(R) Ethernet Connection E800 Series of
>> 	  devices.  For more information on how to identify your adapter, go
>>diff --git a/drivers/net/ethernet/intel/ice/Makefile
>>b/drivers/net/ethernet/intel/ice/Makefile
>>index 5d89392f969b..6c198cd92d49 100644
>>--- a/drivers/net/ethernet/intel/ice/Makefile
>>+++ b/drivers/net/ethernet/intel/ice/Makefile
>>@@ -33,7 +33,8 @@ ice-y :=3D ice_main.o	\
>> 	 ice_lag.o	\
>> 	 ice_ethtool.o  \
>> 	 ice_repr.o	\
>>-	 ice_tc_lib.o
>>+	 ice_tc_lib.o	\
>>+	 ice_dpll.o
>> ice-$(CONFIG_PCI_IOV) +=3D	\
>> 	ice_sriov.o		\
>> 	ice_virtchnl.o		\
>>diff --git a/drivers/net/ethernet/intel/ice/ice.h
>>b/drivers/net/ethernet/intel/ice/ice.h
>>index 5736757039db..a71d46e41c01 100644
>>--- a/drivers/net/ethernet/intel/ice/ice.h
>>+++ b/drivers/net/ethernet/intel/ice/ice.h
>>@@ -74,6 +74,7 @@
>> #include "ice_lag.h"
>> #include "ice_vsi_vlan_ops.h"
>> #include "ice_gnss.h"
>>+#include "ice_dpll.h"
>>
>> #define ICE_BAR0		0
>> #define ICE_REQ_DESC_MULTIPLE	32
>>@@ -201,6 +202,7 @@
>> enum ice_feature {
>> 	ICE_F_DSCP,
>> 	ICE_F_PTP_EXTTS,
>>+	ICE_F_PHY_RCLK,
>> 	ICE_F_SMA_CTRL,
>> 	ICE_F_CGU,
>> 	ICE_F_GNSS,
>>@@ -512,6 +514,7 @@ enum ice_pf_flags {
>> 	ICE_FLAG_UNPLUG_AUX_DEV,
>> 	ICE_FLAG_MTU_CHANGED,
>> 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
>>+	ICE_FLAG_DPLL,			/* SyncE/PTP dplls initialized */
>> 	ICE_PF_FLAGS_NBITS		/* must be last */
>> };
>>
>>@@ -635,6 +638,7 @@ struct ice_pf {
>> #define ICE_VF_AGG_NODE_ID_START	65
>> #define ICE_MAX_VF_AGG_NODES		32
>> 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
>>+	struct ice_dplls dplls;
>> };
>>
>> struct ice_netdev_priv {
>>diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c
>>b/drivers/net/ethernet/intel/ice/ice_dpll.c
>>new file mode 100644
>>index 000000000000..3217fb36dd12
>>--- /dev/null
>>+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
>>@@ -0,0 +1,1929 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/* Copyright (C) 2022, Intel Corporation. */
>>+
>>+#include "ice.h"
>>+#include "ice_lib.h"
>>+#include "ice_trace.h"
>>+#include <linux/dpll.h>
>>+#include <uapi/linux/dpll.h>
>
>Don't include uapi directly. I'm pretty sure I had the same comment the
>last time as well.
>

Fixed, no idea how it is still there, thanks!

>
>>+
>>+#define ICE_CGU_STATE_ACQ_ERR_THRESHOLD	50
>>+#define ICE_DPLL_LOCK_TRIES		1000
>>+#define ICE_DPLL_PIN_IDX_INVALID	0xff
>>+
>>+/**
>>+ * dpll_lock_status - map ice cgu states into dpll's subsystem lock
>>+status  */ static const enum dpll_lock_status
>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] =3D {
>>+	[ICE_CGU_STATE_INVALID] =3D DPLL_LOCK_STATUS_UNSPEC,
>>+	[ICE_CGU_STATE_FREERUN] =3D DPLL_LOCK_STATUS_UNLOCKED,
>>+	[ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_CALIBRATING,
>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] =3D DPLL_LOCK_STATUS_LOCKED,
>>+	[ICE_CGU_STATE_HOLDOVER] =3D DPLL_LOCK_STATUS_HOLDOVER, };
>>+
>>+/**
>>+ * ice_dpll_pin_type - enumerate ice pin types  */ enum
>>+ice_dpll_pin_type {
>>+	ICE_DPLL_PIN_INVALID =3D 0,
>>+	ICE_DPLL_PIN_TYPE_SOURCE,
>>+	ICE_DPLL_PIN_TYPE_OUTPUT,
>>+	ICE_DPLL_PIN_TYPE_RCLK_SOURCE,
>>+};
>>+
>>+/**
>>+ * pin_type_name - string names of ice pin types  */ static const char
>>+* const pin_type_name[] =3D {
>>+	[ICE_DPLL_PIN_TYPE_SOURCE] =3D "source",
>>+	[ICE_DPLL_PIN_TYPE_OUTPUT] =3D "output",
>>+	[ICE_DPLL_PIN_TYPE_RCLK_SOURCE] =3D "rclk-source", };
>>+
>>+/**
>>+ * ice_find_pin_idx - find ice_dpll_pin index on a pf
>>+ * @pf: private board structure
>>+ * @pin: kernel's dpll_pin pointer to be searched for
>>+ * @pin_type: type of pins to be searched for
>>+ *
>>+ * Find and return internal ice pin index of a searched dpll subsystem
>>+ * pin pointer.
>>+ *
>>+ * Return:
>>+ * * valid index for a given pin & pin type found on pf internal dpll
>>+struct
>>+ * * ICE_DPLL_PIN_IDX_INVALID - if pin was not found.
>>+ */
>>+static u32
>>+ice_find_pin_idx(struct ice_pf *pf, const struct dpll_pin *pin,
>>+		 enum ice_dpll_pin_type pin_type)
>>+
>>+{
>>+	struct ice_dpll_pin *pins;
>>+	int pin_num, i;
>>+
>>+	if (!pin || !pf)
>
>How this can happen? If not, remove.
>

Makes sense, fixed.

>
>>+		return ICE_DPLL_PIN_IDX_INVALID;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		pins =3D pf->dplls.inputs;
>>+		pin_num =3D pf->dplls.num_inputs;
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		pins =3D pf->dplls.outputs;
>>+		pin_num =3D pf->dplls.num_outputs;
>>+	} else {
>>+		return ICE_DPLL_PIN_IDX_INVALID;
>>+	}
>>+
>>+	for (i =3D 0; i < pin_num; i++)
>>+		if (pin =3D=3D pins[i].pin)
>>+			return i;
>>+
>>+	return ICE_DPLL_PIN_IDX_INVALID;
>>+}
>>+
>>+/**
>>+ * ice_dpll_cb_lock - lock dplls mutex in callback context
>>+ * @pf: private board structure
>>+ *
>>+ * Lock the mutex from the callback operations invoked by dpll subsystem=
.
>>+ * Prevent dead lock caused by `rmmod ice` when dpll callbacks are
>>+under stress
>>+ * tests.
>>+ *
>>+ * Return:
>>+ * 0 - if lock acquired
>>+ * negative - lock not acquired or dpll was deinitialized  */ static
>>+int ice_dpll_cb_lock(struct ice_pf *pf)
>
>On many places you call this without saving the return value to int
>variable. You should do that and propagate the error value.
>

That is true, fixed.

>
>>+{
>>+	int i;
>>+
>>+	for (i =3D 0; i < ICE_DPLL_LOCK_TRIES; i++) {
>>+		if (mutex_trylock(&pf->dplls.lock))
>>+			return 0;
>>+		usleep_range(100, 150);
>>+		if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>>+			return -EFAULT;
>>+	}
>>+
>>+	return -EBUSY;
>>+}
>>+
>>+/**
>>+ * ice_dpll_cb_unlock - unlock dplls mutex in callback context
>>+ * @pf: private board structure
>>+ *
>>+ * Unlock the mutex from the callback operations invoked by dpll
>>subsystem.
>>+ */
>>+static void ice_dpll_cb_unlock(struct ice_pf *pf) {
>>+	mutex_unlock(&pf->dplls.lock);
>>+}
>>+
>>+/**
>>+ * ice_find_pin - find ice_dpll_pin on a pf
>>+ * @pf: private board structure
>>+ * @pin: kernel's dpll_pin pointer to be searched for
>>+ * @pin_type: type of pins to be searched for
>>+ *
>>+ * Find and return internal ice pin info pointer holding data of given
>>+dpll
>>+ * subsystem pin pointer.
>>+ *
>>+ * Return:
>>+ * * valid 'struct ice_dpll_pin'-type pointer - if given 'pin' pointer
>>+was
>>+ * found in pf internal pin data.
>>+ * * NULL - if pin was not found.
>>+ */
>>+static struct ice_dpll_pin
>>+*ice_find_pin(struct ice_pf *pf, const struct dpll_pin *pin,
>>+	      enum ice_dpll_pin_type pin_type)
>>+
>>+{
>>+	struct ice_dpll_pin *pins;
>>+	int pin_num, i;
>>+
>>+	if (!pin || !pf)
>>+		return NULL;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		pins =3D pf->dplls.inputs;
>>+		pin_num =3D pf->dplls.num_inputs;
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		pins =3D pf->dplls.outputs;
>>+		pin_num =3D pf->dplls.num_outputs;
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_RCLK_SOURCE) {
>>+		if (pin =3D=3D pf->dplls.rclk.pin)
>>+			return &pf->dplls.rclk;
>>+	} else {
>>+		return NULL;
>>+	}
>>+
>>+	for (i =3D 0; i < pin_num; i++)
>>+		if (pin =3D=3D pins[i].pin)
>>+			return &pins[i];
>>+
>>+	return NULL;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_freq_set - set pin's frequency
>>+ * @pf: private board structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being configured
>>+ * @freq: frequency to be set
>>+ *
>>+ * Set requested frequency on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error on AQ or wrong pin type given  */ static int
>>+ice_dpll_pin_freq_set(struct ice_pf *pf, struct ice_dpll_pin *pin,
>>+		      const enum ice_dpll_pin_type pin_type, const u32 freq) {
>>+	u8 flags;
>>+	int ret;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		flags =3D ICE_AQC_SET_CGU_IN_CFG_FLG1_UPDATE_FREQ;
>>+		ret =3D ice_aq_set_input_pin_cfg(&pf->hw, pin->idx, flags,
>>+					       pin->flags[0], freq, 0);
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		flags =3D pin->flags[0] | ICE_AQC_SET_CGU_OUT_CFG_UPDATE_FREQ;
>>+		ret =3D ice_aq_set_output_pin_cfg(&pf->hw, pin->idx, flags,
>>+						0, freq, 0);
>>+	} else {
>
>How exactly this can happen? If not, avoid it.
>And use switch-case for enum values
>

Sure, fixed.

>
>>+		ret =3D -EINVAL;
>>+	}
>>+
>>+	if (ret) {
>>+		dev_dbg(ice_pf_to_dev(pf),
>
>dev_err
>

True, fixed.

>
>>+			"err:%d %s failed to set pin freq:%u on pin:%u\n",
>>+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
>>+			freq, pin->idx);
>>+	} else {
>>+		pin->freq =3D freq;
>>+	}
>>+
>>+	return ret;
>
>Usual pattern is:
>	ret =3D something() //switch-case in this case
>	if (ret)
>		return ret;
>	return 0;
>Easier to follow.
>

Ok, fixed.

>
>>+}
>>+
>>+/**
>>+ * ice_dpll_frequency_set - wrapper for pin callback for set frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ * @pin_type: type of pin being configured
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw  */ static
>>+int ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll,
>>+		       const u32 frequency,
>>+		       struct netlink_ext_ack *extack,
>>+		       const enum ice_dpll_pin_type pin_type) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, pin_type);
>
>This does not make any sense to me. You should avoid the lookups and remov=
e
>ice_find_pin() function entirely. The purpose of having pin_priv is to
>carry the struct ice_dpll_pin * directly. You should pass it down during
>pin register.
>
>pf pointer is stored in dpll_priv.
>

In this case dpll_priv is not passed, so cannot use it.
But in general it makes sense I will hold pf inside of ice_dpll_pin
and fix this.

>
>>+	if (!p) {
>>+		NL_SET_ERR_MSG(extack, "pin not found");
>
>That would be very odd message the user would see :)
>

Removed.

>
>>+		goto unlock;
>>+	}
>>+
>>+	ret =3D ice_dpll_pin_freq_set(pf, p, pin_type, frequency);
>>+	if (ret)
>>+		NL_SET_ERR_MSG_FMT(extack, "freq not set, err:%d", ret);
>
>Why you need to print "ret"? It is propagated to the caller as a return
>value.
>

Removed.

>
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_frequency_set - source pin callback for set
>>+frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw  */ static
>>+int ice_dpll_source_frequency_set(const struct dpll_pin *pin, void
>>+*pin_priv,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 frequency, struct netlink_ext_ack *extack) {
>>+	return ice_dpll_frequency_set(pin, pin_priv, dpll, (u32)frequency,
>>+extack,
>
>Avoid the cast here, not needed.
>
>The dpll core should do check if user passes frequency which is supported,
>so you don't care about the overflow either.

Fixed.

>
>
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_frequency_set - output pin callback for set
>>+frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: frequency to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal set frequency command on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't set in hw  */ static
>>+int ice_dpll_output_frequency_set(const struct dpll_pin *pin, void
>>+*pin_priv,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 frequency, struct netlink_ext_ack *extack) {
>>+	return ice_dpll_frequency_set(pin, pin_priv, dpll, frequency, extack,
>>+				      ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_frequency_get - wrapper for pin callback for get frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ * @pin_type: type of pin being configured
>>+ *
>>+ * Wraps internal get frequency command of a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw  */ static
>>+int ice_dpll_frequency_get(const struct dpll_pin *pin, void *pin_priv,
>>+		       const struct dpll_device *dpll, u64 *frequency,
>>+		       struct netlink_ext_ack *extack,
>>+		       const enum ice_dpll_pin_type pin_type) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, pin_type);
>>+	if (!p) {
>>+		NL_SET_ERR_MSG(extack, "pin not found");
>>+		goto unlock;
>>+	}
>>+	*frequency =3D (u64)(p->freq);
>
>Drop the pointless cast.
>

Removed.

>
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_frequency_get - source pin callback for get
>>+frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal get frequency command of a source pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw  */ static
>>+int ice_dpll_source_frequency_get(const struct dpll_pin *pin, void
>>+*pin_priv,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 *frequency, struct netlink_ext_ack *extack) {
>>+	return ice_dpll_frequency_get(pin, pin_priv, dpll, frequency, extack,
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_frequency_get - output pin callback for get
>>+frequency
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: pointer to dpll
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @frequency: on success holds pin's frequency
>>+ * @extack: error reporting
>>+ *
>>+ * Wraps internal get frequency command of a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error pin not found or couldn't get from hw  */ static
>>+int ice_dpll_output_frequency_get(const struct dpll_pin *pin, void
>>+*pin_priv,
>>+			      const struct dpll_device *dpll, void *dpll_priv,
>>+			      u64 *frequency, struct netlink_ext_ack *extack) {
>>+	return ice_dpll_frequency_get(pin, pin_priv, dpll, frequency, extack,
>>+				      ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_enable - enable a pin on dplls
>>+ * @hw: board private hw structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being enabled
>>+ *
>>+ * Enable a pin on both dplls. Store current state in pin->flags.
>>+ *
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_enable(struct ice_hw *hw, struct ice_dpll_pin *pin,
>>+		    const enum ice_dpll_pin_type pin_type) {
>>+	u8 flags =3D pin->flags[0];
>>+	int ret;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		flags |=3D ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN;
>>+		ret =3D ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		flags |=3D ICE_AQC_SET_CGU_OUT_CFG_OUT_EN;
>>+		ret =3D ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
>>+	}
>
>switch-case
>

Fixed.

>
>>+	if (ret)
>>+		dev_dbg(ice_pf_to_dev((struct ice_pf *)(hw->back)),
>
>dev_err?
>

Fixed.

>
>>+			"err:%d %s failed to enable %s pin:%u\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status),
>>+			pin_type_name[pin_type], pin->idx);
>>+	else
>>+		pin->flags[0] =3D flags;
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_disable - disable a pin on dplls
>>+ * @hw: board private hw structure
>>+ * @pin: pointer to a pin
>>+ * @pin_type: type of pin being disabled
>>+ *
>>+ * Disable a pin on both dplls. Store current state in pin->flags.
>>+ *
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_disable(struct ice_hw *hw, struct ice_dpll_pin *pin,
>>+		     enum ice_dpll_pin_type pin_type) {
>>+	u8 flags =3D pin->flags[0];
>>+	int ret;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		flags &=3D ~(ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN);
>>+		ret =3D ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		flags &=3D ~(ICE_AQC_SET_CGU_OUT_CFG_OUT_EN);
>>+		ret =3D ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
>>+	}
>
>switch-case?
>

Fixed.

>
>>+	if (ret)
>>+		dev_dbg(ice_pf_to_dev((struct ice_pf *)(hw->back)),
>
>dev_err?
>

Fixed.

>
>>+			"err:%d %s failed to disable %s pin:%u\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status),
>>+			pin_type_name[pin_type], pin->idx);
>>+	else
>>+		pin->flags[0] =3D flags;
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_update - update pin's state
>>+ * @hw: private board struct
>>+ * @pin: structure with pin attributes to be updated
>>+ * @pin_type: type of pin being updated
>>+ *
>>+ * Determine pin current state and frequency, then update struct
>>+ * holding the pin info. For source pin states are separated for each
>>+ * dpll, for rclk pins states are separated for each parent.
>>+ *
>>+ * Return:
>>+ * * 0 - OK
>>+ * * negative - error
>>+ */
>>+int
>>+ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
>>+			  const enum ice_dpll_pin_type pin_type) {
>>+	int ret;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		ret =3D ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, NULL, NULL,
>>+					       NULL, &pin->flags[0],
>>+					       &pin->freq, NULL);
>>+		if (!!(ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN & pin->flags[0])) {
>
>Don't do "!!", it's not needed. You have this on multiple places. Please
>reduce.
>

Fixed.

>
>>+			if (pin->pin) {
>>+				pin->state[pf->dplls.eec.dpll_idx] =3D
>>+					pin->pin =3D=3D pf->dplls.eec.active_source ?
>>+					DPLL_PIN_STATE_CONNECTED :
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+				pin->state[pf->dplls.pps.dpll_idx] =3D
>>+					pin->pin =3D=3D pf->dplls.pps.active_source ?
>>+					DPLL_PIN_STATE_CONNECTED :
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+			} else {
>>+				pin->state[pf->dplls.eec.dpll_idx] =3D
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+				pin->state[pf->dplls.pps.dpll_idx] =3D
>>+					DPLL_PIN_STATE_SELECTABLE;
>>+			}
>>+		} else {
>>+			pin->state[pf->dplls.eec.dpll_idx] =3D
>>+				DPLL_PIN_STATE_DISCONNECTED;
>>+			pin->state[pf->dplls.pps.dpll_idx] =3D
>>+				DPLL_PIN_STATE_DISCONNECTED;
>>+		}
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		ret =3D ice_aq_get_output_pin_cfg(&pf->hw, pin->idx,
>>+						&pin->flags[0], NULL,
>>+						&pin->freq, NULL);
>>+		if (!!(ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0]))
>>+			pin->state[0] =3D DPLL_PIN_STATE_CONNECTED;
>>+		else
>>+			pin->state[0] =3D DPLL_PIN_STATE_DISCONNECTED;
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_RCLK_SOURCE) {
>>+		u8 parent, port_num =3D ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT;
>>+
>>+		for (parent =3D 0; parent < pf->dplls.rclk.num_parents;
>>+		     parent++) {
>>+			ret =3D ice_aq_get_phy_rec_clk_out(&pf->hw, parent,
>>+							 &port_num,
>>+							 &pin->flags[parent],
>>+							 &pin->freq);
>>+			if (ret)
>>+				return ret;
>>+			if (!!(ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN &
>>+			       pin->flags[parent]))
>>+				pin->state[parent] =3D DPLL_PIN_STATE_CONNECTED;
>>+			else
>>+				pin->state[parent] =3D
>>+					DPLL_PIN_STATE_DISCONNECTED;
>>+		}
>>+	}
>
>Perhaps:
>
>	switch (pin_type) {
>	case ICE_DPLL_PIN_TYPE_SOURCE:
>		..
>	case ICE_DPLL_PIN_TYPE_OUTPUT:
>		..
>
>?

Fixed.

>
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_find_dpll - find ice_dpll on a pf
>>+ * @pf: private board structure
>>+ * @dpll: kernel's dpll_device pointer to be searched
>>+ *
>>+ * Return:
>>+ * * pointer if ice_dpll with given device dpll pointer is found
>>+ * * NULL if not found
>>+ */
>>+static struct ice_dpll
>>+*ice_find_dpll(struct ice_pf *pf, const struct dpll_device *dpll) {
>>+	if (!pf || !dpll)
>>+		return NULL;
>>+
>>+	return dpll =3D=3D pf->dplls.eec.dpll ? &pf->dplls.eec :
>>+	       dpll =3D=3D pf->dplls.pps.dpll ? &pf->dplls.pps : NULL; }
>>+
>>+/**
>>+ * ice_dpll_hw_source_prio_set - set source priority value in hardware
>>+ * @pf: board private structure
>>+ * @dpll: ice dpll pointer
>>+ * @pin: ice pin pointer
>>+ * @prio: priority value being set on a dpll
>>+ *
>>+ * Internal wrapper for setting the priority in the hardware.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int
>>+ice_dpll_hw_source_prio_set(struct ice_pf *pf, struct ice_dpll *dpll,
>>+			    struct ice_dpll_pin *pin, const u32 prio) {
>>+	int ret;
>>+
>>+	ret =3D ice_aq_set_cgu_ref_prio(&pf->hw, dpll->dpll_idx, pin->idx,
>>+				      (u8)prio);
>>+	if (ret)
>>+		dev_dbg(ice_pf_to_dev(pf),
>
>dev_err
>

Fixed.

>
>>+			"err:%d %s failed to set pin prio:%u on pin:%u\n",
>>+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
>>+			prio, pin->idx);
>>+	else
>>+		dpll->input_prio[pin->idx] =3D prio;
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_lock_status_get - get dpll lock status callback
>>+ * @dpll: registered dpll pointer
>>+ * @status: on success holds dpll's lock status
>>+ *
>>+ * Dpll subsystem callback, provides dpll's lock status.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_lock_status_get(const struct dpll_device *dpll, void
>>*priv,
>>+				    enum dpll_lock_status *status,
>>+				    struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D priv;
>>+	struct ice_dpll *d;
>>+
>>+	if (!pf)
>>+		return -EINVAL;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	d =3D ice_find_dpll(pf, dpll);
>
>Another example of odd and unneeded lookup. Register dpll device with
>struct ice_dpll *d as a priv. Store pf pointer there in struct ice_dpll.
>And remove ice_find_dpll() entirely.
>

Fixed.

>
>
>>+	if (!d)
>>+		return -EFAULT;
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pf:%p\n", __func__, dpll, pf);
>>+	*status =3D ice_dpll_status[d->dpll_state];
>>+	ice_dpll_cb_unlock(pf);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_mode_get - get dpll's working mode
>>+ * @dpll: registered dpll pointer
>>+ * @priv: private data pointer passed on dpll registration
>>+ * @mode: on success holds current working mode of dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Provides working mode of dpll.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_mode_get(const struct dpll_device *dpll, void *priv,
>>+			     enum dpll_mode *mode,
>>+			     struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D priv;
>>+	struct ice_dpll *d;
>>+
>>+	if (!pf)
>>+		return -EINVAL;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	d =3D ice_find_dpll(pf, dpll);
>>+	ice_dpll_cb_unlock(pf);
>>+	if (!d)
>>+		return -EFAULT;
>>+	*mode =3D DPLL_MODE_AUTOMATIC;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_mode_get - check if dpll's working mode is supported
>>+ * @dpll: registered dpll pointer
>>+ * @priv: private data pointer passed on dpll registration
>>+ * @mode: mode to be checked for support
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Provides information if working mode is
>>+supported
>>+ * by dpll.
>>+ *
>>+ * Return:
>>+ * * true - mode is supported
>>+ * * false - mode is not supported
>>+ */
>>+static bool ice_dpll_mode_supported(const struct dpll_device *dpll, void
>>*priv,
>>+				    const enum dpll_mode mode,
>>+				    struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D priv;
>>+	struct ice_dpll *d;
>>+
>>+	if (!pf)
>>+		return false;
>>+
>>+	if (ice_dpll_cb_lock(pf))
>>+		return false;
>>+	d =3D ice_find_dpll(pf, dpll);
>>+	ice_dpll_cb_unlock(pf);
>>+	if (!d)
>>+		return false;
>>+	if (mode =3D=3D DPLL_MODE_AUTOMATIC)
>>+		return true;
>>+
>>+	return false;
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_set - set pin's state on dpll
>>+ * @dpll: dpll being configured
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ * @pin_type: type of a pin
>>+ *
>>+ * Set pin state on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - OK or no change required
>>+ * * negative - error
>>+ */
>>+static int
>>+ice_dpll_pin_state_set(const struct dpll_device *dpll,
>>+		       const struct dpll_pin *pin, void *pin_priv,
>>+		       const enum dpll_pin_state state,
>
>Why you use const with enums?
>

Just show usage intention explicitly.

>
>>+		       struct netlink_ext_ack *extack,
>>+		       const enum ice_dpll_pin_type pin_type) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, pin_type);
>>+	if (!p)
>>+		goto unlock;
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		if (state =3D=3D DPLL_PIN_STATE_SELECTABLE)
>>+			ret =3D ice_dpll_pin_enable(&pf->hw, p, pin_type);
>>+		else if (state =3D=3D DPLL_PIN_STATE_DISCONNECTED)
>>+			ret =3D ice_dpll_pin_disable(&pf->hw, p, pin_type);
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		if (state =3D=3D DPLL_PIN_STATE_CONNECTED)
>>+			ret =3D ice_dpll_pin_enable(&pf->hw, p, pin_type);
>>+		else if (state =3D=3D DPLL_PIN_STATE_DISCONNECTED)
>>+			ret =3D ice_dpll_pin_disable(&pf->hw, p, pin_type);
>
>switch-case?
>
>Perhaps it would be nicer to do this in ice_dpll_output_state_set() and
>ice_dpll_source_state_set() directly?
>

Sure makes sense, fixed.

>
>>+	}
>>+	if (!ret)
>>+		ret =3D ice_dpll_pin_state_update(pf, p, pin_type);
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf),
>
>dev_err in case ret !=3D 0 ?
>

Fixed.

>
>>+		"%s: dpll:%p, pin:%p, p:%p pf:%p state: %d ret:%d\n",
>>+		__func__, dpll, pin, p, pf, state, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_state_set - enable/disable output pin on dpll
>>+device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: dpll being configured
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Set given state on output type pin.
>>+ *
>>+ * Return:
>>+ * * 0 - successfully enabled mode
>>+ * * negative - failed to enable mode
>>+ */
>>+static int ice_dpll_output_state_set(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     const enum dpll_pin_state state,
>>+				     struct netlink_ext_ack *extack) {
>>+	return ice_dpll_pin_state_set(dpll, pin, pin_priv, state, extack,
>>+				      ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_state_set - enable/disable source pin on dpll
>>+levice
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: dpll being configured
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: state of pin to be set
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Enables given mode on source type pin.
>>+ *
>>+ * Return:
>>+ * * 0 - successfully enabled mode
>>+ * * negative - failed to enable mode
>>+ */
>>+static int ice_dpll_source_state_set(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     const enum dpll_pin_state state,
>>+				     struct netlink_ext_ack *extack) {
>>+	return ice_dpll_pin_state_set(dpll, pin, pin_priv, state, extack,
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>>+}
>>+
>>+/**
>>+ * ice_dpll_pin_state_get - set pin's state on dpll
>>+ * @dpll: registered dpll pointer
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ * @pin_type: type of questioned pin
>>+ *
>>+ * Determine pin state set it on a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int
>>+ice_dpll_pin_state_get(const struct dpll_device *dpll,
>>+		       const struct dpll_pin *pin, void *pin_priv,
>>+		       enum dpll_pin_state *state,
>>+		       struct netlink_ext_ack *extack,
>>+		       const enum ice_dpll_pin_type pin_type) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll_pin *p;
>>+	struct ice_dpll *d;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, pin_type);
>>+	if (!p) {
>>+		NL_SET_ERR_MSG(extack, "pin not found");
>>+		goto unlock;
>>+	}
>>+	d =3D ice_find_dpll(pf, dpll);
>>+	if (!d)
>>+		goto unlock;
>>+	ret =3D ice_dpll_pin_state_update(pf, p, pin_type);
>>+	if (ret)
>>+		goto unlock;
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE)
>>+		*state =3D p->state[d->dpll_idx];
>>+	else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT)
>>+		*state =3D p->state[0];
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"%s: dpll:%p, pin:%p, pf:%p state: %d ret:%d\n",
>>+		__func__, dpll, pin, pf, *state, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_output_state_get - get output pin state on dpll device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Check state of a pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int ice_dpll_output_state_get(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     enum dpll_pin_state *state,
>>+				     struct netlink_ext_ack *extack) {
>>+	return ice_dpll_pin_state_get(dpll, pin, pin_priv, state, extack,
>>+				      ICE_DPLL_PIN_TYPE_OUTPUT);
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_state_get - get source pin state on dpll device
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @state: on success holds state of the pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Check state of a source pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failed to get state
>>+ */
>>+static int ice_dpll_source_state_get(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     enum dpll_pin_state *state,
>>+				     struct netlink_ext_ack *extack) {
>>+	return ice_dpll_pin_state_get(dpll, pin, pin_priv, state, extack,
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_prio_get - get dpll's source prio
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @prio: on success - returns source priority on dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting priority of a source pin=
.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_source_prio_get(const struct dpll_pin *pin, void
>>*pin_priv,
>>+				    const struct dpll_device *dpll,
>>+				    void *dpll_priv, u32 *prio,
>>+				    struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll *d =3D NULL;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_SOURCE);
>>+	if (!p) {
>>+		NL_SET_ERR_MSG(extack, "pin not found");
>>+		goto unlock;
>>+	}
>>+	d =3D ice_find_dpll(pf, dpll);
>>+	if (!d) {
>>+		NL_SET_ERR_MSG(extack, "dpll not found");
>>+		goto unlock;
>>+	}
>>+	*prio =3D d->input_prio[p->idx];
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, dpll, pin, pf, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_prio_set - set dpll source prio
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @prio: source priority to be set on dpll
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for setting priority of a source pin=
.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_source_prio_set(const struct dpll_pin *pin, void
>>*pin_priv,
>>+				    const struct dpll_device *dpll,
>>+				    void *dpll_priv, u32 prio,
>>+				    struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll *d =3D NULL;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+
>>+	if (prio > ICE_DPLL_PRIO_MAX) {
>>+		NL_SET_ERR_MSG(extack, "prio out of range");
>>+		return ret;
>>+	}
>>+
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_SOURCE);
>>+	if (!p) {
>>+		NL_SET_ERR_MSG(extack, "pin not found");
>>+		goto unlock;
>>+	}
>>+	d =3D ice_find_dpll(pf, dpll);
>>+	if (!d) {
>>+		NL_SET_ERR_MSG(extack, "dpll not found");
>>+		goto unlock;
>>+	}
>>+	ret =3D ice_dpll_hw_source_prio_set(pf, d, p, prio);
>>+	if (ret)
>>+		NL_SET_ERR_MSG_FMT(extack, "unable to set prio: %d", ret);
>
>Why you need to print "ret"? It is propagated to the caller as a return
>value.
>

Fixed.

>
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, dpll, pin, pf, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_direction - callback for get source pin direction
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @direction: holds source pin direction
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting direction of a source pi=
n.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ */
>>+static int ice_dpll_source_direction(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     enum dpll_pin_direction *direction,
>>+				     struct netlink_ext_ack *extack) {
>>+	*direction =3D DPLL_PIN_DIRECTION_SOURCE;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_source_direction - callback for get output pin direction
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @dpll: registered dpll pointer
>>+ * @dpll_priv: private data pointer passed on dpll registration
>>+ * @direction: holds output pin direction
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback. Handler for getting direction of an output p=
in.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ */
>>+static int ice_dpll_output_direction(const struct dpll_pin *pin,
>>+				     void *pin_priv,
>>+				     const struct dpll_device *dpll,
>>+				     void *dpll_priv,
>>+				     enum dpll_pin_direction *direction,
>>+				     struct netlink_ext_ack *extack) {
>>+	*direction =3D DPLL_PIN_DIRECTION_OUTPUT;
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_rclk_state_on_pin_set - set a state on rclk pin
>>+ * @dpll: registered dpll pointer
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @parent_pin: pin parent pointer
>>+ * @state: state to be set on pin
>>+ * @extack: error reporting
>>+ *
>>+ * Dpll subsystem callback, set a state of a rclk pin on a parent pin
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>>+ */
>>+static int ice_dpll_rclk_state_on_pin_set(const struct dpll_pin *pin,
>>+					  void *pin_priv,
>>+					  const struct dpll_pin *parent_pin,
>>+					  const enum dpll_pin_state state,
>>+					  struct netlink_ext_ack *extack) {
>>+	bool enable =3D state =3D=3D DPLL_PIN_STATE_CONNECTED ? true : false;
>>+	u32 parent_idx, hw_idx =3D ICE_DPLL_PIN_IDX_INVALID, i;
>>+	struct ice_pf *pf =3D pin_priv;
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EINVAL;
>>+
>>+	if (!pf)
>>+		return ret;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
>>+	if (!p) {
>>+		ret =3D -EFAULT;
>>+		goto unlock;
>>+	}
>>+	parent_idx =3D ice_find_pin_idx(pf, parent_pin,
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>
>Again, this does not make sense. You need struct ice_dpll_pin * related to
>parent. That should be parent priv and passed to dpll subsystem during
>registration and put as an "void * parent_pin_priv" arg to
>.state_on_pin_set() op. Whenever you do lookup like this, it is most
>usually wrong.
>

Fixed.

>
>
>>+	if (parent_idx =3D=3D ICE_DPLL_PIN_IDX_INVALID) {
>>+		ret =3D -EFAULT;
>>+		goto unlock;
>>+	}
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++)
>>+		if (pf->dplls.rclk.parent_idx[i] =3D=3D parent_idx)
>
>Can't you just store idx in struct ice_dpll_pin to avoid lookups like this
>one?
>

Fixed.

>
>>+			hw_idx =3D i;
>>+	if (hw_idx =3D=3D ICE_DPLL_PIN_IDX_INVALID)
>>+		goto unlock;
>>+
>>+	if ((enable && !!(p->flags[hw_idx] &
>>+			 ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN)) ||
>>+	    (!enable && !(p->flags[hw_idx] &
>>+			  ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN))) {
>>+		ret =3D -EINVAL;
>>+		goto unlock;
>>+	}
>>+	ret =3D ice_aq_set_phy_rec_clk_out(&pf->hw, hw_idx, enable,
>>+					 &p->freq);
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: parent:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, parent_pin, pin, pf, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_rclk_state_on_pin_get - get a state of rclk pin
>>+ * @pin: pointer to a pin
>>+ * @pin_priv: private data pointer passed on pin registration
>>+ * @parent_pin: pin parent pointer
>>+ * @state: on success holds pin state on parent pin
>>+ * @extack: error reporting
>>+ *
>>+ * dpll subsystem callback, get a state of a recovered clock pin.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - failure
>
>I wonder how valuable this return values table is for a reader.
>Not much I suppose. Do you need it in comments to all the functions you
>have here?
>

0 is success - most impoertant. I will leave those as is.

>
>>+ */
>>+static int ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin,
>>+					  void *pin_priv,
>>+					  const struct dpll_pin *parent_pin,
>>+					  enum dpll_pin_state *state,
>>+					  struct netlink_ext_ack *extack) {
>>+	struct ice_pf *pf =3D pin_priv;
>>+	u32 parent_idx, hw_idx =3D ICE_DPLL_PIN_IDX_INVALID, i;
>
>Reverse christmas tree ordering please.

Fixed.

>
>
>>+	struct ice_dpll_pin *p;
>>+	int ret =3D -EFAULT;
>>+
>>+	if (!pf)
>
>How exacly this can happen. My wild guess is it can't. Don't do such
>pointless checks please, confuses the reader.
>

From driver perspective the pf pointer value is given by external entity,
why shouldn't it be valdiated?

>
>>+		return ret;
>>+	if (ice_dpll_cb_lock(pf))
>>+		return -EBUSY;
>>+	p =3D ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
>>+	if (!p)
>>+		goto unlock;
>>+	parent_idx =3D ice_find_pin_idx(pf, parent_pin,
>>+				      ICE_DPLL_PIN_TYPE_SOURCE);
>>+	if (parent_idx =3D=3D ICE_DPLL_PIN_IDX_INVALID)
>>+		goto unlock;
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++)
>>+		if (pf->dplls.rclk.parent_idx[i] =3D=3D parent_idx)
>>+			hw_idx =3D i;
>>+	if (hw_idx =3D=3D ICE_DPLL_PIN_IDX_INVALID)
>>+		goto unlock;
>>+
>>+	ret =3D ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_RCLK_SOURCE)=
;
>>+	if (ret)
>>+		goto unlock;
>>+
>>+	if (!!(p->flags[hw_idx] &
>>+	    ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN))
>
>Avoid needless "!!".
>

Fixed.

>
>>+		*state =3D DPLL_PIN_STATE_CONNECTED;
>>+	else
>>+		*state =3D DPLL_PIN_STATE_DISCONNECTED;
>
>Use ternary operator perhaps?
>

Fixed.

>
>>+	ret =3D 0;
>>+unlock:
>>+	ice_dpll_cb_unlock(pf);
>>+	dev_dbg(ice_pf_to_dev(pf), "%s: parent:%p, pin:%p, pf:%p ret:%d\n",
>>+		__func__, parent_pin, pin, pf, ret);
>>+
>>+	return ret;
>>+}
>>+
>>+static struct dpll_pin_ops ice_dpll_rclk_ops =3D {
>
>const.
>

Fixed.

>
>>+	.state_on_pin_set =3D ice_dpll_rclk_state_on_pin_set,
>>+	.state_on_pin_get =3D ice_dpll_rclk_state_on_pin_get,
>>+	.direction_get =3D ice_dpll_source_direction, };
>>+
>>+static struct dpll_pin_ops ice_dpll_source_ops =3D {
>
>const.
>

Fixed.

>
>>+	.frequency_get =3D ice_dpll_source_frequency_get,
>>+	.frequency_set =3D ice_dpll_source_frequency_set,
>>+	.state_on_dpll_get =3D ice_dpll_source_state_get,
>>+	.state_on_dpll_set =3D ice_dpll_source_state_set,
>>+	.prio_get =3D ice_dpll_source_prio_get,
>>+	.prio_set =3D ice_dpll_source_prio_set,
>>+	.direction_get =3D ice_dpll_source_direction, };
>>+
>>+static struct dpll_pin_ops ice_dpll_output_ops =3D {
>
>const.
>

Fixed.

>>+	.frequency_get =3D ice_dpll_output_frequency_get,
>>+	.frequency_set =3D ice_dpll_output_frequency_set,
>>+	.state_on_dpll_get =3D ice_dpll_output_state_get,
>>+	.state_on_dpll_set =3D ice_dpll_output_state_set,
>>+	.direction_get =3D ice_dpll_output_direction, };
>>+
>>+static struct dpll_device_ops ice_dpll_ops =3D {
>
>const.
>

Fixed.

>
>>+	.lock_status_get =3D ice_dpll_lock_status_get,
>>+	.mode_get =3D ice_dpll_mode_get,
>>+	.mode_supported =3D ice_dpll_mode_supported, };
>>+
>>+/**
>>+ * ice_dpll_release_info - release memory allocated for pins
>>+ * @pf: board private structure
>>+ *
>>+ * Release memory allocated for pins by ice_dpll_init_info function.
>>+ */
>>+static void ice_dpll_release_info(struct ice_pf *pf) {
>>+	kfree(pf->dplls.inputs);
>>+	pf->dplls.inputs =3D NULL;
>>+	kfree(pf->dplls.outputs);
>>+	pf->dplls.outputs =3D NULL;
>>+	kfree(pf->dplls.eec.input_prio);
>>+	pf->dplls.eec.input_prio =3D NULL;
>>+	kfree(pf->dplls.pps.input_prio);
>>+	pf->dplls.pps.input_prio =3D NULL;
>>+}
>>+
>>+/**
>>+ * ice_dpll_release_rclk_pin - release rclk pin from its parents
>>+ * @pf: board private structure
>>+ *
>>+ * Deregister from parent pins and release resources in dpll subsystem.
>>+ */
>>+static void
>>+ice_dpll_release_rclk_pin(struct ice_pf *pf) {
>>+	struct ice_dpll_pin *rclk =3D &pf->dplls.rclk;
>>+	struct dpll_pin *parent;
>>+	int i;
>>+
>>+	for (i =3D 0; i < rclk->num_parents; i++) {
>>+		parent =3D pf->dplls.inputs[rclk->parent_idx[i]].pin;
>>+		if (!parent)
>>+			continue;
>>+		dpll_pin_on_pin_unregister(parent, rclk->pin,
>>+					   &ice_dpll_rclk_ops, pf);
>>+	}
>>+	dpll_pin_put(rclk->pin);
>>+	rclk->pin =3D NULL;
>>+}
>>+
>>+/**
>>+ * ice_dpll_release_pins - release pin's from dplls registered in
>>+subsystem
>>+ * @pf: board private structure
>>+ * @dpll_eec: dpll_eec dpll pointer
>>+ * @dpll_pps: dpll_pps dpll pointer
>>+ * @pins: pointer to pins array
>>+ * @count: number of pins
>>+ * @ops: callback ops registered with the pins
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Deregister and free pins of a given array of pins from dpll devices
>>+ * registered in dpll subsystem.
>>+ */
>>+static void
>>+ice_dpll_release_pins(struct ice_pf *pf, struct dpll_device *dpll_eec,
>>+		      struct dpll_device *dpll_pps, struct ice_dpll_pin *pins,
>>+		      int count, struct dpll_pin_ops *ops, bool cgu) {
>>+	int i;
>>+
>>+	for (i =3D 0; i < count; i++) {
>>+		struct ice_dpll_pin *p =3D &pins[i];
>>+
>>+		if (p && !IS_ERR_OR_NULL(p->pin)) {
>>+			if (cgu && dpll_eec)
>>+				dpll_pin_unregister(dpll_eec, p->pin, ops, pf);
>>+			if (cgu && dpll_pps)
>>+				dpll_pin_unregister(dpll_pps, p->pin, ops, pf);
>>+			dpll_pin_put(p->pin);
>>+			p->pin =3D NULL;
>>+		}
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_register_pins - register pins with a dpll
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Register source or output pins within given DPLL in a Linux dpll
>>subsystem.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error
>>+ */
>>+static int ice_dpll_register_pins(struct ice_pf *pf, bool cgu) {
>>+	struct device *dev =3D ice_pf_to_dev(pf);
>>+	struct ice_dpll_pin *pins;
>>+	struct dpll_pin_ops *ops;
>>+	u32 rclk_idx;
>>+	int ret, i;
>>+
>>+	ops =3D &ice_dpll_source_ops;
>>+	pins =3D pf->dplls.inputs;
>>+	for (i =3D 0; i < pf->dplls.num_inputs; i++) {
>>+		pins[i].pin =3D dpll_pin_get(pf->dplls.clock_id, i,
>>+					   THIS_MODULE, &pins[i].prop);
>>+		if (IS_ERR_OR_NULL(pins[i].pin)) {
>
>How exactly dpll_pin_get() can return NULL? It can't, use IS_ERR.
>Same in ice_dpll_release_pins() and two occurances below.
>

Fixed.

>
>
>>+			pins[i].pin =3D NULL;
>>+			return -ENOMEM;
>>+		}
>>+		if (cgu) {
>>+			ret =3D dpll_pin_register(pf->dplls.eec.dpll,
>>+						pins[i].pin,
>>+						ops, pf, NULL);
>>+			if (ret)
>>+				return ret;
>>+			ret =3D dpll_pin_register(pf->dplls.pps.dpll,
>>+						pins[i].pin,
>>+						ops, pf, NULL);
>>+			if (ret)
>>+				return ret;
>
>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..)
>here.
>

No, in case of error, the caller releases everything ice_dpll_release_all(.=
.).

>
>>+		}
>>+	}
>>+	if (cgu) {
>>+		ops =3D &ice_dpll_output_ops;
>>+		pins =3D pf->dplls.outputs;
>>+		for (i =3D 0; i < pf->dplls.num_outputs; i++) {
>>+			pins[i].pin =3D dpll_pin_get(pf->dplls.clock_id,
>>+						   i + pf->dplls.num_inputs,
>>+						   THIS_MODULE, &pins[i].prop);
>>+			if (IS_ERR_OR_NULL(pins[i].pin)) {
>>+				pins[i].pin =3D NULL;
>>+				return -ENOMEM;
>
>Don't make up error values when you get them from the function you call:
>	return PTR_ERR(pins[i].pin);

Fixed.

>
>>+			}
>>+			ret =3D dpll_pin_register(pf->dplls.eec.dpll, pins[i].pin,
>>+						ops, pf, NULL);
>>+			if (ret)
>>+				return ret;
>>+			ret =3D dpll_pin_register(pf->dplls.pps.dpll, pins[i].pin,
>>+						ops, pf, NULL);
>>+			if (ret)
>>+				return ret;
>
>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..)
>here.
>

As above, in case of error, the caller releases everything.

>
>>+                                              ops, pf, NULL);
>
>
>>+		}
>>+	}
>>+	rclk_idx =3D pf->dplls.num_inputs + pf->dplls.num_outputs + pf-
>>hw.pf_id;
>>+	pf->dplls.rclk.pin =3D dpll_pin_get(pf->dplls.clock_id, rclk_idx,
>>+					  THIS_MODULE, &pf->dplls.rclk.prop);
>>+	if (IS_ERR_OR_NULL(pf->dplls.rclk.pin)) {
>>+		pf->dplls.rclk.pin =3D NULL;
>>+		return -ENOMEM;
>
>Don't make up error values when you get them from the function you call:
>	return PTR_ERR(pf->dplls.rclk.pin);
>

Fixed.

>
>>+	}
>>+	ops =3D &ice_dpll_rclk_ops;
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++) {
>>+		struct dpll_pin *parent =3D
>>+			pf->dplls.inputs[pf->dplls.rclk.parent_idx[i]].pin;
>>+
>>+		ret =3D dpll_pin_on_pin_register(parent, pf->dplls.rclk.pin,
>>+					       ops, pf, dev);
>>+		if (ret)
>>+			return ret;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_generate_clock_id - generates unique clock_id for registering dpl=
l.
>>+ * @pf: board private structure
>>+ * @clock_id: holds generated clock_id
>>+ *
>>+ * Generates unique (per board) clock_id for allocation and search of
>>+dpll
>>+ * devices in Linux dpll subsystem.
>>+ */
>>+static void ice_generate_clock_id(struct ice_pf *pf, u64 *clock_id) {
>>+	*clock_id =3D pci_get_dsn(pf->pdev);
>>+}
>
>How about:
>
>static u64 ice_generate_clock_id(struct ice_pf *pf) {
>	return pci_get_dsn(pf->pdev);
>}
>
>??
>

Fixed.

>
>>+
>>+/**
>>+ * ice_dpll_init_dplls
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Get dplls instances for this board, if cgu is controlled by this
>>+NIC,
>>+ * register dpll with callbacks ops
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - allocation fails
>>+ */
>>+static int ice_dpll_init_dplls(struct ice_pf *pf, bool cgu) {
>>+	struct device *dev =3D ice_pf_to_dev(pf);
>>+	int ret =3D -ENOMEM;
>>+	u64 clock_id;
>>+
>>+	ice_generate_clock_id(pf, &clock_id);
>>+	pf->dplls.eec.dpll =3D dpll_device_get(clock_id, pf-
>>dplls.eec.dpll_idx,
>>+					     THIS_MODULE);
>>+	if (!pf->dplls.eec.dpll) {
>
>You have to use IS_ERR()
>

Fixed.

>
>>+		dev_err(ice_pf_to_dev(pf), "dpll_device_get failed (eec)\n");
>>+		return ret;
>>+	}
>>+	pf->dplls.pps.dpll =3D dpll_device_get(clock_id, pf-
>>dplls.pps.dpll_idx,
>>+					     THIS_MODULE);
>>+	if (!pf->dplls.pps.dpll) {
>
>You have to use IS_ERR()
>

Fixed.

>
>>+		dev_err(ice_pf_to_dev(pf), "dpll_device_get failed (pps)\n");
>>+		goto put_eec;
>>+	}
>>+
>>+	if (cgu) {
>>+		ret =3D dpll_device_register(pf->dplls.eec.dpll, DPLL_TYPE_EEC,
>>+					   &ice_dpll_ops, pf, dev);
>>+		if (ret)
>>+			goto put_pps;
>>+		ret =3D dpll_device_register(pf->dplls.pps.dpll, DPLL_TYPE_PPS,
>>+					   &ice_dpll_ops, pf, dev);
>>+		if (ret)
>
>You are missing call to dpll_device_unregister(pf->dplls.eec.dpll,
>DPLL_TYPE_EEC here. Fix the error path.
>

The caller shall do the clean up, but yeah will fix this as here clean up
is not expected.

>
>>+			goto put_pps;
>>+	}
>>+
>>+	return 0;
>>+
>>+put_pps:
>>+	dpll_device_put(pf->dplls.pps.dpll);
>>+	pf->dplls.pps.dpll =3D NULL;
>>+put_eec:
>>+	dpll_device_put(pf->dplls.eec.dpll);
>>+	pf->dplls.eec.dpll =3D NULL;
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_update_state - update dpll state
>>+ * @pf: pf private structure
>>+ * @d: pointer to queried dpll device
>>+ *
>>+ * Poll current state of dpll from hw and update ice_dpll struct.
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - AQ failure
>>+ */
>>+static int ice_dpll_update_state(struct ice_pf *pf, struct ice_dpll
>>+*d, bool init) {
>>+	struct ice_dpll_pin *p;
>>+	int ret;
>>+
>>+	ret =3D ice_get_cgu_state(&pf->hw, d->dpll_idx, d->prev_dpll_state,
>>+				&d->source_idx, &d->ref_state, &d->eec_mode,
>>+				&d->phase_offset, &d->dpll_state);
>>+
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"update dpll=3D%d, prev_src_idx:%u, src_idx:%u, state:%d,
>>prev:%d\n",
>>+		d->dpll_idx, d->prev_source_idx, d->source_idx,
>>+		d->dpll_state, d->prev_dpll_state);
>>+	if (ret) {
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"update dpll=3D%d state failed, ret=3D%d %s\n",
>>+			d->dpll_idx, ret,
>>+			ice_aq_str(pf->hw.adminq.sq_last_status));
>>+		return ret;
>>+	}
>>+	if (init) {
>>+		if (d->dpll_state =3D=3D ICE_CGU_STATE_LOCKED &&
>>+		    d->dpll_state =3D=3D ICE_CGU_STATE_LOCKED_HO_ACQ)
>>+			d->active_source =3D pf->dplls.inputs[d->source_idx].pin;
>>+		p =3D &pf->dplls.inputs[d->source_idx];
>>+		return ice_dpll_pin_state_update(pf, p,
>>+						 ICE_DPLL_PIN_TYPE_SOURCE);
>>+	}
>>+	if (d->dpll_state =3D=3D ICE_CGU_STATE_HOLDOVER ||
>>+	    d->dpll_state =3D=3D ICE_CGU_STATE_FREERUN) {
>>+		d->active_source =3D NULL;
>>+		p =3D &pf->dplls.inputs[d->source_idx];
>>+		d->prev_source_idx =3D ICE_DPLL_PIN_IDX_INVALID;
>>+		d->source_idx =3D ICE_DPLL_PIN_IDX_INVALID;
>>+		ret =3D ice_dpll_pin_state_update(pf, p,
>>ICE_DPLL_PIN_TYPE_SOURCE);
>>+	} else if (d->source_idx !=3D d->prev_source_idx) {
>>+		p =3D &pf->dplls.inputs[d->prev_source_idx];
>>+		ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_SOURCE);
>>+		p =3D &pf->dplls.inputs[d->source_idx];
>>+		d->active_source =3D p->pin;
>>+		ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_SOURCE);
>>+		d->prev_source_idx =3D d->source_idx;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_notify_changes - notify dpll subsystem about changes
>>+ * @d: pointer do dpll
>>+ *
>>+ * Once change detected appropriate event is submitted to the dpll
>>subsystem.
>>+ */
>>+static void ice_dpll_notify_changes(struct ice_dpll *d) {
>>+	if (d->prev_dpll_state !=3D d->dpll_state) {
>>+		d->prev_dpll_state =3D d->dpll_state;
>>+		dpll_device_notify(d->dpll, DPLL_A_LOCK_STATUS);
>>+	}
>>+	if (d->prev_source !=3D d->active_source) {
>>+		d->prev_source =3D d->active_source;
>>+		if (d->active_source)
>>+			dpll_pin_notify(d->dpll, d->active_source,
>>+					DPLL_A_PIN_STATE);
>
>Didn't the state of the previously active source change as well? You need
>to send notification for that too.
>

Makes sense, fixed.

>
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_periodic_work - DPLLs periodic worker
>>+ * @work: pointer to kthread_work structure
>>+ *
>>+ * DPLLs periodic worker is responsible for polling state of dpll.
>>+ */
>>+static void ice_dpll_periodic_work(struct kthread_work *work) {
>>+	struct ice_dplls *d =3D container_of(work, struct ice_dplls,
>>work.work);
>>+	struct ice_pf *pf =3D container_of(d, struct ice_pf, dplls);
>>+	struct ice_dpll *de =3D &pf->dplls.eec;
>>+	struct ice_dpll *dp =3D &pf->dplls.pps;
>>+	int ret =3D 0;
>>+
>>+	if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>>+		return;
>>+	ret =3D ice_dpll_cb_lock(pf);
>>+	if (ret) {
>>+		d->lock_err_num++;
>>+		goto resched;
>>+	}
>>+	ret =3D ice_dpll_update_state(pf, de, false);
>>+	if (!ret)
>>+		ret =3D ice_dpll_update_state(pf, dp, false);
>>+	if (ret) {
>>+		d->cgu_state_acq_err_num++;
>>+		/* stop rescheduling this worker */
>>+		if (d->cgu_state_acq_err_num >
>>+		    ICE_CGU_STATE_ACQ_ERR_THRESHOLD) {
>>+			dev_err(ice_pf_to_dev(pf),
>>+				"EEC/PPS DPLLs periodic work disabled\n");
>>+			return;
>>+		}
>>+	}
>>+	ice_dpll_cb_unlock(pf);
>>+	ice_dpll_notify_changes(de);
>>+	ice_dpll_notify_changes(dp);
>>+resched:
>>+	/* Run twice a second or reschedule if update failed */
>>+	kthread_queue_delayed_work(d->kworker, &d->work,
>>+				   ret ? msecs_to_jiffies(10) :
>>+				   msecs_to_jiffies(500));
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_worker - Initialize DPLLs periodic worker
>>+ * @pf: board private structure
>>+ *
>>+ * Create and start DPLLs periodic worker.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - create worker failure
>>+ */
>>+static int ice_dpll_init_worker(struct ice_pf *pf) {
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct kthread_worker *kworker;
>>+
>>+	ice_dpll_update_state(pf, &d->eec, true);
>>+	ice_dpll_update_state(pf, &d->pps, true);
>>+	kthread_init_delayed_work(&d->work, ice_dpll_periodic_work);
>>+	kworker =3D kthread_create_worker(0, "ice-dplls-%s",
>>+					dev_name(ice_pf_to_dev(pf)));
>>+	if (IS_ERR(kworker))
>>+		return PTR_ERR(kworker);
>>+	d->kworker =3D kworker;
>>+	d->cgu_state_acq_err_num =3D 0;
>>+	kthread_queue_delayed_work(d->kworker, &d->work, 0);
>>+
>>+	return 0;
>>+}
>>+
>>+/**
>>+ * ice_dpll_release_all - disable support for DPLL and unregister dpll
>>+device
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is controlled by this driver instance
>>+ *
>>+ * This function handles the cleanup work required from the
>>+initialization by
>>+ * freeing resources and unregistering the dpll.
>>+ *
>>+ * Context: Called under pf->dplls.lock  */ static void
>>+ice_dpll_release_all(struct ice_pf *pf, bool cgu) {
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct ice_dpll *de =3D &d->eec;
>>+	struct ice_dpll *dp =3D &d->pps;
>>+
>>+	mutex_lock(&pf->dplls.lock);
>>+	ice_dpll_release_rclk_pin(pf);
>>+	ice_dpll_release_pins(pf, de->dpll, dp->dpll, d->inputs,
>>+			      d->num_inputs, &ice_dpll_source_ops, cgu);
>>+	mutex_unlock(&pf->dplls.lock);
>>+	if (cgu) {
>>+		mutex_lock(&pf->dplls.lock);
>
>Interesting, you lock again a lock you just unlocked. One might wonder why
>you just don't move the call to mutex_unlock below this "if section".
>

Fixed.

>
>>+		ice_dpll_release_pins(pf, de->dpll, dp->dpll, d->outputs,
>>+				      d->num_outputs,
>>+				      &ice_dpll_output_ops, cgu);
>>+		mutex_unlock(&pf->dplls.lock);
>>+	}
>>+	ice_dpll_release_info(pf);
>>+	if (dp->dpll) {
>>+		mutex_lock(&pf->dplls.lock);
>>+		if (cgu)
>>+			dpll_device_unregister(dp->dpll, &ice_dpll_ops, pf);
>>+		dpll_device_put(dp->dpll);
>>+		mutex_unlock(&pf->dplls.lock);
>>+		dev_dbg(ice_pf_to_dev(pf), "PPS dpll removed\n");
>>+	}
>>+
>>+	if (de->dpll) {
>>+		mutex_lock(&pf->dplls.lock);
>>+		if (cgu)
>>+			dpll_device_unregister(de->dpll, &ice_dpll_ops, pf);
>>+		dpll_device_put(de->dpll);
>>+		mutex_unlock(&pf->dplls.lock);
>>+		dev_dbg(ice_pf_to_dev(pf), "EEC dpll removed\n");
>>+	}
>>+
>>+	if (cgu) {
>>+		mutex_lock(&pf->dplls.lock);
>>+		kthread_cancel_delayed_work_sync(&d->work);
>>+		if (d->kworker) {
>>+			kthread_destroy_worker(d->kworker);
>>+			d->kworker =3D NULL;
>>+			dev_dbg(ice_pf_to_dev(pf), "DPLLs worker removed\n");
>>+		}
>>+		mutex_unlock(&pf->dplls.lock);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_release - Disable the driver/HW support for DPLLs and
>>+unregister
>>+ * the dpll device.
>>+ * @pf: board private structure
>>+ *
>>+ * Handles the cleanup work required after dpll initialization,
>>+ * freeing resources and unregistering the dpll.
>>+ */
>>+void ice_dpll_release(struct ice_pf *pf) {
>>+	if (test_bit(ICE_FLAG_DPLL, pf->flags)) {
>>+		ice_dpll_release_all(pf,
>>+				     ice_is_feature_supported(pf, ICE_F_CGU));
>>+		mutex_destroy(&pf->dplls.lock);
>>+		clear_bit(ICE_FLAG_DPLL, pf->flags);
>>+	}
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_direct_pins - initializes source or output pins
>>+information
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Init information about input or output pins, cache them in pins struc=
t.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure
>>+ */
>>+static int
>>+ice_dpll_init_direct_pins(struct ice_pf *pf, enum ice_dpll_pin_type
>>+pin_type) {
>>+	struct ice_dpll *de =3D &pf->dplls.eec, *dp =3D &pf->dplls.pps;
>>+	int num_pins, i, ret =3D -EINVAL;
>>+	struct ice_hw *hw =3D &pf->hw;
>>+	struct ice_dpll_pin *pins;
>>+	u8 freq_supp_num;
>>+	bool input;
>>+
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE) {
>>+		pins =3D pf->dplls.inputs;
>>+		num_pins =3D pf->dplls.num_inputs;
>>+		input =3D true;
>>+	} else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT) {
>>+		pins =3D pf->dplls.outputs;
>>+		num_pins =3D pf->dplls.num_outputs;
>>+		input =3D false;
>>+	} else {
>>+		return -EINVAL;
>>+	}
>>+
>>+	for (i =3D 0; i < num_pins; i++) {
>>+		pins[i].idx =3D i;
>>+		pins[i].prop.label =3D ice_cgu_get_pin_name(hw, i, input);
>>+		pins[i].prop.type =3D ice_cgu_get_pin_type(hw, i, input);
>>+		if (input) {
>>+			ret =3D ice_aq_get_cgu_ref_prio(hw, de->dpll_idx, i,
>>+						      &de->input_prio[i]);
>>+			if (ret)
>>+				return ret;
>>+			ret =3D ice_aq_get_cgu_ref_prio(hw, dp->dpll_idx, i,
>>+						      &dp->input_prio[i]);
>>+			if (ret)
>>+				return ret;
>>+			pins[i].prop.capabilities +=3D
>>+				DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE;
>>+		}
>>+		pins[i].prop.capabilities +=3D DPLL_PIN_CAPS_STATE_CAN_CHANGE;
>
>It is a flag. Common is to use bit op &=3D instead.
>

Fixed.

>
>>+		ret =3D ice_dpll_pin_state_update(pf, &pins[i], pin_type);
>>+		if (ret)
>>+			return ret;
>>+		pins[i].prop.freq_supported =3D
>>+			ice_cgu_get_pin_freq_supp(hw, i, input, &freq_supp_num);
>>+		pins[i].prop.freq_supported_num =3D freq_supp_num;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_rclk_pin - initializes rclk pin information
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Init information for rclk pin, cache them in pf->dplls.rclk.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure
>>+ */
>>+static int ice_dpll_init_rclk_pin(struct ice_pf *pf) {
>>+	struct ice_dpll_pin *pin =3D &pf->dplls.rclk;
>>+	struct device *dev =3D ice_pf_to_dev(pf);
>>+
>>+	pin->prop.label =3D dev_name(dev);
>>+	pin->prop.type =3D DPLL_PIN_TYPE_SYNCE_ETH_PORT;
>>+	pin->prop.capabilities +=3D DPLL_PIN_CAPS_STATE_CAN_CHANGE;
>>+
>>+	return ice_dpll_pin_state_update(pf, pin,
>>+					 ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_pins - init pins wrapper
>>+ * @pf: board private structure
>>+ * @pin_type: type of pins being initialized
>>+ *
>>+ * Wraps functions for pin inti.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure
>>+ */
>>+static int ice_dpll_init_pins(struct ice_pf *pf,
>>+			      const enum ice_dpll_pin_type pin_type) {
>>+	if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_SOURCE)
>>+		return ice_dpll_init_direct_pins(pf, pin_type);
>>+	else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_OUTPUT)
>>+		return ice_dpll_init_direct_pins(pf, pin_type);
>>+	else if (pin_type =3D=3D ICE_DPLL_PIN_TYPE_RCLK_SOURCE)
>>+		return ice_dpll_init_rclk_pin(pf);
>>+	else
>>+		return -EINVAL;
>
>How this can happen?
>
>How about:
>	switch (pin_type) {
>	case ICE_DPLL_PIN_TYPE_SOURCE:
>	case ICE_DPLL_PIN_TYPE_OUTPUT:
>		return ice_dpll_init_direct_pins(pf, pin_type);
>	case ICE_DPLL_PIN_TYPE_RCLK_SOURCE:
>		return ice_dpll_init_rclk_pin(pf);
>	}
>?
>

It shall not if called properly, changed to switch case as suggested.
Altough still needs default: as there is one not covered case, thus compile=
r
warns about it.

>
>
>>+}
>>+
>>+/**
>>+ * ice_dpll_init_info - prepare pf's dpll information structure
>>+ * @pf: board private structure
>>+ * @cgu: if cgu is present and controlled by this NIC
>>+ *
>>+ * Acquire (from HW) and set basic dpll information (on pf->dplls
>>struct).
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - error
>>+ */
>>+static int ice_dpll_init_info(struct ice_pf *pf, bool cgu) {
>>+	struct ice_aqc_get_cgu_abilities abilities;
>>+	struct ice_dpll *de =3D &pf->dplls.eec;
>>+	struct ice_dpll *dp =3D &pf->dplls.pps;
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	struct ice_hw *hw =3D &pf->hw;
>>+	int ret, alloc_size, i;
>>+	u8 base_rclk_idx;
>>+
>>+	ice_generate_clock_id(pf, &d->clock_id);
>>+	ret =3D ice_aq_get_cgu_abilities(hw, &abilities);
>>+	if (ret) {
>>+		dev_err(ice_pf_to_dev(pf),
>>+			"err:%d %s failed to read cgu abilities\n",
>>+			ret, ice_aq_str(hw->adminq.sq_last_status));
>>+		return ret;
>>+	}
>>+
>>+	de->dpll_idx =3D abilities.eec_dpll_idx;
>>+	dp->dpll_idx =3D abilities.pps_dpll_idx;
>>+	d->num_inputs =3D abilities.num_inputs;
>>+	d->num_outputs =3D abilities.num_outputs;
>>+
>>+	alloc_size =3D sizeof(*d->inputs) * d->num_inputs;
>>+	d->inputs =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!d->inputs)
>>+		return -ENOMEM;
>>+
>>+	alloc_size =3D sizeof(*de->input_prio) * d->num_inputs;
>>+	de->input_prio =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!de->input_prio)
>>+		return -ENOMEM;
>>+
>>+	dp->input_prio =3D kzalloc(alloc_size, GFP_KERNEL);
>>+	if (!dp->input_prio)
>>+		return -ENOMEM;
>>+
>>+	ret =3D ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_SOURCE);
>>+	if (ret)
>>+		goto release_info;
>>+
>>+	if (cgu) {
>>+		alloc_size =3D sizeof(*d->outputs) * d->num_outputs;
>>+		d->outputs =3D kzalloc(alloc_size, GFP_KERNEL);
>>+		if (!d->outputs)
>>+			goto release_info;
>>+
>>+		ret =3D ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_OUTPUT);
>>+		if (ret)
>>+			goto release_info;
>>+	}
>>+
>>+	ret =3D ice_get_cgu_rclk_pin_info(&pf->hw, &base_rclk_idx,
>>+					&pf->dplls.rclk.num_parents);
>>+	if (ret)
>>+		return ret;
>>+	for (i =3D 0; i < pf->dplls.rclk.num_parents; i++)
>>+		pf->dplls.rclk.parent_idx[i] =3D base_rclk_idx + i;
>>+	ret =3D ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
>>+	if (ret)
>>+		return ret;
>>+
>>+	dev_dbg(ice_pf_to_dev(pf),
>>+		"%s - success, inputs:%u, outputs:%u rclk-parents:%u\n",
>>+		__func__, d->num_inputs, d->num_outputs, d->rclk.num_parents);
>>+
>>+	return 0;
>>+
>>+release_info:
>>+	dev_err(ice_pf_to_dev(pf),
>>+		"%s - fail: d->inputs:%p, de->input_prio:%p, dp->input_prio:%p,
>>d->outputs:%p\n",
>>+		__func__, d->inputs, de->input_prio,
>>+		dp->input_prio, d->outputs);
>>+	ice_dpll_release_info(pf);
>>+	return ret;
>>+}
>>+
>>+/**
>>+ * ice_dpll_init - initialize dplls support
>>+ * @pf: board private structure
>>+ *
>>+ * Set up the device dplls registering them and pins connected within
>>+Linux dpll
>>+ * subsystem. Allow userpsace to obtain state of DPLL and handling of
>>+DPLL
>>+ * configuration requests.
>>+ *
>>+ * Return:
>>+ * * 0 - success
>>+ * * negative - init failure
>>+ */
>>+int ice_dpll_init(struct ice_pf *pf)
>>+{
>>+	bool cgu_present =3D ice_is_feature_supported(pf, ICE_F_CGU);
>>+	struct ice_dplls *d =3D &pf->dplls;
>>+	int err =3D 0;
>>+
>>+	mutex_init(&d->lock);
>>+	mutex_lock(&d->lock);
>>+	err =3D ice_dpll_init_info(pf, cgu_present);
>>+	if (err)
>>+		goto release;
>>+	err =3D ice_dpll_init_dplls(pf, cgu_present);
>>+	if (err)
>>+		goto release;
>>+	err =3D ice_dpll_register_pins(pf, cgu_present);
>
>This should be rather called "ice_dpll_init_pins()" to be in sync with
>ice_dpll_init_dplls() as it is doing more then just registration.
>

Makes sense, fixed.

Thank you very much!
Arkadiusz

>
>>+	if (err)
>>+		goto release;
>>+	set_bit(ICE_FLAG_DPLL, pf->flags);
>>+	if (cgu_present) {
>>+		err =3D ice_dpll_init_worker(pf);
>>+		if (err)
>>+			goto release;
>>+	}
>>+	mutex_unlock(&d->lock);
>>+	dev_info(ice_pf_to_dev(pf), "DPLLs init successful\n");
>>+
>>+	return err;
>>+
>>+release:
>>+	ice_dpll_release_all(pf, cgu_present);
>>+	clear_bit(ICE_FLAG_DPLL, pf->flags);
>>+	mutex_unlock(&d->lock);
>>+	mutex_destroy(&d->lock);
>>+	dev_warn(ice_pf_to_dev(pf), "DPLLs init failure\n");
>>+
>>+	return err;
>>+}
>>diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.h
>>b/drivers/net/ethernet/intel/ice/ice_dpll.h
>>new file mode 100644
>>index 000000000000..aad48b9910b7
>>--- /dev/null
>>+++ b/drivers/net/ethernet/intel/ice/ice_dpll.h
>>@@ -0,0 +1,101 @@
>>+/* SPDX-License-Identifier: GPL-2.0 */
>>+/* Copyright (C) 2022, Intel Corporation. */
>>+
>>+#ifndef _ICE_DPLL_H_
>>+#define _ICE_DPLL_H_
>>+
>>+#include "ice.h"
>>+
>>+#define ICE_DPLL_PRIO_MAX	0xF
>>+#define ICE_DPLL_RCLK_NUM_MAX	4
>>+/** ice_dpll_pin - store info about pins
>>+ * @pin: dpll pin structure
>>+ * @flags: pin flags returned from HW
>>+ * @idx: ice pin private idx
>>+ * @state: state of a pin
>>+ * @type: type of a pin
>>+ * @freq_mask: mask of supported frequencies
>>+ * @freq: current frequency of a pin
>>+ * @caps: capabilities of a pin
>>+ * @name: pin name
>>+ */
>>+struct ice_dpll_pin {
>>+	struct dpll_pin *pin;
>>+	u8 idx;
>>+	u8 num_parents;
>>+	u8 parent_idx[ICE_DPLL_RCLK_NUM_MAX];
>>+	u8 flags[ICE_DPLL_RCLK_NUM_MAX];
>>+	u8 state[ICE_DPLL_RCLK_NUM_MAX];
>>+	struct dpll_pin_properties prop;
>>+	u32 freq;
>>+};
>>+
>>+/** ice_dpll - store info required for DPLL control
>>+ * @dpll: pointer to dpll dev
>>+ * @dpll_idx: index of dpll on the NIC
>>+ * @source_idx: source currently selected
>>+ * @prev_source_idx: source previously selected
>>+ * @ref_state: state of dpll reference signals
>>+ * @eec_mode: eec_mode dpll is configured for
>>+ * @phase_offset: phase delay of a dpll
>>+ * @input_prio: priorities of each input
>>+ * @dpll_state: current dpll sync state
>>+ * @prev_dpll_state: last dpll sync state
>>+ * @active_source: pointer to active source pin
>>+ * @prev_source: pointer to previous active source pin  */ struct
>>+ice_dpll {
>>+	struct dpll_device *dpll;
>>+	int dpll_idx;
>>+	u8 source_idx;
>>+	u8 prev_source_idx;
>>+	u8 ref_state;
>>+	u8 eec_mode;
>>+	s64 phase_offset;
>>+	u8 *input_prio;
>>+	enum ice_cgu_state dpll_state;
>>+	enum ice_cgu_state prev_dpll_state;
>>+	struct dpll_pin *active_source;
>>+	struct dpll_pin *prev_source;
>>+};
>>+
>>+/** ice_dplls - store info required for CCU (clock controlling unit)
>>+ * @kworker: periodic worker
>>+ * @work: periodic work
>>+ * @lock: locks access to configuration of a dpll
>>+ * @eec: pointer to EEC dpll dev
>>+ * @pps: pointer to PPS dpll dev
>>+ * @inputs: input pins pointer
>>+ * @outputs: output pins pointer
>>+ * @rclk: recovered pins pointer
>>+ * @num_inputs: number of input pins available on dpll
>>+ * @num_outputs: number of output pins available on dpll
>>+ * @num_rclk: number of recovered clock pins available on dpll
>>+ * @cgu_state_acq_err_num: number of errors returned during periodic
>>+work  */ struct ice_dplls {
>>+	struct kthread_worker *kworker;
>>+	struct kthread_delayed_work work;
>>+	struct mutex lock;
>>+	struct ice_dpll eec;
>>+	struct ice_dpll pps;
>>+	struct ice_dpll_pin *inputs;
>>+	struct ice_dpll_pin *outputs;
>>+	struct ice_dpll_pin rclk;
>>+	u32 num_inputs;
>>+	u32 num_outputs;
>>+	int cgu_state_acq_err_num;
>>+	int lock_err_num;
>>+	u8 base_rclk_idx;
>>+	u64 clock_id;
>>+};
>>+
>>+int ice_dpll_init(struct ice_pf *pf);
>>+
>>+void ice_dpll_release(struct ice_pf *pf);
>>+
>>+int ice_dpll_rclk_init(struct ice_pf *pf);
>>+
>>+void ice_dpll_rclk_release(struct ice_pf *pf);
>>+
>>+#endif
>>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>>b/drivers/net/ethernet/intel/ice/ice_main.c
>>index a1f7c8edc22f..6b28b95a7254 100644
>>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>@@ -4821,6 +4821,10 @@ static void ice_init_features(struct ice_pf *pf)
>> 	if (ice_is_feature_supported(pf, ICE_F_GNSS))
>> 		ice_gnss_init(pf);
>>
>>+	if (ice_is_feature_supported(pf, ICE_F_CGU) ||
>>+	    ice_is_feature_supported(pf, ICE_F_PHY_RCLK))
>>+		ice_dpll_init(pf);
>>+
>> 	/* Note: Flow director init failure is non-fatal to load */
>> 	if (ice_init_fdir(pf))
>> 		dev_err(dev, "could not initialize flow director\n"); @@ -
>4847,6
>>+4851,9 @@ static void ice_deinit_features(struct ice_pf *pf)
>> 		ice_gnss_exit(pf);
>> 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
>> 		ice_ptp_release(pf);
>>+	if (ice_is_feature_supported(pf, ICE_F_PHY_RCLK) ||
>>+	    ice_is_feature_supported(pf, ICE_F_CGU))
>>+		ice_dpll_release(pf);
>> }
>>
>> static void ice_init_wakeup(struct ice_pf *pf) diff --git
>>a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
>>b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
>>index e9a371fa038b..39b692945f73 100644
>>--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
>>+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
>>@@ -3609,28 +3609,31 @@ enum dpll_pin_type ice_cgu_get_pin_type(struct
>>ice_hw *hw, u8 pin, bool input)  }
>>
>> /**
>>- * ice_cgu_get_pin_sig_type_mask
>>+ * ice_cgu_get_pin_freq_supp
>>  * @hw: pointer to the hw struct
>>  * @pin: pin index
>>  * @input: if request is done against input or output pin
>>+ * @num: output number of supported frequencies
>>  *
>>- * Return: signal type bit mask of a pin.
>>+ * Get frequency supported number and array of supported frequencies.
>>+ *
>>+ * Return: array of supported frequencies for given pin.
>>  */
>>-unsigned long
>>-ice_cgu_get_pin_freq_mask(struct ice_hw *hw, u8 pin, bool input)
>>+struct dpll_pin_frequency *
>>+ice_cgu_get_pin_freq_supp(struct ice_hw *hw, u8 pin, bool input, u8
>>+*num)
>> {
>> 	const struct ice_cgu_pin_desc *t;
>> 	int t_size;
>>
>>+	*num =3D 0;
>> 	t =3D ice_cgu_get_pin_desc(hw, input, &t_size);
>>-
>> 	if (!t)
>>-		return 0;
>>-
>>+		return NULL;
>> 	if (pin >=3D t_size)
>>-		return 0;
>>+		return NULL;
>>+	*num =3D t[pin].freq_supp_num;
>>
>>-	return t[pin].sig_type_mask;
>>+	return t[pin].freq_supp;
>> }
>>
>> /**
>>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
>>b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
>>index d09e5bca0ff1..4568b0403cd7 100644
>>--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
>>+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
>>@@ -192,147 +192,137 @@ enum ice_si_cgu_out_pins {
>> 	NUM_SI_CGU_OUTPUT_PINS
>> };
>>
>>-#define MAX_CGU_PIN_NAME_LEN		16
>>-#define ICE_SIG_TYPE_MASK_1PPS_10MHZ	(BIT(DPLL_PIN_FREQ_SUPP_1_HZ) | \
>>-					 BIT(DPLL_PIN_FREQ_SUPP_10_MHZ))
>>+static struct dpll_pin_frequency ice_cgu_pin_freq_common[] =3D {
>>+	DPLL_PIN_FREQUENCY_1PPS,
>>+	DPLL_PIN_FREQUENCY_10MHZ,
>>+};
>>+
>>+static struct dpll_pin_frequency ice_cgu_pin_freq_1_hz[] =3D {
>>+	DPLL_PIN_FREQUENCY_1PPS,
>>+};
>>+
>>+static struct dpll_pin_frequency ice_cgu_pin_freq_10_mhz[] =3D {
>>+	DPLL_PIN_FREQUENCY_10MHZ,
>>+};
>>+
>> struct ice_cgu_pin_desc {
>>-	char name[MAX_CGU_PIN_NAME_LEN];
>>+	char *name;
>> 	u8 index;
>> 	enum dpll_pin_type type;
>>-	unsigned long sig_type_mask;
>>+	u32 freq_supp_num;
>>+	struct dpll_pin_frequency *freq_supp;
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_inputs[] =3D {
>> 	{ "CVL-SDP22",	  ZL_REF0P, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "CVL-SDP20",	  ZL_REF0N, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>-	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>>+	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX, 0, },
>>+	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX, 0, },
>> 	{ "SMA1",	  ZL_REF3P, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "SMA2/U.FL2",	  ZL_REF3N, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
>>-		BIT(DPLL_PIN_FREQ_SUPP_1_HZ) },
>>-	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>>+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR, 0, },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_inputs[] =3D {
>> 	{ "CVL-SDP22",	  ZL_REF0P, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "CVL-SDP20",	  ZL_REF0N, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>-	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "C827_1-RCLKA", ZL_REF2P, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "C827_1-RCLKB", ZL_REF2N, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>>+	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX, },
>>+	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX, },
>>+	{ "C827_1-RCLKA", ZL_REF2P, DPLL_PIN_TYPE_MUX, },
>>+	{ "C827_1-RCLKB", ZL_REF2N, DPLL_PIN_TYPE_MUX, },
>> 	{ "SMA1",	  ZL_REF3P, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "SMA2/U.FL2",	  ZL_REF3N, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
>>-		BIT(DPLL_PIN_FREQ_SUPP_1_HZ) },
>>-	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-			BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>>+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR, },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_outputs[] =3D {
>> 	{ "REF-SMA1",	    ZL_OUT0, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "REF-SMA2/U.FL2", ZL_OUT1, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>-	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "MAC-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>>+	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT, },
>>+	{ "MAC-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT, },
>> 	{ "CVL-SDP21",	    ZL_OUT4, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>> 	{ "CVL-SDP23",	    ZL_OUT5, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_outputs[] =3D {
>> 	{ "REF-SMA1",	    ZL_OUT0, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "REF-SMA2/U.FL2", ZL_OUT1, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>-	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "PHY2-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "MAC-CLK",	    ZL_OUT4, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>>+	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>>+	{ "PHY2-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>>+	{ "MAC-CLK",	    ZL_OUT4, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>> 	{ "CVL-SDP21",	    ZL_OUT5, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>> 	{ "CVL-SDP23",	    ZL_OUT6, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e823_si_cgu_inputs[] =3D {
>> 	{ "NONE",	  SI_REF0P, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "NONE",	  SI_REF0N, DPLL_PIN_TYPE_UNSPEC, 0 },
>>-	{ "SYNCE0_DP",	  SI_REF1P, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "SYNCE0_DN",	  SI_REF1N, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+	{ "SYNCE0_DP",	  SI_REF1P, DPLL_PIN_TYPE_MUX, 0 },
>>+	{ "SYNCE0_DN",	  SI_REF1N, DPLL_PIN_TYPE_MUX, 0 },
>> 	{ "EXT_CLK_SYNC", SI_REF2P, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "NONE",	  SI_REF2N, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "EXT_PPS_OUT",  SI_REF3,  DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "INT_PPS_OUT",  SI_REF4,  DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e823_si_cgu_outputs[] =3D {
>> 	{ "1588-TIME_SYNC", SI_OUT0, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>-	{ "PHY-CLK",	    SI_OUT1, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>>+	{ "PHY-CLK",	    SI_OUT1, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>> 	{ "10MHZ-SMA2",	    SI_OUT2, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_10_mhz), ice_cgu_pin_freq_10_mhz },
>> 	{ "PPS-SMA1",	    SI_OUT3, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e823_zl_cgu_inputs[] =3D {
>> 	{ "NONE",	  ZL_REF0P, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "INT_PPS_OUT",  ZL_REF0N, DPLL_PIN_TYPE_EXT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_1_HZ) },
>>-	{ "SYNCE0_DP",	  ZL_REF1P, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "SYNCE0_DN",	  ZL_REF1N, DPLL_PIN_TYPE_MUX,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>>+	{ "SYNCE0_DP",	  ZL_REF1P, DPLL_PIN_TYPE_MUX, 0 },
>>+	{ "SYNCE0_DN",	  ZL_REF1N, DPLL_PIN_TYPE_MUX, 0 },
>> 	{ "NONE",	  ZL_REF2P, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "NONE",	  ZL_REF2N, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "EXT_CLK_SYNC", ZL_REF3P, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "NONE",	  ZL_REF3N, DPLL_PIN_TYPE_UNSPEC, 0 },
>> 	{ "EXT_PPS_OUT",  ZL_REF4P, DPLL_PIN_TYPE_EXT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_1_HZ) },
>>-	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
>>-			BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>>+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR, 0 },
>> };
>>
>> static const struct ice_cgu_pin_desc ice_e823_zl_cgu_outputs[] =3D {
>> 	{ "PPS-SMA1",	   ZL_OUT0, DPLL_PIN_TYPE_EXT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_1_HZ) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
>> 	{ "10MHZ-SMA2",	   ZL_OUT1, DPLL_PIN_TYPE_EXT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_10_MHZ) },
>>-	{ "PHY-CLK",	   ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>-	{ "1588-TIME_REF", ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>-		BIT(DPLL_PIN_FREQ_SUPP_UNSPEC) },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_10_mhz), ice_cgu_pin_freq_10_mhz },
>>+	{ "PHY-CLK",	   ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>>+	{ "1588-TIME_REF", ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT, 0 },
>> 	{ "CPK-TIME_SYNC", ZL_OUT4, DPLL_PIN_TYPE_EXT,
>>-		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
>>+		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
>> 	{ "NONE",	   ZL_OUT5, DPLL_PIN_TYPE_UNSPEC, 0 },
>> };
>>
>>@@ -429,8 +419,8 @@ bool ice_is_clock_mux_present_e810t(struct ice_hw
>>*hw);  int ice_get_pf_c827_idx(struct ice_hw *hw, u8 *idx);  bool
>>ice_is_cgu_present(struct ice_hw *hw);  enum dpll_pin_type
>>ice_cgu_get_pin_type(struct ice_hw *hw, u8 pin, bool input); -unsigned
>>long -ice_cgu_get_pin_freq_mask(struct ice_hw *hw, u8 pin, bool input);
>>+struct dpll_pin_frequency *
>>+ice_cgu_get_pin_freq_supp(struct ice_hw *hw, u8 pin, bool input, u8
>>+*num);
>> const char *ice_cgu_get_pin_name(struct ice_hw *hw, u8 pin, bool
>>input);  int ice_get_cgu_state(struct ice_hw *hw, u8 dpll_idx,
>> 		      enum ice_cgu_state last_dpll_state, u8 *pin,
>>--
>>2.34.1
>>


