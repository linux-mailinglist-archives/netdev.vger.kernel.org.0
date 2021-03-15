Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D938733C0BC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhCOQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:00:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231795AbhCOQA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:00:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FFvmS9012280;
        Mon, 15 Mar 2021 09:00:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nRsIvyJ6xYhNG8iZavxIPOq0A2HTvha2Mu68RNFHg7E=;
 b=a5IkvQ5KAja+3nTjeJSXuVclVV/iBAx6tOEXPY8va4mzCy8qAw3Opln2aqJ1YR+eqW2a
 kOWIMgGTefuiEdDf0oS0Wycc+8RX4L6J3xWqhcmZe9YqIFGMsObONSY4vFp9XoJ9qAp+
 zyGucmnHxsPy1qNejIVxDireGUkxIqaS1w8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 379ee5dpay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 15 Mar 2021 09:00:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 09:00:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AG9BZBmar/CJTDTaXvm+YfQJ90cN8RTqK6RRTbGDfOgBGHz5p+P2qDcXhap7IJbgQv/OxK0kV1FAOrpL3NWTr1yKAr50jyZzaav/nP5651nQSLbivvFnw5K1HzCqKYzrh5kMv1xz4mRG7aPDHwz9G8iFLM5zRW2TgYxexzulBFN3lYXYJDPgQwBmEqhpKP7txZEY2A2ZQgy543K9YaQulhUm+UWmFae+JsmDJ+wtR26l05CmT+3DYqfavWr+VVam2W573/x1IW+36t3Vm2EpMo3Hn2ENfB6Z58XUbqBFIUa/ruDVQwZoD1DDbQGenPIkEU/xpRjESxduDxxyc6VGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRsIvyJ6xYhNG8iZavxIPOq0A2HTvha2Mu68RNFHg7E=;
 b=aCPKLY1Djv4u1kYPeMvXPRaRqHWHGIz3ANY1yne01Tx/lOrfp8zIxyZwh4kfUMt5Gakxp1rBVM9izdsUD2bbTuN0NO7anqHRcB37w8uGyXI7gk5Ho6u1Os1EZUfaT8iZugFL0EGYo5/w4IDYyT2jeOzF/e+qf8ulbDTzgJ5Clfjdfkz9JgPqomU5OLnawf7KKC6d/aNR0kgAru4NpbUONfFKw6qNn+AAtdsdaITrce+f08s+5BL3a5hV9NnbZ81TrZ2dS2M+H0xYU2EX4lRzgrQEvu36GcpBfwWQMhXzCqc0XTrulsqyxeQxpbVHvhDONF0W9w4GXBq0k++pO+dJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 16:00:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 16:00:13 +0000
Subject: Re: [PATCH] bpf: selftests: remove unused 'nospace_err' in tests for
 batched ops in array maps
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210315132954.603108-1-pctammela@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <53bde615-7435-6af1-da77-9b8c791fba52@fb.com>
Date:   Mon, 15 Mar 2021 09:00:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210315132954.603108-1-pctammela@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:323f]
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::104e] (2620:10d:c090:400::5:323f) by MW4PR04CA0268.namprd04.prod.outlook.com (2603:10b6:303:88::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 16:00:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b0a8f10-a8d5-4e14-c104-08d8e7cb6ac0
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2064F8F5661D22A68D10E748D36C9@SN6PR1501MB2064.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:439;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzTYm/VDpjBb7AG8BXfE8nAX8ssNXGsXan0v9wfF1VOLJihW5FBh93D4xURsk81rwVcBQafz8E0TAM8edwQLzFQgpwDMPoemdETzNR5auSYZqFj0aXCIdmRQQO49IfCt7JdLLNkSX0HgvWrBiJmdwrt2iEBAHlpXIE2H/m0H8G/zhCsBQmvYTrhLA3YNRUW7rseSaQeBXeuA0TOa42HoP1YNW0gzwv68eHafMgC8YfgfPN0e8o210kJZ7qLctP1XwePVGWsYEg8WSyhT9wepkrhdQmOmLzHgV0bf1PPl7hQ4c+5sqoROE4NI4GDsxVp9j0+UYwFZutdca7elIUBwLRYWHnv4KtRmt/ZLzkkn0GCH2W4u8XiRAwhYhq+edQXqkvy0WWwTJf7wVsW0ka8Ew5URwl2eoNISoKa2gYZDgBr2PtC+/RdCWKt3Z3thDZbCnkGwNRh0S2JADQsGR+ib96f5AjT3V8/3UNWVm9MDLV8OPdsBrPFJFT5GAbOTrv/8sYMsXR4oPYtJV+GhsNASXYX9JyZ0afzuJRNGvUgDgXAlt4hUd3XC265i7u/BI4sUuQuTbLpX/HvwC2xIw7mx1Qa76onzNpbnsuW5+8Yc+JCWycx1R7sLS+vG+R/d2AZ72D0IrLwNTUe9MhHcl3ZaWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(2616005)(54906003)(6486002)(52116002)(16526019)(6916009)(316002)(8676002)(31686004)(36756003)(86362001)(66476007)(66556008)(186003)(5660300002)(558084003)(31696002)(478600001)(8936002)(4326008)(2906002)(66946007)(53546011)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHJEWjBUTEhHVDdkcmJBUlBzMDk3TXc2ekg1amNsb293WnFqZFNIbkMxT2Fl?=
 =?utf-8?B?WHFnUDZlZHBmUDRIT1FIUzgzbEZseUJXa25JQjVyNU1Md2EwNk1Hb0RKSXo5?=
 =?utf-8?B?R2VDdURNRlo2aWs0M1ZRU0d2MVZjaTd4Q3NJd2F5K2hVeTNZZm4ySytqNW92?=
 =?utf-8?B?ZjcxSVZnYW5jRHdXNVc3UG5pZ3JMY09oMHRKSER2MFp5TXNJY0xtcTNxQ2Z6?=
 =?utf-8?B?Y2c5MlczUzYyUFZIN1h0TXVxNDE0WHI5Qm1MTFBzZnJtVzk0VjNmNXh6Um55?=
 =?utf-8?B?QklET3FVZ1NIQVJEWWIzaElMQ2RsaitVNWhGV1ErSk9mMUw2Vm5GQXBlcUs0?=
 =?utf-8?B?Qlh5QzVTUWZYK29TSG1RK0lNSzR1UktFTFUzUGZxVGlhaGhnWjZyblF0Y0x4?=
 =?utf-8?B?MmE4V1hsWHFnNUJuaW1FSW11L1NZWHFCNjBiMUFFaEN1VllMZ2loVHZYeWZm?=
 =?utf-8?B?UXo1dHdieSt5TTVOM0ZhcS9GSDczMlhQbThoMGxvR2k2Z3JaLzdYUnFQRU9G?=
 =?utf-8?B?VHBGVFh5d3Zwb2dBQmxseHZvaTd5bGx2T3MvbW4wQzh5TUM1UWxKRmtLcytG?=
 =?utf-8?B?VmhSZlY3aTQ1NWxlajJLUlZraVpJQWdJcDU2a3F4cWR0cnBwMGJJYVhkSVoy?=
 =?utf-8?B?NmdSa3dzcitqeTlEeXFxUy9oWDJ5M1paV1dueFQxWUdETE5XZFRlRjFRZjNP?=
 =?utf-8?B?dUJKUnR4N2xKZ3FSc3dWbGM1anY5Y0w1NGphZ25JTHNxR01rYmpDakJab0FG?=
 =?utf-8?B?VDBwcVpLd3dBTlhncWtNeWMzRmFQN0U5ank5SURIUDhhVDZQVjVYTGhMenZP?=
 =?utf-8?B?SXhTQVM3dTRMd1FFOWtuOUo4R1pCbWt3WTV2cllkVlpuQ3U5MUIwQnJDUm5B?=
 =?utf-8?B?dHVVanduTGhWZGk2V2xJUFU5OC9RRlZtU21NclFkYlE2aFl4YkJmMkR4WDZv?=
 =?utf-8?B?NXArczhpdjN6cGtTSlg5emlVdFZaVEJqYXZjelhnSnZGK1M3ajdZemFkcTB4?=
 =?utf-8?B?ZWRlSG9zV2JBQzlkaHdDMmdqb202QzdMSzB0emJZVVZpYktZTGkrNDE3bUhj?=
 =?utf-8?B?U3ZPOENxNlplcDIvQ3Y3bVdxNEFpSHdtbnZOQmtlOWc5bWFmekNSRlFIdTVJ?=
 =?utf-8?B?dUFqbEtGT0dva2p5d1ZRdlVhT1dtVDZqNDZSaXVKVG40ckk5Y01vT2o3Z095?=
 =?utf-8?B?dk5RWFBIOGcyd2UzZmZpZ0N1MlBNcGlyUHVtTXBlWlIyeDVDYlNSeERRWTNT?=
 =?utf-8?B?b3lKM2FBQjhwTHdLdGM2UWk5ZkswOTZmby9uZG04V043VW9KQXNBS3doc1Qw?=
 =?utf-8?B?K1BBeG5Dd1Z2UDd1QklxamdBdUpmcmNjZEErYjB4eU9mZktVaU1WM0dMdTFB?=
 =?utf-8?B?b3N5Uk5kZnNDdnA0Q29oY01UVnlaYm52UGN6UEdNWXIyeC9MQzhUcWQvVTVE?=
 =?utf-8?B?WnRKdHNva2ZoeVhrWmFsaUR4K1JNVkw3K3RmQ0JBV2VoL3NGQU55YjVGNXZk?=
 =?utf-8?B?dFZEaUEvV2JFWUM2bGg5bnlNSmxTWGR5OEdWdy9LNFFqeWxRcnd6RTl4NEY4?=
 =?utf-8?B?NFd4YWZVNmNrQ2pXbDc3RUVhQXk0M3BHQ2RRSlU3Uy9yVEwvL3BDRG1CNU1S?=
 =?utf-8?B?aGFZTnRsYWtITU5wYTdheWNKdGozQVoxUzBDWmJxQmgrS2JKUVNRQ2VPUTBk?=
 =?utf-8?B?cFo0YjduQ0ZkcGhsSENKVjlxZS94SzZhR2MwcVUrS2xHQlhRSEI1cHI5R0Ew?=
 =?utf-8?B?b25FbU1hZGF0dkNCN1VTWlc2VU1iM1JwM0Z4RVJEZ3VlRzl1a29DeFZFU0Fs?=
 =?utf-8?B?bjhVRllTT014MVNidUNEQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0a8f10-a8d5-4e14-c104-08d8e7cb6ac0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 16:00:13.0038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrQxxnrgdGTQQuBjuLAiHdJTOqDo0mjVZcNOsvDqL0OC/wDhaZtei1RI8M+B6a5M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2064
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_08:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 impostorscore=0 mlxlogscore=836 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/21 6:29 AM, Pedro Tammela wrote:
> This seems to be a reminiscent from the hashmap tests.
> 
> Signed-off-by: Pedro Tammela <pctammela@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
