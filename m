Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12A62337D7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgG3Rnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:43:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45398 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727080AbgG3Rnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:43:51 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UHhTAM006683;
        Thu, 30 Jul 2020 10:43:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kjs30mLLJtvI0MNP152bEo+1h55nHchMl+6RwbGfCKY=;
 b=GirYQYnfq0JLriWthgRiypFHUq7Ll/hUONAgUdCwV9EZPx2R32/E5C8a4bAnG93av7+a
 Un5vB+I340xC/w6w8v1BRZ6VArOuBVMJ5bwvz3IffIq33zIFQXmKp8PzeLdTC06R+DMZ
 kIRYDTXC+EL+a1AHIKRBsdM15r/278eidZk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kxek9ruh-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 10:43:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 10:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSXdpon6EBw4qKIvAi81ebdv4eyi1iMAGQX9xCUFhvz3XzIMZ1BTle5s2xJ8fmgdNu0ygmoZeIXthIf8HSpCJByiOA9p/9mID13PMGGawuBsFsztg8Kj9q7ypm3f2yiRiF+Kj2MEvz3RVGFXl8C1zmPQKxR6aeIxWX4IDXYUcWlmiLEHYmNKDfbW/3eIjlnkcXXujyZC8beFzIVeWE/S8DQbr1zdZBUj1znlj7PaO5oyQDOcyNZdABfO7iiQCmpswyo3s8lgiFQt/iaHzfRpPVz5MZMSnqGGXwzp/IgRPo5PDDqxsz+zWAaBoSrDnO/ymx7nQfItbtrr3IKLXww7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjs30mLLJtvI0MNP152bEo+1h55nHchMl+6RwbGfCKY=;
 b=EA9wbMbjtL7UypFgqw7n7MbbI3b16WhrOzavfGlTLP+10Oz9gMnYzaA/0d+tXd5h3G1Bz5Ww/PzdQMbBEDBCtveVs219a4H6D0ixfaVIitkC9ZjM1z6hC/50LwQQTdNEli0LicIuhBRLFTIovH2VPTZDNfy1iTewJNAujlAG2pS2aClqGwu203qD7sdeo64W4ztOWIh76RygRa5pLc21W+ZiOMDu1vbZ02bx9PtTYRsq5Ay1NB3CjbvBih4TEWdz7K1AuSYVJFszLm2/PCm8zPGQIuhtV/rQ+U4vTNZ/MeW8n0Tg+D7ekqXeKz09jvkYTDM7T7M1wKBrn/vQMXxxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjs30mLLJtvI0MNP152bEo+1h55nHchMl+6RwbGfCKY=;
 b=fuZYR5+KqjNHMJZX0HQ6vL8O+deBfKFj3F+G0WOw51mItJyCvICbmxtX9hHhlkZPs8Wl1Q/h4MqJwyrLONeI5SXeA+uPPZX1MUL3pFKWRjoGW4ivymikcaruQ1qsfAWbUMIvcFoqKaIzrWDTaFlEL0YPe+y9n6acFyAiJVkWm8I=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Thu, 30 Jul
 2020 17:43:22 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 17:43:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH
 command
Thread-Topic: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH
 command
Thread-Index: AQHWZfzM10o3KVlXF0C1TJ9tT1+b76kgZdmA
Date:   Thu, 30 Jul 2020 17:43:22 +0000
Message-ID: <E5C327CB-962D-46B9-9816-29169F62C4EF@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-2-andriin@fb.com>
In-Reply-To: <20200729230520.693207-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f857c675-cb5d-4f9c-9a8f-08d834b00dc9
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB26931F04EE4BF9E2235E6CA7B3710@BYAPR15MB2693.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQL0a24sxS/2y0iK5AAoOSqRAzIVMJKu6FsQ0nJuRdPFVxJ1NTnJv/hvVsk/IgVnF7lvyiDa4D3uDU6jlzySFlhxmLRVSb87xRvsHdxtwDFjlbIxtS1yNhQYyCc0zjgQz/D9LsmUSR5CzPlxO8HrYSvn+6LG1HsACka4UrdwQ7F4jLujZL9zkERsM0LzVFyHIjao7VWbn5V8aBfmVypWgl7NdV0hdHnnq9B//G4R42ybn8VfhRFZU3j8Q8IDviuWY1hkwgqu+eFL3uQgJxwHgBd/2HQuOOqBfPG6ScaizHdyb7UT+Fi3eiDTiSUsvA3+KAOEpK2xiEYD88SuC0qRYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(346002)(39860400002)(376002)(8676002)(86362001)(6512007)(186003)(5660300002)(6636002)(83380400001)(71200400001)(478600001)(316002)(4326008)(2906002)(6486002)(6862004)(8936002)(66446008)(64756008)(66556008)(66946007)(66476007)(33656002)(37006003)(4744005)(53546011)(6506007)(54906003)(76116006)(36756003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uGzWDUcD2q6DLdwV7W/bLDiApueVCSs7QbogbZbk06skbh8Ed44XzVJ7L3+ovqGs4VBSlj1LxOEoYxcHHyNNt/y8JLgrY2IMGhZsJ2rgb1NXZnoyvc+F8saoOc0bZOya2EAprSPGrasRE4AKkKW0LwcanQIpTqFUNRs6/fxigzhrG5TulIBr+e88AK2AjSibUV+5lMVzE2QnGcqMUyV9DYt+6Y3jGRGLRhs6XCETwgEPbG+aFQVL2mv7OO5q/AJ3gerfR8ie9shkVTBfYhIZF5lhZxeeCzo0t5QWi6KVz0LNphJz0TqEpERiEBqZnHu6PyZYBTneEcdId8/mRe6rvOf7wNUk36/w9s0uioj/o4zX8dJXdcgeMenNtbWPJONvSaKANM6V+J3cqDWXGVWEjbGGL6JJ8f9uPYnDKzaeia5DHkRhvpqBhFL2fVudd0yseGZEIXkLxof0J/uEDrgIPh/ItCU1t0maxcaBvWqtXjrmO0uPYdtuTsEDxq1AcnMiqbJdudir2gGyRbAFb2GqGw==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A47D36D76FCE1E4F948F437855109283@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f857c675-cb5d-4f9c-9a8f-08d834b00dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 17:43:22.1920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2m6kYMNPLOa4vL6L8HFCu/MthwjxxRqP1Sug/IhsrCKNXotiPEUep2gemfHQP+lIxUXnyYonRLS7eHgBL+Ut9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_13:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=954 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add LINK_DETACH command to force-detach bpf_link without destroying it. I=
t has
> the same behavior as auto-detaching of bpf_link due to cgroup dying for
> bpf_cgroup_link or net_device being destroyed for bpf_xdp_link. In such c=
ase,
> bpf_link is still a valid kernel object, but is defuncts and doesn't hold=
 BPF
> program attached to corresponding BPF hook. This functionality allows use=
rs
> with enough access rights to manually force-detach attached bpf_link with=
out
> killing respective owner process.
>=20
> This patch implements LINK_DETACH for cgroup, xdp, and netns links, mostl=
y
> re-using existing link release handling code.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

The code looks good to me. My only question is, do we need both=20
bpf_link_ops->detach and bpf_link_ops->release?=20

Thanks,
Song

[...]=
