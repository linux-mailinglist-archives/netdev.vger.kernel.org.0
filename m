Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EAA226CDE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgGTRIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:08:34 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:18567 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgGTRIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:08:31 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2020 13:08:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2398; q=dns/txt; s=iport;
  t=1595264909; x=1596474509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VX3c/+Mxe9HMyKrf6gzXcvD3vCStJB5sHZuUnRwt/mk=;
  b=Op/V/+g1IzbX7ZMEo9X8IJbH86i04l8NDIwQsNZPOICnjYirQQr7Om+A
   y7LPHwYbUoBXxby+TvvAQaWMbZPmOB7/6lXRuGa6giqXpcq60AUSGx1m/
   zHRUtRIlYcahWtG8hOCv7RS6bvMeYEltvNv0rVX29iAgHz+zVCvUaNHWX
   w=;
IronPort-PHdr: =?us-ascii?q?9a23=3A2k0rjhXisYcjptYXSkk1s2gacU3V8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSBNyHuf1BguvS9avnXD9I7ZWAtSUEd5pBH1?=
 =?us-ascii?q?8AhN4NlgMtSMiCFQXgLfHsYiB7eaYKVFJs83yhd0QAHsH4ag7dp3Sz6XgZHR?=
 =?us-ascii?q?CsfQZwL/7+T4jVicn/3uuu+prVNgNPgjf1Yb57IBis6wvLscxDiop5IaF3wR?=
 =?us-ascii?q?zM8XY=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CrBQCLzBVf/5FdJa1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgUqBUlEHgUcvLAqEKYNGA41LigKOXIJTA1ULAQEBDAEBLQI?=
 =?us-ascii?q?EAQGETAIXgggCJDgTAgMBAQsBAQUBAQECAQYEbYVcDIVyAQEBAxIREQwBATc?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIfERUQAgQBDQUbB4MEgkwDLQEBoDcCgTmIYXaBMoMBAQE?=
 =?us-ascii?q?FhQ0NC4IOCRR6KoJqg1WGM4IagTgcgk0+ghqCI4MWM4ItgUcBjXOCXzyiKE0?=
 =?us-ascii?q?GBIJdlHOEcAMVCYJ6iT6TEC2RVI0EkXsCBAIEBQIOAQEFgWojgVdwUCoBc4F?=
 =?us-ascii?q?LUBcCDY4eg3GKVnQ3AgYBBwEBAwl8jgIBgRABAQ?=
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="790727111"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Jul 2020 17:01:13 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 06KH1DKp004879
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 20 Jul 2020 17:01:13 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 12:01:13 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 13:01:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 20 Jul 2020 12:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jV4dDuK638lYiLJypWbKUOtbraHutmEw+NNQR1teB/OGahbMm+p0zwdSJ8Rcn9V1Emfw1g6jf8oIFywfLiPklnK49tEIFdcyAvERT8D9u7dRgm0NR6Xy7gxNOqMAXU5/r6YiyZzwcOSQU1SQCGqobzO1S5qjvuETFR2EKx/a8JrtD8whH29y0MGlO/PHx7HbiYtPQ+Xt0ExcNtCeMtABaaGbnQqZzfNwVAQ49fRs8bAE5kaApOy7CzmsAai8iKGRgN9Me5MsDgUFn6Ko1MqM+tjkDVpri2k+0eckPlBOHpXr2K3dbIrh0sECEXpaSLDM1IWAsPfEoerVqZUa51qHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX3c/+Mxe9HMyKrf6gzXcvD3vCStJB5sHZuUnRwt/mk=;
 b=Zz/npAafgC8HqSHudTsDOmlErbUnr3q60/MR/UnU5fuGcYCBlPMHyLsO1LbvP+Bv5GrsbP+yvC+L+y0Vwr0upSG+PUS4Vt2l/zWRXHOJq1+ZdLwo+bFBk6jhjFdqYdZQ6Q/aPDDDNx+igiDZlOVLODRrFneFSpc8WVFXzmyqLN7YznbltndKue/7nuu/8AKgt5VCH4Dl4uXV0+KjWVgX2usHAcJaQ3HUWpSXfmkgx7Iwyf88jT81zvnEOCyVB31XR6TY6rv2oLni7SOS4WeURA7vg3RU+xmTjAjyrmqKhvCloLqdxsmD5wfQnniqHb4Ke2ZMEX67C5rS6sVviclV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX3c/+Mxe9HMyKrf6gzXcvD3vCStJB5sHZuUnRwt/mk=;
 b=zCG7KMAry1RiEPGBywgtax2xRxEXpbv9A4duziRJ71QVSrn2fvRpwDBWYHWeqjrB/GHKFkgHryKv6H+T1HyvBX/D2qi22h6QozJM7Pa69hY+Le1jhmi/em4bUKButq0G/iBuav/UPsE1KL8kz7LkW+5NrNIrTGv4x75cOoshMO4=
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by CY4PR11MB1255.namprd11.prod.outlook.com
 (2603:10b6:903:30::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Mon, 20 Jul
 2020 17:01:11 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766%11]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 17:01:10 +0000
From:   "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
Thread-Topic: [PATCH v2] AF_PACKET doesnt strip VLAN information
Thread-Index: AQHWXRxVWAaissRR4kW2xbRd/pNvc6kP2PgOgACm0ICAAJDsAA==
Date:   Mon, 20 Jul 2020 17:01:09 +0000
Message-ID: <EFC5EACE-753A-430E-84D5-E22C3F8C5106@cisco.com>
References: <20200718091732.8761-1-srirakr2@cisco.com>
 <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
 <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
 <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com>
In-Reply-To: <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.39.20071300
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [106.51.23.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f70b15a2-2605-4840-7b81-08d82cce8048
x-ms-traffictypediagnostic: CY4PR11MB1255:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB1255772781983656C6915970907B0@CY4PR11MB1255.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOLuYBEuNN5VrRJZld7vUGm91CvzcmSPyZKrwkEQDatT2orkVDba5GVuw0iveJpBfsd0+6kz9wBAivR+UtFOoP3Q6wTh6W8Ik+Nl1uY0VoVLvtOwDB/F0bJb+n2tbqn26Qb17uptYQtb92lNIokwjMVkNXF1yb2Y+N4KeWG2Enn/W3x6b4ZaDinr3sgfHQmfHn167eWdNS9ryBvGGYcg+oDWE/nJZ7ZgOcNjO6QZlbRMuKi7OZp9gOpv6ZJ8yVxuROXzUMPsVlL1fB5qinJ2vZGv6vy2plXVn0uyXw4gFopPADl/wLIuxiP5A/6OV0ETtNixf1Z2kn618z95z3cv+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(6486002)(4326008)(478600001)(91956017)(83380400001)(6512007)(2906002)(8936002)(54906003)(110136005)(36756003)(8676002)(5660300002)(64756008)(66446008)(66476007)(66556008)(66946007)(316002)(76116006)(107886003)(55236004)(186003)(26005)(33656002)(6506007)(53546011)(86362001)(2616005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TE1pElfmz6IaoRSJrEX72PoKPSQddai0YN2xIAD2Uj12ShCicVPdkwGzAc4FGi7Ck0p6SgaupqONZ9sG4c+NFYL2Vx0so0eqJNACgqE6AGJc+OraCXjZ70yG7XaGPiQZLpIEHYTm7QVg3TDosLH+xto8CkFTOQbawHX0uLR61dLzZzn1/hyzlGlz74Au5r3n4w1nrhV5QLpkVzeyMSSsYeK9xJwBL3U8iFH6fjEuZuJRwNHnKZxPzJd72xJPcMtLAo/UIEi88Bsvd5XpLSF+ENN/ii5ZTor2dGznp7yGACUa7FHfQS9DJscNvUA4lvk1zYY9ciooGjrDJDOPgk22FW22QpPrrWWNyLQFUmQ3WBhF7UXyQdFpG37+Y++6Hh3oU1kEG6QdgqkluBU4/NA0jCTcPWzMAR6FEO2xyc3sw3QZBEfR3Hec1RtryKFnbvXKN9VFifitK0ZKXA2qOiavfvfI7WnSNAgmpsIu/CpOqWA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF9E762792042549AB7B66B438024889@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70b15a2-2605-4840-7b81-08d82cce8048
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 17:01:09.8255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5iLwI1PnTalode6cAsTuKOiMJB47c3WZsadnPql44kpooGHQTef9XBioePdHs5f4EpRMa7ljlGLklDsrwrOcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1255
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBoYXZlIG1vdmVkIHRoZSBjb2RlIHRvIHRoZSBkcml2ZXIgYW5kIHB1c2hlZCBhIG5ldyBwYXRj
aCBkdWUgdG8gdGhlIGJlbG93IGhpZ2hsaWdodGVkIGlzc3Vlcy4NCg0KU3RlcGhlbiBILA0KUGxl
YXNlIGxldCBtZSBrbm93IGlmIHlvdSBoYXZlIGFueSBjb25jZXJucyBsb2NhbGlzaW5nIHRoZSBj
aGFuZ2VzIHRvIHRoZSBuZXR2c2MgZHJpdmVyLg0KDQoNClRoYW5rcywNClNyaXJhbQ0KDQrvu79P
biAyMC8wNy8yMCwgNzoyMyBQTSwgIldpbGxlbSBkZSBCcnVpam4iIDx3aWxsZW1kZWJydWlqbi5r
ZXJuZWxAZ21haWwuY29tPiB3cm90ZToNCg0KICAgIE9uIE1vbiwgSnVsIDIwLCAyMDIwIGF0IDEy
OjI3IEFNIFNyaXJhbSBLcmlzaG5hbiAoc3JpcmFrcjIpDQogICAgPHNyaXJha3IyQGNpc2NvLmNv
bT4gd3JvdGU6DQogICAgPg0KICAgID4gK1N0ZXBoZW4gSGVtbWluZ2VyDQogICAgPg0KICAgID4g
SGkgV2lsbGVtLA0KICAgID4gVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhlIGNvZGUsIEkgdW5k
ZXJzdGFuZCB0aGF0IHRoaXMgaXMgbW9yZSBvZiBhIGdlbmVyaWMgcHJvYmxlbSB3aGVyZWluIG1h
bnkgb2YgdGhlIGZpbHRlcmluZyBmdW5jdGlvbnMgYXNzdW1lIHRoZSB2bGFuIHRhZyB0byBiZSBp
biB0aGUgc2tiIHJhdGhlciB0aGFuIGluIHRoZSBwYWNrZXQuIEhlbmNlIHdlIG1vdmVkIHRoZSBm
aXggZnJvbSB0aGUgZHJpdmVyIHRvIHRoZSBjb21tb24gQUYgcGFja2V0IHRoYXQgb3VyIHNvbHV0
aW9uIHVzZXMuDQogICAgPg0KICAgID4gSSByZWNhbGwgZnJvbSB0aGUgdjEgb2YgdGhlIHBhdGNo
IHlvdSBoYWQgbWVudGlvbmVkIG90aGVyIGNvbW1vbiBhcmVhcyB3aGVyZSB0aGlzIGZpeCBtaWdo
dCBiZSByZWxldmFudCAoc3VjaCBhcyB0YXAvdHVuKSwgYnV0IEknbSBhZnJhaWQgSSBjYW50IGNv
bXByZWhlbnNpdmVseSB0ZXN0IHRob3NlIHBhdGNoZXMgb3V0LiBQbGVhc2UgbGV0IG1lIGtub3cg
eW91ciB0aG91Z2h0cw0KDQogICAgUGxlYXNlIHVzZSBwbGFpbiB0ZXh0IHRvIHJlc3BvbmQuIEhU
TUwgcmVwbGllcyBkbyBub3QgcmVhY2ggdGhlIGxpc3QuDQoNCiAgICBDYW4geW91IGJlIG1vcmUg
cHJlY2lzZSBpbiB3aGljaCBvdGhlciBjb2RlIGJlc2lkZXMgdGhlIGh5cGVyLXYgZHJpdmVyDQog
ICAgaXMgYWZmZWN0ZWQ/IERvIHlvdSBoYXZlIGFuIGV4YW1wbGU/DQoNCiAgICBUaGlzIGlzIGEg
cmVzdWJtaXQgb2YgdGhlIG9yaWdpbmFsIHBhdGNoLiBNeSBwcmV2aW91cw0KICAgIHF1ZXN0aW9u
cy9jb25jZXJucyByZW1haW4gdmFsaWQ6DQoNCiAgICAtIGlmIHRoZSBmdW5jdGlvbiBjYW4gbm93
IGZhaWwsIGFsbCBjYWxsZXJzIG11c3QgYmUgdXBkYXRlZCB0byBkZXRlY3QNCiAgICBhbmQgaGFu
ZGxlIHRoYXQNCg0KICAgIC0gYW55IHNvbHV0aW9uIHNob3VsZCBwcm9iYWJseSBhZGRyZXNzIGFs
bCBpbnB1dHMgaW50byB0aGUgdHggcGF0aDoNCiAgICBwYWNrZXQgc29ja2V0cywgdHVudGFwLCB2
aXJ0aW8tbmV0DQoNCiAgICAtIHRoaXMgb25seSBhZGRyZXNzZXMgcGFja2V0IHNvY2tldHMgd2l0
aCBFVEhfUF9BTEwvRVRIX1BfTk9ORS4gTm90DQogICAgc29ja2V0cyB0aGF0IHNldCBFVEhfUF84
MDIxUQ0KDQogICAgLSB3aGljaCBjb2RlIGluIHRoZSB0cmFuc21pdCBzdGFjayByZXF1aXJlcyB0
aGUgdGFnIHRvIGJlIGluIHRoZSBza2IsDQogICAgYW5kIGRvZXMgdGhpcyBwcm9ibGVtIGFmdGVy
IHRoaXMgcGF0Y2ggc3RpbGwgcGVyc2lzdCBmb3IgUS1pbi1RPw0KDQo=
