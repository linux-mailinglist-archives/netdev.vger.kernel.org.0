Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734BA4D6152
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345881AbiCKMNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiCKMNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:13:12 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA510C51E;
        Fri, 11 Mar 2022 04:12:09 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22ANuepO027753;
        Fri, 11 Mar 2022 04:11:47 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3eqgr4wjn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 04:11:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhy9GB61uPWC0NAb/DDfyvVnVWzyVuIchNLeoTwXkFu6yBF6G3r9hF0DPImuVGR+4y88qBIa4MrqE6NFdBQFjpMJo/AWdIkUVPTOax1gp1yt6yYFk6ztYLaXhRkJ19agYtuoqf9CqcQ3J6HUAY2HHGfjzGfiWatbwQOS+XLkuopKtDuuqyrWNJ4ysBtZ+M36dGuQJ87/o+8dIpTUBUCMnFd+rbtzI1c+5zsnDNuetU4s/GDWSpxv1bOgaZOcLkN0QlsxJC+Na5w1SEIF28h3yj4kzCtf3Wba0FRgxHWKy0k20yRObCdnmIHF2b8l6/S/OJ1KbQ/ftXSh1aVpf38e3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3vLdM7TcMtaXXkvEYPR00ygiyxNcaW8Wh+nIucEvc0=;
 b=iO+xtMijaLN2RPsFOtUFOddVCUnkhlQwcMIcpq6RGLnRRKYMVsnenox7hDGD+yQMarvFtXLtB4U+hYJofv3F2xamMp8sgmdWG82M99f2r9/uv9phgQVMlhsyRF68J89EHmQR4RGhW3OH/7c1o2OH0ha4TEEmKWks7Y8sqpWHBEEX6UlIs4ELk76dijj38vZapy97q+wTEsikXPKiGIEhguAadQQZcDEbdM16sTDyV4cvmRnCv2drSJa2kOKZ3PncxAn0naLCKmKadpMjC2VL1EFMJQvOkdAAOsRnUKspUE2nZhhgNJaTZArzet3gUpL1HKoSIBP/DtPDmwi5gCLhsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3vLdM7TcMtaXXkvEYPR00ygiyxNcaW8Wh+nIucEvc0=;
 b=gYSI8ezt49Cmw7aKwWrD7wgKNlOZO2ehOW5cZnOVzEsIb6Qo7bUzGUJ7vL+1tFwhFXGAWiW3PfWLEXSO1mihULpOnhrgE0M1JxeaIjeGA0Q1PWt+8Zy1yZM9xg2rmrrx9vnNkEtN6M6ap8cf1d+R6N1M9d/n+xJJ6xvsX8HraW8=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BN6PR1801MB1970.namprd18.prod.outlook.com (2603:10b6:405:68::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 12:11:45 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9%6]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:11:45 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Topic: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Index: AQHX82cKaSG7IQ3NYE6x2TZQurl1/6y3uviAgAACYwCAABsBAIAACH9AgAAPEQCAAAE60IAALzmAgAJ5owA=
Date:   Fri, 11 Mar 2022 12:11:45 +0000
Message-ID: <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211217165552.746-1-manishc@marvell.com>
 <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
 <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
 <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
In-Reply-To: <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3deb031f-a048-4a94-539b-08da03584f77
x-ms-traffictypediagnostic: BN6PR1801MB1970:EE_
x-microsoft-antispam-prvs: <BN6PR1801MB1970A1339E8E81077DD7FB91AB0C9@BN6PR1801MB1970.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: drs2q2HpMvZDNFsw1QHrt/j6iGaho2icq6spDmfPpRDFzbpM08hwmGxFqVansF99bfh7VLMMCrbZ/1CSExNyITsFTWV33kDCzrpG3Dv46BqVnMnQn7T9U+kKYBzW65p2xxXwrFPIgqssVhn+1Wl7u0SI8hxPLMmRKFrIOxbZSqFZZC5joWaVvzGMGawE1zSRW/ubMz/PW+n9z2s6GMffcFsPNYCq25XA+Q0BJjQ3rTWE2nrvqsk/EPwqzaNy5O9q7yRBHIsBkxDvqyD37MQSllEcvZegZCBSbIcmdab6StgE06LyysNpBS56JDn6WKWw7Uf0cbARZGvwCu2kAuLPuabTHDQJROSZxz0cB130e/6wzVUqw/GXUcwbzG1DwDyerWR1UjqEfhSQ/lURlVqq2SAIynkiArKF4oBIBBs1bCybQ1w1gXHMh9Bmjxh9NDmrMzLEsCugDSyRgV/4z/y9NIMuLhHojkHaXfklWlfsBDGB5OKF4xFJMxeMgdEhEljC0aTdhAPpOjJzBY/0YZl+cJl14cxWpjMaMPSMgYW+ZVSBNtXwx+DTWA+z0S6JQhqs7hs6Yqo5KJOejuujNSnEJHNcjhHr4tyWo6RSeOtdUbzMwD3aw/G+QdBhAYE44xZbLwpwrT0wPMgQYfKoXXANTyXs9Xc6++hyHRYAyGe2EGlvAOR35jcm+Iwwml8hhuDunITi73w+JCtKZzjapUtzow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(52536014)(38070700005)(66446008)(4326008)(66476007)(8676002)(66556008)(66946007)(64756008)(76116006)(186003)(26005)(316002)(122000001)(38100700002)(508600001)(5660300002)(54906003)(53546011)(71200400001)(6506007)(7696005)(2906002)(9686003)(110136005)(55016003)(83380400001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVNBMVFlMDA5aEtKTG1FQkN2aFFMdUlvTUNXMmZONnEwV0hVcnc4bkl0b1BD?=
 =?utf-8?B?OHZiNkFzaUtRc3JFTUVQekZoZGFjWVdLd29NMmQwRmgvTE95eDF1VThGelZl?=
 =?utf-8?B?ZTZTak1uOEh3bmduNGFIVk9qa0Z0dUFZa2QyL3BxQ1I3cjkyS0RpRUhPbFlw?=
 =?utf-8?B?QWc1cE54OW12VCtuUHpwM2dEd2tRdkpaa1lQQWYzVGZCVm91WXQ3Z09ZMnZw?=
 =?utf-8?B?VWxnNzFCbS9XMTNrVUF6SGVTUGpnVzVET3hUUGJIZDNqdC94bXpZeHVtZFo1?=
 =?utf-8?B?UU1ObVIzaFVFL0hxQWcyS2lvcG4vK0tKaVRGdnlNTE1EcEY1OFJ5WnFNZ2xy?=
 =?utf-8?B?YVAzcUtNLy9ibm8yVy9lUHB4Z1pFSzhUTk1wYUFrQm5aNkU2bk1mdGdFQXhT?=
 =?utf-8?B?aVd4WUZIT2pMendlT2pZZ2R4TW9mc2dNYW5RSThLUCtRemZVV05acVVWSVc2?=
 =?utf-8?B?NUUzaTBzWkZKWXZ1NmMzUXJFbDJGVW13dEJWQjJKcUE5WnBvYzM4U3IwQmV6?=
 =?utf-8?B?TmVGcDMvb2xKaUR0Z3l3cHlXL0lkOWUxNDZwMUJwUXkyZ0JoZ3k3aGlzOWVM?=
 =?utf-8?B?eDQ1MjBEREVCY0U5NFBkcWo5b25PdG9YR0tnZUNveVRrNnJTQVRtUmZEUTZt?=
 =?utf-8?B?YVFsWkVFcnNMT0hKbG5CaDVZaWd2R0lRZ3V0dUJpeW1JMDgwRCtVM3NzWDNq?=
 =?utf-8?B?QjZKVXo5YzVQWjRGMzdwcmpXVFE3OUxJY3c4OGZzWFlvM0Yxem5OeUR3VlEw?=
 =?utf-8?B?MkZmdk9mUElOUXYxMmdhOWdNU1JzU01jRTEzR01iSEFNTTB6KzRnTHFvMHJR?=
 =?utf-8?B?b1ZFZDlLZFN3MVJkTU9xZXVyQlMyZnJFTmJaQWhaakI5dW1XNm1odkN1blF5?=
 =?utf-8?B?K3Zpdk1vZTRsSzJQZHdQc0RhOGNuVTN6bFErNThmOEVFbDl0VVNTdnZVbWVw?=
 =?utf-8?B?UFFFT3NaNlhsK1M2RTZpd1plak0zNEhyb0VUZmhRTzAwNFJNM3N2bm44ZXZh?=
 =?utf-8?B?Q1Q4ZGJVeW5xeDBDeE52UjVCekl0YXI0TkFWZjFhZ0ZiZ3ZkbFZnSCtHMWFs?=
 =?utf-8?B?ckhiNHR2ajQ3NTFDaVZXUVdhVEJMUGkwUS9xRS9Mejh4SWpjTVp0NVd2WFo5?=
 =?utf-8?B?TG02bEdYQlk2bGpldWp4ZkFvWldpV2cvT1VKS0k1SzJIcVR4Mk93YnNJSWJJ?=
 =?utf-8?B?OWpwRzI4QVBpOVFHbkpBTDVuSCs3N1h5Nkh2c3d6V29vMXB1OUp5UWxadGRh?=
 =?utf-8?B?VG43cDFCamJycCs1N2ZRWGJmdWlBRFpYbkY1ZEZvNDR6eVN2aEdhaU1sQVNT?=
 =?utf-8?B?ZWJKVUJFQjRDdC9ObThxWWVwdjVPSzJRemZOeGR2amRJS2hpZjlaVk4rZXFl?=
 =?utf-8?B?cWRXNjh6R2YyRGE5MllrMldtc1B6L2ZvWkFJanQzVnVxM2pYZWl0UUptKzBh?=
 =?utf-8?B?L1Y3d2NOYnAwWSt5dGhNMk92RDNib3FGTkx4cXVaMEJ3SHFYbXJqWDJKZ2t6?=
 =?utf-8?B?RFJ5anQ2UFJMb3NoeXZpQkNoVEl2eFF3RWFiTlVkTVRVbUNlSW9RSVhobTRC?=
 =?utf-8?B?ZlQ0ZGt0ZGVpTHovVTR3a1d6ZjV5Rno3RzF2WlVxekZFTmloS3dQZVJGL2k2?=
 =?utf-8?B?V1hRbkp3UDhSTFRSSjRyL1lnY0VUM2FRMEluZkFNKzJiUkgyVnN3NGpOMW54?=
 =?utf-8?B?TU5sQnQ1bzdrTlBNd1diSHp0QWZNbmJWd0xTSXRBeWhkTTE4bVY1cDhuU1lK?=
 =?utf-8?B?WHBFY3pmS1VuTWdTOUwvVUxXc0RmWFZRNDgyMlVzTm0wMHZYUmdad1ZxWUY3?=
 =?utf-8?B?eW4weDY0V2pUTDVaZC9iMmpnbk5vNGNMVmw1aHI3NEpzZjU1SFFINy9NY2kz?=
 =?utf-8?B?NlhZTlUzeDZkQUtmWnBYamo0U0lDNnU2dVFObEJCaEpWaEtYRUNoV1JoeXgy?=
 =?utf-8?Q?pIrmN+Qyft57Qy/HNgjVWlehQb2rfRFK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3deb031f-a048-4a94-539b-08da03584f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 12:11:45.0791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7zLESHGKxuASwZ/M3hScS2MXqzpry2v/HwSXZ+oJumlfRnzfQzx2xs47MwEkI8K7Q7JNoxXxiDGXLDEwnSVS5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1970
X-Proofpoint-ORIG-GUID: zNTJbcq0QD93Q5H00_ZF6mBP7KXQdsXb
X-Proofpoint-GUID: zNTJbcq0QD93Q5H00_ZF6mBP7KXQdsXb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_05,2022-03-11_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAxMCwg
MjAyMiAzOjQ4IEFNDQo+IFRvOiBNYW5pc2ggQ2hvcHJhIDxtYW5pc2hjQG1hcnZlbGwuY29tPg0K
PiBDYzogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT47IGt1YmFAa2VybmVsLm9y
ZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxs
LmNvbT47IEFsb2sgUHJhc2FkDQo+IDxwYWxva0BtYXJ2ZWxsLmNvbT47IFByYWJoYWthciBLdXNo
d2FoYSA8cGt1c2h3YWhhQG1hcnZlbGwuY29tPjsNCj4gRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBk
YXZlbWxvZnQubmV0PjsgR3JlZyBLSA0KPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBz
dGFibGVAdmdlci5rZXJuZWwub3JnOw0KPiBpdCtuZXRkZXZAbW9sZ2VuLm1wZy5kZTsgcmVncmVz
c2lvbnNAbGlzdHMubGludXguZGV2DQo+IFN1YmplY3Q6IFJlOiBbRVhUXSBSZTogW1BBVENIIHYy
IG5ldC1uZXh0IDEvMl0gYm54Mng6IFV0aWxpemUgZmlybXdhcmUNCj4gNy4xMy4yMS4wDQo+IA0K
PiBPbiBXZWQsIE1hciA5LCAyMDIyIGF0IDExOjQ2IEFNIE1hbmlzaCBDaG9wcmEgPG1hbmlzaGNA
bWFydmVsbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gVGhpcyBoYXMgbm90IGNoYW5nZWQgYW55
dGhpbmcgZnVuY3Rpb25hbGx5IGZyb20gZHJpdmVyL2RldmljZSBwZXJzcGVjdGl2ZSwNCj4gRlcg
aXMgc3RpbGwgYmVpbmcgbG9hZGVkIG9ubHkgd2hlbiBkZXZpY2UgaXMgb3BlbmVkLg0KPiA+IGJu
eDJ4X2luaXRfZmlybXdhcmUoKSBbSSBndWVzcywgcGVyaGFwcyB0aGUgbmFtZSBpcyBtaXNsZWFk
aW5nXSBqdXN0DQo+IHJlcXVlc3RfZmlybXdhcmUoKSB0byBwcmVwYXJlIHRoZSBtZXRhZGF0YSB0
byBiZSB1c2VkIHdoZW4gZGV2aWNlIHdpbGwgYmUNCj4gb3BlbmVkLg0KPiANCj4gU28gaG93IGRv
IHlvdSBleHBsYWluIHRoZSByZXBvcnQgYnkgUGF1bCBNZW56ZWwgdGhhdCB0aGluZ3MgdXNlZCB0
byB3b3JrIGFuZA0KPiBubyBsb25nZXIgd29yayBub3c/DQo+IA0KDQpUaGUgaXNzdWUgd2hpY2gg
UGF1bCBtZW50aW9uZWQgaGFkIHRvIGRvIHdpdGggIi9saWIvZmlybXdhcmUvYm54MngvKiBmaWxl
IG5vdCBmb3VuZCIgd2hlbiBkcml2ZXIgcHJvYmVzLCB3aGljaCB3YXMgaW50cm9kdWNlZCBieSB0
aGUgcGF0Y2ggaW4gc3ViamVjdCwNCkFuZCB0aGUgY29tbWl0IGUxM2FkMTQ0MzY4NCAoImJueDJ4
OiBmaXggZHJpdmVyIGxvYWQgZnJvbSBpbml0cmQiKSBmaXhlcyB0aGlzIGlzc3VlLiBTbyB0aGlu
Z3Mgc2hvdWxkIHdvcmsgYXMgaXQgaXMgd2l0aCB0aGUgbWVudGlvbmVkIGZpeGVkIGNvbW1pdC4N
ClRoZSBvbmx5IGRpc2N1c3Npb24gbGVkIGJ5IHRoaXMgcHJvYmxlbSBub3cgaXMgd2h5IHRoZSBy
ZXF1ZXN0X2Zpcm13YXJlKCkgd2FzIG1vdmVkIGVhcmx5IG9uIFtmcm9tIG9wZW4oKSB0byBwcm9i
ZSgpXSBieSB0aGUgcGF0Y2ggaW4gc3ViamVjdC4NCkkgZXhwbGFpbmVkIHRoZSBpbnRlbnRpb24g
dG8gZG8gdGhpcyBpbiBteSBlYXJsaWVyIGVtYWlscyBhbmQgbGV0IG1lIGFkZCBtb3JlIGRldGFp
bHMgYmVsb3cgLSANCg0KTm90ZSB0aGF0IHdlIGhhdmUganVzdCBtb3ZlZCByZXF1ZXN0X2Zpcm13
YXJlKCkgbG9naWMsICpub3QqIHNvbWV0aGluZyBzaWduaWZpY2FudCB3aGljaCBoYXMgdG8gZG8g
d2l0aCBhY3R1YWwgRlcgbG9hZGluZyBvciBkZXZpY2UgaW5pdGlhbGl6YXRpb24gZnJvbSB0aGUN
CkZXIGZpbGUgZGF0YSB3aGljaCBjb3VsZCBjYXVzZSBzaWduaWZpY2FudCBmdW5jdGlvbmFsIGNo
YW5nZSBmb3IgdGhpcyBkZXZpY2UvZHJpdmVyLCBGVyBsb2FkL2luaXQgcGFydCBzdGlsbCBzdGF5
cyBpbiBvcGVuIGZsb3cuDQoNCkJlZm9yZSB0aGUgcGF0Y2ggaW4gc3ViamVjdCwgZHJpdmVyIHVz
ZWQgdG8gb25seSB3b3JrIHdpdGggZml4ZWQvc3BlY2lmaWMgRlcgdmVyc2lvbiBmaWxlIHdob3Nl
IHZlcnNpb24gd2FzIHN0YXRpY2FsbHkga25vd24gdG8gdGhlIGRyaXZlciBmdW5jdGlvbiBhdCBw
cm9iZSgpIHRpbWUgdG8gdGFrZQ0Kc29tZSBkZWNpc2lvbiB0byBmYWlsIHRoZSBmdW5jdGlvbiBw
cm9iZSBlYXJseSBpbiB0aGUgc3lzdGVtIGlmIHRoZSBmdW5jdGlvbiBpcyBzdXBwb3NlZCB0byBy
dW4gd2l0aCBhIEZXIHZlcnNpb24gd2hpY2ggaXMgbm90IHRoZSBzYW1lIHZlcnNpb24gbG9hZGVk
IG9uIHRoZSBkZXZpY2UgYnkgYW5vdGhlciBQRiAoZGlmZmVyZW50IEVOVikuDQpOb3cgd2hlbiB3
ZSBzZW50IHRoaXMgbmV3IEZXIHBhdGNoIChpbiBzdWJqZWN0KSB0aGVuIHdlIGdvdCBmZWVkYmFj
ayBmcm9tIGNvbW11bml0eSB0byBtYWludGFpbiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IHdpdGgg
b2xkZXIgRlcgdmVyc2lvbnMgYXMgd2VsbCBhbmQgd2UgZGlkIGl0IGluIHNhbWUgdjIgcGF0Y2gg
bGVnaXRpbWF0ZWx5LA0KanVzdCB0aGF0IG5vdyB3ZSBjYW4gd29yayB3aXRoIGJvdGggb2xkZXIg
b3IgbmV3ZXIgRlcgZmlsZSBzbyB3ZSBuZWVkIHRoaXMgcnVuIHRpbWUgRlcgdmVyc2lvbiBpbmZv
cm1hdGlvbiB0byBjYWNoZSAoYmFzZWQgb24gcmVxdWVzdF9maXJtd2FyZSgpIHJldHVybiBzdWNj
ZXNzIHZhbHVlIGZvciBhbiBvbGQgRlcgZmlsZSBvciBuZXcgRlcgZmlsZSkNCndoaWNoIHdpbGwg
YmUgdXNlZCBpbiBmb2xsb3cgdXAgcHJvYmUoKSBmbG93cyB0byBkZWNpZGUgdGhlIGZ1bmN0aW9u
IHByb2JlIGZhaWx1cmUgZWFybHkgSWYgdGhlcmUgY291bGQgYmUgRlcgdmVyc2lvbiBtaXNtYXRj
aGVzIGFnYWluc3QgdGhlIGxvYWRlZCBGVyBvbiB0aGUgZGV2aWNlIGJ5IG90aGVyIFBGcyBhbHJl
YWR5DQoNClNvIHdlIG5lZWQgdG8gdW5kZXJzdGFuZCB3aHkgd2Ugc2hvdWxkIG5vdCBjYWxsIHJl
cXVlc3RfZmlybXdhcmUoKSBpbiBwcm9iZSBvciBhdCBsZWFzdCB3aGF0J3MgcmVhbGx5IGhhcm1m
dWwgaW4gZG9pbmcgdGhhdCBpbiBwcm9iZSgpIGlmIHNvbWUgb2YgdGhlIGZvbGxvdyB1cCBwcm9i
ZSBmbG93cyBuZWVkcw0Kc29tZSBvZiB0aGUgbWV0YWRhdGEgaW5mbyAobGlrZSB0aGUgcnVuIHRp
bWUgRlcgdmVyc2lvbnMgaW5mbyBpbiB0aGlzIGNhc2Ugd2hpY2ggd2UgZ2V0IGJhc2VkIG9uIHJl
cXVlc3RfZmlybXdhcmUoKSByZXR1cm4gdmFsdWUpLCB3ZSBjb3VsZCBhdm9pZCB0aGlzIGJ1dCB3
ZSBkb24ndCB3YW50DQp0byBhZGQgc29tZSB1Z2x5L3Vuc3VpdGFibGUgZmlsZSBBUElzIGNoZWNr
cyB0byBrbm93IHdoaWNoIEZXIHZlcnNpb24gZmlsZSBpcyBhdmFpbGFibGUgb24gdGhlIGZpbGUg
c3lzdGVtIGlmIHRoZXJlIGlzIGFscmVhZHkgYW4gQVBJIHJlcXVlc3RfZmlybXdhcmUoKSBhdmFp
bGFibGUgZm9yIHRoaXMgdG8gYmUgdXNlZC4NCg0KUGxlYXNlIGxldCB1cyBrbm93LiBUaGFua3Mu
DQoNCj4gWW91IGNhbid0IGRvIHJlcXVlc3RfZmlybXdhcmUoKSBlYXJseS4gV2hlbiB5b3UgYWN0
dWFsbHkgdGhlbiBwdXNoIHRoZQ0KPiBmaXJtd2FyZSB0byB0aGUgZGV2aWNlIGlzIGltbWF0ZXJp
YWwgLSBidXQgcmVxdWVzdF9maXJtd2FyZSgpIGhhcyB0byBiZSBkb25lDQo+IGFmdGVyIHRoZSBz
eXN0ZW0gaXMgdXAgYW5kIHJ1bm5pbmcuDQo+IA0KPiAgICAgICAgICAgICAgICAgIExpbnVzDQoN
Cg==
