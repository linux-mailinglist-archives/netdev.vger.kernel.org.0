Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0084E611FC8
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 05:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJ2Dc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 23:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJ2Dcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 23:32:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2128.outbound.protection.outlook.com [40.107.96.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16A8132240
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 20:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D89VKN3cYiThEHjdnDhNN7u+sEeTWSfbLdlKM5mmeAgPf/tGycTE29M63FglGj7R8URTQ2j6BDisB5rg2rTVGRz1VMW2DwVDDbxS4iTdVCxP5YfbOypNgrBKK9JKu4mgVy/8c6U35FRGiaC0rMxSzmnhin8vtmgpyLtpfWCZTlcEugpScBthM4ZxC4jAXioQZelXIt5HxpdaTP75CjFhdylvU69lV6J0vlwK31/TB8fw71a2C+o/+NtVdisdzcUJoEIQAaZdWokeUX5N/FGcOpnuPn6Zw0EXsGjheTQP1iUc3ql8tZdy0J/IkangTl33nze9WnLlYP03GNiagUBl6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbVoI3/ARflIuUwSM8Yjapahh/VQJcV4XQapCAXRzlw=;
 b=oXwaEBsyh8r0awbr5kNQvFr5vIbaxgSHl8nqDIPI2eW4DFnUQLq0J2uEliDW6o88BiThnlaXrtObbLG81kZqXSFfGbsMh+HWz0TEPBF+YRAg50IuyIjGSCuBLMAwynJ3voP1AU/AmE7u9awxtCYqgpI2KNBB5LqiTH5tTP9gvCpny5u6iug7FFofp28GPWTmHl5dg3Q/uyX3/NclH6Rz9Hdp8RYf/DowMHC8XYQt1GUR0OVX6N6gX4JCj1R0QEX01UupQBD3SlTvEY/WcraoBVg9j0kPCTG2j5RF6B9UGIWVZwHzoqMMr1fWHg9GA787SOXU3PridonPI8BqA4rgYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbVoI3/ARflIuUwSM8Yjapahh/VQJcV4XQapCAXRzlw=;
 b=Vvjer5Nw9bP4yjkrCHTfYcWztw+ws08+zhC/69la+IUfFLpMsTsd4kFvcYjGqkmsozcKjLLOS/ztyAVLdHld4L3VDwSTXaZpm52ZRTZ6E4rjcTsgJ9IBKgw7XyoZVnZPO+AcHeQP9DBWoQs907EFodQaaNdj9hklaStiN1KOc9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY3PR13MB4850.namprd13.prod.outlook.com (2603:10b6:a03:36b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Sat, 29 Oct
 2022 03:32:49 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.010; Sat, 29 Oct 2022
 03:32:49 +0000
Message-ID: <339fef36-8f3d-096a-8bd8-92bd2ff824f7@corigine.com>
Date:   Sat, 29 Oct 2022 11:32:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
References: <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221027084654.uomwanu3ubuyh5z4@sx1>
 <DM6PR13MB370569B90708587836E9ED6AFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221027104914.fasecsmjsksbrace@sx1>
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
In-Reply-To: <20221027104914.fasecsmjsksbrace@sx1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|BY3PR13MB4850:EE_
X-MS-Office365-Filtering-Correlation-Id: aeda87fd-2b68-4bc6-8811-08dab95e40da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuqDuizRWunWmIjCEOa0Bj137AZ2Tu+67MXULxxhTJ8X6kJlKUotmM8Voq27452n2boYfHUBs3iQtvDCoy4sVHRhfiOxWUd3pXJLoVKWlHGqzBPUpP56krGsX7OQEctbvxbXssyzdxrOUcEsrCmE3iCiOWQqj3qJ3+9E66v1l99xv8+kDkPg9X6w0xnJnGhOHtotD6sOjc4PSI44WNl6crIjWMH5EYqWOWJbsF+QBhde4FTfAE7s8VsJcuB+/j1lg1IqCBvyjPUxlxAuEymQUhvq7fyrWNKqY7vy1WJlzGKJ2/XIRKEoaHqhQr1r+Q3ka29qR3wVXDbQ1tvX5YVFxoT/IkKCbvWX1nM0wLHcuNSy1AkQFpXwqdp0avXolYAqi1fa31/TW55/KleToT8zaXJFRrb1kR/lUbPpVkRnvrAjOKrHOX1tQwh+CkGnvUG2fOCR/lgkgiAiEia5/3EEjozasGE/Q7WTvVxjMW99asFElSbIC7z51Uf1thfRK7Ms6pMYFMyh+TtZgQ2R4L+biGTMyivcP2eF+bcSRdcgZErxXchujNdpPyRoeOfhhYEsgw5xVYOMqmKQoS+wjAmL4xRKh4LnlVqMNQTCLTF8p3ubvejbcwnbRAi0Ed2/RwO8RhYTTL0VydvQHVUsReCuQDUgO0XUkbXS587cZ6FTs7Wey4ud/mVpACDmKNMnvUU188Z8JGQ3fThT+NJl8ZccWApv3vDlyW5tao9NawydU5QvOqNUj/HhSoDLjl1qO2a3QXjpMJr50VG8VBQPnRgSnftaC9QFQ3ByN2yxI2bkNR+tYvCCBULvmTfRjbumtz0IHW3KP8+Sco/GbHx/gIHXx+Ie/zcxRHeTi3JBQNtECDi5Ao18cImd5zr7AzBB2XHw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(366004)(136003)(376002)(346002)(396003)(451199015)(2616005)(53546011)(26005)(6512007)(6666004)(52116002)(186003)(478600001)(83380400001)(8936002)(6506007)(107886003)(44832011)(6916009)(66556008)(54906003)(2906002)(66946007)(316002)(6486002)(7416002)(66476007)(8676002)(5660300002)(4326008)(41300700001)(31696002)(86362001)(36756003)(38100700002)(38350700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3NPbytRSG1jWEhOcUJMRGhKaUJzeHAwcTdrS0xvcWF1ZUh1NDRpeVRIZ3NL?=
 =?utf-8?B?RlZidkVSbi9Jdk9tZE1ZMDBTVmVnaGtnNFgxdWJPemw5MzZHN3hlZnQ2bTMv?=
 =?utf-8?B?RVcxWWU1VTM3ZUZ3OERnZWd6RkpLOEtMQ0puR0o3Q1NlVVprTS9tZkpFdUQz?=
 =?utf-8?B?ZU5UZjlVM0RBVDFJcXZBbXVyVFZFdE9LYm5GaTc0NTVsTkJ0SXJocE50Z3k4?=
 =?utf-8?B?RDRMSGxoR2daK0IzZnFtWW5PZVNUZWN1UE5kSjZMbXlFNkxUSVd2S25uYmk3?=
 =?utf-8?B?UU5TdVBGVXlCUGJ5S1puUUVPZ0ZiT1pDaldVUjBRbFQ3YjZSN041bWVRanIr?=
 =?utf-8?B?MmNnaUcyUkNGVjhBWFltUWM5UTM4cUpsZEFTMnVybnlTYjQ2U0JqME1EeUlj?=
 =?utf-8?B?YU5qRnY2YmpYcmJIVGEvTlJ0azlUcGJmRnVCeXQvWmZGbThndk44VEhvZHo3?=
 =?utf-8?B?QlRwK01WU0o4Z095TEZ5VjJCZ1NrS3IzMEN2MVJSNWpzL29XSG5wRVZOcTFs?=
 =?utf-8?B?OFRZVE8xR3U3OGtaWFFkWUJ2S095eG5iZjlnRHZ2VzhUd3o3V252cGRuTEdZ?=
 =?utf-8?B?LzIzL3lneGhnNEtMZmFDNDQ2ZSsxejB4UDZKWVpUMmtqVDFhRjZWd1RodHdP?=
 =?utf-8?B?UUFvT3F4LzB6WnQ0VEVNci9SYXZBQ0hvRXZwK0pnRU5TeWM0OWlOckNwNUNh?=
 =?utf-8?B?ZEZrNUlUdCtFc1ZEUi9kSktFcHFBWWZxTmdqd0UzbzFBeUJCZDRWck43WWZQ?=
 =?utf-8?B?MzNKTkRnTWFaTFVCMUF3OVBzUld0NXZBUVdxZmMyMFFzNGRDUm1xSHFUdWF1?=
 =?utf-8?B?R3NYK2RBVkUweG94Uy9jZkVWRnZaUm5RNHBYTUJQaVJRbHFJTERUdkVQK2cx?=
 =?utf-8?B?RDZ4UVlaQU0xMXVwWk9Qam43MXdYRmdrajUwRzJtM1N1OWtKajc2RS8xMnFG?=
 =?utf-8?B?OHE5cEhrVml3Q3JnajFUbEx0c1YwcXpWWnRXREVtcnhnSkdWbDZPYllsbTNY?=
 =?utf-8?B?NUZTeGNmWHJDM3NjSVJqcm1nMVNQL2szKzRpYjdNcGJYZ0lNS1BBSllHNEsv?=
 =?utf-8?B?VGZHUVJZak5HbGthRFd1aW44TkhFeHpJbThJYWUvbUpMNmhWRnVpQ0NhMEtt?=
 =?utf-8?B?Q1gxM1lNSFFwYWg2VHZWK1FqK2ptdldVajlER2FoZmVsdjJOTWhjN2ptRUti?=
 =?utf-8?B?eDRLZHJ1MDQ3ZmFjN0liZ2x6dnBSMHVVb1ExTCsyZGhmMDNDTTNtVFlRR2tv?=
 =?utf-8?B?VVd6Z3Y0aWRHbm5HUVFEbEplalk0OTJDMmErWFRtM2pmVXdlVTZhc0xReXE5?=
 =?utf-8?B?clZSMGdTUGtYQ1lSaDlnQ0hPbU9wdlRLM0pRbHUvS0NlVDlVWTRYaXpCWUEw?=
 =?utf-8?B?eGdWVTlua0Q4NjJyL1VJTHduNXhkZk1hTHczZ0hxc3JDZkVlZzJkaElWVlJj?=
 =?utf-8?B?bjRJNkd2N0FVWHdTWGpINkZaQURSZUliREZ3Ny9FaGVsem9PdDQyR1FQdEVY?=
 =?utf-8?B?ekU4R2xDSDRzNVIvUUVkZVAzTjc1cDUvMEltOFl2MExLRUI5QmhWMGVmdTdR?=
 =?utf-8?B?UmpybmpHdzBEQnkwM3hGSGtieGZabUxvNitXUHRqbTFhYnFNWmVKL3hTd0k4?=
 =?utf-8?B?Yms2TzNEWVRncXczZ0N3cVp6eU9oR09YU21RUlB5NzlsbjYyR3BlTlpFRG00?=
 =?utf-8?B?azhiNWFveWdhUnRSWkcvWmgrNmdwby8xZFg5RkNUTWhDa2diaU5lQnNDQ1pT?=
 =?utf-8?B?RW9HS2VsdkhCdmhvS1BmOUE5REFoU2xuZXdIZXdCV0pLOXN2NUJ4bGhEM0pB?=
 =?utf-8?B?NytUY2x3dnErUG1kYjYrZGJydlJSSmQybWZCWmNIemhja0dmOGhMSmJkK0xE?=
 =?utf-8?B?ck1INUoxeGtFYXE3ZXoxdHRFaDBnb0EvTnkzc3dValNENUFZOEh1amkybjU0?=
 =?utf-8?B?Rkx0Q0k5aEVnM0hiVUpNdlBWT1NXeXo3WHdaMlErMWx5ZFAwMnlRRkJFVVA3?=
 =?utf-8?B?aUtaeGNxMDZHb05RTDJweDFYbGZhUXIrcGZ1cVQ2b09pYVJHVnZxMi9BMWp2?=
 =?utf-8?B?OXBKQm8xZWxQTlJTMFM3Q1czcVVoVHBGeW9MSlJxVkRnNEFJL1orSmNCYTJz?=
 =?utf-8?B?QmlVTkpiZUhWR3FMaDErbWsxbEs4SHpuNkh5bFQveHpIMVBVRlV3M3dkQlND?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeda87fd-2b68-4bc6-8811-08dab95e40da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 03:32:49.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UF3hZoQwNWRrPJd0NnrAkV8IymFI8pejjbNEZ6jIegLTDMEw2UMapIYOCoQBn08FuvQXuZRPysnSzkJEUtJ9zeg+K+D9H6RE7ejmDCgEnBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4850
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/27 18:49, Saeed Mahameed wrote:
> On 27 Oct 09:46, Yinjun Zhang wrote:
>> On Thu, 27 Oct 2022 09:46:54 +0100, Saeed Mahameed wrote:
>> <...>
>>> if you want to go with q as a resource, then you will have to start
>>> assigning individual queues to vfs one by one.. hence q_table per VF 
>>> will
>>> make it easier to control q table size per vf, with max size and 
>>> guaranteed
>>> size.
>>
>> Excuse my foolishness, I still don't get your q_table. What I want is 
>> allocating
>> a certain amount of queues from a queue pool for different VFs, can you
>> provide an example of q_table?
>>
>
> queue pool and queue table are the same concept. Q as a resource is an
> individual entity, so it can't be used as the abstract.
> for simplicity you can just call the resource "queues" plural, maybe ..

I see, you're always standing on VF's point, so "queues" is just one of 
the VF's
properties, so that port way sounds better indeed. And I'm standing on
queues' point, and VFs happen to be its recipients.

> Also do we want to manage different queue types separately ?
> Rx/Tx/Cq/EQ/command etc ?

We didn't expect those variants in our case for now.

>
> how about the individual max sizes of these queues ?
> BTW do you plan to have further customization per VF? not in particular
> resource oriented customization, more like capability control type of
> configs, for example enabling/disabling crypto offloads per VF? admin
> policies ? etc .. If so i would be happy if we collaborated on 
> defining the APIs.

Not scheduled either.
I think it's better to introduce port param back, it's more flexible 
than port function
and can avoid frequent change to uAPIs.
