Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6742DBD131
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437445AbfIXSHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:07:33 -0400
Received: from mail-eopbgr720125.outbound.protection.outlook.com ([40.107.72.125]:35727
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437035AbfIXSHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:07:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhIb8u1fTayxIg4b/YEh1Rjt67Oc12Rn58RxWLyuCXNVXSWV+B+FOW4jBbtI4JtgaAp0OpcvJwhpFEjgFxN3dboGYhLPHRGy1NAfgcljyri5pIbB1aXZgAtcEAK5p/QNXLp8i8CmDCCpGTq+haudIq7gW7PcIhYcOlftFySpa5szzJ25N2i5pfx0ubEoT1f48AcdKiOEDEivzRdt47iD/yr5oak8E9F6YgVArSO3xkyjE46Oi2SkSEcEjCJk9AE0vBRGSus5IP2WsD9nUsYb3req925TJZ3W/LAt43TAMa+wAU+rG/x/BBZ25Ki4UZ8440nQL60GYVZtpJOpjtdRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJruZwRdtCmRP541Gb9CtAJTmVu7pcgKdU4mMjvD1II=;
 b=XgyyjRbbIgVKTQ5X+B52GBKVKAQDy3ZjAHwJv8kdoSlE1EB1iZ157LrHWVRpUFR5ZLu2xTaUXXXoJ0PDRv+LVoFfgkI7VTzk5ZTQfHgBOMvpM4paZ02FwqjgZ8R1uXIhzjTbNv/dKZ5q8brtoAMzdlJHy+pZMB1XFeXwpRg3WYkOAfXY2Y1UfM/9iLowVXUSLHqL5fzT8qS5yGTUh84Otiuq+pPqKCKtG3/AdlB3HtK++ONVVLaN9YMCU4lBXtFPGSfiQFQthY9LW9sJFUoQ/d3HjcTTYybmxEBfsfCHMbofxuJmDBkVyr2tZQJMtLhLTDvxFgrZgc8uaystkFPLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 160.33.194.230) smtp.rcpttodomain=arm.com smtp.mailfrom=sony.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=sony.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJruZwRdtCmRP541Gb9CtAJTmVu7pcgKdU4mMjvD1II=;
 b=qfb4P1lPLGuu4hGg+VDzdYHa5XZ9G4SmtSyCxiSJFIPGmsoPNzkmBdOcK5Ftiu05BnP0kRYCZ51pFIqHWrX7I3dLCYJ4LH+wg09TwihdZSenn1IZPVOfgy/arMZavypcoN7bSB3dGJUGusCAqCH+sEbHem+/xRBuMpX5zYGLB5w=
Received: from MWHPR13CA0010.namprd13.prod.outlook.com (2603:10b6:300:16::20)
 by MWHPR13MB1453.namprd13.prod.outlook.com (2603:10b6:300:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2305.13; Tue, 24 Sep
 2019 18:07:26 +0000
Received: from SN1NAM02FT007.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by MWHPR13CA0010.outlook.office365.com
 (2603:10b6:300:16::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2305.11 via Frontend
 Transport; Tue, 24 Sep 2019 18:07:26 +0000
Authentication-Results: spf=pass (sender IP is 160.33.194.230)
 smtp.mailfrom=sony.com; arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=pass action=none header.from=sony.com;
Received-SPF: Pass (protection.outlook.com: domain of sony.com designates
 160.33.194.230 as permitted sender) receiver=protection.outlook.com;
 client-ip=160.33.194.230; helo=usculsndmail03v.am.sony.com;
Received: from usculsndmail03v.am.sony.com (160.33.194.230) by
 SN1NAM02FT007.mail.protection.outlook.com (10.152.72.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25 via Frontend Transport; Tue, 24 Sep 2019 18:07:25 +0000
Received: from usculsndmail14v.am.sony.com (usculsndmail14v.am.sony.com [146.215.230.105])
        by usculsndmail03v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x8OI7ORn001246;
        Tue, 24 Sep 2019 18:07:24 GMT
Received: from USCULXHUB08V.am.sony.com (usculxhub08v.am.sony.com [146.215.231.169])
        by usculsndmail14v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x8OI7NhY011348;
        Tue, 24 Sep 2019 18:07:24 GMT
Received: from USCULXMSG01.am.sony.com ([fe80::b09d:6cb6:665e:d1b5]) by
 USCULXHUB08V.am.sony.com ([146.215.231.169]) with mapi id 14.03.0439.000;
 Tue, 24 Sep 2019 14:07:23 -0400
From:   <Tim.Bird@sony.com>
To:     <cristian.marussi@arm.com>, <skhan@linuxfoundation.org>,
        <alexei.starovoitov@gmail.com>, <daniel@iogearbox.net>
CC:     <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: RE: Linux 5.4 - bpf test build fails
Thread-Topic: Linux 5.4 - bpf test build fails
Thread-Index: AQHVcuyKCwQm1Wb0Hk6kQMx/hiriUKc7PXgAgAADAYCAAAn5gIAADggA///GalA=
Date:   Tue, 24 Sep 2019 18:07:16 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF977BCBF5@USCULXMSG01.am.sony.com>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
 <34a9bd63-a251-0b4f-73b6-06b9bbf9d3fa@linuxfoundation.org>
 <a603ee8e-b0af-6506-0667-77269b0951b2@linuxfoundation.org>
 <c3dda8d0-1794-ffd1-4d76-690ac2be8b8f@arm.com>
In-Reply-To: <c3dda8d0-1794-ffd1-4d76-690ac2be8b8f@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [146.215.231.6]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:160.33.194.230;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(39860400002)(13464003)(189003)(199004)(70586007)(47776003)(229853002)(70206006)(305945005)(6666004)(7736002)(55846006)(55016002)(37786003)(8676002)(5660300002)(86362001)(2201001)(6246003)(8936002)(246002)(2876002)(446003)(186003)(316002)(54906003)(126002)(476003)(11346002)(486006)(478600001)(53546011)(4326008)(33656002)(336012)(426003)(436003)(356004)(106002)(7696005)(110136005)(50466002)(23676004)(26005)(76176011)(14444005)(102836004)(2486003)(66066001)(2906002)(6116002)(3846002)(5001870100001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR13MB1453;H:usculsndmail03v.am.sony.com;FPR:;SPF:Pass;LANG:en;PTR:mail03.sonyusa.com,mail.sonyusa.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1db30408-08ab-4c3e-ac83-08d7411a0e01
X-MS-TrafficTypeDiagnostic: MWHPR13MB1453:
X-Microsoft-Antispam-PRVS: <MWHPR13MB1453D49765A6C099DB049B87FD840@MWHPR13MB1453.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0170DAF08C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLnSsyud1QQ6Soygkx6OcqxvB/JrUUtERr/BB/C82j4qFyTcTmIO5ldmb4Rn9SscpUp8w0gykMDyt6BkrOCZ4omDvlyCtamm50xHS1b4+BAPC39BJFE18ihFJ/9vTt0NfsRoonW3W/eQfFSZTLqgyXhGTkljnhlYed3FfNIK+2RdSBKXxo5u3QTWLhnZLNf9iSfWrc3tTVA7+idg6gzQppF3g8+1M0bRFVfk1WRs5c3sYS+WXuYau+ntyclGLKIMDsJ9qVU+0HhpkHOgW8QbRRq4FaKNWG9FyJB0QKexflhWpzlnJTkTlER6ZoAZSq0JeUtj4BINk19uvaCukqPduFaRyjPAWX/qiMLZqcaqZGBAPAhjsMeyoo5kynxmfdTxEsn+9nb1c9Dq64SQ7X6I7rVYYXuypvkR9Gz4IKBa3AY=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2019 18:07:25.4689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db30408-08ab-4c3e-ac83-08d7411a0e01
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[160.33.194.230];Helo=[usculsndmail03v.am.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1453
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ3Jpc3RpYW4gTWFydXNz
aSBvbiBUdWVzZGF5LCBTZXB0ZW1iZXIgMjQsIDIwMTkgNzozMCBBTQ0KPiANCj4gSGkgU2h1YWgN
Cj4gDQo+IE9uIDI0LzA5LzIwMTkgMTc6MzksIFNodWFoIEtoYW4gd3JvdGU6DQo+ID4gT24gOS8y
NC8xOSAxMDowMyBBTSwgU2h1YWggS2hhbiB3cm90ZToNCj4gPj4gT24gOS8yNC8xOSA5OjUyIEFN
LCBDcmlzdGlhbiBNYXJ1c3NpIHdyb3RlOg0KPiA+Pj4gSGkgU2h1YWgNCj4gPj4+DQo+ID4+PiBP
biAyNC8wOS8yMDE5IDE2OjI2LCBTaHVhaCBLaGFuIHdyb3RlOg0KPiA+Pj4+IEhpIEFsZXhlaSBh
bmQgRGFuaWVsLA0KPiA+Pj4+DQo+ID4+Pj4gYnBmIHRlc3QgZG9lc24ndCBidWlsZCBvbiBMaW51
eCA1LjQgbWFpbmxpbmUuIERvIHlvdSBrbm93IHdoYXQncw0KPiA+Pj4+IGhhcHBlbmluZyBoZXJl
Lg0KPiA+Pj4+DQo+ID4+Pj4NCj4gPj4+PiBtYWtlIC1DIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi8NCj4gPj4+DQo+ID4+PiBzaWRlIHF1ZXN0aW9uLCBzaW5jZSBJJ20gd3JpdGluZyBhcm02
NC8gdGVzdHMuDQo+ID4+Pg0KPiA+Pj4gbXkgImJ1aWxkLXRlc3RjYXNlcyIgZm9sbG93aW5nIHRo
ZSBLU0ZUIGRvY3MgYXJlOg0KPiA+Pj4NCj4gPj4+IG1ha2Uga3NlbGZ0ZXN0DQo+ID4+PiBtYWtl
IFRBUkdFVFM9YXJtNjQga3NlbGZ0ZXN0DQo+ID4+PiBtYWtlIC1DIHRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzLw0KPiA+Pj4gbWFrZSAtQyB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy8gSU5TVEFMTF9Q
QVRIPTxpbnN0YWxsLXBhdGg+IGluc3RhbGwNCj4gPj4+IG1ha2UgVEFSR0VUUz1hcm02NCAtQyB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy8NCj4gPj4+IG1ha2UgVEFSR0VUUz1hcm02NCAtQyB0b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy8NCj4gPj4+IElOU1RBTExfUEFUSD08aW5zdGFsbC1wYXRoPiBp
bnN0YWxsDQo+ID4+PiAuL2tzZWxmdGVzdF9pbnN0YWxsLnNoIDxpbnN0YWxsLXBhdGg+DQo+ID4N
Cj4gPiBDcmlzdGlhbiwNCj4gPg0KPiA+IFRoYXQgYmVpbmcgc2FpZCwgSSBkZWZpbml0ZWx5IHdh
bnQgdG8gc2VlIHRoaXMgbGlzdCBsaW1pdGVkIHRvDQo+ID4gYSBmZXcgb3B0aW9ucy4NCj4gPg0K
PiA+IE9uZSBwcm9ibGVtIGlzIHRoYXQgaWYgc29tZWJvZHkgd2FudHMgdG8gZG8ganVzdCBhIGJ1
aWxkLCB0aGVyZQ0KPiA+IGlzIG5vIG9wdGlvbiBmcm9tIHRoZSBtYWluIG1ha2VmaWxlLiBJIGhh
dmUgc2VudCBzdXBwb3J0IGZvciB0aGF0DQo+ID4gYSBmZXcgbW9udGhzIGFnbyBhbmQgdGhlIHBh
dGNoIGRpZG4ndCBnb3QgbG9zdCBpdCBhcHBlYXJzLiBJIGFtDQo+ID4gd29ya2luZyBvbiByZXNl
bmRpbmcgdGhvc2UgcGF0Y2hlcy4gVGhlIHNhbWUgaXMgdHJ1ZSBmb3IgaW5zdGFsbC4NCj4gPiBJ
IHNlbnQgaW4gYSBwYXRjaCBmb3IgdGhhdCBhIHdoaWxlIGJhY2sgYW5kIEkgYW0gZ29pbmcgdG8g
cmVzZW5kLg0KPiA+IFRoZXNlIHdpbGwgbWFrZSBpdCBlYXNpZXIgZm9yIHVzZXJzLg0KPiA+DQo+
ID4gSSB3b3VsZCByZWFsbHkgd2FudCB0byBnZXQgdG8gc3VwcG9ydGluZyBvbmx5IHRoZXNlIG9w
dGlvbnM6DQo+ID4NCj4gPiBUaGVzZSBhcmUgc3VwcG9ydGVkIG5vdzoNCj4gPg0KPiA+IG1ha2Ug
a3NlbGZ0ZXN0DQo+ID4gbWFrZSBUQVJHRVRTPWFybTY0IGtzZWxmdGVzdCAob25lIG9yIG1vcmUg
dGFyZ2V0cykNCj4gPg0KPiA+IFJlcGxhY2UgdGhlIGZvbGxvd2luZzoNCj4gPg0KPiA+IG1ha2Ug
LUMgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvIHdpdGgNCj4gPg0KPiA+IG1ha2Uga3NlbGZ0ZXNf
YnVpbGQgb3B0aW9uIGZyb20gbWFpbiBtYWtlZmlsZQ0KPiA+DQo+ID4gUmVwbGFjZSB0aGlzOg0K
PiA+IG1ha2UgLUMgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvIElOU1RBTExfUEFUSD08aW5zdGFs
bC1wYXRoPiBpbnN0YWxsDQo+ID4NCj4gPiB3aXRoDQo+ID4gbWFrZSBrc2VsZnRlc3RfaW5zdGFs
bA0KPiANCj4gWWVzIHRoZXNlIHRvcCBsZXZlbCBvcHRpb25zIHdvdWxkIGJlIGFic29sdXRlbHkg
dXNlZnVsIHRvIGF2b2lkIG11bHRpcGxpY2F0aW9uDQo+IG9mIGJ1aWxkIHRhcmdldHMgdG8gc3Vw
cG9ydCBhbmQgdGVzdC4NCj4gDQo+IE1vcmVvdmVyLCBjdXJyZW50bHksIHNpbmNlIHRoZXJlIHdh
cyBhIGxvdCBvZiB0ZXN0IGdyb3dpbmcgaW50byBhcm02NC8NCj4gaW5zaWRlIHN1YmRpcnMgbGlr
ZSBhcm02NC9zaWduYWwsIEkgc3VwcG9ydCAoc3RpbGwgdW5kZXIgcmV2aWV3IGluIGZhY3QpIGlu
IHRoZQ0KPiBhcm02NC8NCj4gdG9wbGV2ZWwgbWFrZWZpbGUgdGhlIHBvc3NpYmlsaXR5IG9mIGJ1
aWxkaW5nL2luc3RhbGxpbmcgYnkgc3ViZGlycyBvbmx5LCBpbiBvcmRlcg0KPiB0byBiZSBhYmxl
IHRvIGxpbWl0IHdoYXQgeW91IHdhbnQgdG8gYnVpbGQvaW5zdGFsbCBvZiBhIFRBUkdFVCAocmVz
dWx0aW5nIGluDQo+IHF1aWNrZXIgZGV2ZWwpLA0KPiBpc3N1aW5nIHNvbWV0aGluZyBsaWtlOg0K
PiANCj4gbWFrZSBUQVJHRVRTPWFybTY0IFNVQlRBUkdFVFM9c2lnbmFsIC1DIHRvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzLw0KPiANCj4gaWYgcG9zc2libGUsIHRoYXQgd291bGQgYmUgdXNlZnVsIGlm
IGtlcHQgZnVuY3Rpb25hbCBldmVuIGluIHRoZQ0KPiBuZXcgc2NoZW1hLiBJIG1lYW4gYmVpbmcg
YWJsZSB0byBzdGlsbCBpc3N1ZToNCj4gDQo+IG1ha2UgVEFSR0VUUz1hcm02NCBTVUJUQVJHRVRT
PXNpZ25hbCBrc2VsZnRlc19idWlsZA0KDQpGcm9tIGEgdXNlciBwZXJzcGVjdGl2ZSwgaW5zdGVh
ZCBvZiBhZGRpbmcgYSBuZXcgU1VCVEFSR0VUUyB2YXJpYWJsZSwNCkkgd291bGQgcHJlZmVyIHNv
bWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmc6DQoNCm1ha2UgVEFSR0VUPWFybTY0L3NpZ25hbCBr
c2VsZnRlc3RfYnVpbGQNCg0KSWYgeW91IGp1c3QgYWRkIGEgc2luZ2xlIGZsYXQgc3Vic2lkaWFy
eSBuYW1lc3BhY2UsIHRoZW4gaXQgZG9lc24ndCBzdXBwb3J0IGZ1cnRoZXINCmluY3JlYXNpbmcg
dGhlIGRpcmVjdG9yeSBkZXB0aCBpbiB0aGUgZnV0dXJlLg0KDQogLS0gVGltDQoNCj4gd2l0aCB0
aGUgU1VCVEFSR0VUUz0gb3Igd2hhdGV2ZXIgRU5WIHZhciBoYW5kbGluZyBkZWxlZ2F0ZWQgdG8g
dGhlIGxvd2VyDQo+IGxldmVsDQo+IG1ha2VmaWxlcyAoc28gbm90IGhhbmRsZWQgYnkgdGhlIHRv
cGxldmVsLCBidXQganVzdCBsZXQgZ28gdGhyb3VnaCkNCj4gDQo+IENoZWVycw0KPiANCj4gQ3Jp
c3RpYW4NCj4gDQo+ID4NCj4gPiBUaGF0IHdheSB3ZSBjYW4gc3VwcG9ydCBhbGwgdGhlIHVzZS1j
YXNlcyBmcm9tIHRoZSBtYWluIE1ha2VmaWxlDQo+ID4NCj4gPiB0aGFua3MsDQo+ID4gLS0gU2h1
YWgNCj4gPg0KPiA+DQoNCg==
