Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F7E44B7D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfFMTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:01:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49412 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbfFMTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 15:01:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DIwV6q030063;
        Thu, 13 Jun 2019 12:00:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VFPPYCcQREiqIC+TSEfHFRUTjX4IcpHWBNNCEdTYgwY=;
 b=SG8Obs+l9F/mu9LpvSs/K+uot6q24NQuxy70GcBFzeSoplEDo9d3RXGwEhGavX8LAv5+
 /pggLFIJTfgbZj13ZSE6cTuHYeSPgh9Aiy9B69wSl3b6himD+wzOL+lnuBxgYePH0Cdn
 HtqT3WwW1sLOFrYLZCWtYEZK3wQqyDr1x80= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3pr5ha73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 12:00:32 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 12:00:31 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 12:00:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFPPYCcQREiqIC+TSEfHFRUTjX4IcpHWBNNCEdTYgwY=;
 b=YHjlYRNQf5T/hSM4mU3vBgLFQXVEZsU3p78nCwBV0BTfjt0wuzZpW9w3gh4NXeeSJsUyt+MejoY5O5w38ue2YzP+U3j2qg9bEgwm8/fc5b8E1Et2JrL0rQr3ifoNHtKynEYc7euinwcpKlDKqm8Tr0ELsYCNSn1IWyAyHEqHeRI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 19:00:23 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 19:00:23 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 0/9] x86/bpf: unwinder fixes
Thread-Topic: [PATCH 0/9] x86/bpf: unwinder fixes
Thread-Index: AQHVIes//WMyu4FDpkOs0XVwNclJ+aaZ8KuA
Date:   Thu, 13 Jun 2019 19:00:23 +0000
Message-ID: <F836C59D-3C80-4D45-9BB8-34FF893A22EB@fb.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::706c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab079b21-4331-4567-7114-08d6f03163e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB18400ADF57434E341C0A4DCBB3EF0@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(136003)(376002)(189003)(199004)(6116002)(46003)(81156014)(8676002)(229853002)(50226002)(54906003)(14454004)(5660300002)(81166006)(256004)(6436002)(6486002)(25786009)(6916009)(7736002)(305945005)(33656002)(486006)(316002)(4326008)(8936002)(446003)(478600001)(476003)(2616005)(36756003)(11346002)(6246003)(186003)(76176011)(102836004)(66556008)(86362001)(2906002)(64756008)(71200400001)(71190400001)(76116006)(73956011)(68736007)(53546011)(6512007)(6506007)(53936002)(57306001)(66476007)(66946007)(99286004)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZJgLEQEJ4uaz1n+CEKsehEZ44IpVL/Gw6ziJHH8Qd8BLIcPN+yaWUtZ7SER/UbKXhFf0d8J79EO/Isck+y9CeKqRIcR+3j31vv5hu3JKthSDyN9cggTt4NQCK66UfwUOcEZUUdr25LaFr2/IcdTt65zKpOnA3OAvjMoM7EpvkPy0h0RERFMRextfAlYJ0mPnpLRYKDzKobM0wpP0OWeKjUWWUwnLW40wuoo0L2xpJuvLVxGwgHmd+rv7vJrVqvxLGUOcJmzFtvzv+DNQOVRGAwbBYScC7xridNi0Dhg2R/Fr2Ow8pw3iUlhOXVIHwNXYlBUW6zABbaarC5GoQyUPL0tK1ZIX0SLjr7RlFKgvRTAhwwPElqg7oC6LYgRbxYlDi6TgmU/aPwK19Wjvh0xkm4EClG2fNXbVTS+wu8sJkCQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D8CA8E3335AB0A4A8EA528E5B676E7B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ab079b21-4331-4567-7114-08d6f03163e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 19:00:23.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 13, 2019, at 6:20 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>=20
> The following commit
>=20
>  d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_=
POINTER")
>=20
> was a step in the right direction, but it triggered some BPF selftest
> failures.  That commit exposed the fact that we currently can't unwind
> through BPF code.
>=20
> - Patch 1 (originally from Song Liu) fixes a bug in the above commit
>  (regs->ip getting skipped in the stack trace).
>=20
> - Patch 2 fixes non-JIT BPF for the ORC unwinder.
>=20
> - Patches 3-5 are preparatory improvements for patch 6.
>=20
> - Patch 6 fixes JIT BPF for the FP unwinder.
>=20
> - Patch 7 fixes JIT BPF for the ORC unwinder (building on patch 6).
>=20
> - Patches 8-9 are some readability cleanups.

These work well in my tests. Thanks!

Tested-by: Song Liu <songliubraving@fb.com>

>=20
>=20
> Josh Poimboeuf (8):
>  objtool: Fix ORC unwinding in non-JIT BPF generated code
>  x86/bpf: Move epilogue generation to a dedicated function
>  x86/bpf: Simplify prologue generation
>  x86/bpf: Support SIB byte generation
>  x86/bpf: Fix JIT frame pointer usage
>  x86/unwind/orc: Fall back to using frame pointers for generated code
>  x86/bpf: Convert asm comments to AT&T syntax
>  x86/bpf: Convert MOV function/macro argument ordering to AT&T syntax
>=20
> Song Liu (1):
>  perf/x86: Always store regs->ip in perf_callchain_kernel()
>=20
> arch/x86/events/core.c       |  10 +-
> arch/x86/kernel/unwind_orc.c |  26 ++-
> arch/x86/net/bpf_jit_comp.c  | 355 ++++++++++++++++++++---------------
> kernel/bpf/core.c            |   5 +-
> tools/objtool/check.c        |  16 +-
> 5 files changed, 246 insertions(+), 166 deletions(-)
>=20
> --=20
> 2.20.1
>=20

