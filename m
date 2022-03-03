Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C744D4CC4F2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiCCSS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiCCSS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:18:27 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6097E5F64;
        Thu,  3 Mar 2022 10:17:38 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223DXOTY004268;
        Thu, 3 Mar 2022 10:17:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RRQKDgfReTJr2uo8Yek+V7ehVKeKU/ZPmh/rpUeWXbc=;
 b=Ysk6ISFOLm3ADz5X98jt3czaw1pFLngtyvn6+Eh38gaviJyWFgx8i08BmHyNKN8TwoyW
 EQTu6zXA4XEvxBqjSAHu3VEuq4BEWPciidQnwS1OS6VFY2ABw2DOkPFtzfUoEQ9SRD9B
 9DriE2bBw7i4237oJ9eERh5tW8Eqri3C9/E= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejxnma433-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 10:17:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCQWVhNDZF4uQfmWuJkQ81I6VZgd6yKBCPOTWEJ02siL+10QKG8i4/UqeaOTMbkSsagexMCa2/Cz93J0YtDPYM2hh6w5oHjdHEV1BZTvBXhj9hET4NcSkHmyWz5RYf7fP1IKuAWDbfqSQZpVfkOJfMSEHqUVdqaGZGkm/1q6ULJElRfLA3OVLLDNgsx61tCdVw3VhomQWxjzozpwIhc9RN/rkKaKlUNN+BSreiV0V0h7nV8ZgDorUVyQ78VZrDm+jqIxJtXOkS12vsUUyQ6VLrQzepfOhq98v2H31jetgp5X5D/eL0tOjF3Ht9OkDLD1Jm5nlVL92ni0kewFLwmcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRQKDgfReTJr2uo8Yek+V7ehVKeKU/ZPmh/rpUeWXbc=;
 b=BT4XG2au99EbJUjINtvrU5IUqAy0Rt/8GW2O3e3G1Z/2288StJ9xL4dqMdDRhDlWsKVFFRNAHy6ISuzg+z+IzbeBRh6Dp/DTvTW/Ei8WdHcwXJWgMFkl5pT9bryL0ye0pYXCkV3s5rD2XvlBiBQ+1Cqfo0j1L2ZPnW/7iifmQ6YMMxxAn2l2dEBSAda3sjWbgyYgLETIX54qpqaxk98bucz2I1TBq1dK3SkOz9bWK9EcGUj1d4Fh4tRHTPRWkvvsuuFgx6tg4cSWviOY1OB8tLZf8SVcdnz/TrV5CiujiuJkoMW1L0NrHbQUCMbDeDO+YEBn/L2JaiIZJ2bkX30Z8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1307.namprd15.prod.outlook.com (2603:10b6:3:b6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Thu, 3 Mar 2022 18:17:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.029; Thu, 3 Mar 2022
 18:17:20 +0000
Message-ID: <e1e060a0-898f-1969-abec-ca01c2eb2049@fb.com>
Date:   Thu, 3 Mar 2022 10:17:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next] bpf: Replace strncpy() with strscpy_pad()
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220303081800.82653-1-ytcoode@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220303081800.82653-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MWHPR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:300:4b::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6beb0dc0-a62f-47da-a385-08d9fd420ebe
X-MS-TrafficTypeDiagnostic: DM5PR15MB1307:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1307862D2FE0F6A7B8C0A548D3049@DM5PR15MB1307.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2VEkpkYPEeu4QcDMlP9spfILvTg0/15qASPBCYSUKvgyWW/siPQ9WCRz7A0AtFk2EDc/sDcI3UZ7OYE46QAsoKk407XzMBbI2AVLkiCSQsbnUd4E4ls2BRQoSGNJ9oIyOjdJjnEZlfBEebbaLr9xgIoXxW8OsdKWyPOzdPw2d7Hd490lHwh/WZhgiHiQu66ib4mcwa6DZQ8uhGrbz4QSW50RoTQyKEeF2EuIfJpKwsm2wyrUhydxy+uD+FnypwilMxusjHHji8s0uX2abfJXdzprM8Yoo3eLdtBb/WCn3GAa/OpHcfRpnyUEcbTfx2TTSmhktt6eKRLMvVNdypfjl03legifN2RerXSd+5jcoBJ6yEE5cWvgo/S1pZN04DeWwPXBDvhQpMm1Uka3IgDmX7M7Aq+2aw0GQjkEo9aqZqYf0i4JnkpJ+tMroNx3PopGooIctob3qaBFdRZzT6vYeChj2yTbPzbYV1dZSDAZXVAe0dxEA4YiaCy07r+uekaMdosIFXeqHS5w1MKq/o5g/7zLMd6x6zYLme420U6PLN2+7Na11Nu7Zf7rQMmjqthUVGBdyBEfqb2WG26F5gxZojFNsr9EjOVFE+dYq/muGc9/haVE27+39eW+kNyYBzP3pElzmFET0fkE2swrrZ5g1iDVZ13c1V4gQ/Moromxz43UJTnHLutJRMlJeUGmbBu96ODf3L5PPrTfwb5hfxsvnvZTsecrorHRe0XlkwCB6wyKt5CZfjKdno0q9p2N+T8LeU/VQntgrAn+NA0RFPI+K0eSQjO+OcXaYTx0VnIGWzPiW2v5M3hQbG7mCXCG7+b4C+ip8+pPyxGRwX8Yh9yzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66946007)(66556008)(66476007)(52116002)(53546011)(6512007)(966005)(6506007)(6666004)(6486002)(31696002)(2616005)(31686004)(316002)(8676002)(54906003)(4326008)(8936002)(36756003)(5660300002)(38100700002)(83380400001)(2906002)(86362001)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1QvZlozUm1HY2RwS0x6OThtSHJodVBoZ1diQlVadW5ZaXdIYTNNcFY4YVVG?=
 =?utf-8?B?N2tZc1JjRW4wODZWN0ppV0h5anNKdTBZYUx5dHFRdGxJakJjUXgyZEVOM04v?=
 =?utf-8?B?TThVYzlwNzFQeFNBMlRnZ3RNM3ZnY1JFZXNVclFORmdPb2NCZHpyaERTd3Jz?=
 =?utf-8?B?V0NBd1R5dk5VcFdPOE1vQS83bEJhUUZoNk53dE5GM3FrcmdxalR3Q2hLM2FJ?=
 =?utf-8?B?a3FGZW55K1Z4bmlmUmEyRzZXNnI5cUlFcWJ1eHJyWUlWU3l6ekhOMmVwMXNt?=
 =?utf-8?B?d3ZKZGNhanl2Y3JmR1JxSG9pTEhIOWlsTXRWdDhsUC9pZlluaGY2VE44d1hs?=
 =?utf-8?B?OWZLWjNPdHBPRXdYZmVsWUc4STF3UFljbHdGZHFIbWwvbWFVZ2dwZy80Znoz?=
 =?utf-8?B?YXBTWDR0eThmaWFhNU1oKzV4UU4wS1IyUmovekNGWjUzRnQrclBLenZMUFNC?=
 =?utf-8?B?QldxdHJ5RUlVaU42QWJWYlg3VU10bURyY3VvVGxNSWhsSkgzV3pqWjFCOG1S?=
 =?utf-8?B?bkh0RVN6b1VEaW4zWVRWUG5scExTbVVSeVZSR2tXeGVHSUZUMUxOV2ZRQWhL?=
 =?utf-8?B?Uzlwb2k4MVhsemxKVFppck1Ybkl2c2ZnU0c1K3Bwb2U1WmNkNjczY0pUMGxz?=
 =?utf-8?B?aHNUMSszV0drUmVqSXhQYW1BdHFLTUR0bjkyazRia3JzSjVFRWMvTVo2RXBF?=
 =?utf-8?B?dU03UUxWQjh5VDFqTnpuMjdGcjBZNDVOYUtSVlVpZ1FzU0xnMWZybEdlMmZp?=
 =?utf-8?B?bkRhc2FZeFJuTlp1VHJzaDZwSFE4MWQrR1pRRldFcVFUUU1OZGFuV2NQVXRG?=
 =?utf-8?B?MjJhakJZWDBqVlQvaHpFSU4rbGRObXZReDRDWkJjYnF4aExXMkFuRUpldzU1?=
 =?utf-8?B?SWpsZ2hYKzkxNEd4MnBqNFU1YjVsd1drc3BoRDJrOEpLK3ZhTFpSZ2hrUUNR?=
 =?utf-8?B?MXAyZjhleTN1VE1hRGlRcDJvelN5Y1pjZ1RzaG50dGhVbzNzZHhjcXU2cXcx?=
 =?utf-8?B?T3BYY1hSSW9MdzAwektiWDU2NE85RjBXME85TE5sUFNvS2U2M1JiWlhhVmpI?=
 =?utf-8?B?T0VoNUwwL3l4N0tQVWdMVXJsS0tEWmpvbVZmakEzR3RMUWlkM3JjcFF4SHVK?=
 =?utf-8?B?L0Z2TGFGZk9FaUdoTWRwUGdwK2c3MWk5R1FibDl6ekdpcVVUb1JaK0I3RjYr?=
 =?utf-8?B?c3dmaFMreFFPaUtQOXZ5Y0RwaWdNVjFDSFVsTU0rTUlWcjR1Wmo4aFZuYXZi?=
 =?utf-8?B?S0p6cjBVSHBaR0IzS3lkVGdEai9KdXBiOUZ1ZjExOG50SVlnSGhlWENLdCtp?=
 =?utf-8?B?M0dqcFk0UFFmeDAvaUc1dmdackg2ZzROOWJHeGhuNWd6UFI4SXVMQWFHeXRX?=
 =?utf-8?B?Sm91cjg4LzhWLzg3dXJLM2doMGc1OFBhNFo5OFV6S1UvUE42aURaNTRnaFl4?=
 =?utf-8?B?ekNqVk0ybjFQek0zQU5aOTc1VW5acnZUcWgvTXAvazF5N1NSeUdTbmhxd21z?=
 =?utf-8?B?YUdCNlVDMll2NmkvRW5EellHamdUb0dlMzlqeW1FanBpUDhPblJqc1dBRi9z?=
 =?utf-8?B?SytqVm8rQ3h2MldoVVZKODkyYkExTTcxUU1kT1JLS0p5aUE5UXBzMDl5YnRM?=
 =?utf-8?B?a2RDckNZMVR1MzNXSWxhYjRJa09RRzllT1UzdjQxUmhmMDRkdTJwZFZacHpu?=
 =?utf-8?B?SnZZdnRtNTZuN1pwVWFiQXRROEZub1dMZmZSZFE2Zk1WYkFaNVZvMXlvUW9j?=
 =?utf-8?B?WUEwaTFFN1JkN0Z3akZJbmVsU2Rxd3ZFR3ZvdzhKVHFCQVV2VWZKbmtBVzNo?=
 =?utf-8?B?b29NeVAxc3BZVUdocFFEVXBXRVUyTzBmejdVZWRFOVQzTmJPZllEM1oxSW1n?=
 =?utf-8?B?YXIxVUFmS3lyZHRhZExUUFBsYXhOQlNnUXVhTnd4VmdrbFNWYlNRaWFNTysr?=
 =?utf-8?B?SnNTNVoyQ3lHbmpLRXlBVUFzTnlHY2dNWlN6L3E0MHAwRVNCRndtMjdPbUZT?=
 =?utf-8?B?c1ZBVnBxbDU0cHJaMG9UeGFwckR0YVNCZlloQlZKK1Q1b1IyRjl1My9mQnFK?=
 =?utf-8?B?MjlEZ3RWcWh3aHdEVXlXcjhRVmNKc3BIT0pmV3p3bEpSMUdDS29oOGRKVHlD?=
 =?utf-8?B?M3BJMWVtUXNPUkJIbXB0WVJZa2lYL3JodXB6aDRnMDZRUVplTzBPeERJY0ti?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6beb0dc0-a62f-47da-a385-08d9fd420ebe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 18:17:20.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y227ycwYQKEaPUaJix+w/C4Js3kWN6XZeE2islrNeVeMw9NW1WZkfcE8ihKsHkvK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1307
X-Proofpoint-GUID: BK1UXIxtHsEwuNBMVBcaCqYCF274Fit5
X-Proofpoint-ORIG-GUID: BK1UXIxtHsEwuNBMVBcaCqYCF274Fit5
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxlogscore=703
 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030083
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/22 12:18 AM, Yuntao Wang wrote:
> Using strncpy() on NUL-terminated strings is considered deprecated[1],
> replace it with strscpy_pad().
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>   kernel/bpf/helpers.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index ae64110a98b5..d03b28761a67 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -225,13 +225,7 @@ BPF_CALL_2(bpf_get_current_comm, char *, buf, u32, size)
>   	if (unlikely(!task))
>   		goto err_clear;
>   
> -	strncpy(buf, task->comm, size);
> -
> -	/* Verifier guarantees that size > 0. For task->comm exceeding
> -	 * size, guarantee that buf is %NUL-terminated. Unconditionally
> -	 * done here to save the size test.
> -	 */
> -	buf[size - 1] = 0;
> +	strscpy_pad(buf, task->comm, size);

The precise replacement should be strscpy(...), right?
I am not sure whether we want to do pad here or not, probably
not as it is mostly used by user space for string copy/print
and we don't have cases demanding padding yet.

Please keep the comment
   /* Verifier guarantees that size > 0 */
this is important as strscpy will not do anything if size == 0.


>   	return 0;
>   err_clear:
>   	memset(buf, 0, size);
