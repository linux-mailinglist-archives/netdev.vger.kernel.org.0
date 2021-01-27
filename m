Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD5305D0B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhA0NZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:25:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14382 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbhA0NXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:23:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601168ff0000>; Wed, 27 Jan 2021 05:22:07 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 13:22:03 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 13:22:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgeqJ1vor0CROnAesdkTI3H2c3qRd4uylY3u+vsSp2B5onmwSQixKNL58EF/98mJ6WrcnteMX70c1cthL3c+zbRFHD+tT2OIcvfqB8aoafzpUX86/C0GPv0kTOviiGLxUwW++NrKtCEYsS5+wujhH1IPyv45w95/lgV3ZAcCpZ8+cCJhCCIJdDtWL76s8hRGKMYVF5EF5QbPmK7xThGxypTNxEdoqiE0qNtYCAF5gUZKbBnOjaRUl5Aq2In5eL1bxZ1jX6EpnELmX1v5+j3Bkz6w1UebBW9ewa3iRhnoSOGc9o0c1VQNCJpvrz9QZaYOgM4+HGujhGtkncoS0OG8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0S1y+06dtggV2nrg6Y3hFIlW/usrcq1eaqcbhGNCRw=;
 b=fIqusiTZHGYicr7yzhBOL4Nhlh+NBqcucOkplPlAsKzO30FwBB8PeTPmjmy1muQBIqNBhFONdBOZwlbIiDlwj/aPJr+DcBfc5Z47KY451mXE8bqRZJPpE5e+VCAQeHneD9+0uU7JEuEKSB2J7J10Q6O2XpmT5fsmu7WLwiF+CDMibPHdq8f+MCupTMpmZsp/cq2AHWwPnvWVtpM3Gygc52EyrMEWBZONOhNMmCyfn7yFcXyX9wp4krxoGok5t68D5O2oQHf+WxGPa9Bg/5EGpzhgyuHaB7vUPjyj5St5nxcfc4LlCG1eq4SWwoN1rmjlOQLKBMVjgIpCEcXi1qRtFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 13:22:02 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 13:22:02 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>,
        Michal Kubecek <mkubecek@suse.cz>
CC:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Topic: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Index: AQHW7w/mnu6I7KMocku/Ks1pUflayqoxLNcAgAVHQjCAAjatgIABgM1wgAADnoCAAT7X8A==
Date:   Wed, 27 Jan 2021 13:22:02 +0000
Message-ID: <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com>
 <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
 <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
 <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
In-Reply-To: <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [93.173.23.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8b9a123-f220-4257-88cf-08d8c2c6886f
x-ms-traffictypediagnostic: DM5PR12MB1258:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB125877100C72FD7CB6F0B476D8BB9@DM5PR12MB1258.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nPvV2cBNjIR+m5hKz5AoSueTRQb9Bl7l6exln/YJpwuNfEi++qNrjh+tsR46bE5c1EN3qygZTd2hWfFmHGHBh/0uI65YpPuCUeo+b6y1zIFrG5RVhbP6ENfwvLtoWsLyq7RkeIZ4rueBOwzsVvvKL0HUCg6P16hfEugs5D9a8gtMFIuiZITDfhFTKZn26G31Jxn6oGg5pYTmsXaC8dZJq3F3s4mdKRpdsNogehq2weB0kf0QV3ENslPoxCk3xvX5EDMYgHds1VZsEXgw8n367nIUBym4tXujIv8jOg/aDp8PTzbYgO0VnT99DsjW6FL512YsHq/DcWwnJPctsO2/T30BfsvhpBtUU+cCeeq8Ehi5x2R0CS36afWVkg6rEkLd2WnUC4tsLfmfClkggdXwskXoZshqmLVQu/g8MZSWt83x+kD27S0yW9RxfmA7acSwDS/SOFwv4DjHyjjG32GqVapy7Yy+jft/iPcyoUktlNJm1zV/vigqQH0ksD+Ynk3aKk5wjCN6Og1g6t0MC9f1hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(86362001)(9686003)(53546011)(186003)(5660300002)(2906002)(52536014)(7696005)(316002)(83380400001)(26005)(66946007)(110136005)(33656002)(107886003)(71200400001)(76116006)(8936002)(66476007)(66446008)(64756008)(66556008)(478600001)(54906003)(4326008)(55016002)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MThEZWh1RVBhaWJBc2NhSmpGTVVKT09sZDdRMmpEdWUzZVR2RVVVM2lnWWVh?=
 =?utf-8?B?YmVsWFc5R3dtc1lrRGdOTnEvbDRZZkwrZUkwczFoeVNjSm9EZitNRy9lU3pU?=
 =?utf-8?B?Ry9qZDVOTERRNVhIQ3RiTzVBRE96K2FIN1JvSTlXT1hQL3FFZTVXbWxqUEhY?=
 =?utf-8?B?U2xpMUpTM1F4VzNVV2RrQ3FNam9aaWVxZGY5dUF5REd3eGN1NnV6OHEvcmpD?=
 =?utf-8?B?aE12OVl6RmxHbW04TWJVcWNzdEg2ZTN4aHJjQk4yTVZCa3hIVnJNTCtUVUwr?=
 =?utf-8?B?Z1g5cGNzZi9wWC9YeFZZaDBGd2JJN2FlOHE0TTZ2S1RuZFh6MHNvYXRxTElT?=
 =?utf-8?B?bUdpUERIaXNabll0VE9mVTZ2dkQxTDhMUVVUOGg1T1dUYmwzVUNOc0FDVytE?=
 =?utf-8?B?QkZiaWNBc2ZpRWRPbDdON3VwS0xISzZXMGFRY2NCK2oyVTNWYWNUWDc0SmQ1?=
 =?utf-8?B?OVUvNlNISFpDTTZyNDRIMldDMnhwN3JFWXA1bjlpU3pHcTRFWmlYLzQ4UzVR?=
 =?utf-8?B?TERKSDVhcDI5bG5NZ3hjc21rL2tBang0bWxTdEtXdFFDc3FPeVpUeTVtVXdl?=
 =?utf-8?B?ZHpxRTVFcitjRldGTm1UZ2daNVAvVHYrV3VVcnZKTWQzOVhBaGVTeHVlSHBW?=
 =?utf-8?B?M1Z2UndlaUkvTXIyNERhUDk0N1Bwc2lvZXJselN6SC9UMmk1MVZ1WkhVK0t1?=
 =?utf-8?B?SmU4M1NpNVI3RTJzNWVrcW8xVzZwR21tVEIrRVcrS2t3NDFpait3bGZvTjlx?=
 =?utf-8?B?YmlqVWVQRUJOYVExR0M1V0t4WGxrK2hldWQrR1VUbnJZZEpXem9rZEFybUJL?=
 =?utf-8?B?bWlwQUkzbElUZlUya1B5QnE5NytkT0pvd2d3bW9BWlJEK2pmM0dmM1czQVRy?=
 =?utf-8?B?OUlLenh5N3l3L3Z6QWIwQkhhcURjVjJnU0pLSnd4VzJGMTZBOWYxYjVqdmdW?=
 =?utf-8?B?MVZtWWdGOVo4ZStqaGM0L2ZWWitKUWp5Sy9xekJub3FYR09tWWpLY01IME5I?=
 =?utf-8?B?THN5NnM3M0ozaWhHaWF2Q1pYTENSdXA3UVJSNmZDSEFUcFhaNEdabHlJS3RI?=
 =?utf-8?B?MWRWaFFoeU9GRFhHdWV4cTc4UWhWMzdhbHFXQ3BxdTM5Yi9LWFNxUVZEQzFJ?=
 =?utf-8?B?RFBRenQ4aGI0MEt4SW9HVDdMQk05eU1TclhCTnNsNmhkVThyOE1NOEFHTVA4?=
 =?utf-8?B?ZngzZXJabDNhTGNLMCt2UG8rQ1pEQTJka05rdmQ0MHNVY3dObGwyNW43a3lU?=
 =?utf-8?B?RStDci9nbVBqUG9BZ2JmOHo2dGtibnJXNEtWdmZYUVNRRkJ0dFc2N2gvaVUv?=
 =?utf-8?B?Y2t5bGljVVluWEpGVG9aQXB0VzlIbGpXcnc0TUYvcjQrMVRhV2dJcVJRZ09R?=
 =?utf-8?B?TlNLN2Q0QmFUK0svZ3FRSUl6YjZwdUJOcGY0WlFib1ljNGZjMXRYM0xEWXF2?=
 =?utf-8?Q?3ntOpIrX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b9a123-f220-4257-88cf-08d8c2c6886f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 13:22:02.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+jfQ59AWMVxWrPZB7lF7TWid7Kk91c2kELLIS0RPsg1COeP0KdE6HC7sDvribJvHNdJAmwA8pAciGYNDz3AhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611753727; bh=B0S1y+06dtggV2nrg6Y3hFIlW/usrcq1eaqcbhGNCRw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=TZl4YoA2V+SUvwVzLVr+8NWoI6mDCdBrcC1hZ7o3cdaQApG7BLExwU2RMYJxJq3P6
         6IsJSf8HXIEG1XksCCnETL/XWVgGpI5WyL9+x9ORSJ//hZnWoCRI9aLO2PNpigwmx9
         YfW8CFGCwcX16/Sk22VNcajwm9gpt2XVRqP5A1e2jM3QGtpe98M9gb34jXFkn5ORqV
         m/hBy4TOhQM/ffHDL1XeFIiTniBAMGLuCT29fZ4RB4f17q5z9xayCAq2aYuLRFWWeX
         YizYM1N2dxMiiXWNlPv/8huDShRpOWTTeSaoIN5f5HvmbOq+raIJkoRaUvLyfal3lD
         4upmfloo9Xfhg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRWR3aW4gUGVlciA8ZWR3
aW4ucGVlckBicm9hZGNvbS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMjYsIDIwMjEg
NzoxNCBQTQ0KPiBUbzogRGFuaWVsbGUgUmF0c29uIDxkYW5pZWxsZXJAbnZpZGlhLmNvbT4NCj4g
Q2M6IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IERhdmlkIFMgLiBNaWxsZXIgPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSmly
aSBQaXJrbw0KPiA8amlyaUBudmlkaWEuY29tPjsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNo
PjsgZi5mYWluZWxsaUBnbWFpbC5jb207IE1pY2hhbCBLdWJlY2VrIDxta3ViZWNla0BzdXNlLmN6
PjsgbWx4c3cNCj4gPG1seHN3QG52aWRpYS5jb20+OyBJZG8gU2NoaW1tZWwgPGlkb3NjaEBudmlk
aWEuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYzIDIvN10gZXRodG9vbDog
R2V0IGxpbmsgbW9kZSBpbiB1c2UgaW5zdGVhZCBvZiBzcGVlZCBhbmQgZHVwbGV4IHBhcmFtZXRl
cnMNCj4gDQo+IE9uIFR1ZSwgSmFuIDI2LCAyMDIxIGF0IDk6MDkgQU0gRGFuaWVsbGUgUmF0c29u
IDxkYW5pZWxsZXJAbnZpZGlhLmNvbT4gd3JvdGU6DQo+IA0KPiA+ID4gSSB1bmRlcnN0YW5kIHRo
ZSBiZW5lZml0IG9mIGRlcml2aW5nIHRoZSBkZXBlbmRlbnQgZmllbGRzIGluIGNvcmUgY29kZQ0K
PiA+ID4gcmF0aGVyIHRoYW4gaW4gZWFjaCBkcml2ZXIsIEkganVzdCBkb24ndCB0aGluayB0aGlz
IGlzIG5lY2Vzc2FyaWx5DQo+ID4gPiBtdXR1YWxseSBleGNsdXNpdmUgd2l0aCBiZWluZyBhYmxl
IHRvIGZvcmNlIGEgcGFydGljdWxhciBsaW5rIG1vZGUgYXQNCj4gPiA+IHRoZSBkcml2ZXIgQVBJ
LCBtYWtpbmcgbGlua19tb2RlIFIvVyAoYW5kIGV2ZW4gZXh0ZW5kIHRoaXMgaW50ZXJmYWNlDQo+
ID4gPiB0byB1c2VyIHNwYWNlKS4gRm9yIGEgZHJpdmVyIHRoYXQgd29ya3MgaW50ZXJuYWxseSBp
biB0ZXJtcyBvZiB0aGUNCj4gPiA+IGxpbmtfbW9kZSBpdCdzIHJldHVybmluZywgdGhpcyB3b3Vs
ZCBiZSBtb3JlIG5hdHVyYWwuDQo+ID4NCj4gPiBJIGFtIG5vdCBzdXJlIEkgZnVsbHkgdW5kZXJz
dG9vZCB5b3UsIGJ1dCBpdCBzZWVtcyBsaWtlIHNvbWUgZXhwYW5zaW9uIHRoYXQgY2FuIGJlDQo+
ID4gZG9uZSBpbiB0aGUgZnV0dXJlIGlmIG5lZWRlZCwgYW5kIGRvZXNuJ3QgbmVlZCB0byBob2xk
IHRoYXQgcGF0Y2hzZXQgYmFjay4NCj4gDQo+IEZvciBvbmUgdGhpbmcsIGl0J3MgY2xlYW5lciBp
ZiB0aGUgZHJpdmVyIEFQSSBpcyBzeW1tZXRyaWMuIFRoZQ0KPiBwcm9wb3NlZCBzb2x1dGlvbiBz
ZXRzIGF0dHJpYnV0ZXMgaW4gdGVybXMgb2Ygc3BlZWRzIGFuZCBsYW5lcywgZXRjLiwNCj4gYnV0
IGl0IGdldHMgdGhlbSBpbiB0ZXJtcyBvZiBhIGNvbXBvdW5kIGxpbmtfaW5mby4gQnV0LCB0aGlz
IGFzeW1tZXRyeQ0KPiBhc2lkZSwgaWYgbGlua19tb2RlIG1heSBldmVudHVhbGx5IGJlY29tZSBS
L1cgYXQgdGhlIGRyaXZlciBBUEksIGFzDQo+IHlvdSBzdWdnZXN0LCB0aGVuIGl0IGlzIG1vcmUg
YXBwcm9wcmlhdGUgdG8gZ3VhcmQgaXQgd2l0aCBhIGNhcGFiaWxpdHkNCj4gYml0LCBhcyBoYXMg
YmVlbiBkb25lIGZvciBsYW5lcywgcmF0aGVyIHRoYW4gdXNlIHRoZSAtMSBzcGVjaWFsIHZhbHVl
DQo+IHRvIGluZGljYXRlIHRoYXQgdGhlIGRyaXZlciBkaWQgbm90IHNldCBpdC4NCj4gDQo+IFJl
Z2FyZHMsDQo+IEVkd2luIFBlZXINCg0KVGhpcyBwYXRjaHNldCBhZGRzIGxhbmVzIHBhcmFtZXRl
ciwgbm90IGxpbmtfbW9kZS4gVGhlIGxpbmtfbW9kZSBhZGRpdGlvbiB3YXMgYWRkZWQgYXMgYSBy
ZWFkLW9ubHkgcGFyYW1ldGVyIGZvciB0aGUgcmVhc29ucyB3ZSBtZW50aW9uZWQsIGFuZCBJIGFt
IG5vdCBzdXJlIHRoYXQgaW1wbGVtZW50aW5nIHRoZSBzeW1tZXRyaWMgc2lkZSBpcyByZWxldmFu
dCBmb3IgdGhpcyBwYXRjaHNldC4NCg0KTWljaGFsLCBkbyB5b3UgdGhpbmsgd2Ugd2lsbCB1c2Ug
dGhlIFdyaXRlIHNpZGUgb2YgdGhlIGxpbmtfbW9kZSBwYXJhbWV0ZXI/IEFuZCBpZiBzbywgZG8g
eW91IHRoaW5rIGl0IGlzIHJlbGV2YW50IGZvciB0aGlzIHNwZWNpZmljIHBhdGNoc2V0Pw0KDQpU
aGFua3MsDQpEYW5pZWxsZQ0KDQo=
