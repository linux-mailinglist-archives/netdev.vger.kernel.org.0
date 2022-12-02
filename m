Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1102164119C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiLBXmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiLBXmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:42:50 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5CE218B8;
        Fri,  2 Dec 2022 15:42:45 -0800 (PST)
X-UUID: cf38e9520aa04a16bd91d128c6f83033-20221203
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XznkicVyGkT9bzO3F0ruKdOeVg4M411Zp+706t9sI98=;
        b=nxSVqP/luhPPQsDTaV1i48unSb8ImkeSjj27Z6HzkVn5lu378ljP6KgtFOTeR82JhOWAiaAWe+x80hIHIzo5mKRE+1vRyYwc++LYM/az/sig+RVgl4KfC3lQp7lPn4rgqv9fKPIhzN5i1S0elNokrs0RUCIUCTuH1uL0nVrPlx4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:a7f9aa0b-ed09-4dc8-bd04-91ade8bf2610,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:a7f9aa0b-ed09-4dc8-bd04-91ade8bf2610,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:db8b041f-5e1d-4ab5-ab8e-3e04efc02b30,B
        ulkID:221203065626A3XV88X6,BulkQuantity:23,Recheck:0,SF:17|19|102,TC:nil,C
        ontent:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: cf38e9520aa04a16bd91d128c6f83033-20221203
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 208233583; Sat, 03 Dec 2022 07:42:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Sat, 3 Dec 2022 07:42:39 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Sat, 3 Dec 2022 07:42:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcTeH4CT0gfU8NZGnzHSyVhBnBO/fW5gf9/0WucREvQ5xbDGnm9aUUtIzyKqCKNKZP8Jpo+l2MlPMTCDSR9lS6LNjRkQm74SlgzT9EmGPw5H1eukQ8BYQy9uaF8q0yd7Jx4KLlh5ejOMqV8/dnp/zj8SN5k8vbpcb5z91vDBHEbwZL7IUWE1PVl8x1Tz5kgmAQLluSGwkPfSN3PzYPQOl8uHr9VWYaS1zLVt/Xfd5eez6C/GprKQxwN/BFMLNVxtH+MMV2vlkkQpOPMbOce/LR5ZZZhWl32Jrpo8hXk3Y4qqZUqaixRVNH9fIqVEn4iQ8AdCo0B+H3W4qcC2sWwI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XznkicVyGkT9bzO3F0ruKdOeVg4M411Zp+706t9sI98=;
 b=GIBBh53u1X2zWj3nxq7VcXEH61mgDKUmaqwjVGUgV4UcVY9R+qQPxKNJ8BSkDqr2xHFrEfhGGrEgOftlAIRd8jE9Lnd3bfIes8d/ksxEUUxYcSkYPKmyKTeZ6MYkyi6MV02t3tMRO8YiyOaMHXD2q+fDnXFgz70e1n7nvLIeZTixkF2fWwddz1ZjnlW1ycZsLbRjjmfg+0W5hcBE+HuD2c/jZZVSYxl4Wo6GKOrLXBXCsM0+VzdG0GnkaIFGDZRRby604dDOoUsR4A4IExEHc9t/LsEhNK37u8HwWVnEtqJdF8E7fKbGpxqlybuzA9UF9GTh5CHKT3nG25x+2KbPcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XznkicVyGkT9bzO3F0ruKdOeVg4M411Zp+706t9sI98=;
 b=OpETVxftf9Nbv7rPxXaHWj/mzcFEy+7mUrEqwj5JEQUM+hzL817XVrqGIsTK7TO0lnW+lZED5SeNvKKuzrZyygdhnbIlMv+ZQA3tJoUY4uvg5214auwV+j8bkp9Xjz4NXCSBceCZ94ZIEBDL1mzwMzxW9QF46Hl6wKDMcDiLDIs=
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com (2603:1096:400:14a::9)
 by TYZPR03MB7027.apcprd03.prod.outlook.com (2603:1096:400:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 23:42:37 +0000
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3]) by TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3%5]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 23:42:37 +0000
From:   Ryder Lee <Ryder.Lee@mediatek.com>
To:     "keescook@chromium.org" <keescook@chromium.org>
CC:     =?utf-8?B?TWVpQ2hpYSBDaGl1ICjpgrHnvo7lmIkp?= 
        <MeiChia.Chiu@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        =?utf-8?B?U2hheW5lIENoZW4gKOmZs+i7kuS4nik=?= 
        <Shayne.Chen@mediatek.com>, "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        =?utf-8?B?U3VqdWFuIENoZW4gKOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?Qm8gSmlhbyAo54Sm5rOiKQ==?= <Bo.Jiao@mediatek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Thread-Topic: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Thread-Index: AQHZBp97nbgv/Go0Rk6e4OypxWDzN65bNVOAgAACYoCAAAqLgA==
Date:   Fri, 2 Dec 2022 23:42:36 +0000
Message-ID: <6285b967a37d7f641b13ba73c10033450ee8ea7f.camel@mediatek.com>
References: <202212021424.34C0F695E4@keescook>
         <1a16599dd5e4eed86bae112a232a3599af43a5f2.camel@mediatek.com>
         <202212021504.A1942911@keescook>
In-Reply-To: <202212021504.A1942911@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR03MB6354:EE_|TYZPR03MB7027:EE_
x-ms-office365-filtering-correlation-id: f1f4595b-9961-4beb-093d-08dad4bee42b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hTywygS7DNdRaDL4l83RdEpNocwne2nswxnfovMzZwmEtouiYykrG81khbGiX+aR63SQZ1e7wOlgfRR9Ns15n8eEAnGJPxHHssOnQw9NQ6yOb9IyKgkPnMyV4pkcMlJZI9uZfLrDnrbH9iBnYe9Ppg8LBIEMFrkLF/UOd8GXjxNPqYO3AOK22gdmBdF8fq15yivz0MZd4MN2f0siBgnrsyiHKwjeLy1icLhPuKwJIP03hOxX8R53Y7CwTVU3W0YSSl291+7vIckixPr9LzYEpsJiM4xgo2mxDdnOqUQpEA3DhPHer8F3cc996ShpVouvQ0tIxwQgpQCIrKxdmP1V7JHFF7wU9UuyUbMFLtmjkYTg8YG8UkwP+zNCHyHgLFpZ0XA2DHK/nJu3DLvOoOcAYE0zAua5O0ab9yaSb1rSas7GtELw5FwiJpBnFtG+wh+Q+QGlDrIlgisDMXF0eHPJX9DTZSckV/Jqux7cEiYGQXw1hdaaRLUc5RP/YxxwKxWK9LmbCeEkzOnVjPjEi1EJaTIjOvU/YJSkaWMd+q/l6VENgDzXY6rgf2sZPTKBQGM8p0ceHvSTigGhfgrEpIwpDxYB8iTCmksM9zEVjI6mgFEXn4pHWjp3c/zaaQ7dm9yzKbOtvzesqN7FAL16r1n6O4kKA8tGeYdCtBLCj3+B8cKMs51uHcJi3WSbLr+v0wm3G/NY1/82jz9cgDEm+trMqxNMteS2y52pOLk2/hhZfk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR03MB6354.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(36756003)(83380400001)(8676002)(2616005)(76116006)(316002)(6486002)(86362001)(38070700005)(38100700002)(66556008)(7416002)(64756008)(2906002)(41300700001)(54906003)(4326008)(6506007)(8936002)(186003)(966005)(6512007)(26005)(5660300002)(478600001)(91956017)(71200400001)(6916009)(66446008)(122000001)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXZkTTRnOHhqSGw3YmVHblBSQndCOHdjcWQ0RW51Rms0cTlnL0tBS1MxNncw?=
 =?utf-8?B?ZzVIOEVRYnlkZ0lMN0twb2J2azVLRjU4eGluV1hDck5KVDZ4cGZzN3p6QjNi?=
 =?utf-8?B?bk10ZUdrdlNnWWNqQTByNkl5aENhNFR6MGY1VHlLMTAyaWxscko4T1A1ZTlH?=
 =?utf-8?B?VHFCZ0R2cmNpdk9wNS9uVEFJSEZuUEVBV3hla0M5VFhVRTZyUWZYcW9oS2pW?=
 =?utf-8?B?YVFHRVhCTCszODYzUnZCbGluMmhYVVVuKzdFOHdQdU1uUjVlS01Oc2txdUFn?=
 =?utf-8?B?RHdUZmg5ZXZXZG16OENjc1JaOHUwSDM1RktDTzhwZ1BCeHdrbDFUTm1nRFVp?=
 =?utf-8?B?U1lPS3lVM2dmcUlGRXhxanV4M0pmMVdYNE5scDRwTHlzMnBvUy9uZzFhcFFF?=
 =?utf-8?B?N0F4OEIxK3hlNkppZFRtRldsQUtNTTJiTCtxVzFUYzhaU3p4c082Wm93SVRp?=
 =?utf-8?B?UjRXVW5zbDlNb1dZOWYyYTdwQ3k5RHNvY2lDbkphZU1US0Q2d29wcEVaL1lH?=
 =?utf-8?B?ZjVUQWdwaW5JRnhGUk1MZkhjMU93NHFhbDlJeDNEbFIyOGd4b052emlvVVcy?=
 =?utf-8?B?Y3lkZE5NUE1MRjJwMWdLaDNLcE5UZ0FJTkFLUlBscFpOREdzRVlGK3FXbHBa?=
 =?utf-8?B?U0tVbkdWUGt3NXFXQnorK0JDcGxJRjZwRlJSYlFpdWtmb2VhYzA2dXZIZzZO?=
 =?utf-8?B?MU1wSGU1TU81VlA4UEJSdjBtQlBLYkltUlJ5V0ZWQldYZXVVVk5CNXlKbmhs?=
 =?utf-8?B?d2syN0VGWEdWSmVkSUttOHNPTkJlT0dBamlTMTN5T2J5d0VuRGVoSXFmZGJC?=
 =?utf-8?B?NDEwc05ZZzdKcUFOclhlTGZHaWphb29JUllBcGt3Vkp1a0xTK0dTM2lRNkd5?=
 =?utf-8?B?SE1rWXp4NTYrbklycmFJRXNLeXUxQjBwbzFZaXZvdXZ5Z2lmcThwZ202OVk0?=
 =?utf-8?B?RnlYYXUrbk5IQkxCazRBMjlFL25kQytjb3lpaVVZRHppb0lYNVYvUko4UkRy?=
 =?utf-8?B?RWk0bU9FREZIWURKMWlEVkFvaGJ4cmgwMHl6OGVsSFZFMWgxc3orRDRqcjg4?=
 =?utf-8?B?d0tSdFBBV3JFeTl1dGlCdzVTaDVTZnZxZjFuU0VLcTVybmdvODFEOW9JbnZr?=
 =?utf-8?B?eGRJU1VwQTFWNGRlUzdEb21PaTdldWdBYmJlRFAxSkhBMFUyeTVyZVhmczdP?=
 =?utf-8?B?d2xYYTg3MFhhd1poRm8xaVZzNWZJNlc3WVdKQXVHMmsxRytGeDQ5QzByTWs1?=
 =?utf-8?B?ZHRQSlFhVHdKNDNFNFdRUzZmd21LVy8vZ0tlZHUrbXJZV2g5dHZGK1FLQkNE?=
 =?utf-8?B?QUlCbnI3em1vWFZYeXoyZmFOR2lXVk54WTNKVVIrb3lDY2t4WEVOM0xGWjFj?=
 =?utf-8?B?VWMwRFcwdmZYcUhxYzRqM2hXT0o3dGg4QTRsTkpMZnV1WHYwN2xybS9Oamty?=
 =?utf-8?B?ZmwyaVBPb1RXYm93QnIxK0FBZlRVTlRpZjJnYUhET0NyeVZVbFJCYnUxRlJG?=
 =?utf-8?B?Z0JGQndDbmRLQStWUVdMMEVsc3VMWVg4U1hIaWZxOWk4emVpVEh5VWlERkhs?=
 =?utf-8?B?YWN4bU04UlRtTGRaVm9XY3A5K1BWcFQvRlJpVFVvV2wxdm5qTlhBRm80bDBV?=
 =?utf-8?B?R3AvcGxXek8wRjlIbFZiaHhoUDlUUG85Sk9yTzBadGpyeWVPR3JkYzVMQlhS?=
 =?utf-8?B?UkJMTnZGNTRvdW9RN1lQOXdrYit0SUlKYy91UzNrNEtPQmphanRXRTFoWUZh?=
 =?utf-8?B?bG5JcTVlSjJhNUs3UHVWSURZZExuLytRb3R0ckZUTTdSNWlneFJveTBNZ0NF?=
 =?utf-8?B?a2pTVVA1VUp6eU5uS1k5VnBxOEpSaE5GZGVCR00vZkNuWjZxRnZoclEyOXda?=
 =?utf-8?B?ZTFDUkxHTW1DalIvcTNjTnorS3p1NUh5T0RsTGVMN1JUMHpRVE5JRU9OVTlx?=
 =?utf-8?B?RXlpN25Bajk1U3NzNS9TaXc1Nk93U28rM3dHdFdzcUpyUmVtS3lFRTlWckVj?=
 =?utf-8?B?cllOa0FHaTdLNUhZNzhjMERTMGVSa0NhNkliUkwveUxFbndTamx2M0Rod2Rr?=
 =?utf-8?B?WGtpRnd4Y3VtUW9vVkZiTU5LdmVjQVlnNnVYbE1SNktRUVd4WEdPb3JsOEhY?=
 =?utf-8?B?ZnZCUzB3cEhkUWhEL2hyVk9VYnBBUEJSOXRHdUtUR2o5VVVHMzcyVFVIMTdh?=
 =?utf-8?B?cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52B8E1FF4ECC014690D8C015368B0DFE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR03MB6354.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f4595b-9961-4beb-093d-08dad4bee42b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 23:42:36.2934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zSnVODo6bcYtWOhaMk9RUUwoXs37XvHbJzuarD2tMcxRRlli4kVuvz1FcpJ6eu2aPL8XEcKbuV0FK+BbVIr0TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7027
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDE1OjA0IC0wODAwLCBLZWVzIENvb2sgd3JvdGU6DQo+ID4g
DQo+IE9uIEZyaSwgRGVjIDAyLCAyMDIyIGF0IDEwOjU2OjE5UE0gKzAwMDAsIFJ5ZGVyIExlZSB3
cm90ZToNCj4gPiBPbiBGcmksIDIwMjItMTItMDIgYXQgMTQ6MjQgLTA4MDAsIGNvdmVyaXR5LWJv
dCB3cm90ZToNCj4gPiA+IEhlbGxvIQ0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIGFuIGV4cGVyaW1l
bnRhbCBzZW1pLWF1dG9tYXRlZCByZXBvcnQgYWJvdXQgaXNzdWVzDQo+ID4gPiBkZXRlY3RlZA0K
PiA+ID4gYnkNCj4gPiA+IENvdmVyaXR5IGZyb20gYSBzY2FuIG9mIG5leHQtMjAyMjEyMDIgYXMg
cGFydCBvZiB0aGUgbGludXgtbmV4dA0KPiA+ID4gc2Nhbg0KPiA+ID4gcHJvamVjdDoNCj4gPiA+
IA0KPiA+IA0KPiA+IA0KaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vc2Nhbi5j
b3Zlcml0eS5jb20vcHJvamVjdHMvbGludXgtbmV4dC13ZWVrbHktc2Nhbl9fOyEhQ1RSTktBOXdN
ZzBBUmJ3IWo3al9DMEtwTzRWRDJ5TU9vZHZwZUlleFRHcTRmaHkyeXE2bm9rTnVhOXU0TFRvaVVP
TGs0b3U4SkZGTnJYa3JoODBkNUJLMms0NGZhUlFzdEhFOSQNCj4gPiAgDQo+ID4gPiAgDQo+ID4g
PiANCj4gPiA+IFlvdSdyZSBnZXR0aW5nIHRoaXMgZW1haWwgYmVjYXVzZSB5b3Ugd2VyZSBhc3Nv
Y2lhdGVkIHdpdGggdGhlDQo+ID4gPiBpZGVudGlmaWVkDQo+ID4gPiBsaW5lcyBvZiBjb2RlIChu
b3RlZCBiZWxvdykgdGhhdCB3ZXJlIHRvdWNoZWQgYnkgY29tbWl0czoNCj4gPiA+IA0KPiA+ID4g
ICBUaHUgRmViIDMgMTM6NTc6NTYgMjAyMiArMDEwMA0KPiA+ID4gICAgIDQxN2E0NTM0ZDIyMyAo
Im10NzY6IG10NzkxNTogdXBkYXRlIG10NzkxNV9jaGFuX21pYl9vZmZzIGZvcg0KPiA+ID4gbXQ3
OTE2IikNCj4gPiA+IA0KPiA+ID4gQ292ZXJpdHkgcmVwb3J0ZWQgdGhlIGZvbGxvd2luZzoNCj4g
PiA+IA0KPiA+ID4gKioqIENJRCAxNTI3ODAxOiAgTWVtb3J5IC0gaWxsZWdhbCBhY2Nlc3NlcyAg
KE9WRVJSVU4pDQo+ID4gPiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210Nzkx
NS9tY3UuYzozMDA1IGluDQo+ID4gPiBtdDc5MTVfbWN1X2dldF9jaGFuX21pYl9pbmZvKCkNCj4g
PiA+IDI5OTkgICAgIAkJc3RhcnQgPSA1Ow0KPiA+ID4gMzAwMCAgICAgCQlvZnMgPSAwOw0KPiA+
ID4gMzAwMSAgICAgCX0NCj4gPiA+IDMwMDINCj4gPiA+IDMwMDMgICAgIAlmb3IgKGkgPSAwOyBp
IDwgNTsgaSsrKSB7DQo+ID4gPiAzMDA0ICAgICAJCXJlcVtpXS5iYW5kID0gY3B1X3RvX2xlMzIo
cGh5LT5tdDc2LT5iYW5kX2lkeCk7DQo+ID4gPiB2dnYgICAgIENJRCAxNTI3ODAxOiAgTWVtb3J5
IC0gaWxsZWdhbCBhY2Nlc3NlcyAgKE9WRVJSVU4pDQo+ID4gPiB2dnYgICAgIE92ZXJydW5uaW5n
IGFycmF5ICJvZmZzIiBvZiA5IDQtYnl0ZSBlbGVtZW50cyBhdCBlbGVtZW50DQo+ID4gPiBpbmRl
eCA5IChieXRlIG9mZnNldCAzOSkgdXNpbmcgaW5kZXggImkgKyBzdGFydCIgKHdoaWNoIGV2YWx1
YXRlcw0KPiA+ID4gdG8NCj4gPiA+IDkpLg0KPiA+ID4gMzAwNSAgICAgCQlyZXFbaV0ub2ZmcyA9
IGNwdV90b19sZTMyKG9mZnNbaSArIHN0YXJ0XSk7DQo+ID4gPiAzMDA2DQo+ID4gPiAzMDA3ICAg
ICAJCWlmICghaXNfbXQ3OTE1KCZkZXYtPm10NzYpICYmIGkgPT0gMykNCj4gPiA+IDMwMDggICAg
IAkJCWJyZWFrOw0KPiA+ID4gMzAwOSAgICAgCX0NCj4gPiA+IDMwMTANCj4gPiA+IA0KPiA+ID4g
SWYgdGhpcyBpcyBhIGZhbHNlIHBvc2l0aXZlLCBwbGVhc2UgbGV0IHVzIGtub3cgc28gd2UgY2Fu
IG1hcmsgaXQNCj4gPiA+IGFzDQo+ID4gPiBzdWNoLCBvciB0ZWFjaCB0aGUgQ292ZXJpdHkgcnVs
ZXMgdG8gYmUgc21hcnRlci4gSWYgbm90LCBwbGVhc2UNCj4gPiA+IG1ha2UNCj4gPiA+IHN1cmUg
Zml4ZXMgZ2V0IGludG8gbGludXgtbmV4dC4gOikgRm9yIHBhdGNoZXMgZml4aW5nIHRoaXMsDQo+
ID4gPiBwbGVhc2UNCj4gPiA+IGluY2x1ZGUgdGhlc2UgbGluZXMgKGJ1dCBkb3VibGUtY2hlY2sg
dGhlICJGaXhlcyIgZmlyc3QpOg0KPiA+ID4gDQo+ID4gDQo+ID4gSSB0aGluayB0aGlzIGlzIGEg
ZmFsc2UgcG9zdGl2ZSBhcyB0aGUgc3Vic2VxdWVudCBjaGVjayAnaWYNCj4gPiAoIWlzX210Nzkx
NSgmZGV2LT5tdDc2KSAmJiBpID09IDMpJyBzaG91bGQgYnJlYWsgYXJyYXkgIm9mZnMiIG9mIDgu
DQo+IA0KPiBBaCwgb2theS4gV2hhdCBpZiBpc19tdDc5MTUoJmRldi0+bXQ3NikgaXMgYWx3YXlz
IHRydWU/DQo+IA0KPiAtS2Vlcw0KDQoJaW50IHN0YXJ0ID0gMDsNCg0KCWlmICghaXNfbXQ3OTE1
KCZkZXYtPm10NzYpKSB7DQoJCXN0YXJ0ID0gNTsNCgkJb2ZzID0gMDsNCgl9DQoNCglmb3IgKGkg
PSAwOyBpIDwgNTsgaSsrKSB7DQoJCXJlcVtpXS5iYW5kID0gY3B1X3RvX2xlMzIocGh5LT5iYW5k
X2lkeCk7DQoJCXJlcVtpXS5vZmZzID0gY3B1X3RvX2xlMzIob2Zmc1tpICsgc3RhcnRdKTsNCg0K
CQlpZiAoIWlzX210NzkxNSgmZGV2LT5tdDc2KSAmJiBpID09IDMpIC8vDQoJCQlicmVhazsNCgl9
DQoNCkZvciAnaXNfbXQ3OTE1JyBjYXNlLCBzdGFydDowIGFuZCBpOiAwIDEgMiAzIDQsIHdoZXJl
YXMgIWlzX210NzkxNScNCmNhc2UsIHN0YXJ0OjUgYW5kIGk6IDAgMSAyIDMgKHRoZW4gYnJlYWsp
Lg0KDQpJIGtub3cgaXQncyBhIGJpdCB0cmlja3kuIFRoaXMgaXMgdXNlZCB0byBkaWZmZXJlbnRp
YXRlIGNoaXBzZXQNCnJldmlzaW9uLg0KDQpSeWRlcg0K
