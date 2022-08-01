Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94CC586E0C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiHAPta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiHAPt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:49:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491B53335A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 08:49:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjPIz3jENONIVAIfShwx1oCZWb4NoO0DT3or4RNkLUL4oCY4EVzJpykAow7CWE277i26spTPUbrINR8cY5TU6ONkryb+DQ1RH9WuXRD91CELE18T5Dc1q1yz6nKwTzVA2y6BTYhOlXWcIXAwHB3vw0uRlRlv42vIAAMc2PKSSlFlOWODFarFqpPCHUJuefqmgE52g2FCxo9KRXgpQO1I+W9pvHBiq0MZXekTHlx2NU+ITNCxn8R5C8yvSMCXwJp8w79dXv7f65TJmOROWgVKhlfAt43lQm1RcJNAZnDCUR2A/l2QTqvnUiOH/4Wt0LcWT5MC+HmHg/TLM+RCaWSenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axpw9G5hCsJqwRMjLuwJIfPDdeutDG73fxiry4F4GPg=;
 b=g77dxoR1gdMR5nNn+eqhlOSDek0pQOta5uPymEvkSH0jbGYs5AYdlg0nW8k1BhuMRTC3DLCAkVgKiLPLDN9ASMbx6lqTG6t3jz4jZOwedrL2+uSAq1VAVz6W15eiMfUukxYbKZxKAe2rYIkiBmtqrKaOus6/bKMUncwyux5f9+X2+2YbEuRBX6KAxYcSbpULzh9Hx4eTee5Sc1lFwiwlbtbxIyLaE4IyM7lGB6aPbHDkXxnbxBn8FTtV7ltX/J0w1WTcVUKsRQfJUiKI1zdi6DFQ0GPO2I2Zkc7DosM2jEyHfblQVQI666Q+fVcx2/a7fs6rrCmx8/M/Yo4vAJQvVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axpw9G5hCsJqwRMjLuwJIfPDdeutDG73fxiry4F4GPg=;
 b=UMS8SC7EX2FJ7Yize39YV1C++/LuFTwxa5xx0thF1fjSvH+bonBi4gBJqAwnNg0IC+/BgVCkRgxlaBwGYj2HJk7/nlgBz7E8wn/nydyJb6yLBVSOzczm71UWqqjEalAo9jIiTcInhv/9O1ngLfcczTZB2addbhq++cCz8x2UW/Tecr4FI8Dji9Lg9gbCS9ZCRqMz0khikmdYKCpmBI/PNxBKmWv13JeWkRNdsJlpgjbLzZNE6WBf0yGmWT5gaBLuJ8iV6ycGxEMJJOLiwlxj9sJsbz9SOfZz3OwUhK0bHa0a1mdh5YxiUrT4KPG9zCc20LHHa8bUW5MkMinWGJaVyQ==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB3104.namprd12.prod.outlook.com (2603:10b6:208:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 15:49:26 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 15:49:26 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>
CC:     "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Thread-Topic: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Thread-Index: AQHYo0S40mUHMPrn60ubYFdJ/lMLJq2aElOAgAAjsIA=
Date:   Mon, 1 Aug 2022 15:49:26 +0000
Message-ID: <e87bd57d938ff840b567a05ceb1417cfb9f623e1.camel@nvidia.com>
References: <20220729121356.3990867-1-maximmi@nvidia.com>
         <YufYFQ6JN91lQbso@boxer>
In-Reply-To: <YufYFQ6JN91lQbso@boxer>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27fd2524-af5f-452b-30c3-08da73d5698a
x-ms-traffictypediagnostic: MN2PR12MB3104:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VwnAlq4ox9E0W2oGGtPge231bgT0bLOeMCKGcal4h6rOS8MRxZlN9uk2MDKHn+8LN7OHV4NGBwLRFwn4WLd5U2HJjEf44p9vXK2cRXwqXmuIQf2fkXiEC6TkmryfGjCqfdjDITzEkOVX2MzmQiva+6Dn7a+8SS+y3Faveo4LDeADxuwgvp/DCJKiclfIucBEQbYpEqDhCBJeQtN7JqIO1XlQF3ROhfAnPP2icJt+ySCRrxQNgOqsnkQR4eqVOxH4kd/MC5e3Dbuh35E16ISRjDZ/1kishW6DkzE5O0UyKB4/EZ3c8k9yiKGZ8QkPiiYfIVS1wz61rLZ6FRnSOqHt3Geewuwj0YMaVBh1fm3wyK6i5R2zWG/2uhg5zhVfjIGViK34B5B24FD35SwG0VTvIX6rKPGZyzD9eKMllQq8AKj6HHTH7d9JV39GHF1YTXFwzqzcDphicUtcZFCwy81GqrVhZprdrMUIlHIWUeyuZ/qdT48IC13vHknZYDox+hbyTmPijQefqiRfNslTe7qVuzbJK5ZEA9EM8ppyqccyWgLoD5OCCMMpU91Qo9TO6MF3ZEO0WkSqFc4Y60Uelg6AqTxsDRQAYZ+XNGZnBdphtqfMHx/nILFU/0rIoSl93NpXsgbRv5jv07E6qqIDEsdFOFr65rWfWTsFZSVlSJH+BTtkyA0zF4AtnWrpQVzLv+3SrWRp4tCcd4UQoHcvnvA71STesI7ro3L05r0gQlHdUrr2+6Tq+N00x3APho4yr3HobJ5QwpNpc/cfv6uQLe2ryW4J7iNdeqgZuuU03PsrQfVF/Ls7uKI8pr5jrI63Hmrw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(6486002)(76116006)(66946007)(91956017)(4326008)(71200400001)(66476007)(66446008)(64756008)(66556008)(41300700001)(6512007)(8676002)(2906002)(86362001)(2616005)(186003)(478600001)(7416002)(5660300002)(6506007)(8936002)(36756003)(316002)(54906003)(6916009)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU5CNXRNaGxjejVDZTExZksrRWJaWHpPMCtLT0dnWkd0T3NCaGszcUpHSk0x?=
 =?utf-8?B?NmdYc3pYd0gyUnV5SS9NY3VHUFRHeU0vZ3VwL2RsL3BwZ3lyZHE5YW0valpX?=
 =?utf-8?B?MTNzMTZpeXpweVpEVTdqOWgvNDJCRGhyWDR0aGFzT2NYbytDZDViN09JSTNY?=
 =?utf-8?B?ZDRZMnVYYmZudzQyWmh6OHI2SmlIVEYyYS9yOEdqNU40NE1ST1dHdHJTM0Y5?=
 =?utf-8?B?RVQ3SVIwb2ZSbUQvSmxKRUQzYlkxa0swSFlzamF0eUQvUmJOUjBWN0x3c0p2?=
 =?utf-8?B?QWtUR0h4WWt4ZFA2L2g4U1YycytFM2JBb3hQZmNHU1pzZHpMNU4zWHlVNnZX?=
 =?utf-8?B?ZXJQMFRYK0duZUF1VUxObVZ1YWhhYmNVOE0zTndVajNOUllXb0swQ00yTDY3?=
 =?utf-8?B?cXc4RzJTc1kzYlAyRG1wWWJEUnp0UUlvV2NKY3RCTFg1WGpMUGpJMzZXdUpn?=
 =?utf-8?B?eE5DL21TOEVZYi9LRTRuRTNKcC9GcTRxb0VPL1JSeXlFdlVtQVdYMVNCRjdK?=
 =?utf-8?B?UDk3SmUxWUZBeXpiN2J1WVBwU1dZUHpicXNCSkt0U1JKSThHRks3MThRMzVN?=
 =?utf-8?B?SG1kL2RSZ1kvVFNTNytPK0Y4OFNoY1FFMnhvVnB0Wm9meGhXT1BNc0F2allT?=
 =?utf-8?B?bGlORGxSRXlveDkwY2NhcGZ3ZjdkZ25xak1kSTFlU0pQTXJ1d1ZBTUR0ZWQ3?=
 =?utf-8?B?eFVvZmVHN1BPQ1dQOFZPTVBJdno3aGNuNXZCR1NOTjlaZWFzZTBZcGFmcjlU?=
 =?utf-8?B?UnVuNXB5Yk9WTGVRQVRtTGN1L0tlNFpucmlITTBtQkNTSE4rbEtmVGtMb3Fv?=
 =?utf-8?B?ZFJzbloyMXdYblB3L0dsUGdtak5MQ2VSeW1GMVBVT2ZlQ0pqT2NQZ0s2WlpI?=
 =?utf-8?B?OHlCWjNoM0R5dWQ5NXpZRURNeHA0dW1HVllnSjQrWlNndC9MSHhEWS85dy9w?=
 =?utf-8?B?Wm16eXppaTlaekFCYldqTDI3OHVzaGJmbjhpTEFvZS80MTNWQklnMlBOK1hF?=
 =?utf-8?B?eEZaUzNpVDk5dUQvVDZsTGtoNUlZZFJnVi9TK3J3elVSY3YzbjBsNi9peVR2?=
 =?utf-8?B?SXVXOVdNMnRTbEpMSWdQY3ptWWNrUXg4c0o3N21mZUhZR2YxSU1PZXB1eVhj?=
 =?utf-8?B?K0RyS0tzOHBUcHpGeUlFZVRmZGZlNzY2VmJzYVdIU3J6Y0RCcmxocHhEVHVl?=
 =?utf-8?B?TUJzT2VpeS9VOE1qYW82SlFTaGVicFIxbmFRQjIrK1MvODZuNUFsUW10YU9t?=
 =?utf-8?B?WTZqZ2tkZW5DUk80NWFDUG9RL2RRT2FXejYybEkzaUp4elEzcW5QaWJSSTlI?=
 =?utf-8?B?VWJPZy9ES09ZOUhiWHk4T2dZMFhLaXhaczVzSGl4VGdJa3dyRGxsYjRISmkv?=
 =?utf-8?B?dFI1Mk43d0ZKU2k0NXZQUnRZRHcyNjAwUXQ3L2hvYi9jcEtUTXpNMW9RY0VD?=
 =?utf-8?B?d1R3SkxhT1RSTDQ2TkNFQ0tBVzdtMG1kSVdZdWs3S1djT1ppWk1QQUJxQ3JX?=
 =?utf-8?B?am1NOU5CVVcrTHZtNkx1WVZySVFST1cwQ1hNOE16V3cyQ1FoWVBGL0RNTjY0?=
 =?utf-8?B?cWxBSWpMcHJ3eGVRc2ZnWnNVd2tKUlNMakI2d3U0UGxyejlHVDdXZ1VCcjAw?=
 =?utf-8?B?VGRDQW9sUXIxc2k2UmJiT09EWCt3Zkc4VXVDd0lnTkJxSVBiMnNaY2QvazB3?=
 =?utf-8?B?VDhselFYa2tiUTYxMS8wbHpoYThvTWcxcXJoaDV2SzhNcVpmWHBOMC9uZmts?=
 =?utf-8?B?ZHdwSkNVeDZFbGxjeFJ1VUU1UUtlVWdCNFpNMlRrK2NzQk9ydmtIZWRHcjF2?=
 =?utf-8?B?N1VnK1lmbzQyN0IwUEZrM21KMnhCekl6TG9HZk5XVnNJMS9Bczd4NE9oY3pZ?=
 =?utf-8?B?Zm8yMDhQOW9hRFNtMm1FYlZWTGtNRms5Rk9uVjRVejF0a3p0ZjVTbGM2QytM?=
 =?utf-8?B?TDNVQ1JGZy8veVFDZjR1QTNVMlAzaVVzWDNWcVJ4am5VUVZ6Ny9BK01ndnpi?=
 =?utf-8?B?OVBTUTR0VFFUeFRqdFErRGk0LzQrcjdwVnFvRnVvb3ZzY3QrOTJhMzZZUUZY?=
 =?utf-8?B?blNoMGJPSDlTanZMUDJ1Z0JMcEUyZEFXVWNDTGc3MlVDN0JRNTVKTWh3REZO?=
 =?utf-8?B?MldNb3NtR3VpQnBGNmNvTFQyOGhXUmUzeGhXOGhDLzJvYWVweWNBNXN0YnhL?=
 =?utf-8?B?UEdVNmZhVmNhdnE2dVJwS2VHTWRrRG5CMkFTVVR1ODNxamNMdXFvTnRHM04x?=
 =?utf-8?B?RUxCUnlhMlVjS05QYkJXTEl4ekVRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D4765958A557E448488B08264DF8E8A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fd2524-af5f-452b-30c3-08da73d5698a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 15:49:26.1614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzy6vcDqJKa13wZC6vPD3SIk/klHRoRBG4kKK4jJ68PZlR479k2H2HrcD6N8mLFZTVf5ml2O8hfisorTGW3arg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3104
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rmlyc3Qgb2YgYWxsLCB0aGlzIHBhdGNoIGlzIGEgdGVtcG9yYXJ5IGtsdWRnZS4gSSBmb3VuZCBh
IGJ1ZyBpbiB0aGUNCmN1cnJlbnQgaW1wbGVtZW50YXRpb24gb2YgdGhlIHVuYWxpZ25lZCBtb2Rl
OiBmcmFtZXMgbm90IGFsaWduZWQgYXQNCmxlYXN0IHRvIDggYXJlIG1pc3BsYWNlZC4gVGhlcmUg
aXMgYSBwcm9wZXIgZml4IGluIHRoZSBkcml2ZXIsIGJ1dCBpdA0Kd2lsbCBiZSBwdXNoZWQgdG8g
bmV0LW5leHQsIGJlY2F1c2UgaXQncyBodWdlLiBJbiB0aGUgbWVhbndoaWxlLCB0aGlzDQp3b3Jr
YXJvdW5kIHRoYXQgZHJvcHMgcGFja2V0cyBub3QgYWxpZ25lZCB0byA4IHdpbGwgZ28gdG8gc3Rh
YmxlDQprZXJuZWxzLg0KDQpPbiBNb24sIDIwMjItMDgtMDEgYXQgMTU6NDEgKzAyMDAsIE1hY2ll
aiBGaWphbGtvd3NraSB3cm90ZToNCj4gT24gRnJpLCBKdWwgMjksIDIwMjIgYXQgMDM6MTM6NTZQ
TSArMDMwMCwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiA+IFN0cmlkaW5nIFJRIHVzZXMg
TVRUIHBhZ2UgbWFwcGluZywgd2hlcmUgZWFjaCBwYWdlIGNvcnJlc3BvbmRzIHRvIGFuIFhTSw0K
PiA+IGZyYW1lLiBNVFQgcGFnZXMgaGF2ZSBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzLCBhbmQgWFNL
IGZyYW1lcyBkb24ndCBoYXZlDQo+ID4gYW55IGFsaWdubWVudCBndWFyYW50ZWVzIGluIHRoZSB1
bmFsaWduZWQgbW9kZS4gRnJhbWVzIHdpdGggaW1wcm9wZXINCj4gPiBhbGlnbm1lbnQgbXVzdCBi
ZSBkaXNjYXJkZWQsIG90aGVyd2lzZSB0aGUgcGFja2V0IGRhdGEgd2lsbCBiZSB3cml0dGVuDQo+
ID4gYXQgYSB3cm9uZyBhZGRyZXNzLg0KPiANCj4gSGV5IE1heGltLA0KPiBjYW4geW91IGV4cGxh
aW4gd2hhdCBNVFQgc3RhbmRzIGZvcj8NCg0KTVRUIGlzIE1lbW9yeSBUcmFuc2xhdGlvbiBUYWJs
ZSwgaXQncyBhIG1lY2hhbmlzbSBmb3IgdmlydHVhbCBtYXBwaW5nDQppbiB0aGUgTklDLiBJdCdz
IGVzc2VudGlhbGx5IGEgdGFibGUgb2YgcGFnZXMsIHdoZXJlIGVhY2ggdmlydHVhbCBwYWdlDQpt
YXBzIHRvIGEgcGh5c2ljYWwgcGFnZS4NCg0KPiANCj4gPiANCj4gPiBGaXhlczogMjgyYzBjNzk4
ZjhlICgibmV0L21seDVlOiBBbGxvdyBYU0sgZnJhbWVzIHNtYWxsZXIgdGhhbiBhIHBhZ2UiKQ0K
PiA+IFNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBudmlkaWEuY29t
Pg0KPiA+IFJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+DQo+ID4gLS0t
DQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oICAg
IHwgMTQgKysrKysrKysrKysrKysNCj4gPiAgaW5jbHVkZS9uZXQveGRwX3NvY2tfZHJ2LmggICAg
ICAgICAgICAgICAgICAgICAgICAgfCAxMSArKysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDI1IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oDQo+ID4gaW5kZXggYThjZmFiNGEz
OTNjLi5jYzE4ZDk3ZDhlZTAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oDQo+ID4gQEAgLTcsNiArNyw4IEBA
DQo+ID4gICNpbmNsdWRlICJlbi5oIg0KPiA+ICAjaW5jbHVkZSA8bmV0L3hkcF9zb2NrX2Rydi5o
Pg0KPiA+ICANCj4gPiArI2RlZmluZSBNTFg1RV9NVFRfUFRBR19NQVNLIDB4ZmZmZmZmZmZmZmZm
ZmZmOFVMTA0KPiANCj4gV2hhdCBpZiBQQUdFX1NJWkUgIT0gNDA5NiA/IElzIGFsaWduZWQgbW9k
ZSB3aXRoIDJrIGZyYW1lIGZpbmUgZm9yIE1UVA0KPiBjYXNlPw0KDQpQQUdFX1NJWkUgZG9lc24n
dCBhZmZlY3QgdGhpcyB2YWx1ZS4gQWxpZ25lZCBtb2RlIGRvZXNuJ3Qgc3VmZmVyIGZyb20NCnRo
aXMgYnVnLCBiZWNhdXNlIDJrIG9yIGJpZ2dlciBmcmFtZXMgYXJlIGFsbCBhbGlnbmVkIHRvIDgu
DQoNCj4gDQo+ID4gKw0KPiA+ICAvKiBSWCBkYXRhIHBhdGggKi8NCj4gPiAgDQo+ID4gIHN0cnVj
dCBza19idWZmICptbHg1ZV94c2tfc2tiX2Zyb21fY3FlX21wd3JxX2xpbmVhcihzdHJ1Y3QgbWx4
NWVfcnEgKnJxLA0KPiA+IEBAIC0yMSw2ICsyMyw3IEBAIHN0cnVjdCBza19idWZmICptbHg1ZV94
c2tfc2tiX2Zyb21fY3FlX2xpbmVhcihzdHJ1Y3QgbWx4NWVfcnEgKnJxLA0KPiA+ICBzdGF0aWMg
aW5saW5lIGludCBtbHg1ZV94c2tfcGFnZV9hbGxvY19wb29sKHN0cnVjdCBtbHg1ZV9ycSAqcnEs
DQo+ID4gIAkJCQkJICAgIHN0cnVjdCBtbHg1ZV9kbWFfaW5mbyAqZG1hX2luZm8pDQo+ID4gIHsN
Cj4gPiArcmV0cnk6DQo+ID4gIAlkbWFfaW5mby0+eHNrID0geHNrX2J1ZmZfYWxsb2MocnEtPnhz
a19wb29sKTsNCj4gPiAgCWlmICghZG1hX2luZm8tPnhzaykNCj4gPiAgCQlyZXR1cm4gLUVOT01F
TTsNCj4gPiBAQCAtMzIsNiArMzUsMTcgQEAgc3RhdGljIGlubGluZSBpbnQgbWx4NWVfeHNrX3Bh
Z2VfYWxsb2NfcG9vbChzdHJ1Y3QgbWx4NWVfcnEgKnJxLA0KPiA+ICAJICovDQo+ID4gIAlkbWFf
aW5mby0+YWRkciA9IHhza19idWZmX3hkcF9nZXRfZnJhbWVfZG1hKGRtYV9pbmZvLT54c2spOw0K
PiA+ICANCj4gPiArCS8qIE1UVCBwYWdlIG1hcHBpbmcgaGFzIGFsaWdubWVudCByZXF1aXJlbWVu
dHMuIElmIHRoZXkgYXJlIG5vdA0KPiA+ICsJICogc2F0aXNmaWVkLCBsZWFrIHRoZSBkZXNjcmlw
dG9yIHNvIHRoYXQgaXQgd29uJ3QgY29tZSBhZ2FpbiwgYW5kIHRyeQ0KPiA+ICsJICogdG8gYWxs
b2NhdGUgYSBuZXcgb25lLg0KPiA+ICsJICovDQo+ID4gKwlpZiAocnEtPndxX3R5cGUgPT0gTUxY
NV9XUV9UWVBFX0xJTktFRF9MSVNUX1NUUklESU5HX1JRKSB7DQo+ID4gKwkJaWYgKHVubGlrZWx5
KGRtYV9pbmZvLT5hZGRyICYgfk1MWDVFX01UVF9QVEFHX01BU0spKSB7DQo+ID4gKwkJCXhza19i
dWZmX2Rpc2NhcmQoZG1hX2luZm8tPnhzayk7DQo+ID4gKwkJCWdvdG8gcmV0cnk7DQo+ID4gKwkJ
fQ0KPiA+ICsJfQ0KPiANCj4gSSBkb24ndCBrbm93IHlvdXIgaGFyZHdhcmUgbXVjaCwgYnV0IGhv
dyB3b3VsZCB0aGlzIHdvcmsgb3V0IHBlcmZvcm1hbmNlDQo+IHdpc2U/IEFyZSB0aGVyZSBhbnkg
Y29uZmlnIGNvbWJvcyAocGFnZSBzaXplIHZzIGNodW5rIHNpemUgaW4gdW5hbGlnbmVkDQo+IG1v
ZGUpIHRoYXQgeW91IHdvdWxkIGZvcmJpZCBkdXJpbmcgcG9vbCBhdHRhY2ggdG8gcXVldWUgb3Ig
d291bGQgeW91DQo+IGJldHRlciBhbGxvdyBhbnl0aGluZz8NCg0KVGhpcyBpc3N1ZSBpc24ndCBy
ZWxhdGVkIHRvIHBhZ2Ugb3IgZnJhbWUgc2l6ZXMsIGJ1dCByYXRoZXIgdG8gZnJhbWUNCmxvY2F0
aW9ucy4gQXMgZmFyIGFzIEkgdW5kZXJzdGFuZCwgZnJhbWVzIGNhbiBiZSBsb2NhdGVkIGF0IGFu
eSBwbGFjZXMNCmluIHRoZSB1bmFsaWduZWQgbW9kZSAoZXZlbiBhdCBvZGQgYWRkcmVzc2VzKSwg
cmVnYXJkbGVzcyBvZiB0aGVpcg0Kc2l6ZS4gRnJhbWVzIHdob3NlIGFkZHIgJSA4ICE9IDAgZG9u
J3QgcmVhbGx5IHdvcmsgd2l0aCBNVFQsIGJ1dCBpdCdzDQpub3Qgc29tZXRoaW5nIHRoYXQgY2Fu
IGJlIGVuZm9yY2VkIG9uIGF0dGFjaC4gRW5mb3JjaW5nIGl0IGluIHhwX2FsbG9jDQp3b24ndCBi
ZSBhbnkgZmFzdGVyIGVpdGhlciAod2VsbCwgb25seSBhIHRpbnkgYml0LCBiZWNhdXNlIG9mIG9u
ZSBmZXdlcg0KZnVuY3Rpb24gY2FsbCkuDQoNCkluIGFueSBjYXNlLCBuZXh0IGtlcm5lbHMgd2ls
bCBnZXQgYW5vdGhlciBwYWdlIG1hcHBpbmcgbWVjaGFuaXNtLA0Kd2hpY2ggc3VwcG9ydHMgYXJi
aXRyYXJ5IGFkZHJlc3NlcywgYW5kIGl0J3MgYWxtb3N0IGFzIGZhc3QgYXMgTVRULCBhcw0KdGhl
IHByZWxpbWluYXJ5IHRlc3Rpbmcgc2hvd3MuIEl0IHdpbGwgYmUgdXNlZCBmb3IgdGhlIHVuYWxp
Z25lZCBYU0ssDQp0aGlzIGtsdWRnZSB3aWxsIGJlIHJlbW92ZWQgYWx0b2dldGhlciwgYW5kIEkg
YWxzbyBwbGFuIHRvIHJlbW92ZQ0KeHNrX2J1ZmZfZGlzY2FyZC4NCg0KPiBBbHNvIHdvdWxkIGJl
IGhlbHBmdWwgaWYgeW91IHdvdWxkIGRlc2NyaWJlIHRoZSB1c2UgY2FzZSB5b3UncmUgZml4aW5n
Lg0KDQpTdXJlIC0gZGVzY3JpYmVkIGluIHRoZSBiZWdpbm5pbmcgb2YgdGhlIGVtYWlsLg0KDQo+
IA0KPiBUaGFua3MhDQo+IA0KPiA+ICsNCj4gPiAgCXJldHVybiAwOw0KPiA+ICB9DQo+ID4gIA0K
PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC94ZHBfc29ja19kcnYuaCBiL2luY2x1ZGUvbmV0
L3hkcF9zb2NrX2Rydi5oDQo+ID4gaW5kZXggNGFhMDMxODQ5NjY4Li4wNzc0Y2U5N2MyZjEgMTAw
NjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9uZXQveGRwX3NvY2tfZHJ2LmgNCj4gPiArKysgYi9pbmNs
dWRlL25ldC94ZHBfc29ja19kcnYuaA0KPiA+IEBAIC05NSw2ICs5NSwxMyBAQCBzdGF0aWMgaW5s
aW5lIHZvaWQgeHNrX2J1ZmZfZnJlZShzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkNCj4gPiAgCXhwX2Zy
ZWUoeHNrYik7DQo+ID4gIH0NCj4gPiAgDQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCB4c2tfYnVm
Zl9kaXNjYXJkKHN0cnVjdCB4ZHBfYnVmZiAqeGRwKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgeGRw
X2J1ZmZfeHNrICp4c2tiID0gY29udGFpbmVyX29mKHhkcCwgc3RydWN0IHhkcF9idWZmX3hzaywg
eGRwKTsNCj4gPiArDQo+ID4gKwl4cF9yZWxlYXNlKHhza2IpOw0KPiA+ICt9DQo+ID4gKw0KPiA+
ICBzdGF0aWMgaW5saW5lIHZvaWQgeHNrX2J1ZmZfc2V0X3NpemUoc3RydWN0IHhkcF9idWZmICp4
ZHAsIHUzMiBzaXplKQ0KPiA+ICB7DQo+ID4gIAl4ZHAtPmRhdGEgPSB4ZHAtPmRhdGFfaGFyZF9z
dGFydCArIFhEUF9QQUNLRVRfSEVBRFJPT007DQo+ID4gQEAgLTIzOCw2ICsyNDUsMTAgQEAgc3Rh
dGljIGlubGluZSB2b2lkIHhza19idWZmX2ZyZWUoc3RydWN0IHhkcF9idWZmICp4ZHApDQo+ID4g
IHsNCj4gPiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIGlubGluZSB2b2lkIHhza19idWZmX2Rpc2Nh
cmQoc3RydWN0IHhkcF9idWZmICp4ZHApDQo+ID4gK3sNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3Rh
dGljIGlubGluZSB2b2lkIHhza19idWZmX3NldF9zaXplKHN0cnVjdCB4ZHBfYnVmZiAqeGRwLCB1
MzIgc2l6ZSkNCj4gPiAgew0KPiA+ICB9DQo+ID4gLS0gDQo+ID4gMi4yNS4xDQo+ID4gDQoNCg==
