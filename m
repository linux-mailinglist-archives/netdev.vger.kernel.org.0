Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2382F365077
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhDTCtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:49:02 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:49326 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhDTCtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:49:00 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AEE07C0080;
        Tue, 20 Apr 2021 02:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618886910; bh=qUAQP+IGrGdZp0YA+E2JQQ+xs1dUfAdn6QvpZjqfK2o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=jAt+h+uwzj3Qc0I5b/CfO4CqwhoDdPqf/fW1vkLKbIyl+nF54GNdJI2TwAje68eNX
         ze/DSIQvgv/PnVjBGOoMx0WmhM1JeXGDebND6AJGfTraa/8o3F4LSf/u9u4iQJYTQf
         iU36VyI1LIKdGkVpXH+zf8bTov4U5CAiEChAMk7RmTXV3tHhroySpcBDaV5YLKoBGM
         +jCVzSh3FW08oz7jVtRml6zBr8TKh8Pnej6N5gf/sAQdfAJAHZv5Y4PVoS3pe4dQcB
         ZttN1M25DwzQ9GxCeL0hRq7mrTzCN+JtMyrBux3oismNFN3qjw4yKViCjqLCu6+As2
         vmpJZ1iN/RoOA==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5A85AA0096;
        Tue, 20 Apr 2021 02:48:23 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C88E04009A;
        Tue, 20 Apr 2021 02:48:20 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Q4RCQFRY";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzVLhOq1G7swHWFHB+GNE4jXIZjVUI0fk8tazUbFmlnBN7pVtS93bxxOF7+J8TmJ0AGgnKFA0124DPQUdhvaxO2JH8cbsB3OSinKrm39hQ8GnmG/ZxE7geb3nXv2GCFkI4s/XOxUVrnOe6ZXXTblLcC2tmNqsGFufuizBqJQfelnK8KJWZWQwVtxiudtCTT/YT9gZIzGjwLGGiIBRNaksxXfCtL2e51d8iT4Dy+Wnj0FAjF8EReeldP42ylWrAEgWZIJ1CPX4BhKSJNLvBtB848CtQYWSDmvFUBfXD0GuuQGLwGmAHzPQ9D5Z3wVsga5JGl/7WXAob7DCoE+lU5eUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUAQP+IGrGdZp0YA+E2JQQ+xs1dUfAdn6QvpZjqfK2o=;
 b=Xjjhxg8ASS3Xsa9iFjmP5eaig8AU7UFOqEg3ZdWot+cwt/jAiv9UtpjkMdGkJTOwfnh+5s52pXkIer9TF7hL8wcMrORUFeJ1tIKNeEU2VwZoIsBUqxDzHZAttpEt9IgDNOViUpKOdS9sGZIbt8+S00pcWPhYxN/cHj9h++13+Gb4XxIQjbaiyL7BdnQHB5hwi1WuOeUmfQQOFNF/mQCmvNBDkCEnTPT01CN0ZyRPTO1y9IRaqzXP/c3hxirjHRhQ7/vN83Qn2Q5OoUQanX/DMhtRAUFCPV8j5/NfyHelJsMf0X/N9IgiVGQx458Y2nat8eE/IeG9bUjaEdb1loLSdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUAQP+IGrGdZp0YA+E2JQQ+xs1dUfAdn6QvpZjqfK2o=;
 b=Q4RCQFRYvLoPAJY0k4dhNg5HIeqpZuUipyR56fvdXtxiqkBsJavn4e1vSf3wbHNMkE3mdAQ9ZkFHG/X5M0KWQp66f3rnTwv4DmV3QGxdyZsKBTIsnY8dR9aPN1P63p0qidt3P4sVNePAV86BYMgVSpxqYYVRyc4P5VqfNBMjflA=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BYAPR12MB4982.namprd12.prod.outlook.com (2603:10b6:a03:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Tue, 20 Apr
 2021 02:48:18 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::88a:1041:81ed:982]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::88a:1041:81ed:982%7]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:48:18 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "arnd@kernel.org" <arnd@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXMxVijWO/awtGlkiVwcCofC+50Kq4AUEAgAS3z4A=
Date:   Tue, 20 Apr 2021 02:48:17 +0000
Message-ID: <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
In-Reply-To: <20210417024522.GP2531743@casper.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [24.4.73.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae4a7ca5-bbfb-496c-d44b-08d903a6c09c
x-ms-traffictypediagnostic: BYAPR12MB4982:
x-microsoft-antispam-prvs: <BYAPR12MB498243392B89A28882FE3071B6489@BYAPR12MB4982.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HgwXo2HX2pqA9pAHhYTMJVVDJaASZ9sfGYdBkwlxzuarA/FxzHKP2IE7n0T3LQRrjqhwcXOqFc43I96ZtybhZ7zei9fs8OxN1rrdWQxBqmzF5it4KXKdxqddq4Sbv7TdSGCSrKlxPfkpdZtOrukICFc42tm6AgBhER4Wel28hA5gr3bYanZoKkglQ3RPwNmLWOIwBhFSL/9Cv8UHYCrETljQckq4aW43Qben3SkeAEilmWT9oI17cYvgzoSCq8QCqaiWyFV9WD3wAhXuw2uOUsD78ViBUYUAQ4uQLToddwku1KoqTCs2/8ZElYEyfo4w2W3xSN7LfSQpYBJdY0s4h5bb2bLT9JFXZSLMt1nXvFNQ7tualty+MesrrM+xj53QFl96oFu3ysuSpsnHizHK1eBiVaPqe6FGqr2peDE4lDQ+2pzHbrK+/BA7lVyCm5XODpyd7DvvrR7HcvR8EBTr2wLJVSs6hXA+OfuV6XKghtwt3Gqd/582EC03TePdA7+/svbsnQHi053Re9R6CDVUNaBEjyY3wP/uhvtCm4szhD8ngnZXUPhik/7J9pjKYRcGUqBHsNhfuxAxNCTp3qqc18ff687X74ijBqvMSO7fO3f8rAWNwB8FYwmihvhQI2ADd3m+b3SdEJOvhTde5EjQ1CTl8qkwdYOBp7D7nfFO52XZ3SjPktCJNpmAYhuvqWou
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(366004)(376002)(66476007)(66946007)(64756008)(31686004)(66446008)(66556008)(2616005)(53546011)(36756003)(6506007)(76116006)(8676002)(186003)(8936002)(83380400001)(26005)(6486002)(110136005)(7416002)(6512007)(316002)(54906003)(478600001)(5660300002)(122000001)(38100700002)(4326008)(71200400001)(2906002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dmVPMTd2N2ZQWnppMkcreFJzTVlHZ2tDNnIwT202bk9aQm5tUGxKL3B3WE83?=
 =?utf-8?B?cWlPK0NzZzFyYU5tUUNkTWRhSjJRd3QwbnMxU1dDMDM2WEtZSmliNVcvZlND?=
 =?utf-8?B?Ky95UkVzdG1yQ2NQU3U4cUQyQVQvdXRubDlKS2Q4Z2N2ZG1KajhBc2JZdDVi?=
 =?utf-8?B?Vm1TZkRWQ21sRGRnYzVKMXV0Umk5T2RMaEUrL2NTbnl2VnhkTUdWTElyWHQ2?=
 =?utf-8?B?d3RmYWNHcFRYa0VGd1U4RmUzKzI0NXVZMmtNdTNzTnNnanJXVkJzWlc0NFZy?=
 =?utf-8?B?VDNiYVZqYzdidUlDZVNrNHpyRVFQSk1rTGwyR0Z0aGFVZHhDWHM0SXdyMGdy?=
 =?utf-8?B?VHJEbTBJaEsvck90T3FyL21XcUlMQjU3RG1KRGtyb29IV2VINDRSM1k5ZzFn?=
 =?utf-8?B?MncrRXRPYTVEQ0dxL0xXQzhZQVlpYU15UG9jT0psU1FGUUwraHhPVkFURWpq?=
 =?utf-8?B?V0xZdEIzSy9vOHpZbWtrQjJrZlFxNklVNEhXWkxFS1RCaGlPUzB4OG8xbGhz?=
 =?utf-8?B?azlBZi9JeFdaVm1iTnRyS1ROa0kvWi9BcmJCWjh5b2dGbmRwTmlvT3EyTkQz?=
 =?utf-8?B?bkZoeFo4SG1KTkFlVVhVQ0tnQ25sSG9SN21hZDdGNHE1SG1iYm1Na3ZOSzV6?=
 =?utf-8?B?TjBFMGF3Ti8rbStWTmJVWUVibWhDR2xCWXN1cUUxdEczdTZpZWNxK21XUWxa?=
 =?utf-8?B?a3J5WUJ6TFI4MGcyc214SGtFZVlySmlOa0I0M1Y2TERrSTNCeldXcitUM2c0?=
 =?utf-8?B?cU1VeFE2NGtjZ3JJZVFZNWFUd0MxcXFGTWFCYkVaYnJUalNGWDVxWkE4Sks5?=
 =?utf-8?B?OFZnRE5pajdTcGRqYnpHWDI5Q2dNcEVSMVhQWUF4K0djOWYyNWFrWEQwYTRN?=
 =?utf-8?B?WE9wNEdqc1RFUDhkMytsZXUwbW1iQkFGTFlDOUVDVnMrSjRyME1WT0EzSVY2?=
 =?utf-8?B?Tk9aS2dTS2VWT0taeER5ekZyb1YwK2xDWnhYK1plUkpiUGxDZVFadEdDQmVh?=
 =?utf-8?B?bjFZVytCS0hxa1NhN2xWN01naGFiK1d3dkw4QWZoTUNMOXFLTmRlcHFVQThn?=
 =?utf-8?B?amE2aHhnZHkwN0VPSWgyWUtndDFZV3FaY291OGhnS2VRU0twOVpVSGQ5Q1A2?=
 =?utf-8?B?OUozVnNObm9FQi9URjNoWm9vUlVQRkRSTzl4R3hEL1h0R1VMcDBubmFBckZC?=
 =?utf-8?B?WDU1b2Z6TTR4eDVCRGZMTVhBNFhQOXl5SW1meTBKamhMMDRFSUJ2cDlQNXhU?=
 =?utf-8?B?QTFvQ2hGZ2NVbk1nUnp4VGFIYTFQRTJHV2NnQzJNa0dIR2wzcDVOUGtwNG8v?=
 =?utf-8?B?NlFRS1V2ZkM2N3hNK1hsVmlVcDVXWGNQajRHQVo5amJLZmN4dEpIOEVSV2Ny?=
 =?utf-8?B?UGsvZWI2TEl6a3VWNG50ZWI4S3ZKRkEwWnJCTU5iZE5Ddnp4SWRIREh3RXhI?=
 =?utf-8?B?YWVqR21NZFVqNTN4ZzhGK29lYXB5QVVLdlo2QXJYQkhCWFJzRHFiWm9XUk12?=
 =?utf-8?B?UkJOblAwVHBkR0V0T2x4Z01kSW9aL3VlbUI0Nzlxa1lUQ3kzTG9GNHhKN0F6?=
 =?utf-8?B?cDkwb0ZYYkFtVWZWUFlzZEJ4aGhCSkRlbzV1N0tORjB6eHdQUklTQlJJa1pN?=
 =?utf-8?B?UWw3Q2xFUnNERXlCRzJ5dlZLOWRxUGxSMVpDemR6ZUsrWXhFNDRQZGN2ME1C?=
 =?utf-8?B?VkoxNldmWVNrRlQrR3QrQW01VHAwUk5yeXpUNVM1bi9vZTFXUHhiWG9nOENX?=
 =?utf-8?Q?LgoZTf9Z1d4IaxtQ7Y=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BDBF6EFD3284647AECFC870F7B57F29@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4a7ca5-bbfb-496c-d44b-08d903a6c09c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 02:48:17.9954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sSIHKpZAMSbnlRcpRRWTq7fVCDb0jABv8dUhZuXm/OzEtRDgUG5Kz47UksNzMNEPkTPgwzM/eLTm/wntBwD2cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4982
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0dGhldywNCg0KT24gNC8xNi8yMSA3OjQ1IFBNLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gUmVwbGFjZW1lbnQgcGF0Y2ggdG8gZml4IGNvbXBpbGVyIHdhcm5pbmcuDQo+DQo+IEZyb206
ICJNYXR0aGV3IFdpbGNveCAoT3JhY2xlKSIgPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+IERhdGU6
IEZyaSwgMTYgQXByIDIwMjEgMTY6MzQ6NTUgLTA0MDANCj4gU3ViamVjdDogW1BBVENIIDEvMl0g
bW06IEZpeCBzdHJ1Y3QgcGFnZSBsYXlvdXQgb24gMzItYml0IHN5c3RlbXMNCj4gVG86IGJyb3Vl
ckByZWRoYXQuY29tDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnLA0KPiAgICAg
IGxpbnV4LW1tQGt2YWNrLm9yZywNCj4gICAgICBuZXRkZXZAdmdlci5rZXJuZWwub3JnLA0KPiAg
ICAgIGxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnLA0KPiAgICAgIGxpbnV4LWFybS1rZXJu
ZWxAbGlzdHMuaW5mcmFkZWFkLm9yZywNCj4gICAgICBsaW51eC1taXBzQHZnZXIua2VybmVsLm9y
ZywNCj4gICAgICBpbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmcsDQo+ICAgICAgbWNyb2NlQGxp
bnV4Lm1pY3Jvc29mdC5jb20sDQo+ICAgICAgZ3J5Z29yaWkuc3RyYXNoa29AdGkuY29tLA0KPiAg
ICAgIGFybmRAa2VybmVsLm9yZywNCj4gICAgICBoY2hAbHN0LmRlLA0KPiAgICAgIGxpbnV4LXNu
cHMtYXJjQGxpc3RzLmluZnJhZGVhZC5vcmcsDQo+ICAgICAgbWhvY2tvQGtlcm5lbC5vcmcsDQo+
ICAgICAgbWdvcm1hbkBzdXNlLmRlDQo+DQo+IDMyLWJpdCBhcmNoaXRlY3R1cmVzIHdoaWNoIGV4
cGVjdCA4LWJ5dGUgYWxpZ25tZW50IGZvciA4LWJ5dGUgaW50ZWdlcnMNCj4gYW5kIG5lZWQgNjQt
Yml0IERNQSBhZGRyZXNzZXMgKGFyYywgYXJtLCBtaXBzLCBwcGMpIGhhZCB0aGVpciBzdHJ1Y3QN
Cj4gcGFnZSBpbmFkdmVydGVudGx5IGV4cGFuZGVkIGluIDIwMTkuDQoNCkZXSVcsIEFSQyBkb2Vz
bid0IHJlcXVpcmUgOCBieXRlIGFsaWdubWVudCBmb3IgOCBieXRlIGludGVnZXJzLiBUaGlzIGlz
IA0Kb25seSBuZWVkZWQgZm9yIDgtYnl0ZSBhdG9taWNzIGR1ZSB0byB0aGUgcmVxdWlyZW1lbnRz
IG9mIExMT0NLRC9TQ09ORCANCmluc3RydWN0aW9ucy4NCg0KPiBXaGVuIHRoZSBkbWFfYWRkcl90
IHdhcyBhZGRlZCwNCj4gaXQgZm9yY2VkIHRoZSBhbGlnbm1lbnQgb2YgdGhlIHVuaW9uIHRvIDgg
Ynl0ZXMsIHdoaWNoIGluc2VydGVkIGEgNCBieXRlDQo+IGdhcCBiZXR3ZWVuICdmbGFncycgYW5k
IHRoZSB1bmlvbi4NCj4NCj4gRml4IHRoaXMgYnkgc3RvcmluZyB0aGUgZG1hX2FkZHJfdCBpbiBv
bmUgb3IgdHdvIGFkamFjZW50IHVuc2lnbmVkIGxvbmdzLg0KPiBUaGlzIHJlc3RvcmVzIHRoZSBh
bGlnbm1lbnQgdG8gdGhhdCBvZiBhbiB1bnNpZ25lZCBsb25nLCBhbmQgYWxzbyBmaXhlcyBhDQo+
IHBvdGVudGlhbCBwcm9ibGVtIHdoZXJlIChvbiBhIGJpZyBlbmRpYW4gcGxhdGZvcm0pLCB0aGUg
Yml0IHVzZWQgdG8gZGVub3RlDQo+IFBhZ2VUYWlsIGNvdWxkIGluYWR2ZXJ0ZW50bHkgZ2V0IHNl
dCwgYW5kIGEgcmFjaW5nIGdldF91c2VyX3BhZ2VzX2Zhc3QoKQ0KPiBjb3VsZCBkZXJlZmVyZW5j
ZSBhIGJvZ3VzIGNvbXBvdW5kX2hlYWQoKS4NCj4NCj4gRml4ZXM6IGMyNWZmZjcxNzFiZSAoIm1t
OiBhZGQgZG1hX2FkZHJfdCB0byBzdHJ1Y3QgcGFnZSIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hdHRo
ZXcgV2lsY294IChPcmFjbGUpIDx3aWxseUBpbmZyYWRlYWQub3JnPg0KPiAtLS0NCj4gICBpbmNs
dWRlL2xpbnV4L21tX3R5cGVzLmggfCAgNCArKy0tDQo+ICAgaW5jbHVkZS9uZXQvcGFnZV9wb29s
LmggIHwgMTIgKysrKysrKysrKystDQo+ICAgbmV0L2NvcmUvcGFnZV9wb29sLmMgICAgIHwgMTIg
KysrKysrKy0tLS0tDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbV90eXBlcy5oIGIv
aW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQo+IGluZGV4IDY2MTNiMjZhODg5NC4uNWFhY2MxYzEw
YTQ1IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L21tX3R5cGVzLmgNCj4gKysrIGIvaW5j
bHVkZS9saW51eC9tbV90eXBlcy5oDQo+IEBAIC05NywxMCArOTcsMTAgQEAgc3RydWN0IHBhZ2Ug
ew0KPiAgIAkJfTsNCj4gICAJCXN0cnVjdCB7CS8qIHBhZ2VfcG9vbCB1c2VkIGJ5IG5ldHN0YWNr
ICovDQo+ICAgCQkJLyoqDQo+IC0JCQkgKiBAZG1hX2FkZHI6IG1pZ2h0IHJlcXVpcmUgYSA2NC1i
aXQgdmFsdWUgZXZlbiBvbg0KPiArCQkJICogQGRtYV9hZGRyOiBtaWdodCByZXF1aXJlIGEgNjQt
Yml0IHZhbHVlIG9uDQo+ICAgCQkJICogMzItYml0IGFyY2hpdGVjdHVyZXMuDQo+ICAgCQkJICov
DQo+IC0JCQlkbWFfYWRkcl90IGRtYV9hZGRyOw0KPiArCQkJdW5zaWduZWQgbG9uZyBkbWFfYWRk
clsyXTsNCj4gICAJCX07DQo+ICAgCQlzdHJ1Y3QgewkvKiBzbGFiLCBzbG9iIGFuZCBzbHViICov
DQo+ICAgCQkJdW5pb24gew0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvcGFnZV9wb29sLmgg
Yi9pbmNsdWRlL25ldC9wYWdlX3Bvb2wuaA0KPiBpbmRleCBiNWIxOTUzMDUzNDYuLmFkNjE1NGRj
MjA2YyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9uZXQvcGFnZV9wb29sLmgNCj4gKysrIGIvaW5j
bHVkZS9uZXQvcGFnZV9wb29sLmgNCj4gQEAgLTE5OCw3ICsxOTgsMTcgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIHBhZ2VfcG9vbF9yZWN5Y2xlX2RpcmVjdChzdHJ1Y3QgcGFnZV9wb29sICpwb29sLA0K
PiAgIA0KPiAgIHN0YXRpYyBpbmxpbmUgZG1hX2FkZHJfdCBwYWdlX3Bvb2xfZ2V0X2RtYV9hZGRy
KHN0cnVjdCBwYWdlICpwYWdlKQ0KPiAgIHsNCj4gLQlyZXR1cm4gcGFnZS0+ZG1hX2FkZHI7DQo+
ICsJZG1hX2FkZHJfdCByZXQgPSBwYWdlLT5kbWFfYWRkclswXTsNCj4gKwlpZiAoc2l6ZW9mKGRt
YV9hZGRyX3QpID4gc2l6ZW9mKHVuc2lnbmVkIGxvbmcpKQ0KPiArCQlyZXQgfD0gKGRtYV9hZGRy
X3QpcGFnZS0+ZG1hX2FkZHJbMV0gPDwgMTYgPDwgMTY7DQo+ICsJcmV0dXJuIHJldDsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIGlubGluZSB2b2lkIHBhZ2VfcG9vbF9zZXRfZG1hX2FkZHIoc3RydWN0
IHBhZ2UgKnBhZ2UsIGRtYV9hZGRyX3QgYWRkcikNCj4gK3sNCj4gKwlwYWdlLT5kbWFfYWRkclsw
XSA9IGFkZHI7DQo+ICsJaWYgKHNpemVvZihkbWFfYWRkcl90KSA+IHNpemVvZih1bnNpZ25lZCBs
b25nKSkNCj4gKwkJcGFnZS0+ZG1hX2FkZHJbMV0gPSBhZGRyID4+IDE2ID4+IDE2Ow0KPiAgIH0N
Cj4gICANCj4gICBzdGF0aWMgaW5saW5lIGJvb2wgaXNfcGFnZV9wb29sX2NvbXBpbGVkX2luKHZv
aWQpDQo+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9jb3JlL3BhZ2Vf
cG9vbC5jDQo+IGluZGV4IGFkOGIwNzA3YWYwNC4uZjAxNGZkOGMxOWE2IDEwMDY0NA0KPiAtLS0g
YS9uZXQvY29yZS9wYWdlX3Bvb2wuYw0KPiArKysgYi9uZXQvY29yZS9wYWdlX3Bvb2wuYw0KPiBA
QCAtMTc0LDggKzE3NCwxMCBAQCBzdGF0aWMgdm9pZCBwYWdlX3Bvb2xfZG1hX3N5bmNfZm9yX2Rl
dmljZShzdHJ1Y3QgcGFnZV9wb29sICpwb29sLA0KPiAgIAkJCQkJICBzdHJ1Y3QgcGFnZSAqcGFn
ZSwNCj4gICAJCQkJCSAgdW5zaWduZWQgaW50IGRtYV9zeW5jX3NpemUpDQo+ICAgew0KPiArCWRt
YV9hZGRyX3QgZG1hX2FkZHIgPSBwYWdlX3Bvb2xfZ2V0X2RtYV9hZGRyKHBhZ2UpOw0KPiArDQo+
ICAgCWRtYV9zeW5jX3NpemUgPSBtaW4oZG1hX3N5bmNfc2l6ZSwgcG9vbC0+cC5tYXhfbGVuKTsN
Cj4gLQlkbWFfc3luY19zaW5nbGVfcmFuZ2VfZm9yX2RldmljZShwb29sLT5wLmRldiwgcGFnZS0+
ZG1hX2FkZHIsDQo+ICsJZG1hX3N5bmNfc2luZ2xlX3JhbmdlX2Zvcl9kZXZpY2UocG9vbC0+cC5k
ZXYsIGRtYV9hZGRyLA0KPiAgIAkJCQkJIHBvb2wtPnAub2Zmc2V0LCBkbWFfc3luY19zaXplLA0K
PiAgIAkJCQkJIHBvb2wtPnAuZG1hX2Rpcik7DQo+ICAgfQ0KPiBAQCAtMjI2LDcgKzIyOCw3IEBA
IHN0YXRpYyBzdHJ1Y3QgcGFnZSAqX19wYWdlX3Bvb2xfYWxsb2NfcGFnZXNfc2xvdyhzdHJ1Y3Qg
cGFnZV9wb29sICpwb29sLA0KPiAgIAkJcHV0X3BhZ2UocGFnZSk7DQo+ICAgCQlyZXR1cm4gTlVM
TDsNCj4gICAJfQ0KPiAtCXBhZ2UtPmRtYV9hZGRyID0gZG1hOw0KPiArCXBhZ2VfcG9vbF9zZXRf
ZG1hX2FkZHIocGFnZSwgZG1hKTsNCj4gICANCj4gICAJaWYgKHBvb2wtPnAuZmxhZ3MgJiBQUF9G
TEFHX0RNQV9TWU5DX0RFVikNCj4gICAJCXBhZ2VfcG9vbF9kbWFfc3luY19mb3JfZGV2aWNlKHBv
b2wsIHBhZ2UsIHBvb2wtPnAubWF4X2xlbik7DQo+IEBAIC0yOTQsMTMgKzI5NiwxMyBAQCB2b2lk
IHBhZ2VfcG9vbF9yZWxlYXNlX3BhZ2Uoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwgc3RydWN0IHBh
Z2UgKnBhZ2UpDQo+ICAgCQkgKi8NCj4gICAJCWdvdG8gc2tpcF9kbWFfdW5tYXA7DQo+ICAgDQo+
IC0JZG1hID0gcGFnZS0+ZG1hX2FkZHI7DQo+ICsJZG1hID0gcGFnZV9wb29sX2dldF9kbWFfYWRk
cihwYWdlKTsNCj4gICANCj4gLQkvKiBXaGVuIHBhZ2UgaXMgdW5tYXBwZWQsIGl0IGNhbm5vdCBi
ZSByZXR1cm5lZCBvdXIgcG9vbCAqLw0KPiArCS8qIFdoZW4gcGFnZSBpcyB1bm1hcHBlZCwgaXQg
Y2Fubm90IGJlIHJldHVybmVkIHRvIG91ciBwb29sICovDQo+ICAgCWRtYV91bm1hcF9wYWdlX2F0
dHJzKHBvb2wtPnAuZGV2LCBkbWEsDQo+ICAgCQkJICAgICBQQUdFX1NJWkUgPDwgcG9vbC0+cC5v
cmRlciwgcG9vbC0+cC5kbWFfZGlyLA0KPiAgIAkJCSAgICAgRE1BX0FUVFJfU0tJUF9DUFVfU1lO
Qyk7DQo+IC0JcGFnZS0+ZG1hX2FkZHIgPSAwOw0KPiArCXBhZ2VfcG9vbF9zZXRfZG1hX2FkZHIo
cGFnZSwgMCk7DQo+ICAgc2tpcF9kbWFfdW5tYXA6DQo+ICAgCS8qIFRoaXMgbWF5IGJlIHRoZSBs
YXN0IHBhZ2UgcmV0dXJuZWQsIHJlbGVhc2luZyB0aGUgcG9vbCwgc28NCj4gICAJICogaXQgaXMg
bm90IHNhZmUgdG8gcmVmZXJlbmNlIHBvb2wgYWZ0ZXJ3YXJkcy4NCg0K
