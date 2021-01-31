Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793D4309AE0
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhAaHDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:03:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15136 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhAaHCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:02:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10V720xV021306;
        Sat, 30 Jan 2021 23:02:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=nU0PQYfqyFfnPvsT3y53dbnKnnoYFh0Ul9dcSmSL26g=;
 b=YiMf5MOGJknnBv5hBdr0hH0PKzfZ1xxMTJ9rfEOLIDVihJ41moHIXcxmUmAVeGEo0w5W
 DD1ROo1k/iobcIXl07qhU4Wn6AAjWSATKlxnTLRCAxRzBVE3P/afpa64SnrXHWxvsP2P
 ocnWRaz+KrFyPLROiBFnTANUm5XPhNPYGn+ihfhMWedOIvUXJWw2Ps37GUMHthdk98Dl
 O4V4Txom2UOJa+xlso27g0WPYSBHi88kPO2mjAr4bYGdfHC5vFC+SY4LEurK/GFD7w+c
 9LvTiUP2/84uMZeb2vuLrTrRl6ytFcg6X8jeFwydb9lNRa0g8xhEiqubCcheL7ZqCRVZ 4Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1537-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 23:02:00 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 23:01:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 23:01:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 23:01:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=car4R8Jq8W0Sr/jSVrdLODWulFLEr935BZaGptXJB+GFeVy8Gi5KHO7CTEFk+kuudUrGMF3cmbPkUu0XoT6+fMRFJKJU5dhBTVjEtXxEfY+IZXzvtFP8jbP+E3+MHAL/JmJYPoJkUeUNDnUub9AsBED4wNdi/d0DHv37FL+9EdGLDNFcyzlOcYlNcEVuHs+9zmxGQmAurYUOHXFQ5bNtpuaETVgt2qAsU2Gu1oYkp/DylmeApTk21HbwdFtQ/arKtS/lsJb4Jekug7zUQLRI+HlTIt/93TuN6eD/WevtujWEHUF0jvcVGBX1uRSS7AWKCU0CvjCN98kjoNKKM2eWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nU0PQYfqyFfnPvsT3y53dbnKnnoYFh0Ul9dcSmSL26g=;
 b=kIhgE/8hXztFzwr/PSU7rxexKVVa+JTiMkOsBpuDsgJnBXkK4rczjoJzKYTu3WYmkWdZ3vePN/eXaZQK680NvNzSxp5Ep954XBbMQfeSNw0/bmyA1FnWSxgz8eECIDtaUOmvdHZGPgFKVOOSGfydovr7p6lhJEwtt/jK65UTzUrvfYRE+ORtg2YYqttp82fFd5YndCZGoBzRwfNoEkI9aNDqCHx5yMnpZL5VqXrc+wiuJmC6YZ/kM6ipb1il8kPyDrlzfUW9CHeWnGNXKm22JvSlPE6S01zFYz7U6rOZV1mapM0sAhAsxCKPuhBGOvrDY7v/vvYna1eV7+O26D26RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nU0PQYfqyFfnPvsT3y53dbnKnnoYFh0Ul9dcSmSL26g=;
 b=RUUFiALqy1jxmq6ACBx2ntYy4taybEgFyepvZ54WkVbUja8aiSsuM39MtT/JeO5B9sRUCWgjDLalOqVx9HGCNI9T7z1oanbMKdeAuzCb5r+caJZiApsrEZUZP0S1BV5PE+JHrKeKzQ/7mV3FpbM3QdU+YGyZSvjqiPIAwOLd7nQ=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW2PR18MB2348.namprd18.prod.outlook.com (2603:10b6:907:b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sun, 31 Jan
 2021 07:01:56 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sun, 31 Jan 2021
 07:01:55 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        "Sunil Kovvuri Goutham" <Sunil.Goutham@cavium.com>
Subject: Re: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
Thread-Topic: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
Thread-Index: Adb3ntJ8qz9eRYGTTf2FShS0rhLUQw==
Date:   Sun, 31 Jan 2021 07:01:55 +0000
Message-ID: <MWHPR18MB142149F54F5AB88590B4AB2BDEB79@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.214.104]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457f2a8b-e0bc-4f10-1b2c-08d8c5b61887
x-ms-traffictypediagnostic: MW2PR18MB2348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB23484AEA297DC8585AE42B88DEB79@MW2PR18MB2348.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7WGfeUWIdq4i8GMPeX2LGR7KxJ7lgEbvlMCQA75hPq7wyXaQVZuxUoHmdz0xOY09P+og0gUL6/VfBmf8vOM06W1m4fkzW/6N97vN7AKUlPcJpkopy8v0h8R+DZjWoCnX6S46k6c9mwBPuUUNFoQ50ZId0d9yyoS6TbCQiNkSQrTvNdwctbayFf3Dt/ifeULkpg6TEoVB359Nln37Kb6SbIyi5bcrD6kFoORALHYYzFk/5pWhvQMayXbWXEyorND0LKsR5yz0SENeDQd3tACnWqI3f473YwBJq0fW0/8f1/pUxJx8NFuNbGyrP7lYFjLCDmLCyp0ASbogDmt9bjV9L5SkX5GzyHqJbUQm83CX39lcXoD2w7pyL+WxE1URr403vy8Te8PREO1tvWwcYv4JlLU7s0Ihy0hsz5LSFM69XhsohvN+1dW/KFmWOTYFKwUP0TjtTdKsy5ma3VOWPA4/UuWog6+8wDB9+2EWJLnAyOgUy8Cz8nKDSjNdZXaGZjy5jqlB859rMT2wWxho9ymxzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39840400004)(396003)(136003)(478600001)(6506007)(53546011)(9686003)(52536014)(83380400001)(8676002)(2906002)(26005)(55236004)(33656002)(76116006)(86362001)(4326008)(186003)(7696005)(55016002)(64756008)(66556008)(66476007)(71200400001)(6916009)(5660300002)(8936002)(316002)(66946007)(66446008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1VBTlNwR3hHM0VjMnhHQnRocEFWSHJuU1ZJbi83aTlZck8wZ0NFaDZFT2xm?=
 =?utf-8?B?L3pPNzltZUtJa1k2WDJWM1hzcmJ4TzFocHhVYkJ1bjgwZmtZbGNIcG82NWtu?=
 =?utf-8?B?Ny8rcFlxQVFmNWZZL0FuakdQc0Y0U29xcmdxcTk0ZDZwcTRIMXowb2dxZkV6?=
 =?utf-8?B?cnpoM3pmUStYQWFXZnV0bmNEN3pub3pzQ3pNc3d2L1FYYUF4K1NaS3d3MWJX?=
 =?utf-8?B?S1Y1ckY5eit2bFNXQ091Um5LY2x4b2RkVWlrUWxKZGpvYTBPWFlnNjZKbUd2?=
 =?utf-8?B?RWtuWkg3UWZNZVdjRXE3c2tyUXBIY3pCSFhSUXI0UUtPbHhWU2hST2M5NEM4?=
 =?utf-8?B?bVBTbEdQSE1oblh6VTlRUlVONXFIaEs5aTJTeVIwY1dMcm5iQU5YYUtiUE9Z?=
 =?utf-8?B?aTl1Q1c4VmduUHlIOEpwR1hnSHlKRFVXSndTOVIyU0Z5TXo0Y01wWVRJYU5X?=
 =?utf-8?B?ZHhmMHNXYVFuUlkrNTZ2UXBrWGRwYTRBYWZBb0hja3FQWjRoVUxPT0JyWC9P?=
 =?utf-8?B?clJnQWlrYU1IVXhwV3R5ejNOSVd4L1o4RXluTXVDYjdxWmhNNDZCTGVQWVdS?=
 =?utf-8?B?VXJLSGlVYUF5d3NNdnBoVERRN0h5SGlEWmdQK0YxNUllNFF2OU5RSzgxMmhz?=
 =?utf-8?B?VVJBenU5T2paNmlycFZCa0hZemJNVjFYODY4ZnE2alVRZjhPSCsrZHIybEFM?=
 =?utf-8?B?R0N4RUgzNU5jbm1JWE1BWkZyNFovVGUyMTVNVzJqcityK0dtUmFPa2JoVnpp?=
 =?utf-8?B?c214eG1YZnJRR3lyeTl0UW0vVlo1ZXJ1a0FWTHVqd0d0bkc5M3lKakJ0RFdh?=
 =?utf-8?B?eGxqNEZoSldsWEpBNVJoWFdzbEppVHRVWXZ2d3RObXc3anRsaTVqY0VTQ2Jy?=
 =?utf-8?B?eVBnaTB5azcvdERDaTB3YnRiZHVKQUtDQXhRcGNjVURsYVIzRkphb3ZMVndH?=
 =?utf-8?B?OVV5TGtJSThsY01laVlLbXZGSGZOR251TXRNcjF0TXZlOVpqZU5xZHVHcXIy?=
 =?utf-8?B?MS9ibTVsN01OUlpwOUlFTTNYSVV1azRyM1Q1Yk5vSGxCeHVzMWRMbUp2SElz?=
 =?utf-8?B?dFg1OWdEeHF2YUhLV2xlcTBlZ1hrdHJEbzVuR0ZHaHpPVzBndnhNcW1zRWtr?=
 =?utf-8?B?MUM3RXR3RnpLN1c5WS9xbU9ueFc0RHlzenRiQ0xZaDdKWU5nT2ZEOXJFT3My?=
 =?utf-8?B?Z2NaVW9BS01lV1Y3Zm5CdjRxOG5Kemt2NVFBczE0Z1lXQXNrZWVFZHZRdGhj?=
 =?utf-8?B?LzRHR3lTOU9YTyt1L1dRRHJSU2c3U0g3RmV1UktvdWNwdW9HdDR1SUQ5cXUw?=
 =?utf-8?B?dWhzZGtYcWJobHpUVzRLdFdkMm83Y1BXMWkvdTJIcGFPdUxmTDByam1uUUJW?=
 =?utf-8?B?NHlRVFNnYkJvK0lTb1RxWWNuYlR3VWhYejk4NlhWdit4WWRRbWE4Z01oWFhk?=
 =?utf-8?Q?2HuTsuW9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457f2a8b-e0bc-4f10-1b2c-08d8c5b61887
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:01:55.6393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xGCfgxsVSoAYQ1YrPBHVRtOXO+ZyrytGsOgXj27kNRux2b/o7//2cr2LXThhpXKOptcQ9dAye/2bAaFehkgoRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2348
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_02:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxl
bSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFNh
dHVyZGF5LCBKYW51YXJ5IDMwLCAyMDIxIDc6NTcgUE0NCj4gVG86IEhhcmlwcmFzYWQgS2VsYW0g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBTdW5pbCBLb3Z2dXJpIEdvdXRoYW0NCj4gPHNnb3V0aGFtQG1hcnZl
bGwuY29tPjsgTGludSBDaGVyaWFuIDxsY2hlcmlhbkBtYXJ2ZWxsLmNvbT47DQo+IEdlZXRoYXNv
d2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2th
cmFuDQo+IDxqZXJpbmpAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0dGEgPHNi
aGF0dGFAbWFydmVsbC5jb20+Ow0KPiBGZWxpeCBNYW5sdW5hcyA8Zm1hbmx1bmFzQG1hcnZlbGwu
Y29tPjsgQ2hyaXN0aW5hIEphY29iDQo+IDxjamFjb2JAbWFydmVsbC5jb20+OyBTdW5pbCBLb3Z2
dXJpIEdvdXRoYW0NCj4gPFN1bmlsLkdvdXRoYW1AY2F2aXVtLmNvbT4NCj4gU3ViamVjdDogW0VY
VF0gUmU6IFtQYXRjaCB2MiBuZXQtbmV4dCAyLzddIG9jdGVvbnR4Mi1hZjogQWRkIG5ldyBDR1hf
Q01EDQo+IHRvIGdldCBQSFkgRkVDIHN0YXRpc3RpY3MNCj4gT24gU2F0LCBKYW4gMzAsIDIwMjEg
YXQgNDo1MyBBTSBIYXJpcHJhc2FkIEtlbGFtIDxoa2VsYW1AbWFydmVsbC5jb20+DQo+IHdyb3Rl
Og0KPiA+DQo+ID4gSGkgV2lsbGVtLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gRnJvbTogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVs
QGdtYWlsLmNvbT4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDI4LCAyMDIxIDE6NTAg
QU0NCj4gPiA+IFRvOiBIYXJpcHJhc2FkIEtlbGFtIDxoa2VsYW1AbWFydmVsbC5jb20+DQo+ID4g
PiBDYzogTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IExLTUwg
PGxpbnV4LQ0KPiA+ID4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47IERhdmlkIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+ID4gPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
PjsgU3VuaWwgS292dnVyaSBHb3V0aGFtDQo+ID4gPiA8c2dvdXRoYW1AbWFydmVsbC5jb20+OyBM
aW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gPiA+IEdlZXRoYXNvd2phbnlh
IEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2thcmFuDQo+
ID4gPiA8amVyaW5qQG1hcnZlbGwuY29tPjsgU3ViYmFyYXlhIFN1bmRlZXAgQmhhdHRhDQo+ID4g
PiA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47IEZlbGl4IE1hbmx1bmFzIDxmbWFubHVuYXNAbWFydmVs
bC5jb20+Ow0KPiA+ID4gQ2hyaXN0aW5hIEphY29iIDxjamFjb2JAbWFydmVsbC5jb20+OyBTdW5p
bCBLb3Z2dXJpIEdvdXRoYW0NCj4gPiA+IDxTdW5pbC5Hb3V0aGFtQGNhdml1bS5jb20+DQo+ID4g
PiBTdWJqZWN0OiBbRVhUXSBSZTogW1BhdGNoIHYyIG5ldC1uZXh0IDIvN10gb2N0ZW9udHgyLWFm
OiBBZGQgbmV3DQo+ID4gPiBDR1hfQ01EIHRvIGdldCBQSFkgRkVDIHN0YXRpc3RpY3MNCj4gPiA+
DQo+ID4gPiBPbiBXZWQsIEphbiAyNywgMjAyMSBhdCA0OjA0IEFNIEhhcmlwcmFzYWQgS2VsYW0N
Cj4gPiA+IDxoa2VsYW1AbWFydmVsbC5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+
ID4gRnJvbTogRmVsaXggTWFubHVuYXMgPGZtYW5sdW5hc0BtYXJ2ZWxsLmNvbT4NCj4gPiA+ID4N
Cj4gPiA+ID4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgdG8gZmV0Y2ggZmVjIHN0YXRzIGZyb20g
UEhZLiBUaGUgc3RhdHMgYXJlDQo+ID4gPiA+IHB1dCBpbiB0aGUgc2hhcmVkIGRhdGEgc3RydWN0
IGZ3ZGF0YS4gIEEgUEhZIGRyaXZlciBpbmRpY2F0ZXMgdGhhdA0KPiA+ID4gPiBpdCBoYXMgRkVD
IHN0YXRzIGJ5IHNldHRpbmcgdGhlIGZsYWcgZndkYXRhLnBoeS5taXNjLmhhc19mZWNfc3RhdHMN
Cj4gPiA+ID4NCj4gPiA+ID4gQmVzaWRlcyBDR1hfQ01EX0dFVF9QSFlfRkVDX1NUQVRTLCBhbHNv
IGFkZCBDR1hfQ01EX1BSQlMgYW5kDQo+ID4gPiA+IENHWF9DTURfRElTUExBWV9FWUUgdG8gZW51
bSBjZ3hfY21kX2lkIHNvIHRoYXQgTGludXgncyBlbnVtIGxpc3QNCj4gPiA+ID4gaXMgaW4gc3lu
YyB3aXRoIGZpcm13YXJlJ3MgZW51bSBsaXN0Lg0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBGZWxpeCBNYW5sdW5hcyA8Zm1hbmx1bmFzQG1hcnZlbGwuY29tPg0KPiA+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RpbmEgSmFjb2IgPGNqYWNvYkBtYXJ2ZWxsLmNvbT4NCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogU3VuaWwgS292dnVyaSBHb3V0aGFtIDxTdW5pbC5Hb3V0aGFtQGNhdml1
bS5jb20+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBt
YXJ2ZWxsLmNvbT4NCj4gPiA+DQo+ID4gPg0KPiA+ID4gPiArc3RydWN0IHBoeV9zIHsNCj4gPiA+
ID4gKyAgICAgICBzdHJ1Y3Qgew0KPiA+ID4gPiArICAgICAgICAgICAgICAgdTY0IGNhbl9jaGFu
Z2VfbW9kX3R5cGUgOiAxOw0KPiA+ID4gPiArICAgICAgICAgICAgICAgdTY0IG1vZF90eXBlICAg
ICAgICAgICAgOiAxOw0KPiA+ID4gPiArICAgICAgICAgICAgICAgdTY0IGhhc19mZWNfc3RhdHMg
ICAgICAgOiAxOw0KPiA+ID4NCj4gPiA+IHRoaXMgc3R5bGUgaXMgbm90IGN1c3RvbWFyeQ0KPiA+
DQo+ID4gVGhlc2Ugc3RydWN0dXJlcyBhcmUgc2hhcmVkIHdpdGggZmlybXdhcmUgYW5kIHN0b3Jl
ZCBpbiBhIHNoYXJlZCBtZW1vcnkuDQo+IEFueSBjaGFuZ2UgaW4gc2l6ZSBvZiBzdHJ1Y3R1cmVz
IHdpbGwgYnJlYWsgY29tcGF0aWJpbGl0eS4gVG8gYXZvaWQgZnJlcXVlbnQNCj4gY29tcGF0aWJs
ZSBpc3N1ZXMgd2l0aCBuZXcgdnMgb2xkIGZpcm13YXJlIHdlIGhhdmUgcHV0IHNwYWNlcyB3aGVy
ZSBldmVyDQo+IHdlIHNlZSB0aGF0IHRoZXJlIGNvdWxkIGJlIG1vcmUgZmllbGRzIGFkZGVkIGlu
IGZ1dHVyZS4NCj4gPiBTbyBjaGFuZ2luZyB0aGlzIHRvIHU4IGNhbiBoYXZlIGFuIGltcGFjdCBp
biBmdXR1cmUuDQo+IA0KPiBNeSBjb21tZW50IHdhcyBpbnRlbmRlZCBtdWNoIHNpbXBsZXI6IGRv
bid0IGFkZCB3aGl0ZXNwYWNlIGJldHdlZW4gdGhlDQo+IGJpdC1maWVsZCB2YXJpYWJsZSBuYW1l
IGFuZCBpdHMgc2l6ZSBleHByZXNzaW9uLg0KPiANCj4gICB1NjQgbW9kX3R5cGU6MTsNCj4gDQo+
IG5vdA0KPiANCj4gICB1NjQgbW9kX3R5cGUgICAgIDogMTsNCj4gDQo+IEF0IGxlYXN0LCBJIGhh
dmUgbm90IHNlZW4gdGhhdCBzdHlsZSBhbnl3aGVyZSBlbHNlIGluIHRoZSBrZXJuZWwuDQpHb3Qg
aXQgLiBXaWxsIGZpeCB0aGlzIGluIG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0KSGFyaXByYXNh
ZCBrDQo=
