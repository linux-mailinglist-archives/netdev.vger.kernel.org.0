Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F416F019D
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbjD0HYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242821AbjD0HYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 03:24:36 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE6C49D9
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 00:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682580254; x=1714116254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AknQQdcurFLL952IboUu3W0MlTGuiC7CSw2z5o19EuU=;
  b=AzBcuPgDiUHdaw8joW/E0lNU4avkCwb1QPRwOjlLJnI4u8+N46iGHfAd
   QdoNPiuGSRRaP8P/yyvW72tvCwl3hkEtScg6iimWPowcxlNY125q+/h+h
   P6UZ9ofNDfDDAl/z+PzsAA8Mq+Dts2oDufjKbfDjhYepm9huP6hVgBsvz
   3qTQ25Xt0jYTYU0A9tfTvUuIZmr2Y72SXES4ngmw3ZmrGr23LOTLVYG38
   v+Ux2wIeWzVrXlrJu7QtipNObF8ICFRBLrkT6EAIgjphVDwDEXoug48Kz
   JJEYhD6iFiyqjF4/vJZj82SJ5zgkLvDFHhtXnaQNZAW/arVie4uFStXJM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="349306790"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="349306790"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 00:24:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="783613902"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="783613902"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2023 00:24:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:24:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 00:24:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 00:24:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeSpRO4SXqk+rfP/r981auDRvA6lpQuCWvdjJQwEF5yRXx9hmje0DTyiaY8fVsxi1kfS9jCzCmID/lLFItWiaNL1BlvItuBkDAkJNioD0xbHoSqgIaYxaMYx5OeZdUbNNjvGIFoIJRzA/m8/pm0seWucmZBYi/fBteiETPPXhuUYYiAnIxf1xjrHtm57VNEg5WOtl0B+8LB//+y0sNLZVlPkJZjUD9Hpn6NaWuzB5wA2ywDfGw5SUqRrCuoWz+/2MEztBvhCfRT4KKcf3BV0U+ZRLT+sBHpqvqiTPPRftzfGr/ptUQ4BuasUTTmFuABkjEEsYTzW6KP3Wt50sFdb7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AknQQdcurFLL952IboUu3W0MlTGuiC7CSw2z5o19EuU=;
 b=KF5hg0t0reh+T3yYYYbI7bjDB/4lW6gXUDbtTRBeFVieSXR9XowEHcVRYT3Ix4IZe4Nrv+oZnTbrTynYhFni+3xiMFyQaOw0fB2JNHM89m2HHBuyWS4rpwdk5dFSFpJiJYgfoj8k1CfpDnbIfVNcPHmeVH43tNunokBS610iYAN9WT8tLZetvCglIcWvyGVWK958b+Y6S22KDoY8q1LET8qZX2X2sHOQA92H386rCEk2fB6gSNjXSJtakVd/YOnq8a4Mr33BTEZztWHDewJtQ+5ouuzGjkycZJnBTqcBPPR8o6T2OiPae8FqobhCzv3xxRwtpOqIogFUfMr48rzP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MW5PR11MB5929.namprd11.prod.outlook.com (2603:10b6:303:194::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Thu, 27 Apr
 2023 07:24:05 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6319.033; Thu, 27 Apr 2023
 07:24:05 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Topic: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Index: AQHZdFz0yKQvf74srUeucgetCSVNH687uWiggAGmb0CAAF30AIABC9/g
Date:   Thu, 27 Apr 2023 07:24:05 +0000
Message-ID: <MW4PR11MB57763D4ECDBA8A57EAF045D9FD6A9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-7-wojciech.drewek@intel.com>
 <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
 <MW4PR11MB5776FC269FE6CFAA5B0E73DDFD649@MW4PR11MB5776.namprd11.prod.outlook.com>
 <MW4PR11MB577640D359484E99EB333D05FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
 <97e4fc5a-85d2-3b46-12c3-7e893a3305d8@intel.com>
In-Reply-To: <97e4fc5a-85d2-3b46-12c3-7e893a3305d8@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|MW5PR11MB5929:EE_
x-ms-office365-filtering-correlation-id: 8f44fed0-b524-4a6e-900c-08db46f061ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H+UE1z8Y4O864l7gi08Abr7GqyYHvKvIEvngrnKPANx0MUkPvnCJg1rNpeXaiQ4kjTJYSY3EYdx77Ymu/AEqpYaqKYiXmXrQV+5xoUwBAnL5OyeL+ljqFCRKUtn+2YIrZuXMfgKzzNF69OOVw3MDevil0q1f3WkjGYP8JxlGftDbwYp3vM0Mwe9U91BSzJ5haqXVK90X35wCImU4Zj20Fnc5OinHC0+Sdsr7tbbk859LzuhWaFYr1jYmay5PTu1hSDUMf/CqpHGEOghxLQ7nKEQWVERS3RbY7Cy9Gt84lvoUaEiPt119B9fT8kbMLoTFe5zkMK4abpZ8Y6PPtclS270UA4pCWWGx2x0TFNHQRZkGd9okrrI2fQRHA3JTe3WI59LVH00s7h3tpohWqSFZdif4L3TNYAt0fQkddLBXsyooy8Vl97Wwv3QoVfTGIeaIGvJ+QikRMSY0LLxgNwCEy/Ousy6dq1j+sgUWwxEAgOPQtDLREF4ohr9l33dYHWLCzzqSG0mZtUD7FOH/FdbV77JRJrlhfm23nKhT8phJmKT/xUL416whBbYMDmyo+KhjI9CsmBlelMCH/5ZYJ423bPkS5fDSbo8uQ9T+FEUFCzXd9NbsqpuvZRc4lInhTnhf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(2906002)(8936002)(8676002)(33656002)(83380400001)(6862004)(41300700001)(5660300002)(52536014)(71200400001)(7696005)(4326008)(316002)(54906003)(66946007)(66556008)(122000001)(82960400001)(55016003)(186003)(38100700002)(38070700005)(53546011)(86362001)(66446008)(26005)(9686003)(6636002)(6506007)(64756008)(66476007)(478600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M3hTZEFRQWRnNHl6YU1LTzBMeDFyRHNPdUVrQ2QwTDNHSUhoZkRZRmYrNnN2?=
 =?utf-8?B?ZWVGZXZQL09LNmNiai9odnpjQ2pHclcvd1liVmZqejZMMGNEeEJQRzdHZ2k2?=
 =?utf-8?B?R3ZTTllsVWtjbkVDNVJucFdCbE0wVUh3V3Roc25mK1FkZ2RBR25KeHBXQy81?=
 =?utf-8?B?KzVSTGNwUkMxS3NxdHhQLzBwK1dMQ2xVZGFJa3FLcFAwU1NwZWpZRldIZlBQ?=
 =?utf-8?B?b1hHMWJ1TjUwVGp4eXppeXg3a3M0WFJmS0tzd3F4K1FET3phQ0U3OEt6WlFk?=
 =?utf-8?B?UjFER3VSVmNVQWdLN2dnN1orYkZMODJUT1ZIalFGK0pySzdidHpobXMwRVFY?=
 =?utf-8?B?ZG5iMjA4Z2hGNnBpWnc1cVJreTNBMzBJaXF6SUpRQnZoU3dkZDU0TEZSY0Fw?=
 =?utf-8?B?V0ZNVDRkVENlTk0vbWwxTVU5NytWYVFrTG9hK3RFandYdTVPeWJNSVVOcVZa?=
 =?utf-8?B?VDZmbXNlTHdURmVzbmRERFFqY3JxdXJDbDRQdmxiNmNYOUVNbjZKeFo4UUlv?=
 =?utf-8?B?VzhDa2dRdExzdkdOK0hoRUpHSnpycTAybkdQMC9BdUc1Y2FoTTdNSWY5UGxh?=
 =?utf-8?B?d01ZNFUvcGxRb3k1REh5NTJqVmJrQktsRmpxcHU4aXcvTWpFeXZSa2dHYlBI?=
 =?utf-8?B?MUhQYzJNUjhiODZyN3ZCZklyQkVxN0Z3M2dQN0lWT04zVDB0dDJkdmJTQjVo?=
 =?utf-8?B?Y21JR1A5d05xOVZHVitwc1ZBMGxJcVhOQmdpeGhCMGlaYXVENXRwMEQzUklJ?=
 =?utf-8?B?UlRnb2J0bER1YzJQOGhMcjdFRGM2NXlvWFF4cW1sQW1zM2NPR2xtRjc2OTFU?=
 =?utf-8?B?NkhXQTNWZ2I4WkRUUWFBOTZ4UDI2Mis3NERyLzc1VEE2NXRPVHpQV2NMejl6?=
 =?utf-8?B?YW5vWTZNWUp2RzZjUTZSM2hBV0dUVFNsaDhJSUgyRjhEUlVReUpzL0k4QVh5?=
 =?utf-8?B?ZFJuYUFLOVB4aHZOVlFCOTJhbGlUU3Fva29POXAvcEpDaTd4dytDWXpPRWZv?=
 =?utf-8?B?dTVrYUlUNFVDMkMwUkpkQ0taR0h3bnhPY0dzNVUvbXpmQko5bDk0dnc0ZDdr?=
 =?utf-8?B?YlVOR29YZTI2dzByd2VkbnlWWktqYzhKZE8rYVB0OVF6MThDa29XN2RObVVq?=
 =?utf-8?B?ZVpNTGNVYXI3aVlxT1U5M1VuSGFtK2E4QUp4cGo3YUJhWjQ1dTNJNUJ2RFNN?=
 =?utf-8?B?VXFiT3kwWExsZmRVRlFTTjkwbTNrck9LMXVXRmtGS05FRTJnOUZyQU9IT1dW?=
 =?utf-8?B?eFZUQzVjTExpbTJIaVBNSWtkVVVaWkROZGx3YXBhWG9RMEkvN29mUjhJTGpE?=
 =?utf-8?B?SkVaMUhZVXJvQW85VVZ3c05Sd20yZlFFQ2RRb0hSYnplMkhZR0I5NnZHYTQ3?=
 =?utf-8?B?eWVPK2V0MGlXVUJkNDMyTUlEb3hoVWhaMzNuVVhhRVFYNnBCd1lXbVIwTGx2?=
 =?utf-8?B?bW5iV2doZ3JmcEFvWlNhWWJkMDJLSm9YVzU2UXpiNnk2NmNHTUVhWHo5aU5q?=
 =?utf-8?B?cnhQOVltRDd1eURaQlRoblVGRnNjVVBob1IyVHp4SlB3VjJ1UlJsdHlHNDdW?=
 =?utf-8?B?UDl3RVN6QWk3L29kUjBSVW4yL3dPOWd0WFhUK3ZaYnlZSHZoOHlLOHpCQ2Nv?=
 =?utf-8?B?d0s5bDhBZ2NScE9GeXRVdUw1UTV1T2MvNFFXS2FiMlNDUkFwMlRHWHg5TUt5?=
 =?utf-8?B?ZGtxWDJ6L0xGZk5yd2NUZks1M2lUUjJLbHorV2FUdk9qRjlxbzIxcVpsMzBU?=
 =?utf-8?B?akpGbVlTVDRkVU9aQ2hGQWJEUFQrMWFOVDRrTFplZGl0YjFJNmt6aGR3SHlv?=
 =?utf-8?B?TmZYeUwya2RvRTNWa1VNZkVjczZTNjNYQjBPSzJzM0pGUVdRYnFXQS9mRm9C?=
 =?utf-8?B?TjVUNnVqRXdxOUxMTmF5aS9pNm0zMGRJQ1Vxc0NKQklrcjU0RXFpQmhUbHUx?=
 =?utf-8?B?TlF2MWFiRnBWRDljN0Z0SnIybzV2Wk1wVDhTTXY1WEZiTzMyZEdyaHVXbGxh?=
 =?utf-8?B?WXhOYzQ2QklDTjlDT2tzNU5LNXFnUENLUUpicmFHYVVja25oNDdhdFBUMlFq?=
 =?utf-8?B?Z29NMjU0U2JrdHN0SUtQTWhWWlBSQlJ6VFd2V3o0U1FGU3lZeHI4N2grYWZM?=
 =?utf-8?Q?TcQ1wJL6dhzJT5Iq/JgT/4sLD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f44fed0-b524-4a6e-900c-08db46f061ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:24:05.1652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OJ3BUsgTpQxy3vk3ifBTdgOdQt+x42lHoP6Y+HccvT4m6MA2sOw+k3RuRgQot0TBGM+uCgEFyBY7tG7SGQsiEdDNfwoWe8/so17gUMJn7mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5929
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogxZtyb2RhLCAyNiBr
d2lldG5pYSAyMDIzIDE3OjI1DQo+IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3
ZWtAaW50ZWwuY29tPg0KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50
ZWwuY29tPjsNCj4gbWljaGFsLnN3aWF0a293c2tpQGxpbnV4LmludGVsLmNvbTsgbWFyY2luLnN6
eWNpa0BsaW51eC5pbnRlbC5jb207IENobWllbGV3c2tpLCBQYXdlbCA8cGF3ZWwuY2htaWVsZXdz
a2lAaW50ZWwuY29tPjsNCj4gU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVkcmFsYUBp
bnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDYvMTJdIGljZTogQWRk
IGd1YXJkIHJ1bGUgd2hlbiBjcmVhdGluZyBGREIgaW4gc3dpdGNoZGV2DQo+IA0KPiBGcm9tOiBX
b2pjaWVjaCBEcmV3ZWsgPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+IERhdGU6IFdlZCwg
MjYgQXByIDIwMjMgMTE6NTA6NTYgKzAyMDANCj4gDQo+ID4NCj4gPg0KPiA+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBEcmV3ZWssIFdvamNpZWNoDQo+ID4+IFNlbnQ6
IHd0b3JlaywgMjUga3dpZXRuaWEgMjAyMyAxMToxOA0KPiA+PiBUbzogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+
Pj4gCWd1YXJkX3J1bGUgPSBpY2VfZXN3aXRjaF8uLi4NCj4gPj4+IAllcnIgPSBQVFJfRVJSKGd1
YXJkX3J1bGUpOw0KPiA+Pj4gCWlmIChlcnIpIHsNCj4gPj4+IAkJLi4uDQo+ID4+Pg0KPiA+Pg0K
PiA+PiBJIGxpa2UgaXQsIGxlc3MgcHRyIDwtPiBtYWNyb3MNCj4gPg0KPiA+IEFjdHVhbGx5IGl0
IHdvbid0IHdvcmssIFBUUl9FUlIgd291bGQgbm90IGNvbnZlcnQgcG9pbnRlciB0byAwIGluIGNh
c2Ugb2Ygc3VjY2Vzcy4NCj4gDQo+IE9vb3BzLCBQVFJfRVJSX09SX1pFUk8oKSB0aGVuPyBJIGZv
cmdvdCB0aGVyZSBhcmUgc2V2ZXJhbCBtYWNyb3MgZm9yDQo+IGRpZmZlcmVudCBjYXNlcyA9XA0K
DQpDb29sLCB0aGlzIGlzIHdoYXQgd2UgbmVlZGVkIDopDQoNCj4gDQo+ID4NCj4gPj4NCj4gPj4+
PiArCQlkZXZfZXJyKGRldiwgIkZhaWxlZCB0byBjcmVhdGUgZXN3aXRjaCBicmlkZ2UgJXNncmVz
cyBndWFyZCBydWxlLCBlcnI6ICVkXG4iLA0KPiA+Pj4+ICsJCQlwb3J0X3R5cGUgPT0gSUNFX0VT
V0lUQ0hfQlJfVVBMSU5LX1BPUlQgPyAiZSIgOiAiaW4iLA0KPiA+Pj4+ICsJCQllcnIpOw0KPiA+
Pj4NCj4gPj4+IFlvdSBzdGlsbCBjYW4gcHJpbnQgaXQgdmlhICIlcGUiICsgQGd1YXJkX3J1bGUg
aW5zdGVhZCBvZiBAZXJyIDpwIChzYW1lDQo+ID4+PiB3aXRoIEBmd2RfcnVsZSBhYm92ZSkNCj4g
Wy4uLl0NCj4gDQo+IFRoYW5rcywNCj4gT2xlaw0K
