Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B509B1CC6DF
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgEJFBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:01:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47108 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbgEJFBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 01:01:52 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04A4vGwV012564;
        Sat, 9 May 2020 22:01:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3ij9jyvLRQrxiYAQ7+FN1eQ0DgepcSPyYpBX3bUOarw=;
 b=OkHpwY2hJUIkrLqtsQ2WnjrgJAfJmKWgS+NKnLwKfSYchYNxJnL/FrvYHVZt25IHIHfw
 6nU4xGPlC2qYvBFj3Qh/meRTM28aqI/lqh7bVqwUwbyg4GjcCuv3rUqZcoGsrMcI2g+0
 Zb095jESX6HWpCQST2D0NGgI2LXHXXc7MYo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30ws2138sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 22:01:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 22:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L64wJCb/lq+9F7T0OLDHBXo8jd8y4XcE2vMf468CVDZ9UuP3aTIJi4ffkStiKthzf0zfJbMz0MverV0IIa5/QaelWKHrrb2ymWDhqvHdskwKKQ4kr9Pt5TP66F34oHcJ2brmdE5o9NuVQXndVQoNqLZxtzFgfG0aWYwCebhtx/IFUoKitLcO7Jt6Vrc/YqXUyL2MwMCmu7MLyE8jUdCWq/TVxpX1W7IYJ92dyB+B6BOm9F4BGFsSVir7Uc3h2lQJBxV4vaFl1M9vwu0Al5ewF6BWu8MjIGp14GyysT1hxr/4Pw3+KQJTp3Zfe4AfGBBOXPNDrjRyUcHSE0UeKGCquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ij9jyvLRQrxiYAQ7+FN1eQ0DgepcSPyYpBX3bUOarw=;
 b=ZHswcKFd1YA/ReVr0/hBM2QSPYNXtBsxuv7MwyU3VJ3Bx0Wia8putvaK/z5/81XP/pQn35MZCB0FOJu95ZGYcMVE91l1nG3uWmG0icQzfXsRBG7+/88X1+i4w1VWduzJaF9ghnjnsSwpyZ0o4Y/oMknwdaBlGjMl24j8d1XfWmuMBFTB/R/lgOtM7tDIU9rCjF6Cv/3UoFrNZCzdS9S0tbvIUd436zydNqpVI6pxjLwukKTw4d5+klqfYNQTuJvZLcO/Y7FbzmQtoXSLOFLMVEXRbf3Fig5OhkS80DvrPvSlaQ6f5QYaaB+FzjMEKsCCcLNofWwSh7i2GpLOVTvk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ij9jyvLRQrxiYAQ7+FN1eQ0DgepcSPyYpBX3bUOarw=;
 b=XqVRmlEJlx+0gXAIM5ChRp3T2zEwQ534sjpe2E0BNtf9PckQmnylvfYc/s2LDwjbnNVD2dceLyNHH5yLbwxm4PiR2lRSlo4K2SWpsZ+Bsoq+H+abbg1H91ETqTL/+5SIoLZdPb6Wqbvtuen7YvLatXHp+n+Me/o/g+mm5olHlLo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2869.namprd15.prod.outlook.com (2603:10b6:a03:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sun, 10 May
 2020 05:01:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 05:01:36 +0000
Subject: Re: [PATCH bpf-next v4 21/21] tools/bpf: selftests: add bpf_iter
 selftests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175923.2477637-1-yhs@fb.com>
 <20200510003402.3a4ozoynwm4mryi5@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3b2b2e40-4e80-2a5d-e479-fc12a95162f2@fb.com>
Date:   Sat, 9 May 2020 22:01:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510003402.3a4ozoynwm4mryi5@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BYAPR05CA0014.namprd05.prod.outlook.com (2603:10b6:a03:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Sun, 10 May 2020 05:01:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c29a9dc0-d276-46ef-8b8a-08d7f49f37a3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2869CDF2A2076A46E21E4436D3A00@BYAPR15MB2869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PdcsHFn2Z1VFc5m5Cv5mIKd8IRXZxUH9uA83eGdhKuQCR7QxHme5vIQQo8Ilnhs6+325CU9pLgddjoniWV7BwZtBXtyaar1nqAvyrJc5vtTTfaKn8SI74tvwMLHFWrUYbNVcpFvAg1VYoHU86dJRGqNybUZW+k8LoPrkqQz5Yn6LjcoZN6Xj2WdJVvvjT0n3AmkLxk4pcg+v5UrvMKYTi+DKfExsINs4ZnOxM3Cxvlms2+vcQejlbvq+fzu7ScozGbQ6UXroGhgS0vJstGhwAsnS86Yx2K4pvRXC5737mbEwTEL3CyDq8ouB1x82i9ziKO8ycZfByo5ZBGgIU2N6Rmz4DvNMocoatxbRh/a2hR0zWHoxMckrVkJd2CcZpPDWXDLykNUXrbfLFQJOpFVA1cfaWBWZkOC/UnnD/aLtIMCYIEA0feFRyjVOw6O9cPeisMKbSylRE+m07o1C2m4/rUjUS5Khxg8JKe1zScf51F6UJdVXIOq7x3D3Wk1qXblO0uuvvQ4qErPyWMbgc74jcrK95rX5n5ZlBOHw2M61zajEFaKFBSAl1VlAVti6i6Mf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(33430700001)(86362001)(66946007)(6506007)(2906002)(316002)(52116002)(53546011)(2616005)(4326008)(6512007)(33440700001)(6486002)(6916009)(186003)(5660300002)(16526019)(66556008)(36756003)(8936002)(66476007)(54906003)(31696002)(31686004)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jYXtKRemXHZK0Pz7/2iModEJRxsRspxrz8/qvK9wsM1sguNETLvzM6QPyJbmfuzfV9a4agwpN+WZ9NOM89W+HpYt4qRdKXEPFXWj25OhcmHfJt/fWDmG91h1DvzuSxO/ZnUQgaEA3BrmtgIbcZCiNUMtb7rijYKjk/+nFnUGiw+jMYvzpX5I8WGcZITq67HIK8Uc73DXw7gggUx9WagrRFGPuOFlcqmdO9nFbIedHpCFPSsfnjeKoVsCo8PPC/pQ+hMHx3WQaQWFbLBS5Z8FhgGalSyP3h/kd8uKxhB6pj8zj9Nrn0r/ZaIN+WmdKhXlfzXbygCvNrpSt80PASxbr1Bg7FYZivw0ehr3KwQb4NsZaWP5gDYEnJtK42nzZgCylTwdob5ThVn0BQbfPNGQ1C1+a7KAsyXUeiC4v/gA/JbUfD9TNR1gPE9oE6UpvK3tzMTyMUAVROIKlCfliSUyTOOH9u6idLDQRqnuHHvK88juSdVu6+7O2xJh4/1qJsa10/7tokxAgEP8xvswt+42GA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c29a9dc0-d276-46ef-8b8a-08d7f49f37a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 05:01:36.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYh00S5AnRXQUcLXZ3RPtJ3q4y9mo17xPFYq+k5QLPEaJ1PfzmboxK9Ze4LXgnAk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2869
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005100045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:34 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:23AM -0700, Yonghong Song wrote:
>> +static volatile const __u32 ret1;
>> +
>> +SEC("iter/bpf_map")
>> +int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
>> +{
>> +	struct seq_file *seq = ctx->meta->seq;
>> +	struct bpf_map *map = ctx->map;
>> +	__u64 seq_num;
>> +	int i, ret = 0;
>> +
>> +	if (map == (void *)0)
>> +		return 0;
>> +
>> +	/* only dump map1_id and map2_id */
>> +	if (map->id != map1_id && map->id != map2_id)
>> +		return 0;
>> +
>> +	seq_num = ctx->meta->seq_num;
>> +	if (map->id == map1_id) {
>> +		map1_seqnum = seq_num;
>> +		map1_accessed++;
>> +	}
>> +
>> +	if (map->id == map2_id) {
>> +		if (map2_accessed == 0) {
>> +			map2_seqnum1 = seq_num;
>> +			if (ret1)
>> +				ret = 1;
>> +		} else {
>> +			map2_seqnum2 = seq_num;
>> +		}
>> +		map2_accessed++;
>> +	}
>> +
>> +	/* fill seq_file buffer */
>> +	for (i = 0; i < print_len; i++)
>> +		bpf_seq_write(seq, &seq_num, sizeof(seq_num));
>> +
>> +	return ret;
>> +}
> 
> I couldn't find where 'return 1' behavior is documented clearly.

It is in the commit comments:

commit 15d83c4d7cef5c067a8b075ce59e97df4f60706e
Author: Yonghong Song <yhs@fb.com>
Date:   Sat May 9 10:59:00 2020 -0700

     bpf: Allow loading of a bpf_iter program
...
     The program return value must be 0 or 1 for now.
       0 : successful, except potential seq_file buffer overflow
           which is handled by seq_file reader.
       1 : request to restart the same object

Internally, bpf program returning 1 will translate
show() return -EAGAIN and this error code will
return to user space.

I will add some comments in the code to
document this behavior.

> I think it's a workaround for overflow.

This can be used for overflow but overflow already been taken
care of by bpf_seq_read(). This is mostly used for other use
cases:
    - currently under RT-linux, bpf_seq_printf() may return
      -EBUSY. In this case, bpf program itself can request
      retrying the same object.
    - for other conditions where bpf program itself wants
      to retry the same object. For example, hash table full,
      the bpf progam can return 1, in which case, user space
      read() will receive -EAGAIN and may check and make room
      for hash table and then read() again.

> When bpf prog detects overflow it can request replay of the element?

It can. But it can return 0 too since bpf_seq_read() handles
this transparently.

> What if it keeps returning 1 ? read() will never finish?

The read() will finish and return -EAGAIN to user space.
It is up to user space to decide whether to call read()
again or not.
