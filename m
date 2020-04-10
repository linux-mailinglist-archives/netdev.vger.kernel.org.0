Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E162B1A4262
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDJGK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:10:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48368 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgDJGK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:10:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A6AGCW013828;
        Thu, 9 Apr 2020 23:10:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uWv9qGsz6cOOl4RndBP8dXMsX3leqjSUyMS4CvwleuE=;
 b=lauD4cZ4Orm7/NFMjvniPLddzScoNjZbmrHpBc33MhHdBYxaZf5pupIM3Ll3loPr3cQF
 TQaovZq5CLjejNWHGWOXNodGWegU5tSWARHAWgWYWlOy/4uHOfXdHJdrDVqM/OBzGU6u
 jXRQCPIZhBe0ipH7xZJEayT0cj96yCRq+98= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n45x8n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 23:10:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 23:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV9ZwlLO4XzIT6gwdX/f7ViCSXSxXAr72ujN7vjHt5EeW31oBhsSjURCPVujwjMhI6yUSOO6e9pW6UnXvXYKBvW7r47L66MD5fN1RLDgHLpAzIsLI/YycK2QILXguSkMpTzeF3hedIUWGme1A0qDNZTGuFWeRmW7aYhz/DKjDSU3SreUtGVaYIF/mQ+uobM4xYAT1j6m6FSdYGwTihs5oPGbtrDxxGNgc5WFXka+B9vnOUItqiX3E2K5nH0hb1Xr8WVWZU2qvaVMY6JNDX57eq99PjUGMTHhD2+jM0U5y3mHfdbcv7L7g4sEYhZcv671y92mWfLPY3O3LUBhplq4qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWv9qGsz6cOOl4RndBP8dXMsX3leqjSUyMS4CvwleuE=;
 b=bt/07mzroOJA5SWmmQTI7rQ0Y1ZYy3uu8Pt4b9VEHq85ROL5ot/N+QxhgHNpOd0sp/9YvfWwFXCCh6r+W76qTEA5nYIA6E7WBYJbkfQa7Yus9BwlX+ITOYMURXSGII2vdcm8PzmdgtCCaz/QTkFQrpYAh3TqcEASSspqTXkni8UfYMR4vGbdrqd99AtJn1rpzO4FwMULQN4CUeBd8dsljLUAjrpIt5QyA/7s3gnlFHA6dW6iLzjMwf9Zn+LheTDDgTDRdiH606mgNgx5mt2EMjZLx2JNWu5OnWvQhv1Wcryp92F5HFfOsUQePoHlFuv5+a8auLWy9QYEvIHJL//yOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWv9qGsz6cOOl4RndBP8dXMsX3leqjSUyMS4CvwleuE=;
 b=YkPuaShUY85IeLDO2ftxgjRkkaMyk5jJmIuzMbQqaDViip87U8L523/KZQEpUvvN6tAnMMAroDJN/lCMZhsV13ERNzO1OtoM8fGwdWZfL0EbOIKY+Gqs0tSoVD+wVA5O2oHeoPmY7NgSSE8ZqBfzuGb8S41UKBn+I9A1rZPQh18=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3977.namprd15.prod.outlook.com (2603:10b6:303:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 06:09:57 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 06:09:57 +0000
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
Message-ID: <814a49f7-68b5-e796-7254-2a4ce9c0af74@fb.com>
Date:   Thu, 9 Apr 2020 23:09:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0154.namprd04.prod.outlook.com (2603:10b6:104::32)
 To MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rutu-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75b7) by CO2PR04CA0154.namprd04.prod.outlook.com (2603:10b6:104::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Fri, 10 Apr 2020 06:09:55 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee4acfaf-e175-4ce7-0625-08d7dd15caed
X-MS-TrafficTypeDiagnostic: MW3PR15MB3977:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3977588AAB896615DC8533E7D3DE0@MW3PR15MB3977.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(136003)(39860400002)(376002)(366004)(396003)(2906002)(6916009)(31686004)(31696002)(36756003)(5660300002)(6666004)(66556008)(66476007)(86362001)(66946007)(53546011)(6506007)(52116002)(8936002)(478600001)(6512007)(2616005)(316002)(8676002)(81156014)(4326008)(6486002)(54906003)(16526019)(186003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOfX1C5Vn1ixwn8KKYIqVyrqFdUuKWNrrN0z6GAJ5usiqWOkhkbeu13HGD9X669PBowmWmtiW9YD36UnjybHXFFYPK0+txZh3vV8ymuFJ64eaVVB/s7ZttxI1Gx/ziSrbHmMAzxYRW4zm9OuA6zWPbh7LEsUPJe/N7uXRStNIo7LqqOVNshVAk1t5l44yrLlc/UBXR80oazTj6DgsOCg7NClCWBut08AZBFS5odmooSL/b55lbr+qdV5NsOk7tA64aaFzJG/kjoPQUW9c+GcAa6uZWgGuivqygUCJaUYTWQiCjyPhXw9YEDj+2tV9wpsJjkmxGTKFjMA8KWI6h2qP7iakUiQ56owCfCXpBpUBhBBe4odNBOiFSKWkav5y+atL/7cHxvubg1rQUfBd3Rba5dUE4baCxypPR/+nkpmsDHqmvyQSQ4Rgnrze6IUnOXr
X-MS-Exchange-AntiSpam-MessageData: aHMNWT1ZTLuREZdKKAJrxEb0eWqqpz3ADBrq6fmMhHLp6zwWx0pHCEs5IOEsP3jBr+4HFpHRIaMno3lEDcP233udw3KrSdkELHz5c8/7gM4mrx8WnFbCxe+fqb/12b5tipeKguRCN4HtiG7swSEBoXNMXVRaU/fBtS6pVozLd67xAzQQfJ+/+lKktMqXtcUK
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4acfaf-e175-4ce7-0625-08d7dd15caed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 06:09:56.8690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjRo5rHXNJVbSV+CyxS/8H3ysRTvga0F3f1EGGACvtJS7jwVUTp0agrk/NI4c0wr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_01:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100052
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

Good point. Yes, no need for BPF_F_DUMP, expected_attach_type
is enough. Will change.
