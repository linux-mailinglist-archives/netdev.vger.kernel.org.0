Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA953BDB2
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiFBSBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiFBSBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:01:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A2218CE08;
        Thu,  2 Jun 2022 11:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSZRvBHc9uqhICLQXf2GQoXPbsK5/uTiH2I8bjMFxWHM+0Ziy1ji2IX+hz80JkjZ2tgXE4ge+oCvn8vllpegQIsli9lbhe6Q3r8LqEka+41mm5RGxpaXOfqbbvnBcMCEjH10VKeqpi8Y5E+aPfO0j67YiBuLYFyKMOY3ZBUxMX2AWyjIJl3srZaJHLkaoyPFFQ2Kn3FsaM+iJGD79nmEUdGghLrvAdY/KwaekC0Lwc2E+a+mrCxP7a6QfLEsw+nifGxfaJ7jxCsmc+DtCGlMR2t5UPXAFrNFKOeyww7ep4K7566w1zun7zOJgoT6ZQZx5yVYzXvnQQsHDMelGVHYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTe4lzataAvhUN4AZA0hPrI19nQnHDFRkSyBLLhZCvM=;
 b=Lv6w+OtnQ/dlVwPl402ZCfrZ2WJynf8JjpmwkuuVNjMnjHid1hXTKRKhbCqyRn+4T9ejZaAI67gNkAJleMueQI4uHcXqxdeUoBF8hfMfOzsazFBBvvcra1jjTSaUdsqSxFPBODjw5oJN1oE0yqP/KyXpbFxlsJZWnwZl2IF5ia3305l2P5BTEsbUeCPggCzUIFVX3VZkZ+GAqCsRgZ2l9hdXkpiTjtO9g5tNWAByXI+FjA8mDeVVi0FDAptSmVQ27FcvVkprBGvnsRAc+mrBlYx73DIMZRDGD7rMFRLfDXP/d5nMzlzVKRZCYHWkGX8C50ApR55HyBELCKtCsVUQPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTe4lzataAvhUN4AZA0hPrI19nQnHDFRkSyBLLhZCvM=;
 b=Hq65YZ8rFaaCwH7JVL+Gpgp1ccZZ+y6Yg76mytf4F1RQDT9sBtoPDEE9jcqbe1ufph0fzfyuwwfVa/bfA5WNIx8GKpMHIymbW3tyWKJNIP8wMGw+L3vGckgExQ3eqDOlFl51t87CFwzSsJDI9seecOV3IU+do6P4SBrB2IUzl14=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CH0PR10MB5050.namprd10.prod.outlook.com (2603:10b6:610:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 18:01:09 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 18:01:08 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8AgAAI2QCAAATTAIAAClqAgAACeoA=
Date:   Thu, 2 Jun 2022 18:01:08 +0000
Message-ID: <2765ed7299a05d6740ce7040b6ebe724b5979620.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
         <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
         <20220602095756.764471e8@kernel.org>
         <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
         <20220602105215.12aff895@kernel.org>
In-Reply-To: <20220602105215.12aff895@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d450e7c-f538-42df-b0e6-08da44c1dea3
x-ms-traffictypediagnostic: CH0PR10MB5050:EE_
x-microsoft-antispam-prvs: <CH0PR10MB50506801274A977E2FA9FDC4F4DE9@CH0PR10MB5050.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NiZjvkXOyXfin5jyD7KOM4qnxlv88tW1jlWNcFtKZWbGxGkTIOfF05U/LrCrHsHK6SJCkzsyygmF4ToL+FUxEoELbvGI4MZCXIOsK2h1KQVR+sWzK0uTh3zTnjawEjEDGXgqhwx+uvZOOwTwTdWzurmZxJjz4HSwTdpAZ8unY/hEn8T/p4u1iYK6uJu/Bjiv/GhV7sgkQfF8NKgrgv6bAUyJ/3GJzR6x9mwLANeCqxvTHj7Mc6DVtHp/1Yup8Aj2Yw84QU7kkI6pBJzh5dsD/vWVKRAnZVRc00jur58/lprRNWwBJ/gou4dQCKclMbeZna2KrmEm/BZmWjymz7PAPr2JtDQky/oiVX3aZ6cDv7K4uZqRy57O2l2gU1GkSye8uDgfUstoQ2FCRuiXpQQ2m+Gshn9V5yl3kruT138v1BOpc5dtotMVZFY2prnvgRMTCOJ4d/RKRnFc/C98m+6HkcZWNSGMP88picOjk9AVQBh7UTuoEKLpaPtnhhvm0HHfUhVRFIcdxu2ZHia2R8mwG99cMCRmH6Ex7K8aT677Joj+r7OnTx3cec+hFCeOvN1LvGsa6sPohWknQuFPAIjNlwq/htMKV9UFLkzv5eFslH8vrz0aiK84zAi03V4aAsB6Z0dIDBG8fW2nOFpPPqzqhzEhb3+dZ8baSlqrNbCHKuAX9deYwBJIWZlG2PXNNWTjyzO3fPF+KHRIWQYQBHfRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(38070700005)(38100700002)(2906002)(186003)(6916009)(66556008)(66446008)(66476007)(66946007)(64756008)(91956017)(54906003)(76116006)(8676002)(316002)(4326008)(36756003)(83380400001)(8936002)(71200400001)(6506007)(6486002)(5660300002)(508600001)(122000001)(26005)(6512007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmJqK2hKczFDaDZ0MFN4RndHN1pvVkJuTmZDOHg3d3ZLQzYweG9sZ2daSjVJ?=
 =?utf-8?B?Yjd5SElMZ3grSnRRTFdVclUvb2pBcWRJTXNnMEQ1cXhXWlJtQnJCUmR0M1pT?=
 =?utf-8?B?YklTV2dMeFNCNTN6eXMxSzFLc2VMV2lDcG45akdvWGM5QXVDTyt2elhBa1ZR?=
 =?utf-8?B?QVNlYWtNU3U5RTVGMENKSmlDb20xaVlOSy84bFk3RWI1TGUxNFA1dk1Wa1hS?=
 =?utf-8?B?Uk1peFFodGxzR0s3b3VmMVJrVXJ3bGcrOEdnaTVDd01RanBodE5VZ1diRmNm?=
 =?utf-8?B?RmtCdlVMV21TKzZ0NWpETTg3eCs2WUpIOFl1d1ZKUUVEZE51dThJUnRrMVpo?=
 =?utf-8?B?WkhmZFpUbTdGY3JIcDBYMW1SbVZaQzFTQlFMSTNIMVhZK3dSa0xVbk52UU5i?=
 =?utf-8?B?cEg4dTdmSlF5TUZTY0FSa0JBdmxrdkV4VG9zZkdSSUhmQ3VIeDFyZ0FpMDlF?=
 =?utf-8?B?V2Q3dEZRMXZkc3FpOFRiYWJNa20zRkRNclNMYkJmTW9ZeEdxK2tCZUxUMXBB?=
 =?utf-8?B?M1VJamJLby95Q0lOVWhSeC9rWVI4WlNMRDBhTzlYTGppMHpBQ1lzMzRNK3Q0?=
 =?utf-8?B?QTRib3lEUkJqVHpKUFN6cGtwNjhHTkFKWXlOZ3BXT29nK2NSZCtEUE1CaUdk?=
 =?utf-8?B?VGVkOEVYbGFyamw5aUNEQmI0UWNKMFdkekh0ZEkzK09yc1UwQ1dtblV4azF3?=
 =?utf-8?B?dVBlMEtSWUpIM1VQQXR4cGlpZTFLTTZIVHFlSjBNZE9TUkJ2bnBaZmdPcE10?=
 =?utf-8?B?VTUzV29VNktJb3N0WVNBVDhOYlZVand0Z21iUXpCUzdsQzAwb3dMeVVIbGJC?=
 =?utf-8?B?TXA5ZEpzY2xpOFZpbkRMNkxtcUN4eTFDWkxmNGRONFJ3WlNpbVhlQjh6YkFF?=
 =?utf-8?B?TzlPM2haQ0NiMHdzU3UzVGRNZ0tEMmF4Z2dVSTBwVVp2a0lzZk1WNFZ5UEEz?=
 =?utf-8?B?V0srRWZ5NUdMOXA0Q1gvWGZ2MXljTmMrVFVCZnhLRXpwejBTOTJpaThlcTk3?=
 =?utf-8?B?VmJLcy8wcURBY0NpOHZBUitxR0NRZWNVQkU3bUVZajJlelRsNHlPblp0UUli?=
 =?utf-8?B?UktrellVcGRNaUNycG9aS3I2WndPdE1EeW5tNStTQ2FBS25pQjl5UTlSVVRw?=
 =?utf-8?B?aGcvUGVobWVnN0JlMndwaWlDNzA3MFNVRWhodzRoMWo1UStTUUJoRFR6UzU4?=
 =?utf-8?B?ZG0wS0Rrek5VRTRnZXc0WHB6RkhwbW9rWXF3dWxlWU5HUllLSzRqSENRY2FT?=
 =?utf-8?B?YlZkZWxQUVFxbXQwRlBpTkxSZkh3WHNjNDk1RkM0cFlVYXl3eXhhdSs5ZnVw?=
 =?utf-8?B?ajNlT1l3ZE1Xb2NmWnFrNUROdnRnTnY5RFhjdEEwdFoyUSs5dUsvcjNHMWpD?=
 =?utf-8?B?d0hYY0w2Z09DekRhRkh1UU1qVjEzNlZkVTRPcTVmcklVQmZnY1VLQjBZNUFD?=
 =?utf-8?B?R3BvTjFoUlQvbDhnVU5LU0ljdzhscVBsSHkvTmpwWjVTWHJJMk1NRkF3dlFj?=
 =?utf-8?B?QzRDcjZZbFJHVWVnTmRISXlKdzROQ2xRenF4THB0YjhqbFkxRzFyK2FDbTdC?=
 =?utf-8?B?ZC9CL3FDVGZQZnRQYjZ0TW0rS1VHbUM0Vk5kNHV5NmhXY0QvNThXNTYyejl5?=
 =?utf-8?B?UStTcnh2R2s2T0JacFhRcU9scUlEOGJxUVpEQ2cvSDNrdlV6cm0waElYL2Jw?=
 =?utf-8?B?N3RZamcxb3ROM25jMkMybnMyVlBFanFwTTlYVERLUUU0OFVpUTlZV0FGQnB6?=
 =?utf-8?B?SFoyNGkrNXVyajgrcEVrNnBJOWFiVVJYQ0hSWkRQb0FDWFlSWnEvMkVYRCtV?=
 =?utf-8?B?OWt6V1RXS1N3bTJlS1NMRnptL1l0Uzl3ZjVQa1M0NUl0N3ZKYWVTMjliRHpD?=
 =?utf-8?B?UUFPVXhtVTNPZDlpNmlaSlBpWVpGOWNQdUNPYzY2dnJEanM4bkNkOGtGSDR5?=
 =?utf-8?B?UlhrYXFGb1V5U2M2aXB1L2lRa2xDUzhvb2tseXQ4Z1BKTXJubm5qRzVlV0J0?=
 =?utf-8?B?a3lWRFpTbm9MZGhRQmF2REVNeUozb0lTM1A0REVUSnp4U2RWZ1loeURVTlZI?=
 =?utf-8?B?VnBxRE9IZE85MTNlMWVlc1lnZ3hwV3lVOGFPU3hhWldSd1M5dlBvQmxTdHJQ?=
 =?utf-8?B?b3NFVTdQUUlra3BqZXRRSTRLMEVlazhjVXY5dlR3dEVpY2xrd0FQYzBocld1?=
 =?utf-8?B?V2NlU2NFTVZKcWY5L0MvcUk2SVZPcFgxMy91Y0xRelo0OXpkUXoxeWZDTWh0?=
 =?utf-8?B?bGtjMDdiTXhxUHoxSDJtQ3pycWVaazR6d2FIQlA0aEhCRHI4aVBWek53Z2xW?=
 =?utf-8?B?ZGx2NkF0aEJWYS9MazhBVmVhN1czV3BNblR6VGdxNWdEbnJNTmdHS2U3R05a?=
 =?utf-8?Q?XGO0sVNpYItaTuUQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59A7C95B553F3E4283F04E0A59C96EE6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d450e7c-f538-42df-b0e6-08da44c1dea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 18:01:08.0368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKDSIAuJ7/bc5F6JXA+U9l/QxzmPbUjq8O1RCpjzaHhrOAX3iXIzil0H1lkwSzhTA6MbdbSQXMJ2IKAHenpP2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5050
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTAyIGF0IDEwOjUyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyIEp1biAyMDIyIDE3OjE1OjEzICswMDAwIEpvYWtpbSBUamVybmx1bmQgd3Jv
dGU6DQo+ID4gPiBXaGF0IGlzICJvdXIgSFciLCB3aGF0IGtlcm5lbCBkcml2ZXIgZG9lcyBpdCB1
c2UgYW5kIHdoeSBjYW4ndCB0aGUNCj4gPiA+IGtlcm5lbCBkcml2ZXIgdGFrZSBjYXJlIG9mIG1h
a2luZyBzdXJlIHRoZSBkZXZpY2UgaXMgbm90IGFjY2Vzc2VkDQo+ID4gPiB3aGVuIGl0J2QgY3Jh
c2ggdGhlIHN5c3RlbT8gIA0KPiA+IA0KPiA+IEl0IGlzIGEgY3VzdG9tIGFzaWMgd2l0aCBzb21l
IGhvbWVncm93biBjb250cm9sbGVyLiBUaGUgZnVsbCBjb25maWcgcGF0aCBpcyB0b28gY29tcGxl
eCBmb3Iga2VybmVsIHRvbw0KPiA+IGtub3cgYW5kIGRlcGVuZHMgb24gdXNlciBpbnB1dC4NCj4g
DQo+IFdlIGhhdmUgYSBsb25nIHN0YW5kaW5nIHRyYWRpdGlvbiBvZiBub3QgY2FyaW5nIGFib3V0
IHVzZXIgc3BhY2UNCj4gZHJpdmVycyBpbiBuZXRkZXYgbGFuZC4gSSBzZWUgbm8gcmVhc29uIHRv
IG1lcmdlIHRoaXMgcGF0Y2ggdXBzdHJlYW0uDQoNClRoaXMgaXMgbm90IGEgdXNlciBzcGFjZSBk
cml2ZXIuIFZpZXcgaXQgYXMgYSBldGggY29udHJvbGxlciB3aXRoIGEgZHVtIFBIWQ0Kd2hpY2gg
Y2Fubm90IGNvbnZleSBsaW5rIHN0YXR1cy4gVGhlIGtlcm5lbCBkcml2ZXIgdGhlbiBuZWVkcyBo
ZWxwIHdpdGggbWFuYWdpbmcgY2Fycmllci4NCiAgDQo+IA0KPiA+ID4gPiBNYXliZSBzbyBidXQg
aXQgc2VlbXMgdG8gbWUgdGhhdCB0aGlzIGxpbWl0YXRpb24gd2FzIHB1dCBpbiBwbGFjZSB3aXRo
b3V0IG11Y2ggdGhvdWdodC4gIA0KPiA+ID4gDQo+ID4gPiBEb24ndCBtYWtlIHVubmVjZXNzYXJ5
IGRpc3BhcmFnaW5nIHN0YXRlbWVudHMgYWJvdXQgc29tZW9uZSBlbHNlJ3Mgd29yay4NCj4gPiA+
IFdob2V2ZXIgdGhhdCBwZXJzb24gd2FzLiAgDQo+ID4gDQo+ID4gVGhhdCB3YXMgbm90IG1lYW50
IHRoZSB3YXkgeW91IHJlYWQgaXQsIHNvcnJ5IGZvciBiZWluZyB1bmNsZWFyLg0KPiA+IFRoZSBj
b21taXQgZnJvbSAyMDEyIHNpbXBseSBzYXlzOg0KPiA+IG5ldDogYWxsb3cgdG8gY2hhbmdlIGNh
cnJpZXIgdmlhIHN5c2ZzDQo+ID4gICAgIA0KPiA+ICAgICBNYWtlIGNhcnJpZXIgd3JpdGFibGUN
Cj4gDQo+IFllYWgsIElJVUMgdGhlIGludGVyZmFjZSB3YXMgY3JlYXRlZCBmb3Igc29mdHdhcmUg
ZGV2aWNlcy4NCg0Kc29mdHdhcmUgZGV2aWNlcz8gbGlrZSBkdW1teSBkZXZpY2U/IEkgZ3Vlc3Mg
dGhhdCBpcyB0aGUgZmlyc3QgdXNlciBvZg0KdGhpcyBmZWF0dXJlIGJ1dCBub3QgcmVzdHJpY3Rl
ZCB0byB0aGF0Lg0KDQogSm9ja2UNCg==
