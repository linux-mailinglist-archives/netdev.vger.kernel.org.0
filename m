Return-Path: <netdev+bounces-8115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 184E1722C71
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADDC2281342
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85AE2260F;
	Mon,  5 Jun 2023 16:26:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68A021CFC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:26:31 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE8ACD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/YchuO/LMOsOluZGLmcrYC08+X8IlaxC6DHFqYwzhi4Iux7FRp7maczBI4ytG3+S75qItgpomMaLHasjqYQkFDgMKtKoKrYrpcN7qxtBqKrJp8pOXK0XKP9KuimfmYFGLSE+3csIfFi+ycZZxDUZzWBGivSjXSuzwNRoZqmG44uYyNf6xjbCP5wpXgPy2OHw11xqGkNI8GXPW3cMKK151DF6pALzf5VYg2PlWZeamVDMQh8hsdcyBD0uEznbIEOJzIFS1gU8w10wVOXj+tiCeaGrdplZ9M8jSikYOchtHvQAZI6wTapOR4KQasmxBiXFd9h+HhJo1bPiN7ZS5vGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NpTookXFvlpO04iKjNka97BTlkxCCYV1rtO6yQojyo=;
 b=G6psYWPn5Mrc5EeVb6DN8dc8aDbyfraMLjgF+qI/NkH6LxVYsBRPwumpKpB4af9cLSCxz8Atg306oK2i/ziHNrzIsoPPR6hI0PYNMZxx7IcsADAEqAQvGET7+uAYIWAG0EmUuu9o4Zi05A6lSwtgb0GRFSCG6MzAuMssbw5YSVrxu1V0HZX4AIN8T3rEbNw7Ip722f1iFjsrHuzHSOFLMSkfmkwxnUaHOqXJEQwWkpf3ArUxu9e++Qpbnm/SiveMpCiD5N/qLhf6bdgte1Apk0iymp5KgdynjGL8RU13FSF6+JPxrJdL/tUv/KwLPzepCd3iyEUkbYgQkwXaqihT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NpTookXFvlpO04iKjNka97BTlkxCCYV1rtO6yQojyo=;
 b=BoWlxlMUIQNdNoG9svETmCF8EIcXCJvNmqSnnsp5KtS4ltHllTPaMvuA0i9UkXxtdPvlBTnST6lAdeHMJBW7p37C0WQSuzQnQNZVIboG8JY9fsiVbFftfEcP0AzuDaRoF7Odn5APaM884jUnvn0Lksky5bFBAVOwYiB9ttzjX6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Mon, 5 Jun 2023 16:26:28 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::611f:a9a7:c228:c89a]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::611f:a9a7:c228:c89a%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:26:28 +0000
Message-ID: <be5f26b8-fbe5-841d-5469-3adcfc178ab3@amd.com>
Date: Mon, 5 Jun 2023 09:26:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH net-next] ionic: add support for ethtool extended stat
 link_down_count
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, brett.creeley@amd.com,
 drivers@pensando.io, Nitya Sunkad <nitya.sunkad@amd.com>
References: <20230602173252.35711-1-shannon.nelson@amd.com>
 <20230602234708.03fbb00e@kernel.org>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230602234708.03fbb00e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ede61e-387a-4f4b-7bac-08db65e19cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/3ed+ZkGGclcuTRUNONXiQRzJV8F3MEt4CZTa1Hj3VzGZoPuTEyjdElVtBFUAXRCAzrx5swKpYZVUaL87jG2RELfxCAH3OOC7jdjzYvGRDRKQtAZOhCvm08gFpCkxlAYU2ZtofF1KDItmzfLGv+RFj5xPpGURsRL1nW+X3ug3Jb3Rtu85tNKowix+mQRcLH8h92MNkYARGyZeUHs9GSnZ7hoQJ5TvTk0dVzOLbsjstwAfQF+s8nscDYCVSkHZBYKPkgK1OPgdfdmgEGOMycwNzAXVzEeIvbAsZeHbaW6VEebu/7Jy38JD8RBKcVQ09nJSDHN2h20YSs1GCpyDaDQ/qIWi0QkqRQ9OKO2S8RohnQXDHkYrvRiT0xjNlvzUZ47qsUigO4j9ayJYm9jhykMQ/57mO8iWRfrxXcHf/jM2EEvyLxh6iFlR05gDq+7kCMPFxHW5uPx8iILGXp0u5OudNKHPKJoBWz4mGghrjiYok90Jz4n85/23WHpz5FXaAqbN9SMJ5crInyHUx251rojcISF2eI4oqjQPtTqhoiArvEXxF4ewY/wGK6QHHqvuYaAAW/g/rwYWsLWk6XU71Sub0boTAwxKt85Fkd09KElHWt2KLFCFzGNINWVShNaDo+KTQ+H5GBhvrWKcgNBsFIhhQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199021)(6506007)(53546011)(6512007)(38100700002)(2616005)(41300700001)(31686004)(6486002)(6666004)(186003)(26005)(478600001)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(8936002)(8676002)(5660300002)(44832011)(2906002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEdtc3NDK0I0eDNvRkV3RU9qNlJ0MzhlaUp6MmZPSWhrWTRtWHcyY2ZsbkQr?=
 =?utf-8?B?S2cxL0RzZU1Qd0MyeHI2MW02bFk5eG94Q2d2c0RLWXd6MFFtNHBhdmVwQ1VF?=
 =?utf-8?B?WnRzS3dzUFRreHdNNGF6ZTI1SFJ5eDIvY0gyaVVuSFpyYUR5THVhaHBhTzF4?=
 =?utf-8?B?WlduQ2JpMjJqTXdydS8wU2lueXZtZEpmUHk4QVVyWUJWMGpQOWRxRmNHNkdU?=
 =?utf-8?B?eUsxTkdGYUxxYk9xRzN5UjJjYlV2clVZRlIyNjhVYzJYT1NqdWdlV0hPOUpK?=
 =?utf-8?B?OVpNRDlFN1p5SUdBRGpJZllDTHZManJCeGEveFg4M3FnNkc2MWtrVUxTeDVX?=
 =?utf-8?B?TU5yQmY3Yk9CMXo3N045Y3YyQU1KMUxvYWdJN3J1SlA4UUpLM2FQa25EZm9i?=
 =?utf-8?B?N0doWUZEbVdOZElvYmFoeEFKSGRpeHNDT1ovcEVKdjczRVpVOEtGMm1ZMUZD?=
 =?utf-8?B?Q0NJVURWNU5pZ0NmRWhjR2R4WTN4WTRrQVdXTkw4LzRZSVplRjY4SDc1VUxs?=
 =?utf-8?B?ZTZMK3htRTdhVDNPbkJzZWp0aVllVWJ1YThUUGF3TDJ6RXoyclEvTmI1MXl0?=
 =?utf-8?B?RGpLZG5CQ0JTQU9ISzNSRXhkV3V3UDY4dUpBcEpMeGVDUlZITUdkNUhkVEk4?=
 =?utf-8?B?SGNucHd3K3lkY3ZaUzZ0LzJUbDNVWGdYUVpCQmZJZXBsY2dKT2RCT2JxQlJB?=
 =?utf-8?B?dUE2eXJyb0F1T2JaT1ZwVldQNEZJNDdTa0R6RnhIdmV1dXB2aFU5NlJLSy9m?=
 =?utf-8?B?bXFqOUF3K2h6aXdndXdleDhSVy9WeTRlZlJQbVJ4YnNwT25NaG92Z2xsWEdv?=
 =?utf-8?B?SUE0NmxreDdIdzJ1aWU4US9zTXMyKzU1blp1RWZqR1RiYldBVS9iemNoRXdm?=
 =?utf-8?B?NmFqc3VwMEdmREdGMkR3Zlc5bjBteU9IQnhzSkRXaEpRZXllRDdxdm5CYmkx?=
 =?utf-8?B?Q01wWVB0RVVqdWgwOGdGSzJ1R3BpOFBpMEVINllZbUllUUpsZ1pvak85bitV?=
 =?utf-8?B?Tlp0YmdWbGZpWmNZSGJ4T2VFRkdBVnRxVytXbnJEeEQvUVdicWlaSUFmZWlu?=
 =?utf-8?B?bU1ZWDJhVW80enk5TkV0dFBldUcyeDVwbm43ODRuMzBSaDMxRXBUN0Vramtv?=
 =?utf-8?B?aUhmYTYwNHloWFU1ZlFCaE1jZTdEdkM0eGdvL1VSS2pCdHZCWXhSOW15OFlT?=
 =?utf-8?B?cVdGcWNPNmZWRTZad2prdkRTRHQ5Q2NNbXVCREc2WnQ5SE1vVVFKQ2haYmFE?=
 =?utf-8?B?L0JJV2hGS09teXd2ajhmY1VrMTB2QndDM2Jkang4djhjUmVkSy8yVHZOd0lu?=
 =?utf-8?B?M200RFR4Ykx2a0tQTXFIOERGVDBTUFVCR1FZOHN0RTczZEZzcWhra3dadXVt?=
 =?utf-8?B?R2Zmb1NzWC8xaFFXNEEwWi9mWjlUMDVnb244OGM1Q1ZMRUdzOWMzNnZhMk9L?=
 =?utf-8?B?eWVvS3RjSXNlZXBHLzhJeVplc1VzOGpuaUM3TWt1RUN5ckhidzlwMU04VDRi?=
 =?utf-8?B?NVV3YXVvN0pWbWlUdXg1RCszT2pja1Q0K0lOMDZOZktTeGdUMUdydzE4QUt6?=
 =?utf-8?B?UGxoWkt6YkQ5TFY2WW1nRk56QW1wTUEvbTFaSVRQN3JTVTAzNlZ1aWVRVHoy?=
 =?utf-8?B?TGxKdjV6ajRLSG93T1ZhY1hjaEVkTUFRdEVnVHlmS05wUm9WRWYyVHZabVJK?=
 =?utf-8?B?M3FnWlBkZkgrc3R1d1ZvMG1HRng3QWJhTEYvQklzNXd4R09qVlNwL09iUEcy?=
 =?utf-8?B?a0xnWGZKSkJmY0QzUkJJWmRuUlZhU1Z2V2xDTW91Q0V4RnFzSUQvSkRBZXoy?=
 =?utf-8?B?UjJhVnBscnZsdkE0dWo2OC9pU3RCbG4xOStYa0tVSFFPcjViTHZUTEVwWWdk?=
 =?utf-8?B?R29VT3V4a29RWW1OWWFLL043TCthSHdsWEc3TStzZWMxWjBSS3ppTGdGQjQw?=
 =?utf-8?B?U2FlVEJqR2lPci9NcGlwN3ZKUGEzVHgzUzhleG5mMEJDdkhYT003RjhPTjlp?=
 =?utf-8?B?RE5GcWkrQVllY0I3TzJNR2Z5SGhRcUo3aHZSaDR6TnZwbmhyRzRuczdtdmFv?=
 =?utf-8?B?emN1UWJXcFFDYUowZy8wbzQ5aDN4YWFsNGlIcS9sbXNiRjhBRjZRKzJVdmlY?=
 =?utf-8?Q?buQp3tWPQEPLkC3kkQ5T+gple?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ede61e-387a-4f4b-7bac-08db65e19cf6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 16:26:28.0206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ry9FcHXv0YahQWp5aZ0FAyanaJngsK/i/xqa37t2mnBvDdchazrTXvwpAA9DCJUvhpXN6xEagUA/gIySwB7Kfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/23 11:47 PM, Jakub Kicinski wrote:
> On Fri, 2 Jun 2023 10:32:52 -0700 Shannon Nelson wrote:
>> Following the example of 9a0f830f8026 ("ethtool: linkstate: add a statistic
>> for PHY down events"), added support for link down events.
>>
>> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
>> link_down_count, a property of netdev that gets incremented every time
>> the device link goes down.
> 
> Hm, could you say more about motivation? The ethtool stat is supposed to
> come from HW and represent PHY-level flap count. It's used primarily to
> find bad cables in a datacenter. Is this also the use case for ionic?
> It's unclear to me whether ionic interfaces are seeing an actual PHY or
> just some virtual link state of the IPU and in the latter case it's not
> really a match.

This is a fair question - yes, it is possible that the FW could fake it, 
but normally this is a signal from the HW.  However, I suppose it would 
be best to only have the PF reporting this counter, and not the VFs, 
which is currently the case here.  I'll have Nitya modify this for PF only.

Thanks,
sln

