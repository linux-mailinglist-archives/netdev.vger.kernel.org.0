Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B6466B03F
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 11:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjAOKFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 05:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAOKFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 05:05:44 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A02AC17D
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 02:05:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGc5M+E1zBiUhKgT1zY53iLNWMzKOEGINRFRsZLl4wJbz6pv56DATeETS0LFwWBw873Uk2Kf6XdKhCzagVwRzD4DiUmG6jDSAUiKDGJG9c50wMEzwW1ypmzKZODjrA5vLVRLo5bUti/KeOUAyP2gKeQZUlkkNRtlrSS9pUiukCOZmXtJsBLKX1StG3dHK3rKVI+o+YT4DJoH7E1uv70sUOLKOA5wJPKxYr7vKqj2BfZwR5HTERoKuBQhwJqP0wSoyl1vsntt4e9wb3mSgRcUktif3n5B1ZdzmY+O4gfyn1N/vK/b6x/KrrdlKVm3TUg1jfPtNiiUiYPdPd4CAVRcAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zZXvbkKDwWIZzte04q4QNcfwQH4GoVanVajdq9spUQ=;
 b=WVAPLdlM6jGaEuCyR44bwIqFXcSzmTtTwEFmB5ZFgTdUiozOD7EmmhPfHg6HDzbq7XUfm1OoVAMWJJ7Iq752I25msx02m+j6QJ93vIosn1mU77zwvzER2zI6cjEGr5kVphISoWWY4bErT55FpaNUHoXghrkn/vOToML4f4CvBIFGq/ZWVgTZ/khxTX3GZwuuC+AGKBCgKJYjelMVJ2Bwnyy+KMYiwKlO33q9xa9lrzhzCnSUcaOcx0NJSTeBLB7XaoEWW8DCbtRO6LuOXFxdTecGWXnjolf3nB8k+fhjoAgYxK6qCirMZhT2Sw+zIK+tG5N+RkoPD7ZspojZgWhoHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zZXvbkKDwWIZzte04q4QNcfwQH4GoVanVajdq9spUQ=;
 b=m82M3+7+U+vGmeUw0Iq3Xa7ulVLMeHMWS7jby8jWQZMbIdSxdBvxOeIUlJ4n8B2prTnHQ75yToI6tmOq1X72+YU6kCQ26r59ZuIfYBYHHkbI+IVWUA41zTy42+BILDbjOOAkcWuHu2G5KCgMUT+lOxMYvDfirAdTWygwNztV6Oc25YNuxt203WG/pEpQB3UkGhjD8RIxBFpRI4j/qNpPiM/pAo1nc9bvtdGri+CKhHNgRbv7FZhDrga+vXeE5oh2GpXixWeZ1D4eTI9Xn8Rua0GMoQpU9H1tgcjcWeO8XPIAv/FJ4DRXKOt8WDRpgbBZi7/Z+dkq5NgaAWiENkOV+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 15 Jan
 2023 10:05:41 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.013; Sun, 15 Jan 2023
 10:05:41 +0000
Message-ID: <157d3005-29a8-939e-f63a-784833dbf17b@nvidia.com>
Date:   Sun, 15 Jan 2023 12:05:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>
Cc:     "Arinzon, David" <darinzon@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
 <20230109164500.7801c017@kernel.org>
 <574f532839dd4e93834dbfc776059245@amazon.com>
 <20230110124418.76f4b1f8@kernel.org>
 <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
 <20230111110043.036409d0@kernel.org>
 <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
 <20230111120003.1a2e2357@kernel.org>
 <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
 <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
 <20230112115613.0a33f6c4@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230112115613.0a33f6c4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::17) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: f5bd62af-57e2-451c-e4f0-08daf6e00eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NbR73Acyilli4fRKnwEq1u1nw7UG/3iSctEzn7MOTHksZno93kDyJe6jjkcYbjSQwydf9dSNLdZVbnSzSquIOoxw8+5NjOLPTuxk15cpNqXaZ03FJkfNv5EhZpTFGMUl+D1Wt3Gox/iYFJU4P9AgfvlHYDwd0f4T2nIrZFuWtXSOQsEZCkTQfinC1W1btXZN/1j10vFBihqkC1Q43jBSql6xWYkTuRKngAN8iydvolQWAhEWa+ctOMFWwZqG/lTnEDuBD+NkZKszrnUhzxed65DaZfaQx0aQWFy5bxbe71GwIEOplVLBTtZOgIGla9fQMOamh4iwwh6eO2JSpLpPiHpsUA4LdfdWE8qaUF9APdXAnEXz39pvxT/2b5VvuwtAJ6aPqw37tgUhW9q30IVk/3JCMP2G8p4RgfBQPAfFQVaVUJXZjzFVc0ctsm+mGnW9Fa9nKI3Ol7T7VP/PlurAdz55Z7phlW7P/C631/ztyEHsYWohy3eYF89lb30RrGC/8S0QEi7xkZYz7bbaV1aaTpWBVYnjY0hLEWoJ0H/JjqFu1i+WgZtjei0yIUr6VSWeaj7EhsyBAwdu4HaWCl4KFJka2rcYudZVEKtVW67TcjYjvGCyu8qQXD5pMBA9Rb3l/tjOZl+kjbzXYhfYyfWqM6ZlOpdMd5cLYZ2xyHRF69vIlzhwuQGRnbvbF3aKA8aLB1IHSCUiXWTJfYDTjuLzposfZPUF9fHlqlkOVboa7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(53546011)(26005)(6666004)(36756003)(8936002)(31686004)(6506007)(6512007)(2616005)(6486002)(316002)(478600001)(66476007)(66556008)(66946007)(5660300002)(7416002)(186003)(4326008)(31696002)(41300700001)(38100700002)(8676002)(110136005)(86362001)(54906003)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGM0Y0YxTHNCdlhzR29DSEtSMUx2bmh0YkRuUEpYeEswYjRxYXhkSnkyaVdx?=
 =?utf-8?B?V1R5cVRacFZXYkx6VjF4cWRaZ3h4aU5IbndPenM3d2Nqb05wcDFSZXJndGIr?=
 =?utf-8?B?bnVyYy93WFNNTzNKSUU5NEN5NVpuQjdnWHNmVEVCNmpwdm5aMzA0Z2gvTXRr?=
 =?utf-8?B?d0ZjejJVYnJHdENjSTk4aE8zS1ZFS216TEYvQnJtRUxmNlczMVhpbU5WQkIw?=
 =?utf-8?B?OUtzSXNtWCtCOFh3clB5YU1xUWJBVVFabmRvckhPQ2IwUWtBT3pLaWJQalFK?=
 =?utf-8?B?Q29QSFlYeWlQQjJoeFl1OFp3K0RWUDYxSE1LMmZEQW83ZUxzaFBrcE9JRjA0?=
 =?utf-8?B?OUtFZXQ2Q1orS2xiUWZxWHhxVURrZzJ6RGZVUUFYVytqeWI2SmxmZDRpSmpU?=
 =?utf-8?B?WENJaDFaOTMvRnBLdW44OUp4aG1FTjhJc0JHaS9SUDJxUDFzQWxVdDNpY1pa?=
 =?utf-8?B?a2cvWGRTczhsamlTN1RlY2FxQllua0pBMkRlRm9nTnVjVnVPTE1TS2YveE1z?=
 =?utf-8?B?SkxCbkxEbWl1UmxvQkdmdUVSbW1mMk0wQmROcEsyNXZtcm5zSGlsSUZGbzZk?=
 =?utf-8?B?cmFQYzdQWGVDNXVHQ3FOVTJoakREb3ZvZ3VEWnRzc0Nlb0pnTVV1TURTQjZa?=
 =?utf-8?B?bjFqdHZBeStndnQ3clhrdUFnUGJZcW83Vld5S0ZSaGhTODAyYU10aXN4YmF3?=
 =?utf-8?B?bTdNd1A5SW1TVW1nVE9UbWNjbUI2eGF0QWViRjdlUGZOcU1xMVJmRXNNdkJq?=
 =?utf-8?B?cktsSC9UL2RrTWRQcHk2bGlPaEQ2cXNrMm5VMTNIVXNWZFdXTGVpZ3NFQTFK?=
 =?utf-8?B?Rkd3elBxMkJzOGk5aWorenB2QjBBS0Nzdnl2UWRrbUZrbjh0ekszNkMwcC9Y?=
 =?utf-8?B?dkZsVXltaWFCTkVyL1o4STJ4RkM2ZURLRXZOZmcxTVdjSWFkenFIQS9WMm90?=
 =?utf-8?B?a0ZtL1lYTEtvMlhGWHBtUHpuQ0hpRHJ0RlExVklBVTJvaTlMZ1BRaVZ6Vmd3?=
 =?utf-8?B?MDJBWGRNQ0NoTUNFVXA5Tm10c2dER052eCs3VFBNa3BScXVNUnF1eE5nVXBv?=
 =?utf-8?B?cjIvazFpdFdRejU1WjNFTUVaRXVvbm00SWdmdzZoUDQxclhZYko1QmR3M0dn?=
 =?utf-8?B?SEh2bndvRmw2MDNnVzd5czd0WFJ2SHhXbDhybFFSZXlVQ2RMN3hFS0RYdG9N?=
 =?utf-8?B?cVBWbTlqZ2FMNEZUa1pLYkpNb1dFZXZtazZ4dnp4RzNoK0hrWTZHaWdmOUk1?=
 =?utf-8?B?ZzlET3FFWVMrVWEzY2VhNFRyUWVnYm54Mk92NVNnY1dmcTQvVjhvOGc0cDNs?=
 =?utf-8?B?c3pEand2SXZjV2hQNWh3eis0bTVlbDFMTXAvdDQrTjJ4R2tqbHFQSlQwcG5H?=
 =?utf-8?B?RzM5REFjNE9Kd2ppaVFHN252bHNISUxTYjdOTlhWQS83NFZnNDcySzd5Snk5?=
 =?utf-8?B?TzZ1blltaU5rNEcyS3ZzUXRLL1hKNEQzZ0N2em4zalZkZXNQaFEzQWhrcDNR?=
 =?utf-8?B?c1EzR0lCYkR4d3B3S25QSW5XOUN2K3djUkFLcWJPaEpZOWRLK3BOWnI5eDdB?=
 =?utf-8?B?Z2JWa05BZmdxR05zbXEvbnBSU2xGc2VkcXpZajVFUW01bzZDWGU5UWNVcFhw?=
 =?utf-8?B?NFNLSFM0RFpSdmpIQmVqdjFSMm4wVFZFYnlBN1dOOWFpWStmOHduNmVTUlhK?=
 =?utf-8?B?OVJ1Sysvd0w0VTJsWjh5Q2FWaHJpcElLK0gyakF1bEVxTmhWUmRxbXh0RTd2?=
 =?utf-8?B?NWFkNjYxQVNrd3crYWVhMkZhN3FneCtDd0VIZk5EeElud3BHUkFndXowMThV?=
 =?utf-8?B?YmNPUkJLL1pnNTVXYlhTV1BNMXVHV2VvRkVJNlZlWHJ3elNYUnJkQ3dJNUhW?=
 =?utf-8?B?NjMwSnF1cUVHQkUzZ1BHckIxT0xzbkhkRGJnVXRaWnNUTy9LanlUOHA0Yjgx?=
 =?utf-8?B?NHY5bGZQSUFCMExmeDhKTmt3NEo3QXRKSGxlUTQ3ZzBIbUZjcjdwWTVwY3Nl?=
 =?utf-8?B?ZnZzeVduKzFBVXFHNmptUW9WWEF4d1oxMnZYMEt6UTVab1lzd1NHTHo1Yldm?=
 =?utf-8?B?SU5pSnBXU2tCMXVDa0VEckdTN3FyS3MzVVd2UFBrNnVBWW5VbHl0ZjdSWlpE?=
 =?utf-8?Q?ysTYkXTS7gkZsaU5x9FFHwNjC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5bd62af-57e2-451c-e4f0-08daf6e00eee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 10:05:41.2021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E46+NUMQfDfHhak3a8T3OPERP05WOx83VMWbOyhs6E0jH8DNp/ddTWwyUzgE5PcP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2023 21:56, Jakub Kicinski wrote:
> On Thu, 12 Jan 2023 15:47:13 +0200 Shay Agroskin wrote:
>> Gal Pressman <gal@nvidia.com> writes:
>>> TX copybreak? When the user sets it to > 96 bytes, use the large 
>>> LLQ.
>>>
>>> BTW, shouldn't ethtool's tx_push reflect the fact that LLQs are 
>>> being
>>> used? I don't see it used in ena.  
>>
>> Using tx copybreak does sound like it can work for our use 
>> case. Thanks for the tip Gal (:
>>
>> Jakub, do you see an issue with utilizing tx_copybreak ethtool 
>> parameter instead of the devlink param in this patchset ?
> 
> IDK, the semantics don't feel close enough.
> 
> As a user I'd set tx_copybreak only on systems which have IOMMU enabled 
> (or otherwise have high cost of DMA mapping), to save CPU cycles.
> 
> The ena feature does not seem to be about CPU cycle saving (likely 
> the opposite, in fact), and does not operate on full segments AFAIU.

Segments?

> Hence my preference to expose it as a new tx_push_buf_len, combining
> the semantics of tx_push and rx_buf_len.

Sounds like a good idea.
To clarify, buf_len here refers to the size of the inline'd part, not
the WQE itself, correct? The driver will use whatever WQE size it needs
in order to accommodate the requested inline size?
