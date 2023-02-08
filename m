Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510E268F9C8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjBHVhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBHVhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:37:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4651DBBE
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:37:03 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318Jmor6017252;
        Wed, 8 Feb 2023 13:37:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=ALRavAmdkSxjfPXNJfCQAQkLFrLlpdhFm4FQq+A/tZ4=;
 b=GY2l2hf7LSJInMFPHERKwCxStcLTzMNVrdLlfToMFWqWnIYaLQLy92YVmq5VePUxY+sJ
 4vEujuxun32okqTLW+QCmezh1m4s4ybyhoxx5EUh0pM1qkwbJ6Iqaxl90h8TtyNXekcf
 hawkNj02HBHZwfWCS3hFpHGfov+6sjYlMI8pGie+Po02xBEEhO0Xq1LurDJiZaMiR75B
 HNZgSD2KtUgg/elpFucZb9X+z6R35Le/j+cf/KDW6MVY7SjucZN7YQRQxj2wXI1uPsBw
 zYeIs3g8wKeMd7mGrf5yxNf5iXPR4azKHBKtpP5LHPld48AuWFGOYnTOvIno561CxeSD 7g== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nmce1uqhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 13:37:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CczRqkgMs/JNQ8Au8ljzwo+OMhZp51QobeGJTJQ9FnWQ7XunnZ4ico9Q/uqKkf2lCEx8tT2upMoy4cZe0rdIwvB1zJ1KYtwLOBIFZ0vcPn0ZtLeyMe7aZaL1vQAFf8egBEwlz7JhEWB4rdiEA6VmOMI1St5cvK8sYp6rGLFoIfZAst3fK4y4UEI2QIQrEGamh52pdy/qzlobIjKjpwKy5S11GIgcMR7RBE1bUEoPjOdbZ6N8ef7zbBFcELSQdr30ZiVFR5qh6bXtCgCtvtX2qqj0gI9BfNVmVTCdCdus+0okTBYXyNnrwNlnmh/Vs8hsj1UlvTHIUkpR5iR5c+rL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALRavAmdkSxjfPXNJfCQAQkLFrLlpdhFm4FQq+A/tZ4=;
 b=h2evtQHO0M2f/Pxik1vL8JkakXppqZZrJk8BYwFpLKKjhSlxJtbRBr7YqTO+jQCt7KQKrQATMa2S17y69aGI/zYms/Pwtcuv51Sb3fXdy4ivegNFGNqpPvKFha9JOmK2SMzMfnBqo4p1KgsqeMzHeXc6jVn6tts/WEGsO4jI2umdQNzz4wynKPFA5mnwR+hOcR1bIH6VcPDeTTQ23LehZpgB1OUZxyYVvRXdtsVU+J0F/R/IakPnU6c8RQ9TFgpYJoo5wDAKnBsFdEBKZuhsZaUEoN9tH1YusLSHK/2SnAOZ8XzbeXTgAaMQBAOK++0GhyBV8UaxcwyF4WkzAvN9bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by PH0PR15MB4656.namprd15.prod.outlook.com (2603:10b6:510:8d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 21:36:58 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%4]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 21:36:58 +0000
Message-ID: <3af8d360-bccb-a121-8e97-82a00472c93e@meta.com>
Date:   Wed, 8 Feb 2023 21:36:52 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230208030302.95378-1-saeed@kernel.org>
 <66d29f48-f8e1-7a2e-cc46-3872a963c33a@meta.com>
 <DM5PR12MB134054EC92BC13E36B6C5711B3D89@DM5PR12MB1340.namprd12.prod.outlook.com>
 <871qmzoo2r.fsf@nvidia.com>
Content-Language: en-US
From:   Vadim Fedorenko <vadfed@meta.com>
In-Reply-To: <871qmzoo2r.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0400.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::28) To BLAPR15MB3874.namprd15.prod.outlook.com
 (2603:10b6:208:272::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR15MB3874:EE_|PH0PR15MB4656:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d174d2-3014-4f19-64c4-08db0a1c9af8
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /GRkDZCsyGTbJOaaE85IG7beSBedgUjSXWbgMtzwvFJYa+NNwn0CguqW/wm393kKgfjgpTQ751/9vO7L74bgDrW0a9xG6KT/uol4bs/1n5xooeLzFt4ooYdms40YvQiPoh4YE3//m2GuBIGtFLvD4jyL5rU9vrKpmeZjrTWD2xPjxZY31DkiCUujBKMgq0CB5HoK8Bvy0Vg2GxOrQfQMbyFcfArs1fVhDoSaLe8koH8PTKbPxLD2pV11nm7L6jC3i3dUfUgueyb1ee+gFLZusAsMSYwmm0CuwX2fI5yMLGEaiBTNdYbP43eLmGAG+EhsoNsALecn+i/LRCYvx+l2kpK3RFRbI07zFtTP90OJrpPepqMlp57WSQmHgtJNM21UQG1JCKIaH1Oa+GHfo6G8WWoEwZyEYwzumlxYrswft0X0jdSDxyhFiubdfteCN9JonY4EV/KZHN/jV29wKahuidUzDID7+kZDB/2aU+TreWInBW8XpC67om1+tdAS6Ixfj1riESG+bwxUou8iC49cwf/4smKWVutikebtmqg/9AXcidegRaRqDhYzMLuFSlVlxuVZNBAW+AoWV4JfDnCS9epf+nXh0cGtvAnd8/GEp60wROmWU7SWgZahuB4TD+4JgErvIvqZtz1jWxUwF+rqFokR6OqoEz62YqPuRgXbeWeV6p0Bg5RLfgd9OfBKSn+LkB/QKJ46NNry+JI4zD77Hoi4NbO5DgmKzFCvP8nOyb0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199018)(54906003)(53546011)(6506007)(31696002)(38100700002)(6512007)(316002)(110136005)(186003)(86362001)(8676002)(6666004)(6486002)(478600001)(41300700001)(83380400001)(5660300002)(8936002)(36756003)(4326008)(66476007)(2616005)(66946007)(66556008)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXpmdWN4eUp2amY0cGw2WWVWTTRoNTE0WkMyQkhWbTNodHFjSkVtTGNVUEdM?=
 =?utf-8?B?TkFpdHlmU0JTM3BKYW5pL3VCY01SV2N4N3lwRFNiblNrNVIzMnNzcXZTU2pa?=
 =?utf-8?B?ZjlYQWZrSHEvTmhzenh1OFJrUmdreXNFTnR0aml1NWxweUhqMytuVDR5V3dC?=
 =?utf-8?B?b2xObGFkLzFYbjFWSWs0ekI5NXRNMGxwdjJpYWF1UmUxc2JmbkVIcjV5M1Fh?=
 =?utf-8?B?NG1iR285SFhTbjJoaFoxeFFuSkZORTkrNktSb3BXZ2RtQzlPa3kzeVc4ak80?=
 =?utf-8?B?WFAwYlJqbThEWTYveGdQWng5bjUyU1pHb3ZNUlViSkQrbURIVnI2UVRtS2pV?=
 =?utf-8?B?Y1VQU0tUVm9RS0lKbkppamtTRzhvZDlNRmw5b2dpNFgxZ0U5ZndpdVd2UnFY?=
 =?utf-8?B?MVE5Q3BzTDhZUWN1T0lvTVRZalAraUJLbXNpZG4ydFYxc1FEVi9TanBpRWZL?=
 =?utf-8?B?MHMzQkN0NzJDYUhZZVlpdFZNaHdiQ2FoaVBjeG9nYmorSzBsU0lwc3d1eGhy?=
 =?utf-8?B?VEE3M1lKMkVuZU5SZ0xXb0E0YkRpakc1OWcyVXB2N3NkaGY4U2tyNXhCTlI2?=
 =?utf-8?B?SUNXcFNVWm54SjUrRUJrVUdZZDBMa3pJc2R2SzhoQWg3Yjl3MktyUUVNZ2xn?=
 =?utf-8?B?OWNpclhLaUl4K2hyL2hwZ1hXNWlFNWZjbXFqZ2VkRW4rL2lkc0NNRTZ4cnJY?=
 =?utf-8?B?ZHgwbmc4MUUzUVNKSEhkcWNobTArNlF6Tmh5cTBETXVhZ25sdGRMdkRNYVZx?=
 =?utf-8?B?OUpvZXpTMWJYdFY1cUpETGJMUytoQS81S3dxYTNhdHNjcEkwS3RNeTdVUjhU?=
 =?utf-8?B?bjNpSTlYY2RtVWR1eHRFUW9VYi9rdVQyQURoZnBvK2JKakFweDVhblFvMWlT?=
 =?utf-8?B?OGxXRVlLdk1iZTQvU2NTd3RxeDFhMUtCb2F6WWZhTWNJVnBrRHNNUWJaaTlz?=
 =?utf-8?B?dGg0VFNoZDk1a1VFYWlucmVoR1JvRDA5d2t0TlhtZjJUWVlJOWFQVEtvMzlN?=
 =?utf-8?B?d2U1cmVBWkRjTmJWV3RWWm1PczJJY0ZjNnBEYWxOb29oSmYwejhVVERDazJ0?=
 =?utf-8?B?Tzk5Mk43RE1EVlRCZVVQa2VhaEhWUGZQdHdsWVNROXF6cEhIMHd2SUFUZStB?=
 =?utf-8?B?b2xyeUJGZEhCbXN6SlB6U05JWHFqTnc5aE5NMGY1YUVNOWtvTzBXdnpZRnVs?=
 =?utf-8?B?amRZeDlhTGUrSGthN2YyTTQ0V1YrWkpPeDJnOXVja21JOFZqS2duRjkvbEtv?=
 =?utf-8?B?TXBYa0x2RlgzREdnWFJLdGxCd0xwTCtHRmlOb0pGYUpxRVVucDFEckZNRmtz?=
 =?utf-8?B?L0twR3A1QThCZEVpeUxnU25TWUpnM1c5d0R5K3FibFJoZDcxcmZSV29CWDlm?=
 =?utf-8?B?aEszTXRVcDVMVnJzcWhQUTJhNEpUcmUwWEl0bDlLNDBKRm92eVVhUWlsNWlC?=
 =?utf-8?B?cm9NVEdBUzRpbWU4SnlQYUZ1eXUyekE4VlUvWVJvZnp1V0pRQ0o5enFkenAv?=
 =?utf-8?B?d0M3TjYra1JrVjBjdXEyaFNlSktBMTFMdjhxQVFzZXBmU0xRVk5mT2pHT3Bt?=
 =?utf-8?B?NVlRbGhmUUtpQlhZa3pqWElOMU55MFFEV3dmWmRNMjVHYysyM3BzRmxadXQ1?=
 =?utf-8?B?ZmYwTXhZQVVhWnN4dUU1cE9BZG5DNmNnL2dzU0RjaGcxbnZ6cm4vUFhzUTN0?=
 =?utf-8?B?UGI2YTcyU1lGQk5zMUlsQWxKdHdUTjIyaEh2QmVpdllDT2l1L2JrVzd5SWhI?=
 =?utf-8?B?eXpnc3BRcGdjc0NlM055Qi8zS2owb09TbHA5S1dTZ2JHN1BZU2Z0STEreWlL?=
 =?utf-8?B?c0trRys5WEw2ZFV2MVpreUhyRk0vd2RPaXBtZU9YY2d0bHJoQUk1SnllRW9B?=
 =?utf-8?B?dlJHWVczV3hIUEhDUVkzeTlzcDUvVWt0Vnd0TzVXTENJZmVHV1FGRHNqalNy?=
 =?utf-8?B?WUtGa0NITlV4b25uYXFsV1VVZDFWOUhWaFA0eHpvclgrVENYNTFzY24rMzJL?=
 =?utf-8?B?cDlvWGg4R0kwNXRuSHdsdnpnY2ZBa1hNaFB5bDVGc0FnZHRjME90QWlCZ3BF?=
 =?utf-8?B?RDdtOHNOUTJxaFVTTlB4dGg4MElFZ2J3RHoxdGFFUjNoSG9SVVJGdjhMN3U3?=
 =?utf-8?B?R3FscnZnZGNtZUt4RURGaW1nKzF4ejlVTkg1RStHTUp4VVZ2ZTRPei9lbUt5?=
 =?utf-8?B?Vnc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d174d2-3014-4f19-64c4-08db0a1c9af8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 21:36:58.0576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgSo/J16CTeSQgAK3iJkHN6/jub5Ieg2QEo963PIJWWCcza5MqcWCbjsaaf5TA/Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4656
X-Proofpoint-ORIG-GUID: oRvuAkZj9tQqVniUn_05L2J12BDJj821
X-Proofpoint-GUID: oRvuAkZj9tQqVniUn_05L2J12BDJj821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2023 21:16, Rahul Rameshbabu wrote:
> On Wed, 08 Feb, 2023 12:52:55 -0800 Saeed Mahameed <saeedm@nvidia.com> wrote:
>> Hi Vadim,
>>
>> We have some new findings internally and Rahul is testing your patches,
>> he found some issues where the patches don't handle the case where only drops are happening, meanings no OOO.
>>
>> Rahul can share more details, he's still working on this and I believe we will have a fully detailed follow-up by the end of the week.
> 
> One thing I noticed was the conditional in mlx5e_ptp_ts_cqe_ooo in v5
> does handle OOO but considers the monotomically increasing case of 1,3,4
> for example to be OOO as well (a resync does not occur when I tested
> this case).
> 
> A simple patch I made to verify this.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index ae75e230170b..dfa5c53bd0d5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -125,6 +125,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>   	struct sk_buff *skb;
>   	ktime_t hwtstamp;
>   
> +	pr_info("wqe_counter value: %u\n", skb_id);
> +
>   	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>   		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>   		ptpsq->cq_stats->err_cqe++;
> @@ -133,6 +135,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>   
>   	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
>   		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
> +			pr_info("Marked ooo wqe_counter: %u\n", skb_id);
>   			/* already handled by a previous resync */
>   			ptpsq->cq_stats->ooo_cqe_drop++;
>   			return;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index f7897ddb29c5..8582f0535e21 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -646,7 +646,7 @@ static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptpsq *ptpsq, struct sk_buff *skb,
>   				 struct mlx5_wqe_eth_seg *eseg)
>   {
>   	if (ptpsq->ts_cqe_ctr_mask && unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> -		eseg->flow_table_metadata = cpu_to_be32(ptpsq->skb_fifo_pc &
> +		eseg->flow_table_metadata = cpu_to_be32((ptpsq->skb_fifo_pc * 2) &
>   							ptpsq->ts_cqe_ctr_mask);
>   }
>   
> Basically, I multiply the wqe_counter written in the WQE by two. The
> thing here is we have a situation where we have "lost" a CQE with
> wqe_counter index of one, but the patch treats that as OOO, which
> basically disables our normal resiliency path for resyncs on drops. At
> that point, the patch could just remove the resync logic altogether when
> a drop is detected.
> 
> What I noticed then was that the case of 0,2 was marked as OOO even
> though out of order would be something like 0,2,1.
> 
>    [Feb 8 02:40] wqe_counter value: 0
>    [ +24.199404] wqe_counter value: 2
>    [  +0.001041] Marked ooo wqe_counter: 2
> 
> I acknowledge the OOO issue but not sure the patch as is, correctly
> solves the issue.
> 

With this patch it's not clear how many skbs were in the queue. AFAIU if 
there was only skb id = 1 in the queue, then the id = 2 is definitely 
OOO because it couldn't be found in the queue. Otherwise resync should 
be triggered and that is what I have seen in our setup with v5 patches.


>>
>> Sorry for the late update but these new findings are only from yesterday.
>>
>> Thanks,
>> Saeed.
>>
>>   
>> -------------------------------------------------------------------------------------------------------------------------
>> From: Vadim Fedorenko <vadfed@meta.com>
>> Sent: Wednesday, February 8, 2023 4:40 AM
>> To: Saeed Mahameed <saeed@kernel.org>; Jakub Kicinski <kuba@kernel.org>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org <netdev@vger.kernel.org>; Tariq Toukan <tariqt@nvidia.com>
>> Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
>>   
>> On 08/02/2023 03:02, Saeed Mahameed wrote:
>>> From: Saeed Mahameed <saeedm@nvidia.com>
>>>
>>> This series provides bug fixes to mlx5 driver.
>>> Please pull and let me know if there is any problem.
>>>
>> Still no patches for PTP queue? That's a bit wierd.
>> Do you think that they are not ready to be in -net?
> 
> -- Rahul Rameshbabu

