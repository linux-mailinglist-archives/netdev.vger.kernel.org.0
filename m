Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8B75B5C2B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiILO1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 10:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiILO1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 10:27:37 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2092.outbound.protection.outlook.com [40.107.21.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345A25FF8;
        Mon, 12 Sep 2022 07:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWfPJWxbSF+e+JkiXKjzQgykpJiCE4EyDAq1NW0RqK7H3f82BM97iDozTB/d32jDGOIZsytnIaDYu6OQ+L1FQA6/owFbZG6/QxcFqbFlB5t7StB3r0TNG40Y8+drv0Eji6T5dOsPaIzYSohzsYXHYbxDSm3HoiYnNxFJNG+M9rJRYExLAjPM/PhcQhXtLkMx+CX/A2cNeYPNMAPV1tc5MhiBnSjACincu0VoGmn0yi1anWvfH/swARv5ai8nideajKhPM+I+mtMsPHq8nRB+p/G12Az9dCWtB0oohrxJ2ymuFVPfWlN8sRKM3hI1QjJr0AqzBnmWXECA9Ow4wS7vUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mh5y7aV9IeZ+9dfqOWF/LEDc45To/nUB70gmyECoSzI=;
 b=lDcpqUjdNP1ZnsfnKc9DwHeRr4GCvpWt3Pd0mvWDeWNXp67XJQq+CJlo+NURqoBPJUC6VMrYwp5+FYRq9riHuV9xzi3rVcvYlK5ZbCt5NuWh9NLUpqhUZvvKD8N5JpvSTbwDKaBez10uDx+r8TUr66sXL6ZD+wPFmX2VxVNGyJaQCGouRNi/9OdPU5/NimRVh6t5Ns4ap2+rmzbpcWCcj/EMvNPNFkRUXtDO9/lKto1z4LO2Cfb0NPBt92xIcQm7OPfkwhEKrmDhgCCHKNIWKFq//wxtqN5VyGujsT+WSvSBgz9krpOJD8t/g3U9IkwhtsbBvKUWVSpNIj+MhHztOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mh5y7aV9IeZ+9dfqOWF/LEDc45To/nUB70gmyECoSzI=;
 b=WAHZUBKCzTpAbbwsTDCy9fgMbT2edIqoyU8u1GO5W7xsZ5ooxNk/9cEkTixMLacuPWM1xiezMRkMtJ83DgkYajbWJqXZE8jIBiU7HA1HmrUnHbhdwBhWrwLGqaM78K1noN+6PT4AYqvWkiCiYGqjDoZXTzB225T6ELtbKb1bzhk=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM9PR03MB7525.eurprd03.prod.outlook.com (2603:10a6:20b:410::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 14:27:32 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 14:27:32 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Mark Kettenis <mark.kettenis@xs4all.nl>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "aspriel@gmail.com" <aspriel@gmail.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "arend@broadcom.com" <arend@broadcom.com>
Subject: Re: [PATCH wireless-next v2 01/12] dt-bindings: net: bcm4329-fmac:
 Add Apple properties & chips
Thread-Topic: [PATCH wireless-next v2 01/12] dt-bindings: net: bcm4329-fmac:
 Add Apple properties & chips
Thread-Index: AQHYxp8VRhIzhoN1vkifFhGA/p+3uK3bsoMAgAAgcgCAAANdAIAABACA
Date:   Mon, 12 Sep 2022 14:27:32 +0000
Message-ID: <20220912142727.tmqd7h7axwo226hm@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7N-0064ug-9l@rmk-PC.armlinux.org.uk>
 <20220912115911.e7dlm2xugfq57mei@bang-olufsen.dk>
 <Yx8gasTCj90Q5qZz@shell.armlinux.org.uk>
 <Yx87omI/la1o+Aye@shell.armlinux.org.uk>
 <d3cee741b298e526@bloch.sibelius.xs4all.nl>
In-Reply-To: <d3cee741b298e526@bloch.sibelius.xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AM9PR03MB7525:EE_
x-ms-office365-filtering-correlation-id: 99f6192d-eb6a-44f5-f2f5-08da94caedfe
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cLZjExReu54NA+O2y6pnzksew7tlatH0MGJ54sQ52NCdwgPqEElnhuOmFnj/jiTFbnhK8J9N/+jILfgtMAYNet/SuKUn7A4L9wNv8+UEv6wt4udsXBtH0eqct3Q7asq89bKlpLmRHg5vatLTVBasZhXlCv2CzpXcAXVAFJJyGbReM50tA5bH4tJFJ83GNQoqCkpO+tluk+MCRUA2JLr3LM3ApxVKc1YFana234OrsxtS+du54BznyyjgpwlRvlo+1XQi4RpOJ+Hu3gUmfMqA8heOuML7Kw7krfT4GAqWHaxB2HJE0317gd4hDr+xV9qkfrcwJfCWfAUJpkyuk7YXUYLePR/V6Bjb/OCBmIHKPkl1BaYDDE7JpLBxEE6YgSOsYq7fXsoIH7vo+fr6xm5T9sP5eXUCzfBzyhFOs/Syg+ixrMhdR3WvVz+XcTU2e4TDoWlgnojRpBDnr39opVz4nYavhZFzST7Ac8gIyaDWoTdoVpLf372fnRLXnwYK8l8rle0CeHmrU9lrjzvEawuEVdD+6qc+3h8eeI4yrg4vnYNMPy6TmotAGlx3TTW6tQXe5MsSggv5qEbmg8ApyYzWcib2bTGZxWXeuqukAv4gafWVIywD/DkYYoj3UD0Pa/t2c1RmRsTs2GZ9fYN1ifyOjW2BWuxC82Fm2JseHnHguMCp8+/T4kQP5CrwK4U7lZTGSSVHTc7Lrw+stcC+hpdPfP9pTtnJwlfgModiKo7d83Y4wDgApinh3CydRvRx2WbuInAemlokNnb7cSpAHHG48VJ1+SDc8V1Y0dPBjgTzPPACTGBBmKHse4xbkCR1Di7PO9TJ61fsB+Hyh5spnqPxIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(47660400002)(83380400001)(6916009)(54906003)(966005)(316002)(478600001)(6486002)(71200400001)(36756003)(85202003)(85182001)(26005)(6512007)(6506007)(1076003)(186003)(2616005)(2906002)(122000001)(38070700005)(86362001)(38100700002)(7416002)(5660300002)(76116006)(8676002)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(8976002)(91956017)(8936002)(41300700001)(46800400005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2VRK1FidVZRN0JBN2VpQjc0WnNZUGdwdmRSd0k4WWZkYnMwWnkydlZDWG9D?=
 =?utf-8?B?OEplUExuRDM1czZZUEl3Q0JSUUtJVXlhV2xnbzN1U3pyVmJvL3NYSWR2K1Nh?=
 =?utf-8?B?V21yM0hqRTIwY1JhTnhpYjkwQW55VmtaSFFmRUxQOFlzQ0JYTzBoR0VJNklB?=
 =?utf-8?B?TFJGS0tFa3cyMWhxcDJINXF5c1pnZ0FmZERKeWZEWE9qcGFQYnFnVW81dkFP?=
 =?utf-8?B?eExuT0g0TFNHczNDL3ViQTVnSFFuYlJVbUxDVi9TZ3FRZmxOME8vZUtZRnBZ?=
 =?utf-8?B?NjJJb1czeWlpdURsWi9MQkVMSllUUUl0cmZzcUpPcGpWWEFGRG51d0tkWGJD?=
 =?utf-8?B?OFMyMVRTYlc5Ujg4ZmhEYXdVdWhHejgyT0FLWnVNOVB3aXRYQndDU203bUxq?=
 =?utf-8?B?cjhKTXVaNmZCdk4vOThEWVJRa09XZ3Y3cGVVZ0ZFNWxIc282M2t5eTh1bmZh?=
 =?utf-8?B?Y2FUbGN6YVBvL3lDaWJmWE5YTmhaV3NrZnlJTkFGVk9VM25nWG5NbW5qcmI4?=
 =?utf-8?B?VXhkRGJ1QjZDUHpadFBpck85YTkvdWNIM3R5ckp4WENTL24vakVZVG1vRnNk?=
 =?utf-8?B?dnVjanR4TDU0TXg2UVZWVG1nNWtFYmt1eGVsWElXcDVuSTVXMTFTZ1FvUm5R?=
 =?utf-8?B?NDZQR2twL3JMeVExRzZ0a1JWajRIYXN5clBvTDZNTEJOT3cvamdSbFAxTCtZ?=
 =?utf-8?B?NG1Mb1NweHVUaGdSTHZaUnNTLzBod05MdFc3ZGZ0QlFWZ2lFYWtmaHhlbjZB?=
 =?utf-8?B?eGpYblpMYlEybkljMUphUFhEWlowLzVWQm1SWmFRNHJ6UXJCZUF4U05yNUlG?=
 =?utf-8?B?bTVRNENaRmJ4WFpjQzAxNFd6RlJUT1JvUDBuT3dMc3BjOWNnU2JxSmRPQjZR?=
 =?utf-8?B?Z1BudXljZHgvZ3ZZNlFEOTgxcUhML2JURG4rK1BVZnlGRlhqNUJGdTNnMzN1?=
 =?utf-8?B?RUJOVk5RVlBpaU96NVk3NnE0ekRNazdSbUdBNEcvVWNXR3RsWkd3bnYyZFVF?=
 =?utf-8?B?MXI3QVV5dDZFdnZnMFo5bkxGMHdlcm0xekNDNFc2N3dXd2d5TXhQNWV1N2tt?=
 =?utf-8?B?bTZqRmVRSVN3a2s4YzJFNVJJYUNtMUNwRm81Sjkrc05SZmdNdnVBZ2FocnN2?=
 =?utf-8?B?TTB2RzRhVXlkNS9BN3dNZ0JGNUxjRWF5MFY4Q1Jqam1laVJ0UDFYaDFaZWZt?=
 =?utf-8?B?ajBTc1FtZUgybGVRMWNyM3Z3cFR2MFFuWGFUVGVVR3N2Zkhmd0cveWt1NSti?=
 =?utf-8?B?ZElRSE1WQWhXTGROa0lsaWFxNHNDVUF4NFd5YXlXQnBFUmxtQXZ3UFAvZm5P?=
 =?utf-8?B?Sjd5STlrbGlnT3hyVHJpaFF4bUlmY2EzTndyK2orbXg0azhQcTBwTXloUXA0?=
 =?utf-8?B?dGtmMktLV1MrWFdmODBmSzMwcGFSK3Mvdm5NMjZ0WWtDSTlxOWtjMHZkekEr?=
 =?utf-8?B?Vk5sUUpPcm1odHg3eXF4aUFJYkozWHBzZ0Rhd1VkaGNmdkcrUWwvWndWb3FB?=
 =?utf-8?B?OW02dldVNzQwdU1oTXpyKzYvbTZweGZCOXEwK1J6ZWI2RDRhdXlCMWc4bWds?=
 =?utf-8?B?ZHdPeXkrcnV6eVMvM05zZFA3TmV2WWxrZWRmZTgyMmhaKyt1RXZMVndiK1JS?=
 =?utf-8?B?aSs5bXptZGpwY1p2SzRiR1pFTkpsWWtSNmR1amVvdHdvMzBBNERBbmZWV3l0?=
 =?utf-8?B?WVA5NTd5SFdHMjFpMmFFTkZKd3VIdHdHVjVmM2F6MDNJNHNvQVljNjlFVEYz?=
 =?utf-8?B?cEU0c3dweHJlY250SFQyS1ArZnQzcHljaEV3bC9EKzRxNG5RT3J1S0tXdVZi?=
 =?utf-8?B?Q1RNZkZDdnRHcFF2TTlPOWQ4NjNjSUxBRHVQb0JlSERTd2FucFpQZG9heDlV?=
 =?utf-8?B?VTZ1VnkxUnBRKzAvNkJwN3dWa3pmRVlkU2tOK21lL2xzUnI5Qmx4NGxoSHB4?=
 =?utf-8?B?M0lsbVlPTE1CNVNLaCszQndUcEtJSEtCTFR3Um9Kck5NVXJuK0Y1ZlhxNFdr?=
 =?utf-8?B?TGF0RWNOYXdVMkx2WSszaGJmb1pCdGRsSE5TNnZJTWtXWHhQdkR6RTdtMHh1?=
 =?utf-8?B?Z1B0eGswWno4VnE5R3FCSHpQRGVSMVFmU3lLZ0pabXNRc1Q3SmErM1RzTy9i?=
 =?utf-8?B?UHVuTVh3R24raUVpNUIwSko1c0xGZnE5Z1p6VHEremNkS0JWeXhtOUgvR2Zu?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C3740E8DBB5D34999E9A793B760313F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f6192d-eb6a-44f5-f2f5-08da94caedfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 14:27:32.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+qd+D/3mliyafdDXnOg3p8eMPuBG47rDC9UJozS/Q6hEQXiJw/GcPh4r9sYI9b7PGud3as9qw5K9OSGnOlTOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7525
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYm90aCwNCg0KT24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMDQ6MTM6MDhQTSArMDIwMCwgTWFy
ayBLZXR0ZW5pcyB3cm90ZToNCj4gPiBEYXRlOiBNb24sIDEyIFNlcCAyMDIyIDE1OjAxOjA2ICsw
MTAwDQo+ID4gRnJvbTogIlJ1c3NlbGwgS2luZyAoT3JhY2xlKSIgPGxpbnV4QGFybWxpbnV4Lm9y
Zy51az4NCj4gPiANCj4gPiBPbiBNb24sIFNlcCAxMiwgMjAyMiBhdCAwMTowNDo1OFBNICswMTAw
LCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgd3JvdGU6DQo+ID4gPiBPbiBNb24sIFNlcCAxMiwgMjAy
MiBhdCAxMTo1OToxN0FNICswMDAwLCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4gPiA+ID4gT24g
TW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTI6NDFBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdyb3Rl
Og0KPiA+ID4gPiA+IEZyb206IEhlY3RvciBNYXJ0aW4gPG1hcmNhbkBtYXJjYW4uc3Q+DQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gVGhpcyBiaW5kaW5nIGlzIGN1cnJlbnRseSB1c2VkIGZvciBTRElP
IGRldmljZXMsIGJ1dCB0aGVzZSBjaGlwcyBhcmUNCj4gPiA+ID4gPiBhbHNvIHVzZWQgYXMgUENJ
ZSBkZXZpY2VzIG9uIERUIHBsYXRmb3JtcyBhbmQgbWF5IGJlIHJlcHJlc2VudGVkIGluIHRoZQ0K
PiA+ID4gPiA+IERULiBSZS11c2UgdGhlIGV4aXN0aW5nIGJpbmRpbmcgYW5kIGFkZCBjaGlwIGNv
bXBhdGlibGVzIHVzZWQgYnkgQXBwbGUNCj4gPiA+ID4gPiBUMiBhbmQgTTEgcGxhdGZvcm1zICh0
aGUgVDIgb25lcyBhcmUgbm90IGtub3duIHRvIGJlIHVzZWQgaW4gRFQNCj4gPiA+ID4gPiBwbGF0
Zm9ybXMsIGJ1dCB3ZSBtaWdodCBhcyB3ZWxsIGRvY3VtZW50IHRoZW0pLg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IFRoZW4sIGFkZCBwcm9wZXJ0aWVzIHJlcXVpcmVkIGZvciBmaXJtd2FyZSBzZWxl
Y3Rpb24gYW5kIGNhbGlicmF0aW9uIG9uDQo+ID4gPiA+ID4gTTEgbWFjaGluZXMuDQo+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gUmV2aWV3ZWQtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpA
bGluYXJvLm9yZz4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3IgTWFydGluIDxtYXJj
YW5AbWFyY2FuLnN0Pg0KPiA+ID4gPiA+IFJldmlld2VkLWJ5OiBNYXJrIEtldHRlbmlzIDxrZXR0
ZW5pc0BvcGVuYnNkLm9yZz4NCj4gPiA+ID4gPiBSZXZpZXdlZC1ieTogUm9iIEhlcnJpbmcgPHJv
YmhAa2VybmVsLm9yZz4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9y
YWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KPiA+ID4gPiA+IC0tLQ0KPiA+ID4g
PiA+ICAuLi4vbmV0L3dpcmVsZXNzL2JyY20sYmNtNDMyOS1mbWFjLnlhbWwgICAgICAgfCAzOSAr
KysrKysrKysrKysrKysrKy0tDQo+ID4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRp
b25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQg
YS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL2JyY20sYmNt
NDMyOS1mbWFjLnlhbWwgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dp
cmVsZXNzL2JyY20sYmNtNDMyOS1mbWFjLnlhbWwNCj4gPiA+ID4gPiBpbmRleCA1M2I0MTUzZDli
ZmMuLmZlYzFjYzliOWEwOCAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL2JyY20sYmNtNDMyOS1mbWFjLnlhbWwNCj4g
PiA+ID4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVs
ZXNzL2JyY20sYmNtNDMyOS1mbWFjLnlhbWwNCj4gPiA+ID4gPiBAQCAtNCw3ICs0LDcgQEANCj4g
PiA+ID4gPiAgJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9uZXQvd2lyZWxlc3Mv
YnJjbSxiY200MzI5LWZtYWMueWFtbA0KPiA+ID4gPiA+ICAkc2NoZW1hOiBodHRwOi8vZGV2aWNl
dHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbA0KPiA+ID4gPiA+ICANCj4gPiA+ID4gPiAt
dGl0bGU6IEJyb2FkY29tIEJDTTQzMjkgZmFtaWx5IGZ1bGxtYWMgd2lyZWxlc3MgU0RJTyBkZXZp
Y2VzDQo+ID4gPiA+ID4gK3RpdGxlOiBCcm9hZGNvbSBCQ000MzI5IGZhbWlseSBmdWxsbWFjIHdp
cmVsZXNzIFNESU8vUENJRSBkZXZpY2VzDQo+ID4gPiA+ID4gIA0KPiA+ID4gPiA+ICBtYWludGFp
bmVyczoNCj4gPiA+ID4gPiAgICAtIEFyZW5kIHZhbiBTcHJpZWwgPGFyZW5kQGJyb2FkY29tLmNv
bT4NCj4gPiA+ID4gPiBAQCAtNDEsMTEgKzQxLDE3IEBAIHRpdGxlOiBCcm9hZGNvbSBCQ000MzI5
IGZhbWlseSBmdWxsbWFjIHdpcmVsZXNzIFNESU8gZGV2aWNlcw0KPiA+ID4gPiA+ICAgICAgICAg
ICAgICAgIC0gY3lwcmVzcyxjeXc0MzczLWZtYWMNCj4gPiA+ID4gPiAgICAgICAgICAgICAgICAt
IGN5cHJlc3MsY3l3NDMwMTItZm1hYw0KPiA+ID4gPiA+ICAgICAgICAgICAgLSBjb25zdDogYnJj
bSxiY200MzI5LWZtYWMNCj4gPiA+ID4gPiAtICAgICAgLSBjb25zdDogYnJjbSxiY200MzI5LWZt
YWMNCj4gPiA+ID4gPiArICAgICAgLSBlbnVtOg0KPiA+ID4gPiA+ICsgICAgICAgICAgLSBicmNt
LGJjbTQzMjktZm1hYw0KPiA+ID4gPiA+ICsgICAgICAgICAgLSBwY2kxNGU0LDQzZGMgICMgQkNN
NDM1NQ0KPiA+ID4gPiA+ICsgICAgICAgICAgLSBwY2kxNGU0LDQ0NjQgICMgQkNNNDM2NA0KPiA+
ID4gPiA+ICsgICAgICAgICAgLSBwY2kxNGU0LDQ0ODggICMgQkNNNDM3Nw0KPiA+ID4gPiA+ICsg
ICAgICAgICAgLSBwY2kxNGU0LDQ0MjUgICMgQkNNNDM3OA0KPiA+ID4gPiA+ICsgICAgICAgICAg
LSBwY2kxNGU0LDQ0MzMgICMgQkNNNDM4Nw0KPiA+ID4gPiA+ICANCj4gPiA+ID4gPiAgICByZWc6
DQo+ID4gPiA+ID4gLSAgICBkZXNjcmlwdGlvbjogU0RJTyBmdW5jdGlvbiBudW1iZXIgZm9yIHRo
ZSBkZXZpY2UsIGZvciBtb3N0IGNhc2VzDQo+ID4gPiA+ID4gLSAgICAgIHRoaXMgd2lsbCBiZSAx
Lg0KPiA+ID4gPiA+ICsgICAgZGVzY3JpcHRpb246IFNESU8gZnVuY3Rpb24gbnVtYmVyIGZvciB0
aGUgZGV2aWNlIChmb3IgbW9zdCBjYXNlcw0KPiA+ID4gPiA+ICsgICAgICB0aGlzIHdpbGwgYmUg
MSkgb3IgUENJIGRldmljZSBpZGVudGlmaWVyLg0KPiA+ID4gPiA+ICANCj4gPiA+ID4gPiAgICBp
bnRlcnJ1cHRzOg0KPiA+ID4gPiA+ICAgICAgbWF4SXRlbXM6IDENCj4gPiA+ID4gPiBAQCAtODUs
NiArOTEsMzEgQEAgdGl0bGU6IEJyb2FkY29tIEJDTTQzMjkgZmFtaWx5IGZ1bGxtYWMgd2lyZWxl
c3MgU0RJTyBkZXZpY2VzDQo+ID4gPiA+ID4gICAgICAgIHRha2VzIHByZWNlZGVuY2UuDQo+ID4g
PiA+ID4gICAgICB0eXBlOiBib29sZWFuDQo+ID4gPiA+ID4gIA0KPiA+ID4gPiA+ICsgIGJyY20s
Y2FsLWJsb2I6DQo+ID4gPiA+ID4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZp
bml0aW9ucy91aW50OC1hcnJheQ0KPiA+ID4gPiA+ICsgICAgZGVzY3JpcHRpb246IEEgcGVyLWRl
dmljZSBjYWxpYnJhdGlvbiBibG9iIGZvciB0aGUgV2ktRmkgcmFkaW8uIFRoaXMNCj4gPiA+ID4g
PiArICAgICAgc2hvdWxkIGJlIGZpbGxlZCBpbiBieSB0aGUgYm9vdGxvYWRlciBmcm9tIHBsYXRm
b3JtIGNvbmZpZ3VyYXRpb24NCj4gPiA+ID4gPiArICAgICAgZGF0YSwgaWYgbmVjZXNzYXJ5LCBh
bmQgd2lsbCBiZSB1cGxvYWRlZCB0byB0aGUgZGV2aWNlIGlmIHByZXNlbnQuDQo+ID4gPiA+IA0K
PiA+ID4gPiBJcyB0aGlzIGEgbGVmdG92ZXIgZnJvbSBhIHByZXZpb3VzIHJldmlzaW9uIG9mIHRo
ZSBwYXRjaHNldD8gQmVjYXVzZSBhcw0KPiA+ID4gPiBmYXIgYXMgSSBjYW4gdGVsbCwgdGhlIENM
TSBibG9iIGlzIChzdGlsbCkgYmVpbmcgbG9hZGVkIHZpYSBmaXJtd2FyZSwNCj4gPiA+ID4gYW5k
IG5vIGFkZGl0aW9uYWwgcGFyc2luZyBoYXMgYmVlbiBhZGRlZCBmb3IgdGhpcyBwYXJ0aWN1bGFy
IE9GDQo+ID4gPiA+IHByb3BlcnR5LiBTaG91bGQgaXQgYmUgZHJvcHBlZD8NCj4gPiA+IA0KPiA+
ID4gSXQgZG9lcyBhcHBlYXIgdG8gYmUgdW5wYXJzZWQsIGJ1dCBJIGRvbid0IGtub3cgd2hldGhl
ciBpdCdzIG5lZWRlZCBmb3INCj4gPiA+IHRoZSBiaW5kaW5nIG9yIG5vdC4gSSdsbCB3YWl0IGZv
ciB0aGUgQXNhaGkgZm9sayB0byByZXZpZXcgeW91ciBjb21tZW50DQo+ID4gPiBiZWZvcmUgcG9z
c2libHkgcmVtb3ZpbmcgaXQuDQo+ID4gDQo+ID4gT2theSwgdGhlIGFuc3dlciBpcywgaXQgaXMg
c3RpbGwgdmVyeSBtdWNoIHBhcnQgb2YgdGhlIGJpbmRpbmcsIGFuZA0KPiA+IHRoZSBtMW4xIGJv
b3QgbG9hZGVyIHBvcHVsYXRlcyBpdC4NCj4gPiANCj4gPiBUaGlzIHNlcmllcyBpcyBhIHN1YnNl
dCBvZiBhIGxhcmdlciBzZXJpZXMgKHJlbWVtYmVyIHRoZSBwcmV2aW91cyAzNA0KPiA+IG9yIDM1
IHBhdGNoIHNlcmllcz8pLCBzbyB0aGVyZSBhcmUgdGhpbmdzIGluIHRoZSBiaW5kaW5nIGRvY3Vt
ZW50DQo+ID4gd2hpY2ggYXJlIG5vdCBpbmNsdWRlZCBpbiB0aGlzIHNlcmllcy4NCj4gPiANCj4g
PiBJIGRvbid0IHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGJyZWFrIHVwIHRoZSBiaW5kaW5nIGRv
Y3VtZW50IGdpdmVuDQo+ID4gdGhhdCBpdCBoYXMgYWxyZWFkeSBiZWVuIHJldmlld2VkIHNldmVy
YWwgdGltZXMgaW4gaXRzIGN1cnJlbnQgc3RhdGUsDQo+ID4gc2hvdWxkIHdlIHJlYWxseSByZW1v
dmUgdGhpcyBvbmUgcHJvcGVydHkgYW5kIHRocm93IGF3YXkgYWxsIHRoYXQNCj4gPiByZXZpZXcg
ZWZmb3J0Lg0KPiANCj4gVGhlIE9wZW5CU0QgZHJpdmVyIGFscmVhZHkgdXNlcyB0aGVzZSBwcm9w
ZXJ0aWVzLiAgU28gZXZlbiBpZiB0aGUNCj4gTGludXggZHJpdmVyIGRvZXNuJ3QgdXNlIHRoaXMg
eWV0LCB0aGVyZSBpcyBhbiBleGlzdGluZyBpbXBsZW1lbnRhdGlvbg0KPiB0aGF0IGRvZXMuICBU
aGF0IHNob3VsZCBiZSBnb29kIGVub3VnaCBmb3IgaXQgdG8gYmUgaW5jbHVkZWQgaW4gdGhlDQo+
IGJpbmRpbmcgaXNuJ3QgaXQ/DQoNClllcywgSSBzdXNwZWN0ZWQgdGhhdCBtaWdodCBiZSB0aGUg
Y2FzZSB0b28uIEkgdGhpbmsgaXQncyBmaW5lLg0KDQpUaGFua3MgUnVzc2VsIGZvciB0aGUgY2xh
cmlmaWNhdGlvbiBidHcuIEZlZWwgZnJlZSB0byBhZGQgbXkNCg0KUmV2aWV3ZWQtYnk6IEFsdmlu
IMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
