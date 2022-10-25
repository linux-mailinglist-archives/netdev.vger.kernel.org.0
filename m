Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7260CAD3
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJYLYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJYLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:14 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2102.outbound.protection.outlook.com [40.107.113.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D2C15CB3A;
        Tue, 25 Oct 2022 04:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znd6eor+JJJaAu9Oysn5ljGnOl32oj2GgLpbR6v9w7SHR8Zpjf5kb3M5GSu+D3wfvSy0e596ODVqMN26tn4wMfxxS0hZNU4wt0SszgKBmZmc7NgWNBy1CGr2Tc7tYCDqL7hdZbmEum7QdATgWBSXKXpW9Eg+6BjcTY+wP/5qql0luh5YkFH56ax3Wd20JtZrURxlFRz4pq4qVLxRmcV7BHMp7tiVMEPLKCyOElNfa3jITniWGsPRmnkqdAXv+cvRikR+PpDArOjsDt887OjQsrZCOIqTrRHEf8HCaKXCZC5g1SPMV1L9vQCxF6SiifXbEZB9tVcncxnMHG3DM9hKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fK7mKSnYOpnePXvlbX3iKM5pYDBtUvWNhS0agdhpUw=;
 b=cmyUo1zKCooM5cMOhyJ6c8MBPsY7Dbi9mvLQmv7LdMrtvyl+s1YAy77dqjYXWlwq3G9I8eB+xapRzNQdnqzhRnCq0LPQ5InAU1mgwnY2ZseXi0Ede/BPguNIKImE45XTOE0e3XwZFBR8YaJRWcvuVRojZwgA4C+6h0CWYU9k5n6y/6XiRQ6HnM4JNjtJSiUzkPUfmnFDsyka92Az9PFbVq3MqoJpM75L4EHgZ19gBOY4Pez8p4drGRZK0k3b6pyeHLQufM1WVzMqflhroJlEi8XVq716vwcJGLs/nKsWntu2u14zroJJl24gX1NqQgsa2S1ff5rVqWoWK9MpWjKz3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fK7mKSnYOpnePXvlbX3iKM5pYDBtUvWNhS0agdhpUw=;
 b=gBIi4j9DrXdBuI46yYlvYNUr0fPngR/XN/b8BtyqaLkV3IgM6lvISbGaowooYDzRuJGNRr5IF++oZDxXk0Bzx02mECsd9T5IHvLo3JTaSKmZLGVXj31FTZP+ZCT7MF0L8SchWKnHyR8b2Lu8jpRa8wglHo7Yo8PSeFcH9yzZ038=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB5805.jpnprd01.prod.outlook.com
 (2603:1096:400:44::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 11:24:10 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 11:24:10 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHY45W84OTfYE+kgU+A+iXKytdlb64Vg9sAgAgvUoCAANcrgIAAKfaAgABMcuA=
Date:   Tue, 25 Oct 2022 11:24:10 +0000
Message-ID: <TYBPR01MB534112D6F52D17617A1995D6D8319@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com>
 <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
 <TYBPR01MB5341E2B5F143F178F0AFD1CBD8319@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdU+O+hz9ja18cFkmwtz+AfEXJHz7N5Hx0S9aw+zD9wkEQ@mail.gmail.com>
In-Reply-To: <CAMuHMdU+O+hz9ja18cFkmwtz+AfEXJHz7N5Hx0S9aw+zD9wkEQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB5805:EE_
x-ms-office365-filtering-correlation-id: d030b452-b95e-4fa5-54fa-08dab67b6fff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5kxlrEcCFdm6ZC2e2Xj1H50E+VyOZKDAXgX3KTSSSe5gc53c/U/xdHHpGT63Q6HraiBIWm7gAiODzDQO3eNDR2LeTvJbfXkPxvxxOzRL/QvkhQnCJChHcW+hNkLqLCweATlZVVYosEjow/1IKTn//YohSuT6T4WhcUE+GngVEnE0t07nGPGHcTR9kxSo+3Tl2senazmnjIegX03CqeugNhKWFpez1RtBYR90uWVkAOq+si5MHhmWk9qwoNOzaTlz3vzyxZFHbNbuxsbu5wTV6PHpgOo/Kpmh4A8MH5DmIc+Xnmx7Tauunv4+djDIwVmUZrO/xpgvNelaFdEKUcpAEoppJEo+ApRvFtEX27LyVmbGTQ43NsdsELVANqHKr7zfyb+337x9G6DSIyK4Ixaa3M6hDVdssgINpU16IR32VjdfdLlP0eBefoidOQo1SuNtcT+GZaVf7Wa0QBmMsCTCsxuHH/s3ERIvYFf6qKyyo5p56jxK80H9kOOsULdHVaq6RadJ0wq4baJfiND++pqz/wvCuZtvmXAabIc52stwF5fMCZ2GDVyjSbxvAfuz57IOig4jaYVAG0w76HLHpb/X1zn2Xq9GOCWP0/tgzWd/M91uzz2P+VWU446aK+G3KIHS4Y2c/irAuLLmiJzJhmxM7jbdNNN5AdWx2oxpBkmVcGG3nKP7bwScZD3snAl8oJMZIhYoauvgfw8Cx9+30moykzKbRUMjYnYZVUNliZUlHhfw9epQWS4FKLe+wR4wVFstvn7rMAueCd1PICa3BXu/FX1nCQS9VkVqpX8bXGEddrg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(33656002)(86362001)(122000001)(2906002)(38100700002)(38070700005)(186003)(83380400001)(6506007)(53546011)(71200400001)(66446008)(4326008)(66946007)(7696005)(9686003)(76116006)(6916009)(54906003)(316002)(64756008)(66556008)(66476007)(8676002)(5660300002)(55016003)(41300700001)(8936002)(7416002)(52536014)(478600001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlFjdnBXQ0FIMHpPTm5Pd05EdE5pTVVLYi9hMEhmVXJUMmNCcnJhVmRDbWJk?=
 =?utf-8?B?dlZNOVBqVEg1OW1nSEl4eEE0bWNzM0V2YnlSVTJZZlIvZW5LNnc1bnBkUGhR?=
 =?utf-8?B?VzB0Sm1mNFdKK3lpdzBqV3lvLyt3ZVdVUktWaDIxUTJtclBiV2t5ZFBSRVBk?=
 =?utf-8?B?TnVhMStTNldRODV3MEdxWXRiOTNsdzVYbi96WGtsWWxKMm9JanlSN2w2OSto?=
 =?utf-8?B?Zk92SmxGVzRCRDFXb2pkK1p4L3VCMlhOMmpHbnRiNEtCOTBubmIrNEI4aDNE?=
 =?utf-8?B?MVBBL1RUSUFYQXNuUG5CMmMvUlJqMGR6L0N4RklzZ1V2YXFzWFFRaWIrZnor?=
 =?utf-8?B?a0NQdWNpa0FVVUI3UWpXbHJKUnQzN0lnUmxBMmhwOHN5czJsbDJqWDFXZElN?=
 =?utf-8?B?NlJJOGZzZ2VlekdVL2x5Vzl3RkhlczJGWXVDNWFGZjJzTjd1SDJXK3BudCtU?=
 =?utf-8?B?RUtVWTNDTnhMQWFSOWcrem4vMU0zaU9PaC8ySlJxNFk0L0wxNkxHN2VxZGV4?=
 =?utf-8?B?K3A1aGhxZ2g5WHVHdmQ4RlVwcDZxS1MzNUtJUmRJR3BMSVhwdW0wSk9DS3NQ?=
 =?utf-8?B?Y0Nxd2xUOEwybzZnSzZON2FHQ2lTYklDa29RSCtJOVl2RHFpNGw0NkNNRUx0?=
 =?utf-8?B?RzFVNkRyVUpLdHZEaERIeFFqaE1hWW5PaTRyVFBzb3FrSUVpejdDeVU3VVND?=
 =?utf-8?B?TUtLaVdERUovNHVnaHJxc1hpUXltelAzRmxGcmVuZkhubzRTT2UycjhmRERG?=
 =?utf-8?B?L0VHRlBSMS9VZmg4WVk3NFZrc1duNEtYVGQxa2hXMmN1bFUwdlZUM3M1aGhQ?=
 =?utf-8?B?dnJCclh4SUlLYThHazBLQ2VZU2ZEVVZ1T0wzalRqdGNkWmVWTmMzbGJPOXhx?=
 =?utf-8?B?djNEdWsyU1BCRzRWbTJKekwrYjYrT2RIS1M4cm81RnhTYnFTRXN3Sk92NU1u?=
 =?utf-8?B?R0RzbEtKZUFvMHlGejdQNGxYWVR5QUZrSjhLbDVWVHpmVXFwWDVzME9KWE5y?=
 =?utf-8?B?bTNCZ09CMnFKVS9oTkZLTndpUTQ3YVg5bmwzTThFektDaXlwQkdoNHBCVUwy?=
 =?utf-8?B?NlFNVi9GemNTcUNqZ2doc0pkRUhMNGZhWUd6TFcxa21CcjA0cEgvK3JCSkJ2?=
 =?utf-8?B?V3duRVdQQnV1N3p6QTF1dHBUckVSVmd1VWgvaWtQZ0Q2bmZtNzBEdGNwNkNy?=
 =?utf-8?B?THdiSWhBMEZJbWFLMWEvVW1KZWtGMzVMbWkxdXBkNEUrbkx2VVhwVHcvYTll?=
 =?utf-8?B?Sk4rZVoxaWxDdHFKcDlSRWU0U2ZTTURMRlErQnllK28wMXNsNHE3U0pOb2Ri?=
 =?utf-8?B?eHJPTGtsdFQ1b1BZWkdIT1Z4b1NxUFJlZlgrNGpaM2N3RlExKzRud3MydUtG?=
 =?utf-8?B?Um93MjNLS3EyYVdSNE11LzMxWCtEWEhkMmJScytRbjYwRWY5Ym4vR2toR1Fs?=
 =?utf-8?B?Ri9Sbk5yNy9IWVFDa3lhcTFQMGZveDNPdVVybkh3cU95MjlxNDlkT1NVTldO?=
 =?utf-8?B?ampUOGh6azJUZjFFdENLQWg3d21SOVNOVDE0d1lqdjJ3U2QwcWpsdlIyVVhT?=
 =?utf-8?B?ZEYwQkxJZjlXSVpTdUtQcFh5YUVURlljalF5M3JRSGdCWnc0TFRjU3JjcTVo?=
 =?utf-8?B?dy9sMS9qVGd5QjR6MlM2SmUyMjlXNGpJb0xObVE3emM3clB3VURZZ1U0WWJB?=
 =?utf-8?B?R3FLQVFreDEzRGZncnlqc203SHRkUEx2cmhCNE83dHZMKytOYUxITmpQdFIw?=
 =?utf-8?B?Mk1HNGFRbkhxeDZZd0t0dHVtVlFZRTVjMW5hSUFEQjlhKzJJOUEyVWs4QXpU?=
 =?utf-8?B?akJxNE5QM1BacjVWaU1Ddy95L1BOcHlQVlpyWU1ScFQ5YkcxdUkvQ3crNWlU?=
 =?utf-8?B?NVgrR1hndnFpbXVYRXNsbDBLWGM4L0JUSG8ra2pKY1lwdHk1NXVISVJWUVhN?=
 =?utf-8?B?SEJ6cEdMQnlteDNsbDk0QVVzbllFRENHblJhSVd3Qk1RTnNwTkZvb0ovaHYx?=
 =?utf-8?B?MFhOVk1OMi8vMnZwSDlkUXloNUd6VERCMlRCeWZHMEFoZFp4ZUVxV1pINSs2?=
 =?utf-8?B?QnlpcWpOR2JPK2J5MHNjK1VrVC96TTIxOEFIaGpYdEZqTE41WVl6S1JnOUJr?=
 =?utf-8?B?RUNoaU1lL3ZUOWxNVUVDbnY0dlkvdTJPT3pyOHMrTEpHdkRXYVEyRFRQNlVn?=
 =?utf-8?B?UW8wSlRzeWhDNVdxcDFaNUw0MG54dUlKUWxsVmd0K3ZscUZkektyM1grRFpW?=
 =?utf-8?B?Y0J0VUpRVDZhR1MrMFQvbHV0RHBBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d030b452-b95e-4fa5-54fa-08dab67b6fff
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 11:24:10.2271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AhprICvLU5m5PHx2bzEUCIGusxzfVZ9y0dwyhdnr3y4sx7K4nZuoowl0/pQ0ymu43sYyrOFtsRgZUwvxm3A6OvU7KwTIHt/SEFEreBxe83FlcZ42Zdozau4BHZpt7dwP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5805
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgT2N0b2JlciAyNSwgMjAyMiAzOjQ4IFBNDQo+IE9uIFR1ZSwgT2N0IDI1LCAyMDIyIGF0IDY6
MzkgQU0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMu
Y29tPiB3cm90ZToNCj4gPiA+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgT2N0b2JlciAyNSwgMjAyMiAxMjoyOCBBTQ0KPiA+ID4gVG86IGtlcm5lbCB0ZXN0IHJvYm90
IDxsa3BAaW50ZWwuY29tPg0KPiA+ID4gQ2M6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8u
c2hpbW9kYS51aEByZW5lc2FzLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdv
b2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gPiA+IHBhYmVuaUByZWRoYXQuY29tOyByb2Jo
K2R0QGtlcm5lbC5vcmc7IGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9yZzsga2J1aWxk
LWFsbEBsaXN0cy4wMS5vcmc7DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnDQo+
ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDIvM10gbmV0OiBldGhlcm5ldDogcmVuZXNhczog
QWRkIEV0aGVybmV0IFN3aXRjaCBkcml2ZXINCj4gPiA+DQo+ID4gPiBPbiBXZWQsIE9jdCAxOSwg
MjAyMiBhdCAxOjE3IFBNIGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPiB3cm90ZToN
Cj4gPiA+ID4gSSBsb3ZlIHlvdXIgcGF0Y2ghIFBlcmhhcHMgc29tZXRoaW5nIHRvIGltcHJvdmU6
DQo+ID4gPiA+DQo+ID4gPiA+IFthdXRvIGJ1aWxkIHRlc3QgV0FSTklORyBvbiBuZXQtbmV4dC9t
YXN0ZXJdDQo+ID4gPiA+IFthbHNvIGJ1aWxkIHRlc3QgV0FSTklORyBvbiBuZXQvbWFzdGVyIHJv
YmgvZm9yLW5leHQgbGludXMvbWFzdGVyIHY2LjEtcmMxIG5leHQtMjAyMjEwMTldDQo+ID4gPiA+
IFtJZiB5b3VyIHBhdGNoIGlzIGFwcGxpZWQgdG8gdGhlIHdyb25nIGdpdCB0cmVlLCBraW5kbHkg
ZHJvcCB1cyBhIG5vdGUuDQo+ID4gPiA+IEFuZCB3aGVuIHN1Ym1pdHRpbmcgcGF0Y2gsIHdlIHN1
Z2dlc3QgdG8gdXNlICctLWJhc2UnIGFzIGRvY3VtZW50ZWQgaW4NCj4gPiA+ID4NCj4gPiA8c25p
cD4NCj4gPiA+ID4gICAgICAgICBnaXQgY2hlY2tvdXQgZjMxMGY4Y2MzN2RmYjA5MGNmYjA2YWUz
ODUzMDI3NjMyNzU2OTQ2NA0KPiA+ID4gPiAgICAgICAgICMgc2F2ZSB0aGUgY29uZmlnIGZpbGUN
Cj4gPiA+ID4gICAgICAgICBta2RpciBidWlsZF9kaXIgJiYgY3AgY29uZmlnIGJ1aWxkX2Rpci8u
Y29uZmlnDQo+ID4gPiA+ICAgICAgICAgQ09NUElMRVJfSU5TVEFMTF9QQVRIPSRIT01FLzBkYXkg
Q09NUElMRVI9Z2NjLTEyLjEuMCBtYWtlLmNyb3NzIFc9MSBPPWJ1aWxkX2RpciBBUkNIPW02OGsg
U0hFTEw9L2Jpbi9iYXNoDQo+ID4gPiBkcml2ZXJzL25ldC8NCj4gPiA+ID4NCj4gPiA+ID4gSWYg
eW91IGZpeCB0aGUgaXNzdWUsIGtpbmRseSBhZGQgZm9sbG93aW5nIHRhZyB3aGVyZSBhcHBsaWNh
YmxlDQo+ID4gPiA+IHwgUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwu
Y29tPg0KPiA+ID4gPg0KPiA+ID4gPiBBbGwgd2FybmluZ3MgKG5ldyBvbmVzIHByZWZpeGVkIGJ5
ID4+KToNCj4gPiA+ID4NCj4gPiA+ID4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
c3dpdGNoLmM6IEluIGZ1bmN0aW9uICdyc3dpdGNoX2V4dF9kZXNjX2dldF9kcHRyJzoNCj4gPiA+
ID4gPj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmM6MzU1OjcxOiB3YXJu
aW5nOiBsZWZ0IHNoaWZ0IGNvdW50ID49IHdpZHRoIG9mIHR5cGUgWy1Xc2hpZnQtY291bnQtb3Zl
cmZsb3ddDQo+ID4gPiA+ICAgICAgMzU1IHwgICAgICAgICByZXR1cm4gX19sZTMyX3RvX2NwdShk
ZXNjLT5kcHRybCkgfCAoZG1hX2FkZHJfdCkoZGVzYy0+ZHB0cmgpIDw8IDMyOw0KPiA+ID4gPiAg
ICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBefg0KPiA+ID4gPiAgICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3Jzd2l0Y2guYzogSW4gZnVuY3Rpb24gJ3Jzd2l0Y2hfZXh0X3RzX2Rlc2NfZ2V0
X2RwdHInOg0KPiA+ID4gPiAgICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2gu
YzozNjc6NzE6IHdhcm5pbmc6IGxlZnQgc2hpZnQgY291bnQgPj0gd2lkdGggb2YgdHlwZQ0KPiBb
LVdzaGlmdC1jb3VudC1vdmVyZmxvd10NCj4gPiA+ID4gICAgICAzNjcgfCAgICAgICAgIHJldHVy
biBfX2xlMzJfdG9fY3B1KGRlc2MtPmRwdHJsKSB8IChkbWFfYWRkcl90KShkZXNjLT5kcHRyaCkg
PDwgMzI7DQo+ID4gPiA+ICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+DQo+ID4gPiA+DQo+ID4g
PiA+DQo+ID4gPiA+IHZpbSArMzU1IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcnN3aXRj
aC5jDQo+ID4gPiA+DQo+ID4gPiA+ICAgIDM1Mg0KPiA+ID4gPiAgICAzNTMgIHN0YXRpYyBkbWFf
YWRkcl90IHJzd2l0Y2hfZXh0X2Rlc2NfZ2V0X2RwdHIoc3RydWN0IHJzd2l0Y2hfZXh0X2Rlc2Mg
KmRlc2MpDQo+ID4gPiA+ICAgIDM1NCAgew0KPiA+ID4gPiAgPiAzNTUgICAgICAgICAgcmV0dXJu
IF9fbGUzMl90b19jcHUoZGVzYy0+ZHB0cmwpIHwgKGRtYV9hZGRyX3QpKGRlc2MtPmRwdHJoKSA8
PCAzMjsNCj4gPiA+DQo+ID4gPiBBIHNpbXBsZSBmaXggd291bGQgYmUgdG8gcmVwbGFjZSB0aGUg
Y2FzdCB0byAiZG1hX2FkZHJfdCIgYnkgYSBjYXN0IHRvICJ1NjQiLg0KPiANCj4gPiBJIGdvdCBp
dC4gSSdsbCBmaXggdGhpcyBieSBhIGNhc3QgdG8gInU2NCIuDQo+ID4NCj4gPiA+IEJUVywgaWYg
c3RydWN0IHJzd2l0Y2hfZXh0X2Rlc2Mgd291bGQganVzdCBleHRlbmQgc3RydWN0IHJzd2l0Y2hf
ZGVzYywNCj4gPiA+IHlvdSBjb3VsZCB1c2UgcnN3aXRjaF9leHRfZGVzY19nZXRfZHB0cigpIGZv
ciBib3RoLg0KPiA+DQo+ID4gWWVzLCBhbGwgcnN3aXRjaF94eHhfZGVzYyBqdXN0IGV4dGVuZCBz
dHJ1Y3QgcnN3aXRjaF9kZXNjLg0KPiA+IFNvLCBJJ2xsIG1vZGlmeSB0aGlzIGZ1bmN0aW9uIGxp
a2UgYmVsb3c6DQo+ID4gLS0tDQo+ID4gLyogQWxsIHN0cnVjdCByc3dpdGNoX3h4eF9kZXNjIGp1
c3QgZXh0ZW5kIHN0cnVjdCByc3dpdGNoX2Rlc2MsIHNvIHRoYXQNCj4gPiAgKiB3ZSBjYW4gdXNl
IHJzd2l0Y2hfZGVzY19nZXRfZHB0cigpIGZvciB0aGVtLg0KPiA+ICAqLw0KPiA+IHN0YXRpYyBk
bWFfYWRkcl90IHJzd2l0Y2hfZGVzY19nZXRfZHB0cih2b2lkICpfZGVzYykNCj4gPiB7DQo+ID4g
ICAgICAgICBzdHJ1Y3QgcnN3aXRjaF9kZXNjICpkZXNjID0gX2Rlc2M7DQo+ID4NCj4gPiAgICAg
ICAgIHJldHVybiBfX2xlMzJfdG9fY3B1KGRlc2MtPmRwdHJsKSB8ICh1NjQpKGRlc2MtPmRwdHJo
KSA8PCAzMjsNCj4gPiB9DQo+IA0KPiBXaGlsZSB0aGUgYWJvdmUgd291bGQgd29yaywgdGhlIHZv
aWQgKiBwYXJhbWV0ZXIgaW5oaWJpdHMgY29tcGlsZXIgY2hlY2tzLg0KPiANCj4gSGVuY2UgSSBz
dWdnZXN0IGRlZmluaW5nIHN0cnVjdCByc3dpdGNoX2V4dF9kZXNjIGxpa2U6DQo+IA0KPiAgICAg
c3RydWN0IHJzd2l0Y2hfZXh0X2Rlc2Mgew0KPiAgICAgICAgICAgICBzdHJ1Y3QgcnN3aXRjaF9k
ZXNjIGRlc2M7DQo+ICAgICAgICAgICAgIF9fbGU2NCBpbmZvMTsNCj4gICAgIH07DQo+IA0KPiBU
aGVuIHlvdSBjYW4ganVzdCBwYXNzICZleHQtPmRlc2MgdG8gYSBmdW5jdGlvbiB0aGF0IHRha2Vz
IGENCj4gKGNvbnN0KSBzdHJ1Y3QgcnN3aXRjaF9kZXNjICouDQoNClRoYW5rIHlvdSBmb3IgeW91
ciBzdWdnZXN0aW9uLiBJdCB3b3JrZWQgY29ycmVjdGx5Lg0KSSdsbCBjaGFuZ2UgYm90aCByc3dp
dGNoX2Rlc2NfZ2V0X2RwdHIoKSBhbmQgcnN3aXRjaF9kZXNjX3NldF9kcHRyKCkuDQoNCkJlc3Qg
cmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
