Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9443F52694D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383286AbiEMSbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382221AbiEMSbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:31:32 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2012.outbound.protection.outlook.com [40.92.103.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3BF3CA5E;
        Fri, 13 May 2022 11:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnIpn5ZGTG8DnDWZfC7T+Cc1XqVB8o5dzns0wGtMlrI1R9hKxVQJmovHCuC+lJ07kBOeHerUbfthDWTl3b5qbCzBrFnM8xkI8wp+qaZKilZihO9BMUIRAlmfT0OJ6duOvDqv+LRntoCLCIiYFGWd2kKBhQOppIpH/LTuf96THtouqCwf3F28uLPWp8hQOfoPqIZs9V9DFDawcq7bElnsd8YI13wdKcI59Nf7ZBS/2BMO7hViDXx0q0y6Ca2N30casVWAU6EpRmyFgumSoFuMoW//ZqKUgNojjJgvcji7g3DtOgK2YlshNinK5kM8fpipc/MGB/LEa5tOM+3tkxKF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDKTMSoRxRGhvP6sQa1O6AdMk+6c69lhrOX4wkBilY4=;
 b=Ewq5cQAo7vfO9Nzv51CRmsr/LInZHD+aCsJSEEY1xWfCKi8Z/symcDThfw/FlrSnn/DXUjxobUTUe2X2NlPNCnjwLPuQFowon9VyBsfDKTbJs6owNzzfgNz6MlZFSz50oGBiNeM+OV6ugCeMX+R8wHoY7z3RWYze0uNKV0yWh9qI6yHQvoOc2LSqYcqKYbVybbqlOz0KHzoNdv4P6enInXmUq804SmTA0KVJfz2Qu/6bDRvszVvSyIFwfDUW2buPJddeBbZgbr8YMVOevHortkeHJc25sYYj+4NMhYIS+pcGLrycVio0t2OYk8yv8QyKmKKkj6EjPXO0Omz+EKNARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDKTMSoRxRGhvP6sQa1O6AdMk+6c69lhrOX4wkBilY4=;
 b=IkaoOkvWXlMxauvgsRaq+28WjurUvwFWeqC6hUHg9Gmr6ZJ5mytIvoAOIY8djD4fTkcNaWii4wOtgUUinqevoOgSQV9HQ1O+wGdF6ZbysFME9SrLt5OWhhjupX5skf5sIc8uI0jaFWJ0ZTjAo8ldNnJNwTkdmFCBQ5v3cmLMFZLl6V6ZqK/4mKpw652KplFRjWnpRu8IGSMNtsVl8f8PUCDsuXPpnNRpdYkWx3cdiT8XRK02KpGMHcBWBgzxychwLvGJ/RaBBx6GaMU2rAEiR/DbiWKHgWd6O5P+qKlDbwzwvufGUdgwHWcSDG33JPhaV26rRBWqxia73lNCmWYpkw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB3843.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Fri, 13 May
 2022 18:31:19 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3d8a:448e:5dc6:510a]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3d8a:448e:5dc6:510a%8]) with mapi id 15.20.5250.017; Fri, 13 May 2022
 18:31:19 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v7] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v7] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYUOqhZ3rJVKiKIEGNviGnPrtC160dGVGAgAA0G4A=
Date:   Fri, 13 May 2022 18:31:18 +0000
Message-ID: <D6CDA21E-CC8F-4DA1-A5A4-8B706CA79182@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
 <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
 <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
 <06062b288d675dc060f33041e9b2009c151698e6.camel@linux.ibm.com>
In-Reply-To: <06062b288d675dc060f33041e9b2009c151698e6.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [w8iim0wr1kaoJ3FRLU993eVh63ZsXXfyBKAdP6Yjih/vaWLNdLQk6U/8RLPOJVbh]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dfdc68a-48b1-488e-318a-08da350ec59d
x-ms-traffictypediagnostic: BM1PR01MB3843:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wt8QJR5LeR5JdeS+YuNFYefQr4s+wdnDT/tqHpZVGQ3Y6v5tca9yyragV3wQMRzEzlavg9kSKV7Y+/Rxd9FQSmUIdSMpTQP+1XDaHuYeL3kf+W5hKYNVkIMQFiNU5sOYvVyJt8sGjwcNX6QZogFRVelpxmp2zFTKzXcX8Yx+Qf0FUN3r0sbjyBs+6HnTKfeKLT1Gh6I/X6K5ZpRZ7jspI2c9pZPtigfdoQtI3xUizA25ejyIjE407+Zw+Ygx/3Hk7B9pK47Vpcf1XdtV9UD7aFjtJZkVWnToqfu3bjFBhodZy79r+0o1UxkDBkSbEm+WyoxpBteEwqu0lhidbJ9DUkrPIdHIccK3tRhb7RE9DHndgeY7ElAgZxs+ZNFC7g2cJDU5yR36RUZ3JXbxY1T7Jfy97MFQjV8OdM7R5Rlizfa5p2/D0gdcuCSN24Efjhsr935xC2NhplX83VsL0BFNWX6mV21XTxjjBLLPk6QHUIIkCVuKFHbQBDe3bQCHnzyYMgusKzwpCEnC00whOpnxsKO9GbCZ36K2hMFoLxMq9p4DeAOYOkzr3fzeDlpjMBOHQFjVxtBInHXKtrqddvUPvOlLMRcGKyn5gwmrAf2kEwcwxs5YLAMsMp9VAIPNUH5Q
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1B6amhDTXZYQUZ4OXQrSXExTFRzUVQ2NjJaU2hwSDBneEZGcHdQc05tK2k4?=
 =?utf-8?B?dEdFTlZDelY4QnFhalYvVHk0YklBWHVRWnF1NEJvWGllWXhCRWxCWUMvZ1cy?=
 =?utf-8?B?NlEzNjhHRy9YcEsrWTFTdDhnbjAwblk3SGpJVW1oU2tIamorWVMwUHI1WUt6?=
 =?utf-8?B?RzVSK3NFYnFXY2tnMmNFTjdNcTFvZEZkblhVZ2FBanpGa2tsOTROa3lPbjJp?=
 =?utf-8?B?WVJVNkNpUFFLcjUyZHRTSVBoWFFoZzRnVThmSHJBTnFxTVc1SG54TE1qRzl6?=
 =?utf-8?B?QjVPamR3WUFpYUppOUFDS0hPZGdtNlo4UmlleFI1enk4WFZTOE5WQlZ2MHZr?=
 =?utf-8?B?MXNmbVBVRzhSbFBvK1E4TTBZWGloVll4dEJqN0orcFlwdFI5RmVGZjQ2Wjd4?=
 =?utf-8?B?NG8yYmtXWWN2NDJFUzArYjJDMTQ3V1RQTHc0Z2JwK1dqWFRZQzRzRlMvRVZX?=
 =?utf-8?B?QU5nL2FqUFVId2oxYlBoSHNkKzJiek9DUXloUE9hWTlabkxjZVZDWHlaS21L?=
 =?utf-8?B?N1YxZXRzZkRhY2JLVnlSakxnMEhTZ0RqVHhIcjVUMVVoL2NBbS84N2NaRzdk?=
 =?utf-8?B?eENpVHBTUVFqakxVZkVQcUw0alRSbGQ0YTRLbnhYdXE2YXdYaDFBQlFJamdH?=
 =?utf-8?B?Tk1JYnRtbStMUlNDR1VDQUZkVmZNVjFoMTJQYy9XYmNYcjlRbVgzY3JMQml1?=
 =?utf-8?B?WWE4eTdIQ1FmVkxma215QWhjRkhzQUJ6YTNQaElDZ01sOGtYdk94a25WN1ZJ?=
 =?utf-8?B?ZXdyNnBvVDI3TEJCOVNjQ0RWWENFbkdLTTczdGhCNVJqbjJlLzk0aThLK1VI?=
 =?utf-8?B?NWtQdmMrU0NPeUF2dGExQzhSSWVZbWVvZFZyV3pNWlZaSks5elM3QWkzek1v?=
 =?utf-8?B?Q2ZSRUc3LzR0bG93UjMvWlIyYm9Zb3ZQVlh0ZGpvWXpIdlJDRFpWSFhuQ2pD?=
 =?utf-8?B?U0NCRGRyeGM0eFI2T1U2MUNKZ3QvbUZEY1JWMlJrcGdQMkhadlhYbWdRdE9M?=
 =?utf-8?B?QXNEWUNSWnp5Y0F0RWFQNktXOUg0NTFYSkdZMm5nQ1pZM3Npa0ZMb2tYQkZD?=
 =?utf-8?B?Qzl5UGYyZVd0a2o1dXJjeEQ2ejhqMnNrNk8vTmVjV1QyUDBuRzU3MUpwaUxZ?=
 =?utf-8?B?QWNYVU9OOFAwU2VzaFVoOGZVaHl5MGVQMG0zQVJCSUd5SFRhMHB4ZWZONUR1?=
 =?utf-8?B?NnI4WmtoMEVnc0paRTBiUXc1WGpXYjRaY2hXMGRtTFRzUUppN2VvQWNDVnlY?=
 =?utf-8?B?eFJJUTI3ekpMa29IaXV5SCtLSVVXcTRXSGdMNlJpT1k5VVJwc3U0R3RnNHJY?=
 =?utf-8?B?YlVVTU9nS0xma1JKT0xlTEhtZHpLZC9UVVFEdnNKcGYrU21rZjJXa0VOR2VR?=
 =?utf-8?B?ay9kbTBuK0l3b1JtcGVBRmFJaGl1anNlNkRESDA5NmdjSWhhV1A1dm5oUEdU?=
 =?utf-8?B?QUczR29KbDdSUWU0T2xyS0NQckNKbVBqNU9GYXJxK2Z2bVlqbW1UUFNnTU1q?=
 =?utf-8?B?NC9GWS9mR1ZzWDRhUnlLN2RVZmY5RVoxS0J5akYxWGhFNUYyUG5FMGhrWGIy?=
 =?utf-8?B?OE9ENklUNzNwdXdrNm5RSFNlWUxsczloUnQzcHRKMEg4QUJQYU9XcjJDWFBh?=
 =?utf-8?B?RGJoQ0lFdGlyNHBSR0NveXpiblE2M254Tk4zaDJXemFDQUhUaDJ2bVZibU9w?=
 =?utf-8?B?RXZXc2lHTzcrQzdrdUgvbFE5eHMzRDdqRk10NGdtS3V6Z3ljclIxNEI4T3I3?=
 =?utf-8?B?ZWR0Y1RCblRFZGNIVzNVUnRYKzdyNGwzQjNsdW9TS1g5UCtpSFV3anVvc2Y2?=
 =?utf-8?B?TnFpdFQzbHQ2Tmg4MkI2VjZmQWM3MXc4QW9JVlk0dXp5YW5CK3E1MFAyMkRQ?=
 =?utf-8?B?d0FUYW5tdVlOVUgrOGFSVGlNWkdGYTlsRHZzem5NSU5SaW5EOHN4Z2V4OUo1?=
 =?utf-8?B?aCtwZkdQbTlreGx1Mk1QYU5ORmc1WFNWekZSZmhxZmdEWVZ2UDh1aVBPSkty?=
 =?utf-8?Q?2YeIQ6S6twnaNOH4BG3wYNlI0DXt9c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1D4D3F880FA3B48B47E76D7982AA010@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfdc68a-48b1-488e-318a-08da350ec59d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 18:31:18.7261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB3843
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEFyZSB0aGVyZSBkaXJlY3Rpb25zIGZvciBpbnN0YWxsaW5nIExpbnV4IG9uIGEgTWFjIHdp
dGggQXBwbGUgZmlybXdhcmUNCj4gY29kZT8gIA0KDQpXZWxsLCBkaXJlY3Rpb25zIG9mIGluc3Rh
bGxpbmcgTGludXggb24gYW4gSW50ZWwgYmFzZWQgTWFjLCB3aGljaCBpbmNsdWRlcyB0aGUgVDIg
TWFjcyBpcyB0aGUgc2FtZSBhcyBvbiBhIG5vcm1hbCBQQy4NCg0KVGhvdWdoLCBpbiBjYXNlIG9m
IFQyIE1hY3MsIHdlIGZvciBub3cgbmVlZCB0byB1c2UgY3VzdG9taXNlZCBJU09zLCBzaW5jZSBz
b21lIGRyaXZlcnMgYW5kIHBhdGNoZXMgdG8gc3VwcG9ydCBUMiBNYWNzIGFyZSB5ZXQgdG8gYmUg
dXBzdHJlYW1lZC4NCg0KQW4gZXhhbXBsZSBvZiBpbnN0YWxsaW5nIFVidW50dSBjYW4gYmUgcmVh
ZCBoZXJlIG9uIGh0dHBzOi8vd2lraS50MmxpbnV4Lm9yZy9kaXN0cmlidXRpb25zL3VidW50dS9p
bnN0YWxsYXRpb24vDQoNClRhbGtpbmcgYWJvdXQgdGhlIG9mZmljaWFsIElTT3MsIGZvciBtYW55
IGRpc3Ryb3MsIHNpbmNlIENPTkZJR19MT0FEX1VFRklfS0VZUyBpcyBub3QgZW5hYmxlZCBpbiB0
aGVpciBrZXJuZWwgY29uZmlnLCB3ZSBjYW4gaW5zdGFsbCBMaW51eCB1c2luZyB0aGVtLCBidXQg
dGhleSBzdGlsbCBsYWNrIG1hbnkgZHJpdmVycyByZXF1aXJlZCwgc2luY2UgdGhleSBhcmUgeWV0
IHRvIGJlIHVwc3RyZWFtZWQuIFNvIHRoZSBpbnN0YWxsYXRpb24gZG9lc27igJl0IHdvcmsgZWZm
aWNpZW50bHkgYW5kIHdlIGhhdmUgdG8gbWFudWFsbHkgaW5zdGFsbCBjdXN0b20ga2VybmVscyBo
YXZpbmcgdGhvc2UgcGF0Y2hlcy4NCg0KSW4gc29tZSBkaXN0cm9zIGxpa2UgVWJ1bnR1LCB0aGV5
IGhhdmUgQ09ORklHX0xPQURfVUVGSV9LRVlTIGVuYWJsZWQgaW4gdGhlaXIga2VybmVsIGNvbmZp
Zy4gSW4gdGhpcyBjYXNlIHRoZSBjcmFzaCBhcyBtZW50aW9uZWQgaW4gdGhlIHBhdGNoIGRlc2Ny
aXB0aW9uIG9jY3VycyBhbmQgRUZJIFJ1bnRpbWUgU2VydmljZXMgZ2V0IGRpc2FibGVkLiBTaW5j
ZSBpbnN0YWxsaW5nIEdSVUIgcmVxdWlyZXMgYWNjZXNzIHRvIE5WUkFNLCB0aGUgaW5zdGFsbGF0
aW9uIGZhaWxzIHdpdGggb2ZmaWNpYWwgSVNPcyBpbiB0aGlzIGNhc2UuIFRodXMsIGEgY3VzdG9t
IElTTywgd2l0aCB0aGlzIHBhdGNoIGluY29ycG9yYXRlZCBpbiBiZWluZyB1c2VkIGZvciBub3cg
Zm9yIHVzZXJzIGludGVyZXN0ZWQgaW4gVWJ1bnR1IG9uIFQyIE1hY3MuDQoNCj4gQXJlIHlvdSBk
dWFsIGJvb3RpbmcgTGludXggYW5kIE1hYywgb3IganVzdCBMaW51eD8NCg0KSSBkb27igJl0IHRo
aW5rIGl0IGFjdHVhbGx5IG1hdHRlcnMsIHRob3VnaCBpbiBtb3N0IG9mIHRoZSBjYXNlcywgd2Ug
ZHVhbCBib290IG1hY09TIGFuZCBMaW51eCwgYnV0IEkgZG8gaGF2ZSBzZWVuIGNhc2VzIHdobyB3
aXBlIG91dCB0aGVpciBtYWNPUyBjb21wbGV0ZWx5LiBCdXQgdGhpcyBkb2Vzbid0IGFmZmVjdCB0
aGUgU2VjdXJlIEJvb3QgcG9saWN5IG9mIHRoZXNlIG1hY2hpbmVzLg0KDQo+ICBXaGlsZSBpbg0K
PiBzZWN1cmUgYm9vdCBtb2RlLCB3aXRob3V0IGJlaW5nIGFibGUgdG8gcmVhZCB0aGUga2V5cyB0
byB2ZXJpZnkgdGhlDQo+IGtlcm5lbCBpbWFnZSBzaWduYXR1cmUsIHRoZSBzaWduYXR1cmUgdmVy
aWZpY2F0aW9uIHNob3VsZCBmYWlsLg0KDQpJZiBJIGVuYWJsZSBzZWN1cmUgYm9vdCBpbiB0aGUg
QklPUyBzZXR0aW5ncyAobWFjT1MgUmVjb3ZlcnkpLCBBcHBsZeKAmXMgZmlybXdhcmUgd29uJ3Qg
YWxsb3cgZXZlbiB0aGUgYm9vdCBsb2FkZXIgbGlrZSBHUlVCLCByRUZJbmQgdG8gYm9vdC4gSXQg
c2hhbGwgb25seSBhbGxvdyBXaW5kb3dzIGFuZCBtYWNPUyB0byBCb290LiBZb3UgY291bGQgc2Vl
IGh0dHBzOi8vc3VwcG9ydC5hcHBsZS5jb20vZW4taW4vSFQyMDgxOTggZm9yIG1vcmUgZGV0YWls
cy4NCg0KPiANCj4gSGFzIGFueW9uZSBlbHNlIHRlc3RlZCB0aGlzIHBhdGNoPw0KDQpJIHdvcmsg
YXMgYSBtYWludGFpbmVyIGZvciBVYnVudHUgZm9yIFQyIExpbnV4IGNvbW11bml0eSBhbmQgSSBo
YXZlIHRoaXMgcGF0Y2ggaW5jb3Jwb3JhdGVkIGluIHRoZSBrZXJuZWxzIHVzZWQgZm9yIFVidW50
dSBJU09zIGN1c3RvbWlzZWQgZm9yIFQyIE1hY3MsIGFuZCB0aHVzIGhhdmUgbWFueSB1c2VycyB3
aG8gaGF2ZSB1c2VkIHRoZSBJU08gYW5kIGhhdmUgYSBzdWNjZXNzZnVsIGluc3RhbGxhdGlvbi4g
VGh1cywgdGhlcmUgYXJlIG1hbnkgdXNlcnMgd2hvIGhhdmUgdGVzdGVkIHRoaXMgcGF0Y2ggYW5k
IGFyZSBhY3R1YWxseSB1c2luZyBpdCByaWdodCBub3cuDQpXZSBhbHNvIG5lZWQgdGhlIGhhdmUg
dGhlIE5WUkFNIHdyaXRlcyBlbmFibGVkIHNvIGFzIHRvIHVubG9jayB0aGUgaUdQVSBpbiBNYWNz
IHdpdGggYm90aCBJbnRlbCBhbmQgQU1EIEdQVSwgYW5kIHdpdGggdGhpcyBwYXRjaCwgd2UgaGF2
ZSBiZWVuIHN1Y2Nlc3NmdWxseSBhYmxlIHRvIHVubG9jayBpdCwNCg0KSSBob3BlIEkgY291bGQg
YW5zd2VyIHlvdXIgcXVlc3Rpb25zDQoNClJlZ2FyZHMNCkFkaXR5YQ==
