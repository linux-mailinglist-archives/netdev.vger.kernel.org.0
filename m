Return-Path: <netdev+bounces-10182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6FD72CAE2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A300E280FF5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FE51F18A;
	Mon, 12 Jun 2023 16:02:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BC31DDF8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 16:02:00 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB04CA;
	Mon, 12 Jun 2023 09:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686585718; x=1718121718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jGEJkelPWn7iyywk3kYtutFbRwKrnmdVS+sPeyRKJEk=;
  b=ggZrmHLIy6QgcXd0+1esjsolfMU8HkNKDnQIycAdm7RrJ8jjRaP6ZTFK
   r/4i9yCSOZH8ZfhnDqHZgMqw0WdEudL7yiEAGPM+K1MDioDHx4aArEpHf
   JadSEyzN4zBd1cuNuZuslqiA4TzNh9grIemq9lLhl5l/H7nE4I3XYpwnB
   Z9PiQKmBnaucOAqRKuYHgVZUnAsdhia/39OrAuHZl7hfk8sC4jlg6vGFP
   rH7c6G6RAkDOQOHrCc3PEerAvbROrT3h/1C5SLk3IUcmgV7xldyOBCkNe
   85TINqp21b2eiKWS0QP/owMpDa/jufmvwybhnFner9fgSqs1fxbUY/HWD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="361449240"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="361449240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="958075690"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="958075690"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2023 09:01:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:01:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 09:01:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 09:01:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWBgyB6ML8jLxcH69L8GrtzattjvmYOXBUG8/c1U2Hgf3C52xwM6fn/Cuw7FcrxiSzOd2nCPoKIvomiq3fAlyRC27aAFQZ667JyErZSCn24JMCj+znwMvmSaFr0PNx8GIIFnVNp1MnM/F1FFagXmEFhPjNbw8LrT2ObhESy9wq4V6CJVyi0V8W4EK+1vLWyLwd9RttQfdXpOHkhGKzKaitmZG5r+C9uHN16iE+a13UJJo4RkPguQDIVSFT9oUc8KB0+ugRUNSxrkjfIVmlXJyxE8RmhU1kucrPB/lA79y7F6ugtWLEqbr+G/Vonq21D4UFwyq2tsKAxLJ+H+hxAULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGEJkelPWn7iyywk3kYtutFbRwKrnmdVS+sPeyRKJEk=;
 b=ctuzbXMyZVtdjiMjGLfidGy8ltlufwlc/Qx3RA+IQqCZbFz74JAZzt0K/SrZBLpIUZ272cOv70ShmEVQQWf5thHczXFV1F19QzfOuqcblHWmbMM+BV6t8KpgozkySONdIwTNGbDkg8a7a04u0/8Va1T8BnZrET8qtjyFsPqHOrzHAWzao2/ldJme2DmABfeXSD0jLiN9APpHrMIKZXOLMV2g6gSG+4gvmj4one05hWEgAovYbpA4nqwnXvaXI7fCbjXwDesSFCz3JDXwGJkHRBQvsEgip6joEJ3FEWRz7m1PnjhVLaK+PR51fN5V8ldLTxidOrygcISupFYw6co46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CO6PR11MB5587.namprd11.prod.outlook.com (2603:10b6:303:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 16:01:04 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Mon, 12 Jun 2023
 16:01:04 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Bart Van Assche <bvanassche@acm.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>, "vadfed@meta.com" <vadfed@meta.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
	<ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
	<michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
	<jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
	<airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
	<milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
	<idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
	<phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZmszoYeH83BxaW02EVqODRhjpgq+HT+mAgAAIb3A=
Date: Mon, 12 Jun 2023 16:01:04 +0000
Message-ID: <DM6PR11MB46578CA8A72438F5AD41799D9B54A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
 <de920a42-0d72-c5ec-1af9-8bfa4b954cfd@acm.org>
In-Reply-To: <de920a42-0d72-c5ec-1af9-8bfa4b954cfd@acm.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CO6PR11MB5587:EE_
x-ms-office365-filtering-correlation-id: 57200e35-d453-4704-79c5-08db6b5e3a04
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWkhAUZvX6230ej4LDuXpr+XmjL/64di+jY4wxmJJKEiSLPmoxs1HZZRcHXq97sapxl2QfJf1nH3DVIQs8aNarxwEHPjrh3JgtGyzMTstWWKwSpa++QgrfAt7vUSHQ3OpVBxVDZ8tD9NpMeuwg4uAJVrTts6uvoFnKEaRv4LXzQyopNTTE/wkfLXYz/qfL8FvRnrQlpW1zVAzqB/sHynhLYq2BXe6Wb7wRrCOdDXtWyOulXLDubHtcpS5dvdKcZk5amIk8epX7Z/PIwkdsW6XZroyg+NZILAo8R0TdsynUWdqta62c4IWph2mUpDddyS8kAnj/WRd/nceZvhM1p+Uke3C1fqxyr/gbGysqbcovrU5vmTToES02yyImRdf9mfRqtmNZzM457XpQkPdikdUaOID+Vbr/UcTQ3OHlRd6OQ//5L9xBCVNeJZTumJkROXQdPEqWcwNK9PPq2Wn5ERIgqajPaxg9qZ+pVAsaHAdprtoc4qnk5ZMyWlwbr2Y0Mtm2Pzur0fH8xZQDORy1Bft76L6YGIhVqVsB1mGQ3uG1SUHxh5IUTKp4g01TDNQfkNR0yW++JwpkB14M6v9km8zGdKxTXmi1O9smnlijBUyoHkzmUIjt4DqP9sQ2TvyxQ0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199021)(71200400001)(7696005)(478600001)(33656002)(26005)(9686003)(6506007)(186003)(38100700002)(86362001)(38070700005)(82960400001)(122000001)(55016003)(4326008)(64756008)(66476007)(66556008)(76116006)(66946007)(66446008)(316002)(8936002)(8676002)(7416002)(7406005)(5660300002)(52536014)(41300700001)(4744005)(2906002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzVaQ0Voaktsam1HQlpITElFWUVMRkx6YUE2TFZROUxiUHlFMUx1TFRnTzlR?=
 =?utf-8?B?dFUrZUZKaWZkRDdKcjI1MW9uUUpPNGFYM1RvMmk2MnEyRi9xZktIcVJPUnhR?=
 =?utf-8?B?SERvUUZFMEtpbnUvNHF0cjY2VjMzTmNySmtlREZpWCtNY3dvYklXYVVla1dv?=
 =?utf-8?B?U0dKK3ZYckpzc3U1YnZMT3JPdllYVXBLNGNHT1ZDQ0c2UUNvcStrR2w2aWV0?=
 =?utf-8?B?eDFKdlpIaHdlWW5wZ0tUeFJ0WDJwYnlMTFNOSllvUTJFSTRScis5VEdGYVkw?=
 =?utf-8?B?OG1EMHAzbll6WEgvOFBwZXk5TWdWaVNkZzdCSVp3ZmRNbmNTdHRWZFdLNGJa?=
 =?utf-8?B?aGVIL2hnV1JnVmF5THQzNmVuR3h1YnBHSkZSMTBVUjRVeFp5dmdzUEp1Mkh4?=
 =?utf-8?B?RUJWbDRJVTBrOFl6VmI1bTBHM1NiWG8vL3NzSW5KL2dVVW9sZzBXaTJaNm03?=
 =?utf-8?B?ZW0xaXd2enhva2dHWnJYTFNhdHE5OXFCdGZVTUxZSzF5RG9pR0xteTJUT0h6?=
 =?utf-8?B?YzN1OVlBWGlSVlVEMmdrcS9DczI2N1BCODBvdEtVcjNBUWxvbnl4RWZydDkx?=
 =?utf-8?B?REhBMXJkbkVZRytQVmVEV1lTVEZNUWZFTGF0ZXhMd0t5TEJzb3dWWkJSWWN2?=
 =?utf-8?B?c1RMY3RjWWxoRHFKRWxWOXR2QlFXV3ZRbndnQ0IvVFVOd1pPOUZLRFlPQUJY?=
 =?utf-8?B?SlRlVjNESFZoeXJEa1hDejh1dkMvQXMyeWlmMndScmhmbC9JckhrMnBwOUND?=
 =?utf-8?B?NG1TSk03SVBjMmtIeFpLV3BNUWNhQmNkQ2syZlBLdEozbWhGWmk2TjhLZk0z?=
 =?utf-8?B?Nmh2MVNWdm5hVFZ6SGlaQmxMQmZMSjRLR3lpaWxMNS9MZzBhb0grVy9BTld0?=
 =?utf-8?B?Y2s4QitlRFhta2Ywd1cyYldiblAxU240N3JySGtJOU1VVUc4aDErRHFSaURF?=
 =?utf-8?B?cW8ySkxDb3hvMnNwMmZhYk4rMGVDNVp6RlZnakRWSnVnQmJyaStzSlhRS29w?=
 =?utf-8?B?S1pYOU1OcmpLS28xOGRrNEg2RFVkQ3orVmo3elJkUHRRTG1iRUl5SURUWi9p?=
 =?utf-8?B?QXovTTlvVVlQam9oR0JaeC9iNmRHVGhRS05HZzc4TXM3TmlLaW5Kak1JUXBL?=
 =?utf-8?B?ejJVem1hbWRZTGRHeGY5VkpEWEhTVnNRRWtrYm8rWWRoUzdkamlxdklqbmpL?=
 =?utf-8?B?eUo3RGg1VXpWZXd4MXo4MGFQa0gvYUtqMzRieFJMcU1wTllFYzNacVQ0bkFO?=
 =?utf-8?B?aEdtajVKaU5DamcyOEpha0t3c25ubmFVMjRDbVBFTjViM2hheFlDOUNOaWVs?=
 =?utf-8?B?a2lDY2hyWmJkcjJiOXo2N1drTlVZNG0yRHpMY3BOK3QvZGxqWS9IMFpJK2hE?=
 =?utf-8?B?cmhOd0xPSkp1Yytva08vcncyaFRXVFE3TVZvUHRKTzl1QXRQUU5qQUFidllz?=
 =?utf-8?B?c1JhazRoaEdLUHltbXZZbFU0QXhzSVRPYkk1SjFFMmJMZmhQS0pHRVB2b3BH?=
 =?utf-8?B?MDhUeWdYZ1R0Z3E0dDhVL3RPU3E3SkpnYlZpQ29YTnkvSG1uTjVhUzBnTDVk?=
 =?utf-8?B?YnVVZVlpd2d6d1FjVzFqbEY2M2l3cjhjKzBST1ZYNmJSTUNCMHkwak5uQzZq?=
 =?utf-8?B?VHZJbnRhQXo0bzRzU2d6aWVjRm5XMGhhWGhEc1dRbVR3MFo3eDBhMjZ4M3Vr?=
 =?utf-8?B?bERVUTNMeHROaXFZNTNzZXRtTXhET3dwUitMbnU4eU5NemVjMHc2OXUrU1J1?=
 =?utf-8?B?NzJybFlHcnYwWnBUQzhJQ3VLVHF0SkxqQm92M2ZENTN2aXVLdDlkV2hhV2Va?=
 =?utf-8?B?cmkxb2hwSzgzRWlkUVpRbndnYytTUTkyYzhiQ1Y3bDdDb0ZXczlIT3lPWHl2?=
 =?utf-8?B?TEVKb2l0ODBDb1lLQUY0VE1UT0wzZyt6d0o4czUwK1V4U0NCeTNxeGVuWU0y?=
 =?utf-8?B?dWZ3RDZVdkJmQStPY2trR0ora2lNNGp3U3RtRThZTmptOExJVUp0ZUNQRUJP?=
 =?utf-8?B?Y2oxUHRFUGt4TUZWV2g5MkxUUGVwZTdFUjQvSjFOVHU2SGNDS2MyY2s3aVFl?=
 =?utf-8?B?elRZL0ZDUjRjTnQyczBBcU5BaXFZU0pmNmNlTmNDbXNuVkh4TWNDa0dMTTJO?=
 =?utf-8?B?SDlpUHJHOUc4d1VWbmExeW9pZ29sZWV2L0Y0bUxEaDd5emZCQzg0TC9KTEU1?=
 =?utf-8?B?L0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57200e35-d453-4704-79c5-08db6b5e3a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 16:01:04.7093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdzcqnKMUQTxlWQcvxNDL05krk4cCaRz+2yrUavG3qd26CveA2XTYD6jjJwwZywyB2MULnJc3dbW0PC9R1uFSHCF+1cZJSETOSeLWzFWeeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5587
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PkZyb206IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPlNlbnQ6IE1vbmRh
eSwgSnVuZSAxMiwgMjAyMyA1OjMwIFBNDQo+DQo+T24gNi85LzIzIDA1OjE4LCBBcmthZGl1c3og
S3ViYWxld3NraSB3cm90ZToNCj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RyaXZlci1h
cGkvZHBsbC5yc3QgYi9Eb2N1bWVudGF0aW9uL2RyaXZlci0NCj5hcGkvZHBsbC5yc3QNCj4+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjhjYWE0YWYwMjJhZA0K
Pj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL2RwbGwu
cnN0DQo+PiBAQCAtMCwwICsxLDQ1OCBAQA0KPj4gKy4uIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wDQo+PiArDQo+PiArPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPj4g
K1RoZSBMaW51eCBrZXJuZWwgZHBsbCBzdWJzeXN0ZW0NCj4+ICs9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09DQo+PiArDQo+PiArVGhlIG1haW4gcHVycG9zZSBvZiBkcGxsIHN1YnN5c3Rl
bSBpcyB0byBwcm92aWRlIGdlbmVyYWwgaW50ZXJmYWNlDQo+PiArdG8gY29uZmlndXJlIGRldmlj
ZXMgdGhhdCB1c2UgYW55IGtpbmQgb2YgRGlnaXRhbCBQTEwgYW5kIGNvdWxkIHVzZQ0KPj4gK2Rp
ZmZlcmVudCBzb3VyY2VzIG9mIHNpZ25hbCB0byBzeW5jaHJvbml6ZSB0byBhcyB3ZWxsIGFzIGRp
ZmZlcmVudA0KPj4gK3R5cGVzIG9mIG91dHB1dHMuDQo+PiArVGhlIG1haW4gaW50ZXJmYWNlIGlz
IE5FVExJTktfR0VORVJJQyBiYXNlZCBwcm90b2NvbCB3aXRoIGFuIGV2ZW50DQo+PiArbW9uaXRv
cmluZyBtdWx0aWNhc3QgZ3JvdXAgZGVmaW5lZC4NCj4NCj5BIHNlY3Rpb24gdGhhdCBleHBsYWlu
cyB3aGF0ICJEUExMIiBzdGFuZHMgZm9yIGlzIG1pc3NpbmcuIFBsZWFzZSBhZGQNCj5zdWNoIGEg
c2VjdGlvbi4NCj4NCj5UaGFua3MsDQo+DQo+QmFydC4NCj4NCg0KU3VyZSwgd2lsbCBhZGQuDQoN
ClRoYW5rIHlvdSENCkFya2FkaXVzeg0KDQo=

