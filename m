Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BA93E19F3
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhHERFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:05:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32154 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhHERFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:05:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175H0Aw0006177;
        Thu, 5 Aug 2021 10:05:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=IREPXqe4ITJ9zpmSzgmovZ83c+1Cmq8gLLb5RWkh0tc=;
 b=YOGykOjyCm2mAXDDWOatFIDBZWyLDgIQUsDq+r72cJ5EQDZ1vci71lWSRl7X+ExG+gLp
 0IR6l+jJYUMtXLHm7iWs2MUT4mtz8GQjzB7ICdju4mBcG35bckvUuuA1IJt6TjoeInXw
 FnsyT5GDX3ZOCvYJb8s/H5ise4WVTi/sTYA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a8jh5gnd6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Aug 2021 10:05:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 10:05:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8vhJfV8r8aTfAVRjkE35uylA4OEcSZ5XOJuzL43mkl4WH81S7AnemMICMA0dse/VTZYA3njLGK2SaJjHKoxx85vJ3cobxg+oBCGAZlUTFF1rbP3IG2Lq/ye5FjN9EnzLcdZMWLQDfGMVny85Tqj7EdPj9ZJjYX5EnYMaqPoNsnyoCs8PrU9F1xhXdgLyzTX0Bd/w5rCC1mgSD+OkGk4N7psram3oBlSyNUx1iPXjSmmhA5XgKSoNuhKBt18L2FEMhw2MqlgZUTLzdusCh3HBE1xhC65Ijln6qijTZzegiUhMC5J4QgyO2OMzG+6qSUIaZRqFXFxa7x9adMcdPiF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IREPXqe4ITJ9zpmSzgmovZ83c+1Cmq8gLLb5RWkh0tc=;
 b=h5xGJPXBjyOOZCZBxiWDrvnMvtvs1xSWdzrxsHTlpXKtPevr4Tmc9phdY58wJJ9dwJEevRon1SzelnywEQdLukDeFGjSoXu2VUQl1HLQ4FGCIE1NL3BghvYidjC1cP9sxlSJcJgLvcPt5tv9AL5kY8NBTktyKHLJCsf/sAIkZcRgX1P+RwdGnooDyBMFiGjLuzLKDkNufIX+SICtq8u0n4TClIJZEx6RIE0G0knEnGvg510HiZ4YUdfIwgfs3X5OelcP9CZD3bi1Pfh0j5KiF/TCL0TIS9t5V7AL10SWGNoDEV5lRJYUM2vxkKImCSVgeLwbKyGkMR4LiEtNC+L9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4918.namprd15.prod.outlook.com (2603:10b6:806:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 17:05:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 17:05:02 +0000
Subject: Re: [PATCH] selftests/bpf: Fix bpf-iter-tcp4 test to print correctly
 the dest IP
To:     Jose Blanquicet <blanquicet@gmail.com>
CC:     Jose Blanquicet <josebl@microsoft.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210805164044.527903-1-josebl@microsoft.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <76d7a36a-b63e-7794-ad6c-047176cf90d9@fb.com>
Date:   Thu, 5 Aug 2021 10:05:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210805164044.527903-1-josebl@microsoft.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::13bf] (2620:10d:c090:400::5:9ce) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Thu, 5 Aug 2021 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97249c39-e639-4260-44f1-08d958332a3b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4918116619D79A2916DA292BD3F29@SA1PR15MB4918.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJdopUfv/mqd/ln+mx/VmD2Nlh4PtyD46CkhOwz6A07576dUl9O0LmvllP37zesZa8cWISOetZfWAMa00EVylQjLJP/MK3tYfk+sLpk+vpkw03WQJGGqbsTwL7Bj1Q2V+1H1eUTpPSHyVcX0hFp1aN1fFdzu4+AnZoQldr8fGzMXMJhODP+O6dmzzkAcq9IqVgvSpe/NwmQnoaJcAWOtC5ovap51bwkkjx8c5ZDtkjOcYB16mLrUzXPu6lw2dbv7pgms8Wni0lsee8MMtOINjJ8Sh2d2lnm0xf/dMDf9jzIg0YEgftmly2v86y2GWT/ps8FCTu15aydLHphAI/QFyLagNwj1QY+RghxCTXMef1mjOVzkhBT/IdWyuwIOwgyNzpfbAB//ayRnEyF/rBumujyTILKD+7t3qxua/l+kwG8FCJ8OBClU8YIZzLTZti5Y1IPPtPAX7rWHzrUWsyLRb+eZ+JpjfwGDtV5LumcC2Z8u6EwHnIVlK2+G3JQ9IpxdE3kAetGBAO+iYDVHAKGssTfUg3EDxARkrGIc1XYrEU2+gZgx2LavEvtP68uS36iZr4R9gvj1uOpWbZKBScht5ZXBi8w1VByFqOPz2tE37hPwJez/8m5sq3QXWdx64vEe92YPysHFhN13UFJ2/xFRC6Swuty1zlosaAd/dSKjtFqVkhpLCH+cSuZYxduPH6BhYip0LFsBoxzhR5j+FiwGFS6WHDQXxLAmsu9l5pTLq74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(6916009)(5660300002)(31696002)(38100700002)(316002)(36756003)(86362001)(31686004)(54906003)(6486002)(186003)(8676002)(52116002)(2906002)(558084003)(66476007)(66556008)(45080400002)(4326008)(7416002)(66946007)(8936002)(53546011)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UU5rYmtvS3dLbDN4S1FCR1R3cXlNbzZqVWtNZmRpUDZSc2VDdkpQUDU3a2tS?=
 =?utf-8?B?NWV3VXk0YzNIRG5DTEwyN3ZWbjFYWkd0VEJMU2pJcXN1V2w4cDZ6SEdReHBS?=
 =?utf-8?B?TitlRzhLNHJmMEZteGtFRGpsdFV3TVhwWCsxMlgrNi9LSlE0aUk1aWVuRUFT?=
 =?utf-8?B?cjlmU0dYSUFDaGJuNUVGOG9Yblk4blRKaXRwanl0SlVJUU15aG5KMmJ2bWdq?=
 =?utf-8?B?a3FwYlVPRC9aVWlFT0syUW50Ym4rS09wdEJKd3lTTXFLSE1oWXduQzRmSnl4?=
 =?utf-8?B?cjhuWkRERkFCZ05udkhQeGVFMGkzYXpodG9EMzVHWlRDOUZHZ3Vad3hzMXcw?=
 =?utf-8?B?T2toNXpXOTZJMjhtUTF2VVo5K3pIZXBXbWl5K0c5TWluL1FLNGxvU3FUYWhi?=
 =?utf-8?B?YWRvcXNZZy8wMjNrNnJEMmZ3Ynl3L3R5Z1NXbG5qWktDWkFDdWpwcnhXSkg4?=
 =?utf-8?B?YlIwVXZVZmNxeUVNSnV6djhyakRYSS9pNVF1TFQ5Vk1YVS92R2ZRaDloSFFv?=
 =?utf-8?B?bk50dmliTi81dWVZNGpseEZET1dVWEdQRHl0V1FWeWhUNklaTHhxdEQzczA3?=
 =?utf-8?B?c2J6SmVTV0VzenUydlhLVzVjZGl4c3Q0Wk9iWGhad1hPVlNhaHU4VkdMMyth?=
 =?utf-8?B?cWppeWRJL0NTMFhwMnFwdGgybXNGbG5EcVRDek5NSU1memlLU1ZCZ0JzLzJM?=
 =?utf-8?B?VFRJWE5BK01SdGtJbjl3bXR5R0I1QVRWOGFWdldUSldLb1RzelVza05xVjY5?=
 =?utf-8?B?QWJpUHhYS1ltZC9JRTlnOW5idk40WXppNU9Pcng2cGlCM1VBU2UyL255VnBD?=
 =?utf-8?B?MmhoMXd3bzVwcWpEMk5wS1AwZTZVdWI2TVVUT1kyMXJmdjJQeW03S0xBTXUw?=
 =?utf-8?B?aHhNdjlLMFpBZmdPY1UrcXNCeUw5MEpWUlYrQ1RoaFNhbmVJRXdKeSt6VUxG?=
 =?utf-8?B?Q1FMSEttcjQ0MDFqb3RUcHYvNEVGYkMzbUdRU0prd204L1Z1ZUZidWlVN1Mx?=
 =?utf-8?B?N0N1NHM2WnR0K2ljY3NheVMrOHp1QXA4VzE1RG9OWXVxWUcrbWppa3F2d09S?=
 =?utf-8?B?bmdyQXFQbFpjMnVsdWpGcHU3Qmx4SnA3VWduSWtJMHBOUFhCNFJwdGlwL0ph?=
 =?utf-8?B?SmxEdlF6N2M3aE5kUDV6YUZVcDAxN2dMRk56OENYQlpPeXR3Q2NvaTdNdUwy?=
 =?utf-8?B?MHdJRHZmRHZ5V1BiQU1aOU9PUXoxSXdzOWhIVlJCMWJPQXR2SUYrc3kvNXUx?=
 =?utf-8?B?V1ZkcENGUlFqaWkzcU9FNllsMXdvNTRUSFQ0L2JpaFFiNVA4cU41Y2hXZXNT?=
 =?utf-8?B?TzBIdytDVkFLRkhzbUM2b0djQVdZVXF5eTR0SmtzOUhlQTRlb2YwSlR5dUY0?=
 =?utf-8?B?Y3RPTng4Q0xpTytZVVhrN0NBWlo2ZE5oSE5CR3ltdHpXQW4xVE9LenAyNzVa?=
 =?utf-8?B?eXB6dDlPVGlUVFlCazEzOWV2cXNEQ1Z4V2J0Z3Q2d0hLRUZBNGdoOVpaWWFt?=
 =?utf-8?B?azFGMEkrMUtxTnBpOWcrdFVYWW1FWlppRk9hUHZWbXAvQ3NnMC9rbkUyT3pZ?=
 =?utf-8?B?MG1melk0MXU3U28xQzgrOWRNRnQvMmlSNXVSQ25VNzNySGFTcDFRbnhZRzVD?=
 =?utf-8?B?cHREMU0zcUp4cExqY2dpUllLeXEvdHB2Z2xuR0NjK0R0RFFIUDh0VVAveUo1?=
 =?utf-8?B?Y2JXT1dqQ3JhK3JoSXUrOHpRU2cxelE4Nk9zbXZXQy84L3JxeGhvNEhUY2Nm?=
 =?utf-8?B?bklJNDhSd0dBczNPU2JIdUcwQTFrVU9CZll1eVNhR0RqcFl1RkQ1YTJiM2RI?=
 =?utf-8?B?Zk1qZDJhYi9EOHNhQjN2dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97249c39-e639-4260-44f1-08d958332a3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 17:05:02.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztHpgKnLfvAYNG1kuUbveqgmGwRQxz/5XuDhdFywUftvP3ScuEWhjBQKA+i2Ywon
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4918
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lhxXh5Z5Gi1gKUvU_DZHBJrhsjYczWJM
X-Proofpoint-ORIG-GUID: lhxXh5Z5Gi1gKUvU_DZHBJrhsjYczWJM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_05:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=789
 clxscore=1011 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/5/21 9:40 AM, Jose Blanquicet wrote:
> Currently, this test is incorrectly printing the destination port
> in place of the destination IP.
> 
> Signed-off-by: Jose Blanquicet <josebl@microsoft.com>

Thanks for the fix! LGTM.

Acked-by: Yonghong Song <yhs@fb.com>
