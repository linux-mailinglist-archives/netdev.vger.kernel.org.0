Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43423BEB9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfFJVeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:34:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389362AbfFJVeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:34:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ALRLlh011900;
        Mon, 10 Jun 2019 14:33:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GbZXyWpBALIDgjzpCnufG+iYCGFO6m24sgZBdI5E/hM=;
 b=m0cLqjIn6WdKBa4P/nZRSDTJjenJJYH3K9zDWi5PzI8L9qvSNSEHiHq6rbX/CA3ioWQr
 i/M9k6Z7v32NioABVxofE5X7ldGGj4sPUpbUlf5bfuYYZZaoSNkPzcYYqJMLVml9jw4A
 EDrwzBNme4626UwwTtap8ZG8Wh0vOoEojsg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1wqbrbh7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Jun 2019 14:33:56 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 14:33:55 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 14:33:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbZXyWpBALIDgjzpCnufG+iYCGFO6m24sgZBdI5E/hM=;
 b=bfFRUh1GlNhpEUPMX0V7qH0UKYJ4M+C+l8v7G1hvugabXrElut024m7iF/S4MoAs2Z6opIuuZgvHXVTEl28F9QobmMlLhIXIU78rHTXCvU2hgSJpegVmrw9+XVQACe8KuIqJs0WiNUZ5efdUGBQVplbpsinGNDxVESClRPTiiH8=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1694.namprd15.prod.outlook.com (10.175.141.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Mon, 10 Jun 2019 21:33:53 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 21:33:53 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf] bpf: lpm_trie: check left child of last leftmost
 node for NULL
Thread-Topic: [PATCH v2 bpf] bpf: lpm_trie: check left child of last leftmost
 node for NULL
Thread-Index: AQHVHjP4qhUQs68DyEu8nAv9VT3An6aVa/mA
Date:   Mon, 10 Jun 2019 21:33:53 +0000
Message-ID: <20190610213349.de7wfhvo73my4kpp@kafai-mbp.dhcp.thefacebook.com>
References: <20190608195419.1137313-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190608195419.1137313-1-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0023.namprd20.prod.outlook.com
 (2603:10b6:301:15::33) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:4395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65126ebe-7108-4e68-0873-08d6edeb5599
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1694;
x-ms-traffictypediagnostic: MWHPR15MB1694:
x-microsoft-antispam-prvs: <MWHPR15MB1694E8537FB632D9BA9267F4D5130@MWHPR15MB1694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(396003)(136003)(346002)(199004)(189003)(186003)(76176011)(71190400001)(2906002)(53936002)(71200400001)(9686003)(14454004)(8676002)(446003)(86362001)(81156014)(68736007)(6512007)(81166006)(11346002)(4744005)(8936002)(25786009)(256004)(52116002)(6916009)(6436002)(1076003)(316002)(54906003)(6116002)(6486002)(73956011)(6506007)(6246003)(66476007)(66946007)(66556008)(64756008)(66446008)(102836004)(386003)(7736002)(478600001)(305945005)(46003)(5660300002)(476003)(486006)(99286004)(4326008)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1694;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Jp+q1569Qa3tMjZZS+keMrqpsceZj/cceOu7IXobEClGoUoQFrvY16h6fZ+0LRV18tspMEJK3WJCTVJdsE2z8a02xh3YdmuRn5HY3jtTrWwjymlyQVU9igSPSwJlbvJ9ivqhagRcZIqnEiOLphtXTfmCAuUrDhHo+dxmRTelQxIbj41ARNblaDageevdi0DLh/CFPzf4XnDwRtnWccPwSJI+zENs1K2NDNzdIvO26ftKeiCG18w0Q+Vcr+BTPyf1w6/R0Bo2Jk9eMyOxmzko7pvFgrp+CHCr9dIDei6ijm8ZWyEMoktIdJfvus/LCM3lXk1z1pM4OFC5Kx3mbRPm8Yvu96SpJinJmHP2GZ62fwlHSSdKpOl1DCGsUA9ZgVM/eB9QeNhAHbTSGqe12gtc+tYo35UFozIFd1ARaWmlcGQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56B937AB4AD92442B4AA2EFC3670F59C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 65126ebe-7108-4e68-0873-08d6edeb5599
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 21:33:53.6019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=609 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 12:54:19PM -0700, Jonathan Lemon wrote:
> If the leftmost parent node of the tree has does not have a child
> on the left side, then trie_get_next_key (and bpftool map dump) will
> not look at the child on the right.  This leads to the traversal
> missing elements.
Good catch!

Acked-by: Martin KaFai Lau <kafai@fb.com>
