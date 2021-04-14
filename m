Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B05035FD8D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhDNWDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:03:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45064 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhDNWDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:03:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13ELxcEs025807;
        Wed, 14 Apr 2021 15:03:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jSbTh3nrTonK4AOkzQJYhreD2kW8jxBb8bNNb6OmSQg=;
 b=hUjvyCDI4a+Nmkg18suSjKT4/br0b2HZep8Yn0mwGT1vkYqd48d+50mAjpSYfOuu83sb
 FCJnWN0OhQ4D4Ji3CL2yqO2mHcpwFaisINSEB6GrbxsyxshfH8YdTE0YNVi6YbmX/hev
 4cPQlvZyuqldN85JrJx/N12QscvwVkam2Mg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvcmm659-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Apr 2021 15:03:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 15:03:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hcinv2ej0/S39Mj9qwu9dbHi/ilYSOwhl0f5IYj2nuj/9RfdyhCDTLOl1ecva09cQTjXMcImvnx9KU8SehP1+Sy/0hpoahGiGjWt/i31bp5s2wt32RQFWmJAUMDEFvL097o4tMafDShOzw9df9y8qBzY5MCzoJ5Pj+a2N44IF8kD5u1xPiIYZshPVa2zgAKYf+v+IzhKoWPXwyW+qeyPFlizlu3do4roVE99j0tx2GKh5Sec2W1qwjKEMKg33lpkfJDGSvIvkhkIq1QXsmYJM2aIZxeTWGVJdLiwvEy9n4nVVn2UcDCRcbhRw1/MsdYRUgkC3gfaW8DOhsU281r2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSbTh3nrTonK4AOkzQJYhreD2kW8jxBb8bNNb6OmSQg=;
 b=Z+6UEeB3hfyFz+nFbvVtdlDbltVT7DsPAfmtbPUUD+xbFJWu2V562Delsyzzu56SMn2K+lTjGtmZ/wc2f+TatykyCeFQw1oDB8hkb/O7YBAe5RFFd3mQntPguZcCh+VrOzLtdme6krITYtXVZ2F6U77NZUikzWslRqr1turm65ifBjDftJAWAGVi0/dWb2jmQJscDDlDbvEfvJDs6H3es0vejE6B++UiEv3521W64QYZxa1VEnNFofSOgNvmP98Wo+V7q2l3TdgE0bBCdxvcYlGJ2TWVU7udkWtxKcRg+xxL+BM064oBnKLbNYNu1wBVaciC6ZHr3l3scXdGNrwLNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1235.namprd15.prod.outlook.com (2603:10b6:404:ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 22:03:04 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.040; Wed, 14 Apr 2021
 22:03:04 +0000
Subject: Re: [PATCH bpf-next 13/17] selftests/bpf: use -O0 instead of -Og in
 selftests builds
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210414200146.2663044-1-andrii@kernel.org>
 <20210414200146.2663044-14-andrii@kernel.org>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <538f25d4-d7e6-527b-bb9b-c08f42dd088e@fb.com>
Date:   Wed, 14 Apr 2021 15:02:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210414200146.2663044-14-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:62bb]
X-ClientProxiedBy: MW4PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:303:b9::27) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:62bb) by MW4PR03CA0232.namprd03.prod.outlook.com (2603:10b6:303:b9::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 14 Apr 2021 22:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c1f2487-7f76-4459-5e62-08d8ff9113e2
X-MS-TrafficTypeDiagnostic: BN6PR15MB1235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB123531CAAD545992127D814ED74E9@BN6PR15MB1235.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+eor96oMFUyEYBTWyr3LoIDDIoRcHSJO2QoOjxjX5swMufAdEA+UMMLWBiF0j2QD/JfeEEG11SBTGObG/sD1WcJ/Txtqh2p1zC/yj7PGTWbNxSIxCfMU1fSEFiCveICMocV+KBfnV7nHB9HoSb1XTKsf8+gfAQ5UA2rf3rZKVpBI/RWI4PCm4LV8tUNx1OECG0wjKiNuQLmftr+xBM9IL5QO5Sa8prom2O8O6q8Z00Fyel1e9d2K7IKcBe0cv70cYN2P/uhHNeeCWAlCRxhKG0VQJ6H69p+iFoVzXcD2Nme1APPRSQBd9hnuZLJP72U6RqUhZ9JoFn4LtlxWilDHZ4VuieKbtXCyozt5Coi+omS7H2YWmgcFmBsR0aQTrb9ybn9e25f3byQZ54PjiNZwZvS8gU1m/LEFZN5JBgrQWCWYHq4UmrR+o211PMshWNq9EYbZM7+Gvy23Q7A1j2PdtmR9NBqyeDOhqWmW3yiiS3aritIepuhFI5dDGo+XW+Ono1hHO+rcfEyY5kHAFXp8JS5o0+F4YgPOP2rlyWFzyMIvzhmc6D6eJi9Br6AubxJHHH8sF02D/pxmYgNpaaYPGmuJy1iDlDwei5sn7Oy9117tDZpygm1YkxJPE6NR5syGbohClLx8C24/K5AH/bjx/9qvy3kJxkCOBvvC2GfHhU0jxDV2z1+0X51fOppLgHE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(52116002)(16526019)(4326008)(31696002)(186003)(66946007)(2906002)(6486002)(5660300002)(83380400001)(86362001)(316002)(53546011)(66476007)(66556008)(2616005)(8676002)(36756003)(478600001)(31686004)(6666004)(38100700002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NjZXRWwvZ25GSkp5MHJYNTBKZDJxQnR6aFV4VnZqbVNSZ2VFT1pLRDM1SVVp?=
 =?utf-8?B?U05Eek9ldFhVbVFIbFgrL3cxMXdSWGk4MGk4aU15ejlvY2RKUUh2ZVRQR1Fk?=
 =?utf-8?B?N1lEc09YWHZHU0F2OHozVmRNcXRIOEFUMWlFMldUNXozMDBjbUpUSkE3OFpQ?=
 =?utf-8?B?N2lrSC8zZktHd0YvRmZLTW5KMkRKR1lRUXNLQ1h1OThOblZ5cVNKYXhoWHg0?=
 =?utf-8?B?OHVLQkZLN2ExQmxNYUIwMkR1ZzFqbmlScDBPTWNYaUd5SkUwTWNXV3crY1VF?=
 =?utf-8?B?dlVEckk0NThiV2s1cGQ5NjhZQkJLOG9BREEyUC9EZVI0UjVXeU9lWktWMDZ1?=
 =?utf-8?B?enNXRENTa2lCMThFRnduS3ArSUxLd0ZWeTk0OWZIa3hOOWdXWUdBYk1wWmM0?=
 =?utf-8?B?WExBNEpmNTFEK3VQcEVZcngrZjRVUTM1V0FROTdlOGZqWGFONVFaOVVWTFpk?=
 =?utf-8?B?VUlKOEpGWW9lazRtejdLaXVhbVFhWkkwcFRCQkdldFVydFo5cVVmR3NjVGtU?=
 =?utf-8?B?SjFBYmlDVURrekxXaHpxYjZxaHk1dmdra0t4TUJzdm1IdUUreXBUc2tWaDZs?=
 =?utf-8?B?VXMxWFptMUxGQ2NNL1MyWktjd2plUTU2N3l1QVUyVE5NZmZZT1U3c3AxMGw3?=
 =?utf-8?B?WkNpZ1RyUHI4TGNjVTZVMFd0NTNIL1NSUmM5RzJRd1dGK0ZQZWdXM05wQ09p?=
 =?utf-8?B?SEgxWDJrZXJyU1lQZ0N6Q0hWd016MHpwODNrUFJMMjJNQ0Z1Sm0zcWlvWXIw?=
 =?utf-8?B?eVRvTVVQcW8yRFY3QmtvY0ZaZ1A3bFdOaTFwQ2JzRmp2QU5GdytLODZUV0F4?=
 =?utf-8?B?Y1lNRDdkWFE4QTZTKy8xcjd5NTZkdGkzV2p4cFRxM0dVMFFzRkJqQS9OY2g4?=
 =?utf-8?B?c0dpRWZKZ3hNN0FrUFJ1L1cwSFYwUnpSYXU2NkVxTWxjQXVwMzlzdG1mbGFm?=
 =?utf-8?B?Zk9VMW10NUpEWUVRTGJoZkFyZjBSYTgvNWVLS2l6S0tDUUg0aDlDWWtyeXV5?=
 =?utf-8?B?YnJncDdCcy9TS21ZMjV2b0N0RC9kZXZZeURZOVJBdTFrbnRzeExBK0YveG1E?=
 =?utf-8?B?NkJVWmJhdXFHekwxelRqU0hLK3BLYk1pb0tsTnNic0JXTnh0bzk3TVE4L210?=
 =?utf-8?B?U0ZqNHUzZDhRN2xwVUp0aC92MHArbTdGRTlZNmo2OEs3aHZ4UUZyeUhuRXor?=
 =?utf-8?B?ckR1RVBzMmFpUFpWKzl6SzZuK2N4SzFaTXh0UTVPM3FPK3ZyTXp0OFBZMDZ5?=
 =?utf-8?B?cjhIOEtqS3Y2N1FodDFoSUYyUG1jYTU3QUdDeHY5SzM1ZWJxeXVYcTl6M2F0?=
 =?utf-8?B?UmhiK3lESGxhOXNyMkVGTmUvU1R1bnBrb0VRL1F3NTNmeVR2NENuMmhMdzA3?=
 =?utf-8?B?YzgyWlZvTTZ4eGdTVDZ6NFNqa09WbDZsbGdyM0hVckIwemFKaUhxaVE5bFdL?=
 =?utf-8?B?WTlVQzNTNGVrejZVWnRrYnN4ZENoendkSkhkNlhtY0FtVEdPVHNibUM0MXJE?=
 =?utf-8?B?NkQ3bkFaeldhVThpdzhYUEFTNzRDMDRUZUxvZU1zalRrbm8xV2tzNjZBQ2xZ?=
 =?utf-8?B?R21zYWpkSURpVE81NGk5UGt6QUxEUEVmZEdlVDJzTjJNSXpjWEVkYnpUWFl2?=
 =?utf-8?B?a1YvOGthKzJZT0o0Y0JnNDFnT3RDbDdYa0dQN1pTTkM2YlkrZUtIdGFZYU5W?=
 =?utf-8?B?WjQzTmU2VHR6WGprMjRGdE54U003M0UvZ0tYeWFQb1lJQzNqeTVlNGVuZFpE?=
 =?utf-8?B?YUY1R0t4U0lyVVBSZWZZZ1N2ek5PSmJGbjBPaEk4dUpuL0syUE1peGhxNHhr?=
 =?utf-8?B?ajZBT1dweUVaWGNyOWZpQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1f2487-7f76-4459-5e62-08d8ff9113e2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 22:03:04.2917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6kfKnTqDTDwkouuJEwdwSMEvg2ZZ+J1UNtSfHIswsbe9WIXERA5c1BK+cpni+vJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1235
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Z6_SOBNK_RMKywFxqKMc9J7vn3SSDWN4
X-Proofpoint-ORIG-GUID: Z6_SOBNK_RMKywFxqKMc9J7vn3SSDWN4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_15:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/21 1:01 PM, Andrii Nakryiko wrote:
> While -Og is designed to work well with debugger, it's still inferior to -O0
> in terms of debuggability experience. It will cause some variables to still be
> inlined, it will also prevent single-stepping some statements and otherwise
> interfere with debugging experience. So switch to -O0 which turns off any
> optimization and provides the best debugging experience.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/testing/selftests/bpf/Makefile | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 6448c626498f..22a88580b491 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -21,7 +21,7 @@ endif
>   
>   BPF_GCC		?= $(shell command -v bpf-gcc;)
>   SAN_CFLAGS	?=
> -CFLAGS += -g -Og -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)		\
> +CFLAGS += -g -O0 -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)		\
>   	  -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)		\
>   	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(OUTPUT)			\
>   	  -Dbpf_prog_load=bpf_prog_test_load				\
> @@ -201,7 +201,7 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
>   		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
>   	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
>   		    CC=$(HOSTCC) LD=$(HOSTLD)				       \
> -		    EXTRA_CFLAGS='-g -Og'				       \
> +		    EXTRA_CFLAGS='-g -O0'				       \

lol. so much for gcc docs :)
