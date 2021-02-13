Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A443731A986
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBMBp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:45:57 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:47848 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhBMBpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:45:55 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D1gxLe010514;
        Fri, 12 Feb 2021 20:45:05 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hq424bex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 20:45:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyBzV7bJhYeKnnaoWz0QwC2rQKVA7/uQE1rQHLQJ6Op0Dr81gsU1RGMV5j0bRKC4m6zCPEfodsnhDQOxwJ9pI+hbFnYZje9RM0y0eQOpGEm2a3FPq34zt9jAcyiF2FZJ0IMm4KtgWhAlotYm/VSZkFp3Zjv9xArXvPqz844u6TPWHE3k4C0FkpQtr63LT+ccgriFCEKxyDNej5lngTAD2Ipddjgg8b78g4iOcv1x58LxD887z8Be9dCorwnX1q88fNOLBBkhHfjoY3+Dbs5t2cMr8GQdEGsaIe7hSPmwwyuRh2b/bnh/S2ZjKrzDJvr5frprYiBltJM7A2uTJv2Z7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJWPirM5XxVZP57x/ovXUjxpcoN4oBrfmk6tQi6KTbE=;
 b=GHZ2wszibAiYvYRdyizWmo5FQTopvGRu8KwN8t+EYTldoJCj67tnjeIkFtUsHB88ML90JAeOTlTJ8LajxznwbMLese3xzG0oO1CPpL/U+owutZl9aNhpIK9OfqTBXrRxl+FrusRxF06eVFrB6BWv9hajnkfrISO6ULm93YGGht3H1ZvAkGb+KyG8tguV+gF76xHUbc+rU+nS0AmH4glcoiBE0NpCDKLxnJ+q/usgMNzZreUVLDfZkHOTX2bweM/qZall7WB/iNUwUk5mpsJS3SYlM3AA42gJdAZ5dbSJxiQwIXE7Y8yrZF2zknFD3CjycqCKFAa2aHmOuAxt7Ju+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJWPirM5XxVZP57x/ovXUjxpcoN4oBrfmk6tQi6KTbE=;
 b=yXVT4OqfA6VSUreh6Gm5CeLJeOPE6LJ1E1waCxRlvKAWBW3qmGBA6GeeQL7xQ8exfJcMr1XdtqdLgA8gP/s48Zh56XDTVPmuRul9QtcdWyRkpu0Yf5bwox52pyQtuC7Ae8UC0x1VlWGZL/M3e0AczdkzQ4nvDAAxiMiyi6+Wi+Q=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2762.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Sat, 13 Feb
 2021 01:45:03 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.037; Sat, 13 Feb 2021
 01:45:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: Set proper
 1000BaseX/SGMII interface mode for BCM54616S
Thread-Topic: [PATCH net-next 1/2] net: phy: broadcom: Set proper
 1000BaseX/SGMII interface mode for BCM54616S
Thread-Index: AQHXAZ815Bv0185tZk2OOLz/DMtRNKpVSyMAgAAFUIA=
Date:   Sat, 13 Feb 2021 01:45:03 +0000
Message-ID: <6d854d63df7f81421e927e1cd7726a41fd870ee3.camel@calian.com>
References: <20210213002825.2557444-1-robert.hancock@calian.com>
         <20210213002825.2557444-2-robert.hancock@calian.com>
         <87f06cb4-3bee-3ccb-bb21-ce6943e75336@gmail.com>
In-Reply-To: <87f06cb4-3bee-3ccb-bb21-ce6943e75336@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61df8772-67c6-4952-368d-08d8cfc0fbbd
x-ms-traffictypediagnostic: YT1PR01MB2762:
x-microsoft-antispam-prvs: <YT1PR01MB2762C60FA8E2D223B878F216EC8A9@YT1PR01MB2762.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TnxzPM94i76GGOE58RGqPyGkuIFJawG9+nKmDw7mBuMqx7BLdBs57zZZLKrFVVQ8XAGp8qTxmSPNi0lHypNgWl8n4IhIu/BNX/DwbWskIERQff+t+PqwuAKIVsfGUqhX32LiGUh7hk5EWZO08YBXx7XU09DN3uO27FT6V4aQYfReF/KA4DJRcXfmn7OAxKDMrxYkJAT6qyYbVX9InS2HEIsEltFhegz+5pmV5typmeDMD3Kx+uUGEOQRs+OHCwuIrxRASai6dG1kCZqry6Z3s3fPkzoZdy+g56lzU7noSKnMULLTWDwQL1ShAxPW0XcgduJGy+djRYsjy0mkpbAOiMmOFHKEFdofAuWDfQfQwdsgZkqaWBH26/n3bQc1wf9WNMESEDah0lJjHJXsgJ5SApuUNvONjVWUfpsWfvSIUgQVYLREivUkM70qQQJ6METgWCbN1/AV9wVfdsJ3tN9+3oNJJFRoxfcgqOPeIGgVadhvivWvlpWVENbsYa/z52R1AkPMhUUJpJM1LldyT4LjOGJ1Xy+tlrScFdhVeFpmD4Nsq1uJS4F2uLq856zaZU/XgqfQNnsb+GzDYpHn2any/QueuwXVC7mtOp8Ji/ZPxoSFUcccgu5Ms2AnXlMha8o07koXZDAKy+aCDa6/Zsoq6ctdoZgTfQD8kNd2LcWgF4scSFBf9RjDcUTUCeXRhSIw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39850400004)(366004)(136003)(91956017)(66946007)(2906002)(44832011)(26005)(8936002)(6486002)(6512007)(66556008)(86362001)(2616005)(66476007)(64756008)(316002)(5660300002)(66446008)(186003)(110136005)(83380400001)(36756003)(53546011)(478600001)(8676002)(54906003)(6506007)(4326008)(966005)(15974865002)(71200400001)(76116006)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dUFOSzFJdnRzVGJ6cVdZdXR1NGpPQWY5U0srUzRjc3pzdE0raWdtRHpZV0o3?=
 =?utf-8?B?S0Z2djlvMjFNY0ZqYXhsUHEyS0M1VllMRmdMVTQrUVlPbkMyZE16dkJZTVZX?=
 =?utf-8?B?N3FOQ2c2dGYySGZzbW55U3hqNiswTHo4WnJORk9FTkdDZzhEbTJMWXkySUM4?=
 =?utf-8?B?VTdGR1J6QWNLR1VHcmRmVkczOWRDcVU2SHh0WURZemp5Njk4SG1vQUdGVVE0?=
 =?utf-8?B?V2R4MlZaMkcvTmdVYk5oT2V5WEpCZXpqK3ErdUl2VWRibWp1RmRhVW92a2lm?=
 =?utf-8?B?bitLRlpFazYrTzVDUFlLbGJxbER5OHNFcXoya0ljc3ZPMU9EUGtnL2tEaWty?=
 =?utf-8?B?RWFxVGVpUHJwTUtUUVVOSG1YZmN0cWlNUDFKc0svN0MzU0RUSEY1eEpSWVlM?=
 =?utf-8?B?RDdUVWF2NGlic1hhWmN1MWREQ3l2NmhRRTRRQi9Ed2YxNDZyYVpOMmE1OWtX?=
 =?utf-8?B?WEZWUEY3b3hnNmE2d2dxSkFoYngrMHN1TmNzQnZSNnZ4YnBYWFFNdmdkRWlv?=
 =?utf-8?B?WlRYamdDdFBnZWw0RmZBc1ozVWJBQ21XbThqVmg4ZW5qcG5LdytDNllqYXIz?=
 =?utf-8?B?M3FqM04reE90SHBjeHlOekFLeXpTemsrczhoSU1Tb0s5SnpPTWdZcnNwM3Fa?=
 =?utf-8?B?eU5pWGpPTkZaTFk4ODRFN01KSzAwYkRFVklYUHVqYk9CMTRxclR6UWdzeExi?=
 =?utf-8?B?NHcxVlpvcDBuQU5LQlRTT0ZsOTNoKzNCWXNsc1QwVTBFN0hNWXY5aDRRaXVB?=
 =?utf-8?B?ejBsOEhSc0QzdFVGc2drcW55bTV5UkUvclh0TUkxcnFxdHl1NFNBOXlobTh5?=
 =?utf-8?B?UlVMZ3QxbzBTTjR1eWwzMXUxaXdUU1AyRnh0N1BtVVJIeFVxNjRkS3pHSEhE?=
 =?utf-8?B?VmlZK0Y5akFpSjZsZkcvZ0duTk1ldmsvTEtCczZJUW5QRzFqYUVzWDNQeVRh?=
 =?utf-8?B?VDdkR09VNFowSzIzWkZJZkEyTjNPeEQ3ZkJ1SlZiZTQ4emliMTJRZDJaV3BG?=
 =?utf-8?B?dnRLdThFZ0VoNDBra296N3lBQ05jeUhWYmliYktWMWk4clRjTytsT3Ztc3pF?=
 =?utf-8?B?RXJ4cHZod1ZQNnh4UWxzNTRJUEJMWVlzTTBvWVBkVmFRVkRMcUlzTXZyU2VD?=
 =?utf-8?B?ZjRDK2ZaR2lEMXFiREw3S0M2WmcrVW1tdUVtNWthVkxnWkoyTTlZTUFvYjZj?=
 =?utf-8?B?S1E1TFZ0SlJBUGJCWHEwNFd0MnZGUExwNXJRVStVNWlZNTllQjRXWXJUaW5z?=
 =?utf-8?B?L0Q2RnRNYjBiL3dzR0xGMnlJdlZBZ1JQQ1FIQWJHK2FIazZCczBZUm53bXBr?=
 =?utf-8?B?UFVsUlJSQjVTYVl4bHJSRjN1cjNkWWc0YmZsR1BJL1JsM2dDSTdlTVhpYVU0?=
 =?utf-8?B?WXB6bFZzSUZrM3B4YWdKREhudUdoVXE3NmRjeEpwa1N4QUluY1Z0N1FzaFF1?=
 =?utf-8?B?bU5JcHk2c29LbERNV2RDWXBwb2IzVUo4cmNEdmRlRFkrYWQ0Q1pWbWJvbUZo?=
 =?utf-8?B?QlZPZ1E2RXYva1ZaNmYwMWw3UHJsNCt5aEIwQXNOZGt6L2hRbHQ4em5WaTJl?=
 =?utf-8?B?Yyt5ZHJmVWJuaHUxb2FMUlFJOVVQU1dzYi9BLzBaZGFXYkpIRXBzN3F5eUR5?=
 =?utf-8?B?WmUzZ1lpbmlCTkNmeldlcnpOR3NvYmVLNFdPUENyRm1oSSs1V1puK3AyVm5x?=
 =?utf-8?B?OFBhclJ4ZlQrS1NacldoMFVJdjVHNWM3SlRRdENBZlNPMWl0VVBVR09GZ3dN?=
 =?utf-8?Q?C9Wq4Y8IW7jHCGSF7iHvay/CIwoODroF+4S5Ol7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64401A3FAA6A2F44901C02EB2AA8369C@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 61df8772-67c6-4952-368d-08d8cfc0fbbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2021 01:45:03.6267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jt6U2csRV7Tv3VPFlzfbitM4npTmByCNjQxQ0Ee3iGdGSg+Z2iPfkwOM8eOgLmedTcYqX2hIiV8uWmWOUX07dWFUMtWW14iz3VPkUVbqtfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2762
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTEyIGF0IDE3OjI2IC0wODAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiANCj4gT24gMi8xMi8yMDIxIDQ6MjggUE0sICdSb2JlcnQgSGFuY29jaycgdmlhIEJDTS1L
RVJORUwtRkVFREJBQ0stTElTVCxQREwNCj4gd3JvdGU6DQo+ID4gVGhlIGRlZmF1bHQgY29uZmln
dXJhdGlvbiBmb3IgdGhlIEJDTTU0NjE2UyBQSFkgbWF5IG5vdCBtYXRjaCB0aGUgZGVzaXJlZA0K
PiA+IG1vZGUgd2hlbiB1c2luZyAxMDAwQmFzZVggb3IgU0dNSUkgaW50ZXJmYWNlIG1vZGVzLCBz
dWNoIGFzIHdoZW4gaXQgaXMgb24NCj4gPiBhbiBTRlAgbW9kdWxlLiBBZGQgY29kZSB0byBleHBs
aWNpdGx5IHNldCB0aGUgY29ycmVjdCBtb2RlIHVzaW5nDQo+ID4gcHJvZ3JhbW1pbmcgc2VxdWVu
Y2VzIHByb3ZpZGVkIGJ5IEJlbC1GdXNlOg0KPiA+IA0KPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5j
b20vdjMvX19odHRwczovL3d3dy5iZWxmdXNlLmNvbS9yZXNvdXJjZXMvZGF0YXNoZWV0cy9wb3dl
cnNvbHV0aW9ucy9kcy1icHMtc2ZwLTFnYnQtMDUtc2VyaWVzLnBkZl9fOyEhSU9Hb3MwayEyMEZo
WnFSSEVpejItcUZKN0o4WEM0eFgycUctYWpaMTdNYTFXLVZ3RGd3ZFFaZUloSEVwV0tsTmxkV1c4
RHlGYVFvJCANCj4gPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly93d3cuYmVs
ZnVzZS5jb20vcmVzb3VyY2VzL2RhdGFzaGVldHMvcG93ZXJzb2x1dGlvbnMvZHMtYnBzLXNmcC0x
Z2J0LTA2LXNlcmllcy5wZGZfXzshIUlPR29zMGshMjBGaFpxUkhFaXoyLXFGSjdKOFhDNHhYMnFH
LWFqWjE3TWExVy1Wd0Rnd2RRWmVJaEhFcFdLbE5sZFdXNThLM2ZZNCQgDQo+ID4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jIHwgODMgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gPiAgaW5jbHVkZS9saW51eC9icmNtcGh5Lmgg
ICAgfCAgNCArKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDc1IGluc2VydGlvbnMoKyksIDEyIGRl
bGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvYnJvYWRj
b20uYyBiL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+ID4gaW5kZXggMDQ3MmIzNDcwYzU5
Li43ODU0MjU4MGYyYjIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L2Jyb2FkY29t
LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYw0KPiA+IEBAIC02NCw2ICs2
NCw2MyBAQCBzdGF0aWMgaW50IGJjbTU0NjEyZV9jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2Rldmlj
ZQ0KPiA+ICpwaHlkZXYpDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+ICANCj4gPiArc3Rh
dGljIGludCBiY201NDYxNnNfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikN
Cj4gPiArew0KPiA+ICsJaW50IHJjLCB2YWw7DQo+ID4gKw0KPiA+ICsJaWYgKHBoeWRldi0+aW50
ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSB8fA0KPiA+ICsJICAgIHBoeWRldi0+
aW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV8xMDAwQkFTRVgpIHsNCj4gDQo+IENhbiB5
b3UgcmV2ZXJzZSB0aGUgY29uZGl0aW9uIHNvIGFzIHRvIHNhdmUgYSBsZXZlbCBvZiBpZGVudGF0
aW9uPw0KDQpDYW4gZG8uDQoNCj4gDQo+ID4gKwkJLyogRW5zdXJlIHByb3BlciBpbnRlcmZhY2Ug
bW9kZSBpcyBzZWxlY3RlZC4gKi8NCj4gPiArCQkvKiBEaXNhYmxlIFJHTUlJIG1vZGUgKi8NCj4g
PiArCQl2YWwgPSBiY201NHh4X2F1eGN0bF9yZWFkKHBoeWRldiwNCj4gPiBNSUlfQkNNNTRYWF9B
VVhDVExfU0hEV1NFTF9NSVNDKTsNCj4gPiArCQlpZiAodmFsIDwgMCkNCj4gPiArCQkJcmV0dXJu
IHZhbDsNCj4gPiArCQl2YWwgJj0gfk1JSV9CQ001NFhYX0FVWENUTF9TSERXU0VMX01JU0NfUkdN
SUlfRU47DQo+ID4gKwkJcmMgPSBiY201NHh4X2F1eGN0bF93cml0ZShwaHlkZXYsDQo+ID4gTUlJ
X0JDTTU0WFhfQVVYQ1RMX1NIRFdTRUxfTUlTQywNCj4gPiArCQkJCQkgIHZhbCk7DQo+ID4gKwkJ
aWYgKHJjIDwgMCkNCj4gPiArCQkJcmV0dXJuIHJjOw0KPiANCj4gSSBkb24ndCB0aGluayB0aGlz
IHdyaXRlIGlzIG1ha2luZyBpdCB0aHJvdWdoIHNpbmNlIHlvdSBhcmUgbm90IHNldHRpbmcNCj4g
TUlJX0JDTTU0WFhfQVVYQ1RMX01JU0NfV1JFTiBpbiB2YWwsIEkga25vdyB0aGlzIGlzIGFuIGFu
bm95aW5nIGRldGFpbCwNCj4gYW5kIHdlIGNvdWxkIHByb2JhYmx5IGZvbGQgdGhhdCB0byBiZSB3
aXRoaW4gYmNtNTR4eF9hdXhjdGxfd3JpdGUoKQ0KPiBkaXJlY3RseSwgc2ltaWxhcmx5IHRvIHdo
YXQgYmNtX3BoeV93cml0ZV9zaGFkb3coKSBkb2VzLg0KDQpBaCwgaW5kZWVkLiBJIGFzc3VtZSB0
aGF0IGlzIHNwZWNpZmljIHRvIHRoZSBNSUlfQkNNNTRYWF9BVVhDVExfU0hEV1NFTF9NSVNDDQpy
ZWdpc3Rlcj8gSSBzdXBwb3NlIGJjbTU0eHhfYXV4Y3RsX3dyaXRlIGNvdWxkIGFkZCB0aGF0IGF1
dG9tYXRpY2FsbHkgZm9yDQp3cml0ZXMgdG8gdGhhdCByZWdpc3Rlci4gTm90IHN1cmUgaWYgdGhh
dCBpcyB0b28gbXVjaCBtYWdpYyBmb3IgdGhhdCBmdW5jdGlvbg0Kb3Igbm90Li4NCg0KPiANCj4g
VGhlIHJlc2V0IG9mIHRoZSBzZXF1ZW5jZSBhbmQgY2hhbmdlcyBsb29rcyBmaW5lIHRvIG1lLg0K
LS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2
YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
