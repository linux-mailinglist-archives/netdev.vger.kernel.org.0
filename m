Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C21A4C30
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDJWnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:43:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17514 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgDJWnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:43:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03AMYPLf029250;
        Fri, 10 Apr 2020 15:43:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5OmHnOPA8UQl97sYaOBJmZP7HHh3zsg/5+Mqqf2Rxyk=;
 b=FiRRu7IytjykATbMLyKL2a+FjdTkLzipV85m2rXR1DoRVch1VdMFgiMt8OrJbv+sp6m5
 jkfiK1MQqq3aorRau2RzTztCoeAV0/cm5gsFXC+XpeodDxldBoh1C5SzqZAH5Q2od0OQ
 0bZDw40CpykMqmEYojGwj13N5Qly2PcZtFU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n4a4wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 15:43:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 15:43:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSY7M1nM8rp+JI7fXT0PnrLPcvJqActHfLD27AomGcxGHMI0Z9qWSi9ovpMfbhegyhnEHvSZ/dBK2ylXap+JfzSlRjDDxXb5A46fbdUlt1Iavx3TNQLMVGooaH24IbjQO0PDC4iHar4zXyvg/lWpu8NcvoDrMR4oMRrd5u06dMSYk6Fb7oYoGmPZ3SqB9mDCxVgqDn6GX8c2ex1cQw2AFYA9AwH2I5z9xj2PE6T8EPr/wdCOOQCH9pRVS9tV4bWvfc9Q/sB01dxDh3Pxs5Qv6AyxSyobW5AxCpcuoqZ+4/78Cndh0QIt/e8ra06aGQyNirnJaPA2CGxzHIV3/gUMZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OmHnOPA8UQl97sYaOBJmZP7HHh3zsg/5+Mqqf2Rxyk=;
 b=BrEoZeJzv1E2JF2aqTBreBTXcJYyWO8LQMKWZ1bHlKDJGZNwbxSlMS1kgu63KScVGAZtuAuGA/nKw+M5SvFFyvmKGoeNqCSaPEqUiDYB3yJ7g34F+wM9p+WzxcX+3vqUjj3A84MHo8l2xAeI7rYfxQRRX4wqX1+PeldQtN1sQslQbHeaJ7voH0qkXHVC63cLfb8SfqeYElgoIDAZEE8cDeY6frwvx3iOEhNgCFSZm5v2JGc8rZSFyz3457fTdkVRKag1spmeDdncpDE99JeqY/0OaCWojCCv3rvTsCxXgol61Z5DtX2HTsWdsSDSnQOURb1manUHIGQ/5B714paopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OmHnOPA8UQl97sYaOBJmZP7HHh3zsg/5+Mqqf2Rxyk=;
 b=kz2HXaQ01qAFSFqHKT9NkylsiApKVqCawK3oJe6f2YFjpTgAkqrBD8cPDe2Le/hWxLb1l8pYeBpOhdNm8AZL+ZLVsdlEDla5lIb0VmzduNNmw6T1u/2UrY3CgJ9S++R1obMzAOTfn7wBBw4UKZWcRrikjKs8IcehHdjbQOjHZSw=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3977.namprd15.prod.outlook.com (2603:10b6:303:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 22:43:01 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 22:43:01 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
Date:   Fri, 10 Apr 2020 15:42:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0044.namprd22.prod.outlook.com
 (2603:10b6:300:69::30) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR22CA0044.namprd22.prod.outlook.com (2603:10b6:300:69::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 22:43:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e01b2d4c-bf99-458b-0e43-08d7dda0860f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3977:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3977D16719A4E39372BC1B7AD3DE0@MW3PR15MB3977.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(366004)(39860400002)(346002)(136003)(376002)(2906002)(6916009)(31696002)(36756003)(66556008)(31686004)(66476007)(66946007)(6666004)(5660300002)(86362001)(478600001)(6486002)(8936002)(6512007)(2616005)(52116002)(4326008)(316002)(54906003)(6506007)(53546011)(186003)(16526019)(81156014)(8676002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aOKoFIS+W/hlKnW6E1nUI/ffCBwge1V0q7ExtTl1NAD0QBgo8IIOO2o1yCpJlmAFAFbAyZUQUDzl0kpUvJTX9D4xmIyKKBQLe+Xm40Qr09pu/+GEEl2a3Kr6UFitwfsOTFgewx2GN1oLhlaOKesUZpWWDU3WVHCiJNRA+0Wqio7ahYkwp35FbNT1p4i+AXmDyMMrCASlCOqUvY7OHIh2t6+ctzfrI+Tf0jpEqabL5OXsrmlz2zIcVtKCxAIyXIObtFm2gc5dQd555BjWi7dfGTNxmHShyxDU6UFgRGH2815GqJnksW9l7T9amgO3YiTj45nRnPgrqhbRA+fd5U3tAfd2cpWVmeCG/gRl9j3HbgUJ2Q66DrGpHJE21ynnhFYNv0tPDLbl1vnwz0q6HkYPOovmoIrwF5PDsom6dWMhM7T9MtmC+SawnQVfW/Sw8NyP
X-MS-Exchange-AntiSpam-MessageData: gxt5AKghxVUAYM+zBJ+ZWNLAuXY65Tm6huxQZY5Yp5WBCxMidUAc7x53mlklZG9y7Ly3ivk1XmFuIAuyspXRcGPUWj1yuu4PF77quyd2QsrRCfqzPtc29HUHhYklvcsqyBgJVuh9u3gjKysxc/b96djnfdIe5wHwYooAwgqLrrr7wJpt5dIYi+d57xjRqyB1
X-MS-Exchange-CrossTenant-Network-Message-Id: e01b2d4c-bf99-458b-0e43-08d7dda0860f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 22:43:01.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiMyqLYgpldwkxsc6UvBolBPKgf2DVDp2mPUtBMVYAjycf+oXKcjvK4oNO98hRaH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 8:00 PM, Alexei Starovoitov wrote:
> On Wed, Apr 08, 2020 at 04:25:26PM -0700, Yonghong Song wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 0f1cbed446c1..b51d56fc77f9 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -354,6 +354,7 @@ enum {
>>   /* Flags for accessing BPF object from syscall side. */
>>   	BPF_F_RDONLY		= (1U << 3),
>>   	BPF_F_WRONLY		= (1U << 4),
>> +	BPF_F_DUMP		= (1U << 5),
> ...
>>   static int bpf_obj_pin(const union bpf_attr *attr)
>>   {
>> -	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags != 0)
>> +	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags & ~BPF_F_DUMP)
>>   		return -EINVAL;
>>   
>> +	if (attr->file_flags == BPF_F_DUMP)
>> +		return bpf_dump_create(attr->bpf_fd,
>> +				       u64_to_user_ptr(attr->dumper_name));
>> +
>>   	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
>>   }
> 
> I think kernel can be a bit smarter here. There is no need for user space
> to pass BPF_F_DUMP flag to kernel just to differentiate the pinning.
> Can prog attach type be used instead?

Think again. I think a flag is still useful.
Suppose that we have the following scenario:
   - the current directory /sys/fs/bpf/
   - user says pin a tracing/dump (target task) prog to "p1"

It is not really clear whether user wants to pin to
    /sys/fs/bpf/p1
or user wants to pin to
    /sys/kernel/bpfdump/task/p1

unless we say that a tracing/dump program cannot pin
to /sys/fs/bpf which seems unnecessary restriction.

What do you think?
