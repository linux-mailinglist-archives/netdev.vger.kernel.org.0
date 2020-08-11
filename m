Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ACF241DDC
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgHKQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 12:09:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2052 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728924AbgHKQI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 12:08:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07BG8f7h002438;
        Tue, 11 Aug 2020 09:08:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jYmt/ecgvcTdzkqrwtrLQB/i6A1V51bjagtOBzhKnAw=;
 b=qJDx7iypGimpbX8ztHxtgtDj52oofzlIsRfa4Zuc0x1RPpL1XDQxI7OdSm5jCmXlOLao
 pPNti3tPb9d0g1+r+gdVSldFPNrOTozBV7na9LQHXcrcB6TlSUCIMN7RbfC6nMtnrYP8
 OC8UjUPNBsmqnRRoyMFF2Awq2lAWbEPxcWk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32ssvfwgbk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 11 Aug 2020 09:08:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 11 Aug 2020 09:08:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euyO9ezE0Qkb8Ywqpz2irPBWxdZgUb//PnhEHZbY2IaZq8l0geimCYAlp7CcQy2ZTwSDVXrAPkis/oYKm4hSQTZe+22uoTT85E9Bw6AMX2QEgamkMZ8X2v0BwlJKpRW+BcIHVEqVD9tukCngjtR9cMSNydN6jAtxvIgZjRPpdoVbf9Db3TvU/iXsuq2nP90rYd4ajUfMuqb4kKPisvEHsj7iPUkG7n9GSjK6hAskDxJL4WpvFV6M03FJ10pMEjILBIclVcJdbUTEG25Q6IfJSOnj+ZHxMiaL5S/L3nnzEazm396feidBOME51FlqVcpfeRbujFPDb8jhm4QUUeconw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYmt/ecgvcTdzkqrwtrLQB/i6A1V51bjagtOBzhKnAw=;
 b=JQNskzF88kpS57/x5xzQQdf54vSJszqLp2xAYVJov5vMhvL3muEMI6qk2hrh2gfnsHJ4xPSIL6v5gRYTLeEyFVJyYerFz6Xhxlk+sL4y/9OrVNIikYsOu/SfHAhvmljr4AxevS6EoMhh6Nmv0b+Xa4cB9I7gWM/GFxcIOTxe9a0aj4c1oUHfp2wSpO/0s+OzvlWdROEJTueOAJs68/loq/9ntuKcXv/IVI7ALnQtnOy7bJELG8UgxSYqcZZcRRQTI4+f5UO+J66KUjhN11ETyFtnfm1oflbd+sBSaE1XDK/Quv0lR9PX4cKDd4BGOOmwWY+ruoUVwaVF4SjrS/PtZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYmt/ecgvcTdzkqrwtrLQB/i6A1V51bjagtOBzhKnAw=;
 b=VDLekOziAMF72JDlpqx3M90WGbaKjNu/UyWve1NKRj0X9z8UaAqMxunmsH7GuhfgzrdK1SC75UXCd3RglzdWU6O30dPlkeu66ci9zFes1A6vvnK+tFfteTVNs6HRWCt3JvBoyeZ7zloanb2NcZVXtQqO8+iWO5hsL9KnYmram6k=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3665.namprd15.prod.outlook.com (2603:10b6:a03:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Tue, 11 Aug
 2020 16:08:14 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3261.025; Tue, 11 Aug 2020
 16:08:14 +0000
Subject: Re: [RFC] bpf: verifier check for dead branch
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200807173045.GC561444@krava>
 <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com> <20200810135451.GA699846@krava>
 <e4abe45b-2c80-9448-677c-e352f0ecb24e@fb.com> <20200811071438.GC699846@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f03e2ce3-8cf8-0590-1777-f9e8171cd3fa@fb.com>
Date:   Tue, 11 Aug 2020 09:08:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200811071438.GC699846@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11b3] (2620:10d:c090:400::5:50a6) by BYAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:a02:a8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Tue, 11 Aug 2020 16:08:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:50a6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77ad24b4-1a5b-442f-f5c1-08d83e10c0ae
X-MS-TrafficTypeDiagnostic: BY5PR15MB3665:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36655BD9E73B22F527BAA4F3D3450@BY5PR15MB3665.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+X4YkBbOq3Ua34skSXugdRzsmVx3qAhgiWFrrYSPy/8uLxH1vbnG35VNYPib1zYlubsLI58/sVjZtR5AOJ5h5bI5BRpTqUlKdivCTO6LfQpbQNE8yVwYO4b8AFXS5BQx8txrSssTENZ8s4/lT6QvmaoYPUBpUH1oxJtcdBDVECd7FXn+tAqztZHeI/dM/B72Mbb72Uaix33cq0XSL5ItW7ZYsrX2d59Ms4vXh59VD2R36wmbnGGUckKYMBCxiZhjVmBQKDgYxX2j6Cha3cdtoRmstsc9wuAjeRI2FwxTa8Add2tcUUemsP5NUCt7yWU5aQXFnQlwnrpg7Wwd9gx1vOgUeAy9qlC4YP2TKx6DwMnxH+wVfIDRxqY3qaWjBfADAc5fXWD8dTtdOmcwC7RPquNlsA4KfwIGK2tUSMv4LyaOvSiUYozKpRLtB9gYmNUm6Fz3a+XeUpIxgF8COUShg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(6916009)(2906002)(8936002)(31686004)(86362001)(2616005)(8676002)(4326008)(478600001)(66476007)(66556008)(66946007)(52116002)(31696002)(36756003)(186003)(16526019)(5660300002)(83380400001)(966005)(53546011)(6486002)(316002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: CqI/aHCO7SM3Z+kbYEB5FOxirFKaHgdVFnY6o1Nd9neX4c/CqY3qt4QxjrodE+s3t/7mLRdl3nsVuwMAQ5JFzhnVGPclBrn2TJR8LsAvsdkPC9102xulKu3Unrl+1be09tQJtBxlnXzBPsoR5rbWNbZlnM5Y6CzhlxP5SVnWhtcjnaT6LiEX2lGtT8Bcy08myzIOS17hzIZ0f8X0OjScC0X5JbqBgoXCr19t1/xzyysTPXRzU2AYP405Y9gs9Sd8fz88cL6xn9zRWGOq1dQkoQ4W1BXfXAguY4V2S0l1OpbNFwo9qJUQ/FQ+zg8x4t0UwLDSAdDtGf2vjoYHIvqGdBMU/tT+TFPHRKOXoJfWr3QhGPKJDC+1hqtn05fuUnrnlPaPE98BR/UAt5zZ+7qQ564o9FLkxWM+WR7c7i7PoINIrD5LlPYCzOaKT4NOl7cHhz/W9lnJ+OCuO7Gp5QlF6Ghx7VkWcBLFYS0kVDECGYHhdoP7QcOpr11QbNwGrlTCq3k8Uks1sSLaUPfrEauPnST1J2Ec6tOxbWTdp66nmZvNp7sbbJuEq03oHoqKgHG3MGCMojZEmfEUaBRsrzy9M7Cfe7CgthKX8pYIMGpqCTS91r1wGp8d24tHZqTUkdisiVvn+WIN9LETCmltQS15jv6wmkcaRrcPh32zlDWQIlRtr3A7ZRajXn65utY4O6jg
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ad24b4-1a5b-442f-f5c1-08d83e10c0ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 16:08:14.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHL1KlNBlNSiiGj0qsRv72vLVhWZDl/4QaLD3/AqseT+PlC1flC4kmR6Mq6LriiS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3665
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_15:2020-08-11,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110112
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/20 12:14 AM, Jiri Olsa wrote:
> On Mon, Aug 10, 2020 at 10:16:12AM -0700, Yonghong Song wrote:
> 
> SNIP
> 
>>
>> Thanks for the test case. I can reproduce the issue. The following
>> is why this happens in llvm.
>> the pseudo IR code looks like
>>     data = skb->data
>>     data_end = skb->data_end
>>     comp = data + 42 > data_end
>>     ip = select "comp" nullptr "data + some offset"
>>           <=== select return one of nullptr or "data + some offset" based on
>> "comp"
>>     if comp   // original skb_shorter condition
>>        ....
>>     ...
>>        = ip
>>
>> In llvm, bpf backend "select" actually inlined "comp" to generate proper
>> control flow. Therefore, comp is computed twice like below
>>     data = skb->data
>>     data_end = skb->data_end
>>     if (data + 42 > data_end) {
>>        ip = nullptr; goto block1;
>>     } else {
>>        ip = data + some_offset;
>>        goto block2;
>>     }
>>     ...
>>     if (data + 42 > data_end) // original skb_shorter condition
>>
>> The issue can be workarounded the source. Just check data + 42 > data_end
>> and if failure return. Then you will be able to assign
>> a value to "ip" conditionally.

sorry for typo. The above should be "conditionally" -> "unconditionally".

> 
> is the change below what you mean? it produces the same code for me:
> 
> 	diff --git a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	index 2f11027d7e67..9c401bd00ab7 100644
> 	--- a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	+++ b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	@@ -41,12 +41,10 @@ static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
> 		struct ethhdr *eth;
> 	
> 		if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
> 	-		goto out;
> 	+		return NULL;
> 	
> 		eth = (void *)(long)skb->data;
> 		ip = (void *)(eth + 1);
> 	-
> 	-out:
> 		return ip;
> 	 }
> 	
> 
> I also tried this one:
> 
> 	diff --git a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	index 2f11027d7e67..00ff06fe6fdd 100644
> 	--- a/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	+++ b/tools/testing/selftests/bpf/progs/verifier-cond-repro.c
> 	@@ -57,7 +57,7 @@ int my_prog(struct __sk_buff *skb)
> 		__u8 proto = 0;
> 	
> 		if (!(ip = get_iphdr(skb)))
> 	-               goto out;
> 	+               return -1;
> 	
> 		proto = ip->protocol;
> 
> it did just slight change in generated code - added 'w0 = -1'
> before the second condition

The following is what I mean:

diff --git a/t.c b/t.c
index c6baf28..7bf90dc 100644
--- a/t.c
+++ b/t.c
@@ -37,17 +37,10 @@

  static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
  {
-       struct iphdr *ip = NULL;
         struct ethhdr *eth;

-       if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
-               goto out;
-
         eth = (void *)(long)skb->data;
-       ip = (void *)(eth + 1);
-
-out:
-       return ip;
+       return (void *)(eth + 1);
  }

  int my_prog(struct __sk_buff *skb)
@@ -56,9 +49,10 @@ int my_prog(struct __sk_buff *skb)
         struct udphdr *udp;
         __u8 proto = 0;

-       if (!(ip = get_iphdr(skb)))
+       if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
                 goto out;

+       ip = get_iphdr(skb);
         proto = ip->protocol;

         if (proto != IPPROTO_UDP)

> 
>>
>> Will try to fix this issue in llvm12 as well.
>> Thanks!
> 
> great, could you please CC me on the changes?

This will be a llvm change. Do you have llvm phabricator login name
https://reviews.llvm.org/
so I can add you as a subscriber?

> 
> thanks a lot!
> jirka
> 
