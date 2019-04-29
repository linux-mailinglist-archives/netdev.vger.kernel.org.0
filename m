Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7625CE6BB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfD2Plg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:41:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728436AbfD2Plf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:41:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3TFUuLP006764;
        Mon, 29 Apr 2019 08:40:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iLZA70gLFhJM7f0zFPd1aRE6IaUnN3rcUL/lhvvpl44=;
 b=OultsvJKEShCnYB8iSoj8j1QCYME2QkEQlvbO6hLXGOVZC08766RuKUoa6BPRJP4elYF
 3ZEptPeqwTlREjiItFE4R0gi/UybtZaTXDnBDYgNxdP7ofc2cx3Z8F9tEqAnRl4qutib
 SJ5QG5I8k8XPeTQzGDm232HdO3zWklwUKHk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s62ad0dyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Apr 2019 08:40:25 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Apr 2019 08:40:22 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Apr 2019 08:40:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLZA70gLFhJM7f0zFPd1aRE6IaUnN3rcUL/lhvvpl44=;
 b=Gl/zhS0azfObgxdaMIfqzYCmpZKl5h/QpvvwU8/najE1ZOIoZTnFnZyUMEKve3yJ1Zsy8bhrlHv9XeNABM0Cp7n217KqHU1XsQRLzLNK+cUSSqJ3Gz0y7oeMQcWuikF274jZ2L37KaoAGRcSbjb34nLWu9r9n6AYOuTv0r4E3GI=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1245.namprd15.prod.outlook.com (10.175.3.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 15:40:20 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a%8]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 15:40:20 +0000
From:   Martin Lau <kafai@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] bpf: Use PTR_ERR_OR_ZERO in
 bpf_fd_sk_storage_update_elem()
Thread-Topic: [PATCH net-next] bpf: Use PTR_ERR_OR_ZERO in
 bpf_fd_sk_storage_update_elem()
Thread-Index: AQHU/pH06s/P2PoS+UqnPdwriAt0qqZTRoyA
Date:   Mon, 29 Apr 2019 15:40:20 +0000
Message-ID: <20190429154017.j5yotcmvtw4fcbuo@kafai-mbp.dhcp.thefacebook.com>
References: <20190429135611.72640-1-yuehaibing@huawei.com>
In-Reply-To: <20190429135611.72640-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0022.namprd02.prod.outlook.com
 (2603:10b6:301:74::35) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3a1a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6028122-2970-424b-e125-08d6ccb8fc41
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1245;
x-ms-traffictypediagnostic: MWHPR15MB1245:
x-microsoft-antispam-prvs: <MWHPR15MB1245DA195D3DEF6BE7A8DC66D5390@MWHPR15MB1245.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(2906002)(5660300002)(81156014)(8676002)(498600001)(8936002)(81166006)(68736007)(4326008)(76176011)(558084003)(53936002)(25786009)(9686003)(6512007)(6246003)(52116002)(1076003)(6916009)(54906003)(97736004)(99286004)(14454004)(71200400001)(71190400001)(66556008)(64756008)(229853002)(73956011)(66946007)(7736002)(66476007)(66446008)(6486002)(102836004)(305945005)(476003)(6116002)(46003)(86362001)(186003)(6506007)(446003)(386003)(256004)(11346002)(486006)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1245;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UdQk6/+KBLofeVwxuJhExyAsxMoZGpirFVaFZaLh11k6M/GJQxeuwZekZDYSEaysfikckJvN7cU0jBcvZ+sBDY/fymPNWXbjMv113eldOaUIT6ByRfLtJ2kluLV0elokBYOBAF4dy/rEu+eQndvB5qtF4JjliW8YC/cCzYyxDDZHTrOm6TKciRAtBPd9Y3R5xWFzziVTA5UoOhEeuy2KG26vZb0WS5UJ56b7umTj+EZMqTqJc15GWWxSUqM1hITSloSUqljhcODyBXDXTchJkMH3C4gJ6Z4c21mwPR82lX8jBg8erIZui/PkQY4TIyMes6RVsxcLbfsPL1XpUob6/2yTswnPax4v30Y7/JVwjxDGQF2RrDliQ4Xuv3AD5x+aMXbHN50yqecZREUAgi9nytJUnafTWS1w4qlXTGew24M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCFFAFBA9133DC45874498ACB59C730F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6028122-2970-424b-e125-08d6ccb8fc41
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 15:40:20.1541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=506 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 01:56:11PM +0000, YueHaibing wrote:
> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
Acked-by: Martin KaFai Lau <kafai@fb.com>
