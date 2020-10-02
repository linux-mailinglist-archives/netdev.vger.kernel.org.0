Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1201281C62
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJBT4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:56:55 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:47902
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgJBT4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 15:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJiVC4alC+H2bGz3gpNmPu1RpiOzDgTo+oi1wgbIbS+49e+7TzXK1m30FdUJoDAxriQ2sbS5XpgFFnKOiZ4WgDRc7Ur06vClKatoYchDxNwyadokYlrLzElGzjyHbVXSmZS8lsYNQDFfCJOoeLjh0Ar9AvdKSGxbKMnLC4oQAd7V6DH7jPcaT2j5yVQHUqkR/0G15XloW4jep6Sj9WIyVdI7ROegtG1oSB5KlP1aoP6e5spZZW6vDE5TJ9odNKRuBCYXmSrVpexdHL27sLd0LwjmU5rZSHTdptkS+6CYaUkns3A8x0R4vgUrz3UlV/bX4ocKhiRCY4si1jZYpnwZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMgsGNkFGTD+mL5ybLFj7RmuApc/ukwPObuU/jY7KwQ=;
 b=h//iiGBltLknVL9TaDR/bmwOkGNJXIX3xBuP2+exlXSJ7jqL049M6akgCSz9e49ImpXGN6mWZHdBJVHmUOoxw7HXqY3EH7sgESrkvhFMQHYuG1ZuzKgASzfnsgg0N4HY9JsL6gwiQG5+2QnCSeUVhfNfF5SdyyMqxT5TwVflWLloYtd8KV8XCjuJIN+pKNMvUtr7QVWtRW+A9Kh3uvkTNkU5nRM3LmDqzvZofOBjuMQUEzM7nhVASnZM7/GwOefgihgtRvnuGmQaIt00fJzVZG9uRfuY5FSkOFGr+PlhduyPewIBH8bkQ5GxuvWHmF7MNBTqPjkvjAfLYoouzIY0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMgsGNkFGTD+mL5ybLFj7RmuApc/ukwPObuU/jY7KwQ=;
 b=XmoPts/CTSJTamekTrQmXpcHpJo41er+zQEG5gH4f4niJZHoB6VaX/hzHiL7CtOyBypMPvr37UEkBXb91D4a8PtbHMDUV0XmoJCgFgRQJ4YkshGa81MwXPj70Qfo2tG4I0ZNfLwmAPDdAZw/1cWjToKEuC0UXBwwtmlSLleECIQ=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VI1PR1001MB1374.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Fri, 2 Oct
 2020 19:56:51 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b80e:490f:a2d4:7e6b]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b80e:490f:a2d4:7e6b%4]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 19:56:51 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
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
Subject: Re: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Topic: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Index: AQHWmDS8TLGr6QV+p0Sd77e/YKvWCqmErIiAgAAPTYA=
Date:   Fri, 2 Oct 2020 19:56:50 +0000
Message-ID: <VI1PR10MB2446AE70D793A5DD8490A5B9AB310@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
 <87eemg5u5i.fsf@intel.com>
In-Reply-To: <87eemg5u5i.fsf@intel.com>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-document-confidentiality: NotClassified
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.27.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8cb4bd83-325e-4bf4-f425-08d8670d4e06
x-ms-traffictypediagnostic: VI1PR1001MB1374:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR1001MB1374B08B3282A7BAFBCDCBF8AB310@VI1PR1001MB1374.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ONPgfbeeKwjzNvIFoDXb391vE22Gf14gF6CNVVzH7TVjTo63to0VkY89NWKOJQPP1lvJ7Amylw3ymPPewTJLTaznqLK+o73GFcCr2fGbJ8HPy29gAooMPwDoYoiEwrB7ESJNlbwsdgcqllAcaHHjmZQXPXgkU12eP9JK1wRK8jD6yEp7H/TOENatbsvmEZtYXE/7CJeeHO/NgZzsLSqjGyJo7nsQkqQtbMo9wmfrLABauF5NFLo2QaM5LZALf+ufQGI6m9WPuLpNy0Ttz8pThd4wxNhVBVkwvUosU3APt+8yod46t+9qm2uZgGGogVZASpZvT0b/d5lTE3dVMnkw7iUdq2Ze1gisFEm1Xudr+VJ6bLKVNnAKeQHirUfRr/Lx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(53546011)(83380400001)(55016002)(6506007)(55236004)(8676002)(4326008)(9686003)(5660300002)(86362001)(8936002)(71200400001)(66946007)(66446008)(26005)(66476007)(76116006)(64756008)(478600001)(2906002)(52536014)(186003)(7696005)(54906003)(7416002)(66556008)(316002)(33656002)(110136005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /iOCysbSqRMWZ1N4+wFD23XC8qacR+klQJ5y9ynzN5n7sxUx7FbvLevXg4FpZc24usSSZH+FVxwqzbjlC1hgR12ZvdTqW23WEmFIlBFUntk/GBNKP+fm2wpdIpy2w26C4uPuh9wfPE6OS/aUGhvUKBIpLLHrxygCwRh98yK2YYH0zkn+PygauZ0NLxMlIy5a9S8p2/Ucx/8LcTJs9ZmQtI41qgwttcxfU1ulNGcmBcfDGV0KzrmT/5qzJLcEsLDUyS/cBy6teXEKlrJ0tVGf7cYt7yLau3xsD3S9wDuoTUeDz/3uR8pI+T7FMhb0jhSJoFlSwySf2IvZbA1+K8RjabjI2ppqLSUSmektDyWPhmkzyCcgp3NngFRnPFwKyR+SZW0yA/5WsdNWNm5GReQtX9/IKHN/LkF7nKxRjN1ePwRqSztp1MFPeTo7mpQpX+vZUTpzC3/TIM/vR1wzK+6q/T7nmRqmi4dYUjVWAsblDHd8J6jygUGWgges8oq6HAiYFVHDoLnXY6xJEg+Ho82SZ3o5CzaHckDlQyCfsgR4bRqZsk/JbhbcsKCnfpRIMXFQc91MDZs4KkqbCZbQKB12D0itT2BQUDgI/yDDp4vwZDJHmKcoWxIR8HqK/7i9h+ZrNLPsYYbcBFztgdA+ld6cfQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6722AF8767E1664DAD2D9AD459D97471@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb4bd83-325e-4bf4-f425-08d8670d4e06
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 19:56:50.9892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJRHbdGPOSKxDwDthMRz+rpD7b6BZojqMqo8t7ifzNkTadFkLiwbowYK3nQEtx/msa/8kxM1yNYH9O2bEfeNBt9WcF8zvDXjQ56RCjhvXZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDAyLzEwLzIwMjAgMjE6MDEsIFZpbmljaXVzIENvc3RhIEdvbWVzIHdyb3RlOg0KPiBI
aSBFcmV6LA0KPg0KPiBFcmV6IEdldmEgPGVyZXouZ2V2YS5leHRAc2llbWVucy5jb20+IHdyaXRl
czoNCj4NCj4+IEFkZCBzdXBwb3J0IGZvciB1c2luZyBQVFAgY2xvY2sgd2l0aA0KPj4gICBUcmFm
ZmljIGNvbnRyb2wgRWFybGllc3QgVHhUaW1lIEZpcnN0IChFVEYpIFFkaXNjLg0KPj4NCj4+IFdo
eSBkbyB3ZSBuZWVkIEVURiB0byB1c2UgUFRQIGNsb2NrPw0KPj4gQ3VycmVudCBFVEYgcmVxdWly
ZXMgdG8gc3luY2hyb25pemF0aW9uIHRoZSBzeXN0ZW0gY2xvY2sNCj4+ICAgdG8gdGhlIFBUUCBI
YXJkd2FyZSBjbG9jayAoUEhDKSB3ZSB3YW50IHRvIHNlbmQgdGhyb3VnaC4NCj4+IEJ1dCB0aGVy
ZSBhcmUgY2FzZXMgdGhhdCB3ZSBjYW4gbm90IHN5bmNocm9uaXplIHRoZSBzeXN0ZW0gY2xvY2sg
d2l0aA0KPj4gICB0aGUgZGVzaXJlIE5JQyBQSEMuDQo+PiAxLiBXZSB1c2Ugc2V2ZXJhbCBOSUNz
IHdpdGggc2V2ZXJhbCBQVFAgZG9tYWlucyB0aGF0IG91ciBkZXZpY2UNCj4+ICAgICAgaXMgbm90
IGFsbG93ZWQgdG8gYmUgUFRQIG1hc3Rlci4NCj4+ICAgICBBbmQgd2UgYXJlIG5vdCBhbGxvd2Vk
IHRvIHN5bmNocm9uaXplIHRoZXNlIFBUUCBkb21haW5zLg0KPj4gMi4gV2UgYXJlIHVzaW5nIGFu
b3RoZXIgY2xvY2sgc291cmNlIHdoaWNoIHdlIG5lZWQgZm9yIG91ciBzeXN0ZW0uDQo+PiAgICAg
WWV0IG91ciBkZXZpY2UgaXMgbm90IGFsbG93ZWQgdG8gYmUgUFRQIG1hc3Rlci4NCj4+IFJlZ2Fy
ZGxlc3Mgb2YgdGhlIGV4YWN0IHRvcG9sb2d5LCBhcyB0aGUgTGludXggdHJhZGl0aW9uIGlzIHRv
IGFsbG93DQo+PiAgIHRoZSB1c2VyIHRoZSBmcmVlZG9tIHRvIGNob29zZSwgd2UgcHJvcG9zZSBh
IHBhdGNoIHRoYXQgd2lsbCBhbGxvdw0KPj4gICB0aGUgdXNlciB0byBjb25maWd1cmUgdGhlIFRD
LUVURiB3aXRoIGEgUFRQIGNsb2NrIGFzIHdlbGwgYXMNCj4+ICAgdXNpbmcgdGhlIHN5c3RlbSBj
bG9jay4NCj4+ICogTk9URTogd2UgZG8gZW5jb3VyYWdlIHRoZSB1c2VycyB0byBzeW5jaHJvbml6
ZSB0aGUgc3lzdGVtIGNsb2NrIHdpdGgNCj4+ICAgIGEgUFRQIGNsb2NrLg0KPj4gICBBcyB0aGUg
RVRGIHdhdGNoZG9nIHVzZXMgdGhlIHN5c3RlbSBjbG9jay4NCj4+ICAgU3luY2hyb25pemluZyB0
aGUgc3lzdGVtIGNsb2NrIHdpdGggYSBQVFAgY2xvY2sgd2lsbCBwcm9iYWJseQ0KPj4gICAgcmVk
dWNlIHRoZSBmcmVxdWVuY3kgZGlmZmVyZW50IG9mIHRoZSBQSEMgYW5kIHRoZSBzeXN0ZW0gY2xv
Y2suDQo+PiAgIEFzIHNlcXVlbmNlLCB0aGUgdXNlciBtaWdodCBiZSBhYmxlIHRvIHJlZHVjZSB0
aGUgRVRGIGRlbHRhIHRpbWUNCj4+ICAgIGFuZCB0aGUgcGFja2V0cyBsYXRlbmN5IGNyb3NzIHRo
ZSBuZXR3b3JrLg0KPj4NCj4+IEZvbGxvdyB0aGUgZGVjaXNpb24gdG8gZGVyaXZlIGEgZHluYW1p
YyBjbG9jayBJRCBmcm9tIHRoZSBmaWxlIGRlc2NyaXB0aW9uDQo+PiAgIG9mIGFuIG9wZW5lZCBQ
VFAgY2xvY2sgZGV2aWNlIGZpbGUuDQo+PiBXZSBwcm9wb3NlIGEgc2ltcGxlIHdheSB0byB1c2Ug
dGhlIGR5bmFtaWMgY2xvY2sgSUQgd2l0aCB0aGUgRVRGIFFkaXNjLg0KPj4gV2Ugd2lsbCBzdWJt
aXQgYSBwYXRjaCB0byB0aGUgInRjIiB0b29sIGZyb20gdGhlIGlwcm91dGUyIHByb2plY3QNCj4+
ICAgb25jZSB0aGlzIHBhdGNoIGlzIGFjY2VwdGVkLg0KPj4NCj4NCj4gSW4gYWRkaXRpb24gdG8g
d2hhdCBUaG9tYXMgc2FpZCwgSSB3b3VsZCBsaWtlIHRvIGFkZCBzb21lIHRob3VnaHRzDQo+ICht
b3N0bHkgcmUtd29yZGluZyBzb21lIG9mIFRob21hcycgY29tbWVudHMgOi0pKS4NCj4NCj4gSSB0
aGluayB0aGF0IHRoZXJlJ3MgYW4gdW5kZXJseWluZyBwcm9ibGVtL2xpbWl0YXRpb24gdGhhdCBp
cyB0aGUgY2F1c2UNCj4gb2YgdGhlIGlzc3VlIChvciBhdCBsZWFzdCBhIHN0ZXAgaW4gdGhlIHJp
Z2h0IGRpcmVjdGlvbikgeW91IGFyZSB0cnlpbmcNCj4gdG8gc29sdmU6IHRoZSBpc3N1ZSBpcyB0
aGF0IFBUUCBjbG9ja3MgY2FuJ3QgYmUgdXNlZCBhcyBocnRpbWVycy4NCj4NCj4gSSBkaWRuJ3Qg
c3BlbmQgYSBsb3Qgb2YgdGltZSB0aGlua2luZyBhYm91dCBob3cgdG8gc29sdmUgdGhpcyAodGhl
IG9ubHkNCj4gdGhpbmcgdGhhdCBjb21lcyB0byBtaW5kIGlzIGhhdmluZyBhIHRpbWVjb3VudGVy
LCBvciBzaW1pbGFyLCAic29mdHdhcmUNCj4gdmlldyIgb3ZlciB0aGUgUEhDIGNsb2NrKS4NCj4N
Cj4gQW55d2F5LCBteSBmZWVsaW5nIGlzIHRoYXQgdW50aWwgdGhpcyBpcyBzb2x2ZWQsIHdlIHdv
dWxkIG9ubHkgYmUNCj4gd29ya2luZyBhcm91bmQgdGhlIHByb2JsZW0sIGFuZCBjcmVhdGluZyBl
dmVuIG1vcmUgaGFyZCB0byBoYW5kbGUgY29ybmVyDQo+IGNhc2VzLg0KPg0KPg0KPiBDaGVlcnMs
DQo+DQoNCllvdSBhcmUgcmlnaHQuDQoNClRoYW5rcyBmb3IgdGhlIGluc2lnaHQuDQoNCkVyZXoN
Cg==
