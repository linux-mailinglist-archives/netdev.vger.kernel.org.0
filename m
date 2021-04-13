Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0388835DA94
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhDMJCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:02:50 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:59521
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229524AbhDMJCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:02:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1w3kkNlbZ/jTpLMGQH3M+L8IHxuIViYeQl57odwXCm6vIb1D52F1WC5oRdfjVfTa63BlKhB/4XAMStvJL42oFt++D6eFIsQIXfTay5zd0dVBWybhijMquHsxigXXimtjg1O/yd3b6hkCWBC2woPFIrzxREVs2AaAOJix+tePz4crKcMiFU0RyZtyeMSUTBaFLjq/XRADXX/ATm7icqYTy2Qp8nxLyH+Wfs4JdTa18cJliJlulXzYnQKmGhREC08KNfL1yZW/F6k8DBFCeC5gacykyhu+R2Xy9Aop5x+8J5PPePRQ3v71Q3wR2R5Rzr8XrsPoV7etnzJAcwhuQJ5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGaGliK4bZjHZs3sa13vErWr4Z1kEMP9ynBqTpfWFrQ=;
 b=jmQRc0OkH9II69BwGVr5U1Irz7yxf/Um0WBdvujdoYnfO+QBXK2/414qLcyvwiTXa+SUA7PEx9oUCfPIPJIxl6JQioAljU3wIAmIyiW3p1oHuYugSjVCKCmerTvgdYLqhyFXt1tCzlLID7PVIz2muv52ef1E/XkfAjltudruvHJg5MgLudnWtOxftX+w55AWlIZJIvRnCNJhdXoWPFoQnDsEsCejYVn287Bk9QopqN+slCbJwlHBasn28NdfKOUSNgM4pJUhsibo7u3WPmljhrOGGwFHjKtqTyfPesEZOruUPwNR7PT+mrDhjuQfcvM+NXacBAzvzwXut8rY8DSbkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGaGliK4bZjHZs3sa13vErWr4Z1kEMP9ynBqTpfWFrQ=;
 b=TtmShboxZSJv2MfnNReAuZXyscqxM/Ahl7LfgpQtQN0gA6c+o9GtEtvE6pBWk5Lu8VV168Yl5/m0AERlf2GbiRwANKVWiOQsIAXK3kbbm45N8tqXMXkgT/NTrT3gJrzCU/p8+BIU1Fsjmep/H3Jr1wfvgbN5ynYCIomm7admN0I=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DM5PR05MB2890.namprd05.prod.outlook.com (2603:10b6:3:56::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.6; Tue, 13 Apr 2021 09:02:23 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::1025:e864:4f6:e517]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::1025:e864:4f6:e517%3]) with mapi id 15.20.4020.015; Tue, 13 Apr 2021
 09:02:22 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     "Jiang Wang ." <jiang.wang@bytedance.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [External] [RFC] vsock: add multiple transports support for dgram
Thread-Topic: [External] [RFC] vsock: add multiple transports support for
 dgram
Thread-Index: AQHXMEO3/vE49hjfcUySzWAE9iKnSQ==
Date:   Tue, 13 Apr 2021 09:02:22 +0000
Message-ID: <4FE66B72-E16B-474D-9A17-70B3BCCD5A19@vmware.com>
References: <20210406183112.1150657-1-jiang.wang@bytedance.com>
 <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com>
 <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
In-Reply-To: <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [83.92.5.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f7f93e1-3b28-4c24-b558-08d8fe5ad9e8
x-ms-traffictypediagnostic: DM5PR05MB2890:
x-microsoft-antispam-prvs: <DM5PR05MB289032069C92EF269C89DDAEDA4F9@DM5PR05MB2890.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xiXfbUprsTZ4id/goQHRxKpVwmjDXLpq+WatqO9EgY6WJpc9ze4VyTPjeuITPIacOHNfmRCBNFcFMREGg5E88qfnoMHfS0mV2cJJcGEnzNPnHzljI2G7WBwer2aL7S3qQDi5NlRHzElZUBjHPYUKZhOWWbcalFp/uSL4ICXQrjwpnqiB9gnu5tvEKoMOCM3rw/ypXkhtunrpmHHAdV1H5+RSqEaBr+xMwRJINegCwRyt6efUINiHKj1ElpKCpMytFL4hV81N+S6sgp2bZBBU1I6p+itbgbuIYN3yWV9KQnpdCvTw+nI3HXfAiFRKE/9hA+8ZYlkwO4FF6F6gDOnSCQpwAB/U1vIP3suWEI6DijeE3zyREJroxAVeUhxDcSUUGb2r7UwXd3Qxaa6mKGMrWGdSIc739IMFG3FOeaNZ+wLgkQb0fH7CLfVk5tY/DWnCIo3C+EQuqFbjxhvD8cSBy1CbvxCNq78KCZtum/ieMcAhGMQD0h+TpwQti9xfcDiyeSZP1hNl0clYjQipeEsbXLvP7FDbsoRzbBv6TxKkWUWGqyqixZTNZP316qmFmLb71VCM8zH3f1fiOTOnJXVFqB/pdyOAO7mMruLEd6S+rmQIyGSFSYeJiq88C1A2kTpaqZ2U2ga7d+7e+rSU6oY3aP5h5ULMGoG0pi6HQU5lVig=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(71200400001)(7416002)(91956017)(66946007)(36756003)(66556008)(66476007)(33656002)(2906002)(4326008)(316002)(66446008)(64756008)(478600001)(76116006)(6512007)(54906003)(6916009)(2616005)(5660300002)(38100700002)(8936002)(6486002)(186003)(53546011)(6506007)(83380400001)(8676002)(122000001)(86362001)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y28wZ1NseFNORHo2V0xLb1ZOZm9sR3JHWXVrdjdkcUU0NVRpb3p5SHhzRy92?=
 =?utf-8?B?WmVUR1R6UDRJeC92K2hJaGRKMGRrUzlRSDI3RHkzTnhicWc4NTAwU3pLWXlB?=
 =?utf-8?B?Nm5IK0V2Ty9OUE1CdWttd285S1pDOGxpSTZ1cS9UamhHQlV5WGNTcDRVRm5T?=
 =?utf-8?B?b0JLSDlsYmtkRVJzMGlrWVU0Zzltd1VvRWRYNUZOWGIxbW9LQkRIWGxYeG1I?=
 =?utf-8?B?ZS9xdnk3Q0tDWDExems0TE01b1NGTVY4dTFDbENndDM3Rk5EbVdCb2tDbEo4?=
 =?utf-8?B?TndzOTZMdThFbkFEY0hSSWFpUTZUTTZWN2FCbnFXZDE3bUlyazhLVDdaQi81?=
 =?utf-8?B?N3JWaTgrM0hMLzJMV1gxaStYVnlSTStzaS95Tnc2eXJ1eFJ3ajFIRWxEV3pB?=
 =?utf-8?B?YitYOUswdWZlek1mbjBBbjBLaEJZaGlQck42SGZkcSt1TmVoaEJvWXVIUG5Q?=
 =?utf-8?B?VnBaTnVXSFJEWU82TUxlZTdqcWlvdSsvVC82OEoyTTlJMUNEY1ZzaENiRjJT?=
 =?utf-8?B?Z05FL1M0Q083alB5NUZ0SWVPbXQwb3p0WkpINktZaGJKUDRJTnM1ODJrMkdv?=
 =?utf-8?B?UmxYYnRTaDJBQ2N3V2c2eWZ6cXphWEpRSDJvUTArUmdLcjB1UyszQzQ3R0kv?=
 =?utf-8?B?eE1LSC9sTlBIcTdVL0J5REJsa2lFZmp5dlV0ZElNcXBHM2F0aG9XUVJqQWVX?=
 =?utf-8?B?bEY5MGxhMW5mbnkrZEdrVEhRSFdFYnhPc2JOa2Y2YythcVJXUGRWQmRSVmlh?=
 =?utf-8?B?RlhZaDRFQ1NhcEJ6NXltdUZLMXZSRmhjbDMxZ2pmZjFXQXJTQXpSc2cvNW9t?=
 =?utf-8?B?U1VaRU1ENjVBeVVIc29qVXdGMTgvV3lGb2V3NUNrMlp4U3hjWUZTY3pvRUdh?=
 =?utf-8?B?dk5LZjl1MnIra0JjaFVtSjR6dzBoQTEvUVR0SHJGaWhmbHpKbnpXL3Z1VFNq?=
 =?utf-8?B?MkhVbkpKMEVqV25JMUU3bU5EdjNPay83aEEwU25SeXRodlVWOTE5SkhoQTVM?=
 =?utf-8?B?RVNuZnliaGRmMmVCV0hHajUzN1lpd1BuZDlZZ0EwMndSSkFJUGdKVGI1UUNR?=
 =?utf-8?B?ZXBvcXU1dnpVM3JTaVBzVnFtVmZSSzNWclhBaTVhWVNaZGxJcXhjVFpKVjlJ?=
 =?utf-8?B?M0xNcThFK2lkTzNjRUh6dWJpL2NoY1dONkJXQkxmaFpsenN3d2kzWW14cTlX?=
 =?utf-8?B?SUVqZS9McXJra2NEc2U1YkhaMVhjUk9kQlhPY3kwM0NTYzJtSDdlQTFkNTF0?=
 =?utf-8?B?TnhrV29JL3BxSzRLU0F1bGxoeGRDVW1kK1JoZlhNTmNDMzNmcGMrbW4yTFBF?=
 =?utf-8?B?QjB1ZHJ3Q3h2N0FWOE40QVFiNllLNGFrSVlKazBEbC9YLytnRlNLQ2ZTQlJG?=
 =?utf-8?B?K1ppN2poWVp4cEVzNFQ3MnFOMUpQbzZjaDdFUzgyR1lvSHRUK2ZDV0F0RjZS?=
 =?utf-8?B?dndBazltVXpGWWt2NGIvbUNlN2tOMmtKR0RLaytoWUlvR0NXWTIvaFhSSDFo?=
 =?utf-8?B?SWt0aFB1dzJlVlJQQ2grK2VVS2w1WVA5ejlkZU5mOS9iTndHdUJKNElPc2d3?=
 =?utf-8?B?U0h4b2xOOUh5cVh6TjFOL2taTWp4UjZIQW93TWhoMGVWUlN2YlpNcWtwQ2xu?=
 =?utf-8?B?Rkd1QkdXSDNKZENDV3FPaEhzY096ZVBraERJYnVPZy8zYTJJcFpYdnlwN2xi?=
 =?utf-8?B?Q3J0S2sxR2trTWhUL3dlbFFuYlN5Mm9sZW9HcWM1UjM4a1R5NE9CZFBnNkgx?=
 =?utf-8?Q?9BsCwEHwrGX30zDmafKnbFvbIWRC1LAB3Buuz9f?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C04CBDFEFA67994687641415B05EA086@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR05MB3452.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7f93e1-3b28-4c24-b558-08d8fe5ad9e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 09:02:22.8723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QtGaIjkpq4qrCvHI9hQvVCcAxWrNWa74cmuWxp1Lq79mRCcQavTZaHzRZzyNJ8eX0FYLJrdqYNpQ1oufjqhECA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR05MB2890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNyBBcHIgMjAyMSwgYXQgMjA6MjUsIEppYW5nIFdhbmcgLiA8amlhbmcud2FuZ0Bi
eXRlZGFuY2UuY29tPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgQXByIDcsIDIwMjEgYXQgMjo1MSBB
TSBKb3JnZW4gSGFuc2VuIDxqaGFuc2VuQHZtd2FyZS5jb20+IHdyb3RlOg0KPj4gDQo+PiANCj4+
PiBPbiA2IEFwciAyMDIxLCBhdCAyMDozMSwgSmlhbmcgV2FuZyA8amlhbmcud2FuZ0BieXRlZGFu
Y2UuY29tPiB3cm90ZToNCj4+PiANCj4+PiBGcm9tOiAiamlhbmcud2FuZyIgPGppYW5nLndhbmdA
Ynl0ZWRhbmNlLmNvbT4NCj4+PiANCj4+PiBDdXJyZW50bHksIG9ubHkgVk1DSSBzdXBwb3J0cyBk
Z3JhbSBzb2NrZXRzLiBUbyBzdXBwb3J0ZWQNCj4+PiBuZXN0ZWQgVk0gdXNlIGNhc2UsIHRoaXMg
cGF0Y2ggcmVtb3ZlcyB0cmFuc3BvcnRfZGdyYW0gYW5kDQo+Pj4gdXNlcyB0cmFuc3BvcnRfZzJo
IGFuZCB0cmFuc3BvcnRfaDJnIGZvciBkZ3JhbSB0b28uDQo+PiANCj4+IENvdWxkIHlvdSBwcm92
aWRlIHNvbWUgYmFja2dyb3VuZCBmb3IgaW50cm9kdWNpbmcgdGhpcyBjaGFuZ2UgLSBhcmUgeW91
DQo+PiBsb29raW5nIGF0IGludHJvZHVjaW5nIGRhdGFncmFtcyBmb3IgYSBkaWZmZXJlbnQgdHJh
bnNwb3J0PyBWTUNJIGRhdGFncmFtcw0KPj4gYWxyZWFkeSBzdXBwb3J0IHRoZSBuZXN0ZWQgdXNl
IGNhc2UsDQo+IA0KPiBZZXMsIEkgYW0gdHJ5aW5nIHRvIGludHJvZHVjZSBkYXRhZ3JhbSBmb3Ig
dmlydGlvIHRyYW5zcG9ydC4gSSB3cm90ZSBhDQo+IHNwZWMgcGF0Y2ggZm9yDQo+IHZpcnRpbyBk
Z3JhbSBzdXBwb3J0IGFuZCBhbHNvIGEgY29kZSBwYXRjaCwgYnV0IHRoZSBjb2RlIHBhdGNoIGlz
IHN0aWxsIFdJUC4NCg0KT2ggb2suIENvb2wuIEkgbXVzdCBoYXZlIG1pc3NlZCB0aGUgc3BlYyBw
YXRjaCAtIGNvdWxkIHlvdSBwcm92aWRlIGEgcmVmZXJlbmNlIHRvDQppdD8NCg0KPiBXaGVuIEkg
d3JvdGUgdGhpcyBjb21taXQgbWVzc2FnZSwgSSB3YXMgdGhpbmtpbmcgbmVzdGVkIFZNIGlzIHRo
ZSBzYW1lIGFzDQo+IG11bHRpcGxlIHRyYW5zcG9ydCBzdXBwb3J0LiBCdXQgbm93LCBJIHJlYWxp
emUgdGhleSBhcmUgZGlmZmVyZW50Lg0KPiBOZXN0ZWQgVk1zIG1heSB1c2UNCj4gdGhlIHNhbWUg
dmlydHVhbGl6YXRpb24gbGF5ZXIoS1ZNIG9uIEtWTSksIG9yIGRpZmZlcmVudCB2aXJ0dWFsaXph
dGlvbiBsYXllcnMNCj4gKEtWTSBvbiBFU1hpKS4gVGhhbmtzIGZvciBsZXR0aW5nIG1lIGtub3cg
dGhhdCBWTUNJIGFscmVhZHkgc3VwcG9ydGVkIG5lc3RlZA0KPiB1c2UgY2FzZXMuIEkgdGhpbmsg
eW91IG1lYW4gVk1DSSBvbiBWTUNJLCByaWdodD8NCg0KUmlnaHQsIG9ubHkgVk1DSSBvbiBWTUNJ
LiANCg0KSeKAmWxsIHJlc3BvbmQgdG8gU3RlZmFub+KAmXMgZW1haWwgZm9yIHRoZSByZXN0IG9m
IHRoZSBkaXNjdXNzaW9uLg0KDQpUaGFua3MsDQpKb3JnZW4=
