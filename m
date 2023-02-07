Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D4B68DC9C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjBGPL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjBGPLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:11:19 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C47A3D936;
        Tue,  7 Feb 2023 07:11:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXTBuq2pCk9vBuHfmr6pxlLZ1toUx0rUueyTh+j6xE726Re+W+SDFDyVLVDmWsk2UIxthYi1gaxQxN2BB8RuAPfEUp6IawnLblVbOrwnUmzdLfJL+wgVlIZDmMvpFXaKQu8aexvZQsFeYouHx78IlSkryaQDM9wm7m0e6w0QwrsfjdrBVePcWSy+vJxvqW9dkHBgFnYqIo/qap/Jwj5GRJel1h002340i8RcAcjA6+cweAteGRQr4h1w2ZQ7O3t6mkbvFUDWJh8NpCheIJaMTlvMnHrza/kO2TXMWlJ4QjNDbR40pO1K3Z23k4+uonfroL3xX7kutMU7ScrAOanv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ak9gog75s4oTi5UnBCPvO11NpJkQ8VuQFfF+knkAuWk=;
 b=FoUvii+hhdcVmrh3z2k3S8Pno2Ue2lwOah+UX5sj1FlBr17oMpdrtnjUkkDNG2HNMOTB1nolwLiL8jusikQe9qiaF+xO/EZvbLtiE9uDdRbJUDdBU4cNVgSe54R+QSnvrZifRRvNQwZASL8GSm+pGKtd48jL8H0xbr3AFcDzn/VdIH4qbNcKKdPR03nGNTac/3Xl93QjuIleQPvvuzjb+DkkiG3RpjI5LB9qpfEYNZRmK8BzpmuqkbzFiYGnL3bkCJmPqAl4tBg3yu/hMJaD4nS62WACn+qtcTDy/V9bQ3vtTzT3S22k/v6cOjpcGEt3ToBv9gkhikvI3mJkatjndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ak9gog75s4oTi5UnBCPvO11NpJkQ8VuQFfF+knkAuWk=;
 b=TjZ5sA6u5Qq9/rzip475WxANKuQOvsyso4wmBg7AAsx/vVj7kbpKAgTuKce5nHms7X61kyNv4RRfm9hmInD6vqtGG/O6EM5recg6ppX9O6cegSiOQAod/BMRWlqEsOX8+2xy2WHp86JtJW1L145nGA458YyLp7okrfGrZ7nhwVQ=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM6PR12MB4076.namprd12.prod.outlook.com (2603:10b6:5:213::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 15:10:51 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 15:10:51 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZNveRaZV2migBBki/Fbor0TTGVq67jUyAgAgJY4CAAAS0gIAAA0yA
Date:   Tue, 7 Feb 2023 15:10:51 +0000
Message-ID: <DM6PR12MB42026D97627495DC2FF2A346C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
 <Y9ulUQyScL3xUDKZ@nanopsycho>
 <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
 <Y+JnH+ecdTGgYqAf@nanopsycho>
In-Reply-To: <Y+JnH+ecdTGgYqAf@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4202.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM6PR12MB4076:EE_
x-ms-office365-filtering-correlation-id: ee1af5b5-594f-476a-c385-08db091d8064
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LVKCffYt/AlExshy77vm5QuKHbIKSXjNACFi3WYXbipukM1vwjOf8qdRAf2+UsSgpZNXJpVqACafo2KYkJWOoefu8nTOG/D5VInhbGF8qmGkePIe4u/SadH4uBhlA30OAR3V80bZogSNaiuw3Xbxknc74jHflThc2ZPe1A7yYOm6dQarsiLsrkJG1r2Wi+1O82ov0yK0l9L60MfGqNfkjRCMtHmTT69tcHEY6GJqs6TAv+0T+joQrXbCXuDKD2YV+XxGNr7zLBfUCtPIncW5TeDlp2+fcNHEQBVR4l6bnPefmIBKvMWRn9F5C/Hmrd2eeE5G1x4axpahKCpcC6WI52ibiVBQ1nJhLUO6UEnNe2tJa6L8DPRmyN/wyrJ5JW2KXFJJmvVt9JhC5FSqKe5vTrQHZmQQvFCw+7wRy0ZcJ0oIHStzcsaDl/WgeYG3hrL594SrSKcRBOifxCZLLfXZSf1AUUEa8+Qt0vWpflMOr2HXc9FF/UwbVFKsl0xwcx0QKUafj/3tU1mLFCq8PaB5AKAhgiIE6x77kaeNXXR2U5zQIWZcIu4gxZqVoCe7AvxMV0MTG3OBeclGJ0htbnP39XGe7zXE2vVhAb3XhAcqt7eMZKscV18HegtWW4mJuAjkFpaYTCZYRauJa6+IuYt4WJ2NeTSrz8/sw4wcZeoWukUBJYuQmBJQAjRcgrUZSV1Sj91TrIygp2Ro54HQp/sTaTq3US/u3tX3EdqXjGjLQ5wNU6o1K/aIaajVeJKhwZeN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199018)(478600001)(9686003)(26005)(186003)(7696005)(33656002)(2906002)(122000001)(38100700002)(6636002)(71200400001)(316002)(38070700005)(110136005)(54906003)(83380400001)(76116006)(4326008)(66946007)(66556008)(6506007)(53546011)(66476007)(55016003)(7416002)(8936002)(41300700001)(52536014)(8676002)(66446008)(64756008)(5660300002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnBhSFVjNUJGSzM2cHY1bDF5Ung0blVTbFlKdkl0cEZYeWptczJKS2Q2ckZQ?=
 =?utf-8?B?SGVwSkVoNVppL1NRSkhzTFg2K2dETjkvZTVoelpkcWZIYWcvRHYvK3NqaUg0?=
 =?utf-8?B?bmZkS21aSHgrMjIzVFArRWFWVUxnV3NHRzlNTW5tSVU1cjZvY0ZtS3lQUWVl?=
 =?utf-8?B?NDNveE9EYnNCRnhmd2ZrOUZScHU3TGdjQkdNR0drckJGWWEwWU5kVERBVkk1?=
 =?utf-8?B?ZnpKclNwajBSV3QyYUdsdERuZVdZRTFTMGJMYkFoRjV1NmpUUm1WanVwaXQ4?=
 =?utf-8?B?bUR1c214ZW5qTWpTZkQrTmxDS0xoRWFvVEduZVhkbkZ1cVQxczF5SFcxa3Nz?=
 =?utf-8?B?T2pNZXREajNqSkFCZmdVTHJHc0FxS2wzTjNFR0gvT3FmelRqVHpjMDJ0TmFB?=
 =?utf-8?B?b1o1MkZYNW8yV0xBbVFLeWR0RDZCNWdINm5GNktUWnhyTzJOdkhaV3YvaUZw?=
 =?utf-8?B?YmVKMGhWNlNONDRWeGdQOVJueDRLRitOSWt4bGRtN00zWEhPWW5aWTlwamJQ?=
 =?utf-8?B?RUM3N2s0VFQvSXZBMEozdkRYcGdkeXFsTGRENE42bG5JVFIzaG44Y2JvNjd1?=
 =?utf-8?B?M2VPM0QxRkNEOENwQlZRM2FEY2orQ244THNqckhkNHFoeHlvSHVXUHNsR3lZ?=
 =?utf-8?B?YWZISllhU0N3MkhxenhtQnF5b1A2K2FUc1lLL3FpTmpseXFkSnVMNXFSeExj?=
 =?utf-8?B?UUFja1ZtOSthRkFCYVNmSDI0Z01OVURrMnlrM1pwWnRxditWZ0ZJZHNGcVdL?=
 =?utf-8?B?M2QyV0ZtK0xVdkVaRUwxS3c0K3RFMk5wYUppYXNNalY1WlZ1MXV0NndvRkoy?=
 =?utf-8?B?dXI0T0tIRjNnLzBRL0ducStQUlZ0LzVzamw0R1daWGtydnE5RjJkTXFiMENK?=
 =?utf-8?B?dUNCbjM5M0NrQ1Z2MGtRdGxhdjQ3ZURsdHBkYlVJZEduK0MydVFyS29EWnVo?=
 =?utf-8?B?aUh0M3YyQjRJczJnZjFwQnA3eW5CcmloLzlrQ0ZLNlZjaW93Y0hERFlBUVpM?=
 =?utf-8?B?aEhzYlJDMGhZNGtqR2ZxNzVET3krZzlDVGo0ZXNvM2RIeld0UElxV2JQTEI5?=
 =?utf-8?B?cWxWc3gzSjhLZXE1N1hlNm4zMlh6RzdjVlNkZDB6bGdZaW95YkdQYWl6QWFk?=
 =?utf-8?B?VXh5SW5pOThEZFpIQ1REMnZ4M1F1cUphWTdic2szYllPYXhoRkd1dHJSaFhW?=
 =?utf-8?B?TXQ2YjZId1ZCbjdIaUVCQktOdDQ4YWNkRitVUzcxWFNTdGxneGJVbStienY2?=
 =?utf-8?B?YUdxZkZwRG1jMWIxd0U4QjVuMGhWcWVOTjJyY095RkR0RlplZzBYbjlxTWc5?=
 =?utf-8?B?bkwwek9Qc1hnTUd0WjFmZmtOa1VxN3dxNUVVQkg4eVN4SXJoM3BQcXc3Vk1T?=
 =?utf-8?B?MWxQT3BUTmN0RGVFZ1VFa1hRRWZkYUdnaFJHT1YxcFBoZGhLUld0NHlFdzho?=
 =?utf-8?B?dTN6THJ5WWhiNWFzREJkTmI5RHJhclQxWkxmTW9Sc3BVcTh2M1MvaHlMV096?=
 =?utf-8?B?OExRcnJWdWdXaDBLWjhuMkRSM0sxNW9lSk5BWFU5Z2RyUER4VTFVT3BYNTFy?=
 =?utf-8?B?SW1Wd3hYaUE1MTV0ZmFjWUNML2lNOTgxYWtKYWNxczZRNEswajFJaUlsdDMz?=
 =?utf-8?B?RVRVN0cyanpVaFh0Zjk2WGpnVWVGY1paMFMvV2V1a3Q0TXhiMjNERmoyeHBk?=
 =?utf-8?B?L1VpQ2E2QU5CTFBjV1EvTGIyMFJBU0tYQTNHc0VIemRVaHFMQnQ1emQ3bDRz?=
 =?utf-8?B?Wmc5VkxzU0tKajZodGVNWG0yMzFBaTZkRHdwcnJxNjY2cXArME5sOUhUeGdR?=
 =?utf-8?B?eTZpakUyTmkvUjZGbGhNSnJxUFVGWEFKYkg0bkVSOXRCQXI2VEpYR1NqMEw2?=
 =?utf-8?B?SGJ3a0EvNTRLY0ZVdFNEd0tFczI1K1VMOXpndk1za1NOUDU0aHlLcUhvR2ZI?=
 =?utf-8?B?L3NkZUl0WmFFWS80eGZyaTRDdnQ4dU03SDd3eXJqZExUZ2VwSmxLM1A2RXJH?=
 =?utf-8?B?SDhxZ0xDYWlKS3RYampxaXI3RG5TK084RW5Ec1M5R0xZemNiUGRDakd4S2RG?=
 =?utf-8?B?UkRERXYvUE5LTUZYSUJ4Y3lrbFNqR1dxZGV4Q3pTSS9TNlRjSWJLK3ZwcnRX?=
 =?utf-8?Q?fVNE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBE98DBE960F841932B63BC842A2089@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee1af5b5-594f-476a-c385-08db091d8064
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 15:10:51.5533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtemN5GDoK9m5EVkN9QpDU+r+zCrqP/rH1L3zkstggvuEnD3rT3mH1Qu8WLYnRdzExyCsdz7Brhn3e7Qlr2kig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4076
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzcvMjMgMTQ6NTgsIEppcmkgUGlya28gd3JvdGU6DQo+IFR1ZSwgRmViIDA3LCAyMDIz
IGF0IDAzOjQyOjQ1UE0gQ0VULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6
DQo+PiBPbiAyLzIvMjMgMTE6NTgsIEppcmkgUGlya28gd3JvdGU6DQo+Pj4gVGh1LCBGZWIgMDIs
IDIwMjMgYXQgMTI6MTQ6MTdQTSBDRVQsIGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3
cm90ZToNCj4+Pj4gRnJvbTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxh
dUBhbWQuY29tPg0KPj4+Pg0KPj4+PiBTdXBwb3J0IGZvciBkZXZsaW5rIGluZm8gY29tbWFuZC4N
Cj4+PiBZb3UgYXJlIHF1aXRlIGJyaWVmIGZvciBjb3VwbGUgaHVuZHJlZCBsaW5lIHBhdGNoLiBD
YXJlIHRvIHNoZWQgc29tZQ0KPj4+IG1vcmUgZGV0YWlscyBmb3IgdGhlIHJlYWRlcj8gQWxzbywg
dXNlIGltcGVyYXRpdmUgbW9vZCAoYXBwbGllcyB0byB0aGUNCj4+PiByZXN0IG9mIHRoZSBwYXRo
ZXMpDQo+Pj4NCj4+PiBbLi4uXQ0KPj4+DQo+PiBPSy4gSSdsbCBiZSBtb3JlIHRhbGthdGl2ZSBh
bmQgaW1wZXJhdGl2ZSBoZXJlLg0KPj4NCj4+Pj4gK3N0YXRpYyBpbnQgZWZ4X2RldmxpbmtfaW5m
b19nZXQoc3RydWN0IGRldmxpbmsgKmRldmxpbmssDQo+Pj4+ICsJCQkJc3RydWN0IGRldmxpbmtf
aW5mb19yZXEgKnJlcSwNCj4+Pj4gKwkJCQlzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2sp
DQo+Pj4+ICt7DQo+Pj4+ICsJc3RydWN0IGVmeF9kZXZsaW5rICpkZXZsaW5rX3ByaXZhdGUgPSBk
ZXZsaW5rX3ByaXYoZGV2bGluayk7DQo+Pj4+ICsJc3RydWN0IGVmeF9uaWMgKmVmeCA9IGRldmxp
bmtfcHJpdmF0ZS0+ZWZ4Ow0KPj4+PiArCWNoYXIgbXNnW05FVExJTktfTUFYX0ZNVE1TR19MRU5d
Ow0KPj4+PiArCWludCBlcnJvcnNfcmVwb3J0ZWQgPSAwOw0KPj4+PiArCWludCByYzsNCj4+Pj4g
Kw0KPj4+PiArCS8qIFNldmVyYWwgZGlmZmVyZW50IE1DREkgY29tbWFuZHMgYXJlIHVzZWQuIFdl
IHJlcG9ydCBmaXJzdCBlcnJvcg0KPj4+PiArCSAqIHRocm91Z2ggZXh0YWNrIGFsb25nIHdpdGgg
dG90YWwgbnVtYmVyIG9mIGVycm9ycy4gU3BlY2lmaWMgZXJyb3INCj4+Pj4gKwkgKiBpbmZvcm1h
dGlvbiB2aWEgc3lzdGVtIG1lc3NhZ2VzLg0KPj4+PiArCSAqLw0KPj4+PiArCXJjID0gZWZ4X2Rl
dmxpbmtfaW5mb19ib2FyZF9jZmcoZWZ4LCByZXEpOw0KPj4+PiArCWlmIChyYykgew0KPj4+PiAr
CQlzcHJpbnRmKG1zZywgIkdldHRpbmcgYm9hcmQgaW5mbyBmYWlsZWQiKTsNCj4+Pj4gKwkJZXJy
b3JzX3JlcG9ydGVkKys7DQo+Pj4+ICsJfQ0KPj4+PiArCXJjID0gZWZ4X2RldmxpbmtfaW5mb19z
dG9yZWRfdmVyc2lvbnMoZWZ4LCByZXEpOw0KPj4+PiArCWlmIChyYykgew0KPj4+PiArCQlpZiAo
IWVycm9yc19yZXBvcnRlZCkNCj4+Pj4gKwkJCXNwcmludGYobXNnLCAiR2V0dGluZyBzdG9yZWQg
dmVyc2lvbnMgZmFpbGVkIik7DQo+Pj4+ICsJCWVycm9yc19yZXBvcnRlZCArPSByYzsNCj4+Pj4g
Kwl9DQo+Pj4+ICsJcmMgPSBlZnhfZGV2bGlua19pbmZvX3J1bm5pbmdfdmVyc2lvbnMoZWZ4LCBy
ZXEpOw0KPj4+PiArCWlmIChyYykgew0KPj4+PiArCQlpZiAoIWVycm9yc19yZXBvcnRlZCkNCj4+
Pj4gKwkJCXNwcmludGYobXNnLCAiR2V0dGluZyBib2FyZCBpbmZvIGZhaWxlZCIpOw0KPj4+PiAr
CQllcnJvcnNfcmVwb3J0ZWQrKzsNCj4+PiBVbmRlciB3aGljaCBjaXJjdW1zdGFuY2VzIGFueSBv
ZiB0aGUgZXJyb3JzIGFib3ZlIGhhcHBlbj8gSXMgaXQgYSBjb21tb24NCj4+PiB0aGluZz8gT3Ig
aXMgaXQgcmVzdWx0IG9mIHNvbWUgZmF0YWwgZXZlbnQ/DQo+PiBUaGV5IGFyZSBub3QgY29tbW9u
IGF0IGFsbC4gSWYgYW55IG9mIHRob3NlIGhhcHBlbiwgaXQgaXMgYSBiYWQgc2lnbiwNCj4+IGFu
ZCBpdCBpcyBtb3JlIHRoYW4gbGlrZWx5IHRoZXJlIGFyZSBtb3JlIHRoYW4gb25lIGJlY2F1c2Ug
c29tZXRoaW5nIGlzDQo+PiBub3Qgd29ya2luZyBwcm9wZXJseS4gVGhhdCBpcyB0aGUgcmVhc29u
IEkgb25seSByZXBvcnQgZmlyc3QgZXJyb3IgZm91bmQNCj4+IHBsdXMgdGhlIHRvdGFsIG51bWJl
ciBvZiBlcnJvcnMgZGV0ZWN0ZWQuDQo+Pg0KPj4NCj4+PiBZb3UgdHJlYXQgaXQgbGlrZSBpdCBp
cyBxdWl0ZSBjb21tb24sIHdoaWNoIHNlZW1zIHZlcnkgb2RkIHRvIG1lLg0KPj4+IElmIHRoZXkg
YXJlIHJhcmUsIGp1c3QgcmV0dXJuIGVycm9yIHJpZ2h0IGF3YXkgdG8gdGhlIGNhbGxlci4NCj4+
IFdlbGwsIHRoYXQgaXMgZG9uZSBub3cuIEFuZCBhcyBJIHNheSwgSSdtIG5vdCByZXBvcnRpbmcg
YWxsIGJ1dCBqdXN0IHRoZQ0KPj4gZmlyc3Qgb25lLCBtYWlubHkgYmVjYXVzZSB0aGUgYnVmZmVy
IGxpbWl0YXRpb24gd2l0aCBORVRMSU5LX01BWF9GTVRNU0dfTEVOLg0KPj4NCj4+IElmIGVycm9y
cyB0cmlnZ2VyLCBhIG1vcmUgY29tcGxldGUgaW5mb3JtYXRpb24gd2lsbCBhcHBlYXIgaW4gc3lz
dGVtDQo+PiBtZXNzYWdlcywgc28gdGhhdCBpcyB0aGUgcmVhc29uIHdpdGg6DQo+Pg0KPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTkxfU0VUX0VSUl9NU0dfRk1UKGV4dGFjaywNCj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgIiVzLiAlZCB0b3RhbCBlcnJvcnMuIENoZWNrIHN5c3RlbSBtZXNzYWdlcyIs
DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1zZywgZXJyb3JzX3JlcG9ydGVkKTsNCj4+DQo+PiBJIGd1ZXNzIHlv
dSBhcmUgY29uY2VybmVkIHdpdGggdGhlIGV4dGFjayByZXBvcnQgYmVpbmcgb3ZlcndoZWxtZWQs
IGJ1dA0KPj4gSSBkbyBub3QgdGhpbmsgdGhhdCBpcyB0aGUgY2FzZS4NCj4gTm8sIEknbSB3b25k
ZXJpbmcgd2h5IHlvdSBqdXN0IGRvbid0IHB1dCBlcnJvciBtZXNzYWdlIGludG8gZXhhY2sgYW5k
DQo+IHJldHVybiAtRVNPTUVFUlJPUiByaWdodCBhd2F5Lg0KDQpXZWxsLCBJIHRob3VnaHQgdGhl
IGlkZWEgd2FzIHRvIGdpdmUgbW9yZSBpbmZvcm1hdGlvbiB0byB1c2VyIHNwYWNlIA0KYWJvdXQg
dGhlIHByb2JsZW0uDQoNClByZXZpb3VzIHBhdGNoc2V0cyB3ZXJlIG5vdCByZXBvcnRpbmcgYW55
IGVycm9yIG5vciBlcnJvciBpbmZvcm1hdGlvbiANCnRocm91Z2ggZXh0YWNrLiBOb3cgd2UgaGF2
ZSBib3RoLg0KDQo+Pj4NCj4+Pj4gKwl9DQo+Pj4+ICsNCj4+Pj4gKwlpZiAoZXJyb3JzX3JlcG9y
dGVkKQ0KPj4+PiArCQlOTF9TRVRfRVJSX01TR19GTVQoZXh0YWNrLA0KPj4+PiArCQkJCSAgICIl
cy4gJWQgdG90YWwgZXJyb3JzLiBDaGVjayBzeXN0ZW0gbWVzc2FnZXMiLA0KPj4+PiArCQkJCSAg
IG1zZywgZXJyb3JzX3JlcG9ydGVkKTsNCj4+Pj4gKwlyZXR1cm4gMDsNCj4+Pj4gK30NCj4+Pj4g
Kw0KPj4+PiBzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfb3BzIHNmY19kZXZsaW5rX29wcyA9
IHsNCj4+Pj4gKwkuaW5mb19nZXQJCQk9IGVmeF9kZXZsaW5rX2luZm9fZ2V0LA0KPj4+PiB9Ow0K
Pj4+IFsuLi5dDQo=
