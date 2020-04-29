Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778751BD161
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD2Asq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:48:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgD2Asp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:48:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0eqWw031417;
        Tue, 28 Apr 2020 17:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=S4nxemoyMddcl/p+J/p0KS42H53+IuyMNWLft5V8ONc=;
 b=VuroaGKRu14okWVU/W+kDyyhfWrPFtW/4FKT/CJnnLf3zC4E2uA5pLw3oxFPbuxLs0OW
 rKvRd0Smp3TK1M8ZP0PMegCutWrIKw8QeNH3Z48Nw2yM3LExqN57/REBUf11bmIKEui8
 7mFcXg1Uo7cYpgXz7HIKbxmvg0Hjx0Z7mQk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qb6n4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 17:48:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 17:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBVcmNUOalZ8rboMO31aCUZ25oUNDEGdu0UoDkd2VAwMzbRmHumt+ctzLvwm5IUwrriKkT/ceUiIPTR7SnYuzFgy7hoCY4vFTX4aDTTWZMa8E/HRkfMZIiMIWYInQ/8WtM6p7v5rPXBsCxdIwfllgCbn3I1O3KJmkWRnt4b/tG2IB4Vp/HJX0ykYbhxG9peN1RsXgmv2cYbpbdDkOkhpJbBrSoF2bCRHBlba57vF5Ixabzt1VO/Fpp4DQ6P2f0WjHJJlzEhurvuYUiQSPcDy13x+JtFqWFp/gDhUpatZ/W70AeLXHTVNkomFPSYGbT/MNRYki+cgFH1xkQhiKhsNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4nxemoyMddcl/p+J/p0KS42H53+IuyMNWLft5V8ONc=;
 b=f7ZPT4NZDpSzg5195U/VeV46TzUPzx4CAsf0XfwSFxuUgRCXSpnL5I+4o6133/YO98G58uOf49GZvzz+UryMSDkOo3cZOr6SgmwtyxkRVOZ8xEdY2Qwa3TO8Hku4csfPnENcq6RS2mlyTQcElM3ZkR5fubfu/7aKf8NdDgczkrZB5dBWNBC5vWNshCPEN1rizdhVB0yonYajD1MWYT136InkbBSzY01AhSOZQHNvCiIbMjKMMptoGQoWn1g6XHEyoNKlZAsS8BnPXsrav1nt+P+Itvdzx7SoceUnbsITagKtPtq7o/7pPdulLtSgH5NQPsiCc/vtCfqZML1S8mge1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4nxemoyMddcl/p+J/p0KS42H53+IuyMNWLft5V8ONc=;
 b=ThRICMB8D7eH/ffFJr7kKwG8dXapCLRPCoTcTy35g6yg9ZjpyN/VyqSsg0dx5xvqKwEfYzkREye/vaBs+1lGF9ArluZIHcKru0N/P+jSn4Wl5U5GaH/JA8vqlgDfvNkp4b2rYyhq9olIgKLGvDeeEoWQ/EZH5hIcueQRMBjCYWc=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3755.namprd15.prod.outlook.com (2603:10b6:303:4c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 00:48:30 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%7]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 00:48:30 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
Date:   Tue, 28 Apr 2020 17:48:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:300:ad::30) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::11a7] (2620:10d:c090:400::5:9061) by MWHPR15CA0044.namprd15.prod.outlook.com (2603:10b6:300:ad::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 00:48:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:9061]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b32c7cc5-dd8d-4dc2-bcab-08d7ebd708cb
X-MS-TrafficTypeDiagnostic: MW3PR15MB3755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3755D30478CCD6DA51183302D7AD0@MW3PR15MB3755.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(136003)(39860400002)(346002)(366004)(53546011)(8936002)(54906003)(36756003)(6636002)(316002)(478600001)(110136005)(52116002)(8676002)(66556008)(66476007)(66946007)(2906002)(31686004)(4744005)(186003)(6486002)(16526019)(5660300002)(31696002)(86362001)(2616005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bW63YQUN1EmfojBhO4Zudlg328S6R6BDxAnCi4nLHwRTG2rIVghJgRLk3ANotpqzGq6/VzvPbsytKDGnG7UBqPVvnXkrpoe+sUvHkSHF4JKdpn/5/2zLF/lK48/bTAdb4I4Z6RDXq0IPbW0z5gcfPm1G18cgkObEv1f6miDBXM67QTx2/GiC2fbllDVON1IjgQmQo0kkLsYRhf7WGGFFIPu5vOrctvpsDbzOmmxeo6UHzReVIFatCfXSDQvPuq/f8A2tY7vuCPtc5gbLodR8oCqjYilvXMxuwVuHpHqStzZ4pU6RO0PftJEFiTteX20CjY/LzkOtSqrtQh7xqWOh5x/IA+GkWG4cu4RGdt0kNZnUZXgeqrFAb9qnUq/zfKW6CjyVKegfqWDZPAQ8Drhi8QKhtnA5Yh93X0lwg3fckLXRaD0sn2w450+++BEo+hfI
X-MS-Exchange-AntiSpam-MessageData: kPEqw4k7yZDEeVR592g6ro3lILM04OlnYNSUtUBcTq101LLGBRrr6Ll6HfeMTVJWX51dEzOBjqepWA5uz5trFIzWhkvd7gyyaYPqg/9B7r0NY3NKPIUb141enzFlkGlVi0DfPw3fhu+OaG8bHML6CTAJcb1ZE2rqCgHmIvRQq3Z+p2ux2FoYZ4fztZJD1BiCBbzlGpDZa+jfVLG3R+p+bp/B8WKuZFtO0R6TvRK863ZZFf8l3VIizDPMCYrzT1BtgRVynhsYRqBTypa51CpGdlmcwEUBudms0TAU2bHlY7KUeBSPrj21l9CPZJgZSMXB+WzeLHL9RD6Xox/K0Z/PJDiomSU/1HtzsR3qakBKKQ0qRsmQ30IFKpoWRSAR6LSlbK0vefnNWsVP2K0LLyeApJNCl6XAGMKv2/NcrgxmAsk4oEHp5w6eT7CDG6hnkfDH2GeR81DVtW+udRgLDqIxHYMrqigsM4pQLdfQYKOO7h4c42KkHTJjasK/wwrdeQSQzWhnBbtCuO6QHWw/hD5GYkdULKF7Ii4Iy0dUe9vkPUHI5hNadQFSukMCmP/CwOLuzAZ38vW42JQ6jKFiycTOtDeRI5ndJOe3qDC4XlaUIqex0tzB2/cdZ1ivGQSpxl+08bA0TIy8XXCytsqOT24pDmuuMqlDRz13S7y/uurFgRWytppyH7ejeIh7Q+k+Mn/jXaT0c7Su0ngwsVccwaiEGQ2LZ8X5BGEFy6aOWn7PmCmtz+gWovVx9ysbCEdFXvqHWvAKoS0jf9tVMrBxxHKet8TNrKnViRNdSH05HSoEqixlhQzhOK2eLf3rN2hUyIhfbtMJ9dJYfEsbO8Ks2KEhgw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b32c7cc5-dd8d-4dc2-bcab-08d7ebd708cb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 00:48:29.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdJG/FPNBGht2cZg56jc8b9q6cu9Vz7GKeM2EvNGmMSMDQgEdSfSgqmorHjhFdV/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3755
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 mlxlogscore=818
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>> +	prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_map_info),
>> +				 &meta.session_id, &meta.seq_num,
>> +				 v == (void *)0);
>  From looking at seq_file.c, when will show() be called with "v == NULL"?
> 

that v == NULL here and the whole verifier change just to allow NULL...
may be use seq_num as an indicator of the last elem instead?
Like seq_num with upper bit set to indicate that it's last?

