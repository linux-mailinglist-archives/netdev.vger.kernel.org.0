Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A746775F7
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjAWIAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjAWIAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:00:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4B713D61
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEWRObhYpLB3DfmI9DDMhC8lZ/EgpW/GPjnM60bsg1HBpsPLZtA1cWzu4KgvoCeXHSTeoVe49VnZEOQTgJAugGWoYABakqUxV0BQJ0eXz5G3D60OnPHm2JdzAZtf1DKrahVDY+KtOeALbAyNMjSCk8CB+3rU/sRuQYTQTTLCyd2AgCDWoGLW5Ts6Di3X16NgPmOwDtUnFU5jPprNmDLeVU5sNSWKs9YfuLRWtXCWKRs2o2XZ10AtTU4pRclJN3W2vDXkSx3S1LbPhiALCNmHq55dhQ/rsr7LfWhJNjjZZQqnL0MAoHpQCJJtDa5/p/wpr8yCtmXhOvQL/6YV280hAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/oK3iwK3Oo+sMfG5rdTXngMOIgWYXFLjXTwyARVGH4=;
 b=gjqKTf52neUWW9FJPw4YlW1qq1pSRbw5MHZ9NfBynTX/cI/yF/eNnDvP07g1L2gY18ZHdoJ4QmVX76j0qZBOniCyjmBGzbcerIfn8r6pC0lu8JA2j1IDRz8S6FkQrByKsla1ycF4TAXJR45jMEodSRSJE3VA9+NCkP4qfxZltrxaOSpkhMvtfb1wOT2b+fGoI0EzklnUmIhB7TryBY9zBM6C8XL061kweA1ZtlmB9oyYAX77NzQ5GFX5xSBeiCyXSI8n07aPZa24udxtUqJN36Cb8tid6Edx6FVXPzjMyACp3kn+rq4Kfx89T5/FOd/yyYf4k77MqixJpoctGAihBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/oK3iwK3Oo+sMfG5rdTXngMOIgWYXFLjXTwyARVGH4=;
 b=ag0dtjd/VRozTlVF9N4qAK+gBVmoBIkvcDHExwynd5kR7NVtChuT/g+GVVEJ0EhMLPwcV9Ha8YWUq2Smcyev+My3zVkf1ecOuAR/VfJP0FWdvCKlGf/XlEkXE0CnpSwcX3Z3FWRT9kUlFtw5xuTz/rrOIIIV8ZpeWE7GovkESrnFxP8kg0DY0Kc6pjyku8goqZG1JQ0asC3Tj70qZ36lbpKl9uTG2i5UgEFgFaOMlXkbPnrZIX1UTQU0/hdupsE1mBcHWoA3siRQWOB4sZsbfg8F9iaL2khI9pCEzqPbU41e3MYeuu5/Wxs2nAQGDGO4sag4V7OkbbfoQgwRn0RgKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Mon, 23 Jan 2023 08:00:48 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 08:00:48 +0000
Message-ID: <a8b50a56-1efe-dded-4cde-1ca119929347@nvidia.com>
Date:   Mon, 23 Jan 2023 10:00:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/2] ethtool: netlink: convert commands to common
 SET
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        piergiorgio.beruto@gmail.com, tariqt@nvidia.com, dnlplm@gmail.com,
        sean.anderson@seco.com, linux@rempel-privat.de, lkp@intel.com,
        bagasdotme@gmail.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com
References: <20230121054430.642280-1-kuba@kernel.org>
 <20230121054430.642280-2-kuba@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230121054430.642280-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::27) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DS7PR12MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: bf7a8afa-5493-4d8b-4af6-08dafd17efca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFQBNeoyFOoUp8NgEVxhXraB0FWJTsqVQoYF8Rd38buNW/6qw7nAV4mWPmwev9MUj0TBAANMmpuilH9FQmjOsJktnXaomEcC9sNWjCVcrqSK93vXNmPujxuSgmbnn9AdVMI+FNd+5ZzVWQP+1uDuPcT8lRtateoM1Z7vHuT5ZZm9eTU8FXoUvFu4lE/FP75wI04SMPkJcIdrDhhSLwnCIkbnOQdPi0tbYofH8aDUxZtwjy6LUS5cMiLw1EoxVqD5O+N/PZ/cMD3k0mUSqbJJaBSljkDCJtB8Vq5ycFQPvBfWWvQgyS9G/V8WLyRUx/Ft47UsDbAFAA08NBLD8XQzeDBhOkOKmatGSeAgGoEsBnbhJrWVJpjYrRzOsmNp1Rwwu08tJCD9pjuoM6eI7KVGuvcZf/kimKvGe/5AfX4gYEXe/bvCwQL+xTSbSY3xB3pbcsNbyl88KnKp5XZoOB5x3+fA5kOgKJ4iazp7k4MmjMjXMqoS94cDeuyhHKlYyQ0gern9EGQ4Sgy9n/Jnd63ZkTQWUX3fGYLUE4UWB93tNwvLzBGdxM7h+xzO//NA6VXOFylbKzEls2wyl09th8giFh8MdVe5nCS/EXdsv0ea0Ylwmq4wZVQsPDTJQYBzgXw2DLhlxWDuiA0XXG9brwXADkKoXfweRcmIHwD5nYZ+vjhuOYK/tmSfJhcLcfx9CytJt+miJLfUK8/hUcHkaIRhgHW6ohQHUwahyLhZ2kagPF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199015)(31686004)(36756003)(558084003)(6486002)(7416002)(31696002)(2906002)(316002)(53546011)(38100700002)(478600001)(41300700001)(86362001)(26005)(5660300002)(6512007)(186003)(6506007)(2616005)(8936002)(4326008)(6666004)(8676002)(66556008)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1lBRkh5ODZYU2xIVTRXcnVYZk13M3lkakUwYWdRYjJLbXp4bGIvMmc2SHli?=
 =?utf-8?B?bWdFM25BalltMFM3OHA3OTJPMkdDWHFKTVMvUWc1NG44dlE3bndjY212Ulhs?=
 =?utf-8?B?RVF0bmFMSmx0V1J5ZTdIMHFDczFUN3ZTR1BtK0FaNTJObHp0MWx4VC83TkZk?=
 =?utf-8?B?NWR2S0lHTVhIQXdWTzJtMXdqZmFGZWpKYW16cFRRSldHaTFDOW5TRzlPMFIx?=
 =?utf-8?B?SGJjc1lIZG1HWnA4RXBEaStVRUxPZDlWMWFzVStPM1c0Rm9ZUWlURnBDU3ZE?=
 =?utf-8?B?OFN2MllWNnk1UnlIeHNUL05aNmI3SS90blVGaDBFb3ZZZkFVZEc2QTUyWm0y?=
 =?utf-8?B?a1VTSmRoVkdmdUVpZHM1UXlVRGdSQ0JzM1QrRHZnUDIwNHc3RGY0WE1GYkd2?=
 =?utf-8?B?T1hreG5zMmZzZ1d1aDBJOEpyQ0RCUTRuT3E4REk1NWdISnBGaDRVUkRPbXpC?=
 =?utf-8?B?ZEM4Mng3dTlWbnltNnNMbXB4MEt2K205c2FXc3Qrd2tSTk5JRVE4LzNRYThs?=
 =?utf-8?B?dlJhdDBJZEh5eWp3VWVEc1YxOTlSSlg2T2ZTQWlER3hUWjBkVlhaYXQraXlw?=
 =?utf-8?B?VGsva0Ftd1k5UTcyMW8ra2RESTVPQ0RiMWNMSWJoTTF3SEFWTVN6a0d5OU9B?=
 =?utf-8?B?N2NQaDhwaC9qWjdzQ2FKbEFCVGdRYUROa1ZiS3kzbU0xUkV6SzRxSlIzNUhJ?=
 =?utf-8?B?ZHRVM25zZnVXSWV5d296MVZVRjJRTDBMRlZrYkxlMXpVYVYwRTZqZWFpLzBU?=
 =?utf-8?B?U21uVDhKN05aSmV3cHRBcUJDbHR2eDhDcGkyTHE3NGRHVWlubFR1Rm1INzZ2?=
 =?utf-8?B?dURVdHVXZGFZMEUvWC9nWllCUG9Wd2NsR2hOWDJjeS81a2hMSHBUbGxpT282?=
 =?utf-8?B?OUtkcG1oR2M5WUZVQjQwN0ptMzhjdEd5NVIxV2pHempzUHhTZHVRTUs1WWtW?=
 =?utf-8?B?WUpNeXVEbk5ZcllraHF5NExZREo1L3lXbWprNzBlcGRxYmY2ZEh6aWJkWXlo?=
 =?utf-8?B?QnlCTm9yK3VWNVVQZUJqRXUySHRsd2hSTlpJMzBvdnRpY3IrQW8wRUpGZ3Ez?=
 =?utf-8?B?VnhwdXpBRGRrSmpla1dJS0haR0ZFNlE2QjQybzBlbjRmMk9iU3NIN3JkNm16?=
 =?utf-8?B?Y0pmWkl4eWZ5bXl0ZldnQ3lUUW91OWViTU96K3Yya1p0bUxjRnhleENzZWps?=
 =?utf-8?B?dmh0UnZ3a2FqZDlPQ0QveFFDaExZZW9ZZWVveGdGSVE0OHVkS042QXJ2eXhQ?=
 =?utf-8?B?S3kweXBaSFI1SGtaN2N4c0dmSmRsR1JxNDFDVGlDNXFwcnFnekFNN1pWSDAx?=
 =?utf-8?B?NlJxb2xoRlhIN21XbzZOdSs5Y2tCYTdncForVlFmUENYQktybDhGNjRYVzRl?=
 =?utf-8?B?aEJYK2dxbGlYVlpQdUExUUFTZzVXb0JUR0JDbG5meEVBSk52NVFMZFY4c1VZ?=
 =?utf-8?B?UUJUK21MTFlDY2s0TGNoUWJvYkMyVExmWHVTTmZOcTdFNjN0Nm4yczlSaHpQ?=
 =?utf-8?B?bGI4c0pOSlBKU2JOYmJWZUVTeXlEUTVEcGM0SUlIN1IxR2tZWUxKUmxKRXJa?=
 =?utf-8?B?bVRUZi9Ma3E3Z0p0TU8vVWIrK2ZCY2I5RmJIMFNUekJMT0VCWW9HVUFBaElv?=
 =?utf-8?B?Rno0b0I2cE5zT1h1N1doS3hMNGxETndPd0VLdHNZUGR6dXk0N3RndnRlSzBj?=
 =?utf-8?B?b2plcFJGVlhIaFdPUFk3WFdxMklsZXdESDVTYjJwcldyc0hLVlVLVkJaUm54?=
 =?utf-8?B?aURBS1ZWOUVxT2Z6eVVuVUg2M29BNjR4TitCOThzelhWdnl5eXYyd2E0S1A4?=
 =?utf-8?B?TXc0ekRwNmpybjFjNld2c21IUElhL2c3cWZNekpqR29oNUxnekFnbm9YOGlM?=
 =?utf-8?B?aVVNeklGbHVBMEM3TnZjNFNlRktYRTJGVmU5WjN1Ry9xN2I4MzVsL21SbHhu?=
 =?utf-8?B?NDBrNGVGLzBkSExodEJEZ3pJTUppOGlXRDkxTG9Uc0hkbGxrUjVQNit4Unpx?=
 =?utf-8?B?UE4wc1lYQXVINExFVlkyMnMwQWI4djJBbnBKY2dYZWorOFY3TXRnQ2d4c1Nu?=
 =?utf-8?B?T2tBVk1UVTBWNWZGQ0l2SnhOeXN0bnFjUzg5TzdZYUdSSTJqanUyZU8wTjM1?=
 =?utf-8?Q?EPCN3zxLSVS9BHVV/hwc66eJ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7a8afa-5493-4d8b-4af6-08dafd17efca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 08:00:47.9652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vriUhn3VaS4/Gk1lOLiIHgKJwQq56I9t/xoFzLXn5X06Y2zi8wOFtLgx7bMBUPtP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2023 7:44, Jakub Kicinski wrote:
> Convert all SET commands where new common code is applicable.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Gal Pressman <gal@nvidia.com>
