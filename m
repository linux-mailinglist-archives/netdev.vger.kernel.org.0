Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56AC1CC6E7
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEJFID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:08:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbgEJFID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 01:08:03 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04A56kMM012259;
        Sat, 9 May 2020 22:07:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CvMK+Xg2DPgPzd3PO5HAXk2xwyxuPVadGw4o5Wo8qnw=;
 b=iPeVPKy/ryNQdi1tUiZWBPsZZ6VCr1AWUJqAAJVDENnkCw6T/ng04QdzhOIbWZbkkjUR
 5j1WfVWL76DYK65Ded2uZmKBjMlRc7VOeMoPMq/x5cVLv0rVqSGGheMENT5tInzJQM8T
 skNxHtv8JNdafrozftH2tD8goNytwVbNofc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wsbq36d1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 22:07:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 22:07:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGNkmIbNiv2MniNuuxsHapQZFhXdZ9X2TM9MFsbcO6AgIdbbAo32VI/DTcZ3rm5YzFKSN40U1xEAZxHBqtzFOWRCB9ah2qCrMkvH77+X/fyUJqFHFoLgm/XeYHSzylMoD69kkU7oRZxZRBd73CnVtYN4Mm/XWUJTLBIasLNAuuU9tVCzT5U40sYrvkNdKDRxA1FFgF+H7HMp3BMfhaafzCPkdMGtmeyj+wPPAurJ5RcaYlY2yJeVorbbefU+JcruykYh+1j7ahl/oHOWI7t4C1whF+Vn0gi65bquD9zsX8v0bA0+1gAmyMCeSa2OQ1VJHAlbOWZrwCKQgKt149naEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvMK+Xg2DPgPzd3PO5HAXk2xwyxuPVadGw4o5Wo8qnw=;
 b=hIvheCp9kB6iUt+zxAvGkB9wRuPeEZhfV2hCogbmtmznV4yPKOelO4ubDKf9C89mechIrVzIVhosYFG+bhbKCuFAUd4s5y3rMZwepMr1Lk+PIhLp9xhAsa4ApleNhC0hq8hwTcMvN7bSKkpJMOjwvC7jq8Mk+0KnHyQ5lhaWbVzgNYqsTJBNtAAXNtl4DSjPDWhiqYu2tt0sygulVMJEd+vQtPznMcBdzmBsoshTo2BmLuZoW8KWF/B6iBNScPQnAibBeXGpTuCutV6ouyjF67ldtzZUR7vEBU3WEgOoWJOdHFkDgA89hqe0Q9TAe+DLSw0jUyyF17CY9ac0kUZJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvMK+Xg2DPgPzd3PO5HAXk2xwyxuPVadGw4o5Wo8qnw=;
 b=k9x3o9pJ6eSeju58P4437g/aUoU8/IG3n4IByZUUodeovMZJCJE7TFAcHN65oCTF+gb+NUWaDTFlV7Lf1hp2bOnGPei73Syg0TFkfoZ+yWaxsw8D+1FWzntgftvqP1lOCns8eJ5NrvSH3hENkjjMMuviXi8sBxMIBt5zYgx6aR0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2296.namprd15.prod.outlook.com (2603:10b6:a02:8b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Sun, 10 May
 2020 05:07:34 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 05:07:34 +0000
Subject: Re: [PATCH bpf-next v4 02/21] bpf: allow loading of a bpf_iter
 program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175900.2474947-1-yhs@fb.com>
 <20200510004139.tjlll6wqq7zevb73@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5fdb2fa0-7284-5276-c91b-0d4064f768f7@fb.com>
Date:   Sat, 9 May 2020 22:07:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510004139.tjlll6wqq7zevb73@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0005.namprd21.prod.outlook.com
 (2603:10b6:a03:114::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BYAPR21CA0005.namprd21.prod.outlook.com (2603:10b6:a03:114::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Sun, 10 May 2020 05:07:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 832f0732-1df8-4927-d370-08d7f4a00cd1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22961E0F2ADBE1C0C73052F7D3A00@BYAPR15MB2296.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 655rHap6n9AHf2J64KDmISlmXpj8L+23EDGMNnUn3by5PKDkpN3cUrPHPkbQKLkzZ/uUXsmza7js5Fq+6bY2KLX1C79XiQUmJI92nVcLWuKmXTADititoDErxoykFNAdXqtvx6ma17SNofcQPlbit2+W/M/9Yo9kiV8YmpRmVNMV/Q0ImEWOB/Jy4CuLrXei2xwHyPL3vfC3MN11Kl/gSXJNnZZ/pBhdBi8I1NGUKEnMO6qrrDr53bEqnk9S3lCt7OFWu4CSGYC9D7cNviDCGVxhE3pwnSKgLTY5zUWZ/YwT/93WABIfiotDkSYHN4pdzXR9WIepr6xluRfXwUEh8PnYq1wfCn9vKenpUPwnJdSZY1NU1FpC7lnPq+p+ipFdH27iYEDjuwie1YTsUuam145y46KbhiVJLcnuILVAxTJKTtoKllosnHEr6AGlrsO/ExEzGokDBd2WmJLT6LLfWPm85kul3K5Z4oLiPnq4q269xem1AFXQlXeBEUCgtKhYYgWRkzAn83uuKxt1tqdkVJkygWh6kU/iLAteXvwoSkco1hNoWj5dXQneIuesDWKA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(33430700001)(5660300002)(2616005)(4744005)(478600001)(31696002)(6486002)(2906002)(33440700001)(6506007)(86362001)(53546011)(52116002)(36756003)(31686004)(66556008)(4326008)(16526019)(66476007)(8676002)(186003)(6916009)(6512007)(8936002)(66946007)(316002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jx0D43Iyqr6DO0XrbcNAIr4wGg1w/wOT/SODIqFY7ZCc9SU33t6szH3nMWwsZd9U52w2+maTAGtpIKfzAxI3ojBVGF5JUJVQqGcnCkj6rEOv2M6WBKebbwvaOyCia1keOw1Ly1v14whLet/DvUDbb8nPN9EwpmhHGe1BGDIzhZ1oMbxUPAxD7OhfqAURWdju7NGhWpse4yNm8zHAvJ7+KmOM4Y6vzrGZb1F1EHyXJxoeEmuzKQ75laqClw7FVPvECw83vqUMkQ2Z1g0hx/gVb/lRCfRE8411EtINng/zRw/NrYF7vEoChNXVd+aBDnb7X5GVXJeIt7OOovfCuByxuJh0l9xQrOAo4nGb4irdIF4zalenU6iDYfV0zotSAnejxD2cTVKpnWVz8RLpZPp9XZ5Lj2RiXnuPKaFuEtmDOLSmby4wL5gWuUDEF7nYr5oLJFUD87WZhG/So6F1zJRjAlSvyI7/9RRFxflXXGII0EDJghRDCuzOGzuzVeWHv/zxEi4N52t7TCGQAxLjZYXmqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 832f0732-1df8-4927-d370-08d7f4a00cd1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 05:07:34.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOJg1Xt+3f0ts2RC1OaAqpkhqN+giNPSKwo0o1u11pD8LsJ/ixyJPvp4ADf2aN4t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2296
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005100046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:41 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:00AM -0700, Yonghong Song wrote:
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 70ad009577f8..d725ff7d11db 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>>   			return 0;
>>   		range = tnum_const(0);
>>   		break;
>> +	case BPF_PROG_TYPE_TRACING:
>> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
>> +			return 0;
>> +		break;
> 
> Not related to this set, but I just noticed that I managed to forget to
> add this check for fentry/fexit/freplace.
> While it's not too late let's enforce return 0 for them ?
> Could you follow up with a patch for bpf tree?

Sure. I can have a followup patch for this.
