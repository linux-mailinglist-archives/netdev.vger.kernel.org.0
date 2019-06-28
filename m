Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B825A4DC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfF1TLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:11:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfF1TLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:11:20 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SJ9cgr026467;
        Fri, 28 Jun 2019 12:10:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h0tZWuOWSyXVPjXo4MnM45UMBUNBxnlDC2LEzCn9iNg=;
 b=m1OdZ8RzplfVJVXF7zKErd0vFVWM+8NG/ZJG1ZB4Zd0CpV22PkdcdSq4QF2Lm78ySu31
 PV3woQvwbrAy1ya6JkcxoRwDWfz5pY4CuGF3xe4STeWbRZ2oF7WoMtGo3ZtYual07lds
 EJ7Bv5vgZdLlebJ8C5+/zB6RGyDwiiv13zo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdj7w1m3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 Jun 2019 12:10:52 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 28 Jun 2019 12:10:51 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 12:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=YvTx6yx8UnEb4R4rIO3kyF3CBeY5+TE73JKanVhMEQM8j1UtYqwNrTNIyAC99yYEXMUxxo3a5tSyDwktIIks9Lgm9VnHHqlOPS3DEDQopGylCc1yzNd3d9xF9VNzwLoyg6TYSuVpH4RPskJlAp/JFthKd+JDss1zVvapmS6mBsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0tZWuOWSyXVPjXo4MnM45UMBUNBxnlDC2LEzCn9iNg=;
 b=EUKSMpRnjfnvWMBCVAyy6BtPTtBHqN2xGID959bYdaFWfjeaSZ+l0gHnEqsPdHANb9fH8F3NIn6QiwHKUcwnj1Z+jgDiKuBQGijjgF7HUK1/z6nnf0r9shpargUchF9LjWreFSTE3bv13T81Y60xpeu4qYyEtnP73u/jiscApco=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0tZWuOWSyXVPjXo4MnM45UMBUNBxnlDC2LEzCn9iNg=;
 b=TDoxMn719q3GV6NFr/QIzwJMfORKPJoTR3Kzo5HMafIUc7D+7fIXvcRrAndevmF3moIQg8vbMb+IE9hOLoJyZAf7Ajw1wvhxg6HrxynPMShQ94inBDWLWXPXAN8Ou7tglHAZRUjsUVYCXCfzHp5q7CBd5rs/NeFHtDW7VH7k3TU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1152.namprd15.prod.outlook.com (10.175.3.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 19:10:50 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 19:10:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>, Jann Horn <jannh@google.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awxdYAgACqQoA=
Date:   Fri, 28 Jun 2019 19:10:50 +0000
Message-ID: <91C99EC0-C441-410E-A96F-D990045E4987@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <CACAyw98RvDc+i3gpgnAtnM0ojAfQ-mHvzRXFRUcgkEPr3K4G-g@mail.gmail.com>
In-Reply-To: <CACAyw98RvDc+i3gpgnAtnM0ojAfQ-mHvzRXFRUcgkEPr3K4G-g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [199.201.64.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1dea67f-1774-4c91-d9d7-08d6fbfc5598
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1152;
x-ms-traffictypediagnostic: MWHPR15MB1152:
x-microsoft-antispam-prvs: <MWHPR15MB11520B4D22C510CB2FE0C369B3FC0@MWHPR15MB1152.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(199004)(189003)(51444003)(2616005)(33656002)(316002)(8676002)(54906003)(6512007)(2906002)(478600001)(66946007)(66476007)(8936002)(53936002)(6116002)(3846002)(64756008)(6436002)(66556008)(229853002)(11346002)(6486002)(73956011)(446003)(5660300002)(66446008)(86362001)(486006)(186003)(81166006)(76116006)(7736002)(476003)(305945005)(256004)(71190400001)(71200400001)(102836004)(6506007)(81156014)(99286004)(76176011)(14444005)(25786009)(4326008)(57306001)(66066001)(14454004)(6916009)(26005)(50226002)(53546011)(6246003)(36756003)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1152;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Hzj8nxUDUyEH1znzNfds8b1l50Ap/s+rFkWOhbmLHkf84PTbnwXvyXVQ5qwTYxOovh2gsOznWZ8DZgWw7wdhlpbS16p5Doy9VitJU16zMLFpyQeUkURXDxAFLJIn121YL4uQbcHY2bBT+WWGc70RvHHQKD35o6aRBy06YqjQ+ZygOk42xsq/FlS+6uzlt2WJLXa9IDqB5O6Rd4AHx7f9ScFB2/otAHo87FcXr53MpNexUVEyGhcdt3Lr3oLk8CMOnLlUn1PBR9pLA0yrbBWqfmgRxJ1+armrYV5cGDI72bBXrBBZax/phvB4Y4QgrpuEfWV5jvqZ0eR/yWaHiQqx7B7c0YngMIxeZSSQ1tqwcEBgMYXZShzqI1vnMKwglXjMyfqIi7WAMvY8+vhB6YOMZ2fWj6NAvVisdEPSKszEK6E=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B254E806A2E3BD419B5BC21DAF9D7DB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b1dea67f-1774-4c91-d9d7-08d6fbfc5598
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 19:10:50.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1152
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=250 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280217
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 28, 2019, at 2:01 AM, Lorenz Bauer <lmb@cloudflare.com> wrote:
>=20
> On Thu, 27 Jun 2019 at 21:19, Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This patch introduce unprivileged BPF access. The access control is
>> achieved via device /dev/bpf. Users with write access to /dev/bpf are ab=
le
>> to call sys_bpf().
>>=20
>> Two ioctl command are added to /dev/bpf:
>>=20
>> The two commands enable/disable permission to call sys_bpf() for current
>> task. This permission is noted by bpf_permitted in task_struct. This
>> permission is inherited during clone(CLONE_THREAD).
>=20
> If I understand it correctly, a process would have to open /dev/bpf befor=
e
> spawning other threads for this to work?
>=20
> That still wouldn't work for Go I'm afraid. The runtime creates and destr=
oys
> threads on an ad-hoc basis, and there is no way to "initialize" in the
> first thread.

There should be a master thread, no? Can we do that from the master thread =
at
the beginning of the execution?

> With the API as is, any Go wrapper wishing to use this would have to do t=
he
> following _for every BPF syscall_:
>=20
> 1. Use runtime.LockOSThread() to prevent the scheduler from moving the
>    goroutine.
> 2. Open /dev/bpf to set the bit in current_task
> 3. Execute the syscall
> 4. Call runtime.UnlockOSThread()
>=20
> Note that calling into C code via CGo doesn't change this. Is it not poss=
ible to
> set the bit on all processes in the current thread group?

I think that's possible, with some extra work. And there will be overhead, =
as=20
we need to atomic operation for all these processes. I would rather not to =
this
path unless it is really necessary.=20

Thanks,
Song




