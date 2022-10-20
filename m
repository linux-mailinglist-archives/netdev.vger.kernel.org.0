Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF80F606A2B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJTVZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJTVZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:25:30 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34FF419C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666301128; x=1697837128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/BRDAsWw3rTJOYltR6zEHq+vUZTomttly+kjNfxfYUA=;
  b=JxYfQhHFSHRH5Kl6LYXLjOVdBMp+6SSwB4dPXNDs4YFCaGzKo+TQhHNT
   l8PoMnbpXpZFkgH+86ldB9NDz7LQ5ym94AxLX4wWt8RDhqvcwM9UATaBD
   St53Pk0NQTEdn0g8iBMdPA9kqS54qxDCWetvXWNIrCuisC1EK6DaT74yT
   xWpt5dRlcpc0iO6b0o84dpf2WTVgSEJe/Ba93DF7uQaxVfXs4JUXRohhd
   D/ndlYB9dUc7TdLEwozxHijcH7O+BGuN1z2vqS0XKec0jWxFRvt1go7Q4
   8SjfygImIvWACO5T9598zwTLmHbbgXZr9E1q7I1kdPtoF9KgH6ixFEf+D
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661788800"; 
   d="scan'208";a="326481544"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 05:25:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oa+Rj/9cqqx5O8NNPL3jRD9cbAdieVo1XVssKY86TBDAej81HTgl5X5GNpz3640NSg3RlnXhgOsr1fLgifgUy2FCM+W7LMgnW2otWHm6ZCRGI13oW0c+T8RHE/uk1RtDW6fODnhldXbr3vqt1y8DYwcaav4saEJkaZRMjasZYhufuzb9IwbCZtz1fa2IvkdKIpONGJu3alEAINLWCPOIuAkiiFaPe10GqN5y3369mgn5Y/vxAGT/rpHHKii2Eggq3MozemlCYl9yG/2DOcy+/IWEFDhFcAu0S3kwR/KQZBQR0Jz7x0HHYPUZXIDYvC0kLkgfz1KlqF21/PZyF/5d9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BRDAsWw3rTJOYltR6zEHq+vUZTomttly+kjNfxfYUA=;
 b=SjfNuhjMqo9UtBEBQ07y4SJRuVue/VbPTOosDGaVLHxeWRTQyCztuOPYhcn9gY3WY0bhNkalKJHw6i47J7IB3a2xwXlNp5lHrQbC797Qc0bzeywDKWOzMiU2IY/K89lA7IkWxph1yZydvp/spbivCYwvIj7JpbrNVQ0tab/3C2VuZjKost40tOUZNyvA72dGM7zt91ztij/+GAolsx5Zo0VaN4Ywi7mK4q7/qTWHTgFrnxim9BhPkLqqGLnJdH+uZgtzyJ91ysq/pD4zQFbX/OIDMNPlbOr+PW7JSQwl9QpV5K3FC/DxLNp7b4gmSZdnX+aQd9mlJDcBlmaXpGmrfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BRDAsWw3rTJOYltR6zEHq+vUZTomttly+kjNfxfYUA=;
 b=bzM0hxwTGwuhb3SiQvvPmDMcLXVJiNkJT9hXZmMBrXswafSJOEgcVRurrFIElUGT/HxTe2X4/27aQT+fjWz/zd3+bhzR13UNcKJ49R5WxGN6RTgquumIfTjVIto59CcgA1w0G9FwxaPStToMjVFk7NhonoCNR26XctzQWx4HckQ=
Received: from BYAPR04MB4151.namprd04.prod.outlook.com (2603:10b6:a02:ef::28)
 by MN2PR04MB5967.namprd04.prod.outlook.com (2603:10b6:208:da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Thu, 20 Oct
 2022 21:25:25 +0000
Received: from BYAPR04MB4151.namprd04.prod.outlook.com
 ([fe80::7faf:c6ec:d7f4:ed8]) by BYAPR04MB4151.namprd04.prod.outlook.com
 ([fe80::7faf:c6ec:d7f4:ed8%4]) with mapi id 15.20.5676.046; Thu, 20 Oct 2022
 21:25:24 +0000
From:   Kamaljit Singh <Kamaljit.Singh1@wdc.com>
To:     "edumazet@google.com" <edumazet@google.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] tcp: Ignore OOO handling for TCP ACKs
Thread-Topic: [PATCH v1 2/2] tcp: Ignore OOO handling for TCP ACKs
Thread-Index: AQHY5LD2Tv6XifhhFUauN+p+/7afxK4XoisAgAApYQA=
Date:   Thu, 20 Oct 2022 21:25:24 +0000
Message-ID: <4dbc732f7cfa066bd07eaf7eb653e2b4e4a8de80.camel@wdc.com>
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
         <20221020182242.503107-3-kamaljit.singh1@wdc.com>
         <CANn89iLZZAA6N5wzzP_ZR2u-shHLxknobxt+5CixA92rv7udcw@mail.gmail.com>
In-Reply-To: <CANn89iLZZAA6N5wzzP_ZR2u-shHLxknobxt+5CixA92rv7udcw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR04MB4151:EE_|MN2PR04MB5967:EE_
x-ms-office365-filtering-correlation-id: a018335c-d7aa-4362-4129-08dab2e19a14
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlKpcDIdCcxGkjOo6Ha1fMONsDhl09pMkgnx9z9Tc4rplPuSqdbYEoX+Qj0hv0cNo9utQJXIKJ1o/ZOf5V4/PhbHkOQ0y/fIQP3Gc9V7m8FqNmQldSXVslwxBMZqgkqOx84V9zZ4r8t560bqycIkG/Smm4rKq1iCfi84/VEi57jl/YIig7hD1f2JJwpm9H27uTNDblA849n1CUMBl1mieOU8VP6WHWdryp7vzNj9M3wB34VSJnfwXKmXsDN4XAyU+Q/ezluXQudaQUsZ8CrXRGqdRqVvCB31jRoNsT8yCXZQ+xofi+u44pyyQb5quZ+5/hzzqCUpD5yZ3gPlWLYBeGEwNWmdd4x5sfq/B3R5E+RpLtc5eUBOloidbNmEuxc3hAbfHvKGAhh8v3Cd/wicycMkZR3XoI9OhjwI2SI5aLrMb1BYbulSCOXkYGRPg2kyCjtsdiKbSU5jqViZJKgZv5Bk+adXAV+gSe8y2lhAOZFuMeRnzFlvARkGSx/afLF/GtlTOFZfAkOM9uFu5j0C5kUQEAxXX2FVDKDRk+EmR6soOkJsYYgVkqAQ52xGd3JpoU5QAxhIzim7j5FZ+RJiw5T6o9K/Tl/ijCPrPOUZ7TAJC0eKuP7YK9HgKWaTtOxwsFGIdwG94hcQU7DqMMNXxMcirOv0vKFWX7i5VAGoRdyVisEzuQfAaBiMxQI6mht74IuCpiV4Qr0FaYsCtUzRcrW+MlXjRJKKZ/kEKTKRJh86p6RXLdtWCPy1mDhuuA0clt6CitwzNjoaBjiQBO1bDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4151.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(38070700005)(4326008)(54906003)(6916009)(6512007)(76116006)(26005)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(41300700001)(6506007)(36756003)(53546011)(316002)(8936002)(83380400001)(2906002)(4001150100001)(186003)(66899015)(6486002)(82960400001)(71200400001)(478600001)(2616005)(38100700002)(86362001)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTVKbmVoMmUyVGliQnJQVHVIQWp6QjBGTUltVlIzK0JlS1R1emY2RjJTTEpk?=
 =?utf-8?B?VW9TV2Z1cG8wSnBhbzFzMzJ1RFkxaWNQcGNoRmo5Zy9iS0UrM1Q1WFM4dGdt?=
 =?utf-8?B?RFJabHhqcC9neW9kWVAyVXN3VkVpeFBwbTY4cmVpMFpBQUI4ZnNuZ3F2Q0FM?=
 =?utf-8?B?NEhzcUh1cWxhRVFFR0x3Vzh6SG4xVHJHVnRob2xiMGtTTGNWV1QwYjVJZThD?=
 =?utf-8?B?U2pEWHhOYlpHYkdJR2szcDZzNVlhWDNyQ1NqOGJqaVEvT1N3YjA1eDlUYlAx?=
 =?utf-8?B?T2VPdmJpTFhqY0ZhVUVtMGoxYlpEdVRxWm94WlpWTEZGOFhJY2MxdW16Tmtr?=
 =?utf-8?B?azMvc05zVzBZblowZ0U3dm96aE9KZDE5UmRBNWVERnFUYzNaVXdqczhyNmpO?=
 =?utf-8?B?V3ZUQUhnNVlHZlF4OHJIa1M5L0lnVU9yMDBxY3hrMjdGRmlQbXYwYUgrSDBF?=
 =?utf-8?B?QjJxR2NXenROTjcwaFRhUEtYLy9ld3lTbGJ3aDlibDNWcHhHVU4rc2xYK3FO?=
 =?utf-8?B?OGw5VHZ3c2I2bDNjdGZVYlJOa2Flc1Mzc3VYUXJiTzBCUnBXSjZHQXhoQi9r?=
 =?utf-8?B?QWx2WEMxb3pPU1Y0YXRHcHlmWUJXK0lORVFSSFEwL0UwVTRTSHVsZTloMHZW?=
 =?utf-8?B?NXlRd1R3cFg0eVVLUlJTQXhYOU1McnlGV2tQMlkxNzM4U0tjUHNhRVZSeHlq?=
 =?utf-8?B?enREMFNRdU1NV3dQWHBUS21RNmtVbmcyOGNqWmNsWVAzZGpGTGoxZ0h1UmNN?=
 =?utf-8?B?bklhR2h5SmpXMitIWTNmeGVhR0RxTENwTWh0dTZGaGFsTEtZenpEd3lteXhS?=
 =?utf-8?B?dG5CdUhlTS9oWlI1NkkwRWVFSStaYzFTbGJvMmNJY0RNZjVsRlMraTUrVGcx?=
 =?utf-8?B?WEZ6K0s4dUZKNnBKd1dxTzdpTTdwZFNJSzJjbFAzalBvU0dTRGhGYTJyRHJu?=
 =?utf-8?B?Y1FTWVA2NzZCSVZTN1VpdEtlMU5qWnM3cmg5T2NubmVqZUU3NEhYRlZwdDNy?=
 =?utf-8?B?S2orTGJndFFJakhZN2JTSFVOanBsMCt1R0lEeDk0UE9nc2Zscy9Fc3pRSVEy?=
 =?utf-8?B?OVJsYlh5RzNJVWlpTTcvRktxbjVIdVorb21oL0NRN0JuUmhTV0s5dGxWZ2lj?=
 =?utf-8?B?OHVaZE92MkkxS0JPa1JVWWc5L1IwRlVmQXZTdXhPMFcyT2xtekVTQU1Sa001?=
 =?utf-8?B?dWVEcGtzeDV0b0VNdnJZVTdBbnpKZjJoMU5FMkVTS3h5Wld4TlVodzczbEpm?=
 =?utf-8?B?U3g0d20vaTlaSXBPWkdHSEZDbnd1OGJtdWZ0bUpncXVNMnRJUmEzOWxrSkZs?=
 =?utf-8?B?WnJLMmZEVFluN1RKejFPWVFuNjk5MmZUNUZXendoSjBzZzJRcFlLVWNrd1g5?=
 =?utf-8?B?ZW5XNHl1L2J2Vkt2cllSZFFNTWpaVXRqVkJySUNYL2RDRmtnTmhyakRSMmxV?=
 =?utf-8?B?a1BoYU1ENFk4SEsxSmFIN0htaGJKdGdzbEFsdVFQUzZrR1VZRENjTXFHWHdn?=
 =?utf-8?B?VXJxeFNZVFNadUhtSExld1p6bVB0Wm9KQzZrZnZCQzJkQys3UE1TVUZGTnE1?=
 =?utf-8?B?SklnNk9iVDh6dDVRamNZRkJBTVJyYld5REVIb2ZwMHhhQ1UySzcyVWp1WXdq?=
 =?utf-8?B?YXhPd0FibzdTemI4ZFUzaWFzSGRlZkc3Y2IxTWpKdjdoang1Qm9YWE00SXdy?=
 =?utf-8?B?NXYvd3lMbDd6aUpzR1ZJb1ZJWEV2dXp6dFBadkoyeDhLRklVQmJpL0llbnh1?=
 =?utf-8?B?TEowM1M5YnRkZk9OYlFObVhyS0QvWitFWEtoM0V2R1RTcllCWHVGNi9qbGdj?=
 =?utf-8?B?MUdoS2dtbTNoeDR0bkJGakRHU1Z5NTlzQ2plR3BIYk5kazIwajZBL0VGOEZH?=
 =?utf-8?B?MjYxcnhTS05xb0VwNUpWZ3BUMUVDd1h3ZWw5b2lmSGhXZGttU0o1VkRxR200?=
 =?utf-8?B?UTRzSE81NnRuc1JuUmlhcUtNZXBGa3pwSFFsbVNhYUpxQ216NkRuaXlTbnJr?=
 =?utf-8?B?OUJBcFNaUVlTQkxFNGpSSm5PTFNtSTduSE1yWmlwMFpOSzZuTnM1N2R0VkNW?=
 =?utf-8?B?Nm96M3J1Wkg1WXFZRjU1b0JEeWJ3eGNmWnJhd0kvNllhYjluVjZ3anVhVWlJ?=
 =?utf-8?B?OCtkcVV3ZE1OYWdSOSs4TStsOExiZFpYNGwvUGY1YW43MXNrcXM5UXJOc21u?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2ECE2DA704FC04DA44AB1E1B203EBE3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4151.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a018335c-d7aa-4362-4129-08dab2e19a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 21:25:24.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pA0/jX7YtBqPKmOBVepLGO3DBQ0gW9/TOBii2171m392xngCFNW2hIp5ouIilx/HzTXkNkB6qL6zxJIGA6CaQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5967
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTIwIGF0IDExOjU3IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgV2VzdGVybiBE
aWdpdGFsLiBEbyBub3QgY2xpY2sNCj4gb24gbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxl
c3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoYXQgdGhlDQo+IGNvbnRlbnQg
aXMgc2FmZS4NCj4gDQo+IA0KPiBPbiBUaHUsIE9jdCAyMCwgMjAyMiBhdCAxMToyMiBBTSBLYW1h
bGppdCBTaW5naCA8a2FtYWxqaXQuc2luZ2gxQHdkYy5jb20+DQo+IHdyb3RlOg0KPiA+IEV2ZW4g
d2l0aCB0aGUgVENQIHdpbmRvdyBmaXggdG8gdGNwX2FjY2VwdGFibGVfc2VxKCksIG9jY2FzaW9u
YWwNCj4gPiBvdXQtb2Ytb3JkZXIgaG9zdCBBQ0tzIHdlcmUgc3RpbGwgc2VlbiB1bmRlciBoZWF2
eSB3cml0ZSB3b3JrbG9hZHMgdGh1cw0KPiA+IEltcGFjdGluZyBwZXJmb3JtYW5jZS4gIEJ5IHJl
bW92aW5nIHRoZSBPb08gb3B0aW9uYWxpdHkgZm9yIEFDS3MgaW4NCj4gPiBfX3RjcF90cmFuc21p
dF9za2IoKSB0aGF0IGlzc3VlIHNlZW1zIHRvIGJlIGZpeGVkIGFzIHdlbGwuDQo+IA0KPiBUaGlz
IGlzIGhpZ2hseSBzdXNwZWN0L2JvZ3VzLg0KPiANCj4gIFBsZWFzZSBnaXZlIHdoaWNoIGRyaXZl
ciBpcyB1c2VkIGhlcmUuDQpUaGUgTlZNZS9UQ1AgSG9zdCBkcml2ZXIgKGFsc28gbWVudGlvbmVk
IGluIHRoZSBjb3ZlciBsZXR0ZXIpLg0KDQoNCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FtYWxq
aXQgU2luZ2ggPGthbWFsaml0LnNpbmdoMUB3ZGMuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvaXB2
NC90Y3Bfb3V0cHV0LmMgfCA1ICsrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvdGNw
X291dHB1dC5jIGIvbmV0L2lwdjQvdGNwX291dHB1dC5jDQo+ID4gaW5kZXggMzIyZTA2MWVkYjcy
Li4xY2Q3NzQ5M2YzMmMgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2lwdjQvdGNwX291dHB1dC5jDQo+
ID4gKysrIGIvbmV0L2lwdjQvdGNwX291dHB1dC5jDQo+ID4gQEAgLTEzMDcsNyArMTMwNywxMCBA
QCBzdGF0aWMgaW50IF9fdGNwX3RyYW5zbWl0X3NrYihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdA0K
PiA+IHNrX2J1ZmYgKnNrYiwNCj4gPiAgICAgICAgICAqIFRPRE86IElkZWFsbHksIGluLWZsaWdo
dCBwdXJlIEFDSyBwYWNrZXRzIHNob3VsZCBub3QgbWF0dGVyIGhlcmUuDQo+ID4gICAgICAgICAg
KiBPbmUgd2F5IHRvIGdldCB0aGlzIHdvdWxkIGJlIHRvIHNldCBza2ItPnRydWVzaXplID0gMiBv
biB0aGVtLg0KPiA+ICAgICAgICAgICovDQo+ID4gLSAgICAgICBza2ItPm9vb19va2F5ID0gc2tf
d21lbV9hbGxvY19nZXQoc2spIDwgU0tCX1RSVUVTSVpFKDEpOw0KPiA+ICsgICAgICAgaWYgKGxp
a2VseSh0Y2ItPnRjcF9mbGFncyAmIFRDUEhEUl9BQ0spKQ0KPiA+ICsgICAgICAgICAgICAgICBz
a2ItPm9vb19va2F5ID0gMDsNCj4gPiArICAgICAgIGVsc2UNCj4gPiArICAgICAgICAgICAgICAg
c2tiLT5vb29fb2theSA9IHNrX3dtZW1fYWxsb2NfZ2V0KHNrKSA8IFNLQl9UUlVFU0laRSgxKTsN
Cj4gPiANCj4gDQo+IFRoaXMgaXMgYWJzb2x1dGVseSB3cm9uZyBhbmQgd291bGQgaW1wYWN0IHBl
cmZvcm1hbmNlIHF1aXRlIGEgbG90Lg0KPiANCj4gWW91IGFyZSBiYXNpY2FsbHkgcmVtb3Zpbmcg
YWxsIHBvc3NpYmlsaXRpZXMgZm9yIGFja2V0cyBvZiBhIFRDUCBmbG93DQo+IHRvIGJlIGRpcmVj
dGVkIHRvIGEgbmV3IHF1ZXVlLCBzYXkgaWYgdXNlIHRocmVhZCBoYXMgbWlncmF0ZWQgdG8NCj4g
YW5vdGhlciBjcHUuDQpBcmUgeW91IHN1Z2dlc3RpbmcgdGhhdCB0aGUgcHJvcG9zZWQgY2hhbmdl
IG5vdCBiZSBkb25lIGF0IGFsbCBvciBkb25lIGluIGENCmRpZmZlcmVudCB3YXk/IFdlIGRpZCBz
ZWUgYW4gb2JzZXJ2ZWQgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgaW4gTlZNZS9UQ1ANCnRyYWZm
aWMgd2l0aCB0aGlzIGZpeC4gSWYgeW91IGhhdmUgYW4gYWx0ZXJuYXRpdmUgaWRlYSBJJ2QgYmUg
aGFwcHkgdG8gdHJ5ICYNCnRlc3QgaXQgb3V0Lg0KDQoNCj4gDQo+IEFmdGVyIDNXSFMsIGFsbCBw
YWNrZXRzIGdldCBBQ0sgc2V0Lg0KLS0gDQpUaGFua3MsDQpLYW1hbGppdCBTaW5naCA8a2FtYWxq
aXQuc2luZ2gxQHdkYy5jb20+DQo=
