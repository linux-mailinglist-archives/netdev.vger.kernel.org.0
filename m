Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A38645826
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLGKtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLGKtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:49:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DBE30573;
        Wed,  7 Dec 2022 02:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670410183; x=1701946183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kvGC87ZjhWDrqnndP/UGy6ckI8U5DyQcwjt9m7Sw2dM=;
  b=KgNUUY0GL11mn/oJ8YoNxXW1KpsWxkjQSBlrMXYZSJ+pmzkD0bW6Uaow
   DgTH0LAzECSdl7J7JvPmFZhnfsHy98E2Ww7jQ5z9pVxhErDAx+vTM7Kq3
   MUkdrQ+rzyBz3gQT/o4/Gru2//D+lCsPukPwbudCO8gXiPXfFbAqlBZ76
   PGyZciX6aPfV9q6yAhYc63qRDBQeao00khMXfJYvhLO4ph5BOU9EwVWmu
   NW/urVG2FbY6z4piXtzrNQvQlT3nAs8vMPDSJlp2yOjczMBYY90z/3zpl
   jr4DjuZXKAWufeammumuiMo1FZTVMpubBGit0Mas5kZjru11E05MzT8Uk
   w==;
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="190450758"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2022 03:49:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Dec 2022 03:49:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Dec 2022 03:49:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8BSv87/xhDEGl+8VrIfgHM599wxhOjzGIfE9FhG3MV8juFUT+UZwCOShKDNhM3CrPJwkYHahggQzAL1wzSeOa8oAYfbVstLeoHoWL5eSVijnHXgK71QhSZ+jT7FOeC+9Jfni0i0Hu4lanSy89i+fSkT1Ocb0wX9Fz1bD/7jGSo5rDZ4qkNFm4vneYFX/EC/YEw5CyhrCzjiGMPldA/XS+/QeLKm0l3FFjBrrq8LheslPIgJqb+CjMCaEJoG2Pxkj5V6RC1/I7w6LwDwQ9aMnFYgn3w2t1ggu88NINJ6cgtO+KQwNt3awq5y86fTiGXEjC2yMm16jkI8V4mVYkMUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvGC87ZjhWDrqnndP/UGy6ckI8U5DyQcwjt9m7Sw2dM=;
 b=iuvuN9M2NTC3xC11LtG3f3+FoiVSVfh/uV+IzlB3ufXEjsaq3d1PBCEkWrisnPm2ztqjF9nspMRjlLCgZJv/2CXlh1cpGsBUVZBsFjzeK/HWOeK+YicS4J9WSg0uwX8rlpZNSKd1V9VY+3pl1ZaO3QNE+2/3bur9ikmrSSunpofdSNolaeaSEK2FRVgAtyXlEJUfxAbFwr4HRC7IyMKsQBvpRCWoOVS8IAWqrvCb6vj1RRybLhqgYyfDu8Vu9S9ewhdT3ZDZeTDodoznCdibG5zO57kD7LnOJuOFqKH68piPK2/7Os8XES8toXrGVs+vuPpIy70+kWZG+NhGQqDpaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvGC87ZjhWDrqnndP/UGy6ckI8U5DyQcwjt9m7Sw2dM=;
 b=i8ykxyVD6qBn+qoMDmCgzlNN5p35YXjTlU/eGiAcU+u1K5/VBwGees1eNQHqS5HSFN1zZyH6SJpyC2VBdOrKk6Vaa2FhUBPH8+t4Gb2xWtmVWJhZi3EZWVUpQ/KHdnEqC9Nyeinw178Fr1/2ODMWVFZJGPUUQN4TAfsWyEK9oAU=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MW4PR11MB7031.namprd11.prod.outlook.com (2603:10b6:303:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:49:39 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15%10]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 10:49:39 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <Sergiu.Moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: phylink: add helper to initialize phylink's
 phydev
Thread-Topic: [PATCH 1/2] net: phylink: add helper to initialize phylink's
 phydev
Thread-Index: AQHZCimamQeVqmrndkqd6pgP48+/hg==
Date:   Wed, 7 Dec 2022 10:49:39 +0000
Message-ID: <4375d733-ed49-869c-635f-0f0ba7304283@microchip.com>
References: <20221205153328.503576-1-claudiu.beznea@microchip.com>
 <20221205153328.503576-2-claudiu.beznea@microchip.com>
 <Y44VATEVPpEOBz/3@shell.armlinux.org.uk>
In-Reply-To: <Y44VATEVPpEOBz/3@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: f26859cd-ce8e-40cb-be57-08dad840bd61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VyBzerf51w8fSnLAXGYk6vLU0DOONVmSCAcr4OrlsprdmWJieedg20HB2YNNgoKmSpDpOBSAihowfYUReX04GMBPZdIdLvbNKe9NscDzcyGpkw44yiJrQIdYq9UkI1WOSYhNp3zyOlVXMbH9cHOK6dbWRDCeSG+zwoy1KTK+LVSjCIL0xVT4ZmS5C1ctPsSAttDnCZvsFze0NrHlLETH+F/GDiBvM89LqSNZoGsRaSdaNrMJ9n2bCBtcH7vI/Il1mgLkLx4P3DTraxzWrsrVeb9++jkUfRewI7Upx6dbRpwwSPm69oYDNeoRNcRuDoh16Zl1rZDWgM4aI/0FTMVvnl1mdi0CLkoNZzcHpqxGBTs1/WOVuVNjbheJLe3uJuf1XrklZsmbgFcKW8P/gXYmlF2qWIGi39tyudm+SYO+c5M9dvWLTf2ey07xPWeajZk83BvzDGOxliPvXA5iinUL02aX9BsPRpfzpvI2c/KsBnrMIdZQVvuw7b1pTLqry6wcPkVVlE3wiTiQI1c66ddVl/CdL4+SH5ke6EPBFXRiW6SmRQsxeWmIdZZ09M70hpOt2/dAPX0R6oBM6KsH3Fu2pnCq1nvSq7UzCc1C/qRYYTnFE33YHtmfnuOswYIBBUXpV1g6DLw4yJoNHJOVGPWpBtHEz8sJslG7LfG3K7KsPkwtBZzA/psGG+wLjB+DmjrDmhdmj2uxjfbVcoWIgdCrM0GwQl0WjfjhFvQXrqxbGlik36CJ2VZ6xYGOZ14hvPxYat6W+15gCBPZ7CXqUFNWdbrDNXujsNNdaVJIjxrQQdU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(6486002)(478600001)(53546011)(966005)(6506007)(71200400001)(2616005)(36756003)(4326008)(8936002)(91956017)(122000001)(8676002)(76116006)(64756008)(66556008)(66446008)(5660300002)(41300700001)(186003)(2906002)(6512007)(86362001)(83380400001)(54906003)(6916009)(66946007)(31696002)(26005)(66476007)(38070700005)(316002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnd6T3lmaDlsVU1hcFhaWE9CWmUxWmUvM1pXajV3OUF0WVljTlgveUdUWUhL?=
 =?utf-8?B?M0NHdVp3Q1ZyMGk5V0dQTlVNNGxjR2VEWlk5blBwVmQvYmRJcnVobTJMV0VK?=
 =?utf-8?B?ZE1OTTloT1pHekZ0UnJLd3dPc3B2RnFPTFc4enlrYjhPb3ZsODhBV1BISlJk?=
 =?utf-8?B?ZkRDVHpUcHI5blJkN1BIcUVMeHo2MHRsbk13VmZWS0NZMjZmY0EwRG45OUth?=
 =?utf-8?B?Y09UN3czMXRHd3RwanBxbmwyUm1haXhxdzZhU2NUcy9MVWI5aHZFMXU1Zk9M?=
 =?utf-8?B?Vy8xOHNXR3hZeEZxVUtyR0tabHJEWVE1c1V1VVg3UjIwbk5xc2EzaUdLdlZj?=
 =?utf-8?B?SFQ2Rk5oVUFJZFErSittSHdMSi9PK0YyVFdURVNOVTY0b3ZOTHRCblJ2QldE?=
 =?utf-8?B?VHM0ajNLTmhYYzZJOWpVRE5kTWNMbUhHTG95K20xVVEvbmhCc3hOOW1MejZt?=
 =?utf-8?B?YjlkNEtzL3o0eUVtRlEwQ2FRa3h1S3dIUEduY2Y5VDN2SFhBVmJuZXpWZ2xS?=
 =?utf-8?B?bEt6dlRjU1RDYzJFUHBTZG0wT2NRMHljRWRJNy9XUkpIajhSMEkwckVlRkJo?=
 =?utf-8?B?RVpxcUEwR0VwRjQ3dC9qK2gwVFVwT05mVkR4VXl3V0JySXBlSkpBU3BEank4?=
 =?utf-8?B?TmdDL0ZMeEwzUWFWdXNnenA1cStOd0ppQ3hIbG9HSFMwRGI1aytadlpGYVRr?=
 =?utf-8?B?VGY1UzFJd2l2TjRuZ1pOTWFCSCtDMVdMQ1ZSVXpPYjZpMzd0eHd2UXBudVpW?=
 =?utf-8?B?Q0hvMmVHSVZDaE0vNWU1NThtdTZmU29BcStRU2ExQXZWREFwQ3dpMmN3aGdp?=
 =?utf-8?B?M1drM3pwUzN0ZGJwSHc5TGxtemJJbmlTTTRybnpLa20zZHBBTk1Ic2hwVk9z?=
 =?utf-8?B?UXY0MC9xSmszTWpXeVZ1MzM4bnZXQndZbWFRcHVtclI5enFDeURLVUszMSt5?=
 =?utf-8?B?L3lvczdkbUlDN2Z5MXVzRFBDOXU3djNZTWNXR0JleGZNUEtYNHo5ZTRMeFNi?=
 =?utf-8?B?TW1IYkJJUkozdVJ4VUZJY3NvZ2ZMWGNOMjRSUW5BLy9TOVdnNkIzNWpIb1lJ?=
 =?utf-8?B?SjhYcjJzeHEyR3JHcWVxei84Q2ZSRDJJSXFCVHlTU1BkVFJpcXQvZEpZcksx?=
 =?utf-8?B?WEV5K1lTS1Z1clQvQk1ON3VqcFdjY2xNMGp3b1FxUy9LWGM2ZjcrMHhEaXRF?=
 =?utf-8?B?VHJFSnBDUDhBMHE0TGZiN3R3bitLcXp6NmFya2JNNnNVTHlWTzZ4NkU3d2hm?=
 =?utf-8?B?b1hHaTgxQnNMd3BQMnNFTVl6eU5PdTgvQUZDdEdLUDRjR2U4VkpIWldndVZD?=
 =?utf-8?B?QWs3VEJWdVVnbnFtRTB2RWt1WURQN3Blak10NVJTZ0ZLQ3FBbjZrQ2RYSVNB?=
 =?utf-8?B?bkp1TzFBb1JwY2xyb2x5eCtsNVFycmZ4aFFQUmhlSzc2WFo1dTlDV3RZN2tD?=
 =?utf-8?B?NzBZVklVQ2haV2RkYXcvZXUzVVVxU3I2emdHMmhIblRLQmp1dEhoa1l5WjJk?=
 =?utf-8?B?K0lpeGU5V21kc3BadHI1TXQzamd0bXNjSzNmczhpbmFFWnpRSkRKd05NTGx0?=
 =?utf-8?B?YytINHlKMDNEQ2JQN0RPeHVsOWg3SXcxYURtUFQzaURlOXRzWUs2MFZzZ0Rp?=
 =?utf-8?B?ZXl6WjFvbDI2MmhBcW0wRzNhZ1NFWGhzRFVQRElXTS8wUk04MVZNVzZXWFV0?=
 =?utf-8?B?TVg0UER4Qk5PNUVUZHluc0grcFFKVERZQ09WcnBoR21NRnVKMHpDUXh6dFpx?=
 =?utf-8?B?dVFMSHZQS0tsbWtiakhtUzUxSDhPb2p5MWNUUGIrUGJLaU5uT0pQSituQ3l5?=
 =?utf-8?B?bURUazVDTVRKdWdwK1ZQR0NDNEtHZU4xMHlUeEdCY1hUZUh0bFRSWjIrTUpl?=
 =?utf-8?B?cXZ1U29kaWZKNDRrVU9aNGlNSkl1aFhhNlZvM0Frb25OZGd3SVk2eVpsOVZ3?=
 =?utf-8?B?N09MaHdJaTI3UFp5bzd2SEJ6Z2V3MmI4QjdrL0FkdmZNdUhUVnJiaVZJRjU4?=
 =?utf-8?B?UGVGVHJwbSt2d2Nabk5YcTI0WkJaS0lZZmRCYzd1bEhUaCtqMEZqU2cvSkcy?=
 =?utf-8?B?UUdDVWdFTDVGVlpwVlp5RDdzZVUyQWdaQ1IvcnNHdlhiRkVveHgyV2p2dkww?=
 =?utf-8?B?d21hSk5mSE5ONDBDazBjKzhnWXc2VDFuT2xoSG0wTGdTdVh1M0VOWm5YSkNK?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED56E5C73A0BD1419AB1855750175A36@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f26859cd-ce8e-40cb-be57-08dad840bd61
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 10:49:39.2996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGIqWcdEI/EBAhGulpU/gkx+PJtTtsbvxxzHzAQaLI6Cv1B0RxSVMFNQP1mLsNhNtQC1ChkV36Oh7xHuEV2zvNoPokFPFmFHGoy+xVIX8+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUuMTIuMjAyMiAxNzo1NywgUnVzc2VsbCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIE1vbiwgRGVjIDA1LCAyMDIy
IGF0IDA1OjMzOjI3UE0gKzAyMDAsIENsYXVkaXUgQmV6bmVhIHdyb3RlOg0KPj4gQWRkIGhlbHBl
ciB0byBpbml0aWFsaXplIHBoeWRldiBlbWJlZGRlZCBpbiBhIHBoeWxpbmsgb2JqZWN0Lg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2No
aXAuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYyB8IDEwICsrKysr
KysrKysNCj4+ICBpbmNsdWRlL2xpbnV4L3BoeWxpbmsuaCAgIHwgIDEgKw0KPj4gIDIgZmlsZXMg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9waHkvcGh5bGluay5jIGIvZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYw0KPj4gaW5kZXggMDlj
YzY1YzBkYTkzLi4xZTI0NzhiOGNkNWYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9waHkv
cGh5bGluay5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jDQo+PiBAQCAtMjU0
MSw2ICsyNTQxLDE2IEBAIGludCBwaHlsaW5rX2V0aHRvb2xfc2V0X2VlZShzdHJ1Y3QgcGh5bGlu
ayAqcGwsIHN0cnVjdCBldGh0b29sX2VlZSAqZWVlKQ0KPj4gIH0NCj4+ICBFWFBPUlRfU1lNQk9M
X0dQTChwaHlsaW5rX2V0aHRvb2xfc2V0X2VlZSk7DQo+Pg0KPj4gKy8qKg0KPj4gKyAqIHBoeWxp
bmtfaW5pdF9waHlkZXYoKSAtIGluaXRpYWxpemUgcGh5ZGV2IGFzc29jaWF0ZWQgdG8gcGh5bGlu
aw0KPj4gKyAqIEBwbDogYSBwb2ludGVyIHRvIGEgJnN0cnVjdCBwaHlsaW5rIHJldHVybmVkIGZy
b20gcGh5bGlua19jcmVhdGUoKQ0KPj4gKyAqLw0KPj4gK2ludCBwaHlsaW5rX2luaXRfcGh5ZGV2
KHN0cnVjdCBwaHlsaW5rICpwbCkNCj4+ICt7DQo+PiArICAgICByZXR1cm4gcGh5X2luaXRfaHco
cGwtPnBoeWRldik7DQo+PiArfQ0KPj4gK0VYUE9SVF9TWU1CT0xfR1BMKHBoeWxpbmtfaW5pdF9w
aHlkZXYpOw0KPiANCj4gSSdkIGd1ZXNzIHRoaXMgaXMgc29tZXRoaW5nIHRoYXQgbWFueSBNQUMg
ZHJpdmVycyB3aWxsIG5lZWQgdG8gZG8gd2hlbg0KPiByZXN1bWluZyBpZiB0aGUgUEhZIGhhcyBs
b3N0IHBvd2VyLg0KPiANCj4gTWF5YmUgYSBiZXR0ZXIgc29sdXRpb24gd291bGQgYmUgdG8gaW50
ZWdyYXRlIGl0IGludG8gcGh5bGlua19yZXN1bWUoKSwNCg0KT0ssIEknbGwgbG9vayBpbnRvIHRo
aXMuDQoNCj4gd2hlbiB3ZSBrbm93IHRoYXQgdGhlIFBIWSBoYXMgbG9zdCBwb3dlciAtIG1heWJl
IHRoZSBNQUMgZHJpdmVyIGNhbg0KPiB0ZWxsIHBoeWxpbmsgdGhhdCBkZXRhaWwsIGFuZCBiZSB1
cGRhdGVkIHRvIHVzZSBwaHlsaW5rX3N1c3BlbmQoKSBhbmQNCj4gcGh5bGlua19yZXN1bWUoKSA/
DQoNCkN1dHRpbmcgdGhlIHBvd2VyIGlzIGFyY2ggc3BlY2lmaWMgYW5kIGl0IG1heSBkZXBlbmRz
IG9uIHRoZSBQTSBtb2RlIHRoYXQNCnN5c3RlbSB3aWxsIGdvIChhdCBsZWFzdCBmb3IgQVQ5MSBh
cmNoaXRlY3R1cmUpLiBBdCB0aGUgbW9tZW50IHRoZXJlIGlzIG5vDQp3YXkgZm9yIGRyaXZlcnMg
dG8ga25vdyBhYm91dCBhcmNoaXRlY3R1cmUgc3BlY2lmaWMgcG93ZXIgbWFuYWdlbWVudCBtb2Rl
Lg0KVGhlcmUgd2FzIGFuIGF0dGVtcHQgdG8gaW1wbGVtZW50IHRoaXMgKGZldyB5ZWFycyBhZ28s
IHNlZSBbMV0pIGJ1dCBpdA0Kd2Fzbid0IGFjY2VwdGVkIChmcm9tIHdoYXQgSSBjYW4gc2VlIGlu
IHRoZSBzb3VyY2UgY29kZSBhdCB0aGUgbW9tZW50KS4NCg0KU28sIGluIGNhc2Ugd2UgY2hvb3Nl
IHRvIG1vdmUgaXQgdG8gcGh5bGlua19yZXN1bWUoKSB3ZSB3aWxsIGhhdmUgdG8NCnJlaW5pdGlh
bGl6ZSB0aGUgUEhZIHVuY29uZGl0aW9uYWxseSAoc2VlIGJlbG93KS4gV291bGQgdGhpcyBiZSBP
Sz8NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxNzA2MjMwMTA4MzcuMTEx
OTktMS1mLmZhaW5lbGxpQGdtYWlsLmNvbS8NCg0KPiANCj4gbWFjYl9zZXRfd29sKCkgc2V0cyBi
cC0+d29sJ3MgTUFDQl9XT0xfRU5BQkxFRCBmbGFnIGRlcGVuZGluZyBvbg0KPiB3aGV0aGVyIFdB
S0VfTUFHSUMgaXMgc2V0IGluIHdvbG9wdHMuIE5vIG90aGVyIHdvbG9wdHMgYXJlIHN1cHBvcnRl
ZC4NCj4gR2VuZXJpYyBjb2RlIHNldHMgbmV0ZGV2LT53b2xfZW5hYmxlZCBpZiBzZXRfd29sKCkg
d2FzIHN1Y2Nlc3NmdWwgYW5kDQo+IHdvbG9wdHMgaXMgbm9uemVybywgaW5kaWNhdGluZyB0aGF0
IFdvTCBpcyBlbmFibGVkLCBhbmQgdGh1cw0KPiBwaHlsaW5rX3N0b3AoKSB3b24ndCBiZSBjYWxs
ZWQgaWYgV29MIGlzIGVuYWJsZWQgKHNpbWlsYXIgdG8gd2hhdA0KPiBtYWNiX3N1c3BlbmQoKSBp
cyBkb2luZy4pDQo+IA0KPiBHaXZlbiB0aGF0IHRoZSBtYWNiIE1BQyBzZWVtcyB0byBiZSBpbXBs
ZW1lbnRpbmcgV29MLCBpdCBzaG91bGQgY2FsbA0KPiBwaHlsaW5rX3N1c3BlbmQoKSB3aXRoIG1h
Y193b2w9dHJ1ZS4NCg0KSW4gQVQ5MSBCU1IgKGJhY2t1cCBhbmQgc2VsZi1yZWZyZXNoKSBjb3Vs
ZCBjb2V4aXN0IHdpdGggb3RoZXIgUE0gbW9kZXMNCih0aGF0IGRvZXNuJ3QgY3V0IHBvd2VyKS4g
QW5kIHRoZXkgYXJlIG1hcHBlZCB0byBMaW51eCBzdGFuZGFyZCBQTSBzcGVjaWZpYw0KbW9kZXMu
IFNvLCB3aGVuZXZlciBvbmUgd291bGQgZXhlY3V0ZToNCmVjaG8gbWVtID4gL3N5cy9wb3dlci9z
dGF0ZSAjIG9yDQplY2hvIHN0YW5kYnkgPiAvc3lzL3Bvd2VyL3N0YXRlDQoNCkJTUiBvciBvdGhl
ciBQTSBtb2RlIGNvdWxkIGJlIGV4ZWN1dGVkLiBNQUNCIGRyaXZlciBjb3VsZCBrbm93IG9ubHkg
aWYNCnN5c3RlbSBnb2VzIHRvIG1lbSBMaW51eCBQTSBtb2RlIG9yIHN0YW5kYnkgTGludXggUE0g
bW9kZS4gQnV0IEJTUiBjb3VsZCBiZQ0KbWFwcGVkIGVpdGhlciB0byBtZW0gb3Igc3RhbmRieS4g
V2UgY2FuJ3QgZGVjaWRlIGZyb20gZHJpdmVyIGlmIHdlIGdvIHRvIEJTUi4NCg0KSW4gQlNSIHRo
ZXJlIGFyZSBtaW5pbXVtIHdha2V1cCBzb3VyY2VzIChzb21lIHJlc2VydmVkIHBpbnMgYW5kIFJU
QyBhbGFybSkuDQpUaGVyZSBpcyBubyB3YXkgdG8gcmVzdW1lIGZyb20gV29MLiBBcmNoIHNwZWNp
ZmljIFBNIGNvZGUgY291bGQgZGVjaWRlIHRvDQpub3QgZ28gdG8gQlNSIGlmIE1BQ0IgbWF5IHdh
a2V1cCB0aHVzIG9uIE1BQ0IgZHJpdmVyIHdlIGNvdWxkIGRlY2lkZSB0byBydW4NCnBoeWxpbmtf
c3VzcGVuZCgpL3BoeWxpbmtfcmVzdW1lKCkgYmFzZWQgb24gbm90IGhhdmluZyB0aGUgTUFDQiBk
cml2ZXINCmNvbmZpZ3VyZWQgYXMgYSB3YWtldXAgc291cmNlLiBCdXQgaXQgd2lsbCBub3QgbWVh
biBpbiBhbGwgY2FzZXMgdGhhdCB3ZSBnbw0KdG8gQlNSLiBBbmQgaW1wb3Npbmcgb24gYXJjaCBz
cGVjaWZpYyBjb2RlIHRvIG5vdCBnbyB0byBCU1IgaWYgTUFDQiBtYXkNCndha2V1cCBtYXkgYmUg
YSBwYWluIGZvciB1c2VycyAoaW4gY2FzZSB0aGV5IHN3aXRjaCBmcm9tIG9uZSBQTSBtb2RlIHRv
DQphbm90aGVyIGFzIHRoZXkgd2lsbCBuZWVkIHRvIHJlY29uZmlndXJlIHRoZSB3YWtldXAgc291
cmNlcyBldmVyeSB0aW1lKS4NCg0KSG9wZSBJIHdhcyBjbGVhci4NCg0KVGhhbmsgeW91IGZvciB5
b3VyIHJldmlldywNCkNsYXVkaXUgQmV6bmVhDQoNCj4gDQo+IFBsZWFzZSBjYW4geW91IGxvb2sg
aW50byB0aGlzLCB0aGFua3MuDQo+IA0KPiAtLQ0KPiBSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBz
Oi8vd3d3LmFybWxpbnV4Lm9yZy51ay9kZXZlbG9wZXIvcGF0Y2hlcy8NCj4gRlRUUCBpcyBoZXJl
ISA0ME1icHMgZG93biAxME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg0K
