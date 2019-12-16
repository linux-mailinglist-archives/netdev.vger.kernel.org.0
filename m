Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165B1121A32
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLPTsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:48:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbfLPTsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:48:23 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBGJi4qS009355;
        Mon, 16 Dec 2019 11:48:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=I9fNJq5VF27shq13/hQs+XqqXWvBYs0ZB+xXPd8g1Rw=;
 b=nf4rQzs0FsRfF6PMu/TacC+m3tzy+fSJJHSXf08xOzxu7yoAgzdEN4p9e8tXnfHXhNLV
 /wh9WJfeFbLkp6CalmiBrX/1NOrr5SdB6jyEF0rcsjXLlB4UIwIsWAOzMo/LG44CxpOU
 o/xQ0m+EShLibnzp2t1w/UDGLNuGkR8Onro= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wxfr0875j-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Dec 2019 11:48:07 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 11:48:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 11:48:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFTZ1sH1AGjnI/a6QZoBMqllIii6zfH7CDqi5hesV5H4w8Vo6G4OfSWxbwEfSnIzf9f+KOMIPlUcLnfeJ9XiZy9SCzlNpmjrR/8ErZsTcT/UOJg+sQfx0ApGPixR8thNFgjfRqaILeWdynzmdgK9goh+9Qli+zk5uSAsdJSHqOyFKSmegO0Gd4RkBfHJk+6rGtAw5pDKaIKrw1JG2Nrxwy5b9prXrDmCZbaYL1zu5Tb2oFlD8fUCqvJIDeG+aIZ4Aa9gFpeS2xsahWdk3PWlsaETOcfyrpROihSpWtE2AwwCG69Qp14gqW2pjcSzz17T2eOVef4F9aaRyi+erofkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9fNJq5VF27shq13/hQs+XqqXWvBYs0ZB+xXPd8g1Rw=;
 b=j/MJubLWoTIFHhygIcTEothN2MvdQ4p7lsxHSpPTOVHF9yoky4LDWx+3MAHR9t/FSqpghPkj8Z98tmQb/bRA4Y3V0Hf8tmPxMp5+vsUYy3uwoWQqd7Q46SmjrMOs2CWd1OmYejPgFoccdhxs8teoMQj/YVWY9yfm+2zaMhtjbqShjuloqYwPc0EY71I/haNxIeZXdN+ImUinlroBEviaxphhyER02m0GfPK1gzoelzAyFePrZHXpfjUyHWVJ8z6BVKkInr8xh/b/gAhS8VdH6tcDnqgsD0zpXQW9lU6sjD7CMCA0kV8ouCPsMiyOO+1hgKQP6MqBdP71ZiJj08LnjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9fNJq5VF27shq13/hQs+XqqXWvBYs0ZB+xXPd8g1Rw=;
 b=elpmx8IlDkikGt5ji5Hgkfi8HGEbz7aZ8Mu5fZvv6rR+3w/trdCYCGVOjtU90JY11RKCT8hNXcKAnnqNa1KTxu+l78539EIY8HG3rk5Lhiop1nY2kTLo0nACbKpwTmS3mKeOi4TYP9+7p8gkxObj1kD2wKS820jtS4erScX1m3M=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1657.namprd15.prod.outlook.com (10.175.107.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 19:48:06 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 19:48:06 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 01/13] bpf: Save PTR_TO_BTF_ID register state
 when spilling to stack
Thread-Topic: [PATCH bpf-next 01/13] bpf: Save PTR_TO_BTF_ID register state
 when spilling to stack
Thread-Index: AQHVshgeCmLfkH905EahWuPA1DzmPae9L0SA
Date:   Mon, 16 Dec 2019 19:48:05 +0000
Message-ID: <7f616665-1b2a-66d4-5cce-edc58cb168cc@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004738.1652239-1-kafai@fb.com>
In-Reply-To: <20191214004738.1652239-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:300:6c::21) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4da2258c-f801-44be-aa8b-08d78260de81
x-ms-traffictypediagnostic: DM5PR15MB1657:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1657947E1F94753FB0DBB11CD3510@DM5PR15MB1657.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(39860400002)(366004)(189003)(199004)(71200400001)(2906002)(5660300002)(86362001)(52116002)(110136005)(186003)(2616005)(478600001)(31696002)(31686004)(54906003)(81156014)(558084003)(8936002)(8676002)(81166006)(6486002)(6506007)(53546011)(36756003)(6512007)(4326008)(66476007)(316002)(64756008)(66946007)(66556008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1657;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DsPhxy8+DDrQpYxXkkUkxYUPeKIye0x3F+d/tXEbX+dy+tzpKQe+zJv37/5YJvJwFlWcIdquHFt+LozGc7E140rcJCcbJcx10pci0uOGfg5YRiEslgYMF25DUdNwnOFIoDj6fmdBJ+IIASpnSj6TbjFIyJWjS40CIQ4N4Nsv8qxwm6AdWTIQ9vEyyG9GnPSa05BXL0Hl6HLgLTUW8KSBMsTK4Z9V20tP6Z3TsczEJS9gE0ZGi0EWOaUdDv4B9YEtNNDu1w/MUmUd7KdYa0M+N+L2Zy5otPG0Ds0e21OoC5vo/Safcajc43iQVrv8hUJChV9I5VF00r3pEA0Ys7r8gwWSgeISMBJ9oG7U1IpXGiZeUnd7tHxpy/1rXRcKv6FXYXJDtGt86TKHnTjNrr2gl+SnS+Xg1TscHsfXajlkyXr1C5bijeLF5xg+Q/tGyZqv
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD6D31CC2560AF4883103E2944138832@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da2258c-f801-44be-aa8b-08d78260de81
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 19:48:05.9934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XxJUbGl2T0NTdLsPzdJlTeT8fhDAU6dfjhsyoL+OGuxiSzVKmp2PrcVLUtFISqb5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1657
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=698
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEzLzE5IDQ6NDcgUE0sIE1hcnRpbiBLYUZhaSBMYXUgd3JvdGU6DQo+IFRoaXMg
cGF0Y2ggbWFrZXMgdGhlIHZlcmlmaWVyIHNhdmUgdGhlIFBUUl9UT19CVEZfSUQgcmVnaXN0ZXIg
c3RhdGUgd2hlbg0KPiBzcGlsbGluZyB0byB0aGUgc3RhY2suDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBT
b25nIDx5aHNAZmIuY29tPg0K
