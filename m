Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08FCA897F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbfIDPWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:22:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730299AbfIDPWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:22:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84F7pAx011607;
        Wed, 4 Sep 2019 08:21:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VQp8PxvTOOpN9WTFL80kxiAUWElYqgglDxYxLzQZMpg=;
 b=TrRNzac5SBajzrWPOQIoFARI+uVgXJ4sPeutJgZ0Kv5Jh/LP1sS5MYfRa/KCdYWYA6Ct
 grCUaxv5H0CxkfXPespctxnVRXKROA6tUWVNyqPGlA/7UTwKHLAnQew5S8cE0bvjufIY
 0tNZIp+e1VhKc/Vrgu1cOuklXOt9WX3uBNs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2usu2fn6w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 08:21:14 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 4 Sep 2019 08:21:13 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 4 Sep 2019 08:21:13 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 4 Sep 2019 08:21:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4OFp3nOig5McVBddJJPGKOxWUHyGbFWTMCRqW+WMY2GQLI2KPKRm9x5wXhNQ2twvv7sC7wq1Mg5SpaNWzKsrX+aHJLaAenvNgMqXS6mswKrMbeGb2zTI1MVIKPMaEMDF+znv60LHYSDLBivX45DNDEHx7am4GivVuDmnVdCj+eAlizGiRe+SC9OB9n7hl10rqsjdPCy3X3yWH1IEyYINOk5+qYvJVb1ZscHZQjuvPAy20zf6vky7oJWbwBLqFKx3NCSquglD4Bq+I/OjQE6kAxFJEvc0OENzucA1mMkNHcgu2pbj32vDjEfV/B25NyQF5Lb9MaHb49gCwHz6Zu3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQp8PxvTOOpN9WTFL80kxiAUWElYqgglDxYxLzQZMpg=;
 b=WV6RYorHUyOhkrPgSEUG8HwwfBIgEnt8P5Ht8SsVSQvnfaEKnMYBZmQzFDFUzusfDbnaYJB1Cq9aGcBApigFQFi4EtsVpR1M8KIEFyYgrGHyRHr7p5KpSA2Ck/RIksGXV/gSw2mJggPdK7sj4rLFS3KCGPAQe0ZjXYPVhELglPOiS5RWs1Pazzvm5hOEAExzhVmbBhG3wA35hyGLlQc3N2bKocGJfiFjfSLPLsUjHc7qxApqm2HbgpvCZFPWxr5F0T3yexLadnjbUBt8gIUBKHiqiif/MC2RGhpyKxOSIZ1q/NB9nzM/GIcdftOv3DzRNYsvqyHanTuiRcSdirZFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQp8PxvTOOpN9WTFL80kxiAUWElYqgglDxYxLzQZMpg=;
 b=PR7GsASF3uzcjcgrLP68t9cw5vwuNTnUNFzGg73e8ZGBOMr+Q10YbULspdVFQKzFHauc9LDrHv87h+bgCks1EmOkkCMNa2zxy5BBw6y9yveKejNhMsCDUlc3x3GqjAnAphp3iCrbwYTU3nH1maSaTH8zKrcuSWwTTG1fiH0G9Go=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYASPR01MB0023.namprd15.prod.outlook.com (20.177.126.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Wed, 4 Sep 2019 15:21:12 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::65e2:8d24:46f3:fd3d]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::65e2:8d24:46f3:fd3d%7]) with mapi id 15.20.2220.021; Wed, 4 Sep 2019
 15:21:11 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Topic: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Index: AQHVXiiECXa58nNjTk27E4Nc66HXg6cSQZuAgAAhAoCAAW2TAIAGgVCAgAFZroCAAAFBAA==
Date:   Wed, 4 Sep 2019 15:21:11 +0000
Message-ID: <99acd443-69d7-f53a-1af0-263e0b73abef@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
 <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
 <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
 <5e36a193-8ad9-77e7-e2ff-429fb521a79c@iogearbox.net>
In-Reply-To: <5e36a193-8ad9-77e7-e2ff-429fb521a79c@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:a03:54::40) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5f42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f30aa0b-9b6e-45b3-bdef-08d7314b848a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYASPR01MB0023;
x-ms-traffictypediagnostic: BYASPR01MB0023:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYASPR01MB00236EF44D43E04168841C3AD7B80@BYASPR01MB0023.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(396003)(136003)(376002)(189003)(199004)(446003)(53936002)(25786009)(6512007)(6436002)(46003)(6246003)(4326008)(14454004)(478600001)(31686004)(66476007)(64756008)(2501003)(66556008)(66446008)(476003)(31696002)(486006)(71200400001)(71190400001)(11346002)(2616005)(66946007)(256004)(8936002)(4744005)(36756003)(229853002)(305945005)(86362001)(7736002)(186003)(81166006)(81156014)(8676002)(5660300002)(54906003)(110136005)(53546011)(6506007)(386003)(6486002)(102836004)(76176011)(6116002)(99286004)(52116002)(2906002)(7416002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYASPR01MB0023;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eCUwseemVUwwMOQTC+UKOHIlLpnEIFd4eLGAAAIdKdyXlmAyrbr2dN0/2CR2A8ZDE2X9hChnN47RivZjk5TcprAu6d+tQxHGjmkhsppav3BCRxgNs372Vbo5IUOAhMK0ggkO7GwSJDoLCHcxbnq4cUkoscvU6uXopD4R+58YQ9ZweMNKPgWk7MXy+bsVeMc39b/8qvSdCztuJrcA18vcHArb4SSzy2psP9VWetduH6GhVmZFLO0YFlo+hNY6mVqKdXp2qge3AfCl/cmmrRW3lkikNYjM2xGXZ6833tnCXVaijze6BCcQKS/7rTy70KyrjTOKRhMm7TCNoE5MnZAcodgjIVvZFBLYGn74RzTs83nbzEoxoL2/UaZwXBT65lsWSTUfiubSrpjFHKRpIFRKXwf01SJf+iFs+VyNzWvnhic=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2DB9086D997BB47992EA8F2BE17B6A7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f30aa0b-9b6e-45b3-bdef-08d7314b848a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 15:21:11.4536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+YXo/TUG7jJYGSTfej/DQyz8s849dLtba6I9h+JAOIPrwd2M5QqIbguXMFJrUCt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0023
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_04:2019-09-04,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS80LzE5IDg6MTYgQU0sIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4gb3BlbmluZy9jcmVh
dGluZyBCUEYgbWFwcyIgZXJyb3I9IlVuYWJsZSB0byBjcmVhdGUgbWFwIA0KPiAvcnVuL2NpbGl1
bS9icGZmcy90Yy9nbG9iYWxzL2NpbGl1bV9seGM6IG9wZXJhdGlvbiBub3QgcGVybWl0dGVkIiAN
Cj4gc3Vic3lzPWRhZW1vbg0KPiAyMDE5LTA5LTA0VDE0OjExOjQ3LjI4MTc4NjY2WiBsZXZlbD1m
YXRhbCBtc2c9IkVycm9yIHdoaWxlIGNyZWF0aW5nIA0KPiBkYWVtb24iIGVycm9yPSJVbmFibGUg
dG8gY3JlYXRlIG1hcCANCj4gL3J1bi9jaWxpdW0vYnBmZnMvdGMvZ2xvYmFscy9jaWxpdW1fbHhj
OiBvcGVyYXRpb24gbm90IHBlcm1pdHRlZCIgDQo+IHN1YnN5cz1kYWVtb24NCg0KT2suIFdlIGhh
dmUgdG8gaW5jbHVkZSBjYXBzIGluIGJvdGggY2FwX3N5c19hZG1pbiBhbmQgY2FwX2JwZiB0aGVu
Lg0KDQo+IEFuZCAvc2FtZS8gZGVwbG95bWVudCB3aXRoIHJldmVydGVkIHBhdGNoZXMsIGhlbmNl
IG5vIENBUF9CUEYgZ2V0cyBpdCB1cCANCj4gYW5kIHJ1bm5pbmcgYWdhaW46DQo+IA0KPiAjIGt1
YmVjdGwgZ2V0IHBvZHMgLS1hbGwtbmFtZXNwYWNlcyAtbyB3aWRlDQoNCkNhbiB5b3Ugc2hhcmUg
d2hhdCB0aGlzIG1hZ2ljIGNvbW1hbmRzIGRvIHVuZGVybmVhdGg/DQoNCldoYXQgdXNlciBkbyB0
aGV5IHBpY2sgdG8gc3RhcnQgdW5kZXI/IGFuZCB3aGF0IGNhcHMgYXJlIGdyYW50ZWQ/DQo=
