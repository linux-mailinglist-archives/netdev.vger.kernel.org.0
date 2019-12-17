Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825DC1238FD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLQV60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:58:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbfLQV6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:58:25 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHLsPQd024644;
        Tue, 17 Dec 2019 13:58:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YqRfU3vZPK4Nk7PpdUG5uzuxqxL2a86O3JiHCg7Ahxk=;
 b=pmOGeMpN7rYPopkdnAByFC5We8/3naTBrJOSu8/WSBN1i3iJU7EjqwKSuKqIAd58FpMX
 sLnhqrNOIa4kjDHf6DNeSmjfg7jlcYiwZszxicdN6oZCmaBIhm2nTc0jShZBGSAEkKwG
 GS7FPCBaEvpmDOMMJW/z/aYZgyXVKkFJDN8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxg74p3r8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 13:58:10 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 13:58:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 13:58:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2l7ibjQDew9IJorsSissHdUWbRNKJpgzKVrs0FxkNb8udH06sraiUaZFtUNYCyr655KGMsWWCRDhZLQ87ME+5mcloYp3Ud0dMINR34j+d2o/F2b5/yvp6sk/bQH1kqogVaxWnQfMlLwGtKriPtbhVX2NBbRAagBez1jjAZncpORpMPdonK2hXLTQPfWHfLegf/bHwXojtv2UGmWDhINnQlT+cTWkVZ9M2p/Orj7W2Dl9YiXaCb12PCLUiXpqSifwzL0ixrw11vDbJlgS8ZAUtuA5BE4nrHvXA03ZguqgI4pM7JOAzkO1WcOxrTMFpJH8KB+uI1Hfi4No5UXMgxtDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqRfU3vZPK4Nk7PpdUG5uzuxqxL2a86O3JiHCg7Ahxk=;
 b=lc61DwWdZr+ultNBcRcMTzsafs2dWFw5XPJX6hefn3hrdZ+aWktxGSGijSbWiFaJzcVhMF750XgbHqtwoPCI0g8/6084MzYCBS0ZkU+yzdOcSKqwLFjc3YQHnl5UtdEGicXVgc370tO95bg+EQYIfyeMewYNGmDg5UITNQjbd2nTV1lqyCy0cdlGeVYaoEdgWYMH8nEUSWh5/oSzVtLbYbUa5PaPr0lKCA1UcRRxSr5kqeR1GSQ/HtREuO+OIU/5A40EbiPmGXXDTZ0fdcww4FO7lFfV/B4XZPQL0xq1F1Tq8X/XGoHDUj7QV2kplP08oAyzxPg0loWKlfOOruZWBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqRfU3vZPK4Nk7PpdUG5uzuxqxL2a86O3JiHCg7Ahxk=;
 b=C0INnN80PYsjTl3ZTwVx8Aiq/Av6QndaX6lYselGCg7utWfTw/J7z9GUvcAYA+hMsUvPoFWmp1EDltSm/q6+UfY8WiKeXao11YYkFpKQiOUqqosIAop34tUaHwewy5y4BbzYvysBrDx4rmeIEwOhlbE/5apeLG7gyudRpKCnv0U=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1548.namprd15.prod.outlook.com (10.173.222.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 21:58:08 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:58:08 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Fix libbpf_common.h when installing
 libbpf through 'make install'
Thread-Topic: [PATCH bpf-next] libbpf: Fix libbpf_common.h when installing
 libbpf through 'make install'
Thread-Index: AQHVtM0klwOq8VxAT0i7zUX30aMLtqe+4ISA
Date:   Tue, 17 Dec 2019 21:58:08 +0000
Message-ID: <c6a49edd-3992-6ddc-58d9-2c37acdeeece@fb.com>
References: <20191217112810.768078-1-toke@redhat.com>
In-Reply-To: <20191217112810.768078-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:300:4b::12) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:406]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6056c49e-6684-415f-a9d6-08d7833c3385
x-ms-traffictypediagnostic: DM5PR15MB1548:
x-microsoft-antispam-prvs: <DM5PR15MB15480FAD08A68E48C72CB629D3500@DM5PR15MB1548.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(136003)(376002)(189003)(199004)(66446008)(66946007)(66556008)(5660300002)(64756008)(66476007)(6486002)(36756003)(71200400001)(186003)(4744005)(2616005)(86362001)(478600001)(316002)(52116002)(6512007)(8936002)(81156014)(81166006)(2906002)(6506007)(31686004)(54906003)(110136005)(8676002)(4326008)(31696002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1548;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6AFEBrg2EzyWn2P+sd9fYgie4JKbQeqfgJ288I9jl/emPPvm6Ao/WICBHFe5WTBYh+suBZ5fEheJ9PC7aDnnCGpMKZPfqH8Z0QQ2Q7rxE5kP7rSbm96g1rSPDnMuNucXivu7ZRvNLAnMbZRw97EAoOU3F2/szf0a3Vz5QO6QLgH0sTzPKiM7Db+Mzp0uf8CuinqPLzVOj4kIKcJk8P2ccx158Hw936+hBdyX6mFgcfOuS3mAq4J93Z7bCGH6femKqYhA056hikO7pjFIxKjZlrnSHSvb31hDvr++Dk6V0lndjXRpzxPgX0QExkkx2LOj1h8zxcZFREMN1pPCcb+MyceG55WLgvvmynoR/E+oHOvZo/B2HAAQIOTufAF6oU0v3HWg4QVjkqxXGboO8PeNda+D9X55hc6KUJdChAZBUrzagVfC31CVAxtb6BUXxpap
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1E1E071E83B2B43952E9ACA99EBC828@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6056c49e-6684-415f-a9d6-08d7833c3385
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:58:08.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: stR5qdgWc+lkh4mSlIBk/smu+oCk6UaShzmGL1Vos611IL2SKsjVceuZtSB2of0l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1548
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 mlxlogscore=973 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE3LzE5IDM6MjggQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gVGhpcyBmaXhlcyB0d28gaXNzdWVzIHdpdGggdGhlIG5ld2x5IGludHJvZHVjZWQgbGliYnBm
X2NvbW1vbi5oIGZpbGU6DQo+IA0KPiAtIFRoZSBoZWFkZXIgZmFpbGVkIHRvIGluY2x1ZGUgPHN0
cmluZy5oPiBmb3IgdGhlIGRlZmluaXRpb24gb2YgbWVtc2V0KCkNCj4gLSBUaGUgbmV3IGZpbGUg
d2FzIG5vdCBpbmNsdWRlZCBpbiB0aGUgaW5zdGFsbF9oZWFkZXJzIHJ1bGUgaW4gdGhlIE1ha2Vm
aWxlDQo+IA0KPiBCb3RoIG9mIHRoZXNlIGlzc3VlcyBjYXVzZSBicmVha2FnZSB3aGVuIGluc3Rh
bGxpbmcgbGliYnBmIHdpdGggJ21ha2UNCj4gaW5zdGFsbCcgYW5kIHRyeWluZyB0byB1c2UgaXQg
aW4gYXBwbGljYXRpb25zLg0KPiANCj4gRml4ZXM6IDU0NDQwMmQ0YjQ5MyAoImxpYmJwZjogRXh0
cmFjdCBjb21tb24gdXNlci1mYWNpbmcgaGVscGVycyIpDQo+IFNpZ25lZC1vZmYtYnk6IFRva2Ug
SMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hv
bmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
