Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5586D7D49
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbjDENEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbjDENEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:04:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F0D5BAB;
        Wed,  5 Apr 2023 06:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680699838; x=1712235838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1STkUzrWJukoHQHkrMAAww8/f2cY9ziju9npfk7+usE=;
  b=oEQPdJnrUFgYkfETGvwrI8x44nStyrQvvyy2t/f9PTF7mbvWamPrCwbF
   sBQjZOMChLHyhLY7imTvrcjf7aceIUTMPqLkjlCN5C+ptSd1a4Yjlq8+0
   MP+KgZy8St97AKf88dbJede39TwcnoHwEXN3eznMQ4lTi//NOEQ6PcPyS
   aI/0ycG5VBSdC4dPymIsXrJptEMPA6Szm/JXFdlmqMp1jr3HM2ytoYM7K
   Rf8VU0lyODPBvoJ3+bqPHGgYKvMkRLabBy8VhxXSwCW2xtTHkHiMpTiVb
   UI2k55g7qkaBqvpXfK+PrLckNzGzciESq+bMG5e0BtaCsTWDAuZbSSYIK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="342462220"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="342462220"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 06:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="717033718"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="717033718"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2023 06:03:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:03:57 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:03:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 06:03:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 06:03:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2OC8ffTRUBmUi+N7iGwKmnrQ2x5AHl2ed+DLzSVW58bLV5sAK3ukNLK6jtGBL2vGceiwmXDg50uZfdDJ5T89HSxVnksG6K2UmBIHoHfSink3/hrO5YFPK22FhVFJVceIy8wMO5erS+PeB2dFNHcS5BDtYPk082IPaz3mjJvun3Ym/EiOfvnhMVpb59hR8mz1QMnl58m3t1XlYH5aWvhZxMPs+Gbrlh5DGo0e2HmeA53DI3b1+Vrpuvw/yhNnqcG/t7qaR72luwkBQQdEl8B/XiWyRNkLyskZKa7SDGrv8yyOlt5P1D6gksFOEsP2K1jd02QzA8CD3lEreAfbC0haw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1STkUzrWJukoHQHkrMAAww8/f2cY9ziju9npfk7+usE=;
 b=e8o7rpR3tDZskoPBl2qNZJ3YVg6w6cl0AxZpNPo1uBcj1X2mHE1l0PY3uCz2NF/cHwbUCYHe/wMnOBle8yWn5xDf6qFXWmPGJ9qaaoZ9f79JuFTEsZmL3rjpXg/EW5O1HBdPVRjinC2s/M+REgp4XUPq+7OoNcHhPENh2M/7kUsO8+MS9Xa7pKKahsUGrga5apqFG9QD2tU+u4vLTPARRkj4qcLTGRsIqyBkCG1jB3DD0FYPN7j1LHsl1IDwUpcpsFNk15Swz1J1o79F1H0SdOLAQNomjRZslGW3yuue50bU1D6D7ZD8qxV6cyKhjXN9SIWVOUixRIHnziIk6fQ0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5454.namprd11.prod.outlook.com (2603:10b6:5:399::22)
 by CH3PR11MB8238.namprd11.prod.outlook.com (2603:10b6:610:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 13:03:54 +0000
Received: from DM4PR11MB5454.namprd11.prod.outlook.com
 ([fe80::c40b:7d87:f6eb:2a75]) by DM4PR11MB5454.namprd11.prod.outlook.com
 ([fe80::c40b:7d87:f6eb:2a75%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 13:03:54 +0000
From:   "Looi, Hong Aun" <hong.aun.looi@intel.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>
Subject: RE: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Topic: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Index: AQHZZ6KzQDJftjZQFEGKRRyHo2kIM68cfY4AgAAM+oCAACP20A==
Date:   Wed, 5 Apr 2023 13:03:53 +0000
Message-ID: <DM4PR11MB54545199C99137AE8498B56EBE909@DM4PR11MB5454.namprd11.prod.outlook.com>
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
        <CGME20230405100807eucas1p158f0f542e55873249ce4c861df8da7e8@eucas1p1.samsung.com>
        <ac972456-3e0b-899f-1d84-ce6f11b87d27@synopsys.com>
 <ef0b7276-0fd3-4517-de59-c76e6a57d192@samsung.com>
In-Reply-To: <ef0b7276-0fd3-4517-de59-c76e6a57d192@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5454:EE_|CH3PR11MB8238:EE_
x-ms-office365-filtering-correlation-id: 62a19c58-2ed1-4cdf-5c77-08db35d63582
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4eY+22yQo6niOExZ9Acng68pGjSnUE41rwcrmJ1LImEyZX4uXsqDuMv9mAoNAvK445sJgIcR4SXt6cpInlNy4AETyPAjLKs9xzgpwPi9f4PFkfs9i1ENzmeg2ezV/T34NQ6GCtyxq9YywqwSNRAe4iq7aqyCDqKOoJYUQCRhBeWSO/jWAapZ4gTxIjFEa537VgPRL94O4pgav3VEJwtz4nu5NJU1++i0kYZBpBcRAST/qT79BJ0mQh882PCZjyuT5JQAWu3LC761ZNcoOn6MftHwwJNpdiLMBjQIxbw64X1m1u4uptk6kXnNWbUQqpT+5dxCOnIbiEJqHGkZq6byq+rMOTAvsPHHXXyaymTf+46+zHprezOAwPS4tAIc6XdjhOM9+8QripOzvGlcGkO2Ugoca9j0ixovzlQ6Z0JME2UeGPvfW5cP+LjKMo2Obr75tXCr7CvMdKd3rWDNXM0KD48isFUR8Ks2ZUP/8D0H1heL6LRx3+qPG/74fSlEu/RdHuXR052KKJ5nlcmDeKmDgK6bYX91Yk+Z7gu/646Yi+JM0+y+PA69LfSe1NHRJJOed7uhbJMaYQ9PbCeUTae59gNnOrMwe44NshIpglsltTUXplGFiZQMRIgf5VY6hFUdQ4N17i+xghTagFIz1uH83A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5454.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199021)(86362001)(38070700005)(33656002)(2906002)(8936002)(55016003)(7696005)(71200400001)(53546011)(83380400001)(186003)(6506007)(26005)(9686003)(4326008)(64756008)(66556008)(66476007)(66946007)(66446008)(8676002)(76116006)(478600001)(54906003)(5660300002)(921005)(38100700002)(82960400001)(52536014)(41300700001)(7416002)(122000001)(316002)(4744005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SElObGVxVnBkTGZXRTNzR3N3SUpXT2tWY2FKUnNJREt0a1BGU3YwQnMzRHpT?=
 =?utf-8?B?a1AyTzgyQUJlOU1vVnVFY1pUUy9BMzFRUHhPT2V3amxLNVRsMEdYTmJGWjRz?=
 =?utf-8?B?ZmEyNWRmT1BsS3B5TlNFVFRiclF3Z3pZTUlPNmF6eVFVMjNZOERRbVUwalY4?=
 =?utf-8?B?YXU2T0ZGUnhpNVBEUUtoY2llRlVnU2RFd3FYbnJydU1ycmFDNkxhWXZVQlRM?=
 =?utf-8?B?cGlHMGVrZEhMdi9vZDJFZnF4L0VTTDhnSmsyS1BGZm1aUTVBTDU3eVErRlhH?=
 =?utf-8?B?V2VaTWZ1KzVMVDEwbkxUMEdoUm1va1BlU2xkV0pEVmZ3ZWJlTVY5RHNUZE1I?=
 =?utf-8?B?bTU4MXIvUVNIR1RtNS92dkhZeXpmY0xTeEloMzltd0dBTTZ2Y1h1RC91L1Bt?=
 =?utf-8?B?TzFrWk12Mkg5K2IwS25tYzhLZWJlaXdzbjlNTlVxTTNzQ0FhenJheWhrVDA5?=
 =?utf-8?B?OFdma3R5TWtNNjFTT1Y4WnBLZlhpZFZWNkdLaDBzekovM0VHUnk1WURJdmdl?=
 =?utf-8?B?eUVzQTYwdHIvdlhZd3BaM0hnQUtNbXZiaS9OZ2xnTHhLdWN2RG5FbmgwRWNJ?=
 =?utf-8?B?QzRJelYramZ0L2M4OE5FbW5KRkd2RUxtdGd3bXVIVFlvRFVTYlFUQlgwN09Z?=
 =?utf-8?B?MkFPcnVyT0lnYnZsc3JmS205Z0R1cFRMUU1Eem9kZTZhM1JVWkRMeGJOYXVU?=
 =?utf-8?B?cEpiUjVMb2dLZ050bjNnV1pvL2gwN1dRMTIrdzF3cDJnS3ljMkZuTFJUNUxH?=
 =?utf-8?B?RmxWWDVlQ1oyT1dPYk9Jd1g0eFJ5OGhwNDNYRkl5Z0RrL2pZZFpFd0R3eXdJ?=
 =?utf-8?B?ZWZNQWxleVVGQmhGSFd4QnpJazdKazdmNUFvV1F5MVI4b0g2cVJWMUxhNUtU?=
 =?utf-8?B?bUxSdXhiNHQ0QVhnb2swL0NiT1FlUTdNKzd3Sms3KzdRMTVmc2JQdGlkNEpG?=
 =?utf-8?B?RnZ5UlpybUpWa2FtNC9oaDhkd1NwbHlIOWd5TVBQWS9tMm00U1VtNWxQdEgv?=
 =?utf-8?B?cUUvbmFxMzRUV2N3blhqNjIvcE1pZkFCNEhVTG9td01KOWpGTVIxcmdKcDVD?=
 =?utf-8?B?Wi9iYUlCVUNwK0krN05MWlphNE1ieG5KQy9WdThFZmtrdWkzcFZBaGVnZ2lH?=
 =?utf-8?B?TmpaTnl5VjIybnV5ZVlxSmJhT2ZJZXltaFV2TEZMOXhqU3BqVDFqWUFGSWNx?=
 =?utf-8?B?b09TRm9JRjYzV2VOd2psdjNCeWpoc3V3QXRaL1VQd0xzZ2x0UUtSM01Wdmtm?=
 =?utf-8?B?M2JoTTRRS2NXY0ZTbDF5anNTL1Vxa1pweWJxNEtmVkdsU3BWS0x0Ni84OHAv?=
 =?utf-8?B?aXVTenVZTXhpeVN6bWwzMmtoekM2SFlYYTBkejRvUnpTeWNFYVUvdXdVWFln?=
 =?utf-8?B?dkxVazQrbTZMVlB0Q0FDUUtwUnVaNGYwaFc5OURCMWRsSTdEYXVMVzlHVytt?=
 =?utf-8?B?ak5HWDJnYmN1Y1VoQ0FaZHh0UGZCSitiY0t6U0FpWFZFb3c2N3JocXB1dlVG?=
 =?utf-8?B?bDNvTytRNjdSZE9UOFU5MUN0TkFPMVBhb3dsbFVRZFpIaDRscUVLU1hpZGc4?=
 =?utf-8?B?NzNQL01BdUxiVVhxUWppMzJPRmNwNHAzeGRIQ0tuR21QSHJ6eUYxNVZ0dVN4?=
 =?utf-8?B?UWRMdzJJYU1GeFFWb0liRmVlQ3o1eDArRi9zKytQZjRqR0lDWGxsd08zQ1pI?=
 =?utf-8?B?RG0zNjN6aEIzQjljMGdJVHdndVViZ0JQZ2Yvc2wyZ1lZMFMwdWJORnh2L2NP?=
 =?utf-8?B?MjBOZllLQTZ0T2RLUnhZRm5JODdQR2RzS0h2OVFGdGtpcnYzdERkcFlxWkRT?=
 =?utf-8?B?MWV1YXIwbEVrYStGYVpVRU1NbHZkbDhtQTcxSHR4OEpja1BXS1VxUU9mZTd6?=
 =?utf-8?B?bVgvWXNtNjljczVPYlFEaWtnc0hVanYveVpzbGRrQzltRDBTM1M2TzBiaThQ?=
 =?utf-8?B?c2xQWCszWTJVSlBVM3Z1YzMzYnBvb2djQWNxdFFhY2szano4elcyeG51ekJm?=
 =?utf-8?B?UEwxMVVjR3lJNmFJdlhqZzJydHd5UkpHNEk4N2lQYjFYQlFKNjdUK0ZPb1cz?=
 =?utf-8?B?WlJudktaQm8xWDFFVnNaWXMxcEFEWndpQit2dzNtV25oTW54RzhBNmtMYTBV?=
 =?utf-8?Q?HyKYq0OziCcJ9Vl2upNdoJOjp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5454.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a19c58-2ed1-4cdf-5c77-08db35d63582
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 13:03:53.9457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Syi2tyHTbSKA4JtLRM8m9M2hOw8iV+dWfhNtiBi4xZba/ucXC3X5yiqG+iPbP+tgqTS08FtZh9iSAnDtN+FDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8238
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAwNS4wNC4yMDIzIDEyOjA3LCBTaGFoYWIgVmFoZWRpIHdyb3RlOg0KPiA+IE9uIDQvNS8y
MyAxMTozOSwgTWljaGFlbCBTaXQgV2VpIEhvbmcgd3JvdGU6DQo+ID4+IFNvbWUgRFQgZGV2aWNl
cyBhbHJlYWR5IGhhdmUgcGh5IGRldmljZSBjb25maWd1cmVkIGluIHRoZSBEVC9BQ1BJLg0KPiA+
PiBDdXJyZW50IGltcGxlbWVudGF0aW9uIHNjYW5zIGZvciBhIHBoeSB1bmNvbmRpdGlvbmFsbHkg
ZXZlbiB0aG91Z2gNCj4gPj4gdGhlcmUgaXMgYSBwaHkgbGlzdGVkIGluIHRoZSBEVC9BQ1BJIGFu
ZCBhbHJlYWR5IGF0dGFjaGVkLg0KPiA+Pg0KPiA+PiBXZSBzaG91bGQgY2hlY2sgdGhlIGZ3bm9k
ZSBpZiB0aGVyZSBpcyBhbnkgcGh5IGRldmljZSBsaXN0ZWQgaW4NCj4gPj4gZndub2RlIGFuZCBk
ZWNpZGUgd2hldGhlciB0byBzY2FuIGZvciBhIHBoeSB0byBhdHRhY2ggdG8ueQ0KPiA+Pg0KPiA+
PiBSZXBvcnRlZC1ieTogTWFydGluIEJsdW1lbnN0aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBn
b29nbGVtYWlsLmNvbT4NCj4gPj4gRml4ZXM6IGZlMmNmYmM5NjgwMyAoIm5ldDogc3RtbWFjOiBj
aGVjayBpZiBNQUMgbmVlZHMgdG8gYXR0YWNoIHRvIGENCj4gPj4gUEhZIikNCj4gPj4gU2lnbmVk
LW9mZi1ieTogTWljaGFlbCBTaXQgV2VpIEhvbmcgPG1pY2hhZWwud2VpLmhvbmcuc2l0QGludGVs
LmNvbT4NCj4gPj4gLS0tDQo+ID4gV29ya3MgZmluZSBvbiBBUkMgSFNESyBib2FyZC4NCj4gPiBU
ZXN0ZWQtYnk6IFNoYWhhYiBWYWhlZGkgPHNoYWhhYkBzeW5vcHN5cy5jb20+DQo+IA0KPiBUZXN0
ZWQtYnk6IE1hcmVrIFN6eXByb3dza2kNCj4gDQo+IFdvcmtzIGZpbmUgb24gS2hhZGFzIFZJTTMs
IE9kcm9pZC1DNCBhbmQgT2Ryb2lkLU0xLg0KPiANCj4gQmVzdCByZWdhcmRzDQo+IC0tDQo+IE1h
cmVrIFN6eXByb3dza2ksIFBoRA0KPiBTYW1zdW5nIFImRCBJbnN0aXR1dGUgUG9sYW5kDQoNClBs
ZWFzZSBmaXggdGhlIG1pbm9yIHR5cG8gYXQgdGhlIGVuZCBvZiB5b3VyIGNvbW1pdCBtZXNzYWdl
Lg0KDQpSZWdhcmRzLCANCkhvbmcgQXVuDQoNCg==
