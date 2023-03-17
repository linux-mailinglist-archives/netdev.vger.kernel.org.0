Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3DB6BECA4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCQPPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjCQPOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:14:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8332A2680;
        Fri, 17 Mar 2023 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679066090; x=1710602090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O0L/ux81PJB7HPn6YqlhKs+tB6ClLmGB8OahtjcIGxM=;
  b=nRXb2gV8B3PcXvm7xTyY+Z/KB3zsMoj4KsfUZAcJSe1dBHYwvJLaOGGW
   tallZ5Lq1NTVDQ8cEbBPeWSSt46Xkw01OsYnUimeJmlzEgqc/EylJ1TGM
   Aqhf/0i1yEJy/kz+bO4gfEIafjOs94awwYAIzqryiD0ooPb2KhE0Lzzd6
   RkOR20ZR3iq042l2ryMmmYoQxZWC9aFxx1AURIVpdoIiKF02OQR0fuPTz
   SbptqgdDuszs5VPC4QiPj7qqwQRnpMHRiFcd79L6fQ96B6BGYYoWz2vdx
   qkM/9uVXZt74C2K1/kwwWbCJeWJH2d/G6fb+UdjuUUsdFzekl4q9VewAp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="338301649"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="338301649"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 08:14:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="673586569"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="673586569"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2023 08:14:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:14:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:14:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 08:14:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxq350LlKVcepYh4Ug5DyqONkxll0729gdqUa0huML57aIE3Ktm8u9P82QXn5Dh8QQIwzHcpC3oOERetVWTcumeunfJarBPsaUnYv8G6ToEYgTI/aFoOCogl+n5JxNJQMW0O9lMkvLi63XjYIRz4O1Hrq9m4EVvYOdSR7pEeJvCZJJQumRnZF4YS3xxHvZ+rU5nhcmuvvP4XwDExs14wVXKKelodV+NdgbGXgDgbgrvvRtQXrX5d118IVRbRKKKeBrBIdYd388OKqVLc1RhxvvuVH5JfEU84gCuO3vgoikXA9tmLS4DlRK4QQpkPXYxjIeOg9tBqnQUAVtnDDRFyug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrbDoxRPKndWHkObeH7A8irqTsOZQmTdoJ+sU0eJNeM=;
 b=BfAHRqNlfdEHZH/4ZzYMp2D97jy5WDXoLixYlsJD/9U7VIpg6ycicLOtkgNqUMt1j5v/0kMQEu8wqQ04l/F/VQYzM/AZhTC+2KiTnYLPgWMQnbqwN/uzbjdTuOkzlU6UKtqbzSZX6jpdzFYyWWR3QuQEL3Ly6TsBmkudrZ2Q+cZ/u/OO4yKXEdv9anNge5CluzYPvvqaLt8zR0coyMPCMuCuk+F/SYcpEW6y0xtPXd84PzPUltsQhMqJZF0ehPZ0+3xLXkCquRiAP1YfrQ8CWBwdi7y1Oe+ikRN4Jz02QTYEZxnu9vghXeoeMe75KuSzQwf2eVrA+nQQ0V6OSiSo8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS0PR11MB6400.namprd11.prod.outlook.com (2603:10b6:8:c7::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Fri, 17 Mar 2023 15:14:46 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Fri, 17 Mar 2023
 15:14:46 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK76Xc8AgAML3PCAAAhNAIAAnfVQgAC2+wCAAC320A==
Date:   Fri, 17 Mar 2023 15:14:45 +0000
Message-ID: <DM6PR11MB4657F48649CFEB92D28D4ED49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBQ7ZuJSXRfFOy1b@nanopsycho>
In-Reply-To: <ZBQ7ZuJSXRfFOy1b@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS0PR11MB6400:EE_
x-ms-office365-filtering-correlation-id: 9e7a7053-de99-47f0-d76b-08db26fa57ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +qAIJEPLp7DWxHja+3XW4hvJMpy4DZVfOUW2EDXzKOlrMxfX+VxQIMry8Xb4u2Ul05N/9vXf+qDkde1UJvbzjVmPgAAkXsY5w3ymz9kOmWvBIkud1jYjx5iZFSceRHV+v1KXk3481yavFlw7TvLQrmioFLPyLrH6F0DG4WsyY63WNhyljghFLXO3S/SaR76OFvT9pae4GHVIaJofb22pE5/vV2cuahpVmOgEQBvSu219vP+JBQfmSL3Xtg0s/RgGuVoOblGWgoKdEORgJJVKCWm1yGo3ToZGOakSoT67QYnmIhfWZhO2Rj4z6is6weY4NTHsFYr8SVWzy77RIwjLWoZnagKhnaL3HbQ+awqblw4YAGxupu0/zATgWM+thZGQvBpd7YGvVPWBr7U6I44SxrwPVRj09i2pl0DaTq7iRrCaEHnvnfbqsAeVXxgI8rPhS3JrnJpeT11qXpEVoW/p8OmYRjdo+thw7bpVRNnBsC+ZzTYPtQ6mAQ03YP4skGX9K3qvAZ9YUdlCKzrGExSJMb8FdAddH571733eCCzw4PdGiPdGbdnl2baH/682zodcVevYp1GB7Fc6TQ36aBwjMc5NV1mLXWSY91ebB1IYDOrirnU72izBS/0Yss8XJtKjBLpXTRApWBXzgr3HmgmkIOe0LKtP/giwNfr78a0gvPij/EruLdJkfIwvevHpPgh1R9jft5aHNKpb+Y2XCNSy/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(54906003)(316002)(33656002)(38100700002)(86362001)(186003)(55016003)(83380400001)(122000001)(107886003)(26005)(9686003)(6506007)(82960400001)(66556008)(71200400001)(5660300002)(38070700005)(478600001)(8676002)(52536014)(8936002)(2906002)(64756008)(66946007)(6916009)(66476007)(4326008)(7696005)(66446008)(41300700001)(76116006)(7416002)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jypWhmI1YJvkK2lx/A0hlVEYsXK8tzKNjJJdbsCk+E1VOiSNxbF7IQfUBJZi?=
 =?us-ascii?Q?nEmN1qs4IYXsAc2Ie6hYGh7UuxiUXRg+ocLNZ4iCAvjJNDHgNfn4EQE9ou3J?=
 =?us-ascii?Q?4hIHc18z7LCyfRmScneMev8Idjy0Va8c17Bc3hZrXjXc5Ts9Uv4g5ur2Hob/?=
 =?us-ascii?Q?I7UeVsRueOhBRHhmqeIHjVHvcRFuAQmguRehWzVn3Xlf1xK2ozddPh6Zj01d?=
 =?us-ascii?Q?QK3aCy1Sjo6e1h//xbzmTnuSu7SH67ugJvUcYXyAXN1Pg2nSDu6q+sZ7IMgr?=
 =?us-ascii?Q?yopT8xecxaOIaFKDwEEfI06tRl/hyxI6vKTH19Fd3ANaJzSEiBxZ4tFanTu+?=
 =?us-ascii?Q?0sNAEhF0Q/yuH5Uz3bDwUzOrIAPxbdoQIUpDDGYHAdpnCyPKLoYDldqUFdf3?=
 =?us-ascii?Q?AkFBEF0T1ptJ7K2a7wFb27PGF0cQikMzcFmhMG3va5CiYgHKtsZaCVmNgdWq?=
 =?us-ascii?Q?GWWJI/1NugIblk+uC9xnBgpRA6QuuLAjASN+TgmfoLIalToVoP0OpmIiP2gY?=
 =?us-ascii?Q?R0znR3wfY8MY/1+w6XnFrleLBwWSb6Lvy1gDDWY+EMhJ+AI896gXeco9X2Qc?=
 =?us-ascii?Q?2lM2FIRKepq7H1xl3GqjWFQYHovjsPg03KD5chw1R0HnhqTr5aarK9mOKEmt?=
 =?us-ascii?Q?SHrnhRad9zhalWKabzMhcxl/Taq67SST21eEKRGI+7Cq9eGN/UG0o3JDk51h?=
 =?us-ascii?Q?au4DWS0y4bn12Fmni1Z7s+p5UD3Lxa+J9QSQIHoQF6dGA8D/Fzr3wcbI0wQP?=
 =?us-ascii?Q?U1PG9xXDSDABRLG9ENNT7h0WloGX7UkeLUn34AF+r4CVDKUVv3vdyzdT3//m?=
 =?us-ascii?Q?pCWCZnWI0F1DzIdL951omXKnwHMwowYDWURHLka2OW0LDRDp5Cqivv+msAC3?=
 =?us-ascii?Q?F8S+c74INxsUYBcas3Gdwb3vh2lUv08eyK/SMnoxBVu8bTQD12QoodfxS0pn?=
 =?us-ascii?Q?Xx/dnfhlPQBdFFYWKeC/FszQBPXGhZBH3/OxsnYNSVw4E0EwKkgnx63dms0E?=
 =?us-ascii?Q?o++N+1IuW03iV3/VN25oDUs+1QlL6R0/2AAeP7GL0iqhLYsJFQsgCIpbKs3J?=
 =?us-ascii?Q?C96EBe5YKRgt9z7knIts6GAHjaU4fmPU78/bFGS2lzY8i0Srm9lRk2as8uPF?=
 =?us-ascii?Q?pVVD+ulqOb7UyQRt9UweMXRVjN/eJQTnXG12nuzLtxjdT7hLRha1KZ2i/6IP?=
 =?us-ascii?Q?nKr1wy+JltXCvb9+48jjn/OTJG2cM4xTAc4N7lfMeX3GXXyazn0lbwhdn9Un?=
 =?us-ascii?Q?UEYS7mr6aUQu4G8y3mRegKHnWNtPlfeCLx5p66LWt7t+tm1ZgpFPmtoHsCLW?=
 =?us-ascii?Q?/H8zXYEs4NCz5GiYjCblApXnB4qe9fTaS5f6LM9MksztmS8kITF+zA53NNfq?=
 =?us-ascii?Q?jexesrVBnN/IwsDmjGA9LH2La5tPXV/zZxmc6L0xg5xnyIBXPfGzcDkqqFWE?=
 =?us-ascii?Q?jO4Jx9hAYE+106iv7vqiUg2CcLMFpgPCo85LX+C4MQ9I5/IdzwvR0y47TEdJ?=
 =?us-ascii?Q?6KiOr0WrE9YlXN+OceX54FiE+uh/71aZDUlDyj3lgaw11hYWtAvCac27bPQI?=
 =?us-ascii?Q?c1Pj+eONY26f2UxP6iWPMKgRdEI2XsxmSW9D7oNvrveLvw/t2UvWUj9r8UnE?=
 =?us-ascii?Q?IQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7a7053-de99-47f0-d76b-08db26fa57ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 15:14:46.1120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0T7Zym5ve985juR2gz6DY5G0UdwI/TemwPN0MYjTRHSrPZjnDoQi3R68w0Tx9yFVjYxbHww+lOebYke1Xb+cXcAiUaKvP8GudrokiG197s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6400
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, March 17, 2023 11:05 AM
>
>Fri, Mar 17, 2023 at 01:52:44AM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Thursday, March 16, 2023 2:45 PM
>>>
>>
>>[...]
>>
>>>>>>+attribute-sets:
>>>>>>+  -
>>>>>>+    name: dpll
>>>>>>+    enum-name: dplla
>>>>>>+    attributes:
>>>>>>+      -
>>>>>>+        name: device
>>>>>>+        type: nest
>>>>>>+        value: 1
>>>>>>+        multi-attr: true
>>>>>>+        nested-attributes: device
>>>>>
>>>>>What is this "device" and what is it good for? Smells like some leftov=
er
>>>>>and with the nested scheme looks quite odd.
>>>>>
>>>>
>>>>No, it is nested attribute type, used when multiple devices are returne=
d
>>>>with netlink:
>>>>
>>>>- dump of device-get command where all devices are returned, each one
>>>>nested
>>>>inside it:
>>>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id': 0}=
,
>>>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id':
>>>>1}]}]
>>>
>>>Okay, why is it nested here? The is one netlink msg per dpll device
>>>instance. Is this the real output of you made that up?
>>>
>>>Device nest should not be there for DEVICE_GET, does not make sense.
>>>
>>
>>This was returned by CLI parser on ice with cmd:
>>$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
>>--dump device-get
>>
>>Please note this relates to 'dump' request , it is rather expected that
>there
>>are multiple dplls returned, thus we need a nest attribute for each one.
>
>No, you definitelly don't need to nest them. Dump format and get format
>should be exactly the same. Please remove the nest.
>
>See how that is done in devlink for example: devlink_nl_fill()
>This functions fills up one object in the dump. No nesting.
>I'm not aware of such nesting approach anywhere in kernel dumps, does
>not make sense at all.
>

Yeah it make sense to have same output on `do` and `dump`, but this is also
achievable with nest DPLL_A_DEVICE, still don't need put extra header for i=
t.
The difference would be that on `dump` multiple DPLL_A_DEVICE are provided,
on `do` only one.

Will try to fix it.
Although could you please explain why it make sense to put extra header
(exactly the same header) multiple times in one netlink response message?=20

>
>>
>>>
>>>>
>>>>- do/dump of pin-get, in case of shared pins, each pin contains number
>of
>>>dpll
>>>>handles it connects with:
>>>>[{'pin': [{'device': [{'bus-name': 'pci',
>>>>                       'dev-name': '0000:21:00.0_0',
>>>>                       'id': 0,
>>>>                       'pin-prio': 6,
>>>>                       'pin-state': {'doc': 'pin connected',
>>>>                                     'name': 'connected'}},
>>>>                      {'bus-name': 'pci',
>>>>                       'dev-name': '0000:21:00.0_1',
>>>>                       'id': 1,
>>>>                       'pin-prio': 8,
>>>>                       'pin-state': {'doc': 'pin connected',
>>>>                                     'name': 'connected'}}],
>>>
>>>Okay, here I understand it contains device specific pin items. Makes
>>>sense!
>>>
>>
>>Good.
>
>Make sure you don't nest the pin objects for dump (DPLL_A_PIN). Same
>reason as above.
>I don't see a need for DPLL_A_PIN attr existence, please remove it.
>
>

Sure, will try.

>
>
>>
>>[...]
>>
>>>>
>>>>>
>>>>>
>>>>>>+      -
>>>>>>+        name: pin-prio
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-state
>>>>>>+        type: u8
>>>>>>+        enum: pin-state
>>>>>>+      -
>>>>>>+        name: pin-parent
>>>>>>+        type: nest
>>>>>>+        multi-attr: true
>>>>>>+        nested-attributes: pin
>>>>>>+        value: 23
>>>>>
>>>>>Value 23? What's this?
>>>>>You have it specified for some attrs all over the place.
>>>>>What is the reason for it?
>>>>>
>>>>
>>>>Actually this particular one is not needed (also value: 12 on pin above=
),
>>>>I will remove those.
>>>>But the others you are refering to (the ones in nested attribute list),
>>>>are required because of cli.py parser issue, maybe Kuba knows a better =
way
>>>to
>>>>prevent the issue?
>>>>Basically, without those values, cli.py brakes on parsing responses, af=
ter
>>>>every "jump" to nested attribute list it is assigning first attribute
>>>there
>>>>with value=3D0, thus there is a need to assign a proper value, same as =
it is
>>>on
>>>>'main' attribute list.
>>>
>>>That's weird. Looks like a bug then?
>>>
>>
>>Guess we could call it a bug, I haven't investigated the parser that much=
,
>>AFAIR, other specs are doing the same way.
>>
>>>
>>>>
>>>>>
>>>>>>+      -
>>>>>>+        name: pin-parent-idx
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-rclk-device
>>>>>>+        type: string
>>>>>>+      -
>>>>>>+        name: pin-dpll-caps
>>>>>>+        type: u32
>>>>>>+  -
>>>>>>+    name: device
>>>>>>+    subset-of: dpll
>>>>>>+    attributes:
>>>>>>+      -
>>>>>>+        name: id
>>>>>>+        type: u32
>>>>>>+        value: 2
>>>>>>+      -
>>>>>>+        name: dev-name
>>>>>>+        type: string
>>>>>>+      -
>>>>>>+        name: bus-name
>>>>>>+        type: string
>>>>>>+      -
>>>>>>+        name: mode
>>>>>>+        type: u8
>>>>>>+        enum: mode
>>>>>>+      -
>>>>>>+        name: mode-supported
>>>>>>+        type: u8
>>>>>>+        enum: mode
>>>>>>+        multi-attr: true
>>>>>>+      -
>>>>>>+        name: source-pin-idx
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: lock-status
>>>>>>+        type: u8
>>>>>>+        enum: lock-status
>>>>>>+      -
>>>>>>+        name: temp
>>>>>>+        type: s32
>>>>>>+      -
>>>>>>+        name: clock-id
>>>>>>+        type: u64
>>>>>>+      -
>>>>>>+        name: type
>>>>>>+        type: u8
>>>>>>+        enum: type
>>>>>>+      -
>>>>>>+        name: pin
>>>>>>+        type: nest
>>>>>>+        value: 12
>>>>>>+        multi-attr: true
>>>>>>+        nested-attributes: pin
>>>>>
>>>>>This does not belong here.
>>>>>
>>>>
>>>>What do you mean?
>>>>With device-get 'do' request the list of pins connected to the dpll is
>>>>returned, each pin is nested in this attribute.
>>>
>>>No, wait a sec. You have 2 object types: device and pin. Each have
>>>separate netlink CMDs to get and dump individual objects.
>>>Don't mix those together like this. I thought it became clear in the
>>>past. :/
>>>
>>
>>For pins we must, as pins without a handle to a dpll are pointless.
>
>I'm not talking about per device specific items for pins (state and
>prio). That is something else, it's a pin-device tuple. Completely fine.
>
>
>
>>Same as a dpll without pins, right?
>>
>>'do' of DEVICE_GET could just dump it's own status, without the list of
>pins,
>
>Yes please.
>
>
>>but it feels easier for handling it's state on userspace counterpart if
>>that command also returns currently registered pins. Don't you think so?
>
>No, definitelly not. Please make the object separation clear. Device and
>pins are different objects, they have different commands to work with.
>Don't mix them together.
>

It does, since the user app wouldn't have to dump/get pins continuously.
But yeah, as object separation argument makes sense will try to fix it.

>
>>
>>>
>>>>This is required by parser to work.
>>>>
>>>>>
>>>>>>+      -
>>>>>>+        name: pin-prio
>>>>>>+        type: u32
>>>>>>+        value: 21
>>>>>>+      -
>>>>>>+        name: pin-state
>>>>>>+        type: u8
>>>>>>+        enum: pin-state
>>>>>>+      -
>>>>>>+        name: pin-dpll-caps
>>>>>>+        type: u32
>>>>>>+        value: 26
>>>>>
>>>>>All these 3 do not belong here are well.
>>>>>
>>>>
>>>>Same as above explanation.
>>>
>>>Same as above reply.
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>+  -
>>>>>>+    name: pin
>>>>>>+    subset-of: dpll
>>>>>>+    attributes:
>>>>>>+      -
>>>>>>+        name: device
>>>>>>+        type: nest
>>>>>>+        value: 1
>>>>>>+        multi-attr: true
>>>>>>+        nested-attributes: device
>>>>>>+      -
>>>>>>+        name: pin-idx
>>>>>>+        type: u32
>>>>>>+        value: 13
>>>>>>+      -
>>>>>>+        name: pin-description
>>>>>>+        type: string
>>>>>>+      -
>>>>>>+        name: pin-type
>>>>>>+        type: u8
>>>>>>+        enum: pin-type
>>>>>>+      -
>>>>>>+        name: pin-direction
>>>>>>+        type: u8
>>>>>>+        enum: pin-direction
>>>>>>+      -
>>>>>>+        name: pin-frequency
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-frequency-supported
>>>>>>+        type: u32
>>>>>>+        multi-attr: true
>>>>>>+      -
>>>>>>+        name: pin-any-frequency-min
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-any-frequency-max
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-prio
>>>>>>+        type: u32
>>>>>>+      -
>>>>>>+        name: pin-state
>>>>>>+        type: u8
>>>>>>+        enum: pin-state
>>>>>>+      -
>>>>>>+        name: pin-parent
>>>>>>+        type: nest
>>>>>>+        multi-attr: true
>>>>>
>>>>>Multiple parents? How is that supposed to work?
>>>>>
>>>>
>>>>As we have agreed, MUXed pins can have multiple parents.
>>>>In our case:
>>>>/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>>>>pin-get --json '{"id": 0, "pin-idx":13}'
>>>>{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0',
>>>>'id': 0},
>>>>                     {'bus-name': 'pci',
>>>>                      'dev-name': '0000:21:00.0_1',
>>>>                      'id': 1}],
>>>>          'pin-description': '0000:21:00.0',
>>>>          'pin-direction': {'doc': 'pin used as a source of a signal',
>>>>                            'name': 'source'},
>>>>          'pin-idx': 13,
>>>>          'pin-parent': [{'pin-parent-idx': 2,
>>>>                          'pin-state': {'doc': 'pin disconnected',
>>>>                                        'name': 'disconnected'}},
>>>>                         {'pin-parent-idx': 3,
>>>>                          'pin-state': {'doc': 'pin disconnected',
>>>>                                        'name': 'disconnected'}}],
>>>>          'pin-rclk-device': '0000:21:00.0',
>>>>          'pin-type': {'doc': "ethernet port PHY's recovered clock",
>>>>                       'name': 'synce-eth-port'}}]}
>>>
>>>Got it, it is still a bit hard to me to follow this. Could you
>>>perhaps extend the Documentation to describe in more details
>>>with examples? Would help a lot for slower people like me to understand
>>>what's what.
>>>
>>
>>Actually this is already explained in "MUX-type pins" paragraph of
>>Documentation/networking/dpll.rst.
>>Do we want to duplicate this explanation here?
>
>No, please extend the docs. As I wrote above, could you add some
>examples, like the one you pasted above. Examples always help to
>undestand things much better.
>

Sure, fixed.

>
>>
>>
>>>
>>>>
>>>>
>>>>>
>>>>>>+        nested-attributes: pin-parent
>>>>>>+        value: 23
>>>>>>+      -
>>>>>>+        name: pin-rclk-device
>>>>>>+        type: string
>>>>>>+        value: 25
>>>>>>+      -
>>>>>>+        name: pin-dpll-caps
>>>>>>+        type: u32
>>>>>
>>>>>Missing "enum: "
>>>>>
>>>>
>>>>It is actually a bitmask, this is why didn't set as enum, with enum typ=
e
>>>>parser won't parse it.
>>>
>>>Ah! Got it. Perhaps a docs note with the enum pointer then?
>>>
>>
>>Same as above, explained in Documentation/networking/dpll.rst, do wan't t=
o
>>duplicate?
>
>For this, yes. Some small doc note here would be quite convenient.
>
>Also, I almost forgot: Please don't use NLA_U32 for caps flags. Please
>use NLA_BITFIELD32 which was introduced for exactly this purpose. Allows
>to do nicer validation as well.
>

Actually BITFIELD32 is to much for this case, the bit itself would be enoug=
h
as we don't need validity bit.
But yeah, as there is no BITMASK yet, will try to change to BITFIELD32.

[...]

>>>>>
>>>>>Hmm, shouldn't source-pin-index be here as well?
>>>>
>>>>No, there is no set for this.
>>>>For manual mode user selects the pin by setting enabled state on the on=
e
>>>>he needs to recover signal from.
>>>>
>>>>source-pin-index is read only, returns active source.
>>>
>>>Okay, got it. Then why do we have this assymetric approach? Just have
>>>the enabled state to serve the user to see which one is selected, no?
>>>This would help to avoid confusion (like mine) and allow not to create
>>>inconsistencies (like no pin enabled yet driver to return some source
>>>pin index)
>>>
>>
>>This is due to automatic mode were multiple pins are enabled, but actual
>>selection is done on hardware level with priorities.
>
>Okay, this is confusing and I believe wrong.
>You have dual meaning for pin state attribute with states
>STATE_CONNECTED/DISCONNECTED:
>
>1) Manual mode, MUX pins (both share the same model):
>   There is only one pin with STATE_CONNECTED. The others are in
>   STATE_DISCONNECTED
>   User changes a state of a pin to make the selection.
>
>   Example:
>     $ dplltool pin dump
>       pin 1 state connected
>       pin 2 state disconnected
>     $ dplltool pin 2 set state connected
>     $ dplltool pin dump
>       pin 1 state disconnected
>       pin 2 state connected
>
>2) Automatic mode:
>   The user by setting "state" decides it the pin should be considered
>   by the device for auto selection.
>
>   Example:
>     $ dplltool pin dump:
>       pin 1 state connected prio 10
>       pin 2 state connected prio 15
>     $ dplltool dpll x get:
>       dpll x source-pin-index 1
>
>So in manual mode, STATE_CONNECTED means the dpll is connected to this
>source pin. However, in automatic mode it means something else. It means
>the user allows this pin to be considered for auto selection. The fact
>the pin is selected source is exposed over source-pin-index.
>
>Instead of this, I believe that the semantics of
>STATE_CONNECTED/DISCONNECTED should be the same for automatic mode as
>well. Unlike the manual mode/mux, where the state is written by user, in
>automatic mode the state should be only written by the driver. User
>attemts to set the state should fail with graceful explanation (DPLL
>netlink/core code should handle that, w/o driver interaction)
>
>Suggested automatic mode example:
>     $ dplltool pin dump:
>       pin 1 state connected prio 10 connectable true
>       pin 2 state disconnected prio 15 connectable true
>     $ dplltool pin 1 set connectable false
>     $ dplltool pin dump:
>       pin 1 state disconnected prio 10 connectable false
>       pin 2 state connected prio 15 connectable true
>     $ dplltool pin 1 set state connected
>       -EOPNOTSUPP
>
>Note there is no "source-pin-index" at all. Replaced by pin state here.
>There is a new attribute called "connectable", the user uses this
>attribute to tell the device, if this source pin could be considered for
>auto selection or not.
>
>Could be called perhaps "selectable", does not matter. The point is, the
>meaning of the "state" attribute is consistent for automatic mode,
>manual mode and mux pin.
>
>Makes sense?
>

Great idea!
I will add third enum for pin-state: DPLL_PIN_STATE_SELECTABLE.
In the end we will have this:
              +--------------------------------+
              | valid DPLL_A_PIN_STATE values  |
	      +---------------+----------------+
+------------+| requested:    | returned:      |
|DPLL_A_MODE:||               |                |
|------------++--------------------------------|
|AUTOMATIC   ||- SELECTABLE   | - SELECTABLE   |
|            ||- DISCONNECTED | - DISCONNECTED |
|            ||               | - CONNECTED    |
|------------++--------------------------------|
|MANUAL      ||- CONNECTED    | - CONNECTED    |
|            ||- DISCONNECTED | - DISCONNECTED |
+------------++---------------+----------------+

Thank you,
Arkadiusz

>
>>
>>[...]
>>
>>>>>>+
>>>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE=
 +
>>>>>>1]
>>>>>>=3D {
>>>>>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>>>>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>>>+	[DPLL_A_MODE] =3D NLA_POLICY_MAX(NLA_U8, 5),
>>>>>
>>>>>Hmm, any idea why the generator does not put define name
>>>>>here instead of "5"?
>>>>>
>>>>
>>>>Not really, it probably needs a fix for this.
>>>
>>>Yeah.
>>>
>>
>>Well, once we done with review maybe we could also fix those, or ask
>>Jakub if he could help :)
>>
>>
>>[...]
>>
>>>>>
>>>>>>+	DPLL_A_PIN_PRIO,
>>>>>>+	DPLL_A_PIN_STATE,
>>>>>>+	DPLL_A_PIN_PARENT,
>>>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>>>
>>>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>>>>>enum name.
>>>>
>>>>Sure, fixed.
>>>
>>>
>>>Thanks for all your work on this!
>>
>>Thanks for a great review! :)
>
>Glad to help.
