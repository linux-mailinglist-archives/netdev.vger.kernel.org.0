Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0FE253CE0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 06:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH0EuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 00:50:06 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:27616
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbgH0EuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 00:50:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE9ppHVcGk4kOhwQMpG1D63tWJRZNPdrSfE4FrXZrEMX3CAJhXJ03vtA59miyi7M9jiCB9Jw1DJN0tjn5G5UqL413kA2kCfgrR1eAn0gIH6hh93itIIZd1jKHsSyWn5PZDh0voeCeypRm6rvBopfwEsxRhMJN+PBc1J8Nznp9IWSDrSkU/CjlsHwi8B7goCPsXGH5s3RV+XXJKk4gMMVGY9chE6oIeKvmG4fg+kOZ96Obx1tnevtWeEkNyGT1wduwlktov4i60PzZkD/m2b2KD8JBhFUEBAMgNtfzfZ7vboHH36I2UZpPhOBME9p7/9WwBC6illznUtEx2phGQWisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPupukfW0cdWq5zkm7LWxLzLoDPsb73fwQiicwAas2Y=;
 b=nmMcRWWnCvvxfSpWWqSeloyWWxvVCf/K0g9b38cYQi6nbHX83ciU1dmzlS2eWgCC9BfbRuvizUU52Jg20P2uhqK2cGq+ngzaLzn/XHxxGvwtpeT748TCOqXUdM/wfdtID8xjnScVR48eEGLdaOBsb7Q55SjPXLID1SLcqWuxeuOUvoadwmdKTKsOiJoG9PIaPVSGzGxCc9KDIJlvx2QriSAZkVi3ZRGNOvIxMhsRJuaRcsaSWXZ01Ql55x9CBzJ9ssDEeBQHjsmdsQkiNCRFw9KeefNllH4qH4GSagL6IquP+y91iPT3OwTFvpUIPUlgronrBfeSCZfxzUUWBX1x6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPupukfW0cdWq5zkm7LWxLzLoDPsb73fwQiicwAas2Y=;
 b=G8D/n8jJ30jDGj4o1UQIJlBVubavO8PxNYuvvxIoHPxm+zlRAbDfykavgV3E7XkzrLNgslAu3N//TIxaQaf545E+RzhpNCXkpAgPjv5/rZUwgYQ+4fClySJjEmAQ/apf6rjCIA/oXOaBjuheflxKPxCD6HgS9yEyVnbH2CFI+4s=
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com (2603:10a6:803:3d::27)
 by VI1PR0402MB3568.eurprd04.prod.outlook.com (2603:10a6:803:f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 04:50:00 +0000
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8937:c469:3af3:9666]) by VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8937:c469:3af3:9666%4]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 04:50:00 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     Brian Norris <briannorris@chromium.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC:     amit karwar <amitkarwar@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
Subject: RE: [EXT] Re: [PATCH v2] mwifiex: don't call del_timer_sync() on
 uninitialized timer
Thread-Topic: [EXT] Re: [PATCH v2] mwifiex: don't call del_timer_sync() on
 uninitialized timer
Thread-Index: AQHWekfYicXMahtYK0m70usVJQxeUalLY7Cg
Date:   Thu, 27 Aug 2020 04:50:00 +0000
Message-ID: <VI1PR04MB4366AFB378F2AC506D8565848F550@VI1PR04MB4366.eurprd04.prod.outlook.com>
References: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <CA+ASDXOHDU+SWmr+7aOUtbuzC22T-UWhZXJ5UXtcsev5ZTbqMw@mail.gmail.com>
In-Reply-To: <CA+ASDXOHDU+SWmr+7aOUtbuzC22T-UWhZXJ5UXtcsev5ZTbqMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [106.210.253.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32231a22-5b06-41eb-d9f4-08d84a44a7c8
x-ms-traffictypediagnostic: VI1PR0402MB3568:
x-microsoft-antispam-prvs: <VI1PR0402MB3568F2A951B1EC1CCB8D35428F550@VI1PR0402MB3568.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tpxsrNCM5eMR3e1DgxQtf7zsqYyt7zDRotdv83pv8C5kPVmW8zhybRBOeOsQQRZ41uuXHX5muV9qWRCglANgwjL8yY7ewTBeaFb4Eqyg6Icxrtq2p7iaaC1ZS3L/8KkYxd5ntSK3nUvfySg4fq/KP4dCsSWRmInvV/7mQH8x09wOBC2Q9Nrt2FjVGgeerwsbE/ygyXPtj/f9CvoQs037HL87CrYOCOLUirMJUtJXI69o3XbsSaAWJzBPjVPSqi8B9Zyf+V2GwmXYERm//9BqAfujarURClzzcKP03AUVzSmLzu+i6RFuac9fTcuB+7FQYJ1UxoEfNUqTV3UxOFwTEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4366.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(2906002)(64756008)(66446008)(4744005)(478600001)(86362001)(71200400001)(55016002)(33656002)(5660300002)(54906003)(52536014)(110136005)(66476007)(6506007)(55236004)(7696005)(66946007)(4326008)(66556008)(186003)(7416002)(76116006)(26005)(44832011)(8676002)(8936002)(316002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zZ98yJGILYtvckjHU1TuAdTR9ytvHbUL3Oyf3gqWmNKfo/ypCOCh7h3ZCD83pPgPyZ1yra2xw6pq5Svet+B5biyPup51ZbFmt/Ile9IzCpHCrWbAxlmMMy6t0wgwN3V8xAUH0WOe3jlcTSaDAw9ES1+KleZ5gD21f/iLdKtXKz9uCTFF2CF+Q40RJjPUxcr84z3tdxN+v2kSdMXv3TBBNRgJo/sBs1EihgDLgbd08M7kO+fqfsiAFRdTP4WvuhFB72jUipE0djE3prHOwhYjPFWNRWWyWHBPJY5qi9NG5y74FZPkx5V1zdBk6PolhIXas0l+eMk+J0eClcL6OOdRxyunu5euFx3NzEwDyxHryhe6GEmZ2sJ8HQm6NKzRnfLxfPYC5RFfzW8nTgaatLE16/nDHnEdo78BfEDwqks1vcNIBP76/fbKR+z/UzgzuGPLZVuQEsWBVO2622NzXjqenbf9eFqeSUpUbRCv04ye6aQxNO1gbY2CcKGZoKb2chqKxdxKCgDA1I6q5NCJVSFn1yvO6h07V9apGZieRIAlonI8DmDcFXApMC1P0Gef47mAenunwfJlndT9TvMxTO92bGNouyy2A+QfFSEK4/y89QVTN2dOUVLU4oGjxVjoSj8SnlXcs2VTwrwNI2PjXxYbLQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4366.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32231a22-5b06-41eb-d9f4-08d84a44a7c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 04:50:00.5435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0d2w+xuXsnTh2R9xjUFJjH3neN2ZxilHiclcJRkUzk26OqXoeVYzKIMlM4KtXw/x6HPMBtlYE08QsSmkSvNknQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3568
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVGV0c3VvLA0KDQo+ID4gImdyZXAgLUZyQjEgJ2RlbF90aW1lcicgZHJpdmVycy8gfCBncmVw
IC1GQTEgJy5mdW5jdGlvbiknIiBzYXlzIHRoYXQNCj4gPiBjdXJyZW50bHkgdGhlcmUgYXJlIDI4
IGxvY2F0aW9ucyB3aGljaCBjYWxsIGRlbF90aW1lcltfc3luY10oKSBvbmx5IGlmDQo+ID4gdGhh
dCB0aW1lcidzIGZ1bmN0aW9uIGZpZWxkIHdhcyBpbml0aWFsaXplZCAoYmVjYXVzZSB0aW1lcl9z
ZXR1cCgpDQo+ID4gc2V0cyB0aGF0IHRpbWVyJ3MgZnVuY3Rpb24gZmllbGQpLiBUaGVyZWZvcmUs
IGxldCdzIHVzZSBzYW1lIGFwcHJvYWNoIGhlcmUuDQoNClRoYW5rcyBmb3IgdGhlIGNoYW5nZSwg
aXQgbG9vayBjbGVhbmVyIHRoYW4gbXkgcmUtd29yazsNCg0KQWNrZWQtYnk6IEdhbmFwYXRoaSBC
aGF0IDxnYW5hcGF0aGkuYmhhdEBueHAuY29tPg0KDQpSZWdhcmRzLA0KR2FuYXBhdGhpDQo=
