Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867CF126917
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSSbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:31:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbfLSSbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:31:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBJIOjaf006431;
        Thu, 19 Dec 2019 10:31:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pp4q+gZvszY8D9JMMDOpiS3pMrFykxveQqTT425oFWM=;
 b=FetAlXn/6DvQS/icZ0dtcYDZM/wmvefOG7MTRVWNq33+Bpj7gxlcav89jEh5zoxLBq2h
 SGlqvxk0imoTEwVmnML9S9LmOeZS8nvfjlBTECGn+7rSj2zrE0oCOQNr+NHqpX3U1Iep
 A959QbsOl2wFoaiBTWDlF2fyUuG7o9FF+cM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2x0as6hc5r-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Dec 2019 10:31:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 19 Dec 2019 10:31:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGrIo+GfvT7CsHjQDUpgWAzUy40gwfz8PfwJ7AYzvOdz7N+uAC6qeoHBHv3pv5cMgy6Eh+mulZdeA9l+vsPjw0E8yP336K2G1pTyRT2npmQNw+CMy7am31SIJVAIw1LJmURzIUQPlHfX+1HqDUByffdkQMD0UGjvga/2y2cRaDqH45waoQgE0Fo9tFchDAPGn+4j2r3jFMtG0cGWE6YikPNPuCSRgi3rNAKLZxISFZd/sTjVoQPB08TjGZa8OmJbjSC7wiU4wTn/PIHy1wnzybsJoWnitd2ZREAv8I8MKPhr6QQfR+F20jZQ6aO4hH26j3oKR677ZWhjXm/f3yNgpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp4q+gZvszY8D9JMMDOpiS3pMrFykxveQqTT425oFWM=;
 b=T/4/Y4iEp6BtznRq0Drq2RhWX+dNiX9SovLqkWFFVWHAHs9/spMrWJofjNsx6iwePsmMs+Dy3XNHfsF6Hdof2FKzSMRyyiG/czIF7DDUJ3ZtGLyZ1Xi62FhJnrBiL6PMhB8cVJGMv3DcFVe9YUoHWnXYgn2inAu3A3xTk7CSDDs2sviaNKjO5P7OSC2C8SLdexAXWZfdhVGzsvZQdmB5F9VWWOrBqSDDoeERuMNp79q7NDPayqR0zzshafX4Q0PlFRpVvwLl6rrdynV5lo1c2FFvNhmpt77PGESXivaH1ocwuGsABx6rYjnDMWYchAgdxyaa+6pSEp0rzeH/xapWSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp4q+gZvszY8D9JMMDOpiS3pMrFykxveQqTT425oFWM=;
 b=FJSe20JI5//QOKnI6VrMylNH9yQofOCKxWdEz4qI2+aFNrphAe0figjBSDawZg2Si/N8L5pktmBsSMqNR9Xd1TjsxQILt8QM3cZp09Z3gA8xBDUAJDUZM7w2UNXZlfP5dP9vSmlxQLUVyXoIkhFYjhbLI09tonFMroLJnlsfSBY=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1290.namprd15.prod.outlook.com (10.173.212.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Thu, 19 Dec 2019 18:31:17 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 18:31:16 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v16 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Thread-Topic: [PATCH v16 2/5] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Thread-Index: AQHVtcoEMXXc4iJDJEyFjEmcvRkHdqfByWgA
Date:   Thu, 19 Dec 2019 18:31:16 +0000
Message-ID: <75b6ae2b-ee87-2c1f-57b8-73470c50394b@fb.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <20191218173827.20584-3-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-3-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0015.namprd22.prod.outlook.com
 (2603:10b6:300:ef::25) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:442e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d9be363-bd8d-421e-7ab5-08d784b1a274
x-ms-traffictypediagnostic: DM5PR15MB1290:
x-microsoft-antispam-prvs: <DM5PR15MB1290716655AD644BCAB424F0D3520@DM5PR15MB1290.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:210;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(189003)(2616005)(66946007)(110136005)(2906002)(53546011)(6506007)(66476007)(66556008)(64756008)(66446008)(6486002)(186003)(54906003)(4744005)(36756003)(71200400001)(5660300002)(4326008)(6512007)(81156014)(81166006)(86362001)(31696002)(478600001)(31686004)(52116002)(316002)(8936002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1290;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32vd1o3pqgS7vrwCTQb1tz03egDFePs4r/Kr/DOrn5gZ9Un3F93IGZXK4H2JkP31aB9Sc+DY8zptwFQ/+K8bxdFHTjkHRqaZK8bEA9jK38uynTS8c0jtZDBdCUwDTaWX9XKb+J00irIRkQMh3W6cKiucjshtlmVmaFcDw+Ye9vvfAgmWOpS9rRayihSBnW6WeZFr/LxVL6Rm16BWkf07mI+SiFZ3QwM6EsSOJ0/xpGvdO0QaxM9hrG1fKjhYJanXy9qfq++f91NGdaIIBGRh6gj20saUMgGOIg0EaA0dWW9mUeH2eH9DyxTylpUjWw7vLf+5R6dnhRoIITx9Ul1P2y1Guun/dzACoFOEdcsHzecOw+PIfgZpbS+RCG2BdGJdwwQRO20+Gi98/+ct1L4C9vt0iFGnGVjh7+IpBXOe50gZ13mNkM2XmhvnIiGf/JEI
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ED49DBD665743408320FBA53AD1E91B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9be363-bd8d-421e-7ab5-08d784b1a274
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:31:16.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DqjrXvVwShbvd2fXqSOt4h2eZJZSIdIRMNyS7wMlG1EZQJHPiGtzsPQ8NwZyQFIp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1290
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=778
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDk6MzggQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gTmV3IGJwZiBo
ZWxwZXIgYnBmX2dldF9uc19jdXJyZW50X3BpZF90Z2lkLA0KPiBUaGlzIGhlbHBlciB3aWxsIHJl
dHVybiBwaWQgYW5kIHRnaWQgZnJvbSBjdXJyZW50IHRhc2sNCj4gd2hpY2ggbmFtZXNwYWNlIG1h
dGNoZXMgZGV2X3QgYW5kIGlub2RlIG51bWJlciBwcm92aWRlZCwNCj4gdGhpcyB3aWxsIGFsbG93
cyB1cyB0byBpbnN0cnVtZW50IGEgcHJvY2VzcyBpbnNpZGUgYSBjb250YWluZXIuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQoNCkFj
a2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
