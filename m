Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EB4188EC1
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgCQUOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:14:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726388AbgCQUOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:14:05 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02HKADA9013908;
        Tue, 17 Mar 2020 13:13:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=32r/m1qpw2i5U/TJtC7YwrEuMptHJiFb+6bne3ldzho=;
 b=XlGof1ZnLs4EmWLSghK9XFi86qfMAF7/A362ClXRerH+j7p/CfvHWoUvYH6lJR4BmJ9e
 GHeQg3ZjYHPdZTqh8AVtam4BPyxcgPQWhlQAKOKehFYC9yitN3V0DLBEbFXxXrBsMOJ+
 pj70sMd1Vk/0EzqSpqJ0hxzwGhfkWYOBDyM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yrtryf28v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 13:13:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 13:13:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Su3Ej1afM1DwbZcVF5cKkSTjfaRZeLGUszRwBPX7hiOe2BSY9TT2+jg0+h7ctZ22IstoMNDlul5sB9fFWsm0QzmttzI/mfFouk8lJngcNeB/yIpGrVRJ6XmBrk+hN+JaYAsKZc9XHqG40Dad23qBnFW1TlqeK6SPseldjo7mNNQMWh0sjGE1/+l+ghDf0C0/qJOwLkoNebMrLr/YnSN8ZVkTs+v7dbCUk1YxK6JD23S0bWQtMCxXZ0up8Dk2Vx8wxmKvCqh/9qvsn8KnGVWehxBAJwQpgyJMqcyeahUj/x3PKf6dPadeD4Zv5ocd+KKlLxTNokKL5Ip2Y7MT7Igb2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32r/m1qpw2i5U/TJtC7YwrEuMptHJiFb+6bne3ldzho=;
 b=VcfXAAH9wgnYh9hh+t1qYOTepgV91s/w6Ct7+2dhoGJDXYlMWJ5pgCx31sncBsCzkUYuDFcZE2LtEHCDzpqng2Q9Zj0bETKSjwiMHwk+Ts98Mp0IGauCyO2gvkeBkoBfS/5h7HEtljjHo8scQZQEHVCnsV6E55ArLHzqEyNG9yuZaOu52m/MPOQlSn9ZpfjnpH0zyYuvErWS3ydxzs1VfRAJrACZci5jpDGkgZ+GIs3+qdwdWvPj5DdVhm6BCIF/syzUCHpebgPtD6yTmfpVb3lywYcu7nph8dykQPZxtGBBKdP8G5bwbQBw+IhS42n0nYWzfOnYStjJyJ8S16pMzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32r/m1qpw2i5U/TJtC7YwrEuMptHJiFb+6bne3ldzho=;
 b=hYdoZyZKMxsxq3nmuuemy8c27N5G9eivYzELz/zce5CilWCsMvBrSpB4n6SidP2umA0asOeOo1I9cS0fxVrRcXid8O5K/L2863U6KiDdqfQfA4379Ig5bFxz7vV6vphrYhGYUfJJK7crBbHnL+Ga5L4VlBfrNrd+k+7mJNAfSVo=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB4011.namprd15.prod.outlook.com (2603:10b6:303:49::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Tue, 17 Mar
 2020 20:13:45 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 20:13:45 +0000
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
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAAJXAIAAAvkA
Date:   Tue, 17 Mar 2020 20:13:45 +0000
Message-ID: <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
In-Reply-To: <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 187b4dd4-2c75-4d9f-aa68-08d7caafb263
x-ms-traffictypediagnostic: MW3PR15MB4011:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB401103124AB780CACBDB3426B3F60@MW3PR15MB4011.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(366004)(376002)(136003)(199004)(6486002)(186003)(2616005)(5660300002)(54906003)(316002)(76116006)(86362001)(66476007)(64756008)(66946007)(66556008)(66446008)(71200400001)(4326008)(36756003)(478600001)(33656002)(8936002)(8676002)(81156014)(81166006)(6512007)(6916009)(6506007)(53546011)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4011;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RK7akb88GY/sULKuhnwIQPLA/Je/4qGA7FgYM21cLeLy4cz6hJWycWZPZK5z3+7vFEeb1B/W+6Bf6NEYqmCoKzXRLo3chCIaT4d59OMAy9OCRhcz38JQSfNVfvH6x2GwK7vbD7tFIvBEfSvTDx65jRCxXrXq8jv0XVPa3AX/UddCFoMFH2QW9uSwSXk2xsyWS+uX6liEksPta/vQtFqgDPLO4aMRHNOSZRpr6AB5Jm70aKAlnZFqdj3vLaZufHevxEfZpVzaMED39amBruEWfh54lMYP24U5tKgOg5CHCkEeD45HylO237T9RCDAup6Gcl7vCpImUZ0M6wQzfbHtQ8oBtJNuhOWj6hrWQFysRBML7DefXyXG5twFKV/4bXUgMRIooW2slKc84IuY+1RO12S+UJWlbge8BuBXb1D75y8A710nnzGwoVIJhyUMM3QS
x-ms-exchange-antispam-messagedata: EWLQE1Xiilkp89WFrg1jQxp5aOSEWkdH6KnEsRHxoggREiOOM/KtnxGZ6Mljlf3LyBe7aZmUNaSPkf95nTPr8MJ+EwlxxIqm7BFzSSiqC7qESxRQeTbiuCT4/b/FG1a+E+WOjMV5xKcpQ19V/jGDbg0wofJ/3lneP2WhwV8SPsi1TIHC5FoL3F/rwjbz3nDg
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC3BB408A56AF840958766B94B7FAA3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 187b4dd4-2c75-4d9f-aa68-08d7caafb263
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 20:13:45.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Pgrif3o9fWBzCZa0R9kfPbhI7lzAZ1ihxgct+xHZoNCO3oQh9etj5DJEIfjc9WCK37ByyuPyPf50BFLM8eQEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4011
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_08:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170076
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 17, 2020, at 1:03 PM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 3/17/20 8:54 PM, Song Liu wrote:
>>> On Mar 17, 2020, at 12:30 PM, Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
>>> On 3/16/20 9:33 PM, Song Liu wrote:
>>>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>>>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>>>   1. Enable kernel.bpf_stats_enabled;
>>>>   2. Check program run_time_ns;
>>>>   3. Sleep for the monitoring period;
>>>>   4. Check program run_time_ns again, calculate the difference;
>>>>   5. Disable kernel.bpf_stats_enabled.
>>>> The problem with this approach is that only one userspace tool can tog=
gle
>>>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>>>> measurement may be inaccurate.
>>>> To fix this problem while keep backward compatibility, introduce a new
>>>> bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
>>>> run_time_ns stats and returns a valid fd.
>>>> With BPF_ENABLE_RUNTIME_STATS, user space tool would have the followin=
g
>>>> flow:
>>>>   1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid=
;
>>>>   2. Check program run_time_ns;
>>>>   3. Sleep for the monitoring period;
>>>>   4. Check program run_time_ns again, calculate the difference;
>>>>   5. Close the fd.
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>=20
>>> Hmm, I see no relation to /dev/bpf_stats anymore, yet the subject still=
 talks
>>> about it?
>> My fault. Will fix..
>>> Also, should this have bpftool integration now that we have `bpftool pr=
og profile`
>>> support? Would be nice to then fetch the related stats via bpf_prog_inf=
o, so users
>>> can consume this in an easy way.
>> We can add "run_time_ns" as a metric to "bpftool prog profile". But the
>> mechanism is not the same though. Let me think about this.
>=20
> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" fen=
try/fexit
> programs supersede this old bpf_stats infrastructure? Iow, can't we imple=
ment the
> same (or even more elaborate stats aggregation) in BPF via fentry/fexit a=
nd then
> potentially deprecate bpf_stats counters?

I think run_time_ns has its own value as a simple monitoring framework. We =
can
use it in tools like top (and variations). It will be easier for these tool=
s to=20
adopt run_time_ns than using fentry/fexit.=20

On the other hand, in long term, we may include a few fentry/fexit based pr=
ograms
in the kernel binary (or the rpm), so that these tools can use them easily.=
 At
that time, we can fully deprecate run_time_ns. Maybe this is not too far aw=
ay?

Thanks,
Song=
