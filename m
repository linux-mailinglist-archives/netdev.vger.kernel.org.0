Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947503677C0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDVDKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:10:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhDVDKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 23:10:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M3881l015012;
        Wed, 21 Apr 2021 20:09:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=udKgybn/PX4QF2d9Wu32iccNIsLaqR9RHebOaydD8g4=;
 b=U1ogferHeE3B2m7JOYhHFsZclB0LOjybukq8KuDW8jLcX8TxKPtMgv71sFaOS8MH9hqt
 h9r/1Htg44Mo7hyp84rld5HNPkvl2brm1+FRQAplwPn4pTsGgqKoF5x+GsmnyQOyCeKB
 Js4ACRYCqt1OHl3/45rQXCH+rK30ebtx2h4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 382kqnw56q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 20:09:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 20:09:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neSiyMi1xUkG169QfcQWIDAcJRS8rhzyRA6ynhtXa4tjhMHIxQNBCU5vc0+7SAq5Syz5Sr6NsIFnjNyLjRSBcti8xq8QYUhiaZ0kCb7uvqPGjbA7fmK3r2iYLptulJn679XvXYV/VtY9SWV/DTnnl3+4uMpeYiWTkgzWKbcSGNQaYhvIQDmnGHza5JED/XQDBHnCC/r1SZOtXUCepSV57lCqFDQiotVcPKdg7lZdnsS1p3cAKo791qhA6SvBgIsEZYqG3oQ/6kAdxo+ffJddLNxgBuRIps4JPyTF/5s1Tt7v5+cKe41VADaXR0vRVMM2eX2WOJuqEfXnMrxwMpSMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udKgybn/PX4QF2d9Wu32iccNIsLaqR9RHebOaydD8g4=;
 b=Un0LJda3fo7t0isQEnuirfd5fngqFDJEG6AwlLfmp/QRwVj4wXyehsTyE3MHGwQyzbK3CRmjhnOXaWMdlYNlzvR8fTOUwaBdYoZ0i4eh51wjxdNAm/o6ln0QQUIaXSyeZhqmPJMRd1VmgMl4n3YBL2jB+E7kIL/uDEql9D4ywWxJYpwwbZ5o/6r1sUfNPw8eIX0yyq+xHEKp1TQsArWe19NF+IziZN6YkxCnL+sjf/21KIz2bAm2fQKmS9BSLAc3AxVijsYP++B4rnxOFiKGijIQSVhXpIM9heowBppe2c8fB+aMZDnsfbvNdyPBpjK2G2CuzDsutEs1br7RSikdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4498.namprd15.prod.outlook.com (2603:10b6:806:199::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 22 Apr
 2021 03:09:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 03:09:35 +0000
Subject: Re: [PATCH v2 bpf-next 02/17] bpftool: dump more info about DATASEC
 members
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-3-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <35749ecd-39aa-f09a-8eec-7afdbecc425f@fb.com>
Date:   Wed, 21 Apr 2021 20:09:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-3-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6133]
X-ClientProxiedBy: MWHPR19CA0059.namprd19.prod.outlook.com
 (2603:10b6:300:94::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:6133) by MWHPR19CA0059.namprd19.prod.outlook.com (2603:10b6:300:94::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 03:09:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc9d59bf-0edb-46e8-6b07-08d9053c0eb5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4498A759B5EDED08CA9B0398D3469@SA1PR15MB4498.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGjSkJ2mhf4K7UoqCrO1V3kuJqREhD4eX0PmqlTrNQaQjlZNkGVipwjW2UypUGsW5mZSOXgiq9x3btRsSF5GjwnaG4EmGTbJ9k3d4Dj6FwVvmfJ4w960hIZryGXWq1ZKdWSneJ360UqxdRwumn9+FMy5WcCj4jPGe7nwoCiCu92cZyEr3qndfiuzXDONlEJISac1gOK098Qcve1ZIOoYzdV6IMngdbyyUmLwdVAqxv+3SREUxBLa72wd4zx8/WwTskdc14UuNqqMNK+6U8QqOyCNzK4UoEBX5UvCMJmlIfXWxop/buVy03rH8BLh6C9U6ca9ttKPJsn47BfuWGiWSyG798Bzo75Os/3pJcFRPsJK2f8HsTTDx7jaRh21nZnZ29z/Mblafjk8MorkaBciW0N3SRDa4Mm+EnwPet4uckRwGCtQwreF2TzolBtEryEbljZiYGkfQIcN4pSrzkN2D0FBGV0ak/RZvbRtLXakOm0fCsowbJOGVXGDBAAgXUNKXLk/9PcncMCUvaI/bRsEvrS6yHiKwgVvqOAGx0CF3DGV/sG1iD2tWcu60lMbAfpR0v6jr7IFutd8X3Om3te3XJ04DE2ZAHiuH5tT/USvFaOLfRWZsrA1o/Wy5N3RcP778w0+4Y5rlWtDrpshHZ57RrLyXlmFGGLLKeWTDqTeiyOSXrxKCAsKiMNolBIuFqJm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(66556008)(66476007)(66946007)(6666004)(478600001)(38100700002)(8676002)(2616005)(31686004)(8936002)(16526019)(53546011)(36756003)(52116002)(4326008)(6486002)(186003)(31696002)(2906002)(86362001)(316002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SkpxajBSZk5jajk1UWRoZVdZeWx4Slp6Ym9DYkxVUE82RGpDWTZBbzVBQmVQ?=
 =?utf-8?B?STF6aEcrQitQeEJJNUhjaldmRVZkbjJMdEtwdlR3RVA3VXI4UkFjenprRTBj?=
 =?utf-8?B?bUx6VGxmSy82MjVqZGRyaElYRGticHYxMHpoU2p5TXV4UXZqVEF3dStaNmFo?=
 =?utf-8?B?ZlZVWFRhMEYrZGpUQUwwZlM1UXRvVzd6TzJkbU9BdkdnWFJVaTNrU0phS050?=
 =?utf-8?B?eXN1TXAzSDVVTVJtTHZWT09Dci95MWlKTXVPTXBnM1Z6UXlRUHBLR3ppTVVQ?=
 =?utf-8?B?K2VlZEZ0blRyaC9jTVpTcEtlK1BzeW1maWRFWlc3RnY3bUJrc3JhdWtEbmZB?=
 =?utf-8?B?WTMwbCtNVERlaVhVR1FIOEppYkNtUzQ3TjVLWUVQdm9Nelc2Qi9Ib25nUlhk?=
 =?utf-8?B?dzZaM0NvaC9MVDRsR2dyQ0RvY2dDVm9BdmYxZ0tiRWVSOE93bE4rL08wTFBD?=
 =?utf-8?B?UUYyV3pVM1hwOFZ5RTFuSW4yMHQ0a21QRUgxd0xMU251RTgyTmhPZUJLMG9K?=
 =?utf-8?B?UjA0TDdKbHZtOEg3UkgxNHFnSHQyOC96UXExaEVNcVI0ZWNkNmNMeE11enQ1?=
 =?utf-8?B?S08vZHZrenBtdGNnN3JMWnN5THp1UWtYOHRTdEFsZVBRcXcvaFR1dkVMNkh1?=
 =?utf-8?B?K0d2QUVLVGJBZWJIeVlQdUtSZlpyazd5TjZ3NVhNdnJseWl4eFNyTDN6M2sv?=
 =?utf-8?B?VUptZmFZbHgvVXBrckdlWkUxWTYyN3IzaHQwdGdackYzdGwvZ21ONXNnakhP?=
 =?utf-8?B?b0FTUWRnSFJab1RFODNsTGdveUM2N2JzUnc3RFoybVlzdE1Id05mVC93aXQr?=
 =?utf-8?B?TGhnN1RIVFpJSlA0U0xGcDZHYVJyb3RKQXhPMzlhWjNrQWFhUHZyN3hLT0RF?=
 =?utf-8?B?TEhFUHlBR2R2RUNGTUlxb2dUY1Qrelg4b0UyRlkxcyt2MzE0SzdteVZpY3Jo?=
 =?utf-8?B?ZDZvSzFMN0wzeVU2ZmFzZjZzU1FzR0JiVThYRVlEbUxPLzE4Q0tIN3J6bnJL?=
 =?utf-8?B?VitCaGprajdXa0FXRXlmTmdhSU9JdmxrUXFiWEJyZGVLWjNidFZ1cko5QlB2?=
 =?utf-8?B?cktCOTQ3R1hBbHZFaU40c3BRRTFjZU5LWXZCcitlbG1qNkk3YTdzNFR3Qkgr?=
 =?utf-8?B?YTdwVmpYSVA4aVlJTzNTTkdtSTNndVdxSWRIYW8rNXYzWHBOcWhXUDUzMGRG?=
 =?utf-8?B?OW5wT00vMmtDd0Q1UjlwMU1IYTJvdnFneVBFNmw0ZnpqOVhiTmN2RTJWdUdz?=
 =?utf-8?B?VFZKNVc4d3dHc1pDYTlPNnp4UW1rcHJwREQ0STVaeU5BeGFBZXVEajJWU3c2?=
 =?utf-8?B?RTczby95SStGSWI1NzZrNnBZWGptMlBkRmNqTGszalJoN05NMzZ4MDhSQ2J0?=
 =?utf-8?B?SnlwK2RNOG0reVVrc2pDTSttZzlyY0lMOFBkdEJLVWhXQzlJOTdWcXBxSG1G?=
 =?utf-8?B?SXRkbk04VXNSYlJkd0h2YjZKb2ZpMkpsbnZOaDdaV3haUCtlVEc1VHRhTzR3?=
 =?utf-8?B?dEVURE0vSEhjOHl0elpwK2xsbldhU1gyam9kajJJRXVRTXl0WGVMby92NWN6?=
 =?utf-8?B?bVVINlRWb3J0MDJzcW5zV3RqTlNXeStHTWlJcWV4aDRRMjNvN3Y5QWVBUkg0?=
 =?utf-8?B?RXJnZmhYWTFWUzJ3SkFRVTRGaWozcC9FakVMdXZ6eVRtYzVBQnQrcXlzS0p2?=
 =?utf-8?B?dTN1L2drWjRKVklEa1pOY0YxVjlpcHNWWFFaL2hiblNrTE91SDVKbllNV2Fy?=
 =?utf-8?B?aGE2WGtucXVBWExlRGZhZlorVVZTNjh0SzBlZE8xeVpXcFNXOW5mb3I4Yjlo?=
 =?utf-8?Q?evaQzmHwZVXFAY+jVQ0POb5wYyBY0H4ItJH6o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9d59bf-0edb-46e8-6b07-08d9053c0eb5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 03:09:35.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1d42G/A/uvschWKBxk8e1DAycaeFxaCQs+Z6VuuviMC/y3t2PHqY/852uEgmdtQS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4498
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: eKUNewiS_ezvuNaHZQlr6-MI2BjV3d71
X-Proofpoint-ORIG-GUID: eKUNewiS_ezvuNaHZQlr6-MI2BjV3d71
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Dump succinct information for each member of DATASEC: its kinds and name. This
> is extremely helpful to see at a quick glance what is inside each DATASEC of

This is indeed very useful and user friendly!

> a given BTF. Without this, one has to jump around BTF data to just find out
> the name of a VAR or FUNC. DATASEC's var_secinfo member is special in that
> regard because it doesn't itself contain the name of the member, delegating
> that to the referenced VAR and FUNC kinds. Other kinds, like
> STRUCT/UNION/FUNC/ENUM, encode member names directly and thus are clearly
> identifiable in BTF dump.
> 
> The new output looks like this:
> 
> [35] DATASEC '.bss' size=0 vlen=6
>          type_id=8 offset=0 size=4 (VAR 'input_bss1')
>          type_id=13 offset=0 size=4 (VAR 'input_bss_weak')
>          type_id=16 offset=0 size=4 (VAR 'output_bss1')
>          type_id=17 offset=0 size=4 (VAR 'output_data1')
>          type_id=18 offset=0 size=4 (VAR 'output_rodata1')
>          type_id=20 offset=0 size=8 (VAR 'output_sink1')
> [36] DATASEC '.data' size=0 vlen=2
>          type_id=9 offset=0 size=4 (VAR 'input_data1')
>          type_id=14 offset=0 size=4 (VAR 'input_data_weak')
> [37] DATASEC '.kconfig' size=0 vlen=2
>          type_id=25 offset=0 size=4 (VAR 'LINUX_KERNEL_VERSION')
>          type_id=28 offset=0 size=1 (VAR 'CONFIG_BPF_SYSCALL')
> [38] DATASEC '.ksyms' size=0 vlen=1
>          type_id=30 offset=0 size=1 (VAR 'bpf_link_fops')
> [39] DATASEC '.rodata' size=0 vlen=2
>          type_id=12 offset=0 size=4 (VAR 'input_rodata1')
>          type_id=15 offset=0 size=4 (VAR 'input_rodata_weak')
> [40] DATASEC 'license' size=0 vlen=1
>          type_id=24 offset=0 size=4 (VAR 'LICENSE')
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
