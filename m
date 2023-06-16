Return-Path: <netdev+bounces-11520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4759733714
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7EC81C20D98
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A01E1ACDA;
	Fri, 16 Jun 2023 17:03:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA41ACC4;
	Fri, 16 Jun 2023 17:03:33 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAF635BF;
	Fri, 16 Jun 2023 10:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934991; x=1718470991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zHd3TS71swFhG8RMGSnlbtJ7WI0MBrRbGEKCUVGjX0Q=;
  b=NPdk+8/mU/I98hM5f3sDOnCNHnLFvYKuCS89olLJGSrs8ifKUfRFMoQ7
   4EE4tbLFgkgX8eJv+modZJ20/KJJD64lL0fezhnnJ4u1jaqBG686a8Qku
   KCMTbF+5dQhZclBAx0GzIMlyTDPqTWdwCn7boTSMBg9//WpsMhz3kzFxU
   zerbcrtz7VwRWLf9S1NDdV19KUtc2V2xWRwFMXpQpgiEM7525kfNyuSvo
   VYDqysdOqSBPM1AQa4f0PWr0qN9/qiktgPGhgJDRu66eHACPZRTDN0wiJ
   /EeWGh8ZS9lxjr8i8EZ0a4e01wy+2lSxg7ckE3K1ueKL+xhiVah6jL/GM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="358135424"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="358135424"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 10:02:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="716092462"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="716092462"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2023 10:02:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 10:02:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 10:02:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 10:02:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 10:02:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNpY7uIBBNXVqe2fOVLh9gLcMfp1euWmmgIP4qOmo39/LuNts/nPYPYCq5K3ICnpBKaWGQPkeR4yD4iKp/lrujywlAP5emcgONW+Nnon3BFic4aTh4PSFGC+3XoW0KgDYgHtV60065wSGiMhfmhN+KN5D3cWDT4YC+XvaphSbsppWYCIfqnhakPnsSdP3jDBLdzs4SZTV31u/9xucd35qoksu33rM2Nt2PsEqXbTJ4G7697ANMNwbT0liyDZy9FuQoJ/zvRecpjJv341BLOFgfBoIYKHbGZYa0tnpbPuiDWUGA9zF3cGjKJ2qSvT0LdffPucZ2ZGkEpMSAmiWmaq1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHd3TS71swFhG8RMGSnlbtJ7WI0MBrRbGEKCUVGjX0Q=;
 b=nusVKTysbu35+Mmh/CeuEzRLT5sBtpL5JtDAH+562fKEE58+Pfu1VYstTkhIR4H7y1GM76p6oBXJsypAJGZbXEAZsJ3dHnftuVRJqiZGVvH8G7qJSivcj4VNSTlepgHy+T6hgpwx7sluRiB00e5T+Kbk4Yy99brTdmG0Wto26ZWt5VDXpMIPN5SOtW8o/oYN5X1f1u9UR2GRRzp2TDxte3rSdgCBQkSZ49DUvCHsJPWhTxgfzDMjcmKUaONm/bThqw2MuZDsczJnWj0EL6LskUDSR9Le209m8SDY6fDSlFJwmn4ByEsquTETXkiuwY2CybBbHcRcIa/uAZ8d7hR8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 17:02:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 17:02:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mcgrof@kernel.org"
	<mcgrof@kernel.org>, "deller@gmx.de" <deller@gmx.de>, "davem@davemloft.net"
	<davem@davemloft.net>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"puranjay12@gmail.com" <puranjay12@gmail.com>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"will@kernel.org" <will@kernel.org>, "dinguyen@kernel.org"
	<dinguyen@kernel.org>, "naveen.n.rao@linux.ibm.com"
	<naveen.n.rao@linux.ibm.com>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "linux-modules@vger.kernel.org"
	<linux-modules@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "song@kernel.org" <song@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
Subject: Re: [PATCH v2 00/12] mm: jit/text allocator
Thread-Topic: [PATCH v2 00/12] mm: jit/text allocator
Thread-Index: AQHZoC+0c1p3dpPJ0Umm53KR18jBkK+NqGKA
Date: Fri, 16 Jun 2023 17:02:50 +0000
Message-ID: <557b2205c6826ce00c4cb76d8d8679807eb0ff58.camel@intel.com>
References: <20230616085038.4121892-1-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-1-rppt@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5015:EE_
x-ms-office365-filtering-correlation-id: c0a47551-35b1-4512-9c4b-08db6e8b8441
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TejL0XHybv9fjD47zhrpMJcVYKnhdJKohm/7rGrV3fadxqN8WIDf6LCbTqORF3P1sk6Ko9gkPRsVgACdvD5ZzrxN0slwwKScNK8F9sGfyNz4UTNwldVYSAIQ69EXd91H1LNnaKjkGz1/2f8Vc4UHE8gMsTMeQhDb1oJ+CCAhJqRS6TFOikZu1vhJP92S4qwrv2LQE1HkVLZtKRD7nC25rBnrp6dQPrykP/3zt4v90cxYeM2HrxmDPxKaPPyYQenbMGysmQvbXUq8oNPGGXxODpRVL7d1X6TqOd4B7vX0t7D8izAGIdVNxwBhVSKCB/t26BE8DyjvlbQK8iG/QF+JAK8+UHIEo5CnNo9D1qgr7ty8bsBgDCmpBopEX++nS+3oSd1UZo7IFptABls/ncDpaToldWtCvMAOq1WODlSLsKExfjKeif8Ve7QmYvFmnPGRlGBtJTHLVLDD+xsUJe9tMz57hUWMeZiH4eZyajrwWIYGc2gO8wvx8FDeH8VBwhgROdWBXAg37oXRRNCfC13mFI+m3MoE2B3HdbK9oNM5V2UfT+pxB4Hq3NYk88DHWRcuNb2/rJq459CBmcYo/AjvwnhlTSs+XhyJ+v74SCflgYw3o6l2ReHHhqkDXUxBUge4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199021)(5660300002)(38100700002)(82960400001)(122000001)(186003)(2616005)(2906002)(4744005)(6506007)(6512007)(7406005)(7416002)(478600001)(26005)(38070700005)(66446008)(66946007)(316002)(66476007)(6486002)(71200400001)(64756008)(66556008)(8936002)(8676002)(41300700001)(86362001)(76116006)(91956017)(4326008)(36756003)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG5DcElmUE5vbk9WUkgyTFpkamxXNXgxMURNSkZrcytOWnFCRlpVQjdjZmow?=
 =?utf-8?B?MVcrMTE5VUJyUHZaNHVoZ1JoUkhNOHkzWXVjaDBrYm9yM25QbDJrWGJ5Q0py?=
 =?utf-8?B?a3QvVFlPWGlNUHBQQzROWEwxN01nTjYzdSttTHJWUm92VzBEdmJvdkRBNWRw?=
 =?utf-8?B?bDBxNU00cmNMWjY2eHZqNmtFMU55Z3RJRGt6K0ZzeXNST0JoZDZTaFJuUTRm?=
 =?utf-8?B?R0p3aTZpRStTeXBvZmVGeDZQTUFXdlJZSVV2L3M4N1ZIOU11UEg3ZXRGMTNw?=
 =?utf-8?B?eGtXN25HVFE3NmZnT2ZjMzR1NFJ1MG00WnRaWEVvTC9WWUxPR1JRS1Y3Uk5r?=
 =?utf-8?B?RFFISENjbFcvd01wYXBYUFVoOVVPc3U0WmQyc3lKYzUrTGRNdzd6V1lLK0hI?=
 =?utf-8?B?aEVhd29FZTFyK2NZQithQmR4bktxSk16c0xqSmo2TmhxQ3YvV2VlZGd6bTJy?=
 =?utf-8?B?YlBrRTFid3ZhMmlpbWhtZ1U1RXVKRmlBaXBGZ3VDbVlRaTVLalF0TjllRTln?=
 =?utf-8?B?UnF0ZEJiVk5Gblp0aUxHTVlGclNkemtLcDlWMEFIS1Zrd3NRamhEZEhlNGdv?=
 =?utf-8?B?MktwQktPWXhXd2RIK0dzTVJ5LzVqejFDU1ZwVVFmdkFvY3JpS3pxeE5kVkxy?=
 =?utf-8?B?WE1YTjJkbEdjMDJpYzRpdU1aUllqV2o0S2pEL1NtV0ZpSXBjRE9iVTR6RTNO?=
 =?utf-8?B?QmZHNUd3eHNlc3BMMkVzNGpaR24yQzA4QVpyZnU4T3V4ZnFOcFJ4NXdSN3Fs?=
 =?utf-8?B?eHVxNEZBRS8yeVpaeEt4aUZPY2tYQkkxb0VQWlZxODNBUXJBT2xvQnNFcldo?=
 =?utf-8?B?VDhoZXRtZXZzMDJ4L2ZJbXdIVTBsbXVRR1JjVlprbzBnQ3ZRRGZ5bmp4RVgr?=
 =?utf-8?B?Lyt0TG9ibWFnd2ZjT3hzS0lZZXoveStLWnE1Yzg3L09JUlVFcUxHcndaSDJF?=
 =?utf-8?B?S01ra3RyaC9sd3pzeUNNM3g0MFFxc0VBd042Skg0RnExRzhjSUhRM1dCNlhq?=
 =?utf-8?B?TmhYQlpLWU9QQ1dOMTFZZnR0dDMrYkg3OXlXY0t4UlRWM1RmS3RNMHdvckRz?=
 =?utf-8?B?cXVuUFVQM2FyYjl5QzJzNXhKT05qRStrRldNT1RMN3dMQ3hxSzRDcnBlTGk2?=
 =?utf-8?B?b2FtTU96cTBDUkEzTTA0OFhzVDRXY09UcWs1MEdEY1hLNENrNkVUdk9TQ1E0?=
 =?utf-8?B?K3VXZ3VoSVZ1OUJUMFlkVXFtQUtBTkFUanlES3BHb3pFMFlwempvclpGOEs0?=
 =?utf-8?B?NEc2ZzNRVmlObVcvazRwUFJadk4vV2ZUQ01tYnJmRk4vbjQ4ZU1kdk1TYktq?=
 =?utf-8?B?WWVYUlhzM0w0NjQzS0VRcm8rdklXU3ZSZWJLU0VFOWZMa2JQRThFRWsvdmdE?=
 =?utf-8?B?RjYrMExEb0xXVzJkTEFRUlYwOVlvd2U4NCtDUFFINVpnemZyc2pWNGZpKzVE?=
 =?utf-8?B?MDdyWFA5MEpWM2dveUpKTG1ITlQ2dVhNbWtNYlBFUUEzNlFaNGlraWZXV1hW?=
 =?utf-8?B?eEVRVWJYZW1SbWdwcTM3cGNrUGhJdXlNUG9RSmFndndBWkJQaGZsc25tb3gv?=
 =?utf-8?B?OUZianlNa1dkSGJMWWZkTFFvcnRWSm1sZlFYSjY5MFB2UmpBRmZ0RmlJSjkr?=
 =?utf-8?B?MEk5bDdSVlJ1YW5RWkRZWlFTYVMrVDV0SjZ4elBaNXBtWENmZ2FiTmt4RzE5?=
 =?utf-8?B?TllTT0YvTy9YdG1CbVBvSjd2R0RHNWNPYzcyeWhXbGZ4WG8rWXVWdmVEelNa?=
 =?utf-8?B?cEJrMzF2ZGpYcEhGQmtZUXZFc04rbkJmWWZPVHoyd1h6SWhpbEcrRHJIOVJ4?=
 =?utf-8?B?TXZHYWE4aEptczJmZHcwN1M1ZEszejRtbFBvZzc4V1I0dmROWiswZS9ydW5V?=
 =?utf-8?B?Z29pVi9BZjZEa0VCM0xldjRvM2dqWVJrdkpCcjIybHpFT2czQTZkTmZrcUZD?=
 =?utf-8?B?R2RpVUszRk5zUklwUTlGR3FvaHkwd3YwK0NoYk1ldlpwUUtHWmZiWW13RzJE?=
 =?utf-8?B?WmZBdWJVRk1ZYjNuOHZBeTJPOWR0elpzeFRjeW9Ya1lFbzNjNCsvZGVoSmZK?=
 =?utf-8?B?RU1YcXdsQW4xL3lqUzVrWStjUW0rYlJsbm9VQ3BIalVqWkxMaExJZ1NxZmlG?=
 =?utf-8?B?eWEzeWc2b2xZaHVjWVJFRm5DSW9aTzloMVJzeURTNkJvRlBNUHF0UFBuMzFr?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <007468AB03AB764CA8371FF7D2F58E71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a47551-35b1-4512-9c4b-08db6e8b8441
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 17:02:50.1302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxNS+ahK+DX1qWqlhMqp8dGmxRY2V1uAK49QA5AQIKPjhPYDLmEE/uWc8XataiNhlTucVUMvPXTbfyxsBS2XERmqw4bOuyDR4kHjwNoPlVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gRnJpLCAyMDIzLTA2LTE2IGF0IDExOjUwICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBGcm9tOiAiTWlrZSBSYXBvcG9ydCAoSUJNKSIgPHJwcHRAa2VybmVsLm9yZz4NCj4gDQo+IEhp
LA0KPiANCj4gbW9kdWxlX2FsbG9jKCkgaXMgdXNlZCBldmVyeXdoZXJlIGFzIGEgbWVhbiB0byBh
bGxvY2F0ZSBtZW1vcnkgZm9yDQo+IGNvZGUuDQo+IA0KPiBCZXNpZGUgYmVpbmcgc2VtYW50aWNh
bGx5IHdyb25nLCB0aGlzIHVubmVjZXNzYXJpbHkgdGllcyBhbGwNCj4gc3Vic3lzdG1lcw0KPiB0
aGF0IG5lZWQgdG8gYWxsb2NhdGUgY29kZSwgc3VjaCBhcyBmdHJhY2UsIGtwcm9iZXMgYW5kIEJQ
RiB0bw0KPiBtb2R1bGVzIGFuZA0KPiBwdXRzIHRoZSBidXJkZW4gb2YgY29kZSBhbGxvY2F0aW9u
IHRvIHRoZSBtb2R1bGVzIGNvZGUuDQo+IA0KPiBTZXZlcmFsIGFyY2hpdGVjdHVyZXMgb3ZlcnJp
ZGUgbW9kdWxlX2FsbG9jKCkgYmVjYXVzZSBvZiB2YXJpb3VzDQo+IGNvbnN0cmFpbnRzIHdoZXJl
IHRoZSBleGVjdXRhYmxlIG1lbW9yeSBjYW4gYmUgbG9jYXRlZCBhbmQgdGhpcw0KPiBjYXVzZXMN
Cj4gYWRkaXRpb25hbCBvYnN0YWNsZXMgZm9yIGltcHJvdmVtZW50cyBvZiBjb2RlIGFsbG9jYXRp
b24uDQoNCkkgbGlrZSBob3cgdGhpcyBzZXJpZXMgbGVhdmVzIHRoZSBhbGxvY2F0aW9uIGNvZGUg
Y2VudHJhbGl6ZWQgYXQgdGhlDQplbmQgb2YgaXQgYmVjYXVzZSBpdCB3aWxsIGJlIG11Y2ggZWFz
aWVyIHdoZW4gd2UgZ2V0IHRvIFJPWCwgaHVnZSBwYWdlLA0KdGV4dF9wb2tpbmcoKSB0eXBlIHN0
dWZmLg0KDQpJIGd1ZXNzIHRoYXQncyB0aGUgaWRlYS4gSSdtIGp1c3QgY2F0Y2hpbmcgdXAgb24g
d2hhdCB5b3UgYW5kIFNvbmcgaGF2ZQ0KYmVlbiB1cCB0by4NCg0KDQo=

