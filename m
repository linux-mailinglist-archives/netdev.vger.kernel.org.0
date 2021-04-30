Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FC43700B8
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhD3Stf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:49:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3Std (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:49:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIiBB2044723;
        Fri, 30 Apr 2021 18:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HYCr0U/7DDVNDyv9nO5E2Y7aeXsWXHxVXGyTnO0Bt0A=;
 b=fw67ZmtxIb676kW4V/coLQAn0V8nba9aQTtxEgJLb03DMpym3rypkmednja3egQnHgMC
 zZm7M7IVPcaX4q7eMMfIU8RNBE3WjngGGo4Yz855qqyJE+hMzdKHGx7P53udBhTAJCu5
 h2RYXSQaiHHJ33JPWbO7qS4f5P/XgdJGuQjgTO0yqbaOpeSJXj+WdlnYccdz80rWaX7f
 wymorQBfQXQ1SMlj/niyQnLVJ7UViwKKGSj4ScY2Rm9I01wRIR2iLBtaXR9LFfiWXLsG
 ILZdTl/aWtL2TgQJqeWsYKb8OtAjCn0gW3LykbGjzuT29xVwhMTbgnVl4rtzWBsuDuvk fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 385aft8mcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 18:48:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIiri4122303;
        Fri, 30 Apr 2021 18:48:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 384w3y45yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 18:48:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOP4/waiPdzg0sHCHY3XrvzoL0vZtwwP+FiJUgLyieXbnO1G2pXxxPAyvgYEaF135gwjtBvQ+CJztBnvyo/nxxrY+CPBe1d7AoqrcFsV/awKOxXaDlprX34wYT/i3CR9jnp45H/c+qY54leskOmcNCXR/8PYNMn2aadjOMSKmiJYPqXPNx/nm0MafpPuxHQ2ApjwTlMzJbfcaFe5jOEtnlpHHvj5BaNTN66ry4n5f41sbdVy5c9SSUQDeeN7PBEdwqOeYHWT3YMIi0PzgCJ7XjLZBAMAlQlRKta1vueZodMOrXYABreZm9NuzYJXu5dC7FKwxygTYynhlYnOk7PQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYCr0U/7DDVNDyv9nO5E2Y7aeXsWXHxVXGyTnO0Bt0A=;
 b=clJdGZwiRYjaSyqN0T9LMrjS55ibN8oEJG1ACc/xQe0sYljcKjggtsM2a645VC/TeePBSVWY5Aga7Eq5RlTKqAFOKftVO1o0ybkauqvmJsCAw9iuL8m5uFAnNu9dAZTpGDtzh5QXAh0q5AKxsN2qB7XtgJlCO75+mWmTsTi88yd3Nq3PPSknXQ7dOuOGkc4yLH35C5yUxu3TNIOOljT0EAubopM1Cc4rsHwY8h8n4iygMGplzdRcD/L5pqLRPOcukY+XiVqueJfpiPtO1IUKXPM5ZsGmyx2PGD423j/ZFcqtruGf9QpCwNcYNoEWE/CoztQYe1C7wKUQuevH/eT/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYCr0U/7DDVNDyv9nO5E2Y7aeXsWXHxVXGyTnO0Bt0A=;
 b=ErmUjQG5G/6MSOXsaKsenTKWoAQTNvrWDvNq/553jtV99XSW6zj7pl1xgrVHzvJXo/WHSsP3P4IWV7jcyuzb5cqbYyPvgMYClJvII07a8HLupmKSsADYZHNCOcOzIe59VVSatMkpP/Y2bu8Bnq2JRNef3HinXwopPHITsbyxQ9o=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR1001MB2416.namprd10.prod.outlook.com (2603:10b6:301:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 30 Apr
 2021 18:48:08 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.034; Fri, 30 Apr 2021
 18:48:08 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Thread-Topic: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Thread-Index: AQHXNgU7cqnWwo9uSUqkb8fv6D7LrKrAf6QAgABdihGAABDSgIABgYVxgAAb1ICACUmEkIABocSA
Date:   Fri, 30 Apr 2021 18:48:08 +0000
Message-ID: <20210430184757.mez7ujmyzm43g6z2@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
 <20210422124849.GA1521@willie-the-truck> <m1v98egoxf.fsf@fess.ebiederm.org>
 <20210422192349.ekpinkf3wxnmywe3@revolver> <m1y2d8dfx8.fsf@fess.ebiederm.org>
 <20210423200126.otleormmjh22joj3@revolver> <m1czud6krk.fsf@fess.ebiederm.org>
In-Reply-To: <m1czud6krk.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: xmission.com; dkim=none (message not signed)
 header.d=none;xmission.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16078c39-63c8-496d-8652-08d90c087f66
x-ms-traffictypediagnostic: MWHPR1001MB2416:
x-microsoft-antispam-prvs: <MWHPR1001MB2416D9D0C495B94250FCA9B9FD5E9@MWHPR1001MB2416.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4mgJ+d68kWycICveckGIQr14j97BwGRtkdOgTHLoZfiwJi3fAJO28oVLf6JtXmzuMFf8xRIcMoc4gzhDzKY8FKZK7RdSmHcrzDIOYEJaibKQk8QP3Hpj6JUyeGsuer6aR679CGGapZGGeefDwP/rDi3AP4de+MqLqc5SzVgLOvxDr1hsbTdK1nWqzS9ujntVywAlXHVRJJvDCRy6xP6cYYPgLgk0CMixAp6BIot+GwIK+yYyzYGUkNGk++BdGPw+qhUyB0xBrFLzYenR6CdBA5U2VbU23hqF8oti2/9J++izHjhEWrgfDo5Q9K3smX4KrOz/RLefcwvdeypGo0Oi95agel087fjYapzYSv4bBAeH0vhW4zg3zZCjMdwmUSLfsSp6iaB+ZVe3ZPyW3WLcz/rY0vgUgXir9q1scVChLW2/bUhJ35lFtH3xeo/HTFmePkszXV3TtBMryBGlt+KPKKmwhKUisydVPa4kgmSQwpdP60b7Zho0GdkEJ5QoeMJAzf0SFMTDq8o43P4Dmi1U3jJukAZryiicTgf4qYK77m11ZArD+aQdDboUTm4le/Axw9/PzbI6KYmDoIDoqpDRjBLOv9BJzMIfa3ZNknkribw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(376002)(396003)(366004)(136003)(39860400002)(86362001)(5660300002)(4326008)(316002)(54906003)(71200400001)(7416002)(2906002)(66946007)(6512007)(66556008)(122000001)(33716001)(64756008)(76116006)(91956017)(38100700002)(66446008)(26005)(1076003)(6506007)(478600001)(6916009)(44832011)(6486002)(186003)(8676002)(8936002)(66476007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Aq5tDMabjt/F6si95IbO9fn7mhf55JJF6ZvCHFOMVuTq6zgEt/+zIh3WnIXw?=
 =?us-ascii?Q?bakC1X3MVVqk7Ys2VWPyD9diM0tOdZWYRho6Rz/fFGKZUDNv/sS4Bz4g6i1e?=
 =?us-ascii?Q?qF/+u3x2B6w7tjXJo/1LxFxMvJf1UnVfjQeS/zj59nHK/jIMccZIGHfzDnal?=
 =?us-ascii?Q?D34CryMBBQM8Npgk7PPeaoDFGEtRrqvmvpc1QFLTA5/E+fOcH0p5g3XzYI8n?=
 =?us-ascii?Q?mX3BSTJIgo5x6gxtNDy4Q4ao+zPBBLA0AZADrhEzsoCF/eIgbnVbd9MHcUUZ?=
 =?us-ascii?Q?F+xZzgkDxqj1YiwyVQndizP4SEsvicu5Xo8z1rYxm6eMY7rpwRHYayGsMfmc?=
 =?us-ascii?Q?F0iyaFfhwCp/B6NnMbTlwRiMB8VyIuGExlZHf+PpeGYQYLgXgSijoCGBbAeb?=
 =?us-ascii?Q?a2mEVhlBihJXe870s9+8ia16qC+9ocQagyLQfmKmhStFDntFoIteeY1rPtV+?=
 =?us-ascii?Q?FYChSdx8i4RB39tEd+P1lw9H188zGQOrnDHkH/GbNj7+01sUZJVV4fe9Ye+Z?=
 =?us-ascii?Q?zRkwU/KWCR4wsrik0XN/GXJ5DHSUqxJ0VzGwZlNtRaE4uzVf0+Hqabbitm8J?=
 =?us-ascii?Q?yw4Y2TsL2itN55nEI2We5ISA51vtotVcj3+IqicvQkmOGFnyv2kt1WSXnTkX?=
 =?us-ascii?Q?nWrnDGD8fNe4aLIwwgqV8c0fsAY7cuoJAfsxmhOFdfORbChckkBZ6Ltxon42?=
 =?us-ascii?Q?dTciimrA8U6DSTLJssyroOYvFYXmcEvW214+1m0nQyR2mvqSSlN3/VyHTyWA?=
 =?us-ascii?Q?3Qc3/SkQYTGH7ZswqHt9CRSqWt3gBhPSADb9ON9/IQmgFF8XgtdmTEwzq+qJ?=
 =?us-ascii?Q?uU7/Bv4tOYb77yPLhTHTgsLWdfTEpou2Xlgy9Q0CNTcukN0g3c4eQkNwp8LJ?=
 =?us-ascii?Q?XNdTNEADvEBSug78Irf7OmwhhwaO5GUKF0V5BMV048gnDztxjOZZAQNtlZae?=
 =?us-ascii?Q?5vTD+UhBmhzht0cKjm3rRoTPureEiZdE6emwqL6vAIHMx+/EyiNoy2xek+bw?=
 =?us-ascii?Q?NXX4btluZQJtwMmByTYI3k9OqFZlDfQx78KfCFcCJwr5zRIUg8fNR29MmnQg?=
 =?us-ascii?Q?4D8ObCJdTeQsil1pkdHG0esCUoH7k2oohgQbAp/6ADGXzCxkaJz6J5giG8F1?=
 =?us-ascii?Q?5Ynf2puymu+XA4T3nZt1WGYUaUySEfmjkFYt1uuvW+glICgaruuOIkAbDTFM?=
 =?us-ascii?Q?HnuEHsHbsH8EgpSpJaa4MIk0zbeQp/ZFyXBk0aCFyv2ZmheGO1+uTGf1qfx3?=
 =?us-ascii?Q?/tw/SwiQmFn5G1Nx/P0/nWuIBcqKrwtRWKO4LOB9dDDsaiKgUYwRf9j77CFg?=
 =?us-ascii?Q?TLLwxFXlFwJsoVKxw+p52xZm?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38C7F8000F14444EB388C40FB3D20C5F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16078c39-63c8-496d-8652-08d90c087f66
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 18:48:08.4783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x52Q+Ar8c17MQalN5odCr3Kr11XWWfOrVxqsTA7aU7qkMCl7jWeNQzazblYqj5e9SbC6NTMiFlhvIeLfNYCYSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2416
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300127
X-Proofpoint-GUID: Hck_2i5oYsjL3ukberMMCBWfua9EZBp_
X-Proofpoint-ORIG-GUID: Hck_2i5oYsjL3ukberMMCBWfua9EZBp_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is way out of scope for what I'm doing.  I'm trying to fix a call
to the wrong mm API.  I was trying to clean up any obvious errors in
calling functions which were exposed by fixing that error.  If you want
this fixed differently, then please go ahead and tackle the problems you
see.

Thank you,
Liam


* Eric W. Biederman <ebiederm@xmission.com> [210429 13:52]:
>=20
> This entire discussion seems to come down to what are the expected
> semantics of arm64_notify_segfault.  The use of this helper in
> swp_handler and user_cache_main_handler is clearly for the purposes of
> instruction emulation.  With instruction emulation it is a bug if the
> emulated instruction behaves differently than a real instruction in
> the same circumstances.
>=20
> To properly fix the instruction emulation in arm64_notify_segfault it
> looks to me that the proper solution is to call __do_page_fault or
> handle_mm_fault the way do_page_fault does and them parse the VM_FAULT
> code for which signal to generate.
>=20
> I would probably rename arm64_notify_segfault to arm64_emulate_fault, or
> possibly arm64_notify_fault while fixing the emulation so that it
> can return different signals and so that people don't have to guess
> what the function is supposed to do.
>=20
> For the specific case of sigreturn and rt_sigreturn it looks sufficient
> to use the fixed arm64_notify_segfault.  As it appears the that the code
> is attempting to act like it is emulating an instruction that does not
> exist.
>=20
>=20
> There is an argument that sigreturn and rt_sigreturn do a poor enough
> job of acting like the fault was caused by an instruction, as well
> as failing for other reasons it might make more sense to just have
> sigreturn and rt_sigreturn call "force_sig(SIGSEGV);"  But that seems
> out of scope of what you are trying to fix right now so I would not
> worry about it.
>=20
> Eric=
