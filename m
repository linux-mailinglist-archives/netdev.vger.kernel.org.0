Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A934AC84A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiBGSE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbiBGR6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:58:39 -0500
X-Greylist: delayed 814 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 09:58:39 PST
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B438C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:58:39 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217H9fR2023825;
        Mon, 7 Feb 2022 09:44:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4wFMvE2QGNnFKwTdO+C0Ws9LFAvRt1M1W/0FfZxU9fY=;
 b=OQwHteYjW8T9Q8thEoEAcsG1Sr1Uj64/TqJAVwpDVpYVwNE57oRrd+cagZPXJIPT4+Um
 fWRvVhNyKM/fpdK0i7FMOkyOZzsV8V2EV3BfQCkFftnS40L1DSb5xAGaxXJ0PzOmR/gb
 Hqp8zSn/B71olHdUQMA9Zx52YKexdT0RfyE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e2sxm4kgv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 09:44:50 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 09:44:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKygfFxAgf+ky8bN/Q0kweqAYebmb/0coirb034pPiUMGFaRQtk/bLZx1otSRgAl36A0WRcBwZ6Ty9zmm35By6Te7fi5MzhWZka3qNrWbrg7zLuLLfma4MVnF7zo/mhTn0w+bn6/yuy8qi58Cbosssk4i0k48Y9Y1OhxSaACFIBUbuVmgfafVgz7e6b3NBY8ODLwhPmLwzH/bsFDhlTA33WU16MTscvchKlE2srnlNFlTKAmeQ9WJoHQOwsaFLDkI0jYcvVawBw3xAM8ePlP94ssqu1Ni8gQgpeoO9/JzCWaICYBSUMRsCibAx5rfw3qkTRQ6yoG93t1uQUAtJ3BCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wFMvE2QGNnFKwTdO+C0Ws9LFAvRt1M1W/0FfZxU9fY=;
 b=YFTuKGF9MfgqIR1JiZS09jKuhpICBzkvgf0Xnimb7b0RZTMoyD3nHLtN/U3UZFsI9jXhmvXkKIpx/Zjh5VVu+dcW7GiQtrKXSLYI1yQzSTTt5bj3bw/lbOQVz0DLtpakXokh4sqmSbVlZLIdMulVc5Yo//P+h7DkkWCzjrbTbIvXfm5xQYFbv7MwgTt4QPwdl803bQuWLr5BmGpu/3TcS99gXiBkLXSTK1VzFxj8EGAL8bJtMkeMa8bLF3AcK71k4SLId1m8EUMRUIzflzHM4vOWtFVSWn0d2fjzaDZxDmzv1rsmzU6tBf5lZY6bRlN0/wtGefzEBcjLVAHnKG3kAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3887.namprd15.prod.outlook.com (2603:10b6:806:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 17:44:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 17:44:46 +0000
Message-ID: <9b89ac02-de43-10db-816d-4f4888e71a80@fb.com>
Date:   Mon, 7 Feb 2022 09:44:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next 2/2] bpf: test_run: fix overflow in
 bpf_test_finish frags parsing
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <20220204235849.14658-1-sdf@google.com>
 <20220204235849.14658-2-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220204235849.14658-2-sdf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:303:8f::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d43c6b98-07aa-4beb-87b1-08d9ea6187eb
X-MS-TrafficTypeDiagnostic: SA0PR15MB3887:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB38876A4BB472E75CEB34DCB6D32C9@SA0PR15MB3887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TzL2cERmcyk3p3GziTYfauIK5Z6wjl18LY73msHDB45nNKz5z2n6d0oKGesDmh4wognIhUn3wKA0HCXFToT/Y+TTFYmt/ktz8/Md4sgOurN8GcvSzr4f6ZsGUlv386Mkq/HndB0mao++KUR8NdzLowVoZI7N7YP2O7q8YGGcQjc1meFEBjbYLjtVYzfjsidKkbRdk7iivFjJghvo0ykMCDNYakL5obVD/rukOcpE5szr4zogKboLaJfCWjdwOjWoTSuALOFqqeoMaezEx5gccyBMeXX6ON+K2uqtu5rhib8hgJLtWPDqR/V/p2JOtBz1nDGaL080ppQH86sJD7C05i92pNcQ/6Z6QdpjemsqBtdetKebOMrzGQd893xzL/eTW1WaK9NGlUBtm0Hc0krObpjyo6LmsLXxTkG3k1sWEsElttDCTF1/Zxnh5dpgx0tP3yjyaZOlKXIRF1FbBU5v/9DlJnGPCOMsFdH77Cshh7p80fCcS7CDDZgcv8Je3xur8rjs5dH5b+jggTABSucXJLF5QZ8QaTmz7eapCJJUauzqaTV8OP1PsL8WKHH/jsIZFSYkDeh/KtJ0BLvt8zNuYRYog4+1ZV8DQowkdnUoOXoMK4iBTDx0v8lhur1GksK+faFtyAeDaDJ/RKTtvYGyjpgTyDuL/o5SmNIB/Mqipd9QMNcBQ7LqM2xq/4ddWwPZOp78bwginesmTnT4U3o6+3Ow82Tv+Mio/ClXzFcuRm1ihQ8ut29L8QyY+MJXNEj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31696002)(52116002)(186003)(6512007)(36756003)(4744005)(5660300002)(53546011)(8936002)(66476007)(8676002)(83380400001)(66946007)(4326008)(86362001)(6666004)(6506007)(2616005)(2906002)(66556008)(31686004)(6486002)(38100700002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE4veDVBT3g4ZlNuN3ZwSzlSTHl6bGhSSVFUZVJvQ210bzBJR3daVXVTbXd0?=
 =?utf-8?B?SVVBTzJWME5MZGxCTEVsRm92REF3M0FMNDdGT2F2TGNvUXBuTFRWZEV2bHJX?=
 =?utf-8?B?cFVJeHRuWi9heTdLb2Ficml0cGllSkpveGFLMmhUbEs3Zjl4bzRVWEhwUmNS?=
 =?utf-8?B?Tk9jTU1TUFpWUUZtWlFMV0VSbkFnM0hmWnBENlh5UkZKR0FaMVlJeXBTQk5P?=
 =?utf-8?B?RmRIUTE4dEZ4cllid1FPR1dmdFcxSGVQOThsaEZ3WHpnajdScUV1aGh6bFRX?=
 =?utf-8?B?RFJlaWVjYjZyYm85RDI5VVpFVkV1a2RVYzdSbGNzaFVoTGp3NmdVeGdsQXNn?=
 =?utf-8?B?UlZKNFJSRzcxd3JLUkc2TlBVQWUwKzRSYXVJdnVXQjByZWMyYnBYSmVCNlhv?=
 =?utf-8?B?MGVodGlLNHVtUGxEaW00dHhPTTRoOHZZOGI3Q1VLVWtKQ1Vva3pVYWVhT1RI?=
 =?utf-8?B?YjJkOVBNZDZpZU9CRGgwV0R2RU11bWI1L3V4blp4bnV4Z3VZY21HMHJqZ01E?=
 =?utf-8?B?S1hFUVovUTNkaCt2NitRNjdrdFowNUU1R3BLTFltQjNPYmRzQzI2RGQySkY2?=
 =?utf-8?B?ajZDZDBhNnVwaTQ5SXFtWjRpc0lRQmtMQWJpNGxFbFBXaG9hRkk1c2twbG5V?=
 =?utf-8?B?RGlDcU5DRjEyM0FyRHh3WDgzT1dHTkNlbWdESmhnT2J4OC8wRG1SREJBZDJn?=
 =?utf-8?B?azJjY2V0L2tHWDlrZWlzbXZQWnVrMWt1SzVGSWJlYTI3ZTFvK2tKYlRIQ2R3?=
 =?utf-8?B?TVJQY2JKaTBkalBqbWRGUGExV1gvU3krK0k3MGRkNWhPaS9CMjFGV0Z4L2k5?=
 =?utf-8?B?bmFiSW5qSkw4K2tZTmF6RVF4RGlvZ0pLQXdNSTZqNi9oMmR0bCtlajUrQmZS?=
 =?utf-8?B?L3FVWXkyaDZOQ1FQbGpaejJ5UitQK3JIWTIzTTI5c0sybWV5QkJMY0h0Lzla?=
 =?utf-8?B?Ymt6V3hPT2tyUjZxV001SXdVcUNoeWxkekZUZlNORTNXQUxORVZjbTZQMkZ3?=
 =?utf-8?B?bHRzTnJVWGtETkVVZytRcFV5MUtGUjNYTGhkeTlnZXZhYm8yK0I5dVNMVU9m?=
 =?utf-8?B?UmhGRlNhcTQ3enk3L3FXSyt5TzI4clJXNVNlNEZSdktuMm5FZlhtZW9UNHM3?=
 =?utf-8?B?cXJJNXh3S1FJQjNHZm5PQThHSkV1SHhWTklvMW53aUNoWWxGN0o0b1NQbjdU?=
 =?utf-8?B?T2FzMEZtWFBsZDNFajdqTEpVOGgwNVpLbU5zeU9tdGo3Wmd5Z3ZBb1MzVXBj?=
 =?utf-8?B?LzNYNEw3NDRScnJUTEE1bGtlWGRyTVZWNUlmTDhkMjU1akR3RzNJSUdtbG5q?=
 =?utf-8?B?ZklkNVBROXBQeGR2YWM4enZMQjJRQm9xaVBtNVc4SGVoMjk2aWNtVFV5OVph?=
 =?utf-8?B?SU9BWmtCTW5ZdjVmbHYzUm5LelhzbEhNYTBCQjlCZXRPTVo4MFZpVEF6c1kv?=
 =?utf-8?B?K3VRdWxGV1JmdFVIeGxPR1pHN1FnTkkvakhsYlBXZXNsaHRjRVFCNzViamV4?=
 =?utf-8?B?SWtlZW91UnZzK29YS2JDcXd6cStpRHN0cEx4N1czSjF1YmRzcTFPMFRuR25i?=
 =?utf-8?B?VStOUUQrKzJQQ0FIQldUc3lYN21PZUNLL1ZSSXdjeHpWQlI1WGlLK1VVbUE5?=
 =?utf-8?B?Sy9yUEtCdHE4UnBGL25BaGJOazgxQjJTZHZqUDFveWtveXI1MEhIYkhWUGRw?=
 =?utf-8?B?WG5nUVFTU0crWVdqcm02QTV5QTRIOXFUQUZ3UHpFVDJYYzJUaUdMMnZyc29M?=
 =?utf-8?B?UGs2end1b0MzOVhzZTJEZWx6T1ROZjZCTXlWWVNuMXhCMlJBQ1dEQ3dubzlo?=
 =?utf-8?B?anBCODJ3RENrNnRyeGJiQ1doUGppZ2RNV0s4TXg3UWU0U0wyS0JaSmNlb29S?=
 =?utf-8?B?dTcva1hUS2VwL0ovMld6WFlvQWxUeVYzMUl6M1dyT2pxN1pjMFVvd3dKOFdG?=
 =?utf-8?B?RUcwY1doZHFpTmUwcjJhSThKbXVsSk1tUzZ6MEE1TDhQdWNWUU1VbDJtTFJI?=
 =?utf-8?B?cjRCdktkc0pIY1pEdFNFRTdodEFISEVDdnVEQUcwN05qT2h3QmVVSy9DYnQ5?=
 =?utf-8?B?eWM1K29LL2lzM0g1QUU2Sjg2S3Fka2M3QkZ5L0tUTS9RL2thS3BGYkN5L3NP?=
 =?utf-8?B?RXVXaHNOSHlmRERnelZnUHJsTmZrN1hIS0p0YzZhY2F5RDBqWmdtbzJzblJ6?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d43c6b98-07aa-4beb-87b1-08d9ea6187eb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:44:46.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+uABcJZ80Q0sKBw+/xgXU/+2QUb88sCb4A2lWKwZbYdry7oHBGDsl7Ycqem24kw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3887
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: QUEZ8Ofg-dXZpS454nL3lzp7UxE5XMPq
X-Proofpoint-ORIG-GUID: QUEZ8Ofg-dXZpS454nL3lzp7UxE5XMPq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxlogscore=866
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202070110
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/22 3:58 PM, Stanislav Fomichev wrote:
> This place also uses signed min_t and passes this singed int to
> copy_to_user (which accepts unsigned argument). I don't think
> there is an issue, but let's be consistent.
> 
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Fixes: 7855e0db150ad ("bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Agreed that there is no actual issue as the 'copy_size' should be small 
here (<= maximum skb total packet size). I tried to add 
-Wsign-conversion to kernel compilation and saw tons of warnings. I guess
we have to deal with case by case then.

Acked-by: Yonghong Song <yhs@fb.com>
