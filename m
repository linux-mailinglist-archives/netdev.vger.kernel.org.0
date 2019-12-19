Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986FA1267A5
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfLSRF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:05:59 -0500
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:42390 "EHLO
        mx0a-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726760AbfLSRF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:05:59 -0500
Received: from pps.filterd (m0108156.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJGjxxD017037;
        Thu, 19 Dec 2019 09:05:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=PPS1017;
 bh=FcfHMxVoz1uIgqDKXkVkTL9rh6wCtT5lFpiVmkYa/vY=;
 b=Blbvm0ESMeDBCekAphfv0rMv4064zm7tB0dUzyLYKRm+NjrwtFYJ0H3weOB3Ha1/zbDL
 TXteZFHLfGa/BHTV/GzUjeo/i4AQHreSoPFPqw/ff7D569FzU+Fm2BZQy1VErGjzj4aD
 3xILmS6cryN/oL7zbtQdIvdkUxXqHifqVQmq52B82OYiAgBVKIFK9OW642FYZ7ZUHqa5
 sodibHNfJ5UWnhrAwXZCJwTEBA43NRsv32XYxDjdXT4KpN33U5Yf236dmCXORoQt8Jm5
 2YvZWmU0DizFzTXj+IREjdbcpuaxQIj6BjIn0R12ldG8Qjvbq3CanBQv8tM5DSxLjpVY eA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2053.outbound.protection.outlook.com [104.47.36.53])
        by mx0a-00273201.pphosted.com with ESMTP id 2x05860tkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 09:05:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpNvtQH12uj0+bO+F+oMpQUE/UwrC108LdGl3bZn9AXFiVPT2z8AtzAmdi35Ngj+/DGY05tbW38014DF+A8oF+mlPopB+l563ueP5FcxDrqLw5RmsA+HExV4g5+GPMEAjZMs9sZ1Eg5Hi4BiH/zpE5azrkHtF5rD7fFHWaiXUdeYFNS9AV+eLrB1h05vG5hbBdX0u9dFPeP0CK/QAJ0PEh1SkNZwczYGxqWPWmAYTt6LGKBX4Ub8HxCxGxeVyUBK2aTa8281NseoBknsPfHVgr4DpBi8Lf9rvxPXRI5kZ3A7kAEGNatymcTOOGwGcdcQ41knvAHJe9TaZwDa79iP9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcfHMxVoz1uIgqDKXkVkTL9rh6wCtT5lFpiVmkYa/vY=;
 b=be/YzBlIiyMwOKqlkpYOUyXlXzWtPsQZp1Pz5cf8VzT2UwKwji3TZwd/epnIYtC69y5xTMxsrAGaTTySulR53Hy3Z++peykwDTk+CsOC7gQBoXPpdn4VQdGTADJUfGjQp4U07cvptnEEsPzFpUDCU6pordwlww1BxIGHE5hbSnaxkCmEfrB7A85rzrajFKOcyeXzBSrDXSLnsApniizFZdhYDMub6W4LrwHHPNr6Lj9C30N2yPmGIs+pDyeuzMyKDDvEcMhICBjONJ9iGZfgLS3TBavhfnOUeUDzeCcNdCSjXy+UbMAm/qyc7htobeT8ENK2BUuuMS5BGFZNvMlrSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcfHMxVoz1uIgqDKXkVkTL9rh6wCtT5lFpiVmkYa/vY=;
 b=DcdpRzK8waZAl2tlmIykC04hT3uPfU9oxP9shCFMxLkoLOI8UsED0FQoDS3QmzEfeRRWJKPEQ5I/iu8wQH4H0XBPVucloSWcob8hu4tlGZylc/QPp4x3rNqwpFV+H0L5/TD3NK5mCo4f49U31HI1d9ZX5I2fqONTEGeLRmilvzw=
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.99.143) by
 CY4PR0501MB3699.namprd05.prod.outlook.com (52.132.100.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Thu, 19 Dec 2019 17:05:42 +0000
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47]) by CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 17:05:42 +0000
From:   Edwin Peer <epeer@juniper.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Y Song <ys114321@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Topic: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Index: AQHVtgy6x2wMuQ42JECcwOBV53W8TKfBDSIA///4BwCAAJXcAP//j9uA
Date:   Thu, 19 Dec 2019 17:05:42 +0000
Message-ID: <CEA84064-FF2B-4AA7-84EE-B768D6ABC077@juniper.net>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
 <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
 <20191219154704.GC4198@linux-9.fritz.box>
In-Reply-To: <20191219154704.GC4198@linux-9.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Name=Juniper
 Business Use
 Only;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ContentBits=0;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Method=Standard;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ActionId=43de90f8-d5f3-49c3-8d29-0000eb6ce104;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SetDate=2019-12-19T16:51:55Z;
x-originating-ip: [66.129.242.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 451bcc07-32a7-4081-caa2-08d784a5ae22
x-ms-traffictypediagnostic: CY4PR0501MB3699:
x-microsoft-antispam-prvs: <CY4PR0501MB36997911451C72BB4D456C93B3520@CY4PR0501MB3699.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(36756003)(66476007)(66946007)(66556008)(8936002)(64756008)(91956017)(76116006)(86362001)(316002)(53546011)(66446008)(2616005)(8676002)(5660300002)(71200400001)(54906003)(6916009)(81166006)(2906002)(186003)(26005)(81156014)(6486002)(478600001)(6506007)(4326008)(33656002)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3699;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zAPnh8QQhDsUUFY+O0oQw4JBWfaursPE1NXVffEZsmLaUNXtSzEtNgMDRlK6nYA+TOR6JBdz0AdYKWionHi+lp1WipKNxIebuy2hN2abQUMMuGkL/n0Z5u0DbWPin6hR80jQi9Fqvqi0k0ZbYxknR0k6uh+2VJUdrRP1E2A9MVOKuK4HwMwwEhVl0GJVyhQcAKR6lFOpDStYip0ZRkWOsVCUlcFSalrS09jl85wfeWDDIyHa0dUb4xIJT0bOe0GXjD9Ct4Z+2QdJbOK830Ou8Ub+t5MhW2Pa9AYnrEv6Ifuo9PN6ausGOfVZO45FLe5m/fNuWUUXEeyCJ0fBnX54hGqIsnSxkM3rrbxW5+j67F4D8kEIi/iGnjgkehFxCGvkW/kJSXH/tcMKzvSKlqMpCbxkRKTPj2yvZyGHS206dVmEqDQpiK2WQB0gN/RNNiUZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A63B3A0F3FE1A489F0B6D194982D26D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 451bcc07-32a7-4081-caa2-08d784a5ae22
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 17:05:42.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HsoBVRqtfg7MZ2p+FO4tJj18edFC2hM6tFvH3eUq/r8PhLMMBnn4WPTTfV3VG8lFU1BNH0Hdi5n20tlbNUntig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3699
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_04:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTkvMTksIDA3OjQ3LCAiRGFuaWVsIEJvcmttYW5uIiA8ZGFuaWVsQGlvZ2VhcmJveC5u
ZXQ+IHdyb3RlOg0KDQo+ICBXaGF0IGFib3V0IENBUF9CUEY/DQoNCldoYXQgaXMgdGhlIHN0YXR1
cyBvZiB0aGlzPyBJdCBtaWdodCBzb2x2ZSBzb21lIG9mIHRoZSBwcm9ibGVtcywgYnV0IGl0IGlz
IHN0aWxsIHB1dHMgdGVzdGluZw0KQlBGIG91dHNpZGUgcmVhY2ggb2Ygbm9ybWFsIHVzZXJzLg0K
DQo+IElJUkMsIHRoZXJlIGFyZSBhbHNvIG90aGVyIGlzc3VlcyBlLmcuIHlvdSBjb3VsZCBhYnVz
ZSB0aGUgdGVzdCBpbnRlcmZhY2UgYXMgYSBwYWNrZXQNCj4gIGdlbmVyYXRvciAoYnBmX2Nsb25l
X3JlZGlyZWN0KSB3aGljaCBpcyBub3Qgc29tZXRoaW5nIGZ1bGx5IHVucHJpdiBzaG91bGQgYmUg
ZG9pbmcuDQoNCkdvb2QgcG9pbnQuIEkgc3VzcGVjdCBzb2x1dGlvbnMgZXhpc3QgLSBJJ20gdHJ5
aW5nIHRvIGFzY2VydGFpbiBpZiB0aGV5IGFyZSB3b3J0aCBwdXJzdWluZw0Kb3IgaWYgdGhlIGlk
ZWEgb2YgdW5wcml2aWxlZ2VkIHRlc3RpbmcgaXMgYSBjb21wbGV0ZSBub24tc3RhcnRlciB0byBi
ZWdpbiB3aXRoLg0KDQpBcmUgdGhlcmUgb3RoZXIgaGVscGVycyBvZiBjb25jZXJuIHRoYXQgY29t
ZSBpbW1lZGlhdGVseSB0byBtaW5kPyBBIGZpcnN0IHN0YWIgbWlnaHQNCmFkZCB0aGVzZSB0byB0
aGUgbGlzdCBpbiB0aGUgdmVyaWZpZXIgdGhhdCByZXF1aXJlIHByaXZpbGVnZS4gVGhpcyBoYXMg
dGhlIGRyYXdiYWNrIHRoYXQNCnByb2dyYW1zIHRoYXQgYWN0dWFsbHkgbmVlZCB0aGlzIGtpbmQg
b2YgZnVuY3Rpb25hbGl0eSBhcmUgYmV5b25kIHRoZSB0ZXN0IGZyYW1ld29yay4NCg0KQW5vdGhl
ciBpZGVhIG1pZ2h0IGJlIHRvIGhhdmUgc29tZSBraW5kIG9mIHRlc3QgY2xhc3NpZmljYXRpb24g
c3RvcmVkIGluIHRoZSBwcm9ncmFtDQpjb250ZXh0LiBUaGF0IHdheSwgZGFuZ2Vyb3VzIGhlbHBl
cnMgY291bGQgYmUgcmVwbGFjZWQgYnkgdmVyc2lvbnMgdGhhdCBtb2NrIHRoZQ0KZnVuY3Rpb25h
bGl0eSBpbiBzb21lIHNhZmUgd2F5LiBQZXJoYXBzIGhhdmluZyB0ZXN0IHByb2dyYW1zIG9ubHkg
aGF2ZSBhY2Nlc3MgdG8gYQ0Kc3Vic2V0IG9mIHZpcnR1YWwgbmV0ZGV2cyBmb3IgY2xvbmUgcmVk
aXJlY3QsIGZvciBleGFtcGxlLiANCg0KUmVnYXJkcywNCkVkd2luIFBlZXINCiAgDQoNCg==
