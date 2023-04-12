Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584BB6DFA8B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDLPrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDLPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:47:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB76059E1;
        Wed, 12 Apr 2023 08:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681314455; x=1712850455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B7mBPod028QCDnAhEvgoExGiid9hUlg1RvVgqqC4Fjw=;
  b=rRus0n+mDs7DQHPv5j351iKLKn/Zw5L1vUmolFCkDOo1HWURIvUkA4f3
   REJov38u2ZO1azYXYDfOaWd7t8bxR/60dxvlkZGHpHAMF20i2ImVq9b8a
   EQLqzt5TKaZeHw1Zwk0fEmRiS3+56ua0/vKr/GGeXpRSzJ+fDeISPGDup
   4MuXj7lhtLx53jNgI30Nt4l+u40l5g4INWGWV5ULvfd+fxtjKf4a+gLxK
   F53JEwAGkyFYv3NMO2/JMGGBUZLMfS+bmRERSC5bV38sQKckzVYs6cjl5
   R9Nz3AJrFFztqo6DfnMZ0/FXk6MD4M2sfS4PPCdTKNGdZEk4WM0i4YI1U
   w==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="scan'208";a="146725149"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 08:47:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 08:47:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 08:47:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7gGnMuRkrGsOhApcwH6EBGyQed17SDWgiJNT0prgjPX/rzoxDJfutSI6tCZaCySCoibrQI0XuNJWfDc8Rpg4+QMUkD1xwL6tEuLc0cOP1kxQdpBW0TEMfh8ara7Gui91kHZdsDvTEFEXRV3uC4g+OHqbIAfUAI6sMzBdXKO1BeoqW3lFhrjN1GncFBkOZsGH83Pxp57MGZLmmciI9uxMo608bg7tCRHV6lGCKjHMrRgJWmXl6nwXDa9x3NWTeVJUfxVXO+B7Jfj63DgJ5JFWh56gQ9sCqFNx9shuY+PzDS4glD+B0T+0y36EnrlwEu/ltV7zj8HOGqS0nXMMqxk+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7mBPod028QCDnAhEvgoExGiid9hUlg1RvVgqqC4Fjw=;
 b=nr1syYVhgG6DAyGeBNNxMgccCOtbfaHwk7dGgZeUuPc3IFk2vnZD9JkJituXw6q2QgMJZJU8jlC4vmPcUYRtl3XxiKcLs5AVYzYwBbXuwt2XGJ+MiAfPQh60tF6vFl09bI/eqUtDX7U+QvB8vPcKwn2wEppj8t4rRcDcz5Ch3JtwYB9SZf7wArIx0p+FK/uVEz0QLR7stWykr5FleFR0I0foBkM106grEWVsBHClGaxm042c4XEsUIhvy2oqY2PxkWdRDq5RP4zld8VYlKyHNBQJbuqYCPQfINzOXDJTsJtyNT32L5NyJSraVnmPJPhguZMoixpaC6JkWtSiD0JonQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7mBPod028QCDnAhEvgoExGiid9hUlg1RvVgqqC4Fjw=;
 b=sjnu8utaoo6n7gWkdRNv8E6xNNw/1k+NMepPgEKI4BUENP9AedWKQr6E70K617DAvNaiq2jE5h3yfFrUWUXlQkySCkURB7EJp13H72J5yfEyiWLrMVkjPhs499kioj/ZELCRSHpoei7rjQ/TcJOA8hQh31eWMmqhrMQoHjRU0A8=
Received: from SJ0PR11MB7154.namprd11.prod.outlook.com (2603:10b6:a03:48d::9)
 by CH3PR11MB7820.namprd11.prod.outlook.com (2603:10b6:610:120::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 15:47:31 +0000
Received: from SJ0PR11MB7154.namprd11.prod.outlook.com
 ([fe80::8052:da5b:3a4d:45a]) by SJ0PR11MB7154.namprd11.prod.outlook.com
 ([fe80::8052:da5b:3a4d:45a%3]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 15:47:31 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <kuba@kernel.org>, <roman.gushchin@linux.dev>,
        <Claudiu.Beznea@microchip.com>
CC:     <lars@metafoo.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rafalo@cadence.com>,
        <Conor.Dooley@microchip.com>, <davem@davemloft.net>,
        <harini.katakam@xilinx.com>
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended buffer
 descriptor mode
Thread-Topic: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Thread-Index: AQHZbVYX579Dls5bQEKuTBIqwhJgvg==
Date:   Wed, 12 Apr 2023 15:47:30 +0000
Message-ID: <70253758-c167-02dc-9266-96edef8597f2@microchip.com>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
 <20230411184814.5be340a8@kernel.org>
 <6c025530-e2f1-955f-fa5f-8779db23edde@metafoo.de>
 <ZDYqIj4Fg3tlGKd5@P9FQF9L96D.corp.robot.car>
 <20230411211343.43b6833a@kernel.org>
In-Reply-To: <20230411211343.43b6833a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB7154:EE_|CH3PR11MB7820:EE_
x-ms-office365-filtering-correlation-id: 0f010821-5f50-4d90-42ce-08db3b6d39a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oSL6aQ5JxtGWTZWBpDjjxOwE2QDkMGBbZWAeURkasf2yao7G47nGFBvQ3m2eCVBDAnJPDr9ppVl2Y22+fEMhfkeGYV2txurPYELnLMYhi6ji2EzVP3b4XcOffmTgBBO5OdSjURtbRrY7bp0HL9+EeCmpe8i1u2Se8Wcry3cBlobyfxEp8p2in61HlkZgnXm2sr62Jtg0J2HffwiTiMrVjU/FVvjg6A3eW/0NSvtns92SjH0F64/JtAeOmDr/Eu9VP401BCI5E6lAzRLO7DTDPFHC+2EbWuTz6GrBDJLG6i6keOiBEX3B/m48UDxADnhc/5Wl7aXcyPj24wsthb2ZtvK5QHBT0uIJEpEmaeVeCyzJze17fcziafVcnUflmwtm8WXiDkZi0B5Ytw491/vbbc78SaeOvjOzGn6sIoIxVu+5Nx4b+t3glZizRZC/WoU/ilSwOCosYnIBXG3xt0bmXAU7PyxDzgdrk3F054jXAKX1+eRbV9ITU2jyDVW3n5v9xue699mBmIr9qUop04XPEsEOohRt6HAgCvgFBT5o99kd10bhjgzPRWzpEpSK3J2r1ZeaDScc3IxkHIeRGn9jUguNEKMnE3/mnK/jePf2iWvoDFauNtEFkwqFzahtIh4Pz+KFsLXLMpJip281VBxXSY8AJ+6qV+UykzA3iy9fzNbVHF25NmnBGoFjIGVDw2fn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB7154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199021)(83380400001)(76116006)(2616005)(91956017)(6486002)(71200400001)(478600001)(186003)(54906003)(110136005)(6506007)(6636002)(6512007)(53546011)(2906002)(36756003)(38100700002)(5660300002)(122000001)(66446008)(64756008)(66946007)(4326008)(41300700001)(66556008)(66476007)(8936002)(38070700005)(316002)(86362001)(31696002)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVA5Uldpc0VtbDRkOVByeWxZb21tSkV0T2MwZVlmeENtbzdWZzJHcWxTVWlq?=
 =?utf-8?B?WHpiTk9iMis4N3RzcXBwd0toQVFqSzdyMTBzaEtxM3JxN1A1SVdVNmJ4d2hT?=
 =?utf-8?B?Q0g0MTh2aGZZQ1MrSk1HTFFENkZ6alZpUmJ6bWJZOWwxMCtoMGVWMllWNHN2?=
 =?utf-8?B?KzVTUFB6c3R1QmNRKzlDaGcrWG5hTXZnN0ZOckFocUxSeWk4d2E1RC8vUlQ0?=
 =?utf-8?B?UWNhVSsvcHd2bUQ1OUd0OE5aUkV0UEhUazBBc2JwbTZwMTNHMmVidXFFblRR?=
 =?utf-8?B?R3NNRnhualFYb0E2aGNTUXYrbzY1SkUwU1JzMFlqK1A4NGpiKzdhdWYrTUZK?=
 =?utf-8?B?RnhtVlViMnU3MzMyU0I1ZGxiUHExbUJIdEs0RHR3SnkxUWlzS1BkL3hQUVc1?=
 =?utf-8?B?Y0lqWmlLbXZKc3lZWGtiblA0U2s4TU1DSkVHb3krckNtOEhxWnpId1o0MW9O?=
 =?utf-8?B?eE10c3UyVWcvUTl2Wlh0UzNmclhOaW1TdGNzK2w5bWZUakkxZ0NhRW9MS3N1?=
 =?utf-8?B?bTdsOWp1OE9BYUFMbzNLZEVjcGR5WklxbFMvUHlKeFRFTVB1SFhjamJlbWl0?=
 =?utf-8?B?eEdpUEFHZ1QvdlV2SW42NHJJYk1SM1JvODdTa3ZiL01zN0l1aEphOUU3T3lO?=
 =?utf-8?B?dzltSW4ydXBrV0ZlaEd5elJVOUxRcERBQmptNm5xanZZVG93Wm9EZGFuVjJr?=
 =?utf-8?B?UUVmeVlEM3UzL1lkNW9adUtIaHd1VGVQcVkzMHh0WFpabW5GZ0FKQldXbXdU?=
 =?utf-8?B?SndqSGs0cUtVSEVEQjU1K2VXajlYWlZTTk81VTdyNlJVNklLeHhDODBWb0hK?=
 =?utf-8?B?eXVYSEl3MlM3VDFjK2JhU2pDRVBkVkhIYzVtaGdxQlpRbEFyaWhiL2krU3pS?=
 =?utf-8?B?alFLQzQva1NDaFJmZnkvMlRyRFZIZVVHWkhBbXUyajJKb2RlL3VnSTNHRG14?=
 =?utf-8?B?ODJ5WXhvUWN5OStIeVZxM1BVT2JaN2tEcTB3ZXN3MGVYOVpBTkhoQjFDQ3Q5?=
 =?utf-8?B?OU03cWFSVlI2UjFpVjN4bGVXV2dlelhrZ2Z0VEpLbzYzWEVrL3hKSmF2cXFm?=
 =?utf-8?B?VSswMURmSllHNS9Ybml1RlBaUm1ZOC96Z2VNUlFORkFzWGVzSEpaQU1vNzJi?=
 =?utf-8?B?b3JiWVdzN1ZacnV1UTVDNk85d0tMVkE1UnZjak8xSHZ6Nm9aWFVQYnpqV1Iy?=
 =?utf-8?B?dndqNjNKclQ4VHp1dytKbUlQVXNTS3l5QTFkU2FjNlo0cGVEdERKWnVWYzEv?=
 =?utf-8?B?dlZONWdOUHhSbXVmT2hyM3NsT25yRTNac0FjcDlHZTFsczFwdGQ5RC9ZVENR?=
 =?utf-8?B?alBVYlI0UnVMZVd3YUdLdW44eG5UU1dkT3BEaVRHd3ZaVDZockZvV05hb1RN?=
 =?utf-8?B?TzBMOHNpaHk1ZllHZ1Z3a3JCTXRVK3RsN1B4WjYvcGFMekZhaGh5UVVQZGZT?=
 =?utf-8?B?RmVhbE55aTFDR2ZtdGhrQWFERkoxZmdrekQ2TDk1TkVHSURxY3NNVVppWEcx?=
 =?utf-8?B?VjF1Y1h6ZWxkNE9WRmIxeUsxZjBpdXhqYnQyMnNHTzZWU3A2MHZaK0d0Zmxw?=
 =?utf-8?B?TVc1QitGdnBQLzJwTk5yWmdMM0VyYXJDWXYxU3RoalNqSEE4L3RHamU3S3lM?=
 =?utf-8?B?NzNBR0YyZlpRSXUzMjVzcVpLNHl5andvWmMwU3daVVFTbWpBbDI2T04wQy9x?=
 =?utf-8?B?L2VRNlpNRGY4VStKdlh3SGdQeHEwUk12N3ZGc1YvWGkrVEhiOWtJdVhjRzcz?=
 =?utf-8?B?TkM3djFCVUE2Nll6bkdoa2VYaFo5TlBGQmE3bkpiZVYzR1pOYi9rWUxYZnc3?=
 =?utf-8?B?a2FpUW9aMWhuRDBMTFdObGZBMi84ODBhb2E1b25SaTBZMEtqR0E3K1hNN1du?=
 =?utf-8?B?SWFqWmdmRW1lZkFlb2RkMkpOeTRQTGxYbE93U2c2MitIcERaak1uK2dsb2Jz?=
 =?utf-8?B?YVZud2ZUa0NTc0YxbEI2T2FQZzh4elRSS1hkcDZyYTU2citaeFBZMHVmSVlm?=
 =?utf-8?B?UmdKMDZGbUQyMmdHM3RmY3BzNXpVaDVQUGlTa1VHUnFpdzZ4UWcyM2Q0bjBY?=
 =?utf-8?B?dVRQZjJNV3pGZWF4NGNpOXozVHpPekxjYlZWWEhEYVgwbG0vWllQMDNYYlA3?=
 =?utf-8?B?UTBzVnRHdTVCalAveENnUlFBOW1tTDZRd2s5Z0dHM1J2U3ZrTTFXVGZkMUFH?=
 =?utf-8?B?bWNKcWJKTTg0dU9MYWZYRkxrTU5jMEgzTFdmc1ErWEp1U0x1dmJNbmJDOC9R?=
 =?utf-8?B?ZlFndW8wbW5lZzRETmpZNUgxOGd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92A6A00DAE333E44B3B9BDCCB013EBE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB7154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f010821-5f50-4d90-42ce-08db3b6d39a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 15:47:30.7231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9llfjRTzQbCS7fnsYwQSIBP2FbZRC+tZwjTan0l7LLCXMv/85W8CsZ3NnGQQ1OdKOktCNVURc3gIffdQhs9mliFKTGGyZ88tnMnHMpL9ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7820
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFrdWIsIFJvbWFuLA0KDQpPbiAxMi8wNC8yMDIzIGF0IDA2OjEzLCBKYWt1YiBLaWNpbnNraSB3
cm90ZToNCj4gT24gVHVlLCAxMSBBcHIgMjAyMyAyMDo0ODo1MCAtMDcwMCBSb21hbiBHdXNoY2hp
biB3cm90ZToNCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYw0KPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
Yw0KPj4+IGluZGV4IGQxM2ZiMWQzMTgyMS4uMWE0MGQ1YTI2ZjM2IDEwMDY0NA0KPj4+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+PiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+Pj4gQEAgLTEwNDIsNiArMTA0
MiwxMCBAQCBzdGF0aWMgZG1hX2FkZHJfdCBtYWNiX2dldF9hZGRyKHN0cnVjdCBtYWNiICpicCwN
Cj4+PiBzdHJ1Y3QgbWFjYl9kbWFfZGVzYyAqZGVzYykNCj4+PiAgwqDCoMKgwqDCoMKgwqAgfQ0K
Pj4+ICDCoCNlbmRpZg0KPj4+ICDCoMKgwqDCoMKgwqDCoCBhZGRyIHw9IE1BQ0JfQkYoUlhfV0FE
RFIsIE1BQ0JfQkZFWFQoUlhfV0FERFIsIGRlc2MtPmFkZHIpKTsNCj4+PiArI2lmZGVmIENPTkZJ
R19NQUNCX1VTRV9IV1NUQU1QDQo+Pj4gK8KgwqDCoMKgwqDCoCBpZiAoYnAtPmh3X2RtYV9jYXAg
JiBIV19ETUFfQ0FQX1BUUCkNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhZGRy
ICY9IH5HRU1fQklUKERNQV9SWFZBTElEX09GRlNFVCk7DQo+Pj4gKyNlbmRpZg0KPj4+ICDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gYWRkcjsNCj4+PiAgwqB9DQo+Pg0KPj4gSSB0aGluayB0aGlzIHZl
cnNpb24gaXMgc2xpZ2h0bHkgd29yc2UgYmVjYXVzZSBpdCBhZGRzIGFuIHVuY29uZGl0aW9uYWwN
Cj4+IGlmIHN0YXRlbWVudCwgd2hpY2ggY2FuIGJlIHJlbW92ZWQgd2l0aCBjZXJ0YWluIGNvbmZp
ZyBvcHRpb25zLg0KPj4gSSBjYW4gbWFzdGVyIGEgdmVyc2lvbiB3aXRoIGEgaGVscGVyIGZ1bmN0
aW9uLCBpZiBpdCdzIHByZWZlcmFibGUuDQo+Pg0KPj4gQnV0IGlmIHlvdSBsaWtlIHRoaXMgb25l
LCBpdCdzIGZpbmUgdG9vLCBsZXQgbWUga25vdywgSSdsbCBzZW5kIGFuIHVwZGF0ZWQNCj4+IHZl
cnNpb24uDQo+IA0KPiBZdXAsIElNSE8gdGhpcyBsb29rcyBiZXR0ZXIuIE1vcmUgbGlrZWx5IHRo
YXQgc29tZW9uZSByZWFkaW5nIHRoZSBjb2RlDQo+IHdpbGwgc3BvdCB0aGUgdHJpY2tpbmVzcy4N
Cg0KT2sgd2l0aCB0aGlzIHZlcnNpb24sIGV2ZW4gaWYgYWRkaW5nIHRvIHRoZSBob3QgcGF0aCBp
cyByZWFsbHkgYSBiaWcgDQpjb25jZXJuIGZvciBvdXIgbG93LWVuZCBDUFVzIChBUk05IGFuZCBD
b3J0ZXgtQTUpLg0KDQo+IEkgc3VzcGVjdCB3ZSBjb3VsZCBjbGVhciB0aGF0IGJpdCB1bmNvbmRp
dGlvbmFsbHksIGlmIHRoZSBicmFuY2ggaXMNCj4gYSBjb25jZXJuLiBUaGUgY29kZSBzZWVtcyB0
byBhc3N1bWUgdGhhdCBidWZmZXJzIGl0IGdldHMgYXJlIDhCIGFsaWduZWQNCj4gYWxyZWFkeSwg
cmVnYXJkbGVzcyBvZiBDT05GSUdfTUFDQl9VU0VfSFdTVEFNUC4NCj4gDQo+IERyaXZlcnMgY29t
bW9ubHkgc2F2ZSB0aGUgRE1BIGFkZHJlc3MgdG8gYSBTVyByaW5nIChoZXJlIEkgdGhpbmsNCj4g
cnhfc2tidWZmIHBsYXlzIHRoaXMgcm9sZSBidXQgb25seSBob2xkcyBzaW5nbGUgcHRyIHBlciBl
bnRyeSkNCj4gc28gdGhhdCB0aGV5IGRvbid0IGhhdmUgdG8gYWNjZXNzIHBvdGVudGlhbGx5IHVu
Y2FjaGVkIGRlc2NyaXB0b3INCj4gcmluZy4gQnV0IHRoYXQnZCBiZSB0b28gbGFyZ2Ugb2YgYSBj
aGFuZ2UgZm9yIGEgZml4Lg0KDQpPayB3aXRoIHRoYXQgc3RhdGVtZW50Og0KDQpBY2tlZC1ieTog
Tmljb2xhcyBGZXJyZSA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPg0KDQpUaGFua3MsIGJl
c3QgcmVnYXJkcywNCiAgIE5pY29sYXMNCg0KLS0gDQpOaWNvbGFzIEZlcnJlDQoNCg==
