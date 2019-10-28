Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560BFE6C17
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 06:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbfJ1FxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 01:53:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbfJ1FxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 01:53:02 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9S5o7iL020586;
        Sun, 27 Oct 2019 22:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1msbrGl+5SHDfVDNs6mZoSxdxHPDmTkovGERK+srMIU=;
 b=L57M0yiFr+Tahog+ZVbaiw+GyCXSc2sidFRZBJhpZcwr4t1buH/WeYf4LSHQ9hciX5pR
 pEUnkI9t8Cfin5GZV3DQxXU47n9K5n060L6fblOXYtildOn4whCw4kBko8pM8QnTxo0j
 +nsmbU/cmERNQZm/yHUu5sWbyZ5KR2gQvIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vw5uauhtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 27 Oct 2019 22:52:59 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 27 Oct 2019 22:52:58 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 27 Oct 2019 22:52:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRuoVHjesRtKHubkiaWlMEGSZg0PgYfV/czUCctXDDNy7p1CwiKG2NsmU1c/E/nhasY8z2GE0Wm/sKoUCBktcEmxz4BsD1F5aKN0wKAbukdjTf46YAyd7aJ3aqyyDKQptQtwKya3LcAZ0Iv0cqLcpoO2g6vSUVHyCR/HJ/VoomFug69gEMg1LK17vfeC8gvznYPa0tJKNEsv08KcPFrVnm2o1hsdYNfeuiGlER/gCkK65uWRrXvtRx0Sa5L7KCTyL1yMWqbyVYt57xRf7S9sqkK2jEMJUvORu+g6wSSDGrUHIHkEbX6eaR6fPoC1vwEP4MahQhprTvD2rcS1ha20JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1msbrGl+5SHDfVDNs6mZoSxdxHPDmTkovGERK+srMIU=;
 b=LfkoQIDZjXEZHDWu+QnHfrd6MwKK4juv0tDpc2aBrcwcgyWA9lcFMgV0WEiCX7MoUOvrCh3bqyZfgKc7HAaxcdeHifkzHN4XPiS+FQmWGn1Qen+7z6u8HjVxgSPLIdpEPBVdvMe2sd8f5JnIhyELMGr8Dn/95V7COBmhXKEguiPLRg1pEMlfcYt37CU9e3XXYfQG2OR0nIEBzjN41Li7YkdRlKbX02YmexXzncaONqtijMZ0KG4xIErxhxVJforrqifazKfnt+QTx0V4q49AXt+2weZurlR2790TduNJ1vgYpxvIcRp0jFdDdqEL2FnFJ1VJfNX8cVSpnKBSh423/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1msbrGl+5SHDfVDNs6mZoSxdxHPDmTkovGERK+srMIU=;
 b=RmL4Q0pZhP+GBjv4qdiuVpYb/My3lt6PJmkACuBEn/2c86k+l6lKrxl4bCt3YuNIOCvLLZ1sMIGbhohcYENfIgdhQ8MV5l3RpAijXSo9appL33ekd56cAurpxPSzR7h25+j8C08/DlMpF/UxVAmORvnqjvjBgk7Zs0F/Efn5Z9Y=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3407.namprd15.prod.outlook.com (20.179.23.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 05:52:57 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 05:52:57 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Topic: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Index: AQHViM0cMelp7mfgSECOn4gRCJXJt6dvlj+A
Date:   Mon, 28 Oct 2019 05:52:56 +0000
Message-ID: <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
In-Reply-To: <20191022113730.29303-1-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0075.namprd17.prod.outlook.com
 (2603:10b6:300:c2::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df9194a8-a738-423e-f84a-08d75b6b14f2
x-ms-traffictypediagnostic: MN2PR15MB3407:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR15MB3407149A2BD87AA1BFC662A9D5660@MN2PR15MB3407.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(39860400002)(136003)(189003)(199004)(316002)(386003)(54906003)(81156014)(81166006)(8676002)(8936002)(11346002)(446003)(476003)(7736002)(6116002)(305945005)(25786009)(486006)(2906002)(6506007)(6916009)(52116002)(6306002)(99286004)(76176011)(102836004)(14454004)(6512007)(1076003)(478600001)(6246003)(71190400001)(71200400001)(86362001)(66556008)(64756008)(66446008)(66476007)(9686003)(5024004)(186003)(6486002)(6436002)(5660300002)(14444005)(46003)(66946007)(4326008)(229853002)(256004)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3407;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZglWWsXuVoH0VcSEY4i1BWRqvCFMkWpoPGurKRIXuzLB9Fytj4pUdHN4yC05XHi6iVICrxPWGw+szxDVi+mfZrnn42s2K9LiTxRlniQEB505E0FqWmiifAfHZNs5oddykOAm61fiPvtwU2YKElikjv+h1fl9Rp/7b799N+EeFFODY7mzDns3QuF+GjgsxcdopAfXdXCZn0xPaGxAIbFP1aSwIqewA8IcrKFuUAWm6+x+SnorrFD9QJaDYLWDg8RgnHkwolIx1fbV4CQ/v7F6rj1wpO6etZ7GKIR5DUeu4/v4U6+ECyXSSIPm3ypMTwTunzoQxUeg425QIOFm9LxtCDu0VW3CAviUfqj/XUjYy0IHpcEAZmk/a5YkhCcqfHFczHNMzZTkxmE1w2Dc8LBHRM2Cd7szbnRJyeQkm7z78K/QMXCqusWKJ0ycq+Nm6zXVNlSZeczsn/WiuGEDZe2D67hMaWePQMHWkDdNCcVmXcc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F5A927D35117E4CAFB267977C04D95E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: df9194a8-a738-423e-f84a-08d75b6b14f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 05:52:56.9299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: reTrthk2qqzjkLUFaJS3ttiOV+XE5JNsaRozKpsFAZdSysL/+ctVWZ+1mWPDu5R7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_02:2019-10-25,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> This patch set is a follow up on a suggestion from LPC '19 discussions to
> make SOCKMAP (or a new map type derived from it) a generic type for stori=
ng
> established as well as listening sockets.
>=20
> We found ourselves in need of a map type that keeps references to listeni=
ng
> sockets when working on making the socket lookup programmable, aka BPF
> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found i=
t
> problematic to extend due to being tightly coupled with reuseport
> logic (see slides [2]).
> So we've turned our attention to SOCKMAP instead.
>=20
> As it turns out the changes needed to make SOCKMAP suitable for storing
> listening sockets are self-contained and have use outside of programming
> the socket lookup. Hence this patch set.
>=20
> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
> lead to code consolidation between the two map types in the future.
What is the plan for UDP support in sockmap?

>=20
> Having said that, the main intention here is to lay groundwork for using
> SOCKMAP in the next iteration of programmable socket lookup patches.
What may be the minimal to get only lookup work for UDP sockmap?
.close() and .unhash()?

>=20
> I'm looking for feedback if there's anything fundamentally wrong with
> extending SOCKMAP map type like this that I might have missed.
>=20
> Thanks,
> Jakub
>=20
> [1] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.c=
om/
> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__linuxplumbersc=
onf.org_event_4_contributions_487_attachments_238_417_Programmable-5Fsocket=
-5Flookup-5FLPC-5F19.pdf&d=3DDwIDAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DVQnoQ7Lv=
ghIj0gVEaiQSUw&m=3DY-Ap1QuRBsqsu8gATb1wH3rPT89No2mam2qINt1BGDI&s=3D_sfXVfJh=
B2eR7znE7-WBk660dQXIBxuDLRi7jvXVpsg&e=3D=20
>=20
>=20
> Jakub Sitnicki (5):
>   bpf, sockmap: Let BPF helpers use lookup operation on SOCKMAP
>   bpf, sockmap: Allow inserting listening TCP sockets into SOCKMAP
>   bpf, sockmap: Don't let child socket inherit psock or its ops on copy
>   bpf: Allow selecting reuseport socket from a SOCKMAP
>   selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
>=20
>  kernel/bpf/verifier.c                         |   6 +-
>  net/core/sock_map.c                           |  11 +-
>  net/ipv4/tcp_bpf.c                            |  30 ++++
>  tools/testing/selftests/bpf/Makefile          |   7 +-
>  .../selftests/bpf/test_select_reuseport.c     | 141 ++++++++++++++----
>  .../selftests/bpf/test_select_reuseport.sh    |  14 ++
>  6 files changed, 173 insertions(+), 36 deletions(-)
>  create mode 100755 tools/testing/selftests/bpf/test_select_reuseport.sh
>=20
> --=20
> 2.20.1
>=20
