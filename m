Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373496BF26B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCQU2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCQU1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:27:55 -0400
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11012007.outbound.protection.outlook.com [40.93.200.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2885A8C55;
        Fri, 17 Mar 2023 13:27:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaiEVyMC6wIbb2SIwww2FcNKEsz2Qa0zzqFfoTuBgmKKRIT6F8fx3YKR7ThxyiQwH9yCc+rA9Tm8f5+oXYSbeROoEkUobmgeAoXY1A0IoxitPwu3T3zQS3NLP5SjbM9Q03p4f+W4g6y4VZUWh9n/+0bTRNT1R/+iPwbtfXjG31kZ914TVS9PDp9Yyd3H4E/Q1gAlIpalTVzKN+PKIdigjS6Dxsyp51mF6lHXP18k6OuSy7f5xAe8+7jLn7feYEJ+NdZWUNKAqOtHaCnRV+7A7LMv/1uKqXYuW+/gcaVRblc45xMLDrqqh52pszVrfESRjeOp1vh0jfSFv0dQSc6eqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNKQt+bZlAlixW4FtjYXfaK6XstfIEdt9cfefo2uIfM=;
 b=QVNYJzRrL6a+jOphQJdFkpC4TR0SGunodqEl9vfMtD2tbVp7ItUdMap18O2PlUH0jvDw5G/5/M5nktORmXnC7qUAH5mQT8xmGB9B20uBFfSNF+gGSE+RgQhpEHFhR9+AewMcEICv7xfr1bNVSS1X4hgKKal5Hve31u5w9Hv/dqpnqTgK4WrSO1jn2Tvi9JJu2pzjdHkaL2UskWjrh+3evjZMTpc4hbKZmycCu5U8/RfLgrjIX81I1f0XsUkcR/N57E/Rs+o/SXuJ7Hu1Q9dYvjF03ThXLRlPoPkH7kDpiRUIoZu93B+Z6NCkj7q+aqB8XhQoP/I6ijw0jJ8W05+kCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNKQt+bZlAlixW4FtjYXfaK6XstfIEdt9cfefo2uIfM=;
 b=CeeACXGZXG0MSqTMw9ZDn06xsYia+mRmR/uNLGmv7Iyzyai//PvJxDiPYzRDaa3AYVu4GHB8sG2seP+x4S9gKaE7pSOGdQq4glnSup4f8Bm2tlTN2wxC01faChag0eGtK37y6Jh/eLrrdHdZWtlbDbWJ+nG3am5LSXW3Df43yoo=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by PH0PR05MB9656.namprd05.prod.outlook.com (2603:10b6:510:28c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 20:27:50 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::4d4a:e1d0:6add:81eb%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 20:27:50 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Topic: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Thread-Index: AQHZUgzlNAVJE7qL50u4mFq6JoP4Ta7xmZqAgADvKQCAAKsUgIAHJTAAgADERoD//5SOgIAAf+AAgADlBQCAAJecAP//sNOAgAB4CoD//522AAAuiIyAAAywAgAAFrd5gA==
Date:   Fri, 17 Mar 2023 20:27:50 +0000
Message-ID: <754F4F49-97C9-45D3-9B2F-C7DAE3FFC30E@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
 <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
 <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
 <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
 <20230315211329.1c7b3566@kernel.org>
 <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
 <20230316133405.0ffbea6a@kernel.org>
 <06e4a534-d15d-4b17-b548-4927d42152e1@huawei.com>
In-Reply-To: <06e4a534-d15d-4b17-b548-4927d42152e1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.70.23021201
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|PH0PR05MB9656:EE_
x-ms-office365-filtering-correlation-id: 28c07bb8-c12c-471f-a393-08db2726145c
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHV/XvrEXMDQQ4JUJmA1cGJbVt1EADd6HLHSyfkQHyK+mKTwbcYYyy2Hpn8p2B145ChGwhLykQeoizmVn54zhe57NLNe34KAfPyWvYMtJbTS/RlPe+Lfw+579Ev07/IfoK3wNMV8SAvcmWcpRNp5QtQ8mSq9phDvdWr/fRz3hXm+kxq0d/BRNK7/2yQRGjsKUEQKByT1GGRwPByqu0HgqzEFYQWSiEiqCYykxIybmD5geCSCdaKU0G4McZ6PbFfSXPl5EGqJYKT6UF2Iyv/YWGSScThLC09pJsjwGkm0i8VA/tkn1OR4GIvlD/OZ3Vs6j7tQrBBv+z3UJwWt1pD8O3EoyR2aT5s8JW09tT3KUavQdQ8KgTmua9JS0qFlscCoUn/tPr4/45EUiURoPcp2U/raBfiWbJ3zV3EUe+OyNn0+ZKsdXQ6qbAz5QJd/eZCHeXPHQ1iAbSFQTRjA4dPTgBv1zOhnGAiJZ9rPMQ5VxhLPLo9l8ccZHRTlnFuzVqv04cTZ0cEsnKhUEFuK941XlRiTPXBownAzIE3dOVTwzmAoW/C3VbsENQ1y1T+jsaJppCNYj0s1R06R647yf8AQinn50yu88wC8IrxTNpLC8N+uCVLVr1YyEuT4oNnS2eoKP7oU9+Hq7R8+dImclrdO6hBypJaqkg7JIQ4XaiX3blZn7R01zRl09f3BuI9OrVJtA+wbj0YzXLAF/50dyJUOxMyPiv5kYpicM26zFyhGaIeI5A0D5WCB9yWC/50azTtM8GgIYlH4w36xdrXU1w7RHyA0itZ13EqH9fY7ayrNXpY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199018)(5660300002)(478600001)(64756008)(8676002)(41300700001)(2906002)(4326008)(76116006)(66476007)(66946007)(66556008)(8936002)(66446008)(110136005)(316002)(54906003)(6506007)(53546011)(186003)(6512007)(6486002)(33656002)(71200400001)(122000001)(2616005)(86362001)(38100700002)(38070700005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGgzNmp0c3BxRUhzL0FpT085NldyZi81UkI4T0w4VThJbGZ3OTUvbXpsU2Jp?=
 =?utf-8?B?MWVFd2hlREVJMmtrMVBqSEVuSnltVG5YQ3Z1ck1OWnhrTnNxeVBPQ1JuZFdL?=
 =?utf-8?B?U3FwY2NBY0NQN1BVMnFVUFlXaXRBOC9qeFpZeEowTmNSblhocUpwS1lMb0ZT?=
 =?utf-8?B?UnlVMzJuMTNxOHlSb0R6YlVQZER5SGhvclBqbVkrdEg0WEozK0hsM1hXQ0Fq?=
 =?utf-8?B?YjlIa2llSWJONEdoUWRadEZiSVFwQnJHK3hzZDUwanFrUW9lY01XNG0yUFA1?=
 =?utf-8?B?WlA4bUlUb3hFV3YyRms4ZHl0ZmdsRyt1bXFpQlVndktmc1IxTmpHdEVmbk9F?=
 =?utf-8?B?MVo0SnBaM3M5Y3dMSFFvZW9tNFRBTzJrQklENEl4UllrRGVjdm1jMlZLejY3?=
 =?utf-8?B?L3FhMFdxTi9IZFFDa0RwbzdUZFRpRGh2SlNiUmN4bjg5SGRwZ0RNMHRHU2hZ?=
 =?utf-8?B?N0dmQWsxMStZWFNINTM4Z0YrWVFKV3NNOHV3alUrOFo2Nkx3ZmdmMWowRDNH?=
 =?utf-8?B?T2Frdzl3UnJXRkRZNVhVY2cwbm5LM0w2ZWg0Y3Fwcm9WVzErWjNwc1ZvZlhj?=
 =?utf-8?B?aTFCUDlaZVkycHFKNW1PZWRveE92TGtnNkRsK1N3TnZwanJPQ3FzWE03NURw?=
 =?utf-8?B?Mk1la2ZMOUlCdFZHT3duRytiTXdEVHRCdkxYa2pVdDlCMmhHc09YYURrcVha?=
 =?utf-8?B?a0Y1alZUWSs2Q3VjR2swSFplVkt2UUx0QVowMDVUT2lRWXZMUE15cnJkZzd5?=
 =?utf-8?B?OThOdDBQdGhNMkJtNmpmOHQwS3daMkE5dE9XZ2JYYVBqOXlMRmFVMm5GNUF5?=
 =?utf-8?B?YlcxTWlqNFgzei9jRGt6ZDBBV0o0YmNzQ1ViSkJDejlzeXdWTDA0WWVyL2hl?=
 =?utf-8?B?YnB2ZitHd2QvUHM5QVptcU8yMEZwaHVySFFvWTh6WWk1VXQ1QlR5VldKRGw1?=
 =?utf-8?B?RDBsZzdUUHVJa2s4bGxkb3hHaVI1OGppc00zQ3RaWW0rcGZWSHhQVmgyMXMv?=
 =?utf-8?B?TzZ0ay95QXdnVW9HYiswTXNybyt1ZnV1eFNUVVFZTUE5TElFSVlqcXdaY0Rw?=
 =?utf-8?B?alVheG5qTWtkU1k2UCtxZVFaVDFEZ1h1aTFDdGdhaERQbDZUeU5KejNNeDlm?=
 =?utf-8?B?Qkc0eWxMVTFsZEEvUmJvclRFUEJ4Q3I3bVNQVjdYd2JuVG9rQ2E1QVRQNVRr?=
 =?utf-8?B?MW45WkFsUWh3UkUzNXpsbWtMUjkzcTFRamN4L1EydFc3M1VYdFZsUGVSaktQ?=
 =?utf-8?B?cnlnTVFydlAyR0tXRUc4Tk02amtsQmZyQmh2RlYzeTczS1h3bHpJaWt5Z2lO?=
 =?utf-8?B?RWh0cXlnenB6d2hGbFNqNzNEN2tyclNGKzZUcWRmMHZrb1oyUWhWSTIrVFVz?=
 =?utf-8?B?TG5LcTk1dU5qVjVwZEZNRG9oV3lmbnJFUXJqK0IvOFFERDhuOGZMYjF0RTJl?=
 =?utf-8?B?ZFczK053UTlvZ1Y2anZ0Vkp1NTRmSWNQYktpWVJxa1p2TmwvTGVVamlCdTR0?=
 =?utf-8?B?QjN3V3lxanBaNE9BTnhDVUVuRXRGWWFYSDNNeGVEWnF5encvVHZvcWFGa2xF?=
 =?utf-8?B?ZGZqbzNXU0dHOElIZWdScStpUDAxZ1RTYkd0VW9LVmZ5S0t6ekJVM3B4S2JT?=
 =?utf-8?B?cTBZWkVRVEZxV2Ryek1wdlVVVDFHTWVBSnhXb2FmZmlMODcxd2ZFWDF4N3hp?=
 =?utf-8?B?b0pPVnJRL1puTUtGRVFseGM3VlppN3pBT2lwQmFPaGczT3BwaUQvNE94bXFq?=
 =?utf-8?B?SmxUWGMybnlBRnROMTk2Y1dPR3p6QWdWbW5BZENybGZxbGMzSVE0MHNXVnN5?=
 =?utf-8?B?WUlCdnlpRkRNeDZZd0wrUEFWNEZhQUtYaUNvOU1vUkI1VVFjZDUxM3FWR1hy?=
 =?utf-8?B?bDFzSHIvWUJvMitqT1hxdGtRdmlZdy8vSzlmRlNhS0RQc09ER1RJemxZa3Ur?=
 =?utf-8?B?SnRwek9vYU5ST080TXpMbXpUMXkyRGhpc2dSM0NkYVlac2NBcDVlNlJjKzVP?=
 =?utf-8?B?QjQzOFpqV1VOZ1A0eWNHOHRLeVZhaWk2alUrSzNBbUJSckg2dUJpNkFYOG1x?=
 =?utf-8?B?MHdPUmxJbXlubG5ZemhUQ0NuNTFNL2s0OElEdjVQTFpYVnVrekhrZVVJNzJY?=
 =?utf-8?B?clhueWtGdzJRYjMwQ0szN0ZuWi9GTGhDQnh5T1VzMkc4QkR2ZmkxVmgyU0xn?=
 =?utf-8?Q?raEvnbvthNq0zi3gzP3q4jT+8W19Xu/hRnii48DTjIi1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAE452DA2697934C9C7387CF3EC2E6ED@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c07bb8-c12c-471f-a393-08db2726145c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 20:27:50.6600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2UwWQqPPMmjj9/Vrs3yxjW2CUgctzuc65C5HyQc8KPrBZ5G+HM9pmNYi+6ho4psvaErfpwjZelOV5+8v4EtyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB9656
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7vz4gT24gMy8xNi8yMywgNzozNyBQTSwgIll1bnNoZW5nIExpbiIgPGxpbnl1bnNoZW5n
QGh1YXdlaS5jb20gPG1haWx0bzpsaW55dW5zaGVuZ0BodWF3ZWkuY29tPj4gd3JvdGU6DQo+ID4g
T24gMjAyMy8zLzE3IDQ6MzQsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+IE9uIFRodSwgMTYg
TWFyIDIwMjMgMDU6MjE6NDIgKzAwMDAgUm9uYWsgRG9zaGkgd3JvdGU6DQo+ID4+IEJlbG93IGFy
ZSBzb21lIHNhbXBsZSB0ZXN0IG51bWJlcnMgY29sbGVjdGVkIGJ5IG91ciBwZXJmIHRlYW0uDQo+
ID4+IFRlc3Qgc29ja2V0ICYgbXNnIHNpemUgYmFzZSB1c2luZyBvbmx5IGdybw0KPiA+PiAxVk0g
MTR2Y3B1IFVEUCBzdHJlYW0gcmVjZWl2ZSAyNTZLIDI1NiBieXRlcyAocGFja2V0cy9zZWMpIDIx
Ny4wMSBLcHMgMTg3Ljk4IEtwcyAtMTMuMzclDQo+ID4+IDE2Vk0gMnZjcHUgVENQIHN0cmVhbSBz
ZW5kIFRocHQgOEsgMjU2IGJ5dGVzIChHYnBzKSAxOC4wMCBHYnBzIDE3LjAyIEdicHMgLTUuNDQl
DQo+ID4+IDFWTSAxNHZjcHUgUmVzcG9uc2VUaW1lTWVhbiBSZWNlaXZlIChpbiBtaWNybyBzZWNz
KSAxNjMgdXMgMTcwIHVzIC00LjI5JQ0KPiA+DQo+ID4gQSBiaXQgbW9yZSB0aGFuIEkgc3VzcGVj
dGVkLCB0aGFua3MgZm9yIHRoZSBkYXRhLg0KPg0KPiBNYXliZSB3ZSBkbyBzb21lIGludmVzdGln
YXRpb24gdG8gZmluZCBvdXQgd2h5IHRoZSBwZXJmb3JtYWNlIGxvc3QgaXMgbW9yZSB0aGFuDQo+
IHN1c3BlY3RlZCBmaXJzdC4NCj4NCg0KSSBkb27igJl0IHRoaW5rIGhvbGRpbmcgdGhpcyBwYXRj
aCB0byBpbnZlc3RpZ2F0ZSB3aHkgaXQgdGFrZXMgbG9uZ2VyIGluIEdSTyBpcyB3b3J0aHdoaWxl
Lg0KVGhhdCBpcyBhIHNlcGFyYXRlIGlzc3VlLiBVUFQgcGF0Y2hlcyBhcmUgYWxyZWFkeSB1cHN0
cmVhbWVkIHRvIExpbnV4IGFuZCBjcm9zcy1wb3J0ZWQgdG8NCnJlbGV2YW50IGRpc3Ryb3MgZm9y
IGN1c3RvbWVycyB0byB1c2UuIFdlIG5lZWQgdG8gYXBwbHkgdGhpcyBwYXRjaCB0byBhdm9pZCB0
aGUgcGVyZm9ybWFuY2UNCmRlZ3JhZGF0aW9uIGluIFVQVCBtb2RlIGFzIExSTyBpcyBub3QgYXZh
aWxhYmxlIG9uIFVQVCBkZXZpY2UuDQoNCkkgZG9u4oCZdCBzZWUgYSBmdW5jdGlvbmFsIGlzc3Vl
IHdpdGggdGhpcyBwYXRjaC4gSW4gVVBUIGFzIExSTyBpcyBub3QgYXZhaWxhYmxlLCBpdCBuZWVk
cyB0byB1c2UgR1JPLg0KDQpUaGFua3MsIA0KUm9uYWsNCg0KDQo=
