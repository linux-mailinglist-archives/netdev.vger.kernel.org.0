Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A653B35F8FD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351805AbhDNQbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:31:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349084AbhDNQbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:31:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EGEgur149290;
        Wed, 14 Apr 2021 16:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Frl3qGnuhhzmNiKBToajHVY2sASWR2ZgJRsSHRAPsZU=;
 b=KLALLeeiaXmI7U5+prZldZ4JCYdlg6NxreDIkaTjCxWutBQUu8bXofOBjYtKTkDVe8DP
 21hJULGu4X7Dvkbnmmqph8lPgXRWBA9M7FA2CFs44OQP8QXST+KtkHGPTJggz9qeIPfL
 Hz5k08NAWpOzXv6aBJ11izYSU76VKCp2vPojqldn+i2d4vFsDYjHqwe8BY3nTYvFDdkT
 xVRElWquYBs4ni3OHpszM9zG5v97CU20Hf8c06SPvbzxvwSYk9kWJBptc/a+nMV0yNsw
 puLX3Gy919NTYNTv/nfBDQlvqfWUk023ofuDhO17V7WwVa+dddxAVaf3IszZ3j/0wjyZ Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erk3f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 16:30:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EGGYAT072369;
        Wed, 14 Apr 2021 16:30:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 37unkr9r5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 16:30:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHOskn9q1BavT/uRpTzrxWQqhyvJ4fsbkhfJCDqSmfQziRGqDuQw68GLvULcdLfpWnewMNXTmTK/H5D9n1VPnweGHEoHGtQLijp5Pb4f6b3yB55VS95algZCod1BhasYKbmWIMH4Y4iykmdbuuNQndgORieJ0/qQqCjATxPUnEHCX8ATlzsClhPPagfA7uEdScqTRQe6UMfL03PJLuzMS56yHEe8OVJ+KuJEXm9895bYnk8P6zl9/29gQt6cRaHODRUuOPGNRDUKI5pkTiyjHeuXbizCw8SjjYWomjrEelRx0ae7DzkP4WEwGYBiYTqXVMfnIWyGbWs90I2FzgzIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frl3qGnuhhzmNiKBToajHVY2sASWR2ZgJRsSHRAPsZU=;
 b=KvolMQOja6hfmVJb9DRAAFjWNGBMByoBWw7ft8impLJ5mL0mlPh3GTt+ak/t93c2NSpHzeYFL/zZP0CMYN8+AeJwsWcJqS+BGG834DtrEfYTPFlQs0PMiqJf3LTxMMRzJCKDmYJnixxkD9lT3BNMEfhj5KkQ/myRICjTgvAh9w+aH5LB1X/WZ7O4pMazVsJ4dwGYeWoKE1WrPo+Gt9q4WndTdxtNQmahac5G87y2wQyMOQgZ6f0J0yoU4XGinSQnhRyFKuy+54DRuWHiPdfLj5jIplS0sCS9yIdhew3l/DEqM8FTCTWITgaxbqo2FV3xVJ1CoIvlAfBiSOGyPPP52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frl3qGnuhhzmNiKBToajHVY2sASWR2ZgJRsSHRAPsZU=;
 b=wruvBUsY7hJpBhIZK5gf0/jRQfZfMEoLLsy4MIJFwaAWQv7Yvde4Gkf/WgRXNytTKcFNWhimaLpDZ72a2CoRXWLt3SC0IMitjGhRq5qnjiC099KwcIE/QbUK78bmf27Yn4jBftlwAdgw2rZNboeYCTK2ZbIkWsNRBxNk5vFZslc=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 16:30:11 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c%11]) with mapi id 15.20.4020.023; Wed, 14 Apr
 2021 16:30:11 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Topic: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Index: AQHXK8A77pSb5Vt+VUCCce95n7TITaqxL0MAgAGEBoCAABMCgIABeQ8A
Date:   Wed, 14 Apr 2021 16:30:11 +0000
Message-ID: <20210414163006.jh2kccbliktnt3x4@revolver>
References: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
 <20210412174343.GG2060@arm.com> <20210413143035.7zrct6a3up42uaoo@revolver>
 <20210413180030.GA31164@arm.com>
In-Reply-To: <20210413180030.GA31164@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86a62310-4d23-48b4-db0d-08d8ff62935e
x-ms-traffictypediagnostic: CO1PR10MB4770:
x-microsoft-antispam-prvs: <CO1PR10MB47700E7B16C157AA23C70ED3FD4E9@CO1PR10MB4770.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RuixIKoPh+CPhxQZCQfx9plUGkHPHL86oTDpaXKSblxe+RWFyNRzaRPJptXErj6EeB3CbN23hQQOl8NQA8sJdMGLMkkhKv0pft6fjt7JqYyuxpEWh0O8f3+8mXYTrGDxwaYRO6S4WUfT3JsZftGzUVf0oopSuUge0Tdq9UE9nxt/2GgonxQbl98mNdIKlponpG0/zD7fZAewsgqQ6nE0uKXv/pHjLQRd511kZRcwecctP91Xr2VNqnW6PBHcgfIR2baDkJ1nw9lVtEvTLzL88fHdLXy7/kFEoVd7gLbgIXfxtRJj3UcMa+ze20MT5X4Kl8z5Qcyiu3RrfhdAPMWo2ForDEp5gWM3b0K6lza7xHds1Le18z6UzfWQA1eq3U0BBMNqu4gBEaoULRHbiaom5g982XI7bX3ArNmJ2jgHBWY4uksDZMsWXSySuiY29tEehlaSnEWUbq3lj9mhKJZAx5Qp5ToYfH0TeD1MZYV5Gh7oCczX9LmlXOpD5tWXMvsNL0va6e+dIzHfdCQVwdOpyBlejxWiRszTajwaMJZX+60pxfwAlZ2qxrZsGaqq/MS98uQ5GRNH54TkWyvUhpPVkZfcW61wWj5jynymLAGbH0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(396003)(366004)(136003)(39860400002)(376002)(44832011)(54906003)(83380400001)(316002)(6486002)(4326008)(6506007)(9686003)(8676002)(478600001)(6512007)(6916009)(66476007)(71200400001)(33716001)(66556008)(7416002)(66446008)(66946007)(76116006)(122000001)(1076003)(8936002)(91956017)(64756008)(38100700002)(86362001)(26005)(2906002)(5660300002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SsC9CxSZboGtnuZ5Nb/Wgi9ImbSzRmNqk0Yhg859lUlqjxGJlRAB8H+i9gtj?=
 =?us-ascii?Q?J74P9nMmrePJcswBlHHf/q4iwjFWn6cSFs9h9rQV+87KNdUfabiR9BH66yZv?=
 =?us-ascii?Q?Gnfv8E24Ht2843HmDuWTl+Xg0VkX3gCUedGXOzKM0ygTyqOeNk1tPFkxJEJN?=
 =?us-ascii?Q?CDjOrlITeYr0BzHUQTZoumH6EriO8FHxjnjSq+hvgqLBjBFgjUxv7oa4Pzzj?=
 =?us-ascii?Q?7sjJZWv5dAokrnEdv7KH0m+vQoNYiE1LoCBx77X3c51tVJ8jaIa6+tQMAehT?=
 =?us-ascii?Q?9eSyGSGIbaKIby1/t8+bNp56pyd3eiQ69YWO4ciKYALpfkMqK2aCpzo0dlEP?=
 =?us-ascii?Q?mVddS90jzKGLgeLvJYa4aGJ9J9K1yAxZnPMoqW3zws/8GOuzhbpCfrO8E/u6?=
 =?us-ascii?Q?e2vuvXtU/hjsUc75Cphu3lZYPp2uPWKeRUKLY8kpbG9UI+WANTDQEBen7kem?=
 =?us-ascii?Q?byS+i2tA6R7ZfxX57a6EdljUIA2RlbITxyxWpe7SsSJNVqIwCZuM0exlIFgB?=
 =?us-ascii?Q?Pqy281BB2YH2/ftDQbLSXPCqsXXd4uBfhWDhaFmKlHqVrWwxy4pL7rmfEn3F?=
 =?us-ascii?Q?h3kmaGqFt3Ujde1aEriZIxJ+Vc+6gKbR7ZJEJsQHH8I4Cd3vH9lAfygz8DSS?=
 =?us-ascii?Q?IhVNZI3JrCbD4Wve2kR1gyqTJTQQTPoIP7WLUKnz49BITotw1ADe0kl5CVMH?=
 =?us-ascii?Q?JHPoLB+n6NVQEVMy01hYpfG1MnM5wHu+x5tQzK1llowf3lL4W22W0AoteErU?=
 =?us-ascii?Q?zuHAhWX9PPvfc81KhXXtPtcu0UQ+usHFoteqQ1T1IeYmNXlcInSeaGTV3uMf?=
 =?us-ascii?Q?4Xt4hM6QI+z861ln0bVc+yWskfTa1XJHzadNmzYwYJStWnHDqoq3cwqbi/e5?=
 =?us-ascii?Q?S9VdEzup/VE47zVPY3gbQ6NThK4NVlK4OCthgfsLmPLCkeZeR6dLbNGiBwdI?=
 =?us-ascii?Q?gl3L1DeLWSKDrjssrhZJ8V/1IzF0Y4M7pj86upyu97vxKkk5D+RdBtwDIjrN?=
 =?us-ascii?Q?c63dLVoqepuA5ZoqynMLrRouZAQaUJfSq2/I8nz9bAfMocHm6dc8sadsvjPl?=
 =?us-ascii?Q?VUtqw2/Lph6akVnFr6A3yeRCgdAik1aFzKhMtCH1hNg7W2v4sZjyv9IlCOnL?=
 =?us-ascii?Q?iWFjDNb/wGm+/GOznpk8FhTUAtVTbv7BwQVPcQpKSq+XV/EY61WmkGRoWG4p?=
 =?us-ascii?Q?z9jE+yMphjZb6O2eQowuIM8jOGjpMnM0aOJq1/P1T15BFvsNnHQOYmfwZuhv?=
 =?us-ascii?Q?osDs8BBDYBuYyIg3AF/f3BwdQmHPbQIZrmj0oXCIfWX18u/OOIEOFD0+KhgG?=
 =?us-ascii?Q?YQqm03VASnK0fJuNJWkB0M2a?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <838FEE97A1C3084C97469725CCFBD0F7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a62310-4d23-48b4-db0d-08d8ff62935e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 16:30:11.5850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NO7YHqAbu5yv7sUocE/EIE2VG5/AQwvzfcSjegdRISv2GO95sKrNE1vb6vX4ladquKxOGNYvG2Ms58Nvf70pWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140106
X-Proofpoint-ORIG-GUID: dqmCT1ggQgPCavJD7rBM2RtUT30x4sCK
X-Proofpoint-GUID: dqmCT1ggQgPCavJD7rBM2RtUT30x4sCK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [210413 14:00]:
> On Tue, Apr 13, 2021 at 04:52:34PM +0000, Liam Howlett wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> [210412 13:44]:
> > > On Wed, Apr 07, 2021 at 03:11:06PM +0000, Liam Howlett wrote:
> > > > find_vma() will continue to search upwards until the end of the vir=
tual
> > > > memory space.  This means the si_code would almost never be set to
> > > > SEGV_MAPERR even when the address falls outside of any VMA.  The re=
sult
> > > > is that the si_code is not reliable as it may or may not be set to =
the
> > > > correct result, depending on where the address falls in the address
> > > > space.
> > > >=20
> > > > Using find_vma_intersection() allows for what is intended by only
> > > > returning a VMA if it falls within the range provided, in this case=
 a
> > > > window of 1.
> > > >=20
> > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > > > ---
> > > >  arch/arm64/kernel/traps.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > > > index a05d34f0e82a..a44007904a64 100644
> > > > --- a/arch/arm64/kernel/traps.c
> > > > +++ b/arch/arm64/kernel/traps.c
> > > > @@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code,=
 unsigned long address, unsigned i
> > > >  void arm64_notify_segfault(unsigned long addr)
> > > >  {
> > > >  	int code;
> > > > +	unsigned long ut_addr =3D untagged_addr(addr);
> > > > =20
> > > >  	mmap_read_lock(current->mm);
> > > > -	if (find_vma(current->mm, untagged_addr(addr)) =3D=3D NULL)
> > > > +	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) =3D=
=3D NULL)
> > > >  		code =3D SEGV_MAPERR;
> > > >  	else
> > > >  		code =3D SEGV_ACCERR;
> [...]
> > > I don't think your change is entirely correct either. We can have a
> > > fault below the vma of a stack (with VM_GROWSDOWN) and
> > > find_vma_intersection() would return NULL but it should be a SEGV_ACC=
ERR
> > > instead.
> >=20
> > I'm pretty sure I am missing something.  From what you said above, I
> > think this means that there can be a user cache fault below the stack
> > which should notify the user application that they are not allowed to
> > expand the stack by sending a SIGV_ACCERR in the si_code?  Is this
> > expected behaviour or am I missing a code path to this function?
>=20
> My point was that find_vma() may return a valid vma where addr < vm_end
> but also addr < vm_addr. It's the responsibility of the caller to check
> that that vma can be expanded (VM_GROWSDOWN) and we do something like
> this in __do_page_fault(). find_vma_intersection(), OTOH, requires addr
> >=3D vm_start.

Right.  The find_vma() interface is not clear by the function name;
returning a VMA that doesn't include the address of interest is unclear.
I think this is why we ended up with the bug in the first place.

>=20
> If we hit this case (addr < vm_start), normally we'd first need to check
> whether it's expandable and, if not, return MAPERR. If it's expandable,
> it should be ACCERR since something else caused the fault.
>=20
> Now, I think at least for user_cache_maint_handler(), we can assume that
> __do_page_fault() handled any expansion already, so we don't need to
> check it here. In this case, your find_vma_intersection() check should
> work.
>=20
> Are there other cases where we invoke arm64_notify_segfault() without a
> prior fault? I think in swp_handler() we can bail out early before we
> even attempted the access so we may report MAPERR but ACCERR is a better
> indication.

swp_handler() is also buggy.  It is currently getting the ACCERR as long
as the address being checked is > mm->highest_vm_end.  If access_ok()
fails, it should return ACCERR and not search VMAs for the address at
all.

...

>Also in sys_rt_sigreturn() we always call it as
> arm64_notify_segfault(regs->sp). I'm not sure that's correct in all
> cases, see restore_altstack().

Ditto for sys_rt_sigreturn() and sys_sigreturn(), they both suffer the
same bug as swp_handler() outlined above.

In the case of restore_sigframe() or restore_altstack() failing, it
seems that the signal shouldn't be dependent on where the address falls
within the VMA at all.  Should the signal still be SIGSEGV or something
else?  By the comments, I would have thought SIGBUS, si_code of
BUS_ADRALN?

>=20
> I guess this code needs some tidying up.

Indeed, there seems to be a few code paths that need to skip this
function all together and just set the code to ACCERR - especially since
the access_ok() just validates the number itself.

I don't think the right answer is to rewrite the function to check
VM_GROWSDOWN, as I cannot see a way to reach this function when trying
to expand the stack which should report back ACCERR.  Do you agree?

I also see that my fix would expose other bugs which need to be
addressed at the same time.

>=20
> > > Maybe this should employ similar checks as __do_page_fault() (with
> > > expand_stack() and VM_GROWSDOWN).
> >=20
> > You mean the code needs to detect endianness and to check if this is an
> > attempt to expand the stack for both cases?
>=20
> Nothing to do with endianness, just the relation between the address and
> the vma->vm_start and whether the vma can be expanded down.

Okay, thanks for clarifying.


Cheers,
Liam=
