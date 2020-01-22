Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89E145D54
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgAVUwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:52:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15406 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgAVUwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:52:42 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MKqRfx012521;
        Wed, 22 Jan 2020 12:52:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AQ+ohz4+vsR89WG0VsAdMkAFvRA65De7yAbCYL9JsfA=;
 b=cSqDUfVXYhF5fyAuD5ZjkIcDj5/KmPV9qcuqRoyzjeQ5vwWDy6wbY7PFQtEloUtIOE5q
 h30c1djsEOuDehTrJV5kV/NR2kBqMBSM0riy2Efp28M327Oi8hItjjvdsy5pDJ6VSZ4A
 grhXA/y9EKuVxQPffjL/eTzPUHf29hpyy9M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpj9tk5aq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 12:52:28 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 12:52:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgR17ydwnVX3Aq3J4PVXdonf1dirXM0EQuxPMdpYYS+G2fCwb+cpMtvP3Q84LsOUhIdkMEiBGP8elUcE0ta0vY8lREZTM2EaCcRkBX4cxTHAFAHxg+L3X7/iOrk1Ro443gUAQNfuANomN2uviNHDV5P8oWRKUgc7E2vxAbQVmHdhgRSNxHI5EQ16w2Jhz2HqEn72mWwFW80kiNCOkp7N3Wv7hAQLc2/K0hKmb3aM+LNQ32KB1Pv8sUu7VAdASjs8Vmefdn5fPhLih6skHlY9IfVNQeYZ0RqO8ICyDJRXYkrNLbx6or9BR5v8vSBzpR1sgUBMG9q9QlzwcwQzQt44mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQ+ohz4+vsR89WG0VsAdMkAFvRA65De7yAbCYL9JsfA=;
 b=Cu7fIHF4PQSlU0NLhH6EcOMlTaLUpdfvZ4yDAP9oosQ3jQE9zPuTdD30oZg52GIYR7nBPbMumvHj4M+Z1GN471+sNR+R6zd+WJONCpRmHzqzR1E8k2buggzZv9RwaPM80jHTPH3rxJgrtxfMzNlM1ZbnJq3wDbXNi0mT3NiveW3ddQjsi3xS4h1GquOIHFN6sX8mhcrwAD9XJGlpCbjfylAIsz50PFnlYe8tXjPNzpDdrXRb4RevMlrzu5JXJ6riKANEoaC4rmvX3OVGCAQzAW2A0dqKqQf375TJqrrmWKFuEkr+FGS/CpYV+z09qYVj3CPz4HKZhLPBc5kOD6XZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQ+ohz4+vsR89WG0VsAdMkAFvRA65De7yAbCYL9JsfA=;
 b=LXxTGa3Ur+wdxf1IcRfhpTQ1A6sFURBw7RHTpUjpXfiwjGPth0C/yoCkBNtI/CfvsIx5jxtQooqcYQY2OpbKzOrohaZXMThfLrpz9/1XuSk10gRYALbjzgAOEA4/PuBusm56i8+jeOjeKdtTpwr2c4sUZd9DdzD7e3j0NZZ4XkQ=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2541.namprd15.prod.outlook.com (20.179.144.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.19; Wed, 22 Jan 2020 20:52:01 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 20:52:01 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by CO2PR04CA0114.namprd04.prod.outlook.com (2603:10b6:104:7::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Wed, 22 Jan 2020 20:52:00 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 05/12] bpf, sockmap: Allow inserting listening
 TCP sockets into sockmap
Thread-Topic: [PATCH bpf-next v3 05/12] bpf, sockmap: Allow inserting
 listening TCP sockets into sockmap
Thread-Index: AQHV0SSzKzV5GgWELUWPrZUg0lcH76f3KUiA
Date:   Wed, 22 Jan 2020 20:52:01 +0000
Message-ID: <20200122205157.b7ljnymrumplfahk@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-6-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-6-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:104:7::16) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4695b1f-67f3-4302-41b8-08d79f7cede5
x-ms-traffictypediagnostic: MN2PR15MB2541:
x-microsoft-antispam-prvs: <MN2PR15MB2541D3F7D85B446D31F30B45D50C0@MN2PR15MB2541.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(366004)(376002)(199004)(189003)(55016002)(8936002)(81166006)(81156014)(5660300002)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(9686003)(66446008)(186003)(316002)(16526019)(478600001)(52116002)(8676002)(6506007)(4744005)(4326008)(2906002)(7696005)(54906003)(6916009)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2541;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CptEUn4qDuFIdkb2ND3aO8WxlxWRaplKxUP4ZEeaUkyglknmf55nFJtBKYC9EySBK+U1Pc1Gszr9YF31R6l4dtlj3Xz6vGYGfUe9ef+vjjulWo6BEPozrVgSjA6LEIhz8hN1D0hDr21hexU5a4p42+WQYRkCkuhWlUZ4fYHMCwtDIigFVHseI4EaV97CoMFR6qGStK8pij/zBqULfBuq481B6h9Nyetj/yq6tRVLYVMQo2Y9S1HvPs+TsbavrtMX/hz6B7kOAew36jBPNkweXIagg57e6S2wHdMnHJL8SfI3kD3iwcbJ8tVAqz/kc8N4rq5mviN08fjwLHWvr7rbZVPEQOmLxiYoqPHe/oIKWvbMGYzFm79g2pyWCk+pF+qvFOUQFnPIthbdOxyLKy15zWRmAhlmnNHRiHvjPn5KrcK4nt+G2PK2QpXwrkoUFsBR
x-ms-exchange-antispam-messagedata: Ws17vc/YSUvwO6iUZQC6YEFJb9bPGExrsAp0ygVN/MBh1yvOFAckz+A1/JRFvUJK9qkNTkGXwTZxFYKPqC4SuwnpEUa60UP+J4Kb7/TNvfMvn8XJ1k3NnenJJe6EMBqDKIflDjHpPsAglfO4fPueT/14v62hJkY9XdkA9LFJPi8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10338C961EE5FD498D9A65968CC1C157@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4695b1f-67f3-4302-41b8-08d79f7cede5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 20:52:01.3329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qVJQkn6cb+p8W73uRY3rC4vo6dSXpuhW6ttTRNlspM1APzHg+tofiJOQiWXY96Rd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2541
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=587 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:42PM +0100, Jakub Sitnicki wrote:
> In order for sockmap type to become a generic collection for storing TCP
> sockets we need to loosen the checks during map update, while tightening
> the checks in redirect helpers.
>=20
> Currently sockmap requires the TCP socket to be in established state (or
> transitioning out of SYN_RECV into established state when done from BPF),
If I read the SYN_RECV changes correctly,
does it mean BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB currently not work?

> which prevents inserting listening sockets.
>=20
> Change the update pre-checks so the socket can also be in listening state=
.
>=20
> Since it doesn't make sense to redirect with sockmap to listening sockets=
,
> add appropriate socket state checks to BPF redirect helpers too.
Acked-by: Martin KaFai Lau <kafai@fb.com>
