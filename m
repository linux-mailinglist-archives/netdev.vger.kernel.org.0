Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A744AEC66
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiBII34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:29:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiBII3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:29:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0047DC05CB9E;
        Wed,  9 Feb 2022 00:29:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJE++7nCV0VR2iNomX2dM/djX0pwEpXuMp2PQO0YgZIqMGXtlBQUBhzQuHAUGtlb0BPE+r6WuwiTASZjJqLJy7UVrMylOUfROUTCJQ1U5tYWvoyLONSn/u1J+4xpPwrrb4xO5NQhpJ9LfELxghFTTwBCZkXclqlZ1Q4DVGRvNwKFblG9OypGdgyU2/bUS4DVKIdWNtubAi1/p5nZnzDoQ76UA+bMsoMLBrT9+0VSWBq0Mv0SZnkvoWLSA2a2M50jJknDuVYovs/02MUSETb+7JP1TE4MygRS6TtWN33TGEdDGWkqxuscvTvw1p0CBjvwTS9/qortoOuFJLuJ/J3POQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qssOm+TmeasxUFDKQhOi/ZP5oXU9T4AoWutATZ9F4Sw=;
 b=MMt3sLQ0e//ZSDa3WRHxQdvjmWMNUVRxrHebaPbZ3hO+Oss7p8X7p1yU1gN3du5OrBeahblb0LzVcnEtB1kChTwsaCKLuuASaMW4NyCBkhdUCxU37LdYBtbYaqjrTQjPa98cLKwdv9XP7laN96IDwgAG9CxEsM4Ijf3r17lJnwEmaYMr5Ne47cmBLJi0NIhybx0+0lLtQhSwy9ag5c915P/zFDMkz75P5t+Estdkb8qFLSNUefIUEd4DZfHOpMJmKEroKyWH8mbte00YNlbzAfQXBRPLULgZyTMe+wnnU9wUK2MIlUyPdhjP9pULcje4lYRIPKk62krLAq57jLSoUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qssOm+TmeasxUFDKQhOi/ZP5oXU9T4AoWutATZ9F4Sw=;
 b=bX7N9sZwxBbsFenZznuNBAQ0Q6wlML0bCD7kdEyklwSgg4pshp+o1ZRQMa1i2kT/Swp1DKCuXKIXtyuxLjCCFRIhHBjVWSGnUbzqZ66qudbAUybZOJYJHlrsAoJ0LgbK3agFkOYJqt5GB4eOHkjQTOyg+0dTA/r3Uh8EXwRZFe0=
Received: from DM6PR02MB5386.namprd02.prod.outlook.com (2603:10b6:5:75::25) by
 CH2PR02MB7093.namprd02.prod.outlook.com (2603:10b6:610:85::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Wed, 9 Feb 2022 08:29:55 +0000
Received: from DM6PR02MB5386.namprd02.prod.outlook.com
 ([fe80::edcb:5b1a:1a4a:f93e]) by DM6PR02MB5386.namprd02.prod.outlook.com
 ([fe80::edcb:5b1a:1a4a:f93e%6]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 08:29:55 +0000
From:   Srinivas Neeli <sneeli@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Srinivas Goud <sgoud@xilinx.com>, git <git@xilinx.com>
Subject: RE: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Thread-Topic: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Thread-Index: AQHYHQfhCbkJD7wJyUaac0q2SvLXYKyK2RMAgAAKW4A=
Date:   Wed, 9 Feb 2022 08:29:55 +0000
Message-ID: <DM6PR02MB53861A46A48B4689F668BEE9AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
References: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
 <20220209074930.azbn26glrxukg4sr@pengutronix.de>
In-Reply-To: <20220209074930.azbn26glrxukg4sr@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ab9cd03-67f9-449d-434f-08d9eba65a1b
x-ms-traffictypediagnostic: CH2PR02MB7093:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <CH2PR02MB7093008502D17DD97D75008BAF2E9@CH2PR02MB7093.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0xIBCAjY/IB+4lVyiAW3gmTpolry5fd/3fD20Xp4iQXydhnS5APSjxdLKnqnMpeCbzrkjn4lKBkFiGgG5IclOmtqlT4kFlqwh6IUfuiw+HLr9aR9ZP4ngFkhWEIM6c+IDg4dy1+YDv1/GqD2550HmthGYEkQgzMv7YjKV+hYFPLnyLbXRA+k/8ilTPNTBKWwk9I1rUX7d/ScXN1Ozvp/BY6TrKzVBalxz1wDJZQ9cHAbH1aC6/uf+oDItsbnFFwTX4LIqERxwa2MEG4DlH7tanstQVbzAYykOE/R9jsB4G84u6eny5rmphDTS8PBMbpA2eMgLgmLyy+D5Ul450JuDiwQ0Aqy42OqVAzk4I34EPitzw7JcBNzPgH4Ey/7sclSIZnc8Gqo7CSaQZpAP6ux6qEPZUOIAa0KvTjQ/z9MCwKhRzAPjeM0TZWhfs8T+79cNWGElwlBD4MKiLOW+ebmc01Evwko76brMglu3HcWZ0oc1Dj5ZyimgWWLP21eSH3vDoww/XuroM2jyBmQE2nvQld2Iy0B/DDjA/97q+1YHNG1eW/3jBT1gyY1rKLT7cDtrgdjtTBw2f/7EC1lsQEFHGDB4Y2x4pFs/3kEAPKLnQRjyqn7d8EryNqN0XfNF/EC1aNWLXUc1ntSFLPGkOrsnpQKvJlSOjvjoVbD7vpXI+yQse8rn4pbF/D2/qrivLYUCBo94u4DGm8RqQGkp7K1UrvlQwso1QQ5Xi5oRtjXEW+S9Pi2NgmKnQJIk9yiDlvIxRhnjoDlzGD7NbBdKFh763a9X89kN60xFxN+1NrN6+o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB5386.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(122000001)(38070700005)(6506007)(66556008)(33656002)(52536014)(71200400001)(966005)(9686003)(508600001)(8936002)(55016003)(107886003)(53546011)(6916009)(26005)(8676002)(54906003)(186003)(5660300002)(7696005)(76116006)(66946007)(66446008)(38100700002)(64756008)(316002)(83380400001)(4326008)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUNEWnQyMlVmRUNRSU9yNkxtVjUreDk0VGdtUmp3dzlNVVhjL1h2T1BVeXU0?=
 =?utf-8?B?aEk5OHM5QnpZNXNrTWdrOHFiVHhxWU9WbnNxcDcycXV0K1FEcUlCSHd2Qk5j?=
 =?utf-8?B?cDh1VVh4dGJFY2ZDNFNybkpsS1V6bmhUMzZick9mQ0lBYW9YdWtKenhPaTIx?=
 =?utf-8?B?djFDOXNRREtDVlUwVExvMlFBWTVha1NIMEIrbnlpWFVhZ3R2REp4WEZ1QnJO?=
 =?utf-8?B?Mm14dVRMdnp3R1VZVlEwdnRNOVVoSUlkZ2tPbWZGbXkrRjUybWlQZEo2NlNi?=
 =?utf-8?B?b1VZUFlPWHBQcm9ZSDR0b0dqK0ZheTk5dzEycWhvZzhxZ0pCenp3ZE02U1VT?=
 =?utf-8?B?VzB5c2tuZUJKRlpLQzhONkgrR3dBOGlBdERmOVlwbk9TcTZPa0gvd0Uwa1Jt?=
 =?utf-8?B?SHNqT2pqTDg4Mno3MHRvc0s4S0I1VUh3R0xlS3VvblRNcUJzY2V0S256bko0?=
 =?utf-8?B?YjFsSlh1VDdUZEw0UWxpdE1UV1BvZCt6blc1aTVMRkVCUFpycHVzYzJUTXVx?=
 =?utf-8?B?Snd1SzdXRDN4ZGVVOEFMSmxmcE1icEx1a2czSGFjTHFTdU5VYjgvVmVuYUZ2?=
 =?utf-8?B?VVJ6a2tRbHNOVjdkTkhCK0dVOFA2Z1dSRnJ3b3JNWEtBanNiRTRydnZnMXFk?=
 =?utf-8?B?WU9pRVhnQ1VEQWtPeFZZV1dCQWhnTnZYb3FrYXVUMzlFYmEvZEkxVmRERU9W?=
 =?utf-8?B?NkZtT1JTbk1ELytvQzF4YUcrZHBBYnRZY21DR3hhUGZoYm1kRzZYTzJ6dkVo?=
 =?utf-8?B?aDcxT05RcmdCSTllTEd4U3VJVzJSc0o3S0hPamZQZHpEOGFjVFFuaUhyOTVC?=
 =?utf-8?B?aDBrNTl3TVdjRms1M0tLMm5TOWJZY2xVL2xINnNwazJQS25yMXR2bU1SeSth?=
 =?utf-8?B?djlGbEEwZklmK1FVYk5GcjhLdzlNeWZ3WE8xTXhKVVJacUR5TjZrcDZRRHp5?=
 =?utf-8?B?dEtmQzUwZFNOTk4xcE53ZTR4NnpsaU43YXhDOUZqZW5OZk1HUFRUVXFyaS8r?=
 =?utf-8?B?N1orMkFGSUMxREk4ZjlnSm9LaGcyaUNsK0lCZjJMenhESjVPYWRzd1dOdHRT?=
 =?utf-8?B?aXdBSGFIMWhzWnZWREhLekhhU2ZkTFRGU1dGNjFDWEtkNERyOGtFS2hoVXJC?=
 =?utf-8?B?TkE5S2ZSU2duTEJIUk9jYWtXSTJ3TFM2SWNaWGowSjZFbVRvbW0xVXJ5QS9j?=
 =?utf-8?B?MHhRZGpNR3E1V1F5ejFBYzFWemtlYkJNVUZNaEhXSTUzNFNyUFJxRFJUSmxr?=
 =?utf-8?B?YWRlVGtZMkRiVDV6RWEybHlzSHdXWCtHU3B3S0ZNcytxejBYV0RGYS9tc3FW?=
 =?utf-8?B?dS9jQ29vYkJvbDg5Yi92eEN0bWNZKzdNMWxsWURhN1o4SWM4TTR6bUwyOEt3?=
 =?utf-8?B?RWhQNkYrMTY1Q3dvV0hwYnRscU5wU0hIdkpnU284TE4zbW41cG1KcDIxY2s3?=
 =?utf-8?B?K0xTUitHRlNQY083VUQ0MFR1MjF1ei9lazZieVREMVBma1FVRm9sQ2F0RHpo?=
 =?utf-8?B?cUsxYWpCVEtKV2Z3Y0lFUDdCRXI0bWxTL1QrTW9weFhQS2k0ckZnNlZXMElF?=
 =?utf-8?B?czVxMW9qbDVZeFpaOGVBRGcyS0IwbThZT3R4LzNQK0ZKQkFuNUh4OHhVQWlP?=
 =?utf-8?B?bnFDbEY3N2FlZ3E3bjFvUFI1OGYxTk5CVlFhWmJ2dm1FcU83dU85ZjNkYjM3?=
 =?utf-8?B?Yk9pNHRBVEQyN1crOTRDdGRtWHZTRU1OWlZFcnlDUXIvRDFxK1I0OE52Uy9p?=
 =?utf-8?B?NTVEcXpjU0dtM1lpTUhUYVpueGIrbm1XYThKRWFjQkJPNCtIRjJJTXVBT2s2?=
 =?utf-8?B?QU1ud0VNM2pIb3ljZ3pWWFc3N1ZxWXRmNEduaUlqeEF2eVJFemY5SjlsRkZ3?=
 =?utf-8?B?RnZnektKUHlTNE9VVjRuNG15SkMzMm5kWktLbDhXYk9FNXdkUW9Nd3NETFFQ?=
 =?utf-8?B?NTJZbFJjOHNrSGx6eGI4SkFIZElxUXBiUWNIYkZHdW5CdFF0RHFMMDNkdlNm?=
 =?utf-8?B?ZkhCK0Fxd0s3bHNScHNUdnowQVhvSEJ0THByQmxXU284MGpZVVFRWGJFSG9T?=
 =?utf-8?B?QnhuWmV3V3oxa0hKQjJpcmc4YittR3VhRHZDZ3FVR29LSXluZWtnRkx1aHNE?=
 =?utf-8?B?U0FNNDhtQjFhSDlpS3dvV0JtNWxZZmpFS1hkU1VNaEFGVHVtSHYySW9vRWNZ?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB5386.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab9cd03-67f9-449d-434f-08d9eba65a1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:29:55.6751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tggYWccLf7AKCJJtspPpsXBfWrPMLjMr2P7NINoj0NjZrJCUDPF7HCoGKkfRwneNooB6pUScnWuGBjwn5wEn/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7093
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEts
ZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1
YXJ5IDksIDIwMjIgMToyMCBQTQ0KPiBUbzogU3Jpbml2YXMgTmVlbGkgPHNuZWVsaUB4aWxpbngu
Y29tPg0KPiBDYzogd2dAZ3JhbmRlZ2dlci5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZzsgTWljaGFsDQo+IFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+OyBsaW51eC1j
YW5Admdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0t
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgUmFvDQo+IDxhcHBhbmFkQHhpbGlueC5jb20+
OyBTcmluaXZhcyBHb3VkIDxzZ291ZEB4aWxpbnguY29tPjsgZ2l0DQo+IDxnaXRAeGlsaW54LmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2FuOiB4aWxpbnhfY2FuOiBBZGQgY2hlY2sgZm9y
IE5BUEkgUG9sbCBmdW5jdGlvbg0KPiANCj4gT24gMDguMDIuMjAyMiAyMTo1MDo1MywgU3Jpbml2
YXMgTmVlbGkgd3JvdGU6DQo+ID4gQWRkIGNoZWNrIGZvciBOQVBJIHBvbGwgZnVuY3Rpb24gdG8g
YXZvaWQgZW5hYmxpbmcgaW50ZXJydXB0cyB3aXRoIG91dA0KPiA+IGNvbXBsZXRpbmcgdGhlIE5B
UEkgY2FsbC4NCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLiBEb2VzIHRoaXMgZml4IGEgYnVn
PyBJZiBzbywgcGxlYXNlIGFkZCBhIEZpeGVzOg0KPiB0YWcgdGhhdCBsaXN0cyB0aGUgcGF0Y2gg
dGhhdCBpbnRyb2R1Y2VkIHRoYXQgYnVnLg0KDQpJdCBpcyBub3QgYSBidWcuIEkgYW0gYWRkaW5n
IGFkZGl0aW9uYWwgc2FmZXR5IGNoZWNrKCBWYWxpZGF0aW5nIHRoZSByZXR1cm4gdmFsdWUgb2Yg
ICJuYXBpX2NvbXBsZXRlX2RvbmUiIGNhbGwpLg0KDQpUaGFua3MNClNyaW5pdmFzIE5lZWxpDQoN
Cj4gDQo+IHJlZ2FyZHMsDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAg
ICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQg
TGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0K
PiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYt
OTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0
OS01MTIxLTIwNjkxNy01NTU1IHwNCg==
