Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0125E2F0BA8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbhAKEDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:03:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18164 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbhAKEDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:03:44 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B40Grj012582;
        Sun, 10 Jan 2021 20:02:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wStcYtuUvgRGvWjGEoiX7Bz2CjdYwfJJX4OJbr/kl74=;
 b=JVrRthAW/R2H/k4o7hzj/dcSc37KB/Mt6/+pUd9+Q7CQkQvJICDGBMXr5InVQuWs2gxE
 0aMswXyttnJyr1035BSPLYDz9cWkiJ+sGnlQxkSUVf6Le102USdbJJo/n1VYv1WcSuH8
 9sW3nEswv+ouf1lMEa8Hb3d8bs1/mQFsn/s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yavswfgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:02:47 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:02:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ij1UrKbZ0I990lDwVNHUuoYYCVJNgSMbVimaGGFRHbSoBuWWQ7iGB0fs+9ibOyZPh0K/0IfGBcWj2D8B6R2NXMXzVsWar/DjBIfGRRsE7LX8e5gFmyvThrKPCxh70z0sro97mvgw7oOvz8mZ5HbLDy4nqOSPFnZSq9EgfJedKIowLHzaEwlC6zcJckab6QIA8rGPS5NkSQtCIcW0juW0LtwFIfKX4NNgS19Rt4vBYWf8iSECM72jwZZNFWzSipzYlJN5XxS1JOY5uf+SDRbs6vSyZgOuhhJB+7wSp5GAoCJHNS+WHtsUUhcKZE6mappfGH1qVlwBhwXslC/nZ3/ieA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wStcYtuUvgRGvWjGEoiX7Bz2CjdYwfJJX4OJbr/kl74=;
 b=Oe+hy9/k+D9vPHgFIAc7g9Y2o/O9QECJJJ5dovfjDWpLwHk/7IR6syoLqIV0fhcV5abQmGIAGvjo9VeJsz2g3pQ4nAf7sUL8tVTtJQTxejB4bfUiHKl4YupKFErolWMurORcOMj6LY6l9KvM7f72HHvmT24viIKpRnqVlupfUQ2gydvpZ3ckXE2ht0IWWSTmJIk7KzppOtzroHz3f3x1/FvdqTMWyi5vbZjzFkYQ1vbRcluEqLZUu89Xcnf6B0N9Rm2cm8VkmUUEL6JV522PytdJv7j365k5wnIpKBqHNMBtQrBPNh91ihAvScf/o+Cr3qaQoI6NE1yTSTwXdwR6HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wStcYtuUvgRGvWjGEoiX7Bz2CjdYwfJJX4OJbr/kl74=;
 b=MGhdyuY5I8Lg+UhXAODTkMdT9uTx4oMuYn237OneHCNOkv+QNBCX1VhAtRIFjcJPBiFkvD/zdOFfJMU61cJyX7z9wyDfRCm10OM88zQR1oHrA+nDdzGYM1oBTnLvhkl29sIVlXUwF1SXoPKkS2dKvTdI7SWCYQqBqYXKPo1atxI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 11 Jan
 2021 04:02:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:02:45 +0000
Subject: Re: [PATCH v2 bpf-next 1/7] bpf: add bpf_patch_call_args prototype to
 include/linux/bpf.h
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-2-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <47ef4626-6467-fd4f-f015-facc470cc51c@fb.com>
Date:   Sun, 10 Jan 2021 20:02:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-2-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: MWHPR2201CA0048.namprd22.prod.outlook.com
 (2603:10b6:301:16::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by MWHPR2201CA0048.namprd22.prod.outlook.com (2603:10b6:301:16::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:02:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 109387bc-5ec4-47d7-b946-08d8b5e5c0c1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27737B009B1D3AFEFA48337AD3AB0@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1s9kAECHlL4Duk4r1nCoe/0y2ereOIRdbk8KqimV/QN4BMu//HFp+Kg6PBCdPG0bKL6JpZ46U0pKCu/unGZvC754l8Xh4R3NcitXYZmemHkSERRN3c50OOqTQInQjq7XuscJUPQv431IHkpHUxXCLfCVaFXmKQ3dvbZV5KUcV98QNEdMvElObaW3FtG0LdwoO091nw3136HJH96WOiLFeUMAgiExNzDpCKt8awMJIa4Cpo8VnkwtItDprEabaxPaGU5odaWL3w00i7MrDuzzC/7oy/OaJgCvj7JWXfcbMPjubuEsuIH4AT74z9dlF0HQb7LSZF4P2PTdunBCbf2gR5ELTP2DtSQDgFyH4blS//keaekPxRohnhVCZ91zk5UW9Qy0Yp/VtU8i/mg8YJhceEtrt2DdzITismeEily0aBO+eHqRTIZU9KR1oipxTt8r1vpDbxYI9GzO9yTxeVmhh1oCNDl+FCaG1GSA9HLCkng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(478600001)(6486002)(2906002)(8676002)(5660300002)(16526019)(53546011)(83380400001)(31696002)(2616005)(8936002)(4744005)(66946007)(66556008)(54906003)(66476007)(186003)(52116002)(4326008)(31686004)(316002)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUhTaTRnSm45dnNmelk3WjRFM040OGE4dDRRNlc1WXRiZ3BGem9SbDhDNUhm?=
 =?utf-8?B?SGlJS25YVzZCczlvbXdkUmFzQ0JRL3FiRGFpYWpFWUxhTytKMURwQXJhVWFt?=
 =?utf-8?B?VUxFMUNHYWhPOUJsSGN4clZNVi84YlJPa0RycTI3NW5WSW80VDBJRUVwekVY?=
 =?utf-8?B?eTlUTTRIVEJOb1pDTXY3U2wvemNjZ2JtSktOM2sxMXZKWW9xcktMQTNyL1k4?=
 =?utf-8?B?OWFDUU9QYm40dlY1aFFhdDF2VkZDc3lINTRxWnM0UnUvcndrL0VKYzhMSUhn?=
 =?utf-8?B?bnNDZk8xaEUvZjNNY3ZtMktCNDJTeXlvMUlmenZTQkc5cEc4Ujhjcm5UOCty?=
 =?utf-8?B?VFk0dTV3Nmg4RFZYS1cvVzIzVUFxTmdJYnpEYTZEM05JR0lEdmtFRXZacDE0?=
 =?utf-8?B?MmJiRnNHanR3dEZCaCtpZ1RNWHR4N0Rmcm81V2FxUFQ0S2VkU2NFNG1pNjZW?=
 =?utf-8?B?eFVPbml0eUVqckZEeVRobTJyQ2tvUU9vNERQbmlSRXlIT3hybkxaWk5ZRVpE?=
 =?utf-8?B?V3ZHRUxjK3VKb2c0THBkVlo2dk92VFRsU2hvRDFwTTFZOTJibU1RelJBb1ZG?=
 =?utf-8?B?WXllZThLZDVFaitSeTE4NHFEdm9rYklGQzYybk9BZ3Qvc0lUMzg1YlJnWVdi?=
 =?utf-8?B?NzkvNDhaeWpYWkYvWHZDM2ZXL1lMM2F1Vmt3VlBrM3VkOE9JRnUva0hmSHlY?=
 =?utf-8?B?RTcxMHFvbEVWWkE1bTZTMXpaMlFiUjFtWmlibFplN1NWMkVTSzNlUnlIRWpT?=
 =?utf-8?B?ZHVzemFxa0hGaGZmSVlaMnl6aFVFeGFtYk1UbHk5NlJ1aFc1RXQ0K0dNU2ZF?=
 =?utf-8?B?andrd2FaUUl6UHhsaThWdDdKY3VnWU1EL2tzRElhQVU3UmpGcTJKaC8rZXBl?=
 =?utf-8?B?Mll0MThlRnRRSTh6NjVGNFRVTjMzdE14amZnUkZCWXVrc1VWazkyOW5vbWhU?=
 =?utf-8?B?ZjlPUXdZYjV0NFRtdkx5c3VpVDdXRnRNbHBZM0w2L05pR2J2SWJ4TTd1S3pU?=
 =?utf-8?B?eDVlQkpVNTlmRHRTSGh2Z01jQXc2T2RMeUY4NmY3akhPbG1BaUk5RjdJOWh1?=
 =?utf-8?B?bnZCU1RjSXNPMnhCTGQ1R2Vjd0RKMEhMOWhuQTZqN3g5V0VPeG9ORjluZmcx?=
 =?utf-8?B?N0cxMHVodHBhVDNLcHJGaFdhN3o4RkxLMW03Um42V3ZiS0tkRUw1cW5GWkJ3?=
 =?utf-8?B?LzdYOHdEY00zK292M1J4TWpkczYwOXBGVUdJb1RHS0VSK0V1c1pjTlMrNHBv?=
 =?utf-8?B?MHNBQ0tBRHdKUUEwSkYwQzR5NVN3VXNYVFJ6eHBPbTk1NlpRL0Nkb1lzM0Jp?=
 =?utf-8?B?VWtZQ2JwWW9ia1VMWkNVR1pBNXdIMUQwRDRkYm5uS3E2NWwzQ3E4Sm1LRmow?=
 =?utf-8?B?Nk1YNGZrTGxkZkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:02:45.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 109387bc-5ec4-47d7-b946-08d8b5e5c0c1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iB3gS5sqHXJChcwSRglBBBeG+Tb4k8TtElxopRwckzrOhKc033kwk3IVT0NcCm5/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=797 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> Add bpf_patch_call_args() prototype. This function is called from BPF verifier
> and only if CONFIG_BPF_JIT_ALWAYS_ON is not defined. This fixes compiler
> warning about missing prototype in some kernel configurations.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
