Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BE826E1A4
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgIQREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:04:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64600 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728651AbgIQRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:03:20 -0400
Received: from pps.filterd (m0042983.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HFmtLN018192;
        Thu, 17 Sep 2020 08:49:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=arFfvQrib3xAUSVLC/nkF80NYJOldw/pwSu750/7ezg=;
 b=ndy5zZ7xy3YiWj6L9VJyJJ/cJZRJyfpqWGpiv0C87zV5gEZenTLVAR7dAtmIshcotqgv
 ptiOSrW/G7AG9syCU+a0lNt8odkXUxpsSFIvwn9xrNkmtv1WhgGAyXDCYASOQmCXxBF+
 cUg2+t+/UGeWnh51DDy1By1ILOsYwQYt5x8= 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00082601.pphosted.com with ESMTP id 33m9wg8jk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:49:08 -0700
Received: from pps.reinject (m0042983.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HFmRXT016951;
        Thu, 17 Sep 2020 08:48:36 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33k5p86m2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Sep 2020 15:43:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 15:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWQPYL8hIZsWH9OzqIPLiIAqzAqRvZ2Xft3a2E/8mOf+dmd0CB0wTBVrhSP5PERM0DAyfserur4b+D6mS8mJJ7fyY/Ynl6yz1UIu0tFAetOX7PvuFs8eBxIRSz4pdCUhdZmLy2pquMJPjxSpHQ6gtWfRsh6wv8eG7r/q2k9n5bc3ngpJNcdvf5svE34iY9vk5TFNbdioQTyr1yDp33pEX8sAkrFrjzw+oyHOcN53OkRB2aEAlf9QSCTGrPW/fDCJVu/05dfYZS6vHpIw/ctmuQ3Nt2xok+cenodAD5SFgBc0u7hauNh1AIkQhGg8WQX+llzTX82Xmeoe9hQ/tvTgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arFfvQrib3xAUSVLC/nkF80NYJOldw/pwSu750/7ezg=;
 b=RAc94xkdzH+4HV8/Iiz6r19wHNcbDaaJ+z4BQ99zeCBdorcybrvWxy14YL+NYWU1hBleTufO4UREbFuZniUQKt4MZBJ1y31BDOMhr9coYmZb3Ao7up0NFmCQHMg+13bNYYzJXnY4vppLjLzXzpueAWmorKW93mI8RHUI6xQv6Mr5VCEM07kQdC4gRZxuDpZ78ejjTZ04unSp9CPS2Oor05DAuCgoMYDWK/xb3fpx0MvqlXsyuD8xK+BAjxFOE6S6P4caFmAN6mMFFLxghKXMV0WkyNvj1POTq/dO9Hecl2jxm/5H92BDcI7hfrYJBsdvAbOglxbBsl/oKjsVYeu8fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arFfvQrib3xAUSVLC/nkF80NYJOldw/pwSu750/7ezg=;
 b=LvKttXjPdpWHwCWkz+z0F6U04vZeeReQysw1+6WaA+grRTW52gQJXG48XIQ7WLAe0JS8ofRC++UrEL6gEqTZlEZUZ4Kjr8mWShkD5EeSPrkr15xCjSO+pXmrQX9tkgqjd/JJRJzkAIo1q2EBrZqa6ihyj1jwPikFzAgTlCrE0mI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 22:43:12 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 22:43:12 +0000
Subject: Re: [PATCH bpf-next v3] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
References: <20200916061649.1437414-1-yhs@fb.com>
 <20200916175553.4fevmxgcv2r6nhiu@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b4db3cc4-ecdc-1372-183d-5e96dde2ca8b@fb.com>
Date:   Wed, 16 Sep 2020 15:43:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200916175553.4fevmxgcv2r6nhiu@kafai-mbp>
Content-Language: en-US
X-ClientProxiedBy: CO1PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:101:1f::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1042] (2620:10d:c090:400::5:e2e5) by CO1PR15CA0056.namprd15.prod.outlook.com (2603:10b6:101:1f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 22:43:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:e2e5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 174ee839-50c8-4537-e311-08d85a91e472
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2246C407323621DD9FFC76FAD3210@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLgn+bhuhMBMpL5o+AcwV6yns+0h0RoGstY2cyLoAbnOWT01YzQVZdfZFjuA6ENw4uKV4wvp72+GzrjC4RESJQkmlRGSZkIloNHa9s/HX1Uj6VzAs98iqDtcpavOOgVP/WozLeSEgHbyQ8ccbHvVa6YSAP/hLMrWE26CvZ1KsevpxAxNpBAUizek5ZnnrY24NSFiLS+KbMn+BKoOAculL30QHVfZvglH7mmshLQ+TCQQ0p/jRcvkhgru+gb1A5GRRXmLzC29oo5kBzlXW58r7O8RowprNOR5yjcAoZtNQjRxzlketIvQff9rUrqT5Ao4NPkyXR1vtqW+CP/M0DrOPesvE1CKSa1oA6Ult1+TUu42Y1eFCI8ka6RncTsE7k1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6862004)(16526019)(6636002)(53546011)(8936002)(6486002)(31686004)(498600001)(2906002)(83380400001)(186003)(5660300002)(36756003)(52116002)(2616005)(37006003)(86362001)(8676002)(6666004)(4326008)(66476007)(66556008)(31696002)(54906003)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kXlnvaQgjrTzOa65bF3xeUsQAYdboCCWb63VWMQZRYov39b/AzchCVt7bdoI+VF2DGtSNm2qu6SFj7NpQ2izWCHJiPV/WVg1V+dDk0S9iyB+B+wBYcwj6da7OKNLy48WIOjAXquLmz4jYein8pLk9INz30CnHwfwd2oMaWSd0V6C5xHEtiT5ooO7ttyBRsTFO8uJzYXGdaoOIdjhgyfGUxFi9+7KjdREdfmsq59HYmxShpubLzAwp2Avm2zwgIaUfgP7EFJkYXMMhz0T4kMZyjtlWa+riRixi2DkYS+iZX/yOWs4Zbw2TFNlgkxBWMdWjab0ovhQuQesvm3ojWD5z6+G1HaUY+A3vNyl2HEoOvCCPu0qvxEdgXmU2eYtzrVI0Rpe38pfqwqxiLGdeZLXlPimk2gsw6JecqLN8hV+StxZSnT5XWoOBpygubAyG5Ky3sKz3muOzoWDEj4nJoJ5tUBdE8BGbhxjGQo2WMkb+2mVhWLpZqAUrwUNcq2GIP+SFYbfjKoLuFGDhgYxp8xd5c2tmlw6ROP7j2h2G/XQIBi+mCycx8wzYrpj/TxILM1Bau6u62JdxEZaDzyAKIHAC/6wcG48eQfFGYTwk1rRjf5/WPdi/Dy8JR3vcdSK7lHwClv0iT1WYmr/FbFfDD+yYNDPj13C8nApKtrQhkSqMkQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 174ee839-50c8-4537-e311-08d85a91e472
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 22:43:12.7134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bce6e78T4Be9xWEGblgUKZp6lTOpmf/LOr57ALylHiTzPSg8cTV7i02m1/weNrBx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_13:2020-09-16,2020-09-16 signatures=0
X-FB-Internal: deliver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.12.0-2006250000 definitions=main-2009170120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/20 10:55 AM, Martin KaFai Lau wrote:
> On Tue, Sep 15, 2020 at 11:16:49PM -0700, Yonghong Song wrote:
> [ ... ]
> 
>> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
>> index 4a86ea34f29e..d43c3d6d0693 100644
>> --- a/net/core/bpf_sk_storage.c
>> +++ b/net/core/bpf_sk_storage.c
>> @@ -678,6 +678,7 @@ struct bpf_iter_seq_sk_storage_map_info {
>>   static struct bpf_local_storage_elem *
>>   bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>>   				 struct bpf_local_storage_elem *prev_selem)
>> +	__acquires(RCU) __releases(RCU)
>>   {
>>   	struct bpf_local_storage *sk_storage;
>>   	struct bpf_local_storage_elem *selem;
> In the while loop earlier in this function, if I read it correctly,
> it is sort of continuing the earlier hlist_for_each_entry_rcu() for the
> same bucket, so the hlist_entry_safe() needs to be changed also.
> Something like this (uncompiled code):
> 
>          while (selem) {
> -               selem = hlist_entry_safe(selem->map_node.next,
> +               selem = hlist_entry_safe(rcu_dereference(hlist_next_rcu(&selem->map_node)),
>                                           struct bpf_local_storage_elem, map_node);
>                  if (!selem) {
>                          /* not found, unlock and go to the next bucket */

Thanks and Ack. Will send v4 shortly.

> 
>> @@ -701,11 +702,11 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>>   		if (!selem) {
>>   			/* not found, unlock and go to the next bucket */
>>   			b = &smap->buckets[bucket_id++];
>> -			raw_spin_unlock_bh(&b->lock);
>> +			rcu_read_unlock();
>>   			skip_elems = 0;
>>   			break;
>>   		}
>> -		sk_storage = rcu_dereference_raw(selem->local_storage);
>> +		sk_storage = rcu_dereference(selem->local_storage);
>>   		if (sk_storage) {
>>   			info->skip_elems = skip_elems + count;
>>   			return selem;
