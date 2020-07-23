Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C426E22A705
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgGWFoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:44:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39696 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgGWFoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 01:44:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N5ZBp5016187;
        Wed, 22 Jul 2020 22:43:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ceVyK1nspjFtSTffP+dKK9w1ePTFuOoOfW+MEHkXULs=;
 b=Oc1vTfHmrWaNf/YvsR2xZ+ELKAXpxh7w8CwEverxjhbMeIBvwGqJSqLG6vN/51eTwhiy
 VWMAPWNgJNoxZc/n3yC6aUcPuKvgB3CTkTX2dURAv1O9NLXk5emIrWGqYLuWdKZA1yAE
 b3ccfwfyTl81Yz8g2P31EY8N2YFibaw3xgg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32etbg2jwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jul 2020 22:43:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 22:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdsaZGVlE6luRnu1dYIpfconO/JsLYvtYRLdep0XATgnL05b61Lha5RMzVkIh/osxLrNfiBTBJJDXpa823R0OaESjn8Y0d37BIrySD7Z1yEeUvpHeNbp9ge4KopAyoNeer+o9cnTNXeRYehcWVsl3U/uJpxlwseCAGfvmwabBeEGKsDdUc5qMu7zGEyx+gij/MHLEBaEUQmVnFa+J8gVouzhaYUvMrQpaN8t34Xe9R3jMFWTl5TKg16LdnCJELaeoTJDqFbfCsQxPr0KMys6NRAJIqFEYbMnL3vCixIfvDoRYUX3uc1S2/EcD6Hfpru1g7EIqpdSrMnnlv51L/vQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceVyK1nspjFtSTffP+dKK9w1ePTFuOoOfW+MEHkXULs=;
 b=cMTd4vyb/WiBGajDheghcDc+SM5Xn2MKuefHPUg5RQhNSFQilVoamjnJaapg6i2EpiZ1mEXvmrgd/HX9t06tOp5nPGgFOqK5uzgS1Tc9NRtFfmU/xJ30f0q9/6r3zA6fHd0cJWPJ+AOrIJ5jVRuMBZc8WXZ4LXDnk5eoms5kQyuKfN5qSXQ9crdUIaJtaWaRy4l67AHrDSYLsHMKelObr7yyWD3TqUOfd81WJM5J1qUSjNVcAVpbVB3wfhqQYMxUzlTgXDPTeNQtILM9YSJRZ/am4K/z/JVZq/yrHtNh7mJmC4qrDQA58fINwD6KbiK37kilbsJr45NokV3Wn+ujnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceVyK1nspjFtSTffP+dKK9w1ePTFuOoOfW+MEHkXULs=;
 b=UJkhJ8H69Q+vLTTa1He4KOR99lkT03XoL/QxFMlIgu/LP3me/ScTOL2PRc6yXElS55xLg0+GdNwQmHro54mntcPnGhVmIZAkY0x6vVKt0OhQiQQAoIEDaDHrGQYyygeLV5ciHmuiGW+s8/JqfbF/kKkZlVgOqq5qD4u+yWufgYU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 05:43:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.021; Thu, 23 Jul 2020
 05:43:38 +0000
Subject: Re: [PATCH bpf-next v2 01/13] bpf: refactor bpf_iter_reg to have
 separate seq_info member
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200722184945.3777103-1-yhs@fb.com>
 <20200722184945.3777163-1-yhs@fb.com>
 <20200723053840.tnqzumivvtjwy3tv@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3300d901-122d-3954-ef51-ea7b6df8ee48@fb.com>
Date:   Wed, 22 Jul 2020 22:43:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200723053840.tnqzumivvtjwy3tv@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1888] (2620:10d:c090:400::5:eebd) by BY5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:a03:180::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.17 via Frontend Transport; Thu, 23 Jul 2020 05:43:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:eebd]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c8980d1-113a-4283-3b92-08d82ecb58bb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2999:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB299919F8D32B63C36511187AD3760@BYAPR15MB2999.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uIwM/EApQfeK6xGn2KDnQ/FmtU6QxqzaQeWQDg41QuzDW8mWV6rWQg4Sv+64r6wuE5CPrurKSqUYOEVNs8yqis/he5ww38ProaEwhP83s3zZBse8ur0mrk/fSD70PSIb/TH21ii7ObO3GkVABET8y+dTd0gqzqeV37ZdfNLDr39VjSxlpJlTt/9JDVax04FXdNOuOw5oRoMtPlGRzh5+wB04+5x4MUfScx01KsiyuDzZV79zDOkoaNzIohKlbwokOgAtWVMNkgmZZVqmIQQDBL9l7+x7HR6u8yCt4LnDamLqTEKu0Z553ul/yULK5KLup1TKJc9P62fkNzaSseAVfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(31686004)(54906003)(316002)(2616005)(31696002)(2906002)(478600001)(86362001)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(53546011)(16526019)(186003)(8936002)(8676002)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ANSbk8TKR3kSSMzhLn1UtcqdkMTHPc/UN5ak2zbIPnEbzZg33aS0FiU7Kt0oHxU637QhSBI4JuayoXQ91/4s8+Hz9jW4xhw7N/qWQUhW7JLwpsZLbyFxhideRUTix1ULjjK6nHYdcQTh6bAiqswa5XmNrdwAkBAukHwj3ANFQHzEqQW8Cl9lAErzY3lHvETG+e5gNXPyZX4NDYNYDx8xSdsqXuJVCupDaU6kWDyjUaGZnGU8bd53lUFgVC+fvX/PyvpvPgNYgBj0+rOoJ6hGXrLXAtqSXc2bsYFXnDqY416O8+TewdSK5SQ2ZkL7vdlSowTW+55b8JPp9UwnYPOR3OHEgJros+IE/qy9n9E96/Gs/RugJ/DcS2gNJzvQOU2kMu+J9zF5NhIoGFic19s94hDlqp9Pnywd9fHeFFUWX0jI2ha8yfzR1kHwE/6hfzuO/taZU+oxChRA9/P5dmtjg9ZxmMY0TPJT8iEBfr5hLHpIga7TSzVHQc+X7R72RqxkvM1JIIuHCxLHeEV0WmTAuw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8980d1-113a-4283-3b92-08d82ecb58bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2020 05:43:38.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVuZCjFpiXRe86WXj5nbn7hWbChmtZA9GVGVMxQuRVYutC39oc20+W3Mn0TJGmi1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_01:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/20 10:38 PM, Alexei Starovoitov wrote:
> On Wed, Jul 22, 2020 at 11:49:45AM -0700, Yonghong Song wrote:
>> diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
>> index 8a7af11b411f..5812dd465c49 100644
>> --- a/kernel/bpf/map_iter.c
>> +++ b/kernel/bpf/map_iter.c
>> @@ -85,17 +85,21 @@ static const struct seq_operations bpf_map_seq_ops = {
>>   BTF_ID_LIST(btf_bpf_map_id)
>>   BTF_ID(struct, bpf_map)
>>   
>> -static struct bpf_iter_reg bpf_map_reg_info = {
>> -	.target			= "bpf_map",
>> +static const struct bpf_iter_seq_info bpf_map_seq_info = {
>>   	.seq_ops		= &bpf_map_seq_ops,
>>   	.init_seq_private	= NULL,
>>   	.fini_seq_private	= NULL,
>>   	.seq_priv_size		= sizeof(struct bpf_iter_seq_map_info),
>> +};
>> +
>> +static struct bpf_iter_reg bpf_map_reg_info = {
>> +	.target			= "bpf_map",
>>   	.ctx_arg_info_size	= 1,
>>   	.ctx_arg_info		= {
>>   		{ offsetof(struct bpf_iter__bpf_map, map),
>>   		  PTR_TO_BTF_ID_OR_NULL },
>>   	},
>> +	.seq_info		= &bpf_map_seq_info,
>>   };
> 
> ahh. this patch needs one more rebase, since I've just added prog_iter.
> Could you please respin ? Thanks!

Sure. Will respin.
