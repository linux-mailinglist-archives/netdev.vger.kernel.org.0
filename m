Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73F359B2EC
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 11:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiHUJXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 05:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHUJXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 05:23:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE101AD90;
        Sun, 21 Aug 2022 02:23:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDLaTwwkqA7zWoh2qnfFven7X6EYrM1EDOjadImpe5arj7JjDQ832IMN9zeguSu33MX8Lp2ZYEMvAfNzY6SMwrbSC07HpQeKuE8LWO3k50R6gzNUiW6Jt/iBL2U2M+rRFTD67UL1F6HZwj6CvDlnFZPPQVQoEPZ8EaDQkgr6TBx82Z81Kkml++IKE+JLesM68jMnBM53NT14VyPd16UsUKh6fojE+SyxfZNbZPpiIY2pW2EVXqZfEm8vH2L2EhUznW55qhdQfer2MI1DHmd+PgF/uyg+vT+mMh69To9FehKcrpB93mUqE1n9tgM1ksmqzB/713B44rH2+5pnu9MqAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjluFHMgCIIQ45eLasBcN3jhpWDiCNmdxjLbR16jb1w=;
 b=dr3oIRaoAzDNgo19C0KcfTbyQQXzSgtVZ65qmF8+74IDwkZhIZRJnqfXEjTcjyOLehnOD35sv4276qd4ASmY8o2uYBX6hX6i6G0Rzc1/QYaZfzCwjw6ah6cHTAtv4buWv8GqffnMLwRJnaLrAcOOjy1n0uaqx3tD2AeSuB0lixZrLDnSBOI74eqQMflUS0VMkbuIhSRzXcwhHMNOUooEzXmzyHCV7miv/rVBSAVB+5ZlPklDaqjf7AmTxF3RpRMiBcKJ8jGWzUtWyFVIrypVq6ORgbjG5XRHfdQdSXRgyVCyhpDYgfVD/i0Wue17FjIcQMbeeGwU7QteDAOVyMp8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjluFHMgCIIQ45eLasBcN3jhpWDiCNmdxjLbR16jb1w=;
 b=dM/UqOrkKD3+2hd2CnG2f9ZpEbJitEwLX8eXOmwj1s0pWN1tCndl4Okliyt7QjfRlixFGf6FAhWNnWW/EwcsZGEk1GzDAm7pLNFhtMMZjkHqYSLbE5zOYaAxHy3gCPadIrwsQ+ARXrF7D3CYsYI2yDcXQYRzBgli8qcKeIhPse5qyXSYIHG1ii6byGqEL1FjbJyBm0tNoQABVuhHoRJenzkR2fs4KKvVmHDRIszu5I16WCs6j/21qQ2Gs/qG138H7aGp5pvIi0i7Qkxyx45F71jOTBmgOZkso1VIZEMfDwgJWZcy+Oa+TSyZqpCb0hy5UPbkSty3wkAxvGSySL43EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 09:23:49 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365%5]) with mapi id 15.20.5546.016; Sun, 21 Aug 2022
 09:23:49 +0000
Message-ID: <11b87f33-98fb-e49a-5f63-491d4f27e908@nvidia.com>
Date:   Sun, 21 Aug 2022 12:23:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Fix use after free after
 freeing flow table
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        netfilter-devel@vger.kernel.org
References: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
 <Yv7FauVMX2Smkiqb@salvia>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <Yv7FauVMX2Smkiqb@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0062.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::26) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69fac049-f805-4648-c5ee-08da8356dad3
X-MS-TrafficTypeDiagnostic: SN7PR12MB6789:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3sx2Xh7GrszFnGh68AB5jgnpER3ZUwPhon2naRVlG4QbauXXkoDc5MfOi9ET/rxB9Gy6X26uQ+uYf6NKqcbhd+4X/43OR9iS6lW7GgCVweUan5WJnwFHJ55xMlXhUQQpfopiuUta15PhBlJLPQWs1w7s97qyg3XSm6gdQxc8ReAj041rEyZHOst0XxabAzn0YvuWOWrkGXV27L0GBA6VZOaPE6IS1wcR3HaoS7logPhL1dckieAGqhFnWX6cW80OcwKNAGmpU9/wGf1nM4kpJzz13AXhYr5e6tzQMcu/pzYM1PA9zSkLpGUrZ7/UGtbVGPoqbe2cvz1dWQ/QVhFoByvA8OI2eaiSBP91MaQwge7Kq6zbcQynuOVkKFXVRQ2f5Wo/QDhRkqPkl335hg4hliNgMduR6eJgDYek2eJM3XC6dlkpZng8aJD8B6yU3riK/uJRsaDpYN8x9Sax4c5Exltub7V9FPSRcfI4Rv1/C4UIoFMGtMENKP5ifgAQMEQ0urmWFeTyE9wzfC+NEhs8KDR8h9WVsH1x3uN09QG1gyMhVmJyZ/D/BVlTG436/v+aQf4uaBGNMcjZ8r3jxUUi29yhhPF4r5OP/rdvdr6Hyjk3sFQF3E+AAupKOtWeWF2Qz2wh+dW3DVmwQqFPhIQnKTvHNuYxxLdr1J9QyHFIcwWWS0vXlUenbllXLWZS9W8jx8UsHm3HieY4L7ZFJhhUqDMI6xKumhcBDxYIuSjNozVCMVZFKXXmF2KpCUJ0H/cMGkvBT1H9HlCV7ICgHLPOEJyaHJDt5DH9ky7bHUEOGMIYM39gzgq/ULgoz49gwcl+3a2nmYebjpHdb/qWnv2O+Zq3YMbOJsWTaQ2w+/KHxkdG8JaF5EbqQjS++STRUmg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(2616005)(31686004)(38100700002)(8936002)(41300700001)(2906002)(6506007)(26005)(36756003)(53546011)(6512007)(478600001)(186003)(83380400001)(5660300002)(8676002)(6916009)(316002)(66556008)(66476007)(6486002)(6666004)(966005)(66946007)(31696002)(86362001)(54906003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEhibFo0QUVsSjFNR3cvMjlsT2IzS1RYSm53cUdBTzNDanI2aDYvejJxQXlI?=
 =?utf-8?B?am1pTXByd2lzc3AyNFN6WDNSSU5JTUZMY01YaWR6SkF6VWlYUjJvK0dma3Uy?=
 =?utf-8?B?OWlOUVNIb2NSZ0YzaE0vaHFyRlVPelRRaHpOTUJuS1pjVTN5aU5ZSEZxWEUz?=
 =?utf-8?B?RVRtdXNkcEovaUVkZ0VvOGtzV0VHN2pDeHBEMENGbldST2Z5RndUczNjNkxB?=
 =?utf-8?B?S2JmR2FvS3ZzaTRTS0xrYXlodm9JUityeUp5bXNZY3NmMTZjSFlDTHFucHNB?=
 =?utf-8?B?czNIYkpTZXh5bHc5c1NvTjZvTWxmNXlubXRkVHZ1VmdYT0ZSOWRwY1pBSlFV?=
 =?utf-8?B?eVRYL1JMZ3JvRjY3Rms0c1R2MFRFcXRBKzA5U2NJTkNjcHVXTkIzSlNGTXYw?=
 =?utf-8?B?dFFFK2U2MjhiS2k2bllOcDl0bVVCRW0wUGZMUm1CQjdHQ3ByWU5HRldTUXpm?=
 =?utf-8?B?bXJ4WkUwYnZRRTRIelF2bHBnMEpvNGR5SDVDY0hIdWt3T0ZhbmRFcHJqVWZk?=
 =?utf-8?B?WEd3bHA0WUJMZ0hGQlJPY2pmb0huMjFINFZTeTArT3lsZ1pVMWc1c0FHdXY2?=
 =?utf-8?B?QUxvZ1dTN2VMaStUSXI3TWZnSjlIdnRxSTg5SmxYalE4Y1RKK3dCUVJsY0Nr?=
 =?utf-8?B?Uzh3R3pvQWQrbXAyUzU4MDRBdzhLUStvVTBUbWhhczZIdy83bytVOW5lTzNE?=
 =?utf-8?B?Y05EVThKK3JiL3RmMGVsVWJNakpCeVZpN2ZPNDhFa2Q5MEtEaVlYcTA3Q0Jk?=
 =?utf-8?B?U1h0cXJ0bThyVnUyVFRRbXdYNTlpV3VxU3pobVF3M0NYazJpM3FSOEpiQ2dw?=
 =?utf-8?B?ZXMwRzdsekl5QTEvaFEyeDVYOFlJcVR3WStaeDhGN3NLUCtFTC8wNjVBcWti?=
 =?utf-8?B?TzZQcXc1N00zcTBubTVzR0lCZFdVVVBYZVAxMHgrODEzQTlHY2xHZy9PQnND?=
 =?utf-8?B?WVFpVnFzeTA3SW1sVFEybklOWkgvaFc4dUl6a3FZYU1jaUg1eHZZa0xIYjdR?=
 =?utf-8?B?c3ZCVXdZL0ZxTGhXSWdvWlQyVFBVc0o4Y1JkOGg3bU5kbDluSE1jQmIzampP?=
 =?utf-8?B?NEcyUXdmaDJpeU9Bd3FSYlpDdUVHTzVqOG1tQ01nMlNhaU5xTDViT2lMdDVx?=
 =?utf-8?B?Q24zRjVsREtQMlVXNmJMMWpTVWdUUjFzUCtoTGJENVRnTkFVaEdpQXV0Rkd6?=
 =?utf-8?B?L1p4L0JMQVFsVGVwQm9pVThuVWtXUTRwRVg2S1ZZaGNhS3JzNDBZTkdNTTBN?=
 =?utf-8?B?clFDVWNXQkQ3V1ZINnB6ZHBrSWVrYXgyMzgzamRVUldFQUFycXdHTGhzRmtM?=
 =?utf-8?B?aGZHMmU5a1Rac0wvT3VWR1J5eHJYZjMzVnhkaHYyTkhQZzVNd0pyRkNQVjB5?=
 =?utf-8?B?ajBBaUQwRFpnVDVMelVuWXl0TXlodGpZREVhWENMcjBYc3g3UExmVXBQR0tx?=
 =?utf-8?B?elprN1BUZStya3N1Q1N1V2N5bDIvYW1zMEp3UnBOWHc1bXVQSytEWTFWbThT?=
 =?utf-8?B?RlBueDhZakZ2cGxrTkhIMjROaW9LWWhSTlJVOVpDTnBudWhUeGlJYjZIQUJV?=
 =?utf-8?B?djR6U1dESktHMmNhRGh0SzBxcWUwZ2FPbVdpZVZKaXprUWRTYU5Xak5UYll0?=
 =?utf-8?B?MzVNTWptMWVFN1JoNUxwVGFCNXd2d2cydGxSSFcxWHhKUWVUOWp3OG1ySURW?=
 =?utf-8?B?VWhTUGZkaDNoVDc0STlMd2tWM1p2ejRzcTdXenNBL2laODhsa0Rmb0l5VXVy?=
 =?utf-8?B?UXNWVkorbUhzazQzd2Z3c2piSkdMMndSWm40NlZKWkZXU0RBUGZUT3NiL0J4?=
 =?utf-8?B?a0ExMnd1VHkwcTlMSmMwVkJtT2pES0t0U2ZOamNDQUN5ejdoVWtnYU80MmpC?=
 =?utf-8?B?QStudTZuYzYwdWsvaUhPQUIrdHliZllZSHNCMllZbksxcVhGbXJ3dFEyS0E3?=
 =?utf-8?B?aUNNRUtzeExyMlZhT2oyaDNIQ3hKZnBIMUFSbWd0WHFOMW1iMnY0WWJia01X?=
 =?utf-8?B?dVRvdEY5SHd4elJvbk90OXVaaElnd3NxL05aMDFyUGhzajk0VkJReGlvcEl0?=
 =?utf-8?B?bDZLdkJlV0EvWkVINVFuNXlCVTdsaDl4ZEIvY1JGWFpWaXVTWTFPMG95QXhI?=
 =?utf-8?Q?w/bKt73Zlcc7XCs2GTr56lr5q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fac049-f805-4648-c5ee-08da8356dad3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 09:23:49.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eg2yPYhQSJQz5XRDlxQ6MQlJCnPX1Im2drBzMnrEg0Oy0HpSVYzOErQiyDFky7F3yjfR4osTWjjNIcy/jbXMxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/08/2022 02:04, Pablo Neira Ayuso wrote:
> Hi Paul,
> 
> On Thu, Aug 18, 2022 at 10:27:54AM +0300, Paul Blakey wrote:
> [...]
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index f2def06d1070..19fd3b5f8a1b 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -605,6 +605,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>>   	mutex_unlock(&flowtable_lock);
>>   
>>   	cancel_delayed_work_sync(&flow_table->gc_work);
>> +	nf_flow_table_offload_flush(flow_table);
>>   	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>>   	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>>   	nf_flow_table_offload_flush(flow_table);
> 
> patch looks very similar to:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/1633854320-12326-1-git-send-email-volodymyr.mytnyk@plvision.eu/
> 
> I proposed these two instead to avoid reiterative calls to flush from
> the cleanup path (see attached).
> 
> It should be possible to either take your patch to nf.git (easier for
> -stable backport), then look into my patches for nf-next.git, would
> you pick up on these follow up?


Hi!

The only functional difference here (for HW table) is your patches call 
flush just for the del workqueue instead of del/stats/add, right?

Because in the end you do:
cancel_delayed_work_sync(&flow_table->gc_work);
nf_flow_table_offload_flush(flow_table);
nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
nf_flow_table_gc_run(flow_table);
nf_flow_table_offload_flush_cleanup(flow_table);


resulting in the following sequence (after expending flush_cleanup()):

cancel_delayed_work_sync(&flow_table->gc_work);
nf_flow_table_offload_flush(flow_table);
nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
nf_flow_table_gc_run(flow_table);
flush_workqueue(nf_flow_offload_del_wq);
nf_flow_table_gc_run(flowtable);


Where as my (and Volodymyr's) patch does:

cancel_delayed_work_sync(&flow_table->gc_work);
nf_flow_table_offload_flush(flow_table);
nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
nf_flow_table_offload_flush(flow_table);
nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);


so almost identical, I don't see "extra reiterative calls to flush" 
here,  but I'm fine with just your patch as it's more efficient, can we 
take yours to both gits?

Thanks,
Paul.


