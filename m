Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1E12D12F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfE1Vs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:48:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbfE1Vs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:48:59 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SLmOxO020024;
        Tue, 28 May 2019 14:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6XTqEWQhfZeqkJ3i4aWqUY76MUMssW855O/1BlB0Alg=;
 b=hgbMZzO28QUsXkDXP8lMshmBqoHMhkYvVTZRsd2iPRMbBbAqEfwk4ijTReKXj9r1PgO4
 sPSV6iaB1lBAUgcySF2WGcY5IYHprn7B2T1W4pz9MXmN+6ISYlg7lr9HpoA8nsf+/9Iw
 v7PuR5TxObpH1geOmK/CLnfHT7ZmdMm23CQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss6cssny6-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 May 2019 14:48:33 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 28 May 2019 14:48:31 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 28 May 2019 14:48:31 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 14:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XTqEWQhfZeqkJ3i4aWqUY76MUMssW855O/1BlB0Alg=;
 b=qpzCkdKtEwkbnbxYrmrhAczDrKNdv0cXvPF9s2tLJD5T1NQ+UMKopYThGfNnL0NRXSg00yt4fLwVyPHcXegGGY33XW2QgZZDbZBCgaKms9MjQVSl24NQCPIj8tde0qfdK4bmebd6kMKaoM4ttGqWGFFooNVX5juGzqbMFvX4VRM=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2566.namprd15.prod.outlook.com (20.179.155.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Tue, 28 May 2019 21:48:29 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 21:48:29 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v4 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Topic: [PATCH bpf-next v4 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Index: AQHVFZpp/b439S6XvUGt9RAiotfhBqaBEvKA
Date:   Tue, 28 May 2019 21:48:29 +0000
Message-ID: <20190528214823.GC27847@tower.DHCP.thefacebook.com>
References: <20190528211444.166437-1-sdf@google.com>
 <20190528211444.166437-3-sdf@google.com>
In-Reply-To: <20190528211444.166437-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:301:60::26) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3dca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b71191f3-c83d-44c7-3133-08d6e3b6389d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2566;
x-ms-traffictypediagnostic: BYAPR15MB2566:
x-microsoft-antispam-prvs: <BYAPR15MB2566F1DAEF5F2046CEE64A2ABE1E0@BYAPR15MB2566.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(396003)(136003)(366004)(199004)(189003)(71200400001)(71190400001)(6436002)(316002)(25786009)(486006)(54906003)(476003)(86362001)(4326008)(446003)(99286004)(478600001)(6246003)(5660300002)(6486002)(6116002)(229853002)(11346002)(256004)(6512007)(4744005)(102836004)(9686003)(2906002)(68736007)(14454004)(46003)(53936002)(52116002)(6506007)(33656002)(81166006)(386003)(81156014)(8676002)(305945005)(1076003)(66476007)(66556008)(64756008)(66946007)(73956011)(66446008)(7736002)(6916009)(186003)(76176011)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2566;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wLmT2gGFj+oeOZuPmoMbDkWNkcGEDpKqxmZIg+JLOVpzKk44zxRztazzKjNdruhHCjRVTFWJC8tkoqM+xWH5ASu73PSQhnPNpqCWLrCQMaBFMc/mvVqMwCTIfcI/E7DIs4+A7AH5gXVqyoHfn0IQ/ZHnVd0gqwsszEcO8QDXocaLkcNDwO0z5dBYQoa9irEr5NBYvvvihAorxaz6T7lYn3MroIY/SqVr02bfVRYtL88E5yeTVENDKEBF/ARd9dSnFiP8Im08ad1k+tsAYiuBVDcRMfQFHXnEm8LZit6+u0vfbR9wTnO6m1WlmAmNMqTU59Zq5RRxhmz6GjY5OrgSjGP2RoXzoghRkZLAVQPM6UBswpv3iDlRJfoZHegp8X3HcwpQ5KO4UbOuYqhXNJajzrbI19RlAeLYqdnYxBHVHl8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21E75D9576662E499F9B0FD1C06BE640@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b71191f3-c83d-44c7-3133-08d6e3b6389d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 21:48:29.5691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=556 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 02:14:43PM -0700, Stanislav Fomichev wrote:
> Now that we don't have __rcu markers on the bpf_prog_array helpers,
> let's use proper rcu_dereference_protected to obtain array pointer
> under mutex.
>=20
> We also don't need __rcu annotations on cgroup_bpf.inactive since
> it's not read/updated concurrently.
>=20
> v4:
> * drop cgroup_rcu_xyz wrappers and use rcu APIs directly; presumably
>   should be more clear to understand which mutex/refcount protects
>   each particular place
>=20
> v3:
> * amend cgroup_rcu_dereference to include percpu_ref_is_dying;
>   cgroup_bpf is now reference counted and we don't hold cgroup_mutex
>   anymore in cgroup_bpf_release
>=20
> v2:
> * replace xchg with rcu_swap_protected
>=20
> Cc: Roman Gushchin <guro@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Yeah, the looks even better.

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
