Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BAE51D71E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 13:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391548AbiEFL7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 07:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391544AbiEFL7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 07:59:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E3D3CA68;
        Fri,  6 May 2022 04:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7kLs1JpjxCUEgEMG6CoLQ67xOR4ifds39wl/k/kzdNuVkqkO66/ZQSShrmUZwX1WjJpV+XerNkgX28aMvCalMYnNCOSUHOMzfqUUbLDh2a55jNJ/QPp0gbOqUCfzHa5+REEwaJzf7sYZwITXd42Y2OhqBmFE193o+PXyIe1ZkPMpPYa1zHlSYBAa9mQOfihGbnT/raWJEb8XeygHYgB/AeT66nxM6U2CPNh2eFUl+rBCrkrc3hsr7BiyUAtGvJk+WpZGWjkxCkr1nsRdPuiAGGm0L9KzVt2DiWxTn+3W6BkJVa1Ibq/FMAOcYGCx/W7jQhifdt2b7V9hUfNlnZp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldBs1arR2FKkCahwTm9+Jk90hTG0XyqSLJLTuR41iBA=;
 b=AuwmiFHNX81Y6hfvU117o3YkSZbYlNP5KuMWhzaxTmcZ7WUt0bjGEP+Ex5QHh9465zYPR0TltePAbf4TIwgv3OXoR1/N/tLKTJcjTIFj3NryVVAtG0vCw0U4EtetZjWdnX9c0HvWJM24U0GLlAIwahWwm5Vq2D99b00OJot59ocAnrTq6Ot95OndqQG87vH67jr1LXgxzPY0JWTAc3jQw/CdZzorw3J+A7AWKOm6EbsTvcnBh/aF4fFWU6NyJF3BICt9hJvRVSfTF5CtxmdLB6zWhHbA/lcHNSTxP2nqaPlLDB1ELmlRRGArlXfKY73fxmaWmz08FkTnMZjRRCvR4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldBs1arR2FKkCahwTm9+Jk90hTG0XyqSLJLTuR41iBA=;
 b=VhvO6qBVLZSmnU/n3lCfMacJ5E3p51IJzlPyAeMT8uoNtaSeR+c+Wp5K1SIlslWTOSuXMvp7Ylnv3+MyubJ9bADm5Elk+SQRlalkEgceccgqlX2ZGKEHZ6cxHnJMfaPn1HGeQWfLSZvgTrLGLtVl2Qig449DZoDW7RZtgOZx7LA=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM6PR07MB4773.eurprd07.prod.outlook.com (2603:10a6:20b:17::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Fri, 6 May
 2022 11:55:57 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25%7]) with mapi id 15.20.5206.025; Fri, 6 May 2022
 11:55:56 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Topic: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Index: AQHYYUA+MyZSZmZ//k6UWoc3zy9sXA==
Date:   Fri, 6 May 2022 11:55:56 +0000
Message-ID: <df67ceaa-4240-d084-7ba1-d703f0c38f33@ericsson.com>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19b5adae-e24b-4ac2-6037-08da2f57615d
x-ms-traffictypediagnostic: AM6PR07MB4773:EE_
x-microsoft-antispam-prvs: <AM6PR07MB47737F0B4C0D27309E04DC7DE1C59@AM6PR07MB4773.eurprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eXq1oWe3lkpKku5/EMCHJYBJ9wtfQXRhBsGEtFTCJsIgPPFQ89fMsDfoGEL8Ej7yId8rlA5t8QWQQPfiNkFdTK9rhLJ87IQ0J9KQj1RIETVgGuCWNjP8cF2PI6SvJfbag9Kx99PS0xFM/wjcTeeGCx+YBYgd3f8yfvtSpQ8fwWhCCRObisLc1i/PBrR503FX4lg+KzqS/mJwSyenz5zeXue6NLi1iCQTe1DXYmETmxuW2hHaL6XLZI9LYwUCZmE4YnL20fziaKgCyOrV/tV9a0pRYHPKVC5cINjOyE0iFcm8rMhwBNb/8v12KmsWYx1W1PNZ4QwNrQKzIG5SmGEJAmk+Q0X/0QHPJNWxjiFqUR1IN/XFccr2wnDukKqDotKP+ToVge0Vc7lCMcePzHhe6iB3zvUqWc63/e3v+FJKgFU1O0vQ7CLEFcR61Vl741Nfb4wX46Fi0kSMIbHR3K0+jDGv5ZbEI+oRdXQTmqALnm68gixFL4S6qx4aIqjjCXLfUnt+ovOacYKWbuxOo6nTptOVGqS96vprFM4W2g2TklOfJDSpaC2d+eDOjIJ9pOiItU85yGSPE3nq3CZydJ8ee5QGd1ByHLTwJgj5bJJf38rFhzC3hftF/d1EFRYp85ywqm5tMp4neoZcdAHY3+5Bmv1HISRO8PM9LDQiYTL1CQHziqpiCgOHmndpvaEelLO9fH/qZ26mAQyx87JW2Bi7fMMBISd1omgFQph19XPdIB0C/DXxqb0JY74lPz0yU/HXqtTFbyaWaAZ7Pz3FRbvOUW5g9pMzQWIjQJ4caUmysVuwRfPI0owGrhSN7MfxAj+OQl3ZsZsqJa/otGBXWRHUuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(71200400001)(4326008)(8676002)(83380400001)(66476007)(66556008)(66946007)(91956017)(76116006)(44832011)(7416002)(64756008)(66446008)(2616005)(5660300002)(86362001)(2906002)(6486002)(6512007)(8936002)(186003)(38100700002)(31686004)(38070700005)(36756003)(508600001)(31696002)(110136005)(54906003)(122000001)(316002)(82960400001)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWNhaFYxR3BCT0xBb0RXVUZtbEtVYkhSMk1YcjBESWsxYlNmOFNNSnhqL1ZS?=
 =?utf-8?B?Z290Tk8yZkRuQjJmd0VQRytXQnVzbU8wVEZwUmg4ZTRkdkJvUU5kVmVMZ0Q4?=
 =?utf-8?B?cWJ4YWNwckZ5eVVobk41T1puQWJFWFFoZ3RLKzhuaFl6KzFOWHpJMXFhODBs?=
 =?utf-8?B?bmNVSktaRys4VVNIZnp6bkpsUmNqa0EwZURlTFlJMytiQ2ZRVzY2b3JrZFZR?=
 =?utf-8?B?aUd5QllydkM4bStISk5IYWZJdjdDNnVNcWZGWTVaQUs3YXJLei9UM2NXeGYw?=
 =?utf-8?B?SFBIMlZvYUdBL2N6U3JaVzk2cmJpZU5PeUdodjFpNFBrSmZEVzRzWUtEbGE2?=
 =?utf-8?B?Ky9xeERPOGpmZVBmY0dvU25IaVc2ckFFQXFaVmdPbmZUN1FvYXl6bEFmb1A4?=
 =?utf-8?B?WVloemZHUTN2ZTRrY0dmd1drQ3h5K0EyZUdqd2czWWl4enZNeXRrQlRLVzVF?=
 =?utf-8?B?a2pmNTVwT1dWZUY4MGNMbjZwb0pSSlZHQlpoUGpoelVnSkNPaE52ZkgrcXdp?=
 =?utf-8?B?VCtyYldKYnlJQU9BWGNsa1puYWt4OGFwaFhJS2RXeE5tU1V3YlZnNE15NlpB?=
 =?utf-8?B?YitZd3VKSXNObGdaY1g2dE5rTTZwdlZEdmduRVNpSVFCbE9WOE5wRFd0VWh1?=
 =?utf-8?B?Z3BSNmZ4Wk9xQmk5WXVTS0t1dWxma3BRODZhckNZd21WT3BBWFhMOTA4TTFr?=
 =?utf-8?B?VHM4QmhTMjhkYjd5VktZOHUvRXQzVjFOWk9LSERROElQdENYc1ZOSk1xTzV6?=
 =?utf-8?B?S3l2Z2d3akJRYnJ4SGRHYTYvUjlUZ3NpZ2hVc01zM1plT1FrYisrV0FrSEJk?=
 =?utf-8?B?THhyVFNzR0xOcG4wUUpPSHBEZjFRNGczRXJFRldtS3dRcEFmNDZxb0FQV2Yv?=
 =?utf-8?B?amVFSFoyU1h3dWFKOW9NMEdKU3VKbFBwU1lVS1F4TEc0cmg1OXBjZm52enBz?=
 =?utf-8?B?Tk5xWlpYaENtU2xScWxVbncwaGN1Q1M1QUFmNFpyTms3dytNYkwvZmd3NU1l?=
 =?utf-8?B?ZG92UGo4WUU3N1B4U0NBdVl3cXhGdFNrVkkvTkJGdUIwZWxmM041Z0JlMW91?=
 =?utf-8?B?Y2k3US8zdFdlKzZpQnVQeUFZRjZnZm0yeS9KUXVOUGxuWGhKUGZjNG9OZnhr?=
 =?utf-8?B?dE5wQzB1L3V3S0RlaC9hV1VWVkYyZUg4cC9vR1JJQm9HcUx4TnF6SDhNSmdV?=
 =?utf-8?B?WXArS1FoUTVvdjA2VHV5L3FEeWxoN3hWbW1FZmFIL0t5RmlHOHU0RmNkSWJJ?=
 =?utf-8?B?VDAvRDZWOVllVThuRGpERUJ2UW1yMEhSdFRDRkF3S2RINytReTR2RTM1Z1ZJ?=
 =?utf-8?B?RkJYY2p4cjh2ekVZUU41d2JNc1pWdUg4MU5KeXVvUHdnQkJVWGZQSjRqSmYz?=
 =?utf-8?B?LzNkM0NZaG5EUm8xaDlpUUpoSTBYUEdrblBHaVZpS05IaEdpQ2c4YllMYVJM?=
 =?utf-8?B?RHJFM2h3TEhWZVM5SVRWNXBXZy9qY2xDekZyK2k3NEYvQVhBaE9FYVAzaDQ0?=
 =?utf-8?B?bXFqRjVnYWFzbml2dDRKVWttc3F1T1BmL0hJL1FUekVHdmNIYXhuYmdxajVY?=
 =?utf-8?B?NVN2bGR0UDJ0ZXVpcDZpbEZrTFp6NmFOWmhnR3kyaTVZOG9maG5pOEVzZzJC?=
 =?utf-8?B?a2FranNOcWJhWW9hbHZlYVhjQWYyclVBWnRyOUN2ZmFIbzg2dWhvVVZPZVpE?=
 =?utf-8?B?M1F3TjlEQURQTmxFaElqcHVPWWR6blBlamREV1V2bHF0b0pxMVdkQXRydGtE?=
 =?utf-8?B?Y1Nobjdyclh0SjBIZGx0ZWFTVXpHU3R0eVJkZEUxZHZEdVhzZTVHMy9aUjFE?=
 =?utf-8?B?dFNEWFFIM2pUcWxHTXptWUxOb0g1ZjBhU1NZYVlvc2dCREtxNzdBVDNJdkx6?=
 =?utf-8?B?NEZqMVVwTnVVUmxnYVRVYlVudXJaeXNFall0dEpucjhCNUJZSm5VT3ppc0VU?=
 =?utf-8?B?cFJzQ1BiM0xsVFlEc1IyL3Y0MlBuZFI4N2ZEYWtzVXNOZjhSUDcwRXJSWXRG?=
 =?utf-8?B?Q1c4eFUxOFVOL1VTelN1WnZZS0J4WjY5c3hkeVZSdnRHMDAydEpNMmVrU01X?=
 =?utf-8?B?L01kTUdMbUdNUnhaQlMrSlI0Q251cGZLUnhyM1U1WGxrUXBuV0dUM2lSZFpL?=
 =?utf-8?B?MFhxWlpCYjdFOTV0SUFrM21RVXgxRUd1SUZzVHZTY0VYZUlMZnlKWXV2ZlVZ?=
 =?utf-8?B?ZnNmc2ExaDdCZ0g0SmVpbCtNWkVtNGR3bGR5OFJESExlVFRJWkUzUzBybEFB?=
 =?utf-8?B?MXBOeHEvYmloejJLRGVzTmIya0QrMHhNREo5d2g4RURKZU9hWHlENXpnQjBR?=
 =?utf-8?B?MTBHdkkrOWJUdmQwbmJpdWI0RHpPNGlSNWNhekJseG9lUmlGWUFVbWVSYktB?=
 =?utf-8?Q?IR30/R8IkH8Lf4SQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C899776F8000474B92CF0A7E29BE9713@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b5adae-e24b-4ac2-6037-08da2f57615d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 11:55:56.8047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +i/noe84U2FZPXk5Kbq/A8cqFs4Px8UCvxPgupNcwCiV2S+gbq/C6Sg0G5AHXjfIz1j69ESarq9GTNv+Z0Zmcj9XHz3lmAaDyiSURrdshdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB4773
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMS4gMDkuIDI4LiAxMzo0NCwgWGlhb2xpYW5nIFlhbmcgd3JvdGU6DQo+IFRoaXMgcGF0
Y2ggaW50cm9kdWNlIGEgZnJlciBhY3Rpb24gdG8gaW1wbGVtZW50IGZyYW1lIHJlcGxpY2F0aW9u
IGFuZA0KPiBlbGltaW5hdGlvbiBmb3IgcmVsaWFiaWxpdHksIHdoaWNoIGlzIGRlZmluZWQgaW4g
SUVFRSBQODAyLjFDQi4NCg0KSGlYaWFvbGlhbmchDQoNCnRoYW5rcyBmb3IgeW91ciBlZmZvcnRz
IHRvIGludHJvZHVjZSBhZnJlcmFjdGlvbiB0byBpbXBsZW1lbnQgZnJhbWUgDQpyZXBsaWNhdGlv
biBhbmQgZWxpbWluYXRpb24gZm9yIHJlbGlhYmlsaXR5LCB3aGljaCBpcyBkZWZpbmVkIGluIElF
RUUgDQpQODAyLjFDQi0yMDE3LiBJIHdvdWxkIGxpa2UgdG8gcmVsYXkgYSBzbWFsbCBjb21tZW50
IGZyb20gb3VyIHRlYW0sIA0KcmVnYXJkaW5nIHRvIHRoZSBGUkVSLCBub3QgcGFydGljdWxhcmx5
IHRvIHRoZSBjb2RlLg0KDQpTdXBwb3J0IG9mIFJUQUcgZm9ybWF0IGlzIHZlcnkgc3RyYWlnaHRm
b3J3YXJkLg0KDQpTaW5jZSAyMDE3LCBzZXZlcmFsIG1haW50ZW5hbmNlIGl0ZW1zIHdlcmUgb3Bl
bmVkIHJlZ2FyZGluZyBJRUVFIA0KUDgwMi4xQ0ItMjAxNyB0byBmaXggc29tZSBlcnJvcnMgaW4g
dGhlIHN0YW5kYXJkLiBEaXNjdXNzaW9ucyByZXN1bHRzIA0Kd2lsbCBiZSBwdWJsaXNoZWQgc29v
biBlLmcuLCBpbiBJRUVFIFA4MDIuMUNCZGIgDQooaHR0cHM6Ly8xLmllZWU4MDIub3JnL3Rzbi84
MDItMWNiZGIvKS4NCg0KT25lIG9mIHRoZSBtYWludGVuYW5jZSBpdGVtcyBpbXBhY3RzIHRoZSB2
ZWN0b3IgcmVjb3ZlcnkgYWxnb3JpdGhtIGl0c2VsZi4NCg0KRGV0YWlscyBvbiB0aGUgcHJvYmxl
bSBhbmQgdGhlIHNvbHV0aW9uIGFyZSBoZXJlOg0KDQotaHR0cHM6Ly93d3cuODAyLTEub3JnL2l0
ZW1zLzM3MA0KDQotaHR0cHM6Ly93d3cuaWVlZTgwMi5vcmcvMS9maWxlcy9wdWJsaWMvZG9jczIw
MjAvbWFpbnQtdmFyZ2EtMjU3LUZSRVItcmVjb3Zlcnktd2luZG93LTAzMjAtdjAxLnBkZiANCjxo
dHRwczovL3d3dy5pZWVlODAyLm9yZy8xL2ZpbGVzL3B1YmxpYy9kb2NzMjAyMC9tYWludC12YXJn
YS0yNTctRlJFUi1yZWNvdmVyeS13aW5kb3ctMDMyMC12MDEucGRmPg0KDQpJdCBpcyBhIHNtYWxs
IGJ1dCBpbXBvcnRhbnQgZml4LiBUaGVyZSBpcyBhbiBpbmNvcnJlY3QgcmVmZXJlbmNlIHRvIHRo
ZSANCnNpemUgb2YgdGhlIHJlY292ZXJ5IHdpbmRvdywgd2hlbiBhIHJlY2VpdmVkIHBhY2tldCBp
cyBjaGVja2VkIHRvIGJlIA0Kb3V0LW9mLXJhbmdlIG9yIG5vdC4gV2l0aG91dCB0aGlzIGZpeCB0
aGUgdmVjdG9yIHJlY292ZXJ5IGFsZ29yaXRobSBkbyANCm5vdCB3b3JrIHByb3Blcmx5IGluIHNv
bWUgc2NlbmFyaW9zLg0KDQpQbGVhc2UgY29uc2lkZXIgdG8gdXBkYXRlIHlvdXIgcGF0Y2ggdG8g
cmVmbGVjdCB0aGUgbWFpbnRlbmFuY2UgZWZmb3J0cyANCm9mIElFRUUgdG8gY29ycmVjdCAuMUNC
LTIwMTcgcmVsYXRlZCBpc3N1ZXMuDQoNCj4gVGhlcmUgYXJlIHR3byBtb2RlcyBmb3IgZnJlciBh
Y3Rpb246IGdlbmVyYXRlIGFuZCBwdXNoIHRoZSB0YWcsIHJlY292ZXINCj4gYW5kIHBvcCB0aGUg
dGFnLiBmcmVyIHRhZyBoYXMgdGhyZWUgdHlwZXM6IFJUQUcsIEhTUiwgYW5kIFBSUC4gVGhpcw0K
PiBwYXRjaCBvbmx5IHN1cHBvcnRzIFJUQUcgbm93Lg0KPg0KPiBVc2VyIGNhbiBwdXNoIHRoZSB0
YWcgb24gZWdyZXNzIHBvcnQgb2YgdGhlIHRhbGtlciBkZXZpY2UsIHJlY292ZXIgYW5kDQo+IHBv
cCB0aGUgdGFnIG9uIGluZ3Jlc3MgcG9ydCBvZiB0aGUgbGlzdGVuZXIgZGV2aWNlLiBXaGVuIGl0
J3MgYSByZWxheQ0KPiBzeXN0ZW0sIHB1c2ggdGhlIHRhZyBvbiBpbmdyZXNzIHBvcnQsIG9yIHNl
dCBpbmRpdmlkdWFsIHJlY292ZXIgb24NCj4gaW5ncmVzcyBwb3J0LiBTZXQgdGhlIHNlcXVlbmNl
IHJlY292ZXIgb24gZWdyZXNzIHBvcnQuDQo+DQo+IFVzZSBhY3Rpb24gIm1pcnJlZCIgdG8gZG8g
c3BsaXQgZnVuY3Rpb24sIGFuZCB1c2UgInZsYW4tbW9kaWZ5IiB0byBkbw0KPiBhY3RpdmUgc3Ry
ZWFtIGlkZW50aWZpY2F0aW9uIGZ1bmN0aW9uIG9uIHJlbGF5IHN5c3RlbS4NCj4NCkFsbCBvZiBv
dXIgcmVzZWFyY2ggaW4gdGhlIHRvcGljIGJhc2VkIG9uIGEgaW4taG91c2UgdXNlcnNwYWNlIEZS
RVIgDQppbXBsZW1lbnRhdGlvbiBidXQgd2UgYXJlIGxvb2tpbmcgZm9yd2FyZCB0byB0ZXN0IHlv
dXIgd29yayBpbiB0aGUgZnV0dXJlLg0KDQpUaGFua3MsDQoNCkZlcmVuYw0K
