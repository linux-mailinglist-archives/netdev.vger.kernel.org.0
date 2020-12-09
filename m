Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40432D4B8E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgLIUTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:19:40 -0500
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:47778
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgLIUT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 15:19:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ91AHcwyvWKGsueP+FNvQZrPNkRg+DcUeLvX1s1jLU02davvyGcOVHwc9NoXsutzwVv31qGixBNt3tKB+r1wMYnbi31NGN80dMRfUQgmyFbzFfXvLXVVTuZPYZ/+GY47NS3EckS+SzCVM1IMgk799wn2idHkBhcRcESBvDHpQXTg4D+7+efrwFvWt3XeiW8ccEMwkyoPTIANLYox2Tb0gHYwEH3dLXXLDmrljzEjyasATruecmp06bB1I7hg8SjeEpCsKeNhGueS06Fz8TGckUYEK9sF/5gXK81Cb4fQrSDFPsLl//1VWUEceZqyqsW45Xb8OmUP0MabmtXPZQTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxEBd7tvGe2tOeCLr2Qdmj02Eqy3nOACux4pE2AjU/8=;
 b=HsUMaaiEMsR8itZfRXKJiVpEmmi8827rAPGNQj3HsKrsGfRNykiviOuw9OmH8RJOsh9Ab41b1TLdFYw5ADVnH+57Nyrcn4qZOK+uwHPdwU72AwXWggqGZcDHdcuMJZ0KR08NebvcsWKZMDDpROOYYQMYSxOT0fzocVwbBd2o1dvNx3VkPJNvVQEONA0tls5fza5E2Kt6Dz3Gm+ky1+vI7sLOhL8ekFeK5q1MZZpUP8CmmKBJQrK4TDNMj4xlAEvIWWP1STBYq/R5bIkDC8cufvup+gADxgsxXFn++lhnI/s2qyv2ZRt7zCjKF3g+T/321e/dGYiGTECuMJB+YoVBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxEBd7tvGe2tOeCLr2Qdmj02Eqy3nOACux4pE2AjU/8=;
 b=cYfqC7UJ09iTJBLjv+QaCuWdlrK+MS9I8yx8Bjk18k4qo4OiqKV3c7N6ppeb3QmRSWAHotHDIehQpziPv0hyFaJjQ2DKqMfXvoe9b1f45FvJXdR7WO+GnDU2pj8Ss2F5PtRST50cJSPIZyiOdp/e0TGZK6JFCOtqC1yTP2Hhn+s=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VI1PR10MB3277.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:135::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 9 Dec
 2020 20:18:42 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f%7]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 20:18:42 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Molzahn, Ines" <ines.molzahn@siemens.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Topic: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Index: AQHWzjjS+JtwwiLyJkKEw3ObDmZ1g6nu2GGAgAAIlICAACaHgIAAFaqA
Date:   Wed, 9 Dec 2020 20:18:42 +0000
Message-ID: <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
In-Reply-To: <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2020-12-09T20:18:39Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=eae03ecb-24cb-4829-918f-ef7d28c5c1f5;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d77a14db-569e-40a2-e265-08d89c7f9fa0
x-ms-traffictypediagnostic: VI1PR10MB3277:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR10MB32774E0833A088019BD0D354ABCC0@VI1PR10MB3277.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jcaM/U8qXpcfpv6/u68IMySPmiuKuV01UA61BolfGuesWJDiwkF9LIsuQ26Pyj4v2Q90sWDQVQfm8ub5L3O8KarTp+mBRZq8iEDzChzlt2B44D+ifnSsDZ1Y+Pc/UCLy1O2fKqH7uV0Vaqhda7l4PnU4bmXwuhZd9UBiA9fobh9x2zX6EPjZ9l8vleip2CZYHSjcnQRCQ9VcppgyezWHkNyuUarsiFMJLYxof1LPmIonRSqV0JJ4gk8EgHGQbGOXbneZdh/iZBFwOTIeAWV0kPb103KRn+qZ07qRaB6kpkzBSxbhb9yaDPpUYNTob93fL+rFKJ3ccS4q5d66FS94Ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(86362001)(66556008)(66476007)(71200400001)(64756008)(7416002)(6506007)(66946007)(4326008)(54906003)(76116006)(7406005)(83380400001)(186003)(6916009)(9686003)(33656002)(8676002)(66446008)(8936002)(508600001)(53546011)(2906002)(5660300002)(7696005)(52536014)(55236004)(26005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R1pyazhPMllhOU1OMU90ZEdPNlYwdFNXb21mK29LRHh3amVXOEZNOE5kN05a?=
 =?utf-8?B?VGNrU0RpU2MzYVU1WVVDLzVqa3puaDlPcWhEZW9LclFKaTdTTWxTZ1Y4U2w2?=
 =?utf-8?B?WFQ4UzA4eVN6Q2ttU05rcE1aalRIS3ZRbmlYZjU2Zm9LWGZURGxJc2lJcVJr?=
 =?utf-8?B?Mm5TUVhiM2RnSUpDMzZab0pKdTZQdS9uS2czeWNtTW9KSXozb0lPcENjS0Nj?=
 =?utf-8?B?RllyM1BLVTNHMnd3Zm9WbDljYm5yTVVEdGo5ZFEwUXlQamdWU1IvM2hCUmxv?=
 =?utf-8?B?azlUWWVkSlhOMDlmMGcxd2FIVFNVbUNKdWhucDVpbkJWZldrNE5PZUw1bjZP?=
 =?utf-8?B?M3VadTJqamY1bXBNOWhraEcyTjhyVzJJN2UrVWE0SlFOMWJsQzV5d1JlUEp3?=
 =?utf-8?B?azd2dTdiY2J0eVlqYXI5WUlGSEI2Nm1McGZNY3JBdzdld1Y3eUJHZi9ZTVJF?=
 =?utf-8?B?NFZYNWVXdzlrOVZQRHdqallsbVFhNExFd0JZeXVJR3VSSXlBZUkwbEdSRVp2?=
 =?utf-8?B?V2NiVXZXTmpYMnlTeVRRRUJEZjlpVlBhdlVuNXVPSEFTZmE4YlJFZHlpemR5?=
 =?utf-8?B?c0VJTWwwMWtBdzhnUTI5aE5POFlqMDBEWGJpaWw3dXg3cnFpTDVqRGRXVmhr?=
 =?utf-8?B?OUlPbkJDMTI3a2FDckc5YkpTU3V4bjFTOXBpdWJ2NFNMcnZnZFBiM08xOXlu?=
 =?utf-8?B?bVNWSTdaSGFqcnE1aUdwL0Vmc09RVnlLWER3bkJ5QnNkUnMySStlR1c1Y1JO?=
 =?utf-8?B?L3pYUXBrb2huVnVLK1B6eXJPM0llRjZTQnJ0eG5LZkFwSmVtRXQwaEFyVjVQ?=
 =?utf-8?B?REN5bENkSkcwMi9XOVJoTkE0SkJ0MjVSSUVrTE1jcFRSUDFqakVRU3A0R0p2?=
 =?utf-8?B?b2VBYnU4MEZ6blJnenQ4bENEaWhvakZWamhTTjlGT3BJKzBZZmJLUm95R2di?=
 =?utf-8?B?V0RkZUdGSlMyeVltZUZabVpvdUpObWR1VXhtWUt2WmZhYmpFYlhBTTFHa1ZG?=
 =?utf-8?B?bHVRcWlUWnpaQ1lqVmRYUTQyL3dZaXk0ZWRYOG45NkprWjRJSWttMDY4QXZj?=
 =?utf-8?B?bWs1OUpTMHlQU2JtQ2FuQTBhbVpUbndUakFGUWxlZVB5WjZETkJuRFRwNmZG?=
 =?utf-8?B?QitCa01xeHpyekdPSUlsNzJxWnNWaVl1TU54TFZJeVZERVBXR3pxaFhkK0Jm?=
 =?utf-8?B?ZUwydVcxWVpJNWI1M0JhY3dCT3pJNDJHUVVEeVdmMEt1ZDdWQkpHVm96MTdO?=
 =?utf-8?B?cU0ycjY1NDlSQXoyNWN0VUxqdXJlUmtVQXMyaVh5VzdMWDFyS2JJcm5QNTdi?=
 =?utf-8?Q?+oXVwdU9Tep0c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D0B420A82BE7D4596E33B5DFB16B6D5@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d77a14db-569e-40a2-e265-08d89c7f9fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 20:18:42.2857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVZQG9UV2ag8NL1ksT9ET8XYMxebQ+gNV7KcjVj+woYdLf5yYcSSbWIQrFZx+85skM/gtn2So+s9unuAnlxxzy8pc/nSp2X7vwwFQ9hxlIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAwOS8xMi8yMDIwIDE4OjM3LCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3RlOg0KPiBPbiBXZWQs
IERlYyA5LCAyMDIwIGF0IDEwOjI1IEFNIEdldmEsIEVyZXogPGVyZXouZ2V2YS5leHRAc2llbWVu
cy5jb20+IHdyb3RlOg0KPj4NCj4+DQo+PiBPbiAwOS8xMi8yMDIwIDE1OjQ4LCBXaWxsZW0gZGUg
QnJ1aWpuIHdyb3RlOg0KPj4+IE9uIFdlZCwgRGVjIDksIDIwMjAgYXQgOTozNyBBTSBFcmV6IEdl
dmEgPGVyZXouZ2V2YS5leHRAc2llbWVucy5jb20+IHdyb3RlOg0KPj4+Pg0KPj4+PiBDb25maWd1
cmUgYW5kIHNlbmQgVFggc2VuZGluZyBoYXJkd2FyZSB0aW1lc3RhbXAgZnJvbQ0KPj4+PiAgICB1
c2VyIHNwYWNlIGFwcGxpY2F0aW9uIHRvIHRoZSBzb2NrZXQgbGF5ZXIsDQo+Pj4+ICAgIHRvIHBy
b3ZpZGUgdG8gdGhlIFRDIEVUQyBRZGlzYywgYW5kIHBhc3MgaXQgdG8NCj4+Pj4gICAgdGhlIGlu
dGVyZmFjZSBuZXR3b3JrIGRyaXZlci4NCj4+Pj4NCj4+Pj4gICAgLSBOZXcgZmxhZyBmb3IgdGhl
IFNPX1RYVElNRSBzb2NrZXQgb3B0aW9uLg0KPj4+PiAgICAtIE5ldyBhY2Nlc3MgYXV4aWxpYXJ5
IGRhdGEgaGVhZGVyIHRvIHBhc3MgdGhlDQo+Pj4+ICAgICAgVFggc2VuZGluZyBoYXJkd2FyZSB0
aW1lc3RhbXAuDQo+Pj4+ICAgIC0gQWRkIHRoZSBoYXJkd2FyZSB0aW1lc3RhbXAgdG8gdGhlIHNv
Y2tldCBjb29raWUuDQo+Pj4+ICAgIC0gQ29weSB0aGUgVFggc2VuZGluZyBoYXJkd2FyZSB0aW1l
c3RhbXAgdG8gdGhlIHNvY2tldCBjb29raWUuDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEVy
ZXogR2V2YSA8ZXJlei5nZXZhLmV4dEBzaWVtZW5zLmNvbT4NCj4+Pg0KPj4+IEhhcmR3YXJlIG9m
ZmxvYWQgb2YgcGFjaW5nIGlzIGRlZmluaXRlbHkgdXNlZnVsLg0KPj4+DQo+PiBUaGFua3MgZm9y
IHlvdXIgY29tbWVudC4NCj4+IEkgYWdyZWUsIGl0IGlzIG5vdCBsaW1pdGVkIG9mIHVzZS4NCj4+
DQo+Pj4gSSBkb24ndCB0aGluayB0aGlzIG5lZWRzIGEgbmV3IHNlcGFyYXRlIGgvdyB2YXJpYW50
IG9mIFNPX1RYVElNRS4NCj4+Pg0KPj4gSSBvbmx5IGV4dGVuZCBTT19UWFRJTUUuDQo+IA0KPiBU
aGUgcGF0Y2hzZXQgcGFzc2VzIGEgc2VwYXJhdGUgdGltZXN0YW1wIGZyb20gc2tiLT50c3RhbXAg
YWxvbmcNCj4gdGhyb3VnaCB0aGUgaXAgY29va2llLCBjb3JrICh0cmFuc21pdF9od190aW1lKSBh
bmQgd2l0aCB0aGUgc2tiIGluDQo+IHNoaW5mby4NCj4gDQo+IEkgZG9uJ3Qgc2VlIHRoZSBuZWVk
IGZvciB0d28gdGltZXN0YW1wcywgb25lIHRpZWQgdG8gc29mdHdhcmUgYW5kIG9uZQ0KPiB0byBo
YXJkd2FyZS4gV2hlbiB3b3VsZCB3ZSB3YW50IHRvIHBhY2UgdHdpY2U/DQoNCkFzIHRoZSBOZXQt
TGluayB1c2VzIHN5c3RlbSBjbG9jayBhbmQgdGhlIG5ldHdvcmsgaW50ZXJmYWNlIGhhcmR3YXJl
IHVzZXMgaXQncyBvd24gUEhDLg0KVGhlIGN1cnJlbnQgRVRGIGRlcGVuZHMgb24gc3luY2hyb25p
emluZyB0aGUgc3lzdGVtIGNsb2NrIGFuZCB0aGUgUEhDLg0KIA0KPj4+IEluZGVlZCwgd2Ugd2Fu
dCBwYWNpbmcgb2ZmbG9hZCB0byB3b3JrIGZvciBleGlzdGluZyBhcHBsaWNhdGlvbnMuDQo+Pj4N
Cj4+IEFzIHRoZSBjb252ZXJzaW9uIG9mIHRoZSBQSEMgYW5kIHRoZSBzeXN0ZW0gY2xvY2sgaXMg
ZHluYW1pYyBvdmVyIHRpbWUuDQo+PiBIb3cgZG8geW91IHByb3BzZSB0byBhY2hpdmUgaXQ/DQo+
IA0KPiBDYW4geW91IGVsYWJvcmF0ZSBvbiB0aGlzIGNvbmNlcm4/DQoNClVzaW5nIHNpbmdsZSB0
aW1lIHN0YW1wIGhhdmUgMyBwb3NzaWJsZSBzb2x1dGlvbnM6DQoNCjEuIEN1cnJlbnQgc29sdXRp
b24sIHN5bmNocm9uaXplIHRoZSBzeXN0ZW0gY2xvY2sgYW5kIHRoZSBQSEMuDQogICAgQXBwbGlj
YXRpb24gdXNlcyB0aGUgc3lzdGVtIGNsb2NrLg0KICAgIFRoZSBFVEYgY2FuIHVzZSB0aGUgc3lz
dGVtIGNsb2NrIGZvciBvcmRlcmluZyBhbmQgcGFzcyB0aGUgcGFja2V0IHRvIHRoZSBkcml2ZXIg
b24gdGltZQ0KICAgIFRoZSBuZXR3b3JrIGludGVyZmFjZSBoYXJkd2FyZSBjb21wYXJlIHRoZSB0
aW1lLXN0YW1wIHRvIHRoZSBQSEMuDQoNCjIuIFRoZSBhcHBsaWNhdGlvbiBjb252ZXJ0IHRoZSBQ
SEMgdGltZS1zdGFtcCB0byBzeXN0ZW0gY2xvY2sgYmFzZWQuDQogICAgIFRoZSBFVEYgd29ya3Mg
YXMgc29sdXRpb24gMQ0KICAgICBUaGUgbmV0d29yayBkcml2ZXIgY29udmVydCB0aGUgc3lzdGVt
IGNsb2NrIHRpbWUtc3RhbXAgYmFjayB0byBQSEMgdGltZS1zdGFtcC4NCiAgICAgVGhpcyBzb2x1
dGlvbiBuZWVkIGEgbmV3IE5ldC1MaW5rIGZsYWcgYW5kIG1vZGlmeSB0aGUgcmVsZXZhbnQgbmV0
d29yayBkcml2ZXJzLg0KICAgICBZZXQgdGhpcyBzb2x1dGlvbiBoYXZlIDIgcHJvYmxlbXM6DQog
ICAgICogQXMgYXBwbGljYXRpb25zIHRvZGF5IGFyZSBub3QgYXdhcmUgdGhhdCBzeXN0ZW0gY2xv
Y2sgYW5kIFBIQyBhcmUgbm90IHN5bmNocm9uaXplZCBhbmQNCiAgICAgICAgdGhlcmVmb3JlIGRv
IG5vdCBwZXJmb3JtIGFueSBjb252ZXJzaW9uLCBtb3N0IG9mIHRoZW0gb25seSB1c2UgdGhlIHN5
c3RlbSBjbG9jay4NCiAgICAgKiBBcyB0aGUgY29udmVyc2lvbiBpbiB0aGUgbmV0d29yayBkcml2
ZXIgaGFwcGVucyB+MzAwIC0gNjAwIG1pY3Jvc2Vjb25kcyBhZnRlciANCiAgICAgICAgdGhlIGFw
cGxpY2F0aW9uIHNlbmQgdGhlIHBhY2tldC4NCiAgICAgICAgQW5kIGFzIHRoZSBQSEMgYW5kIHN5
c3RlbSBjbG9jayBmcmVxdWVuY2llcyBhbmQgb2Zmc2V0IGNhbiBjaGFuZ2UgZHVyaW5nIHRoaXMg
cGVyaW9kLg0KICAgICAgICBUaGUgY29udmVyc2lvbiB3aWxsIHByb2R1Y2UgYSBkaWZmZXJlbnQg
UEhDIHRpbWUtc3RhbXAgZnJvbSB0aGUgYXBwbGljYXRpb24gb3JpZ2luYWwgdGltZS1zdGFtcC4N
CiAgICAgICAgV2UgcmVxdWlyZSBhIHByZWNlc3Npb24gb2YgMSBuYW5vc2Vjb25kcyBvZiB0aGUg
UEhDIHRpbWUtc3RhbXAuDQoNCjMuIFRoZSBhcHBsaWNhdGlvbiB1c2VzIFBIQyB0aW1lLXN0YW1w
IGZvciBza2ItPnRzdGFtcA0KICAgIFRoZSBFVEYgY29udmVydCB0aGUgIFBIQyB0aW1lLXN0YW1w
IHRvIHN5c3RlbSBjbG9jayB0aW1lLXN0YW1wLg0KICAgIFRoaXMgc29sdXRpb24gcmVxdWlyZSBp
bXBsZW1lbnRhdGlvbnMgb24gc3VwcG9ydGluZyByZWFkaW5nIFBIQyBjbG9ja3MNCiAgICBmcm9t
IElSUS9rZXJuZWwgdGhyZWFkIGNvbnRleHQgaW4ga2VybmVsIHNwYWNlLg0KDQpKdXN0IGZvciBj
bGFyaWZpY2F0aW9uOg0KRVRGIGFzIGFsbCBOZXQtTGluaywgb25seSB1c2VzIHN5c3RlbSBjbG9j
ayAodGhlIFRBSSkNClRoZSBuZXR3b3JrIGludGVyZmFjZSBoYXJkd2FyZSBvbmx5IHVzZXMgdGhl
IFBIQy4NCk5vciBOZXQtTGluayBuZWl0aGVyIHRoZSBkcml2ZXIgcGVyZm9ybSBhbnkgY29udmVy
c2lvbnMuDQpUaGUgS2VybmVsIGRvZXMgbm90IHByb3ZpZGUgYW5kIGNsb2NrIGNvbnZlcnNpb24g
YmVzaWRlIHN5c3RlbSBjbG9jay4NCkxpbnV4IGtlcm5lbCBpcyBhIHNpbmdsZSBjbG9jayBzeXN0
ZW0uDQoNCj4gDQo+IFRoZSBzaW1wbGVzdCBzb2x1dGlvbiBmb3Igb2ZmbG9hZGluZyBwYWNpbmcg
d291bGQgYmUgdG8gaW50ZXJwcmV0DQo+IHNrYi0+dHN0YW1wIGVpdGhlciBmb3Igc29mdHdhcmUg
cGFjaW5nLCBvciBza2lwIHNvZnR3YXJlIHBhY2luZyBpZiB0aGUNCj4gZGV2aWNlIGFkdmVydGlz
ZXMgYSBORVRJRl9GIGhhcmR3YXJlIHBhY2luZyBmZWF0dXJlLg0KDQpUaGF0IHdpbGwgZGVmeSB0
aGUgcHVycG9zZSBvZiBFVEYuDQpFVEYgZXhpc3QgZm9yIG9yZGVyaW5nIHBhY2tldHMuDQpXaHkg
c2hvdWxkIHRoZSBkZXZpY2UgZHJpdmVyIGRlZmVyIGl0Pw0KU2ltcGx5IGRvIG5vdCB1c2UgdGhl
IFFESVNDIGZvciB0aGlzIGludGVyZmFjZS4NCg0KPiANCj4gQ2xvY2tiYXNlIGlzIGFuIGlzc3Vl
LiBUaGUgZGV2aWNlIGRyaXZlciBtYXkgaGF2ZSB0byBjb252ZXJ0IHRvDQo+IHdoYXRldmVyIGZv
cm1hdCB0aGUgZGV2aWNlIGV4cGVjdHMgd2hlbiBjb3B5aW5nIHNrYi0+dHN0YW1wIGluIHRoZQ0K
PiBkZXZpY2UgdHggZGVzY3JpcHRvci4NCg0KV2UgZG8gaG9wZSBvdXIgZGVmaW5pdGlvbiBpcyBj
bGVhci4NCkluIHRoZSBjdXJyZW50IGtlcm5lbCBza2ItPnRzdGFtcCB1c2VzIHN5c3RlbSBjbG9j
ay4NClRoZSBoYXJkd2FyZSB0aW1lLXN0YW1wIGlzIFBIQyBiYXNlZCwgYXMgaXQgaXMgdXNlZCB0
b2RheSBmb3IgUFRQIHR3byBzdGVwcy4NCldlIG9ubHkgcHJvcG9zZSB0byB1c2UgdGhlIHNhbWUg
aGFyZHdhcmUgdGltZS1zdGFtcC4NCg0KUGFzc2luZyB0aGUgaGFyZHdhcmUgdGltZS1zdGFtcCB0
byB0aGUgc2tiLT50c3RhbXAgbWlnaHQgc2VlbXMgYSBiaXQgdHJpY2t5DQpUaGUgZ2FvbCBpcyB0
aGUgbGVhdmUgdGhlIGRyaXZlciB1bmF3YXJlIHRvIHdoZXRoZXIgd2UNCiogU3luY2hyb25pemlu
ZyB0aGUgUEhDIGFuZCBzeXN0ZW0gY2xvY2sNCiogVGhlIEVURiBwYXNzIHRoZSBoYXJkd2FyZSB0
aW1lLXN0YW1wIHRvIHNrYi0+dHN0YW1wDQpPbmx5IHRoZSBhcHBsaWNhdGlvbnMgYW5kIHRoZSBF
VEYgYXJlIGF3YXJlLg0KVGhlIGFwcGxpY2F0aW9uIGNhbiBkZXRlY3QgYnkgY2hlY2tpbmcgdGhl
IEVURiBmbGFnLg0KVGhlIEVURiBmbGFncyBhcmUgcGFydCBvZiB0aGUgbmV0d29yayBhZG1pbmlz
dHJhdGlvbi4NClRoYXQgYWxzbyBjb25maWd1cmUgdGhlIFBUUCBhbmQgdGhlIHN5c3RlbSBjbG9j
ayBzeW5jaHJvbml6YXRpb24uDQoNCj4gDQo+Pg0KPj4+IEl0IG9ubHkgcmVxdWlyZXMgdGhhdCBw
YWNpbmcgcWRpc2NzLCBib3RoIHNjaF9ldGYgYW5kIHNjaF9mcSwNCj4+PiBvcHRpb25hbGx5IHNr
aXAgcXVldWluZyBpbiB0aGVpciAuZW5xdWV1ZSBjYWxsYmFjayBhbmQgaW5zdGVhZCBhbGxvdw0K
Pj4+IHRoZSBza2IgdG8gcGFzcyB0byB0aGUgZGV2aWNlIGRyaXZlciBhcyBpcywgd2l0aCBza2It
PnRzdGFtcCBzZXQuIE9ubHkNCj4+PiB0byBkZXZpY2VzIHRoYXQgYWR2ZXJ0aXNlIHN1cHBvcnQg
Zm9yIGgvdyBwYWNpbmcgb2ZmbG9hZC4NCj4+Pg0KPj4gSSBkaWQgbm90IHVzZSAiRmFpciBRdWV1
ZSB0cmFmZmljIHBvbGljaW5nIi4NCj4+IEFzIGZvciBFVEYsIGl0IGlzIGFsbCBhYm91dCBvcmRl
cmluZyBwYWNrZXRzIGZyb20gZGlmZmVyZW50IGFwcGxpY2F0aW9ucy4NCj4+IEhvdyBjYW4gd2Ug
YWNoaXZlIGl0IHdpdGggc2tpcGluZyBxdWV1aW5nPw0KPj4gQ291bGQgeW91IGVsYWJvcmF0ZSBv
biB0aGlzIHBvaW50Pw0KPiANCj4gVGhlIHFkaXNjIGNhbiBvbmx5IGRlZmVyIHBhY2luZyB0byBo
YXJkd2FyZSBpZiBoYXJkd2FyZSBjYW4gZW5zdXJlIHRoZQ0KPiBzYW1lIGludmFyaWFudHMgb24g
b3JkZXJpbmcsIG9mIGNvdXJzZS4NCg0KWWVzLCB0aGlzIGlzIHdoeSB3ZSBzdWdnZXN0IEVURiBv
cmRlciBwYWNrZXRzIHVzaW5nIHRoZSBoYXJkd2FyZSB0aW1lLXN0YW1wLg0KQW5kIHBhc3MgdGhl
IHBhY2tldCBiYXNlZCBvbiBzeXN0ZW0gdGltZS4NClNvIEVURiBxdWVyeSB0aGUgc3lzdGVtIGNs
b2NrIG9ubHkgYW5kIG5vdCB0aGUgUEhDLg0KDQo+IA0KPiBCdHc6IHRoaXMgaXMgcXVpdGUgYSBs
b25nIGxpc3Qgb2YgQ0M6cw0KPiANCkkgbmVlZCB0byB1cGRhdGUgbXkgY29tcGFueSBjb2xsZWFn
dWVzIGFzIHdlbGwgYXMgdGhlIExpbnV4IGdyb3VwLg0K
