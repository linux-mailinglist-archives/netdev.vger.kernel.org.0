Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9072FBBA9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbhASPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:51:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391650AbhASPnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:43:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10JFZ2a0012317;
        Tue, 19 Jan 2021 07:41:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NCc4AQpUeN2v+JWXNMTS6cjdIhZZxJSuxApWoR5Bwdc=;
 b=TFam8rB6jMF5cvQQELhfDCKFtrtooBaeR//eVOGP0a4BYYFD6+kGWp8VM2DYXVVd5SPA
 XXiN6hWibjb8JtH2aVzB1sqfKlm971x68h10oH8C6wkDeWv4QJDqEQpPKvnUdUCqjdX4
 /J0VywtPAbh7fgq5p8jVvNz2lPsihjp8u+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 363vh5ce0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 07:41:48 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 07:41:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epRuFVpty/QaiuounCeMJfpxFGB4STIcrOHS62BvwxGWrtwxOPMmnMZdhb2nIur0Y7+Aa5ZfnYmKjnmo4Z4y+shekR/+j07ffELlZgZtqewryPo5XKUYPabMTZBj7sOlFnE6kLw2xmL5D1gq8VfHAT0RKFgUZ3yarTITIOcxq/7ZXMt27chv4KTPaavlrEFSq1y784QJkIpIPK1Ujig4EUmM7ZLoZE3s20smnn31BsWqYFu69cX1kRMUXxZT5AAUEVvOOj0+plPmKJrdIJRjtO0WlJ4b7FlWwCdLusNez8CxgjSRUgTLsUpPWC4pfX6IFVNGdLFUKzDzml7dPK9hTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCc4AQpUeN2v+JWXNMTS6cjdIhZZxJSuxApWoR5Bwdc=;
 b=CthboVwu441duZgAcsrGJt3VrFnsd7e5qcPyFT+b3Q5KqWsxlnNslbyj7DJXkPy8tJDVgwLz1vN6hUveOi4TIlZLfRsEPSjYNeq7vRT+9lAkCdJwUuMzfM3vU0Ub9CdZB8AzTZqcpzTZb8DpeWqK+Ux0NIk+VOHwxrVdUX1iDLI7/NLDWNHkTPUmoBZMG3rHyd5G7n7s/lOgVMn6RS+/bV3iTRKuujGIDyblGr/JiG+Ihdmgrjz3YmuAaKwwIgwceEvoFyCtQmWRD7wDfxSm2v2xWdv7Oi2wsKeCnHXP9XrKK40hMI4d0cVmPkPVenyFOX4v6J0zWN6TkpqtOtvUKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCc4AQpUeN2v+JWXNMTS6cjdIhZZxJSuxApWoR5Bwdc=;
 b=fiu+jyVRVpwp8QK+7NUvHt5BOME6nVmrCqTat7xy84g/I9brWU71yg3TspYQysQ3IGR4t/NRwr8fp1vSA3j1bJhYyPyVSxREAJSB9f5UHQcfUy1hRsUHJnoVVnbK/MdWq8T1N9AaQZOKTwxdFWrp30dNFphNIc+tB9ZUxF4i7Z8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:41:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:41:45 +0000
Subject: Re: [PATCH v3 bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210119122237.2426878-1-qais.yousef@arm.com>
 <20210119122237.2426878-3-qais.yousef@arm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7be38aec-882a-eecb-3c20-c5f6b4d0bcd3@fb.com>
Date:   Tue, 19 Jan 2021 07:41:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210119122237.2426878-3-qais.yousef@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:5f35]
X-ClientProxiedBy: MWHPR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:300:ee::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::126d] (2620:10d:c090:400::5:5f35) by MWHPR04CA0030.namprd04.prod.outlook.com (2603:10b6:300:ee::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:41:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81152a9e-1055-45cd-b518-08d8bc90b992
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2696F1AB2F4C0D779ED3E0BBD3A30@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hlfQ2FQmgYVDDF09gUMqNkFC9n3NhhEDq1DLKpMb5tyJqtgjgW7mk7FjAjFC+HXnlYInY5SMw3AMiT1iBuSpG+Q4QV1xmuteD3j21RsBRREJb/MZMUYuq9b1JlTtvYaWtoK7PlK8AIoyOnP13ahslN1gzJBefQCmaGXz0slkWLEeeSNUaPQs9WsPsRqssGyo7hmE5d/JfQGRvgqpUzfvfujCKlh2RwRlSbjq0rp4n8TfFZJXYLoO2gD3+zOQuwL2VFKbetXSxFS/hpHLfOueOjH+vJpgktF29sYi3y0CPiAxMzymMV+H7qScJTp6UGVJXARjVFyNWt/G72mcEVf2/UKVu2+hMjoGxVibIE8lct1ABYDM4nty+ZAwqZYvD6bCigOYFlSPO/DYJR4qg1R9mhpjKD+XPrScW89rDga2XZApiomUioQipwQdURljjUPjdqYBWI4uJt7KkBCYqUFepMu1+wsYxsQOHo+025gTLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(376002)(366004)(346002)(558084003)(31696002)(2906002)(66946007)(8676002)(316002)(6666004)(2616005)(54906003)(5660300002)(186003)(86362001)(6486002)(53546011)(31686004)(52116002)(16526019)(36756003)(478600001)(66476007)(4326008)(66556008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZC9jTlhYQWNIK0pYRmpQV2RaWlA0ZmFRTkdMRTJOSVlvRWVacVpZamRjNktF?=
 =?utf-8?B?eVp6cEFoSlRUbGt3N09uc0JzWFhjdFYxRndGSWgvOFVhOUZFNGI4SUs0azRn?=
 =?utf-8?B?d1NtMWwzNisrbjdJSDFXc2VqUFE4YnR2dzVmdVBHRm5SaVhuMGUxbjRXcDRU?=
 =?utf-8?B?djVVWXRyZ1JudHJmbzRCZTczd3A1dE5ZMnZOZWJRaUpIMFZYTHlmVDBYR0Qx?=
 =?utf-8?B?a1d5QVJ2UTd6bGhhUkRDREJEbm5rL3RXU2RSRzFaV3NsTVhza21oZkZ5VWMx?=
 =?utf-8?B?R3kybkZOdTFIV1YrSHMvL1FMVUlYVGN4a0ErS1J5cE9CaE1aL3E2SGZvRita?=
 =?utf-8?B?aXhhdTFwT3hGanNQSldzQnpGMHoyMm9wN0Fxa1crekhLUTk5MVMrRnJOVzZx?=
 =?utf-8?B?cFhMRTVoWmdMVW5Jb3IvU3pybTNXUjVjSFRWMldTMVUzNVNFSWFpOGxhaGEy?=
 =?utf-8?B?UTZrdjZTNlVmUTNLWVFMa2NzUGViVWdlT0s3eXJZVGJMcVVlRlRoMkVXRllm?=
 =?utf-8?B?K3J5b2FPS0p2U3BXcG04TVhFODhaV25DVDB2TFRiWXRoVTliTjRXUTRkR1Na?=
 =?utf-8?B?SHFOc3IybkZFTldWOWd4RHg0aTFzZWIrdWFaNHZFQ0JuOVV5bHc0MUZqYk5W?=
 =?utf-8?B?VEJQbWxjaERTbXFFeWV3NjlGaFRwMVZRTnlWTUkrMjBVQ29VdDMrSjNSRVM2?=
 =?utf-8?B?UWlKTVlzWEk3NXRwbG1ZKzNsdXZUbG9DRUVtUkJYUzEzM3VOYk41c3Q1TkJK?=
 =?utf-8?B?VUJST0taM0NpK2l2aWZzaittSjNTM29WMURVOXNOMWV5cHB4cGVndlAwZmpj?=
 =?utf-8?B?RGtwVGVwSVZ1MVEwWnJ3ek9KalFUVkJUaFJUS0FlbnpmODFNRzREVU9LNHhk?=
 =?utf-8?B?Rlg0aHNoODhTbHFTMzJ2bVB4eWJVdHczdWdSaDJXTGdjN2Y3QUUzeUsvR1dl?=
 =?utf-8?B?cDUxcDNaOExZM2R4U2owQ3BIWFlPZjJ0UjFwanVLZ2h1WWxURno4cm9icVZQ?=
 =?utf-8?B?SXpNcE5aV1JPNU5XSG8zUEk1SnYwZC94bWViMjZrMkZMSHpwcHQ1Wk5ZMUpK?=
 =?utf-8?B?cXR5bkpMekNteFZVR1FGVjR0dXhWMHFFclJPT052SysySHdyQ2dKL1N1dWZn?=
 =?utf-8?B?OUJWVDFRYWRKZUh2SzM0SS9WWFBIcnh4TFFUUzlPcHlRRVJJQ3ZjQm9YNTcx?=
 =?utf-8?B?b3lNVTB0NXB3RWRrbHZjQ3ZBNDM0WURxeUQraUhlelFtb0xwVUhUemhPVzFi?=
 =?utf-8?B?RmxJZE03aDBhRGU3OHM5aWJQajl4UndYdERBT2lER3dMb3NJa2dzRlFXcngx?=
 =?utf-8?B?UklaQ0U2cjhsVWc2VVN0TlBBdjN5bndhNVdSMDFxQ3FwV3NpK0lOeWk0eUF4?=
 =?utf-8?B?c3JBZndnRGJFeUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81152a9e-1055-45cd-b518-08d8bc90b992
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:41:44.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJZTNaUiy34zdrZ8jA0x/6iArspT2gBbxP9qSlHEI+fTEhIQxM5g+j52CNkphjta
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=887
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/21 4:22 AM, Qais Yousef wrote:
> Reuse module_attach infrastructure to add a new bare tracepoint to check
> we can attach to it as a raw tracepoint.
> 
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>

Acked-by: Yonghong Song <yhs@fb.com>
