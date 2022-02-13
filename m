Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFC4B3B54
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiBMMbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:31:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbiBMMbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:31:48 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30129.outbound.protection.outlook.com [40.107.3.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271A65AEF9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 04:31:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BT51a7PPFE71wKst9wLK5kufxcd8fHfQV0QL61u5zpq2of6ctiN0qeIDfiH2WskmafeKBC8Blj+IqjMqFANCp7W7ODYt21yDLYKKE+8f8ZZ2+TB/Yl16ZBJ+2Wd77RSsOLZIT85G5lfxUP8rojiLkuqH529n1xKMed/q+ubWj6BQnXOvnR7g0ezY+M+Jj1KuZHEUrgc55widdDqziW45uggbXfjfmr2nYnkYNQumqDB2dGDd1m3kePpa+aGJfDTUIQp74Ee339BNWfkscZbB3eTdWV3qv16BbS6n2dzkckEvUVSZ1BZHnnJfaoVrJmucHL3IfVpXaPA3tztwaYHS+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRBFhMtACaUxQkAfWba0TSsvYwR3LjuWBVuNYcUVyp4=;
 b=JiMHAwMRsl6e0VLIycvS8Fv1LMimV9vKbmJbp1Xwgwvm1NoYKjYgyCuhZAml3HH3QZ00k33AuSk61yh3CViUoQHgxCNPow2zvbWM5AH5eQzCndmwpego/F6n3CnzcGRqAY2woEKbFywkCHmWjpJFnAiEx0/wfOUdVD6MMpOwHtTPR5aaxxK+BFFInT2jLV1cU4Qo41BRDv/M8Z8OocZleheLUoFJRZ85ImDzic5/lHkjp8RbRSUisYcTARv63GSXZ5ZrbHg/fZhwNk3UyL5PDWGjEaXzkiLsptD5n4BiGPLIr7ShR8P+9bwuo09F/yeTivL/5Pe3pqaMEAArqvtXpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRBFhMtACaUxQkAfWba0TSsvYwR3LjuWBVuNYcUVyp4=;
 b=gNtxO0sN2gkVDwQbMTWyYzFJy7hyrvO65U/B47Z/4Tf54LqCYKZObMCsDYdaNi3mpNTPs19rzxMqq52b/QF28dpe8/AJNkmKigUaHvoVa3hI0phU+GqmPfQm1Gdqzbf956hTf1hMaoMwqQcbuQY/0ir0CUz0wVvv+VfP39Ew9+c=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM7PR03MB6515.eurprd03.prod.outlook.com (2603:10a6:20b:1c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Sun, 13 Feb
 2022 12:31:41 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Sun, 13 Feb 2022
 12:31:40 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset before
 setup
Thread-Topic: [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset
 before setup
Thread-Index: AQHYH7r64CbbeXDQN0G2aJaj2NZGYA==
Date:   Sun, 13 Feb 2022 12:31:40 +0000
Message-ID: <87iltjuevn.fsf@bang-olufsen.dk>
References: <B3AA2DEA-D04C-49C8-9D22-BA6D64F7A6B2@arinc9.com>
In-Reply-To: <B3AA2DEA-D04C-49C8-9D22-BA6D64F7A6B2@arinc9.com>
 (=?utf-8?B?IkFyxLFuw6cgw5xOQUwiJ3M=?=  message of "Sat, 12 Feb 2022 05:47:49
 +0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a3961c5-a886-4ee4-8df1-08d9eeecc97f
x-ms-traffictypediagnostic: AM7PR03MB6515:EE_
x-microsoft-antispam-prvs: <AM7PR03MB6515F8F0F0844438905D87AA83329@AM7PR03MB6515.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k+UUgpmWL7Sa3F8pFFIzHD2UOH9OepOvWf6lahyF9Rci7ILiQR+O/yxhamN0aVOCWXHPNGbzUWf+GM08ik5gAJwCsXiap4pavqVe3RMW4wYk6tnQpJJxLi7ABlcCHMVkv9y2x9Yk5+KMsVENW4OMqJycjRX+84MV/5tULuWXzYUfgj1/aghLp13q44skoAj8GRb1sAGoOOJL3+VEhSYAY25KCf7zzVrQrVtS/U3Adm8HI+hABSiKFwG4/qsQSjf7Y8gI4SCJS8HREvcMK34mITONz8SyraNsyPgKgEoEiXF++VAngiyUqLUoWNxM2uy/wzj23SfsN1aLIh50Z1foGzIMoIIrNuHSc4Un2k04gi6QoTShW4bhuUXNwJrD5UZ8q98iKNBwYzhXXoj8kQzihURvsD3hkZfty59l4ccO6KNG/KBV7+dEZtzVRjVkEsVI9NWIXjOI3NedWTrCf0/jByEATVMxNU5pEPQTn4wOZg/21IrAeo6+jTkjugIcDtIC41zmdJkgb9Ib6q9b5NBq6zbRxh9LTL96/HlbISE0u/YkWBdJ1axpx/y3GuhgSvv8iPUvD9K3bS1dOBlIA8gVq7t7PL1QdIS33VuDQ4gl5vkfdVwlXvhjtG24SywLEicFHAaKJCZEebXJinzSRZKn/aS1HVrpvP71dw8peu1kL8U1tZYFs2lD5/q3p3VuYm4j/4JkFggz8miBVUbHsm0mtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66946007)(66446008)(508600001)(66476007)(64756008)(2616005)(4326008)(8676002)(2906002)(38070700005)(91956017)(6512007)(122000001)(6486002)(38100700002)(66556008)(186003)(6916009)(54906003)(26005)(316002)(8936002)(8976002)(7416002)(85202003)(53546011)(6506007)(66574015)(83380400001)(5660300002)(71200400001)(86362001)(85182001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm1UcVM1K2tBL2lWcTBCS3JLb3JmY0IxcnJSTlQ4dDIrOUcwM3U3andNYjA1?=
 =?utf-8?B?c0pUck1iQU9jSkNBYTM4bS96N1hNWlArSldSQW5qcGdGb2FyWGVRNUIyYmpz?=
 =?utf-8?B?dUNhUkNQdzRmRVNzNFRDVmVYVzUycm1uTU5mMjROL04zeExPY3o2L2xzKzZT?=
 =?utf-8?B?WVVEK3NIR2JjdDVXdlMrdnVmQkwwWVo3Nyt1ell4SzBZZnM0TjBDWHYyWjYx?=
 =?utf-8?B?QWlHMmdYdFhkcGVJdFgyemVqRC9VeHhiMlk0NkxBeGpzc2RkU0p5S2VVWXNQ?=
 =?utf-8?B?dm1Qbnh5SXFiQ2lhdnEybE1KdUlVNWRVcXltYktKTlI2cFprUmdXUEFJTUtZ?=
 =?utf-8?B?UFd0Yks5ZXNnTlUzWEFYanZadjFPRzFjMyt0R00ySXFEOHQzS1d3MW1wTy8y?=
 =?utf-8?B?UmZqeXlTelpQZ3RyVS9PZnE3d0hTU09Id1BoN2ViN2xzNDM2Q256cnM0OUZD?=
 =?utf-8?B?YWZHRlF6cTVsak9hbDVrU0pmOStJcE1DRHY1UjdIU0cxVlNlTDBmbmdwMUlQ?=
 =?utf-8?B?eWpEQjZhN1FzOVhNNGRCNmtPUmhJMFZZaytGVElaTFFoVHg1Z1JJZGtLOGxy?=
 =?utf-8?B?ZkV3QTlLdGE2VGx2OHJPUk1vVjJZbTBoTjhqOW0yS2N1L2IwQmNvRDM5bmdm?=
 =?utf-8?B?ZWYzWDRDRzZlU1BoTGp5ZzhLQnNiS0NXbTZpdThoVy9Zb2l6ZW50RUc2VHpq?=
 =?utf-8?B?T1lSMjdESkhvbHE0dWNFUzF5VjFvTm5zMmRzbllRK0JvR0QwdEQxR0hzS2dH?=
 =?utf-8?B?VTN5Ui8vRU9hUkd6NmNZdDF0a1lCU2NwNUJvUGs3WC80VDZSWlk2b1NxclVi?=
 =?utf-8?B?d1NsbU1GdGgybVdTUXkvd2kwdC80UGNIbTMvWjg3RzRPbUs4bnF2cVhaditq?=
 =?utf-8?B?a3FnbGFpK004ejNlck84QVRKWEdzY3Zwd2RuMnRIdVhnamZjYmg1bmVJUXMy?=
 =?utf-8?B?eXBzRFdSK2M4VlQ2Wm1hVm5rQTVDMy9YeURBcEt0RWFKSkpzZFI0YlY5ZjR2?=
 =?utf-8?B?a1UwZldrUm83ZkJWOTQ5K0pxKy9ESWVVRFVZenhiU3ZiWGlxZkczWDFaUEJN?=
 =?utf-8?B?UXNIaVlSLzF3YWhucW1tZUFLY09vTzQzV2IyTXF4ajYzZ0o2UzdiOGVxZld1?=
 =?utf-8?B?MzE0aDBKY25OWkNjeXErRG9lRzZ1SkF2bGZrNWVnSzJodkM0Z2JxRi9IbFpx?=
 =?utf-8?B?M0ordDVVTnN4UEthTFFvY29BeFU3ZVlLVVVUa3hqbFdJWklUdWJaRWczaFhs?=
 =?utf-8?B?WlZKck9jSWNrWnNUbzJYUVdQSU5VbXJXSitZKzRNVG42MkY5ZUgxcTEydWU0?=
 =?utf-8?B?VStkcUN3d09SUlUvWUxwdGJxRXJINERRbldhRmVDS1NNUjhzUEw1UHhXaXZH?=
 =?utf-8?B?Q1FSZVkxVnpQTTdURDdyRmhWRGx4aEdTNndwaENGMmRJVUtwaDhxTFViVjRj?=
 =?utf-8?B?bEM5OHRneFpFdTNDT3dlbU4xL0FhemxaTmtPU3ZvUlhEY05yZjQyTzV5aUp1?=
 =?utf-8?B?YTZIZkN2Wk1nOGliamc0MDVtMm9sYmxVbkt2RDg4d2lVTDJSRFdoS0ZkdTNs?=
 =?utf-8?B?cWk2M0N5RHBDQk9JNVU2NDJ3bTNaVmtUd2RudXlTS25HeFM3SEk5Ym5kRG9o?=
 =?utf-8?B?K1BITUtuRjgzQnJZR3FDSmxTcHBvejZiMDRKRXQ1UDlXRUt3TmhTczF1L2VQ?=
 =?utf-8?B?dEh4WEFJQ0FBSWlYTTJJMW9NS2E3cmJjTWtKZFF6Wkp0UmdyNFVxTDFlTHh1?=
 =?utf-8?B?aUErS01EQW9GZXZQY0NrdXRYU0FpRzR2bjdmV0RnWnJXVHJGS0dTVmlvVnhh?=
 =?utf-8?B?bW96YnhLZG1SdktieXdxd3BYTm1KVGpJNG0vVnZwUzljOW1abEV1RG03Qkky?=
 =?utf-8?B?aFQ4QTA0U0xyYXFZend0TWk5UHAvc0RXN3Z3ejBtR1pwOWNVNGdVdE0xUEhC?=
 =?utf-8?B?di9IUEhsc3k5K0EwbURXMGhwWUhjVDRYRGtJVURHZ3llcUx3azVyTTJlL01i?=
 =?utf-8?B?VkpldVlDVEd4NlMrZHpWOFI1c3V5M0pNQ3BuL2YxWFBJa1BKdFVrWWtjZGtW?=
 =?utf-8?B?TGM5NVg1bGc3ME83VFpsK1dNbVRETEVPbUh1TGZ3SGdQajhZL25qdTg1ZTVo?=
 =?utf-8?B?QjJHL1NBZHhiWWkwclIzL25XSXR6d0U0QSt3ejZvcHR0YmRET3BPUVB3QkVY?=
 =?utf-8?Q?mlPy8xMEnKu3NwFWvDr1y+g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <583C58C6B53B5445B809AE0AB5D58DC3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3961c5-a886-4ee4-8df1-08d9eeecc97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 12:31:40.8970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4S17ysBFTpVnrxSTUfQK/V1Ky4vcocCbgUN3u3+Ay5ywcgwcUEixBumBnOM1iwMytUubNASS997r4YjZjdbxEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6515
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPiB3cml0ZXM6DQoNCj4g77u/DQo+
PiANCj4+IE9uIDEyIEZlYiAyMDIyLCBhdCAwNToyNywgTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVj
YSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cm90ZToNCj4+IA0KPj4g77u/U29tZSBkZXZpY2VzLCBs
aWtlIHRoZSBzd2l0Y2ggaW4gQmFuYW5hIFBpIEJQSSBSNjQgb25seSBzdGFydHMgdG8gYW5zd2Vy
DQo+PiBhZnRlciBhIEhXIHJlc2V0LiBJdCBpcyB0aGUgc2FtZSByZXNldCBjb2RlIGZyb20gcmVh
bHRlay1zbWkuDQo+PiANCj4+IEluIHJlYWx0ZWstc21pLCBvbmx5IGFzc2VydCB0aGUgcmVzZXQg
d2hlbiB0aGUgZ3BpbyBpcyBkZWZpbmVkLg0KPg0KPiBJZiByZWFsdGVrLXNtaSBhbHNvIHJlc2V0
cyBiZWZvcmUgc2V0dXAgd2l0aCB0aGlzIHBhdGNoIChJIGRvbuKAmXQgdW5kZXJzdGFuZCBjb2Rl
IHZlcnkgd2VsbCkgY2FuIHlvdSBtZW50aW9uIGl0IG5leHQgdG8gbWRpbyBpbiB0aGUgc3VtbWFy
eSB0b28/DQoNCnJlYWx0ZWstc21pIHdhcyBhbHJlYWR5IGFzc2VydGluZyByZXNldC4gSSBqdXN0
IGFza2VkIEx1aXogdG8gc2VuZCBhDQpwYXRjaCB0byBvbmx5IHRyeSB0aGUgcmVzZXQgaWYgcmVz
ZXQtZ3BpbyBpcyBhY3R1YWxseSBzcGVjaWZpZWQsIGVsc2UgaXQNCnByaW50cyAiYXNzZXJ0aW5n
IFJFU0VUIiB3aXRob3V0IGFjdHVhbGx5IGRvaW5nIGl0LiBTbyB0aGlzIGlzIGxhcmdlbHkNCmNv
c21ldGljLiBCdXQgaXQgaXMgb2RkIHRvIHRvdWNoIHJlYWx0ZWstc21pIHdoZW4gdGhlIHN1Ympl
Y3QgaXMNCnJlYWx0ZWstbWRpby4NCg0KQXJndWFibHkgdGhpcyBjb3VsZCBiZSBzZXBhcmF0ZWQg
aW50byBhIGZldyBwYXRjaGVzOyBzb21ldGhpbmcgdG8NCmNvbnNpZGVyIGlmIHlvdSBkZWNpZGUg
dG8gc2VuZCBhIHYzIHBlciBGbG9yaWFuJ3MgY29tbWVudDoNCg0KMS4gcmVhbHRlay1zbWk6IGFk
ZCBpZiBibG9jayBhcm91bmQgcmVzZXQtZ3BpbyBhc3NlcnRpb24NCjIuIHJlYWx0ZWstc21pOiBk
ZW1vdGUgZGV2X2luZm8gdG8gZGV2X2RiZyBpbiByZXNldC1ncGlvIGFzc2VydGlvbg0KMy4gcmVh
bHRlay1tZGlvOiBhZGQgSFcgcmVzZXQgaGVyZSB0b28sIGJhc2VkIG9uIHJlYWx0ZWstc21pICh3
aXRoDQogICBkZXZfZGJnKQ0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
