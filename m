Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E5233B02
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgG3Vut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:50:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36134 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730552AbgG3Vus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:50:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULaknV019076;
        Thu, 30 Jul 2020 14:50:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=s2lFm7KxwtzE00jQIZqI1nr6j0EdVOgYYBJzoTA+5l8=;
 b=A+s7doNv3rhBIPbFcax4Qdp3MMkdOtlLBi7lzF1pH+ckyrzR/vgVzKemixL4MLh50pso
 Mb6P0mkNnSClgm3pS785sDgA22XRF+rwXDNFa5Ku3v8oQvuOK9XjOhfgltB8KqfCW9UB
 ZlKaHC1iYPb27eH7T4h6NGaSmaP8yAck0Aw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32m35f91n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 14:50:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JynoabTVPqwtBfvnVC2jdGq+WXTiCAmao2qjSkfKMadVvs2SsoMoGwhgFFxR889tIl7+PAzUuk/sTIlNRdYpuycroMwQ1NFXh2Ayx8Hi1BkhvoLLCLXhudVWOu1yPHro/5uEe8DE8tHK+pSwUuYJgUbHXko20CtV8SXrkJq82Y9eTOPjdGMc4KF0IjCPvljfdSagzsaJY7RabfT2JaG6lMl8QGUc9N4SbWb790nETfi6KmGKMhnK07ht8ApzAq0Eh6SvXQ7tFOc4YjH5M2im7KN0v3OfshgEtFgaK7DslpiDyJAlfhR+0QmSHucAytzknXF9oNna/jzWjDl0oa/Ong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2lFm7KxwtzE00jQIZqI1nr6j0EdVOgYYBJzoTA+5l8=;
 b=Zq4X6UZabvlHpXmSapWy0InGQLm9AUN0DQz87fkIKP9rAW6OhOjALcM5d/JepVxj+sW8mBKvlGo2MPOghjId4Rbt35JNtsMGR14f5BZe9fWvX/cMBZlchA1HGCgieZU6PKglGNDeDx2GGbjxVre+qqgRBAgvDiPNf0Sw6jRkG6k6JTkt2dSaQ4f5e0VEt5Y0jCvLoL7kapCqc+TQ9s7I2Ym7YU64ywCWQTAGkftzlhp52YkmiQszPyfPLfz9NOxhyfEjmqk1ajTiLJZMXffFU2wKR/A6LCpw0+fx2M5QxEAJtdGz1l6xWsIwGKs+RkReyhODhd6DzubJujJYC5Qrhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2lFm7KxwtzE00jQIZqI1nr6j0EdVOgYYBJzoTA+5l8=;
 b=a6ScdT+/eG7nsYHohKrKjWZsHal4Ce73hijSa0scwvNXghYcG84WYGIJOR2V/5r5SfefKSfkcemf0+VXAIqI9v4ng88gmQX6wPIGnKoUrbeiFHrbolFS5lbg+tz2XEFOM3oP9srUzi+h83PRpcL6j90mSKbbU2p7vxGmkP667EI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2776.namprd15.prod.outlook.com (2603:10b6:a03:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 30 Jul
 2020 21:50:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 21:50:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
Thread-Topic: [PATCH bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
Thread-Index: AQHWZfzjf8qCBt0Ndk2N70dqiVdn66kgoKUAgAAAqoCAAAmbgA==
Date:   Thu, 30 Jul 2020 21:50:32 +0000
Message-ID: <1BCA833A-4C0C-41BA-8603-E68C41C9FE60@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-6-andriin@fb.com>
 <770B112E-DBDF-4537-8614-765D19EDF641@fb.com>
 <CAEf4BzYOmtjmYRPjA_Crbt8TjQZpTG12YZSp1xTrr4d4dADcNA@mail.gmail.com>
In-Reply-To: <CAEf4BzYOmtjmYRPjA_Crbt8TjQZpTG12YZSp1xTrr4d4dADcNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6aa026fb-6036-4eab-d18e-08d834d29555
x-ms-traffictypediagnostic: BYAPR15MB2776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2776EBE9786335F9F284A6DBB3710@BYAPR15MB2776.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xYaciAfqBWAi/jLCDTTuLtuHdDpWaXqmPBeAXSp02ipUWfe35IAL8MWJ2D1tlLzLhf9RcFdtaDQsSnx/etLKORJERF/Y665nhAZ8p8Uf0UHos+U+k7MZse2t+v8DKHT9Y38QY+qX1jsuf1/E1QXPj2Pt/rKc5K3FllyR9bB5Rtl1adC29oLLhMxawWR8Trdlb0ok0Ytvt6moGK3xUz1Ih7DvJMNIWkwfHiAD54bbbulU9DJVu/CRoNtiWdBG+eCfZfSa7foA9PYlxgWndbKprkm+koRYnoEpBCf5AAqFMu/uYU33mPs/qB+J0RwQ43FCYsLQJdtpWckwK7fbrUu6L9m1hlnVj76SSC5CvuS6OT1J/qZ78u/tnK7a0pJDQOJm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(8936002)(86362001)(2906002)(54906003)(5660300002)(6916009)(83380400001)(36756003)(33656002)(6512007)(53546011)(6506007)(6486002)(478600001)(186003)(8676002)(66946007)(4326008)(2616005)(66556008)(66476007)(71200400001)(316002)(66446008)(76116006)(64756008)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BmJgn3gNG4Px+Cng4MLNMrsqU1o1u6fMKFsBMm2am+8W9B+0cW9MeK+FSte3cGEeQg3wjeWPejlk37gWFvXi5Yqc/IpePO95LB3t/uRkk5eA1sKZ51/K59lGgKv3B8qCRi2OeIRCWnIM7wiFhkQim7PTIzqIAbLFSj2CP7nM9pnZszqILB2/M5xUSLXAVfOYh4alri9+psFfU++SiLspATiWiNP8FtVgQzSahk12tdM+A2VQEA9k14jiZgCUxVHxo3zvt6aeBgpZTuQQCJwN6YZZKyI0MNTNtlKS5D8Mb1Eu6GvrPJEzHDDCsk+0ui13V2O9lAJab7l/7vkRjG27JmYVfXxUeX8NDhaWgzWyXs+3+IFxoQA/v0lSjgSxYGi1BckxTeqx4UHYsIaU1QJPQCQUTJzZFwT7ndbii3SbXvJq7orQWoqDnX69UbGNSH5cAuitQ6VEN1dIcM8nB4/Ge1PgABUftLCSZR+J6OjGpxhbAOhbDNJz02HhUsC07R8HEaBhXKNLq5EwTjnJhiOd8g==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A307FA6C7C00C14A9FBF68809420CAB8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa026fb-6036-4eab-d18e-08d834d29555
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 21:50:32.4462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dwlQkXE1YHdPpgAov+MxcF90Utzxim56jZ6E6OwonDlzMmBHJ2B8350emKoGmzHJLyQGOllg+Am/peJLw8tQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_18:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2020, at 2:16 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Jul 30, 2020 at 2:13 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add info on link detach sub-command to man page. Add detach to bash-com=
pletion
>>> as well.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With one nitpick below.
>>=20
>>> ---
>>=20
>> [...]
>>=20
>>> @@ -49,6 +50,13 @@ DESCRIPTION
>>>                contain a dot character ('.'), which is reserved for fut=
ure
>>>                extensions of *bpffs*.
>>>=20
>>> +     **bpftool link detach** *LINK*
>>> +               Force-detach link *LINK*. BPF link and its underlying B=
PF
>>> +               program will stay valid, but they will be detached from=
 the
>>> +               respective BPF hook and BPF link will transition into
>>> +               a defunct state until last open file descriptor for tha=
t
>>=20
>> Shall we say "a defunct state when the last open file descriptor for tha=
t..."?
>=20
>=20
> No-no, it is in defunc state between LINK_DETACH and last FD being
> closed. Once last FD is closed, BPF link will get destructed and freed
> in kernel. So I think until is more precise here?

Ah, I see. I misunderstood "defunct state". Please ignore the comment.=20

Thanks,
Song

