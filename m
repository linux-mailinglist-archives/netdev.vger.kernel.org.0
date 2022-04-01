Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A862F4EE663
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbiDADEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiDADEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:04:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28E125B923;
        Thu, 31 Mar 2022 20:02:15 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22VNFr6p010852;
        Thu, 31 Mar 2022 20:01:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mq2cCyLd94m43elcGdmPAQ986mOa+UpquVsYsSidXe0=;
 b=nwo2Wn/OlRsx82DrWN0E92hMeGgHwQjeVfxEISX4VQStvQPfgIgUY2I5nB0cgRl4RFl8
 RtuhVSfBm0evhrlbnnt2+WNdtdotXEGBr43jT+AypfD4d9UHl2S/j/CXcNg41Gw0I/lP
 O82V5+s2tDTtfnGsZc6WxuWH74mHlgAUo4M= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpckmq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 20:01:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjNGB0s3OluwuVmr8UrI0bA71XiF4ZllVBk7mms0t3og8dAFglGjTWk4YASMoS1MQGyoay5NxfHvK95K+PpvEbfzL8vzIP2Ho55sEoExMCKfsH8XRSHHoeySM/ZWcj+AB/r96RczlqzCjTkkFGNy7uqbx49auxpm1y2RmdZZTaolRa7k8CEqTycE6d8GJwTxErpHGid9DoVFaJVvlbaAHVwH9ozne9JZepcXFYD6PR55pGl+8IPEeg11TSHEryjEB0L6OBAnAHe8r78ItWTxiWSaVq9199KG5B8wxkODqxqBHJ2yBWEMz+jSNBrY4xFXV2okM/1mlPmpAs5Q83Fk6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mq2cCyLd94m43elcGdmPAQ986mOa+UpquVsYsSidXe0=;
 b=XScno70TzThntafzlreL3wzQXTeACnEEf4lyp0uRHWUuD6Evf5m5fkMnveTgG6lrC0XkxHCxkB0yWKTEoyU1WeEbkzumjCUAyIoBt+xDKbJz4AxCbZgZKmVP4liiXPAsXVt2WGEynNAkkCPf+yyM2XnLGRRgKAXXvPaC4kX+8hgePusFC+ozrAHCphUBs9/ZyJ84W5PiMzL7v4hjXCwWBX+H/CXP7UIQl7PBXRbboyUAb4Fqmvo8pBkqG3i2VNpM17zMtpu8QYLt87pGHfP+RCoc62bFRTJuioKp7nIWXjy3MiMR4fp+axcIk4F5wkKiLHX/hUDdADf22SiTyp59ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by PH7PR15MB5275.namprd15.prod.outlook.com (2603:10b6:510:13d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 03:01:55 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c905:31ba:4885:cc7b]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c905:31ba:4885:cc7b%7]) with mapi id 15.20.5123.020; Fri, 1 Apr 2022
 03:01:55 +0000
Message-ID: <882349c0-123d-3deb-88e8-d400ec702d1f@fb.com>
Date:   Thu, 31 Mar 2022 20:01:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] sample: bpf: syscall_tp_user: print result of verify_map
Content-Language: en-US
To:     Song Chen <chensong_2000@189.cn>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1648777272-21473-1-git-send-email-chensong_2000@189.cn>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <1648777272-21473-1-git-send-email-chensong_2000@189.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::16) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cd1ba6f-15b1-4a9d-8f6d-08da138bfabb
X-MS-TrafficTypeDiagnostic: PH7PR15MB5275:EE_
X-Microsoft-Antispam-PRVS: <PH7PR15MB5275CF2CA4AD04907D69CAE1D3E09@PH7PR15MB5275.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuQuF3wdt+tgwZ/6/xLg6AYr9xYxSULCbOhd6cJlJ8PhjzJZYEdyPK4ajRQCKjK9/NRf2v8bx8qVbvXvZ+F/2ZA0FHIhzIZhHTZqUZMkWZ/7DfNChHANr6rr6Xa12mtl3+jGqZn1q8Zc8q9DNHE1IYTOEDrf4WvK32ITSzPQVmFEffb9b3njHiskd5rh5aW32vvK9f/irjyH2R0/57oy7YfuChwoVR4AJivDAX56cCoX+CSN4FORUlq37LlCsxqRgHk3F4311KuJUXTh47HOVSm/NP92Wos3PxZoc1VmT4/so/aJNKq8nwwbpZ+wlaeelnBU2zZY5+iH6C/sdxbrIqTvwNCZAhyqBm8zMqBsUC5K25ovlEftu2/YdgO5T39pkcZPgrs/1RrgUKZrvFuIeMh/4EXC+4M0C3mSbN1/Bo7pAP8T2AXiLn5koaNM7nFA0k+0k2G00CaTSX0Ujou5OQKY4Lysk/zJtZcjiWXclhZO2xlH1skdWMw4iQTKu1h7VKo78KIxQVm8zjpwfmwhHH2NKp/3gCDUZadoFYRVyjFxpYjJQdBvVFkq4uxFw5HZYVloX934Je/hch2Pa8X5nOTmz/rzr6EjgJLyqoeLBItTXgkos3pt2gDX1e/hYY/t3vYFHyf6u7LMFAuv1ODjIDv90iRncjsL/IsdoBlkJ1VSQzTWebhvlWkcMH0Rn/3vARdCHeTciC0nkRnN3z9b9E134D2euDspmhnoKHk9AwhRe7YqbxSElIS/VmLjWPiqWT6wOdemiynUBSJ79SF+zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(921005)(31696002)(86362001)(38100700002)(66476007)(31686004)(8676002)(316002)(15650500001)(2906002)(36756003)(5660300002)(66556008)(66946007)(8936002)(6666004)(6506007)(53546011)(52116002)(6512007)(2616005)(6486002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enl5QTFQOUZuZ3lSb0J5bXRTTHc1WFIrU3lDZnBUYjhPc0h0UTVscUU5c29B?=
 =?utf-8?B?dVRCUm1CSFk1WktLV0hHUDlUaTUzcmgraVorOGdXczRWN1VQWVVhOHpGRXdT?=
 =?utf-8?B?Q0pheHBsS2IvL0JRWC9rb1I0SUhvMzdsU09SeWd4QVUweVpCUVdualdhcFBr?=
 =?utf-8?B?eWZrSU5ycWlSUFBnM2ZxVDVXeE9JSXVnbGxkZGoySUg4NjkyRFZTT2kzUnpH?=
 =?utf-8?B?SVUwak5VTmFnZ1daRFE4eFF2TUFyYjk2ZjErVXV0aWFOQ1BTVWRoNVRJcFdC?=
 =?utf-8?B?QzMvRnVMZUppak96dytDVFNPRVQ0akQrSU80RFRRbmUxWTZyMlVlUFhUU2xz?=
 =?utf-8?B?VmQyUm9sMmRPZ0ZKYjNpUnp0UVQ0UktXbXU0YXJOMGJRQ1BiT05pS3BReGRM?=
 =?utf-8?B?bEpFc3BXcjlOaUZ2a2h4US93VUc4QUFOQnZ0cTd2VjVqL0ZSVUtXMC9TTFJE?=
 =?utf-8?B?R05tcVNqYkhtZWFrL2haU1Vma0t2c05yeDh6dDIvb1RPY21lbkd2RVpjckVV?=
 =?utf-8?B?eWlYRnJ0Nnd4dUtraWZBa3FNamNlb2pndDY4VllhQTJhOFdVUm9ualNuc3po?=
 =?utf-8?B?UVBxWXM4bGpyVk1ydlJqSHpTdlM5THF6d1dZSStPM1hscElrYlJoSW9WbXkv?=
 =?utf-8?B?VVdCVUhna0xsQjhpR3RqN1NWL1ZVbDI2T2ZNcmpWZnNLV1IxSkFPaTllcXdN?=
 =?utf-8?B?T0J4NjFjSlBueDB6NHU3MitDZERhMWZQMVdwczJHeHo2SW90VnhqclZLWS9D?=
 =?utf-8?B?VHlTRWJJRmNhbHlXNjFtRU84ejBNUWIvL1J0OGxDdk11NnhHTTIzTzZJWjJv?=
 =?utf-8?B?K0EzT0RkM0JkUmhTaHdvQ3l5MXVIMDh0MVZaeWpBd1RNZGxiRHFGYnZOMDlB?=
 =?utf-8?B?WWRadm1GUmpIYldaVmwwMFdleUs2MEVubXhZd2VQRjlLUFhqWENJbW0yTndh?=
 =?utf-8?B?djltcGtpaGE0eDkxeEt1dzJsQkVQcFkzandsdUpLb0RqVHBYdmxhdjFtKzFP?=
 =?utf-8?B?MnlRMUd6OVkzanhrV3JxTnlHSjdXS0V4MGtkUkZXR3NMN0RXTGZ0ZWNvWGdI?=
 =?utf-8?B?VnAxVTAxbFVxZjVGek1Rckg3VG1pYlUwcm13Rk9DMCtZQk5takJXeUtLclpR?=
 =?utf-8?B?RzV3a0xMWE12TUZMQWFzdEVhK2hFeE85UHUraWtmZGxGRjE0cEJDR2xuUzhO?=
 =?utf-8?B?cDF2NFVBT0FHWVpSRThpSkpna2xIeVJiaGI1ZTlseVZET2tDU2wxTU5FUitv?=
 =?utf-8?B?VGpxaGFZejVsVS9wZDE3YXJSVGx4UXd2UnlZWlpSZlpIMkJFKzJWaVd3S3Mr?=
 =?utf-8?B?OEcxekRGZnlrRlp2bVJtUlNGanhyWW5NYnFaNmhUKzdoaThsQTlGRkpybUtS?=
 =?utf-8?B?cU1INGFJMThRcjVVVnBUbk9JV2JEUDd4aU56RnJ4VFBsaEE4eGlzeW1EcWhu?=
 =?utf-8?B?SW8zWG1PVSsvWURhWFFkaTczcVJzaWVTaW1UU2cxTk9CUnQwNHZIZWxYck5M?=
 =?utf-8?B?Y2IydHFaNWxoMzR0b1BoNGFScHFjcjFUZ013Ujkyd2c5c0NuSVJSRk1WdUFV?=
 =?utf-8?B?cllYaEk0a2dmYW8yNkRhY2x4YldDQXhXR0YvNVp2dHdyMjMyVTlIRGtuclhn?=
 =?utf-8?B?a3UzeXNPRGdQYWwwcU04WlRCSG5nV3Btc25Vc05oYXcxQWJNNVc0eG9CREVz?=
 =?utf-8?B?TnV4emVwUW9Fa2NoN0NrKzBRY3VGYVM4eWQyTjRGTVpyM3dMc0dSRGNpNFUy?=
 =?utf-8?B?TGFwZFFGbWtEaWVUOXh3Vk0vbCt3d05uM0xTajdUTUc0NDRFeFFSV09rbmsv?=
 =?utf-8?B?UWIyRFpQQWRWM0I4aW5OUWhEajlKU2xxRnFqOThaUjZYUGx5ZnVDc3Z5TkVN?=
 =?utf-8?B?ZXc5UVFiL2tuNGtubklTU1dTSDlrU1lqa3I1eVNXb1pqZGptck1Dd0Y2YTds?=
 =?utf-8?B?NUhwT3JIYnZ4ZTh2bVI1RTNxeEwzUzBFTGJKbmhOTW1sell6K0Z0bURwRDZn?=
 =?utf-8?B?cVJYbzJyMXdwY3JYZmpUeUp6RlZRZndDS2ZBUjdodnBXVHllS2lGc0FHT0cy?=
 =?utf-8?B?L29YRmNkOE5xWlFsZmJKVjFzR1I4akZNRWJmeis4d2hPMjZHMUUyZUNYRXRS?=
 =?utf-8?B?ZldFK2xXWVdXSnNxallBd0F0YTE2VThWZmpUK2pZZGZxV0dhc1B4ZWhWdUFX?=
 =?utf-8?B?Q3ZrRDVUSk13cEkxWFVJcm1sbHhTSS9FMzFhMVdUeWpYeCt5K3I1dzNnOHRP?=
 =?utf-8?B?MmdVcytTc0VLZjhBZFlEcCtia1RnbHFhamZGYmE3ZzgybUVvVjluYnhNZmtJ?=
 =?utf-8?B?Q2RBRDRhbUhxNFM4NC9ZTmtxaGt2cHRmcHRkY1ZFd1dTTllLUTFRMHoydmJW?=
 =?utf-8?Q?xdmEtNW9YtLjIKKM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd1ba6f-15b1-4a9d-8f6d-08da138bfabb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 03:01:55.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvPI73syI2+tmrlCvprbBAlwfPtYlIyQMOOTernpYTG1YwrfxFJGf4NJYg3v1bRh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5275
X-Proofpoint-ORIG-GUID: qa2xWRwyBUqjLhMy0jgPDNb1AlnRRnce
X-Proofpoint-GUID: qa2xWRwyBUqjLhMy0jgPDNb1AlnRRnce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_06,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 6:41 PM, Song Chen wrote:
> syscall_tp only prints the map id and messages when something goes wrong,
> but it doesn't print the value passed from bpf map. I think it's better
> to show that value to users.
> 
> What's more, i also added a 2-second sleep before calling verify_map,
> to make the value more obvious.
> 
> Signed-off-by: Song Chen <chensong_2000@189.cn>
> ---
>   samples/bpf/syscall_tp_user.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
> index a0ebf1833ed3..1faa7f08054e 100644
> --- a/samples/bpf/syscall_tp_user.c
> +++ b/samples/bpf/syscall_tp_user.c
> @@ -36,6 +36,9 @@ static void verify_map(int map_id)
>   		fprintf(stderr, "failed: map #%d returns value 0\n", map_id);
>   		return;
>   	}
> +
> +	printf("verify map:%d val: %d\n", map_id, val);

I am not sure how useful it is or anybody really cares.
This is just a sample to demonstrate how bpf tracepoint works.
The error path has error print out already.

> +
>   	val = 0;
>   	if (bpf_map_update_elem(map_id, &key, &val, BPF_ANY) != 0) {
>   		fprintf(stderr, "map_update failed: %s\n", strerror(errno));
> @@ -98,6 +101,7 @@ static int test(char *filename, int num_progs)
>   	}
>   	close(fd);
>   
> +	sleep(2);

The commit message mentioned this sleep(2) is
to make the value more obvious. I don't know what does this mean.
sleep(2) can be added only if it fixed a bug.

>   	/* verify the map */
>   	for (i = 0; i < num_progs; i++) {
>   		verify_map(map0_fds[i]);
