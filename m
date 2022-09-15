Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8835B93B6
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 06:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIOEn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 00:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIOEn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 00:43:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44FC91085;
        Wed, 14 Sep 2022 21:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663217032; x=1694753032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vxsdospa0Z0jMgIO+I/4U8UleIQQfAgUDFokuLK+7/Q=;
  b=1qhrHrpXARqXeZEAeubCIZRk3Zi+nYZJEXKwjtnibfh2NrTiEWHRAgiM
   ABLt4B7bWERN5pRStUf78SA6JpuGSGhLbZP/ghjDCn3rnGPtSu3K6EVgB
   aJK41iKcuFeEFiC07JwWBgM72mTJLrWxK/9gp9am4n1EG5IWtO1dKu/DL
   MB5xpHbFxMrNMJx5Bv48xjS2/6spz31hTudbdZ3RYCdWmwPddVUeIWC9F
   bAtzwwhD51aKi4R5GhuSy1YrFTRsj71Yf/8O/Z1fYk/uRVVF03AYuv6BN
   pQJPh1f0DlJd2JKbMlkpdaQYEzeMBMV0h8UL1P7ImM8Iy1Ef/gB/jBKNV
   A==;
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="190919138"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Sep 2022 21:43:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 14 Sep 2022 21:43:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 14 Sep 2022 21:43:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+UkstZvx1HOiZ4Q2/j/uGA8jtfquK99vZUfFFH3PxUE7Z98XRXL83cEqhl92P4IIrwdrtVggrFtHjxVoyPHQw/yrM2CxSK+fwYkGYgZY+QbBGK1WwLbwk/Qogrfk9TivxHTUkSlcJCVXO98CNR1eMMOGYzE3vFHchtR/82xM8ZXB3TGv0MHDZg20l1A/CkXo1w8HcVthaduejdKG7rvBGQdnyhndv9v/CUdKlXHfeDU7BDT0Nf7Mu28OK+4OEY0lwNTjGlOQhwZFmZMT5PNeLMvr7OfRApviBhW/UoLzXM603da81LaDxhuQSdc5fa3Isynfyyt2/0MZvdeJ/yYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vxsdospa0Z0jMgIO+I/4U8UleIQQfAgUDFokuLK+7/Q=;
 b=PFrENkxB7g6qiLKNDeDQCoGsf45W4UPmnmKrKSwLCkaqBOqZk+kksvnozrX5AmBxueK+udYQbiXFovwLlacwKCYwXK1NpfAnoG9KApA6LonM4gr8OU2VzDqgfZzanymcRLR4wnATxX7D7uJQmzX8L83sHl1uUoMWVyiM++KDegu4IoXTOfHkvpKeKJCUWdK4dk36INzvY/H7mHKYg72MSNQHM3pkZ8OUGOzqEd64xdNl8v2TD2i5knH6UFg1G/42f5veNMf1EZ+sLM1/13aQkW4fOd74xQ+fL0H290gHbbIzXj7yeTsdEYoJCTR3Cnbe6/uw0PD3GUgjf+U+tEwIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vxsdospa0Z0jMgIO+I/4U8UleIQQfAgUDFokuLK+7/Q=;
 b=jxq9mPclpEjjEuSxyurAIZP/KWUt+mekiJRDs3PFb7OHzg9uyvhbYi9govs7ZyT8HU0VEOM/PEoT4ae1pPdyIk7yuQ0v9Rk0iqWnWUX/cvwWk2y997c53SI1/9pU1eDK9bwSnARq+qAYcH5BDuYdBUGnEDL1rVAKnTvmYpbkU14=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5421.namprd11.prod.outlook.com (2603:10b6:5:398::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 04:43:46 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 04:43:46 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>,
        <Prasanna.VengateshanVaradharajan@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>
Subject: Re: [Patch net-next v2 4/5] net: dsa: microchip: move interrupt
 handling logic from lan937x to ksz_common
Thread-Topic: [Patch net-next v2 4/5] net: dsa: microchip: move interrupt
 handling logic from lan937x to ksz_common
Thread-Index: AQHYx+3VJDuaAvNY/0WGJClYBOJ5gK3eyiKAgAEhegA=
Date:   Thu, 15 Sep 2022 04:43:45 +0000
Message-ID: <7ad568dc151647a7481a6ddd3c402c0b79277896.camel@microchip.com>
References: <20220914035223.31702-1-arun.ramadoss@microchip.com>
         <20220914035223.31702-5-arun.ramadoss@microchip.com>
         <YyG6q6SPURSAtz7C@shell.armlinux.org.uk>
In-Reply-To: <YyG6q6SPURSAtz7C@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5421:EE_
x-ms-office365-filtering-correlation-id: d772eb92-baf8-47e1-8c14-08da96d4dfdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2nneqEDXoMEG8l33LocHXl+rVIg1f3vIZGmcTQy803vgBazy/Gt696mFwfHdLAbbH6WWAu61CxXupW1b7AFXdpRUK9iebMq4OOoQ6WjRjlKbPj1tfG+ZxMIqO1Q0D8hrjS2vD1lI/nLWlCHJUk58O+P5cYMk7CAsxtvoG48+J9b389SPKz/xBI/xhyHU07pvN0F8pkcwY8a1kzeKKpuaiCu33auaZ1ZIfYXUUn7vAz+yb5MwEEVHCCYkoUkmpyMk8QfAzLjaXsK04FvmRg69EXzaVl3gW2wgkARieIQ9tkx6anVyHFUIOikGbGdDwYhzj1AHsKR4wXGqYLltfYokoYaHKxgN64SUhIAk1hkIp6XHCW0Y8/8bMN4o/BoCVSPAjB8UicQffuQUglroDmJQ20Lcg7q7Qj9xvPDfQaPSLCMOyjuizQ0XQwD7bTRUjw4DP313bhHp1YRKAW4VHmATL80EVW1tUM3t+W2jrycLXFJ2HyG5wkoV/9/gCJ6lQ6WE4x1r++GXckRHtdT6Qn2hVZeHMx7h/E/SW7/3jPrewXUX/N/kZEtuF1REZUIrRREyG+8o6xbLXcR79WLR/51xP4I7kLPxCvBP2/236ICBrxOSHOUFWGzRKa9y++3FzK3avxWTprgJvcbcOQB6lInen2APRw6YX6uu36Pc24VAovuKdOIAXpJdPv5i0LdaOBInWHzMmOcXKAlE1F/e3txGC8ZnG+X18xTtbWFzy66EkUV34onDwn/XrtdEsJUGn+NuWA/BOofFhrRgAgRjZr/xBDptLk570aypIGPoqED7Uxh47moXDBzis0OwUPNWDPNZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(41300700001)(38070700005)(26005)(6486002)(966005)(6512007)(36756003)(38100700002)(86362001)(316002)(478600001)(8676002)(66446008)(64756008)(66946007)(66476007)(4326008)(6916009)(66556008)(76116006)(54906003)(122000001)(6506007)(91956017)(7416002)(5660300002)(186003)(83380400001)(2616005)(71200400001)(8936002)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlhHM0NpSTk0OU9id0ZWeXY0QUFKUVpwUzI0ZEtNd2JxTEJQQy9GTk1ZcDlq?=
 =?utf-8?B?cFk3bG83b0hNRVNsL3VXa2srL09oODFWMFNia1NmUWtrYS9TR0JlSUszU3Rw?=
 =?utf-8?B?N0htSWZiMWF6UVVzaFgreWxzck1BcUhjaEN4T2RaRE00dm1xa0NNb1phMEdi?=
 =?utf-8?B?eWcvWWhjRkxFZGxydURTdytFN0RoVWpYMUVWVUtsQUFaclNkVXRQTGV6d05D?=
 =?utf-8?B?S0Q5djArNHNrK3A4UzlEV3ZiU3dDSVpyRTFqZHJneW5halgyOWo5NTRqeU9S?=
 =?utf-8?B?U1RyNllYVVFRbStZc0hGQVZHbmlkZWhkL1hJKzJwUWVIQzNBSkgzN2tESTI5?=
 =?utf-8?B?Zm9wbnVCODE5YlcyWDNMamg5RWwvVmNNeUpxZkh4MlBPRUoxYy84ZGhNVWN1?=
 =?utf-8?B?S2RWZEcxZ2U2ZVZlNlZEZVBCTWNVRWxabExqS0FNSmJjSlp3bzltQmo3OWZm?=
 =?utf-8?B?SVdkTnl3YVg2VlhFTVJaYjAzU1Rvcnhta1ZOL0djS0Q2SmREODRTZWJJVERq?=
 =?utf-8?B?anpwQzFPQ2Q1ejczcGV2SWlHbW9qZTl0S2VCbFhhcmR1b2g3MWRsamNyZkxY?=
 =?utf-8?B?SE9oUzRxanlLVEMrdDhrOVNRdm5ibE1UWDJOYkFjK2JQdDlVZ2hrWlM0OEJE?=
 =?utf-8?B?Y01qUFk2bzZacFNCeTJkV1ZNeUlpL3QvaDlGTGszcWl1YnN5clB2R01MS0RQ?=
 =?utf-8?B?V2M1MXBpVUUwK1E1MmM0eEF5MHJpRDhLeVdlK1puZUtEcnB2bCtXZFZzb04x?=
 =?utf-8?B?QjdsdDVGWjQyWEZwcW11eFpYSHd1cTZuWFRvSVMyZEtEUjg3dThNdXQxdWE5?=
 =?utf-8?B?WXRVQUdSL3dCRTNKYlVQZUl0UDRHcEhCVW8wQzBEaXpFdSs1VG5JVlpEN3Rt?=
 =?utf-8?B?SHp2TzBtc0EyNnNwbm1LQkJrdTRCamJnbHZHRU9ubVRBcXJ6ZDAvaUdrU3Rv?=
 =?utf-8?B?TWRySytxWEpBNUdGM3J2V0ZlOUN3REFHVFkxQUNrdDRZMjhGaXJvSHdnVE8z?=
 =?utf-8?B?bzNDRDA3NHJEeG1zWFV6aDhEaWEycW5yY3I0c1hTdHk2SStYQUp2L3YwSWl1?=
 =?utf-8?B?WVVrNzJGazhFc05uNDExLy9zTHZKeGE4emRsRC9pVWt3THRqcEg0TUtsOE9h?=
 =?utf-8?B?U1dyZnB5NkpSTU4xVjZIUTVwTGQ3eHJqQjNTMXg5ajFvcnh3TjZod2l6dzVh?=
 =?utf-8?B?L0JlMEkrdHNjdG5QcEdDYmdndmtCdDRrcHFJNnBrVlpTbE5uaE9iRkZWRGRJ?=
 =?utf-8?B?RmRzaWUwRnNNSW5hR2EwWi9LNjF0OHRrUFVYLy9oL3V3Y1BaVGlzNmJrWHp3?=
 =?utf-8?B?S3R3UVV2Q3lBSHRlRU4wblgrZVlIOVd5cWFhZUorM1NOcGR1YitNS3VKdlJ5?=
 =?utf-8?B?STFtMCtGU0J0M25pbnNpQ1lZUDZGZHRicmVOYzNaeWhVVEZmcWxwOXBqWVVU?=
 =?utf-8?B?QmZiMlp5ODdUeUplOFdFY05waDFHeitCODZ6ZGkxR2F6cVJBTlg3VCtzTXNp?=
 =?utf-8?B?WVM5ZlJxUXk3NDF3dU14amxYRmZtRENjOG5waElsWlJwdmlXOE1LOEVaWkZV?=
 =?utf-8?B?bTBabmVHeUhmVTFla1pGZDVKWnpKdWxUNDA5eFZPcGx0bmFJKzFaQzV4ZktW?=
 =?utf-8?B?VE1CY2FyeE1wWFAwRFdQN1F3SFM1cWFZZ1VtVVhSUjhVS2FIK3ZML2xxUy9X?=
 =?utf-8?B?VE02UGhOUFRGWmlVQXM0aGZKdzlvRGtad0tDV2xaT2pBeStiR0ZzV3g1a2Js?=
 =?utf-8?B?bVUxN2lVQ2JqL3RYR0ZCL0xTUXJveDBJL2hrY2RncXFGSkx1bVJJd2tQNnVI?=
 =?utf-8?B?aTZOMXdSbW9aT1dVbEkwa3RGRm1ncGgvcDlBV2dMZHFERXArSDhOZFZ5NGNO?=
 =?utf-8?B?bkxSQkt2akVUNVpYV3NqQmVocEprUWhxVHYzUTBOeXhuUk92TG9QYkZzOU54?=
 =?utf-8?B?TVYyRStFeHRLcTNKOGhjWENFUWd4THhUR3hQeFNlVEx4QnovakoxNGtpbUFC?=
 =?utf-8?B?QlljbGJLQmxEZXNoeFZHMGNQVUUrcmhHSmNFUTlZNkdRbFlLU0wwaEJYNXY0?=
 =?utf-8?B?cUJXSWNhM3VmODFkdzB1OWxuaDJwZmozdDVrR1lUaHkxYVpNMi9qL2c1Y3JK?=
 =?utf-8?B?Qlh6NjZHYm9FS2RXTzhTeVkwenh6a3BRcCtJenBqSDRSRHMrMC9OSE1iM3lF?=
 =?utf-8?Q?mX7H8vqGU1OxKGhiH3WuyLU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <934CBC7D2FAB8143A6BF653BEF957B7C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d772eb92-baf8-47e1-8c14-08da96d4dfdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 04:43:45.9261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7J0qViNbcvh8IepqY4jQLVsQUKztwJamJa09nLQBiXNaAjhxDZVwGPo5olALf8MBK8jK90anULybqD4GUrBTXy8BNIiEoaoGUq5+UZG9uhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5421
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsLA0KVGhhbmtzIGZvciB0aGUgY29tbWVudC4NCg0KT24gV2VkLCAyMDIyLTA5LTE0
IGF0IDEyOjI3ICswMTAwLCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGksDQo+IA0KPiBTb21lIHN1Z2dl
c3Rpb25zIGZvciBhIGZldyBpbXByb3ZlbWVudHMgaW4gYSBmdXR1cmUgcGF0Y2g6DQo+IA0KPiBP
biBXZWQsIFNlcCAxNCwgMjAyMiBhdCAwOToyMjoyMkFNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdy
b3RlOg0KPiA+ICtzdGF0aWMgaW50IGtzel9pcnFfcGh5X3NldHVwKHN0cnVjdCBrc3pfZGV2aWNl
ICpkZXYpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMgPSBkZXYtPmRz
Ow0KPiA+ICsgICAgIGludCBwaHksIGVycl9waHk7DQo+ID4gKyAgICAgaW50IGlycTsNCj4gPiAr
ICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICBmb3IgKHBoeSA9IDA7IHBoeSA8IEtTWl9N
QVhfTlVNX1BPUlRTOyBwaHkrKykgew0KPiA+ICsgICAgICAgICAgICAgaWYgKEJJVChwaHkpICYg
ZHMtPnBoeXNfbWlpX21hc2spIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaXJxID0gaXJx
X2ZpbmRfbWFwcGluZyhkZXYtDQo+ID4gPnBvcnRzW3BoeV0ucGlycS5kb21haW4sDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUE9SVF9TUkNfUEhZX0lO
VCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChpcnEgPCAwKSB7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gaXJxOw0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB9DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIGRzLT5zbGF2ZV9taWlfYnVzLT5pcnFbcGh5XSA9IGlycTsN
Cj4gPiArICAgICAgICAgICAgIH0NCj4gPiArICAgICB9DQo+ID4gKyAgICAgcmV0dXJuIDA7DQo+
ID4gK291dDoNCj4gPiArICAgICBlcnJfcGh5ID0gcGh5Ow0KPiA+ICsNCj4gPiArICAgICBmb3Ig
KHBoeSA9IDA7IHBoeSA8IGVycl9waHk7IHBoeSsrKQ0KPiA+ICsgICAgICAgICAgICAgaWYgKEJJ
VChwaHkpICYgZHMtPnBoeXNfbWlpX21hc2spDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGly
cV9kaXNwb3NlX21hcHBpbmcoZHMtPnNsYXZlX21paV9idXMtDQo+ID4gPmlycVtwaHldKTsNCj4g
DQo+ICAgICAgICAgd2hpbGUgKHBoeS0tKQ0KPiAgICAgICAgICAgICAgICAgaWYgKEJJVChwaHkp
ICYgZHMtPnBoeXNfbWlpX21hc2spDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGlycV9kaXNw
b3NlX21hcHBpbmcoZHMtPnNsYXZlX21paV9idXMtDQo+ID5pcnFbcGh5XSk7DQoNCk9rLiBJIHdp
bGwgdXBkYXRlLg0KDQo+IA0KPiA/DQo+IA0KPiA+ICtzdGF0aWMgdm9pZCBrc3pfZ2lycV9tYXNr
KHN0cnVjdCBpcnFfZGF0YSAqZCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pfZGV2aWNl
ICpkZXYgPSBpcnFfZGF0YV9nZXRfaXJxX2NoaXBfZGF0YShkKTsNCj4gPiArICAgICB1bnNpZ25l
ZCBpbnQgbiA9IGQtPmh3aXJxOw0KPiA+ICsNCj4gPiArICAgICBkZXYtPmdpcnEubWFza2VkIHw9
ICgxIDw8IG4pOw0KPiANCj4gICAgICAgICBkZXYtPmdpcnEubWFza2VkIHw9IEJJVChkLT5od2ly
cSk7DQo+IA0KPiA/DQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBrc3pfZ2ly
cV91bm1hc2soc3RydWN0IGlycV9kYXRhICpkKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtz
el9kZXZpY2UgKmRldiA9IGlycV9kYXRhX2dldF9pcnFfY2hpcF9kYXRhKGQpOw0KPiA+ICsgICAg
IHVuc2lnbmVkIGludCBuID0gZC0+aHdpcnE7DQo+ID4gKw0KPiA+ICsgICAgIGRldi0+Z2lycS5t
YXNrZWQgJj0gfigxIDw8IG4pOw0KPiANCj4gICAgICAgICBkZXYtPmdpcnEubWFza2VkICY9IH5C
SVQoZC0+aHdfaXJxKTsNCg0KT2suIEkgd2lsbCByZXBsYWNlIHRoZW0gd2l0aCBtYWNyb3MuDQoN
Cj4gDQo+ID8NCj4gDQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIGtzel9naXJxX2J1
c19sb2NrKHN0cnVjdCBpcnFfZGF0YSAqZCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pf
ZGV2aWNlICpkZXYgPSBpcnFfZGF0YV9nZXRfaXJxX2NoaXBfZGF0YShkKTsNCj4gPiArDQo+ID4g
KyAgICAgbXV0ZXhfbG9jaygmZGV2LT5sb2NrX2lycSk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0
YXRpYyB2b2lkIGtzel9naXJxX2J1c19zeW5jX3VubG9jayhzdHJ1Y3QgaXJxX2RhdGEgKmQpDQo+
ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qga3N6X2RldmljZSAqZGV2ID0gaXJxX2RhdGFfZ2V0X2ly
cV9jaGlwX2RhdGEoZCk7DQo+ID4gKyAgICAgaW50IHJldDsNCj4gPiArDQo+ID4gKyAgICAgcmV0
ID0ga3N6X3dyaXRlMzIoZGV2LCBSRUdfU1dfUE9SVF9JTlRfTUFTS19fNCwgZGV2LQ0KPiA+ID5n
aXJxLm1hc2tlZCk7DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGRldl9l
cnIoZGV2LT5kZXYsICJmYWlsZWQgdG8gY2hhbmdlIElSUSBtYXNrXG4iKTsNCj4gPiArDQo+ID4g
KyAgICAgbXV0ZXhfdW5sb2NrKCZkZXYtPmxvY2tfaXJxKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAr
c3RhdGljIGNvbnN0IHN0cnVjdCBpcnFfY2hpcCBrc3pfZ2lycV9jaGlwID0gew0KPiA+ICsgICAg
IC5uYW1lICAgICAgICAgICAgICAgICAgID0gImtzei1nbG9iYWwiLA0KPiA+ICsgICAgIC5pcnFf
bWFzayAgICAgICAgICAgICAgID0ga3N6X2dpcnFfbWFzaywNCj4gPiArICAgICAuaXJxX3VubWFz
ayAgICAgICAgICAgICA9IGtzel9naXJxX3VubWFzaywNCj4gPiArICAgICAuaXJxX2J1c19sb2Nr
ICAgICAgICAgICA9IGtzel9naXJxX2J1c19sb2NrLA0KPiA+ICsgICAgIC5pcnFfYnVzX3N5bmNf
dW5sb2NrICAgID0ga3N6X2dpcnFfYnVzX3N5bmNfdW5sb2NrLA0KPiA+ICt9Ow0KPiANCj4gQXMg
dGhlIHBpcnEgY29kZSBpcyBhbG1vc3QgaWRlbnRpY2FsIHRvIHRoZSBnaXJxIGNvZGUsIGhvdyBh
Ym91dA0KPiBwdXR0aW5nDQo+IGEgInJlZ19tYXNrIiwgInJlZ19zdGF0dXMiIGFuZCBhIHBvaW50
ZXIgdG8ga3N6X2RldmljZSBpbnRvIGtzel9pcnEsDQo+IGFuZA0KPiB1c2luZyB0aGUga3N6X2ly
cSBhcyB0aGUgY2hpcCBkYXRhPw0KPiANCj4gVGhlc2Ugd291bGQgdGhlbiBiZWNvbWU6DQo+IA0K
PiBzdGF0aWMgdm9pZCBrc3pfaXJxX21hc2soc3RydWN0IGlycV9kYXRhICpkKQ0KPiB7DQo+ICAg
ICAgICAgc3RydWN0IGtzel9pcnEgKmtpID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEoZCk7
DQo+IA0KPiAgICAgICAgIGtpLT5tYXNrZWQgfD0gQklUKGQtPmh3aXJxKTsNCj4gfQ0KPiANCj4g
c3RhdGljIHZvaWQga3N6X2lycV91bm1hc2soc3RydWN0IGlycV9kYXRhICpkKQ0KPiB7DQo+ICAg
ICAgICAgc3RydWN0IGtzel9pcnEgKmtpID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEoZCk7
DQo+IA0KPiAgICAgICAgIGtpLT5tYXNrZWQgJj0gfkJJVChkLT5od2lycSk7DQo+IH0NCj4gDQo+
IHN0YXRpYyB2b2lkIGtzel9pcnFfYnVzX2xvY2soc3RydWN0IGlycV9kYXRhICpkKQ0KPiB7DQo+
ICAgICAgICAgc3RydWN0IGtzel9pcnEgKmtpID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEo
ZCk7DQo+IA0KPiAgICAgICAgIG11dGV4X2xvY2soJmtpLT5kZXYtPmxvY2tfaXJxKTsNCj4gfQ0K
PiANCj4gc3RhdGljIHZvaWQga3N6X2lycV9idXNfc3luY191bmxvY2soc3RydWN0IGlycV9kYXRh
ICpkKQ0KPiB7DQo+ICAgICAgICAgc3RydWN0IGtzel9pcnEgKmtpID0gaXJxX2RhdGFfZ2V0X2ly
cV9jaGlwX2RhdGEoZCk7DQo+ICAgICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGtpLT5k
ZXY7DQo+ICAgICAgICAgaW50IHJldDsNCj4gDQo+ICAgICAgICAgcmV0ID0ga3N6X3dyaXRlMzIo
ZGV2LCBraS0+cmVnX21hc2tlZCwga2ktPm1hc2tlZCk7DQo+ICAgICAgICAgaWYgKHJldCkNCj4g
ICAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LT5kZXYsICJmYWlsZWQgdG8gY2hhbmdlIElSUSBt
YXNrXG4iKTsNCj4gDQo+ICAgICAgICAgbXV0ZXhfdW5sb2NrKCZkZXYtPmxvY2tfaXJxKTsNCj4g
fQ0KPiANCj4gYW5kIHRodXMgdGhpcyBjb2RlIGNvdWxkIGJlIHNoYXJlZCBiZXR3ZWVuIGJvdGgg
cGlycSBhbmQgZ2lycS4NCj4gSSdtIHByZXR0eSBzdXJlIHRoZSB0aGVhZF9mbiBjb3VsZCBiZSBz
aGFyZWQgYXMgd2VsbCwgYW5kIEknbQ0KPiBzdXJlIHRoYXQgdGhlIHNldHVwIGFuZCB0ZWFyIGRv
d24gY291bGQgYmUgaW1wcm92ZWQgaW4gYSBzaW1pbGFyDQo+IHdheS4NCg0KVGhhbmtzIGZvciB0
aGUgc3VnZ2VzdGlvbi4gSSB3aWxsIHVwZGF0ZSB0aGUgY29kZSBhbmQgc2VuZCB0aGUgbmV4dA0K
dmVyc2lvbiBvZiB0aGUgcGF0Y2guDQoNCj4gDQo+IC0tDQo+IFJNSydzIFBhdGNoIHN5c3RlbTog
aHR0cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2RldmVsb3Blci9wYXRjaGVzLw0KPiBGVFRQIGlz
IGhlcmUhIDQwTWJwcyBkb3duIDEwTWJwcyB1cC4gRGVjZW50IGNvbm5lY3Rpdml0eSBhdCBsYXN0
IQ0K
