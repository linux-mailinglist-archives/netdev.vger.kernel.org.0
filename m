Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076593BECC
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390082AbfFJVjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:39:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389362AbfFJVjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:39:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5ALcn3p018529;
        Mon, 10 Jun 2019 14:39:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=c1qVk4nXj8/AxxzfHV8C4tPj+LO9QAJ4ptVjB/w4/5Q=;
 b=MVUmhkMOjcZ4IaupPNJZyC0T2O+WI9VTb6r3xbJOKXT/V8nskJpBMaDpRqx9Le128T1a
 /hOAWHVcgCy0gUe2rvGO7xW1WGZuMSr/SiCC952M5sGP8os0+s0MuVPkP7plOaNEcG2+
 CuAUvlUEkQCeRhk9CTaRJOkAhLIUibewKbI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2t1u4qs1de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 10 Jun 2019 14:38:59 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 10 Jun 2019 14:38:56 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 14:38:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1qVk4nXj8/AxxzfHV8C4tPj+LO9QAJ4ptVjB/w4/5Q=;
 b=ge5jRD7fYLuzTXRipLh0kxGqnQyGQOchrHMgRE8TOTn2gCsXV8EPq8+p4SKAeTmTE64+saxG6c5mjgHD8t5h44A1MCXtq8R5c49/PWLgWLLC0+qhd9p5WwRZEASYwMm4Zf5L9J3GW65LseUzuV1z39mGdEv8K9ARYByeh/b72tc=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1694.namprd15.prod.outlook.com (10.175.141.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Mon, 10 Jun 2019 21:38:55 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 21:38:55 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v5 0/8] bpf: getsockopt and setsockopt hooks
Thread-Topic: [PATCH bpf-next v5 0/8] bpf: getsockopt and setsockopt hooks
Thread-Index: AQHVH9C4cK5m9+GzZEimVutm907JWKaVaiqA
Date:   Mon, 10 Jun 2019 21:38:55 +0000
Message-ID: <20190610213853.vx4dtpspzgvsspez@kafai-mbp.dhcp.thefacebook.com>
References: <20190610210830.105694-1-sdf@google.com>
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:301:5f::24) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:4395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9b2ccfe-8a37-49c7-a948-08d6edec09e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1694;
x-ms-traffictypediagnostic: MWHPR15MB1694:
x-microsoft-antispam-prvs: <MWHPR15MB1694F51D1E015347A822EB57D5130@MWHPR15MB1694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(386003)(102836004)(305945005)(478600001)(7736002)(66556008)(66946007)(66476007)(6246003)(73956011)(6506007)(66446008)(64756008)(4326008)(99286004)(229853002)(46003)(486006)(476003)(5660300002)(11346002)(81166006)(81156014)(86362001)(6512007)(68736007)(4744005)(76176011)(71190400001)(186003)(2906002)(446003)(8676002)(14454004)(71200400001)(53936002)(9686003)(1076003)(6436002)(6116002)(6486002)(316002)(54906003)(25786009)(6916009)(52116002)(256004)(14444005)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1694;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /Qn6ORfAlky8kmobT2jFyZ0agy1i62kzSOgLOWhoEFoB00kY5ebSVTWopa03qDC+njlzCB+cOFLGS6Asxrgh67poljhB4op54ieIH1DDvqFFzvhB3ESu10X9yRuaHGme6s6HXb78i1vPD1Ny7kPiar7mHRdUpd1Ebh0gTGd9BEwTXEc0+zcKtUzyZ0QPTtNlnu8XVIo2vLthv2brct4F+b23KxHt1uxEeNE7WU4fJDbTSSxtkUb8moZQ5RjisZ1uGu3VyAiO6fOlt7zjdedKUNcyZDTiE2NpQAfUVVQRDVnCJehlJAfq56asj0BrIxorqUjg+qTXnJ8qwkFo4x4IgzFYnxaOo4+9NV0jmh0AgNEhcVmJ8fWgJzVF4TV22vC78BmQV2ml7PO3GRtbcQnEvAE2h83HH2ZIfa8QPkisSJQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56D62451CFBD80468CE07BB84E0FCA85@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b2ccfe-8a37-49c7-a948-08d6edec09e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 21:38:55.7861
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
 mlxlogscore=663 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 02:08:22PM -0700, Stanislav Fomichev wrote:
> This series implements two new per-cgroup hooks: getsockopt and
> setsockopt along with a new sockopt program type. The idea is pretty
> similar to recently introduced cgroup sysctl hooks, but
> implementation is simpler (no need to convert to/from strings).
>=20
> What this can be applied to:
> * move business logic of what tos/priority/etc can be set by
>   containers (either pass or reject)
> * handle existing options (or introduce new ones) differently by
>   propagating some information in cgroup/socket local storage
>=20
> Compared to a simple syscall/{g,s}etsockopt tracepoint, those
> hooks are context aware. Meaning, they can access underlying socket
> and use cgroup and socket local storage.
Acked-by: Martin KaFai Lau <kafai@fb.com>
