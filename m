Return-Path: <netdev+bounces-2312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C3A70122B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 00:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81101281B2E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB078BFD;
	Fri, 12 May 2023 22:30:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD841EA67
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 22:30:14 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716711FDB;
	Fri, 12 May 2023 15:30:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CJ0nJX021751;
	Fri, 12 May 2023 22:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=UgE95QSNGxiUaPfLiZFrgs6z5ltC/M072ygJMhFssm8=;
 b=IRK62GzTNl1nA57el/zec3xMqoKcVTEBZd2uldDhOBcWPKZ8deRouNlMmp8DOMOdfbjo
 IDMq7ZcmENxwkpZOFdEQGiBn8VgVCixy5Q2n931H0EXl0wbICSVlr/1ByV64E2z9ukvW
 Xfu9QcHJKecDjBA1j8DOb1KsfL28IP2hVX7MoxSz6r9F4mg59XOFodnLvmsTgmoqPMNb
 IsL4m7g7qV8yFKyie4w2QDo+1UgglbsaGtnGf8swABRPLlW2UI5ah/wVgt60QvEKGG45
 vIH9d7F13nTWNqAp9sZHPEmvEtD9gFRmBKHg9yVEvj0hW++wef6c78J4d63qq/TWHyMF oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7794b4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 May 2023 22:30:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34CLG1Q1011669;
	Fri, 12 May 2023 22:30:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qf815ek63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 May 2023 22:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntMA3wS3UYXZvGyirvdHEUhV1zGynokqDdr/7MI3NQaNMMMR4WxQBiWJqAzKDLZzC3C6Kl1c+Pyl/vMpi2rduGYAfsLjYPO2GZi+Zj90uN4i7DClXrTVY3HYHYzhnyfjnZD+wMKajDMDzbnkhTezrMs2nkKYqFN4o5JJ7yyS0/SZh+EWEXZjhl3Dk0xASfxkgjNe5erH0ZlIf66Wr85e53h+svh/oeoeWL1M+xVco8SmuENBNEw0ezl67jAZaWwPWVpQly78pIyYH+sI3FpM3/2chNqgZWds4WDUrLAmme3P5FHpPC+EAcda4YO0k6gYD7sGhmU6dziYVza3KmkU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgE95QSNGxiUaPfLiZFrgs6z5ltC/M072ygJMhFssm8=;
 b=Ua9thAQGaVnsJ06guPiOC8w6GrlifaOINzsgCPf7sc6g5vxTpJDIhy4q4KV6SEaTIH8UBnzy3oNetgXubUfIazMyQYDbtU67upArCbvw9C2yv/UmW+f5+i6tQ91cSt6Y5t8ea00W3/D8n/Jvwp/xotKyLysQ9BzYAdiC47S8ZtQTzAJtipuAZ9Gr9B1hSr86rFsCJS1VU4T5FAo5acDP1HD5Q/GTC36Q/kdKunFo4KPBxJDaitzGzk2Jau2udisGpFn2E/4L1UtpUtlU9T0A6vMca1p7oeIU6dzrsin373G99c8m+GhorQwyLqpgcQ8sEPb3boqAgqes9bYj9j+7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgE95QSNGxiUaPfLiZFrgs6z5ltC/M072ygJMhFssm8=;
 b=tuAgFX0SyWqE11P6wtoVDorG2f8EA4Zjg9cCrf8pcFLQ77ijwikEPYKzQRf6zfTMatqt1s38ACYXT9YTSr2pGye0wUWUPt5bZWb9ASOtAqHmFihDCloSKroEn4jmgrVtvl5Rl5u+B0/gfamx84P5Aig0CgtP7lMf3ShH4AnUYls=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4424.namprd10.prod.outlook.com (2603:10b6:510:41::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.23; Fri, 12 May 2023 22:30:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6387.024; Fri, 12 May
 2023 22:30:03 +0000
Message-ID: <1bbea295-69f6-80ad-2000-a48fb1da8eda@oracle.com>
Date: Fri, 12 May 2023 17:30:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 05/11] iscsi: check net namespace for all iscsi lookup
Content-Language: en-US
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
References: <20230506232930.195451-1-cleech@redhat.com>
 <20230506232930.195451-6-cleech@redhat.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230506232930.195451-6-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: 842ecbf4-4e09-4af9-bd75-08db53386e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HQWb08C9iWXReto05CIfTGjyeCQ2QzIX8oFkY54M0L3tFDPvlwLxMizhfITnlgLhmMFrIM9kxoX0kXVR82Pv7+sRqXvldtog1jO0vxy6QofOL4mE+rbvAFxorcVjljh1TFXGxcGGxje4pl2bi8xUg9Tymmxnc1P5836uHftSJvPh4WTZT6JZzdGhV5SRY8Mea++faSM3nROQegOo49GD37/UX1GFC7IvZmIwyCY6DXeGY2wWeu5gZhxmwzE66CQ8MkKWPD8dv/14BgjbU44Er1nBDvgbYL9X8k+KmBSoZtUHzj9F/5A3ia2bGx2rUIxt/e8qazAGezfm7lbnaLQhgP6o5oZNfkXZnDNckLF06t7xn3+ZvMKiggO7xYljs/MwvXn4dt2xFpVD2ShZJOEPuj2Bcufgyv9hDZlR7+8xEgFat23gquzoAqENDiRcLMLuOVKTnN/E5hLM0Fl7CQU1u6rIrMlu+iLnW/8HIhIwj6S20ip8oohS5a1uwEZ42U/Ff+gjGx8AAPCK7fofUvB+53QriSe3laqPheDGllW4+wN/G6jNF5XoeYWo9w7xPqqewmX3AFUBHZOkUQdwGSSm+6Ic3QV8q/Py+l+hhgfXDDOfubAOnFKLgvFCmuW5Ffl89MZmCiiVUPpstwQ8C46mcw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(478600001)(110136005)(2906002)(66476007)(66946007)(66556008)(41300700001)(31686004)(316002)(4744005)(8936002)(8676002)(5660300002)(186003)(6512007)(53546011)(26005)(6506007)(2616005)(6486002)(38100700002)(86362001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RXMyc0VVME43ZnE4WHYzWVozL1o1TnVtQzNiVFFyV252RFFzeVN2ay92VDVK?=
 =?utf-8?B?djVaUDJpYjluODVQSm1qQlZWMmVuTXRhMEJvbFZIakR1Ty9XYUZrUHIvTlQ5?=
 =?utf-8?B?R0lxbjFCNERab041MXc3RDhFMVF3K3NocFM3M2l4OVFJbE92RllTVVA3c3c3?=
 =?utf-8?B?OElOczlyUHViKzdvanJlUGh0V0plWEJtaGNRLzVtZEZiOTNiYW5wU3NEb1Fm?=
 =?utf-8?B?aE9NZk0zYms3NDk3WjNROVd0Z05rcHFCeW55aVZ4U0dtbjMvcmN4Y0hBZVdu?=
 =?utf-8?B?cERoMys5MjFmalVrK3p0STFUZmwxRmxQbVRNaGFpWXNub3V2V3NITklXKzlG?=
 =?utf-8?B?Z0szb3BNVlF6bHdjVWtKdE9EeTcwUG5EUlhDakRmQ1BTMUdZZUxxWU1laEVh?=
 =?utf-8?B?VWxEcXdaOFdFNE9uSXdIUzdVUFZmT2U3Tk9yS0hNalFOSDNLc2hocTBMbkJN?=
 =?utf-8?B?L2RjdlkvT0s3YU11UVFIcUJqMForYTlicmNRYmRVUzdPcXRuT1VQcG5WdFFs?=
 =?utf-8?B?d0JhY0FFbHk1eDNWQTUrZVo1Rk9iU1RjS2I3MFpaU1dxbU1GZUVVcmVTcE1r?=
 =?utf-8?B?eGUwZlhkbjFqMzJCdWlIYUdxTnNLU09IVFBqUDdLVHFxemdObHZZZkZySGNi?=
 =?utf-8?B?NGJkSEhzK3dXaUVsQ3ZzMkdDbXJUWDRyMzdwSWpyWVVOaW04Zk5mMU1OaUcy?=
 =?utf-8?B?a0xFV09GN0ZuT2w1Ump1MitTZkFWb3dRLzNiOEZlYUVDSVhLRDB6SGUvbzU5?=
 =?utf-8?B?YXlLT3hTaUxhMnFiTzV6NjZUUlRQaUxEekY3RUM4L0l0cEZwVDNRTmV4bS85?=
 =?utf-8?B?ckxuQitOTi9wL1VPZkpuWmtqaHpnMHRFK1F6WGRVQlVQQkhEV1oySWhTSFUr?=
 =?utf-8?B?WnZxbjNDVjFyaDdkZm5NOXgzRlI5dHd4Qzl6QVpwV2JrbWVuMncvZG9NZ2pa?=
 =?utf-8?B?bzBuM3dqcEZqSTM2UG9QQmE2SzV0UTE4NFJYSHowcFFwTHFSYjZTRFVrbDlY?=
 =?utf-8?B?QUdvVnVYK2ZKT09oWFNHWE1LczlNajVlTFFnbTVFdnpRK0hSTWxuWG14ZlIv?=
 =?utf-8?B?NlpqUFlxTm42K0tKYkF6NjJLUEdydjN5cU1uRTB5VWI3RllsNGVlWFlXZjN5?=
 =?utf-8?B?YnI4VzlxaU54VVFVanhadk1jeDg3V3RuZnNJZVRKUFYvL1YwMXhGUjgxZ0tI?=
 =?utf-8?B?ZnFaVjBMRlhXaHp2aE5MT1FURzk1S3l2ZVRHaFZha1pGTXhycVJqK1V6eEx3?=
 =?utf-8?B?VmhyVUltVWlmdXZUWXVVUFplazZnUHd3aXFBS096VjhGWkJNMnhoakZxSmQ0?=
 =?utf-8?B?SE11L1NFSXdmRGhtTXVGOENJc2laOHZ0QVBRU1UzVEpvL01iZWVWaC9EYlM0?=
 =?utf-8?B?QXV3MWVYY1F4UGRPRU9nMXdaV1I4eGlmVTU0UjVNWTNqRWlrajRMaEF1RGVh?=
 =?utf-8?B?VWlXT3RSYTh5S015Q0lkaFlhb1lnSDhhVlNwZGJDYlV3WmVGU0dqei9xeUcw?=
 =?utf-8?B?Uk1pczN4T2w4aytOMGVZVGxFelN6UzN1WkUvVjFWektnZDE5Ui9OaVFTN3Iv?=
 =?utf-8?B?TWxQZzd2eGJWb1NZTEJ1WE0yTXBLbXdGbkd1RktIVkNibGZKVXcyZE9kWXhU?=
 =?utf-8?B?OXBTMFRKRWMydVpWbm5weDg5cWJTRVpsYXJGR1VIQ2hCYUZFc1o0c0RuTzFZ?=
 =?utf-8?B?T0NXR25oRUhmak5idENPN2dKaVJyZ3BYaEFQZ2FlSEU0YVZFMFFIMGxSN3Iy?=
 =?utf-8?B?cTZOWndsSkhzbkNjb0FtUzNWbk1YdUJNQjRjVjVLZWhpMzduTEkyNmVxWjBQ?=
 =?utf-8?B?REtCTnY4UkNyTDluelJpVjllT0o1KzFVRDdBRHUwdWNNMGkvZDdFd25EMTha?=
 =?utf-8?B?T01VRkJwbXpmMW9HV2NNK0NUeHE4V2E5MkgxbjNRUmFqUE4rdE1XcENWUCtQ?=
 =?utf-8?B?YWh0TnVQVjBFVndjTEYydmJTWnpoYVJVR3NDVU5iQUFseU1xdHAyYzRENStk?=
 =?utf-8?B?bXpOWWMxQlFDSmdlMjdzbkZZbUltaFFGbUNSKzdEUE5FYjltclliOEwrOXpx?=
 =?utf-8?B?d090WEhTTE1Na1gyaUZNeEdPNFJ0Qmd6Ym5YSGI4UEcvUGVKamlWSGZ1YnNN?=
 =?utf-8?B?MzBrUFQ5UU90OW9RM2xaZFp3Rm0rbGdaNGhUUG04THh1Y0hSa1B2dFpDeCs2?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8hGA+BtogmWInzmMvdrg+gMR/zQw8AZ1ClTI6zlkUpUAZTz+6uxFfxHvT1+vjArtb0ZGzS46VSYuN/z0hSZmuV05geTHupfPssEuA1lCOtel9YIDhhcO5d3RlIC2O2cyHo54b8ZarOfOLHdc/JXVgz4CDO3yJ1+/fsOpa1LntQlMMc8TdQ6jHrTued5lzNUfzhMtj8TMuQ40VI2+BjPHTf9veVQ7wMepb9QbFj/k7k0Mm4/8lEc6gUuFBZZ6rp36ezSd8Tsggs00+hlZHJOH0OTf0N6F5yk6EqQQkQU73YvYdlWXWMueOw+I4U6Co7VVwF8k1KO8rC3ULlN2SP+mr9LwZr3nMZNx5ckDHy28FBIFY+8EReoM9XsUKc3ARnN+KDU/SYJdlWflHA5uDIXyS9nL5OqstQaQ8ItwrCBafRJ6Bl+gfthyHXeVlTlpxWe5J2scwyWeQJbgIb12jhfJc6AjVLnU7aHZmYU+W1l41S7eyKZO7Zhtx90WHn1pYJ63/m7Hc1YSIAZehTd8gIOScoWeNTbGapfAXra+Rwj5FzGJe8pjcn+WwpvSQJV1zhJfd0eYNybi0C0IJuF3Z1HoBQd6FFnu7OPp4a1OVwIqglgzNZv3U7yYos+w6KItU8MDKwAZL0JqJcJIRRVtj4YYtbp7uZInR7vVBo05jvVZlHm+8eVN792OL/+1FRJyqO5XwpQXUtuH8m0PiGTEqoUUV7tQfo/9vb/CPb/WAqrK1hIIbl8URv2zSicY0s0jJLdR3dbDGMRuR8hRwUBCH9MBh79u84qdI7bHhXyFaIseIn4ZNHPAsGg9AXIL/vhju3udAJKqfYLvqUl81hNw5X0UBBNJvyLDUxGw/f/gMv30TPU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842ecbf4-4e09-4af9-bd75-08db53386e1a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 22:30:03.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+5J3DeitcuhNVHHVQucz9U4LJzHri9pF+qSjjCKPCISxX1LWqWBHDPeU8+ELFVNE6K81zWZg4ufp1DmJmO9Ds+2kLkBGnzUlscGzXBB2ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120189
X-Proofpoint-GUID: P61GQfxMvulfihMuK2_3UfZH_dh82zKQ
X-Proofpoint-ORIG-GUID: P61GQfxMvulfihMuK2_3UfZH_dh82zKQ
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/23 6:29 PM, Chris Leech wrote:
> @@ -4065,8 +4108,10 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
>  					      ev->u.c_session.cmds_max,
>  					      ev->u.c_session.queue_depth);
>  		break;
> +	/* MARK */

Got an extra comment in there.

>  	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
> -		ep = iscsi_lookup_endpoint(ev->u.c_bound_session.ep_handle);
> +		ep = iscsi_lookup_endpoint(net,
> +					   ev->u.c_bound_session.ep_handle);


