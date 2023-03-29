Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395F86CD167
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 07:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjC2FGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 01:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2FGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 01:06:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8582D4D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 22:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680066398; x=1711602398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n4cUInkre8B0k3zIFRLCtbQN8e64d6aEgeXKbe8wh7Q=;
  b=SvUUWUehV1OqV299XVXKWfNEGH5KXuHwDmWvHbecWc+LWqCnFW6EO5aO
   chrOx0YN8oZPKFXp5gf+fLWomPE1Byh9jfNe025Nh+4/N8/w0vQQPBbQv
   LH8mpH5idSkpwvPoYhQndrfN3z5d8eCVjRyWB/HkWhAI4dihPbhltmgbN
   0YR+LG4hxKGBBEfmrpUAccFPWrQqFbxN5bL9bdsq4+Rhl2cwi2D0AxdEI
   CFmKuSwEKmyK1Dsdw/l8L3hPaag/la8TeN55L3ao+ffk613C9uJBNWPYx
   4rD/io4Q9ikLvL96+IIqrKhI1wCsO5GlqHmoLzv0eG/e12vtaXRM6P7F/
   w==;
X-IronPort-AV: E=Sophos;i="5.98,299,1673938800"; 
   d="scan'208";a="206798299"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2023 22:06:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 22:06:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 22:06:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gi8T8modaKSZN0OiCEog5OwhmdG5OoQjp1bPSGP9eZ1WhiNGOFTtoiOAWHaUFzwt9nf//FtGEzeIc5OotcVUcUbjfhjBqn4pwCo0DTzLEwBRMGNiiZe9zUnTYbHCdmCkeLbAMHmIvv+wkf2fYj/LaW4u3CQQAgFo0Xo+JJt0eBXrTtDxLNeu9e1zj3MKtxOVOnsk2GUBMtvW47w8SLQou7Chk2Z64sR3/MV390SmRXOq6Ej6UfgC/Vz+tYhhzzzrocl5+RaXRHtqd5et/LUaV53t2bzA16zlSxrPOYu3Ix89osUP3tSpJpFn8JN6SC3hpKKxsajN8nh4ZssX+ZtWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4cUInkre8B0k3zIFRLCtbQN8e64d6aEgeXKbe8wh7Q=;
 b=nh8xaS2rnvdDn3utb/0IznyGyUNGZ6clDv7ZqsVDYYlYRkTbhRdTbwzgWcxFgjBdl6l8DV2hptGv/WVWbrr4NTolW3RxoKIKQarXQ6s+hN8JZ2QB3k1vzB01ACXY31j2ChEg1Lj+pISrLX1xLhdgBUPkvlTsJEB7s/VxYlZ1tRz7LabUTsb2ytwHuImEXTDi7dQUSKE+DbB/CVOzdWB/pZv04sbUhFAOJlfuSai7DyeG9CU8WsOpdeG7stA2vhbq8CC599PhDdFDxzu+K7sqSMnnAquOrcEvFEXiwskzExqpkahvMm90k+6lYWfXxi2aKLgYTuDyINsvrdW6bM6CMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4cUInkre8B0k3zIFRLCtbQN8e64d6aEgeXKbe8wh7Q=;
 b=ObbQu0YXEPIh38txwgMhWyCI1epZRW6Q9z/DJ8Z7+vw0bff4dopG9HkI3COooEvILHf4ESurcTOCJ0mJD/iqHQuwWfVzZo+tHHcRFpQEWPL0WqEnw43rfrMgc6xTNyvyp1BGkIS6rYmenJMfw3hS6FFHF9/kXyy2t/NNlyFtY38=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DM4PR11MB6429.namprd11.prod.outlook.com (2603:10b6:8:b5::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Wed, 29 Mar 2023 05:06:34 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::3b71:50e4:3319:f0af]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::3b71:50e4:3319:f0af%7]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 05:06:34 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <andrew@lunn.ch>, <Allan.Nielsen@microchip.com>
CC:     <netdev@vger.kernel.org>, <Jan.Huber@microchip.com>,
        <Thorsten.Kummermehr@microchip.com>
Subject: Re: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver support
 to Linux
Thread-Topic: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver
 support to Linux
Thread-Index: AQHZU0FVDvLBk51tqEaNUDKyKbSOCq712+WAgBt1/4A=
Date:   Wed, 29 Mar 2023 05:06:33 +0000
Message-ID: <7b30e468-e32c-cba7-8ec1-00477194ad33@microchip.com>
References: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
 <76afad2d-33ab-4bfa-baf9-2f7a0a4aa134@lunn.ch>
In-Reply-To: <76afad2d-33ab-4bfa-baf9-2f7a0a4aa134@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|DM4PR11MB6429:EE_
x-ms-office365-filtering-correlation-id: 544966ec-97b9-405d-b7ec-08db30135dcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ruLx9UdG7J4iU/xTOHPxe6cYTyOuJi2Hov3N3PNbYAl6yMN8+rhBgHtbJd7imIx/3zsPkj9Nz0GHK89hLpaGY6tzGPUPSXFVS22FYkWetofYKmMNgdYYQpcu/WAIY+6JHgk88FZwSB6YXXdOQ38I/fvpx15BuKi85QDzl/5J2c34NomcVoMReVmyhxZR88lWY+0KTvOIyUZQMHfC2ZsfpTu/102Z3OhxIoUBh/KJyyWzEk+EliXRHxu7zRpItCzAKFEheMVb1KOVNCm0lppnSk4689jjwUbYNBM5ylrZ+XFikfi+2NY389O1icYeDBkq52N7NSTOWo9zy+nwqckFhLgVkwjCD0qwqHWqAl4fMI0iu+wFFGC48oPECCWK7QjvCjdJHgtZZSsuEx/mXaxWitm3PfkNf1VcBE2x0bxEXBuvNpImwcUjPnSSUkOMCqyE1uCwFkeQStRJBDbiLJOlGuufdnV4cFuCQkKodJ5aOV+B0cjFv3pKGFchgpRdQozau7Z/7B32oMyHTMWVia71C6QFx7M7Mmkq17mHmfXGspSCGdj2oN7oi9y/JHJ7NPbbHMLI0O58Hp2eULsSG3rHeknhGtmC/Ky6GCHqEVY9QuQLTWyUhJHP+KsI9szLdW0iJ4pE80btkTEI0AuQLjRZbJKyesnmwJGfIoJtAr+CURk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199021)(76116006)(66899021)(66476007)(64756008)(8936002)(91956017)(316002)(8676002)(4326008)(31686004)(38100700002)(31696002)(66946007)(38070700005)(966005)(66556008)(6512007)(2906002)(83380400001)(86362001)(36756003)(66446008)(478600001)(5660300002)(53546011)(186003)(54906003)(6636002)(110136005)(107886003)(41300700001)(122000001)(71200400001)(6506007)(26005)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzZRRXMzUFpuMFNXY3dXN1k0MFliRFVQTFM4Z0djTWJ4UTNwZWkweml0ci93?=
 =?utf-8?B?U0RYaHVES2tpZ0FFTVN5QmFlWUFNVUtDMENrZ1ZPZ2tKNDV2SXZBZWt3Smoy?=
 =?utf-8?B?RFRFNzFZYWZlT3FrbkM5SGNmNkl4TnN2RmowSzE5N003dnFyQWw0ZnlCRjJ0?=
 =?utf-8?B?U1RSR1hkL0FkOHZwYUkycWpxSjdXTWk2ZlNqeS8yUHBsVGNBZVdReUFzZ1Ri?=
 =?utf-8?B?VW12Vy9BSjZiU2gvaEVpN1l6YkhOZVFzUWVPUHc2ZWh2S0xOTzVxK0ZHMWgr?=
 =?utf-8?B?YXNuSXliMEpGL2FVWkpQUTNuZktDOUN6OTlGaWZsazJwSGRkU0ozSmgwQk1M?=
 =?utf-8?B?bmZhcU16Y09wZ09WZXg0MzROUlFmSjFKa3VrT0p2T09XMnBHVzVTUzYxdkhL?=
 =?utf-8?B?YzhqU0o1M3lSNjRRUk42SzNNWTFRaE5oZDFLMUFJZlVLSkpBZ05YWHRxbHZW?=
 =?utf-8?B?MjIwRi9BblozVk1kVzlMeDErOVNVOTBmeldxQ2J1TGFWbTN2Wi9xMFJ5MVhC?=
 =?utf-8?B?VnZ1YnZQQlVRUmRKRlhrZVpMOVhrZTA5cHpZeDRCeHdkc1k1dHhmSEtDRCth?=
 =?utf-8?B?a3QvSmx1VHZmT3JKb2NLM0tTdFR1OHpBVWtNYXZvY0wzS0tQUUJZREpOSmRC?=
 =?utf-8?B?dktiWnhtcW82RDdad0NOTHBNVEZEUG5oM0xYMUpkUlJHU1R1ZVpBa2FxZmZV?=
 =?utf-8?B?OXZEUkhPT0N6ZmVUMkx4YktzT3NUQ2hmTHRaUjBrVEVwT0s1ckhhWVJuVFFZ?=
 =?utf-8?B?cU00djVZV0pHQnVKdUcyMFUralRVcU1YSUVKNVhaWWUzK3JUdjNYWndIeldG?=
 =?utf-8?B?WFZNdFJyUWsyNkNyZXBWTnNocUVjV09JZE92K3hiZ0tmVnI0UElKZHpXZTJp?=
 =?utf-8?B?aEpIdEZIenpJQmRUTDBmYVBiSzhKUkNUdGpmYmhpa0lYZUFKMHkvL0MwNE02?=
 =?utf-8?B?ZXR6eXkyd0xFMWVEM2tZV0JXclZMYkl2WkFuRldabjRHRlYvTGFUVHN2cXpy?=
 =?utf-8?B?b1Z1eDRIVWZGQklYT0gyNlc1UVFmN1hvUmVkSnc4N09NVFRFUmtnbktiYVZR?=
 =?utf-8?B?ZFcxNW92azFWZ3NtN2xZNkhFeVJNL3JuZVZkSExybTh1SlFtWGJGYnBPYnhD?=
 =?utf-8?B?enhRTnE5SEJnRnF0Tk5EQ3dNN3JHVDdubVNpeFJCMHREVm82NUNqL09yakxV?=
 =?utf-8?B?OVhJc3hTdGdNejJNQ0RpRFBFdXkzWnFvMGdmVkN0ZG01b0tVZjdXMk5XYWZr?=
 =?utf-8?B?VXoyS1QxZ1VpRnZzaEtNcjRwRm9USks0RnZJeUJIczM1TDFkMzNqVnVNUzdQ?=
 =?utf-8?B?YUpHdlF2SExwdDhZemxnelUwSjE4NnhhT01aSEJUUDNxbnVDMysrVnRsRDRZ?=
 =?utf-8?B?UWhqU3BmQnlweUhmOVh3cVhqTmN1eTMrcUxvSXJSYnV5ZWs2Wis3b0Y4MEpt?=
 =?utf-8?B?aHBXZmg5TnVBdmNaTCtPbFROb0U4U0Y1bnlSanl0RXlCeG0wcm4xUHdLSDZQ?=
 =?utf-8?B?c3pBNWNoZFVEWHNXbWRRcGFvbVhEMnpWUHk0THFXUWtrNmdSNzNsQkxldlZW?=
 =?utf-8?B?cm9GM2E4bkFidWZDcmM1dUVPQ3RhQklyVzZzaVN6ZitpVUtjZ0ZiNWJ1RVA2?=
 =?utf-8?B?OFcyUDkrUThFWFZOZ2hyKy94ZHA4VHREVjZMV2dzRk5sa1puYVNkK2ZLZHI4?=
 =?utf-8?B?SUtQcUEzOWM2MlY0MmZtRkFFdm01eldkajV1VEE2eHBWZkpSOVorRWJ6dGgv?=
 =?utf-8?B?QWFlb1ZOYXFjZE8rdS9KNEpkYUJTNFF1MmFoMk9SeTlqNlNjeVd2bnNENzRH?=
 =?utf-8?B?aGFDZjNLWXFFc2VaZTgwOVdrMjFqb3pZblJrdERpei9VK0k2cjM1OGRVckZh?=
 =?utf-8?B?UnhFUDdJaHk0SVBwai9yalZZOHFNeTBUeitVSUpkbFpLODY5Wjc4RnUxRzNq?=
 =?utf-8?B?WHpxZ0xLaE9ORk1wMjVNYlhHOVZFZm85NFYxb3k5NXVDZDFPSlhlYXgzRVpX?=
 =?utf-8?B?V05RZTRlamRWRXZyUk02K1NOaS95ekoyeDlYZzh2Z0N5NElnQlF4VTFsL1pX?=
 =?utf-8?B?aWNoQzUzOUk3UlZNQWRMbjFHVGFGdjY4a21kRHdhMXY2YlRZWG5xQWRKcmFY?=
 =?utf-8?B?aVpvRVpQUTlVL3kvdmc4dGV6b0tPWTZMeWQraXNLMi8xb3MwR1ZwMTE4ejZa?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EC061F53299924096D346AF981EECB9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544966ec-97b9-405d-b7ec-08db30135dcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 05:06:33.9094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1aJj0Gh2AxDTgfeEOIl68y+6wbzqhoOqHyITDrGMwccXQNTs0Z3EBreqfMGYSx9AY0QFNep3mqa8ZnmRxnRIVuSXg7Cgp0fa9EbkopzMDEWfBPWiNhLW4KilcKqsPVf/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6429
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFua3MgYSBsb3QgZm9yIHlvdXIgc3VwcG9ydC4gSSB3aWxsIGNoZWNr
IHdpdGggb3VyIGNvbGxlYWd1ZXMgDQpzdWdnZXN0ZWQgYnkgeW91IGFuZCBnZXQgYmFjayB0byBt
YWlubGluZSBhZ2Fpbi4NCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCk9uIDExLzAzLzIz
IDExOjE1IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBj
bGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlDQo+IA0KPiBIaSBBbGxhbg0KPiANCj4gSXQgaGFzIGJlZW4gYSBsb25nIHRpbWUg
c2luY2Ugd2UgdGFsa2VkLCBtYXliZSAyMDE5IGF0IHRoZSBMaW51eA0KPiBQbHVtYmVycyBjb25m
ZXJlbmNlLi4uLiBBbmQgdGhlbiBQVFAgZGlzY3Vzc2lvbnMgZXRjLg0KPiANCj4gSXQgc2VlbXMg
bGlrZSBTcGFyeDUgaXMgZ29pbmcgd2VsbCwgYWxvbmcgd2l0aCBmZWxpeCwgc2V2aWxsZSwgZXRj
Lg0KPiANCj4gT24gRnJpLCBNYXIgMTAsIDIwMjMgYXQgMTE6MTM6MjNBTSArMDAwMCwgUGFydGhp
YmFuLlZlZXJhc29vcmFuQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+PiBIaSBBbGwsDQo+Pg0KPj4g
SSB3b3VsZCBsaWtlIHRvIGFkZCBNaWNyb2NoaXAncyBMQU44NjV4IDEwQkFTRS1UMVMgTUFDLVBI
WSBkcml2ZXINCj4+IHN1cHBvcnQgdG8gTGludXgga2VybmVsLg0KPj4gKFByb2R1Y3QgbGluazog
aHR0cHM6Ly93d3cubWljcm9jaGlwLmNvbS9lbi11cy9wcm9kdWN0L0xBTjg2NTApDQo+Pg0KPj4g
VGhlIExBTjg2NTAgY29tYmluZXMgYSBNZWRpYSBBY2Nlc3MgQ29udHJvbGxlciAoTUFDKSBhbmQg
YW4gRXRoZXJuZXQgUEhZDQo+PiB0byBhY2Nlc3MgMTBCQVNF4oCRVDFTIG5ldHdvcmtzLiBUaGUg
Y29tbW9uIHN0YW5kYXJkIFNlcmlhbCBQZXJpcGhlcmFsDQo+PiBJbnRlcmZhY2UgKFNQSSkgaXMg
dXNlZCBzbyB0aGF0IHRoZSB0cmFuc2ZlciBvZiBFdGhlcm5ldCBwYWNrZXRzIGFuZA0KPj4gTEFO
ODY1MCBjb250cm9sL3N0YXR1cyBjb21tYW5kcyBhcmUgcGVyZm9ybWVkIG92ZXIgYSBzaW5nbGUs
IHNlcmlhbA0KPj4gaW50ZXJmYWNlLg0KPj4NCj4+IEV0aGVybmV0IHBhY2tldHMgYXJlIHNlZ21l
bnRlZCBhbmQgdHJhbnNmZXJyZWQgb3ZlciB0aGUgc2VyaWFsIGludGVyZmFjZQ0KPj4gYWNjb3Jk
aW5nIHRvIHRoZSBPUEVOIEFsbGlhbmNlIDEwQkFTReKAkVQxeCBNQUPigJFQSFkgU2VyaWFsIElu
dGVyZmFjZQ0KPj4gc3BlY2lmaWNhdGlvbiBkZXNpZ25lZCBieSBUQzYuDQo+PiAobGluazogaHR0
cHM6Ly93d3cub3BlbnNpZy5vcmcvQXV0b21vdGl2ZS1FdGhlcm5ldC1TcGVjaWZpY2F0aW9ucy8p
DQo+PiBUaGUgc2VyaWFsIGludGVyZmFjZSBwcm90b2NvbCBjYW4gc2ltdWx0YW5lb3VzbHkgdHJh
bnNmZXIgYm90aCB0cmFuc21pdA0KPj4gYW5kIHJlY2VpdmUgcGFja2V0cyBiZXR3ZWVuIHRoZSBo
b3N0IGFuZCB0aGUgTEFOODY1MC4NCj4+DQo+PiBCYXNpY2FsbHkgdGhlIGRyaXZlciBjb21wcmlz
ZXMgb2YgdHdvIHBhcnRzLiBPbmUgcGFydCBpcyB0byBpbnRlcmZhY2UNCj4+IHdpdGggbmV0d29y
a2luZyBzdWJzeXN0ZW0gYW5kIFNQSSBzdWJzeXN0ZW0uIFRoZSBvdGhlciBwYXJ0IGlzIGEgVEM2
DQo+PiBzdGF0ZSBtYWNoaW5lIHdoaWNoIGltcGxlbWVudHMgdGhlIEV0aGVybmV0IHBhY2tldHMg
c2VnbWVudGF0aW9uDQo+PiBhY2NvcmRpbmcgdG8gT1BFTiBBbGxpYW5jZSAxMEJBU0XigJFUMXgg
TUFD4oCRUEhZIFNlcmlhbCBJbnRlcmZhY2UNCj4+IHNwZWNpZmljYXRpb24uDQo+Pg0KPj4gVGhl
IGlkZWEgYmVoaW5kIHRoZSBUQzYgc3RhdGUgbWFjaGluZSBpbXBsZW1lbnRhdGlvbiBpcyB0byBt
YWtlIGl0IGFzIGENCj4+IGdlbmVyaWMgbGlicmFyeSBhbmQgcGxhdGZvcm0gaW5kZXBlbmRlbnQu
IEEgc2V0IG9mIEFQSSdzIHByb3ZpZGVkIGJ5DQo+PiB0aGlzIFRDNiBzdGF0ZSBtYWNoaW5lIGxp
YnJhcnkgY2FuIGJlIHVzZWQgYnkgdGhlIDEwQkFTRS1UMXggTUFDLVBIWQ0KPj4gZHJpdmVycyB0
byBzZWdtZW50IHRoZSBFdGhlcm5ldCBwYWNrZXRzIGFjY29yZGluZyB0byB0aGUgT1BFTiBBbGxp
YW5jZQ0KPj4gMTBCQVNF4oCRVDF4IE1BQ+KAkVBIWSBTZXJpYWwgSW50ZXJmYWNlIHNwZWNpZmlj
YXRpb24uDQo+Pg0KPj4gV2l0aCB0aGUgYWJvdmUgaW5mb3JtYXRpb24sIGtpbmRseSBwcm92aWRl
IHlvdXIgdmFsdWFibGUgZmVlZGJhY2sgb24gbXkNCj4+IGJlbG93IHF1ZXJpZXMuDQo+Pg0KPj4g
Q2FuIHdlIGtlZXAgdGhpcyBUQzYgc3RhdGUgbWFjaGluZSB3aXRoaW4gdGhlIExBTjg2NXggZHJp
dmVyIG9yIGFzIGENCj4+IHNlcGFyYXRlIGdlbmVyaWMgbGlicmFyeSBhY2Nlc3NpYmxlIGZvciBv
dGhlciAxMEJBU0UtVDF4IE1BQy1QSFkgZHJpdmVycw0KPj4gYXMgd2VsbD8NCj4+DQo+PiBJZiB5
b3UgcmVjb21tZW5kIHRvIGhhdmUgdGhhdCBhcyBhIHNlcGFyYXRlIGdlbmVyaWMgbGlicmFyeSB0
aGVuIGNvdWxkDQo+PiB5b3UgcGxlYXNlIGFkdmljZSBvbiB3aGF0IGlzIHRoZSBiZXN0IHdheSB0
byBkbyB0aGF0IGluIGtlcm5lbD8NCj4gDQo+IE1pY3JvY2hpcCBpcyBnZXR0aW5nIG1vcmUgYW5k
IG1vcmUgaW52b2x2ZWQgaW4gbWFpbmxpbmUuIEpha3ViDQo+IHB1Ymxpc2hlcyBzb21lIGRldmVs
b3BlcnMgc3RhdGlzdGljcyBmb3IgbmV0ZGV2Og0KPiANCj4gaHR0cHM6Ly9sd24ubmV0L0FydGlj
bGVzLzkxODAwNy8NCj4gDQo+IEl0IHNob3dzIE1pY3JvY2hpcCBhcmUgbmVhciB0aGUgdG9wIGZv
ciBjb2RlIGNvbnRyaWJ1dGlvbnMuIFdoaWNoIGlzDQo+IGdyZWF0LiBIb3dldmVyLCBhcyBhIHJl
dmlld2VyLCBpIHNlZSB0aGUgcXVhbGl0eSByZWFsbHkgdmFyaWVzLiBHaXZlbg0KPiBob3cgYWN0
aXZlIE1pY3JvY2hpcCBpcyB3aXRoaW4gTGludXgsIHRoZSBuZXRkZXYgY29tbXVuaXR5LCBhbmQg
dG8NCj4gc29tZSBleHRlbnQgTGludXggYXMgYSB3aG9sZSwgZXhwZWN0cyBhIGNvbXBhbnkgbGlr
ZSBNaWNyb2NoaXAgdG8NCj4gYnVpbGQgdXAgaXRzIGludGVybmFsIHJlc291cmNlcyB0byBvZmZl
ciB0cmFpbmluZyBhbmQgTWVudG9yaW5nIHRvDQo+IG1haW5saW5lIGRldmVsb3BlcnMsIHJhdGhl
ciB0aGFuIGV4cGVjdCB0aGUgY29tbXVuaXR5IHRvIGRvIHRoYXQNCj4gd29yay4gRG9lcyBzdWNo
IGEgdGhpbmcgZXhpc3Qgd2l0aGluIE1pY3JvY2hpcD8gQ291bGQgeW91IHBvaW50DQo+IFBhcnRo
aWJhbiB0b3dhcmRzIGEgbWVudG9yIHdobyBjYW4gaGVscCBndWlkZSB0aGUgd29yayBhZGRpbmcg
Z2VuZXJpYw0KPiBzdXBwb3J0IGZvciB0aGUgT1BFTiBBbGxpYW5jZSAxMEJBU0UtVDF4IE1BQy1Q
SFkgU2VyaWFsIEludGVyZmFjZSBhbmQNCj4gdGhlIExBTjg2NTAvMSBzcGVjaWZpYyBiaXRzPyBJ
ZiBub3QsIGNvdWxkIFN0ZWVuIEhlZ2VsdW5kIG9yIEhvcmF0aXUNCj4gVnVsdHVyIG1ha2Ugc29t
ZSB0aW1lIGF2YWlsYWJsZSB0byBiZSBhIG1lbnRvcj8NCj4gDQo+IFRoYW5rcw0KPiAgICAgICAg
ICBBbmRyZXcNCg0K
