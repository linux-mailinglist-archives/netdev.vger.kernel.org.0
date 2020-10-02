Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26A32810E6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgJBLFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:05:08 -0400
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:23702
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726569AbgJBLFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcpZ/A9F7PG1DNbj9zYLAtVfPjbc3QWXodb/uziFAl3Z2NZ8IMb4AjwCE9ILI3NDAXXdlZJxKBaIgwoEbObfsey2Q6weZsWbQFv/SQfHZpSHCQoYeb3CJ41L23Jnplx/IqBKaEsqcq3xA4iGpRlHZxwE03i896zQjdZqM5+XTWyadRcyLohme+wYvB2LNpqh5pQGRwVBYz8BOc7JIe/7PgNpZldCGp7Hr7Z2Zoup2mBSIRK4RMwkHkY/r2KvFprXXt8xs4/ezpR6pxWk9Z2rzTtiwOjcbFiChF0NXxfoEdEd7Hi7W6XDFN1zmVkKcTIeKsCInyCh4oC3xebrbT/wog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NutZWuV8b7OwFe60V8GwsvJh/vm0IYKe4daMJZ6TgEo=;
 b=H7Rg0QP39z/teMA9Dr237lVQXl5AVhCrILfANGdO7+c9pig2zBeCg2NzidzP7RV6+pLkuFJ6gOtt4BHTLWnEUsdFkYnajfz8bQLMLzE+VMbmatshp+L5lD1r8ciOxeD84xV2KhuO0t7mGdYuKQMcYClEaYmhamisxDJMXSQtlZ+zRuzqLEg6011gbr4OWmWQPKa26DhiMrK0Jp8CzCNL1KNYsFTf5649htyGfVFeoBfNcQbgjav933wY/Eir4CVDk2mZgfc2IbgDIO8gdYxhkZW5ZkYVpms3EdWGvTMyUJvzAI+zMPoG1jMRC/q0R9MemdwwJL++vmJBCYSlDl0B+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NutZWuV8b7OwFe60V8GwsvJh/vm0IYKe4daMJZ6TgEo=;
 b=FqATZTZYip3PD6QIAnN+I1JhAM7v8Zp4BInaLHCrfp1MP8RZSzxA0v5AwshusFJsQZlO3wEZN42w3JFHrU0zBmgniOd5nrcNp34dEfiStBkxZJ6EVZAfZN9Pf0byR1jO534ZlvOtqRyNtPdv2ggRkfEg6Decc1tbinbZC0DD9/o=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VE1PR10MB3424.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:10f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Fri, 2 Oct
 2020 11:05:01 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b80e:490f:a2d4:7e6b]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b80e:490f:a2d4:7e6b%4]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 11:05:01 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
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
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
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
Subject: Re: [PATCH 7/7] TC-ETF support PTP clocks
Thread-Topic: [PATCH 7/7] TC-ETF support PTP clocks
Thread-Index: AQHWmDTFnLS2WKiWskGuj3Ze325AyamDdsaAgACwRYA=
Date:   Fri, 2 Oct 2020 11:05:01 +0000
Message-ID: <VI1PR10MB244671875D9A041C2F9018AFAB310@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
 <20201001205141.8885-8-erez.geva.ext@siemens.com>
 <87a6x5eabi.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87a6x5eabi.fsf@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-document-confidentiality: NotClassified
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.27.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15b7dce1-f6d1-4c84-9675-08d866c3023e
x-ms-traffictypediagnostic: VE1PR10MB3424:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR10MB34246E33FEA83F9763D3E468AB310@VE1PR10MB3424.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7PTKDthESW2+8f4WKfukHkrZpV5NQTZ0fM9VA7W7n1x65fZIDW1cD9jskKyxBrpadNiJXteEz8qq0uUYAhkPO4FAwCgu/qET50to9pBI6x8oYaifEcOJofkSINGQ/lrEeUJz7VTx2EB6KBvfxqU9C4c9XogFw8EIivo/ZqWc+rHZGaNtCy6ep2gqZ05Bt2lDueRKeJwQhKrwYsJf0uz1DLE7TgBBOr0fBWWtj0Oq86SgHUoUxsVUGNEF1xGbjCspXQXCUpsRpXGSCQ0ZL2Oukem6RjYLiXGQAg2+p3Imd48tVHvukKsl16s2a9IqHpRyDWhZ+BoYdFuWm9Xf8u9zcyfQOO8dcbjDt4qzKTqVPsQ51ZcykN0SnjfGUGD6h9c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(186003)(8936002)(52536014)(66476007)(478600001)(54906003)(6506007)(9686003)(110136005)(66946007)(86362001)(64756008)(66446008)(66556008)(33656002)(53546011)(26005)(55236004)(7696005)(71200400001)(7416002)(83380400001)(316002)(55016002)(2906002)(76116006)(5660300002)(4326008)(8676002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: saMhMZacxLSm9Fp/C9YLWV6D3HbkPkW6IaXzKF6vajT2fijR/LAq7VId3rI6gLCbGtzkPFSznCRvo6dy/z9Ya8TffOEvBjKs+As12AM3Ur6T/2mIn16SPTljmbInHEuPJSFyXszozP9wP4HW7UpamxxpU609i59dVPVYG2eHNRPzRIeCHKiYQFaoPDekFmY0Qdg+eUws19IwCji4cZ2/OJGZR0Tb/dXszLuDObC7FJbPUISV1w57apv7UY98duvXVuy/9H7ZQjRsvllZwWl5wS0l7u84sEvIfSOBXVk/uq+MIkYgrSIptbkkwnwcnF70m0mNIwI3nCd++dYgPevZrQyDsTwch8Q/KDaQXheCYhhAIrd1j8+CkQhWhc0Z7TiO7ODc5jFMuPwAMJkg8CyOz0Wp80nFQkK08nXIrjt9XqXpoyPITQ/+0WR+OF714n27QUHNiiFNJFBLvOrdNd8H03y46k/EravqLwjaMH//INZS2S6zZ69Yujxq5rkDKPVxLydc37E7bgUcctjGhM3bAXJfsEfjfvMl6/WKQ2W0qfpgXpd+7BnaWAfM/jPD3bEIv7GrP/9+VE4zJk8Xlj2I5luNcHF21SynGYruLVb81hG4idy9L+1WJ9JWYcsyJkY/JJp86/6VX6IRs9iGd0eWgA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F15A1475FE2DA42B26FC9BD6C4D6912@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b7dce1-f6d1-4c84-9675-08d866c3023e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 11:05:01.4497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5TCsBiA+voekFHFlZgbG0s11ACWNINV109JEEtB7DdfdviaCEMObLT5Tu0G0Otj2CfUfgtBFpJnWCGGfO+Oqg88jgf6BX4aNQdNXopcYo30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR10MB3424
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDAyLzEwLzIwMjAgMDI6MzMsIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4gT24gVGh1
LCBPY3QgMDEgMjAyMCBhdCAyMjo1MSwgRXJleiBHZXZhIHdyb3RlOg0KPg0KPj4gICAgLSBBZGQg
c3VwcG9ydCBmb3IgdXNpbmcgYSBQT1NJWCBkeW5hbWljIGNsb2NrIHdpdGgNCj4+ICAgICAgVHJh
ZmZpYyBjb250cm9sIEVhcmxpZXN0IFR4VGltZSBGaXJzdCAoRVRGKSBRZGlzYy4NCj4NCj4gLi4u
Lg0KPg0KPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L25ldF90c3RhbXAuaA0KPj4gKysrIGIv
aW5jbHVkZS91YXBpL2xpbnV4L25ldF90c3RhbXAuaA0KPj4gQEAgLTE2Nyw2ICsxNjcsMTEgQEAg
ZW51bSB0eHRpbWVfZmxhZ3Mgew0KPj4gICAgICBTT0ZfVFhUSU1FX0ZMQUdTX01BU0sgPSAoU09G
X1RYVElNRV9GTEFHU19MQVNUIC0gMSkgfA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgU09GX1RYVElNRV9GTEFHU19MQVNUDQo+PiAgIH07DQo+PiArLyoNCj4+ICsgKiBDbG9jayBJ
RCB0byB1c2Ugd2l0aCBQT1NJWCBjbG9ja3MNCj4+ICsgKiBUaGUgSUQgbXVzdCBiZSB1OCB0byBm
aXQgaW4gKHN0cnVjdCBzb2NrKS0+c2tfY2xvY2tpZA0KPj4gKyAqLw0KPj4gKyNkZWZpbmUgU09G
X1RYVElNRV9QT1NJWF9DTE9DS19JRCAoMHg3NykNCj4NCj4gUmFuZG9tIG51bWJlciB3aXRoIGEg
cmFuZG9tIG5hbWUuDQo+DQo+PiAgIHN0cnVjdCBzb2NrX3R4dGltZSB7DQo+PiAgICAgIF9fa2Vy
bmVsX2Nsb2NraWRfdCAgICAgIGNsb2NraWQ7LyogcmVmZXJlbmNlIGNsb2NraWQgKi8NCj4+IGRp
ZmYgLS1naXQgYS9uZXQvc2NoZWQvc2NoX2V0Zi5jIGIvbmV0L3NjaGVkL3NjaF9ldGYuYw0KPj4g
aW5kZXggYzBkZTRjNmY5Mjk5Li44ZTNlMGE2MWZhNTggMTAwNjQ0DQo+PiAtLS0gYS9uZXQvc2No
ZWQvc2NoX2V0Zi5jDQo+PiArKysgYi9uZXQvc2NoZWQvc2NoX2V0Zi5jDQo+PiBAQCAtMTUsNiAr
MTUsNyBAQA0KPj4gICAjaW5jbHVkZSA8bGludXgvcmJ0cmVlLmg+DQo+PiAgICNpbmNsdWRlIDxs
aW51eC9za2J1ZmYuaD4NCj4+ICAgI2luY2x1ZGUgPGxpbnV4L3Bvc2l4LXRpbWVycy5oPg0KPj4g
KyNpbmNsdWRlIDxsaW51eC9wb3NpeC1jbG9jay5oPg0KPj4gICAjaW5jbHVkZSA8bmV0L25ldGxp
bmsuaD4NCj4+ICAgI2luY2x1ZGUgPG5ldC9zY2hfZ2VuZXJpYy5oPg0KPj4gICAjaW5jbHVkZSA8
bmV0L3BrdF9zY2hlZC5oPg0KPj4gQEAgLTQwLDE5ICs0MSw0MCBAQCBzdHJ1Y3QgZXRmX3NjaGVk
X2RhdGEgew0KPj4gICAgICBzdHJ1Y3QgcmJfcm9vdF9jYWNoZWQgaGVhZDsNCj4+ICAgICAgc3Ry
dWN0IHFkaXNjX3dhdGNoZG9nIHdhdGNoZG9nOw0KPj4gICAgICBrdGltZV90ICgqZ2V0X3RpbWUp
KHZvaWQpOw0KPj4gKyNpZmRlZiBDT05GSUdfUE9TSVhfVElNRVJTDQo+PiArICAgIHN0cnVjdCBw
b3NpeF9jbG9jayAqcGNsb2NrOyAvKiBwb2ludGVyIHRvIGEgcG9zaXggY2xvY2sgKi8NCj4NCj4g
VGFpbCBjb21tZW50cyBzdWNrIGJlY2F1c2UgdGhleSBkaXN0dXJiIHRoZSByZWFkaW5nIGZsb3cg
YW5kIHRoaXMNCj4gY29tbWVudCBoYXMgYWJzb2x1dGUgemVybyB2YWx1ZS4NCj4NCj4gQ29tbWVu
dHMgYXJlIHJlcXVpcmVkIHRvIGV4cGxhaW4gdGhpbmdzIHdoaWNoIGFyZSBub3Qgb2J2aW91cy4u
Lg0KPg0KPj4gKyNlbmRpZiAvKiBDT05GSUdfUE9TSVhfVElNRVJTICovDQo+DQo+IEFsc28gdGhp
cyAjaWZkZWZmZXJ5IGlzIGJvbmtlcnMuIEhvdyBpcyBUU04gc3VwcG9zZWQgdG8gd29yayB3aXRo
b3V0DQo+IFBPU0lYX1RJTUVSUyBpbiB0aGUgZmlyc3QgcGxhY2U/DQo+DQo+PiAgIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbmxhX3BvbGljeSBldGZfcG9saWN5W1RDQV9FVEZfTUFYICsgMV0gPSB7DQo+
PiAgICAgIFtUQ0FfRVRGX1BBUk1TXSA9IHsgLmxlbiA9IHNpemVvZihzdHJ1Y3QgdGNfZXRmX3Fv
cHQpIH0sDQo+PiAgIH07DQo+Pg0KPj4gK3N0YXRpYyBpbmxpbmUga3RpbWVfdCBnZXRfbm93KHN0
cnVjdCBRZGlzYyAqc2NoLCBzdHJ1Y3QgZXRmX3NjaGVkX2RhdGEgKnEpDQo+PiArew0KPj4gKyNp
ZmRlZiBDT05GSUdfUE9TSVhfVElNRVJTDQo+PiArICAgIGlmIChJU19FUlJfT1JfTlVMTChxLT5n
ZXRfdGltZSkpIHsNCj4+ICsgICAgICAgICAgICBzdHJ1Y3QgdGltZXNwZWM2NCB0czsNCj4+ICsg
ICAgICAgICAgICBpbnQgZXJyID0gcG9zaXhfY2xvY2tfZ2V0dGltZShxLT5wY2xvY2ssICZ0cyk7
DQo+PiArDQo+PiArICAgICAgICAgICAgaWYgKGVycikgew0KPj4gKyAgICAgICAgICAgICAgICAg
ICAgcHJfd2FybigiQ2xvY2sgaXMgZGlzYWJsZWQgKCVkKSBmb3IgcXVldWUgJWRcbiIsDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVyciwgcS0+cXVldWUpOw0KPj4gKyAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIDA7DQo+DQo+IFRoYXQncyByZWFsbHkgdXNlZnVsIGVycm9yIGhh
bmRsaW5nLg0KPg0KPj4gKyAgICAgICAgICAgIH0NCj4+ICsgICAgICAgICAgICByZXR1cm4gdGlt
ZXNwZWM2NF90b19rdGltZSh0cyk7DQo+PiArICAgIH0NCj4+ICsjZW5kaWYgLyogQ09ORklHX1BP
U0lYX1RJTUVSUyAqLw0KPj4gKyAgICByZXR1cm4gcS0+Z2V0X3RpbWUoKTsNCj4+ICt9DQo+PiAr
DQo+PiAgIHN0YXRpYyBpbmxpbmUgaW50IHZhbGlkYXRlX2lucHV0X3BhcmFtcyhzdHJ1Y3QgdGNf
ZXRmX3FvcHQgKnFvcHQsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
c3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPj4gICB7DQo+PiAgICAgIC8qIENoZWNr
IGlmIHBhcmFtcyBjb21wbHkgdG8gdGhlIGZvbGxvd2luZyBydWxlczoNCj4+ICAgICAgICogICAg
ICAqIENsb2NraWQgYW5kIGRlbHRhIG11c3QgYmUgdmFsaWQuDQo+PiAgICAgICAqDQo+PiAtICAg
ICAqICAgICAgKiBEeW5hbWljIGNsb2NraWRzIGFyZSBub3Qgc3VwcG9ydGVkLg0KPj4gKyAgICAg
KiAgICAgICogRHluYW1pYyBDUFUgY2xvY2tpZHMgYXJlIG5vdCBzdXBwb3J0ZWQuDQo+PiAgICAg
ICAqDQo+PiAgICAgICAqICAgICAgKiBEZWx0YSBtdXN0IGJlIGEgcG9zaXRpdmUgb3IgemVybyBp
bnRlZ2VyLg0KPj4gICAgICAgKg0KPj4gQEAgLTYwLDExICs4MiwyMiBAQCBzdGF0aWMgaW5saW5l
IGludCB2YWxpZGF0ZV9pbnB1dF9wYXJhbXMoc3RydWN0IHRjX2V0Zl9xb3B0ICpxb3B0LA0KPj4g
ICAgICAgKiBleHBlY3QgdGhhdCBzeXN0ZW0gY2xvY2tzIGhhdmUgYmVlbiBzeW5jaHJvbml6ZWQg
dG8gUEhDLg0KPj4gICAgICAgKi8NCj4+ICAgICAgaWYgKHFvcHQtPmNsb2NraWQgPCAwKSB7DQo+
PiArI2lmZGVmIENPTkZJR19QT1NJWF9USU1FUlMNCj4+ICsgICAgICAgICAgICAvKioNCj4+ICsg
ICAgICAgICAgICAgKiBVc2Ugb2YgUFRQIGNsb2NrIHRocm91Z2ggYSBwb3NpeCBjbG9jay4NCj4+
ICsgICAgICAgICAgICAgKiBUaGUgVEMgYXBwbGljYXRpb24gbXVzdCBvcGVuIHRoZSBwb3NpeCBj
bG9jayBkZXZpY2UgZmlsZQ0KPj4gKyAgICAgICAgICAgICAqIGFuZCB1c2UgdGhlIGR5bmFtaWMg
Y2xvY2tpZCBmcm9tIHRoZSBmaWxlIGRlc2NyaXB0aW9uLg0KPg0KPiBXaGF0PyBIb3cgaXMgdGhl
IGNvZGUgd2hpY2ggY2FsbHMgaW50byB0aGlzIGd1YXJhbnRlZWQgdG8gaGF2ZSBhIHZhbGlkDQo+
IGZpbGUgZGVzY3JpcHRvciBvcGVuIGZvciBhIHBhcnRpY3VsYXIgZHluYW1pYyBwb3NpeCBjbG9j
az8NCj4NCj4+ICsgICAgICAgICAgICAgKi8NCj4+ICsgICAgICAgICAgICBpZiAoIWlzX2Nsb2Nr
aWRfZmRfY2xvY2socW9wdC0+Y2xvY2tpZCkpIHsNCj4+ICsgICAgICAgICAgICAgICAgICAgIE5M
X1NFVF9FUlJfTVNHKGV4dGFjaywNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICJEeW5hbWljIENQVSBjbG9ja2lkcyBhcmUgbm90IHN1cHBvcnRlZCIpOw0KPj4gKyAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPj4gKyAgICAgICAgICAgIH0NCj4+
ICsjZWxzZSAvKiBDT05GSUdfUE9TSVhfVElNRVJTICovDQo+PiAgICAgICAgICAgICAgTkxfU0VU
X0VSUl9NU0coZXh0YWNrLCAiRHluYW1pYyBjbG9ja2lkcyBhcmUgbm90IHN1cHBvcnRlZCIpOw0K
Pj4gICAgICAgICAgICAgIHJldHVybiAtRU5PVFNVUFA7DQo+PiAtICAgIH0NCj4+IC0NCj4+IC0g
ICAgaWYgKHFvcHQtPmNsb2NraWQgIT0gQ0xPQ0tfVEFJKSB7DQo+PiArI2VuZGlmIC8qIENPTkZJ
R19QT1NJWF9USU1FUlMgKi8NCj4+ICsgICAgfSBlbHNlIGlmIChxb3B0LT5jbG9ja2lkICE9IENM
T0NLX1RBSSkgew0KPj4gICAgICAgICAgICAgIE5MX1NFVF9FUlJfTVNHKGV4dGFjaywgIkludmFs
aWQgY2xvY2tpZC4gQ0xPQ0tfVEFJIG11c3QgYmUgdXNlZCIpOw0KPj4gICAgICAgICAgICAgIHJl
dHVybiAtRUlOVkFMOw0KPj4gICAgICB9DQo+PiBAQCAtMTAzLDcgKzEzNiw3IEBAIHN0YXRpYyBi
b29sIGlzX3BhY2tldF92YWxpZChzdHJ1Y3QgUWRpc2MgKnNjaCwgc3RydWN0IGV0Zl9zY2hlZF9k
YXRhICpxLA0KPj4gICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4+DQo+PiAgIHNraXA6DQo+
PiAtICAgIG5vdyA9IHEtPmdldF90aW1lKCk7DQo+PiArICAgIG5vdyA9IGdldF9ub3coc2NoLCBx
KTsNCj4NCj4gWXVjay4NCj4NCj4gaXNfcGFja2V0X3ZhbGlkKCkgaXMgaW52b2tlZCB2aWE6DQo+
DQo+ICAgICAgX19kZXZfcXVldWVfeG1pdCgpDQo+ICAgICAgICBfX2Rldl94bWl0X3NrYigpDQo+
ICAgICAgICAgICBldGZfZW5xdWV1ZV90aW1lc29ydGVkbGlzdCgpDQo+ICAgICAgICAgICAgIGlz
X3BhY2tldF92YWxpZCgpDQo+DQo+IF9fZGV2X3F1ZXVlX3htaXQoKSBkb2VzDQo+DQo+ICAgICAg
ICAgcmN1X3JlYWRfbG9ja19iaCgpOw0KPg0KPiBhbmQgeW91ciBnZXRfbm93KCkgZG9lcw0KPg0K
PiAgICAgIHBvc2l4X2Nsb2NrX2dldHRpbWUoKQ0KPiAgICAgICAgICAgICAgIGRvd25fcmVhZCgm
Y2xrLT5yd3NlbSk7DQo+DQo+ICAgLS0tLT4gRkFJTA0KPg0KPiBkb3duX3JlYWQoKSBtaWdodCBz
bGVlcCBhbmQgY2Fubm90IGJlIGNhbGxlZCBmcm9tIGEgQkggZGlzYWJsZWQNCj4gcmVnaW9uLiBU
aGlzIGNsZWFybHkgaGFzIG5ldmVyIGJlZW4gdGVzdGVkIHdpdGggYW55IG1hbmRhdG9yeSBkZWJ1
Zw0KPiBvcHRpb24gZW5hYmxlZC4gV2h5IGFtIEkgbm90IHN1cnByaXNlZD8NCj4NCj4gQXNpZGUg
b2YgYWNjZXNzaW5nIFBDSCBjbG9jayBiZWluZyBzbG93IGF0IGhlbGwgdGhpcyBjYW5ub3QgZXZl
ciB3b3JrDQo+IGFuZCB0aGVyZSBpcyBubyB3YXkgdG8gbWFrZSBpdCB3b3JrIGluIGFueSBjb25z
aXN0ZW50IGZvcm0uDQo+DQo+IElmIHlvdSBoYXZlIHNldmVyYWwgTklDcyBvbiBzZXZlcmFsIFBD
SCBkb21haW5zIHRoZW4gYWxsIG9mIHRoZXNlDQo+IGRvbWFpbnMgc2hvdWxkIGhhdmUgb25lIHRo
aW5nIGluIGNvbW1vbjogQ0xPQ0tfVEFJIGFuZCB0aGUgZnJlcXVlbmN5Lg0KPg0KPiBJZiB0aGF0
J3Mgbm90IHRoZSBjYXNlIHRoZW4gdGhlIG92ZXJhbGwgc3lzdGVtIGRlc2lnbiBpcyBqdXN0IGJy
b2tlbiwNCj4gYnV0IHllcyBJJ20gYXdhcmUgb2YgdGhlIGZhY3QgdGhhdCBzb21lIGluZHVzdHJp
ZXMgZGVjaWRlZCB0byBoYXZlIHRoZWlyDQo+IG93biBkZWZpbml0aW9uIG9mIHRpbWUgYW5kIGZy
ZXF1ZW5jeSBqdXN0IGJlY2F1c2UgdGhleSBjYW4uDQo+DQo+IEhhbmRsaW5nIGRpZmZlcmVudCBz
dGFydGluZyBwb2ludHMgb2YgdGhlIGRvbWFpbnMgaW50ZXJwcmV0YXRpb24gb2YNCj4gIlRBSSIg
aXMgZG9hYmxlIGJlY2F1c2UgdGhhdCdzIGp1c3QgYW4gb2Zmc2V0LCBidXQgaGF2aW5nIGRpZmZl
cmVudA0KPiBmcmVxdWVuY2llcyBpcyBhIG5pZ2h0bWFyZS4NCj4NCj4gU28gaWYgc3VjaCBhIHRy
YWlud3JlY2sgaXMgYSB2YWxpZCB1c2UgY2FzZSB3aGljaCBuZWVkcyB0byBiZSBzdXBwb3J0ZWQN
Cj4gdGhlbiBqdXN0IGR1Y3QgdGFwaW5nIGl0IGludG8gdGhlIGNvZGUgaXMgbm90IGdvaW5nIHRv
IGZseS4NCj4NCj4gVGhlIG9ubHkgd2F5IHRvIG1ha2UgdGhpcyB3b3JrIGlzIHRvIHNpdCBkb3du
IGFuZCBhY3R1YWxseSBkZXNpZ24gYQ0KPiBtZWNoYW5pc20gd2hpY2ggYWxsb3dzIHRvIGNvcnJl
bGF0ZSB0aGUgdmFyaW91cyBub3Rpb25zIG9mIFBDSCB0aW1lIHdpdGgNCj4gdGhlIHN5c3RlbXMg
Q0xPQ0tfVEFJLCBpLmUuIHByb3ZpZGluZyBvZmZzZXQgYW5kIGZyZXF1ZW5jeSBjb3JyZWN0aW9u
Lg0KPg0KPiBBbHNvIHlvdSB3YW50IHRvIGV4cGxhaW4gaG93IHVzZXIgc3BhY2UgYXBwbGljYXRp
b25zIHNob3VsZCBkZWFsIHdpdGgNCj4gdGhlc2UgZGlmZmVyZW50IHRpbWUgZG9tYWlucyBpbiBh
IHNhbmUgd2F5Lg0KPg0KPiBUaGFua3MsDQo+DQo+ICAgICAgICAgIHRnbHgNCj4NCg0KVGhhbmsg
eW91IGZvciB5b3VyIHF1aWNrIGFuZCBkZXB0aCBmZWVkYmFjay4NCg0KRXJleg0K
