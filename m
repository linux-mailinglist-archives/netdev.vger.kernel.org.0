Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555211A4267
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDJGLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:11:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbgDJGLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:11:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03A67R2X017755;
        Thu, 9 Apr 2020 23:11:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sbqknILohigieFa7/GHGNF8ESrq4oezk/xOtJPk4/kY=;
 b=l0dKo5d6U5A76DRsJ8QgTkj5zOkbzKB2cAZMvMcocZSuGZbDqi0ZdQQoKODQRE7Vl7j3
 65guyS6JukCWWcu3yxTVmDjhJ8EPRH/kFOL9pmDs3EoA4chiYZcJb4J5DRHNmg8Svuw7
 nD4V1zQwO1cS92jfQgB9PRq2DNWwbjpEED0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 309sad7ms4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 23:11:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 23:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cy5SxMXHXznb4STthkpTK3Yls/nzJ52LP8d4YRMRiUsdvkY7cebWIjxktabYb/rZcxgaH5vrtqUQP40j7ErOwHxOGjm3KDKOY+Ldt2z72AuBu9Czheb6BAfkBPGQYfj4jQ8OlcRNbrMcR1Q473bOnkL4tZa+WpiZBY86OXOuxrhNPodU7Zz9jBu3b3t2hlcY2mHowC/SP9hpIlaJ8ObguGueNbUvYuioO+FqPU+bMSRS6DD2RDqHXPFVh76SmRMWKNY1LvhFUAYDXg9IUd1Hpr9NKO1kz+Jei46H8+ylsJt5vSrRXlmehnQFPm+79WLm16gZwP4JNmJ3rK/dT/n4Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbqknILohigieFa7/GHGNF8ESrq4oezk/xOtJPk4/kY=;
 b=HINfAlnNxaFe4SFq1McprpNG/uQTa3evIA1hSopfKZY6HpS9q2/fKbaWfL8eP54kcB9PSgI/q0+mNKEZJb7ZRuk8FxUpmnSu3jROseC/KRuBnYWjclbCgzJaDSkDqKc0Ql4jC30QHyQVnuKjanvLW5s+HVrg2mSYs2A8VQHMEXQbIclrHHnpJbUHrupT61R0RsvbU7tgTOp9vLUBasaNNItdYSeHeaqtDbZb4MBsyyLCOd7YFbHm2U78TNeIMaJ8EFscrQpAwwUZF8kucdDYq79mM/rtoj3S3B+U2QtgIc5Azr+BmV9d7PTbSdHkoA1RBtcTdRWtyBPES5RGq7bJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbqknILohigieFa7/GHGNF8ESrq4oezk/xOtJPk4/kY=;
 b=iPAXHvu4yCHHGvhQLsN6OfgQXvaLA//Kk1SvIGx0NxFGdOO89rjgCgpN7eCGhp8/znUmXfOCFncZnbjtRsnlaaUgUFwPO+qqb/opJhofdfsmV9Dfgtqr4rNyEc1mcuFB1rNaqFQZTk3lF8JUN+xQXlBskYN264CmgiDgCusdAOs=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3977.namprd15.prod.outlook.com (2603:10b6:303:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 06:11:41 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 06:11:40 +0000
Subject: Re: [RFC PATCH bpf-next 11/16] bpf: implement query for target_proto
 and file dumper prog_id
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232533.2676305-1-yhs@fb.com>
 <20200410031043.lza5p6rzi6vajy7h@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6d706f4c-37b6-a956-372b-5d584e1330d7@fb.com>
Date:   Thu, 9 Apr 2020 23:11:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200410031043.lza5p6rzi6vajy7h@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0146.namprd04.prod.outlook.com (2603:10b6:104::24)
 To MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rutu-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75b7) by CO2PR04CA0146.namprd04.prod.outlook.com (2603:10b6:104::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Fri, 10 Apr 2020 06:11:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 173ef7d9-a6b1-4d6c-aa4e-08d7dd1608cd
X-MS-TrafficTypeDiagnostic: MW3PR15MB3977:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3977FC78668536E8418F622DD3DE0@MW3PR15MB3977.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(136003)(39860400002)(376002)(366004)(396003)(2906002)(6916009)(31686004)(31696002)(36756003)(5660300002)(66556008)(66476007)(86362001)(66946007)(53546011)(6506007)(52116002)(8936002)(478600001)(6512007)(2616005)(316002)(8676002)(81156014)(4326008)(6486002)(54906003)(16526019)(186003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caZ66lineRkUUdAixJSdFl2lK0uz78ZgGh8SpqnrS13rppGm9cvpWMR8OzOYabb8UZPofwSO3vfoQ2ccFUM1/hhK7Qx7kwzXDvmiMpH60tLVqzUb+LyxvjewsC3TEpAkIrnHoXeXu7ezZ1TnUPqjXA6oZSjiG9DBksu/an4ZFUXYMYh2VksuZRZg5FmxSBU/h6bD4k9sZQSUzaA1H9Gaknsch+c4CXxkVoTgzyR3RQR7TAMaxugWKUdM9m+fsbdooUEZuRBg9OufTiwMMJR2bUNvOOxwr0Ctl7hDDkk7mEJTIrYETIPPYIylwQeZF4iCMNA1w6RU4GD6kKRmircHQ3M37A79jU+Q4Tct3m4zlicATC1A6fVS32xAeFJ5bl9RK0vz8DlJJ732RRPlhUjzBhIAQ/ZmrzQOENxna147pzlOHGBYZJ5NS4fbd7FpVeQo
X-MS-Exchange-AntiSpam-MessageData: VnHzbmzpdQDgW2DtFBAab5VCyWcXIZP2BI+u7MbbZZ+ZJzld/8ePyPZ5f7NwnjpPOD0qAJM4HrJLtDZJsfV6vjIMzY5R3fdZinZbIdsA7aMva0Kmo3lkVlJouA2wxp4J0Pd9QTW1GsE01uIGoqvzbwHVSBDyTddfZIRA4MxnZK096MkNBbr6lxUgoAqsUjTI
X-MS-Exchange-CrossTenant-Network-Message-Id: 173ef7d9-a6b1-4d6c-aa4e-08d7dd1608cd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 06:11:40.5309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8hDxI7ngriPtQE2C75XUQazGBxjqOkAmmN+NFaB9rYG0/GpgDptrTRv4nkFW+FK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_01:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004100052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 8:10 PM, Alexei Starovoitov wrote:
> On Wed, Apr 08, 2020 at 04:25:33PM -0700, Yonghong Song wrote:
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index a245f0df53c4..fc2157e319f1 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -113,6 +113,7 @@ enum bpf_cmd {
>>   	BPF_MAP_DELETE_BATCH,
>>   	BPF_LINK_CREATE,
>>   	BPF_LINK_UPDATE,
>> +	BPF_DUMP_QUERY,
>>   };
>>   
>>   enum bpf_map_type {
>> @@ -594,6 +595,18 @@ union bpf_attr {
>>   		__u32		old_prog_fd;
>>   	} link_update;
>>   
>> +	struct {
>> +		__u32		query_fd;
>> +		__u32		flags;
>> +		union {
>> +			struct {
>> +				__aligned_u64	target_proto;
>> +				__u32		proto_buf_len;
>> +			};
>> +			__u32			prog_id;
>> +		};
>> +	} dump_query;
> 
> I think it would be cleaner to use BPF_OBJ_GET_INFO_BY_FD instead of
> introducing new command.

Right, using BPF_OBJ_GET_INFO_BY_FD should be good. Previously, I
am using target/dumper name to query and later I changed to fd,
but still used BPF_DUMP_QUERY...
