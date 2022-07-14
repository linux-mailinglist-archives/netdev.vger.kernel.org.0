Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD95754C8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbiGNSRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiGNSRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:17:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00326870E
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:17:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dst/Q86jkkAHUjDegbuQlyenMS1VMoFuNMxYouYm7RBXDgfSAKsXxm66DZvD/yIH5yNEq18MUe2q9zpF7MVp0VDUKPyqWaC1GkvPnu7JcqHmUK9j2L5xlxIdsQfQ1mDOkykx0gWiFT+UM6MhjKiR0R1KCbMPl87iR/DlOO1tuh6q2dH984oGP0IsM/M3rNjLO6jk+LIuD241Kl5e8DhPENaNdc6HVf8FSkJK3n2GSJyYzwtYMjhLaOULR9F6fhz7XFDJCIZN7SBI/23em4Yep/JsWjfT2JZoZ1OT4mVyrX4oIxv4SYrJV5sdlqLviRTIJgjoinXQxZ4p1pFu54ntng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZS9obCe/R5wMW2yFkGEN4+9zOTyEmuFYk9NepyXEFLE=;
 b=Y6m3ncatK9hua4m82QblkLu5U1aSmvYOudEJN5qxTp9Khs3c7Jc64qzgNAlkLZwvn513ck0n6HwQcAuvu0qb+DXsiGokUsxI+oRDXyCqVucWcorkfUidbJ4R9tMOe7QJ4NpYB7kuhYeuIacxXR+nkRjbfCE2bc4gwARr3uGJriyLS32bdK66+27WM686pknECIyVBo1AJLO8zpGtiWQheuE79SnDVNuYKQqj9Twk2ws8RZP0e7ig+1WUe9fQkBhZ/ilIws1bYN9UdEO3xCcvav0LggNE1mohq0jj8cSHN2XIptKRALfi1jpZKZ3joaEBypmohhIulLKFwubQ0o/9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS9obCe/R5wMW2yFkGEN4+9zOTyEmuFYk9NepyXEFLE=;
 b=ef9t9eiX1TA11YbOZLJcur6ryKRmDWmOs6sAHbrJlNK1o9iUDZ6VD1l9aP3V+15YjqeFCj5JWv/BaMcqQNqBAzxA3OQ/ypRZM0XakgHF5j/z3dkKL2ARDTssKSCE4lwgx9YjH6gATwYtIuQM7ObHUveFl/bqG9yb3c1w+4oGX4o=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by DM6PR10MB3788.namprd10.prod.outlook.com (2603:10b6:5:1f7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 14 Jul
 2022 18:17:41 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe%9]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 18:17:41 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: network driver takedown at reboof -f ?
Thread-Topic: network driver takedown at reboof -f ?
Thread-Index: AQHYl40Svy5jf8uV0UGBbesFglmmI6199V2AgAAmUICAAALVgIAADmUA
Date:   Thu, 14 Jul 2022 18:17:41 +0000
Message-ID: <d8f42b945cb649036ed609df33dd3514cb51e0e1.camel@infinera.com>
References: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
         <191adc26-28d3-758a-7c9a-53e71a62b0fa@gmail.com>
         <5156c006ee7c362ef26b2ad28eea2196c847a106.camel@infinera.com>
         <0893c6fa-84f7-887d-784b-f27abf8868c6@gmail.com>
In-Reply-To: <0893c6fa-84f7-887d-784b-f27abf8868c6@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33cb89e-98b5-41fd-c429-08da65c52400
x-ms-traffictypediagnostic: DM6PR10MB3788:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qpRXtoOsW25KAowLuHbaV/Yb3sqGZT6aiodeQI9syx2qYL3/SsBSDf7RQflSfMWbSJGny6U/KWVRE0pfYujLL0qScqY+89vp7ZelccH7MlNvK2Ju0WpEgTCbYbwqZJr+/E8Cjl4FxARnmQhUoc7V6WHfwBo/WlhtNK8sFR+q99bZJnwEEJKt+DNpDDrxLHJpAtFYwAHqkc4cHoPlpnQqRIUMgkXXy0Ote7F20TptF12DIgMKH3EUJiQYP/thostaynGpP2mGTyS1S4Ujqtend983q7kPe4te3/pfJIn93tS62s/ySbLZZVKqGBVqLZ6twY/KijjnLzgdM31LaxTgX6P4q1Go0A22BvhWDKfCByPowRVH279wI0j13iLNRr3R+IvU241phjiS8gHYtgtag7Ay4cd4hqDlxfizMLIPm/iaLneE80KWYkjw5HGalFfHHLYt6BEicdhahk0TWnDzaNlrax2moh3Damje6sUCEAyRo1IZO71hIIjVzcJVByZprZlOI/dreE8rz1UmM8oNkkqmdsMFyzaD7Zt0Thr5LzMQN8c5TJXoSFo8AJrgy43fbtiNYJh34k8+4nKG9x3Z+FzGoWKtF9lLnXZGgPUVFDuetwj+Tw2fjsRDa3ltvxrbhbvIn3sfQzLo+tAzpenOeSnx7hHqNXAk/Sg8fPIgYBLMGj9ZoRLN4gU6Uax+EMA3UO6h/ui+tV99Y+QpbeLoe6c15PX1ah+ObGUfMQJl9p0cNJhZhWaWdE5g1dAOQ96N29qDmN0LVFTQ858N8EmTtjmyG+ILwG2oULedzzGt1+t8uMnyrb7Sdwir8cDaJeLlTkg7Xa2VDh+iHDNMjQ/B1vBinhNJBFfMVX4TSck3mIE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(71200400001)(2906002)(110136005)(53546011)(86362001)(41300700001)(64756008)(966005)(6486002)(6512007)(5660300002)(76116006)(8936002)(8676002)(66446008)(45080400002)(316002)(26005)(186003)(36756003)(122000001)(66556008)(478600001)(38100700002)(2616005)(91956017)(83380400001)(66946007)(6506007)(38070700005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTZBMG9ZTDdONlJOcTJKdlN1Rk5rTUpvbDQwMFNXN3BxWGVaWVVqdlhvSEw4?=
 =?utf-8?B?K2plaEErRHFEc3VKaFBsemZOa24vL1hjMkx0WDZ2bGVsZWoyWnFmOXhJNW14?=
 =?utf-8?B?Z3BYUlB2aWMwMVZRUHdRTFpGYUtvYzNIQ2Q3ZmhSNnN0cFhHcEZRL2RjNDYw?=
 =?utf-8?B?WjVjcEpQUUlQbnhYV3VKckNBdjJLdm5wN085clh2SnRqOTJrWUZDbnRFdkVz?=
 =?utf-8?B?YmJJV0JFeHBERVJCOFUrQ29ITHorRzBKZGxwbnRrdUFGeDVPamhBMjE2WEZJ?=
 =?utf-8?B?dFZPV0dBTDBFT0ZVVm5xL1p0Q3M3RzQ4WnBPNysxTlNDdWZkRS9zTkZEK2dO?=
 =?utf-8?B?bVIyaE4vc1BSQWlVb0NnZVpoWEVSUVRCTldUR2kzeWNBNTdEMmFXaTB6cjdN?=
 =?utf-8?B?aGlnSHQzM1ZLdDNqb1orOUtJMTVwSjlLWWIxdEVMUTU5aEhVd0xrZUpEYVRX?=
 =?utf-8?B?TjN5Vm9reC9pWDNtbEF2dmplQU5tTTU4N2FMc1ladHRYM2FaVVdFd3dXeXhE?=
 =?utf-8?B?Qjhna0NGYTExcGc0dDZIZnU4WDVSaENFVWJaWlN5YUlLSTlZdVA4NStuL1RB?=
 =?utf-8?B?a2l4R3Q2RUswRFF6UWxSTE94SHZYV1N3bERBYkVZdjlxQmxXaGI3U3puQmFT?=
 =?utf-8?B?TW1mQUlVeEM3Y0o3cFNHVG1WMG50ZjkxaEVwU0lCbWQ4bE9lTzBJMExya1JQ?=
 =?utf-8?B?MHJIRnlFUDlrNXFmRjVuZWhsdkErb29DamlkT2ZKMjExaitKbkVKNmpYa2Fn?=
 =?utf-8?B?YzZ2My8ySFluWW9yQnhJMzFpekZCSFBVdXQvM1VmNVROVm1XcEh6cUhQc1Ey?=
 =?utf-8?B?MmZwWHdtbkdnczlZeFBRK1JVVGk5RGVSdDFwWUk1Yi9FdmxYQTU1amFlT2pH?=
 =?utf-8?B?V3pjMHlZMnRXaGJUSjdMeFBPTWh6ZklaK2pxRExQcUkrL2dheEFWNGdGMlla?=
 =?utf-8?B?UW1IL1NrenhHU1ZCamp3V1FVL2VkajducXIxRWp0cTc1Y1FtYkE3V3NLY2dO?=
 =?utf-8?B?SE1rcEFFWi9lNWxwanFzWXova0lYbGVDQXk0emJobXFqKzBJK2w0RFdtOVhK?=
 =?utf-8?B?T1BuTXBGRXgwQk1wdlpTS0RUL2cwekoycWtyY1FhdXRscW9RQnRLdEQ5SVVo?=
 =?utf-8?B?SVc5MUgrcEZQTForbkR5dzB6YjlzMGp3bE40bWMvSkMxN2p3ME15TURua0pQ?=
 =?utf-8?B?bUh0ZlFsMGVFSFdqTDJydEMzV3BhU3JzMG0waHVzY0s1amgvZ3hqMGFaMGxr?=
 =?utf-8?B?LzlDWE5xVHlPVnIvYVUrUFY5NDU3c2JkNno1dnYvR3UzbnBWNmNTMjJPejFk?=
 =?utf-8?B?USswa1Y5WjBwU0xpWlZlNmt4VWZQRkxaNjM3MWx1dDFoOThycUROVGlZRlMr?=
 =?utf-8?B?YUdNZ3ZCKzA3MVlpQXh2Tm1OSzlDTy9iYVdtaEJqdlBvSytEaHV2MjY2MndX?=
 =?utf-8?B?K2ZIaGEwaE5uSDRGZ0hyWHdLOFJUV205SGFZUkw4TXk0WFdUTHA4dFY1OS9a?=
 =?utf-8?B?QUNkTmNRUDhkd3pPQjRzeXdBQStFZWVyckQ3aEZuQjVtK3QxWmJWVms2UWV5?=
 =?utf-8?B?Rno3VVpMREJuajFxakJmZmZJZzdUeTAxdURFeFA4Z3htcUxWWXMvNUVKZnEv?=
 =?utf-8?B?QlYxTDRQRW1sZW5QWFFIaVNUYXlsYWFjZzROUUMyeHpINnY5M0FzT3lqOFRG?=
 =?utf-8?B?c3d6UGp0Z2s1MVlncXVHWjFlT0VMOFBSazRaVHNtaXVKUWNjNU5yb0FzTEZD?=
 =?utf-8?B?a0NwS1BRejgvWDhrNGxkL0dCRU13N25vWUFUSUlTdHVFSCsyV29raUIvOVAx?=
 =?utf-8?B?NnVvYXRHa2g5UVhRd2lpeWhjQTFmNlRGY2FFaUhNaEZReTRPcVdpazlXZFp6?=
 =?utf-8?B?NzVwZW1yYTRjZUlKWlBRdm5lRWVjUFFVblBHT1ZBaEY0REpISkRlb0h6Wlh4?=
 =?utf-8?B?bEZkbG5RS05IRjBRZ05kRlMvbCtSdTIxaTdBSTdmOXozMTBsc1VxOC85NnRQ?=
 =?utf-8?B?S2VmMTNxQXNLUFp6cCt1M253ck1ibVJIMXczdDVvcHBibTV2TW8rRnE4ZjZE?=
 =?utf-8?B?a1VlSXRrSWg2cWJPb2s5OTRUaDdSa2pwZkR3WDNRUkFqSFN3QkJtek8zaVZH?=
 =?utf-8?Q?SAJYf9r5XMlI8iycO+YOPfq8A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F82668FAA7F0A47A7E54DF0D99A7C0C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33cb89e-98b5-41fd-c429-08da65c52400
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 18:17:41.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bH2Rw0dTHwITJs/O8xfcwVb11BziWxHimplVY7IDLMzjSFZ/PWLM/9oOJCmp01/lqnQZeGgXKwsccRmw7hlwcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3788
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTE0IGF0IDEwOjI2IC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiBPbiA3LzE0LzIyIDEwOjE2LCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMi0wNy0xNCBhdCAwNzo1OCAtMDcwMCwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4g
PiA+IA0KPiA+ID4gT24gNy8xNC8yMDIyIDc6MjEgQU0sIEpvYWtpbSBUamVybmx1bmQgd3JvdGU6
DQo+ID4gPiA+IERvaW5nIGEgZmFzdCByZWJvb3QgLWYgSSBub3RpY2UgdGhhdCB0aGUgZXRoZXJu
ZXQgSS9GcyBhcmUgTk9UIHNodXRkb3duL3N0b3BwZWQuDQo+ID4gPiA+IElzIHRoaXMgZXhwZWN0
ZWQ/IEkgc29ydCBvZiBleHBlY3RlZCBrZXJuZWwgdG8gZG8gaWZjb25maWcgZG93biBhdXRvbWF0
aWNhbGx5Lg0KPiA+ID4gPiANCj4gPiA+ID4gSXMgdGhlcmUgc29tZSBmdW5jdGlvbiBpbiBuZXRk
ZXYgSSBjYW4gaG9vayBpbnRvIHRvIG1ha2UgcmVib290IHNodXRkb3duIG15IGV0aCBJL0ZzPw0K
PiA+ID4gDQo+ID4gPiBJZiB5b3Ugd2FudCB0aGF0IHRvIGhhcHBlbiB5b3UgdHlwaWNhbGx5IGhh
dmUgdG8gaW1wbGVtZW50IGEgLT5zaHV0ZG93bg0KPiA+ID4gY2FsbGJhY2sgaW4geW91ciBuZXR3
b3JrIGRyaXZlciByZWdpc3RlcmVkIHZpYSBwbGF0Zm9ybS9wY2kvYnVzLCBpZg0KPiA+ID4gbm90
aGluZyBlbHNlIHRvIHR1cm4gb2ZmIGFsbCBETUFzIGFuZCBwcmV2ZW50LCBlLmcuOiBhIGtleGVj
J2Qga2VybmVsIHRvDQo+ID4gPiBiZSBjb3JydXB0ZWQgYnkgYSB3aWxkIERNQSBlbmdpbmUgc3Rp
bGwgcnVubmluZy4NCj4gPiA+IA0KPiA+ID4gVGhlcmUgaXMgbm8gZ2VuZXJpYyBwcm92aXNpb24g
aW4gdGhlIG5ldHdvcmsgc3RhY2sgdG8gZGVhbCB3aXRoIHRob3NlIGNhc2VzLg0KPiA+ID4gDQo+
ID4gPiBodHRwczovL25hbTExLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9
aHR0cHMlM0ElMkYlMkZnaXQua2VybmVsLm9yZyUyRnB1YiUyRnNjbSUyRmxpbnV4JTJGa2VybmVs
JTJGZ2l0JTJGdG9ydmFsZHMlMkZsaW51eC5naXQlMkZjb21taXQlMkYlM0ZpZCUzRGQ5ZjQ1YWI5
ZTY3MTE2NjAwNGI3NTQyN2YxMDM4OWUxZjcwY2ZjMzAmYW1wO2RhdGE9MDUlN0MwMSU3Q0pvYWtp
bS5UamVybmx1bmQlNDBpbmZpbmVyYS5jb20lN0NjZTk0MDZmNjg1Nzc0ZWU1ZWQzMzA4ZGE2NWJk
ZjMxYyU3QzI4NTY0M2RlNWY1YjRiMDNhMTUzMGFlMmRjOGFhZjc3JTdDMSU3QzAlN0M2Mzc5MzQx
NjM3NzEzMjU5NDAlN0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlM
Q0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3QyU3
QyU3QyZhbXA7c2RhdGE9S1kxWHViejl0YzBUUWRPUVRldFFScnVHZ0J4Sk9SRU0lMkZIUHJSUENI
aDZJJTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gDQo+ID4gRXhhY3RseSB3aGF0IEkgbmVlZCwgdGhh
bmsgeW91IDopDQo+ID4gDQo+ID4gVHJ5aW5nIHRvIGFkZCBhIHNodXRkb3duIEkgaGF2ZSBhIHBy
b2JsZW0gZ2V0dGluZyBhdCBwcml2IHB0cjoNCj4gPiBzdGF0aWMgdm9pZCBjY2lwX3NodXRkb3du
KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gew0KPiA+IAlzdHJ1Y3QgZGV2aWNl
ICpkZXYgPSAmcGRldi0+ZGV2Ow0KPiA+IAlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiA9ICh2b2lk
KilkZXYtPnBhcmVudDsNCj4gPiAJc3RydWN0IGNjaXBfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2
KG5kZXYpOzsNCj4gPiANCj4gPiBBYm92ZSBkb2VzIG5vdCB3b3JrLCBteSBwcm9iZSBoYXM6DQo+
ID4gCW5kZXYgPSBhbGxvY19uZXRkZXYoc2l6ZW9mKHN0cnVjdCBjY2lwX3ByaXYpLCBpZl9uYW1l
LA0KPiA+IAkJCSAgICBORVRfTkFNRV9VTktOT1dOLCBjY2lwX2luaXRfZGV2KTsNCj4gPiAJcHJp
diA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICAgICAgICAgIFNFVF9ORVRERVZfREVWKG5kZXYs
ICZwZGV2LT5kZXYpOw0KPiANCj4gSG93IGFib3V0IHBsYXRmb3JtX3NldF9kcnZkYXRhKCZwZGV2
LT5kZXYsIHByaXYpIGluIHByb2JlLCBhbmQgaW4gcmVtb3ZlOg0KPiANCj4gc3RydWN0IGNjaXBf
cHJpdiAqcHJpdiA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKCZwZGV2LT5kZXYpOw0KPiANCj4gZG9l
cyB0aGF0IHdvcmsgYmV0dGVyPw0KDQpZZXMhLiBJdCB3b3JrcyBwZXJmZWN0bHksIHRoYW5rcy4N
Cg0KIEpvY2tlDQoNCg==
