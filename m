Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2D31CC32A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEIRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:24:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15706 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgEIRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:24:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HOZq0011683;
        Sat, 9 May 2020 10:24:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+7merY2PAgMauUnQazQtOv5Sgh9vtGDT1OW9GDkUaxs=;
 b=lQw/w+jBUKSNnAEfGloF7A/gMPQ9o851AJQQCY2FdpjGuCDs2GyNOhBNPHPRdTJulBZD
 TP0YCg+fqxQCIIzlpmYL7I7TFitEpbEuUYwa3ReZYgX9sNyJBGRzXcpHqkjQT+B8lNnf
 uiyscyPCbA84v8bYEw6PoRct0MYzIP1LxAk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt8ssa8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 10:24:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:23:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfhuaxpltiTeJ49x4qgX6YDoceeEPa/n+p5XmV4sPtDYWunqncfzkOxGS6uH47dePrm0oxf02KjgExPpxePwPt9nMSa4plcWK9PdupS8DRAaAaTwVSiGD2ujBVrfIag/Nox77A8HuJ0xPVxm86XbcLgezBsuukGnJcPBq4uQG6n3cFm68t+jxXBkdRg6mZwJBrBOKKQwkOVmVnb3XKQ1om4nCWYTS/hevelyhUbiJL4cnMtAnQp2a32n3TI9hum8PFFaUKPqOjrDLMC5qGa2/VIldMXHLUIZUcitAU0TFYa5hbBx8lV6Xc8XY+VzcTIa0ZqtZhD2euTi1+ukIn52pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7merY2PAgMauUnQazQtOv5Sgh9vtGDT1OW9GDkUaxs=;
 b=D9Lq/4L+E5RWqsSDK82bQDisAgQuUXVLwfGaF6P+pGYAQoB9L1FUdYYbTxGhT8alYw2GQisywk4mK7f22Wpx+xdLWMqHDwkB7Hms9FEteqB2cvKDukYMkHp7w53Oq87+Ow+eWCwnSVslxWV+wbN1gXRKuoAOHUKouKe5KXUc5ItCO366JhRH2FZpsmE847Ed+D8VVngsm5a7O57Y8WybVzHlLiKBiDwCmjtM2uQyN3qUt4OfkL1j1xVL4cdh67jOmLOMHt/Q4hms2IWS1W+igQN5aVh4cQgdmLb5dCMF8/gEeS71SBlNLHoXCIxHi1sIsF2ekCWAPMw4oMFWRw1G8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7merY2PAgMauUnQazQtOv5Sgh9vtGDT1OW9GDkUaxs=;
 b=Thgul+1IIdPenmfNQMztV9nSN/tQYrn2qYIecXebhn60lLGWLywEUEgH3XrSKgslvvf+TJWbbiH7cOQ7u68hpRJv2Xcfi0oEDz2SYL4olG8iz4vp9cs21oOa1UbSV56RYcp7XeVH9Mvvv5v+Vh31yZEU/VLRippxa3X1W/zx1z0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (52.135.225.146) by
 BYAPR15MB2503.namprd15.prod.outlook.com (52.135.196.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.33; Sat, 9 May 2020 17:23:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 17:23:55 +0000
Subject: Re: [PATCH v2 bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-3-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com>
Date:   Sat, 9 May 2020 10:23:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200508232032.1974027-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sprihad-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e112) by BY5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:a03:1a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30 via Frontend Transport; Sat, 9 May 2020 17:23:55 +0000
X-Originating-IP: [2620:10d:c090:400::5:e112]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 604f79d9-1342-434e-881e-08d7f43dc07b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB250306F0B3DBDD09C853355FD3A30@BYAPR15MB2503.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VASLfE8IIVtCEH+SRQPR+Dj/NXg1j9JSOd9Sd2no+R/ZsL6yMRb3H31C1nX2DOLuj83ycNKGJ4NaMZ46etv17u3gTgxNTdwuZiOD0/zp7wFiNaeOhkYdCfLoP4MMn/5TG4CxdlK0oYSiXVLJ3alZY+747O/LSlBJDTAmx5sCHcB2zGGkBKnvCtKkC9D2gNZnkZ5si+VILleSXe59uxj1sxbkpHAv5UNp/JkDjp3kpLbs8En7LElRvjYfWFZPS7lna0ulg3XCahdQC68dzDG+V0Vt/L2IeBDfnYL6pfviPwwgdipRiNRF6825SinjHuinknT3esGpfipzLHW+NvILpL7joBpr6nh3GHC94ChwpNDVtAxHbCmF3aHbpRTiy1kxnPcys0q/STrzCoaJONTTbpU+zpR08hDY8FfroDIsYy2lJMjXxPm86mbpr/wKliWOzaTL5JVy+fRc4iiQzHR4LqBrg3Fq81mHsI01wsUD0J8uzn8rNI2j4sjFpWbxQQHqy+7z0dBKnW1un0r/ipBRffbZlhQApA5zcQMvrX9jY6scVbg3uAORRNufmodTIoq4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(33430700001)(316002)(6512007)(6506007)(8936002)(8676002)(16526019)(86362001)(53546011)(186003)(36756003)(6486002)(31696002)(66556008)(478600001)(5660300002)(2616005)(33440700001)(31686004)(52116002)(66476007)(4326008)(2906002)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Oim41uis6z0Lqq28SExLYaLoT8tYxxK5TeORPKuV5HruOaHvx2fhIbkM/cb8oqKNT5ub2AmrNc1f0WBsUqtoT8Bw9XGgGkP1CUcNDt57pMp1IwZb3X8nBlWQjESKE8QvcHWSXKRLlE2XKmGx8T0fCEo3DbscM+xKi6C3cfVQXaAe3DacbiVHRHxy/pn0/CMvnsYOc+hTPOq39AysUE4SIf6SmptQQtZZ/6fIRUH+mpwe9gCr+6walGzz9oM1u4FX41Tx7EH8LRk4llS7KgskjpKxg8lwdr8bsLjCQ72Ot3Vmu8E3g2x5YWLy9gPIjXBCr/7zdKpQUEsYX8WanndP+/A18z9wSK3FIwObgqI4jqpGr3DCM43i+vBuqgccM8VJISElQr1e1Si/JCoOV21WszYldApV+kEYulTwVWyiNZ8O+sCnduR3joJjnSPIPrNqq2m384uSgKA2HNrDHKlKlZ/vKX/NuT4VrJGjaI+iMBV0HbFimy+q2bH4+SrCjb+IBvm2/072kaMJr0u0uIUfiQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 604f79d9-1342-434e-881e-08d7f43dc07b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 17:23:55.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj56rnrRX7CiPIjEhR9agFnwraNo6Hn1bP+o2w3LBx0mLWKETW2jLVZi5lId+WBX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2503
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
> Add fmod_ret BPF program to existing test_overhead selftest. Also re-implement
> user-space benchmarking part into benchmark runner to compare results.  Results
> with ./bench are consistently somewhat lower than test_overhead's, but relative
> performance of various types of BPF programs stay consisten (e.g., kretprobe is
> noticeably slower).
> 
> run_bench_rename.sh script (in benchs/ directory) was used to produce the
> following numbers:
> 
>    base      :    3.975 ± 0.065M/s
>    kprobe    :    3.268 ± 0.095M/s
>    kretprobe :    2.496 ± 0.040M/s
>    rawtp     :    3.899 ± 0.078M/s
>    fentry    :    3.836 ± 0.049M/s
>    fexit     :    3.660 ± 0.082M/s
>    fmodret   :    3.776 ± 0.033M/s
> 
> While running test_overhead gives:
> 
>    task_rename base        4457K events per sec
>    task_rename kprobe      3849K events per sec
>    task_rename kretprobe   2729K events per sec
>    task_rename raw_tp      4506K events per sec
>    task_rename fentry      4381K events per sec
>    task_rename fexit       4349K events per sec
>    task_rename fmod_ret    4130K events per sec

Do you where the overhead is and how we could provide options in
bench to reduce the overhead so we can achieve similar numbers?
For benchmarking, sometimes you really want to see "true"
potential of a particular implementation.

> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   tools/testing/selftests/bpf/Makefile          |   4 +-
>   tools/testing/selftests/bpf/bench.c           |  14 ++
>   .../selftests/bpf/benchs/bench_rename.c       | 195 ++++++++++++++++++
>   .../selftests/bpf/benchs/run_bench_rename.sh  |   9 +
>   .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
>   .../selftests/bpf/progs/test_overhead.c       |   6 +
>   6 files changed, 240 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/benchs/bench_rename.c
>   create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_rename.sh
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 289fffbf975e..29a02abf81a3 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -409,10 +409,12 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
>   $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
>   	$(call msg,CC,,$@)
>   	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
> +$(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
>   $(OUTPUT)/bench.o: bench.h
>   $(OUTPUT)/bench: LDLIBS += -lm
>   $(OUTPUT)/bench: $(OUTPUT)/bench.o \
> -		 $(OUTPUT)/bench_count.o
> +		 $(OUTPUT)/bench_count.o \
> +		 $(OUTPUT)/bench_rename.o
>   	$(call msg,BINARY,,$@)
>   	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
>   
[...]
