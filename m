Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537163D1556
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhGUREw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:04:52 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:36938 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhGUREv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:04:51 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2021 13:04:50 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1230D225678
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 17:36:52 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2050.outbound.protection.outlook.com [104.47.4.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0E57B40065
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 17:36:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXAkhclVKbQVy/u4yO1YKOcc8g7mfY7AiYi8EeRdqUD5kSQf2Ljh81TNJZ0l4kHJz5p6h4OruKTzBICAsfisBmeXdkpcqFLUPDHUNg3PpgV/PNqGSm4Jppevf5jqJNM6ARHfStg8LxdIuxDRQKL8OVl+NSNuVkF+i2khO/hpZPjWeZS2+7jcMGTToozuLJ9JQql2VFGoQXnh0aSOpSa75nrqrSL3+aScEhhMLBJly2YXOs5VolfPbRI2GsYo4SAf3cnjrzmD6BQUHRzK2f77Ms0kmreyi5rKAV24SSWckVxv+PK7P0hnO9iUxD0oWaaOBTbhprchpdRuqLfzmVL6Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAPE2UH42q9jxTjbg95swR28X9eCZ7Z4mota9AjcHiE=;
 b=ZUZ7pcYkJz+pTaxRf+8x9YYIQfmlaDp/nX0eZgf653XcVyqKUaMCcUQ4XFO6e/olyjJiXcPO1pUSA8jdRSFANvBySUKIl9BSPsWk9wIcnPKbYyL5hhLm9G7ewHYzmW27qu3nGyy5mNSk8NJDMeCL1MeqqVHtrfSGwTL2tdCw1trcI00KNzLtKN26DN9Ub4QoSypXXU3d5gBN506msVt9Jk6zzn2E0DEdeOZxHUMNVyYzJ8tUsaU95Nioy8au376Cmqed/VSr+JXsLfTjXHC6Xb7st8GTDs3kdXw9F+vXnD3+mlkjNqG5NQjSV6k0ODOGDmvX6qBAkmbDhk6UQEw7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAPE2UH42q9jxTjbg95swR28X9eCZ7Z4mota9AjcHiE=;
 b=G2+vX9m/TuNcuE6orngM0CWlh1ORjibDsEDtLtp46/DucO0w/LtDO/pv6tLD7JBbaTveZ1EZanwIjwcISJgjhuxrmZU45Cd3LtmB0WUpyjU/OANzSqVTci5WNLwPf6hTXW3fjCAWUxKrc8MWLjoTQ+cHeJLZr3IkNGtM3FTTgTg=
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM6PR08MB5126.eurprd08.prod.outlook.com (2603:10a6:20b:ef::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 17:36:48 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 17:36:47 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Possible GRE-TAP/ECT bug
Thread-Topic: Possible GRE-TAP/ECT bug
Thread-Index: AQHXflb751E7m0FeA02iDt94pqm81w==
Date:   Wed, 21 Jul 2021 17:36:47 +0000
Message-ID: <60DDAD73-D59E-449E-B85C-2A79F41C687D@drivenets.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58d7d49b-664a-4829-040b-08d94c6e1dbf
x-ms-traffictypediagnostic: AM6PR08MB5126:
x-microsoft-antispam-prvs: <AM6PR08MB5126F083FCC4A0905BF958EEBEE39@AM6PR08MB5126.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: exldrQxLC1IKGipROh2Xjhp416EeAStOWIB5CtSDXswBY3IOAV4LsbwhuNFif6cMf5IkvGYG+PNS6u5QcJAjRz3i8x213LlYVPPPz3lrOJ/LYRmvqFi3I/8LVosqdkw5IjVyMRQFi4zHk00nWjS1ws8wJAXy1ic+TSyrrJx23deTQPF5pDZCly99ZJc4TIBTfBA/zYZcZutG9KwCYBI2EJg/9q5Szc540ZIP2tS8jtzALjpr9q7RBgzuPCaAFDrFwCKqPdcMT1QGeZoY3/Slhvw2V7zRurTzg59IptXXQVe9hi+9WetZZ0ewFtJubEn/2anQmNoh5gfvxdMeufXo9h4HXsMu9PeVgzr9RrW7rw3QZqzHFCANQAwVgJgDkAVeMN9IRH46tsSWe0EUnlqPUYQvZLskARW9ZNBZ41D7aq+VbXkJBFoQZTM7+Sj3rwL6Y5kRW0exyBjSgObPKC1gb+F1eU2OjqjRt/dTYiZNsg+/DSn0z6hxo/AkPdhux/h13dhgFA8tSk4D2cxkPsyNZDHr0zE7FOcYg6I8AD0kppa6ci1e4lJs49/95zQ4B4xR7a0q+WFT5hdy3Z1VwulaMKZnMJZoZO4ZjWXonKrmtsZX0gndtfRf6zmDDozMCYT5BFBRRlR7dDb3XiqZUczc/Vb24MrsJHRELqUVK6jMptSQFLI81ZkHd0ER8ehXeGNv421fw7N1vH3gvHqMIxeKhwQI0T6a7GjZkyFjIM+60Q4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39840400004)(396003)(376002)(3480700007)(6512007)(76116006)(66946007)(6506007)(91956017)(8936002)(6486002)(86362001)(122000001)(6916009)(33656002)(66476007)(38100700002)(66556008)(186003)(5660300002)(478600001)(36756003)(71200400001)(2616005)(64756008)(8676002)(316002)(26005)(66446008)(2906002)(45980500001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1VxcldYR2c3eU9WWkF2d3dRTlRseHhwRVE5SVJ4VlhJQXR2YVVsT0d5ZFJr?=
 =?utf-8?B?bXBDTmkzYnYxcUgrSXROZ3djUzg0ejlEYlBMWHArNHpmYlV6SkZwb3VJdFQx?=
 =?utf-8?B?YVNkTXgyRUxZYytQNzV2OGxFOFFzVGNTY0dyMG9LQnVyMTZmZFFaVUN0MGxM?=
 =?utf-8?B?dHNNWmo1SDNRR1c3RldxK2hOTjliSjk5MVdGZEdsYnJoOG5zRk1SS3I5RzVS?=
 =?utf-8?B?bGpYTzlGM2ovYjZ0VUFJZUlzd2xJTW5LV0M3MkdZT3BVMGRmMlFhbzRVa0ov?=
 =?utf-8?B?Sk1NRG5nQkNYMVFvWU9uQlM2N0RPZlJFQ05QUVZDbUtlR0hPWVA0aHBjL0hN?=
 =?utf-8?B?dEJuQVQ0V2tiY3M5L3dkM3NoQUNBci9scUh0MlFSbFZSMk9jQkNrek1WNUpk?=
 =?utf-8?B?UTI0emU2VkF1LzNObUo3b1dxVGxsc0dPZmM5K1FQa1d3MVgzYXlzTEFJNE9J?=
 =?utf-8?B?WVg4Y1I2S08wdG5zNzFrak03dE9iOXd0TWpYMnpCeUNwQk1Pb3NyajhPR21V?=
 =?utf-8?B?SHZLUng5Zjh0dTkzWVhpKzRxUnZHOUhYRlcxOG5hY0NWSWFyU3BHMVB0Vkly?=
 =?utf-8?B?MHBUQWFwbDdqS3FpSWhtOFZaYVIvS1VWQWdaRCs2TXE5YkV4SGFtN3JwMjVF?=
 =?utf-8?B?SVBuVlpDWDJudHRTUnJMOGZBcFd1VW93NEI4V0ZGRzR2NThHeW8rUXN5dFBa?=
 =?utf-8?B?Z1QyTmZUcXBxbitLUDBYK3JrNFFTSHFwazVHYWhkdEcwcmNza1ozSkFiMERE?=
 =?utf-8?B?TVdyVjg3U1BDdDNuTFYydFcyWkxOUWE4a1hOZWJaMW9BaE90cU8wOWFsR1p2?=
 =?utf-8?B?M1pNZG5lclltYXNOdFY2dEY4aW5tbzVSMWVzVjZqRTZtS2xicTZweUJJb0lQ?=
 =?utf-8?B?NHdqMjVHY0FacndEbGtoaUF5VVhmTzdjaGpnNk1jaERyck94SCt1ZWhIS09H?=
 =?utf-8?B?QzhoZzUzOWp0cEZaOHcxZDZaUnozTmpmSlVWeU1jbGlNWGRRcFhBV1R2R0Rw?=
 =?utf-8?B?TkFXS1lwNnN5R3pBZ3llSjJMYnFXR2gwM04xZnFINHU4MHVtS1BhcE80K2VD?=
 =?utf-8?B?aE5hVkZrOG9nTno2L3RvRXVxTS9IRllGL1A1eS8yOGdXcElRMmEyWWZWVCtZ?=
 =?utf-8?B?dy9CM3gvMDgxbVZnZENZbEplRVhnbEFLbDNQc29kVFFkTGNHY3FKYkVvamRt?=
 =?utf-8?B?ajc2OHluL2RVYjFZZlA0dDd4OHpZKzFMRnAwZTBmb3JtSHEwUFp1WUV4akZ5?=
 =?utf-8?B?WklTWk5obnhNYmNyTW9yQkE0bnJOd1IrT3hXNGNER1N3aDdQVm5aQVdOajQv?=
 =?utf-8?B?V1Vsc1ZoZ3NGelZZTG9uTVVyOUU0bVlaTmxxUWFjbGZZZDl2RHJRYjBncjd0?=
 =?utf-8?B?aXhnbSt5SUIwakVFbmYvNzZPWHBXMHlFN0QwY2hhN3I0cnpyRnVwWk5EWW81?=
 =?utf-8?B?SlVTc2NJdWJqTjZCcmI2aitJQ0t4Kyt5cUhGMDc0L2JETEZURXhsR3VGc3Vr?=
 =?utf-8?B?Tlh3elFYZzJIRGluczhGNUUxSDUzeVMzRVVBRENMOGp0enZPc0xUMVJ0K1FO?=
 =?utf-8?B?eDc5TU9vL2lyUytTS052cVo4ZHZOcWJlOStQV1diRXU1SXY0b2U1enlua0x0?=
 =?utf-8?B?K3JnNDZIbHE2dEJXL1pXMXIvSHg3V2U2cnpPSGFGRnUzdmpqTnAxRDljVk5k?=
 =?utf-8?B?TVNhbkJ3UVdwSmZRV21DWEVMMVEzVE4yYUZLREtJNk9wQmtnR00wVmRGUVY2?=
 =?utf-8?Q?yFjW9VYV81iB2f3ZGW4Dy6cNynaZIXYM9E3m0Ue?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <393B591BCE2D424A967F7B9BFEAA92AD@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d7d49b-664a-4829-040b-08d94c6e1dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 17:36:47.8027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z5OBu2hsRt8AOrRlRENblZcA2C0OgixUcZnHuXzGtGv8BvOjhfjTo2syTzQbIFRaeByJHFX7/lY/qHboV9GooA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5126
X-MDID: 1626889009-z_k1yWHs9qAG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGV5LA0KDQpXZeKAmXZlIGVuY291bnRlcmVkIGEgYnVnIHdpdGggaGFuZGxpbmcgb2YgdGhlIEVD
VCBiaXRzIGluIEdSRS10YXAgZW5jYXBzdWxhdGVkIElQdjQgdHJhZmZpYyBvbiBLZXJuZWwgNS40
Lg0KDQpUaGlzIGJ1ZyBtYW5pZmVzdHMgd2hlbiBhIHBhY2tldCBpbiB0aGUgZm9sbG93aW5nIGZv
cm0gZW50ZXJzIHRoZSBzeXN0ZW06DQoNCistLS0tLS0tLS0tLSsNCnxJbm5lciBJUHY0IHwgICAg
RUNUPTBiMDANCistLS0tLS0tLS0tLSsNCnxFdGhlcm5ldCAgIHwNCistLS0tLS0tLS0tLSsNCnxH
UkUgICAgICAgIHwNCistLS0tLS0tLS0tLSsNCnxPdXRlciBJUHY0IHwgICAgRUNUPTBiMDEgIHwg
IEVDVD0wYjEwDQorLS0tLS0tLS0tLS0rDQoNCldoZW4gaW5zcGVjdGVkIGJ5IHRjcGR1bXAtaW5n
IHRoZSBvdXRlciBpbnRlcmZhY2UsIHRoZSBwYWNrZXQgaXMgZmluZTsNCndoZW4gaW5zcGVjdGVk
IGJ5IHRjcGR1bXAtaW5nIHRoZSBHUkUgaW50ZXJmYWNlLCBhIHNtYWxsIGFtb3VudCBvZiBiaXRz
IGlzIGNoYW5nZWQgaW4gdGhlIHNvdXJjZS9kZXN0aW5hdGlvbiBhZGRyZXNzZXMgb2YgdGhlIGlu
bmVyIEV0aGVybmV0IGhlYWRlci4NCg0KVXBvbiBmdXJ0aGVyIGluc3BlY3Rpb24sIHdlIGZvdW5k
IG91dCB0aGF0IHRoZSBiaXRzIGNoYW5nZWQgaW4gdGhlIGV0aGVybmV0IGhlYWRlcnMgY29ycmVz
cG9uZCB0byB0aGUgcG9zaXRpb24gb2YgdGhlIEVDVC9DaGVja3N1bSBmaWVsZHMgaW4gdGhlIElQ
djQgaGVhZGVyLg0KSW4gb3RoZXIgd29yZHMsIHNvbWUgY29kZSBwYXRoIHRyaWVzIHRvIGNvcHkg
dGhlIEVDVCBiaXRzIGZyb20gb3V0ZXIgdG8gdGhlIGlubmVyIElQdjQgaGVhZGVyIGFuZCBjb3Jy
ZWN0IHRoZSBjaGVja3N1bSwgYnV0IGl0IGFjY2lkZW50YWxseSB0cmVhdHMgdGhlIGV0aGVybmV0
IGhlYWRlciBhcyBhbiBJUCBoZWFkZXIuDQoNClVuZm9ydHVuYXRlbHkgdGhpcyByZXN1bHRzIGlu
IHRoZSBsb3NzIG9mIGFsbCBJUHY0IHRyYWZmaWMuDQoNClRoaXMgZG9lc27igJl0IGhhcHBlbiBp
ZiB0aGUgaW50ZXJuYWwgcHJvdG9jb2wgaXMgSVB2NiBvciBJUy1JUywgb3IgaWYgdGhlIGV4dGVy
bmFsIEVDVCBpcyAwLg0KDQpXZeKAmXZlIHRyaWVkIHRvIHNlYXJjaCBmb3IgcGxhY2VzIHRoYXQg
bW9kaWZ5IHRoZSBgdG9zYCBmaWVsZCBvZiBhbiBza2IsIGFuZCBmb3VuZCBqdXN0IGVub3VnaCB0
byBzYXkg4oCceWVzLCBzb21lIGNvZGUgd2FudHMgdG8gc3luYyB0aGUgRUNUIGJpdHPigJ0sDQpi
dXQgbm90IHRvIGZpbmQgdGhlIHJpZ2h0IG9uZS4NCg0KTW9zdCBwcm9taW5lbnRseSwgeGZybSBk
b2VzIGp1c3QgdGhhdCwgYnV0IGFzIGZhciBhcyBJIGNhbiB0ZWxsIGl0IGlzIG5vdCByZWxldmFu
dCB0byB0aGVzZSBwYWNrZXRzLg0KKEl0IGlzIGRvbmUgYnkgY2FsbGluZyBgaXB2NF9jb3B5X2Rz
Y3BgIGZyb20gYHhmcm00X3JlbW92ZV90dW5uZWxfZW5jYXBgKQ0KDQpXZeKAmXZlIGdvbmUgb3Zl
ciB0aGUgaXBfdHVubmVsLmMgY29kZSBkbWVzZyBzaG93cyB0aGF0IGBpcF90dW5uZWw6IG5vbi1F
Q1QgZnJvbSAxMC4yNTQuMy4xIHdpdGggVE9TPTB4MWAgaXMgcHJpbnRlZCBmb3IgdGhlIHBhY2tl
dCBtZW50aW9uZWQgYmVsb3cuDQoNCldvdWxkIGxvdmUgaWYgc29tZW9uZSBjYW4gZGlyZWN0IG1l
IGF0IHdoZXJlIHRvIGxvb2sgZm9yIHRoaXMgRUNUIGNvcHlpbmcgY29kZSBmb3IgZnVydGhlciBh
bmFseXNpcy4NCg0KVGhhbmsgeW91IQ0KDQoNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCg0KQXMgYW4gZXhhbXBsZSB0byBhIG1vZGlmaWVkIHBhY2tl
dCwgaGVyZeKAmXMgYW4gSUNNUCBwaW5nLg0KVGhlIHNlbnQgcGFja2V0IGlzDQoNCmBgYA0KPElQ
ICB2ZXJzaW9uPTQgaWhsPTUgdG9zPTB4MSBpZD0wIGZsYWdzPSBmcmFnPTAgdHRsPTY0IHByb3Rv
PWdyZSBzcmM9MTAuMjU0LjMuMSBkc3Q9MTAuMjU0LjEuNiB8PEdSRSAgY2hrc3VtX3ByZXNlbnQ9
MCByb3V0aW5nX3ByZXNlbnQ9MCBrZXlfcHJlc2VudD0xIHNlcW51bV9wcmVzZW50PTAgc3RyaWN0
X3JvdXRlX3NvdXJjZT0wIHJlY3Vyc2lvbl9jb250cm9sPTAgZmxhZ3M9MCB2ZXJzaW9uPTAgcHJv
dG89VEVCIGtleT0weDQ5MDAwMDAwIHw8RXRoZXIgIGRzdD0xODpiZTo5MjphMDplZToyNiBzcmM9
MTg6YjA6OTI6YTA6NmM6MjYgdHlwZT1JUHY0IHw8SVAgIHZlcnNpb249NCBpaGw9NSB0b3M9MHgw
IGlkPTM1NzE3IGZsYWdzPURGIGZyYWc9MCB0dGw9MSBwcm90bz1pY21wIHNyYz0xMzAuMTMwLjEz
MC4xIGRzdD0xMzAuMTMwLjEzMC4yIHw8SUNNUCAgdHlwZT1lY2hvLXJlcXVlc3QgY29kZT0wIGlk
PTB4YTZlYiBzZXE9MHgzMzFlIHVudXNlZD0nJyB8PFJhdyAgbG9hZD0nXHgxZVxceGYzXFx4Zjdg
XHgwMFx4MDBceDAwXHgwMFpOXHgwMFx4MDBceDAwXHgwMFx4MDBceDAwXHgxMFx4MTFceDEyXHgx
M1x4MTRceDE1XHgxNlx4MTdceDE4XHgxOVx4MWFceDFiXHgxY1x4MWRceDFlXHgxZiAhIiMkJSZc
JygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWicgfD4+
Pj4+Pg0KYGBgDQpvciBpbiBoZXg6DQo0NTAxMDBhNzAwMDAwMDAwNDAyZjYwMjUwYWZlMDMwMTBh
ZmUwMTA2MjAwMDY1NTg0OTAwMDAwMDE4YmU5MmEwZWUyNjE4YjA5MmEwNmMyNjA4MDA0NTAwMDA3
ZDhiODU0MDAwMDEwMWU0ZjI4MjgyODIwMTgyODI4MjAyMDgwMDY0MTFhNmViMzMxZTFlNWM3ODY2
MzM1Yzc4NjYzNzYwMDAwMDAwMDA1YTRlMDAwMDAwMDAwMDAwMTAxMTEyMTMxNDE1MTYxNzE4MTkx
YTFiMWMxZDFlMWYyMDIxMjIyMzI0MjUyNjI3MjgyOTJhMmIyYzJkMmUyZjMwMzEzMjMzMzQzNTM2
MzczODM5M2EzYjNjM2QzZTNmNDA0MTQyNDM0NDQ1NDY0NzQ4NDk0YTRiNGM0ZDRlNGY1MDUxNTI1
MzU0NTU1NjU3NTg1OTVhDQoNCg0KDQpUaGUgcmVjZWl2ZWQgcGFja2V0IGlzDQpgYGANCjxFdGhl
ciAgZHN0PTE4OmJkOjkyOmEwOmVlOjI2IHNyYz0xODpiMDo5MjphMDo2YzoyNyB0eXBlPUlQdjQg
fDxJUCAgdmVyc2lvbj00IGlobD01IHRvcz0weDAgbGVuPTEyNSBpZD0zNTcxNyBmbGFncz1ERiBm
cmFnPTAgdHRsPTEgcHJvdG89aWNtcCBjaGtzdW09MHhlNGYyIHNyYz0xMzAuMTMwLjEzMC4xIGRz
dD0xMzAuMTMwLjEzMC4yIHw8SUNNUCAgdHlwZT1lY2hvLXJlcXVlc3QgY29kZT0wIGNoa3N1bT0w
eDY0MTEgaWQ9MHhhNmViIHNlcT0weDMzMWUgdW51c2VkPScnIHw8UmF3ICBsb2FkPSdceDFlXFx4
ZjNcXHhmN2BceDAwXHgwMFx4MDBceDAwWk5ceDAwXHgwMFx4MDBceDAwXHgwMFx4MDBceDEwXHgx
MVx4MTJceDEzXHgxNFx4MTVceDE2XHgxN1x4MThceDE5XHgxYVx4MWJceDFjXHgxZFx4MWVceDFm
ICEiIyQlJlwnKCkqKywtLi8wMTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZX
WFlaJyB8Pj4+Pg0KYGBgDQpvcg0KMThiZDkyYTBlZTI2MThiMDkyYTA2YzI3MDgwMDQ1MDAwMDdk
OGI4NTQwMDAwMTAxZTRmMjgyODI4MjAxODI4MjgyMDIwODAwNjQxMWE2ZWIzMzFlMWU1Yzc4NjYz
MzVjNzg2NjM3NjAwMDAwMDAwMDVhNGUwMDAwMDAwMDAwMDAxMDExMTIxMzE0MTUxNjE3MTgxOTFh
MWIxYzFkMWUxZjIwMjEyMjIzMjQyNTI2MjcyODI5MmEyYjJjMmQyZTJmMzAzMTMyMzMzNDM1MzYz
NzM4MzkzYTNiM2MzZDNlM2Y0MDQxNDI0MzQ0NDU0NjQ3NDg0OTRhNGI0YzRkNGU0ZjUwNTE1MjUz
NTQ1NTU2NTc1ODU5NWENCg0KDQpOb3RlIGhvdyB0aGUgZGVzdGluYXRpb24gYWRkcmVzcyBjaGFu
Z2VzIGZyb20gYDE4OmJlOjkyOmEwOmVlOjI2YCB0byBgMTg6YmQ6OTI6YTA6ZWU6MjZgLg0KV2hl
cmUgdGhlIGxvd2VyIDIgYml0cyBvZiB0aGUgc2Vjb25kIG9jdGV0IGFyZSBvdmVyd3JpdHRlbiB3
aXRoIHRoZSBFQ1QgYDBiMDFgLg0KDQpUaGUgc291cmNlIGFkZHJlc3MgaXMgdGhlbiBjaGFuZ2Vk
IGZyb20gYDE4OmIwOjkyOmEwOjZjOjI2YCB0byBgMTg6YjA6OTI6YTA6NmM6MjdgLCBwcm9iYWJs
eSBhcyBhbiBhdHRlbXB0IHRvIGZpeCB0aGUgY2hlY2tzdW0uDQpJbiBwcmFjdGljZSBpdOKAmXMg
YWx3YXlzIGluY3JlbWVudGVkIGJ5IDEsIGV2ZW4gdGhvdWdoIEnigJltIG5vdCBzdXJlIGl0IHJl
c3VsdHMgaW4gYSBjb3JyZWN0IGNoZWNrc3VtLg0KDQpJZiB0aGUgTUFDIGFkZHJlc3MgaXMgY2hh
bmdlZCBvbiB0aGUgaW50ZXJmYWNlIHRvIG1hdGNoIHRoZSBFQ1QsIG9yIHRoZSBvdGhlciBFQ1Qg
aXMgdXNlZCBpbiB0aGUgcGFja2V0LCBub3RoaW5nIGNoYW5nZXMgYW5kIHRoZSBwYWNrZXQgaXMg
cmVjZWl2ZWQgY29ycmVjdGx5Lg0KDQo=
