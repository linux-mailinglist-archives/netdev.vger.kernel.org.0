Return-Path: <netdev+bounces-1958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C7E6FFB84
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48B69281131
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFA512B86;
	Thu, 11 May 2023 20:54:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035F2918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:54:58 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD6E4EDA;
	Thu, 11 May 2023 13:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683838497; x=1715374497;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lgLn1kxQ7P8tt7aEo0vsgl6B6sAmIUH6CLPe5yY0wa0=;
  b=k1pl9+D/ujML79CsGANdpv/kOE0rvaPJariayF7rO/Qo5NX1BtMMzCSH
   MkiJejSC1dfosxfsy2FC4lgEHB90M4v1jXxkSWRAJb39fjy8DDztAVrG3
   ZrhZHxMBPvI1dzNSARn2RWANWkuXfCxXDsk/a7uNZZtUqgKRbxkoWd4Fl
   lTFkeuG1pPB17TgC5E9Ar3abx4LDFlANTmZVEpDgRrp2s3aVa1BGOKjIh
   YWrQ6B6lGPYkM9ctUrDUlUTelyCM3jILnD8yyqS7n9y/4YQow5aeLUykq
   nUQ2B9hjJsHT+5Bto0NpyW2vrkf0tuu9nDe3d8hqkZWKZtymEGReS9/p2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="330249508"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="330249508"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="650375580"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="650375580"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2023 13:54:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:54:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:54:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:54:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbCZF/S1vTBM/UvLkWYpjUGal5rcZhF5bO4Q8dqmU4q7dY0OLO4Ls1yZ6w6s9IbeLKTx81omXLmVZak9Sa3d8XZKPtFETOo7u5KQol5gjtO94EemFlmSbcjqhNFkndedWzo48g+wQOy6JGZ06MbH2xLEqlcKZP+NVh23W8MuJJdMdcGoO3yEaSP7LUAm5eaevtNnRACMs/Q4JrxPJ5EnEoMekvCpPas0DgvCov6SY2jkkJnBu9le3gyT3trbMi5cyNp+WNRoEtiNNd9hdCUYqKQV6cOLUSUNdWtAJs42ZyB1Lb6v+Aa6FH5p1J11oOlAYfc6lu54WvFYcoBIte5FDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5HpT7JCTf1CkFOePjCkXbpWnDK6QR2oFDjdWP6DwyE=;
 b=ZQVhwDFV1BxqvyjdpiTGTlfaHCd4CKEpbMu4jEmXtbjR9gypblwR3C8OwiNgHZJNATu/sJICD8zaIO4U7Pzi2CoEF2LQNnH+bT7CXP6KZm/VYD4TB+FgeYLjJcQkbU+/L3ryWmAbLhSKr6iFdw9rzx4ApFtBLRqUzAUCURtVHcCn3hLYvZh/fPBEHbYHeu7Yua8LX1MXiVfj/Os10TgAyUZNB5P35qqgptg6ptYJgXeHooTcGZtiHdK4xJltXPhCooDV7iTAda45/sTbJDfwckFWKYnMaUHu8unqkAb0mlqkN9hSI55P26jwaLg7CNk5vxUM9dyXk+v+C6ZKHnFbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.21; Thu, 11 May 2023 20:54:53 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.022; Thu, 11 May 2023
 20:54:53 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>, Jonathan
 Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech,
 Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgAGJJECACbBKAIAAWO/Q
Date: Thu, 11 May 2023 20:54:53 +0000
Message-ID: <DM6PR11MB4657F2BD5767B66A0B18AB009B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<MN2PR11MB466446F5594B3D90C7927E719B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <20230511082654.44883ebe@kernel.org>
In-Reply-To: <20230511082654.44883ebe@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: b7903d29-b755-4d84-e7a6-08db5261f864
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eAYo2K6c/xRn3g6g93Fg4lDv+8hCdIHHwsyEC96bgiYELrtfqzX+crWOF2I62gvRjzUN39UwV6ulooyq7aiINwO8Jqk1xTRQrN2DTJwkZrVfNB/ZYIynI9ngrbLfAPtfFbtIvhlHQpCGYi3ZMJd2C8Wco1R/HzxPZ8RA7k3Nfc1ivBtN7ZXuKO5z6jXPJVNx4FNZD6T4oeypBU0qZF+hMjLs8DwprthaHLfLMLuySIC0dNZF0dquzOhQzycZHJIQsKKlKcLX7950NvsSR/b5mRTgb4e7IEmBiUssVnhEsVPcJagI86epeoBAZMutv2NgRN5aWDk0MK9EeQhlucpa/3OLOTCOWbqBFWkIIQudgNRjMVw2tSdxtgZt9WyvUrGHEpsKt5+yzt8GOETaOuKuRBotiahHb9NvTMHH1n51+QQg5UKXSIgNOqcfhTfI77PQaflZ7/+JyYW36ezGGbmx0iaDvLzYnoYFNX98lPs7LoOWQX86bApyMYT9rdCH+9F+bAAfCMz3v7kuWkuuRWZJ/K1jQUrZzz++++C25dyuXzskC1YNzPFiEKXr7Own1JCJD10jIrDy3Cm03vLw2W886ltMB9qISKq+QG/6kE6jXYOqCGs6cJHAGE6aqmTsO7AF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(6916009)(5660300002)(41300700001)(52536014)(66946007)(76116006)(4326008)(316002)(66446008)(64756008)(66556008)(66476007)(8676002)(7416002)(8936002)(478600001)(54906003)(86362001)(2906002)(55016003)(38100700002)(83380400001)(7696005)(6506007)(9686003)(71200400001)(38070700005)(82960400001)(186003)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3PmhTNprAHq9KWDo1wuZULtfogJp3efHW16k0EiYWDgFF4t//ANyz/E4mgVk?=
 =?us-ascii?Q?KHPFEb24y2gzCa7wI/qZAz2iJDlLhf3dl8Oy5obe8t4XVJ6rU/8DfqvqhtFm?=
 =?us-ascii?Q?jc6u+Goyplcdu7UMcUzkxdGMcyNwNHqMgwlXoSbQplLwVo8t5QdChRDMIAOO?=
 =?us-ascii?Q?NhsAu4AoI/8+adBa6f0MJ20EunM+SKmw+BWa6e3v0HCixdATq63wRfzXBtIa?=
 =?us-ascii?Q?K8FWW3DAz7qs9dZ0Qwk11OBZLdY2WxLC3R2gYeo5DonKEAP4G/iKdwAnrHXg?=
 =?us-ascii?Q?3K4WbnOqQPSnf9xZm+mQVrooDzA8AZXy4bHX2KNXLmsSlAZ9fgrES01dIWfy?=
 =?us-ascii?Q?G2yOSvsFQWJ0FvGEMIK2FJsSkCOI6KIhtO8Cte5eLjgjd8aJGAupEYy5CFLY?=
 =?us-ascii?Q?uzAw6klFDt2m5dMmvPH/AWDDHkXQXKcFEjmrZJEyaJ+o+G29aYKxvAcqht0g?=
 =?us-ascii?Q?voCqA1CUr9n+LHeJOoHMRZ+Xl1VpFSIjM5RSTCFyN+BVM5ISAAiWKmA7Ax4G?=
 =?us-ascii?Q?MQN5BEAH2ozZF5Kpo2FXW9gZDJKrv4Nh7dLftUc7pb73UGkhlOvFDU8IMiSn?=
 =?us-ascii?Q?ElG7NFl4BmYYLVCN/+KB5gh3SJuyCiGhHi7Yqjjb0dpdnyk6//AoJZBgnb6p?=
 =?us-ascii?Q?RGqL9TS2hikFNbVyWjXs61OQb681VWDSaSGoc3+3SuKZFrd8u/ocZT2A82mH?=
 =?us-ascii?Q?UzG3ePaaGC6qRVC6abVihUV/3h2W1qgbOLbpesBxSTQ7ECpTev35k4zuwAqQ?=
 =?us-ascii?Q?Rs8P4popLKr1VCYmi8Ztxk9IsDS5P71JzgW2tySeZhO0GQFnk+cmBk+MtxJy?=
 =?us-ascii?Q?oUyaGGjuH37o0EvEKssX0ZMRSBuZX2PSKkmEmdbUpQjYh4Q5MGSUQ0hyEdbO?=
 =?us-ascii?Q?V9eihNT1ayHE1oq1kPb8805bmyFXOi/PZH36CskdaryqKFl09zCyXayDQEkb?=
 =?us-ascii?Q?kU4mivG/U3A+Rswu1QXpoSlUv0J2uvZOV6n8hEyQtm7+z00uferNjTNItcEp?=
 =?us-ascii?Q?6QerhX6xmVy0PGANJ2ct3hQKM6TjLJ3TXWPxe2JQbuKnVXR3W4bqy+y7m1jP?=
 =?us-ascii?Q?cvFcaiZPRVGuBZuyOaunY6S0SwrPkAjxIBM64ekpq4OrkNk6vr3tbIp1PV+v?=
 =?us-ascii?Q?k2r5g5RI2XQAYohw+cX/7Wmvgn2l3AyPH+/h3E5YvTzVJ4QylXLem4Jcy3cC?=
 =?us-ascii?Q?bWL8uJ+h9B951LR5nj769uRd7S2sgS5ah67XG83r+JLWFXfw9OhzeYbFydpj?=
 =?us-ascii?Q?OKByzNASS5xT6C5Hbac5Z8/ECLXpXMDtZySI15B4elvDQ1J6ggnacIUrUUhE?=
 =?us-ascii?Q?sgodabWXjrKsQGGo+1LhuCDHOVVBntbfriSdDXf83RUfSl8zN0L2M1JyR7pO?=
 =?us-ascii?Q?x2bVZoJc4d/w1qCMI3WM+EYhnjoW/+xOaWQaRb+gl07LCUe2t0BSECPJQQRz?=
 =?us-ascii?Q?AkRwh427Ne/4Suxxt/hu6Cki+UifkQvvcWMg1AEAbCqntBYvJ+/G2M476vaL?=
 =?us-ascii?Q?fJ3sW4WQkeEjj2IUW2qdY/Whc7OhCREtod2GVqmJ1T7663L/exDBaJT4E+94?=
 =?us-ascii?Q?rczBxjoY9ZjEf1ui4sUF9fa2S3zfTVsvlehuu/aJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b7903d29-b755-4d84-e7a6-08db5261f864
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 20:54:53.5376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pr3gVPZoijw6PRue2ub1IBiaRUaEoZNATQq6WywLJhlV7/yjoA4NqRPZR4ZfF01y8a0eC1zIMZolytVYnhwIBd+mFq63v4gFexqLN01SNsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, May 11, 2023 5:27 PM
>
>On Thu, 11 May 2023 07:38:04 +0000 Kubalewski, Arkadiusz wrote:
>> >>+  -
>> >>+    type: enum
>> >>+    name: event
>> >>+    doc: events of dpll generic netlink family
>> >>+    entries:
>> >>+      -
>> >>+        name: unspec
>> >>+        doc: invalid event type
>> >>+      -
>> >>+        name: device-create
>> >>+        doc: dpll device created
>> >>+      -
>> >>+        name: device-delete
>> >>+        doc: dpll device deleted
>> >>+      -
>> >>+        name: device-change
>> >
>> >Please have a separate create/delete/change values for pins.
>> >
>>
>> Makes sense, but details, pin creation doesn't occur from uAPI perspecti=
ve,
>> as the pins itself are not visible to the user. They are visible after t=
hey
>> are registered with a device, thus we would have to do something like:
>> - pin-register
>> - pin-unregister
>> - pin-change
>>
>> Does it make sense?
>
>I missed this, notifications should be declared under operations.
>
>Please look at netdev.yaml for an example.
>
>I thought about implementing this model where events are separate
>explicitly but I think it's an unnecessary complication.

Ok, will do.

Thank you!
Arkadiusz

