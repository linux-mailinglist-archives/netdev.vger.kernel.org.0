Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF0431CE74
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhBPQxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:53:15 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:41251 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhBPQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:53:11 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GGkZAB016010;
        Tue, 16 Feb 2021 11:52:14 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gukt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 11:52:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyJNlS2/e8DG94JnSBBFSObt32k/bImLJGENVOFaUXzJugok6MKEvkLOUZy1j0LxISZeGjss9Yyw2KuxzCb9XpxqFaXR3qtQhgeX3WmuzxjueSGQbu5MncCZHuIu5MlusBhDlzJRgQENfeWBaxWhQZK7HlGVuu9ZFVU49brWReN6kjiqGSMhaEiBQ+wqMMDe+OmmHXtyvV70Y2oppMwwtomC9CbYkTSetAVEbBA5/IvPgdz9wsJdowMxYIghZjF96HHRubP03NR4wU5Dj4I7zU3uYVQml8kOaKM5gvf7wzStOMcRiaDIYtWyYfW1jO4VD3UpmKF7eTkYSU+jshk/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0ib+Y7vxxtkrObL2TbSO3ymVN4JA4vDithEf067Nz4=;
 b=eENrTMs+uUVmRJecFz1JEF/Nz67iVKrrc+HFpEGDZqUvzKQK1Tnn3IcfkQBhNXyEkpno+gjqtBaZv7z78ifywyXFw3e0wbuSc/yofVLgup4RTOCGHWXr9k0HnXgENwFz1NNsqbibE2ksglOOY9eRcM+mqGNLSVnUSAa2a2HaqOEz+4gnFF4n2Af6Gayo+Hhkn+elq27fCRNFfnVS9XumPi1/wNpafvEQmMsAgsjtGLrHzQyuyKBcFKGK297yzwqCfr1DcpGCH96uDNhJf4MJnjhQ8dbddvkv6xij1GzaECdxK6J/Jl+OcR80xXzQx5iF9IlhKR5Stz9UwK9nt3FlXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0ib+Y7vxxtkrObL2TbSO3ymVN4JA4vDithEf067Nz4=;
 b=uyfc95cfrKHVvf/BxXFvskDo/mcIfY28cpPVVkjeKg+cmBlr17IOsv15OTIOw1TSMlIkHWA+QEkGXaNRo9sE3zMehkQRBG8Gyr1+12B4UfVdP24CVXBMRIwLAJNNOcR5ri/KbxvwiuF5LQH7cxFKiiBkK8ruCi1bY1L+hbvMttE=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2558.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:15::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 16:52:13 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 16:52:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Thread-Topic: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Thread-Index: AQHXAa6bm2rDzLU5nkmgqe9J0QTszqpV51yAgAUdawA=
Date:   Tue, 16 Feb 2021 16:52:13 +0000
Message-ID: <fc3b75ed82a38b5fbf216893f52b3b24531db148.camel@calian.com>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
         <20210213021840.2646187-3-robert.hancock@calian.com>
         <20210213104537.GP1463@shell.armlinux.org.uk>
In-Reply-To: <20210213104537.GP1463@shell.armlinux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 371fd709-9053-474c-9b7b-08d8d29b35a4
x-ms-traffictypediagnostic: YTBPR01MB2558:
x-microsoft-antispam-prvs: <YTBPR01MB255808FBA754EF3CC027A7E4EC879@YTBPR01MB2558.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: koRswmS2IqotaPe1PjZlfgiOFpdQS+f3uCS6YBMdopsNl7ojew1AUBklFCICh0d/h1+5pqJj1MNpbDVhtio1T9UBldRsF46CwhZC3R9OZxpS0znlf1Gfr3UsG4NRjeqLLtAwhjStDkKCT1P/Z6OJwxFHUPlJ6nSa8BzyKZQ672gYF0AO6CaYh9OgqcOw83MQ2nt0KPqKWa7iwY3feoFtEiFfFHB0GuxWzNMgVUJE+UNSqlAG7iLZsUbYaoq48vdrH/iLtQTW4UwHr39mjVOjh2UuZKX2cByybm9q3gM1v1/lPXL0rBR0fVfOSFF2Pe9jwrpNqmmjO2FpVxW++82vJ8r7gj8Wl0R+JAm1kZM9uQ701w/+q2sOsiYjDzs4XpnJ+FtbG0FlTH6Nzu/LKDsyxo1HBSsicNqU0PnF6TLe0PSXDEFzgRN91aHHMNiGW+ZEY6d2+YYEck+TSwxLZiDAdiXlpy4+TQt/B6LnZEYaOuT0kEgYCt0xGYIrpPAYusn1JFNtsIS2GeY71rpsmpET6aEVbVyS7YM94d+iIbJ+RO2+osy2gsftGSJKrBCpnqBZTduNn7f0jcm2VS8AX+auqtFk+yvHTtwXjh3MWr6K6Ap7quQQiWRrExrOdVvYvhTxz4ecX2OhkkEOZw1abU+ceO0mXNc7DhW7gmgIPK0r2bh2ZqRyh0w47KiMMx2Dr+sh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39850400004)(36756003)(316002)(6916009)(54906003)(15974865002)(66946007)(8676002)(5660300002)(8936002)(76116006)(66556008)(66476007)(66446008)(64756008)(44832011)(71200400001)(6486002)(2906002)(86362001)(6506007)(26005)(186003)(4326008)(478600001)(2616005)(83380400001)(6512007)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bHpKTXlGQXV0QVFLRnA0ajQ2SStJVldXdEV0aFNsQWtXSTltaFJqbkZ0eXIz?=
 =?utf-8?B?SlBXWnFGTUp0emxzQWhlR1RMaCtqWklBWUFsZ25EY01hSUd5T2FOTGxqZXZo?=
 =?utf-8?B?WFJ5REtJWXBFR1d4NXVKUzJIQVZhUldEelBVMnlHQmxIMkd6b1g3c1hTRTZl?=
 =?utf-8?B?dDM5eUNtYzZ5UFVlNzVIaG1aSmJEVzdCRmh6am4xTUVoOFZUbTllOVBudUd6?=
 =?utf-8?B?a0VzaForY3F2Y1czSy9tTVNzSmJNUFIvWVFURjZaTDErSUtZbFk2bmhkOUdj?=
 =?utf-8?B?ZEhIWkF4MTV0cDMwL1RmMnFRODZ2QmJkYnRzTWgzMFFYTDVGMzRBTHE5Q0RO?=
 =?utf-8?B?TGtwSnJUNzdVY2wzRnEzdzdPSENacFZ6anBFNm4rbjlqK1VCMWhnSGZqa0Na?=
 =?utf-8?B?VW1YY1FUVUJ6ckVIOHlQZ2htN1VhcDVyd3BYWndnQ2hSNXp2bDZPSXpDTCt5?=
 =?utf-8?B?a3lpeEdPNkdwSjFtMjQwcWdpZUxqcWZZUDI0TDB1dnlieXJnUWxySEp0Skhh?=
 =?utf-8?B?QWJqU1RiRXpKdFFuRkloWTVWMW0yaWpuaW1DWGsvYVR0NkpXT2JaeVNOMHRn?=
 =?utf-8?B?M08yZExGc0E4QngzSXg4RVdxMHMzVXNZUDFFQ3NPS1NrZWI3Y3FzM0s4TGR5?=
 =?utf-8?B?dXFPTHVYMGpjU2t1dDM5SzhxWXhCaXY3MHhNK0JZSjRTbVQ3eWdqL2JNNWho?=
 =?utf-8?B?QlZhLzdiTmRDZVRicW5NNFdmTmNQYXpKeFJNaGt2ZUZ0bjNEa3BtVmhoL3Rp?=
 =?utf-8?B?UmtKZjFJN1BHME0wN0JSa0RUOEpLQzRPNlZhWTdpUFB3Y3dzWDBlUzhIRDFI?=
 =?utf-8?B?TGx3U1A4eFk1Uk1URlZGN3ZqK3laMExkWDEwL2h4Z2o2SnZQV2ZVNmRYR3NZ?=
 =?utf-8?B?Znc2TnhXMjYrekxIZWZmeUR5bUFrSG9MWDlVTW9yTDFSKzZRQTNyVGkwa0cw?=
 =?utf-8?B?b2JMQThrVTYvZUlVTzJDKzk0angrNGkwME84end3Y25UK2JmSHU3ODdHamRh?=
 =?utf-8?B?aUc3a20vaWtoNHhONS9Ec2hlUHZKTDFac2dkY1VzK052MVp2cnJXM0x0d2VZ?=
 =?utf-8?B?STlSLzE3STZMWGhVZU03eW5CSHQraGhGekE2WTdaQ29Bc2JtTVBHSTg3czN0?=
 =?utf-8?B?SitVbXdTbHZDOXhoMGhqUmVHYVZPSzgxeVNPamI5TWR3dGRWNmJ0WTQ4N1l6?=
 =?utf-8?B?cWQ3R3ZZdC8yREhidjBOaE9ibFB0WE14YlVUVUd5YlJxVzg3K2o4Vlp6dWx6?=
 =?utf-8?B?Ky9pdXloWjZ5b1Blc1E0TnBQOHhZazgvcHczRjRJdnp5NmJsOU92Sm1hbW5j?=
 =?utf-8?B?TFFxbkFVZmRzMHJEYWp4ZCtyOWVtMEZGZmNjYlZMUG1iSDVVK210N3lhNE9T?=
 =?utf-8?B?bVNxV3V6T3FuaGtnYVZOeDZLeS9qS3VNdjBqOXJWTVB4c3ZIZXVseks4U0l1?=
 =?utf-8?B?cS9CaDNXMTBMNEkrcnN3SFdQTldjK0JJd08xZzV1VmxxUEpzNThEUlh2T3FO?=
 =?utf-8?B?TVlhcFB1R0UwNGh5aU9mNDVOcnF2K2xIRmM4aVlMeWlmVkxtdDdIZVBuREl1?=
 =?utf-8?B?d0VhWHlqbW51Y2Rad1RVVWxjWUQzdzZ4MFpyK05Uc2tOMmwxRU1kR0twQXRM?=
 =?utf-8?B?UjYzNm5XTWh4SEthSUgxMzJXczlQZW1ndWpWZ1hGYkhFNlNrVlVjRkJXQ3Az?=
 =?utf-8?B?Unp0VHNEZ3dLa2tQWDhMa1lWVktBbjZQSHk1TGFXRm1CdEJtaHJGNnhrWDhs?=
 =?utf-8?Q?u945grXpFTQpVI94bC+l0pbCLS2o+qDVw0OOI4t?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1443B6C1AFC17942A17EDE5C47B32557@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 371fd709-9053-474c-9b7b-08d8d29b35a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 16:52:13.4119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7xAwOCoz8ocF7QipZI/hz5vF4thFi6MNjpL7gkgqNtpfNbE6a6gUz45ai9fNFJB9VjfVc8V86YnGXHfLNSBAamcWR2cvt2stL+coOTi/vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2558
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_07:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAyLTEzIGF0IDEwOjQ1ICswMDAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4gd3JvdGU6DQo+IE9uIEZyaSwgRmViIDEyLCAyMDIxIGF0IDA4OjE4OjQwUE0gLTA2
MDAsIFJvYmVydCBIYW5jb2NrIHdyb3RlOg0KPiA+ICsJaWYgKCFwaHlkZXYtPnNmcF9idXMgJiYN
Cj4gPiArCSAgICAoIXBoeWRldi0+YXR0YWNoZWRfZGV2IHx8ICFwaHlkZXYtPmF0dGFjaGVkX2Rl
di0+c2ZwX2J1cykpIHsNCj4gDQo+IEZpcnN0LCBkbyB3ZSB3YW50IHRoaXMgdG8gYmUgcmVwZWF0
ZWQgaW4gZXZlcnkgZHJpdmVyPw0KPiANCj4gU2Vjb25kLCBhcmUgeW91IHN1cmUgdGhpcyBpcyB0
aGUgY29ycmVjdCBjb25kaXRpb24gdG8gYmUgdXNpbmcgZm9yDQo+IHRoaXM/ICBwaHlkZXYtPnNm
cF9idXMgaXMgbm9uLU5VTEwgd2hlbiBfdGhpc18gUEhZIGhhcyBhIFNGUCBidXMNCj4gY29ubmVj
dGVkIHRvIGl0cyBmaWJyZSBzaWRlLCBpdCB3aWxsIG5ldmVyIGJlIHNldCBmb3IgYSBQSFkgb24g
YQ0KPiBTRlAuIFRoZSBmYWN0IHRoYXQgaXQgaXMgbm9uLU5VTEwgb3IgTlVMTCBzaG91bGRuJ3Qg
aGF2ZSBhIGJlYXJpbmcNCj4gb24gd2hldGhlciB3ZSBjb25maWd1cmUgdGhlIExFRCByZWdpc3Rl
ci4NCg0KSSB0aGluayB5b3UncmUgY29ycmVjdCwgdGhlIHBoeWRldi0+c2ZwX2J1cyBwb3J0aW9u
IGlzIHByb2JhYmx5IG5vdCB1c2VmdWwgYW5kDQpjb3VsZCBiZSBkcm9wcGVkLiBXaGF0IHdlJ3Jl
IHJlYWxseSBjb25jZXJuZWQgYWJvdXQgaXMgd2hldGhlciB0aGlzIFBIWSBpcyBvbg0KYW4gU0ZQ
IG1vZHVsZSBvciBub3QuIEknbSBub3Qgc3VyZSB0aGF0IGEgbW9kdWxlLXNwZWNpZmljIHF1aXJr
IG1ha2VzIHNlbnNlDQpoZXJlIHNpbmNlIHRoZXJlIGFyZSBwcm9iYWJseSBvdGhlciBtb2RlbHMg
d2hpY2ggaGF2ZSBhIHNpbWlsYXIgZGVzaWduIHdoZXJlDQp0aGUgTEVEIG91dHB1dHMgZnJvbSB0
aGUgUEhZIGFyZSB1c2VkIGZvciBvdGhlciBwdXJwb3NlcywgYW5kIHRoZXJlJ3MgcmVhbGx5IG5v
DQpiZW5lZml0IHRvIHBsYXlpbmcgd2l0aCB0aGUgTEVEIG91dHB1dHMgb24gU0ZQIG1vZHVsZXMg
aW4gYW55IGNhc2UsIHNvIGl0IHdvdWxkDQpiZSBzYWZlciB0byBza2lwIHRoZSBMRUQgcmVjb25m
aWd1cmF0aW9uIGZvciBhbnl0aGluZyBvbiBhbiBTRlAuIFNvIHdlIGNvdWxkDQplaXRoZXIgaGF2
ZSBhIGNvbmRpdGlvbiBmb3IgIiFwaHlkZXYtPmF0dGFjaGVkX2RldiB8fCAhcGh5ZGV2LT5hdHRh
Y2hlZF9kZXYtDQo+c2ZwX2J1cyIgaGVyZSBhbmQgYW55d2hlcmUgZWxzZSB0aGF0IG5lZWRzIGEg
c2ltaWxhciBjaGVjaywgb3Igd2UgZG8gc29tZXRoaW5nDQpkaWZmZXJlbnQsIGxpa2UgaGF2ZSBh
IHNwZWNpZmljIGZsYWcgdG8gaW5kaWNhdGUgdGhhdCB0aGlzIFBIWSBpcyBvbiBhbiBTRlANCm1v
ZHVsZT8gV2hhdCBkbyBwZW9wbGUgdGhpbmsgaXMgYmVzdCBoZXJlPw0KDQo+IA0KLS0gDQpSb2Jl
cnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVj
aG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
