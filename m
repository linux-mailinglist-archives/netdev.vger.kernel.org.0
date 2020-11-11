Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C962AEA4C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgKKHpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:45:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgKKHpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:45:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB7ipWo002021;
        Tue, 10 Nov 2020 23:44:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=C8CCcA+x3QpCkzo4LWdRCwm+DE0lVzL4jtV52D14Trc=;
 b=K9pftcjI2lJwpEYdjhSM9G82gATjfQmC7Q5+PjKu5OWuDvUmh7U7H/6u1UN/sbKAib13
 lNoFIgwUH5ef2HbgJSSt1AvG/Rc8cevQH+JUMcHlHGPIjhffiEKWU25U671LvX+gXBjZ
 1zVaD/CMNsmF8Mm+KFzd5CJptXEZ5Zn7N2g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pcmjftm3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 23:44:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 23:44:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GY6xmgt0OWTWr8p/YnPgb/E2ywwVJ/ozmJJMz2NBxHKQW2TIGPsTJY2Dh0h9XHzJJyZzwLa/gvbOu2VAfMMmkqF9vVGwS+WaxRKdp3KiWcfJzmVCdv4yY+V5vQ/4K0hcE/1CDYFP1TMVa2C/ENGbPPFsvcYxq6kIXI1mn83uueDABBwTZ2r0BMVV6z0N51TIOEHFaPKV+c/kbQGBoD84b4jSHlg6Q12ZoESbSTwrW48XMtmcgOoMADjau1N7pw2fRsrD6oYe0o8O2SnTZGPQuh7OJnJgwSYEk90SWjmturEeItiy438MXPqd3bt+aqlpgbw8qL8K6PGR/5wBS43r6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8CCcA+x3QpCkzo4LWdRCwm+DE0lVzL4jtV52D14Trc=;
 b=bVNzeUd1eeE1YGnFmc4bejLxg+ZdhilgZp7yBhXXu4A+Uum9ZCyCXcc6y0rTJyYHr04EidXo4Rb04oglMRS+AnFiB7kBePq1J6fmiK8sxTvNjYVQxrhNtQ0sQSsniWaRvgIJq90j9MfSxt1h70IpcWGdck+KyO96sov2aBchbrom4nGqE8j5LQX5TJsjIv2A2caiyQVxjy5OHaK+l80QKRiDyRHxUGygk4QvEk9WyfapwYWeetJCLVvmBVJt7zYZJW6QVFLF0mTMWfmoRobC22kEZZN28AnEQmavWqwx+ZjlixOfP5q4oziJneHOfAd6Hm/y5NWv/WFax2YQIfW0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8CCcA+x3QpCkzo4LWdRCwm+DE0lVzL4jtV52D14Trc=;
 b=K/S4e1RHP1HIeByH5UWDVUdjORvbzXNDoBke9076xqIe5s9p7AcsmOoFfvt6/wkphhoZebm+8YPCC4YMikytmpZMBsNz35d00th30IuGE5ZCQTGPJB2CNUQ+g5YyX4VYMMtFueHJw3rG+PCcJx7K6m64/ONrcHS6tCEOj/DrsoM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 07:44:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 07:44:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Alan Maguire" <alan.maguire@oracle.com>
Subject: Re: [PATCH v4 bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
Thread-Topic: [PATCH v4 bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
Thread-Index: AQHWtwBlZiwFu4lmdkSb7Pyhw/89SanCIkiAgAAzfQCAADkugA==
Date:   Wed, 11 Nov 2020 07:44:26 +0000
Message-ID: <6F96BB47-7D10-4302-B637-33CFD3342804@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-6-andrii@kernel.org>
 <8A2A9182-F22C-4A3B-AF52-6FC56D3057AA@fb.com>
 <CAEf4Bzamkc29nHsixj1EJ5embPFG=ZCnys9CgPsvPDEMm9bS3A@mail.gmail.com>
In-Reply-To: <CAEf4Bzamkc29nHsixj1EJ5embPFG=ZCnys9CgPsvPDEMm9bS3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1f7d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 493348ea-074a-4bca-e809-08d886159d37
x-ms-traffictypediagnostic: BYAPR15MB2885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2885B871E621A3F972D7C18CB3E80@BYAPR15MB2885.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1ZtSRmwn91HCIRBTexn4vx6SuyOrRsYVl1Us2YZuSlfU7ap5rnqW/eaqpmZXqzcXe37IIO/wThK68XZZjZhHIZfUwgDtGPULq62GeLeHmU8R2gvAfRrKd+JP6n4o50Zh7Ryc64RpNjLB+1odpVHLMFdeInfIzqG76lMLRAEChSwEb/3S6/FxQN+VEPglZCCMNwp0s7DVmxF7qfojw9725VXjy60s4el40/W2Z2EUM/787UCtUc/VmJcDrlHmEDO6R3HOMz69nzLIP4yKCyLfkP3GyQLQ7ei5192IX2ISaypoTfQpIKbBdWWvQR1WSvMQsxd9SgP2akZ1jRBYvEDyxRvYDqVQpYXCPPVg6zghXQnRIr3E0heX111yUiqO8qk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(6916009)(6512007)(76116006)(316002)(186003)(478600001)(83380400001)(54906003)(66946007)(33656002)(2906002)(66476007)(6506007)(71200400001)(8936002)(5660300002)(66556008)(2616005)(53546011)(91956017)(36756003)(4326008)(6486002)(7416002)(8676002)(66446008)(64756008)(86362001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v3CVxZ14fjoFqejad2iwGSlinAx1S4vzfIxxLQuASTdlf/bcNvTcW8U6K628GO/BR/Pgb4yPmDPb+LE57kT2LyjfN6rgCC7s3V/wk1jjh/aNvLdCNEnI0sFGlF7bABh7twmNARUm3q5PbD3An0t4qgKrH5oLeyEkx95dLuQ2BjQ02FcoqN5nyi/ZLPu+q9aNn31M32+8zTNlEKUwFT17YbmZHp6HCI7TBIJzyvfEP9V/qv+lnCa5oan4rwjkEAHwiFSTO+gsfc2b9BDgr0u5AZIkm709OsV5KAmxWrvnk1MHkRCtmed3RrRcfsE6rHufTu20cnZOdNdIkmC2fjzo7KGuojqcoUBAHMR48HQfPOxGegrC+sG6eZXQDMHe5QxjDoWcacDPn6IYPQMkxhhbiclThsJOpn8nqt2au9SfKEyOO1EO4N/riJ1JNi2uv121uUtz2qoVWBlDlJ+1Xtbw0akatQErAlYhkDmfQcvkZzKNAuDKOMANLbq1AUjsjKL2JORbR3sgyLvwsjXgZmLlVXpx1iZSqTe5Njbe6OLaqcbNptp0zpOVGcT3eTyH+l0lc0jk8ePpJtjey9zfYzoRLJaQotd8Tmfq31BjxhkRoq995BHGNBkUBBzjRxvaOCB97k1CZNRvter7chMdmejyxYfcksekRbzjJ2efwRQnlEvXbaDeKq91ESECtRF1jD7iolPMvc2V99zUL6Ju2gLKLfLHAnLN/6Yr8jjrVHfRfI7y590ygZeWLkFc0WTP66mSJUo4DW2oFBZrD28Gi62mrkSnyqrNsAgnlrswPxb/V6axvUOZ5O4n6i8xCBMv6gRYAbAZOcA33SqhnC1bkmeauHxJSpBzOrowYdM6SCgHXoNEZnxRI3RSQzOaTGUwksP0fVl8MF1My3AsXGOsiVM6vH9heRkR9NwHS21kmF1pUu4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44D970B5E1AF0747B78AC6C835910D04@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 493348ea-074a-4bca-e809-08d886159d37
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 07:44:26.1518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YWxfOd3yVl5IUeJRGoKKHB9u6uA+rW3XWwMRbLFo3V/hK/o6rVC3X812tTdbU81e9ujWwhxbEPGzrhDy4DImSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_02:2020-11-10,2020-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011110041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 10, 2020, at 8:19 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Nov 10, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>=20
>> [...]
>>=20
>>> ...
>>>=20
>>> Tested-by: Alan Maguire <alan.maguire@oracle.com>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With one nit:
>>=20
>>> ---
>>> tools/bpf/bpftool/btf.c | 28 +++++++++++++++++++++++++++-
>>> 1 file changed, 27 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
>>> index c96b56e8e3a4..ed5e97157241 100644
>>> --- a/tools/bpf/bpftool/btf.c
>>> +++ b/tools/bpf/bpftool/btf.c
>>> @@ -742,9 +742,14 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
>>>             struct btf_attach_table *btf_map_table)
>>> {
>>>      struct btf_attach_point *obj;
>>> +     const char *name =3D u64_to_ptr(info->name);
>>>      int n;
>>>=20
>>>      printf("%u: ", info->id);
>>> +     if (info->kernel_btf)
>>> +             printf("name [%s]  ", name);
>>> +     else if (name && name[0])
>>> +             printf("name %s  ", name);
>>=20
>> Maybe explicitly say "name <anonymous>" for btf without a name? I think
>> it will benefit plain output.
>=20
> This patch set is already landed. But I can do a follow-up patch to add t=
his.

I realized this was applied soon after sending this. Yeah, a follow-up=20
patch would be great.=20

Thanks,
Song=20

