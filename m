Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE17C632B8F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKURzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKURzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:55:50 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDE9D06E6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669053349; x=1700589349;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dKl2H7GFKBQTBXAVSniCf6tT7rLWnFIsUQlVX3DblWo=;
  b=SQOLK9U6aPzxjLqmuiELbePIWHywLV9ZTiwoGaONRuUJXP5E8JNLPcIa
   LJkxfeXiPzhnF8K1eQMmA9Z+n/yqttvTa/UPqeIxpGzMR5ke8yj18w4jB
   y2FTTgPl8gETdrOZUmH3NOPgeoSJQbCX0iCFYFyAUMNY3wb3q9cQUm9qO
   d5mK36mwnRDfASHf/IRNrQhn6QbwaLE9NLgGmGKiM+G2gJa/R8oIhjO15
   QH0wYpDHkav0gXbEILbTxB3aXQQVZMq4m+e9M1aDQkhL6rvmS055SSzED
   kcHjfXuOm/QgRAZenSRZf9pdghgMy8y1Pm2tdsB5lBS2vmVpZDoYTxxY9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311251528"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="311251528"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="635257626"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="635257626"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2022 09:55:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:55:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:55:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:55:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:55:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bku/uPzocNfKTqY6EKw+qeByeRMH0kakPvFDMePRZBshdcWfS3raPZJUsIzKpwhOotmsARxxlzS92qJUME4NQasrJSYf+a3a05FMmsFsYVUtlpwWYYgK5EuQUsSIdwiSj/rUF+B4ztt3bnw8CdbjEtaqgrK8yjQCKIvmxSO9IScRnHAaNByiwpyLpUcSORlX0ufrNhKwqTKm3zA5M4WocYOn64GJ7pO87EdnLgEgjL4nb0IYD7Rxr1AQNadWp4clt7R0JSJGuyvHKc5X3TycSmznyWzKPaTkbIbaTTSqPGuXnZYoySNJxku/ugGeGIhWAAyrRLH2B6hV31ftlkVVvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HKEP5Ql8fBzvZ2la65T42ZKfMzQ0ALj1M3/0ExniQ00=;
 b=Y2AikOQ7wB7lzlPrcG1grS0/QhMltgfTdcj+S3CVaJPlP/NXxc1f2e3K/E1lB+PeCeUEUOBSpuxOGG2/TBNfZNxadclpCMYdyNm0eyjW4s3b6uJPxWkOtqeaIap0SnOLzMFsJTqcdzunrKf2U0cmmm876ML6pGZjYsBeSbiygOb3RZjhgOdF+YlGTjImR1e2BQfKtfqwf/drlOKUpkWZkw+qU+ltJsDpuGTd5qeA+zeHKF3Y65dDJ51syM5y7o71tkpOBpy3dlq8Mn434JARi+qtzosmkXzOdHsFhHHRVHx96snqHvnnlf53Evrq3w9K1ieBt1X/9QG1J+EM5TKzLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB7352.namprd11.prod.outlook.com (2603:10b6:8:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 17:55:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 17:55:46 +0000
Message-ID: <0bbd66a4-add6-7056-2fb4-c1a5cc377f7d@intel.com>
Date:   Mon, 21 Nov 2022 09:55:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 5/8] devlink: refactor region_read_snapshot_fill
 to use a callback function
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-6-jacob.e.keller@intel.com>
 <20221118174824.513e15d8@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221118174824.513e15d8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:a03:333::24) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d1e9da0-11a1-4b41-5d77-08dacbe99ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTtB1j4EH6AiXTO2xvPIpTQEEOfq6G58Zb+piai3qYCMNXcs8RPNscbiE0ICVuSG52RJsTKK0m7RT5oQ4cdbrphD2Wu66rPl0aSSLRKrgo2M6IZBREZ+QMsr9ZuXGcj8o3v0AXIqCh0Hfb68h+Du1zi0w5zBoCeFJpjuc7MDgLdXdgAZu2cwuDLB3dKFWC19aKzKkoQGLnucJDj5g5QsRDahLtdk34I9HkjZYx1GE+lOzyq3a0m0kt7G1xpafbD1h8VEeBI/Q953a2DTdmsxBLaYU9LtLe92vaoLy3qEpOqnM8P6oetsa6v8UYBhUp2QFVdF7bXnX2duYdZWQDhrszjS6++aiva616XtJFeA/1O+AzT4CeFubNK6kbHPHSVuXPnO6QIpyWyZJsrhp8gIlA4qdU8oArB6fmjfCGNwE9/vlPfG+5ksQwpcHVRCwRCCNccgTzuk1yA2SJFuDRONm0BeWgar2SPkG5cXW6DxnntyHJeOkqmroECrdSE001bQP+Dsqd+9FvdPPjuQxJWFrUBGrP3n2bDsvRJ4k/vtw7Gkv1xkFlwPJhSJNgV/0MACHW71iSyXc98H4rtJUKYKBZ7UGTxZGNNFtuhJKJ5Hlz9AEwPeGmxfdE6AwMookQIJ7MNVhQJults0YhiFRZBUq/7CTBGA949VfxlTr5AxLBSGAaKtt9xuFwnGtUkBXy45G9no8mEsz7trRHhfWAR2ok3HtX6Jf4GSG7Wfic5b9s4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(31686004)(6486002)(36756003)(8936002)(2616005)(5660300002)(31696002)(86362001)(2906002)(26005)(478600001)(38100700002)(6512007)(41300700001)(82960400001)(6916009)(4744005)(186003)(316002)(6666004)(6506007)(4326008)(66556008)(66476007)(66946007)(53546011)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3A2ZTZjeld3TnN6RG5zZ1NZNit3Qk1SakgzV05ucldhWERpaUN6VytFNUcv?=
 =?utf-8?B?MnRKU3lVRVpVWW1qSFVJNDlnNzJOTEFEL0N6K2FvZGVXbTJQVGNMaTllMU5P?=
 =?utf-8?B?WXRFOXN5aU5zTXpiWU1xRGVSTitLa2pNQnFWREtGU2R4WUc1cUxWZkhlQXpF?=
 =?utf-8?B?azVpQkVhVzN3SVE3c05VUXZYcUsyQlNSeFF0YktaY0l0eEVDamlUS3RINkEy?=
 =?utf-8?B?NDNTNGlQdkRzZVFuYW9jY1hiRStnd3FoaVVSQXhTOEVIRnRmRlYrU2J5bDhO?=
 =?utf-8?B?bVN5UkdDbzVVZW9vdUw2N3QxQ3BNMWVncGxhMWxqRVRjcUh2QXRMQmYyNGd4?=
 =?utf-8?B?Y3Z6U2NDT3piWWpFTEtHVHIzNXVzZzhQdXFvOE1SRDBqZHlNK0FJc3JUVmZx?=
 =?utf-8?B?NTlWVVhTVFBLaGVVMHVwdHoxcGtTRnB1SFA4ZzVDU2hseEFFY1M0REM5OTR0?=
 =?utf-8?B?aXg1QkZwaGdheEtYaS9MZTg5VzgySXp3NEdrbVFKR2p2bG1mZEpuOGdnZS9m?=
 =?utf-8?B?WWlSdDVGR1doZEVCZEFqaXRzazVxSVRIc1NSY1dkR1F6S1RnVUxlNy9TeEpK?=
 =?utf-8?B?TkFlVXhOYUZGOFpQNnBwdjBpV0R6KzljY2p1VHJNNmFvRXZIU2h1amFjTWY2?=
 =?utf-8?B?UjcyMlV5andoNm5GOTBGNlVHWWdmL2JiTlJHK21QWEhyZUo4ZUdXUnhQSlZB?=
 =?utf-8?B?eDcrdk9yeFFHVDcrQTlLcG9QV3dLWld6eUs4UkRGU25VU01UUVdjU05FeTgr?=
 =?utf-8?B?NkRWQnlDSHlCRHVsMjZZK2lVZXJnQTBwcXV6czhMTEtiRUE4eVBaWGsyUEZO?=
 =?utf-8?B?ZmJZMXdUMXlhZklCN1BEVVdvYTg3SW1xRmp2SGhJNGw2NVBkUiswUk1DcE9E?=
 =?utf-8?B?RU9kaW00L0dQSXpzaFNDWWJLM0J0MHZkNXlPTTByeHBQTFNxRmZac1AycWtl?=
 =?utf-8?B?MzljSEFTSXVQcTFPVU9BcUNjdTNSbDFwV3hiYjlvZWg2dVM4SFYwdDAwVHhw?=
 =?utf-8?B?enJsd3VJL0N3YTF5Skw3MFJKMnpsS1JZbVdIKzUxRGdLWXMzMlpIeHNFOVlz?=
 =?utf-8?B?N3llQjhBeTR3UjV4dFRsRHQ1UmNXT29JTDQxMHRlOWNvejZRZzFqQkdGOUVF?=
 =?utf-8?B?Z3RnMHVZeEFxVHU5N1VhbFRUa1owdmxIVkhWRGNQYU1ONG4vNmpuSTd4MDhK?=
 =?utf-8?B?Vi9NS3laNXJxNlBnWjhzQ2xGYi84cHRxYk9uQkpkbTlyb2Z6eXFVcm9YS3p5?=
 =?utf-8?B?RFpZT2lRbFBCc1BUUFU2L1ZqNDE1Q3RMcEVsS3hZTU1sb1lVZmFVUEhYZmVM?=
 =?utf-8?B?U1FSNjRWM0R3UzQrS3g2QWErazFZVFpzRHVaWit3N0dMR2VROUM3RTU3SlU3?=
 =?utf-8?B?NkYyR0N1OGh3UXNKN0l1RGZIeEZBd3U3SW1qOXFqOFAyTlA4a0VWVkM2bW5p?=
 =?utf-8?B?bTh1ZlNWT2RNYTNONjJuTVgvZTc5UjNYVTJBVFV6d1JwSjNHSUpxdWt5TnBr?=
 =?utf-8?B?dHg3TWRnZ2l6TndkQ3N5RVQ1WWhhU1VHNzlBRE5YVzF3ajJJaUNSSnJocjhO?=
 =?utf-8?B?djR6bjZtVjJzSTBHenJ6eDBRUk9pOXY5SVhnaGprRitoandsZ083YWpMdkhy?=
 =?utf-8?B?R3haUEZHcTlueE1FSDB1MnpmbGFDeVNGM1g1YTB0bExLQk40T2V5UnhOUlla?=
 =?utf-8?B?UVlMUEwxdU5JY2VCdkhDaG4wdTA5K3lHWitPa1Rvb2FINTRjMm1iNzZnRDlW?=
 =?utf-8?B?OVVQcERiVE9GRkFoQlc1ZXduZCtGaklIZ1BHY2lMTWhFa0ZxMzJmUWx1ekcy?=
 =?utf-8?B?UVlwUE1HTU9RdVlVMUtub2U5SnpEUWdLK3pIdnlJbFNpVVNKMG1kK0dVaDFm?=
 =?utf-8?B?YXJITmUyVnlZMkpGTXZ0UHUrb2Z0TXMxdW5vYk1CdmZ1SW1KR3B6azJnWkdp?=
 =?utf-8?B?cmMvbVI0MDh2UFN5bVowZUlFVjNmaUl4eVI2MDhuOHZNUCtoS0FrYlYwV0Vx?=
 =?utf-8?B?MlZqVXgrRVlYaGpHRVJoQnI4dGVxbjdud2Q2UGxVTU42NUVYczQ4RXFMYnVG?=
 =?utf-8?B?dGNSejJHTW5wc3N3UGRUZzlHT1RuRzYzUWtsckhHZU1xK2UyU1VTUjFyZ2M5?=
 =?utf-8?B?bjQrNFZyRjhGWEhYUHRMNW1POXE4Yk42R2hacEJHdmplNkJtYVhTbjZNTVRr?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1e9da0-11a1-4b41-5d77-08dacbe99ccf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:55:46.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9x799bna3E3kh1FECHc7qiS4WVXorz0D47skxMG2HMoSlpIb1SsuC0hQG3mLp5iPfxh0TW94fhoIgV1rrGC2Db8+nLVpowi2DchdYc6yGFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7352
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2022 5:48 PM, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:08:00 -0800 Jacob Keller wrote:
>> +	/* Allocate and re-use a single buffer */
>> +	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
> 
> Why zalloc? If we expect drivers may underfill we should let them
> return actual length.
> 

Probably just habit. Let me check on this one. I don't think there's a 
particular reason that drivers would under fill since they're in control 
of the region size.

Thanks,
Jake
