Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F0C1BD192
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgD2BQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:16:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgD2BQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:16:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T16sq1004310;
        Tue, 28 Apr 2020 18:16:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=FTgpQNeTlw8y/iTlXWER0zPId/Xl9l/iDsQ8Kbzp6d8=;
 b=E3TwNDjHvCvk22YkIRGsWHXJ04BG5xUXXMQaEizXocN3vODdqSRbiDah03WBajRYPH1+
 VZUq1oOTQTJxt6Iq1n4jpymfFUd/iHLCXsKa+zM+nJewBcrowVXVEiELHlMUAF+l3vgp
 UGG7ms/fiicC69zAmNMY3Dc0+n++TmFPoBc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qbaxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 18:16:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0Px98FpbhGYw4CN1Ym11CVuBXUZenAiZMoXkN8N+uyqZMwYzJ31RY90aLx+CTgYgPsOBZZUt5hXUAJMDFaNNM4GqTONwl/EkGqpFRd/wN+j3tIKEkK3qXoVqbhTefP//IZIVYN5Q/pq8pImWostU1xB/XohNETS8zVnYcIhA7RlvI5Gm200RmQN9eDwhtWaHROANijpTzmR9NWaV1yuKtEytB1mf4raBu3wmh36F3DUXjb3ED5Vi43omrYiTiSBSUhwpwCwnxeDcutZsz5DyWxmIqGhtpHVmEW9Oyo1pYJCRBO9D7r8qOhmMhOrEZURtizmIQX5L6SmIzyq/V5/Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTgpQNeTlw8y/iTlXWER0zPId/Xl9l/iDsQ8Kbzp6d8=;
 b=DgVkdu/YlOBJLaMbHvqB/cMBErC/HwYGABBETCbzrYcgRrJLrdK7IhQcokhqATl+ljoZP3Ds6pyI7rcZ8rWStxNF8XT3mZHQ+4MLmjYiUyEJp6uhgDR8C31KEHxcOB2AqdQ/39/kJZucYI8uG2YcGSgHhFUWwqgSp9Fxx+5tzDHpY/0OWZ0PWChtNuefPdEUr+dICatOciF8MkoaNM0FUkPRJ/QISR+69sCFm+rTpIJwW1OiLssxH8LenzkRWSdlzyX+qxaFOkZvlTYSocHWMF+08QELir2EkUtmrABM56rk5PxaKVTzJ9hZ4pxDIdqBnbzmxnFskIdxwVh84kF71g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTgpQNeTlw8y/iTlXWER0zPId/Xl9l/iDsQ8Kbzp6d8=;
 b=fWX4aQBUCpbpMXvslBuStZRMIwtG/CtFPt0qG/pt8Eu6wrEfGMN0VDcA/jzYav3AfWj20hvZGukWNQlHpBMaX62TnZQkl0mpeWDgIeE6WF5XB7iW5a+X+mDvwL2m1tXh6CHDQH75yAor6SYK+kUrtGzA8MmV2WJICx6SR+DdyN0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:15:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 01:15:17 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
Date:   Tue, 28 Apr 2020 18:15:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:104:3::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2258) by CO2PR06CA0071.namprd06.prod.outlook.com (2603:10b6:104:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 01:15:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:2258]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 622ebfe3-c32f-4503-1b5f-08d7ebdac758
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26468DC1DF8897B2F86A9A5ED3AD0@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(376002)(346002)(39850400004)(2616005)(6636002)(36756003)(2906002)(5660300002)(86362001)(316002)(6512007)(54906003)(110136005)(52116002)(6506007)(53546011)(4326008)(16526019)(66556008)(31696002)(66476007)(186003)(478600001)(66946007)(6486002)(8936002)(8676002)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGVmqDj4IQEun4UxPQFqDfBlKYV9W7Co9LlT0bEo9ZMc1vjDugPmeQwZrxNc2LLXJLyJA4uDEvSZpcz7MQgGCouqMgolPjQg/yV1jMiTc2wjoKGMayRdXf4TSXEZvmfw9dEhTfya3UNeZ0QPg2F9MTVGBPm8d3moErSywo7gyIhgU8ZUm0E+4Gk7zjAAHSPvplPN+i5cKXzxUEUIk5oul3lSEzIHZLc9wRzO65XXQp8YI0nM47d7KfyIDTMfNh6r2m2PB29AroPcKv/U9rK8k8Ee/rn+YGj6+4Qi7GUKWv6srg5oMZKcsi68sO0q0Z0V3GauNwqLb50Ah5vMsP2MthHly/pUjYmsYk/g56wKLDS8c6E1h7zxoKUJ1u84yWvNCUVx5uHC6IFH2dfx3uhg/nR666PGT7nH69OehcyZwfRMPNqZg3rezHXpXpUT9Pag
X-MS-Exchange-AntiSpam-MessageData: KTplFED4TZnFrgY3YWHMFguKHt4vQqD4tS3clRlWlbxsdRs35aWH3ePfosc4zYDKHwLzoqOcK4f2tASjPYf9NtJyDDEJdSZ7zDrc3erfOL8ms2ABZFjafL1FVvJBvZ+tMI6fUvG95Nf4dEaoICsfOBW3ewlmfWYgEFPRY3wJFTN9UTuloiJQNd8d7/HM60L76/T/Oa7P64tZ1977S+q6Ilv+KGEtE0S3YtNgAR8dX7apDv+5KbTmFzCIqq5ZwCGxe7KI2y22qED1B2dKaHPXYIA8Z6d0A9hsqwYXGquTppUPFnFCmRSJYJEIo5t6ORGgvUtYRuZL4gqBxnHQA9rTEM3lrIbHSWhsuTBafmIlF6E6FibfpvXpmrOEpSncfO/e/J4YyckO3g3UL5GqH1vMQXDNt/x7qySG3ZwtcNl1pvyRAgSlVE0uezYwU052VRpLQeocmWysT+R9SzTh4iCDETy/pQeOlAlSWC8Xaz8Mcg4ydP0KJrYBeUUTN0SEuebaFOAubZ7ciUCoIQ2PsCQDRP88eg82Fav+ryKwX62b2TqJkJlZQSaw662nit01IpXeb4ZkBhQL3ZdlEJRNXT3xE2utWaIgMPLzpFj5axl2NG80izN+PEk11s4PjVZG6s9/mGt7uhbRm+7r22hHXsg9F/2CQvd5CUM+UFPe1s+W35uJdhphcrRbPMYhgleJ3rXN3E5y8pjPYiuWSHYZcYzLUGOLe3gS4fO67zKb0E2RNg208XepXhpiNlrdvnYJDRbozZQr+sy1XPr8RFnvnKJNRLIIrgY0jWC4zdDbx/Kn2GjIDO0J2EnaeOf4VlBSQd8MSRWuKhPe0+a+xXwAS6GTAg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 622ebfe3-c32f-4503-1b5f-08d7ebdac758
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 01:15:17.8101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVCn8N03hFe77JlycPd6FOKeCnLjYsMQZ9jtEd1gl4lqihMv4uFtJzfQUe715gtk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=835
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_map_info),
>>> +                 &meta.session_id, &meta.seq_num,
>>> +                 v == (void *)0);
>>  From looking at seq_file.c, when will show() be called with "v == NULL"?
>>
> 
> that v == NULL here and the whole verifier change just to allow NULL...
> may be use seq_num as an indicator of the last elem instead?
> Like seq_num with upper bit set to indicate that it's last?

We could. But then verifier won't have an easy way to verify that.
For example, the above is expected:

      int prog(struct bpf_map *map, u64 seq_num) {
         if (seq_num >> 63)
           return 0;
         ... map->id ...
         ... map->user_cnt ...
      }

But if user writes

      int prog(struct bpf_map *map, u64 seq_num) {
          ... map->id ...
          ... map->user_cnt ...
      }

verifier won't be easy to conclude inproper map pointer tracing
here and in the above map->id, map->user_cnt will cause
exceptions and they will silently get value 0.

I do have another potential use case for this ptr_to_btf_id_or_null,
e.g., for tcp6, instead of pointer casting, I could have bpf_prog
like
     int prog(..., struct tcp6_sock *tcp_sk,
              struct timewait_sock *tw_sk, struct request_sock *req_sk) {
         if (tcp_sk) { /* dump tcp_sk ... */ }
         if (tw_sk) { /* dump tw_sk ... */ }
         if (req_sk) { /* dump req_sk ... */ }
     }
The kernel infrastructure will ensure at any time only one
of tcp_sk/tw_sk/req_sk is valid and the other two is NULL.




