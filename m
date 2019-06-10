Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FFD3BED0
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbfFJVkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:40:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389362AbfFJVkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:40:22 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5ALc2kq017948;
        Mon, 10 Jun 2019 14:40:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wpl1gPxKZRfYTgXoFkJipAfuumNwEnnrXKqe0qnNPpo=;
 b=YxHPFJkrgizakD+z4jD1NHWmF7iPmTGNUFu4lA5/lj3Wi9BbDhsPs52yO5Ng4hYbMIuO
 u2mGY/G+w8+8XcByAg3Bx6dzhyHKJ0RRdDPAODR1DBVSYbougl3JgPMqIktEDIPlGLes
 drZbRcb3PQPCn/VM0Lhyk+esSIDFy5tzI4M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2t08pc7bnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 10 Jun 2019 14:40:03 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 10 Jun 2019 14:40:01 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 10 Jun 2019 14:40:01 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 14:40:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpl1gPxKZRfYTgXoFkJipAfuumNwEnnrXKqe0qnNPpo=;
 b=irlKN+mEcWapKxxBHUF4Lh6wXe1QfSV0HTCzQgpdm1jV2cA3DpMp/ce2gFeWsdGJVyrmfqOt0xpczYNw7+ScxEZCGRX9CN/3rV5tC9WRdTwu/EGe/KLKN6yYIYO7+2ICswk8SJJYE4lNsUI8uwfzbTWIrU8c0mgN3Xe2oWXQXT0=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1694.namprd15.prod.outlook.com (10.175.141.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Mon, 10 Jun 2019 21:39:59 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 21:39:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix constness of source arg for
 bpf helpers
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix constness of source arg for
 bpf helpers
Thread-Index: AQHVH7SHxjGVTIbEIUKF6MDw2P5+k6aVaq+A
Date:   Mon, 10 Jun 2019 21:39:59 +0000
Message-ID: <20190610213957.2q7yfhzy3b2o4wef@kafai-mbp.dhcp.thefacebook.com>
References: <20190610174655.2207879-1-andriin@fb.com>
In-Reply-To: <20190610174655.2207879-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0014.namprd16.prod.outlook.com (2603:10b6:907::27)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:4395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fec0a79-3be7-41e1-dcfa-08d6edec2ffc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1694;
x-ms-traffictypediagnostic: MWHPR15MB1694:
x-microsoft-antispam-prvs: <MWHPR15MB16948B6B32A45D3F203C9F31D5130@MWHPR15MB1694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(386003)(102836004)(305945005)(478600001)(7736002)(66556008)(66946007)(66476007)(6246003)(73956011)(558084003)(6506007)(6862004)(66446008)(64756008)(4326008)(99286004)(229853002)(46003)(486006)(476003)(5660300002)(11346002)(81166006)(81156014)(86362001)(6636002)(6512007)(68736007)(76176011)(71190400001)(186003)(2906002)(446003)(8676002)(14454004)(71200400001)(53936002)(9686003)(1076003)(6436002)(6116002)(6486002)(316002)(54906003)(25786009)(52116002)(256004)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1694;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2/ueTslaGODmljhNfnYrTTkVY2Xz/NoHhEo3SyR9j1SgU2y2g/1xkvlJE7X7SRd+PhDTMqXHJ6UHLkg86QF+jDh1OPhfKNlhHRAGX7rNCW37aE4oIBhLXkO0GHdyzBidVjRMZf6MWytwehoS2IYgMk/cRMcvU1yhFs3zC2rDO4xz6kSahK4Qg2dMBL7aWC49UUOqpL8zCNo9zjUG+mihjleME6E/6lnrh/zeubnYa8ArYEdW726+ECGm9LJwUaCgQp0j58Zck24ec3kOMFBpFch/Tek5IrvqmVXYj+qPPl2UOVcZNWKqpG2Ok+Htz7ftC82qQOCOxB1wKpq8h3VDVvospsdclsr8OYEUmVNIy37ssosIOg4bjxvH8aarOiXdNWSmKiSF0SaoLYs2vPY82r1ht+/yXYXGd2oTs1pWI2I=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A24992C45BAA5459D657BAF067B18B7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fec0a79-3be7-41e1-dcfa-08d6edec2ffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 21:39:59.6492
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
 mlxlogscore=492 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 10:46:55AM -0700, Andrii Nakryiko wrote:
> Fix signature of bpf_probe_read and bpf_probe_write_user to mark source
> pointer as const. This causes warnings during compilation for
> applications relying on those helpers.
Acked-by: Martin KaFai Lau <kafai@fb.com>
