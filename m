Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E76457D2E1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiGUSBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiGUSBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:01:36 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB76F8AEEB;
        Thu, 21 Jul 2022 11:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0rvm3x45jaN61JcVX3CED69JJyOSSZ17oL/tFgQq9q7ACdi5kQn6hfkYYZWp1JC9VSP2gWTeU68I13gRXl1ndAj/ct5nL/96hqg0T3o6of6a5yigb5bSTJIxeEaBQ33llQaxyxhn7n+hj/2YfFxpd51UyAUPxzeubFAvOWThtZjsJUoi1DyDSVBg9ltSLFw1MPqRhAH8T1vox9kA9T+Z1FvHkX6t9WSTzhmnqyrGCaNpoRkbIKw7tBWVYxZMZFYlj2BiaZKdvgUuICcsevY4u/t8xzd3LmmoNotU5NsnelgKf2e+2f9BZlZ16pIsUHMgSh6LwrVAsPlsKn1ZYHwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsIO6/mHvMfVQQcRMFagqTLEqIukOO9GaO8am4fd71U=;
 b=jZqi+g1RnOtlxumudfBOPXAw3BtC190v1AhbftR74X3XoSzgD8RoFn+wwasVO+ZQ7nre8cqTfa6nbM3GWw/t1axhkCYTOemJI5nkO6e0PsdaeIIheG0qXm0N5WRn5wtGBtJxs2eLhAYL8RxvCODpLiJX96AMhG9yjgfvvuzfwRzTx8eX5vM+5p+UihvVg8CBchWb5/sySiixsWz1jsDxCl+O28uLD4Cb4H97jHv4MMGgD+Brjnn7TmFCFxSVgJizJPlyl0SoKfJr3J5Lul78ngi4Ks0/D4/Jg0vIWI9OcOzI8sm3DdQcI8X5V47ROS8UF9O18J3qjRH7UAvQg/yb9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsIO6/mHvMfVQQcRMFagqTLEqIukOO9GaO8am4fd71U=;
 b=bkD3OQRXJXOPI/xftFV+/iSrLg6IiDJmvT2flRWBhpdL6e0kyaMdZSYIOtLKd4numisrCYnmpeKBNni6Ap6GGNik6X1VrLFJLkIPjLRYmBflRyYzJOhAkRQ6E8UupWxs2TUmthN+9kyX6CChTpJR+IgO2Q8CPAxwglDI8oM5xJY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB2062.namprd21.prod.outlook.com (2603:10b6:510:ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Thu, 21 Jul
 2022 18:01:33 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%7]) with mapi id 15.20.5482.001; Thu, 21 Jul 2022
 18:01:33 +0000
From:   Long Li <longli@microsoft.com>
To:     Cheng Xu <chengyou@linux.alibaba.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYgSXbjJmQZA89Xkq00e3L3Okxs62IwvuAgACRyhA=
Date:   Thu, 21 Jul 2022 18:01:33 +0000
Message-ID: <PH7PR21MB326345CED09A427C7309715DCE919@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <f030aeab-b503-8381-53f5-15862e1333b0@linux.alibaba.com>
In-Reply-To: <f030aeab-b503-8381-53f5-15862e1333b0@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f8b5fa8-c1b5-4a0e-a731-9724e25f544c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-21T17:58:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d209cd88-748b-40a1-342c-08da6b430bd3
x-ms-traffictypediagnostic: PH0PR21MB2062:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G02QMm6tXxAWDrlz6QXg6Hx08X2XPizJFKCjJ9M31dL0bhAU2o14tXurQs/pBVslPko55TBmT03oc9/Hx1Zo4frJ6Yng2yg0LUTdHUvf2AARXAtOG3Tx/nfmgtGNSojAvmgVev4pwKO10VawoFxFZk90EXYukelZwkNg22CuHcgP3RUtBb6Jxqdb7XBxFWJ9wR48+5fMiey6TH9jP2GZ3SxdgkOw3VKnT7aahJPu9SRw3POW3HptY/YCxm3GXIVHh5HtwTl6Hvcqy1Df7c1TRVilRXCtWVzAldZdsYL4kR8WofBMUmEpzoBo+PX4O1kkHqudKXEXep53PKB1WkUVH3vHJC9ToHvkq0ZKY/kNmM/+JLhWrux5MWI2DModowk3jro4hA3V6S8IJjO3OatT+e0GB/ToToWu/1sD9ExIfbRqX6ygr2ZQ36RS4A1QIqCvpKT6wUakxtOT37Ybi8BJw02Gu8L9Y/E/5HDLQ1dh+AIOyzPR5af7nKm9vP1sP5mdKVOuwPFyQT+AW8/zWs03E7/6FldTbWRoOGVgdDi3t9t7xiETiSo8sURKUuKowXdYpacIvlJb4fi6UmKWKZ8F/N9JdBwUvxTQP9lP60INtDBsVeZoi4KuzWaeH8HSNS6cDpCQq0k9fIuWYs8BYQOW6on5KbCS2nP2iib4e2RloXqaPN5Srona00h6ttjByIDzut51pLG7uZUDpojuuGCGcWY8Pw4Wyx5Gp5EgoVOAjxm2MNvxOmqZM1fWeJyHv+Dq/ZsXrgHxK6xdcaPuirX4AtmxAxV2vVeaCyTw8u+10NjMNPT8OppNlFITCKNMe1LJOyneN3x+11OtvoKVKrTUCqz0ZEqaQ4Yr0xstkhBU3WpX4xWD81fwLfj7jWEWMTgK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(47530400004)(451199009)(186003)(7416002)(41300700001)(2906002)(6506007)(53546011)(478600001)(71200400001)(82960400001)(7696005)(26005)(83380400001)(9686003)(55016003)(54906003)(5660300002)(76116006)(38100700002)(8936002)(921005)(33656002)(66556008)(10290500003)(66946007)(8676002)(4326008)(64756008)(6636002)(52536014)(110136005)(122000001)(8990500004)(316002)(82950400001)(66446008)(38070700005)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dytncXJXZlN1M1NpaUxieUZ1eGh2TWkzSTRuc3ZIOVMyN3ZIQk1hOFlYdkQv?=
 =?utf-8?B?djdEZmcrLy9zdEFyWFdlYTdBK3FXMmYvYmZCcmRnalRaWDREMUx1cGJ4WjFq?=
 =?utf-8?B?UnFZVXhwSVhxNjhFaC9sQVdON1ltVWorY0VPSThGMjJxOFVIMGtDWXMyWndw?=
 =?utf-8?B?UWFlazdPZHZzY3JLbnBMc1VXUnh5eFBrcUFFNVRQWkNMdjJSdHB6ZjM2TE9P?=
 =?utf-8?B?Qk8vclBHQy8yMEluazFvYkJFbzh0eGpEYzllbEJvYUhoT1JpaXZCckNCSnRa?=
 =?utf-8?B?RGpycWhDR1J5NGJiNHRJMlZwSDdYc0VZTktQUHVDTG8yNnhodm5UVkxobDZW?=
 =?utf-8?B?WWFMT05FN2dIMVR2bFhHdkpaZEJqekU4cXN0NU9EYS9oQ2hvdUhRRnZ4aW1G?=
 =?utf-8?B?NkpPd1dBWXEwVDhqQ1hVTngrM25td0ZlU0UzRTFvTVdNVWxWdytmNTZ4RjAz?=
 =?utf-8?B?TEhjVlFYN0prUVlBbjg4ZTkyNjB2dmVaNVlaSFQyUWc0dXRwcXN0UzM5cER6?=
 =?utf-8?B?Z0tEYWV0ME9IdHRNbWJOQlN2eWNHTlpCMWl1OXNCK2h1NGJQVENmNENXVnlv?=
 =?utf-8?B?Z2cweXMxelgzeW43REphdEhoNWgyb0VNbGRPR043ZEt1SnkvY0plZm03Z1NU?=
 =?utf-8?B?MHR5ZHpUcVZzK3hsWmZRNWNqVGJ0WG5rRDIzbDlBMjBMdmQrcGE1TXdxd3Bu?=
 =?utf-8?B?OUtzczFySXFoUTFIVFdhQnluakRLbDBhaENxcHlGS3lQSUdBSmxMaE9CamR2?=
 =?utf-8?B?WmdXY2RaNFJwbFhGS0U2eTIxOHpUem5LNFRxK1FheDM3OUZSRDVzb0p5U3NM?=
 =?utf-8?B?bFVDYlhPbk1wY2hzUUREMWc1aVZ4dVhnYi9BS1ZDUEROUDFkRWtXeGdzMG5k?=
 =?utf-8?B?NzhjWVQ2TjB0OVp5dW9aVlA0TXhYTlpNYURUTG1oRzZzYlBxLzEvL3hyWmg1?=
 =?utf-8?B?RGcvci9ITHZSZTVGdjI0TmdNMThWak9odDFybDlyVDFsV1dBemNBdzU3aERY?=
 =?utf-8?B?R2cwT0RUSFZYdmhjcHhHQmttTSs4QXE2bHhtZ0t2L3FWcU82ZnQxWlJ6NkVB?=
 =?utf-8?B?Mk5XQU1kbTNpQ1VpV3Y2OEJaM0d5Y2llSlU1Q0t2MzczTVQ4RTh2cGVKNWky?=
 =?utf-8?B?c3BrSCtkRVprRVRRRUMrVFRicjRWbWtiY2w0cXZlb05iVFpZNzQ4d29HNWhE?=
 =?utf-8?B?OXFiUVBPWWxjOGpZRmYyTzI5ZTFIZUlaNG1XQnYzNHRhTzVaelVIOUpYVmt6?=
 =?utf-8?B?UDhUbE5kZE5YdEoxMkpXdGJwczJsL1RyTVlnM2E4LytSc2hpeENLVFVjdHh3?=
 =?utf-8?B?SEVJSUcwVnJsOWM4c0JXTGVPaUM5QkJjZTJhY0hUdk9tSlhyQzZrcnk0bGd5?=
 =?utf-8?B?cTdJbk1UZzVnOXovS28xN2NZTkZ1b1M3UWhEbk0yZ3Z0UUJ2UkdVVForL1J0?=
 =?utf-8?B?WWRZNWR5YXAxRE5kdXBPZmZhUlVKQnZLU2wveHV5b1I2Tnowd3g3Zmp1Q0JN?=
 =?utf-8?B?eTRYTzhWSmlLSUtoRDlNam1mZFJFYzZCcE5BaW9rTDZXOFBtcXJuMkVuNTFx?=
 =?utf-8?B?NFZLd2R2Um9NTG85RlFURUdDcHBiMHJHcTczRTlpenZHK0ZoaHl4RHJBNE9o?=
 =?utf-8?B?OHV0T29URHA2Ni92MGNFVGZsMEN0bTkvVnBTWHZuY0FkejU4Ky96T3FqYkZI?=
 =?utf-8?B?aWJtTm5rWFNQRVpZSlR2YUVPSXd0VkQxK2lOcWJQUE9Yb2M3SjhFT2hnaENB?=
 =?utf-8?B?ZElmUXArcHhzNHdqWHNQMk1vTzQxK1ZvWHNzTzE4RVhTUGw0ejRQWFJlNjUr?=
 =?utf-8?B?MEhDdS8yUS9OY0hvMmpRaldDNDZSQlhoclN6dkJQOUk1TE9KODg3SHcvcWhU?=
 =?utf-8?B?OGZnNXdhUTU5S0RLUjVmdmZVZkc0d2RaZW9NYWdlWDY5Nnp0R2RTN3djWFdQ?=
 =?utf-8?B?Vk9KRmdtdU95eUNuUFZlWUxyV1NkOXdqYzdoem1sT29mbHFGUmJvL1Q3WDk3?=
 =?utf-8?B?eDJRc3NObUdRbWMrdGtxU2lrQTRvbGZjR29rbXYxTDdONjQ4QisydU94Ynhq?=
 =?utf-8?B?SHo2MnRydXNUMHFjWlNiWHBnSm9GNTM5QTZWL3BzS1I5V0QwajJkaURQZ0tH?=
 =?utf-8?Q?tk6AeYqFBG7RuebP3n6+ZeIsY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d209cd88-748b-40a1-342c-08da6b430bd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:01:33.1561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vOvqyVZHgcjR5RY9P/BifatgVrUqupyn5DWxY3RtFRtpn+nvo0LieKn9o/nGPsHvbIwsylUxlmR/PQrIsRCQwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB2062
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BhdGNoIHY0IDEyLzEyXSBSRE1BL21hbmFfaWI6IEFkZCBhIGRyaXZl
ciBmb3IgTWljcm9zb2Z0DQo+IEF6dXJlIE5ldHdvcmsgQWRhcHRlcg0KPiANCj4gDQo+IA0KPiBP
biA2LzE2LzIyIDEwOjA3IEFNLCBsb25nbGlAbGludXhvbmh5cGVydi5jb20gd3JvdGU6DQo+ID4g
RnJvbTogTG9uZyBMaSA8bG9uZ2xpQG1pY3Jvc29mdC5jb20+DQo+ID4NCj4gDQo+IDwuLi4+DQo+
IA0KPiA+ICsNCj4gPiArc3RhdGljIGludCBtYW5hX2liX2NyZWF0ZV9xcF9yYXcoc3RydWN0IGli
X3FwICppYnFwLCBzdHJ1Y3QgaWJfcGQgKmlicGQsDQo+ID4gKwkJCQkgc3RydWN0IGliX3FwX2lu
aXRfYXR0ciAqYXR0ciwNCj4gPiArCQkJCSBzdHJ1Y3QgaWJfdWRhdGEgKnVkYXRhKQ0KPiA+ICt7
DQo+ID4gKwlzdHJ1Y3QgbWFuYV9pYl9wZCAqcGQgPSBjb250YWluZXJfb2YoaWJwZCwgc3RydWN0
IG1hbmFfaWJfcGQsDQo+IGlicGQpOw0KPiA+ICsJc3RydWN0IG1hbmFfaWJfcXAgKnFwID0gY29u
dGFpbmVyX29mKGlicXAsIHN0cnVjdCBtYW5hX2liX3FwLA0KPiBpYnFwKTsNCj4gPiArCXN0cnVj
dCBtYW5hX2liX2RldiAqbWRldiA9DQo+ID4gKwkJY29udGFpbmVyX29mKGlicGQtPmRldmljZSwg
c3RydWN0IG1hbmFfaWJfZGV2LCBpYl9kZXYpOw0KPiA+ICsJc3RydWN0IG1hbmFfaWJfY3EgKnNl
bmRfY3EgPQ0KPiA+ICsJCWNvbnRhaW5lcl9vZihhdHRyLT5zZW5kX2NxLCBzdHJ1Y3QgbWFuYV9p
Yl9jcSwgaWJjcSk7DQo+ID4gKwlzdHJ1Y3QgaWJfdWNvbnRleHQgKmliX3Vjb250ZXh0ID0gaWJw
ZC0+dW9iamVjdC0+Y29udGV4dDsNCj4gPiArCXN0cnVjdCBtYW5hX2liX2NyZWF0ZV9xcF9yZXNw
IHJlc3AgPSB7fTsNCj4gPiArCXN0cnVjdCBtYW5hX2liX3Vjb250ZXh0ICptYW5hX3Vjb250ZXh0
Ow0KPiA+ICsJc3RydWN0IGdkbWFfZGV2ICpnZCA9IG1kZXYtPmdkbWFfZGV2Ow0KPiA+ICsJc3Ry
dWN0IG1hbmFfaWJfY3JlYXRlX3FwIHVjbWQgPSB7fTsNCj4gPiArCXN0cnVjdCBtYW5hX29ial9z
cGVjIHdxX3NwZWMgPSB7fTsNCj4gPiArCXN0cnVjdCBtYW5hX29ial9zcGVjIGNxX3NwZWMgPSB7
fTsNCj4gPiArCXN0cnVjdCBtYW5hX3BvcnRfY29udGV4dCAqbXBjOw0KPiA+ICsJc3RydWN0IG1h
bmFfY29udGV4dCAqbWM7DQo+ID4gKwlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldjsNCj4gPiArCXN0
cnVjdCBpYl91bWVtICp1bWVtOw0KPiA+ICsJaW50IGVycjsNCj4gPiArCXUzMiBwb3J0Ow0KPiA+
ICsNCj4gPiArCW1hbmFfdWNvbnRleHQgPQ0KPiA+ICsJCWNvbnRhaW5lcl9vZihpYl91Y29udGV4
dCwgc3RydWN0IG1hbmFfaWJfdWNvbnRleHQsDQo+IGlidWNvbnRleHQpOw0KPiA+ICsJbWMgPSBn
ZC0+ZHJpdmVyX2RhdGE7DQo+ID4gKw0KPiA+ICsJaWYgKHVkYXRhLT5pbmxlbiA8IHNpemVvZih1
Y21kKSkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKwllcnIgPSBpYl9jb3B5
X2Zyb21fdWRhdGEoJnVjbWQsIHVkYXRhLCBtaW4oc2l6ZW9mKHVjbWQpLCB1ZGF0YS0NCj4gPmlu
bGVuKSk7DQo+ID4gKwlpZiAoZXJyKSB7DQo+ID4gKwkJaWJkZXZfZGJnKCZtZGV2LT5pYl9kZXYs
DQo+ID4gKwkJCSAgIkZhaWxlZCB0byBjb3B5IGZyb20gdWRhdGEgY3JlYXRlIHFwLXJhdywgJWRc
biIsDQo+IGVycik7DQo+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJLyogSUIgcG9ydHMgc3RhcnQgd2l0aCAxLCBNQU5BIEV0aGVybmV0IHBvcnRzIHN0YXJ0IHdp
dGggMCAqLw0KPiA+ICsJcG9ydCA9IHVjbWQucG9ydDsNCj4gPiArCWlmICh1Y21kLnBvcnQgPiBt
Yy0+bnVtX3BvcnRzKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCWlmIChh
dHRyLT5jYXAubWF4X3NlbmRfd3IgPiBNQVhfU0VORF9CVUZGRVJTX1BFUl9RVUVVRSkgew0KPiA+
ICsJCWliZGV2X2RiZygmbWRldi0+aWJfZGV2LA0KPiA+ICsJCQkgICJSZXF1ZXN0ZWQgbWF4X3Nl
bmRfd3IgJWQgZXhjZWVkaW5nIGxpbWl0XG4iLA0KPiA+ICsJCQkgIGF0dHItPmNhcC5tYXhfc2Vu
ZF93cik7DQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYg
KGF0dHItPmNhcC5tYXhfc2VuZF9zZ2UgPiBNQVhfVFhfV1FFX1NHTF9FTlRSSUVTKSB7DQo+ID4g
KwkJaWJkZXZfZGJnKCZtZGV2LT5pYl9kZXYsDQo+ID4gKwkJCSAgIlJlcXVlc3RlZCBtYXhfc2Vu
ZF9zZ2UgJWQgZXhjZWVkaW5nIGxpbWl0XG4iLA0KPiA+ICsJCQkgIGF0dHItPmNhcC5tYXhfc2Vu
ZF9zZ2UpOw0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCW5k
ZXYgPSBtYy0+cG9ydHNbcG9ydCAtIDFdOw0KPiA+ICsJbXBjID0gbmV0ZGV2X3ByaXYobmRldik7
DQo+ID4gKwlpYmRldl9kYmcoJm1kZXYtPmliX2RldiwgInBvcnQgJXUgbmRldiAlcCBtcGMgJXBc
biIsIHBvcnQsDQo+IG5kZXYsIG1wYyk7DQo+ID4gKw0KPiA+ICsJZXJyID0gbWFuYV9pYl9jZmdf
dnBvcnQobWRldiwgcG9ydCAtIDEsIHBkLCBtYW5hX3Vjb250ZXh0LQ0KPiA+ZG9vcmJlbGwpOw0K
PiA+ICsJaWYgKGVycikNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlxcC0+
cG9ydCA9IHBvcnQ7DQo+ID4gKw0KPiA+ICsJaWJkZXZfZGJnKCZtZGV2LT5pYl9kZXYsICJ1Y21k
IHNxX2J1Zl9hZGRyIDB4JWxseCBwb3J0ICV1XG4iLA0KPiA+ICsJCSAgdWNtZC5zcV9idWZfYWRk
ciwgdWNtZC5wb3J0KTsNCj4gPiArDQo+ID4gKwl1bWVtID0gaWJfdW1lbV9nZXQoaWJwZC0+ZGV2
aWNlLCB1Y21kLnNxX2J1Zl9hZGRyLA0KPiB1Y21kLnNxX2J1Zl9zaXplLA0KPiA+ICsJCQkgICBJ
Ql9BQ0NFU1NfTE9DQUxfV1JJVEUpOw0KPiA+ICsJaWYgKElTX0VSUih1bWVtKSkgew0KPiA+ICsJ
CWVyciA9IFBUUl9FUlIodW1lbSk7DQo+ID4gKwkJaWJkZXZfZGJnKCZtZGV2LT5pYl9kZXYsDQo+
ID4gKwkJCSAgIkZhaWxlZCB0byBnZXQgdW1lbSBmb3IgY3JlYXRlIHFwLXJhdywgZXJyICVkXG4i
LA0KPiA+ICsJCQkgIGVycik7DQo+ID4gKwkJZ290byBlcnJfZnJlZV92cG9ydDsNCj4gPiArCX0N
Cj4gPiArCXFwLT5zcV91bWVtID0gdW1lbTsNCj4gPiArDQo+ID4gKwllcnIgPSBtYW5hX2liX2dk
X2NyZWF0ZV9kbWFfcmVnaW9uKG1kZXYsIHFwLT5zcV91bWVtLA0KPiA+ICsJCQkJCSAgICZxcC0+
c3FfZ2RtYV9yZWdpb24sIFBBR0VfU0laRSk7DQo+ID4gKwlpZiAoZXJyKSB7DQo+ID4gKwkJaWJk
ZXZfZXJyKCZtZGV2LT5pYl9kZXYsDQo+ID4gKwkJCSAgIkZhaWxlZCB0byBjcmVhdGUgZG1hIHJl
Z2lvbiBmb3IgY3JlYXRlIHFwLQ0KPiByYXcsICVkXG4iLA0KPiA+ICsJCQkgIGVycik7DQo+IA0K
PiBJdCBpcyBiZXR0ZXIgbm90IHByaW50IGluIHVzZXJzcGFjZS10cmlnZ2VyZWQgcGF0aHMuDQo+
IA0KPiBUaGVyZSBhcmUgYWxzbyBzYW1lIGlzc3VlcyBpbiBvdGhlciBwYXRocy4NCj4gDQo+IFRo
YW5rcywNCj4gQ2hlbmcgWHUNCg0KDQpUaGFuayB5b3UsIEkgd2lsbCBzY2FuIHRoZSBjb2RlIGFu
ZCBtYWtlIHN1cmUgdXNlci1tb2RlIGNhbid0IGZsb29kIGVycm9yIG1lc3NhZ2VzLg0KDQpUaGlz
IGVycm9yIGlzIGEgaGFyZHdhcmUvUEYgZXJyb3IuIEl0IG1lYW5zIHRoZSBoYXJkd2FyZSBjaGFu
bmVsIGhhcyBmYXVsdGVkLiBJdCdzIGxvZ2dlZCBhdCBlcnJvciBsZXZlbC4NCg0KTG9uZw0K
