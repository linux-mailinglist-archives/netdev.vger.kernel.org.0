Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F58E429A56
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhJLATk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:19:40 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:38284 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhJLATj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 20:19:39 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BMM8BY031499;
        Mon, 11 Oct 2021 17:17:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=vqy9XWJxPt6Rqs4/m8i7emVKjU9P+wGBsjuAuW0aEhQ=;
 b=XkDLdMGPtAFE5RP1+PBrCfbZq3fPtjAT6zkXeL966zX5iFXx3vlVyOdiJK2a1P290TPz
 CKzTSNnJlsIz/1L8qFJyWYFDy/CHN39NKINF4Y6LMKN/D8Ng1psF1+uboAoZBCwUobsg
 dY4xdk3rbZ7x50cM9WdCxK85f2nCImB40FvM6YxH7p5/SU9/HoBwEBIyHhrwmwLctLCg
 3lh4HYQs6qN/ynIOHnkCd8svq5OykSx6AL/oIktL74GLuJpxvqK38CoS5su6d9A6NPhz
 45z30wWZYw1xmoDSh0JW0OKEDocX961PuV24VoVCQZheT+7ofNZBJREkw5Y6uyxJIyY/ lw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3bmfwh9u6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 17:17:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb0z9R+A64UNiP21WGDSRAi0pOCJblXdpmTbIei/tU/rD5QxnGJat9y6h0ZdHiZ5wt4c05LRUTXqJQ0FN5Jdp1rs3eyWVx5PBthQpvv5uzVu9N8nNqOKhHJLOqMlybo95k6yI80eWu0ZDthaVjhIyQbNngi8hKChPKHu5U/P5ZipI0x1CjBp+0Dh3sJzzina/7YuqaHLvqF8l2VRgfET1jMQdY9RMNZ6dDISAtOWmSd+qt0nwvlk/5EboFc4y2i+fY/O9tb2rd1X8NY8ghyZzudKDg+IdmZxgB135g9DZDlKus7lw76Cq1PcPsbEaTCjVr5uy5ZTYk6RqdParEdFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqy9XWJxPt6Rqs4/m8i7emVKjU9P+wGBsjuAuW0aEhQ=;
 b=OwFgUMgMNTQpbClzxWjuBrduERDJj1oy7BfbqdgGhIiYrnlwP+TeQ/5JuP590oYJANW22GxOcqlVS6yjbDFCx9klN4Jgz5T+NlE6taBO4pWxU34HbAKaELK+vUOp81v59frBK/uuK0pnnZloHirkE8grCnAysF+ciM1bSWZnH9lwSGm8RlVZgmYItJWKsBX95ZuvXd6h2jKxrymXk9i7lGOQtcqYzZV3tGOWwbQVCnEmdWDfy2TgO4j9L1Svzj+jepEKttXLF/QruxPv5K7Y2kfVQ3cKMZuLvNUnjxfhep1w0d1Yuy+ZGescUnDWqz+/wi2w24fjmKsWZQcy72xiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB6491.namprd02.prod.outlook.com (2603:10b6:610:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 00:17:08 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::248e:65ee:70de:c8e3]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::248e:65ee:70de:c8e3%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 00:17:08 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] sctp: account stream padding length for reconf chunk
Thread-Topic: [PATCH] sctp: account stream padding length for reconf chunk
Thread-Index: AQHXvmtAcwf44jdQsE++hRMBxSCuUqvNxzGAgAC484A=
Date:   Tue, 12 Oct 2021 00:17:08 +0000
Message-ID: <A3FC3A11-C149-4527-84A2-541E951B7A86@nutanix.com>
References: <YWPc8Stn3iBBNh80@kroah.com> <YWQ43VyG8bF2gvF7@t14s.localdomain>
In-Reply-To: <YWQ43VyG8bF2gvF7@t14s.localdomain>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74414a01-2ee4-48f4-5cdc-08d98d15a107
x-ms-traffictypediagnostic: CH2PR02MB6491:
x-microsoft-antispam-prvs: <CH2PR02MB6491D99FFA6887B73B3B888280B69@CH2PR02MB6491.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kvC1xFx6LsplgeVewyebIL6h6A5gNbV27sVgWj5/JCQre/vpnLNiG5MSlsdv3m/4ElQPSsqlj0WtjCs040ktbaNBqPN1hlQ+1RovqbEs78dy0MiKynqpguyDwD40yK/YtNSLFHyc93zhvKzCO8o5WsktgCP8E9zzS9CN6/sW+3K4N0KZ/EY+GH/N8qLKg7OLWp8eQ6lumNX0goaclQrva37yd2hF6vJ54RtEMyuQC1G5TUO/S2C4Mu9dfQlB9OrH97Z1YVkmrjR84lHVvimqWIVC/SRi/mEfbR6YxJNWU0G0WWMMKXUPCEFOHSVG0EQhUD1Km/WXmS7dhKjE7BuVDzhAzh0UblMQqaYBUa7ydDwm7hhk/+TsShjZ+/XF1Atbp9ppY7AJFALlC8IIMGGWGDLrt8MkMoqpopur1UAAMomnsDNUJT2+7TcwlUZEcr00C1/yznZx0fhjyHuCe+e3RGk46ZxsmccaFTzLHbVO1Qocl2UoXYIOzcm1TuhLvbftpFAJFzDrS04KbD9um0NWJaVhpwsdVacw/n9IHtp6zXmcVhUpp6gptiTHw2iXHcL0DeY+QBmOGaOF+jAfZy6faOo/mE6LFtOBkt6phIPm+YNl2NN5Rq4Q6VD6A3srCwXpD/qn7zC+Azg133BMNSKNy4Y+PkCtR3TVmzBk/r/RprlFZNDeoZ6qmtgURAr5zEE2nMmwwj3otbZ6VKis3lUBZvB5Ie2Z9oi+lyxuNW5XUog=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(91956017)(66446008)(64756008)(66556008)(66946007)(66476007)(6486002)(38070700005)(83380400001)(6512007)(86362001)(71200400001)(36756003)(38100700002)(122000001)(2616005)(5660300002)(6506007)(8936002)(33656002)(26005)(54906003)(508600001)(186003)(53546011)(44832011)(2906002)(6916009)(316002)(15650500001)(4326008)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE5lRGVjdlVULzIvbjZma0xMeTFzQnpOVVoyZkd0UzFtKzllUTl0OFhVbG9O?=
 =?utf-8?B?aS9xSkxVRUpudFRiWmc3QkhMYllONWJEWmdNR1YrWlpQWG5VMDFweDNQMDhl?=
 =?utf-8?B?WE5renJGV3NYWHVQR1dpTW5tQ2VoejBlZFFFb3AxU3NBOFRIZWE1czZGRTR1?=
 =?utf-8?B?YVlMTG1neTdkMytPamM1MFJQZjRmRm1Od1l5ZHQ2WkFlbkU2UG1lZlZzdDdO?=
 =?utf-8?B?dGJYVFBUNFJFdjlVK2ZCdGE0ejQwSXpMTi9USFRrREQvcWRoNi91ZzBRZncz?=
 =?utf-8?B?QjdFTmJZempLaTZVcXVSZG5RL2FWYk5RR1pYUGhqVStoWDl3MjVULzJrZHRD?=
 =?utf-8?B?U0QyS2pNUjJvYTBuZlUwYmxIakdXaGpIZm0weGppT01zQnBOMkM0ZDhudGl3?=
 =?utf-8?B?cm1tampHU0F0NjhjeVlTYkZLbUU2WjhJWnMzbFRtM0s2RWlJYTV4TC93OGVx?=
 =?utf-8?B?K0V0eVFxR1FFZkpQUjJvRkJ5NDk3S3lwTUl6L0hxV3VMbWhkUURncVpUMDdl?=
 =?utf-8?B?b2dSZ0tyTWlZQjdjYUxlc3VGYVF6MXBvVys0c1BsV3BISldyNEZUL3BEV0pn?=
 =?utf-8?B?VWhQek1jUWRGWWFHa0FJZU9iY0NjMklGLyt5T2tCcGRYVUpOTVJxcmlHdHF2?=
 =?utf-8?B?SHpZOUZTMDFXZGt6NzdSSjQ5Q25OaWJ0a1BsWHpkZ1FpRzdHK2ZFeFlaVUtx?=
 =?utf-8?B?UE0vZ3M0VkhLdVpLem9uc0dlakdPbGdvVHozTUtjOU9pbVBJVG5KY2E2QWNs?=
 =?utf-8?B?YVl5SDBvcmk3UXlKRGdVTU9GTEQ5NkE1OFprTHZ4UzdTS25OTHFPekM5VG9L?=
 =?utf-8?B?TS9WUWZmcXBueFgvV3RuN2U3dzhNbURMaUNvTGY3bzE2V0NlbXpQZExLaTJT?=
 =?utf-8?B?S21oQUlyNmpxazA3bWZ6d2hhYXI4VEF3RkdLL1VSTE13eElXN08wYXF4VElR?=
 =?utf-8?B?cjJYU3RCYUoyTFl6UnEyc25sK1M3VHhiL0R1TFNlWlRsRDZPREs1aVU0ZER4?=
 =?utf-8?B?aUdZMEJURHlGYzJjYU1MUENqSEpCc2cxMzlqVTc3akMxUTd4RmZtR1k4Vk5a?=
 =?utf-8?B?SnUxOUMycjJsOG44bWIvNTdUYkFXUWtCaFhrTHpmMjlNb3REazVML3JRWkVW?=
 =?utf-8?B?Z1ZRQ29FZ1A4MW44MFpCeDZocG1MUUh0V1cvRjc2VllFMUpqR0RiamMxYmtW?=
 =?utf-8?B?a25zL215aUkvS29BcHQvRmpBbGthaWt0UysrbkdiMnFKVVh2U2ducDcvV2F2?=
 =?utf-8?B?R1dETHZIQ0k2Q3NyZ0dOOWl6bmFDbFFpeDE5dkNrR1l6US9BUC83K2hycTdw?=
 =?utf-8?B?Z3h5b1JRMjFqUE5lelFsQmI4T0RUTFBaN21Nc0l4WkJraUoyNytRTjFyNGpO?=
 =?utf-8?B?ckdCdnoyelVVSEFJeWNKbGZCYjdMbEdBbzlFNVNLa25HaG0wcFFCZ3YwWnFY?=
 =?utf-8?B?RWVWaWhsa2JSMmNEc2JxS2wzTE1IWlZqeHhDYWJDRkVudkJxZ3BseDFKK2F0?=
 =?utf-8?B?V1VEZjBMajZPcTRHUC9KbjVTWk40UlNRRk1Rd2pwaHRyWFVIaEZKNWtHL0dU?=
 =?utf-8?B?R2tMaFRmWEUweitQOE1TMkJUQVYvWk85aVk1Y2dWdVdadzdZQUJyV3hzRnZl?=
 =?utf-8?B?ZHpzSGEwRlJJaFlWUFVBWlU3cHRZRnBaU3I4VUtmRUdOMWUvQ294M3JtbHd5?=
 =?utf-8?B?dklOZjFaYkNQYTc5SDRlRTk3UWJTK0RGNzNCcGFXWmdrL29FY3hGcGlidVdM?=
 =?utf-8?Q?DKcD7lzT3UUmTBRn9ybHWspZL8PQILTVm/PBq+H?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <57B9E4C73CD0F847ACA5C2B339DB58E4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74414a01-2ee4-48f4-5cdc-08d98d15a107
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 00:17:08.3446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FtCdTgcayhKNwC4fl0BFCBuZLAwWezIynmTawpyj98LtpM3DKzvm0Zal5Il9jECUWa2MoC/fCZXSZhv15JMunIjLgw8Tr52A51YXXB0ajG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6491
X-Proofpoint-ORIG-GUID: 5xcsVmoSnOVeDGy4ZuP6RZFP0qPM7ZWv
X-Proofpoint-GUID: 5xcsVmoSnOVeDGy4ZuP6RZFP0qPM7ZWv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_11,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyY2Vsbw0KDQo+IE9uIE9jdCAxMSwgMjAyMSwgYXQgMjI6MTUsIE1hcmNlbG8gUmljYXJk
byBMZWl0bmVyIDxtYXJjZWxvLmxlaXRuZXJAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IA0KLi4u
DQo+IA0KPiBTbyBpZiBzdHJlYW1fbnVtIHdhcyBvcmlnaW5hbGx5IDEsIHN0cmVhbV9sZW4gd291
bGQgYmUgMiwgYW5kIHdpdGgNCj4gcGFkZGluZywgNC4gSGVyZSwgbnVtcyB3b3VsZCBiZSAyIHRo
ZW4sIGFuZCBub3QgMS4gVGhlIHBhZGRpbmcgZ2V0cw0KPiBhY2NvdW50ZWQgYXMgaWYgaXQgd2Fz
IHBheWxvYWQuDQo+IA0KPiBJT1csIHRoZSBwYXRjaCBpcyBtYWtpbmcgdGhlIHBhZGRpbmcgcGFy
dCBvZiB0aGUgcGFyYW1ldGVyIGRhdGEgYnkNCj4gYWRkaW5nIGl0IHRvIHRoZSBoZWFkZXIgYXMg
d2VsbC4gU0NUUCBwYWRkaW5nIHdvcmtzIGJ5IGhhdmluZyBpdCBpbg0KPiBiZXR3ZWVuIHRoZW0s
IGFuZCBub3QgaW5zaWRlIHRoZW0uDQo+IA0KPiBUaGlzIG90aGVyIGFwcHJvYWNoIGF2b2lkcyB0
aGlzIGlzc3VlIGJ5IGFkZGluZyB0aGUgcGFkZGluZyBvbmx5IHdoZW4NCj4gYWxsb2NhdGluZyB0
aGUgcGFja2V0LiBJdCAoYWIpdXNlcyB0aGUgZmFjdCB0aGF0IGlucmVxIGFuZCBvdXRyZXEgYXJl
DQo+IGFscmVhZHkgYWxpZ25lZCB0byA0IGJ5dGVzLiBFaWljaGksIGNhbiB5b3UgcGxlYXNlIGdp
dmUgaXQgYSBnbz8NCj4gDQo+IA0KDQpUaGFua3MsIEkgdW5kZXJzdG9vZC4gSeKAmXZlIHRlc3Rl
ZCB5b3VyIGRpZmYgd2l0aCBteSByZXByb2R1Y2VyIGFuZCBpdCBjZXJ0YWlubHkgd29ya3MuDQpZ
b3VyIGRpZmYgbG9va3MgZ29vZCB0byBtZS4NCg0KPiANCj4gLS0tODwtLS0NCj4gDQo+IGRpZmYg
LS1naXQgYS9uZXQvc2N0cC9zbV9tYWtlX2NodW5rLmMgYi9uZXQvc2N0cC9zbV9tYWtlX2NodW5r
LmMNCj4gaW5kZXggYjhmYThmMWE3Mjc3Li5jNzUwM2ZkNjQ5MTUgMTAwNjQ0DQo+IC0tLSBhL25l
dC9zY3RwL3NtX21ha2VfY2h1bmsuYw0KPiArKysgYi9uZXQvc2N0cC9zbV9tYWtlX2NodW5rLmMN
Cj4gQEAgLTM2OTcsNyArMzY5Nyw3IEBAIHN0cnVjdCBzY3RwX2NodW5rICpzY3RwX21ha2Vfc3Ry
cmVzZXRfcmVxKA0KPiAJb3V0bGVuID0gKHNpemVvZihvdXRyZXEpICsgc3RyZWFtX2xlbikgKiBv
dXQ7DQo+IAlpbmxlbiA9IChzaXplb2YoaW5yZXEpICsgc3RyZWFtX2xlbikgKiBpbjsNCj4gDQo+
IC0JcmV0dmFsID0gc2N0cF9tYWtlX3JlY29uZihhc29jLCBvdXRsZW4gKyBpbmxlbik7DQo+ICsJ
cmV0dmFsID0gc2N0cF9tYWtlX3JlY29uZihhc29jLCBTQ1RQX1BBRDQob3V0bGVuKSArIFNDVFBf
UEFENChpbmxlbikpOw0KPiAJaWYgKCFyZXR2YWwpDQo+IAkJcmV0dXJuIE5VTEw7DQoNClJlZ2Fy
ZHMsDQoNCkVpaWNoaQ==
