Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8389060DA3C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 06:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiJZEYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 00:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJZEYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 00:24:02 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992E4BBE23
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 21:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZq+Izarh3J2AGRE0wchmK0YrcIjF6WhSYe4omkNSB4fNB8YJgTzUG9nGEAMSSXTSeqmoWIcLSlHjLo2ZFUu/STQW4LOa6sYwQdS9JVvW6I+e+oJd1hlCUiYvZsxqnFhSMPO0Xs2ckFkT9Bi/l9z0rAnMfRy9FiPJ4QEz5vpzyShRGLxZIfASRjU07Gow7bip1PTLpGf9y6omeVhclpPv/gpa423vGcDIMqLMZwpqscQjuOWeuKxa25XWVI19CR7Ti7HontFxcFgiWQsZhFm05JmsUOo7XTlyLbe8UpnonWWYL9zYaajGRuiAUp4kje9es49H8P2bstAWCe72OMMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+y+3yPtZ1bpdNKPkA//Gi6ztJVYlB7etMnIaSaXZVw=;
 b=eInQgyfZ8nswOvIWLYVqwJXa2SjQHLQFgPf3N7M93Ag63fcl1k9Knf0kCGBlxegy/h6XDVXE53wtK+eFYwqjBHa4SN7mM7fSeDrYgc+fFfubWWE6+wcOgxh7UNgr6NNF7BdRXZgdQpWWVuGdd1O3CK2vMKIKH1cvlC9HIJd7ipeI4SEXp+Kx2uih70grMYxUY0x8qCtTC7H+cZ6oETWYEmET7/0q7yAJArmBKwfapHFI4jecd4V0lJC07+K686CPsMewg4DuP95OKPqT3PyFgd4iJCNlBhyBVQTVFTy+hWd9VKvsytfuNtCwAv+0RSz2laQ43ohwxfBJ6iNX3oWbqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+y+3yPtZ1bpdNKPkA//Gi6ztJVYlB7etMnIaSaXZVw=;
 b=PzwYGlRjrP46MNANk7oXBOYhLEifZ6JhPY/o+QWvO33N/fKIQMSnFYJM8r6LJ+hsc/W3ii2F45mfJIYJwL77XCMipn978zP3fTw1D7dkgVWeBUjPj/0ztiF5Xm5S83t4QAnGtt7jljihs8J5p8cmrxt8TYDFCfGcBEvCeoLLYq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB6883.namprd12.prod.outlook.com (2603:10b6:510:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 04:23:57 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7%7]) with mapi id 15.20.5746.026; Wed, 26 Oct 2022
 04:23:56 +0000
Message-ID: <2b469008-4057-cbe0-8640-73d42490f65e@amd.com>
Date:   Tue, 25 Oct 2022 21:23:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 net-next 3/5] ionic: new ionic device identity level
 and VF start control
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, leon@kernel.org,
        drivers@pensando.io
References: <20221025112426.8954-1-snelson@pensando.io>
 <20221025112426.8954-4-snelson@pensando.io>
 <20221025200811.553f5ab4@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221025200811.553f5ab4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::32) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: fb3ab413-1f85-463b-2bfd-08dab709e5b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59LKGABAH2eqFss/iZ4fEesO1gfLydp2O0zo3ViEZQVG16wfN3nwroVQ0NDrLxx1poU8KqGzeF121yyEWSs2UQ/i5PL8whR5sWks+WLcPrCIU9Txvzp8XY2F3u70KJPH3+k0nWebU+iJ4g9ddib8vrxwAg6AOcA0jwBGe9UO0o7igM7yKfJSbcMgcGlorQslI1GC40VhtA40qKRZMzVkjWuv+aUhvY++RJtUiPpsGYh+mmEi4n1lk1qMNlLJdsCmgg+YAzeGPckwdXmzyn2Z0nwr3NgMlgs6Aki+QxKQOtx+TamliyfEFOKyR+c0TuxivML9c+LTtLzz835O1CS1Xe9iXHc3JzxSfbKG6Nt7WvxsGfx1y9rp1HczQuN0Ja5euD/ysqn9Z2vjWEUl9zOhFGLDaTZvPweDCUrBOdIWkbX5SlLO0T2dOq/FfyeygRiX/W8JKMyo8ufwrM1o5eQ6cCFXXHV25EWDGQDnrTi6aOA2SNY7VxfUOA41oSX4taoSoXkrg+e4ZWQsBc3ih2B2iR02ZLYG9AMnO3d4y3IhNidy0AbAYwoAzdEiSIh0wsX7C5P13Jo6P2mR5pGObvOgQHt/uu8d/xFutDn61+eDHyH2k9H9KWrtshWmDm8l6iERKlPfuQ/pudIY8RfnzVriaZ1Av2o5XE5LeiW4fbTfNPGLEAcxjxubiGRIvskNN+wiLyBaMJVxrNGTwkk+7B/Ncoy1EWaB2wIuZNlLGE9E34ZAM2C6SCorWVn50/jrzXGxFzqtDA2o5E1Pj54+BVgvHefa/JyNbf41DFZSTdonHfc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199015)(26005)(53546011)(6506007)(6666004)(6512007)(186003)(478600001)(2906002)(2616005)(316002)(4744005)(110136005)(66556008)(6486002)(8936002)(66946007)(4326008)(8676002)(66476007)(5660300002)(41300700001)(31696002)(36756003)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkQvcHEvc2Njc25Vb0RYVUdzR0l5ZFpQcFl1RU1JVDlHRWJ2V2lSalF1bjhS?=
 =?utf-8?B?Y3lrRUVkdnl4THdYYloyUkhodkF3VjhaRlJOSTc3cEpTTkdNUVhrUDNIdC9T?=
 =?utf-8?B?Y1hGdU5Dbi9uUTZIeDkycmpRRVAzWjd2bzlkWXgvODI4ZGdUa1VRZlhmSkp0?=
 =?utf-8?B?TWdmNnpNZnBwT3lHMlA5SThQWHVqK2g2R2NhUDZXTUkxRWErSDZUdUdCNlQz?=
 =?utf-8?B?VnJxVHJ2d0NSRnhiQlF5ZW9IQVU2S0xjUVBpeEJ1QXFSdHVmSHRWUHpCTmtw?=
 =?utf-8?B?WkdNMU5FL2RVdVdMUlVSWVNTRmo5VUNDbVppVS84SXpxVGt1WDNtY3R2OUVT?=
 =?utf-8?B?a3dHS05UbFNNYXdyMzRxa3JUU3VqNEtzUyt2Tlp3akRzdUgzRkZ0R3B1YW8z?=
 =?utf-8?B?SFJjRHVpNUVyRDVYelhRdFBQWDVBUkxNUjV6Z0I0eDZiM0lTRzNBZW8xazBi?=
 =?utf-8?B?bzFpeStBK1IzYjNLSXNUKzREeVliVG1RVEM2cWVDTnVLTkJKdEVmUGZWdkRz?=
 =?utf-8?B?UXFGSEM3d1dWdVQrb2cxT0N6dEFqWXl4MEdpdU02amM3YXRvRGlLMlpRekhw?=
 =?utf-8?B?ZEJEbVRFWjB6UXNMdnRUbjRsazVNdVpTeXo3MkgxOVcwR1Z3NHFEQUc5VHpX?=
 =?utf-8?B?Wm5rODVTb1ZqMHBlUi9yR1ROaDhCUVEwL1dQbUJickQwRGswMEhQSlh6QkVZ?=
 =?utf-8?B?RmQ3N3k2VjVjV0JYVFFkYkdkM2YrRm5ETmlhanZrdzhUTk1sQnhEOUF1eDd5?=
 =?utf-8?B?TmNod08xM0xPaUh3TlhmL1l1eC9mdTE2RHpDR01qNlZqdzhLYXM0bEJHL1JI?=
 =?utf-8?B?QXZjcXBsenNTK3gvSGIvRHF1TVJFY21FVFpUWlMwNWZ6TjQybVlQVkg4SU12?=
 =?utf-8?B?T1UvbkFIc21vNGpXNTllSzlNSVpNZ1JXTkl5Q3F3MXdUTlB0VGJHcVl1ZGhv?=
 =?utf-8?B?STkwaE5BV3F4cm1QdldDaVd0bXpCNlZFV2lYN1JmUFJNNjF0Z2dmZ1d6UVl3?=
 =?utf-8?B?b09xKzFPNVpncktZVnViRy9PcWF4UDQzYzdqaHZhbXRNbXkxbDVnaStrNkU4?=
 =?utf-8?B?dkw4NEQrN1hpVitwWUJjbFhwQnVLY3BtcEdrdFJTSGVuNlI0YUpLYW9CbVoy?=
 =?utf-8?B?TStVTTNWMWwzTHpnWkpkazlGUXFYd2ZsS1BsRWFDdUE2VDQ1SG5PbTFJc0xj?=
 =?utf-8?B?b3hRdGZrM0FPdmYyR3hnSWdwRytWQkh6TzBHMFlpMVExbjlVRy92VUNQRnpi?=
 =?utf-8?B?aE16MmsrRWtiTGczekx1TFlROGZXOXVSSHlxeUhZTkRMd2FrQTBKSjZHSjhC?=
 =?utf-8?B?VHEvWFEya2NyZjJrNndjOEhtS01iWkpUWnFQaTlBZVdoSmtqeHBhUk0yZkZ4?=
 =?utf-8?B?aUpIVnRIWmliZTBZVlRtQlZXSUNYWkhYVmdDQ2xNV1BxcFoxTzhLS1dRN0ZC?=
 =?utf-8?B?c3hTS2h6clova3ptWVJicytJVHB1Y0xCUFdKWWMyVHcxSE50NWI4eXViTm1O?=
 =?utf-8?B?QkVObDdCSzFENE9DdkRmc1gyWUowM1pKRDNGUXRkRFdVYVlGeTdHOUJpRnhn?=
 =?utf-8?B?SnY3SENpOXhiaXNhamNwbHJuZURMdVM4Z0tzejhYeVA3VHMwdDBvd0NhcXRH?=
 =?utf-8?B?MUdDQmJLc2JDSTN2QzZ1UVRoNjduTWtKZGJwMWY5TzNRY2RPcXpsTWRXNU5Q?=
 =?utf-8?B?SVNyRjdqR09mWkVFS0RhT3lmdmxHZmZ3azlaMGdGQndwclZGd3BOZmtwRCts?=
 =?utf-8?B?NUVWb2Z2L1ZqdTdVUFo0cFFCL3lZUmZVUWVXWnBhQU9kN3VRSGlpcnorZzF6?=
 =?utf-8?B?QUd4TkYvbjBOQkIwYUMvb2xEalVGYTIzZXdzcmZqQkZQdUN2WGxVUCtCN3lm?=
 =?utf-8?B?VmNyTkxHVzU0am9DSW1VcElpUmcrNXVHTzQ4SFFyVzZJRmo2cG8vUnVGVzR2?=
 =?utf-8?B?Vy8rZGRZaHo4NkxDRlpBZTFEK1hsV2pqMzBnUjY5VnhhVWt3TjFzSXNqZGZk?=
 =?utf-8?B?dDV3NWE4UzAyL2NrOUl6TzlFQWxZeHVIN2hOUmxzT0lydWVpWEcySnFJUXM4?=
 =?utf-8?B?S000YlBiSVNiTy9DMGxLenZkYTJRbkVDUmhyVGpXNENTcEZ4aTZ6SnFiZ2Za?=
 =?utf-8?Q?mbKVrxg2pNIi5vUb7bQc/c9iA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3ab413-1f85-463b-2bfd-08dab709e5b4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 04:23:56.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0boCJEU3atmbOALraQ6VfekRt4c8F7R3jMccG33Ic9adCEp5HSh4bVHWEXpSEfsgZJtgkhIfFV5BAJn6P9GiGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/22 8:08 PM, Jakub Kicinski wrote:
> 
> You need to tidy up the kdoc usage..

These additions are matching the style that is already in the file, 
which I think has some merit.  Sure, I'll fix these specific kdoc 
complaints, but those few bits are going to look weirdly out-of-place 
with the rest of the file.

I see that kdoc is unhappy with that whole file, but I wasn't prepared 
today to be tweaking the rest of the file to make kdoc happy.  That is 
now on my list of near-future To-Do items.

Just curious - when was the kdoc check added to the netdev submission 
checks?  Have I just been missing it in the past?

sln
