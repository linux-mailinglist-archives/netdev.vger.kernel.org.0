Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2453D17606A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCBQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:52:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10176 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgCBQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:52:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022GTY3q012752;
        Mon, 2 Mar 2020 08:52:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CXCt/jPX+1ymN88PUeLqMc/qhbOl0DLjgWdxgLepCNA=;
 b=ZqdPowNKpwjp7ezPyff8nM92ZyE+OAiOqMDMUHboy3Yi4iWHQKRk9Hfed9dBMxerYKzS
 k5SNLq0hLH97fmLNXCPU/OzaJ3ycRnCuhU7S7qQDvZQ8Ge+f21zMFl8fmYdqr+iUDEEr
 8s2Qa015Hm/TDbKcugtlrTaKmNRJPJj9j8o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpnqrjnw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:52:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:52:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gg7zW8pRWzrjE6wMWoo4b7JpLFNdkPBVhKZ1PcYT/YzjAr6ZDgDb01NKov+W+Mhb5B7aEx3M6aLZEjtvXH6WfgBoWggwkNZbvw9yj17E46o89xjCu37fFEzCbprE5PaxV4jBsfXxT/L8czhInFDauJDlx64cae3klRzeSl8qxsm0D/q7Esbm7yJJnt6QPdniZKnpE4Z2pFLPtIXWAkWlQAGGypcqoarDYBLT8nzLMdtRhvXvUM/49bxmsPFApMIDYTrZfaPQ5XbbTTCguGGnFwfryB/K7uYJHE/oNBi5UvcTMy69nJlEQnAcGUC5YjM2V1UT8zfBnJAXkt32t8bZPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXCt/jPX+1ymN88PUeLqMc/qhbOl0DLjgWdxgLepCNA=;
 b=bdmRUmg4Z9miY1Q2g0YBaMoVkhT5Az8Pu7r0YmMz7mdliFGWuwvpbW4SFuioeg/GQb14GmDW4jt8JjE9jGg0PwS9ZMSRNxtWE7dk+brro3vYd+TIG4T+4RjtkTBUx3CBt7glLg34qbvZllxVwgefAtMD2dfNkJ43rn7xXaqX6UiTFotGPcBSJL6pWR3Nle6754vSqVZMWxGZ2urNzBBCIy76gZDjz7jNPobfyp1uRM2v4jvLI4e69l1w6JlkyuJXPPqAkRztEwUO2+ct3jQuFORoFjeBbWfhhJcOrJusIEUjpUmtzOSP6qccDt8LHOmf7573wpfPM0FS4XGRa0V+bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXCt/jPX+1ymN88PUeLqMc/qhbOl0DLjgWdxgLepCNA=;
 b=kfG7TKUzvXFEPQQ67Fif6Pw6USbs2XMDnIQ517Vlt/pnF6RNlywSNupVP5EakexlDt1HzzhhRAYP10K9C/jPIQ3Byxl9Eq111pMQagAFW2A7+MxCu1W3Hb/jGw+BTnmFelHZnrym0O1jq8FcSSWlk3/lnYn49LquI1dWQ5wd2QU=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3994.namprd15.prod.outlook.com (2603:10b6:303:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 16:52:15 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:52:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>, Yonghong Song <yhs@fb.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV7pCRwZ1HBc6vtU2QEGEJ7IlYy6g1UgcAgAA2soA=
Date:   Mon, 2 Mar 2020 16:52:15 +0000
Message-ID: <D919D5EE-2447-4B2F-B343-9F24B69FAB26@fb.com>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <c70b067d-4284-aeae-98ea-09e167c3757c@isovalent.com>
In-Reply-To: <c70b067d-4284-aeae-98ea-09e167c3757c@isovalent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:500::7:be36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2bf8ef87-9046-4146-8834-08d7beca1004
x-ms-traffictypediagnostic: MW3PR15MB3994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB39943A79D7F2159E2D9CB0A8B3E70@MW3PR15MB3994.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(39860400002)(366004)(189003)(199004)(54906003)(110136005)(33656002)(316002)(6636002)(6506007)(53546011)(6512007)(6486002)(86362001)(8936002)(71200400001)(36756003)(81166006)(81156014)(8676002)(5660300002)(4326008)(2616005)(2906002)(186003)(76116006)(478600001)(66556008)(66946007)(66476007)(64756008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3994;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WL1tbEDMtXil13SQzRLxotM3NrCW2ZV4TMDQw60w0M8ii8zAFCJP54CKuixxfP3nOTn2SEE0OFz1D/gUFTjee70QtXFVcEMFM1ikpQ0J36G8izJxTVd5xgvDa385PjapIACLQDwtuxzJe/NCLWyi2NM3gLya90dTUDR//dpZ39B6OhIaUnWKqLn+ehs7VqDQqNzCZQlbLAjz2DMOkHihVprRpfdXDI4MYGKtyrCsRNBx/peT4G9A5DtSt7pJ+TsRyYEh/6qhkxZlIm7EFPsmMGBLt3WV00vmKdFDGgNTszDwRChk0hJKy+aS1oou3WodiCmpFKtzhuKbhzV8plU/lS/VqBWPdVVregF3WP6rheTLCRtn6V7lruYKwm1PdABXe8Qrr3c1iblbn1Syl25DMHvvyONbGZiy/LiHg9RFZ4yP92xjY8cGYg9UXFeHO0ce
x-ms-exchange-antispam-messagedata: v4mtC8N9W5QSkQzGmzDgSia6/KbQajZU6SWQunIqo0+XMTEwGfdtQ8KTPcdRi+DOwNlGnQA3ZpCNkkcGJBbmBY2bBRfmbv9oWsdTKjIYjnr+MtU9ZcmoqqBIoTz0/TM1H79tm9pJKitz3KjFleOIV8ilQa2N+R1wGbSZdgrr83JN5RXSHA9OFzDXsBEdfWVv
Content-Type: text/plain; charset="us-ascii"
Content-ID: <729F722F9FF1DC4BB2531172F8E60A81@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf8ef87-9046-4146-8834-08d7beca1004
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 16:52:15.5935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +E0QUS2HbMvxlsAtcrfbqHQM1iA9u33UlZgWgNuf2PZeik8TbxjjYRs+yA+B2fS9zdBnUD9D6sPQ2HB829ZvAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3994
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 2, 2020, at 5:36 AM, Quentin Monnet <quentin@isovalent.com> wrote:
>=20
> Hi Song,
>=20
> Thanks for this work! Some remarks (mostly nitpicks) inline.
>=20
> 2020-02-28 15:40 UTC-0800 ~ Song Liu <songliubraving@fb.com>
>> With fentry/fexit programs, it is possible to profile BPF program with
>> hardware counters. Introduce bpftool "prog profile", which measures key
>> metrics of a BPF program.
>>=20
>> bpftool prog profile command creates per-cpu perf events. Then it attach=
es
>> fentry/fexit programs to the target BPF program. The fentry program save=
s
>> perf event value to a map. The fexit program reads the perf event again,
>> and calculates the difference, which is the instructions/cycles used by
>> the target program.
>>=20
>> Example input and output:
>>=20
>>  ./bpftool prog profile 3 id 337 cycles instructions llc_misses
>>=20
>>        4228 run_cnt
>>     3403698 cycles                                              (84.08%)
>>     3525294 instructions   #  1.04 insn per cycle               (84.05%)
>>          13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
>>=20
>> This command measures cycles and instructions for BPF program with id
>> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
>> output is similar to perf-stat. In this example, the counters were only
>> counting ~84% of the time because of time multiplexing of perf counters.
>>=20
>> Note that, this approach measures cycles and instructions in very small
>> increments. So the fentry/fexit programs introduce noticeable errors to
>> the measurement results.
>>=20
>> The fentry/fexit programs are generated with BPF skeletons. Therefore, w=
e
>> build bpftool twice. The first time _bpftool is built without skeletons.
>> Then, _bpftool is used to generate the skeletons. The second time, bpfto=
ol
>> is built with skeletons.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---

Thanks Yonghong and Quentin! I will fix these and send v3.=20

Song
