Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7465D125784
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLRXMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:12:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25614 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbfLRXMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:12:42 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBINB9Zl025706;
        Wed, 18 Dec 2019 15:12:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4F1CY1uUdKCzGL9KIYRi9bzL9vQprt93BWw5DAQOt0A=;
 b=JrA26EM72zdIifeHawfhL/BCDve0PUZEoRH8V44nWt/XwHN5uFSkbsp1DeSKEhZjTjGV
 6mdURofrFnD+h7QwIvGQN6LlKudPM11DFQ8Xx1VI5E687LPinufxOF6x7X0HqcoHq43X
 H0nqdfLlhAi57E9xV+5fIkwWgTPpRE8CRVw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wye5f4es7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Dec 2019 15:12:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 15:12:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGXv01Y+33L9U1JlLd5U4lLHQtZt13LmfKWxlNd7I3JeyTLXjt0pVoAbd0dQDxTIutLP2dX2De86nr+PcK0gqhQRfCmitmaC8JkW+DPUjSHcEeQJ60/o22weD8D7FF30Yk4jBs2CrSVUoY68zD/TyoU/rAynywhb0nPm6cbiztQkjIdd3t/FsGN6Tvskf8yCMMGzxU3aUAjSf9B0jVtLmlGOLpodgGNRtBp6fhBBSI1QfQy2HiOHRHBLHF9t6dO0iA/bDC3kM8yoxaj6elB1sQlgnFb3iRGusfo110blCDxpIDx2lgYVOG/UiMEp6bvvotCmjljjblUn6pWIV4uBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F1CY1uUdKCzGL9KIYRi9bzL9vQprt93BWw5DAQOt0A=;
 b=Z/xcCwSQh1zG+P0Av7aAT1CqyDBFXpk0YNJghn/gNxidij2Jqi0Hpn+3z2HBYaaWhZxnt2Pmq4f4QFMZvLKftWnBysPDVLEF18KOx8ZDOD7HInUpRZdfnReuM/oDI9iNdIVUSAsezNjt5t8e8enRvcviP91mYPe3p+HvGmE+eRKB7gM88XTphfMKfIR6keX6JZNWk9nQpmaM/qvnOMf9oirVaAAYgUz6S+jftfjdnXi6KM6t4ioRR5XZP2yXAN2TAkj2hWyqFd6wlKi744f5LupqshXHCQ7Hy/S0ovTEw4uo2MRWLGaAT/FjNfuhmxXiL7D3Yi3/RR+FaOAkWcmbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F1CY1uUdKCzGL9KIYRi9bzL9vQprt93BWw5DAQOt0A=;
 b=OSXHWfeidBID5ZKATPSmTQZMOrZ7zb5kuBmWY/VgUrcOUdzIf8A41jDclludXTJ08If+VJXk/pKiof6vvZwDEmxtFqkE5R/FYXXgNuzlhS7GXbrViVqOb1mUk53x8/yI8gKjyyi0xXxj85jMCsE0d9hm1k5o1DpbIntVw0o0yls=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2526.namprd15.prod.outlook.com (20.179.146.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 23:12:19 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 23:12:19 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: add
 bpf_link__disconnect() API to preserve underlying BPF resource
Thread-Topic: [Potential Spoof] [PATCH bpf-next] libbpf: add
 bpf_link__disconnect() API to preserve underlying BPF resource
Thread-Index: AQHVtfWZJulKll6KC0+Tn29h+sCeNafAhUCA
Date:   Wed, 18 Dec 2019 23:12:19 +0000
Message-ID: <20191218231215.kzrdnupxs3ybv2zh@kafai-mbp.dhcp.thefacebook.com>
References: <20191218225039.2668205-1-andriin@fb.com>
In-Reply-To: <20191218225039.2668205-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0112.namprd15.prod.outlook.com
 (2603:10b6:101:21::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::afeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 338c187b-5fdd-4675-12f4-08d7840fbb1a
x-ms-traffictypediagnostic: MN2PR15MB2526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB25265491DE97610885E933ABD5530@MN2PR15MB2526.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(136003)(39860400002)(51914003)(189003)(199004)(9686003)(54906003)(52116002)(71200400001)(86362001)(316002)(2906002)(6862004)(6512007)(5660300002)(6636002)(6506007)(8936002)(81166006)(8676002)(81156014)(66446008)(4326008)(66476007)(66556008)(64756008)(478600001)(66946007)(6486002)(1076003)(186003)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2526;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aQ1ccdVJ2yNNTvBfgK3+fkuOZE5I5b0Gu1icI7eD+vPgRvMMj1KWoIDpj2hou2/R0MTOfcIvl2+ci9ssBKZ46j9gTQks9AKl63unVW1x4UrQHUD0oJG0qnTaUzOJxrkzYKwzYSCu2Dw6vMTl6CZqbWq9/RaEL/2E7PjcbLRlNGhqNv1W/TSyTM2HiSWthxZsbjSFeAn2dsbM9oWeY5MeMxhgOkaaVw3iCJvwhVHIX5O9XhHciXRsAZ/hM5Up2bjYcFICOKOzSc8rGTGRQa2oOB3MZb/4tm02RAD7IPNP5ueqH4h3yKm/fTIvSWu/weIrCmx5C1yTm0K4YzeNJ77+cCtDF4vg804+GZLXiPjrx2KjmyV1NNti0RZKL0gB6TQMJo9xz09oU12BzJdneDZquFZZkh+uWPnCpd23CajAn35Pr1K9Nsn8PlEwcTIRF7lC4ZSGqysrjDFZKMJW2oFLfixOglpzR4Xz+f9bIe6KxFgvQ9uWoicBZsxxG4GtwnngdRIDM3vjAMK5w3eYaNDnhQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91EE89DC2267984F841FF20D8AEE51F3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 338c187b-5fdd-4675-12f4-08d7840fbb1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 23:12:19.6537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XPHxrBqwD0nWZcSte4rmfRrTQKWQ0NnMiOJmWOwc8yFGH/lSmxlEkzv8Dk96kDCb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2526
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 mlxlogscore=713 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 02:50:39PM -0800, Andrii Nakryiko wrote:
> There are cases in which BPF resource (program, map, etc) has to outlive
> userspace program that "installed" it in the system in the first place.
> When BPF program is attached, libbpf returns bpf_link object, which
> is supposed to be destroyed after no longer necessary through
> bpf_link__destroy() API. Currently, bpf_link destruction causes both auto=
matic
> detachment and frees up any resources allocated to for bpf_link in-memory
> representation. This is inconvenient for the case described above because=
 of
> coupling of detachment and resource freeing.
>=20
> This patch introduces bpf_link__disconnect() API call, which marks bpf_li=
nk as
> disconnected from its underlying BPF resouces. This means that when bpf_l=
ink
> is destroyed later, all its memory resources will be freed, but BPF resou=
rce
> itself won't be detached.
>=20
> This design allows to follow strict and resource-leak-free design by defa=
ult,
> while giving easy and straightforward way for user code to opt for keepin=
g BPF
> resource attached beyond lifetime of a bpf_link. For some BPF programs (i=
.e.,
> FS-based tracepoints, kprobes, raw tracepoint, etc), user has to make sur=
e to
> pin BPF program to prevent kernel to automatically detach it on process e=
xit.
> This should typically be achived by pinning BPF program (or map in some c=
ases)
> in BPF FS.
Thanks for the patch.

Acked-by: Martin KaFai Lau <kafai@fb.com>
