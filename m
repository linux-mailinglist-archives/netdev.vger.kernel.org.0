Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687D931F2BF
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBRXEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:04:49 -0500
Received: from mail-eopbgr1400093.outbound.protection.outlook.com ([40.107.140.93]:5260
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhBRXEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:04:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYDH1o/Mf1guP3fd6VhhILjrP08jKiwflsoisHhHfG/4Op+l6eaxrKyIvRZ+om6i0UUcbpqIJDF59AdpbzIxsvQtK47I+keYkoinrI8DgpT4m7cu1BwJphcL5g0nApFs6Ozmy98d7kCwOrNCzHPWh7VbyglnD0kRbbL1KWd9PBGagwOPG2rsTGt8QRPr9t2tm1EqPsox32HyV9Qqd38Rs9hMGv4UaII1i3/Ta7X4AfxozWgb9cvJKNEZNzm/NLKynapSufu6TAYW3x3sfGm9b6v4Q4qWa0VJxOqjRzfYC2VTz85tMemIafQWWHNi2JJYup3uoZt45DAmqvxnEqao4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=791Xww3wY0uFuuFC8nGm1uQo7GRg9a1Z1YPTT505vow=;
 b=U4QC2BWhipDKkPDKeJB9sk0V+IkSf+tk7CQmjDWP16wTYVVFt4CYwQehIJKnBz0pyliVBfuR2wi+2w3N5FJgx8t4am7WOCZF7HSmZ2OENL644F7usNh2EA1+6Zq6ci3fs/a4fSn/4+0G2OgzuN23uAzWwy9ZhtM1d8RmxJJzMFniFUPzEpHKHF9rlsVoEEgUJvGP+GJfZHXnLi+qK2lYkvAwpkhja6/swSEwlWnxi+dupj+EO9DpSI3dufvd5I3peSx7soKKenAkXRHx1IZwSbgzPcnVx5e9Q420FK0TZ+BZzy8GGE9dAvQcYoQ9996OvPR9rfpzrqi0C2FoIOhxTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=791Xww3wY0uFuuFC8nGm1uQo7GRg9a1Z1YPTT505vow=;
 b=NcoEJFD3dfhbhzGC675voFdpCYxuJvJt/Le6NlC3DvKuwBiPtPWOR0IQhY592AIb83lJMtAMWpYM3PQ6DJ2FEGWLDzmTG1eJBeT4QzmYnKmeTtw/4tOxg87/HfDlOI/sWMR8AwcJPsFxla50AMQJs1YbetBgOOJgwsfI8owB+yg=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OS0PR01MB5554.jpnprd01.prod.outlook.com (2603:1096:604:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 23:03:51 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 23:03:51 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     "derek.kiernan@xilinx.com" <derek.kiernan@xilinx.com>,
        "dragan.cvetic@xilinx.com" <dragan.cvetic@xilinx.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: FW: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassggABEPICABhmmwIAAPsuAgAAOzaCAATLmgIAAD7eQgABNoACAAGKO8IAAfRmAgABR13CAAHqY8A==
Date:   Thu, 18 Feb 2021 23:03:50 +0000
Message-ID: <OSBPR01MB4773F2E24C8AC98635EB0CBFBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
 <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
 <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
 <OSBPR01MB47737A11F8BFCC856C4A62DCBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3LrkAE9MuMkwMpJ6_5ZYM3m_S-0v7V7qrpY6JaAzHUTQ@mail.gmail.com> 
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05dca1d2-bcb4-4f9a-4123-08d8d46174dc
x-ms-traffictypediagnostic: OS0PR01MB5554:
x-microsoft-antispam-prvs: <OS0PR01MB5554D18D81A51FD72CBD2AC1BA859@OS0PR01MB5554.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRrohu49MF6o5lG7e6sIfNW5P9o+4nQXB4cr7C0N49w4tUdWCmDcMLbOD2dsb6EMi2PpbYScJ724Mb4edbKxxOif7qbbYU5dt4K6lkLpEEXC6MCYNA96PF4kFDZP3VwhEoRSbIiX823B4cQ1EaJ/H/E1uVObz3OviUPRf2AYpcm4Vfo4wfplfjtF956JGMZsMyYbOWMIEAFImpWqGq4wxnIGQ4dBDKdZWWjK26JiJY0nYihsgSD23CfIL25avdPNs1s1i/s1seRG31qJOEQjzW8tpSX/G9GR95xcytiQTs1QlRgOLBCsaFTDp2HCi9LuP86So0jd3V+RNYYPQYPgVONQDaieAwxyNC8MxikSzCbgyEAkEpeIBBvMNyhZbo+PF8omat05+rCdTQcZqW1LNlU9r4H7h3q7onCzUeSy/J66QYr2+Xys5GWCKYKh778yxexVeE481qB4QL8OYAeXlus3xcmfmPMxF/b9118zycPiOEFpOUodkOO6E1XDGmZ+tSY9OLIe70csiwrcgUw8kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(55016002)(6916009)(316002)(83380400001)(186003)(33656002)(9686003)(4326008)(66476007)(64756008)(66446008)(478600001)(66556008)(52536014)(86362001)(5660300002)(76116006)(8676002)(26005)(71200400001)(53546011)(7696005)(2906002)(8936002)(66946007)(6506007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eUpTcTZLbUZDZVBIT2l1d1dYQmZUcEZsWlhobjBuNFFTM2lmb0s2cTF2SUVx?=
 =?utf-8?B?R3JEeHBuMzNkZTZLR0ZjUnpMM3ZVM2tUaGlBbFhLM2RFamM3YTZ0WmxkZEpV?=
 =?utf-8?B?K0kwMWdyWmV3M3g5UjN2cldYbUNSVmw3MDlidC9CNTVtWFFtWC9xZTJsc3JH?=
 =?utf-8?B?ZGZUbEhmSmc2amhZVzR3dTduVUNzdzhKRXo2bVZHK1AxTG1NbUMyejlZQ0lX?=
 =?utf-8?B?Z29HQ1ZBSERjNmZVWG9lRW5GZE0zejZBbDhlaGlCQk5LTzN4bEpOVHRLcFFR?=
 =?utf-8?B?SjQ2dW05U21DSmNDeVM2T1FsVjVJMU41WnBxTDFPWVF3RjZITFo3VUg1d0xa?=
 =?utf-8?B?djM1eXcwK1l3WXFiU3BSeGxrL2NjVkdMQ1hZRGJGRmJmQlRlS0pSVzBHYlVv?=
 =?utf-8?B?UG5wY21wL2tzY0JvbXNDTnkvNXVQcGNpRURmQmJaUllCUTYyNlorT2tQZEJ1?=
 =?utf-8?B?V3BmM1FVck1xV2FQNVA2bnVZTzN6YzFuSW5tNnpwaFQyRW5xUld6QUcyUHJ0?=
 =?utf-8?B?WHlyU01ad09Xd25OOER2NWRBai9RVXpONUJveUNnQ3dqeVRYcHVocVl2STBk?=
 =?utf-8?B?bE44Rmk5a29nbnNlb0kxYkRwNGpkY3UyZTY4bWswZUtFbWY1N2t2a1ZTRXBa?=
 =?utf-8?B?UC9uVm9rY1RMMnZ2dElGZ0lRdDdKMmthMUI1SWppTW11bndKeG10Z2NXYTh1?=
 =?utf-8?B?dTQyT2NkakkrMXFSRnhZYTFFODl5amFZa3V5dnpVOUcrZXJPb2tkall6UnNr?=
 =?utf-8?B?Rk13Z0VGU0pXQU9yVGw4OVJiSXJlWnpyUXZ4OW5zZjVPRTlZNk44WmRXOU1V?=
 =?utf-8?B?WkVJRkNtajg5cEtoak5HTDI5cXQ2dzhNeUh3Zk9iZHBUV3cyc05XdTVBbEN1?=
 =?utf-8?B?Q1VJdU1JTHplWEFLMnNBVEhqTGovSnU3REcybk05S3h1UnEvaGV0bVVzOS9E?=
 =?utf-8?B?blh0a0tYbGV6bzBWOEMxeGt0dGsxQVNoVjNZeCs3YmhObmd6bjYySktuUmsy?=
 =?utf-8?B?OHMxYWlXYVBEYkw3Z010RS9tQjI2RHZXbmJZOFFMZWRBSnFJcGtZK2Jsc3la?=
 =?utf-8?B?dWNRL2JaRFUvQWRJZlNaa2ZCTnZaQXhjM0lnNG5DeWxJTy9NNjFkampCcG5R?=
 =?utf-8?B?eDlGTTZQTHlWTXVtQWNnNmRaMU9Kb3NmZWtNN0RUSFNHZzJZTUVnTERBenhK?=
 =?utf-8?B?c0NTS281dDhGZUsyV3JIeElML0J5WUtMdG5GbUVXd0ZJNllKU21RN3JJZjUw?=
 =?utf-8?B?b21EVTVqdW40VkNIMnFoMzNQL0lKZjQyZmRVZ2JjQXpyNXB1VTRBc1BEYklq?=
 =?utf-8?B?Wko0Q29CU1lnczlvQ3VQcG4vcFRvZ0YvazZveXZzVzQ2aUNUVm9CaWUvdHM0?=
 =?utf-8?B?WFBUQnJ0MnhnVGFhNGx4KzdacmRpTDVYQkw5VTVJVE10ZDVuazdDd0pweXZX?=
 =?utf-8?B?c0tTcFNuSjQzdGdIcUl2aWRUNkF6cjZnTldSeDJCV2pqY1BUSi9ieit6OGVD?=
 =?utf-8?B?d1BLMUVEVzJMNzdRNWhDNXVVR016TXlNLzJkNEt0TG8rZHFoU01FWnpiZWxl?=
 =?utf-8?B?OElvYm9SQ0x4V1FCdGpsM0lGZkFKaGR1bFMvbG80S1loMjE4ck1sZ3gxK041?=
 =?utf-8?B?YllFYmp4aEhvRVkzcnJ0MmZlb3g3c1FZL09LaG9na2dFS3p4RVcwdUZUZDFa?=
 =?utf-8?B?SEJKVkJrMEpicEk5NlQzOVRaa0svb1owSWU2dzBTNlNPeTZyVHZJTnQ4N0U1?=
 =?utf-8?Q?w07fFZtzCCbAhNx7ufNXmQV/jy1lRf/U4qYwsRq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05dca1d2-bcb4-4f9a-4123-08d8d46174dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 23:03:50.9373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: We5Wr1/pAibelWQJy9pHRtGgkEDfiFm/BpFw0ITpj7xp4rRP+oswvQwSfJIsdNU9a/Xv+Prg0WmvhBLn4/4uWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5554
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBNaW4gTGkgDQpTZW50OiBGZWJy
dWFyeSAxOCwgMjAyMSAxMToxNCBBTQ0KVG86ICdBcm5kIEJlcmdtYW5uJyA8YXJuZEBrZXJuZWwu
b3JnPg0KQ2M6IERlcmVrIEtpZXJuYW4gPGRlcmVrLmtpZXJuYW5AeGlsaW54LmNvbT47IERyYWdh
biBDdmV0aWMgPGRyYWdhbi5jdmV0aWNAeGlsaW54LmNvbT47IEFybmQgQmVyZ21hbm4gPGFybmRA
YXJuZGIuZGU+OyBncmVna2ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsgTmV0d29ya2luZyA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47
IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KU3ViamVjdDogUkU6
IFtQQVRDSCBuZXQtbmV4dF0gbWlzYzogQWRkIFJlbmVzYXMgU3luY2hyb25pemF0aW9uIE1hbmFn
ZW1lbnQgVW5pdCAoU01VKSBzdXBwb3J0DQoNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAa2VybmVsLm9yZz4NCj4gU2VudDogRmVi
cnVhcnkgMTgsIDIwMjEgNTo1MSBBTQ0KPiBUbzogTWluIExpIDxtaW4ubGkueGVAcmVuZXNhcy5j
b20+DQo+IENjOiBEZXJlayBLaWVybmFuIDxkZXJlay5raWVybmFuQHhpbGlueC5jb20+OyBEcmFn
YW4gQ3ZldGljIA0KPiA8ZHJhZ2FuLmN2ZXRpY0B4aWxpbnguY29tPjsgQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT47IGdyZWdraCANCj4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgTmV0d29ya2luZyANCj4gPG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc+OyBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbWlzYzogQWRkIFJlbmVzYXMgU3luY2hy
b25pemF0aW9uIA0KPiBNYW5hZ2VtZW50IFVuaXQgKFNNVSkgc3VwcG9ydA0KPiANCj4gT24gVGh1
LCBGZWIgMTgsIDIwMjEgYXQgNDoyOCBBTSBNaW4gTGkgPG1pbi5saS54ZUByZW5lc2FzLmNvbT4g
d3JvdGU6DQo+ID4gPiBJZiB0aGUgZHJpdmVyIGNhbiB1c2UgdGhlIHNhbWUgYWxnb3JpdGhtIHRo
YXQgaXMgaW4geW91ciB1c2VyIA0KPiA+ID4gc3BhY2Ugc29mdHdhcmUgdG9kYXksIHRoYXQgd291
bGQgc2VlbSB0byBiZSBhIG5pY2VyIHdheSB0byBoYW5kbGUgDQo+ID4gPiBpdCB0aGFuIHJlcXVp
cmluZyBhIHNlcGFyYXRlIGFwcGxpY2F0aW9uLg0KPiA+ID4NCj4gPg0KPiA+IEhpIEFybmQNCj4g
Pg0KPiA+DQo+ID4gV2hhdCBpcyB0aGUgZGV2aWNlIGRyaXZlciB0aGF0IHlvdSBhcmUgcmVmZXJy
aW5nIGhlcmU/DQo+ID4NCj4gPiBJbiBzdW1tYXJ5IG9mIHlvdXIgcmV2aWV3cywgYXJlIHlvdSBz
dWdnZXN0aW5nIG1lIHRvIGRpc2NhcmQgdGhpcyANCj4gPiBjaGFuZ2UgYW5kIGdvIGJhY2sgdG8g
UFRQIHN1YnN5c3RlbSB0byBmaW5kIGEgYmV0dGVyIHBsYWNlIGZvciANCj4gPiB0aGluZ3MgdGhh
dCBJIHdhbm5hIGRvIGhlcmU/DQo+IA0KPiBZZXMsIEkgbWVhbiBkb2luZyBpdCBhbGwgaW4gdGhl
IFBUUCBkcml2ZXIuDQo+IA0KPiAgICAgICAgIEFybmQNCg0KSGkgQXJuZA0KDQpUaGUgQVBJcyBJ
IGFtIGFkZGluZyBoZXJlIGlzIGZvciBvdXIgZGV2ZWxvcG1lbnQgb2YgYXNzaXN0ZWQgcGFydGlh
bCB0aW1pbmcgc3VwcG9ydCAoQVBUUyksIHdoaWNoIGlzIGEgR2xvYmFsIE5hdmlnYXRpb24gU2F0
ZWxsaXRlIFN5c3RlbSAoR05TUykgYmFja2VkIGJ5IFByZWNpc2lvbiBUaW1lIFByb3RvY29sIChQ
VFApLg0KU28gaXQgaXMgbm90IHBhcnQgb2YgUFRQIGJ1dCB0aGV5IGNhbiB3b3JrIHRvZ2V0aGVy
IGZvciBuZXR3b3JrIHRpbWluZyBzb2x1dGlvbi4NCg0KV2hhdCBJIGFtIHRyeWluZyB0byBzYXkg
aXMgdGhlIHRoaW5ncyB0aGF0IEkgYW0gYWRkaW5nIGhlcmUgZG9lc24ndCByZWFsbHkgYmVsb25n
IHRvIHRoZSBQVFAgd29ybGQuDQpGb3IgZXhhbXBsZSwgdGltZXgtPmZyZXEgaXMgZGlmZmVyZW50
IGZyb20gdGhlIGZmbyB0aGF0IEkgYW0gcmVhZGluZyBmcm9tIHRoaXMgZHJpdmVyIHNpbmNlIHRo
ZSBEUExMIGlzIFdvcmtpbmcgaW4gZGlmZmVyZW50IG1vZGUuIEZvciBQVFAsIERQTEwgaXMgd29y
a2luZyBpbiBEQ08gbW9kZS4gSW4gRENPIG1vZGUsIHRoZSBEUExMIGNvbnRyb2wgbG9vcCBpcyBv
cGVuZWQgYW5kIHRoZSBEQ08gY2FuIGJlIGNvbnRyb2xsZWQgYnkgYSBQVFAgY2xvY2sgcmVjb3Zl
cnkgc2Vydm8gcnVubmluZyBvbiBhbiBleHRlcm5hbCBwcm9jZXNzb3IgdG8gc3ludGhlc2l6ZSBQ
VFAgY2xvY2tzLiBPbiB0aGUgb3RoZXIgaGFuZCBmb3IgR05TUyB0aW1pbmcsIHRoZSBmZm8gSSBh
bSByZWFkaW5nIGhlcmUgaXMgd2hlbiBEUExMIGlzIGluIGxvY2tlZCBtb2RlLiBJbiBMb2NrZWQg
dGhlIGxvbmctdGVybSBvdXRwdXQgZnJlcXVlbmN5IGFjY3VyYWN5IGlzIHRoZSBzYW1lIGFzIHRo
ZSBsb25nLXRlcm0gZnJlcXVlbmN5IGFjY3VyYWN5IG9mIHRoZSBzZWxlY3RlZCBpbnB1dCByZWZl
cmVuY2UuDQoNCkZvciBvdXIgR05TUyBBUFRTIGRldmVsb3BtZW50LCB3ZSBoYXZlIDIgRFBMTCBj
aGFubmVscywgb25lIGNoYW5uZWwgaXMgbG9ja2VkIHRvIEdOU1MgYW5kIGFub3RoZXIgY2hhbm5l
bCBpcyBQVFAgY2hhbm5lbC4NCklmIEdOU1MgY2hhbm5lbCBpcyBsb2NrZWQsIHdlIHVzZSBHTlNT
J3MgY2hhbm5lbCB0byBzdXBwb3J0IG5ldHdvcmsgdGltaW5nLiBPdGhlcndpc2UsIHdlIHN3aXRj
aCB0byBQVFAgY2hhbm5lbC4gDQoNClRvIHRoaW5rIGFib3V0IGl0LCBvdXIgZGV2aWNlIGlzIHJl
YWxseSBhbiBtdWx0aSBmdW5jdGlvbmFsIGRldmljZSAoTUZEKSwgd2hpY2ggaXMgd2h5IEkgYW0g
c3VibWl0dGluZyBhbm90aGVyIHJldmlldyBmb3Igb3VyIE1GRCBkcml2ZXIgb24gdGhlIHNpZGUu
IFdlIGhhdmUgb3VyIFBUUCBkcml2ZXIgYW5kIHdlIGhhdmUgdGhpcyBmb3IgR05TUyBBUFRTIGFu
ZCBvdGhlciBtaXNjIGZ1bmN0aW9ucy4gDQoNClNvIGNhbiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhp
cyBhZ2FpbiBhbmQgc2VlIGlmIGl0IG1ha2VzIHNlbnNlIHRvIGtlZXAgdGhpcyBjaGFuZ2Ugc2lt
cGx5IGJlY2F1c2UgdGhlIGNoYW5nZSBpcyBub3QgcGFydCBvZiBQVFAgc3Vic3lzdGVtLg0KVGhl
eSBzb3VuZCBsaWtlIHRoZXkgYXJlIHJlbGF0ZWQuIEJ1dCB3aGVuIGl0IGNvbWVzIHRvIHRlY2hu
aWNhbGl0eSwgdGhlcmUgaXMgcmVhbGx5IG5vIHBsYWNlIGluIFBUUCB0byBob2xkIHN0dWZmIHRo
YXQgSSBhbSBkb2luZyBoZXJlLg0KDQpUaGFua3MNCg0KTWluDQo=
