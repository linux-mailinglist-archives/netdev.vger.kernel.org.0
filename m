Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDA631CEB5
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhBPRLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:11:06 -0500
Received: from mail-eopbgr1410133.outbound.protection.outlook.com ([40.107.141.133]:58880
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229699AbhBPRK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 12:10:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehTISGU0lYB5nmfScy8nxB1sktEHFtgClEDWkdb+PrhyEa8o1aIzM0FB4Upof/Cda8buNNzpHUB84GPwT3p1h4ieIn05hQ0sjxjlzhDRdSu3KcX25O3gmJzAHnsL4WmMjOPQPY2uYBXlp8zghMDKEB3IlTCeVP8ytcO2oMTKe6kaJK0WIfMiuzInEOM5SnaEuCrGFKJfSJ8z/ppr8bks7rdpoRsansRlFbvoG3SgggZdSiugixuVAEzFVTAUwgoUZGd4EZfqnWTe9at3DN0gLe5MvEyJHznyinfWynVQeJddJ2JvTx0aq65TFgfGROglBXfKjyF9iwqYsLJreozLxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCOLSF7NRRZcHp1U20AkUCL9c1q8CVZwIwF/0ZT5zIM=;
 b=Yn1p7gJr8jqfHrSRGGOKEi6C/F1c3MOVotz2bJHlIryOPZAl3Hod4hc0fe/jyk1Ij619Fxf1o9g6xUeaC9vDa06cZpxY75fSTwV8d7cNFepyaHRI7YhH8G7MVZMTm3ELbvh4S4V0CNuMI4dLgNlOXzAah6DhP8ZijajIhziGpIXfOM/p5xkpFIXGLZATwjfk1CT4Uu8MBo0BLsQJKVry4i4mR3tNxutzl5j5lxVv1RsL4FS3a9c8BNrWWSbY4RUuUyCA4fOymRcgZ6pGaSgv15bqe/+hwcRMdbM/rn+YamVxSeUjGhwG6EE1syaSbX+ck62eV9kFilHLxnq4T7UQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCOLSF7NRRZcHp1U20AkUCL9c1q8CVZwIwF/0ZT5zIM=;
 b=ND57YXqiRDfALDoKBScYvx6R4VnARTlJv7BMlkUQEhWZQJpaQCR9tf393Z1HTMwLLRKR9Ds3B4mqGWpR0tLN/UVQjk4Lkpl4KuZARCIPfOi/Bq4Ex8XI0a1/81jP+2wSZ5HR/e3iyUcMcRPWXFvKtRB8ROAVJfEpQkigPMDnURM=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OSBPR01MB4952.jpnprd01.prod.outlook.com (2603:1096:604:7e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 17:10:09 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 17:10:09 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassggABEPICABhmmwA==
Date:   Tue, 16 Feb 2021 17:10:09 +0000
Message-ID: <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
In-Reply-To: <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 36612631-f975-48fb-a7a8-08d8d29db6ec
x-ms-traffictypediagnostic: OSBPR01MB4952:
x-microsoft-antispam-prvs: <OSBPR01MB4952CEBE77D099852DB341D0BA879@OSBPR01MB4952.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +TO4pXIXXIeFkV7VDvpH/VpWjCoP6RJM6B6pEy8jVt6mUfwFVOXhd8lYNqY4rZLzLOOUlOsAUz/6eBjHTKbWj56qGHGUhoQXJzXC9Qv03Uuv75fjlcmgY2IwELzu9mIv9mtONKQozLD0qprhUwKqTXjb/IPQtpy9gmo9FCN8F4UBV/dakqUTB8i2YJlLWLBfXgujex3RnlAmbplkjCxMm1Yj+KdlloDpVCeQd/34r+DWl93U49BDCJ9Jj3cfgyMpwUO111ZUTGdi3QBjpHW3ZIZG1e/xS85PJh8hLvhSNIMwzWD2V8ZiATOIzJXNQHkGhVjvOYrSTc05bXG4RBzw8r9aQzWNu/7/FkodBBL0zk+wWF4uq+tSxo7m/6HjQ+LwhUsAJfuEr/AtvrMYJ2szqr0m8rWwios3r5+GFy9HQ6jGaI1G6V7HfImLk4l4uaiqTCz+ASFJrwTgHS6e9KuxggIcFr8Y1qPb4AzzDtIJ0isswTY4SmMROC2mPHsRf+dp3QdNz4/D7Lt01rWH8hi4nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(478600001)(6916009)(26005)(5660300002)(54906003)(83380400001)(4326008)(8676002)(7696005)(6506007)(52536014)(66446008)(316002)(55016002)(2906002)(64756008)(76116006)(9686003)(66556008)(33656002)(66946007)(66476007)(8936002)(86362001)(71200400001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UGIwWnhkUWRvSTFuTVBBbVhqbXEwUXVtTzBOeWRDTjFUc1IyQSttS1hob0Ji?=
 =?utf-8?B?aW1wVWtNZU5lQUVXV3dZcndOS3d0c1U3S3pXemZkMS9SWUtDajB1aG1xRWJ0?=
 =?utf-8?B?NTNSTU05dWxnN2wvZEphaDB2UUlVR0hrWkpPOG4rcm5GeWlWakhyT2p5VXcr?=
 =?utf-8?B?eTk3aFdYRW1FekZNMlRLQ1h0ampHc3hnZWJHbXdyMmNjWjVob1JZRmVoKzEr?=
 =?utf-8?B?NjlDemJpYTVFNERlY0MyTGJTdk5KN1NoU1Q5UjluempYOUdEZUdLbjQ3bUFE?=
 =?utf-8?B?MDgySHl5REpoQXREa0FYMlVxd3J4cm93SWRwcE9KTlk5ajdnVXg5LzBHU2tO?=
 =?utf-8?B?R0Q5a25YR1Q0TFpQdlU5Qm5SdGlRaUg0Vk1lWmZBTVNRY0gvY3RrR3JzZHlW?=
 =?utf-8?B?NHIzczZ6bWtNQnIzN2xyYklNVFplOFY2OGE3dHhySklIK2tKQ1hkSXBxWUt0?=
 =?utf-8?B?M3FyTE9MWFg1cFZRYXcrTmwyLzNjM2hTQ25qZ20vYjRZTlR1VWtUQ3RKT0Qy?=
 =?utf-8?B?eW01SnVvRm9zdU5TOVpaellDMkVPK2RxWitWK092ZUxidnVlUGMvU0JpOUwz?=
 =?utf-8?B?QzA2VUVYMzh5dzFIWXRZbkkvSDRRRzI5ajVNNmlwWlVWdWMwejFtUGRreWZv?=
 =?utf-8?B?eHlWZ0ZKdjFqVnlSenN4bVMyZkl1Z3FvSTdvaU1aTlpRR2M4RDhobTVhZzBl?=
 =?utf-8?B?YkZ2dHpLYUtSNmJmN2RocTBkZk0vRGdKUDhnQm16K0t6YVB3OTFJWGptN3VK?=
 =?utf-8?B?RTEvSENLK0htclRNZ24xbW9GSXpvWkVqVnI5U0pFL3A1ZGVNSnR1bEI4RHcz?=
 =?utf-8?B?VWdTL3gzcHo1d1JHWkh4QXB3OFdMSHcrc0xrelhROWdxbUNIUG8vU25ZVm8x?=
 =?utf-8?B?L2VwSHp4RTRWRkNNem82UXhTY3YzcGpQVW9pUU9zRDdqY1QzS2s2ZGh4MmVr?=
 =?utf-8?B?SkZ0Ujk3Vnp3ZjR6Ty9ORWlSOXpyRi9TUEY3Q3Z0ZkpJT3lPRjJoazNBaDlG?=
 =?utf-8?B?NnNDemxSUjZDN3ExSEpkNFpON1NMdzlSekVsOVQ4d3c3eXliOXRrdzF4NTNr?=
 =?utf-8?B?Tk5UU2xVaXRWU2ZRVDNGMHdTWVdYTi9EZjdIMytBa0k1cG9pUW02WExYL3F2?=
 =?utf-8?B?L08zTFNvbEw4N0JpaDhHWEduYW5PQTZ6cFQrdFdMMm5Tc05yVmRVem9hRHg2?=
 =?utf-8?B?RjAvWnpTbStpQ1laSXdhazk4SldOQ2V0RTZFYVRLbk0ya2hhNWZURk93eFd2?=
 =?utf-8?B?YnNJU2syYk9pSG1WMUZiTWJCUWNiaFJUYlBnYTY3UWJpeTVNQS8vR0diWWpC?=
 =?utf-8?B?bWRWeTMrZElTZVU3Zi8vMlFJRTZqa1NtcFVOd0Z4ZHl6cUJqaUhGckF6akdM?=
 =?utf-8?B?aURkMlkxRCt6ekNFME5LSjV4V3ZKYXdhYUUzR3I5Mi91VkRvUW5jbGtON0hx?=
 =?utf-8?B?OEhxVlBCL3ZVTWo0WkF1K3ArekVibGNrMnJwLzFSbTI0U2Q4L3FGeFJzMVVo?=
 =?utf-8?B?ZzFnLys1VUNKMUhsN0Z0a1FQS2xjY3JZSGhZejc2VWR4OFNyYTVRVUZmVWRY?=
 =?utf-8?B?czNYQ2xjVlZ4cUptQkxPNDJ2NkQ4Wm1OMUlGN0trMDIxa2JxWU84S1RLVXV2?=
 =?utf-8?B?aTNXWlYzeTY0bTRLSXdkYU53T3FIZkdxQW9GY0kwdjd4QUZWc2VrQ0dlSmVh?=
 =?utf-8?B?S1VnTEVhS1gwWWIyOCtzalZHQzIvelQ1a01TMTBOdTN1aEZESVJ5bFJUS0FP?=
 =?utf-8?Q?gWficCeAzz488QufiwVKjHV/uzyrePGmIS6IjlO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36612631-f975-48fb-a7a8-08d8d29db6ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 17:10:09.2397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dt3eubyfec6e8Lq2Fel3rxMOjGGk9rjVYiDcmZr2sNuQlhmXclyEiOpmvZFM2V813aXgHIZkwnwt4ACQJ6YjbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+DQo+ID4gSWYgSSBjb21lIHVwIHdpdGggYSBuZXcgZmlsZSBhbmQgbW92ZSBhbGwgdGhlIGFi
c3RyYWN0aW9uIGNvZGUgdGhlcmUsDQo+ID4gZG9lcyB0aGF0IHdvcms/DQo+IA0KPiBJIHRoaW5r
IHNvLCBidXQgaXQncyBtb3JlIGltcG9ydGFudCB0byBmaWd1cmUgb3V0IGEgZ29vZCB1c2VyIHNw
YWNlIGludGVyZmFjZQ0KPiBmaXJzdC4gVGhlIGlvY3RsIGludGVyZmFjZXMgc2hvdWxkIGJlIHdy
aXR0ZW4gb24gYSBoaWdoZXItbGV2ZWwgYWJzdHJhY3Rpb24sIHRvDQo+IGVuc3VyZSB0aGV5IGNh
biB3b3JrIHdpdGggYW55IGhhcmR3YXJlIGltcGxlbWVudGF0aW9uIGFuZCBhcmUgbm90DQo+IHNw
ZWNpZmljIHRvIFJlbmVzYXMgZGV2aWNlcy4NCj4gDQo+IENhbiB5b3UgZGVzY3JpYmUgb24gYW4g
YWJzdHJhY3QgbGV2ZWwgaG93IGEgdXNlciB3b3VsZCB1c2UgdGhlIGNoYXJhY3Rlcg0KPiBkZXZp
Y2UsIGFuZCB3aGF0IHRoZXkgYWNoaWV2ZSBieSB0aGF0Pw0KPiANCj4gICAgICAgIEFybmQNCg0K
SGkgQXJuZA0KDQpUaGlzIGRyaXZlciBpcyBtZWFudCB0byBiZSB1c2VkIGJ5IFJlbmVzYXMgUFRQ
IENsb2NrIE1hbmFnZXIgZm9yDQpMaW51eCAocGNtNGwpIHNvZnR3YXJlIGZvciBSZW5lc2FzIGRl
dmljZSBvbmx5Lg0KDQpBYm91dCBob3cgcGNtNGwgdXNlcyB0aGUgY2hhciBkZXZpY2UsIHBjbTRs
IHdpbGwgb3BlbiB0aGUgZGV2aWNlDQphbmQgZG8gdGhlIHN1cHBvcnRlZCBpb2N0bCBjbWRzIG9u
IHRoZSBkZXZpY2UsIHNpbXBsZSBsaWtlIHRoYXQuDQoNCkF0IHRoZSBzYW1lIHRpbWUsIHBjbTRs
IHdpbGwgYWxzbyBvcGVuIHB0cCBoYXJkd2FyZSBjbG9jayBkZXZpY2UsDQp3aGljaCBpcyAvZGV2
L3B0cFt4XSwgdG8gZG8gY2xvY2sgYWRqdXN0bWVudHMuDQoNCk1pbiANCg==
