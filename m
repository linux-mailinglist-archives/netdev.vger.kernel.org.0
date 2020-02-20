Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A616612A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBTPkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:40:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64672 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbgBTPkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:40:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KFdqDj005513;
        Thu, 20 Feb 2020 07:40:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=z4/Y2RKqxlrE9f+tNnFoxR506Q9kNivJJi+sOCKQTlY=;
 b=NocTA30zHf8n0gYRruK3mouIm/KyiaqhIxMpYqhxhBjwt+g8tfH2+bzZle6Isabok/yV
 1+tH7KbXsV2C1cVvtWaH8A3xB6YeB/WEg0FuGOFXxyAHW+qnIKDsinYOk+qytWM75cFz
 UFB5rHge3cNPV8Vud9eoYIf9p51e5AEv8vuige9zZXe+F7s7OC6LYlhYeysTLt/TR8li
 jnGa6DsTniITEel20PTvNKXidcuJTvfyipx2wUT20EddMv6qHrl+Wipbm67DNxA+mrWK
 46aeB2XAE0bVGxQjuUuLLRmANmGVe6HDUclUPq8EUuOwYVbXM9/EgOfHKJfuWPFG1pXd tQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y8ubv82aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 07:40:41 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Feb
 2020 07:40:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 20 Feb 2020 07:40:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImshT0JplBfJC7TcIlblNNkxaOrFPXYzqX6JsIkRus8aFKJ09e0yldQqWIAd7IsX7FRDAmtovEFdsA5Bo6j8+X4Bma36wpaAspDm8b3y7eMqFCtee8tAQJ7eHlnhCXB6NFnJYPPg33hTDtaufRlWUoTQ6x0O7xAUnUNsCvwZeXsd132auvwfx/LCRCdPcpOmmzDbRbn05y57AiWbq99We+WcqZ5EcuiuX4mrVBHSQn6dVxe404Z+JVhEyaMd4sllKAlGcvHY1FSwn5s/VcCFN8vNEoB+t4JqYpwscoWATCLpmwdLeG47Y8gG+6jF2h2y6hczvhpcY/QHubJqUvF8ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4/Y2RKqxlrE9f+tNnFoxR506Q9kNivJJi+sOCKQTlY=;
 b=BWnTeir1gP/QhKJUSz/Os+IATcGK5/rS7cm9w1Af3B39ohPmbccPUbZzx7XQhysyTm7XphHXhqqGVOYqDolCnfM1IRvUPfPGmOeLq94Ti24Eyt8MnoiwqueSDfsQK3xojCFmvOdsyaRM+zCr8rwmGon+HIqsZajypsf2eTlFw6/FMtK6wpjk7H9PzJr9/hbkgyXEK/xo2erZBuELbG9+HR8IezAHflcMPuw8nL15NIIi5Phpr2OaMWvIyLck353qY+NRg7hxq9Yjr6TR2DFhhGNwBLP2PBec4uXYDLa/VVmhdkuPjKpisNPE34BKYnlo//zoQAuMSTe+TjYkWh5WAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4/Y2RKqxlrE9f+tNnFoxR506Q9kNivJJi+sOCKQTlY=;
 b=oF9Qqd0k3cRCZCfDY/2vuTouspWTaVSz7Jmwx51RPxWF6JuTTXtZCo/7OdKI7VInEBLtLMG8c0rbBLzl1i1zJ9C/vwvHfYi+RAHl0NYmZhRuo0noQZJIZPz8CiC5WVNUX3nTZ6Wn5oW73w1+H7dOIzoajXbHSBnekq+/j628Afk=
Received: from DM5PR18MB2215.namprd18.prod.outlook.com (2603:10b6:4:b7::18) by
 DM5PR18MB1212.namprd18.prod.outlook.com (2603:10b6:3:b9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Thu, 20 Feb 2020 15:40:38 +0000
Received: from DM5PR18MB2215.namprd18.prod.outlook.com
 ([fe80::bc55:e2d3:1159:1a1a]) by DM5PR18MB2215.namprd18.prod.outlook.com
 ([fe80::bc55:e2d3:1159:1a1a%5]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 15:40:38 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "it+linux-netdev@molgen.mpg.de" <it+linux-netdev@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: bnx2x: Latest firmware requirement breaks no regression
 policy
Thread-Topic: [EXT] Re: bnx2x: Latest firmware requirement breaks no
 regression policy
Thread-Index: AQHV5wGCvUlGLJk7UUybWaBU9BXeqKgidnIAgAFYngCAAGbFwA==
Date:   Thu, 20 Feb 2020 15:40:37 +0000
Message-ID: <DM5PR18MB221508B070C5C2DAE8ADB053C4130@DM5PR18MB2215.namprd18.prod.outlook.com>
References: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
 <MN2PR18MB2528C681601B34D05100DF89D3100@MN2PR18MB2528.namprd18.prod.outlook.com>
 <8daadcd1-3ff2-2448-7957-827a71ae4d2e@molgen.mpg.de>
 <MN2PR18MB2528EC91E410FD1BE9FC3EF5D3130@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528EC91E410FD1BE9FC3EF5D3130@MN2PR18MB2528.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb378971-a546-4844-243c-08d7b61b3bdd
x-ms-traffictypediagnostic: DM5PR18MB1212:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1212AED2971FCF64287FD991C4130@DM5PR18MB1212.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39840400004)(136003)(376002)(346002)(396003)(199004)(189003)(316002)(52536014)(64756008)(66446008)(6506007)(53546011)(966005)(66946007)(6636002)(66476007)(76116006)(110136005)(66556008)(4326008)(81166006)(9686003)(33656002)(478600001)(8936002)(5660300002)(8676002)(186003)(7696005)(54906003)(2906002)(26005)(71200400001)(86362001)(55016002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1212;H:DM5PR18MB2215.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NfbfXTC1Pc6Qf0SSQlhqZhjYLClXzjAKBROZs1qUhSJGQIzTVWGWGUxcQta3EWUFli7KLFasfraCOj9yiJ/yXmlirDBk9UWaUep0IINDgRdUnzIpuqyQ0mhPzhAcLdpStv0tkUqFz7Lxw3tbMhnfTny2ylM/EqXWJe+1UGoagHMpJab1HM1hLlBC8OIzVKNlGLwqWFVctbEJgXn+k75lKScBHHtdBWnVCAl4MQopO7Mcabm9s9iejjkLHXC3SGI3tQB8fZXr3jjyQtfJHA/r7r0lJM7HDVMwkVRDdSYds9IuaGfhY5AYipIu010bmwfG3hR8hw1cA8qxNPo8pxY51Q8aXMRokxlF4N3kXCcjuvcFXUvNKUK/J6ydXmxyXGO4MBjEMDt+Rk89GkBUWqTPHFYOHYn9GqtnMX1sFVwJK5f/3qfyiP80vbOtIQ1/rUY4Es5hgn9hWnKm+x6xQGLDRDpL+wz0q59CFnYxrJFwRD2LLxX80OrasOtdJjI6tyJsmWvEAU7WuUzLpzzrXjbKlA==
x-ms-exchange-antispam-messagedata: Y1N+BnWoHlyNJwnQkDSypzo5nS/6APrx9j0mFZAXU2/GDjFa9/5BHiDFbicFDx6mIf0fbKbI4qnwiXOOuGlL0C6zHUrWSchmVzd5VkW09jJgNhVuMME2/XPtTij9K1KU8TNZ/pVhtkJo+Lyk37dO4w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eb378971-a546-4844-243c-08d7b61b3bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 15:40:37.9076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hgmhOtEPPsnqgVCxxe5jHLOkOqjk/gwZ7U6AuaGzXNminO25aR6hKpzE4JmrVBy/AbzZ6e9ox1fX3W5C4rkgYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1212
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_04:2020-02-19,2020-02-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTdWRhcnNhbmEgUmVkZHkgS2Fs
bHVydSA8c2thbGx1cnVAbWFydmVsbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAy
MCwgMjAyMCAxMToxNyBBTQ0KPiBUbzogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5k
ZT47IEFyaWVsIEVsaW9yDQo+IDxhZWxpb3JAbWFydmVsbC5jb20+OyBHUi1ldmVyZXN0LWxpbnV4
LWwyIDxHUi1ldmVyZXN0LWxpbnV4LQ0KPiBsMkBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBpdCts
aW51eC0NCj4gbmV0ZGV2QG1vbGdlbi5tcGcuZGU7IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD4NCj4gU3ViamVjdDogUkU6IFtFWFRdIFJlOiBibngyeDogTGF0ZXN0IGZpcm13
YXJlIHJlcXVpcmVtZW50IGJyZWFrcyBubyByZWdyZXNzaW9uDQo+IHBvbGljeQ0KPiANCj4gSGkg
UGF1bCwNCj4gICAgIEJueDJ4IGRyaXZlciBhbmQgdGhlIHN0b3JtIEZXIGFyZSB0aWdodGx5IGNv
dXBsZWQsIGFuZCB0aGUgaW5mbyBpcyBleGNoYW5nZWQNCj4gYmV0d2VlbiB0aGVtIHZpYSBzaG1l
bSAoaS5lLiwgY29tbW9uIHN0cnVjdHVyZXMgd2hpY2ggbWlnaHQgY2hhbmdlDQo+IGJldHdlZW4g
dGhlIHJlbGVhc2VzKS4gQWxzbywgRlcgcHJvdmlkZXMgc29tZSBvZmZzZXQgYWRkcmVzc2VzIHRv
IHRoZSBkcml2ZXINCj4gd2hpY2ggY291bGQgY2hhbmdlIGJldHdlZW4gdGhlIEZXIHJlbGVhc2Vz
LCBmb2xsb3dpbmcgaXMgb25lIHN1Y2ggY29tbWl0LA0KPiAJaHR0cHM6Ly93d3cuc3Bpbmljcy5u
ZXQvbGlzdHMvbmV0ZGV2L21zZzYwOTg4OS5odG1sDQo+IEhlbmNlIGl0J3Mgbm90IHZlcnkgc3Ry
YWlnaHQgZm9yd2FyZCB0byBwcm92aWRlIHRoZSBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IGkuZS4s
DQo+IG5ld2VyICh1cGRhdGVkKSBrZXJuZWwgZHJpdmVyIHdpdGggdGhlIG9sZGVyIEZXLg0KPiBD
dXJyZW50bHkgd2UgZG9u4oCZdCBoYXZlIHBsYW5zIHRvIGltcGxlbWVudCB0aGUgbmV3IG1vZGVs
IG1lbnRpb25lZCBiZWxvdy4NCj4gDQo+IFRoYW5rcywNCj4gU3VkYXJzYW5hDQpIaSwNClRoZXJl
IGFyZSBhZGRpdGlvbmFsIHJlYXNvbnMgd2h5IGJhY2t3YXJkcy9mb3J3YXJkcyBjb21wYXRpYmls
aXR5IGNvbnNpZGVyYXRpb25zDQphcmUgbm90IGFwcGxpY2FibGUgaGVyZS4gVGhpcyBGdyBpcyBu
b3QgbnZyYW0gYmFzZWQsIGFuZCBkb2VzIG5vdCByZXNpZGUgaW4gdGhlDQpkZXZpY2UuIEl0IGlz
IHByb2dyYW1lZCB0byB0aGUgZGV2aWNlIG9uIGV2ZXJ5IGRyaXZlciBsb2FkLiBUaGUgZHJpdmVy
IHdpbGwNCm5ldmVyIGZhY2UgYSBkZXZpY2UgImFscmVhZHkgaW5pdGlhbGl6ZWQiIHdpdGggYSB2
ZXJzaW9uIG9mIEZXIGl0IGlzIG5vdA0KZmFtaWxpYXIgd2l0aC4NClRoZSBkZXZpY2UgYWxzbyBo
YXMgdHJhZGl0aW9uYWwgbWFuYWdlbWVudCBGVyBpbiBudnJhbSBpbiB0aGUgZGV2aWNlIHdpdGgg
d2hpY2gNCndlIGhhdmUgYSBiYWNrd2FyZHMgYW5kIGZvcndhcmRzIGNvbXBhdGliaWxpdHkgbWVj
aGFuaXNtLCB3aGljaCB3b3JrcyBqdXN0DQpmaW5lLg0KQnV0IHRoZSBGVyB1bmRlciBkaXNjdXNz
aW9uIGlzIGZhc3RwYXRoIEZ3LCB1c2VkIHRvIGNyYWZ0IGV2ZXJ5IHBhY2tldCBnb2luZyBvdXQN
Cm9mIHRoZSBkZXZpY2UgYW5kIGFuYWx5emUgYW5kIHBsYWNlIGV2ZXJ5IHBhY2tldCBjb21pbmcg
aW50byB0aGUgZGV2aWNlLg0KU3VwcG9ydGluZyBtdWx0aXBsZSB2ZXJzaW9ucyBvZiBGVyB3b3Vs
ZCBiZSB0YW50YW1vdW50IHRvIGltcGxlbWVudGluZyBkb3plbnMgb2YNCnZlcnNpb25zIG9mIHN0
YXJ0X3htaXQgYW5kIG5hcGlfcG9sbCBpbiB0aGUgZHJpdmVyIChub3QgdG8gbWVudGlvbiBtdWx0
aXBsZQ0KZmFzdHBhdGggaGFuZGxlcyBvZiBhbGwgdGhlIG9mZmxvYWRzIHRoZSBkZXZpY2Ugc3Vw
cG9ydHMsIHJvY2UsIGlzY3NpLCBmY29lIGFuZA0KaXdhcnAsIGFzIGFsbCBvZiB0aGVzZSBhcmUg
b2ZmbG9hZGVkIGJ5IHRoZSBGVykuDQpUaGUgZW50aXJlIGRldmljZSBpbml0aWFsaXphdGlvbiBz
ZXF1ZW5jZSBhbHNvIGNoYW5nZXMgc2lnbmlmaWNhbnRseSBmcm9tIG9uZSBGVw0KdmVyc2lvbiB0
byB0aGUgTmV4dC4gQWxsIG9mIHRoZXNlIGRpZmZlcmVuY2VzIGFyZSBhYnN0cmFjdGVkIGF3YXkg
aW4gdGhlIEZXDQpmaWxlLCB3aGljaCBpbmNsdWRlcyB0aGUgaW5pdCBzZXF1ZW5jZSBhbmQgdGhl
IGNvbXBpbGVkIEZXLiBUaGUgYW1vdW50IG9mDQpjaGFuZ2VzIHJlcXVpcmVkIGluIGRyaXZlciBh
cmUgdmVyeSBzaWduaWZpY2FudCB3aGVuIG1vdmluZyBmcm9tIG9uZSB2ZXJzaW9uIHRvDQp0aGUg
bmV4dC4gVHJ5aW5nIHRvIGtlZXAgYWxsIHRob3NlIHZlcnNpb25zIGFsaXZlIGNvbmN1cnJlbnRs
eSB3b3VsZCBjYXVzZSB0aGlzDQphbHJlYWR5IHZlcnkgbGFyZ2UgZHJpdmVyIHRvIGJlIDIweCBs
YXJnZXIuDQpXZSBkb24ndCBoYXZlIGEgbWV0aG9kIG9mIGtlZXBpbmcgdGhlIGRldmljZSBvcGVy
YXRpb25hbCBpZiB0aGUga2VybmVsIHdhcw0KdXBncmFkZWQgYnV0IGZpcm13YXJlIHRyZWUgd2Fz
IG5vdCB1cGRhdGVkLiBUaGUgYmVzdCB0aGF0IGNhbiBiZSBkb25lIGlzIHJlcG9ydA0KdGhlIHBy
b2JsZW0sIHdoaWNoIGlzIHdoYXQgd2UgZG8uDQpUaGFua3MsDQpBcmllbA0K
