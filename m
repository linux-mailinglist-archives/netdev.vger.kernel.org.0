Return-Path: <netdev+bounces-5316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3360B710C6D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8FB11C20EA9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8E6FC1D;
	Thu, 25 May 2023 12:53:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8184D510
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:53:02 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B7C135;
	Thu, 25 May 2023 05:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019181; x=1716555181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oGhYAHmfv48VXpKl7iHBo+bz+2EKurb7nYOKws03bio=;
  b=QGAcF2ckDa5N0Dtk6WlcPI3iyY7YURhYnOouHeiyad4IuoxwAZT+c5YV
   z2IDKoicrsxqi6FgiD8VRe/U3kcuSYGuJ8nHLGbAfLzmum+TkOgR+zjUi
   fRCXhIwekLyk9tVJ/b4Jb2PXh5vqIQmeS9WUwQv4jkQFaniQU9o2JV5C9
   oDixdwep3jWYmmBC4CdZzH+ULPRdoZuxIlT5UJahyC54e0jcRepIWDNBD
   P6ZHbwfvKeO9UDumlPVYQd1sQVZrxmrB+irC0v1lBSYZzdhylkBa+fT+S
   cBClb6UyWlaRCV59Zm6NOWWVu9geZsXiZehC2SaWFQf4ArTBW20ihqKGb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="353896916"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="353896916"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 05:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="698968648"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="698968648"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 25 May 2023 05:53:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 05:52:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 05:52:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 05:52:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaBsMHzG7RXmy8aXPED2Nk5vCj0o91RxZLFEIVKriptyPLpXLfTxajid6rFX1bFTi1wXO15CXec0QCoOGPS85UroH1gUOBnXD1XpRbl9g+pDVI/q8iYzSY3YP2aT7Gz90OOZb52yzZQGtRiodiGQaTBLkwSyc+qGk+pxnx1YUEjOMiUZgNEak2/uPU5PSSCHDpyMp5fccXDKDTujm1PVz/U7anLp4UFizmu2QlIOPXTKCehKNwSrdtbTSRoE9p08YrA3Bsj67nJrKEb5y65rqrkar8xDEW9hkDqrCkBx2IAN5QKBXFsyzQSMPuTmk72f1f/SgI7/kKxGDgqBTJzzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fsi9iPjuHLHJ44J0pAVbzGNS3MxfjC6qds1+Ff9f7VQ=;
 b=T87tUAWOxIkbxh2oxRtliuPl3a4QxrHii6uEvE6Li6qGIT9roZsCeWWEEEywG/pfuhClc3B744Wfm0/s/u5nv4CC2JAHwxevBwfcfkPfizTe6hdeAxZOzo+f8LxpWRSVT7o9wJXb6xewwkamdO8nTReRpWAnm2iemIBL7L/O/A9eQarZ5voPA4Ot19KlVeOgg80CDh1OBozlLnM+wLRAKOc9GmCqj9Se6mFjkDps4HrWsnLlevXIhfj/Z7rHs34XOtCa8tB8LMMOrpSEDWh4daSqYUyKV8Fu5LC+gXr0n4bHtlTLhuVvet9PWzqSorPnCN7ZSY0RM9dLWADukFcjig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BN9PR11MB5515.namprd11.prod.outlook.com (2603:10b6:408:104::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Thu, 25 May 2023 12:52:57 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 12:52:57 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Topic: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Index: AQHZeWdMwpT4Id4KhEupVVmmO03v069G+mmAgCQiSlA=
Date: Thu, 25 May 2023 12:52:56 +0000
Message-ID: <DM6PR11MB465702B76851D80CFA780E349B469@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <ZFEKVWdkDjMMhjQp@nanopsycho>
In-Reply-To: <ZFEKVWdkDjMMhjQp@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|BN9PR11MB5515:EE_
x-ms-office365-filtering-correlation-id: c04fe1b7-041a-48ae-0737-08db5d1ef692
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbpxupB+GrPGF/GD535FuLvORF/cx8P/IUx+H3IEjBGqWbB/eV81zb383P0BmkFfFDv054F+qOoZXlr597YspSGMl+xRaGU9N16UvcqWpoQgYbqPe2zsJddAQQGWo6F5s3OqhuhazXhQ+lC4f1cwZrb5DJCV0IjiQFkpSpw8jfIhFvkjTXGXkh17sgPMiX06pPFMHr7t6/SQmYiinPZGAgPP79rBGwTwoNrOck1c3jJW8Eqay/QhzOh7pDvaRc0I5Y4w5OXEXhkPlEry7ps4BjC4i8DKWdKD3vwyUAtRM58NoV7tRqAiK0JZfD8rxNQnXWXKyWZ/AMhYAM+F8Wok+TGFNe3MF4ZbGObi3mQevkONMzuimQdtmplhW6A2aVNpe2iMtmcacvYNHRn+dcnWPX0Zy33BR5kIdI9prMylzeWSJGtO89gguV6pS6GuYlZnRvYJsx56WgqUHU8my23gpX3tMURoQKMDFlaheEM4qk9zkFRqIkFAsKSaaTCJwJjfjh5MZgP43SrmdyR16xEVwQ2EN3DjQWr5RFJoVwetHQZgHKoEFv33KpHZSpU7537Bs7xtDviVCtKti/gjmeiXEqMbsQsSyTsQDx3sld9rKM29vbi8pF1uIhA335SCZB90
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(71200400001)(7696005)(41300700001)(7416002)(26005)(9686003)(6506007)(8676002)(8936002)(38100700002)(5660300002)(52536014)(83380400001)(2906002)(38070700005)(4744005)(33656002)(186003)(86362001)(55016003)(122000001)(82960400001)(66476007)(4326008)(64756008)(66446008)(76116006)(66946007)(66556008)(110136005)(54906003)(478600001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N6WNoV2TGjyvzKLlVSPIlv4FLmUO4Lgccv1B2HeG3yMoV/spPxIgAYURikXw?=
 =?us-ascii?Q?7i4lGpQ+fIpRbBgLqYlby2nN6IgkOKVC7TAf5Nhv8kTx6PuikTCnRfXInfkt?=
 =?us-ascii?Q?smdDl9yNgUQbSgt9cHN7aFzqj0gtAbUhSuH5nUPM75F9eaEVcyE9tfzGrKvX?=
 =?us-ascii?Q?5SXBh76+43DByX+bJPRguARIG7fOSfhZBXNlzcAB7fmu+xD285rEqsjC7Jok?=
 =?us-ascii?Q?q95CeX+teYbBZzqi4/ZZSawmiIjtoZk/EaMrGO1Oubv7wF459OwYD1WE3icH?=
 =?us-ascii?Q?gzenLD2WU2r11/nIPOrgoG21cMkC3tbjsyg0mXb8hTVYXWJFAYXQ9nQR1PDo?=
 =?us-ascii?Q?D3Xx7cMkzgyObZQ7Fz9uOxws8gzyQpOEA1GU0XGzOOWPU8vhQoYmJHdZgxJK?=
 =?us-ascii?Q?fCSGmtZizrhhLh3mOTuiLIkmvNnLrNB2cYSRPamR1LfCvzH7pICYschOx27a?=
 =?us-ascii?Q?kcz/yie/X4KFv1lY3XpQUaOpdW+/Sdj/gDdbZXjrDareHH2TL/R3S1mAm1sq?=
 =?us-ascii?Q?oSnlTRf7EiJM8GOr7sCEOd7MtVgQwNShGc86u9LJPcJZqplAhEp0Ou7pZBjJ?=
 =?us-ascii?Q?fVmojdeMuWQVmJj7ZB9scNNubR2W6BPcrw8CCCmxErrxfUtaPWr9U1eTzm47?=
 =?us-ascii?Q?/NQI0eqlyaXI9DauUxDR+Nvd5+6cZjO5CTUqdu+PTIl9FIM1GIJ68jDB/9zh?=
 =?us-ascii?Q?rWO5/gIc6nR6Rx1tGVKiaXD+wZimpo0BtPXNsgoLW3O4gD9+EiezfUFhB6AJ?=
 =?us-ascii?Q?+Z5FCQCKPw+zI31RuFEAIcNAEFWP8AaekeeAWcpEhG8RFVTUQmHxuAxYFoAa?=
 =?us-ascii?Q?0kj5b8xoHur/sOQw5ou/pypkq/NwfGGWrLQ5PozEINiw8S/DP6nXEOjEdDej?=
 =?us-ascii?Q?jhGPBmyaJsGJSk9uaqDdShSWh77L3wRZn6YsIlxvmWkBaT01EohN2joFe5yY?=
 =?us-ascii?Q?Ru5bNntRrQhr1pg68NRpGwu8rBzhuudiLlX5sRH6HMhr4V+7XB7g86yOFW9S?=
 =?us-ascii?Q?ygTKe2UHXFC4Rr5WqWLHknuudLcqExXQo5uqLxgqymcimHH9eP35cSyZ97Gd?=
 =?us-ascii?Q?q8OuUCU+pkBaF94Q0siC1YI7ZMSDO20wobXR7+6DyyhUFNDTZ/611L3MKO3f?=
 =?us-ascii?Q?7SC0+NQYtbJhSVxoNif5IfEBD4t+pUO1ETBRxr98cmIXG6Oe7gUDZIrUYN+7?=
 =?us-ascii?Q?j9YfwoyDgdrwP5spiUQXcAEmLWsXepeH1gosyF2pZW9P9nJP0X8GZiOYn0hL?=
 =?us-ascii?Q?PLLqBIuaXfymnaHMLZkqTMOX6/PxWcMGQMPAhGWT6SwLma/doTeaI4Fk+hAj?=
 =?us-ascii?Q?xYN7zH8OcR4U6eAeAEIg2KU+A3k0JemQU2lM7Q+DQFM/a9sth6Nnf0JBWUIX?=
 =?us-ascii?Q?wOGtPaCJTzAEGla5V4pm1fOwGZQgeGiJ4J2jaN0fcsqM7O5l6KLz9A2w2tG8?=
 =?us-ascii?Q?XLapwWFKWbFEsDCvTFxe6ViGeeGJdcfFo65NznrjVKJU7wx2Yrko+GS7uqoi?=
 =?us-ascii?Q?PX6kG1HSIrOLYzl9vBX/gZhs163hW8CgoEZr1KcZ62ZB5AuyjPTAFaNwbK+L?=
 =?us-ascii?Q?ntNRZjRrymZdi16znZFt85Alua7ZC9W37u9DoikkYxcf6cjVlVHpDDlIW/Ym?=
 =?us-ascii?Q?1A=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c04fe1b7-041a-48ae-0737-08db5d1ef692
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 12:52:56.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yl1/bSrwWgmNohNDL0CUuuvbUai4Pi54bMpA6H595xEN/YeGwfyKjPUJ6lT4Ml+0TOlep5B4YUry5zjjhIU0nltgQXM7cy6f5GPjLJUwEnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 2, 2023 3:04 PM
>
>Fri, Apr 28, 2023 at 02:20:01AM CEST, vadfed@meta.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>[...]
>
>>Arkadiusz Kubalewski (3):
>>  dpll: spec: Add Netlink spec in YAML
>>  ice: add admin commands to access cgu configuration
>>  ice: implement dpll interface to control cgu
>>
>>Jiri Pirko (2):
>>  netdev: expose DPLL pin handle for netdevice
>
>Arkadiusz, could you please expose pin for netdev in ice as well?
>
>
>>  mlx5: Implement SyncE support using DPLL infrastructure
>
>[...]

Yes, will do.

Thank you,
Arkadiusz

