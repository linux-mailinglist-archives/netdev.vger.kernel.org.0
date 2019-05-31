Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3070431471
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfEaSLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:11:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbfEaSLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:11:52 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VHrGiL025443;
        Fri, 31 May 2019 11:11:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f2417SouybzACeImhAlO/P1/nVnmXoIkxrUPfna6xg8=;
 b=Lx8yE3F4p6tRijQRmGvP3tkoBSwjoKD6p1ohEAxNiQ+M+L0m/X63pKFaeKDjbyAmBBKU
 LAMhMrf6qmLtFIUT9PWyh8crCTSOrNjTtYT1fi1ma2BOJCY/FNg6i2S0ivRJSYQCNNcq
 okYmVGIIYeF8ErSgSWU4oImGVC9phCWegXM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2su8d9r6s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 11:11:31 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 31 May 2019 11:11:29 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 31 May 2019 11:11:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2417SouybzACeImhAlO/P1/nVnmXoIkxrUPfna6xg8=;
 b=YkGITeeYPcI3fiF/8EiIAjAtrv0v6JYjphynqKWGcSBLmUraZVynXnvhoI5lKrnyKMpTH+4DQc5TUt2xJjAy7kEAtuL6d7G/ppLDxdl6SQkoURk9NDFHEdx7wqfujQRP4LFKi39bImw2rtKvpA0tAWhugug+5nW+p/XP2UPURwQ=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1181.namprd15.prod.outlook.com (10.175.2.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 31 May 2019 18:11:28 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 18:11:28 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lawrence Brakmo <brakmo@fb.com>
CC:     netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 0/6] bpf: Propagate cn to TCP
Thread-Topic: [PATCH v4 bpf-next 0/6] bpf: Propagate cn to TCP
Thread-Index: AQHVFbF23rX5rLub4Ei2d8S9IkFwTKaFjR4A
Date:   Fri, 31 May 2019 18:11:28 +0000
Message-ID: <20190531181122.xx5h63bz3t3iwy2l@kafai-mbp.dhcp.thefacebook.com>
References: <20190528235940.1452963-1-brakmo@fb.com>
In-Reply-To: <20190528235940.1452963-1-brakmo@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:301:3b::44) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:c2df]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7bbd73e-6b3a-44e6-8402-08d6e5f366a3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1181;
x-ms-traffictypediagnostic: MWHPR15MB1181:
x-microsoft-antispam-prvs: <MWHPR15MB1181850557C1FE30B8365644D5190@MWHPR15MB1181.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39860400002)(366004)(376002)(199004)(189003)(305945005)(476003)(6486002)(7736002)(14454004)(186003)(46003)(99286004)(446003)(4326008)(478600001)(76176011)(6862004)(64756008)(6636002)(54906003)(66476007)(25786009)(66556008)(229853002)(66946007)(73956011)(1076003)(66446008)(558084003)(86362001)(6116002)(6506007)(6246003)(386003)(81156014)(6436002)(52116002)(9686003)(81166006)(8676002)(8936002)(256004)(486006)(53936002)(102836004)(316002)(68736007)(2906002)(6512007)(5660300002)(71200400001)(11346002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1181;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UinmPVHXw5votJuRMmDID5RIbjopgHzBT2AvRhqGsOJ3YpzCOzLWjGeFngbOK5zsUO5nSEDNPgT2l8d4wP1UbqXU7LnP2VCGdut7Y3Pm668s51dcsqECz9vr0aKFAbMEir5BAc0fg+g1J8aLTM6WwzqtMC+n95jPVlcWJth72YfkMY3lODaI2AYDuNkkuwECai1ZQpx8hnOyCSLjxroleB9vOKKxoKOyqMjr/b5XHhfjWkEv6ms4wdzHWcppZcOKqGhyDxJXz/Z9Xfjbr12zov9z2TAothCPqGyM+saPf9bdCp4EVvZkqjwina4qo0q+X7k4kUiHDXPyikRjTcuSpPjDkRkxcOAA7okRRt7j9hXNLVJzBtTPu3khrge+XO4waJUEIBYwGRGx5dXs9Vig0RQv2AMTXbHSr7Nz3ayqK54=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7C42A329C2A1F4AA3F43223AF18C1CB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bbd73e-6b3a-44e6-8402-08d6e5f366a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 18:11:28.6143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1181
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=473 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 04:59:34PM -0700, brakmo wrote:
> This patchset adds support for propagating congestion notifications (cn)
> to TCP from cgroup inet skb egress BPF programs.
Acked-by: Martin KaFai Lau <kafai@fb.com>
