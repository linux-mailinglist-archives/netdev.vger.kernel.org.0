Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B44B1244
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiBJQCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:02:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiBJQB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:01:58 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70120.outbound.protection.outlook.com [40.107.7.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F30E5D
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:01:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKkiwhsAHOF/DR8svM8CadupjUawIkFZi/1BhQvWDxBNlkpcixWbgXUrygVVUd9cwHjopTTmDstch7QAx0MXLMDdKfnEp+ltJ5+QqGtmmNpYG5xvJ4BnTcbKzSymm7/61CpWnnzT2N8qxsG1PezWaGJHEiNnYz/wIDWOJgXSOIplbz6LYSA9HTmGEt3AzvuxZEbVxpOfz1vdrX0o+aB/eSTaYfFF7+rZ1FDYPWcQVEfEQTeH+dSVia/U60w0YumoJqiC6L9Clpq0YcVTc1a978niMmSqc6+c1XiVTfBZ09FB2eBC2Nj2hfYgwb28vGMdtJMTyQuTpz+Ydb0h90R0jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0m1LmUgcb5DR28Forrj+SRZdE9YUa7kIU9yl3CGWMU=;
 b=EmQ/0F7QyGtNSkOObJ5zeuYqtLis5aiSIQQIr5W9SJAcTGCJG3UkdC4432P4MQucIKRYwTrv2vXtgEa2On+1gf4EyzCRh3NQ2tulOkbHK3PXmIvKmy7+jXRIjjxiqEYiZLAbwyW/7NcRhLnYkBwOhn0qfK0icSBI2MS3EhKIbDHpQj7iGpQRFbxYAUurPI+xfPU1GU7/xwSeyDzTDcKq5YbpGaBKSsTnVJwIecowOFP33y8uALLLgQSxnSOpPailY+fJmaKRVx+l4EJ7vQbO/Q3AyUyu/bEHj8H0Plcq4otagOYG459eN2JPdGQ+ZSgztQHuFJ8aTE3L0UVj4l+u+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0m1LmUgcb5DR28Forrj+SRZdE9YUa7kIU9yl3CGWMU=;
 b=l1BzfT8JpCac1Bt+5hqSbl0oB85VeRSgOgoiYG1mjrzV2BvPvOjW09+YWssLsD8a6g0ofh/y6sZZgEWOm1d3XQmllm34qxrcQFGsLR4zD8AV1yxknC5WlAu7kKEuDyjFHH68zSwg/LLF1MPDuAjtRVbG615mgc+tTR0+iBI9ZXg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PAXPR03MB8016.eurprd03.prod.outlook.com (2603:10a6:102:21f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 16:01:55 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 16:01:55 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Topic: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Index: AQHYG5fs5yDF6pxxpUySzHA96Kq4cw==
Date:   Thu, 10 Feb 2022 16:01:55 +0000
Message-ID: <87o83eg170.fsf@bang-olufsen.dk>
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
        <878rukib4f.fsf@bang-olufsen.dk>
        <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
        <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>
        <87h797gmv9.fsf@bang-olufsen.dk>
In-Reply-To: <87h797gmv9.fsf@bang-olufsen.dk> ("Alvin =?utf-8?Q?=C5=A0ipra?=
 =?utf-8?Q?ga=22's?= message of "Thu, 10 Feb 2022 08:13:46 +0000")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12d10a94-48de-47ff-717d-08d9ecaea937
x-ms-traffictypediagnostic: PAXPR03MB8016:EE_
x-microsoft-antispam-prvs: <PAXPR03MB8016669A2EF72A44DFBB3ACF832F9@PAXPR03MB8016.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVpmcyyON2XranJvWOucVWD/Qn3OqHBjCFZ1Q25bwKlC/Fy+zB8Axr1U1ynonbe8Zt+D4XcyM3kA4f502LO7kxOCb9KkKeRBnQfOiOI8OK6ysf7NSSS+P0/aa/8ruKD/i1DkRzYt0dIrEEKBU31zVj7lYaePwcT/4MjmUESXtiHPfDLs4aZkHvW9H5sXCT6Xvnm3yeO0+G3sgxgtmEfKnaYieqlwJF0SSDG5G6HR+ruXrAsKFIrfXRaMW4znjgNqEhjR6fRg4S71k5lW5qFONiLEf+tVxcbTm/85vK5N05+Jvhv7KQc/GIe7Q9m8P+dV8MBpWxweCVp5cV7zoBsim+SU0jtk8JzbXzC0nGm2TPIroGem/MmSIykn681mjEOrFqwQEVYoMOaZ7v9LGCuJ0+oJhCveloyL3dm7evU3eCVIRd97Eth0vk7s9gEffpWg3BFxMa1KFRU/QjGlkagvi220rktMuPlNUsujSFqmOXlBToWrujxnN4yNAsZ0VwT/JqV3tWHhH8MxiSccRNc+lyVLfeTkd/8+QjIB0GK7giLpgeYXveRdbwrd60q7zzvDOTKhDM0GoujSJDAT5IoiwV+KWQlZ8hca2to/ceD0Zw1JIoQRTREmR1yuEK/e5FEPOgyX61fXCITCy2/czGYNPo1DeXJaqVrpBcktCciWKHnd1bTWO/x/mHNUIAHsxhbSYDlShVxLVJNMwQThIZuO6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66556008)(66946007)(4326008)(6506007)(91956017)(86362001)(66446008)(66476007)(6486002)(8976002)(71200400001)(8936002)(8676002)(64756008)(76116006)(54906003)(38070700005)(508600001)(26005)(186003)(6916009)(5660300002)(85202003)(122000001)(2616005)(66574015)(85182001)(316002)(2906002)(83380400001)(36756003)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zkg1eXhOQzFrREdqWGQwdDViWm14amRJSVdYWTBPcy9YbW51d3NzbHByS3dw?=
 =?utf-8?B?eURDWG1DOXdHenNnNnZkOEEwcXo0NWhUUGhjRGtMTDY2RGhPcUNEdXlNbGhZ?=
 =?utf-8?B?ZnFTTTQ5dHVqcHl2WGtYc1JLdWlpTGg0aFpOdE0zNVBiNkhtS3N0Z2lHcHds?=
 =?utf-8?B?ckh3S0Q1RVdEVC84aFBBVFRaemQweGwyaHFZN3FRZCsxSmx4a1R5WFIyK0ty?=
 =?utf-8?B?NFZWekNjM0JSb0hGelFRellKY2dBa1ZId0ZXdEhyUVZib1ZhWWUzL0RRa0VC?=
 =?utf-8?B?RWVGREpWNzQzZHJJM2EwQ2pVTzQzblA5YUtIRE5qMENnSzQ5R2prajNLOUFB?=
 =?utf-8?B?b2xFZVBtM0ZjLzBoR2pvbjdOS0FDaWE3ckptZThRdm1kUTJWcFc5QjNoT05T?=
 =?utf-8?B?OW9OaTI1R1lsSjMvMHBkcEVPNXhrL056ZlJsV1NJN0g3aithOWJDN0hZVFNS?=
 =?utf-8?B?MndHaWovTjcvK2tyRDlGZkZRSkVuM1hxb1QwZHJiWXc2SVFGTmRRejRlWFpC?=
 =?utf-8?B?OFFXeitka2t3WjhKeDhsQllmZW9VejVXaXV1cStVWU9WNGtYZTFjeUR3Vmsw?=
 =?utf-8?B?SjA5Q3ZaSDd2QWczeG0rUnJLMHZoU0t5TkVCUFlYYjBpWHdlNTBXZitkZ0tJ?=
 =?utf-8?B?L2YvZDcxVENueUlLT01ycHpxam5Bd0JRUTY4aVBqQkFOQmp2RWdnSmJudzA5?=
 =?utf-8?B?MjhNZVk4Y05JODF5SnVJUkdweVJVQjZiMnRSVUFxZFkxYm0yZXJIaDFDTVVW?=
 =?utf-8?B?V2F2MG9pUDJGOHBGTldDSnF3NWJIa3k1YStSWWRUbnA1bVJFQzZLWStnVUhT?=
 =?utf-8?B?eUVWaGdpaUl1cm5sb1QyMEJsVHIzays0dkdMLy9zalhnMmluNGg4R3hIc0JE?=
 =?utf-8?B?M3F2cENSQlM4VHluZGpxbGQ3MVgxK2o0L1FtZGFJbTh0MTQxYmR6eTBSR2d1?=
 =?utf-8?B?bHozNnVWWTVMcHplb1QyL0JSWGVoR3pIS2VSVXdIanBGdGl2d201MnFxMWNl?=
 =?utf-8?B?UFpKbVlRVGU1L0lzL1d4Tm1qb1VOck1MazF0ZWFUbEUwdHdWUEs5QmJyU2lr?=
 =?utf-8?B?QkJlMno4SG5mK2ZNZnY5S1NzQXN1cXFrUjZ0azRxdDhORzNma0JRZEREdVlt?=
 =?utf-8?B?NU1hT1RzZVdGQitDbmc0WFBXRUxPMnFPcTdadzlBaGM4aVBEQ1hQdDk3bVZm?=
 =?utf-8?B?WVdpVkthOURJZjRhMDJ0SUh5ZVpUYkNXT0ovSDB4OGQ4U1BDTWVObmNtY3dx?=
 =?utf-8?B?TTQ2b2tEN1lHdUtNZmFXT1RQYktKV1JvOStqVUcrcnIra0pJakxaMEtZMHF0?=
 =?utf-8?B?RTB1enNENytKblBSR3VxaG1yTStLbDZ0WW5ZY2VSM25iTHBNUWpKcWxwVXpV?=
 =?utf-8?B?U0tVWmNuYURONkdqbFp6WVFvSitrUWdkenhqb0tpczRVejFtMEZtMHRuazdx?=
 =?utf-8?B?M0FoMGpvOW1vbVo2U2FCdXNZTTMvZFJRSlpPcmZoL2VlbnRueDFIZXFFV0Rs?=
 =?utf-8?B?dkRKdGNuOHZCaGt1NDl0NlF1dFVVb1U5cW0rU2hsSUx5QUFuc3Z0dFpseW5B?=
 =?utf-8?B?WnppZUkwbmI1N3A0c0tBR0dOV0RzTEk5aTY2QTE4UVEvK0VOc1I3RXlSQUtY?=
 =?utf-8?B?WXNzdWZQT2xLL1pRdCtMVUNiTDF4S005RkM2czQ0T2t0c3lENWY0UE9IaC9p?=
 =?utf-8?B?dWZ2YndWQXpKY1FEalVOM3FJM1JHYnVCWExGWWFnd25SUU1zRzlQT1NIVlpm?=
 =?utf-8?B?VTQ5ck1BQlZlMm5PQ1JaUXpWakhYUm1pYzdBbEF1OHNPWmlsd1hmRmtjekh2?=
 =?utf-8?B?bktIVFR2QThMaldwbGRIUTNsK0FTQyt1QkJMaXRRWXZjcU1QcXNYbEhtdGQ2?=
 =?utf-8?B?VGUvTXAyTFgvTU5Ed2VwZmJaVVRTcE1uYlMyMmJrcjRscVJwM1VGTnFGTEhq?=
 =?utf-8?B?emZjK2E0NFRjeW1xOHlSM3dGWGJtOU50U24yZ2FoVmUwYmVaazVQUHdRbFBC?=
 =?utf-8?B?MzArYnRFVW1sWXpEb1N2MTZnUlNlWXhRMnVNWTJWQ045RWJ0WTgvZC9Rdk93?=
 =?utf-8?B?M0lOMFNQMjFkUkNsSnBKNVR0SFZ3cTFHcVJjQThvUUdlUHlseVRoMUplaEZu?=
 =?utf-8?B?bmtaZGxRTGUyZnVkdWtqSVRVTHkvczM0Smd4Z1psSU04djA2ZGlTOHR2Z2tj?=
 =?utf-8?Q?dOFyy+6ciUMI8Hn+cq2g0BY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2E220204A9FA845A87F3925EB8079AE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d10a94-48de-47ff-717d-08d9ecaea937
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 16:01:55.6146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Roo9WtzWKi5wf8ji/yswsTalZtmEqp8g7DwoG1bEYTPELKCrCiqZkx7melLVw46ks/aSK2/wrKiPj+C48nQAWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWdhaW4gTHVpeiwNCg0KQWx2aW4gxaBpcHJhZ2EgPEFMU0lAYmFuZy1vbHVmc2VuLmRrPiB3
cml0ZXM6DQoNCj4gSGkgTHVpeiwNCj4NCj4gVGhhbmtzIGZvciB0aGUgaW5mby4NCj4NCj4gTHVp
eiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQo+DQoN
CjxzbmlwPg0KDQo+Pg0KPj4gU29ycnkgYnV0IEkgYmVsaWV2ZSBteSBub24tU01QIGRldmljZSBp
cyBub3QgImFmZmVjdGVkIGVub3VnaCIgdG8gaGVscA0KPj4gZGVidWcgdGhpcyBpc3N1ZS4gSXMg
eW91ciBkZXZpY2UgU01QPw0KPg0KPiBZZXMsIGl0J3MgU01QIGFuZCBhbHNvIHdpdGggUFJFRU1Q
VF9SVCA7LSkNCj4NCj4gQnV0IG5vIHByb2JsZW0sIEkgd2lsbCBsb29rIGludG8gdGhpcyBhbmQg
Z2V0IGJhY2sgdG8geW91IGluIHRoaXMgdGhyZWFkDQo+IGlmIEkgbmVlZCBhbnkgbW9yZSBmZWVk
YmFjay4gVGhhbmtzIGZvciB5b3VyIGhlbHAuDQoNClNvIEkgaGFkIGEgY2xvc2VyIGxvb2sgdGhp
cyBhZnRlcm5vb24uIEZpcnN0IHNvbWUgZ2VuZXJhbCBzdGF0ZW1lbnRzLg0KDQoxLiBHZW5lcmFs
bHkgdGhlIHN3aXRjaCBkcml2ZXIgaXMgbm90IGFjY2Vzc2luZyByZWdpc3RlcnMgdW5sZXNzIGFu
DQogICBhZG1pbmlzdHJhdG9yIGlzIHJlY29uZmlndXJpbmcgdGhlIGludGVyZmFjZXMNCjIuIFRo
ZSBleGNlcHRpb24gdG8gdGhlIGFib3ZlIHJ1bGUgaXMgdGhlIGRlbGF5ZWRfd29yayBmb3Igc3Rh
dHM2NCwNCiAgIHdoaWNoIHlvdSBjYW4gc2VlIGluIHRoZSBjb2RlIGlzIHRoZXJlIGJlY2F1c2Ug
Z2V0X3N0YXRzNjQgcnVucyBpbg0KICAgYXRvbWljIGNvbnRleHQuIFRoaXMgcnVucyBldmVyeSAz
IHNlY29uZHMuDQozLiBXaXRob3V0IHRoZSBpbnRlcnJ1cHQgZnJvbSB0aGUgc3dpdGNoIGVuYWJs
ZWQsIHRoZSBQSFkgc3Vic3lzdGVtDQogICByZXNvcnRzIHRvIHBvbGxpbmcgdGhlIFBIWSByZWdp
c3RlcnMgKGV2ZXJ5IDEgc2Vjb25kIEkgdGhpbmsgeW91DQogICBzYWlkKS4NCg0KQXMgYSByZXN1
bHQgb2YgKDIpIGFuZCAoMykgYWJvdmUsIHlvdSBhcmUgYm91bmQgYXQgc29tZSBwb2ludCB0byBo
YXZlDQpib3RoIHRoZSBzdGF0cyB3b3JrIGFuZCB0aGUgUEhZIHJlZ2lzdGVyIHJlYWQgY2FsbGJh
Y2tzIGV4ZWN1dGluZyBpbg0KcGFyYWxsZWwuIEFzIEkgbWVudGlvbmVkIGluIG15IGxhc3QgZW1h
aWwsIGEgc2ltcGxlIGJ1c3kgbG9vcCB3aXRoDQpwaHl0b29sIHdvdWxkIHJldHVybiBzb21lIG5v
bnNlbnNlIHByZXR0eSBxdWlja2x5LiBPbiBteSBTTVAvUFJFRU1QVF9SVA0Kc3lzdGVtIHRoaXMg
aGFwcGVucyBldmVyeSAzIHNlY29uZHMgd2hpbGUgZXZlcnl0aGluZyBlbHNlIGlzIGlkbGUuDQoN
CkkgdHJpZWQgdG8gZGlzYWJsZSB0aGUgc3RhdHMgZGVsYXllZF93b3JrIGp1c3QgdG8gc2VlLCBh
bmQgaW4gdGhpcyBjYXNlDQpJIGRpZCBub3Qgb2JzZXJ2ZSBhbnkgUEhZIHJlYWQgaXNzdWVzLiBU
aGUgUEhZIHJlZ2lzdGVyIHZhbHVlIHdhcyBhbHdheXMNCmFzIGV4cGVjdGVkLg0KDQpJbiB0aGF0
IHNldHVwIEkgdGhlbiB0cmllZCB0byBwcm92b2tlIHRoZSBlcnJvciBhZ2FpbiwgdGhpcyB0aW1l
IGJ5DQpyZWFkaW5nIGEgc2luZ2xlIHJlZ2lzdGVyIHdpdGggZGQgdmlhIHJlZ21hcCBkZWJ1Z2Zz
LiBBbmQgd2hpbGUgaXQncw0KdW5saWtlbHkgZm9yIGEgc2luZ2xlIHN1Y2ggcmVhZCB0byBpbnRl
cmZlcmUgd2l0aCBteSBidXN5IHBoeXRvb2wgbG9vcCwNCnB1dHRpbmcgdGhlIGRkIHJlYWQgaW4g
YSB0aWdodCBsb29wIGFsbW9zdCBpbW1lZGlhdGVseSBwcm92b2tlcyB0aGUgc2FtZQ0KYnVnLiBU
aGlzIHRpbWUgSSBub3RpY2VkIHRoYXQgdGhlIHZhbHVlIHJldHVybmVkIGJ5IHBoeXRvb2wgaXMg
dGhlIHNhbWUNCnZhbHVlIHRoYXQgSSByZWFkIG91dCB3aXRoIGRkIGZyb20gdGhlIG90aGVyIG5v
bi1QSFktcmVsYXRlZCByZWdpc3Rlci4NCg0KSW4gZ2VuZXJhbCB3aGF0IEkgZm91bmQgaXMgdGhh
dCBpZiB3ZSByZWFkIGZyb20gYW4gYXJiaXRyYXJ5IHJlZ2lzdGVyIEENCmFuZCB0aGlzIHJlYWQg
Y29pbmNpZGVzIHdpdGggdGhlIG11bHRpLXJlZ2lzdGVyIGFjY2VzcyBpbg0KcnRsODM2NW1iX3Bo
eV9vY3BfcmVhZCwgdGhlbiB0aGUgZmluYWwgcmVhZCBmcm9tDQpSVEw4MzY1TUJfSU5ESVJFQ1Rf
QUNDRVNTX1JFQURfREFUQV9SRUcgd2lsbCBhbHdheXMgcmV0dXJuIHRoZSB2YWx1ZSBpbg0KcmVn
aXN0ZXIgQS4gSXQgaXMgcXVpdGUgcmVsaWFibHkgdGhlIGNhc2UgaW4gYWxsIG15IHRlc3Rpbmcs
IGFuZCBpdA0KZXhwbGFpbnMgdGhlIG5vbnNlbnNlIHZhbHVlcyB3ZSBzb21ldGltZXMgaGFwcGVu
ZWQgdG8gc2VlIGR1cmluZyBQSFkNCnJlZ2lzdGVyIGFjY2VzcywgYmVjYXVzZSBvZiB0aGUgc3Rh
dHMgd29yayBnb2luZyBvbiBpbiB0aGUNCmJhY2tncm91bmQuIFByb2JhYmx5IHdlIGdvdCBzb21l
IE1JQiBjb3VudGVyIGRhdGEgYW5kIHRoaXMgY29ycnVwdGVkIHRoZQ0KUEhZIHJlZ2lzdGVyIHZh
bHVlIGhlbGQgaW4gdGhlIElORElSRUNUX0FDQ0VTU19SRUFEX0RBVEFfUkVHIHJlZ2lzdGVyLg0K
DQpJIGFtIG5vdCBzdXJlIHdoeSB0aGlzIGhhcHBlbnMgLSBsaWtlbHkgc29tZSBwZWN1bGlhcml0
eSBvZiB0aGUgQVNJQw0KaGFyZHdhcmUgLSBidXQgSSB3YW50ZWQgdG8gY2hlY2sgaWYgdGhpcyBp
cyBhbHNvIHRoZSBjYXNlIGZvciB0aGUgTUlCDQpyZWdpc3RlciBhY2Nlc3MsIGJlY2F1c2Ugd2Ug
YWxzbyBoYXZlIGEga2luZCBvZiBpbmRpcmVjdCBsb29rdXANCmFsZ29yaXRobSB0aGVyZS4gQnV0
IGluIHRoYXQgY2FzZSBJIGRpZCBub3Qgc2VlIGFueSBjb3JydXB0aW9uIG9mIHRoZQ0KZGF0YSBp
biB0aGUgTUlCIGNvdW50ZXIgZGF0YSByZWdpc3RlcnMgKFJUTDgzNjVNQl9NSUJfQ09VTlRFUl9S
RUcoX3gpKS4NCg0KU28gbXkgY29uY2x1c2lvbiBpcyB0aGF0IHRoaXMgcHJvYmxlbSBpcyB1bmlx
dWUgdG8gdGhlIGluZGlyZWN0IFBIWQ0KcmVnaXN0ZXIgYWNjZXNzIHBhdHRlcm4uIEl0IHNob3Vs
ZCBiZSBwb2ludGVkIG91dCB0aGF0IHRoZSByZWdtYXAgaXMNCmFscmVhZHkgcHJvdGVjdGVkIGJ5
IGEgbG9jaywgc28gSSBkb24ndCBleHBlY3QgdG8gc2VlIGFueSB3ZWlyZCBkYXRhDQpyYWNlcyBm
b3Igbm9uLVBIWSByZWdpc3RlciBhY2Nlc3MuDQoNCk9uZSBtb3JlIHRoaW5nIEkgd2FudGVkIHRv
IHBvaW50IG91dDogeW91IG1lbnRpb25lZCB0aGF0IG9uIHlvdXIgc3lzdGVtDQp5b3UgY29uZHVj
dGVkIG11bHRpcGxlIHBoeXRvb2wgcmVhZCBsb29wcyBhbmQgZGlkIG5vdCBvYnNlcnZlIGFueQ0K
aXNzdWVzLiBJIHRoaW5rIHRoaXMgaXMgZWFzaWx5IGV4cGxhaW5lZCBieSBzb21lIGhpZ2hlci1s
ZXZlbCBsb2NraW5nDQppbiB0aGUga2VybmVsIHdoaWNoIHByZXZlbnRzIGNvbmN1cnJlbnQgUEhZ
IHJlZ2lzdGVyIHJlYWRzLg0KDQoqKioqDQoNCldpdGggYWxsIG9mIHRoYXQgc2FpZCwgSSB0aGlu
ayB0aGUgc29sdXRpb24gaGVyZSBpcyBzaW1wbHkgdG8gZ3VhcmQNCmFnYWluc3Qgc3RyYXkgcmVn
aXN0ZXIgYWNjZXNzIHdoaWxlIHdlIGFyZSBpbiB0aGUgaW5kaXJlY3QgUEhZIHJlZ2lzdGVyDQph
Y2Nlc3MgY2FsbGJhY2tzLiBZb3UgYWxzbyBwb3N0ZWQgYSBwYXRjaCB0byBmb3JlZ28gdGhlIHdo
b2xlIGluZGlyZWN0DQphY2Nlc3MgbWV0aG9kIGZvciBNRElPLWNvbm5lY3RlZCBzd2l0Y2hlcywg
YW5kIEkgdGhpbmsgdGhhdCBpcyBhbHNvIGENCmdvb2QgdGhpbmcuIE15IHJlcGx5IHRvIHRoYXQg
cGF0Y2ggd2FzIGp1c3QgdGFraW5nIGlzc3VlIHdpdGggeW91cg0KZXhwbGFuYXRpb24sIGJvdGgg
YmVjYXVzZSB0aGUgZGlhZ25vc2lzIG9mIHRoZSBidWcgd2FzIHJhdGhlciBuZWJ1bG91cywNCmFu
ZCBhbHNvIGJlY2F1c2UgaXQgZGlkIG5vdCBhY3R1YWxseSBmaXggdGhlIGJ1ZyAtIGl0IGp1c3Qg
d29ya2VkIGFyb3VuZA0KaXQuDQoNCkkgd2lsbCB0YWtlIGl0IHVwb24gbXlzZWxmIHRvIGZpeCB0
aGlzIGlzc3VlIG9mIGluZGlyZWN0IFBIWSByZWdpc3Rlcg0KYWNjZXNzIHlpZWxkaW5nIGNvcnJ1
cHQgdmFsdWVzIGFuZCBwb3N0IGEgcGF0Y2ggdG8gdGhlIGxpc3QgbmV4dCB3ZWVrLg0KSSBhbHJl
YWR5IGhhdmUgYSBxdWljay1uLWRpcnR5IGNoYW5nZSB3aGljaCBlbnN1cmVzIHByb3BlciBsb2Nr
aW5nIGFuZA0Kbm93IEkgY2Fubm90IHJlcHJvZHVjZSB0aGUgaXNzdWUgZm9yIHNldmVyYWwgaG91
cnMuDQoNCkluIHRoZSBtZWFuIHRpbWUsIGNvdWxkIHlvdSByZXNlbmQgeW91ciBNRElPIGRpcmVj
dC1QSFktcmVnaXN0ZXItYWNjZXNzDQpwYXRjaCBhbmQgSSB3aWxsIGdpdmUgaXQgb25lIG1vcmUg
cmV2aWV3LiBQbGVhc2UgZG8gbm90IHN1Z2dlc3QgdGhhdCBpdA0KaXMgYSBmaXggZm9yIHRoaXMg
YnVnIChiZWNhdXNlIGl0J3Mgbm90KSAtLSBiZXR0ZXIgeWV0LCBqdXN0IGFkZCBhIExpbms6DQp0
byB0aGlzIHRocmVhZCBhbmQgZXhwbGFpbiB3aHkgeW91IGJvdGhlcmVkIGltcGxlbWVudGluZyBp
dCB0byBiZWdpbg0Kd2l0aC4gWW91IGNhbiBtZW50aW9uIHRoYXQgdGhlIGlzc3VlIGlzIG5vdCBz
ZWVuIHdpdGggZGlyZWN0LWFjY2Vzcw0KKHdoaWNoIGFsc28gY29ycm9ib3JhdGVzIG91ciBmaW5k
aW5ncyBoZXJlKS4gVGhlbiBJIHdpbGwgYmFzZSBteSBjaGFuZ2VzDQpvbiB5b3VyIHBhdGNoLg0K
DQpBbHRlcm5hdGl2ZWx5IHlvdSBjYW4gZHJvcCB0aGUgcGF0Y2ggYW5kIHdlIGNhbiBqdXN0IGZp
eCB0aGUgaW5kaXJlY3QNCmFjY2VzcyB3aG9sZXNhbGUgLSBib3RoIGZvciBTTUkgYW5kIE1ESU8u
IFRoYXQgd291bGQgbWVhbiBhZGRpbmcgbGVzcw0KY29kZSAoc2luY2UgTURJTyB3aXRoIGluZGly
ZWN0IGFjY2VzcyBhbHNvIHdvcmtzKSwgYWxiZWl0IGF0IHRoZSBleHBlbnNlDQpvZiBzb21lIHRl
Y2huaWNhbGx5IHVubmVjZXNzYXJ5IGd5bW5hc3RpY3MgaW4gdGhlIGRyaXZlciAoc2luY2UgTURJ
Tw0KZGlyZWN0IGFjY2VzcyBpcyBzaW1wbGVyKS4gQnV0IEknbGwgbGVhdmUgdGhhdCB1cCB0byB5
b3UgOi0pDQoNCldoYXQgZG8geW91IHRoaW5rPw0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
