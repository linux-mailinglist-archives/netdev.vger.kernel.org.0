Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E31188E89
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCQUFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:05:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1200 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgCQUFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:05:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HJZOpT027551;
        Tue, 17 Mar 2020 13:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MBqGaUcuwVb1sExBAm3/xRLRlp1FXubXK34mBduZZSs=;
 b=T5XjTRzTX6j2qKMdrUdknkGc/0Vm3KEcslv9iQx8M1/Ld6q7k/23xHipK7n/uHJYhJTj
 1iAlnsRJoZJXguZIjKteuUvjln1EU/W24zRJwsopMPDh5smZeUuo9qk+Xa6BDWl4SLkL
 oeRW3DprkZxUkuDNcJz/W/7JbgYzjlkvyyI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf3743dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 13:04:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 13:04:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThnK6gbMZHl+uTyVLeSbBR8U+/aHCNHmF9cPD6sDPxgONhJ7Y7Fa8h2ayxRhj2Suip5nDR1/2KHXuBl7ZW6AiUwezzmzM8jMAub+MtHeg2npU7cSL5ypfHv40qvmpEDHkSX59mbDv3h+qK5cTQd0Ufl605JEm9nimGMWEowmhysbFA/VgklXs+LViRG2PE+bQuyJHMN7IfsaUxcLaXPWSSbQjEWTo5alUbQ91y+2IM2n68oLmjSbYe1eAeFotZE0Zaq9zDT+c3EdBqklF9oWDi+fFn8faAQ2CwfpuCB8CfPn+exEuHTUZ8KOoMIiXb7teZQC2hTYfOqHlVsITMN8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBqGaUcuwVb1sExBAm3/xRLRlp1FXubXK34mBduZZSs=;
 b=iuMz5FpjqWvsLX9REmNVjXV7oqqBQwpmUTfnriTV1bvRhHF74Zp97aAzJc6fiOyqH2bTUoUCVMSx3W12dOj+sYw//pHz7lH4eaU8MD+suGbCbPws9O8LFpNG4a0IhiWcZvEv7aq3KVQMVlCe0tJ1Hyz+E1H+WF85gk3M6vu7U6JZ+SUP2ZG/rexyoFdHT/PTrMNtLKwlEpS1r0K2OTCNjLC5OtJNzRePualGAHEKdGxi2w23LYSFIAUbUVZS4LpRk2C/y9JVJuDwPl9vqTpWO2xwGXWdV5ux3layQCDee6v4HiSxFYrji+kFmQ+a6biI1DtdtUF+702vWq6ioCOGkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBqGaUcuwVb1sExBAm3/xRLRlp1FXubXK34mBduZZSs=;
 b=WHBVjHgVrXcTLAXL4+RRzkGn6q8fdppxAk1Ao44RhsZHETExRcKyuDyy3nfp5CfXSuiGdlf4CkmwCbpYnNKqeMRuggzmeZfjmRyS2nTvVoKtDR04nuitt4Wbpj7ZP+u2yHws/lORz+342buPuMEtbSjv3lFmJJdS3M211iDJ0fQ=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3948.namprd15.prod.outlook.com (2603:10b6:303:4b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Tue, 17 Mar
 2020 20:04:45 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 20:04:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Topic: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAALMAA==
Date:   Tue, 17 Mar 2020 20:04:45 +0000
Message-ID: <E936DB84-3CD8-44C7-ACA6-900C220138ED@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
In-Reply-To: <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47080db0-78c0-4a32-262a-08d7caae7076
x-ms-traffictypediagnostic: MW3PR15MB3948:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB39487A5A4E95458FD85BCB4EB3F60@MW3PR15MB3948.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39860400002)(376002)(136003)(396003)(199004)(33656002)(36756003)(81166006)(8676002)(8936002)(81156014)(6916009)(186003)(316002)(2616005)(54906003)(53546011)(66446008)(478600001)(66556008)(64756008)(66476007)(66946007)(71200400001)(4326008)(6486002)(86362001)(2906002)(6512007)(76116006)(5660300002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3948;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tn1rGNNYKENjzEuYCM12Dx/gElWCTXLLA5N7GPmWZsBFKCpP977UkEqJYZOhjYkKeUSZT9MvhKQgdfFYQwcVqi7O0+IRCLtg1+hORzzYI87HQD1r6j6zlJChKo88FsEVDB/jDkkcEKlmiN1VHM4Ft+4GhD/IlAGfn2EWPXH8+rcq5PUb7t5MJE6OaMxRiqjIHC4aLXI1/YT3xvtz3TRurRmrg7O4FJhWL7T4woUMemU0Wi/hPvzIWfrBYgqrmzaJ57QKRDjfBDrL2gu/hVelMq9/zO6xMRTnAAjTFGZmjyktvtQ7wr3o5V0lwVMAzFvBOS388nNR28QDN/iqF8oPjkQctdjpsfuMXskSJuyxKA3PLS6nV1SV7K8a5nD2Nw/b/3XwpgbCeULZZL6DTUGGbQ2Z+enik1CD1wq1UXZ2NYwrahnGli6qgHr8EySOYIEy
x-ms-exchange-antispam-messagedata: lJIIwNISeYI4aCxaOejkLmKU0oXH0jGtfUtk3f9vcUa7d3Q5HgtuJg5W2VsowaExnf5rYPLekV6KlEh7MzqaHxpseFMRR/RO+IzXrtUBs4HruB3UBsTHHcfD0OXsCGm1YLVVqtwmiHMyghYFw6JZCJ1xe0gefGb/8Cow7gTQ+Q8HB1d1EeG4gM6ycPQDnnax
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2AFF007241674C42AFAC2540225E94AD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47080db0-78c0-4a32-262a-08d7caae7076
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 20:04:45.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGMCuU2MCz6pOzLESUzIHSHGlU+K4ZR8C9ppuIZi8m1S0Zb1kth8LrhBBIM69qHQ/z65TNOamYJUsXR0RheyXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3948
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_08:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170075
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 17, 2020, at 12:54 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Mar 17, 2020, at 12:30 PM, Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>>=20
>> On 3/16/20 9:33 PM, Song Liu wrote:
>>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>>  1. Enable kernel.bpf_stats_enabled;
>>>  2. Check program run_time_ns;
>>>  3. Sleep for the monitoring period;
>>>  4. Check program run_time_ns again, calculate the difference;
>>>  5. Disable kernel.bpf_stats_enabled.
>>> The problem with this approach is that only one userspace tool can togg=
le
>>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>>> measurement may be inaccurate.
>>> To fix this problem while keep backward compatibility, introduce a new
>>> bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
>>> run_time_ns stats and returns a valid fd.
>>> With BPF_ENABLE_RUNTIME_STATS, user space tool would have the following
>>> flow:
>>>  1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid;
>>>  2. Check program run_time_ns;
>>>  3. Sleep for the monitoring period;
>>>  4. Check program run_time_ns again, calculate the difference;
>>>  5. Close the fd.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>=20
>> Hmm, I see no relation to /dev/bpf_stats anymore, yet the subject still =
talks
>> about it?
>=20
> My fault. Will fix..
>=20
>>=20
>> Also, should this have bpftool integration now that we have `bpftool pro=
g profile`
>> support? Would be nice to then fetch the related stats via bpf_prog_info=
, so users
>> can consume this in an easy way.
>=20
> We can add "run_time_ns" as a metric to "bpftool prog profile". But the=20
> mechanism is not the same though. Let me think about this.=20

Btw, I plan to add this in separate set. Please let me know if it=20
preferable to have them in the same set.=20

Thanks,
Song

