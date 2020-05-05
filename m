Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539F61C6172
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgEET6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:58:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48234 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbgEET6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:58:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045JtNuI016023;
        Tue, 5 May 2020 12:57:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/ROq7QMax7QuyYfPxx0C7JawUfmKnFrYN7X6vreV6XU=;
 b=miRfAIbdQjb6g6jDK+42Qlcw4WfJove2/nKbuyTC4/sms+eNhui/iIjlrR/lls3P0nzJ
 HrnBRPrAk/Un2YdOhhT6DlJK2SjflzY2xNrfuZGnQV2DdqIvNWzQzPVydpT9TGO0A6YA
 DXBjcrdWzCV4hmj74gRlMtzagqQluUitQ/c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvq53nr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 12:57:53 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 12:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWBAj+UFNKZfS2dQWRoN+vq2HG1CazspGsgSWhK742TUKhNL+UE8/rm9a/7irnhahfKsaLTOMuly/9NeidUp0N7PLkrmCqVaFN0g+4GG6cUrO1i77fn77QmkasYx/fpB+he6SJ9xIgj6x7wIoKHrQaoP4vGNPaq4yZBWRyY8/UMCcYAyuCMXjSLOZAOigG0SqFnirILYnyzN1mCODcZmOcoaRpnHkPelR5p8UQrhN9oHPLLjGfc2TxHoqyeH5CILL0hLQiH2TKJEfr0NZfivmWCVL9feu9musO7/+xQ9ZcdNeAnUJYu9ZpuXX2kKx2eoT7Q8MDoGy4eSnQU814nVug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ROq7QMax7QuyYfPxx0C7JawUfmKnFrYN7X6vreV6XU=;
 b=Qf4HCs8bcGmeoZ7SyZMs7qQDJAQT9+ChyB+KxYGx1TYkgfdPlyMukQQIerB40FGKiRVEy5Z06Z/bNpjnaWPX0HF2VMxS9Pp27pUAjZtWLCefNoXunVXeMF0ePBYzgm4vBVNqciwF4Sfj62+OqB9hBzU4r9h40dy2IwtQ5gal5bsj3L4D5yibUshYn9jQE9pcQuNWWmuUVDhP7+TP0fUU83tP/SZBCFPyTxQrHW2q8x313dnfBFAFD1C7Az3lGkbPT38i9VmQx4cmtIS4mG+sDtyLXsMZboDN6LuMoHDkv1cmeNcetPYtT1KDNC+tSwrcgHyyNpAty3X3CXfRd0YmIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ROq7QMax7QuyYfPxx0C7JawUfmKnFrYN7X6vreV6XU=;
 b=K3OaRTHaVhtSq/onlFGwFgseU8dzxiNydnPmmKb1jbcvzCZ0c511JQUMxzbEOj1Bt9RzJRrC7lltp59Gmnd3Jxl8Fiz0WBMUxIseiDLF1rujP3xRlrX23TARGT+2hwbdPHucDdjFZwUD4MH7Qgr7rfeyKxSTPzqNJAN6fDq8FtE=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3898.namprd15.prod.outlook.com (2603:10b6:303:43::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 19:57:49 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%8]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 19:57:49 +0000
Subject: Re: [PATCH bpf-next v2 05/20] bpf: implement bpf_seq_read() for bpf
 iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062552.2047789-1-yhs@fb.com>
 <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <8900204f-c2db-10aa-7890-099db3b006b1@fb.com>
Date:   Tue, 5 May 2020 12:57:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::19) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::130e] (2620:10d:c090:400::5:e28e) by BYAPR07CA0006.namprd07.prod.outlook.com (2603:10b6:a02:bc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 19:57:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:e28e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de03ea16-51ed-4fb8-8295-08d7f12e9628
X-MS-TrafficTypeDiagnostic: MW3PR15MB3898:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3898E057F2CEC9CB40E8AEAFD7A70@MW3PR15MB3898.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c6w6j6VAyHxZDDgbUiVPWiuSFDzOc0VmaRi6f542W9hhpi8/dERWCRFKoeYz36ioUbTTRIV2zouDHOmLulfHOBnknW7B7S21n7+0D+4/rH+2FI1IPn8I7GZQRxyftrF2heHKSZZQK57B7B818x+eRzbs6LkA/bUA2wWz7j/dShHNnKoJMx0vbxdJRbXiC7qImjpJFGrHzA25xtYFpLI4Rt6w5zsKShHmkAd1Kd5sz0U2pC+JA7bdcuE0Z7x2OpeTYT8mTO771+dbNR1JfwcpGaTwiq2NoJSt7baEsG4UX6EHH15lpyKiZH8aC3a508TOwfjUzPmG2T9IW41qZCGPqA7rqQwnqQTAoFY6yHfVTFMIy+bZFL4H143Y5XwafYv5sp3qAgX/vNO2mkwEAtQYKAhSYqgTNAxgVMMysBZ15lLIEFL+U5rDAN5j12x29Qks0qNXyQi0aqz4H0ba+B2SioSN5X+d6lLIpsmXDjAz3WdeFlD1d9hiA1Y6BSsy1EgpEo4INxG1UKUFVy2+6kOX/wtEnjAMlkfOUVfip1zJSt3iT7b0MbleaE1X2KAFO2p/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(4326008)(8676002)(36756003)(16526019)(5660300002)(498600001)(2906002)(8936002)(186003)(6486002)(66476007)(66946007)(110136005)(66556008)(558084003)(31686004)(52116002)(2616005)(53546011)(54906003)(31696002)(86362001)(6636002)(33440700001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QApFaKyKdkhifmRODm2/p4XWJsbdn5oFKV9lif0Qk48Ufp+LmMcMz3cM/LlJf+Hv3YIOZ6gNTUbUPNQiXEdmyxKtYEtnKa+seXmK1GPwtNbd2+ubBKNOG6VhBQ+IM3ps5IrFXJTAU68Nu8bJYvFqyBJh41QV4w5jJyqyDmHjvVYZX7mATjaqw6pyfLtCOVRfi2GwVfcu6H653/vONgt8Xg6yCRv7wPmvCeVskUhc1okOOZ76ROML1ZSvABD/4oBQ2LnYFcqLJQNfjWw1CzL0o9PcTPQj6JDMXe7mUo60rFnG5HhuIV+YZc6ZmaHlJx4J9posLwpKlMHc1+h+f/bb9qpblXf0aDjt6vIgJove8Tz46Hvwa6wmyv2i8VC6zIXAlpRgqPukyZhhXQTKNxiZKhYR3Bgr/3UggCZI/0XzUl04xPtPSFWHBmJVl4QpYxMIttQR4KCnRvo2TrunSeyGqWKNX7j3iL4/2gHl1yNo2PS2/Nhkhz7BThEXK6I1Pa6EErcWJw2QPJnnEh+61hn+qMxFzFkKvCUZsekz0K+R9rXKE50ImmnXDyLhsNThHf2NHvNLY6vXQkXaDFvWvfqcjZ4FUnsoiK6Xv2YzpGGSK0mjSv1lyFwMEcjN5v1i5jWEhSr0cy2ZwewtMj2cVDzlxEaU9IHXPiYVl5kzC+FcltxO4y9iH1ETS0Ff9tzcbOSE1Jxj5bnpRAsXHrRLPv71qxeXgKnhpqwnKs9laG8x8pSpzAizQBvTUmUiFk6z7Q9UU0PvPHJllPNgTIDgYL+1NkjAQzTfOfPZ/a9WiQH8GN8bCfFNBZyZWhddy8FeYLQHxnhg8hLvw0HRQZvh07eIRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: de03ea16-51ed-4fb8-8295-08d7f12e9628
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 19:57:48.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vb6dWdHvVjMDkYOay8BTje/KeToYSM8s/ghlOZ3xa1FQnA9XS/ZY/ehntgeYFZqL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3898
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxlogscore=700 bulkscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 12:56 PM, Andrii Nakryiko wrote:
>> +               seq->buf = kmalloc(seq->size, GFP_KERNEL);
>> +               if (!seq->buf)
>> +                       goto Enomem;
> Why not just mutex_unlock and exit with -ENOMEM? Less goto'ing, more
> straightforward.
> 

no. please keep kernel coding style. goto is appropriate here.

